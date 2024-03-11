#!/usr/bin/sh
set -euf

if command -v age > /dev/null 2>&1; then
  printf 'age is already installed.\n'
  exit 0
fi
. /etc/os-release

case "${ID}" in
  "fedora")
    dnf install age
    ;;
  "ubuntu"|"debian")
    apt install age
    ;;
  "arch")
    pacman -S age
    ;;
  "alpine")
    apk add --no-cache age
    ;;
esac

