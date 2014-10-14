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

INI_SPACE=${TARGET_ENV}/src/master/ini

if [ -n "${PYTHON_BINARY}" ]; then
	${PYTHON_BINARY} -c "import sys

major, minor, micro, release, serial = sys.version_info

if major >=3 and minor >=3:
    sys.exit(0)
else:
    sys.exit(1)
"
	if [ $? -eq 0 ]; then
		virtualenv -p ${PYTHON_BINARY} ${TARGET_ENV}
		if [ $? -eq 0 ]; then
			. ${TARGET_ENV}/bin/activate
			pip install -r ${PIP_REQUIRES}
			if [ $? -eq 0 ]; then
				ln -s ${INI_SPACE} ini
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
