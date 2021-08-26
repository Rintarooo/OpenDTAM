FROM nvidia/cuda:8.0-devel-ubuntu16.04
ENV DEBIAN_FRONTEND noninteractive

## check opencv version with cuda version
## https://qiita.com/tomoaki_teshima/items/294c9ffb03a3dcc4cfef
ARG OPENCV_VERSION='3.4.11'

## check Compute Capability(CC) with the url of the official cuda website below
## https://developer.nvidia.com/cuda-gpus
## if you don't know your GPU name, check by $ nvidia-settings or $ nvidia-smi
## GPU_ARCH should be the value lower than your GPU CC, otherwise it won't work when you use cuda enabled opencv.
## https://qiita.com/sonots/items/1c60ccb6ffec6d04b223

# ARG GPU_ARCH='6.1'
# ARG GPU_ARCH='5.2'
ARG GPU_ARCH='5.0'


WORKDIR /opt

# Build tools
RUN apt update && \
    apt install -y \
    sudo \
    tzdata \
    git \
    cmake \
    wget \
    unzip \
    build-essential \
    curl \
    vim \
    gdb \
    gnuplot \
    nvidia-cuda-gdb \
    libboost-all-dev \
    qtbase5-dev \
    qttools5-dev-tools \
    qt5-default


# Media I/O:
RUN sudo apt install -y \
    zlib1g-dev \
    libjpeg-dev \
    libwebp-dev \
    libpng-dev \
    libtiff5-dev \
    libopenexr-dev \
    libgdal-dev \
    libgtk2.0-dev

# Video I/O:
RUN sudo apt install -y \
    libdc1394-22-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libtheora-dev \
    libvorbis-dev \
    libxvidcore-dev \
    libx264-dev \
    yasm \
    libopencore-amrnb-dev \
    libopencore-amrwb-dev \
    libv4l-dev \
    libxine2-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libopencv-highgui-dev \
    ffmpeg

# Parallelism and linear algebra libraries:
RUN sudo apt install -y \
    libtbb-dev \
    libeigen3-dev

# Python:
RUN sudo apt install -y \
    python3-dev \
    python3-tk \
    python3-numpy

# Build OpenCV
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
    unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip && \
    mv opencv-${OPENCV_VERSION} OpenCV && \
    cd OpenCV && \
    wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip && \
    unzip ${OPENCV_VERSION}.zip && \
    mkdir build && \
    cd build && \
    cmake \
      -D WITH_TBB=ON \
      -D CMAKE_BUILD_TYPE=RELEASE \
      -D BUILD_EXAMPLES=ON \
      -D WITH_FFMPEG=ON \
      -D WITH_V4L=ON \
      -D WITH_OPENGL=ON \
      -D WITH_CUDA=ON \
      -D CUDA_ARCH_BIN=${GPU_ARCH} \
      -D CUDA_ARCH_PTX=${GPU_ARCH} \
      -D WITH_CUBLAS=ON \
      -D WITH_CUFFT=ON \
      -D WITH_EIGEN=ON \
      -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
      -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib-${OPENCV_VERSION}/modules/ \
      .. && \
    make all -j$(nproc) && \
    make install