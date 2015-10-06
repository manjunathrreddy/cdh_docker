#!/bin/bash -x
docker run -h cdh-docker --name=cdh-docker -i -d -t dgreco/cdh5:v1

ADDRESS=`docker inspect cdh-docker | grep IPAddress | awk -F ':|,|"' '{ print $5}'`

echo -e "Please enter your password:"
read -s pwd
echo -e "$pwd\n" | sudo -kS sed '/172.17.0/d' /etc/hosts > /tmp/hosts
echo -e "$ADDRESS\\tcdh-docker" >> /tmp/hosts
echo -e "$pwd\n" | sudo -kS mv /tmp/hosts /etc/hosts

while ! curl -X POST http://admin:admin@$ADDRESS:7180/api/v5/clusters/Cluster%201/commands/start
do
	echo "$(date) - still trying"
	sleep 30
done
echo "$(date) - started the cluster successfully"

while [ `curl -s -u admin:admin http://$ADDRESS:7180/api/v5/clusters/Cluster%201/services | grep STARTED | wc -l` -ne "6" ]
do
	echo "$(date) - still waiting"
	sleep 30
done

if [ `curl -s -u admin:admin http://$ADDRESS:7180/api/v5/clusters/Cluster%201/services | grep "\"configStale\" : true" | wc -l` -ne "0" ]
then
    echo "$(date) - there is a stale service: restarting the cluster again"
	curl -X POST http://admin:admin@$ADDRESS:7180/api/v5/clusters/Cluster%201/commands/restart
	sleep 30
	while [ `curl -s -u admin:admin http://$ADDRESS:7180/api/v5/clusters/Cluster%201/services | grep STARTED | wc -l` -ne "6" ]
	do
		echo "$(date) - still waiting"
		sleep 30
	done
fi
curl -X POST http://admin:admin@$ADDRESS:7180/api/v5/clusters/Cluster%201/commands/deployClientConfig
echo "$(date) - all the the cluster's services are up and running"

expect -f - <<EOF
spawn ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$ADDRESS mkdir .ssh
sleep 5
expect {
  "assword" {
    send "root\r"
  }
}
expect eof
EOF

expect -f - <<EOF
spawn scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${HOME}/.ssh/id_rsa.pub root@$ADDRESS:.ssh/authorized_keys
sleep 5
expect {
  "assword" {
    send "root\r"
  }
}
expect eof
EOF

ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$ADDRESS "su - hdfs -c 'hdfs dfs -mkdir /user/${USER}; hdfs dfs -chown ${USER} /user/${USER}'"
