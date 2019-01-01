#!/bin/bash
set -e

mkdir -p /config/video_archive /opt/ivideon/videoserverd

[ ! -f /config/config.xml ]                     && cp /DEFAULT/config.xml          /config/config.xml
[ ! -f /opt/ivideon/videoserverd/config.xml  ] && ln -s /config/config.xml         /opt/ivideon/videoserverd/config.xml

[ ! -f /config/videoserverd.config ]                       && cp /DEFAULT/videoserverd.config /config/videoserverd.config
[ ! -f /opt/ivideon/ivideon-server/videoserverd.config  ] && ln -s /config/videoserverd.config   /opt/ivideon/ivideon-server/videoserverd.config

[ ! -f /config/schedule.json ]                      && cp /DEFAULT/schedule.json       /config/schedule.json
[ ! -f /opt/ivideon/ivideon-server/schedule.json ] && ln -s /config/schedule.json         /opt/ivideon/ivideon-server/schedule.json

touch /config/service.log
[ ! -f /opt/ivideon/ivideon-server/service.log ] && ln -s /config/service.log         /opt/ivideon/ivideon-server/service.log

chown -R www-data:www-data /config/*

/opt/ivideon/ivideon-server/initd.sh restart

tail -f /opt/ivideon/ivideon-server/service.log
