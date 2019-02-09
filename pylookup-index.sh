#!/bin/sh
./pylookup.py -d $HOME/var/pylookup/pylookup.db \
  -u /usr/share/doc/python/html/ \
  -u /home/k/src/django/docs/_build/html \
  -u /mnt/ubuntu/home/k/src/ansible/docs/docsite/_build/html
#  -u /home/avk/src/wheezy.web/doc/_build
#  -u ~/src/pymongo/doc/_build/html/
#  -u ~/docs/pymongo-2.3
