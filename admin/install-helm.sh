#!/usr/bin/sh
set -euf

repo_url="https://github.com/helm/helm"
exe="helm"

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
download_url="https://get.helm.sh"

curl -Lf --output-dir "${tmpdir}" --remote-name-all \
  "${release_url}/${exe}-${version}-linux-${altarch}.tar.gz.asc" \
  "${release_url}/${exe}-${version}-linux-${altarch}.tar.gz.sha256sum.asc" \
  "${download_url}/${exe}-${version}-linux-${altarch}.tar.gz.sha256sum" \
  "${download_url}/${exe}-${version}-linux-${altarch}.tar.gz"

# curl https://keybase.io/mattfarina/pgp_keys.asc | gpg --import
gpg --verify "${tmpdir}/${exe}-${version}-linux-${altarch}.tar.gz.sha256sum.asc" \
  "${tmpdir}/${exe}-${version}-linux-${altarch}.tar.gz.sha256sum"

(cd "${tmpdir}" && ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/${exe}-${version}-linux-${altarch}.tar.gz.sha256sum")

gpg --verify "${tmpdir}/${exe}-${version}-linux-${altarch}.tar.gz.asc" \
  "${tmpdir}/${exe}-${version}-linux-${altarch}.tar.gz"

tar -axC "${tmpdir}" -f "${tmpdir}/${exe}-${version}-linux-${altarch}.tar.gz"

install_exe "${tmpdir}/linux-${altarch}/${exe}"
