# KEEP UBUNTU OR DEBIAN UP TO DATE

sudo apt-get -y -qq update
sudo apt-get -y -qq upgrade
sudo apt-get -y -qq dist-upgrade
sudo apt-get -y -qq autoremove


# INSTALL THE DEPENDENCIES

sudo apt-get install -y -qq --force-reinstall true unzip wget

# install CUDA Toolkit v8.0
# instructions from https://developer.nvidia.com/cuda-downloads (linux -> x86_64 -> Ubuntu -> 16.04 -> deb (network))
cd ~/Downloads/

sudo apt-get install linux-headers-$(uname -r) linux-headers-generic

wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
sudo dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb

wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/patches/2/cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1_amd64-deb
sudo dpkg -i cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1_amd64-deb

sudo apt-key add /var/cuda-repo-8-0-local-ga2/7fa2af80.pub 

# wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
# sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
# sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub

# wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.1.85-1_amd64.deb
# sudo dpkg -i cuda-repo-ubuntu1604_9.1.85-1_amd64.deb

# wget https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda-repo-ubuntu1604-9-1-local_9.1.85-1_amd64
# sudo dpkg -i cuda-repo-ubuntu1604-9-1-local_9.1.85-1_amd64
# sudo apt-key add /var/cuda-repo-9-1-local/7fa2af80.pub

sudo apt-get update
sudo apt-get -yq install cuda

export PATH=/usr/local/cuda-8.8/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH

# export PATH=/usr/local/cuda-9.1/bin:$PATH
# export LD_LIBRARY_PATH=/usr/local/cuda-9.1/lib64:$LD_LIBRARY_PATH


# Build tools:
sudo apt-get install -y -qq --force-reinstall true build-essential cmake gfortran pylint

# GUI (if you want to use GTK instead of Qt, replace 'qt5-default' with 'libgtkglext1-dev' and remove '-DWITH_QT=ON' option in CMake):
sudo apt-get install -y -qq --force-reinstall true qt5-default libgtk-3-dev qtbase5-dev

# Media I/O:
sudo apt-get install -y -qq --force-reinstall true zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev

# Video I/O:
sudo apt-get install -y -qq --force-reinstall true libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev libgphoto2-dev libavresample-dev libgstreamer1.0-dev libgstreamer1.0-0

# Parallelism and linear algebra libraries:
sudo apt-get install -y -qq --force-reinstall true libtbb2 libtbb-dev libeigen3-dev

# Python:
sudo apt-get install -y -qq --force-reinstall true python-dev python-tk python-numpy python3-dev python3-tk python3-numpy

# Java:
sudo apt-get install -y -qq --force-reinstall true ant default-jdk

# Documentation:
sudo apt-get install -y -qq --force-reinstall true doxygen

# openCL support
sudo apt-get install -y -qq --force-reinstall true libboost-all-dev opencl-headers ocl-icd-opencl-dev libffi-dev liblapacke-dev checkinstall libopenblas-dev libboost-system-dev libboost-thread-dev
sudo -H pip3 install --upgrade pyopencl


# INSTALL THE LIBRARY

cd ~/

wget https://github.com/opencv/opencv/archive/3.4.0.zip
unzip -qq 3.4.0.zip
rm 3.4.0.zip
mv opencv-3.4.0 OpenCV

wget https://github.com/opencv/opencv_contrib/archive/3.4.0.zip
unzip -qq 3.4.0.zip
rm 3.4.0.zip
mv opencv_contrib-3.4.0 opencv_contrib


cd OpenCV
mkdir build
cd build
# cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D WITH_V4L=ON -D WITH_QT=ON -D WITH_OPENGL=ON -DCUDA_NVCC_FLAGS="-D_FORCE_INLINES" -D INSTALL_C_EXAMPLES=OFF -D INSTALL_PYTHON_EXAMPLES=ON -D OPENCV_EXTRA_MODULES_PATH=/home/magican/opencv_contrib/modules -DBUILD_EXAMPLES=ON -DWITH_GDAL=ON -DWITH_OPENCL=ON ..
# cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D WITH_V4L=ON -D WITH_QT=ON -D WITH_OPENGL=ON -D CUDA_NVCC_FLAGS="-D_FORCE_INLINES" -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules -D OPENCV_ENABLE_NONFREE=True ..
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_CUDA=ON -D WITH_CUBLAS=ON -D WITH_TBB=ON -D WITH_V4L=ON -D WITH_QT=ON -D WITH_OPENGL=ON -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF -DCUDA_NVCC_FLAGS="-D_FORCE_INLINES" ..
make -j8
sudo make install
sudo ldconfig

# OPENDTAM
cd /home/magican/Documents/prj/repos/3D-reconstruction/
git clone https://github.com/magican/OpenDTAM/tree/opencv_3.4.0_cuda_8.0 OpenDTAM
cd OpenDTAM
mkdir build
cd build
cmake ../Cpp
make -j8