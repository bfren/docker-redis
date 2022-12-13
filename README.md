# Docker Redis

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-redis) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Fredis) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Fredis) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/bfren/docker-redis/dev)

[Docker Repository](https://hub.docker.com/r/bfren/redis) - [bfren ecosystem](https://github.com/bfren/docker)

Basic Redis image with support for v6 and v7 and various configuration options.

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
| `REDIS_AUTH`           | string                          | If set, all requests will require the AUTH header.                                                                                      | *blank*  |
| `REDIS_BIND`           | IP                              | Leave this blank to bind Redis to all network interfaces - only do this if you are using Redis within a private Docker network.         | *blank*  |
| `REDIS_LOG_LEVEL`      | debug, verbose, notice, warning | Log level.                                                                                                                              | notice   |
| `REDIS_MAX_CLIENTS`    | integer                         | The maximum number of clients this instance can serve.                                                                                  | 10000    |
| `REDIS_APPEND_ONLY`    | no, yes                         | See [here](https://redis.io/topics/persistence).                                                                                        | no       |
| `REDIS_APPEND_FSYNC`   | no, always, everysec            | See [here](http://antirez.com/post/redis-persistence-demystified.html).                                                                 | everysec |

## Licence

> [MIT](https://mit.bfren.dev/2020)

## Copyright

> Copyright (c) 2020-2022 [bfren](https://bfren.dev) (unless otherwise stated)
