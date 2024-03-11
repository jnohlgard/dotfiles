#!/usr/bin/sh
set -euf

exe="flux"
repo_url="https://github.com/fluxcd/flux2"

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

oidc_regexp="${repo_url}"
oidc_issuer="https://token.actions.githubusercontent.com"

curl -LfO --output-dir "${tmpdir}" --remote-name-all \
  "${release_url}/${exe}_${version}_linux_${altarch}.tar.gz" \
  "${release_url}/${exe}_${version}_checksums.txt" \
  "${release_url}/${exe}_${version}_checksums.txt.pem" \
  "${release_url}/${exe}_${version}_checksums.txt.sig" \
  "${release_url}/provenance.intoto.jsonl"

cosign verify-blob "${tmpdir}/${exe}_${version}_checksums.txt" \
  --certificate "${tmpdir}/${exe}_${version}_checksums.txt.pem" \
  --signature "${tmpdir}/${exe}_${version}_checksums.txt.sig" \
  --certificate-identity-regexp="${oidc_regexp}" \
  --certificate-oidc-issuer="${oidc_issuer}"
(cd "${tmpdir}" && ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/${exe}_${version}_checksums.txt")
slsa-verifier verify-artifact \
  "${tmpdir}/${exe}_${version}_linux_${altarch}.tar.gz" \
  --provenance-path "${tmpdir}/provenance.intoto.jsonl" \
  --source-uri "${repo_url#https://}" \
  --source-tag "v${version}"
tar -axC "${tmpdir}" -f "${tmpdir}/${exe}_${version}_linux_${altarch}.tar.gz"

install_exe "${tmpdir}/${exe}"
