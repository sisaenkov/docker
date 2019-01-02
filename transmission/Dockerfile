FROM lsiobase/alpine:3.8

# set version label
ARG BUILD_DATE=20190101
ARG VERSION=2.94
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="s.isaenkov"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	curl \
	jq \
	openssl \
	p7zip \
	rsync \
	tar \
	transmission-cli \
	transmission-daemon \
	unrar \
	unzip

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 9091 10894
VOLUME /config /downloads
