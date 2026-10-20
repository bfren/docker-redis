use bf
use bf-s6
bf env load

# Generate redis configuration file and apply permissions
def main [] {
    # ensure redis configuration directory exists
    let etc = (bf env REDIS_ETC)
    mkdir $etc

    # generate configuration
    bf write "Generating redis configuration."
    bf-s6 esh template (bf env REDIS_CONF)
    bf-s6 ch apply_file "10-redis"
}
