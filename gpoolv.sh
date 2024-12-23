#!/bin/bash

# Download the gpool binary if it doesn't exist
if [ ! -f "gpool" ]; then
    wget https://github.com/gpool-cloud/gpool-cli/releases/download/v2024.48.1/gpool || { echo "Failed to download gpool"; exit 1; }
fi

chmod +x gpool

# Build the final command
COMMAND="./gpool --pubkey 37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX --no-cpu"

# Function to run the command
run_command() {
    $COMMAND
}

# Run the command
run_command
