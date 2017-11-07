run_time=120
times=0
delay=$(($run_time+10))

date_str=`date +"%Y%m%d_%H%M%S"`
mkdir -p result/$date_str

pkill fio

for i in `seq 5`
do
  times=0
  for line in $(<dev.txt)
  do
    sh do.sh $run_time $date_str $line $delay &
        let times++
  done
  sleep $((($time+$delay)*6*$times+10*$times))
done
echo "=================done================="
