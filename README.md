file-upload
===========

Based on https://github.com/yaasita/docker_jquery-file-upload, some reverse
engineering of https://hub.docker.com/r/bigdatauniversity/file-upload and by
looking at https://github.com/blueimp/jQuery-File-Upload/blob/master/server/php/Dockerfile.

Building this image requires Docker multi-stage build capability which is
supported in Docker version 17.05 and greater.

When running this image the container requires three environment variables:

SITE_NAME	Name of the site (can't currently contain forward slashes)
SITE_USERNAME	Username for web and SFTP access
SITE_PASSWORD   Password for web and SFTP access

Only one user is supported. The upload area can either be accessed via the
exposed web server on port 80 or via a chroot()ed SFTP server on port 22.

TLS isn't supported directly, use something like https://github.com/jwilder/nginx-proxy
in front of file-upload.  If you combine this with https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion
TLS setup has never been easier...

SSH host keys are regenerated once at first container start to prevent
having multiple containers with the same set of SSH host keys.
