#!/bin/bash
set -e

productN=${1%-*}
product=${productN%?}

workdir=$(find . -maxdepth 1 -type d -name "${productN}-system2" | head -1)

[[ -d $workdir ]] || { >&2 echo "Directory must exists in format $productN-system2"; exit 1; }

# folder must be empty, so we don't overwrite anything
if find "${workdir}" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
    (>&2 echo "Non-empty $workdir aready exists, expected unassigned worker id"; exit 1;)
fi

workdir="$(pwd)/${productN}-system2"
[[ -d "$workdir" ]] || mkdir "$workdir"

dt="${workdir}/dt"

wid=${productN: -1}

(

[ "$product" != ap  ] || port=$(($wid * 10 + 1234))

shopt -s nullglob
for filename in .product/.common/system2/* ; do
    m4 -D__wid=$wid -D__workdir=$workdir -D__datadir=$dt -D__port=$port $filename > $workdir/$(basename $filename)
    [[ $filename != *.sh ]] || chmod +x $workdir/$(basename $filename)
done || :

for filename in .*/${product}/system2/* ; do
    m4 -D__wid=$wid -D__workdir=$workdir -D__datadir=$dt -D__port=$port $filename > $workdir/$(basename $filename)
    [[ $filename != *.sh ]] || chmod +x $workdir/$(basename $filename)
done || :

# generate services from .services.lst
[ ! -f .product/${product}/system2/.service.lst ] || for service in $(cat .product/${product}/system2/.service.lst) ; do
    mkdir -p ${workdir}/${service}
    for src in .product/${product}/system2/.service/* ; do
        dst=$workdir/${service}/$(basename $src)
        m4 -D__wid=$wid -D__workdir=$workdir -D__datadir=$dt -D__port=$port -D__service=$service $src > $dst
        [[ $src != *.sh ]] || chmod +x $dst
    done
    grep -q .service.lst .product/${product}/system2/.service/*.sh | grep -qv .product || cp .product/${product}/system2/.service.lst $workdir/
done

)
