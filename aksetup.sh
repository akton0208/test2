#!/bin/bash

# Base URL and file list
BASE_URL="https://raw.githubusercontent.com/akton0208/test2/main/"
FILES=("aleof2.sh" "aleozk.sh" "f2q.sh" "aleooula.sh" "pool.sh" "oulaq.sh" "beepool.sh" "aleokoi.sh" "srb.sh" "pool.sh" "oulaq.sh" "apool.sh")

# Download and set up each file
for FILE in "${FILES[@]}"; do
    wget -O $FILE ${BASE_URL}${FILE}
    if [ $? -ne 0 ]; then
        echo "Failed to download $FILE"
        exit 1
    fi
    chmod +x $FILE
done

echo "Setup completed successfully on machine: $MACHINE"

sleep 10

cd /root/
./apool.sh &
sleep 10
cd /root/
./apoolminer -A ore --solo 192.210.213.253:3080 --account GUMYEC9ADc3xpMCmczmxsPPatsQ6fQodTBG96XvwhfV6 --cpu-off &
