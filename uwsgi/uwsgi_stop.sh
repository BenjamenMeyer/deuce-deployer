#!/bin/bash

echo "Stopping existing instances..."
kill -3 `cat run/server.pid`

