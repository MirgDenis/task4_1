#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
exec 1>$dir/task4_1.out

#Getting information about ...

cpu=`cat /proc/cpuinfo | grep "model name" | cut -d ":" -f 2`
mem=`cat /proc/meminfo | grep "MemTotal" | awk '{print $2}'`
board_name=`sudo dmidecode -s baseboard-product-name`
sys_serial=`sudo dmidecode -s system-serial-number`
distrib=`cat /etc/lsb-release | grep "DISTRIB_DESCRIPTION" | awk -F\" '{print $2}'`
kernel=`cat /proc/version | awk '{print $3}'`
install_date=`sudo dumpe2fs /dev/sda1 2>/dev/null | grep 'Filesystem created:' | awk '{print $3,$4,$5,$6,$7}'`
uptime=`uptime -p | cut -d "p" -f 2`
proc=`ps aux | wc -l`
user_count=`who | wc -l`

#Print that ...

echo "---Hardware---"
echo "CPU:$cpu"
echo "RAM: $mem KB"
echo "Motherboard: ${board_name:-Unknown}"
echo "System Serial Number: ${sys_serial:-Unknown}"
echo "---System---"
echo "OS Distribution: $distrib"
echo "Kernel version: $kernel"
echo "Installation date: $install_date"
echo "Hostname: `hostname`"
echo "Uptime:$uptime"
echo "Processes running: $proc"
echo "Users logged in: $user_count"
echo "---Network---"

ints=`ip a | grep -o "[0-9]: [^:]*" | awk '{print $2}'`

for name in $ints
do
addr=`ip a s $name | grep "inet [^ ]*" | awk '{print $2}' ORS=', ' | rev | cut -c 3- | rev`

if [ "$addr" == "" ]
	then
	addr="-"
fi

echo "$name: $addr"
done

