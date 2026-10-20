# Redis

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-redis) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Fredis) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Fredis) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bfren/docker-redis/dev.yml?branch=main)

[Docker Hub](https://hub.docker.com/r/bfren/redis) - [Quay.io](https://quay.io/repository/bfren/redis) - [bfren ecosystem](https://github.com/bfren/docker)

## Introduction

[Redis](https://redis.io) server, configured with environment variables. It is built on [Alpine + S6](https://github.com/bfren/docker-alpine-s6), with Redis from Alpine's packages - each Redis version uses the newest Alpine release that has it.

It is meant to be used inside a private Docker network, by other containers - for example as the cache or metadata store for [Send](https://github.com/bfren/docker-send). By default anyone who can reach port 6379 can use it, so don't publish the port unless you set a password.

## Quickstart

```yaml
services:
  redis:
    image: quay.io/bfren/redis:redis8
    restart: unless-stopped
    volumes:
      - ./v/redis:/data

  app:
    image: your/app
    environment:
      - REDIS_HOST=redis
```

Run `docker compose up -d` - your app connects to `redis:6379`. To use the Redis CLI:

```sh
docker compose exec redis redis-cli
```

## Features

* 🟥 Redis 6, 7 and 8 - choose with the image tag
* ⚙️ Password, bind address, persistence, log level and client limit set with environment variables
* 💾 Data saved to `/data` with Redis's default snapshot schedule, and optional append-only file
* 🩺 Health check that pings the server, using the password if one is set
* 👤 Redis runs as `redis` (UID 1000), not root
* 🧪 Built-in tests

## Tags

Images are published to Docker Hub (`bfren/redis`) and Quay.io (`quay.io/bfren/redis`) for `linux/amd64`, `linux/arm/v7` and `linux/arm64`.

| Tag                            | Example           | Use when                                                        |
| ------------------------------ | ----------------- | --------------------------------------------------------------- |
| `redisN`                       | `redis8`          | You want the latest image for a Redis version - **recommended** |
| `redisN.M`                     | `redis8.8`        | You want the latest image for a Redis minor version             |
| `redisN.M.R`                   | `redis8.8.0`      | You want an exact Redis release                                 |
| `redisN-VERSION`               | `redis8-6.1.16`   | You want to pin this image exactly                              |
| `redisN.M-VERSION`             | `redis8.8-6.1.16` | You want to pin both                                            |
| `latest`, `6`, `6.1`, `6.1.16` |                   | As above, on Redis 8                                            |

| Redis | Release | Alpine |
| ----- | ------- | ------ |
| 8     | 8.8.0   | 3.24   |
| 7     | 7.2.11  | 3.21   |
| 6     | 6.2.18  | 3.15   |

Use Redis 8 for anything new - Redis 6 and 7 are kept for apps that need them.

## Configuration

### Ports

| Port   | Purpose |
| ------ | ------- |
| `6379` | Redis   |

### Volumes

| Volume  | Purpose                                                                             |
| ------- | ----------------------------------------------------------------------------------- |
| `/data` | Snapshots (`dump.rdb`) and the append-only file, owned by `redis` (UID / GID 1000). |

### Environment Variables

| Variable                  | Values                                  | Description                                                                                                                      | Default    |
| ------------------------- | --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| `BF_REDIS_PASS`           | string                                  | Clients must authenticate with this password (`requirepass`).                                                                    |            |
| `BF_REDIS_BIND`           | addresses                               | Only listen on these addresses, separated by spaces - leave empty to listen on all interfaces.                                   |            |
| `BF_REDIS_PROTECTED_MODE` | `no`, `yes`                             | Redis's protected mode - with `yes`, only local clients can connect unless a password or bind address is set.                    | `no`       |
| `BF_REDIS_LOG_LEVEL`      | `debug`, `verbose`, `notice`, `warning` | Log level.                                                                                                                       | `notice`   |
| `BF_REDIS_MAX_CLIENTS`    | number                                  | Most clients connected at once.                                                                                                  | `10000`    |
| `BF_REDIS_APPEND_ONLY`    | `no`, `yes`                             | Also keep an append-only file, so less is lost if Redis stops suddenly - see [persistence](https://redis.io/topics/persistence). | `no`       |
| `BF_REDIS_APPEND_FSYNC`   | `no`, `everysec`, `always`              | How often the append-only file is written to disk.                                                                               | `everysec` |

See [Alpine + S6](https://github.com/bfren/docker-alpine-s6#environment-variables) for `BF_DEBUG`, `BF_TZ` and the other base image variables.

## How It Works

On every start `/etc/redis/redis.conf` is generated from the environment variables, then `redis-server` runs under S6 as `redis`. The container stops if Redis crashes.

Redis saves a snapshot of the data to `/data/dump.rdb` using its default schedule: after an hour if at least 1 key changed, after 5 minutes if 100 changed, and after a minute if 10,000 changed. With `BF_REDIS_APPEND_ONLY=yes` every write is also logged, so at most about a second is lost (with `everysec`). Mount a volume at `/data` to keep the data when the container is replaced.

The health check (every 30 seconds) runs `redis-cli ping` against the first address in `BF_REDIS_BIND`, or the container's address if that is empty, and passes `BF_REDIS_PASS` if it is set.

### Host configuration

Redis warns at start-up if memory overcommit is turned off, as background saves (which fork the process) may then fail when memory is low. This is a kernel setting, so it can't be changed from inside the container - set it on the Docker host:

```sh
sudo sysctl vm.overcommit_memory=1
echo 'vm.overcommit_memory = 1' | sudo tee /etc/sysctl.d/99-overcommit.conf
```

## Testing

```sh
./test.nu                   # builds Redis 8 and runs /test
./test.nu 6                 # or any version directory
./test.nu --all             # every version, in parallel
./run.sh 8                  # builds and opens a shell
./generate-dockerfiles.sh   # regenerates the Dockerfiles from Dockerfile.esh
```

`/test` runs this image's tests alongside the base images' tests: the generated `redis.conf` (defaults, settings, bind address, password and snapshots), how the health check chooses its address and password, and the installed Redis version.

## Troubleshooting

### Clients get `NOAUTH Authentication required`

`BF_REDIS_PASS` is set - give the same password to your app.

### Clients can't connect

Check the app uses the Redis container's name and port 6379, on the same Docker network. If `BF_REDIS_BIND` is set, Redis only listens on those addresses.

### Data is lost when the container is replaced

Mount a volume at `/data`. Snapshots are only taken on Redis's schedule, so turn on `BF_REDIS_APPEND_ONLY` if losing the last few minutes matters.

### `WARNING Memory overcommit must be enabled!`

See [Host configuration](#host-configuration).

## FAQs

### Should I publish port 6379?

Only if something outside Docker needs Redis, and then set `BF_REDIS_PASS` and publish it to `127.0.0.1` only (e.g. `"127.0.0.1:6379:6379"`). Redis is not designed to be exposed to the internet.

### Can I add my own Redis settings?

`redis.conf` is generated on every start, so changes to it are lost. Build your own image from this one and change `/etc/bf/templates/redis.conf.esh`.

## Licence

> [MIT](https://mit.bfren.dev/2020)

## Copyright

> Copyright (c) 2020-2026 [bfren](https://bfren.dev) (unless otherwise stated)
