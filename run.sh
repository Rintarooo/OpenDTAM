#!/bin/bash

rm -rf build
cd OpenDTAM
mkdir build
cd build
cmake ../Cpp
make -j${nproc}
./a.out ../Trajectory_30_seconds/