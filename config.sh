#!/bin/bash

export REPO_ROOT=`pwd`

# Paths
export CLANG="${REPO_ROOT}/data/clang/bin/clang"
export CROSS_COMPILE="${REPO_ROOT}/data/gcc/bin/aarch64-linux-android-"
export ANYKERNEL_DIR="${REPO_ROOT}/data/anykernel"
export ANYKERNEL_IMAGE_DIR="${ANYKERNEL_DIR}"
export KERNEL_DIR="${REPO_ROOT}/data/kernel"

# Define to enable ccache
if [ ! -z ${AKCI_CCACHE} ]; then
    export CLANG="ccache ${CLANG}"
    mkdir -p "ccache"
    export CCACHE_BASEDIR="${REPO_ROOT}"
    export CCACHE_DIR="${REPO_ROOT}/ccache"
    export CCACHE_COMPILERCHECK="content"
fi

# If not defined gives long compiler name
export COMPILER_NAME="GCC"

# Kernel config
 export DEFCONFIG="infinix_X573_defconfig"
 export KERNEL_NAME="Infinix-X573-Kernel"
# export DEFCONFIG="nabu_stability_defconfig"
# export KERNEL_NAME="nabu"
# export DEFCONFIG="lineageos_land_defconfig"
# export KERNEL_NAME="land-Kernel"

export KBUILD_BUILD_USER="skyhuppa"
export KBUILD_BUILD_HOST="github_runner"
export KBUILD_BUILD_VERSION=1.0
