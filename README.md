## OrangeFox Recovery device tree for the Redmi Note 14 5G / POCO M7 Pro 5G (Beryl)

The Redmi Note 14 5G / POCO M7 Pro 5G (codenamed _"beryl"_) is a mid-range smartphone from Xiaomi/POCO.

## Device specifications

| Feature                        | Specification                                                                             |
| -----------------------------: | :---------------------------------------------------------------------------------------- |
| Chipset                        | MediaTek Dimensity 7025-Ultra (6 nm)                                                      |
| CPU                            | Octa-core (2x2.5 GHz Cortex-A78 & 6x2.0 GHz Cortex-A55)                                   |
| GPU                            | IMG BXM-8-256                                                                              |
| Memory                         | 6GB / 8GB RAM                                                                              |
| Shipped OS                     | Android 14 (HyperOS)                                                                      |
| Storage                        | 128GB / 256GB                                                                     |
| SIM                            | Nano-SIM + Nano-SIM                                                                       |
| MicroSD                        | microSDXC                                                                                 |
| Battery                        | Li-Po 5110 mAh (non-removable), 45W fast charging                                          |
| Dimensions                     | 162.4 x 75.7 x 8.0 mm                                                                     |
| Display                        | 6.67 inches, AMOLED, 120Hz, 1080 x 2400 pixels                                             |

## Device picture

<table>
<tr>
<td><img src="https://fdn2.gsmarena.com/vv/pics/xiaomi/xiaomi-redmi-note-14-5g-1.jpg" width="300"/></td>
<td><img src="https://cdn.idealo.com/folder/Product/206210/1/206210107/s11_produktbild_max/xiaomi-poco-m7-pro-5g-8gb-256gb-violeta.jpg" width="300"/></td>
</tr>
</table>

---

## What's working & what's not working

The recovery is currently functional for the major recovery and flashing operations. Most hardware and recovery features are working as expected, with only a few known limitations.

| Feature | Status | Notes |
| :-------------------------- | :----: | :-------------------------------------------------------------------------- |
| Touchscreen                 |   ✅   | Touch input works correctly in OrangeFox.                                   |
| Display                     |   ✅   | Display output and brightness are working normally.                        |
| USB                         |   ✅   | USB connection works correctly in recovery.                                |
| ADB                         |   ✅   | ADB connection is functional and can be used from a computer.              |
| Fastboot/FastbootD                   |   ✅   | FastbootD/bootloader functionality works as expected.                       |
| Internal Storage            |   ✅   | Internal storage can be accessed normally from recovery.                   |
| MicroSD                     |   ✅   | microSD storage is detected and accessible.                                |
| Decryption                  |   ✅   | Device storage decryption is working.                                      |
| Backup & Restore             |   ✅   | Recovery backup and restore operations are functional.                     |
| Flashing ZIPs               |   ✅   | ROMs, Magisk, patches, and other flashable ZIPs can be flashed.            |                             |
| Mounting Partitions         |   ✅   | Supported partitions can be mounted correctly.                             |
| Reboot Options              |   ✅   | Rebooting to System, Recovery, and Bootloader works as expected.           |
| Vibration                   |   ✅   | Vibration/haptic feedback is working properly in recovery.            |
| Flashlight                  |   ✅   | The flashlight/torch function is working in recovery.        |
| SELinux                     |   ⚠️   | SELinux is currently running in **Permissive** mode.                       |

### Known limitations

- ⚠️ **SELinux:** The recovery currently runs with SELinux in **Permissive** mode rather than Enforcing.

> **Note:** Apart from the limitations listed above, the recovery is considered functional for normal recovery, flashing, backup, restore, wiping, and related operations.

---

---
# Flashing
## Flashing with an installed custom recovery (OrangeFox/TWRP/PBRP/etc.):
    * Download the OrangeFox zip installer file
    * Reboot your device to your custom recovery
    * Flash the OrangeFox zip installer
    * Reboot to OrangeFox after flashing

## Flashing with Fastboot - only if there is no installed custom recovery:
    * Download the OrangeFox recovery image
    * Reboot your device to bootloader/fastboot mode
    * Flash or boot the OrangeFox recovery image according to the device's partition layout
    * Reboot to recovery
        * Reboot to System and configure the Android ROM
    * Reboot to OrangeFox and flash the OrangeFox zip installer if required

---

### Device tree
Available at (https://github.com/IQ-HARRY7/device_xiaomi_beryl_recovery)

---
---

<h2 align="center">✨ Credits & Thanks</h2>

<p align="center">
  <i>This project wouldn't be where it is without the contributions, expertise, and encouragement of the people below.</i><br>
  <i>Sincere thanks to everyone who played a part in making it happen.</i>
</p>

<br>

- 🛠️ **Khargosxh18** — Device tree rebasing and adaptation
- 🧭 **Darthjabba9** — Technical mentorship and project-wide support
- 🤝 **Azzychy** — Valuable assistance and encouragement through the toughest phases
- 🌳 **Specko** — Base tree contributions and technical direction
- 🔧 **Eyad** — Ongoing project support, troubleshooting, and surviving Windows BS — bro is pro
- 🚀 **!Cloud** — Base tree contributions, pull requests, and collaborative development
- 🔐 **KoaaN** — Decryption support and V36 prebuilt assistance
- 🧩 **Sharp shooter** — Device tree refinements and base tree modifications
- 📦 **egaschnsk** — `vendor_boot` implementation references
- 😭 **Aditya Prasad** — For absolutely no documented reason whatsoever (still not sure why bro is here 😐)
- ✨ **Sairaj** - For testing,help & support with Building 
- 🎊 And all Testers

- Helps are not judged by placing (first-last) everybody helped & i appreciate all of them ♥️🎊
<br>

<p align="center">
  <sub>❤️ Thanks to everyone who contributed, tested, advised, or simply helped along the way.</sub>
</p>

---
