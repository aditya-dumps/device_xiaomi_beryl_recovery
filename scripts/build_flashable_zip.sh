#!/usr/bin/env bash
#
# Copyright (C) 2026 PitchBlack Recovery Project
# SPDX-License-Identifier: Apache-2.0
#
# Generates a standard flashable installer zip for vendor_boot recovery devices,
# supporting both recovery installation and fastboot / fastbootd flashing scripts.
#

set -euo pipefail

OUTPUT_DIR="${1:-.}"
RELEASE_DIR="${2:-.}"
DEVICE_NAME="${3:-beryl}"
BUILD_DATE="${4:-$(date +%Y%m%d)}"

VENDOR_BOOT_IMG="$OUTPUT_DIR/vendor_boot.img"
if [ ! -f "$VENDOR_BOOT_IMG" ]; then
  echo "Error: vendor_boot.img not found at $VENDOR_BOOT_IMG"
  exit 1
fi

ZIP_NAME="PBRP-${DEVICE_NAME}-${BUILD_DATE}-UNOFFICIAL.zip"
TMP_DIR="$(mktemp -d -t pbrp_zip_XXXXXX)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Packaging PBRP flashable recovery zip: ${ZIP_NAME}..."

# 1. Main recovery image (vendor_boot for header v4 devices)
cp "$VENDOR_BOOT_IMG" "$TMP_DIR/recovery.img"

# 2. Standalone recovery ramdisk (if available)
if [ -f "$OUTPUT_DIR/vendor_ramdisk_recovery.cpio" ]; then
  cp "$OUTPUT_DIR/vendor_ramdisk_recovery.cpio" "$TMP_DIR/vendor_ramdisk_recovery.cpio"
elif [ -f "$OUTPUT_DIR/ramdisk-recovery.cpio" ]; then
  cp "$OUTPUT_DIR/ramdisk-recovery.cpio" "$TMP_DIR/vendor_ramdisk_recovery.cpio"
fi

# 3. Helper flash scripts for fastboot / fastbootd
cat > "$TMP_DIR/flash-whole-image.sh" << 'EOF'
#!/bin/sh
# PitchBlack Recovery Project - vendor_boot flash script
echo "Run this script at the bootloader prompt"
echo "Please reboot to the bootloader (fastboot) now!"
echo "This script will flash recovery.img to /vendor_boot"
echo "Press CTRL-C to abort or press ENTER to continue..."
read -r
fastboot devices
fastboot flash vendor_boot recovery.img
fastboot reboot recovery
echo "Finished!"
EOF
chmod 0755 "$TMP_DIR/flash-whole-image.sh"

cat > "$TMP_DIR/flash-whole-image.bat" << 'EOF'
@echo off
echo Run this script at the bootloader prompt
echo Please reboot to the bootloader (fastboot) now!
echo This script will flash recovery.img to /vendor_boot
pause
fastboot devices
fastboot flash vendor_boot recovery.img
fastboot reboot recovery
echo Finished!
EOF

cat > "$TMP_DIR/flash-ramdisk.sh" << 'EOF'
#!/bin/sh
# PitchBlack Recovery Project - fastbootd ramdisk flash script
echo "Run this script at the fastbootd prompt"
echo "Please reboot to fastbootd now!"
echo "This script will flash vendor_ramdisk_recovery.cpio to vendor_boot:recovery"
echo "Press CTRL-C to abort or press ENTER to continue..."
read -r
fastboot devices
fastboot flash vendor_boot:recovery vendor_ramdisk_recovery.cpio
fastboot reboot recovery
echo "Finished!"
EOF
chmod 0755 "$TMP_DIR/flash-ramdisk.sh"

cat > "$TMP_DIR/flash-ramdisk.bat" << 'EOF'
@echo off
echo Run this script at the fastbootd prompt
echo Please reboot to fastbootd now!
echo This script will flash vendor_ramdisk_recovery.cpio to vendor_boot:recovery
pause
fastboot devices
fastboot flash vendor_boot:recovery vendor_ramdisk_recovery.cpio
fastboot reboot recovery
echo Finished!
EOF

cat > "$TMP_DIR/INSTALL.txt" << 'EOF'
PitchBlack Recovery Project Installation Guide
===============================================

Option 1: Flashing from an existing custom recovery
- Flash this zip directly via TWRP / OrangeFox / PBRP.

