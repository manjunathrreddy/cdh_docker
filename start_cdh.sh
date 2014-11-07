#!/bin/bash
docker run -h docker -i -d\
-p 2222:22 \
-p 2181:2181 \
-p 7180:7180 \
-p 50010:50010 \
-p 50075:50075 \
-p 50020:50020 \
-p 8020:8020 \
-p 50070:50070 \
-p 50090:50090 \
-p 8032:8032 \
-p 8030:8030 \
-p 8031:8031 \
-p 8033:8033 \
-p 8088:8088 \
-p 8040:8040 \
-p 8042:8042 \
-p 8041:8041 \
-p 10020:10020 \
-p 19888:19888 \
-p 41370:41370 \
-p 38319:38319 \
-p 10000:10000 \
-p 21050:21050 \
-t dgreco/cdh5:v1

while ! curl -X POST http://admin:admin@docker:7180/api/v5/clusters/Cluster%201/commands/start
do
	echo "$(date) - still trying"
	sleep 30
done
echo "$(date) - started the cluster successfully"
curl -X POST http://admin:admin@docker:7180/api/v5/clusters/Cluster%201/commands/deployClientConfig

while [ "`curl -s -u admin:admin 'http://docker:7180/api/v1/clusters/Cluster%201/services' | grep STARTED | wc -l`" -ne "5" ]
do
	echo "$(date) - still waiting"
	sleep 30
done
echo "$(date) - all the the cluster's services are up and running"

expect -f - <<EOF
spawn ssh-copy-id -p 2222 -i ${HOME}/.ssh/id_rsa.pub root@docker
expect {
  "assword" {
    send "root\r"
  }
}
expect eof
EOF
ssh -p 2222 root@docker "su - hdfs -c 'hdfs dfs -mkdir /user/${USER}; hdfs dfs -chown ${USER} /user/${USER}'"
