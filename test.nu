#!/usr/bin/env -S nu -n

use ../index/test.nu

const redis_branches = [
    "6"
    "7"
    "8"
]

# Run test suite for image
def main [
    redis: string = "8"     # define which Redis version to use
    --all (-a)              # test all registered versions of Redis (overrides $redis)
] {
    let branches = if $all { $redis_branches } else { [$redis] }
    test "redis" $branches
}
