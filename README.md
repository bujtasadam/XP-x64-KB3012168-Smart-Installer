![Downloads](https://img.shields.io/github/downloads/bujtasadam/XP-x64-KB3012168-Smart-Installer/total) ![License](https://img.shields.io/github/license/bujtasadam/XP-x64-KB3012168-Smart-Installer)

# XP-x64-KB3012168-Smart-Installer

An automated batch script helper to successfully install the **KB3012168** (GDI+ Security Update) on **Windows XP Professional x64 Edition** (NT 5.2 architecture) without manual file copying or facing installer prerequisite blockages.

## The Problem
When trying to patch Windows XP x64 or Windows Server 2003 using the `WindowsEmbedded\PosReady` registry trick, the official Microsoft update package for **KB3012168** fails with an unbypassable prerequisite validation error logged in `KB3012168.log` as:
`Second Condition in Vbscriptdll.AndOp.Section Failed`

This happens because the Microsoft `update.exe` script engine strictly checks the `vbscript.dll` version file structure and denies execution if a newer Internet Explorer (like IE8) environment is present. Modifying the `update.inf` configuration file directly triggers file integrity check failures (`STR_FAILED_INF_INTEGRITY`).

## The Smart Solution
This script circumvents the obstacle elegantly by:
1. Backing up your current IE8-compatible VBScript engine files.
2. Temporarily swapping them inside `System32`, `SysWOW64`, and the hidden `DllCache` directory with the legacy version bundled inside the hotfix payload (`SP2QFE`).
3. Running the **unmodified, digitally signed original Microsoft update executable** using advanced switches (`/passive /norestart /f /o`).
4. Instantly restoring your original high-version VBScript dll files back to their safe paths once registration completes.

As a result, the update is natively registered into the Registry database and cleanly logged under Windows Updates.

## How To Use
1. Download the script repository.
2. Download the official untouched x64 patch from the Microsoft Catalog archive: 
   * **Filename:** `WindowsServer2003-KB3012168-x64-ENU.exe`
3. Place the official `.exe` file right next to the `installer.bat` script.
4. Right-click `installer.bat` and **Run as Administrator**.
5. *Note:* If the Windows File Protection (WFP) graphic prompt pops up during the process, click **Cancel**, then **Yes** to preserve the script's temporary files.
6. Reboot your machine once finished.

## Legal Disclaimer
This repository **does not contain any proprietary Microsoft binaries** or copyrighted material. It only provides a configuration wrapper script. Users must download the original update package independently through official channels.
