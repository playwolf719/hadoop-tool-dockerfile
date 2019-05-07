FROM ubuntu:14.04

MAINTAINER playwolf719 <playwolf719@163.com>

WORKDIR /root

# install openssh-server, openjdk and wget
RUN apt-get update && apt-get install -y openssh-server openjdk-7-jdk wget

# install hadoop 2.7.2
RUN wget https://github.com/kiwenlau/compile-hadoop/releases/download/2.7.2/hadoop-2.7.2.tar.gz && \
    tar -xzvf hadoop-2.7.2.tar.gz && \
    mv hadoop-2.7.2 /usr/local/hadoop && \
    rm hadoop-2.7.2.tar.gz

# download hbase 1.4.9
RUN wget http://mirror.bit.edu.cn/apache/hbase/1.4.9/hbase-1.4.9-bin.tar.gz && \
    tar -zxvf hbase-1.4.9-bin.tar.gz && \
    mv hbase-1.4.9 /usr/local/hbase && \
    rm hbase-1.4.9-bin.tar.gz

# hive 2.3.4
RUN wget http://mirror.bit.edu.cn/apache/hive/hive-2.3.4/apache-hive-2.3.4-bin.tar.gz && \
    tar -zxvf apache-hive-2.3.4-bin.tar.gz && \
    mv apache-hive-2.3.4-bin /usr/local/hive && \
    rm apache-hive-2.3.4-bin.tar.gz


# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop
ENV HBASE_HOME=/usr/local/hbase
ENV HIVE_HOME=/usr/local/hive
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:/usr/local/hbase/bin:/usr/local/hive/bin

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

# install pack and clear apt
RUN apt-get install -y lsof
RUN apt-get clean && rm -rf /var/lib/apt/lists/* 

COPY lib /tmplib

RUN mv /tmplib/mysql-connector-java-5.1.39-bin.jar $HIVE_HOME/lib/

COPY config /tmp

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-service.sh ~/start-service.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh && \
    mv /tmp/hbase_conf/hbase-env.sh $HBASE_HOME/conf/hbase-env.sh && \
    mv /tmp/hbase_conf/hbase-site.xml $HBASE_HOME/conf/hbase-site.xml && \
    mv /tmp/hbase_conf/regionservers $HBASE_HOME/conf/regionservers

RUN mv /tmp/hive_conf/hive-env.sh $HIVE_HOME/conf/hive-env.sh && \
    mv /tmp/hive_conf/hive-site.xml $HIVE_HOME/conf/hive-site.xml

RUN chmod +x ~/start-service.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh 

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format


CMD [ "sh", "-c", "service ssh start; bash"]

# CMD [ "sh","~/start-service.sh"]

