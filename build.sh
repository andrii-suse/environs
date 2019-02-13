#!/bin/bash

set -e

[ ! -x ./${1}*/clone.sh ] || ./${1}*/clone.sh || :
[ ! -x ./${1}*/build.sh ] || ./${1}*/build.sh
[ ! -x ./${1}*/init_db.sh ] || ./${1}*/init_db.sh
