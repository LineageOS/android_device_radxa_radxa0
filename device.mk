#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

## Bluetooth
PRODUCT_PACKAGES += \
    BluetoothOverlayTarget \
    libbt-vendor

$(call soong_config_set,brcm_libbt,bdroid_buildcfg_include_dir,$(LOCAL_PATH)/bluetooth/include)
$(call soong_config_set,brcm_libbt,custom_bt_config,//$(LOCAL_PATH):vnd_radxa0.txt)

## Bluetooth firmware
include hardware/broadcom/libbt/firmware/bluetooth.mk

## Factory
PRODUCT_HOST_PACKAGES += \
    aml_image_packer

## TEE
TARGET_HAS_TEE := false

## Soong Namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/broadcom/libbt

## Wi-Fi firmware
WIFI_FIRMWARE_OUT_PATH := $(TARGET_COPY_OUT_VENDOR)/lib/firmware
include hardware/broadcom/wlan/bcmdhd/firmware/wifi.mk

## Inherit from the common tree product makefile
$(call inherit-product, device/amlogic/g12-common/g12.mk)

## Inherit from the proprietary files makefile
$(call inherit-product, vendor/radxa/radxa0/radxa0-vendor.mk)
