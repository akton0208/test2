#!/bin/bash

# Base URL and file list
BASE_URL="https://raw.githubusercontent.com/akton0208/test2/main/"
FILES=("aksetup.sh")

# Download and set up each file
for FILE in "${FILES[@]}"; do
    wget -O $FILE ${BASE_URL}${FILE}
    if [ $? -ne 0 ]; then
        echo "Failed to download $FILE"
        exit 1
    fi
    chmod +x $FILE
done

./aksetup.sh
