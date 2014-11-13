#!/bin/bash

echo "Stopping existing instances..."
kill -9 `ps -Aef | grep deuce\.transport\.wsgi\.app | grep -v grep | tr -s ' ' ';' | cut -f 2 -d ';'`
