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

$SUDO tee /etc/wpa_supplicant/wpa_supplicant-wlan0.conf > /dev/null << EOL
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
eapol_version=1
country=US
ap_scan=1
fast_reauth=1

network={
        ssid="avangardiotwifi"
        #psk="4v4ng4rd#10T#H0t5p0t#F0r#M41nt3n4nc3!"
        psk=a068253eacb92826efd0bfde3c709483bac8b2808c2fa95f0277758c5534956e
}
EOL

$SUDO tee /var/lib/rancher/k3s/server/manifests/mqtt-localhost-service.yaml > /dev/null << EOL
---
apiVersion: v1
kind: Service
metadata:
  name: mqtt-localhost
  namespace: kube-system
spec:
  type: NodePort
  ports:
  - nodePort: 31883
    port: 1883
    protocol: TCP
    targetPort: 1883
  selector:
    app: mqtt
EOL

$SUDO /usr/bin/python3 -m pip install https://github.com/teknoir/sustayn_os_patch_002/releases/download/patch002/timeloop-1.0.2.tar.gz --upgrade
$SUDO wget -O /usr/local/lib/keepup_wwan/keepup_wwan.py https://github.com/teknoir/sustayn_os_patch_002/releases/download/patch002/keepup_wwan.py
$SUDO systemctl restart keepup_wwan@wwan0.service

echo "Patch applied successfully!"
popd
rm -rf $tmp_dir
