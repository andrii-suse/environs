set -e
(
mkdir -p __blddir/libzypp
cd __blddir/libzypp
cmake -DCMAKE_INSTALL_PREFIX=__installdir __srcdir/libzypp
make -j 4
mkdir -p __installdir
make install
)
(
mkdir -p __blddir/zypper
cd __blddir/zypper
cmake -DCMAKE_INSTALL_PREFIX=__installdir __srcdir/zypper
make -j 4
make install
)

# now build own installdir for each known distri
for dir in openSUSE_Tumbleweed openSUSE_Leap_15.1 openSUSE_Leap_15.2 openSUSE_Leap_15.3; do
    mkdir -p __workdir/$dir
    ln -s __installdir/bin __workdir/$dir/bin
    ln -s __installdir/lib64 __workdir/$dir/lib64
    ln -s __installdir/sbin __workdir/$dir/sbin
    ln -s __installdir/share __workdir/$dir/share
    mkdir -p __workdir/$dir/var
done

