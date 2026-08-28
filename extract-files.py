#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'vendor/amlogic/g12-common',
]

module = ExtractUtilsModule(
    'radxa0',
    'radxa',
    add_firmware_proprietary_file=True,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device_with_common(module, '../amlogic/g12-common', module.vendor)
    utils.run()
