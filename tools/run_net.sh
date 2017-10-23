#!/bin/bash

DIR="$( cd "$( dirname "$0"  )" && pwd  )"


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

mkdir -p $DIR/result/raw
net_run
