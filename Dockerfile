FROM multiarch/ubuntu-core:armhf-xenial

RUN apt-get update && apt-get upgrade -y \
 && rm -rf /var/lib/apt/lists/*

ENV MONGODB_VERSION 3.2.22

COPY --from=hinchliff/rpi2-mongodb-compile /usr/local/bin/mongod /usr/local/bin/

# unifi version
# From: https://www.ubnt.com/download/unifi/
ENV UNIFI_VERSION "6.0.36"

RUN apt-get update && apt-get install -y \
    binutils \
    jsvc \
    openjdk-8-jre-headless \
    curl \
    gosu \
    logrotate \
    --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

 #&& dpkg --force-all -i /tmp/unifi.deb \
RUN curl -o /tmp/unifi.deb -L "https://dl.ui.com/unifi/${UNIFI_VERSION}/unifi_sysvinit_all.deb" \
 && dpkg --ignore-depends=mongodb-server -i /tmp/unifi.deb \
 && rm -rf /tmp/unifi.deb

WORKDIR /config

# 3478 - STUN
# 8080 - device inform (http)
# 8443 - web management (https)
# 8843 - guest portal (https)
# 8880 - guest portal (http)
# 6789 - throughput / mobile speedtest (tcp)
# 10001 - device discovery (udp)
# ref https://help.ubnt.com/hc/en-us/articles/218506997-UniFi-Ports-Used
EXPOSE 3478/udp 8080 8081 8443 8843 8880 6789 10001/udp

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
CMD ["java", "-Xmx512M", "-jar", "/usr/lib/unifi/lib/ace.jar", "start"]

