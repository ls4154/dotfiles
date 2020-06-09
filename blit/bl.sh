#!/bin/bash

# Backlight brightness script for Dell Latitude 7390

BR_PATH="/sys/class/backlight/intel_backlight"

help() {
	echo "bl.sh options"
	echo "-c	check current brightness"
	echo "-i	increase brightness"
	echo "-d	decrease brightness"
	echo "-s N	set brightness"
	echo "-h	display this help"
	exit 0
}

while getopts cids:h option
do
	case "${option}"
	in
		c)
			BR_OPT="chk"
			;;
		i)
			BR_OPT="inc"
			;;
		d)
			BR_OPT="dec"
			;;
		s)
			BR_OPT="set"
			BR_NEW=$OPTARG
			;;
		h)
			help
			;;
		?)
			help
			;;
	esac
done

BR_CUR=$(cat "$BR_PATH/brightness")
BR_MAX=$(cat "$BR_PATH/max_brightness")

echo "Current brightness : $BR_CUR"

if [ -z $BR_OPT ] || [ $BR_OPT == "chk" ]
then
	echo "empty"
	echo $BR_CUR
	exit 0
elif [ $BR_OPT == "dec" ]
then
	BR_NEW=$((BR_CUR - 500))
	if (($BR_NEW < 0))
	then
		BR_NEW=0
	fi
	echo $BR_NEW > "$BR_PATH/brightness"
	echo "Brightness : $BR_NEW/$BR_MAX"
elif [ $BR_OPT == "inc" ]
then
	BR_NEW=$(($BR_CUR + 500))
	if (($BR_NEW > $BR_MAX))
	then
		BR_NEW=$BR_MAX
	fi
	echo $BR_NEW > "$BR_PATH/brightness"
	echo "Brightness : $BR_NEW/$BR_MAX"
elif [ $BR_OPT == "set" ]
then
	if (($BR_NEW > $BR_MAX))
	then
		echo "Brightness value should not be higher than $BR_MAX."
		exit 1
	fi
	if (($BR_NEW < 0))
	then
		echo "Brightness value should not be lower than 0."
		exit 1
	fi
	echo $BR_NEW > "$BR_PATH/brightness"
	echo "Brightness : $BR_NEW/$BR_MAX"
fi
