#!/usr/bin/sh
set -euf

repo_url="https://github.com/getsops/sops"
exe="sops"

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
  "${release_url}/${exe}-${version}.linux.${altarch}" \
  "${release_url}/${exe}-${version}.checksums.txt" \
  "${release_url}/${exe}-${version}.checksums.pem" \
  "${release_url}/${exe}-${version}.checksums.sig" \
  "${release_url}/${exe}-${version}.intoto.jsonl"
cosign verify-blob "${tmpdir}/${exe}-${version}.checksums.txt" \
  --certificate "${tmpdir}/${exe}-${version}.checksums.pem" \
  --signature "${tmpdir}/${exe}-${version}.checksums.sig" \
  --certificate-identity-regexp="${oidc_regexp}" \
  --certificate-oidc-issuer="${oidc_issuer}"
(cd "${tmpdir}" && ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/${exe}-${version}.checksums.txt")
slsa-verifier verify-artifact \
  "${tmpdir}/${exe}-${version}.linux.${altarch}" \
  --provenance-path "${tmpdir}/${exe}-${version}.intoto.jsonl" \
  --source-uri "${repo_url#https://}" \
  --source-tag "${version}"

install_exe "${tmpdir}/${exe}-${version}.linux.${altarch}" "${exe}"
