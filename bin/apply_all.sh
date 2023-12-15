#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

cd $SCRIPT_DIR

FILES=$(find . -type f -name 'apply_*' -not -name apply_all.sh -not -name apply_base.sh)

./apply_base.sh

for FILE in $FILES; do
  $FILE
done
