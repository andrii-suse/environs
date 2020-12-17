set -e
[ ! -d __workdir/openSUSE_Tumbleweed ] || for oss in oss non-oss; do
        __workdir/openSUSE_Tumbleweed/zypper.sh ar http://mirrorcache.opensuse.org/tumbleweed/repo/$oss download-$oss
done
[ ! -d __workdir/openSUSE_Tumbleweed ] || for oss in {,-non-oss}; do
    __workdir/openSUSE_Tumbleweed/zypper.sh ar http://mirrorcache.opensuse.org/download/update/tumbleweed$oss download$oss-update
done

for leap in 15.1 15.2 15.3; do
    [ ! -d __workdir/openSUSE_Leap_$leap ] || for oss in oss non-oss; do
        __workdir/openSUSE_Leap_$leap/zypper.sh ar http://mirrorcache.opensuse.org/distribution/leap/$leap/repo/$oss download-$oss
        __workdir/openSUSE_Leap_$leap/zypper.sh ar http://mirrorcache.opensuse.org/update/leap/$leap/$oss download-update-$oss
    done
done
