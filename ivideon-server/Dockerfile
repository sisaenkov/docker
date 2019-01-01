FROM ubuntu:16.04

ARG BUILD_DATE=20190102
ARG VERSION=1
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="s.isaenkov"

RUN export DEBIAN_FRONTEND=noninteractive \
  && echo "debconf debconf/frontend select noninteractive" | debconf-set-selections \
  && apt-get update -qy \
  && apt-get upgrade -qy \
  && apt-get -qy install wget psmisc nano \
  && cd /tmp/ \
  && wget http://packages.ivideon.com/public/keys/ivideon.list -O /etc/apt/sources.list.d/ivideon.list \
  && wget -O - http://packages.ivideon.com/public/keys/ivideon.key | apt-key add - \
  && apt-get update -qy \
  && apt-get upgrade -qy \
  && cd /tmp/ \
  && wget http://downloads-cdn77.iv-cdn.com/bundles/server/install-ivideon-server.sh \
  && chmod +x /tmp/install-ivideon-server.sh \
  && cd /tmp \
  && /tmp/install-ivideon-server.sh \
  && apt-get remove -qy wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /tmp/* \
  && rm -f /opt/ivideon/ivideon-server/service.log

ENTRYPOINT ["/entrypoint.sh"]
COPY [ "files/", "/" ]
