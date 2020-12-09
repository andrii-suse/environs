set -ex
. $(dirname "${BASH_SOURCE[0]}")/up.${1:-system2}

zy9*/openSUSE_Leap_15.2/zypper.sh ar Apache:Test
zy9*/openSUSE_Leap_15.2/zypper.sh -n --gpg-auto-import-keys --no-gpg-checks refresh 
zy9*/openSUSE_Leap_15.2/zypper.sh in -y apache-test
