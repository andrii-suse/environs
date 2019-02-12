#!/bin/bash

set -e

productN=${1%-*}
product=${productN%?}

[ $productN = $1 ] || [[ "${1}" =~ ($productN-)(.*)$ ]] || { >&2 echo "Format error, expected {product}{[0-9]}-environ"; exit 1; }

[ ! -x ./${1}/stop.sh ] || ./${1}/stop.sh || :

[ ! -d ./${productN}* ] || rm -rf ./${productN}*

mkdir ./${1}

./plant.sh $*
