#!/bin/bash
set -e

if [ -f "exiftool_bin/exiftool.exe" ]; then
    echo "ExifTool executable already exists in exiftool_bin/exiftool.exe, skipping download."
    exit 0
fi

echo "Downloading ExifTool..."
curl -L -o exiftool.zip "https://sourceforge.net/projects/exiftool/files/exiftool-13.59_64.zip/download"

mkdir -p exiftool_bin
# Extract the executable and the required exiftool_files directory
unzip -q exiftool.zip "exiftool-*/exiftool(-k).exe" "exiftool-*/exiftool_files/*" -d .
chmod -R 755 exiftool-*
# Move contents to exiftool_bin
mv exiftool-*/exiftool\(-k\).exe exiftool_bin/exiftool.exe
mv exiftool-*/exiftool_files exiftool_bin/
rm -rf exiftool-*/

echo "Cleaning up..."
rm exiftool.zip
