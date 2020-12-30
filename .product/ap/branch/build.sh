mkdir -p __installdir
( cd __workdir/src
   [ -f configure ] || ./buildconf
   [ -f Makefile ]  || ./configure --prefix=__installdir
   make
   make install
)
