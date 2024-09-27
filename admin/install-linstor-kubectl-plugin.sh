#!/usr/bin/sh
set -euf

repo_url="https://github.com/piraeusdatastore/kubectl-linstor"
exe="kubectl-linstor"

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

curl -Lf --output-dir "${tmpdir}" --remote-name-all \
  "${release_url}/${exe}_${version#v}_checksums.txt" \
  "${release_url}/${exe}_${version}_linux_${altarch}.tar.gz"
( cd "${tmpdir}" && \
  ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/${exe}_${version#v}_checksums.txt" \
)
tar -axC "${tmpdir}" -f "${tmpdir}/${exe}_${version}_linux_${altarch}.tar.gz" "${exe}"

install_exe "${tmpdir}/${exe}"
