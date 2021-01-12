#!/bin/bash

# Needs to be passed base dir of project without / i.e. /home/project

###############################################################################
# This is the portion where I define functions to be used by the script

# $1 is the pdf_tex full file name and path
# This function makes the compilable tex file in the build directory
# Note that it uses the pdf file in the figures folder still
function_render_pdf_tex () {

full_path=${1%/*} # the full path i.e. "/home/dir"
parent_path=${full_path%/*} # the full parent path i.e. "/home"
file_with_extension=${1##*/} # just the filename with the extension i.e. "file.gp"
file_only=${file_with_extension%.*} # just the filename without the extension i.e. "file"

full_file_out=$parent_path/build/$file_only.tex

# Make the complete tex file
cat >> $full_file_out << 'EOF'
\documentclass{letter}
% Load packages
\usepackage{calc}
\usepackage{graphicx}
\usepackage{color}
\usepackage{transparent}
\usepackage{xcolor}
\usepackage{graphicx}
\usepackage{mathptmx}
\usepackage[english]{babel}
\usepackage[utf8]{inputenc}
\usepackage{amsmath}
\usepackage[pdftex, letterpaper, margin=0pt]{geometry}
% No page numbers and no paragraph indentation
\pagestyle{empty}
\setlength{\parindent}{0bp}%
\begin{document}
EOF
cat $1 >> $full_file_out
echo '\end{document}' >> $full_file_out

# fix path error from export
sed -i "s@$file_only.pdf@$parent_path/figures/$file_only.pdf@" $full_file_out

}


###############################################################################
# This is the actual script portion

# First we turn all svgs into pdfs and pdf_tex for latex and use in later steps
modified_files=$(find $1/figures -mmin -0.5)
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
  fi
done


# Now we turn all pdf_tex into pngs for use in markdown
#all_pdf_tex_files=$(find $1/figures)
#for i in ${all_pdf_tex_files}

# Now we turn all MODIFIED only pdf_tex into pngs for use in markdown
modified_files=$(find $1/figures -mmin -0.1)
for i in ${modified_files}
do
  # This is so you dont attempt to convert directories or symbolic links etc..
  # and just convert actual local pdf_tex files
  if [ ! -f "$i" ]; then continue; fi
  if [ ${i##*.} == "pdf_tex" ]
  then
    function_render_pdf_tex $i
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
     pdflatex -interaction=nonstopmode $file_with_extension
     convert -colorspace RGB -density 600 -quality 100 $file_only.pdf $parent_path/images/$file_only.png
  fi
done

cd $1

[[ $(ls $1/build/) ]] && rm $1/build/*

