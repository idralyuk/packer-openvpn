#!/bin/bash
set -e
CIRCLECI_CACHE_DIR="${HOME}/packer"
PACKER_VERSION="1.2.2"
PACKER_CHECKSUM="6575f8357a03ecad7997151234b1b9f09c7a5cf91c194b23a461ee279d68c6a8"
PACKER_URL="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"

if [ ! -f "${CIRCLECI_CACHE_DIR}/packer" ] || [[ ! "$(packer version)" =~ "Packer v${PACKER_VERSION}" ]]; then
  wget -O /tmp/packer.zip "${PACKER_URL}"
  echo "${PACKER_CHECKSUM} /tmp/packer.zip" | sha256sum --check -
  unzip -oud "${CIRCLECI_CACHE_DIR}" /tmp/packer.zip
  sudo ln -s ${CIRCLECI_CACHE_DIR}/packer /usr/local/bin/packer
fi

packer version
