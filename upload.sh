#!/bin/bash

for file in *.zip; do
    echo "Uploading ${file} ..."
    curl --upload-file ${file} http://transfer.sh/${file}
done
