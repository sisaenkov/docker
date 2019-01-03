# sisaenkov/transmission
[![](https://images.microbadger.com/badges/version/sisaenkov/transmission:2.94.svg)](https://microbadger.com/images/sisaenkov/transmission:2.94) [![](https://images.microbadger.com/badges/image/sisaenkov/transmission.svg)](https://microbadger.com/images/sisaenkov/transmission) ![](https://img.shields.io/docker/pulls/sisaenkov/transmission.svg) ![](https://img.shields.io/docker/stars/sisaenkov/transmission.svg)

[Transmission](http://www.transmissionbt.com/about/) is designed for easy, powerful use. Transmission has the features you want from a BitTorrent client: encryption, a web interface, peer exchange, magnet links, DHT, µTP, UPnP and NAT-PMP port forwarding, webseed support, watch directories, tracker editing, global and per-torrent speed limits, and more.

[![transmission](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/transmission.png)](https://transmissionbt.com)

## Overview
* Based on [linuxserver/transmission](https://github.com/linuxserver/docker-transmission).
* Optimized for myself: [Transmission easy client Chrome extension](https://chrome.google.com/webstore/detail/transmission-easy-client/cmkphjiphbjkffbcbnjiaidnjhahnned) + [FreeNAS 11.2](http://freenas.org/) + [portainer.io](https://www.portainer.io/) [templates](https://github.com/sisaenkov/docker/blob/master/portainer/templates.json).
* Disabled creation of complete/incomplete directories, disabled /watch directory.

## Usage

```bash
$ docker run -d --name=transmission --restart=always \
	-v <path_to_config>:/config \
	-v <path_to_downloads>:/downloads \
	-e PGID=<gid> -e PUID=<uid> \
	-e TZ=<timezone> \
	-p 9091:9091 -p 10894:10894 \
	-p 10894:10894/udp \
	sisaenkov/transmission
```

## Parameters

### Volumes:
* `/config` - transmission config files and logs directory
* `/downloads` - local path for downloads
 
### Ports:
* `9091/tcp` (WebUI port)
* `10894/tcp` (peer listening port)
* `10894/udp` (peer listening port)

### Environment variables:
| Variable | Default | Description |
|--|--|--|
| `PUID` | 1020 | specifies the GroupID for the container internal transmission group (used for file ownership) |
| `PGID` | 1020 | specifies the UserID for the container internal transmission user (used for process and file ownership) |
| `TZ` || timezone information, e.g. Europe/Moscow |

## Setting up the application 

WebUI is on port 9091, the settings.json file in /config has extra settings not available in the webui. Stop the container before editing it or any changes won't be saved.

## Securing the webui with a username/password.

This requires 3 settings to be changed in the settings.json file.

**Make sure the container is stopped before editing these settings.**

`"rpc-authentication-required": true,` - check this, the default is false, change to true.

`"rpc-username": "transmission",` - substitute transmission for your chosen user name, this is just an example.

`rpc-password` will be a hash starting with {, replace everything including the { with your chosen password, keeping the quotes. Transmission will convert it to a hash when you restart the container after making the above edits.

## Updating Blocklists Automatically

This requires `"blocklist-enabled": true,` to be set. By setting this to true, it is assumed you have also populated `blocklist-url` with a valid block list.

The automatic update is a shell script that downloads a blocklist from the url stored in the settings.json, gunzips it, and restarts the transmission daemon.

The automatic update will run once a day at 3am local server time.

## Info

* To monitor the logs of the container in realtime
`docker logs -f transmission`

* container version number 
`docker inspect -f '{{ index .Config.Labels "build_version" }}' transmission`

* image version number
`docker inspect -f '{{ index .Config.Labels "build_version" }}' sisaenkov/transmission`
