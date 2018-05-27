#! /usr/bin/env bash

##
# Amazon provides a VMware ESX image of Amazon Linux 2. We need to convert this
# into the VMX format supported by VMware Fusion and Workstation.
#
# You need to have `ovftool` installed and on your $PATH.
# https://www.vmware.com/support/developer/ovf/
##

if ! [ -x "$(command -v ovftool)" ]; then
	echo "\`ovftool\` is required in order to convert the image into a format compatible with VMware for desktops.";
	echo "Visit https://www.vmware.com/support/developer/ovf/ to download the tool.";
else
	mkdir -p ./packer_cache;
fi;
