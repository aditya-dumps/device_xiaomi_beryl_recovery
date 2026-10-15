# Copyright (C) 2026 PitchBlack Recovery Project
# SPDX-License-Identifier: Apache-2.0
#
# Custom boot/vendor_boot rules for beryl.
# Keeps default boot image behavior (AVB enabled) and replaces vendor_boot with
# a stock-based image that only swaps the recovery ramdisk.

ifdef BUILDING_BOOT_IMAGE
ifeq (true,$(BOARD_AVB_ENABLE))
$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(AVBTOOL) $(INTERNAL_BOOTIMAGE_FILES) $(BOARD_AVB_BOOT_KEY_PATH) $(BOARD_GKI_SIGNING_KEY_PATH)
	$(call pretty,"Target boot image: $@")
	$(call build_boot_board_avb_enabled,$@)

.PHONY: bootimage-nodeps
bootimage-nodeps: $(MKBOOTIMG) $(AVBTOOL) $(BOARD_AVB_BOOT_KEY_PATH) $(BOARD_GKI_SIGNING_KEY_PATH)
	@echo "make $@: ignoring dependencies"
	$(foreach b,$(INSTALLED_BOOTIMAGE_TARGET),$(call build_boot_board_avb_enabled,$(b)))
endif
endif

ifdef BUILDING_VENDOR_BOOT_IMAGE
VENDOR_BOOT_STOCK ?= $(DEVICE_PATH)/prebuilt/vendor_boot.img
VENDOR_BOOT_PATCH_DIR := $(abspath $(PRODUCT_OUT)/vendor_boot_patch)
VENDOR_BOOT_STOCK_ABS := $(abspath $(VENDOR_BOOT_STOCK))
AVBTOOL_BIN := $(abspath $(AVBTOOL))

# Look for magiskboot
HOST_ARCH_SUFFIX := $(if $(findstring aarch64,$(shell uname -m)),arm64,$(if $(findstring arm,$(shell uname -m)),arm,$(if $(findstring x86_64,$(shell uname -m)),x86_64,x86)))
MAGISKBOOT_BIN := $(if $(wildcard $(DEVICE_PATH)/scripts/magiskboot),$(abspath $(DEVICE_PATH)/scripts/magiskboot),$(wildcard $(PWD)/external/magisk-prebuilt/prebuilt/magiskboot_$(HOST_ARCH_SUFFIX)))
ifeq ($(MAGISKBOOT_BIN),)
    MAGISKBOOT_BIN := $(wildcard $(PWD)/external/magisk-prebuilt/prebuilt/magiskboot_x86_64)
endif
ifeq ($(MAGISKBOOT_BIN),)
    MAGISKBOOT_BIN := magiskboot
endif

$(INSTALLED_VENDOR_BOOTIMAGE_TARGET): $(recovery_uncompressed_ramdisk) $(VENDOR_BOOT_STOCK) $(AVBTOOL)
	$(call pretty,"Target vendor_boot image: $@ (patched stock)")
	@if [ ! -f "$(VENDOR_BOOT_STOCK_ABS)" ]; then \
		echo "error: missing stock vendor_boot at $(VENDOR_BOOT_STOCK_ABS)"; \
		exit 1; \
	fi
	@chmod +x "$(MAGISKBOOT_BIN)" 2>/dev/null || true
	@RAMDISK_SRC="$(abspath $(PRODUCT_OUT)/ramdisk-recovery.cpio)"; \
	if [ ! -f "$$RAMDISK_SRC" ]; then \
		RAMDISK_SRC="$(abspath $(PRODUCT_OUT)/obj/PACKAGING/recovery_intermediates/ramdisk-recovery.cpio)"; \
	fi; \
	if [ ! -f "$$RAMDISK_SRC" ]; then \
		RAMDISK_SRC="$(abspath $(PRODUCT_OUT)/obj/PACKAGING/vendor_ramdisk_fragments_intermediates/recovery.cpio.lz4)"; \
	fi; \
	if [ ! -f "$$RAMDISK_SRC" ]; then \
		echo "error: cannot find recovery ramdisk cpio at $$RAMDISK_SRC"; \
		exit 1; \
	fi; \
	echo "Using recovery ramdisk: $$RAMDISK_SRC"; \
	rm -rf "$(VENDOR_BOOT_PATCH_DIR)"; \
	mkdir -p "$(VENDOR_BOOT_PATCH_DIR)"; \
	cp -f "$(VENDOR_BOOT_STOCK_ABS)" "$(VENDOR_BOOT_PATCH_DIR)/stock.img"; \
	(cd "$(VENDOR_BOOT_PATCH_DIR)" && "$(MAGISKBOOT_BIN)" unpack -n stock.img); \
	if [ -f "$(VENDOR_BOOT_PATCH_DIR)/vendor_ramdisk/recovery.cpio" ]; then \
		cp -f "$$RAMDISK_SRC" "$(VENDOR_BOOT_PATCH_DIR)/vendor_ramdisk/recovery.cpio"; \
	fi; \
	if [ -f "$(VENDOR_BOOT_PATCH_DIR)/vendor_ramdisk_recovery.cpio" ]; then \
		cp -f "$$RAMDISK_SRC" "$(VENDOR_BOOT_PATCH_DIR)/vendor_ramdisk_recovery.cpio"; \
	fi; \
	cp -f "$$RAMDISK_SRC" "$(abspath $(PRODUCT_OUT))/vendor_ramdisk_recovery.cpio"; \
	if [ -f "$(VENDOR_BOOT_PATCH_DIR)/bootconfig" ]; then \
		grep -q "androidboot.selinux=permissive" "$(VENDOR_BOOT_PATCH_DIR)/bootconfig" || \
		echo "androidboot.selinux=permissive" >> "$(VENDOR_BOOT_PATCH_DIR)/bootconfig"; \
	fi; \
	(cd "$(VENDOR_BOOT_PATCH_DIR)" && PATCHVBMETAFLAG=true "$(MAGISKBOOT_BIN)" repack stock.img new_vendor_boot.img); \
	cp -f "$(VENDOR_BOOT_PATCH_DIR)/new_vendor_boot.img" "$@"; \
	$(call assert-max-image-size,$@,$(BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE)); \
	"$(AVBTOOL_BIN)" erase_footer --image $@ >/dev/null 2>&1 || true; \
	"$(AVBTOOL_BIN)" add_hash_footer \
		--image $@ \
		--partition_size $(BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE) \
		--partition_name vendor_boot \
		--flags 3 \
		$(INTERNAL_AVB_VENDOR_BOOT_SIGNING_ARGS) \
		$(BOARD_AVB_VENDOR_BOOT_ADD_HASH_FOOTER_ARGS)

endif
