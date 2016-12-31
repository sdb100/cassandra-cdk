# Starts with RHEL and adds Oracle Java plus the DataStax Cassandra distro. To be used for OpenShift. 

# docker build -t cassandra-cdk .
# docker run -p 127.0.0.1:9042:9042 -d -i cassandra-cdk

FROM registry.access.redhat.com/rhel7:latest

MAINTAINER Steve Bell <steve.bell@worldpay.com>

# explicitly set user/group IDs
RUN groupadd -r cassandra --gid=1001 && useradd -r -g cassandra --uid=1001 cassandra

RUN cd /opt \
  && curl -b oraclelicense=accept-securebackup-cookie -O -L http://download.oracle.com/otn-pub/java/jdk/8u111-b14/server-jre-8u111-linux-x64.tar.gz \
  && tar xf *.tar.gz \
  && mv jdk* jdk \
  && ln -s /opt/jdk/bin/java /bin/java \
  && rm /opt/*.tar.gz

ENV JAVA_HOME=/opt/jdk

COPY datastax.repo /etc/yum.repos.d/datastax.repo

RUN yum install -y dsc30 \
    yum install -y cassandra30-tools

ENV CASSANDRA_CONFIG /etc/cassandra/conf

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 777 /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

RUN mkdir -p /var/lib/cassandra "$CASSANDRA_CONFIG" \
  && chown -R cassandra:cassandra /var/lib/cassandra "$CASSANDRA_CONFIG" \
  && chmod 777 /var/lib/cassandra "$CASSANDRA_CONFIG"
VOLUME /var/lib/cassandra

# This default user is created in the openshift/base-centos7 image
USER 1001

# 7000: intra-node communication
# 7001: TLS intra-node communication
# 7199: JMX
# 9042: CQL
# 9160: thrift service
EXPOSE 7000 7001 7199 9042 9160
CMD ["cassandra", "-f"]
