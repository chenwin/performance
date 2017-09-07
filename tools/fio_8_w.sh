#!/bin/bash

DIR="$( cd "$( dirname "$0"  )" && pwd  )"
RESULT_DIR=$DIR/result/raw/fio

if [ $# -ne 3 ]
then
    echo "Usage:$0 /dev/xvde <DEPTH> xvde"
    exit 1
fi

FIO_IOBOW_FILE=$1
DEPTH=$2
DEV=$3

echo "===>Testing model_8k_0read_100random_${DEV}_${DEPTH}depth..."
fio -filename=$FIO_IOBOW_FILE -direct=1 -rw=randwrite -bs=8k -size=50G -iodepth=$DEPTH -ioengine=libaio -numjobs=1 -group_reporting -name=model_8k_0read_${DEV}_$DEPTH --output=$RESULT_DIR/model_8k_0read_${DEV}_$DEPTH.log -ramp_time=20 -time_based -runtime=300
	
			
