#!/usr/bin/sh
set -euf

repo_url="https://github.com/cloudnative-pg/cloudnative-pg"
exe="kubectl-cnpg"

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
  "${release_url}/cnpg-${version#v}-checksums.txt" \
  "${release_url}/${exe}_${version#v}_linux_${arch}.tar.gz"
( cd "${tmpdir}" && \
  ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/cnpg-${version#v}-checksums.txt" \
)
tar -axC "${tmpdir}" -f "${tmpdir}/${exe}_${version#v}_linux_${arch}.tar.gz" "${exe}"

install_exe "${tmpdir}/${exe}"
