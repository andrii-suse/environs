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

dtdir="${workdir}/dt"
srcdir="${workdir}/src"
blddir="${workdir}/bld"
installdir="${workdir}/install"
wid=${productN: -1}

opts="-D__wid=$wid -D__workdir=$workdir -D__srcdir=$srcdir -D__blddir=$blddir -D__installdir=$installdir -D__datadir=$dtdir -D__branch=$branch"

[ "$product" != ap  ] || port=$(($wid * 10 + 1234))
[ "$product" != ap  ] || opts="$opts -D__port=$port"

if test -z "${branch}" && test -d ${2}; then
  if  ! test -d "${3}"; then
    ln -sf $2 $workdir/src
  else
    mkdir -p $workdir/src
    ln -sf $2 $workdir/src/$(basename $2)
    ln -sf $3 $workdir/src/$(basename $3)
  fi
fi


(
shopt -s nullglob
for filename in .product/.common/branch/* ; do
    m4 $opts $filename > $workdir/$(basename $filename)
    chmod +x $workdir/$(basename $filename)
done

for filename in .product/${product}/branch/* ; do
    if [ -d $filename ] ; then
        folder=$filename
        mkdir -p $workdir/$(basename $folder) 
        for src in ${folder}/* ; do
            dst=$workdir/$(basename $folder)/$(basename $src)
            m4 $opts $src > $dst
	    [ "${dst##*.}" != sh ] || chmod +x $dst
        done
    else
        [ ! -z ${branch} ] || [ $(basename $filename) != "clone.sh" ] || continue # skip clone.sh if branch is empty
        m4 $opts $filename > $workdir/$(basename $filename)
        chmod +x $workdir/$(basename $filename)
    fi
done

# generate services from .services.lst
[ ! -f .product/${product}/branch/.service.lst  ] || for service in $(cat .product/${product}/branch/.service.lst) ; do
    mkdir -p ${workdir}/${service}
    for src in .product/${product}/branch/.service/* ; do
        dst=$workdir/${service}/$(basename $src)
        m4 $opts -D__service=$service $src > $dst
        chmod +x $dst
    done
    grep -q .service.lst .product/${product}/branch/.service/*.sh | grep -qv .product || cp .product/${product}/branch/.service.lst $workdir/
done

)
