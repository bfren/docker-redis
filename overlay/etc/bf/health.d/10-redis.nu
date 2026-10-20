use bf
use bf-redis
bf env load -x

# Based on https://github.com/docker-library/healthcheck/blob/master/redis/docker-healthcheck
def main [] {
    # get the address to ping
    let host = { ^hostname -i } | bf handle -i | bf-redis health ping_host $in

    # ping host, passing the password (if set)
    bf write debug $"Pinging redis host ($host)."
    let args = [
        "-h"
        $host
        "ping"
    ]
    let ping = with-env (bf-redis health cli_env) { { ^redis-cli ...$args } | bf handle -i }
    if $ping != "PONG" { exit 1 }
}
