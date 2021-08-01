FROM hadoop-base-centos:latest
LABEL maintainer="lkellermann"

ENV HDFS_CONF_DFS_NAMENODE_DATA_DIR=file:///hadoop/dfs/name

# Install openssh-server and clients:
RUN yum -y install openssh-server openssh-clients.x86_64 vim less

#Copy the key file to the /etc/ssh/ directory. Here to generate a key with root privileges
RUN mkdir -p /hadoop/.ssh
#Generate key, public key
RUN ssh-keygen -t rsa -b 2048 -P '' -f /hadoop/.ssh/id_rsa
RUN cat /hadoop/.ssh/id_rsa.pub > /hadoop/.ssh/authorized_keys
RUN cp /hadoop/.ssh/id_rsa /etc/ssh/ssh_host_rsa_key
RUN cp /hadoop/.ssh/id_rsa.pub /etc/ssh/ssh_host_rsa_key.pub

RUN mkdir -p /hadoop/dfs/name

COPY ./start-namenode.sh ./start-namenode.sh

RUN chmod +x ./start-namenode.sh

EXPOSE 9870 22
CMD [ "./start-namenode.sh" ]
