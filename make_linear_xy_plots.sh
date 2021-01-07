#!/bin/bash

# Make sure no file names have -inc in them naturally or else they will be
# removed

# Variable heredoc generation options
#VAR+=$"test line 1
#"
#VAR+=$'test line 2\n'
#VAR+="expanded string"$'\n'
#VAR+='end'
#echo "$VAR"

function_make_gnuplot_linear_xy_plot_command () {
NEWLINE=$'\n'
COMMAND='datafile = "'$1'"'$NEWLINE
COMMAND+='labels = system("head -2 '$1' | tail -1")'$NEWLINE
COMMAND+=$NEWLINE
COMMAND+="set datafile separator ','"$NEWLINE
COMMAND+='set datafile commentschars "#"'$NEWLINE
COMMAND+="set datafile missing 'NaN'"$NEWLINE
COMMAND+=$NEWLINE
COMMAND+='set style data line'$NEWLINE
COMMAND+='set title word(labels, 1)'$NEWLINE
COMMAND+='set xlabel word(labels, 2)'$NEWLINE
COMMAND+='set ylabel word(labels, 3)'$NEWLINE
let NUMBER_OF_FIELDS=$(awk '{print NF}' $1 | head -2 | tail -1)
let ADDITIONAL_PLOTS=$NUMBER_OF_FIELDS-3
if [ $ADDITIONAL_PLOTS -gt 0 ]
then
   let baseargs=3
   for ((num=0; num < ADDITIONAL_PLOTS; num++))
   do
      let baseargs+=1
      COMMAND+='set ylabel word(labels, '$baseargs')'$NEWLINE
   done
fi
COMMAND+=$NEWLINE
COMMAND+='set terminal cairolatex \'$NEWLINE
COMMAND+='pdf \'$NEWLINE
COMMAND+='standalone \'$NEWLINE
COMMAND+="header '\usepackage{transparent} \usepackage{xcolor} \usepackage{graphicx} \usepackage{mathptmx} \usepackage[english]{babel} \usepackage[utf8]{inputenc} \usepackage{amsmath}' \\"$NEWLINE
COMMAND+="font 'Times-Roman,10' \\"$NEWLINE
COMMAND+='transparent \'$NEWLINE
COMMAND+='blacktext'$NEWLINE
COMMAND+=$NEWLINE
COMMAND+='set output "'$2'/figures/'$3'.tex"'$NEWLINE
COMMAND+=$NEWLINE
COMMAND+='plot "'$1'"'$NEWLINE
COMMAND+=$NEWLINE
echo "$COMMAND"
}

# $1 should be the full file path and full file name of the file being plotted
# /home/myproject/csvdata/data.csv
# $2 should be the full file path of the parent folder of folder containing the file being plotted
# /home/myproject
# $3 should be the file name of the file without the extension
# data
function_make_linear_xy_plot () {

GNUPLOT_COMMAND=$(function_make_gnuplot_linear_xy_plot_command $1 $2 $3)
gnuplot << EOF
$GNUPLOT_COMMAND
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
