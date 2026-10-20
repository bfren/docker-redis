use bf

# Return the environment variables redis-cli needs to authenticate - empty if no password is set
export def cli_env []: nothing -> record {
    # records are wrapped in brackets, otherwise {} is an empty block (which returns nothing)
    match (bf env --safe REDIS_PASS) {
        "" => ({})
        $p => ({REDISCLI_AUTH: $p})
    }
}

# Return the address the health check should ping: the first address in BF_REDIS_BIND if it is set (Redis may not
# be listening anywhere else), otherwise the first of the container's addresses, or 127.0.0.1 if there are none
export def ping_host [
    addresses: string   # The container's addresses, as output by 'hostname -i' (there may be more than one)
]: nothing -> string {
    let bind = bf env --safe REDIS_BIND
        | split row " "
        | where {|x| $x != "" }
        | each {|x| $x | str trim --left --char "-" }
    let container = $addresses
        | split row " "
        | str trim
        | where {|x| $x != "" }
    $bind
        | append $container
        | append "127.0.0.1"
        | first
}
