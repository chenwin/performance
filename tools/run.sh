#!/bin/bash

DIR="$( cd "$( dirname "$0"  )" && pwd  )"


function geekbench3_run
{
    echo "======>Running Geekbench3, please wait for about one minute..."
    cd $DIR/geekbench3/dist/Geekbench-3.4.1-Linux
	CPU_INFO=`cat /proc/cpuinfo | grep "model name" | head -n 1 | awk -F ":" '{print $2}'`
	echo "CPUINFO= $CPU_INFO"
	mkdir -p $DIR/result/raw/geekbench3
	DATE=`date +"%Y%m%d_%H%M%S"`
    RESULT=$DIR/result/raw/geekbench3/runlog-$DATE
    ./geekbench_x86_64 -n | tee $RESULT
    
    int_s=`grep "Integer Score"        $RESULT | awk '{print $3}'` 
    int_m=`grep "Integer Score"        $RESULT | awk '{print $4}'`
    float_s=`grep "Floating Point Score" $RESULT | awk '{print $4}'` 
    float_m=`grep "Floating Point Score" $RESULT | awk '{print $5}'`
    mem_s=`grep "Memory Score"         $RESULT | awk '{print $3}'`
    mem_m=`grep "Memory Score"         $RESULT | awk '{print $4}'`
    score_s=`grep "Geekbench Score"      $RESULT | awk '{print $3}'`
    score_m=`grep "Geekbench Score"      $RESULT | awk '{print $4}'`
    #$DATE-$CPU_INFO $int_s $float_s $mem_s $score_s $int_m $float_m $mem_m $score_m
    echo $DATE-$CPU_INFO $int_s $float_s $int_m $float_m >> $DIR/result/geekbench.csv
	echo "===>geekbench3 run successful,result in $DIR/result/geekbench3.csv,raw result in $DIR/result/raw/geekbench3..."
}

function fio_run
{
    echo "======>Running fio, this will take a long time, please wait..."
    mkdir -p $DIR/result/raw/fio
	sh ${DIR}/all.sh
	if [ $? -ne 0 ]
	then
	    echo "!!!!![ERROR]:fio run failed,please check"
		exit 1
	else
	    echo "===>fio run successful,result in $DIR/result/raw/fio..."
	fi
}

function net_run
{
    echo "======>Running netperf, this will take a long time, please wait..."
    mkdir -p $DIR/result/raw/net
	if [ ! -f $DIR/config.conf ]
    then
        echo "[ERROR] config.conf do not exist, please check..."
    	exit 1
    fi
    SERVER_IP=`cat $DIR/config.conf |grep NETWORK_SERVER_IP= |awk -F "=" '{print $2}'`
	TIME=`cat $DIR/config.conf |grep NETWORK_TIME= |awk -F "=" '{print $2}'`
	echo "server_ip=$SERVER_IP,    time=$TIME"
	sh client.sh $SERVER_IP $TIME
	if [ $? -ne 0 ]
	then
	    echo "!!!!![ERROR]:net run failed,please check"
		exit 1
	else
	    echo "===>net run successful,result in $DIR/result/raw/net..."
	fi
}

function stream_run
{
    CPU_NUM=`more /proc/cpuinfo | grep "processor"|wc -l`
    export OMP_NUM_THREADS=$CPU_NUM
    
    DATE=`date +"%Y%m%d_%H%M%S"`
    mkdir -p $DIR/result/raw/stream
    RESULT=$DIR/result/raw/stream/runlog-$DATE
    
    stream | tee $RESULT
    
    copy=`grep "Copy:"        $RESULT | awk -F " " '{print $2}'` 
    scale=`grep "Scale:"        $RESULT | awk -F " " '{print $2}'`
    add=`grep "Add:" $RESULT | awk -F " " '{print $2}'` 
    triad=`grep "Triad:" $RESULT | awk -F " " '{print $2}'`
    copy_GB=`echo "scale=2;$copy/1024;" | bc`
    scale_GB=`echo "scale=2;$scale/1024;" | bc`
    add_GB=`echo "scale=2;$add/1024;" | bc`
    triad_GB=`echo "scale=2;$triad/1024;" | bc`
    echo "$copy_G $scale_G $add_G $triad_G" >> $DIR/result/stream.csv
    
}

function unixbench_run
{
    chmod -R 755 $DIR/UnixBench
    cd $DIR/UnixBench
    DATE=`date +"%Y%m%d_%H%M%S"`
    mkdir -p $DIR/result/raw/unixbench
    unixbench_log=$DIR/result/raw/unixbench/runlog-$DATE
    ./Run | tee $unixbench_log
    result=`grep "System Benchmarks Index Score" $unixbench_log | awk '{print $5}'`
    echo $result >> $DIR/result/unixbench.csv
    
}

function all_run
{
    #1.netperf/qperf run
    net_run
    
    #2.run geekbench3
    geekbench3_run
    
    #3.run fio
    fio_run
    
    #4.run stream
    stream_run
    
    #5.run unixbench
    #unixbench_run
}

mkdir -p $DIR/result/raw


echo "Please choose your test : "
echo "[1] Netperf test."
echo "[2] fio test."
echo "[3] Geekbench3 test."
echo "[4] stream test"
echo "[5] UnixBench test"
echo "[6] all 4 test above"

while true
do
    read -t 10 -p 'please choose:[1|2|3|4|5|6]' choice
    if [ $choice == 1 ]
	then
	    net_run
		break
	elif [ $choice == 2 ]
	then
	    fio_run
		break
	elif [ $choice == 3 ]
	then
	    geekbench3_run
		break
    elif [ $choice == 4 ]
    then
        stream_run
        break
    elif [ $choice == 5 ]
    then
        unixbench_run
        break
	elif [ $choice == 6 ]
	then
	    all_run
		break
	else
	    echo "Sorry, your choice is not correct."
		all_run
		break
	fi
done

#if [ $1 ]; then
#    if [ $1 == "geek3" ]; then
#         geekbench3_run
#    elif [ $1 == "fio" ]; then
#         fio_run
#    elif [ $1 == "net" ]; then
#         net_run
#    elif [ $1 == "-h" -o $1 == "--help" ]; then
#        echo "Usage: sh $0 [geek3|fio|net]"
#	    echo "For example : sh $0 geek3"
#        exit 1
#    else
#        echo "bad arg : $1...(~~)"
#		echo "Usage: sh $0 [geek3|fio|net]"
#	    echo "For example : sh $0 geek3"
#        exit 1
#    fi
#else
#    all_run
#fi



