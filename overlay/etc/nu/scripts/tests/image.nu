use std/assert
use bf


#======================================================================================================================
# installation
#======================================================================================================================

export def install__redis_user_has_uid_1000 [] {
    assert equal "1000" (^id -u redis | str trim)
    assert equal "1000" (^id -g redis | str trim)
}

export def install__redis_matches_build [] {
    let build = with-env {BF_ETC: "/etc/bf"} { bf build | get Redis }
    let installed = ^redis-server --version | parse --regex 'v=(?<v>\d+\.\d+\.\d+)' | get v.0

    assert ($build | str starts-with $installed) $"Redis ($installed) should match the build ($build)"
}


#======================================================================================================================
# scripts
#======================================================================================================================

export def scripts__parse [] {
    let paths = [
        "/usr/bin/bf/bf-healthcheck"
        "/etc/s6-overlay/s6-rc.d/redis/run"
        "/etc/s6-overlay/s6-rc.d/redis/finish"
    ]
    for path in $paths {
        let result = ^$nu.current-exe --no-config-file --commands $"nu-check ($path)" | complete
        assert equal "true" ($result.stdout | str trim) $"($path) does not parse: ($result.stderr)"
    }
}
