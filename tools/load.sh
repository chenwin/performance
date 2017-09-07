#!/bin/bash

DIR="$( cd "$( dirname "$0"  )" && pwd  )"
RESULT_HOME=$DIR/result
RESULT_DIR=$DIR/result/raw/fio

if [ $# -ne 2 ]
then
    echo "Usage:sh load.sh xvd* depth"
    exit 1
fi

FIO_IOBOW_FILE=$1
DEPTH=$2

echo "===>start parsing result, device is $FIO_IOBOW_FILE , Depth = $DEPTH ..."
date_str=`date +"%Y-%m-%d_%I_%M_%S_%p"`
iops1=`cat $RESULT_DIR/model_1024k_0read_${FIO_IOBOW_FILE}_$DEPTH.log | grep iops | awk -F "iops=" '{print $2}' | awk -F " ," '{print $1}'`
lat1=`cat $RESULT_DIR/model_1024k_0read_${FIO_IOBOW_FILE}_$DEPTH.log | grep avg | grep " lat" | awk -F "avg=" '{print $2}' | awk -F "," '{print $1}'`
iops2=`cat $RESULT_DIR/model_1024k_100read_${FIO_IOBOW_FILE}_$DEPTH.log | grep iops | awk -F "iops=" '{print $2}' | awk -F " ," '{print $1}'`
lat2=`cat $RESULT_DIR/model_1024k_100read_${FIO_IOBOW_FILE}_$DEPTH.log | grep avg | grep " lat" | awk -F "avg=" '{print $2}' | awk -F "," '{print $1}'`
iops3=`cat $RESULT_DIR/model_8k_0read_${FIO_IOBOW_FILE}_$DEPTH.log | grep iops | awk -F "iops=" '{print $2}' | awk -F " ," '{print $1}'`
lat3=`cat $RESULT_DIR/model_8k_0read_${FIO_IOBOW_FILE}_$DEPTH.log | grep avg | grep " lat" | awk -F "avg=" '{print $2}' | awk -F "," '{print $1}'`
iops4=`cat $RESULT_DIR/model_8k_100read_${FIO_IOBOW_FILE}_$DEPTH.log | grep iops | awk -F "iops=" '{print $2}' | awk -F " ," '{print $1}'`
lat4=`cat $RESULT_DIR/model_8k_100read_${FIO_IOBOW_FILE}_$DEPTH.log | grep avg | grep " lat" | awk -F "avg=" '{print $2}' | awk -F "," '{print $1}'`

echo  "$date_str $iops1 $lat1 $iops2 $lat2 $iops3 $lat3 $iops4 $lat4" >> ${RESULT_HOME}/result_${FIO_IOBOW_FILE}_$DEPTH.csv