#!/bin/bash
echo -e "\nstart-dfs\n"

$HADOOP_HOME/sbin/start-dfs.sh

echo -e "\nstart-yarn\n"

$HADOOP_HOME/sbin/start-yarn.sh

echo -e "\nstart-hbase\n"

$HBASE_HOME/bin/start-hbase.sh

echo -e "\nstart-hive\n"

hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir -p /user/hive/tmp
hdfs dfs -mkdir -p /user/hive/log
hdfs dfs -chmod -R 777 /user/hive/warehouse
hdfs dfs -chmod -R 777 /user/hive/tmp
hdfs dfs -chmod -R 777 /user/hive/log

schematool -dbType mysql -initSchema
