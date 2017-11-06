date_str=`date +"%Y%m%d_%H%M%S"`
mkdir -p result/$date_str

pkill fio

for line in $(<dev.txt)
do
  sh do.sh $date_str $line &
done
