#!/bin/bash
# environ.sh will make sure that environ exists

set -e

productN=${1%-*}
product=${productN%?}

[ $productN = $1 ] || [[ "${1}" =~ ($productN-)(.*)$ ]] || { >&2 echo "Format error, expected {product}{[0-9]}-environ"; exit 1; }

# try to stop existing environ, if possible
[ ! -x ./${productN}*/stop.sh ] || ./${productN}*/stop.sh || :

# if environ already exists do nothing, unless REBUILD is set
[ ! -d ./${1} ] || [ x${REBUILD} == x1 ] || exit 0

./replant.sh $*
./build.sh $1
