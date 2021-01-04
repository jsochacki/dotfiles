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
   # sed remove the annoying error message from diagramsio svg files
    sed -i 's@<switch><g requiredFeatures="http://www.w3.org/TR/SVG11/feature#Extensibility"/><a transform="translate(0,-5)" xlink:href="https://www.diagrams.net/doc/faq/svg-export-text-problems" target="_blank"><text text-anchor="middle" font-size="10px" x="50%" y="100%">Viewer does not support full SVG 1.1</text></a></switch>@@' $i
    # export the pdf and pdf_tex files
    inkscape $i --export-area-page --export-dpi 300 --export-pdf ${i%.*}.pdf --export-latex ${i%.*}.svg
    # Get the file name with extension but without path
    tmpfile=${i##*/}
    # Export to png
    inkscape ${i%.*}.svg --export-area-page --export-dpi=300 --export-png=$1/images/${tmpfile%.*}.png
  fi
done

