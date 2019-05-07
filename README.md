# 重要tip
- hadoop搭建部分，使用了[kiwenlau的hadoop dockefile](https://github.com/kiwenlau/hadoop-cluster-docker)。
- 注意，hadoop的分布式是基于多机器的，而本github是通过docker来模拟实现的（单机多节点）。**其主要目的，是让大家通过看dockerfile了解基本的配置和搭建过程，说直白点，本dockerfile就是我认为的搭建流程的最简版。**
# hadoop部署方式
- 单机多节点。（通过docker可快速实现）
- 多机多节点。
    - 鉴于网络特性，对于一类集群，单个机器至多只能存在该类集群的一个节点。
    - 因为存在多类集群，那么，单机上可以存在每一类集群的一个节点，即单机上可以存在多个不同类集群的节点。
    - 这种可以结合docker进行实现，但这里docker的network得为host类型的模式。
    - 真正的分布式，指的是这一种。

# 搭建流程
- 搞清楚hadoop,hbase,hive,hue的定位关系
    - Hadoop实现了一个分布式文件系统（Hadoop Distributed File System），简称HDFS。
    - hbase是运行于HDFS文件系统之上的nosql。
    - hive是基于Hadoop的一个数据仓库工具，可以将结构化的数据文件映射为一张数据库表，并提供简单的sql查询功能，可以将sql语句转换为MapReduce任务进行运行。**hive映射的表既可以落在hdfs上，也可以落在hbase上。**
    - hue是支持多种数据库或数据仓库（包括hive）的web界面。
- 搭建步骤。（基本和参考教程的顺序一致）
    1. hadoop
    2. hbase
    3. hive
    4. hive与hbase和hdfs的整合
    5. hue
    6. hue与hive的整合
# 主要参考教程
- hadoop分布式简易安装教程
https://blog.csdn.net/Evankaka/article/details/51612437
- 写的比较好的，hbase分布式教程。
http://www.ityouknow.com/hbase/2017/07/25/hbase-cluster-setup.html
- hive安装
https://blog.csdn.net/u013310025/article/details/70306421
- hive和hbase整合
https://blog.csdn.net/qq_33689414/article/details/80328665
- hue安装
https://github.com/cloudera/hue/tree/master/tools/docker/hue
- hue与其他存储引擎的整合
https://blog.csdn.net/maomaosi2009/article/details/45648829
# 相关镜像
- 基于docker实现的单机多节点的github工程。
https://github.com/kiwenlau/hadoop-cluster-docker
- hadoop镜像。（该镜像仅供参考）
https://github.com/sequenceiq/hadoop-docker


### 3 Nodes Hadoop Cluster

##### 1. pull docker image

```
sudo docker pull kiwenlau/hadoop:1.0
```

##### 2. clone github repository

```
git clone https://github.com/kiwenlau/hadoop-cluster-docker
```

##### 3. create hadoop network

```
sudo docker network create --driver=bridge hadoop
```

##### 4. start container

```
cd hadoop-cluster-docker
sudo ./start-container.sh
```

**output:**

```
start hadoop-master container...
start hadoop-slave1 container...
start hadoop-slave2 container...
root@hadoop-master:~# 
```
- start 3 containers with 1 master and 2 slaves
- you will get into the /root directory of hadoop-master container

##### 5. start hadoop

```
./start-service.sh
```

##### 6. run wordcount

```
./run-wordcount.sh
```

**output**

```
input file1.txt:
Hello Hadoop

input file2.txt:
Hello Docker

wordcount output:
Docker    1
Hadoop    1
Hello    2
```

### Arbitrary size Hadoop cluster

##### 1. pull docker images and clone github repository

do 1~3 like section A

##### 2. rebuild docker image

```
sudo ./resize-cluster.sh 5
```
- specify parameter > 1: 2, 3..
- this script just rebuild hadoop image with different **slaves** file, which pecifies the name of all slave nodes


##### 3. start container

```
sudo ./start-container.sh 5
```
- use the same parameter as the step 2

##### 4. run hadoop cluster 

do 5~6 like section A

