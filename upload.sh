#!/bin/bash

for file in *.zip; do
    echo "Uploading ${file} ..."
    curl --upload-file ${file} https://oshi.at/${file}
done
