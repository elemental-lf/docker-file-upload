#!/bin/bash

if [[ -z $SITE_NAME || -z $SITE_USERNAME || -z $SITE_PASSWORD ]]
then
  echo "Please set the site name, username and password by adding the following arguments to docker run/create:"
  echo "  -e SITE_NAME='...'"
  echo "  -e SITE_USERNAME='...'"
  echo "  -e SITE_PASSWORD='...'"
  exit 1
fi

if ! getent passwd "$SITE_USERNAME" >/dev/null
then
  # Make sure every container gets its own SSH host keys the first time around
  rm -f /etc/ssh/ssh_host_*
  dpkg-reconfigure openssh-server

  htpasswd -bc /etc/apache2/htpasswd "$SITE_USERNAME" "$SITE_PASSWORD"
  chown www-data /etc/apache2/htpasswd

  useradd -g www-data -d /var/www/upload/server/php/chroot -s /sbin/nologin "$SITE_USERNAME"
  echo "$SITE_USERNAME:$SITE_PASSWORD" | chpasswd
  chown "$SITE_USERNAME:www-data" /var/www/upload/server/php/chroot/files

  # This will break if $SITE_NAME contains a slash...
  sed -i 's/%SITE_NAME%/'"$SITE_NAME"'/g' /var/www/upload/index.html
else
  echo "skipping one-time setup tasks" 1>&2
fi

exec "$@"
