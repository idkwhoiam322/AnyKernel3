# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=WeebKernel by idkwhoiam322
do.devicecheck=1
do.modules=1
do.cleanup=1
do.cleanuponabort=1
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
chown -R root:root $ramdisk/*;

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

## AnyKernel install
dump_boot;

# begin ramdisk changes

# Add skip_override parameter to cmdline so user doesn't have to reflash Magisk
if [ -d $ramdisk/.backup ]; then
  ui_print " "; ui_print "Magisk detected! Patching cmdline so reflashing Magisk is not necessary...";
  patch_cmdline "skip_override" "skip_override";
else
  patch_cmdline "skip_override" "";
fi;

# In case the user wants to disable underclock, set underclock to 0 (zero). Enable = 1, Disable = 0.
underclock=0;
if [ "$underclock" != "1" ]; then
  patch_cmdline "" "cpufreq.disable_underclock=1";
else
  patch_cmdline "cpufreq.disable_underclock=1" "";  
fi

# Remove recovery service so that TWRP isn't overwritten
remove_section init.rc "service flash_recovery" ""

# end ramdisk changes

write_boot;

ui_print "Please DO NOT flash Magisk AFTER the kernel! Flash it BEFORE ONLY. Flashing it after will wipe the ramdisk changes! The kernel preserves Magisk already :)";

## end install

