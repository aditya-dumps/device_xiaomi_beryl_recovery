#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2025 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#

# screen settings
# e.g. if the aspect ratio is 19:9 then use 19*120 (=2280)

# OrangeFox maintainer
OF_MAINTAINER := 🔥IQ_HARRY_07🔥

# Screen settings
OF_SCREEN_H := 2400
OF_STATUS_H := 100
OF_STATUS_INDENT_LEFT := 48
OF_STATUS_INDENT_RIGHT := 48
OF_ALLOW_DISABLE_NAVBAR := 0
OF_CLOCK_POS := 1
OF_OPTIONS_LIST_NUM := 9

FOX_REFERENCE_VENDOR_BOOT_IMAGE := device/xiaomi/beryl/prebuilt/vendor_boot.img

# other stuff
OF_QUICK_BACKUP_LIST := /boot;/persist_image;
OF_ENABLE_LPTOOLS := 0
OF_NO_TREBLE_COMPATIBILITY_CHECK := 1
OF_DYNAMIC_FULL_SIZE := 9126805504

# number of list options before scrollbar creation
OF_OPTIONS_LIST_NUM := 11

# Fix recovery issues caused by large splash images
OF_SPLASH_MAX_SIZE = 2048

# A/B with recovery partition
OF_AB_DEVICE_WITH_RECOVERY_PARTITION := 0

# ----- data format stuff -----
# ensure that /sdcard is bind-unmounted before f2fs data repair or format
OF_UNBIND_SDCARD_F2FS := 1

# automatically wipe /metadata after data format
OF_WIPE_METADATA_AFTER_DATAFORMAT := 1

# avoid MTP issues after data format
# OF_BIND_MOUNT_SDCARD_ON_FORMAT := 1

# don't spam the console with loop errors
OF_LOOP_DEVICE_ERRORS_TO_LOG := 1

# lz4 compression
OF_USE_LZ4_COMPRESSION := 1 

# Drastic size reduction to fit within 64 MB partition limit on Header v4
FOX_EXTREME_SIZE_REDUCTION := 1
FOX_DRASTIC_SIZE_REDUCTION := 1

# build all the partition tools
OF_ENABLE_ALL_PARTITION_TOOLS := 0

ifeq ($(TW_INCLUDE_CRYPTO),false)
	# Set to 1 to skip the FBE decryption routines (prevents hanging at the Fox logo or Redmi/Mi logo)
	OF_SKIP_FBE_DECRYPTION := 1
endif

# Set this to 1 to replace the "Swipe up" lockscreen screen with a button
OF_USE_LOCKSCREEN_BUTTON := 1

# Called just before formatting /data; only useful for devices/ROMs that have dynamic partitions
OF_USE_DMCTL := 1

# Use this to change the default time zone
OF_DEFAULT_TIMEZONE := GMT0;BST,M3.5.0,M10.5.0

# Set this to 1 to avoid the new 'NO KERNEL CONFIG' error, when using a prebuilt kernel
OF_FORCE_PREBUILT_KERNEL := 1

# Set this to 1 if your device uses aidl (as opposed to hidl) to handle boot control, particularly changing slots
OF_USE_AIDL_BOOT_CONTROL := 1

# Set this to 1 to remove toggleable option: "Reflash OrangeFox after flashing a ROM"
# Implemented forced method using /system/bin/pre_rom_flash.sh and .../post_rom_flash.sh
# OF_NO_REFLASH_CURRENT_ORANGEFOX := 1

# Set this to 1 to disable automatic rebooting after openrecoveryscript finishes
OF_DISABLE_ORS_AUTO_REBOOT := 1

# Set this to 1 to force the selection of f2fs when formatting data
OF_FORCE_DATA_FORMAT_F2FS := 1

# Set this to 1 to include an addon for removing factory reset protection (FRP)
OF_ENABLE_FRP_ADDON := 0

# Set to 1 to force the casefolding props to true. Useful for devices that shipped with Android 11+/FBEv2, where casefolding is always used
OF_FORCE_CASEFOLDING := 1
