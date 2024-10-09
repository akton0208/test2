#!/bin/bash

MACHINE=$(hostname)

# Download and set up oula-aleominer
wget https://github.com/apool-io/apoolminer/releases/download/v2.3.1/apoolminer_linux_v2.3.1.tar
tar -vxf apoolminer_linux_v2.3.1.tar

# Download the file
wget -O qli-Client-2.2.1-Linux-x64.tar.gz https://dl.qubic.li/downloads/qli-Client-2.2.1-Linux-x64.tar.gz

# Extract the file
tar -xzvf qli-Client-2.2.1-Linux-x64.tar.gz

# Create and write to appsettings.json file
cat <<EOL > "appsettings.json"
{
  "Settings": {
    "baseUrl": "https://mine.qubic.li/",
    "allowHwInfoCollect": true,
    "overwrites": {
      "CUDA": "12"
    },
    "accessToken": "$ACCESS_TOKEN",
    "alias": "$MACHINE",
    "idleSettings": {
      "gpuOnly": true,
      "command": "/root/apoolminer",
      "arguments": "-A ore --solo 192.210.213.253:3080 --account GUMYEC9ADc3xpMCmczmxsPPatsQ6fQodTBG96XvwhfV6 --cpu-off"
    }
  }
}
EOL

# Run qli-Client
./qli-Client
