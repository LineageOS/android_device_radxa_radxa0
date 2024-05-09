#
# Copyright (C) 2021-2023 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FACTORY_PATH := device/radxa/radxa0/factory

PRODUCT_INSTALL_OUT := $(PRODUCT_OUT)/aml_install
PRODUCT_UPGRADE_OUT := $(PRODUCT_OUT)/aml_upgrade
INSTALL_PACKAGE_CONFIG_FILE := $(PRODUCT_INSTALL_OUT)/image_install.cfg
UPGRADE_PACKAGE_CONFIG_FILE := $(PRODUCT_UPGRADE_OUT)/image_upgrade.cfg
AML_IMAGE_TOOL := $(HOST_OUT_EXECUTABLES)/aml_image_packer$(HOST_EXECUTABLE_SUFFIX)

INSTALLED_AML_INSTALL_PACKAGE_TARGET := $(PRODUCT_OUT)/aml_install_package.img
INSTALLED_AML_UPGRADE_PACKAGE_TARGET := $(PRODUCT_OUT)/aml_upgrade_package.img

define aml-copy-install-file
	$(hide) $(ACP) $(1) $(PRODUCT_INSTALL_OUT)/$(strip $(if $(2), $(2), $(notdir $(1))))
endef

define aml-copy-upgrade-file
	$(hide) $(ACP) $(1) $(PRODUCT_UPGRADE_OUT)/$(strip $(if $(2), $(2), $(notdir $(1))))
endef

UPGRADE_IMAGES := \
    boot.img \
    recovery.img \
    dtbo.img \
    vbmeta.img \
    super.img \
    super_empty.img \
    logo.img

INSTALL_IMAGES := \
    boot.img \
    recovery.img \
    dtbo.img \
    vbmeta.img \
    super.img \
    super_empty.img \
    logo.img \
    misc.img

$(INSTALLED_AML_INSTALL_PACKAGE_TARGET): $(addprefix $(PRODUCT_OUT)/,$(INSTALL_IMAGES)) $(ACP) $(AML_IMAGE_TOOL)
	$(hide) mkdir -p $(PRODUCT_INSTALL_OUT)
ifneq ("$(wildcard $(FACTORY_PATH)/u-boot.bin)","")
	$(hide) $(call aml-copy-install-file, $(FACTORY_PATH)/u-boot.bin)
else ifeq ($(WITH_CONSOLE_BL),true)
	$(hide) $(call aml-copy-install-file, vendor/amlogic/radxa0/radio/bootloader-console.img, u-boot.bin)
else ifneq ("$(wildcard vendor/amlogic/radxa0/radio/bootloader.img)","")
	$(hide) $(call aml-copy-install-file, vendor/amlogic/radxa0/radio/bootloader.img, u-boot.bin)
else
	$(error "no u-boot.bin found in $(FACTORY_PATH)")
endif
	$(hide) $(call aml-copy-install-file, $(PRODUCT_OUT)/logo.img)
	$(hide) $(call aml-copy-install-file, $(FACTORY_PATH)/aml_sdc_burn.ini)
	$(hide) $(call aml-copy-install-file, $(FACTORY_PATH)/image_install.cfg, image.cfg)
	$(hide) $(call aml-copy-install-file, $(FACTORY_PATH)/platform.conf)
	$(hide) $(call aml-copy-install-file, $(PRODUCT_OUT)/boot.img)
	$(hide) $(call aml-copy-install-file, $(PRODUCT_OUT)/recovery.img)
	$(hide) $(call aml-copy-install-file, $(INSTALLED_2NDBOOTLOADER_TARGET), dtb.img)
	$(hide) $(call aml-copy-install-file, $(PRODUCT_OUT)/dtbo.img)
	$(hide) $(call aml-copy-install-file, $(PRODUCT_OUT)/super_empty.img, super.img)
	$(hide) $(call aml-copy-install-file, $(PRODUCT_OUT)/vbmeta.img)
	$(hide) $(call aml-copy-install-file, $(PRODUCT_OUT)/misc.img)
	$(hide) $(AML_IMAGE_TOOL) -r  $(PRODUCT_INSTALL_OUT)/image.cfg $(PRODUCT_INSTALL_OUT)/ $@
	$(hide) rm -rf $(PRODUCT_INSTALL_OUT)
	$(hide) echo " $@ created"

.PHONY: aml_install
aml_install: $(INSTALLED_AML_INSTALL_PACKAGE_TARGET)

$(INSTALLED_AML_UPGRADE_PACKAGE_TARGET): $(addprefix $(PRODUCT_OUT)/,$(UPGRADE_IMAGES)) $(ACP) $(AML_IMAGE_TOOL)
	$(hide) mkdir -p $(PRODUCT_UPGRADE_OUT)
ifneq ("$(wildcard $(FACTORY_PATH)/u-boot.bin)","")
	$(hide) $(call aml-copy-upgrade-file, $(FACTORY_PATH)/u-boot.bin)
else ifeq ($(WITH_CONSOLE),true)
	$(hide) $(call aml-copy-install-file, vendor/amlogic/radxa0/radio/bootloader-console.img, u-boot.bin)
else ifneq ("$(wildcard vendor/amlogic/radxa0/radio/bootloader.img)","")
	$(hide) $(call aml-copy-upgrade-file, vendor/amlogic/radxa0/radio/bootloader.img, u-boot.bin)
else
	$(error "no u-boot.bin found in $(FACTORY_PATH)")
endif
	$(hide) $(call aml-copy-upgrade-file, $(PRODUCT_OUT)/logo.img)
	$(hide) $(call aml-copy-upgrade-file, $(FACTORY_PATH)/aml_sdc_burn.ini)
	$(hide) $(call aml-copy-upgrade-file, $(FACTORY_PATH)/image_upgrade.cfg, image.cfg)
	$(hide) $(call aml-copy-upgrade-file, $(FACTORY_PATH)/platform.conf)
	$(hide) $(call aml-copy-upgrade-file, $(PRODUCT_OUT)/boot.img)
	$(hide) $(call aml-copy-upgrade-file, $(PRODUCT_OUT)/recovery.img)
	$(hide) $(call aml-copy-upgrade-file, $(INSTALLED_2NDBOOTLOADER_TARGET), dtb.img)
	$(hide) $(call aml-copy-upgrade-file, $(PRODUCT_OUT)/dtbo.img)
	$(hide) $(call aml-copy-upgrade-file, $(PRODUCT_OUT)/super.img)
	$(hide) $(call aml-copy-upgrade-file, $(PRODUCT_OUT)/vbmeta.img)
	$(hide) $(AML_IMAGE_TOOL) -r  $(PRODUCT_UPGRADE_OUT)/image.cfg $(PRODUCT_UPGRADE_OUT)/ $@
	$(hide) rm -rf $(PRODUCT_UPGRADE_OUT)
	$(hide) echo " $@ created"

.PHONY: aml_upgrade
aml_upgrade: $(INSTALLED_AML_UPGRADE_PACKAGE_TARGET)
