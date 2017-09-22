DEPTH=1
for line in $(<dev.txt)
do
    file=result/$2/rtt_8k_100read_${line}_$DEPTH.log
	fio -filename=/dev/$line -direct=1 -rw=read -bs=8k -size=50G -iodepth=$DEPTH -ioengine=libaio -numjobs=1 -group_reporting -name=model_8k_100read_${line}_$DEPTH --output=$file -ramp_time=20 -time_based -runtime=$1 &
done
