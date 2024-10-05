#!/bin/bash

HOSTNAME=$(hostname)

apt update
apt install screen -y
apt-get install libsodium23 -y

# Download ore-mine-pool-linux
wget -O SRBMiner-Multi-2-6-7-Linux.tar.gz https://github.com/doktor83/SRBMiner-Multi/releases/download/2.6.7/SRBMiner-Multi-2-6-7-Linux.tar.gz
tar -vxf SRBMiner-Multi-2-6-7-Linux.tar.gz
cd SRBMiner-Multi-2-6-7

# Run hellminer and redirect output to pool.log
screen -dmS srb ./SRBMiner-MULTI --disable-gpu --algorithm verushash  --pool stratum+tcp://ru.vipor.net:5045 --wallet RSMqnwwxaaMDRnBS2W9E7oRfWg7AWwcwyr.$HOSTNAME >> /root/srb.log 2>&1 &
if [ $? -ne 0 ]; then
    echo "Failed to run hellminer"
    exit 1
fi

echo "hellminer is running in the background"
