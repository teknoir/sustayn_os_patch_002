# Patch 002
This patch add requested functionality, and more stability to the script that tries to keep wwan0(LTE) up.

Functionality:
 * Reboot after 60min when WiFi has been used(reboots every 60 min in WiFi regardless)

In the terminal(SSH) enter the following command to apply the patch:
```
bash <(curl -Ls https://raw.githubusercontent.com/teknoir/sustayn_os_patch_002/main/bootstrap.sh)
```

To see the new script working:
```
journalctl -b -f -u keepup_wwan@wwan0
```
