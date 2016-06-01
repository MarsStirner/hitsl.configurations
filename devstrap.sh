#!/bin/bash

HIPPO_BRANCH=RISAR
NEMESIS_BRANCH=develop
CAESAR_BRANCH=develop

for i in "$@"
do
    case $i in
        -hb=* | --hippo-branch=*)    HIPPO_BRANCH="${i#*=}"
                                     shift
                                     ;;
        -nb=* | --nemesis-branch=*)  NEMESIS_BRANCH="${i#*=}"
                                     shift
                                     ;;
        -cb=* | --caesar-branch=*)   CAESAR_BRANCH="${i#*=}"
                                     shift
                                     ;;
        -h | --help )                echo "Установка виртуального окружения и клонирование проектов.
Ветки приложений по умолчанию
 * hippo - RISAR
 * nemesis - develop
 * caesar - develop
Можно переопределить через передаваемые аргументы
 -hb=    --hippo-branch=
 -nb=    --nemesis-branch=
 -cb=    --caesar-branch="
                                     exit
                                     ;;
    esac
done


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
git clone https://github.com/hitsl/hitsl.utils.git -b develop code/hitsl_utils

echo " -> hippo branch: ${HIPPO_BRANCH}"
git clone https://stash.bars-open.ru/scm/medvtr/hippocrates.git -b ${HIPPO_BRANCH} code/hippocrates
echo " -> caesar branch: ${CAESAR_BRANCH}"
git clone https://stash.bars-open.ru/scm/medvtr/caesar.git -b ${CAESAR_BRANCH} code/caesar
echo " -> nemesis branch: ${NEMESIS_BRANCH}"
git clone https://stash.bars-open.ru/scm/medvtr/nemesis.git -b ${NEMESIS_BRANCH} code/nemesis
git clone https://stash.bars-open.ru/scm/medvtr/pysimplelogs2.git -b master code/pysimplelogs2
git clone https://stash.bars-open.ru/scm/medvtr/tsukino_usagi.git -b master code/tsukino_usagi
git clone https://stash.bars-open.ru/scm/medvtr/nvesta.git -b master code/nvesta
git clone https://stash.bars-open.ru/scm/medvtr/simplelogs.git -b feature-tsukino-usagi code/simplelogs

git clone https://stash.bars-open.ru/scm/medvtr/bouser.git -b master code/bouser
git clone https://stash.bars-open.ru/scm/medvtr/bouser.db.git -b master code/bouser_db
git clone https://stash.bars-open.ru/scm/medvtr/bouser.simargl.git -b master code/bouser_simargl
git clone https://stash.bars-open.ru/scm/medvtr/bouser.ezekiel.git -b master code/bouser_ezekiel
git clone https://stash.bars-open.ru/scm/medvtr/bouser.hitsl.git -b master code/bouser_hitsl

# git clone https://stash.bars-open.ru/scm/medvtr/coldstar.bouser.git code/coldstar.bouser

# 4. Установить зависимости
pip install -r requirements/hippocaesar.txt
pip install -r requirements/nvesta.txt
pip install -r requirements/usagi.txt
pip install twisted service_identity # instead of `pip install -r requirements/coldstar.txt`
