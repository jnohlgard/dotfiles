#!/usr/bin/sh
set -euf

exe="argocd"
repo_url="https://github.com/argoproj/argo-cd"

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

curl -LfO --output-dir "${tmpdir}" --remote-name-all \
  "${release_url}/${exe}-linux-${altarch}" \
  "${release_url}/${exe}-cli.intoto.jsonl" \
  "${release_url}/cli_checksums.txt"

(cd "${tmpdir}" && ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/cli_checksums.txt")
slsa-verifier verify-artifact \
  "${tmpdir}/${exe}-linux-${altarch}" \
  --provenance-path "${tmpdir}/${exe}-cli.intoto.jsonl" \
  --source-uri "${repo_url#https://}" \
  --source-tag "v${version}"

install_exe "${tmpdir}/${exe}-linux-${altarch}" "${exe}"
