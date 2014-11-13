#!/bin/bash

source gunicorn_deuce_deployment/bin/activate

echo "Starting new instances..."
gunicorn -b 127.0.0.1:8081 -w 16 --error-logfile run/log/deuce-errors.log --access-logfile run/log/deuce-access.log --log-level DEBUG -D apps.deuce_deploy_app:app
