#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 PitchBlack Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Enable updating of APEXes (if present in build tree)
$(call inherit-product-if-exists, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Installs gsi keys into ramdisk, to boot a developer GSI with verified boot (if present in build tree)
$(call inherit-product-if-exists, $(SRC_TARGET_DIR)/product/gsi_keys.mk)
$(call inherit-product-if-exists, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)

# Inherit from beryl device
$(call inherit-product, device/xiaomi/beryl/device.mk)

# Inherit some common PBRP stuff.
$(call inherit-product-if-exists, vendor/pb/config/common.mk)

PRODUCT_DEVICE := beryl
PRODUCT_NAME := pb_beryl
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := Redmi Note 14 5G
PRODUCT_MANUFACTURER := Xiaomi

# Device properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.pbrp.device=beryl \
    ro.twrp.vendor_boot=true \
    persist.sys.fuse.passthrough.enable=true
