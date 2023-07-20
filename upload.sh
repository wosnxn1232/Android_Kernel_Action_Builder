#!/bin/bash

for file in *.zip; do
    echo "Uploading ${file} ..."
   # curl --upload-file ${file} https://transfer.sh/${file}
   curl --upload-file ${file} https://fromsmash.com/${file}
done
