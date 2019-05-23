#!/vendor/bin/sh 

sleep 35;

#  CPU_BOOST default config
	echo 1 > /sys/module/cpu_boost/parameters/input_boost_enabled
	echo "0:0 1:0 2:0 3:0 4:0 5:0 6:0 7:0" > /sys/module/cpu_boost/parameters/input_boost_freq
	echo 0 > /sys/module/cpu_boost/parameters/input_boost_ms
