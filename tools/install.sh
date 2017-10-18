#!/bin/bash

DIR="$( cd "$( dirname "$0"  )" && pwd  )"

########################################
#                                      #
#            Install                   #
#                                      #
########################################

function base_config
{
    yum -y install unzip tar make gcc expect libaio bc 
    echo Y | apt-get install unzip tar automake make gcc expect
    service iptables stop
    chkconfig iptables off
    service firewalld stop
    chkconfig firewalld off
	chmod 755 $DIR/nettool/ -R
	chmod 755 $DIR/*.sh
}

# Step 1 : Install Geekbench3

function geekbench3_install
{
    cd $DIR/geekbench3
  
	if [ -f dist -o -d dist ]; then
        rm -rf dist
    fi
    tar -xvf Geekbench-3.4.1-Linux.tar.gz
    cd dist/Geekbench-3.4.1-Linux
    ./geekbench_x86_64 -r lhcici521@163.com qpp6g-kq4el-bo72w-mdngp-2kcvx-eu2uq-gjrkp-l5q7r-qi36y
    ./geekbench_x86_64 --sysinfo
    if [ $? -eq 0 ]; then
        echo -e "\n===> Checked, Geekbench installed successed(Geekbench3)...(^^)"
    fi
}

# Step 2 : Install fio
function fio_install
{
    cp $DIR/fio /usr/bin/
    chmod 755 /usr/bin/fio
    echo "===>fio install success(^^)"
}
	

# Step 3 : Install netperf/qperf

function netperf_install
{
	if [ ! -f $DIR/config.conf ]
    then
        echo "[ERROR] config.conf do not exist, please check...(~~)"
    	exit 1
    fi
	PASSWD=`cat $DIR/config.conf |grep PASSWD= |awk -F "=" '{print $2}'`
	IP=`cat $DIR/config.conf |grep NETWORK_SERVER_IP= |awk -F "=" '{print $2}'`
    cp $DIR/nettool/* /usr/bin/
	chmod 755 /usr/bin/netperf
	chmod 755 /usr/bin/netserver
	chmod 755 /usr/bin/qperf
	if [ ! -f $DIR/net.exp ]
    then
        echo "[ERROR] net.exp do not exist, please check..."
    	exit 1
    fi
	cd $DIR
	expect net.exp $IP "$DIR/nettool/netperf" $PASSWD rm
	expect net.exp $IP "$DIR/nettool/netperf" $PASSWD scp
	expect net.exp $IP "$DIR/nettool/netserver" $PASSWD scp
	expect net.exp $IP "$DIR/nettool/qperf" $PASSWD scp
	expect net.exp $IP "$DIR/nettool/netperf" $PASSWD ssh
	#expect net.exp $IP "$DIR/nettool/netserver" $PASSWD ssh
	#expect net.exp $IP "$DIR/nettool/qperf" $PASSWD ssh
	echo "===>netperf/qperf install success"
}

# Step 4 install stream

function stream_install
{
    cd $DIR/stream
    gcc -O3 -fopenmp -DSTREAM_ARRAY_SIZE=20000000 -o stream stream.c
    chmod 755 stream
    cp stream /usr/bin/
    echo "===>stream install success"
}

# Step 5 install UnixBench

function unixbench_install
{
    rm -rf $DIR/UnixBench
    tar -xvf UnixBench.tar.gz
    cd $DIR/UnixBench
    make
    if [ $? -ne 0 ]
    then
        sed -i 's/-march=native//g' Makefile
        make clean
        make
    fi
    
    echo "===>UnixBench install success~"
}

function all_install
{
    #1.install geekbench3
    echo "======>Step 1 : install geekbench3"
    geekbench3_install
    
    #2.install fio
    echo "======>Step 2 : install fio"
    fio_install
    
    #3.install netperf qperf
    echo "======>Step 3 : install netperf/qperf"
    netperf_install 
    
    #4.install stream
    echo "======>Step 4 : install stream" 
    stream_install   

    #5.install UnixBench
    #echo "=======>Step 5 : install UnixBench"
    unixbench_install    
}

#########################################################################################
#1.Get info 
echo "=========>getting info ..."
mkdir -p $DIR/result
sh $DIR/getInfo.sh > $DIR/result/info.txt

#2.base config
echo "=========>base config"
base_config

echo "Please choose : "
echo "[1] Netperf/qperf install."
echo "[2] fio install."
echo "[3] Geekbench3 install."
echo "[4] Stream install"
echo "[5] UnixBench install"
echo "[6] all install"

while true
do
    read -p 'please choose:[1|2|3|4|5|6]' choice
	if [ $choice == 1 ]
	then
	    netperf_install
		break
	elif [ $choice == 2 ]
	then
	    fio_install
		break
	elif [ $choice == 3 ]
	then
	    geekbench3_install
		break
	elif [ $choice == 4 ]
	then
	    stream_install
		break
    elif [ $choice == 5 ]
    then
        unixbench_install
        break
    elif [ $choice == 6 ]
    then
        all_install
        break
	else
	    echo "Sorry, your choice is not correct."
	fi
done

echo "===>!!!!!![NOTICE] : Please confirm that firewall is OFF and permit_root_login is on before running test"

