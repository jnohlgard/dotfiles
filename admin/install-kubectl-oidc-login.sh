#!/usr/bin/sh
set -euf

repo_url="https://github.com/int128/kubelogin"
exe="kubelogin"

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
  "${release_url}/${exe}_linux_${altarch}.zip"{,.sha256}
( cd "${tmpdir}" && ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/${exe}_linux_${altarch}.zip.sha256" )
unzip -d "${tmpdir}" -j "${tmpdir}/${exe}_linux_${altarch}.zip"

install_exe "${tmpdir}/${exe}" 'kubectl-oidc_login'
