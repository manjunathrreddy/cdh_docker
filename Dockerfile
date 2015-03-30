FROM ubuntu:14.04
MAINTAINER David Greco "greco@acm.org"
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq curl
 
#add CDH repo
RUN curl http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/archive.key | apt-key add -
RUN curl http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/cloudera.list > /etc/apt/sources.list.d/cloudera.list
 
# add CM repo 
RUN curl http://archive.cloudera.com/cm5/ubuntu/trusty/amd64/cm/archive.key | apt-key add -
RUN curl http://archive.cloudera.com/cm5/ubuntu/trusty/amd64/cm/cloudera.list > /etc/apt/sources.list.d/cloudera-manager.list
 
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq oracle-j2sdk1.7
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle-cloudera
ENV PATH $JAVA_HOME/bin:$PATH
 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq oracle-j2sdk1.6 cloudera-manager-server-db cloudera-manager-daemons cloudera-manager-server ssh net-tools vim inetutils-ping

RUN echo 'root:root' | chpasswd 
RUN sed -e 's/without-password/yes/g' /etc/ssh/sshd_config > /etc/ssh/tmp; mv /etc/ssh/tmp /etc/ssh/sshd_config
RUN service ssh restart

ADD start.sh start.sh

# Ports for Cloudera Manager
EXPOSE 22 2181 7180 50010 50075 50020 8020 50070 50090 8032 8030 8031 8033 8088 8040 8042 8041 10020 19888 41370 38319 10000 21050 25000 25010 25020 18080 18081 7077 7078 18080 18081 9000 9001

ENTRYPOINT ["sh", "start.sh"]
