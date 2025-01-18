#!/bin/bash

cat <<EOF > metadata.yml
Name: $(head -1 debian/changelog | awk '{print $1}')
Version: $(head -1 debian/changelog | grep -Eo '[0-9]+(\.[0-9]+){2,}-[0-9]+')
Arch: $DEB_ARCH
Variants: $(grep 'Package:' debian/control | awk '{print $2}' | xargs)
EOF
