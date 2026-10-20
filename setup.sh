#!/bin/bash

apt-get update && apt-get install -y wget tar
cd /workspace

# 1. Download and extract the miner if it doesn't exist yet
if [ ! -d SRBMiner-Multi* ]; then
    wget https://github.com/doktor83/SRBMiner-Multi/releases/download/3.7.7/SRBMiner-Multi-3-7-7-Linux.tar.gz
    tar -xf SRBMiner-Multi-3-7-7-Linux.tar.gz
    rm SRBMiner-Multi-3-7-7-Linux.tar.gz
fi

cd SRBMiner-Multi*
chmod +x SRBMiner-MULTI

# 2. Dynamically find the path to the miner directory
MINER_DIR=$(pwd)

# Generate a random 6-digit number for the worker name suffix
RANDOM_ID=$(shuf -i 100000-999999 -n 1)

# 3. Create the persistent auto-start script required by Vast.ai
cat << EOF > /root/onstart.sh
#!/bin/bash
cd $MINER_DIR
nohup ./SRBMiner-MULTI --disable-cpu --algorithm pearlhash --pool stratum+tcp://pearlpow.unmineable.com:3333 --wallet sharednode.rented${RANDOM_ID} > /workspace/miner.log 2>&1 &
EOF

# 4. Make the auto-start script executable
chmod +x /root/onstart.sh

# 5. Manually trigger it for this initial setup launch
/root/onstart.sh

echo "Miner initialization and persistent auto-start configuration complete with worker ID: rented${RANDOM_ID}"
