#!/bin/bash

FULL_PATH_WITH_DIR=$1
CURDIR=$(pwd)

mkdir -p $FULL_PATH_WITH_DIR/figures
mkdir -p $FULL_PATH_WITH_DIR/images
cp $CURDIR/None.rasi $FULL_PATH_WITH_DIR/
cp $CURDIR/systems_book.sty $FULL_PATH_WITH_DIR/
