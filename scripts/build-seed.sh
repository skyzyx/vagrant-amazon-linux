#! /usr/bin/env bash

# Show Errors
set -euxo pipefail

ROOTDIR=$(dirname $(dirname "$(readlink -f "$0")"))
CLOUDINIT_DIR="$ROOTDIR/cloudinit"
PACKER_CACHE="$ROOTDIR/packer_cache"
VMWARE_VM=$(find $PACKER_CACHE -type d -name "*.vmwarevm")

if [ -x "$(command -v genisoimage)" ]; then
    genisoimage -output "$VMWARE_VM/seed.iso" -volid cidata -joliet -rock "$CLOUDINIT_DIR/user-data" "$CLOUDINIT_DIR/meta-data"
elif [ -x "$(command -v mkisofs)" ]; then
    mkisofs -output "$VMWARE_VM/seed.iso" -volid cidata -joliet -rock "$CLOUDINIT_DIR/user-data" "$CLOUDINIT_DIR/meta-data"
else
    echo "Neither \`genisoimage\` nor \`mkisofs\` could be found."
fi;
