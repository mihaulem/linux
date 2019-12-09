#!/bin/bash

p_value_function()
{
	pids=$(ls -v /proc/ | grep -E "^[0-9]+$")

	for pid in $pids
	do
		if [ -d "/proc/$pid" ]
		then
			path="/proc/$pid/status"
			parent_pid=$(cat $path | grep "PPid" | cut -d "	" -f2)
			uid=$(cat $path | grep "Uid" | cut -d "	" -f2)
			username=$(getent passwd $uid | cut -d ":" -f1)
			if [ -d "/proc/$ppid" ]
			then
				parent_name=$(cat /proc/$parent_pid/status | grep "Name" | cut -d "	" -f2)
			fi

			printf "%12s %12s %24s %12s\n" $pid $parent_pid "$uid($username)" $parent_name
		fi
	done
}

u_value_function()
{
	uid=$( id -u )
	pids=$(ls -v /proc/ | grep -E "^[0-9]+$")

	for pid in $pids
	do
		if [ -d "/proc/$pid" ]
		then
			temp_uid=$(cat /proc/$pid/status | grep "Uid" | cut -d "	" -f2 )
			if [ $temp_uid -eq $uid ]
			then
				Name=$(cat /proc/$pid/status | grep "Name" | cut -d "	" -f2)
				cwd=$(readlink -e /proc/$pid/cwd)
				printf "%12s %12s %12s\n" $pid $Name $cwd 
			fi
		fi
	done
}

case $1 in
-u)
	u_value_function
	;;
-p)
	p_value_function
	;;
*)
	echo "Unknown argument"
	;;
esac
