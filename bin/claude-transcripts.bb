#!/usr/bin/env bb
;; claude-transcripts.bb — convert Claude Code session JSONL logs to org-mode.
;;
;; Reads ~/.claude/projects/<encoded-project>/<session>.jsonl and writes one
;; readable .org per session (user prompts + assistant text, with tool calls
;; folded into subheadings), plus a master index.org linking everything.
;;
;; Usage:
;;   bb claude-transcripts.bb [--source DIR] [--out DIR]
;; Defaults: --source ~/.claude/projects   --out ~/claude-transcripts
;;
;; Output is DERIVED data: it is fully regenerated on every run — do not edit
;; the generated files by hand.

(require '[cheshire.core :as json]
         '[babashka.fs :as fs]
         '[clojure.string :as str])
(import '[java.time Instant ZoneId]
        '[java.time.format DateTimeFormatter])

;;; ---------------------------------------------------------------- time/util
(def zone (ZoneId/systemDefault))
(def ts-fmt   (DateTimeFormatter/ofPattern "yyyy-MM-dd EEE HH:mm"))
(def date-fmt (DateTimeFormatter/ofPattern "yyyy-MM-dd"))

(defn parse-instant [s]
  (when (string? s) (try (Instant/parse s) (catch Exception _ nil))))
(defn fmt-ts [inst]   (some-> inst (.atZone zone) (->> (.format ts-fmt))))
(defn fmt-date [inst] (some-> inst (.atZone zone) (->> (.format date-fmt))))

(defn slugify [s]
  (let [x (-> (or s "untitled") str/lower-case
              (str/replace #"[^a-z0-9]+" "-")
              (str/replace #"^-+|-+$" ""))
        x (if (str/blank? x) "untitled" x)]
    (subs x 0 (min 50 (count x)))))

(defn one-line [s n]
  (let [s (-> (str s) (str/replace #"\s+" " ") str/trim)]
    (if (> (count s) n) (str (subs s 0 (dec n)) "…") s)))

;;; ------------------------------------------------------------- org escaping
(defn esc-block-line
  "Escape a line so it cannot break the enclosing org block."
  [l]
  (cond
    (re-find #"^\*" l)     (str "," l)                     ; col-0 heading star
    (re-find #"^\s*#\+" l) (str/replace-first l #"^(\s*)" "$1,") ; #+ keyword / #+end_
    :else l))

(defn example-block [content max-lines]
  (let [lines (str/split-lines (str content))
        n     (count lines)
        lines (if (> n max-lines)
                (concat (take max-lines lines)
                        [(format "  … [%d more lines truncated]" (- n max-lines))])
                lines)]
    (str "#+begin_example\n"
         (str/join "\n" (map esc-block-line lines))
         "\n#+end_example\n")))

(defn render-prose
  "Body text (markdown-ish). Turn ``` fences into src blocks; neutralise
  beginning-of-line * / #+ so they don't become org headings/keywords."
  [text]
  (loop [ls (str/split-lines (str text)), in-code false, out []]
    (if (empty? ls)
      (str/join "\n" (if in-code (conj out "#+end_src") out))
      (let [l (first ls)
            fence (re-matches #"^\s*```(.*)$" l)]
        (cond
          (and fence (not in-code))
          (recur (rest ls) true (conj out (str "#+begin_src " (str/trim (or (second fence) "")))))
          (and fence in-code)
          (recur (rest ls) false (conj out "#+end_src"))
          in-code
          (recur (rest ls) true (conj out (esc-block-line l)))
          :else
          (recur (rest ls) false
                 (conj out (if (re-find #"^(\*|#\+)" l) (str " " l) l))))))))

;;; ----------------------------------------------------------------- parsing
(defn read-jsonl [file]
  (->> (str/split-lines (slurp (str file)))
       (remove str/blank?)
       (keep #(try (json/parse-string % true) (catch Exception _ nil)))
       vec))

(defn text-blocks [content]
  (cond
    (string? content)     [content]
    (sequential? content) (keep #(when (= (:type %) "text") (:text %)) content)
    :else                 []))

(defn tool-uses [content]
  (when (sequential? content)
    (filter #(= (:type %) "tool_use") content)))

(defn result-map [records]
  (into {}
        (for [r records
              :let [c (get-in r [:message :content])]
              :when (sequential? c)
              b c
              :when (= (:type b) "tool_result")]
          [(:tool_use_id b)
           (let [rc (:content b)] (if (string? rc) rc (json/generate-string rc)))])))

(defn arg-summary [input]
  (->> input
       (map (fn [[k v]] (str (name k) "=" (one-line v 60))))
       (str/join "  ")
       (#(one-line % 90))))

(defn render-tool [b rmap]
  (let [nm  (:name b)
        inp (:input b)
        res (get rmap (:id b))]
    (str "** ⚙ " (one-line nm 40) "  " (arg-summary inp) "\n"
         (when (seq inp)
           (str "input:\n"
                (example-block (json/generate-string inp {:pretty true}) 40)))
         (when res
           (str "result:\n" (example-block res 60))))))

(defn render-message [r rmap]
  (let [role    (:type r)
        content (get-in r [:message :content])
        ts      (fmt-ts (parse-instant (:timestamp r)))
        body    (->> (text-blocks content) (remove str/blank?) (str/join "\n\n") str/trim)
        tools   (tool-uses content)]
    (when (or (seq body) (seq tools))
      (str "* " (if (= role "user") "🧑 User" "🤖 Assistant")
           (when ts (str " — " ts)) "\n"
           (when (seq body) (str (render-prose body) "\n"))
           (str/join "" (map #(render-tool % rmap) tools))))))

(defn convert-session [file]
  (let [records (read-jsonl file)
        title   (last (keep :aiTitle records))
        sid     (or (some :sessionId records) (str (fs/strip-ext (fs/file-name file))))
        cwd     (some :cwd records)
        insts   (sort (keep #(parse-instant (:timestamp %)) records))
        start   (first insts)
        end     (last insts)
        rmap    (result-map records)
        msgs    (filter #(#{"user" "assistant"} (:type %)) records)
        bodies  (keep #(render-message % rmap) msgs)]
    {:sid sid :title title :cwd cwd :start start :end end
     :date (or (fmt-date start) "0000-00-00")
     :file (str file)
     :n-turns (count bodies)
     :org (str "#+TITLE: " (or title "Claude Code session") "\n"
               "#+STARTUP: overview\n\n"
               "- Session: =" sid "=\n"
               (when cwd   (str "- Project: =" cwd "=\n"))
               (when start (str "- Started: [" (fmt-ts start) "]\n"))
               (when end   (str "- Ended: [" (fmt-ts end) "]\n"))
               "- Source: [[file:" (str file) "][" (fs/file-name file) "]]\n\n"
               "-----\n\n"
               (str/join "\n" bodies) "\n")}))

;;; -------------------------------------------------------------------- main
(defn parse-args [args]
  (loop [a args, m {}]
    (if (empty? a) m
        (case (first a)
          "--source" (recur (drop 2 a) (assoc m :source (second a)))
          "--out"    (recur (drop 2 a) (assoc m :out (second a)))
          (recur (rest a) m)))))

(let [opts        (parse-args *command-line-args*)
      source-root (fs/expand-home (or (:source opts) "~/.claude/projects"))
      out-root    (fs/expand-home (or (:out opts) "~/claude-transcripts"))]
  (when-not (fs/directory? source-root)
    (println "No source dir:" (str source-root)) (System/exit 1))
  (fs/create-dirs out-root)
  (let [entries
        (doall
         (for [pdir (filter fs/directory? (fs/list-dir source-root))
               jf   (fs/glob pdir "*.jsonl")
               :let  [sess (try (convert-session jf) (catch Exception e
                                                       (println "  ! failed:" (str jf) (.getMessage e)) nil))]
               :when sess]
           (let [pname   (fs/file-name pdir)
                 outdir  (fs/path out-root pname)
                 fname   (str (:date sess) "-" (slugify (:title sess)) "-"
                              (subs (:sid sess) 0 (min 8 (count (:sid sess)))) ".org")
                 outfile (fs/path outdir fname)]
             (fs/create-dirs outdir)
             (spit (str outfile) (:org sess))
             (assoc sess :out (str outfile) :rel (str (fs/path pname fname)) :pname pname))))
        by-project (group-by #(or (:cwd %) (:pname %)) entries)]
    ;; master index
    (spit (str (fs/path out-root "index.org"))
          (str "#+TITLE: Claude Code transcripts\n"
               "#+STARTUP: content\n\n"
               "Generated from =" (str source-root) "=. " (count entries) " sessions.\n\n"
               (str/join "\n"
                 (for [[proj es] (sort-by key by-project)]
                   (str "* " proj "\n"
                        (str/join "\n"
                          (for [e (sort-by :date #(compare %2 %1) es)]
                            (str "- [[file:" (:rel e) "][" (:date e) "  "
                                 (one-line (or (:title e) "(untitled)") 70) "]]"
                                 "  (" (:n-turns e) " turns)"))) "\n")))))
    (println (format "Wrote %d sessions to %s" (count entries) (str out-root)))
    (println (format "Index: %s" (str (fs/path out-root "index.org"))))))
