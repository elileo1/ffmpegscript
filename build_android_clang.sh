#!/bin/bash
set -x
# 目标Android版本
API=33
function build
{
  ./configure \
  --prefix=$OUTPUT \
  --target-os=android \
  --arch=$ARCH  \
  --cpu=$CPU \
  --disable-asm \
  --enable-neon \
  --enable-cross-compile \
  --enable-shared \
  --disable-static \
  --disable-doc \
  --disable-ffplay \
  --disable-ffprobe \
  --disable-symver \
  --disable-ffmpeg \
  --cc=$CC \
  --cxx=$CXX \
  --sysroot=$SYSROOT \
  --extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS" \

  make clean all
  # 这里是定义用几个CPU编译
  make -j8
  make install
}
ARCH=arm64
CPU=armv8-a
TOOL_CPU_NAME=aarch64
#so库输出目录
OUTPUT=/Users/elileo/Downloads/ffmpeg-7.0.1/android/$CPU
# NDK的路径，根据自己的NDK位置进行设置
NDK=/Users/elileo/Library/Android/sdk/ndk/27.0.11902837
# 编译工具链路径
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64
# 编译环境
SYSROOT=$TOOLCHAIN/sysroot

TOOL_PREFIX="$TOOLCHAIN/bin/$TOOL_CPU_NAME-linux-android"
 
CC="$TOOL_PREFIX$API-clang"
CXX="$TOOL_PREFIX$API-clang++"
OPTIMIZE_CFLAGS="-march=$CPU"
build

ARCH=arm
CPU=armv7-a
TOOL_CPU_NAME=arm-linux-androideabi
#so库输出目录
OUTPUT=/Users/elileo/Downloads/ffmpeg-7.0.1/android/$CPU
# NDK的路径，根据自己的NDK位置进行设置
NDK=/Users/elileo/Library/Android/sdk/ndk/27.0.11902837
# 编译工具链路径
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64
# 编译环境
SYSROOT=$TOOLCHAIN/sysroot

TOOL_PREFIX="$TOOLCHAIN/bin/$TOOL_CPU_NAME"
 
CC="$TOOL_PREFIX$API-clang"
CXX="$TOOL_PREFIX$API-clang++"
OPTIMIZE_CFLAGS="-march=$CPU -mfloat-abi=softfp -mfpu=vfpv3-d16"
build
