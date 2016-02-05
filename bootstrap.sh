#!/usr/bin/env bash

virtualenv venv
. venv/bin/activate
pip install --upgrade pip setuptools

pip install pyyaml jinja2 simplejson

git clone https://stash.bars-open.ru/scm/medvtr/hippocrates.git code/hippocrates
git clone https://stash.bars-open.ru/scm/medvtr/caesar.git code/caesar
git clone https://stash.bars-open.ru/scm/medvtr/nvesta.git code/nvesta
git clone https://stash.bars-open.ru/scm/medvtr/tsukino_usagi.git code/tsukino_usagi
git clone https://stash.bars-open.ru/scm/medvtr/simplelogs.git code/simplelogs

pip install -r requirements/bouser.txt
pip install -r requirements/hippo.txt
pip install -r requirements/nvesta.txt

pip install thrift dbf

./install.py
