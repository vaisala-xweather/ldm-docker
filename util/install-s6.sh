#!/bin/bash
set -eo pipefail

S6_OVERLAY_VERSION="${1}"
if [[ -z "${S6_OVERLAY_VERSION}" ]]; then
	echo "Usage: $(basename "$0") <s6-overlay version>" >&2
	exit 1
fi

curl -fsSL -o /tmp/s6-overlay-noarch.tar.xz \
	"https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz"
curl -fsSL -o /tmp/s6-overlay-x86_64.tar.xz \
	"https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz"
dnf install -y xz
tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
rm /tmp/s6-overlay-*.tar.xz
