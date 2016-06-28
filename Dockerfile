FROM centos:7
MAINTAINER maaydin
ENV container docker

# Environment Variables
ENV HTTP_PROXY="http://172.17.0.1:3128" HTTPS_PROXY="http://172.17.0.1:3128" ORACLE_JRE_VERSION="8u91" ORACLE_JRE_BUILD_NUMBER="b14"

# Clean up systemd
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*; \
rm -f /etc/systemd/system/*.wants/*; \
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*; \
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install Oracle JRE
RUN echo "[main]" >> /etc/yum.conf; \
echo "proxy=$HTTP_PROXY" >> /etc/yum.conf; \
export http_proxy=$HTTP_PROXY; \
export https_proxy=$HTTPS_PROXY; \
curl -v -L -H "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/jre-$ORACLE_JRE_VERSION-linux-x64.rpm http://download.oracle.com/otn-pub/java/jdk/$ORACLE_JRE_VERSION-$ORACLE_JRE_BUILD_NUMBER/jre-$ORACLE_JRE_VERSION-linux-x64.rpm; \
rpm -ivh /tmp/jre-$ORACLE_JRE_VERSION-linux-x64.rpm; \
yum clean all; \
rm -f /tmp/*; \
head -n -1 /etc/yum.conf > /etc/yum.conf;

CMD ["/bin/bash"]