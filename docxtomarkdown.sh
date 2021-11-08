#!/bin/bash

pandoc -s -f docx -t markdown --extract-media ./ "$1".docx -o "$1".md
cd media
libreoffice --headless --convert-to png *.emf
rm *.emf
for file in image*.png
do
   mv "$file" "${file/image/"$1"image}"
done
mv * ../images
cd ../
rm -rf media

