#!/bin/bash
/etc/init.d/ssh start
/etc/init.d/cloudera-scm-server-db start
sleep 20
if [ -f /etc/init.d/cloudera-scm-agent ] 
then
	PGPASSWORD=`grep password /etc/cloudera-scm-server/db.properties | awk -F = '{print $2}'`  psql -h localhost -p 7432 -U scm -w -c "update hosts set (name,ip_address) = ('cdh-docker','`ifconfig eth| grep 'inet addr:' | awk -F : '{print $2}' | awk '{print $1}'`') where name='cdh-docker';"
	mv /etc/cloudera-scm-agent/config.ini /etc/cloudera-scm-agent/config.ini.bak
	sed -e "s/172.17.0.*/cdh-docker/g" /etc/cloudera-scm-agent/config.ini.bak > /tmp/config.ini
	mv /tmp/config.ini /etc/cloudera-scm-agent/config.ini 
	/etc/init.d/cloudera-scm-agent start
fi
/etc/init.d/cloudera-scm-server start
/bin/bash