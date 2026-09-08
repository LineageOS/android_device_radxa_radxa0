#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

ifneq ($(filter radxa0 radxa0_car radxa0_tab,$(TARGET_DEVICE)),)

FACTORY_PATH := device/radxa/radxa0/factory
VENDOR_PATH := vendor/radxa/radxa0

PRODUCT_INSTALL_OUT := $(PRODUCT_OUT)/aml_install
PRODUCT_UPGRADE_OUT := $(PRODUCT_OUT)/aml_upgrade
INSTALL_PACKAGE_CONFIG_FILE := $(PRODUCT_INSTALL_OUT)/image_install.cfg
UPGRADE_PACKAGE_CONFIG_FILE := $(PRODUCT_UPGRADE_OUT)/image_upgrade.cfg
AML_IMAGE_TOOL := $(HOST_OUT_EXECUTABLES)/aml_image_packer$(HOST_EXECUTABLE_SUFFIX)

INSTALLED_AML_INSTALL_PACKAGE_TARGET := $(PRODUCT_OUT)/aml_install_package.img
INSTALLED_AML_UPGRADE_PACKAGE_TARGET := $(PRODUCT_OUT)/aml_upgrade_package.img

# $(1): source file, $(2): staging directory, $(3): destination name if it differs
define aml-copy-file
$(hide) $(ACP) $(1) $(2)/$(strip $(if $(3),$(3),$(notdir $(1))))
endef

# Stages a package directory and hands it to the image packer.
# $(1): staging directory
# $(2): image.cfg to use
# $(3): super image to ship as super.img
# $(4): one extra file to include, if any
define aml-build-package
$(hide) mkdir -p $(1)
	$(call aml-copy-file,$(VENDOR_PATH)/radio/bootloader.img,$(1),u-boot.bin)
	$(call aml-copy-file,$(PRODUCT_OUT)/logo.img,$(1))
	$(call aml-copy-file,$(FACTORY_PATH)/aml_sdc_burn.ini,$(1))
	$(call aml-copy-file,$(FACTORY_PATH)/$(2),$(1),image.cfg)
	$(call aml-copy-file,$(FACTORY_PATH)/platform.conf,$(1))
	$(call aml-copy-file,$(PRODUCT_OUT)/boot.img,$(1))
	$(call aml-copy-file,$(PRODUCT_OUT)/recovery.img,$(1))
	$(call aml-copy-file,$(INSTALLED_2NDBOOTLOADER_TARGET),$(1),dtb.img)
	$(call aml-copy-file,$(PRODUCT_OUT)/dtbo.img,$(1))
	$(call aml-copy-file,$(PRODUCT_OUT)/$(3),$(1),super.img)
	$(call aml-copy-file,$(PRODUCT_OUT)/vbmeta.img,$(1))
	$(if $(4),$(call aml-copy-file,$(4),$(1)))
	$(hide) $(AML_IMAGE_TOOL) -r $(1)/image.cfg $(1)/ $@
	$(hide) rm -rf $(1)
	$(hide) echo " $@ created"
endef

NEEDED_IMAGES := \
    boot.img \
    recovery.img \
    dtbo.img \
    vbmeta.img \
    super.img \
    super_empty.img \
    logo.img

$(INSTALLED_AML_INSTALL_PACKAGE_TARGET): $(addprefix $(PRODUCT_OUT)/,$(NEEDED_IMAGES)) $(ACP) $(AML_IMAGE_TOOL)
	$(call aml-build-package,$(PRODUCT_INSTALL_OUT),image_install.cfg,super_empty.img,$(VENDOR_PATH)/radio/misc.img)

.PHONY: aml_install
aml_install: $(INSTALLED_AML_INSTALL_PACKAGE_TARGET)

$(INSTALLED_AML_UPGRADE_PACKAGE_TARGET): $(addprefix $(PRODUCT_OUT)/,$(NEEDED_IMAGES)) $(ACP) $(AML_IMAGE_TOOL)
	$(call aml-build-package,$(PRODUCT_UPGRADE_OUT),image_upgrade.cfg,super.img)

.PHONY: aml_upgrade
aml_upgrade: $(INSTALLED_AML_UPGRADE_PACKAGE_TARGET)

BUILT_TARGET_FILES_ZIPROOT := $(call intermediates-dir-for,PACKAGING,target_files)/$(TARGET_PRODUCT)-target_files
$(BUILT_TARGET_FILES_ZIPROOT).zip: $(BUILT_TARGET_FILES_ZIPROOT)/IMAGES/aml_install_package.img

$(BUILT_TARGET_FILES_ZIPROOT)/IMAGES/aml_install_package.img: $(BUILT_TARGET_FILES_ZIPROOT).zip.list $(PRODUCT_OUT)/aml_install_package.img
	@mkdir -p $(dir $@)
	@cp $(PRODUCT_OUT)/aml_install_package.img $@
	@echo $@ >> $(BUILT_TARGET_FILES_ZIPROOT).zip.list

INSTALLED_RADIOIMAGE_TARGET += $(INSTALLED_AML_INSTALL_PACKAGE_TARGET)

$(BUILT_TARGET_FILES_DIR): $(INSTALLED_RADIOIMAGE_TARGET)

endif
