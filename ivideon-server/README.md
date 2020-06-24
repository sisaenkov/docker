# sisaenkov/ivideon-server

[![](https://images.microbadger.com/badges/version/sisaenkov/ivideon-server:3.8.3.4085.svg)](https://microbadger.com/images/sisaenkov/ivideon-server:3.8.3.4085) [![](https://images.microbadger.com/badges/image/sisaenkov/ivideon-server.svg)](https://microbadger.com/images/sisaenkov/ivideon-server) ![](https://img.shields.io/docker/pulls/sisaenkov/ivideon-server.svg) ![](https://img.shields.io/docker/stars/sisaenkov/ivideon-server.svg) [![](https://img.shields.io/badge/github-repo-brightgreen.svg)](https://github.com/sisaenkov/docker/tree/master/ivideon-server)

A cloud-based video surveillance solution for business and the home. **Ivideon** is easy to set up, maintain, and scale, no matter how many locations you have. It can easily cope with any number of cameras.

[![ivideon](https://i1.wp.com/missiontech.com.au/wp-content/uploads/2017/08/Ivideon-Logo.png)](https://ivideon.com)

## Overview
* Ivideon Video Server for Linux (without GUI).

## Usage

```bash
$ docker run -d --name=ivideon-server --restart=always \
	-e EMAIL=your@ivideon.email \
	-e SERVER_NAME=Home \
	-v <path_to_config>:/config \
	-v <path_to_archive>:/archive \
	-p 8080:8080 \
	sisaenkov/ivideon-server
```

If you have no config yet, during first run server will use default one and will automatically be registered in Ivideon Cloud with a name set in `SERVER_NAME` variable.

## Parameters

### Volumes:

* `/config` - config files directory
* `/archive` - video archive directory [optional]

### Ports:
* `8080/tcp` (Ivideon Client local view connection port)

### Environment variables:
| Variable | Default | Description |
|--|--|--|
| `EMAIL` |  | Your ivideon.com account |
| `SERVER_NAME` | Home | Ivideon server name without spaces (displayed in Ivideon Client and Web UI) |

## Config example

* `/config/schedule.json` - job scheduler
* `/config/videoserverd.config` - cameras, logs and archives

The best way to create a configuration file is to setup Ivideon Server application through a graphical interface on any Desktop Windows or Linux system. Then copy obtained config file from `~/.IvideonServer/videoserverd.config` or `C:\Users\<USER>\AppData\Local\Ivideon\IvideonServer\videoserverd.config` to `/config` volume location.

#### videoserverd.config

```json
{
   // default archive location settings
   "archive" : {
      "id" : 0,
      "maxEventLogSize" : 10,           // in MB
      "name" : "Local archive",
      "path" : "/archive",
      "sizeLimit" : 5120,               // in MB
      "sizeToCleanup" : 1024,           // in MB
      "useArchive" : false,			 // set true to enable. Also don't forget to set docker volume.
      "useEventLog" : false,
      "webcamBitRate" : 2048,           // 512, 1024, 2048, 3072, 4096 (kbit/s)
      "webcamFrameRate" : 30,           // 2, 5, 10, 15, 20, 25, 30 (fps)
      "webcamResolution" : 0,           // 0 - high, 1 - medium, 2 - low
      "webcamVideoFormat" : 1           // 0 - MPEG-4, 1 - H.264
   },
   // if you need more that one archive locations, add such array as listed below and set `useArchive` to true.
   // Otherwise you can delete next 18 lines.
   "archives" : [
      {
         "id" : 1,
         "name" : "Second archive",
         "path" : "/mnt/archive2",
         "sizeLimit" : 2048,
         "sizeToCleanup" : 1024,
         "useArchive" : false
      },
      {
         "id" : 2,
         "name" : "Third archive",
         "path" : "/mnt/archive3",
         "sizeLimit" : 2048,
         "sizeToCleanup" : 1024,
         "useArchive" : false
      }
   ],
   "cameras" : [
      // Camera 1
      // example without motion detection, sound and archiving
      {
         "id" : 0,
         "mdExcludedZoneList" : null,
         "name" : "Camera 1 (Ubiquiti)",
         "recordType" : "disable",
         "rtspTransport" : "auto",
         "urlHigh" : "rtsp://192.168.1.5/live/ch00_0",
         "urlMedium" : "rtsp://192.168.1.5/live/ch01_0",
         "urlPreview" : "http://192.168.1.50/snapshot.cgi",
         "useCameraMotionDetector" : false,
         "useSound" : false
      },
      // Camera 2
      // example with continius recording, three video quality urls; without motion detection and sound
      {
         "archiveId" : 0,
         "id" : 1,
         "mdExcludedZoneList" : null,
         "name" : "Camera 2 (other)",
         "recordQuality" : "high",
         "recordType" : "continuous",
         "rtspTransport" : "auto",
         "urlHigh" : "rtsp://admin:password@172.16.1.3",
         "urlMedium" : "rtsp://admin:password@172.16.1.3/v2",
         "urlLow" : "rtsp://admin:password@172.16.1.3/v3",
         "urlPreview" : "http://admin:password@172.16.1.3/GetImage.cgi?CH=0",
         "useCameraMotionDetector" : false,
         "useSound" : false 
      },
      // Camera 3
      // example with motion detection recording; without sound
      {
         "id" : 2,
         "mdExcludedZoneList" : [
            [ 129, 456, 9892, 10000 ]
         ],								   // depends on video stream resolution
         "mdSensitivity" : 60,				// 1-100 (higher - more sensitive)
         "name" : "Camera 3 (Door)",
         "recordQuality" : "high",			// high, medium, low, high+medium, high+low
         "recordType" : "motion",
         "rtspTransport" : "auto",
         "urlHigh" : "rtsp://user:password@192.168.1.4:554/user=user&password=password&channel=1&stream=0.sdp",
         "useCameraMotionDetector" : false,
         "useSound" : false
      }
   ],
   "externalScheduleFile" : "/opt/ivideon/ivideon-server/schedule.json",
   "localView" : {
      "passwordHash" : "",		// md5hash of password for Ivideon Client local view. Can be empty.
      "proxyPort" : 3101,
      "streamerPort" : 8080,
      "useLocalView" : true
   },
   "logging" : {
      "isTruncate" : false,
      "path" : "/dev/null",
      "rtspPath":"/dev/null"
   },
   "network" : {
      "ivideonProxyHost" : "proxy.ivideon.com"
   },
   "system" : {
      "cwd" : "/opt/ivideon/ivideon-server"
   }
}
```

> If you have already setup Ivideon Server via GUI and bound it with Ivideon Cloud there will be `account` parameter block at the begin of config file:

```
   "account" : {
      "email" : "your@ivideon.email",
      "password" : "gYoaXbrYZwqbh7Lc",
      "serverName" : "Home",
      "uin" : 100001234567
   },
```
