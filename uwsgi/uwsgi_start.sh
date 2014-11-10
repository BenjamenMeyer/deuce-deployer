#!/bin/bash

source uwsgi_deuce_deployment/bin/activate

uwsgi --ini uwsgi/uwsgi_deuce.ini --daemonize run/log/deuce.uwsgi.log
