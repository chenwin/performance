#!/bin/bash

DIR="$( cd "$( dirname "$0"  )" && pwd  )"


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
mkdir -p $DIR/result/raw
unixbench_run

