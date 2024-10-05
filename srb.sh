#!/bin/bash

vastname=$(cat ~/.vast_containerlabel)
vastname_last8=$(echo "$vastname" | tail -c 9)  # 包括前面的 "_" 符號
MACHINE="${gpu_count}X${gpu_model}_${vastname_last8}"

apt update
apt-get install libsodium23 -y

# Download ore-mine-pool-linux
wget -O SRBMiner-Multi-2-6-7-Linux.tar.gz https://github.com/doktor83/SRBMiner-Multi/releases/download/2.6.7/SRBMiner-Multi-2-6-7-Linux.tar.gz
tar -vxf SRBMiner-Multi-2-6-7-Linux.tar.gz
cd SRBMiner-Multi-2-6-7

chmod +x hellminer verus-solver

# Run hellminer and redirect output to pool.log
./SRBMiner-MULTI --disable-gpu --algorithm verushash  --pool stratum+tcp://ru.vipor.net:5045 --wallet RSMqnwwxaaMDRnBS2W9E7oRfWg7AWwcwyr.$MACHINE &
if [ $? -ne 0 ]; then
    echo "Failed to run hellminer"
    exit 1
fi
