DEPTH=1
file=result/$2/rtt_8k_100read_$3_$DEPTH.log
fio -filename=/dev/$3 -direct=1 -rw=read -bs=8k -size=50G -iodepth=$DEPTH -ioengine=libaio -numjobs=1 -group_reporting -name=model_8k_100read_$3_$DEPTH --output=$file -ramp_time=20 -time_based -runtime=$1 &
