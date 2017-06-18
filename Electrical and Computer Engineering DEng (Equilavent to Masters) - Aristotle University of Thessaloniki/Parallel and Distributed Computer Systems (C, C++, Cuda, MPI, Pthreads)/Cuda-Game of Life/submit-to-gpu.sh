#!/bin/bash
#PBS -N GPU-properties
#PBS -q auth
#PBS -j oe
#PBS -l nodes=1:gpu

cd $PBS_O_WORKDIR

module load cuda
nvcc GoLgm.cu -o gm
nvcc GoLgmc.cu -o gmc
nvcc GoLsm.cu -o sm
chmod u+x ./gm table1000x1000.bin 1000 1000
./gm table1000x1000.bin 1000 100

chmod u+x ./gmc table1000x1000.bin 1000 1000
./gmc table1000x1000.bin 1000 100

chmod u+x ./sm table1000x1000.bin 1000 1000
./sm table1000x1000.bin 1000 1000