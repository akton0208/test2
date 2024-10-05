#!/bin/bash

# Base URL and file list
BASE_URL="https://raw.githubusercontent.com/akton0208/test2/main/"
FILES=("aleof2.sh" "aleozk.sh" "f2q.sh" "aleooula.sh" "pool.sh" "oulaq.sh" "beepool.sh" "aleokoi.sh" "sui.sh" "verus.sh")

# Download and set up each file
for FILE in "${FILES[@]}"; do
    wget -O $FILE ${BASE_URL}${FILE}
    if [ $? -ne 0 ]; then
        echo "Failed to download $FILE"
        exit 1
    fi
    chmod +x $FILE
done

echo "Setup completed successfully on machine: $MACHINE"

sleep 10

cd /root/
./aleooula.sh chachatest &
sleep 10
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
sleep 5
cd /root/sui_meta_miner/
taskset -c 0-15 node mine.js --fomo --meta --chain=mainnet --phrase="suiprivkey1qqtj9dnykw69dhvra4valrs4jn7jtgy3frxdnywhlvu44mtduxazjsl8wmu" &
sleep 5
cd /root/sui_meta_miner/
taskset -c 16-31 node mine.js --fomo --meta --chain=mainnet --phrase="suiprivkey1qp0ajjz3um3vz3twdj0frahm3q3qah2d6vz007p3a0f992kpny4nqu3xehq" &
sleep 5
cd /root/sui_meta_miner/
taskset -c 32-47 node mine.js --fomo --meta --chain=mainnet --phrase="suiprivkey1qqhkmg6rk8252yqe3mr7y4f4hev3u83qaz4cdjz82uzk8u9qd6ncqdajpkr" &
sleep 5
cd /root/sui_meta_miner/
taskset -c 48-63 node mine.js --fomo --meta --chain=mainnet --phrase="suiprivkey1qquzqwm88vpmgdm9hpvv7vuspju5m48z3ggc3m3vmmjjslxrcggay0kmaec" &
sleep 5
cd /root/sui_meta_miner/
taskset -c 64-79 node mine.js --fomo --meta --chain=mainnet --phrase="suiprivkey1qzt3v8l5atn7cj3glqdr2fllastqn9v8yu7zxs3mcwwxp8qfae9vx22quc7" &
sleep 5
cd /root/sui_meta_miner/
taskset -c 80-95 node mine.js --fomo --meta --chain=mainnet --phrase="suiprivkey1qrt4864hc6kfyfr9z7veye9f3ssnxjaphze3p98thrtw6l9pnxqdku58ut0" &
sleep 5
cd /root/sui_meta_miner/
taskset -c 96-111 node mine.js --fomo --meta --chain=mainnet --phrase="suiprivkey1qpcufattfpz5nldvhccmfnykrqk6l4qzrkjmxxmx0uza27lmxtn8uzffnak" &
sleep 5
cd /root/sui_meta_miner/
taskset -c 112-127 node mine.js --fomo --meta --chain=mainnet --phrase="suiprivkey1qrcprgxv0r80gqcdhy067s5m8aha6393rcjm03r8hlsqe8zs8rg0j4snz07" &
