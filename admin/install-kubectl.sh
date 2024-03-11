#!/usr/bin/sh
set -euf

if command -v kubectl > /dev/null 2>&1; then
  printf 'kubectl is already installed.\n'
  exit 0
fi

. /etc/os-release

version="v1.29"
base_url="https://pkgs.k8s.io/core:/stable:/${version}"

case "${ID}" in
  "fedora")
    cat <<-EOF > /etc/yum.repos.d/kubernetes.repo
	[kubernetes]
	name=Kubernetes
	baseurl=${base_url}/rpm/
	enabled=1
	gpgcheck=1
	gpgkey=${base_url}/rpm/repodata/repomd.xml.key
	EOF
    dnf install kubectl
    ;;
  "ubuntu"|"debian")
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl
    curl -fsSL "${base_url}/deb/Release.key" | \
      gpg --dearmor \
        -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    printf 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/%s/deb/ /' "${version}" > "/etc/apt/sources.list.d/kubernetes.list"
    apt-get update
    apt-get install kubectl
    ;;
  "arch")
    pacman -S kubectl
    ;;
  "alpine")
    apk add --no-cache kubectl
    ;;
esac

