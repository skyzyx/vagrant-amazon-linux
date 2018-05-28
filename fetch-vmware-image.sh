#! /usr/bin/env bash

##
# Amazon provides a VMware ESX image of Amazon Linux 2. We need to convert this
# into the VMX format supported by VMware Fusion and Workstation.
#
# You need to have `ovftool` installed and on your $PATH.
# https://www.vmware.com/support/developer/ovf/
##

# Show Errors
set -euo pipefail

e() {
echo -e "  \e[1;32m[install] ==> $@\e[0m";
}

RELEASE=2017.12.0.20180509
FILENAME=amzn2-vmware_esx-${RELEASE}-x86_64.xfs.gpt.ova

if ! [ -x "$(command -v ovftool)" ]; then
    echo "\`ovftool\` is required in order to convert the image into a format compatible with VMware for desktops.";
    echo "Visit https://www.vmware.com/support/developer/ovf/ to download the tool.";
elif ! [ -x "$(command -v gpg)" ]; then
    echo "\`gpg\` is required in order to verify that the download is trusted.";
    echo "Visit https://github.com/skyzyx/gpg-quickstart to learn how to install GPG for your platform.";
elif ! [ -x "$(command -v openssl)" ]; then
    echo "\`openssl\` is required in order to complete the conversion for VMware for desktops.";
else
    mkdir -p ./packer_cache;

    e "Amazon Linux 2, release ${RELEASE}";
    echo " ";

    cd ./packer_cache/

    if ! [ -f amazon-gpg-key.asc ]; then
        e "Downloading and importing Amazon’s GPG signing key...";
        curl -L https://cdn.amazonlinux.com/_assets/11CF1F95C87F5B1A.asc -o amazon-gpg-key.asc;
        gpg --import amazon-gpg-key.asc;
    fi;

    if ! [ -f SHA256SUMS.gpg ]; then
        e "Downloading SHA256SUMS.gpg...";
        curl -LO https://cdn.amazonlinux.com/os-images/${RELEASE}/vmware/SHA256SUMS.gpg;
    fi;

    if ! [ -f ${FILENAME} ]; then
        e "Downloading Amazon Linux 2 image...";
        curl -LO https://cdn.amazonlinux.com/os-images/${RELEASE}/vmware/${FILENAME};
    fi;

    e "Verifying that SHA256SUMS was signed by the Amazon Linux GPG key...";
    if gpg --verify SHA256SUMS.gpg; then
        e "SHA256SUMS was signed by the Amazon Linux GPG key.";

        e "Verifying the SHASUM matches the binary...";
        if gpg --output SHA256SUMS --decrypt SHA256SUMS.gpg; then
            e "SHASUM matches the binary. The image is valid.";

            e "Using ovftool to convert .ova to .vmx...";
            ovftool --overwrite --allowExtraConfig ${FILENAME} "${FILENAME%.*}.ovf";
            sed -i "s/VirtualSCSI/lsilogic/" "${FILENAME%.*}.ovf";
            openssl sha1 "${FILENAME%.*}-disk1.vmdk" "${FILENAME%.*}.ovf" | tee "${FILENAME%.*}.mf";
            ovftool --targetType=VMX "${FILENAME%.*}.ovf" "amzn2.vagrant.vmx";
            mkdir -p "amzn2.vmwarevm";

            e "Cleaning up..."
            mv -v "amzn2.vagrant"* "amzn2.vmwarevm/";
            rm -f "${FILENAME%.*}"{-disk1.vmdk,.ovf,.mf};
        else
            e "SHASUM does NOT match the binary. Cowardly refusing to continue.";
        fi;
    else
        e "SHA256SUMS was NOT signed by the Amazon Linux GPG key. Cowardly refusing to continue.";
    fi;
fi;
