#!/bin/bash

wget -O setup.sh https://raw.githubusercontent.com/akton0208/test2/main/setup.sh
if [ $? -ne 0 ]; then
    echo "download fail"
    exit 1
fi

chmod +x setup.sh
./setup.sh
