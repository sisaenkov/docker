# sisaenkov/transmission
* `Based on [linuxserver/transmission](https://github.com/linuxserver/docker-transmission)`
* `Optimized for personal needs: [Transmission easy client Chrome extension](https://chrome.google.com/webstore/detail/transmission-easy-client/cmkphjiphbjkffbcbnjiaidnjhahnned) + [FreeNAS 11.2](http://freenas.org/) + [portainer.io](https://www.portainer.io/) templates.`
* `Also disabled creation of complete/incomplete directories, disabled /watch directory.`

[Transmission](http://www.transmissionbt.com/about/) is designed for easy, powerful use. Transmission has the features you want from a BitTorrent client: encryption, a web interface, peer exchange, magnet links, DHT, µTP, UPnP and NAT-PMP port forwarding, webseed support, watch directories, tracker editing, global and per-torrent speed limits, and more.

[![transmission](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/transmission.png)][appurl]

## Usage

```
docker create --name=transmission \
-v <path to data>:/config \
-v <path to downloads>:/downloads \
-e PGID=<gid> -e PUID=<uid> \
-e TZ=<timezone> \
-p 9091:9091 -p 10894:10894 \
-p 10894:10894/udp \
sisaenkov/transmission
```

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`


* `-p 9091` 
* `-p 10894` - the port(s)
* `-v /config` - where transmission should store config files and logs
* `-v /downloads` - local path for downloads
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
* `-e TZ` for timezone information, eg Europe/London

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it transmission /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application 

Webui is on port 9091, the settings.json file in /config has extra settings not available in the webui. Stop the container before editing it or any changes won't be saved.

## Securing the webui with a username/password.

this requires 3 settings to be changed in the settings.json file.

`Make sure the container is stopped before editing these settings.`

`"rpc-authentication-required": true,` - check this, the default is false, change to true.

`"rpc-username": "transmission",` substitute transmission for your chosen user name, this is just an example.

`rpc-password` will be a hash starting with {, replace everything including the { with your chosen password, keeping the quotes.

Transmission will convert it to a hash when you restart the container after making the above edits.

## Updating Blocklists Automatically

This requires `"blocklist-enabled": true,` to be set. By setting this to true, it is assumed you have also populated `blocklist-url` with a valid block list.

The automatic update is a shell script that downloads a blocklist from the url stored in the settings.json, gunzips it, and restarts the transmission daemon.

The automatic update will run once a day at 3am local server time.

## Info

* To monitor the logs of the container in realtime `docker logs -f transmission`.

* container version number 

`docker inspect -f '{{ index .Config.Labels "build_version" }}' transmission`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/transmission`
