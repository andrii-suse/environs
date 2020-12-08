set -e
# now build own installdir for each known distri
for dir in $(cat __workdir/.service.lst); do
    mkdir -p __workdir/$dir
    ln -s /usr/bin __workdir/$dir/bin
    ln -s /usr/lib64 __workdir/$dir/lib64
    ln -s /usr/sbin __workdir/$dir/sbin
    ln -s /usr/share __workdir/$dir/share
    mkdir -p __workdir/$dir/var
done

