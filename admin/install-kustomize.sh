#!/usr/bin/sh
set -euf

repo_url="https://github.com/kubernetes-sigs/kustomize"
exe="kustomize"

case "$0" in
  */*)
    mydir="$(cd "${0%/*}" && pwd)"
    ;;
  *)
    mydir="$(cmd="$(command -v "$0")"; cd "${cmd%/*}" && pwd)"
    ;;
esac
. "${mydir}/common.inc.sh"

version_tag="$(github_latest_version "${repo_url}")"
release_url="${repo_url}/releases/download/${version_tag}"
version="${version_tag##*/}"

mkdir -p "${tmpdir}/_out"
curl -Lf --output-dir "${tmpdir}" --remote-name-all \
  "${release_url}/${exe}_${version}_linux_${altarch}.tar.gz" \
  "${release_url}/checksums.txt"
( cd "${tmpdir}" && \
  ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/checksums.txt" \
)
tar -axC "${tmpdir}" -f "${tmpdir}/${exe}_${version}_linux_${altarch}.tar.gz"

install_exe "${tmpdir}/${exe}" "${exe}"
