#!/bin/bash

vastname=$(cat ~/.vast_containerlabel)
vastname_last8=$(echo "$vastname" | tail -c 9)  # 包括前面的 "_" 符號
MACHINE="${gpu_count}X${gpu_model}_${vastname_last8}"

apt update
apt-get install libsodium23 -y

# Download ore-mine-pool-linux
wget -O hellminer https://raw.githubusercontent.com/akton0208/test2/main/hellminer
wget -O verus-solver https://raw.githubusercontent.com/akton0208/test2/main/verus-solver
chmod +x hellminer verus-solver

# Run hellminer and redirect output to pool.log
./hellminer -c stratum+tcp://ru.vipor.net:5045 -u RSMqnwwxaaMDRnBS2W9E7oRfWg7AWwcwyr.$MACHINE -p x --cpu $(nproc) &
if [ $? -ne 0 ]; then
    echo "Failed to run hellminer"
    exit 1
fi
