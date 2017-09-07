#!/bin/bash

DIR="$( cd "$( dirname "$0"  )" && pwd  )"
RESULT_DIR=$DIR/result/raw/fio
if [ $# -ne 4 ]
then
    echo "Usage:sh all_io.sh 1/2/3/4 /dev/xvde <DEPTH> xvde"
    exit 1
fi

par=$1
FIO_IOBOW_FILE=$2
DEPTH=$3
DEV=$4

if [ $par -eq 1 ]
then
    cd $DIR
    ./fio_8_w.sh $FIO_IOBOW_FILE $DEPTH $DEV
elif [ $par -eq 2 ]
then
    cd $DIR
    ./fio_8_r.sh $FIO_IOBOW_FILE $DEPTH $DEV
elif [ $par -eq 3 ]
then
    cd $DIR
    ./fio_1024_w.sh $FIO_IOBOW_FILE $DEPTH $DEV
elif [ $par -eq 4 ]
then
    cd $DIR
    ./fio_1024_r.sh $FIO_IOBOW_FILE $DEPTH $DEV
else
    echo "ERROR: param error,should 1 2 3 4"
	exit 1
fi
