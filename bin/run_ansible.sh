#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

PLAYBOOK="$1"
ANSIBLE_ADDITIONAL_PARAMETERS="${@:2}"
ANSIBLE_ROOT=$(cd "$SCRIPT_DIR/../ansible" && pwd)

cd "$ANSIBLE_ROOT"

if [ -z $PLAYBOOK ] || [ ! -f $PLAYBOOK ]; then
  echo 'Provide valid playbook file. Playbook "'$PLAYBOOK'" not found.'
  exit 1
fi

ansible-playbook --ask-become-pass $ANSIBLE_ADDITIONAL_PARAMETERS "$PLAYBOOK"
