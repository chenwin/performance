date_str=$1
dev=$2

iops_file=`ls result/$date_str/iops*$dev*.log`
for file in $iops_file
do
    #echo $file
	iops=`cat $file | grep iops | awk -F "iops=" '{print $2}' | awk -F "," '{print $1}'`
    echo "$date_str $file $iops" >> result/iops.csv
done

bw_file=`ls result/$date_str/bw*$dev*.log`
for file in $bw_file
do
    #echo $file
	bw=`cat $file | grep bw | awk -F "bw=" '{print $2}' | awk -F "," '{print $1}'`
    echo "$date_str $file $bw" >> result/bw.csv
done

rtt_file=`ls result/$date_str/rtt*$dev*.log`
for file in $rtt_file
do
    #echo $file
	rtt=`cat $file | grep avg | grep " lat" | awk -F "avg=" '{print $2}' | awk -F "," '{print $1}'`
    echo "$date_str $file $rtt" >> result/rtt.csv
done


