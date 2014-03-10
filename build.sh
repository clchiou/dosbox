#!/bin/bash
# Copyright (c) 2014 Che-Liang Chiou. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

ConfigureStep() {
  Banner "Copy working directory"
  rsync -av --delete --exclude="build-nacl-*" ${START_DIR}/ ${SRC_DIR}

  Banner "Run autogen.sh"
  ChangeDir ${SRC_DIR}
  ./autogen.sh

  ChangeDir ${BUILD_DIR}
  DefaultConfigureStep

  sed -i "s/-lSDLmain/-lchromedosbox &/" ${BUILD_DIR}/src/Makefile
}

InstallStep() {
  if [ -z "${CHROME_DOSBOX_INSTALL_DIR:-}" ]; then
    echo "Missing CHROME_DOSBOX_INSTALL_DIR"
    exit 1
  fi

  DefaultInstallStep

  Banner "Copy dosbox.nexe"
  local DOSBOX_NEXE="${NACLPORTS_PREFIX_BIN}/dosbox.nexe"
  local ARCH_NAME=
  if [ "${NACL_ARCH}" = "x86_64" ]; then
    ARCH_NAME="x86-64"
  elif [ "${NACL_ARCH}" = "i686" ]; then
    ARCH_NAME="x86-32"
  elif [ "${NACL_ARCH}" = "arm" ]; then
    ARCH_NAME="arm"
  else
    echo "Could not handle NACL_ARCH: ${NACL_ARCH}"
    exit 1
  fi
  LogExecute cp -f "${DOSBOX_NEXE}" \
    "${CHROME_DOSBOX_INSTALL_DIR}/${ARCH_NAME}/dosbox_${ARCH_NAME}.nexe"
  LogExecute cp -f "${DOSBOX_NEXE}" \
    "${CHROME_DOSBOX_INSTALL_DIR}/all/dosbox_${ARCH_NAME}.nexe"
}
