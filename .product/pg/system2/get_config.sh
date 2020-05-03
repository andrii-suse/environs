case $1 in
    host)
        echo __datadir;;
    user | pass)
        echo $USER;;
esac
