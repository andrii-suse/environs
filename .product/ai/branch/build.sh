(
set -e
mkdir -p __blddir
cd __blddir
cmake -G Ninja __srcdir
ninja symlinks
)
