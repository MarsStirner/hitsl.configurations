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

1. `git clone https://stash.bars-open.ru/scm/medvtr/hitsl.configurations.git <директория для проекта>` - cклонировать текущий репозиторий через
1. `cd <директория для проекта>`
1. `./bigstrap.sh` - скрипт установки проекта. Ветки устанавливаемых приложений можно передать аргументами к скрипту, подробнее в `--help`
1. По окончании в директории code будут находиться следующие приложения:
    * `hippocrates` - пользовательское приложение МИС
    * `caesar` - пользовательская административная подсистема и подсистема печати
1. Следующие подпроекты установятся в virtualenv:
    * `nemesis` - общая часть пользовательских приложений
    * `tsukino_usagi` - внутренняя подсистема конфигурирования подсистем
    * `simplelogs` - внутренняя подсистема логирования
    * `nvesta` - внутренняя подсистема справочников
    * `bouser`, `bouser_db`, `bouser_ezekiel`, `bouser_simargl`, `bouser_hitsl` - разные внутренние подсистемы для аутентификации, блокировок и пр.
1. `cp usagi.yaml usagi.local.yaml` - скопировать шаблон конфигурационного файла приложения из hitsl.configurations в текущую директирию
1. Внести изменения в файл конфига
1. `. venv/bin/activate`, `./install.py usagi.local.yaml` - Сгенерировать конфигурационные файлы для uwsgi, nginx, supervisor через скрипт
1. Проверить полученные файлы
1. По необходимости создать директории для системных сервисов и проверить права на доступ к ним
    * /var/cache/nginx
    * /var/lib/sphinxsearch/data_{значение deployment.infra из usagi.local.yaml} (с правами для пользователя из usagi.local.yaml)
    * /var/log/cron/ (с правами для пользователя из usagi.local.yaml)
1. Запустить системные сервисы (supervisord, uwsgi, nginx, ...)
    * при первом запуске при отсутствии индексов сфинкса необходимо выполнить `indexer --config <путь до директории проекта/configs/sphinx/*sphinx.conf> --rotate --all`
    * вручную скорпировать настройки cron из `<путь до директории проекта/configs/crontab/*crontab.cron` в `crontab -e`


# TODO


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
