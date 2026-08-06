#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

import re

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)

from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

blob_fixups: blob_fixups_user_type = {
    'vendor/lib/egl/libGLES_mali.so': blob_fixup()
        .replace_needed('android.hardware.graphics.common-V4-ndk.so', 'android.hardware.graphics.common-V7-ndk.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    'radxa0',
    'radxa',
    add_firmware_proprietary_file=True,
    blob_fixups=blob_fixups,
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
