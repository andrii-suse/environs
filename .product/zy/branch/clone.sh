set -e
mkdir -p __srcdir/libzypp
mkdir -p __srcdir/zypper

git clone --depth=1 http://github.com/openSUSE/libzypp -b __branch __srcdir/libzypp/
git clone --depth=1 http://github.com/openSUSE/zypper -b __branch __srcdir/zypper/
