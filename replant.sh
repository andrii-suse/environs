#!/bin/bash

set -e

[ ! -z $1 ] || exit 1

productN=${1%-*}
product=${productN%?}

[ $productN = $1 ] || [[ "${1}" =~ ($productN-)(.*)$ ]] || { >&2 echo "Format error, expected {product}{[0-9]}-environ"; exit 1; }

[ ! -x ./${productN}*/stop.sh ] || ./${productN}*/stop.sh || :

[ ! -d ./${productN}* ] || rm -rf ./${productN}*

mkdir ./${1}

./plant.sh $*
