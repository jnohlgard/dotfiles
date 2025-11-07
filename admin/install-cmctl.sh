#!/usr/bin/sh
set -euf

repo_url="https://github.com/cert-manager/cmctl"
exe="cmctl"

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

oidc_regexp="${repo_url}"
oidc_issuer="https://token.actions.githubusercontent.com"

curl -LfO --output-dir "${tmpdir}" --remote-name-all \
  "${release_url}/${exe}_linux_${altarch}" \
  "${release_url}/checksums.txt" \
  "${release_url}/checksums.txt.cosign.bundle"
cosign verify-blob "${tmpdir}/checksums.txt" \
  --bundle "${tmpdir}/checksums.txt.cosign.bundle" \
  --certificate-identity-regexp="${oidc_regexp}" \
  --certificate-oidc-issuer="${oidc_issuer}"
(cd "${tmpdir}" && ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/checksums.txt")

install_exe "${tmpdir}/${exe}_linux_${altarch}" "${exe}"
