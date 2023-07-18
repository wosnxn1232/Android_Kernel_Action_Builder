#!/bin/bash

LABEL="$1"; REF="$2"
. ./config.sh

# A Function to Send Posts to Telegram
telegram_message() {
	curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
        -d chat_id="${TG_CHAT_ID}" \
	-d parse_mode="HTML" \
	-d text="$1"
}

process_build () {
    # Used by compiler
    export CC_FOR_BUILD=clang
    export LOCALVERSION="-${FULLNAME}"
    # Remove defconfig localversion to prevent overriding
    sed -i -r "s/(CONFIG_LOCALVERSION=).*/\1/" "${KERNEL_DIR}/arch/arm64/configs/${DEFCONFIG}"

    make O=out ARCH=arm64 ${DEFCONFIG}
    make -j$(nproc --all) O=out \
        ARCH=arm64 \
      #  CC="${CLANG}" \
      #  CLANG_TRIPLE=aarch64-linux-gnu- \
        CROSS_COMPILE="${CROSS_COMPILE}" \
   #     CROSS_COMPILE_ARM32=arm-linux-androideabi- \
        KBUILD_COMPILER_STRING="$(${CLANG} --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')" \
    
    BUILD_SUCCESS=$?
    
    if [ ${BUILD_SUCCESS} -eq 0 ]; then
        mkdir -p "${ANYKERNEL_IMAGE_DIR}"
        cp -f "${KERNEL_DIR}/out/arch/arm64/boot/Image.gz-dtb" "${ANYKERNEL_IMAGE_DIR}/Image.gz-dtb"
        cd "${ANYKERNEL_DIR}"
        zip -r9 "${REPO_ROOT}/${FULLNAME}.zip" * -x README
        cd -
    fi
    
    rm -rf "${KERNEL_DIR}/out"
    rm "${ANYKERNEL_IMAGE_DIR}/Image.gz-dtb"
    return ${BUILD_SUCCESS}
}

cd "${KERNEL_DIR}"

# Ensure the kernel has a label
if [ -z "${LABEL}" ]; then
    LABEL="TESTBUILD-$(git rev-parse --short HEAD)"
fi
FULLNAME="${KERNEL_NAME}-${LABEL}"

# Send the Telegram Message

echo -e \
"
![ Infinix-X573 ](https://skyhuppa.files.wordpress.com/2023/07/infinix-x573.jpg?w=984)
📋 Kernel Builder

✔️ The Build has been Triggered!
🔥 Build-CI: Github Runner
📱 Device: Infinix-X573
🖥 Kernel Verssion: 3.18.X
🌲 Logs: <a href=\"https://github.com/skyhuppa/fox_build/actions/${GITHUB_BUILD_ID}\">Here</a>
" > tg.html

TG_TEXT=$(< tg.html)

telegram_message "${TG_TEXT}"
echo " "

echo "Building ${FULLNAME} ..."

process_build
BUILD_SUCCESS=$?

if [ ${BUILD_SUCCESS} -eq 0 ]; then
    echo "Done!"
    # Save for use by later build stages
    git log -1 > "${REPO_ROOT}/$(git rev-parse HEAD).txt"
    # Some stats
    ccache --show-stats
else
    echo "Error while building!"
fi

cd "${REPO_ROOT}"
exit ${BUILD_SUCCESS}
