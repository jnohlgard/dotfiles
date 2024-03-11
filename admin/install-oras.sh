#!/usr/bin/sh
set -euf

repo_url="https://github.com/oras-project/oras"
exe="oras"

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

# curl -sfSL https://github.com/qweeah.gpg | gpg --import -
curl -Lf --output-dir "${tmpdir}" --remote-name-all \
  "${release_url}/${exe}_${version}_checksums.txt.asc" \
  "${release_url}/${exe}_${version}_checksums.txt"
gpg --verify "${tmpdir}/${exe}_${version}_checksums.txt.asc" "${tmpdir}/${exe}_${version}_checksums.txt"
curl -Lf --output-dir "${tmpdir}" --remote-name-all \
  "${release_url}/${exe}_${version}_linux_${altarch}.tar.gz.asc" \
  "${release_url}/${exe}_${version}_linux_${altarch}.tar.gz"
(cd "${tmpdir}" && ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/${exe}_${version}_checksums.txt")
gpg --verify "${tmpdir}/${exe}_${version}_linux_${altarch}.tar.gz.asc" "${tmpdir}/${exe}_${version}_linux_${altarch}.tar.gz"

install_exe "${tmpdir}/${exe}"
