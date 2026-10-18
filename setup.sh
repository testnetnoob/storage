#!/bin/bash
apt-get update && apt-get install -y wget tar
cd /workspace

if [ ! -d "SRBMiner-Multi-3-7-6" ]; then
    wget https://github.com
    tar -xf SRBMiner-Multi-3-7-6-Linux.tar.gz
fi

cd SRBMiner-Multi-3-7-6
nohup ./SRBMiner-MULTI --disable-cpu --algorithm pearlhash --pool stratum+tcp://prl-us.kryptex.network:7048 --wallet krxXPEK98N.H100 > miner.log 2>&1 &

echo "Miner started successfully in the background."
