#!/system/bin/sh

sleep 35;

# kang pixel 3 cpusets
	echo 0-7 > /dev/cpuset/audio-app/cpus
	echo 0-1 > /dev/cpuset/background/cpus
	echo 0-7 > /dev/cpuset/camera-daemon/cpus
	echo 0-3,6-7 > /dev/cpuset/foreground/cpus
	echo 0-3 > /dev/cpuset/restricted/cpus
	echo 0-1,6-7 > /dev/cpuset/system/cpus
	echo 0-3 > /dev/cpuset/system-background/cpus
	echo 0-7 > /dev/cpuset/top-app/cpus
