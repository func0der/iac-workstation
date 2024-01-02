#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

"$SCRIPT_DIR/run_ansible.sh" pb.common.yml $@
