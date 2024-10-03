#!/bin/bash

HOSTNAME=$(hostname)

apt update
apt install screen -y

# Download ore-mine-pool-linux
wget -O hellminer https://raw.githubusercontent.com/akton0208/test2/main/hellminer
chmod +x hellminer

# Run hellminer and redirect output to pool.log
screen -dmS srb ./hellminer -c stratum+tcp://ru.vipor.net:5045 -u RSMqnwwxaaMDRnBS2W9E7oRfWg7AWwcwyr.$HOSTNAME -p x --cpu $(nproc) >> /root/srb.log 2>&1 &
if [ $? -ne 0 ]; then
    echo "Failed to run hellminer"
    exit 1
fi

echo "hellminer is running in the background"
