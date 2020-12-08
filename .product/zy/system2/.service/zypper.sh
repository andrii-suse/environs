set -e
if [[ "$2" =~ http:// ]] || [[ "$2" =~ https:// ]]; then
    zypper --root __workdir/__service "$@"
    exit $?
fi
if [ "$1" == ar ] || [ "$1" == addrepo ]; then
    zypper --root __workdir/__service addrepo https://mirrorcache.opensuse.org/repositories/$2/__service $2
elif [ "$1" == rr ] || [ "$1" == removerepo ]; then
    zypper --root __workdir/__service removerepo $2
else
    zypper --root __workdir/__service "$@"
fi
