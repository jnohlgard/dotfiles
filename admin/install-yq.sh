#!/usr/bin/sh
set -euf

repo_url="https://github.com/mikefarah/yq"
exe="yq"

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
  "${release_url}/checksums" \
  "${release_url}/checksums_hashes_order" \
  "${release_url}/${exe}_linux_${altarch}"
lineno=0
# yq releases uses a merged checksums file where each column is a different kind of checksum
( cd "${tmpdir}"
  curl -sSfL "${release_url}/checksums_hashes_order" | while read -r line; do
    lineno=$((lineno + 1))
    case "${line}" in
      SHA-256)
        awk "{ printf \"%s *%s\\n\",\$$((lineno + 1)),\$1; }" < "${tmpdir}/checksums" | \
          ${sha256sum_cmd} --ignore-missing -c -
        ;;
      SHA-512)
        awk "{ printf \"%s *%s\\n\",\$$((lineno + 1)),\$1; }" < "${tmpdir}/checksums" | \
          ${sha512sum_cmd} --ignore-missing -c -
        ;;
    esac
  done
)

install_exe "${tmpdir}/${exe}_linux_${altarch}" "${exe}"
