use std/assert
use bf-redis


#======================================================================================================================
# cli_env
#======================================================================================================================

export def cli_env__is_empty_without_password [] {
    assert equal {} (bf-redis health cli_env)
}

export def cli_env__passes_password [] {
    assert equal {REDISCLI_AUTH: "secret"} (with-env {BF_REDIS_PASS: "secret"} { bf-redis health cli_env })
}


#======================================================================================================================
# ping_host
#======================================================================================================================

export def ping_host__uses_container_address [] {
    assert equal "172.18.0.2" (bf-redis health ping_host "172.18.0.2")
}

export def ping_host__uses_first_of_several_addresses [] {
    # 'hostname -i' can output more than one address, e.g. on a network with IPv6
    assert equal "172.18.0.2" (bf-redis health ping_host "172.18.0.2 fd00::2 ")
}

export def ping_host__uses_localhost_without_addresses [] {
    assert equal "127.0.0.1" (bf-redis health ping_host "")
}

export def ping_host__uses_bind_address_when_set [] {
    # Redis only listens on the bind addresses, so the container's own address may not answer
    let result = with-env {BF_REDIS_BIND: "-127.0.0.1 ::1"} { bf-redis health ping_host "172.18.0.2" }

    assert equal "127.0.0.1" $result
}
