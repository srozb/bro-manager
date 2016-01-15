FROM centos:7
MAINTAINER Slawomir Rozbicki <docker@rozbicki.eu>

# Specify program
ENV PROG bro
ENV PF_PROG PF_RING
# Specify source extension
ENV EXT tar.gz
ENV PF_EXT tar.gz
# Specify Bro version to download and install (e.g. bro-2.3.1, bro-2.4)
ENV VERS 2.4.1
ENV PF_VERS 6.2.0
# Install directory
ENV PREFIX /opt/bro
ENV PF_PREFIX /opt/PF_RING
# Path should include prefix
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PREFIX/bin
# Storage prefix
ENV STOR_PATH /data/bro
# Build faster (make -jX)
ENV PROC_NUM 4

# Bro deps
RUN yum update -y && yum install -y wget gperftools geoip file zlib openssh-clients rsync

# Devels (only for bro build - might be removed later)
RUN yum install -y gperftools-devel geoip-devel cmake gcc gcc-c++ bison flex python-devel swig file-devel zlib-devel make openssl-devel

# Build PF_RING
WORKDIR /usr/src/
RUN wget --no-check-certificate http://downloads.sourceforge.net/project/ntop/PF_RING/$PF_PROG-$PF_VERS.$PF_EXT \
&& tar -xzf $PF_PROG-$PF_VERS.$PF_EXT
WORKDIR /usr/src/$PF_PROG-$PF_VERS/userland/lib
RUN ./configure && make -j$PROC_NUM
WORKDIR /usr/src/$PF_PROG-$PF_VERS/userland/libpcap
RUN ./configure --prefix=$PF_PREFIX && make -j$PROC_NUM && make install 

# Build Bro
WORKDIR /usr/src
RUN wget --no-check-certificate https://www.bro.org/downloads/release/$PROG-$VERS.$EXT && tar -xzf $PROG-$VERS.$EXT
WORKDIR /usr/src/$PROG-$VERS
RUN ./configure --prefix=$PREFIX --with-pcap=$PF_PREFIX && make -j$PROC_NUM && make install && make install-aux

# Get the GeoIP data, prepare the storage & misc tunning.
RUN geoipupdate && mkdir -p ${STOR_PATH}/logs ${STOR_PATH}/spool \
&& sed -i 's/^LogDir = \/opt\/bro/LogDir = \/data\/bro/g' ${PREFIX}/etc/broctl.cfg\
&& sed -i 's/^SpoolDir = \/opt\/bro/SpoolDir = \/data\/bro/g' ${PREFIX}/etc/broctl.cfg

# Clean up.
RUN yum remove -y geoip-devel cmake gcc gcc-c++ bison flex python-devel swig file-devel zlib-devel make
RUN rm -rf /usr/src/* && rm -rf /var/cache/yum/*

CMD ["/usr/bin/python", "/opt/bro/bin/broctl"]

