#!/bin/bash

set -e
: "${ENVIRON_LOCATION:=.product}"

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --rebuild)
    if [[ "$2" == --* ]] || [ -z "$2" ]; then 
        ENVIRON_REBUILD=1
    else 
        ENVIRON_REBUILD="$2"
        shift # past value
    fi
    shift # past argument
    ;;
    --no-build|--skip-build)
    ENVIRON_BUILD=0
    shift
    ;;
    --build)
    if [[ "$2" == --* ]] || [ -z "$2" ]; then 
        ENVIRON_BUILD=1
    else
        ENVIRON_BUILD="$2"
        shift # past value
    fi
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

productN=${1%-*}
product=${productN%?}

[ $productN = $1 ] || [[ "${1}" =~ ($productN-)(.*)$ ]] || { >&2 echo "Format error, expected {product}{[0-9]}-environ"; exit 1; }

# try to stop existing environ, if possible
[ ! -x ./${productN}*/stop.sh ] || ./${productN}*/stop.sh || :

# if environ already exists the do nothing, unless --rebuild or global variable ENVIRON_REBUILD=1
[ ! -d ./${1} ] || [ x${ENVIRON_REBUILD} == x1 ] || exit 0

for f in ./${productN}*/*/stop.sh; do
    test -x $f || continue
    $f
done

[ ! -d ./${productN}* ] || rm -rf ./${productN}*

mkdir ./${1}

if [ "$1" = ${productN} ] ; then
    [ x$2 != x ] || { >&2 echo "Expected path to sources as second parameter"; exit 1; }
    [ -d "$2" ] || { >&2 echo "Cannot find path {$2}"; exit 1; }
else
    [[ "${1}" =~ ($productN-)(.*)$ ]] || { >&2 echo "Format error, expected {product}{[0-9]}-environ"; exit 1; }
    environ=${BASH_REMATCH[2]}
fi

if [ "$environ" = system2 ] ; then

[ -d "${ENVIRON_LOCATION}"/${product}/system2 ] || ( >&2 echo "Cannot find 'system2' templates for {$product}" ; exit 1 )
plant_script="${ENVIRON_LOCATION}"/${product}/system2/.plant.sh
[ -e ${plant_script} ] || plant_script="${ENVIRON_LOCATION}"/.common/system2/.plant.sh


elif [ "$environ" = system ] ; then

[ -d ${ENVIRON_LOCATION}/${product}/system ] || ( >&2 echo "Cannot find 'system' templates for {$product}" ; exit 1 )
plant_script=${ENVIRON_LOCATION}/${product}/system/.plant.sh
[ -e ${plant_script} ] || plant_script=${ENVIRON_LOCATION}/.common/system/.plant.sh

else

[ -d "${ENVIRON_LOCATION}"/${product}/branch ] || ( >&2 echo "Cannot find branch templates for {$product}" ; exit 1 )
plant_script="${ENVIRON_LOCATION}"/${product}/branch/.plant.sh
[ -e ${plant_script} ] || plant_script="${ENVIRON_LOCATION}"/.common/branch/.plant.sh

fi

if [ $(find . -maxdepth 1 -name "$productN*" -type d |wc -l || :) -eq 1 ] ; then
    ${plant_script} $*
else
    >&2 echo "Expect one and only one folder matching {$productN}, got "$(find . -maxdepth 1 -name "$productN*" -type d |wc -l)
    exit 1
fi

[ ! -x ./${1}*/clone.sh ] || ./${1}*/clone.sh || :
[ "$ENVIRON_BUILD" == 0 ] || [ ! -x ./${1}*/build.sh   ] || ./${1}*/build.sh
[ "$ENVIRON_INIT"  == 0 ] || [ ! -x ./${1}*/init_db.sh ] || ./${1}*/init_db.sh
