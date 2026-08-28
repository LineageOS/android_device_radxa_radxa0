#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

import re

from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

module = ExtractUtilsModule(
    'radxa0',
    'radxa',
    add_firmware_proprietary_file=True,
    skip_main_proprietary_file=True,
)

if __name__ == '__main__':
    utils = ExtractUtils.device_with_common(module, '../amlogic/g12-common', module.vendor)
    utils.run()

    path = f'../../../vendor/{module.vendor}/{module.device}/Android.mk'
    with open(path) as f:
        content = f.read()
    content = re.sub(
        r'ifeq \(\$\(TARGET_DEVICE\),radxa0\)',
        'ifneq ($(filter radxa0 radxa0_car radxa0_tab,$(TARGET_DEVICE)),)',
        content,
    )
    with open(path, 'w') as f:
        f.write(content)
