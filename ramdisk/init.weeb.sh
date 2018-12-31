#!/system/bin/sh

sleep 25;

# Setup Schedutil Governor
	echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	echo 500 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us
	echo 20000 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
	echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/iowait_boost_enable

	echo "schedutil" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor	
	echo 500 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us
	echo 20000 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us
	echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/iowait_boost_enable

# Input boost and stune configuration
	echo "0:1036800 1:0 2:0 3:0 4:1056000 5:0 6:0 7:0" > /sys/module/cpu_boost/parameters/input_boost_freq
	echo 600 > /sys/module/cpu_boost/parameters/input_boost_ms
	echo 40 > /sys/module/cpu_boost/parameters/dynamic_stune_boost

# Set min cpu freq
	echo 518400 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo 806400 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq

# Enable PEWQ
	echo Y > /sys/module/workqueue/parameters/power_efficient

# Disable Touchboost
	echo 1 > /sys/module/msm_performance/parameters/touchboost

# Set default schedTune value for foreground/top-app
	echo 1 > /dev/stune/foreground/schedtune.prefer_idle
	echo 5 > /dev/stune/top-app/schedtune.boost
	echo 15 > /dev/stune/top-app/schedtune.sched_boost
	echo 1 > /dev/stune/top-app/schedtune.prefer_idle

# Setup EAS cpusets values for better load balancing
	echo 0-7 > /dev/cpuset/top-app/cpus
	echo 0-3,6-7 > /dev/cpuset/foreground/boost/cpus
	echo 0-3,6-7 > /dev/cpuset/foreground/cpus
	echo 0-1 > /dev/cpuset/background/cpus
	echo 0-3  > /dev/cpuset/system-background/cpus

# For better screen off idle
	echo 0-3 > /dev/cpuset/restricted/cpus

# Adjust runtime fs
	echo 128 > /sys/block/sda/queue/read_ahead_kb
	echo 128 > /sys/block/sda/queue/nr_requests
	echo 1 > /sys/block/sda/queue/iostats


	echo 128 > /sys/block/sde/queue/read_ahead_kb
	echo 128 > /sys/block/sde/queue/nr_requests
	echo 1 > /sys/block/sde/queue/iostats

	echo 128 > /sys/block/sdf/queue/read_ahead_kb
	echo 128 > /sys/block/sdf/queue/nr_requests
	echo 1 > /sys/block/sdf/queue/iostats

	echo 128 > /sys/block/dm-0/queue/read_ahead_kb
	echo 128 > /sys/block/dm-0/queue/nr_requests
	echo 1 > /sys/block/dm-0/queue/iostats

# Adjust LMK Values
	echo "18432,23040,27648,32256,55296,80640" > /sys/module/lowmemorykiller/parameters/minfree

# Disable USB Fast Charge by default
	echo 0 > /sys/kernel/fast_charge/force_fast_charge