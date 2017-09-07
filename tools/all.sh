#!/bin/bash

DIR="$( cd "$( dirname "$0"  )" && pwd  )"
RESULT_DIR=$DIR/result/raw/fio
mkdir -p /home/iotest
LOG=/home/iotest/fio.log

if [ ! -f $DIR/config.conf ]
then
    echo "[ERROR] config.conf do not exist, please check..."
	exit 1
fi


INFO=`cat $DIR/config.conf |grep DEVICE= |awk -F "=" '{print $2}'`

i=1
while((1==1))
do
    split=`echo $INFO|cut -d "," -f$i`
    if [ "$split" != "" ]
    then
        ((i++))
		DEV=`echo $split|awk -F ":" '{print $1}'`
		FIO_IOBOW_FILE=`echo $split|awk -F ":" '{print $2}'`
        DEPTHS=`echo $split|awk -F ":" '{print $3}'`
		for DEPTH in ${DEPTHS[@]}
		do
		    cd $DIR
		    ./all_io.sh 1 $FIO_IOBOW_FILE $DEPTH $DEV
            sleep 10
            ./all_io.sh 2 $FIO_IOBOW_FILE $DEPTH $DEV
            sleep 10
            ./all_io.sh 3 $FIO_IOBOW_FILE $DEPTH $DEV
            sleep 10
            ./all_io.sh 4 $FIO_IOBOW_FILE $DEPTH $DEV
            sleep 10
			./load.sh $DEV $DEPTH
		done
		[[ $INFO =~ "," ]] || break
    else
        break
    fi
done

date_str=`date +"%Y-%m-%d_%I_%M_%S_%p"`



mkdir -p $RESULT_DIR/${date_str}
mv $RESULT_DIR/model_*.log $RESULT_DIR/${date_str}/

