#!/usr/bin/env bats

setup() {
    apt-get install -y curl >/dev/null || yum -y install curl >/dev/null
}

@test "process postgres should be running" {
    run pgrep postgres
    [ "$status" -eq 0 ]
    [[ "$output" != "" ]]
}

@test "process rabbitmq should be running" {
    run pgrep rabbitmq
    [ "$status" -eq 0 ]
    [[ "$output" != "" ]]
}

@test "process mig-api should be running" {
    run pgrep mig-api
    [ "$status" -eq 0 ]
    [[ "$output" != "" ]]
}

@test "process mig-scheduler should be running" {
    run pgrep mig-scheduler
    [ "$status" -eq 0 ]
    [[ "$output" != "" ]]
}

@test "rabbitmq answering cmd - sudo -u rabbitmq rabbitmqctl status" {
    run sudo -u rabbitmq rabbitmqctl status
    [ "$status" -eq 0 ]
    [[ "$output" != "" ]]
}

@test "rabbitmq answering cmd - sudo -u rabbitmq rabbitmqctl eval 'node().'" {
    run sudo -u rabbitmq rabbitmqctl eval 'node().'
    [ "$status" -eq 0 ]
    [[ "$output" != "" ]]
}

@test "API url should be accessible internally" {
    run curl -sSq http://localhost:51664/api/v1/
    [ "$status" -eq 0 ]
    [[ "$output" =~ "\"version\":\"1.0\"" ]]
}

@test "API url should be accessible through nginx" {
    run curl -sSq http://localhost/api/v1/
    [ "$status" -eq 0 ]
    [[ "$output" =~ "\"version\":\"1.0\"" ]]
}

@test "API dashboard should be accessible through nginx" {
    run curl -sSq http://localhost/api/v1/dashboard
    [ "$status" -eq 0 ]
    [[ "$output" =~ "\"version\":\"1.0\"" ]]
}

