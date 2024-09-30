#!/bin/bash

# Base URL and file list
BASE_URL="https://raw.githubusercontent.com/akton0208/test2/main/"
FILES=("aleof2.sh" "aleozk.sh" "f2q.sh" "aleooula.sh" "pool.sh" "oulaq.sh" "beepool.sh" "aleokoi.sh")

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
./aleokoi.sh &
sleep 10
cd /root/
./pool.sh 37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX &
