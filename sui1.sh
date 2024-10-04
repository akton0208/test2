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

node mine.js --fomo --meta --chain=mainnet --phrase="suiprivkey1qpr6ys2qg0h9mplvm7s5akwt77dch2grrztfhfzwwqvwjr34cu6kyr4whq6"
