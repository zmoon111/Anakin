#!/bin/bash
# This script shows how one can build a anakin for the <X86> platform
ANAKIN_ROOT="$( cd "$(dirname "$0")"/.. ; pwd -P)"
echo "-- Anakin root dir is: $ANAKIN_ROOT"

# Choose GPU architecture.
if [ "$1" == "sm50" ]; then
    NV_ARCH=50
else
    NV_ARCH=61
fi

# build the target into gpu_build.
BUILD_ROOT=$ANAKIN_ROOT/x86_sm$NV_ARCH\_build

mkdir -p $BUILD_ROOT
echo "-- Build anakin x86 into: $BUILD_ROOT"

# Now, actually build the gpu target.
echo "-- Building anakin ..."
cd $BUILD_ROOT

cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DUSE_ARM_PLACE=NO \
    -DUSE_GPU_PLACE=NO \
    -DUSE_NV_GPU=YES \
    -DUSE_AMD_GPU=NO \
    -DUSE_X86_PLACE=YES \
    -DBUILD_WITH_UNIT_TEST=YES \
    -DUSE_PYTHON=OFF \
    -DENABLE_DEBUG=NO \
    -DENABLE_VERBOSE_MSG=NO \
    -DDISABLE_ALL_WARNINGS=YES \
    -DENABLE_NOISY_WARNINGS=NO \
    -DUSE_OPENMP=YES \
    -DBUILD_SHARED=YES \
    -DBUILD_WITH_FRAMEWORK=NO \
    -DSELECTED_SASS_TARGET_ARCH="$NV_ARCH"

# build target lib or unit test.
if [ "$(uname)" = 'Darwin' ]; then
    make "-j$(sysctl -n hw.ncpu)" && make install
else
    make "-j$(nproc)"   && make install
fi

