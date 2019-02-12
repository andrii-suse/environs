(
set -e
cd __srcdir
autoreconf -f -i 
./configure
make
)
