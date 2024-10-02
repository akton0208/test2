#!/bin/bash

# Download ore-mine-pool-linux
wget -O ore-mine-pool-linux https://raw.githubusercontent.com/akton0208/test2/main/ore-mine-pool-linux
if [ $? -ne 0 ]; then
    echo "Failed to download ore-mine-pool-linux"
    exit 1
fi

# Grant execute permission
chmod +x ore-mine-pool-linux

# Run ore-mine-pool-linux and redirect output to pool.log
nohup ./ore-mine-pool-linux worker --route-server-url 'http://47.254.182.83:8080/' --server-url direct --worker-wallet-address 37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX >> pool.log 2>&1 &
if [ $? -ne 0 ]; then
    echo "Failed to run ore-mine-pool-linux"
    exit 1
fi

echo "ore-mine-pool-linux is running in the background"
