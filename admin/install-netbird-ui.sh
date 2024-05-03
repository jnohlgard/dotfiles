#!/usr/bin/sh
set -euf

repo_url="https://github.com/netbirdio/netbird"
exe="netbird-ui"

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

curl -Lf --output-dir "${tmpdir}" --remote-name-all \
  "${release_url}/${exe}_${version}_checksums.txt" \
  "${release_url}/${exe}-linux_${version}_linux_${altarch}.tar.gz"
( cd "${tmpdir}" && ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/${exe}_${version}_checksums.txt" )
tar -axC "${tmpdir}" -f "${tmpdir}/${exe}-linux_${version}_linux_${altarch}.tar.gz"

install_exe "${tmpdir}/${exe}"
