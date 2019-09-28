# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Weeb Kernel by idkwhoiam322
do.devicecheck=1
do.modules=1
do.cleanup=1
do.cleanuponabort=1
device.name1=OnePlus5T
device.name2=dumpling
device.name3=OnePlus5
device.name4=cheeseburger
device.name5=
supported.versions=9.0 - 10
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;

# Check if user is on OxygenOS or Cutom ROM
userflavor="$(file_getprop /system/build.prop "ro.build.user"):$(file_getprop /system/build.prop "ro.build.flavor")";
case "$userflavor" in
  "OnePlus:OnePlus5-user"|"OnePlus:OnePlus5T-user")
    os="oos";
    os_string="OxygenOS";;
  *)
    os="custom";
    os_string="a custom ROM";;
esac;
ui_print " ";
ui_print "You are on $os_string!";

## begin vendor changes
mount -o rw,remount -t auto /vendor >/dev/null;

# Make a backup of vendor build.prop
restore_file /vendor/build.prop;
backup_file /vendor/build.prop;

## AnyKernel install
dump_boot;

# Add skip_override parameter to cmdline so user doesn't have to reflash Magisk
# Get Android version
android_version="$(file_getprop /system/build.prop "ro.build.version.release")";
# Do not do this for Android 10 ( A only SAR )
if [ "$android_version" != "10" ]; then
  if [ -d $ramdisk/.backup ]; then
    ui_print " "; ui_print "Magisk detected! Patching cmdline so reflashing Magisk is not necessary...";
    patch_cmdline "skip_override" "skip_override";
  else
    patch_cmdline "skip_override" "";
  fi;
else
   ui_print " "; ui_print "You are on android 10! Not performing Magisk preservation. Please reflash Magisk if you want to keep it.";
fi;

# Remove recovery service so that TWRP isn't overwritten
remove_section init.rc "service flash_recovery" ""

# end ramdisk changes

write_boot;
## end install

