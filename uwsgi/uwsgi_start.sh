#!/bin/bash

source ${1}/bin/activate

uwsgi --ini uwsgi/uwsi_deuce.ini --daemonize run/log/deuce.uwsgi.log
