set -ex
. $(dirname "${BASH_SOURCE[0]}")/up.${1:-system2}

# Leap 15.3 is not supported yet
sed -i '/15.3/d' zy9*/.service.lst
rm -r zy9*/*15.3 

zy9*/zypper.sh ar Apache:MirrorBrain
zy9*/zypper.sh --gpg-auto-import-keys --no-gpg-checks refresh
zy9*/zypper.sh -n in --download-only mirrorbrain 
