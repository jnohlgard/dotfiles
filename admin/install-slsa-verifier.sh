#!/usr/bin/sh
set -euf

exe="slsa-verifier"
repo_url="https://github.com/slsa-framework/slsa-verifier"

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
  "${release_url}/${exe}-linux-${altarch}"
(cd "${tmpdir}" && curl -sLf "https://raw.githubusercontent.com/slsa-framework/slsa-verifier/main/SHA256SUM.md" | head | ${sha256sum_cmd} --ignore-missing -c -)

install_exe "${tmpdir}/${exe}-linux-${altarch}" "${exe}"
