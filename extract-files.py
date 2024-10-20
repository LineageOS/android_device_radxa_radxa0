#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

module = ExtractUtilsModule(
    'radxa0',
    'radxa',
)

if __name__ == '__main__':
    utils = ExtractUtils.device_with_common(
        module, '../amlogic/g12-common', module.vendor
    )
    utils.run()
