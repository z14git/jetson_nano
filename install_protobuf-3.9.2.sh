#!/bin/bash

set -e

folder=${HOME}/src
mkdir -p $folder

echo "** Download protobuf-3.9.2 sources"
cd $folder
if [ ! -f protobuf-python-3.9.2.zip ]; then
  proxychains wget https://github.com/protocolbuffers/protobuf/releases/download/v3.9.2/protobuf-python-3.9.2.zip
fi
if [ ! -f protoc-3.9.2-linux-aarch_64.zip ]; then
  proxychains wget https://github.com/protocolbuffers/protobuf/releases/download/v3.9.2/protoc-3.9.2-linux-aarch_64.zip
fi

echo "** Install protoc"
unzip protobuf-python-3.9.2.zip
unzip protoc-3.9.2-linux-aarch_64.zip -d protoc-3.9.2
sudo cp protoc-3.9.2/bin/protoc /usr/local/bin/protoc

echo "** Build and install protobuf-3.9.2 libraries"
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=cpp
cd protobuf-3.9.2/
./autogen.sh
./configure --prefix=/usr/local
make
make check
sudo make install
sudo ldconfig

echo "** Update python3 protobuf module"
# remove previous installation of python3 protobuf module
sudo pip3 uninstall -y protobuf
sudo pip3 install Cython
cd python/
python3 setup.py build --cpp_implementation
python3 setup.py test --cpp_implementation
sudo python3 setup.py install --cpp_implementation

echo "** Build protobuf-3.9.2 successfully"
