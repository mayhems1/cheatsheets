# MegaRaid tool megacli

## Retrieved from links

* [MegaRaid SAS Software User Guide](https://www.supermicro.com/manuals/other/MegaRAID_SAS_Software_Rev_I_UG.pdf)
* [MegaCli reports an inconsistent number of physical disks](https://serverfault.com/questions/835073/megacli-reports-an-inconsistent-number-of-physical-disks?rq=1)
* [MegaCLI cheatsheet](http://erikimh.com/megacli-cheatsheet)
* [MegaCLI Error Messages](https://www.thomas-krenn.com/de/wiki/MegaCLI_Error_Messages)
* [MegaRAID Event Messages](https://www.thomas-krenn.com/de/wiki/MegaRAID_Event_Messages)
* [SCSI Key Code Qualifier](https://en.wikipedia.org/wiki/Key_Code_Qualifier)
* [шпаргалка по megacli](https://wiki.colobridge.net/%D0%BF%D0%BE%D0%BB%D0%B5%D0%B7%D0%BD%D0%BE%D0%B5/%D1%81%D0%BE%D0%B2%D0%B5%D1%82%D1%8B/%D1%88%D0%BF%D0%B0%D1%80%D0%B3%D0%B0%D0%BB%D0%BA%D0%B0_%D0%BF%D0%BE_megacli)
* [MegaCli Common Commands](https://support.siliconmechanics.com/portal/en/kb/articles/megacli-common-commands)

## Some examples how to use megacli

```bash
# Example of alias
alias megacli='/opt/MegaRAID/MegaCli/MegaCli64'

# verify the RAID array and MegaCli version:

sudo /opt/MegaRAID/MegaCli/MegaCli64 -adpallinfo -aALL

sudo /opt/MegaRAID/MegaCli/MegaCli64 -adpallinfo -aALL | grep "Product Name"
Product Name    : LSI MegaRAID SAS 9265-8i

sudo /opt/MegaRAID/MegaCli/MegaCli64 -CfgDsply -a0 | grep 'RAID Level'
RAID Level          : Primary-5, Secondary-0, RAID Level Qualifier-3

sudo /opt/MegaRAID/MegaCli/MegaCli64 -v

      MegaCLI SAS RAID Management Tool  Ver 8.04.07 May 28, 2012

    (c)Copyright 2011, LSI Corporation, All Rights Reserved.

Exit Code: 0x00

# Get information about the drives in the array:

sudo /opt/MegaRAID/MegaCli/MegaCli64 -adpallinfo -a0 | grep -A8 "Device Present"

                    Device Present
                    ================
    Virtual Drives    : 1
      Degraded        : 0
      Offline         : 0
    Physical Devices  : 27
      Disks           : 24
      Critical Disks  : 0
      Failed Disks    : 0

megacli ShowSummary -aALL

# Check for S.M.A.R.T. alerts:
sudo /opt/MegaRAID/MegaCli/MegaCli64 -PDList -aALL | grep 'S.M.A.R.T.'
Drive has flagged a S.M.A.R.T alert : No
Drive has flagged a S.M.A.R.T alert : No
[...]
Drive has flagged a S.M.A.R.T alert : No
Drive has flagged a S.M.A.R.T alert : No


# flash bios
MegaCli -adpfwflash -f /scripts/firmware/lsi_imr_fw.rom -aALL
MegaCli -adpfwflash -f imr_fw.rom -NoVerChk -aAll
MegaCli -adpfacdefset -aALL # reset to factory default

# controller info
MegaCli -AdpAllinfo -aALL
MegaCli -PDGetNum -a0 # nubmer of discs
MegaCli -PDInfo -PhysDrv [64:0] -aALL
MegaCli -PDMakeJBOD -PhysDrv[64:4]

# clear controller config to defaults
MegaCli -CfgClr -aALL

# delete all
MegaCli -CfgLdDel -LALL -aALL

# create raid
MegaCli -CfgLdAdd -r5 [64:0, 64:1, 64:2, 64:3] -a0
MegaCli -CfgLdAdd -r0 [64:4,64:5,64:6,64:7] -a0

# get disk location
MegaCli -PDList -a0 | grep -e '^Enclosure Device ID:' -e '^Slot Number:'

# get raid info
MegaCli -LDInfo -Lall -aALL
MegaCli -PDMakeGood -PhysDrv[64:4] -force -aALL > /dev/null
MegaCli -PDMakeGood -PhysDrv[64:5] -force -aALL > /dev/null
MegaCli -PDMakeGood -PhysDrv[64:6] -force -aALL > /dev/null
MegaCli -PDMakeGood -PhysDrv[64:7] -force -aALL > /dev/null
MegaCli -PDMakeJBOD -PhysDrv[64:4,64:5,64:6,64:7] -a0
MegaCli -CfgLdAdd -r0 [64:4,64:5,64:6,64:7] -a0
MegaCli -AdpEventLog -GetEvents -f logfile -aALL # Dump all events from the adapters event log to a file named logfile
MegaCli -PDList -aAll # Dump information about all Phsyical Disks
MegaCli -LDInfo -LAll -aAll # Dump information about all Logical Disks on all adapters
MegaCli -LdPdInfo -aAll # Dump information of all logical and physical disks on all known adapters
MegaCli -AdpSetProp -EnableJBOD 1 -aALL
MegaCli -CfgDsply -aAll

# adapter diagnostic
MegaCli -AdpDiag -a0

# Controller information
MegaCli -AdpAllInfo -aALL
MegaCli -CfgDsply -aALL
MegaCli -AdpEventLog -GetEvents -f events.log -aALL && cat events.log

# Enclosure information
MegaCli -EncInfo -aALL

# Virtual drive information
MegaCli -LDInfo -Lall -aALL

# Physical drive information
MegaCli -PDList -aALL
MegaCli -PDInfo -PhysDrv [E:S] -aALL

# Battery backup information
MegaCli -AdpBbuCmd -aALL

# Controller management

# Silence active alarm
MegaCli -AdpSetProp AlarmSilence -aALL

# Disable alarm
MegaCli -AdpSetProp AlarmDsbl -aALL

# Enable alarm
MegaCli -AdpSetProp AlarmEnbl -aALL

# Physical drive management

# Set state to offline
MegaCli -PDOffline -PhysDrv [E:S] -aN

# Set state to online
MegaCli -PDOnline -PhysDrv [E:S] -aN

# Mark as missing
MegaCli -PDMarkMissing -PhysDrv [E:S] -aN

# Prepare for removal
MegaCli -PdPrpRmv -PhysDrv [E:S] -aN

# Replace missing drive
MegaCli -PdReplaceMissing -PhysDrv [E:S] -ArrayN -rowN -aN

# Rebuild drive
MegaCli -PDRbld -Start -PhysDrv [E:S] -aN
MegaCli -PDRbld -Stop -PhysDrv [E:S] -aN
MegaCli -PDRbld -ShowProg -PhysDrv [E:S] -aN

# Clear drive
MegaCli -PDClear -Start -PhysDrv [E:S] -aN
MegaCli -PDClear -Stop -PhysDrv [E:S] -aN
MegaCli -PDClear -ShowProg -PhysDrv [E:S] -aN
MegaCli -PDMakeGood -PhysDrv[E:S] -aN

# This changes drive in state Unconfigured-Bad to Unconfigured-Good.

# Set the drive offline, if it is not already offline due to an error
MegaCli -PDOffline -PhysDrv [E:S] -aN

# Mark the drive as missing
MegaCli -PDMarkMissing -PhysDrv [E:S] -aN

# Prepare drive for removal
MegaCli -PDPrpRmv -PhysDrv [E:S] -aN

# using hot spares drive
MegaCli -PDHSP -Set -PhysDrv [E:S] -aN

# re-add the new drive to your RAID virtual drive and start the rebuilding
MegaCli -PdReplaceMissing -PhysDrv [E:S] -ArrayN -rowN -aN
MegaCli -PDRbld -Start -PhysDrv [E:S] -aN
MegaCli -CfgLdAdd -r0 [0:1, 0:1] -a0
MegaCli -LDInfo -Lall -aALL

# View all controleler informations
MegaCli -AdpAllInfo -aAll

MegaCli -LDSetProp CachedBadBBU -LALL -aALL

# Delete all devices
MegaCli -CfgLdDel -LALL -aALL

MegaCli -CfgLdAdd -r1 [252:0,252:1] -a0

MegaCli -CfgLdAdd -r10 [252:0,252:1,252:2,252:3] -a0

# create RAID5
MegaCli -CfgLdAdd -r5 [64:0,64:1,64:2,64:3] -a0

# create RAID10
MegaCli -CfgSpanAdd -r10 -Array0[64:0,64:1] -Array1[64:2,64:3] -a0

# create RAID10
MegaCli -AdpSetProp -EnableJBOD 1

# Enable disks cache
MegaCli -LDSetProp EnDskCache -LAll -aAll

# Force flash
MegaCli -adpfwflash -f ./12.12.0-0111.rom -NoVerChk -a0

# load controller defauts
MegaCli -adpfacdefset -aALL

sudo /opt/MegaRAID/MegaCli/MegaCli64 -ldinfo -lall -a0 | grep Drives
Number Of Drives    : 23

sudo /opt/MegaRAID/MegaCli/MegaCli64 -CfgDsply -aALL | grep -Pi 'SPAN|Span\ Ref|Number\ of'
Number of DISK GROUPS: 1


# Get an event logfile

sudo /opt/MegaRAID/MegaCli/MegaCli64 -adpeventlog -getevents -f lsi-events.log -a0 -nolog
cat lsi-events.log | grep -P -i 'fail|error|warn'

## Some commands 2

/MegaCli64 -FwTermLog -Dsply -aALL > /tmp/ttylog.txt

# Creates the RAID controller log (ttylog)

./MegaCli64 -PDList -aALL > /tmp/disks.txt

# Creates a list with information about the RAID controllers, virtual disks and hard disks installed

./MegaCli64 -LDInfo -LALL -aALL > /tmp/LDinfo.txt

# Creates a list with information about existing RAID volumes and configurations

./MegaCli64 -AdpAllInfo -aALL > /tmp/Adapterinfo.txt

# Creates a list with information about RAID controller settings

./MegaCli64 -AdpBbuCmd -aALL > /tmp/Battery.txt

# Creates a detailed list of the battery status of the RAID controller (state of charge, learning cycle, etc.)

./MegaCli64 -AdpEventLog -IncludeDeleted -f deleted.txt -aALL

# Creates the RAID controller log (ttylog) with all information since very first controller initialization
(Note: This file will always be saved in the MegaCLI root folder)

## Replace disk
megacli -pdoffline -physdrv[28:7] -a0
megacli -pdmarkmissing -physdrv[28:7] -aAll
megacli -pdprprmv -physdrv[28:7] -a0

## Locate/blink disk
megacli -PdLocate -start -physdrv[28:7] -a0

## Stop locate/blink disk
megacli -PdLocate -stop -physdrv[28:7] -a0

## Get status of rebuild
megacli -PDRbld -ShowProg -physdrv[28:7] -aALL

## blink disks
# start
for i in `megacli -PDList -aALL | egrep 'Slot Number' | awk -F: '{print $2}'`; do megacli -PdLocate -start -physdrv[0:$i] -a 0; done
# stop
for i in `megacli -PDList -aALL | egrep 'Slot Number' | awk -F: '{print $2}'`; do megacli -PdLocate -stop -physdrv[0:$i] -a 0; done
```
