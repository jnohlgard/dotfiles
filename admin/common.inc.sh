#!/usr/bin/sh

die () {
  if [ $# -gt 0 ]; then
    >&2 printf "$@"
  fi
  exit 1
}

github_latest_version () {
  [ $# -eq 1 ] || die 'usage: github_latest_version <repo_url>\n'
  local latest_release_url="$(curl -s -w '%{redirect_url}' -I -o /dev/null "${1}/releases/latest")"
  printf '%s' "${latest_release_url##*/releases/tag/}"
}

get_altarch () {
  [ $# -eq 1 ] || die 'usage: get_altarch <arch>\n'
  local altarch
  case "$1" in
    "arm64")
      altarch="aarch64"
      ;;
    "x86_64")
      altarch="amd64"
      ;;
    *)
      altarch="$1"
      ;;
  esac
  printf '%s' "${altarch}"
}

install_exe() {
  [ $# -eq 1 ] || [ $# -eq 2 ] || die 'usage: install_exe <src> [exe]\n'
  local src="$1";shift
  local exe
  if [ $# -gt 0 ]; then
    exe="$1";shift
  else
    exe="${src##*/}"
  fi

  local dest_dir
  if [ -w "/usr/local/bin" ]; then
    dest_dir="/usr/local/bin"
  else
    dest_dir="${HOME:-/home/${USER:-unknown_user}}/.local/bin"
    install -v -d "${dest_dir}"
  fi
  local dest="${dest_dir}/${exe}"
  install -v -m 0755 "${src}" "${dest}"
  printf '\n%s %s installed as %s\n\n' "${src##*/}" "${version:-}" "${dest}"
}

dpkg_version () {
  [ $# -eq 1 ] || die 'usage: dpkg_version <package>\n'
  dpkg-query -f='${Version}' -W "$1"
}

rpm_version () {
  [ $# -eq 1 ] || die 'usage: rpm_version <package>\n'
  rpm -q --qf '%{VERSION}' "$1"
}

arch="$(uname -m)"
altarch="$(get_altarch "${arch}")"

if command -v sha256sum > /dev/null 2>&1; then
  sha256sum_cmd="sha256sum"
elif command -v shasum > /dev/null 2>&1; then
  sha256sum_cmd="shasum -a 256"
fi
if command -v sha512sum > /dev/null 2>&1; then
  sha512sum_cmd="sha512sum"
elif command -v shasum > /dev/null 2>&1; then
  sha512sum_cmd="shasum -a 512"
fi

tmpdir="$(mktemp -d -t download.XXXXXXXX)"
trap "rm -r -- '${tmpdir}'" EXIT
