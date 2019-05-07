#!/bin/bash
# the default node number is 3
N=${1:-3}
# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd --net=hadoop -p 50070:50070 -p 8088:8088 -p 10002:10002 -p 10000:10000 --name hadoop-master --hostname hadoop-master myhh &> /dev/null
# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	sudo docker run -itd --net=hadoop --name hadoop-slave$i --hostname hadoop-slave$i myhh &> /dev/null
	i=$(( $i + 1 ))
done

# docker run -it --net=hadoop --name hadoop-hue -p 8889:8888 -v /data/cbdeng/proj/hadoop-cluster-docker/config/hue.ini:/usr/share/hue/desktop/conf/z-hue.ini  gethue/hue 
# get into hadoop master container
# sudo docker exec -it hadoop-master bash