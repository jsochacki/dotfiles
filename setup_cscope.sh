#!/bin/bash

# Pass in $(pwd) as argument and do at base of library
cd
homedir=$(pwd)

sudo find $1 -name '*.c' -o -name '*.h' > $1/cscope.files
cd $1
cscope -Rb

echo '' >> $1/cscope_env
echo 'export CSCOPE_DB="'$1'/cscope.out"' >> $1/cscope_env
