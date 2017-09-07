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

echo "===>Testing model_1024k_100read_0random_${DEV}_$DEPTH"
fio -filename=$FIO_IOBOW_FILE -direct=1 -rw=read -bs=1024k -size=50G -iodepth=$DEPTH -ioengine=libaio -numjobs=1 -group_reporting -name=model_1024k_100read_${DEV}_$DEPTH --output=$RESULT_DIR/model_1024k_100read_${DEV}_$DEPTH.log -ramp_time=20 -time_based -runtime=300
