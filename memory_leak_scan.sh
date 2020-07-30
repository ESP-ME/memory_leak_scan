#! /bin/bash

declare -a classArray=()
declare -a instancesArray=()
IFS='
'

function queryIncreased() {
	findCount=0
    jmap -histo:live $PROCESS_ID>getCurMap.log
    for line in `cat getCurMap.log`
    do
		#编号
		no=`echo $line | awk '{print $1}'`
		#实例数
		instances=`echo $line | awk '{print $2}'`
		#类名
		class=`echo $line | awk '{print $4}'`
		#大小
		instbytes=`echo $line | awk '{print $3}'`
		if [ -z $class ] || [ -z $instances ] || [ $instances = "#instances" ];
		then
		    continue
		fi

		for i in ${!classArray[@]}
		do
			#echo "class1:" ${classArray[$i]}
			#echo "class2:" ${classArray[i]}
			#echo "class3" $class
			if [ ${classArray[$i]} = $class ];
			then
				#echo "匹配到上次数据，开始比较..."
				lastInstances=${instancesArray[$i]}
				if (($lastInstances < $instances));
		        then
					echo "类名:" $class ", 当前实例数:"  $instances "，上次实例数:" $lastInstances
					instancesArray[$i]=$instances
					let findCount++
				else
					unset classArray[$i]
					unset instancesArray[$i]
				fi
				break;
			fi
		done
    done 
	echo "找到："$findCount
}

function queryDecreased() {
	findCount=0
    jmap -histo:live $PROCESS_ID>getCurMap.log
    for line in `cat getCurMap.log`
    do
		#编号
		no=`echo $line | awk '{print $1}'`
		#实例数
		instances=`echo $line | awk '{print $2}'`
		#类名
		class=`echo $line | awk '{print $4}'`
		#大小
		instbytes=`echo $line | awk '{print $3}'`
		if [ -z $class ] || [ -z $instances ] || [ $instances = "#instances" ];
		then
		    continue
		fi

		for i in ${!classArray[@]} 
		do
			#echo "class1:" ${classArray[$i]}
			#echo "class2:" ${classArray[i]}
			#echo "class3" $class
			if [ ${classArray[$i]} = $class ];
			then
				#echo "匹配到上次数据，开始比较..."
				lastInstances=${instancesArray[$i]}
				if (($lastInstances > $instances));
		        then
					echo "类名:" $class ", 当前实例数:"  $instances "，上次实例数:" $lastInstances
					instancesArray[$i]=$instances
					let find++
				else
					unset classArray[$i]
					unset instancesArray[$i]
				fi
				break;
			fi
		done
    done 
	echo "找到："$find
}

function queryChanged() {
	findCount=0
    jmap -histo:live $PROCESS_ID>getCurMap.log
    for line in `cat getCurMap.log`
    do
		#编号
		no=`echo $line | awk '{print $1}'`
		#实例数
		instances=`echo $line | awk '{print $2}'`
		#类名
		class=`echo $line | awk '{print $4}'`
		#大小
		instbytes=`echo $line | awk '{print $3}'`
		if [ -z $class ] || [ -z $instances ] || [ $instances = "#instances" ];
		then
		    continue
		fi

		for i in ${!classArray[@]};
		do
			#echo "class1:" ${classArray[$i]}
			#echo "class2:" ${classArray[i]}
			#echo "class3" $class
			if [ ${classArray[$i]} = $class ];
			then
				#echo "匹配到上次数据，开始比较..."
				lastInstances=${instancesArray[$i]}
				if (($lastInstances != $instances));
		        then
					echo "类名:" $class ", 当前实例数:"  $instances "，上次实例数:" $lastInstances
					instancesArray[$i]=$instances
					let findCount++
				else
					unset classArray[$i]
					unset instancesArray[$i]
				fi
				break;
			fi
		done
    done 
	echo "找到："$findCount
}

function queryUnchanged() {
	findCount=0
    jmap -histo:live $PROCESS_ID>getCurMap.log
    for line in `cat getCurMap.log`
    do
		#编号
		no=`echo $line | awk '{print $1}'`
		#实例数
		instances=`echo $line | awk '{print $2}'`
		#类名
		class=`echo $line | awk '{print $4}'`
		#大小
		instbytes=`echo $line | awk '{print $3}'`
		if [ -z $class ] || [ -z $instances ] || [ $instances = "#instances" ];
		then
		    continue
		fi

		for i in ${!classArray[@]}
		do
			#echo "class1:" ${classArray[$i]}
			#echo "class2:" ${classArray[i]}
			#echo "class3" $class
			if [ ${classArray[$i]} = $class ];
			then
				#echo "匹配到上次数据，开始比较..."
				lastInstances=${instancesArray[$i]}
				if (($lastInstances == $instances));
		        then
					echo "类名:" $class ", 当前实例数:"  $instances "，上次实例数:" $lastInstances
					instancesArray[$i]=$instances
					let findCount++
				else
					unset classArray[$i]
					unset instancesArray[$i]
				fi
				break
			fi
		done	
    done
	echo "找到："$findCount	
}

function init() {
	echo "初始化中..."
	index=0
	jmap -histo:live $PROCESS_ID>tmp.log
	for line in `cat tmp.log`
    do
		#编号
		no=`echo $line | awk '{print $1}'`
		#实例数
		instances=`echo $line | awk '{print $2}'`
		#类名
		class=`echo $line | awk '{print $4}'`
		#大小
		instbytes=`echo $line | awk '{print $3}'`
		#echo "111类名:" $class ", 实例数:" $instances
		if [ -z $class ] || [ -z $instances ] || [ $instances = "#instances" ];
		then
		    continue
		fi
		#echo "222类名:" $class ", 实例数:" $instances
		classArray[$index]=$class
		instancesArray[$index]=$instances
		let index++
    done
	#for class in "${classArray[@]}"
    #do
	#	echo "2类名："${class}
    #done
	#echo ${classArray[@]}
	echo "初始化完成"
}


read -p "please input java process id:" PROCESS_ID
init
while true

do
	echo " "
	echo "0.Init"
	echo "1.Increased Object Number"
	echo "2.Decreased Object Number"
	echo "3.Changed Object Number"
	echo "4.Unchanged Object Number"
	read -p "please input scan type:" SCAN_TYPE

	case $SCAN_TYPE in
		0) init
		;;
		1) queryIncreased
		;;
		2) queryDecreased
		;;
		3) queryChanged
		;;
		4) queryUnchanged
		;;
	esac
done
