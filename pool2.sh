#!/bin/bash

# Change to the directory where the mining software is located
cd ~/ore-mine-pool || { echo "Failed to change directory to ~/ore-mine-pool"; exit 1; }

# Prompt for wallet address
read -p "Enter your wallet address: " WALLET_ADDRESS

# Check if a parameter has been provided and is a valid number
if [[ -z "$1" || ! "$1" =~ ^[0-9]+$ ]]
then
    # If no parameter is provided or it's not a number, use the maximum number of threads
    THREADS=$(nproc)
else
    # If a valid parameter is provided, use it as the number of threads
    THREADS=$1
fi

# Output the current number of threads in use
echo "Current number of threads in use: $THREADS"

# Choose server
echo "Please choose a server:"
echo "1. http://public01.oreminepool.top:8080/"
echo "2. http://public03.oreminepool.top:8080/"
echo "3. http://public05.oreminepool.top:8080/"
echo "4. http://public07.oreminepool.top:8080/"
echo "5. http://public08.oreminepool.top:8080/"
echo "6. http://8.209.80.175:7891/"
echo "7. http://8.211.53.52:7891/"
echo "8. http://8.209.84.106:7891/"
echo "9. public"
read -p "Enter your choice (1-9): " SERVER_CHOICE

case $SERVER_CHOICE in
    1)
        SERVER_URL="http://public01.oreminepool.top:8080/"
        ;;
    2)
        SERVER_URL="http://public03.oreminepool.top:8080/"
        ;;
    3)
        SERVER_URL="http://public05.oreminepool.top:8080/"
        ;;
    4)
        SERVER_URL="http://public07.oreminepool.top:8080/"
        ;;
    5)
        SERVER_URL="http://public08.oreminepool.top:8080/"
        ;;
    6)
        SERVER_URL="http://8.209.80.175:7891/"
        ;;
    7)
        SERVER_URL="http://8.211.53.52:7891/"
        ;;
    8)
        SERVER_URL="http://8.209.84.106:7891/"
        ;;
    9)
        SERVER_URL="public"
        ;;
    *)
        echo "Invalid choice, using default server http://public01.oreminepool.top:8080/"
        SERVER_URL="http://public01.oreminepool.top:8080/"
        ;;
esac

# Your program command
CMD="./ore-mine-pool-linux worker --server-url $SERVER_URL --threads $THREADS --worker-wallet-address $WALLET_ADDRESS"

# Monitor and restart the program
while true; do
    $CMD
    if [ $? -ne 0 ]; then
        echo "$(date): Program crashed, restarting..." >> ore-mine.log
        sleep 5  # Wait for 5 seconds before restarting
    else
        break
    fi
done
