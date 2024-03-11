#!/usr/bin/sh
set -euf

repo_url="https://github.com/pomerium/cli"
exe="pomerium-cli"

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

mkdir -p "${tmpdir}/_out"
curl -Lf --output-dir "${tmpdir}" --remote-name-all \
  "${release_url}/${exe}-linux-${altarch}.tar.gz" \
  "${release_url}/${exe}_checksums.txt"
( cd "${tmpdir}" && \
  ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/${exe}_checksums.txt" \
)
tar -axC "${tmpdir}" -f "${tmpdir}/${exe}-linux-${altarch}.tar.gz"

install_exe "${tmpdir}/${exe}" "${exe}"
