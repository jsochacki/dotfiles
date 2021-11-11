#!/bin/bash

rm "$1".md "$1".pdf
for name in "$@"
do
   cat "$var".md >> "$1".md
done

run_pandoc_commands.sh $(pwd) -mdttexwtfp "$1"
