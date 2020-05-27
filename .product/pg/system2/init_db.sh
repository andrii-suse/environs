[ -d __datadir ] || mkdir __datadir

initdb --auth-local=peer -N __datadir -U "$USER" > /dev/null

echo "listen_addresses=''" >> __datadir/postgresql.conf
echo "unix_socket_directories='__datadir'" >> __datadir/postgresql.conf
echo "fsync=off" >> __datadir/postgresql.conf
echo "full_page_writes=off" >> __datadir/postgresql.conf
sed -i "s/`#'log_statement = 'none'/log_statement = 'all'/" __datadir/postgresql.conf
