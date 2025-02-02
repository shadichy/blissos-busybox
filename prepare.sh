#!/bin/bash
# shellcheck disable=2086,2103,2164,2317

cd "$(dirname "$0")"

# avoid command failure
exit_check() { [ "$1" = 0 ] || exit "$1"; }
trap 'exit_check $?' EXIT

rawurlencode() {
  local string=$1
  local strlen=${#string}
  local encoded pos c o

  for ((pos = 0; pos < strlen; pos++)); do
    c=${string:$pos:1}
    case "$c" in
    [-_.~a-zA-Z0-9]) o="${c}" ;;
    *) printf -v o '%%%02x' "'$c" ;;
    esac
    encoded+="${o}"
  done
  echo "${encoded}"
}

_gitlab_upstream=https://salsa.debian.org
wget_dl() { wget "${_gitlab_upstream}/${1}" -o /dev/null -O -; }
curl_dl() { curl "${_gitlab_upstream}/${1}" 2>/dev/null; }

if command -v wget >/dev/null; then
  DOWNLOAD=wget_dl
else
  DOWNLOAD=curl_dl
fi

_latest_tag=$($DOWNLOAD "api/v4/projects/installer-team%2Fbusybox/repository/tags" | grep '"name":' | head -1 | awk -F '"' '{print $4}')
_branch=${_latest_tag%%/*}
_full_ver=${_latest_tag##*/}
_encoded_ver=$(rawurlencode "$_full_ver")

# Fetch source package
$DOWNLOAD "installer-team/busybox/-/archive/${_branch}/${_encoded_ver}/busybox-${_branch}-${_encoded_ver}.tar.gz" | tar -xzf -
cp -rn busybox-${_branch}-${_full_ver}/* .
rm -rf busybox-${_branch}-${_full_ver}

# Modify control file
control=debian/control.tmp
touch $control

IFS=$'\n'
while read -r line; do
  echo -e "$line" >>$control
  [ "$line" ] || break
done <${control%.tmp}
unset IFS

cat <<'EOF' >>$control
Package: busybox-aaropa
Architecture: any
Depends: ${misc:Depends}, ${shlibs:Depends}
Conflicts:
Replaces:
Description: Tiny utilities for small and embedded systems
 BusyBox combines tiny versions of many common UNIX utilities into a single
 small executable. It provides minimalist replacements for the most common
 utilities you would usually find on your desktop system (i.e., ls, cp, mv,
 mount, tar, etc.). The utilities in BusyBox generally have fewer options than
 their full-featured GNU cousins; however, the options that are included
 provide the expected functionality and behave very much like their GNU
 counterparts.
 .
 This package installs the BusyBox binary but does not install
 symlinks for any of the supported utilities. Some of the utilities
 can be used in the system by installing the busybox-syslogd,
 udhcpc or udhcpd packages.
 .
 This variant of busybox is only used in BlissOS initrd.img.
EOF

cp -f $control ${control%.tmp}

# Modify build rules
rules=debian/rules.tmp
touch $rules

IFS=$'\n'
while read -r line; do
  case "$line" in
  flavours\ =\ *) echo 'flavours = blissos' >>$rules ;;
  *test-deb*) echo -e "${line//test-deb/test-blissos}" >>$rules ;;
  execute_*) break ;;
  *) echo -e "$line" >>$rules ;;
  esac
done <${rules%.tmp}
unset IFS

cp -f $rules ${rules%.tmp}
