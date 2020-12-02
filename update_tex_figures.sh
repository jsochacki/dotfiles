#!/bin/bash

#modified_files=$(find ./figures -mmin -0.1)
#for i in ${modified_files}
#do
#  [ -f "$i" ] || break
#  if [ ${i: -4} == ".svg" ]
#  then
#    echo "File $i has been created"
#  fi
#done

modified_files=$(find $1/figures -mmin -0.1)
for i in ${modified_files}
do
  # This is so you dont attempt to convert directories or symbolic links etc..
  # and just convert actual local svg files
  if [ ! -f "$i" ]; then continue; fi
  if [ ${i##*.} == "svg" ]
  then
    inkscape $i --export-area-page --export-dpi 300 --export-pdf ${i%.*}.pdf --export-latex ${i%.*}.svg
  fi
done
