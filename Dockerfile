FROM quay.io/centos/centos:stream9 as builder

ARG TRAFFIC_SERVER_VERSION=9.1.2

RUN dnf install -y pkgconfig libtool gcc make tcl-devel openssl-devel pcre pcre-devel libcap flex hwloc lua zlib  ncurses-devel ncurses gcc-c++ bzip2 tcl-devel

RUN  mkdir -p /tmp/trafficserver /opt/trafficserver \
        && curl -L https://downloads.apache.org/trafficserver/trafficserver-${TRAFFIC_SERVER_VERSION}.tar.bz2 | tar xjvf - -C /tmp/trafficserver --strip-components 1 \
        && cd /tmp/trafficserver && ./configure --prefix=/opt/trafficserver --with-user=nobody --with-group=nobody --enable-experimental-plugins \
        && cd /tmp/trafficserver && make -j2 \
        && cd /tmp/trafficserver && make install \
        && mv /opt/trafficserver/etc/trafficserver /etc/trafficserver \
        && ln -sf /etc/trafficserver /opt/trafficserver/etc/trafficserver \
        && rm -rf /tmp/trafficserver

FROM quay.io/centos/centos:stream9


COPY --from=builder --chown=nobody:nobody /opt/trafficserver  /opt/trafficserver

EXPOSE 80 443

VOLUME ["/opt/trafficserver/etc/trafficserver"]

CMD ["/opt/trafficserver/bin/traffic_server"]
