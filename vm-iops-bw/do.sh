time=10
delay=$(($time+25))
echo $delay

sh 1.iops-8krandwrite.sh $time $1 $2
sleep $delay
sh 2.iops-8randread.sh $time $1 $2
sleep $delay
sh 3.bw-1024kwrite.sh $time $1 $2
sleep $delay
sh 4.bw-1024kread.sh $time $1 $2
sleep $delay
sh 5.rtt-8krandwrite.sh $time $1 $2
sleep $delay
sh 6.rtt-8krandread.sh $time $1 $2
sleep $delay
sh get-csv.sh $1 $2
