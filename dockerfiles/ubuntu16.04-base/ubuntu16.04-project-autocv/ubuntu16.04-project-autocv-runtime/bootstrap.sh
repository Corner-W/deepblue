#!/bin/bash

set -e
# do some configuration
#
/bin/bash  /tmp/config/config.sh

exec tini -- $*

