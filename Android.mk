#
# Copyright (C) 2021-2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

ifneq ($(filter radxa0 radxa0_car radxa0_tab, $(TARGET_DEVICE)),)

LOCAL_PATH := $(call my-dir)
include $(call all-makefiles-under,$(LOCAL_PATH))

include $(LOCAL_PATH)/factory.mk

-include vendor/amlogic/radxa0/firmware.mk

endif
