set -e
[ -f /var/run/httpd.pid ] || ( >&2 echo Pid file not found /var/run/httpd.pid; exit 1 )
 
( sudo kill -0 $(cat /var/run/httpd.pid) && ! ps -p "$(cat /var/run/httpd.pid)" | grep -q defunc && echo httpd seems running ) || ( >&2 echo httpd seems be down; exit 1 )

# sudo service apache2 status
