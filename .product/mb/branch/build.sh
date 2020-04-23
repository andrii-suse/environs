( cd __workdir/src
meson setup build
meson configure --prefix=/usr --datadir=/usr/share -Dmemcached=false -Dinstall-icons=false build
ninja -v -C build
mkdir install
DESTDIR=$(pwd)/install  ninja -v -C build install
 )
