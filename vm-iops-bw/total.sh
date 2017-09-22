time=10
delay=$(($time+25))
date_str=`date +"%Y-%m-%d_%I_%M_%S_%p"`
mkdir -p result/$date_str
echo $delay

pkill fio

sh 1.iops-8krandwrite.sh $time $date_str
sleep $delay
sh 2.iops-8randread.sh $time $date_str
sleep $delay
sh 3.bw-1024kwrite.sh $time $date_str
sleep $delay
sh 4.bw-1024kread.sh $time $date_str
sleep $delay
sh 5.rtt-8kwrite.sh $time $date_str
sleep $delay
sh 6.rtt-8kread.sh $time $date_str
sleep $delay

sh get-csv.sh $date_str


