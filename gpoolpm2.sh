#!/bin/bash

# Default wallet address
default_wallet_address="37BgmeJABVhQe9xzuG7UdD6Dy2QF7UAj2Yv7pY37yqwX"

# Function to create PM2 ecosystem file
create_pm2_config() {
    if [ "$1" == "1" ]; then
        cat <<EOL > ecosystem.config.js
module.exports = {
  apps: [{
    name: 'gpool',
    script: './gpool',
    args: '--pubkey $wallet_address --pool 3.64.194.119:10475',
    restart_delay: 600000, // 10 minutes (in milliseconds)
    autorestart: true, // Automatically restart
    watch: false, // Do not watch for file changes
    min_uptime: 30000, // Minimum uptime (in milliseconds)
    exp_backoff_restart_delay: 100, // Exponential backoff restart delay (in milliseconds)
    kill_timeout: 1600, // Time to wait before killing the process (in milliseconds)
    listen_timeout: 8000 // Time to wait for the application to start (in milliseconds)
  }]
};
EOL
    elif [ "$1" == "2" ]; then
        cat <<EOL > ecosystem.config.js
module.exports = {
  apps: [{
    name: 'gpool',
    script: './gpool',
    args: '--pubkey $wallet_address --no-pcie --pool 3.64.194.119:10475',
    restart_delay: 600000, // 10 minutes (in milliseconds)
    autorestart: true, // Automatically restart
    watch: false, // Do not watch for file changes
    min_uptime: 30000, // Minimum uptime (in milliseconds)
    exp_backoff_restart_delay: 100, // Exponential backoff restart delay (in milliseconds)
    kill_timeout: 1600, // Time to wait before killing the process (in milliseconds)
    listen_timeout: 8000 // Time to wait for the application to start (in milliseconds)
  }]
};
EOL
    else
        echo "Invalid argument for PM2 configuration. Please use 1 or 2."
        exit 1
    fi
}

# Main script logic
case "$1" in
    start)
        # Ensure the PM2 configuration argument is provided
        if [ -z "$2" ]; then
            echo "Missing PM2 configuration argument. Please use 1 or 2."
            exit 1
        fi

        # Check if a wallet address is provided, otherwise use the default address
        wallet_address=${3:-$default_wallet_address}

        # Update system and install necessary packages
        if ! apt-get update; then
            echo "Failed to update package list"
            exit 1
        fi

        # Check if wget and curl are installed, if not, install them
        if ! command -v wget &> /dev/null || ! command -v curl &> /dev/null; then
            if ! apt-get install -y wget curl; then
                echo "Failed to install wget and curl"
                exit 1
            fi
        else
            echo "wget and curl are already installed"
        fi

        # Check if Node.js is installed, if not, install it
        if ! command -v node &> /dev/null; then
            curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
            if ! apt-get install -y nodejs; then
                echo "Failed to install Node.js"
                exit 1
            fi
        else
            echo "Node.js is already installed"
        fi

        # Check if PM2 is installed, if not, install it
        if ! command -v pm2 &> /dev/null; then
            if ! npm install -g pm2; then
                echo "Failed to install PM2"
                exit 1
            fi
        else
            echo "PM2 is already installed"
        fi

        # Download gpool
        if ! wget -O gpool https://github.com/gpool-cloud/gpool-cli/raw/refs/heads/main/gpool; then
            echo "Failed to download gpool"
            exit 1
        fi

        # Make gpool executable
        if ! chmod +x gpool; then
            echo "Failed to make gpool executable"
            exit 1
        fi

        # Create PM2 ecosystem file
        create_pm2_config "$2"

        # Start the application with PM2
        if ! pm2 start ecosystem.config.js; then
            echo "Failed to start the application with PM2"
            exit 1
        fi

        echo "Setup completed successfully!"
        ;;
    restart)
        if ! pm2 restart gpool; then
            echo "Failed to restart the application with PM2"
            exit 1
        fi
        echo "Application restarted successfully!"
        ;;
    stop)
        if ! pm2 stop gpool && pm2 delete gpool; then
            echo "Failed to stop and delete the application with PM2"
            exit 1
        fi

        # Remove .gpool directory
        if ! rm -r .gpool; then
            echo "Failed to remove .gpool directory"
            exit 1
        fi

        echo "Application stopped, deleted, and .gpool directory removed successfully!"
        ;;
    *)
        echo "Invalid command. Use start, restart, or stop."
        exit 1
        ;;
esac
