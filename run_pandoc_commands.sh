#!/bin/bash

# Needs to be passed base dir of project without / i.e. /home/project

###############################################################################
# This is the portion where I define the functions

function_run_or_not () {

PROCEED=

if [ ! -f "$1" ]
then
   touch $1
   # Note not an actual bool since bash has none but just a string named true
   # if you don't assign a string though it will eval to false so acts as bool
   # the way that I use it here
   PROCEED=true
fi

echo "$PROCEED"

}

function_run_pandoc_command () {

case "$2" in
   -markdown-to-pdf | -mdtpdf) echo "$2 selected"
      INFILE=$1/$3.md
      OUTFILE=$1/$3.pdf
      pandoc -s -f markdown-implicit_figures -t pdf $INFILE -o $OUTFILE
      ;;
   -markdown-to-pdf-with-tex-figure-placement | -mdtpdfwtfp) echo "$2 selected"
      INFILE=$1/$3.md
      OUTFILE=$1/$3.pdf
      pandoc -s -f markdown -t pdf $INFILE -o $OUTFILE
      ;;
   -markdown-to-pptx | -mdtpptx) echo "$2 selected"
      INFILE=$1/$3.md
      OUTFILE=$1/$3.pptx
      pandoc -s -f markdown-implicit_figures -t pptx $INFILE -o $OUTFILE --reference-doc template.pptx
      ;;
   -markdown-to-pptx-no-template | -mdtpptxnt) echo "$2 selected"
      INFILE=$1/$3.md
      OUTFILE=$1/$3.pptx
      pandoc -s -f markdown-implicit_figures -t pptx $INFILE -o $OUTFILE
      ;;
   *) echo "No such command $2 supported for run_pandoc_commands.sh currently"
      ;;
esac

}


###############################################################################
# This is the actual script portion

if [ $# -ne 3 ]
then
   echo "Usage : Argument 1: $1 needs to be the base dir of the project with the / at the
end, i.e. /home/project"
   echo "Usage : Argument 2: $2 needs to be the pandoc command selected i.e.
   -markdown-to-pdf, -markdown-to-pdf-with-tex-figure-placement, etc...."
   echo "Usage : Argument 3: $3 needs to be the pandoc input file name alone, no
   extension i.e. my-file"
   exit 1
fi

MUTEX_LOCK="$1/build/pandoc/.pandoc_lock"
RUN_BUILD=$(function_run_or_not $MUTEX_LOCK)

# Exit if already in process
if [ ! $RUN_BUILD ]
then
   exit 1
fi

RETURN_STATUS=$(function_run_pandoc_command $1 $2 $3)

echo $RETURN_STATUS

# Only a nuclear 9 will skip this part i.e. kill -9
trap "rm $MUTEX_LOCK" EXIT
