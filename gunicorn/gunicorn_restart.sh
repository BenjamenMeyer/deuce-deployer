#!/bin/bash

VIRTUAL_ENV="${1}"

gunicorn_stop.sh "${VIRTUAL_ENV}"
gunicorn_start.sh "${VIRTUAL_ENV}"
