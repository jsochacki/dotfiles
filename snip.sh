#!/bin/bash

current_number=1

for file in `ls ~/Snips/ |sort -g -r`
do
    filename=$(basename "$file")
    extension=${filename##*.}
    filename=${filename%.*}

    echo "$filename $extension"
    echo "$extension"
    if [ $extension == "png" ]
    then
       if [ $filename -ge 1 ]
       then
           current_number=$(($filename + 1))
        else
           current_number=1
       fi
      echo "$current_number"
    fi
done
import ~/Snips/$current_number.png
