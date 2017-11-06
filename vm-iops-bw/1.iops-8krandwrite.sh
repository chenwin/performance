DEPTH=32
file=result/$2/iops_8k_100write_$3_$DEPTH.log
fio -filename=/dev/$3 -direct=1 -rw=randwrite -bs=8k -size=50G -iodepth=$DEPTH -ioengine=libaio -numjobs=1 -group_reporting -name=8k_100write_$3_$DEPTH --output=$file -ramp_time=20 -time_based -runtime=$1 &  
