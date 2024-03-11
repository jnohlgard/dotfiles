#!/usr/bin/sh
set -euf

repo_url="https://github.com/bitnami-labs/sealed-secrets"
exe="kubeseal"

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

curl -Lf --remote-name-all --output-dir "${tmpdir}" \
  "${release_url}/kubeseal-${version}-linux-${altarch}.tar.gz.sig" \
  "${release_url}/kubeseal-${version}-linux-${altarch}.tar.gz" \
  "${release_url}/cosign.pub"
cosign verify-blob \
  --signature "${tmpdir}/kubeseal-${version}-linux-${altarch}.tar.gz.sig" \
  --key "${tmpdir}/cosign.pub" \
  "${tmpdir}/kubeseal-${version}-linux-${altarch}.tar.gz"

tar -axC "${tmpdir}" -f "${tmpdir}/kubeseal-${version}-linux-${altarch}.tar.gz"

install_exe "${tmpdir}/${exe}"
