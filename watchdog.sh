#!/bin/bash

## Get current version.
##
GITHUB_VER=$(grep Version: usb.ids|cut -d':' -f2|sed 's/\ //g')

## Get upstream data + version.
##
curl -O http://www.linux-usb.org/usb.ids
UPSTREAM_VER=$(grep Version: usb.ids|cut -d':' -f2|sed 's/\ //g')

## Changes seen? Commit. Otherwise, say so.
##
if [[ "$GITHUB_VER" = "$UPSTREAM_VER" ]]; then
  echo "[INFO] No changes to USB ID Repository."
else
  git add usb.ids;
  REMOTE_REPO=$(git remote get-url --push origin|cut -d'@' -f2)
  git remote add delta https://${GH_TOKEN}@${REMOTE_REPO}
  git config user.name "Ismael Casimpan Jr."
  git config user.email "ismael.angelo@casimpan.com"
  git commit -m"$UPSTREAM_VER changes."
  git push -u delta master
fi
