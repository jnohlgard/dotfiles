#!/usr/bin/bash
set -euf

exe=hubble
repo_url="https://github.com/cilium/hubble"

case "$0" in
  */*)
    mydir="$(cd "${0%/*}" && pwd)"
    ;;
  *)
    mydir="$(cmd="$(command -v "$0")"; cd "${cmd%/*}" && pwd)"
    ;;
esac
. "${mydir}/common.inc.sh"

version=$(curl -s https://raw.githubusercontent.com/cilium/hubble/main/stable.txt)
release_url="${repo_url}/releases/download/${version}"

curl -Lf --output-dir "${tmpdir}" --remote-name-all \
  "${release_url}/${exe}-linux-${altarch}.tar.gz"{,.sha256sum}
( cd "${tmpdir}" && sha256sum --check "${exe}-linux-${altarch}.tar.gz.sha256sum" )

tar -axC "${tmpdir}" -f "${tmpdir}/${exe}-linux-${altarch}.tar.gz" "${exe}"
install_exe "${tmpdir}/${exe}"
