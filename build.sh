#!/bin/bash
# Copyright (c) 2014 Che-Liang Chiou. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

ConfigureStep() {
  Banner "Copy working directory"
  rsync -av --delete --exclude=${NACL_BUILD_SUBDIR} ${START_DIR}/ ${SRC_DIR}

  Banner "Run autogen.sh"
  ChangeDir ${SRC_DIR}
  ./autogen.sh

  ChangeDir ${BUILD_DIR}
  DefaultConfigureStep
}
