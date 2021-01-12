#!/bin/bash

# Needs to be passed base dir of project without / i.e. /home/project
all_gp_files=$(find $1/gp-files)
for i in ${all_gp_files}
do
  # This is so you dont attempt to convert directories or symbolic links etc..
  # and just convert actual local gp files
  if [ ! -f "$i" ]; then continue; fi
  if [ ${i##*.} == "gp" ]
  then
     #echo $i
     gnuplot $i
  fi
done

cd $1/build

all_tex_files=$(find $1/build)
for i in ${all_tex_files}
do
  # This is so you dont attempt to convert directories or symbolic links etc..
  # and just convert actual local tex files
  if [ ! -f "$i" ]; then continue; fi
  if [ ${i##*.} == "tex" ]
  then
     full_path=${i%/*} # the full path i.e. "/home/dir"
     parent_path=${full_path%/*} # the full parent path i.e. "/home"
     file_with_extension=${i##*/} # just the filename with the extension i.e. "file.gp"
     file_only=${file_with_extension%.*} # just the filename without the extension i.e. "file"
     #echo $file_with_extension
     #echo $file_only.pdf
     #echo $parent_path/figures/
     #echo $parent_path/figures/$file_only.pdf
     #echo $parent_path/images/$file_only.png
     pdflatex -interaction=nonstopmode $file_with_extension
     mv $file_only.pdf $parent_path/figures/
     convert -density 600 -quality 100 $parent_path/figures/$file_only.pdf $parent_path/images/$file_only.png
  fi
done

cd $1

[[ $(ls $1/build/) ]] && rm $1/build/*

#echo $i
#echo ${i##*.} # just the extension without the . i.e. "gp"
#echo ${i%/*} # the full path i.e. "/home/dir"
#echo ${TMP%/*} # the full paths parent directory i.e. "/home"
#echo ${i%.*} # the full path and the filename without extension i.e. "/home/dir/file"
