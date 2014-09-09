FROM ubuntu:12.04
MAINTAINER David Greco "greco@acm.org"
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq curl
 
#add CDH repo
RUN curl http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key | apt-key add -
RUN curl http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/cloudera.list > /etc/apt/sources.list.d/cloudera.list
 
# add CM repo 
RUN curl http://archive.cloudera.com/cm5/ubuntu/precise/amd64/cm/archive.key | apt-key add -
RUN curl http://archive.cloudera.com/cm5/ubuntu/precise/amd64/cm/cloudera.list > /etc/apt/sources.list.d/cloudera-manager.list
 
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq oracle-j2sdk1.7
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle-cloudera
ENV PATH $JAVA_HOME/bin:$PATH
 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq oracle-j2sdk1.6 cloudera-manager-server-db cloudera-manager-daemons cloudera-manager-server ssh net-tools vim inetutils-ping
RUN echo 'root:root' | chpasswd 

ADD start.sh start.sh

# Ports for Cloudera Manager
EXPOSE 22 7180 7183 7182 7432

ENTRYPOINT ["sh", "start.sh"]
