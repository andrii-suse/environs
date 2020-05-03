#!/bin/bash

set -e

productN=${1%-*}
product=${productN%?}

if [ "$1" = ${productN} ] ; then
    [ x$2 != x ] || { >&2 echo "Expected path to sources as second parameter"; exit 1; }
    [ -d "$2" ] || { >&2 echo "Cannot find path {$2}"; exit 1; }
else
    [[ "${1}" =~ ($productN-)(.*)$ ]] || { >&2 echo "Format error, expected {product}{[0-9]}-environ"; exit 1; }
    environ=${BASH_REMATCH[2]}
fi

if [ "$environ" = system2 ] ; then

[ -d .product/${product}/system2 ] || ( >&2 echo "Cannot find 'system2' templates for {$product}" ; exit 1 )
plant_script=.product/${product}/system2/.plant.sh
[ -e ${plant_script} ] || plant_script=.product/.common/system2/.plant.sh


elif [ "$environ" = system ] ; then

[ -d .product/${product}/system ] || ( >&2 echo "Cannot find 'system' templates for {$product}" ; exit 1 )
plant_script=.product/${product}/system/.plant.sh
[ -e ${plant_script} ] || plant_script=.product/.common/system/.plant.sh

else

[ -d .product/${product}/branch ] || ( >&2 echo "Cannot find branch templates for {$product}" ; exit 1 )
plant_script=.product/${product}/branch/.plant.sh
[ -e ${plant_script} ] || plant_script=.product/.common/branch/.plant.sh

fi

if [ $(find . -maxdepth 1 -name "$productN*" -type d |wc -l || :) -eq 1 ] ; then 
    ${plant_script} $*
else
    >&2 echo "Expect one and only one folder matching {$productN}, got "$(find . -maxdepth 1 -name "$productN*" -type d |wc -l) 
    exit 1
fi
