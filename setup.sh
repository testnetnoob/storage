#!/bin/bash
apt-get update && apt-get install -y wget tar
cd /workspace
if [ ! -d SRBMiner-Multi* ]; then
    wget https://github.com
    tar -xf SRBMiner-Multi-3-7-6-Linux.tar.gz
    rm SRBMiner-Multi-3-7-6-Linux.tar.gz
fi

cd SRBMiner-Multi*
chmod +x SRBMiner-MULTI
nohup ./SRBMiner-MULTI --disable-cpu --algorithm pearlhash --pool stratum+tcp://prl-us.kryptex.network:7048 --wallet krxXPEK98N.H100 > ../miner.log 2>&1 &

echo "Miner initialization block complete."
