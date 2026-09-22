#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/xiaomi/beryl

# Configure Virtual A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/launch_with_vendor_ramdisk.mk)

# Virtual A/B OTA configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression_with_xor.mk)

# Enable developer GSI keys
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)

# Configure generic_ramdidk.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Hidl Service
 PRODUCT_ENFORCE_VINTF_MANIFEST := true

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)

# Dynamic
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION  := false

# API
PRODUCT_SHIPPING_API_LEVEL := 34
PRODUCT_TARGET_VNDK_VERSION := 34
BOARD_SHIPPING_API_LEVEL := 34
SHIPPING_API_LEVEL := 34

BOARD_ROOT_EXTRA_SYMLINKS += \
    /vendor/firmware:/vendor/odm/firmware

# A/B
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/mtk_plpath_utils \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

# Boot
PRODUCT_PACKAGES += \
    android.hardware.boot-V1-ndk \
    android.hardware.boot@1.0 \
    android.hardware.boot@1.1 \
    android.hardware.boot@1.2 \
    android.hardware.boot@1.2-impl \
    libmtk_bsg

# Recovery basics

PRODUCT_PACKAGES += \
    vold.recovery \
    vold_prepare_subdirs.recovery \
    wait_for_keymaster.recovery

# Fastboot
PRODUCT_PACKAGES += \
    android.hardware.fastboot-V1-ndk \
    android.hardware.fastboot@1.0 \
    android.hardware.fastboot@1.1 \
    fastbootd

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.1

# Keymint
PRODUCT_PACKAGES += \
    android.hardware.security.keymint \
    android.hardware.security.secureclock \
    android.hardware.security.sharedsecret

PRODUCT_PACKAGES += \
    e2fsck.vendor_ramdisk \
    fsck.f2fs.vendor_ramdisk \
    resize2fs.vendor_ramdisk \
    tune2fs.vendor_ramdisk

PRODUCT_PACKAGES += \
    fstab.mt6855.vendor_ramdisk

# Drm
PRODUCT_PACKAGES += \
    android.hardware.drm@1.4

# Additional Target Libraries
TARGET_RECOVERY_DEVICE_MODULES += \
    android.hardware.keymaster@4.1 \
    android.hardware.keymaster-V4-ndk.so \
    libion \
    android.hardware.boot@1.0 \
    android.hardware.boot@1.1 \
    android.hardware.boot-V1-ndk \
    libsysutils \
    libvintf

TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.keymaster@4.1.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libion.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.boot@1.0.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.boot@1.1.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/android.hardware.boot-V1-ndk.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libsysutils.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libvintf.so

# Copy first-stage fstabs to vendor_ramdisk — required by first-stage init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/first_stage_ramdisk/fstab.mt6855:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt6855 \
    $(LOCAL_PATH)/recovery/root/first_stage_ramdisk/fstab.emmc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.emmc

# Copy stock vendor_ramdisk essentials to ramdisk00 — sepolicy, context files, snapuserd, init
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/vendor_ramdisk/first_stage_ramdisk/system/bin/snapuserd:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/system/bin/snapuserd \
    $(LOCAL_PATH)/vendor_ramdisk/system/bin/mtk_plpath_utils:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/mtk_plpath_utils \
    $(LOCAL_PATH)/vendor_ramdisk/system/bin/init:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/system/bin/init \
    $(LOCAL_PATH)/vendor_ramdisk/init:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/init \
    $(LOCAL_PATH)/vendor_ramdisk/init.recovery.hardware.rc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/init.recovery.hardware.rc \
    $(LOCAL_PATH)/vendor_ramdisk/sepolicy:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/sepolicy \
    $(LOCAL_PATH)/vendor_ramdisk/prop.default:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/prop.default \
    $(LOCAL_PATH)/vendor_ramdisk/plat_file_contexts:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/plat_file_contexts \
    $(LOCAL_PATH)/vendor_ramdisk/plat_property_contexts:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/plat_property_contexts \
    $(LOCAL_PATH)/vendor_ramdisk/plat_service_contexts:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/plat_service_contexts \
    $(LOCAL_PATH)/vendor_ramdisk/vendor_file_contexts:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/vendor_file_contexts \
    $(LOCAL_PATH)/vendor_ramdisk/vendor_property_contexts:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/vendor_property_contexts \
    $(LOCAL_PATH)/vendor_ramdisk/vendor_service_contexts:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/vendor_service_contexts \
    $(LOCAL_PATH)/vendor_ramdisk/system_ext_file_contexts:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/system_ext_file_contexts \
    $(LOCAL_PATH)/vendor_ramdisk/system_ext_property_contexts:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/system_ext_property_contexts \
    $(LOCAL_PATH)/vendor_ramdisk/system_ext_service_contexts:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/system_ext_service_contexts \
    $(LOCAL_PATH)/vendor_ramdisk/odm_file_contexts:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/odm_file_contexts \
    $(LOCAL_PATH)/vendor_ramdisk/odm_property_contexts:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/odm_property_contexts \
    $(LOCAL_PATH)/vendor_ramdisk/product_file_contexts:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/product_file_contexts \
    $(LOCAL_PATH)/vendor_ramdisk/product_property_contexts:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/product_property_contexts \
    $(LOCAL_PATH)/vendor_ramdisk/product_service_contexts:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/product_service_contexts

# Timezone data for Bionic libc
PRODUCT_COPY_FILES += \
    system/timezone/output_data/iana/tzdata:$(TARGET_COPY_OUT_RECOVERY)/root/system/usr/share/zoneinfo/tzdata


# honestly! fuck this vintf 9.0 issue!!!
# trying to get rid of from the manifest version 9.0  issue - stop this file from being generated
 PRODUCT_REMOVE_PACKAGES += android.hardware.health-service.example
# 

