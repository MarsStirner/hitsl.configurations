#!/bin/bash

RELEASE_BRANCH=RISAR-release-2.4
HIPPO_BRANCH=${RELEASE_BRANCH}
NEMESIS_BRANCH=${RELEASE_BRANCH}
CAESAR_BRANCH=${RELEASE_BRANCH}

for i in "$@"
do
    case $i in
        -r=* | --release=*)          HIPPO_BRANCH="${i#*=}"
                                     NEMESIS_BRANCH="${i#*=}"
                                     CAESAR_BRANCH="${i#*=}"
                                     shift
                                     ;;
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
Ветки приложений можно переопределить через передаваемые аргументы
 -hb=    --hippo-branch=
 -nb=    --nemesis-branch=
 -cb=    --caesar-branch=

или все сразу через
 -r=     --release="
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
pip install pip --upgrade
pip install setuptools --upgrade

pip install pyyaml jinja2

# 3. Склонировать сервисы
echo " -> hippo branch: ${HIPPO_BRANCH}"
git clone https://stash.bars-open.ru/scm/medvtr/hippocrates.git -b ${HIPPO_BRANCH} code/hippocrates
echo " -> caesar branch: ${CAESAR_BRANCH}"
git clone https://stash.bars-open.ru/scm/medvtr/caesar.git -b ${CAESAR_BRANCH} code/caesar

# 4. Установить зависимости
pip install -r requirements/hippocaesar.txt
pip install -r requirements/nvesta.txt
pip install -r requirements/usagi.txt
pip install -r requirements/coldstar.txt

pip install git+https://stash.bars-open.ru/scm/medvtr/hitsl.utils.git@develop#egg=hitsl_utils
pip install git+https://stash.bars-open.ru/scm/medvtr/pysimplelogs2.git@master#egg=pysimplelogs2
pip install git+https://stash.bars-open.ru/scm/medvtr/tsukino_usagi.git@master#egg=tsukino_usagi
pip install git+https://stash.bars-open.ru/scm/medvtr/nvesta.git@non-versioned#egg=nvesta
pip install git+https://stash.bars-open.ru/scm/medvtr/simplelogs.git@develop#egg=simplelogs
pip install git+https://stash.bars-open.ru/scm/medvtr/devourer.git@master#egg=devourer

echo " -> nemesis branch: ${NEMESIS_BRANCH}"
pip install -e git+https://stash.bars-open.ru/scm/medvtr/nemesis.git@${NEMESIS_BRANCH}#egg=nemesis
