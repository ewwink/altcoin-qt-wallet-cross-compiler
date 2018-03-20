#!/usr/bin/env sh

sudo cd "$WORKDIR" || echo "eerrrrrorrr"; exit
# sudo apt-get update -qq -y
sudo apt-get install p7zip-full autoconf automake autopoint bash bison bzip2 cmake flex gettext git g++ gperf intltool libffi-dev libtool libltdl-dev libssl-dev libxml-parser-perl sudo make openssl patch perl pkg-config python ruby scons sed unzip wget xz-utils
apt-get install g++-multilib libc6-dev-i386
  
# Compile MXE
git clone https://github.com/mxe/mxe.git
echo "$WORKDIR"

cd "$WORKDIR"/mxe
make MXE_TARGETS="i686-w64-mingw32.static" boost
make MXE_TARGETS="i686-w64-mingw32.static" qttools

# compile Barkeley DB 4.8

cd "$WORKDIR"
wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
tar -xzvf db-4.8.30.NC.tar.gz
cd "$WORKDIR"/db-4.8.30.NC
  
MXE_PATH="$WORKDIR"/mxe
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

# compile miniupnp

cd "$WORKDIR"
wget http://miniupnp.free.fr/files/miniupnpc-1.6.20120509.tar.gz
tar zxvf miniupnpc-1.6.20120509.tar.gz
cd "$WORKDIR"/miniupnpc-1.6.20120509

MXE_PATH="$WORKDIR"/mxe

CC=$MXE_PATH/usr/bin/i686-w64-mingw32.static-gcc \
AR=$MXE_PATH/usr/bin/i686-w64-mingw32.static-ar \
CFLAGS="-DSTATICLIB -I$MXE_PATH/usr/i686-w64-mingw32.static/include" \
LDFLAGS="-L$MXE_PATH/usr/i686-w64-mingw32.static/lib" \
make libminiupnpc.a

mkdir $MXE_PATH/usr/i686-w64-mingw32.static/include/miniupnpc
cp *.h $MXE_PATH/usr/i686-w64-mingw32.static/include/miniupnpc
cp libminiupnpc.a $MXE_PATH/usr/i686-w64-mingw32.static/lib

# Compile MXE
cd "$WORKDIR" || echo "cd failed"; exit
git clone https://github.com/mxe/mxe.git
echo "$WORKDIR"

cd "$WORKDIR"/mxe
make MXE_TARGETS="i686-w64-mingw32.static" boost
make MXE_TARGETS="i686-w64-mingw32.static" qttools

# compile Barkeley DB 4.8

cd "$WORKDIR"
wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
tar -xzvf db-4.8.30.NC.tar.gz
cd "$WORKDIR"/db-4.8.30.NC
  
MXE_PATH="$WORKDIR"/mxe
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

# compile miniupnp

cd "$WORKDIR"
wget http://miniupnp.free.fr/files/miniupnpc-1.6.20120509.tar.gz
tar zxvf miniupnpc-1.6.20120509.tar.gz
cd "$WORKDIR"/miniupnpc-1.6.20120509

MXE_PATH="$WORKDIR"/mxe

CC=$MXE_PATH/usr/bin/i686-w64-mingw32.static-gcc \
AR=$MXE_PATH/usr/bin/i686-w64-mingw32.static-ar \
CFLAGS="-DSTATICLIB -I$MXE_PATH/usr/i686-w64-mingw32.static/include" \
LDFLAGS="-L$MXE_PATH/usr/i686-w64-mingw32.static/lib" \
make libminiupnpc.a

mkdir $MXE_PATH/usr/i686-w64-mingw32.static/include/miniupnpc
cp *.h $MXE_PATH/usr/i686-w64-mingw32.static/include/miniupnpc
cp libminiupnpc.a $MXE_PATH/usr/i686-w64-mingw32.static/lib

#Compile Alcoin QT Wallet
cd "$WORKDIR" || echo "cd failed"; exit

git clone "$COIN_SRC"

cd ""$WORKDIR""/"$COIN_NAME"

MXE_INCLUDE_PATH="$WORKDIR"/mxe/usr/i686-w64-mingw32.static/include
MXE_LIB_PATH="$WORKDIR"/mxe/usr/i686-w64-mingw32.static/lib

i686-w64-mingw32.static-qmake-qt5 \
	BOOST_LIB_SUFFIX=-mt \
	BOOST_THREAD_LIB_SUFFIX=_win32-mt \
	BOOST_INCLUDE_PATH=$MXE_INCLUDE_PATH/boost \
	BOOST_LIB_PATH=$MXE_LIB_PATH \
	OPENSSL_INCLUDE_PATH=$MXE_INCLUDE_PATH/openssl \
	OPENSSL_LIB_PATH=$MXE_LIB_PATH \
	BDB_INCLUDE_PATH=$MXE_INCLUDE_PATH \
	BDB_LIB_PATH=$MXE_LIB_PATH \
	MINIUPNPC_INCLUDE_PATH=$MXE_INCLUDE_PATH \
	MINIUPNPC_LIB_PATH=$MXE_LIB_PATH \
	QMAKE_LRELEASE="$WORKDIR"/mxe/usr/i686-w64-mingw32.static/qt5/bin/lrelease "$COIN_NAME"-qt.pro

make -f Makefile.Release

# Our altcoin-qt.exe placed in "$WORKDIR"/COIN_NAME/release