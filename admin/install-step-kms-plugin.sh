#!/usr/bin/sh
set -euf

exe="step-kms-plugin"
repo_url="https://github.com/smallstep/step-kms-plugin"

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
  "${release_url}/checksums.txt" \
  "${release_url}/${exe}_${version}_linux_${altarch}.sbom.json" \
  "${release_url}/${exe}_${version}_linux_${altarch}.tar.gz" \
  ;

(cd "${tmpdir}" && ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/checksums.txt")
tar -axC "${tmpdir}" -f "${tmpdir}/${exe}_${version}_linux_${altarch}.tar.gz"

install_exe "${tmpdir}/${exe}_${version}/${exe}"
