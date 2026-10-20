use std/assert


#======================================================================================================================
# helpers
#======================================================================================================================

# Generate redis.conf from the template in a temporary directory, with $vars added to (and overriding) the defaults set
# in the Dockerfile, and return its lines without comments or blank lines
def render [vars: record = {}]: nothing -> list<string> {
    let file = $"(mktemp --directory)/redis.conf"
    let defaults = {
        BF_REDIS_APPEND_ONLY: "no"
        BF_REDIS_APPEND_FSYNC: "everysec"
        BF_REDIS_BIND: ""
        BF_REDIS_LOG_LEVEL: "notice"
        BF_REDIS_MAX_CLIENTS: "10000"
        BF_REDIS_PASS: ""
        BF_REDIS_PROTECTED_MODE: "no"
        BF_REDIS_DATA: "/data"
    }
    with-env ($defaults | merge $vars) { ^esh -o $file /etc/bf/templates/redis.conf.esh }
    open --raw $file | lines | str trim | where {|x| $x != "" and not ($x starts-with "#") }
}


#======================================================================================================================
# redis.conf
#======================================================================================================================

export def template__uses_defaults [] {
    let conf = render

    for x in ["protected-mode no" "port 6379" "loglevel notice" "dir /data" "maxclients 10000" "appendonly no" "appendfsync everysec"] {
        assert ($x in $conf) $"($x) should be set"
    }
}

export def template__uses_settings [] {
    let conf = render {
        BF_REDIS_APPEND_ONLY: "yes"
        BF_REDIS_APPEND_FSYNC: "always"
        BF_REDIS_LOG_LEVEL: "warning"
        BF_REDIS_MAX_CLIENTS: "100"
        BF_REDIS_PROTECTED_MODE: "yes"
    }

    for x in ["protected-mode yes" "loglevel warning" "maxclients 100" "appendonly yes" "appendfsync always"] {
        assert ($x in $conf) $"($x) should be set"
    }
}

export def template__binds_only_when_set [] {
    assert (render | where {|x| $x starts-with "bind " } | is-empty) "Redis should listen on all interfaces by default"
    assert ("bind 127.0.0.1 ::1" in (render {BF_REDIS_BIND: "127.0.0.1 ::1"}))
}

export def template__requires_password_only_when_set [] {
    assert (render | where {|x| $x starts-with "requirepass" } | is-empty)
    assert ("requirepass secret" in (render {BF_REDIS_PASS: "secret"}))
}

export def template__keeps_default_snapshots [] {
    # with no 'save' lines Redis uses its default snapshot schedule, so data in /data survives a restart
    assert (render | where {|x| $x starts-with "save" } | is-empty)
    assert ("dbfilename dump.rdb" in (render))
}
