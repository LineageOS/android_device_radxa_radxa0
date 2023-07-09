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

PRODUCT_UPGRADE_OUT := $(PRODUCT_OUT)/upgrade
PACKAGE_CONFIG_FILE := $(PRODUCT_UPGRADE_OUT)/image.cfg
AML_IMAGE_TOOL := $(HOST_OUT_EXECUTABLES)/aml_image_packer$(HOST_EXECUTABLE_SUFFIX)

INSTALLED_AML_UPGRADE_PACKAGE_TARGET := $(PRODUCT_OUT)/aml_upgrade_package.img

define aml-copy-file
	$(hide) $(ACP) $(1) $(PRODUCT_UPGRADE_OUT)/$(strip $(if $(2), $(2), $(notdir $(1))))
endef

NEEDED_IMAGES := \
    boot.img \
    recovery.img \
    dtbo.img \
    vbmeta.img \
    super_empty.img \
    logo.img

$(INSTALLED_AML_UPGRADE_PACKAGE_TARGET): $(addprefix $(PRODUCT_OUT)/,$(NEEDED_IMAGES)) $(ACP) $(AML_IMAGE_TOOL)
	$(hide) mkdir -p $(PRODUCT_UPGRADE_OUT)
ifneq ("$(wildcard $(FACTORY_PATH)/u-boot.bin)","")
	$(hide) $(call aml-copy-file, $(FACTORY_PATH)/u-boot.bin)
else ifneq ("$(wildcard vendor/amlogic/radxa0/radio/bootloader-recovery.img)","")
	$(hide) $(call aml-copy-file, vendor/amlogic/radxa0/radio/bootloader-recovery.img, u-boot.bin)
else
	$(error "no u-boot.bin found in $(FACTORY_PATH)")
endif
	$(hide) $(call aml-copy-file, $(PRODUCT_OUT)/logo.img)
	$(hide) $(call aml-copy-file, $(FACTORY_PATH)/aml_sdc_burn.ini)
	$(hide) $(call aml-copy-file, $(FACTORY_PATH)/image.cfg)
	$(hide) $(call aml-copy-file, $(FACTORY_PATH)/platform.conf)
	$(hide) $(call aml-copy-file, $(PRODUCT_OUT)/boot.img)
	$(hide) $(call aml-copy-file, $(PRODUCT_OUT)/recovery.img)
	$(hide) $(call aml-copy-file, $(INSTALLED_2NDBOOTLOADER_TARGET), dtb.img)
	$(hide) $(call aml-copy-file, $(PRODUCT_OUT)/dtbo.img)
	$(hide) $(call aml-copy-file, $(PRODUCT_OUT)/super_empty.img, super.img)
	$(hide) $(call aml-copy-file, $(PRODUCT_OUT)/vbmeta.img)
	$(hide) $(AML_IMAGE_TOOL) -r $(PACKAGE_CONFIG_FILE) $(PRODUCT_UPGRADE_OUT)/ $@
	$(hide) rm -rf $(PRODUCT_UPGRADE_OUT)
	$(hide) echo " $@ created"

.PHONY: aml_upgrade
aml_upgrade: $(INSTALLED_AML_UPGRADE_PACKAGE_TARGET)
