FROM fedora:latest
MAINTAINER Ruben Jongejan <ruben.jongejan@gmail.com>
RUN dnf -y install \
        @lxqt \
        xorg-x11-twm \
        tigervnc-server \
        sudo \
        man-pages \
        xrdp && \
    dnf clean all
RUN mkdir -p /etc/sudoers.d && \
    useradd -G wheel devtop
RUN echo 'devtop:password' | chpasswd
RUN echo "devtop ALL = (root) NOPASSWD: ALL" > /etc/sudoers.d/devtop
RUN echo "startlxqt" > /etc/xrdp/startwm.sh
RUN echo "#!/bin/bash" >/entrypoint.sh && \
    echo "# Copyright Maxim B. Belooussov <belooussov@gmail.com>" >>/entrypoint.sh && \
    echo "# generate a random machine id upon startup" >>/entrypoint.sh && \
    echo "openssl rand -out /etc/machine-id -hex 16" >>/entrypoint.sh && \
    echo "# start dbus" >>/entrypoint.sh && \
    #echo "dbus-daemon" >>/entrypoint.sh && \
    echo "# start xrdp session manager" >>/entrypoint.sh && \
    echo "xrdp-sesman" >>/entrypoint.sh && \
    echo "# and now start xrdp in the foreground" >>/entrypoint.sh && \
    echo "xrdp --nodaemon" >>/entrypoint.sh && \
    chmod +x /entrypoint.sh
VOLUME /home
EXPOSE 3389
ENTRYPOINT ["/entrypoint.sh"]
