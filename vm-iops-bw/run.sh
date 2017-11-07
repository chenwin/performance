run_time=$1
date_str=$2
dev=$3

sh 1.iops-8krandwrite.sh $run_time $date_str $dev
sleep $delay
sh 2.iops-8randread.sh $run_time $date_str $dev
sleep $delay
sh 3.bw-1024kwrite.sh $run_time $date_str $dev
sleep $delay
sh 4.bw-1024kread.sh $run_time $date_str $dev
sleep $delay
sh 5.rtt-8krandwrite.sh $run_time $date_str $dev
sleep $delay
sh 6.rtt-8krandread.sh $run_time $date_str $dev
sleep $delay
sh get-csv.sh $date_str $dev
