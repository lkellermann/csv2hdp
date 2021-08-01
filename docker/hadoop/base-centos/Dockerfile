# Generated new image based on centos image
FROM centos:8.3.2011

# Environment variables:
ENV HADOOP_VERSION=3.1.1
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV USER=hadoop
ENV PATH ${HADOOP_HOME}/bin/:$PATH
ENV TZ=America/Sao_Paulo
ENV JAVA_HOME=/etc/alternatives/jre_1.8.0

#Set time zone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone

#Upgrading the system
RUN yum -y update

# Installing softwares
RUN yum -y install yum-utils \
    curl \
    wget \
    nc \
    ncurses \
    perl \
    java-1.8.0-openjdk.x86_64

RUN yum autoremove
# RUN yum install ncurses

#Change the root password to root
RUN echo "root:root"| chpasswd

RUN mkdir -p /opt/hadoop
RUN wget -c -O hadoop.tar.gz https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar xvf hadoop.tar.gz --directory=/opt/hadoop --exclude=hadoop-${HADOOP_VERSION}/share/doc --strip 1 && \
    rm -rf hadoop.tar.gz && \
    ln -s /opt/hadoop/etc/hadoop /etc/hadoop && \
    mkdir /opt/hadoop/logs && \
    mkdir /hadoop-data

COPY ./conf/* /etc/hadoop/

# Initiates base image:
COPY entrypoint.sh .

RUN chmod +x ./entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
