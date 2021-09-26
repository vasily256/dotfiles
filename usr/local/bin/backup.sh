#!/bin/sh

input_file="$1"
archive_dir="$input_file.arc"
archive_file="$input_file.tar.xz"
XZ_OPT='-T0 -9'

mkdir $archive_dir
tar -cJvf "$archive_dir/$archive_file" $input_file
cd $archive_dir
sha256sum $archive_file > "$archive_file.sha256"
par2 create -n1 -r5 $archive_file
cd ..