Option 2: Flashing whole vendor_boot via fastboot (Bootloader)
- Reboot device to fastboot: adb reboot bootloader
- Linux / macOS: ./flash-whole-image.sh
- Windows: run flash-whole-image.bat

Option 3: Flashing recovery ramdisk via fastbootd
- Reboot device to fastbootd: fastboot reboot fastboot
- Linux / macOS: ./flash-ramdisk.sh
- Windows: run flash-ramdisk.bat
EOF

# 4. META-INF updater structure
mkdir -p "$TMP_DIR/META-INF/com/google/android"

cat > "$TMP_DIR/META-INF/com/google/android/updater-script" << 'EOF'
# PitchBlack Recovery Project dummy updater-script
EOF

cat > "$TMP_DIR/META-INF/com/google/android/update-binary" << 'EOF'
#!/sbin/sh
# PitchBlack Recovery Project - vendor_boot recovery installer
OUTFD=/proc/self/fd/$2
ZIPFILE="$3"

ui_print() {
  echo -e "ui_print $1\nui_print" > "$OUTFD"
}

ui_print "==============================================="
ui_print "       PitchBlack Recovery Project (PBRP)      "
ui_print "        vendor_boot Recovery Installer         "
ui_print "==============================================="

# Determine slot
SLOT="$(getprop ro.boot.slot_suffix)"
if [ -z "$SLOT" ]; then
  BOOT_SLOT="$(getprop ro.boot.slot)"
  if [ -n "$BOOT_SLOT" ]; then
    SLOT="_$BOOT_SLOT"
  fi
fi

ui_print "- Active boot slot: ${SLOT:-none}"

# Locate partition block devices
BLOCK_DEV=""
for p in \
  "/dev/block/bootdevice/by-name/vendor_boot${SLOT}" \
  "/dev/block/by-name/vendor_boot${SLOT}" \
  "/dev/block/platform/*/by-name/vendor_boot${SLOT}" \
  "/dev/block/mapper/vendor_boot${SLOT}" \
  "/dev/block/bootdevice/by-name/vendor_boot" \
  "/dev/block/by-name/vendor_boot"
do
  if [ -b "$p" ] || [ -e "$p" ]; then
    BLOCK_DEV="$p"
    break
  fi
done

if [ -z "$BLOCK_DEV" ]; then
  ui_print "! Error: Unable to find vendor_boot partition block device."
  exit 1
fi

ui_print "- Target partition: $BLOCK_DEV"
ui_print "- Extracting recovery image..."

TMP_EXTRACT="/dev/tmp/pbrp_install_$$"
mkdir -p "$TMP_EXTRACT"
unzip -o "$ZIPFILE" "recovery.img" -d "$TMP_EXTRACT" >/dev/null 2>&1 || {
  ui_print "! Failed to extract recovery.img from zip!"
  rm -rf "$TMP_EXTRACT"
  exit 1
}

ui_print "- Flashing PBRP image to vendor_boot..."
dd if="$TMP_EXTRACT/recovery.img" of="$BLOCK_DEV" bs=4096 2>/dev/null
sync

# Flash other slot if active slot suffix exists
if [ -n "$SLOT" ]; then
  OTHER_SLOT="_b"
  [ "$SLOT" = "_b" ] && OTHER_SLOT="_a"
  for other_p in \
    "/dev/block/bootdevice/by-name/vendor_boot${OTHER_SLOT}" \
    "/dev/block/by-name/vendor_boot${OTHER_SLOT}" \
    "/dev/block/platform/*/by-name/vendor_boot${OTHER_SLOT}"
  do
    if [ -b "$other_p" ] || [ -e "$other_p" ]; then
      ui_print "- Also flashing inactive slot ($OTHER_SLOT): $other_p..."
      dd if="$TMP_EXTRACT/recovery.img" of="$other_p" bs=4096 2>/dev/null
      sync
      break
    fi
  done
fi

rm -rf "$TMP_EXTRACT"

ui_print "- Installation complete! Rebooting to PBRP..."
ui_print "==============================================="
exit 0
EOF
chmod 0755 "$TMP_DIR/META-INF/com/google/android/update-binary"

mkdir -p "$RELEASE_DIR"
(
  cd "$TMP_DIR"
  zip -r "$RELEASE_DIR/$ZIP_NAME" .
)

echo "Successfully built: $RELEASE_DIR/$ZIP_NAME"
