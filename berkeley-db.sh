#!/bin/bash

# compile Barkeley DB 4.8

cd $TRAVIS_BUILD_DIR
wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
tar -xzvf db-4.8.30.NC.tar.gz
cd $WORKDIR/db-4.8.30.NC
  
MXE_PATH=$WORKDIR/mxe
sed -i "s/WinIoCtl.h/winioctl.h/g" src/dbinc/win_db.h
mkdir build_mxe
cd build_mxe

CC=$MXE_PATH/usr/bin/i686-w64-mingw32.static-gcc \
CXX=$MXE_PATH/usr/bin/i686-w64-mingw32.static-g++ \
../dist/configure \
	--disable-replication \
	--enable-mingw \
	--enable-cxx \
	--host x86 \
	--prefix=$MXE_PATH/usr/i686-w64-mingw32.static

make -j8

make install
