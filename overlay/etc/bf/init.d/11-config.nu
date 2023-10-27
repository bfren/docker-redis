use bf
bf env load

# Generate redis configuration file and apply permissions
def main [] {
    # ensure redis configuration directory exists
    let etc = (bf env REDIS_ETC)
    mkdir $etc

    # generate configuration
    bf write "Generating redis configuration."
    bf esh template (bf env REDIS_CONF | path basename) $etc
    bf ch apply_file "10-redis"
}
