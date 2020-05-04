obj=$1
name=$2

case $obj in
  db)
    sudo sudo -u postgres createdb $name;;
  user)
    sudo sudo -u postgres createuser $name;;
  *)
    >&2 echo "Unknown operation $obj"; exit 1;;
esac
