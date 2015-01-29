#!/bin/bash

PYTHON_BINARY=`which python3`

TARGET=${1}

if [ "${TARGET}" == "uwsgi" ]; then
	echo "Building uWSGI environment..."
elif [ "${TARGET}" == "gunicorn" ]; then
	echo "Building gunicorn environment..."
else
	echo "Unknown environment."
	exit 1
fi


TARGET_ENV=${TARGET}_deuce_deployment
PIP_REQUIRES=${TARGET}/requirements.txt

INI_SPACE=${TARGET_ENV}/src/deuce-master/ini

if [ -n "${PYTHON_BINARY}" ]; then
	${PYTHON_BINARY} -c "import sys

major, minor, micro, release, serial = sys.version_info

if major >=3 and minor >=3:
    sys.exit(0)
else:
    sys.exit(1)
"
	if [ $? -eq 0 ]; then
		if [ -h ini ]; then
			echo "Found existing ini link."
			echo "Removing..."
			rm ini
		fi

		if [ -d ${TARGET_ENV} ]; then
			if [ "${TARGET}" == "uwsgi" ]; then
				echo "Stopping all uWSGI instances..."
				./${TARGET}/uwsgi_stop.h
			elif [ "${TARGET}" == "gunicorn" ]; then
				echo "Stopping all gunicorn instances..."
				./${TARGET}/gunicorn_stop.sh
			fi

			echo "Found existing virtual environment."
			echo "Removing..."
			rm -Rf ${TARGET_ENV}

		fi

		if [ -f run/server.pid ]; then
			echo "Removing PID File"
			rm run/server.pid
		fi

		DELETE_LOGS=""
		while /bin/true
		do
			read -p "Delete existing logs? [y/n]" -r DELETE_LOGS
			if [ "${DELETE_LOGS}" == "y" ]; then
				break
			elif [ "${DELETE_LOGS}" == "Y" ]; then
				DELETE_LOGS="y"
				break
			elif [ "${DELETE_LOGS}" == "n" ]; then
				break
			elif ["${DELETE_LOGS}" == "N" ]; then
				break
			else
				echo "Invalid input."
			fi
		done;

		if [ "${DELETE_LOGS}" == "y" ]; then
			echo "Deleting logs..."
			rm run/log/*
		fi

		virtualenv -p ${PYTHON_BINARY} ${TARGET_ENV}
		if [ $? -eq 0 ]; then
			. ${TARGET_ENV}/bin/activate
			pip install Cython
			pip install -r ${PIP_REQUIRES}
			if [ $? -eq 0 ]; then
				ln -s ${INI_SPACE} ini

				if [ "${TARGET}" == "uwsgi" ]; then
					echo "Starting uWSGI instances..."
					./${TARGET}/uwsgi_start.sh

				elif [ "${TARGET}" == "gunicorn" ]; then
					echo "Starting gunicorn instances..."
					./${TARGET}/gunicorn_start.sh
				fi
			else
				echo "Failed to install pip environment"
				exit 5
			fi
		else
			echo "Failed to build virtual environment"
			exit 4
		fi
	else
		echo "Python Version must be at least Python 3.3"
		exit 3
	fi
else
	echo "Failed to find Python3 Binary"
	exit 2
fi
