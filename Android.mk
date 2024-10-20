#
# Copyright (C) 2021-2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

ifneq ($(filter radxa0 radxa0_car radxa0_tab, $(TARGET_DEVICE)),)

LOCAL_PATH := $(call my-dir)
include $(call all-makefiles-under,$(LOCAL_PATH))

RADIO_FILES := $(wildcard $(LOCAL_PATH)/factory/boot-files/*)
$(foreach f, $(notdir $(RADIO_FILES)), \
    $(call add-radio-file,factory/boot-files/$(f)))

include $(LOCAL_PATH)/factory.mk

endif
