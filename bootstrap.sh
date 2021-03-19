#!/usr/bin/env bash
set -e

SUDO=''
if (( $EUID != 0 )); then
    echo "Please be ready to enter the device´s sudo password:"
    SUDO='sudo -H'
fi

tmp_dir=$(mktemp -d -t sustayn-patch-002XXX)
pushd $tmp_dir
echo "Applying patch!"

$SUDO /usr/bin/python3 -m pip install https://github.com/teknoir/sustayn_os_patch_002/releases/download/patch002/timeloop-1.0.2.tar.gz --upgrade
$SUDO wget -O /usr/local/lib/keepup_wwan/keepup_wwan.py https://github.com/teknoir/sustayn_os_patch_002/releases/download/patch002/keepup_wwan.py
$SUDO systemctl restart keepup_wwan@wwan0.service

echo "Patch applied successfully!"
popd
rm -rf $tmp_dir
