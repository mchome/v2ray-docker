# V2Ray Dockerfile
#
# Version: 1.3.0

FROM ubuntu:14.04
MAINTAINER fuyumi <280604399@qq.com>

# environment
ENV V2RAY_VERSION 1.10
ENV V2RAY_PORT 9527
ENV V2RAY_ALTERID 7259
ENV SS_PORT 443
ENV SS_PASSWD !~v2foobar~!
ENV SS_METHOD chacha20

# install git & curl & unzip & daemon
RUN apt-get -qq update && \
    apt-get install -q -y git curl unzip daemon

# run install script
RUN mkdir -p /usr/v2ray/
ADD install-release.sh /usr/v2ray/install-release.sh
ADD config.json /usr/v2ray/config.json
RUN chmod +x /usr/v2ray/install-release.sh

EXPOSE $V2RAY_PORT
EXPOSE $SS_PORT

CMD ["bash", "/usr/v2ray/install-release.sh"]
