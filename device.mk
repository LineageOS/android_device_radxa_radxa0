#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/radxa/radxa0

$(call inherit-product, device/amlogic/g12-common/g12.mk)

## Bluetooth
PRODUCT_PACKAGES += \
    libbt-vendor

## Factory
PRODUCT_HOST_PACKAGES += \
    aml_image_packer

## Init-Files
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/init-files/init.amlogic.wifi_buildin.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.wifi_buildin.rc

## Kernel Modules
PRODUCT_PACKAGES += \
    dhd

## Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(DEVICE_PATH)/overlay

include hardware/amlogic/kernel-modules/dhd-driver/firmware/firmware.mk
