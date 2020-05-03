case $1 in
    host)
        echo 127.0.0.1;;
    user | pass)
        echo $2;;
esac
