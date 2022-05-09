# Docker Redis

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-redis) ![Docker Pulls](https://img.shields.io/docker/pulls/bfren/redis?label=pulls) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/bfren/redis/latest?label=size)<br/>
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bfren/docker-redis/dev-6?label=Redis+6) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bfren/docker-redis/dev-7?label=Redis+7)

[Docker Repository](https://hub.docker.com/r/bfren/redis) - [bfren ecosystem](https://github.com/bfren/docker)

I've been using [webhippie](https://github.com/dockhippie/redis)'s Redis image for a while, but I wanted to use the latest version of [Redis](https://redis.io/), and have a little more control over the image.

## Contents

* [Ports](#ports)
* [Environment Variables](#environment-variables)
* [Licence / Copyright](#licence)

## Ports

* 6379

## Environment Variables

| Variable               | Values                          | Description                                                                                                                             | Default  |
| ---------------------- | ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| `REDIS_PROTECTED_MODE` | no, yes                         | Change this to 'yes' if you are exposing Redis to the internet, and set REDIS_BIND to the server IP (you should not normally do this!). | no       |
| `REDIS_AUTH            | string                          | If set, all requests will require the AUTH header.                                                                                      | *blank*  |
| `REDIS_BIND`           | IP                              | Leave this blank to bind Redis to all network interfaces - only do this if you are using Redis within a private Docker network.         | *blank*  |
| `REDIS_LOG_LEVEL`      | debug, verbose, notice, warning | Log level.                                                                                                                              | notice   |
| `REDIS_MAX_CLIENTS`    | integer                         | The maximum number of clients this instance can serve.                                                                                  | 10000    |
| `REDIS_APPEND_ONLY`    | no, yes                         | See [here](https://redis.io/topics/persistence).                                                                                        | no       |
| `REDIS_APPEND_FSYNC`   | no, always, everysec            | See [here](http://antirez.com/post/redis-persistence-demystified.html).                                                                 | everysec |

## Licence

> [MIT](https://mit.bfren.dev/2020)

## Copyright

> Copyright (c) 2020-2022 [bfren](https://bfren.dev) (unless otherwise stated)
