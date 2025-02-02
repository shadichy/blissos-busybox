#!/bin/bash

# Update packages
apt update && apt upgrade -y

# Install build tools
apt install -y debhelper build-essential grep mawk

source .env

# Check for cross-compile
if [ "$DEB_ARCH" != $(dpkg --print-architecture) ]; then
  dpkg --add-architecture "$DEB_ARCH"
  apt update
  apt install -y crossbuild-essential-$DEB_ARCH
  DEB_BUILD_OPTIONS="nocheck $DEB_BUILD_OPTIONS"
  DEB_BUILD_PROFILES="cross nocheck $DEB_BUILD_PROFILES"
  DEB_BUILD_ARGS="-a$DEB_ARCH $DEB_BUILD_ARGS"
  export CONFIG_SITE=/etc/dpkg-cross/cross-config.$DEB_ARCH
fi

dependencies=""
for p in $(dpkg-checkbuilddeps 2>&1 | grep 'Unmet build dependencies' | awk -F ':' '{print $4}'); do
  case "$p" in '('* | *')') ;; *) dependencies="$dependencies $p:$DEB_ARCH" ;; esac
done
yes | apt install -y $dependencies || :

export DEBEMAIL DEBFULLNAME DEB_BUILD_OPTIONS DEB_BUILD_PROFILES

if [ "$GPG_SECRET" ]; then
 echo "$GPG_SECRET" | gpg --import
else
  DEB_BUILD_ARGS="--no-sign $DEB_BUILD_ARGS"
fi

# Build binary package
dpkg-buildpackage $DEB_BUILD_ARGS
