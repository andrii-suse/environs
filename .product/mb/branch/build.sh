( cd __workdir/src
meson setup build
# sleep 1
meson configure --prefix=/usr --datadir=/usr/share -Dmemcached=false -Dinstall-icons=false build
ninja -v -C build
mkdir install
DESTDIR=$(pwd)/install  ninja -v -C build install
 )
