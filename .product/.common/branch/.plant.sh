#!/bin/bash
set -e

productN=${1%-*}
product=${productN%?}

workdir=$(find . -maxdepth 1 -type d -name "${productN}*" | head -1)

[[ -d $workdir ]] || { >&2 echo "Directory must exists in format $productN-branch"; exit 1; }

# folder must be empty, so we don't overwrite anything
# if find "${workdir}" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
#     (>&2 echo "Non-empty $workdir aready exists, expected unassigned worker id"; exit 1;)
# fi

[[ $workdir =~ ($productN-?)(.*)$ ]] || { >&2 echo "Couldn't parse format of $workdir, expected $productN-branch"; exit 1; }

branch=${BASH_REMATCH[2]}

workdir="$(pwd)/${productN}"
[ -z "$branch" ] || workdir="$workdir-$branch"
[[ -d "$workdir" ]] || mkdir "$workdir"

srcdir="${workdir}/src"

wid=${productN: -1}

[ ! -z ${branch} ] || [ -d ${2} ]
[ ! -z ${branch} ] || ln -sf $2 $workdir/src

(
shopt -s nullglob
for filename in .product/.common/branch/* ; do
    m4 -D__wid=$wid -D__workdir=$workdir -D__srcdir=$srcdir -D__branch=$branch $filename > $workdir/$(basename $filename)
    chmod +x $workdir/$(basename $filename)
done

for filename in .product/${product}/branch/* ; do
    if [ -d $filename ] ; then
        folder=$filename
        mkdir -p $workdir/$(basename $folder) 
        for src in ${folder}/* ; do
            dst=$workdir/$(basename $folder)/$(basename $src)
            m4 -D__wid=$wid -D__workdir=$workdir -D__srcdir=$srcdir -D__branch=$branch $src > $dst
	    [ "${dst##*.}" != sh ] || chmod +x $dst
        done
    else
        [ ! -z ${branch} ] || [ $(basename $filename) != "clone.sh" ] || continue # skip clone.sh if branch is empty
        m4 -D__wid=$wid -D__workdir=$workdir -D__srcdir=$srcdir -D__branch=$branch $filename > $workdir/$(basename $filename)
        chmod +x $workdir/$(basename $filename)
    fi
done

# generate services from .services.lst
[ ! -f .product/${product}/branch/.service.lst  ] || for service in $(cat .product/${product}/branch/.service.lst) ; do
    mkdir -p ${workdir}/${service}
    for src in .product/${product}/branch/.service/* ; do
        dst=$workdir/${service}/$(basename $src)
        m4 -D__wid=$wid -D__workdir=$workdir -D__srcdir=$srcdir -D__branch=$branch -D__service=$service $src > $dst
        chmod +x $dst
    done
done

)
