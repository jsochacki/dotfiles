#!/bin/bash

if [ $# -ne 2 ]
then
   echo "Usage : Argument 1: $1 needs to be the path to here i.e. \$(pwd), the place
   you want to create virtual environment
   i.e. just do \"make_venv_here.sh \$(pwd) venv_name\" if you want a venv at the
   current location the virtual environment"
   echo "Usage : Argument 2: $2 needs to be the name of the virtual environment
   you want to create."
   exit 1
fi

VENV_FULL_FILE=$1/$2


python3 -m venv $VENV_FULL_FILE
$VENV_FULL_FILE/bin/pip install -U pip setuptools
$VENV_FULL_FILE/bin/pip install poetry
