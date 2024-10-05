
#!/bin/bash

# 安裝 Node.js 和 npm
apt update -y
apt install curl -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.bash_profile
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> $HOME/.bash_profile
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> $HOME/.bash_profile
source $HOME/.bash_profile
nvm install --lts

# 克隆並安裝 sui_meta_miner
git clone https://github.com/suidouble/sui_meta_miner.git
cd sui_meta_miner
npm install

# Define your command
command="node mine.js --fomo --meta --chain=mainnet --phrase="suiprivkey1qrcprgxv0r80gqcdhy067s5m8aha6393rcjm03r8hlsqe8zs8rg0j4snz07""

# Display the final command
echo "Final command: $command"

# Start the command initially
$command &

# Short delay before the first check
sleep 10

# Monitoring loop
while true; do
    # Check if the process is running
    if ! pgrep -f "$command" > /dev/null; then
        echo "Process has stopped, restarting..."
        $command &
    fi
    # Check every 60 seconds
    sleep 60
done
