#!/bin/bash

# Make sure no file names have -inc in them naturally or else they will be
# removed

# $1 should be the full file path and full file name of the file being plotted
# /home/myproject/csvdata/data.csv
# $2 should be the full file path of the parent folder of folder containing the file being plotted
# /home/myproject
# $3 should be the file name of the file without the extension
# data
function_make_linear_xy_plot () {

gnuplot -p << EOF
datafile = "$1"
labels = system("head -2 $1 | tail -1")

set datafile separator ','
set datafile commentschars "#"
set datafile missing 'NaN'

set style data lines
set title word(labels, 1)
set xlabel word(labels, 2)
set ylabel word(labels, 3)

set terminal cairolatex \
             pdf \
             standalone \
             header '\usepackage{transparent} \usepackage{xcolor} \usepackage{graphicx} \usepackage{mathptmx} \usepackage[english]{babel} \usepackage[utf8]{inputenc} \usepackage{amsmath}' \
             font 'Times-Roman,10' \
             transparent \
             blacktext
set output "$2/figures/$3.tex"

plot "$1"

EOF

cd $2/figures
pdflatex -interaction=nonstopmode $3.tex
convert -density 600 -quality 100 $3.pdf ../images/$3.png
rm *.aux *-inc.pdf *.log *.tex
cd $2

}

#set key autotitle columnheader
#set key title 'Data' center
#set key fixed right top vertical box lt black linewidth 1.000 dashtype solid
#set key noinvert samplen 0 spacing 2 width 3 height 1

# This script needs to be passed the directory to the base folder i.e.
# /home/myproject where there is a /home/myproject/csv-data etc..

all_files=$(find $1/csv-data)
for i in ${all_files}
do
  # This is so you dont attempt to convert directories or symbolic links etc..
  # and just convert actual local svg files
  if [ ! -f "$i" ]; then continue; fi
  if [ ${i##*.} == "csv" ]
  then
     full_path=${i%/*} # the full path i.e. "/home/dir"
     parent_path=${full_path%/*} # the full parent path i.e. "/home"
     file_with_extension=${i##*/} # just the filename with the extension i.e. "file.csv"
     file_only=${file_with_extension%.*} # just the filename without the extension i.e. "file"
     #echo $full_path
     #echo $parent_path
     #echo $file_with_extension
     #echo $file_only
     #echo $i
     #echo ${i##*.} # just the extension without the . i.e. "csv"
     #echo ${i%/*} # the full path i.e. "/home/dir"
     #echo ${TMP%/*} # the full paths parent directory i.e. "/home"
     #echo ${i%.*} # the full path and the filename without extension i.e. "/home/dir/file"
     function_make_linear_xy_plot $i $parent_path $file_only
  fi
done

# NOTE: Another option is to change the line "pdf \" to "eps \" and then you can
# use "latex -interaction-nonstopmode file2.tex" to make a dvi file which you
# can use "dvips -o file2.ps file2.dvi" to make a ps and then 
# "convert -density 600 -quality 100 file2.ps file2.png" to convert it to a png
# but this is more steps than just going from pdf so just go direct from pdf
# unless there are image issues in the future

# NOTE: the set output filename needs to be full from root to avoid missing
# file errors
