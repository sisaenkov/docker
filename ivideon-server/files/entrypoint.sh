#!/bin/bash
set -e

if [ -z $1 ] || [ -z $2 ]; then
	echo EMAIL or SERVER_NAME environment variable is not defined!
	exit 1
fi

mkdir -p /archive /opt/ivideon/videoserverd

[ ! -f /config/videoserverd.config ] && cp /DEFAULT/videoserverd.config /config/videoserverd.config
[ ! -f /opt/ivideon/ivideon-server/videoserverd.config  ] && ln -s /config/videoserverd.config /opt/ivideon/ivideon-server/videoserverd.config

[ ! -f /config/schedule.json ] && cp /DEFAULT/schedule.json /config/schedule.json
[ ! -f /opt/ivideon/ivideon-server/schedule.json ] && ln -s /config/schedule.json /opt/ivideon/ivideon-server/schedule.json

touch /config/service.log
[ ! -f /opt/ivideon/ivideon-server/service.log ] && ln -s /config/service.log /opt/ivideon/ivideon-server/service.log

chown -R www-data:www-data /config/* /archive

# Register server in Ivideon Cloud
if [[ `grep account /opt/ivideon/ivideon-server/videoserverd.config` ]]; then
	echo "This server is already registered in Ivideon cloud."
else
	echo "Registering server in Ivideon cloud..."
	/opt/ivideon/ivideon-server/videoserver --config-filename=/opt/ivideon/ivideon-server/videoserverd.config --attach --email="$1" --server-name="$2"
fi

/opt/ivideon/ivideon-server/initd.sh restart

tail -f /opt/ivideon/ivideon-server/service.log
