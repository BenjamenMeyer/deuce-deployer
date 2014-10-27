#!/bin/bash

VIRTUAL_ENV="${1}"

if [ -n "${VIRTUAL_ENV}" ]; then
	echo "Start: Setting up Virtual Environment at ${VIRTUAL_ENV}"
	source ${VIRTUAL_ENV}/bin/activate
fi

echo "Starting new instances..."
gunicorn -b 127.0.0.1:8081 -w 16 --error-logfile run/log/deuce-errors.log --access-logfile run/log/deuce-access.log --log-level DEBUG -D deuce.transport.wsgi.app:app
