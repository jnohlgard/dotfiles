#!/usr/bin/sh
set -euf

mydir="$(cd "$(dirname "$0")" && pwd)"

for tool in \
  yq \
  slsa-verifier \
  cosign \
  talosctl \
  kubectl \
  sops \
  flux \
  helm \
  cilium \
  hubble \
  kubeseal \
  pomerium-cli \
  step \
  netbird \
  ; do
  printf '\nInstalling %s\n' "${tool}"
  "${mydir}/install-${tool}.sh"
done
