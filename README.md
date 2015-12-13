* Command for bulding the image

		docker build --tag="dgreco/cm5:v1" .

* Create a container with the following command:

		docker run -h cdh-docker --name=cdh-docker -i -d -t dgreco/cm5:v1
 						
* This container will start a Cloudera Manager service that you can use for creating all the services you need.

* Then add a route, using this command, for accessing all the ports used by the container without actually exposing them: 

		sudo route -n add 172.17.0.0/16 `echo $DOCKER_HOST | awk -F '//|:' '{ print $3}'`

* Finally, you can get the Cloudera Manager IP address with this command:

		docker inspect cdh-docker | grep IPAddress | awk -F ':|,|"' '{ print $5}' | sed 1d | uniq

* Create the following services:
	
	ZOOKEEPER
	
	HDFS
	
	YARN

	SPARK (YARN)
	
	HIVE
	
	IMPALA
	
* Change the following parameters for HDFS:
		
		DataNode Default Group / Resource Management: dfs.datanode.max.locked.memory = 65536 B
		Service-Wide / Ports and Addresses: dfs.client.use.datanode.hostname = true
		DataNode Default Group / Ports and Addresses: dfs.datanode.use.datanode.hostname = true
		Service-Wide / Replication: dfs.replication = 1		

* Change the following parameters for YARN:

		NodeManager Default Group / Resource Management: yarn.nodemanager.resource.memory-mb = 4 GiB
		ResourceManager Default Group / Resource Management: yarn.scheduler.maximum-allocation-mb = 2 GiB

* After creating all the services, before committing the container you should stop the entire cluster.

* Then commit the container for creating the CDH image:

		docker commit cdh-docker dgreco/cdh5:v1