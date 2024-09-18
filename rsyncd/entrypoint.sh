#!/bin/sh -x

# Thanks to: https://github.com/stefda/docker-rsync
#
#     MIT License
#
#     Copyright (c) 2017 David Stefan
#
#     Permission is hereby granted, free of charge, to any person obtaining a copy
#     of this software and associated documentation files (the "Software"), to deal
#     in the Software without restriction, including without limitation the rights
#     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#     copies of the Software, and to permit persons to whom the Software is
#     furnished to do so, subject to the following conditions:
#
#     The above copyright notice and this permission notice shall be included in all
#     copies or substantial portions of the Software.
#
#     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#     SOFTWARE.

VOLUME=${VOLUME:-/volume}
ALLOW=${ALLOW:-192.168.0.0/16 172.16.0.0/12}
USER=${USER:-nobody}
GROUP=${GROUP:-nogroup}

#mkdir -p ${VOLUME}

getent group ${GROUP} > /dev/null || addgroup ${GROUP}
getent passwd ${USER} > /dev/null || adduser -D -H -G ${GROUP} ${USER}
#chown -R ${USER}:${GROUP} ${VOLUME}

cat <<EOF > /etc/rsyncd.conf
uid = ${USER}
gid = ${GROUP}
use chroot = yes
log file = /dev/stdout
reverse lookup = no
[volume]
    hosts deny = *
    hosts allow = ${ALLOW}
    read only = true
    path = ${VOLUME}
    comment = docker volume
EOF

exec /usr/bin/rsync --no-detach --daemon --config /etc/rsyncd.conf
