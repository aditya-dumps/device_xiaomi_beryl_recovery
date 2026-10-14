# PitchBlack Recovery Project (PBRP) Port Documentation for beryl

**Device**: Xiaomi Redmi Note 14 5G / POCO M7 Pro 5G (`beryl` / `citrine`)  
**Base**: TWRP Minimal Manifest (Converted from OrangeFox 14.1)  
**Target Recovery**: PitchBlack Recovery Project (PBRP)  
**Maintainer**: 🔥IQ_HARRY_07🔥  
**Date**: 2026-10-10  

---

## 1. Overview of Porting

PBRP is a fork of TWRP. Unlike OrangeFox (which relies heavily on hundreds of proprietary `FOX_*` / `OF_*` shell exports in `vendorsetup.sh`), PBRP follows standard Android and TWRP conventions:
- Hardware, architecture, Virtual A/B, and dynamic partitions are defined via standard AOSP `BOARD_*` / `TARGET_*` flags in `BoardConfig.mk`.
- PBRP-specific features use genuine `PB_*` build flags verified directly against PBRP source (`android_bootable_recovery` and `vendor/pb`).
- Lunch choices are configured through modern `COMMON_LUNCH_CHOICES` in `AndroidProducts.mk`.

---

## 2. File Changes & Architecture

### New Files Created:
- **`pb_beryl.mk`**:
  - Inherits standard AOSP core configs (`core_64_bit.mk`, `base.mk`, `updatable_apex.mk`, `gsi_keys.mk`).
  - Inherits device configuration: `device/xiaomi/beryl/device.mk`.
  - Inherits PBRP common vendor config: `$(call inherit-product-if-exists, vendor/pb/config/common.mk)`.
  - Sets product metadata:
    ```makefile
    PRODUCT_DEVICE := beryl
    PRODUCT_NAME := pb_beryl
    PRODUCT_BRAND := Redmi
    PRODUCT_MODEL := Redmi Note 14 5G
    PRODUCT_MANUFACTURER := Xiaomi
    ```
  - Sets PBRP device runtime properties:
    ```makefile
    PRODUCT_PROPERTY_OVERRIDES += \
        ro.pbrp.device=beryl \
        ro.twrp.vendor_boot=true \
        persist.sys.fuse.passthrough.enable=true
    ```

### Files Modified & Cleaned:

- **`AndroidProducts.mk`**:
  - Registers both `pb_beryl.mk` and `twrp_beryl.mk`.
  - Implements `COMMON_LUNCH_CHOICES`:
    `pb_beryl-user`, `pb_beryl-userdebug`, `pb_beryl-eng`, `twrp_beryl-user`, `twrp_beryl-userdebug`, `twrp_beryl-eng`.

- **`BoardConfig.mk`**:
  - Removed OrangeFox Soong plugin: `-include bootable/recovery/orangefox_soong.mk`.
  - Removed OrangeFox-specific flags: `OF_FLASHLIGHT_ENABLE`, `OF_FL_PATH1`.
  - Removed hallucinated/fake `PB_*` variables.
  - Implemented genuine PBRP build flags verified in PBRP source code:
    ```makefile
    # Flashlight / Torch
    PB_TORCH_PATH := "/sys/class/leds/flashlight"
    PB_TORCH_MAX_BRIGHTNESS := 1

    # PitchBlack Recovery Project (PBRP) Configuration
    PB_DISABLE_DEFAULT_DM_VERITY := true
    PB_DISABLE_DEFAULT_TREBLE_COMP := true
    MAINTAINER := "🔥IQ_HARRY_07🔥"
    TW_DEVICE_VERSION := beryl | 🔥IQ_HARRY_07🔥
    ```
  - Cleaned duplicate `TARGET_RECOVERY_PIXEL_FORMAT` and "BlueFox" comments, keeping clean `TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888`.
  - Retained all MediaTek Dimensity 7025-Ultra (`mt6855`) hardware configurations, Virtual A/B OTA updater, FBE v2 crypto, dynamic partition definitions, and vendor modules.

- **`vendorsetup.sh`**:
  - Cleaned out legacy and fake shell flags. Kept minimal standard environment settings:
    ```bash
    export LC_ALL="C"
    export ALLOW_MISSING_DEPENDENCIES=true
    ```

- **Vendor Boot Generation**:
  - Uses standard PBRP / AOSP build rules (`build/make/core/Makefile` and `vendor/utils/build/tasks/pbrp.mk`).
  - Native `mkbootimg` and `avbtool` packaging of recovery ramdisk fragment into `vendor_boot.img`.

- **`twrp_beryl.mk`**:
  - Cleaned duplicate `PRODUCT_NAME` assignment.
  - Safely includes `vendor/pb/config/common.mk`.

- **`README.md`**:
  - Updated branding to PitchBlack Recovery Project (PBRP) for Xiaomi Redmi Note 14 5G (`beryl`).

---

## 3. How to Build

```bash
# In your PBRP build root:
source build/envsetup.sh
lunch pb_beryl-userdebug
# or lunch pb_beryl-eng

# Build recovery (vendor_boot for beryl):
mka recoveryimage -j$(nproc --all)
# or
mka vendorbootimage -j$(nproc --all)
# or for PBRP target package:
mka pbrp -j$(nproc --all)
```
