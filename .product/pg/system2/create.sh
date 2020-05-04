obj=$1
name=$2

case $obj in
  db)
    PGHOST=__datadir createdb $name;;
  user)
    PGHOST=__datadir createuser $name;;
  *)
    >&2 echo "Unknown operation $obj"; exit 1;;
esac
