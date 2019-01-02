FROM lsiobase/alpine:3.8

ARG BUILD_DATE
ARG VERSION=2.94

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/sisaenkov/docker/tree/master/transmission" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

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
