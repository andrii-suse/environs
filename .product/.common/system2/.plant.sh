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
shopt -s nullglob
for filename in .product/.common/system2/* ; do
    m4 -D__wid=$wid -D__workdir=$workdir -D__datadir=$dt $filename > $workdir/$(basename $filename)
    chmod +x $workdir/$(basename $filename)
done || :

for filename in .*/${product}/system2/* ; do
    m4 -D__wid=$wid -D__workdir=$workdir -D__datadir=$dt $filename > $workdir/$(basename $filename)
    chmod +x $workdir/$(basename $filename)
done || :
)
