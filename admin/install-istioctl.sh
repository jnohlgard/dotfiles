#!/usr/bin/sh
set -euf

repo_url="https://github.com/istio/istio"
exe="istioctl"

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

curl -Lf --output-dir "${tmpdir}" --remote-name-all \
  "${release_url}/${exe}-${version}-linux-${altarch}.tar.gz"{,.sha256}
( cd "${tmpdir}" && ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/${exe}-${version}-linux-${altarch}.tar.gz.sha256" )
tar -axvC "${tmpdir}" -f "${tmpdir}/${exe}-${version}-linux-${altarch}.tar.gz"

install_exe "${tmpdir}/${exe}"
