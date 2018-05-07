#!/usr/bin/env bash

install -m 400 /tmp/host-ssh/id_rsa /root/.ssh/id_rsa
echo -e "Host *\n\tStrictHostKeyChecking no" > /root/.ssh/config

eval $(ssh-agent) 1>/dev/null
ssh-add &>/dev/null
$@
