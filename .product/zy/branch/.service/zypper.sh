if [ "$1" == ar ] || [ "$1" == addrepo ]; then
    __installdir/bin/zypper --root __workdir/__service addrepo https://mirrorcache.opensuse.org/repositories/$2/__service $2
elif [ "$1" == rr ] || [ "$1" == removerepo ]; then
    __installdir/bin/zypper --root __workdir/__service removerepo $2
else
    __installdir/bin/zypper --root __workdir/__service "$@"
fi
