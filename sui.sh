#!/bin/bash

# 安裝 Node.js 和 npm
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

# 設置日誌文件
LOGFILE="mine.log"

# 清空舊的日誌文件
> $LOGFILE

# 獲取當前的CPU線程數
CPU_THREADS=$(nproc)

# 計算需要的進程數和每個進程使用的線程數
PROCESS_COUNT=$((CPU_THREADS / 8))
REMAINING_THREADS=$((CPU_THREADS % 8))

# 啟動進程
for i in $(seq 0 $((PROCESS_COUNT - 1))); do
  taskset -c $((i*8))-$((i*8+7)) node mine.js --fomo --chain=mainnet --phrase="suiprivkey1qra8uek4dqnkpduw9xcq6fk8x2c9vhwu92lkny68f6ynwj00jk535j5ya6h" >> $LOGFILE 2>&1 &
done

# 如果有剩餘的線程，啟動一個使用剩餘線程的進程
if [ $REMAINING_THREADS -gt 0 ]; then
  taskset -c $((PROCESS_COUNT*8))-$((PROCESS_COUNT*8+REMAINING_THREADS-1)) node mine.js --fomo --chain=mainnet --phrase="suiprivkey1qra8uek4dqnkpduw9xcq6fk8x2c9vhwu92lkny68f6ynwj00jk535j5ya6h" >> $LOGFILE 2>&1 &
fi

# 使用 tail -f 查看日誌
tail -f $LOGFILE
