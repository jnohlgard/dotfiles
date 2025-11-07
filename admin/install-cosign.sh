#!/usr/bin/sh
set -euf

repo_url="https://github.com/sigstore/cosign"
exe=cosign

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

. /etc/os-release

if [ "$(id -u)" -ne 0 ]; then
  curl -Lf --output-dir "${tmpdir}" --remote-name-all --parallel \
    "${release_url}/${exe}_checksums.txt"{.sigstore.json,} \
    "${release_url}/${exe}-linux-${altarch}"{-kms.sigstore.json,} \
    "${release_url}/release-cosign.pub"
  if command -v cosign > /dev/null 2>&1; then
    # Upgrading, use the old version to verify the new
    cosign verify-blob \
      --bundle "${tmpdir}/${exe}_checksums.txt.sigstore.json" \
      --certificate-identity "keyless@projectsigstore.iam.gserviceaccount.com" \
      --certificate-oidc-issuer "https://accounts.google.com" \
      "${tmpdir}/${exe}_checksums.txt"
    cosign verify-blob \
      --bundle "${tmpdir}/${exe}-linux-${altarch}-kms.sigstore.json" \
      --key "${tmpdir}/release-cosign.pub" \
      "${tmpdir}/${exe}-linux-${altarch}"
  fi
  ( cd "${tmpdir}" && ${sha256sum_cmd} --ignore-missing -c "${tmpdir}/${exe}_checksums.txt" )
  install_exe "${tmpdir}/${exe}-linux-${altarch}" "${exe}"
else
  if command -v cosign > /dev/null 2>&1; then
    installed_version=0
    case "${ID}" in
      "ubuntu"|"debian")
        installed_version="$(dpkg_version cosign)"
        ;;
      "fedora"|"redhat")
        installed_version="$(rpm_version cosign)"
        ;;
    esac
    if [ "${installed_version}" = "${version}" ]; then
      printf 'cosign %s is already installed.\n' "${installed_version}"
      exit 0
    fi
  fi

  : "${ID_LIKE:=${ID:-}}"

  case "${ID_LIKE}" in
    "fedora"|"redhat")
      dnf install "${release_url}/${exe}-${version}-1.${arch}.rpm"
      ;;
    "ubuntu"|"debian")
      tmpdir="$(mktemp -d -t download.XXXXXXXX)"
      curl -LOf --output-dir "${tmpdir}" "${release_url}/${exe}_${version}_${altarch}.deb"
      dpkg -i "${tmpdir}/${exe}_${version}_${altarch}.deb"
      rm -r -v "${tmpdir}"
      ;;
    "arch")
      pacman -S cosign
      ;;
    "alpine")
      apk add --no-cache cosign
      ;;
    *)
      die 'Unknown OS "%s"\n' "${ID_LIKE}"
      ;;
  esac
fi
