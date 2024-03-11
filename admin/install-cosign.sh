#!/usr/bin/sh
set -euf

repo_url="https://github.com/sigstore/cosign"

case "$0" in
  */*)
    mydir="$(cd "${0%/*}" && pwd)"
    ;;
  *)
    mydir="$(cmd="$(command -v "$0")"; cd "${cmd%/*}" && pwd)"
    ;;
esac
. "${mydir}/common.inc.sh"

version="$(github_latest_version "${repo_url}")"
release_url="${repo_url}/releases/download/${version}"
version="${version#v}"

. /etc/os-release

if command -v cosign > /dev/null 2>&1; then

  installed_version=0
  case "${ID}" in
    "ubuntu"|"debian")
      installed_version="$(dpkg_version cosign)"
      ;;
    "fedora"|"redhat")
      installed_version="$(rpm_version cosign)"
      ;;
  esac
  if [ "${installed_version}" = "${version}" ]; then
    printf 'cosign %s is already installed.\n' "${installed_version}"
    exit 0
  fi
fi

: "${ID_LIKE:=${ID:-}}"

case "${ID_LIKE}" in
  "fedora"|"redhat")
    dnf install "${release_url}/cosign-${version}-1.${arch}.rpm"
    ;;
  "ubuntu"|"debian")
    tmpdir="$(mktemp -d -t download.XXXXXXXX)"
    curl -LOf --output-dir "${tmpdir}" "${release_url}/cosign_${version}_${altarch}.deb"
    dpkg -i "${tmpdir}/cosign_${version}_${altarch}.deb"
    rm -r -v "${tmpdir}"
    ;;
  "arch")
    pacman -S cosign
    ;;
  "alpine")
    apk add --no-cache cosign
    ;;
  *)
    die 'Unknown OS "%s"\n' "${ID_LIKE}"
    ;;
esac
