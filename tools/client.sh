#!/bin/bash
DIR="$( cd "$( dirname "$0"  )" && pwd  )"
RESULT_HOME=$DIR/result
RESULT_DIR=$DIR/result/raw/net
if [ $# -ne 2 ]
then
    echo "Usage: sh $0 <server_ip> <time>"
    exit 1
fi

ip=$1
TIME=$2
tcp_len=(1440)
udp_len=(64)
kill netperf;pkill qperf;pkill iperf
sleep 1
let sleep_time=$TIME+22
for len in ${tcp_len[@]}
do
    echo "===>Testing tcp bandwidth,packet len = $len..."
    netperf -H $ip -t TCP_STREAM -l $TIME -- -m $len > $RESULT_DIR/netperf_tcp_$len.log &
    sleep $sleep_time
	echo "===>Testing tcp latency,packet len = $len..."
    qperf $ip -t $TIME -m $len -vu tcp_lat > $RESULT_DIR/qperf_tcp_$len.log &
    sleep $sleep_time
done

for len in ${udp_len[@]}
do
    echo "===>Testing udp bandwidth,packet len = $len..."
    netperf -H $ip -t UDP_STREAM -l $TIME -- -m $len -R 1 > $RESULT_DIR/netperf_udp_$len.log &
    sleep $sleep_time
	echo "===>Testing udp latency,packet len = $len..."
    qperf $ip -t $TIME -m $len -vu udp_lat > $RESULT_DIR/qperf_udp_$len.log &
    sleep $sleep_time
done

echo "=========>start parse result... ================="
echo "--------result---------" >> $RESULT_DIR/net_raw.csv

title=""
title1=""
for len in ${tcp_len[@]}
do
    title="$title tcp_${len}_bw"
	title1="$title1 tcp_${len}_lat"
done
title="$title $title1"

title2=""
title3=""
title4=""
for len in ${udp_len[@]}
do
    title2="$title2 udp_${len}_bw"
	title3="$title3 udp_${len}_lat"
	title4="$title4 udp_${len}_pps"
done
title2="$title2 $title3 $title4"
title="$title $title2"
if [ -f $RESULT_HOME/net.csv ]
then
    tmp=`cat $RESULT_HOME/net.csv | grep tcp`
	if [ "$tmp" == "" ]
	then
	    echo $title > $RESULT_HOME/net.csv
	fi
else
    echo $title > $RESULT_HOME/net.csv
fi

result=""
for len in ${tcp_len[@]}
do
	tcp_bw=`tail -1 $RESULT_DIR/netperf_tcp_${len}.log | awk -F " " '{print $5}'`
    echo tcp_bandwidth_$len=$tcp_bw >> $RESULT_DIR/net_raw.csv
    result="$result $tcp_bw"	
   done
for len in ${tcp_len[@]}
do	
	tcp_lat=`cat $RESULT_DIR/qperf_tcp_${len}.log | grep latency | awk -F "=" '{print $2}'|tr -d " "`
	echo tcp_latency_$len=$tcp_lat >> $RESULT_DIR/net_raw.csv	
	result="$result $tcp_lat"
done

#for len in ${udp_len[@]}
#do
#	udp_bw=`tac $RESULT_DIR/netperf_udp_${len}.log  |sed -n 2p|awk -F " " '{print $4}'`
#	echo udp_bandwidth_$len=$udp_bw >> $RESULT_DIR/net_raw.csv	
#	result="$result $udp_bw"
#done

#for len in ${udp_len[@]}
#do
#	udp_lat=`cat $RESULT_DIR/qperf_udp_${len}.log | grep latency | awk -F "=" '{print $2}'|tr -d " "`
#	echo udp_lat_$len=$udp_lat >> $RESULT_DIR/net_raw.csv
#	result="$result $udp_lat"
#done		
    
for len in ${udp_len[@]}
do
	udp_pps=`tac $RESULT_DIR/netperf_udp_${len}.log |sed -n 2p|awk -F " " '{print $3}'`
	let udp_pps=$udp_pps/$TIME
	echo udp_pps_$len=$udp_pps >> $RESULT_DIR/net_raw.csv
	result="$result $udp_pps"
done

echo $result >> $RESULT_HOME/net.csv
#for len in ${udp_len[@]}
#do
#	udp_pps=`tac $RESULT_DIR/netperf_udp_${len}.log |sed -n 2p|awk -F " " '{print $3}'`
#	
#    udp_lost=`tac $RESULT_DIR/netperf_udp_${len}.log |sed -n 3p|awk -F " " '{print $4}'`
#    let udp_lost1=$udp_lost-$udp_pps
#    udp_lost=`gawk -v p=$udp_lost1 -v q=$udp_lost 'BEGIN{printf "%.2f\n",p/q}'`
#	echo udp_lost_$len=$udp_lost >> $RESULT_DIR/net_raw.csv
#done

echo "Test end, result is in $RESULT_HOME/net.csv,raw result is in $RESULT_DIR"
