# Ivideon Video Server (without GUI)
[![](https://images.microbadger.com/badges/version/sisaenkov/ivideon-server.svg)](https://microbadger.com/images/sisaenkov/ivideon-server) [![](https://images.microbadger.com/badges/image/sisaenkov/ivideon-server.svg)](https://microbadger.com/images/sisaenkov/ivideon-server) ![](https://img.shields.io/docker/pulls/sisaenkov/ivideon-server.svg) ![](https://img.shields.io/docker/stars/sisaenkov/ivideon-server.svg)

A cloud-based video surveillance solution for business and the home. **Ivideon** is easy to set up, maintain, and scale, no matter how many locations you have. It can easily cope with any number of cameras.

[![ivideon](https://i1.wp.com/missiontech.com.au/wp-content/uploads/2017/08/Ivideon-Logo.png)](https://ivideon.com)
#### Version 3.7.0.2642

## Usage

### Volumes:

* `<path to data>:/config`
where ivideon should store config files

## Description

* /config/config.xml - ivideon.ru access settings
* /config/schedule.json - job scheduler
* /config/videoserverd.config - cams and logs

This image based on https://github.com/ErshovSergey/ivideon_ubuntu1604

