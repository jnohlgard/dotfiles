#!/usr/bin/sh
set -euf

exe="step"
repo_url="https://github.com/smallstep/cli"

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

oidc_regexp='https://github\.com/smallstep/workflows/.*'
oidc_issuer="https://token.actions.githubusercontent.com"

curl -LfO --output-dir "${tmpdir}" --remote-name-all \
  "${release_url}/checksums.txt"{,.pem,.sig} \
  "${release_url}/${exe}_linux_${version}_${altarch}.tar.gz"{.pem,.sig,} \

cosign verify-blob "${tmpdir}/checksums.txt" \
  --certificate "${tmpdir}/checksums.txt.pem" \
  --signature "${tmpdir}/checksums.txt.sig" \
  --certificate-identity-regexp="${oidc_regexp}" \
  --certificate-oidc-issuer="${oidc_issuer}"
cosign verify-blob "${tmpdir}/${exe}_linux_${version}_${altarch}.tar.gz" \
  --certificate "${tmpdir}/${exe}_linux_${version}_${altarch}.tar.gz.pem" \
  --signature "${tmpdir}/${exe}_linux_${version}_${altarch}.tar.gz.sig" \
  --certificate-identity-regexp="${oidc_regexp}" \
  --certificate-oidc-issuer="${oidc_issuer}"
(cd "${tmpdir}" && ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/checksums.txt")
tar -axC "${tmpdir}" -f "${tmpdir}/${exe}_linux_${version}_${altarch}.tar.gz"

install_exe "${tmpdir}/${exe}_${version}/bin/${exe}"
