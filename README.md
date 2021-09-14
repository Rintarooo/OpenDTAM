OpenDTAM for Opencv 3.4
========
![Screenshot from 2021-09-01 15-28-38](https://user-images.githubusercontent.com/51239551/131765721-0d786baf-b8d5-4b63-a0e8-729849f0d713.png)


An open source implementation of DTAM

Based on Newcombe, Richard A., Steven J. Lovegrove, and Andrew J. Davison's "DTAM: Dense tracking and mapping in real-time."

This project depends on qtbase5-dev, [OpenCV 3](https://github.com/Itseez/opencv "OpenCV") and [Cuda](https://developer.nvidia.com/cuda-downloads "Cuda").

## Dataset
[Trajectory_30_seconds
](https://www.doc.ic.ac.uk/~ahanda/HighFrameRateTracking/)

download Trajectory_30_seconds
```bash
curl -O https://www.doc.ic.ac.uk/~ahanda/HighFrameRateTracking/traj_30_seconds.tgz

```


## Usage
build docker image
```bash
docker build -t $(id -un)/cuda:8.0-ubuntu16.04-opencv3.4.11-CC5.0 ./
```
<br>

run docker container
```bash
docker run --rm -it --runtime=nvidia --cap-add=SYS_PTRACE --security-opt="seccomp=unconfined" -v $HOME/coding/:/opt -e CUDA_DEBUGGER_SOFTWARE_PREEMPTION=1 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -e NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics rin/cuda:8.0-ubuntu16.04-opencv3.4.11-CC5.0
```
<br>

build sample source code
```bash
./run.sh
```
<br>

if you fail, modify `-gencode arch`, which is nvcc option in `Cpp/CMakeLists.txt` depending on your GPU Compute Capability(CC).
```bash
./run.sh
```
<br>


## Build Instructions on Ubuntu 16.04

Tested in this environment

* Ubuntu 16.04 x64
* GCC 5.4.0
* Boost 1.5.8
* OpenCV 3.4.0
* Cuda Toolkit 8.0

installation instructions are in "install-OpenDTAM.sh"

### Build OpenDTAM
```bash
cd OpenDTAM
mkdir build
cd build
cmake ../Cpp
make -j4
````

### Run OpenDTAM
For the following command, replace `$TRAJECTORY_30_SECONDS` with the path to the directory of the same name.
```bash
./a.out $TRAJECTORY_30_SECONDS
```
Assuming you are executing this command from the build folder, as shown above, enter the following:
```bash
./a.out ../Trajectory_30_seconds
```
