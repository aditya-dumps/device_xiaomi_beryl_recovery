#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Inherit some common Twrp stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from beryl device
$(call inherit-product, device/xiaomi/beryl/device.mk)

# Configure emulated_storage.mk (if present)
$(call inherit-product-if-exists, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Inherit PBRP common stuff if exists
$(call inherit-product-if-exists, vendor/pb/config/common.mk)

PRODUCT_DEVICE := beryl
PRODUCT_NAME := twrp_beryl
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := Redmi Note 14 5G
PRODUCT_MANUFACTURER := Xiaomi

# Hide Reflash TWRP & FUSE passthrough
PRODUCT_PROPERTY_OVERRIDES += \
    ro.twrp.vendor_boot=true \
    persist.sys.fuse.passthrough.enable=true
