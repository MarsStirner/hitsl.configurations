hitsl.configurations
======

Входная точка для установки проекта и шаблон базового конфигурационного файла приложений

Установка на сервера
=========

Для сборки некоторых библиотек в системе должы стоять дополнительные пакеты:

  * `$ sudo apt-get install build-essential libssl-dev libffi-dev python-dev libxml2-dev libxslt-dev libmysqlclient-dev`
  * `$ sudo yum install gcc libffi-devel python-devel openssl-devel libxml2-devel libxslt-devel libmysqlclient-devel`

Установка использует запросы к git репозиториям. Рекомендуется настроить временное сохранение данных пользователя для
доступа к репозиториям, например, через git credential helper

    # Set git to use the credential memory cache
    $ git config --global credential.helper cache

    # Set the cache to timeout after 1 hour (setting is in seconds)
    $ git config --global credential.helper 'cache --timeout=600'

1. Создать директорию для проекта и перейти в неё
2. Склонировать текущий репозиторий через `git clone https://stash.bars-open.ru/scm/medvtr/hitsl.configurations.git`
3. Дать права на выполнение скрипту установщику `chmod +x hitsl.configurations/bigstrap.sh`
4. Запустить скрипт установки проекта `./hitsl.configurations/bigstrap.sh` По окончании в директории code будут находиться следующие приложения:
    * hippocrates - пользовательское приложение мис
    * nemesis - общая часть пользовательских приложений
    * caesar - пользовательская административная подсистема и подсистема печати
    * tsukino_usagi - внутренняя подсистема конфигурирования подсистем
    * simplelogs - внутренняя подсистема логирования
    * nvesta - внутренняя подсистема справочников
    * coldstar.bouser - разные внутренние подсистемы для аутентификации, блокировок и пр.
5. Скопировать шаблон конфигурационного файла приложения из hitsl.configurations в текущую директирию `cp hitsl.configurations/usagi.yaml usagi_local.yaml`
6. Внести исправления в файл конфига
7. Сгенерировать конфигурационные файлы для uwsgi, nginx, supervisor через скрипт hitsl.configurations/install.py
(предварительно активировать виртуальное окружение `source venv/bin/activate`)
8. Проверить полученные файлы и внести исправления, если требуется
9. Сделать ссылки файлов конфигов на системные директории
10. Запустить системные сервисы


Установка для разработки
=========

Пункты 1 - 6, и предварительная подготовка системы актуальны и для поднятия среды разработки.
Далее есть разные варианты того, какие из приложений запускать локально, какие можно использовать внешние.

  * Все пользовательские приложения - hippocrates, caesar запускаются локально.
  * Конфигуратор tsukino_usagi рекомендуется запускать локально, но можно использовать внешний.
  * coldstar можно использовать внешний, а для удобства переключения между разными бд можно поставить локально.
  * simplelogs, nvesta лучше использовать внешние.


### Типовая настройка среды с использованием PyCharm

1. Открыть проект из директории, созданной ранее на шаге 1
2. Выбрать virtualenv для проекта File - Settings - Project - Project Interpreter
3. Отметить директории hippocrates, nemesis, caesar, hitsl.utils, tsukino_usagi как Source в File - Settings - Project - Project Structure
4. Создать конфигурацию для запуска tsukino_usagi в Run - Edit Configurations. При этом нужно передать в переменную
окружения `TSUKINO_USAGI_CONFIG` полный путь до файла конфига приложения. Проверить работоспособность сервиса можно
перейдя по url, указанному в параметре конфига `TSUKINO_USAGI_URL`
5. Создать конфигурацию для запуска hippocrates. При этом нужно передать в переменную окружения `TSUKINO_USAGI_URL`
адрес сервиса конфигурации из прошлого пункта