# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=WeebKernel by idkwhoiam322
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=OnePlus5T
device.name2=dumpling
device.name3=OnePlus5
device.name4=cheeseburger
device.name5=
supported.versions=9
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;

# Save the users from themselves
android_version="$(file_getprop /system/build.prop "ro.build.version.release")";
supported_version=9;
if [ "$android_version" != "$supported_version" ]; then
  ui_print " "; ui_print "You are on $android_version but this kernel is only for $supported_version!";
  exit 1;
fi;

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chmod 644 $ramdisk/modules/*;
chown -R root:root $ramdisk/*;


## AnyKernel install
dump_boot;

# begin ramdisk changes

insert_line init.rc "init.qcom.rc" after "import /init.usb.rc" "import /init.qcom.rc";

# Add skip_override parameter to cmdline so user doesn't have to reflash Magisk
if [ -d $ramdisk/.backup ]; then
  ui_print " "; ui_print "Magisk detected! Patching cmdline so reflashing Magisk is not necessary...";
  patch_cmdline "skip_override" "skip_override";
else
  patch_cmdline "skip_override" "";
fi;  

# Remove recovery service so that TWRP isn't overwritten
remove_section init.rc "service flash_recovery" ""

# end ramdisk changes

write_boot;

## end install

