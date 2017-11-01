#!/bin/sh
echo -------------kernel--------------------
cat /etc/sysctl.conf |grep -v '#'
echo -------------limit--------------------
cat /etc/security/limits.conf |grep -v '#'
echo -------------virtualization--------------------
dmidecode -s system-product-name
echo -------------lscpu--------------------
lscpu
echo swappiness
cat /proc/sys/vm/swappiness
echo ===================================================================================================

echo -------------CPU INFO--------------------
cat /proc/cpuinfo
sleep 2

if [ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors ];then
	cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
fi

which lmbenck > /dev/null 2>&1
if [ $? -eq 0 ];then
	lmbench
else
	echo "Pls install lmbench package!"
fi

echo -------------SYS THREAD-------------------
cat /proc/sys/kernel/threads-max

echo -------------CPU SCHED INFO---------------
cat /proc/sys/kernel/sched_min_granularity_ns
cat /proc/sys/kernel/sched_latency_ns
cat /proc/sys/kernel/sched_wakeup_granularity_ns
cat /proc/sys/kernel/sched_child_runs_first
cat /proc/sys/kernel/sched_features
cat /proc/sys/kernel/sched_cfs_bandwidth_slice_us
cat /proc/sys/kernel/sched_rt_period_us
cat /proc/sys/kernel/sched_rt_runtime_us
cat /proc/sys/kernel/sched_compat_yield
cat /proc/sys/kernel/sched_migration_cost
cat /proc/sys/kernel/sched_nr_migrate
cat /proc/sys/kernel/sched_tunable_scaling

echo --------------SHARED MEM INFO-------------
cat /proc/sys/kernel/shmall
cat /proc/sys/kernel/shmmax
cat /proc/sys/kernel/shmmni

echo --------------MEM INFO--------------------
cat /proc/meminfo

echo --------------VIRTUAL MEM INFO------------
cat /proc/sys/vm/dirty_background_ratio
cat /proc/sys/vm/dirty_expire_centisecs
cat /proc/sys/vm/dirty_ratio
cat /proc/sys/vm/dirty_writeback_centisecs
cat /proc/sys/vm/vfs_cache_pressure
cat /proc/sys/vm/min_free_kbytes
cat /proc/sys/vm/overcommit_memory
cat /proc/sys/vm/overcommit_ratio

echo --------------STORAGE INFO----------------
fdisk -l | grep Disk | grep dev | awk -F: '{print $1}' | awk -F/ '{print $3}' > diskinfo.txt

while read disk
do
	echo $disk
	cat /sys/block/$disk/queue/scheduler
	cat /sys/block/$disk/queue/max_segments
	cat /sys/block/$disk/queue/max_sectors_kb
	echo ""
done < diskinfo.txt

rm diskinfo.txt

echo --------------MOUNT INFO------------------
mount

echo --------------NET BUFFER INFO-------------
cat /proc/sys/net/core/rmem_max
cat /proc/sys/net/core/rmem_default
cat /proc/sys/net/core/wmem_max
cat /proc/sys/net/core/wmem_default
cat /proc/sys/net/core/netdev_max_backlog
cat /proc/sys/net/core/optmem_max

echo --------------TCP CONFIG INFO-------------
cat /proc/sys/net/ipv4/tcp_rmem
cat /proc/sys/net/ipv4/tcp_wmem
cat /proc/sys/net/ipv4/tcp_mem
cat /proc/sys/net/ipv4/tcp_timestamps
cat /proc/sys/net/ipv4/tcp_sack
cat /proc/sys/net/ipv4/tcp_fack
cat /proc/sys/net/ipv4/tcp_window_scaling
cat /proc/sys/net/ipv4/tcp_tw_reuse
cat /proc/sys/net/ipv4/tcp_tw_recycle
cat /proc/sys/net/ipv4/tcp_retries2
cat /proc/sys/net/ipv4/tcp_keepalive_time
cat /proc/sys/net/ipv4/tcp_keepalive_probes
cat /proc/sys/net/ipv4/tcp_keepalive_intvl
cat /proc/sys/net/ipv4/tcp_fin_timeout
cat /proc/sys/net/ipv4/tcp_syncookies
cat /proc/sys/net/ipv4/tcp_max_syn_backlog
cat /proc/sys/net/ipv4/ip_local_port_range


echo -------------NETCARD INFO----------------
ifconfig |grep eth |grep -v ether| awk '{print $1}' | sed 's/://' > netcards.txt
while read netcard
do
	echo $netcard
	ifconfig $netcard
	ethtool -i $netcard
	echo ""
done < netcards.txt
rm netcards.txt

echo -------------VIRTUALIZATION INFO---------
lsmod |grep xen

lsmod |grep virtio

echo ------------VIRTUALIZATION VERSION-------
dmidecode -t bios

echo ------------OS INFO----------------------
cat /etc/issue.net
uname -a

echo ------------NUMA INFO--------------------
numactl --hardware

