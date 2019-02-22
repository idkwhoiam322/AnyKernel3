#!/system/bin/sh

sleep 35;


# kcal config
	chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal
	chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_cont
	chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_hue
	chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_sat
	chmod 0664 /sys/devices/platform/kcal_ctrl.0/kcal_val

# set cpu permissions
	chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	chmod 0664 /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
	chmod 0664 /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
	chmod 0664 /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor

# Setup Schedutil Governor
	echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	echo 500 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us
	echo 20000 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
	echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/iowait_boost_enable

	echo "schedutil" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor	
	echo 500 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us
	echo 20000 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us
	echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/iowait_boost_enable

# Input boost and stune configuration [We are using Sultan's CPU Input Boost now]
	echo "0:1036800 1:0 2:0 3:0 4:1056000 5:0 6:0 7:0" > /sys/module/cpu_boost/parameters/input_boost_freq
	echo 500 > /sys/module/cpu_boost/parameters/input_boost_ms
	echo 15 > /sys/module/cpu_boost/parameters/dynamic_stune_boost
	echo 1500 > /sys/module/cpu_boost/parameters/dynamic_stune_boost_ms

# Enable PEWQ
	echo Y > /sys/module/workqueue/parameters/power_efficient

# Set default schedTune value for foreground/top-app
	echo 1 > /dev/stune/foreground/schedtune.prefer_idle
# My reason for the top-app schedtune.boost being zero is that we do not really need any boosting when nothing significant is going on, for example, watching a youtube video, or the network indicator changing every second or so. For this reason, I have set it to 0, it does not seem to affect UX in my testing and should be just fine.
	echo 0 > /dev/stune/top-app/schedtune.boost
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

# Adjust runtime fs to improve performance based on pixel settings. 2048 best for boot speed, 128 best for performance.
	echo "cfq" > /sys/block/sda/queue/scheduler
	echo 128 > /sys/block/sda/queue/read_ahead_kb
	echo 128 > /sys/block/sda/queue/nr_requests
	echo "cfq" > /sys/block/sde/queue/scheduler
	echo 128 > /sys/block/sde/queue/read_ahead_kb
	echo 128 > /sys/block/sde/queue/nr_requests
	echo "cfq" > /sys/block/sdf/queue/scheduler
	echo 128 > /sys/block/sdf/queue/read_ahead_kb
	echo 128 > /sys/block/sdf/queue/nr_requests
	echo 128 > /sys/block/dm-0/queue/read_ahead_kb

# Adjust LMK Values
	echo "18432,23040,27648,32256,55296,80640" > /sys/module/lowmemorykiller/parameters/minfree

# Disable USB Fast Charge by default
	echo 0 > /sys/kernel/fast_charge/force_fast_charge

# Configure ZRAM
	echo 8 > /proc/sys/vm/swappiness
	echo 5 > /proc/sys/vm/dirty_ratio
	echo 2 > /proc/sys/vm/dirty_background_ratio

# Disable perfd
#	stop perf-hal-1-0