DEPTH=32
for line in $(<dev.txt)
do
    file=result/$2/bw_1024k_100write_${line}_$DEPTH.log
    fio -filename=/dev/$line -direct=1 -rw=write -bs=1024k -size=50G -iodepth=$DEPTH -ioengine=libaio -numjobs=1 -group_reporting -name=model_1024k_100write_${line}_$DEPTH --output=$file -ramp_time=20 -time_based -runtime=$1 &
done
