#!/system/bin/sh

sleep 35;

# CAF CPU boost and stune configuration
	echo 1 > /sys/module/cpu_boost/parameters/input_boost_enabled
	echo "0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0" > /sys/module/cpu_boost/parameters/input_boost_freq
	echo 0 > /sys/module/cpu_boost/parameters/input_boost_ms
	echo 0 > /sys/module/cpu_boost/parameters/dynamic_stune_boost
	echo 0 > /sys/module/cpu_boost/parameters/dynamic_stune_boost_ms

# Set default schedtune values for various cgroups
	echo 1 > /dev/stune/foreground/schedtune.prefer_idle
	echo 0 > /dev/stune/background/schedtune.boost
	echo 1 > /dev/stune/top-app/schedtune.boost
	echo 0 > /dev/stune/top-app/schedtune.sched_boost
	echo 1 > /dev/stune/top-app/schedtune.prefer_idle

# kang pixel 3 cpusets
	echo 0-7 > /dev/cpuset/audio-app/cpus
	echo 0-1 > /dev/cpuset/background/cpus
	echo 0-7 > /dev/cpuset/camera-daemon/cpus
	echo 0-3,6-7 > /dev/cpuset/foreground/cpus
	echo 0-3 > /dev/cpuset/restricted/cpus
	echo 0-1,6-7 > /dev/cpuset/system/cpus
	echo 0-3 > /dev/cpuset/system-background/cpus
	echo 0-7 > /dev/cpuset/top-app/cpus

# Adjust LMK Values
	echo "18432,23040,27648,32256,55296,80640" > /sys/module/lowmemorykiller/parameters/minfree
