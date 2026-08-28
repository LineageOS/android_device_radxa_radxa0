#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifneq ($(filter radxa0 radxa0_car radxa0_tab,$(TARGET_DEVICE)),)

FACTORY_PATH := device/radxa/radxa0/factory
VENDOR_PATH := vendor/radxa/radxa0

RADIO_FILES := $(wildcard $(VENDOR_PATH)/radio/*)
$(foreach f, $(notdir $(RADIO_FILES)), \
    $(call add-radio-file,../../../$(VENDOR_PATH)/radio/$(f)))

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
    logo.img

$(INSTALLED_AML_INSTALL_PACKAGE_TARGET): $(addprefix $(PRODUCT_OUT)/,$(INSTALL_IMAGES)) $(ACP) $(AML_IMAGE_TOOL)
	$(hide) mkdir -p $(PRODUCT_INSTALL_OUT)
ifeq ($(WITH_CONSOLE_BL),true)
	$(hide) $(call aml-copy-install-file, $(VENDOR_PATH)/radio/bootloader-console.img, u-boot.bin)
else ifeq ($(WITH_RECOVERY_BL),true)
	$(hide) $(call aml-copy-install-file, $(VENDOR_PATH)/radio/bootloader-recovery.img, u-boot.bin)
else
	$(hide) $(call aml-copy-install-file, $(VENDOR_PATH)/radio/bootloader.img, u-boot.bin)
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
	$(hide) $(call aml-copy-install-file, $(VENDOR_PATH)/radio/misc.img)
	$(hide) $(AML_IMAGE_TOOL) -r  $(PRODUCT_INSTALL_OUT)/image.cfg $(PRODUCT_INSTALL_OUT)/ $@
	$(hide) rm -rf $(PRODUCT_INSTALL_OUT)
	$(hide) echo " $@ created"

.PHONY: aml_install
aml_install: $(INSTALLED_AML_INSTALL_PACKAGE_TARGET)

BUILT_TARGET_FILES_ZIPROOT := $(call intermediates-dir-for,PACKAGING,target_files)/$(TARGET_PRODUCT)-target_files
$(BUILT_TARGET_FILES_ZIPROOT).zip: $(BUILT_TARGET_FILES_ZIPROOT)/IMAGES/aml_install_package.img

$(BUILT_TARGET_FILES_ZIPROOT)/IMAGES/aml_install_package.img: $(BUILT_TARGET_FILES_ZIPROOT).zip.list $(PRODUCT_OUT)/aml_install_package.img
	@mkdir -p $(dir $@)
	@cp $(PRODUCT_OUT)/aml_install_package.img $@
	@echo $@ >> $(BUILT_TARGET_FILES_ZIPROOT).zip.list

INSTALLED_RADIOIMAGE_TARGET += $(INSTALLED_AML_INSTALL_PACKAGE_TARGET)

$(INSTALLED_AML_UPGRADE_PACKAGE_TARGET): $(addprefix $(PRODUCT_OUT)/,$(UPGRADE_IMAGES)) $(ACP) $(AML_IMAGE_TOOL)
	$(hide) mkdir -p $(PRODUCT_UPGRADE_OUT)
ifeq ($(WITH_CONSOLE_BL),true)
	$(hide) $(call aml-copy-upgrade-file, $(VENDOR_PATH)/radio/bootloader-console.img, u-boot.bin)
else ifeq ($(WITH_RECOVERY_BL),true)
	$(hide) $(call aml-copy-upgrade-file, $(VENDOR_PATH)/radio/bootloader-recovery.img, u-boot.bin)
else
	$(hide) $(call aml-copy-upgrade-file, $(VENDOR_PATH)/radio/bootloader.img, u-boot.bin)
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

$(BUILT_TARGET_FILES_DIR): $(INSTALLED_RADIOIMAGE_TARGET)

endif
