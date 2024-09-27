#!/usr/bin/sh
set -euf

repo_url="https://github.com/siderolabs/talos"
exe="talosctl"

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
  "${release_url}/sha256sum.txt" \
  "${release_url}/sha512sum.txt" \
  "${release_url}/${exe}-linux-${altarch}"
( cd "${tmpdir}" && \
  ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/sha256sum.txt" && \
  ${sha512sum_cmd} --ignore-missing -c "${tmpdir}/sha512sum.txt" \
)

install_exe "${tmpdir}/${exe}-linux-${altarch}" "${exe}"
