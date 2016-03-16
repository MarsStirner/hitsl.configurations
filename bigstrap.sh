#!/bin/bash
# 0. Создать корневую директорию инсталляции (допустим, /srv/infrastructure). Дальше все пути будут относительно неё

# 1. Создать базовые поддиректории, в которые всё будет соваться
mkdir code
mkdir configs
mkdir logs
mkdir uwsgi

# 2. Создать Virtualenv и активировать его
virtualenv venv
. venv/bin/activate
pip install pip setuptools --upgrade

pip install pyyaml jinja2

# 3. Склонировать сервисы
git clone https://stash.bars-open.ru/scm/medvtr/hitsl.configurations.git configurations

git clone https://stash.bars-open.ru/scm/medvtr/hippocrates.git -b RISAR code/hippocrates
git clone https://stash.bars-open.ru/scm/medvtr/caesar.git -b develop code/caesar

git clone https://stash.bars-open.ru/scm/medvtr/tsukino_usagi.git code/tsukino_usagi
git clone https://stash.bars-open.ru/scm/medvtr/simplelogs.git -b feature-tsukino-usagi code/simplelogs
git clone https://stash.bars-open.ru/scm/medvtr/nvesta.git code/nvesta
git clone https://stash.bars-open.ru/scm/medvtr/coldstar.bouser.git code/coldstar.bouser

# 4. Установить зависимости
pip install git+https://github.com/hitsl/hitsl.utils.git@develop#egg=hitsl_utils
pip install -r code/hippocrates/requirements/_base.txt
pip install -r code/caesar/requirements/_base.txt

pip install -r code/coldstar.bouser/requirements.txt
pip install -r code/nvesta/requirements.txt
pip install -r code/simplelogs/requirements.txt

