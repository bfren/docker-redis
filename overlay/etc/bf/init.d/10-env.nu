use bf
bf env load

# Set environment variables
def main [] {
    bf env set "REDIS_DATA" "/data"

    let etc = "/etc/redis"
    bf env set REDIS_ETC $etc
    bf env set "REDIS_CONF" $"($etc)/redis.conf"

    # return nothing
    return
}
