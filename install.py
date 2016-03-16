#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sys
import yaml
import jinja2
import argparse
import loader

__author__ = 'viruzzz-kun'

parser = argparse.ArgumentParser(description=u'Установщик среды', prog='install.py')
parser.add_argument('config', help=u'Файл конфигурации')
# parser.add_argument('--deps', required=False, action='store_const', const=True, default=False, help=u'Установить зависимости')
# parser.add_argument('--apps', required=False, action='store_const', const=True, default=False, help=u'Скачать и установить приложения')
args = parser.parse_args(sys.argv[1:])


def safe_make_dirs(path):
    try:
        os.makedirs(path)
    except:
        pass


def main():
    with open(args.config, 'r') as fin:
        config = yaml.load(fin, Loader=loader.ConfigLoader)

    base_dir = config['deployment']['base_dir']
    safe_make_dirs(base_dir)
    safe_make_dirs(os.path.join(base_dir, 'code'))
    safe_make_dirs(os.path.join(base_dir, 'configs'))
    safe_make_dirs(os.path.join(base_dir, 'configs', 'uwsgi'))
    safe_make_dirs(os.path.join(base_dir, 'configs', 'nginx'))
    safe_make_dirs(os.path.join(base_dir, 'configs', 'supervisor'))
    safe_make_dirs(os.path.join(base_dir, 'configs', 'sphinx'))

    config['deployment'].setdefault('base_dir', base_dir)
    config['deployment']['config_path'] = os.path.join(os.getcwdu(), args.config)

    def make_filename(this, subdir, ext):
        basename = '%s_%s.%s' % (config['deployment']['prefix'], this['name'], ext)
        return os.path.join(base_dir, 'configs', subdir, basename)

    jinja_env = jinja2.Environment()

    @jinja2.contextfilter
    def do_recurse(context, source):
        if source:
            template = jinja_env.from_string(source)
            return template.render(context)
        return ''

    jinja_env.filters['recurse'] = do_recurse

    for name, this in config['subsystems'].iteritems():
        this['name'] = name

        if 'uwsgi' in this:
            print name, 'uwsgi'
            template = jinja_env.from_string(this['uwsgi']['template'])
            with open(make_filename(this, 'uwsgi', 'ini'), 'w') as fout:
                fout.write(template.render(config, this=this))

        if 'nginx' in this:
            print name, 'nginx'
            template = jinja_env.from_string(this['nginx']['template'])
            with open(make_filename(this, 'nginx', 'conf'), 'w') as fout:
                fout.write(template.render(config, this=this))

        if 'supervisor' in this:
            print name, 'supervisor'
            template = jinja_env.from_string(this['supervisor']['template'])
            with open(make_filename(this, 'supervisor', 'ini'), 'w') as fout:
                fout.write(template.render(config, this=this))

        if 'sphinx' in this:
            print name, 'sphinx'
            template = jinja_env.from_string(this['sphinx']['template'])
            with open(make_filename(this, 'sphinx', 'conf'), 'w') as fout:
                fout.write(template.render(config, this=this))

if __name__ == "__main__":
    main()
    pass
