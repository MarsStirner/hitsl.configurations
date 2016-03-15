hitsl.configurations
======

Входная точка для установки проекта и шаблон базового конфигурационного файла приложений

Установка
=========

Для сборки некоторых библиотек в системе должы стоять следующие пакеты:

  * libffi-dev

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
5. Скопировать шаблон конфигурационного файла приложения из hitsl.configurations в текущую директирию `cp hitsl.configurations/usagi.yaml usage_local.yaml`
6. Внести исправления в файл конфига
7. Сгенерировать конфигурационные файлы для uwsgi, nginx, supervisor через скрипт hitsl.configurations/install.py
8. Проверить полученные файлы и внести исправления, если требуется
9. Сделать ссылки файлов конфигов на системные директории
10. Запустить системные сервисы