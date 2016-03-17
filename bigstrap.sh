#!/bin/bash
# 0. Создать корневую директорию инсталляции (допустим, /srv/infrastructure). Дальше все пути будут относительно неё

# 1. Создать базовые поддиректории, в которые всё будет соваться
mkdir code
mkdir configs
mkdir logs
mkdir uwsgi
mkdir sphinx

# 2. Создать Virtualenv и активировать его
virtualenv venv
. venv/bin/activate
pip install pip setuptools --upgrade

pip install pyyaml jinja2

# 3. Склонировать сервисы
git clone https://stash.bars-open.ru/scm/medvtr/hippocrates.git -b RISAR code/hippocrates
git clone https://stash.bars-open.ru/scm/medvtr/caesar.git -b develop code/caesar

# git clone https://stash.bars-open.ru/scm/medvtr/coldstar.bouser.git code/coldstar.bouser

# 4. Установить зависимости
pip install -r requirements/hippocaesar.txt
pip install -r requirements/nvesta.txt
pip install -r requirements/usagi.txt
pip install -r requirements/coldstar.txt

pip install git+https://github.com/hitsl/hitsl.utils.git@develop#egg=hitsl_utils
pip install git+https://stash.bars-open.ru/scm/medvtr/pysimplelogs2.git@master#egg=pysimplelogs2
pip install git+https://stash.bars-open.ru/scm/medvtr/tsukino_usagi.git@master#egg=tsukino_usagi
pip install git+https://stash.bars-open.ru/scm/medvtr/nvesta.git@master#egg=nvesta
pip install git+https://stash.bars-open.ru/scm/medvtr/simplelogs.git@feature-tsukino-usagi#egg=simplelogs

pip install -e git+https://stash.bars-open.ru/scm/medvtr/nemesis.git@develop#egg=nemesis
