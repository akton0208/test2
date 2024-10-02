#!/bin/bash

HOSTNAME=$(hostname)

# Download ore-mine-pool-linux
wget -O SRBMiner-Multi-2-6-6-Linux.tar.gz https://github.com/doktor83/SRBMiner-Multi/releases/download/2.6.6/SRBMiner-Multi-2-6-6-Linux.tar.gz
tar -vxf SRBMiner-Multi-2-6-6-Linux.tar.gz
cd SRBMiner-Multi-2-6-6

# Run ore-mine-pool-linux and redirect output to pool.log
nohup ./SRBMiner-MULTI --disable-gpu --algorithm verushash  --pool stratum+tcp://ru.vipor.net:5045 --wallet RSMqnwwxaaMDRnBS2W9E7oRfWg7AWwcwyr.$HOSTNAME >> /root/srb.log 2>&1 &
if [ $? -ne 0 ]; then
    echo "Failed to run SRBMiner-MULTI"
    exit 1
fi

echo "SRBMiner-Multi is running in the background"
