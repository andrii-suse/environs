#!BuildTag: serviced
FROM opensuse/leap:15.1
ENV container docker

ENV LANG en_US.UTF-8

RUN zypper -n install systemd
# N zypper -n install systemd curl hostname iputils vim command-not-found bsdtar zip sudo wget gcc gzip patch

RUN systemctl mask dev-mqueue.mount dev-hugepages.mount \
    systemd-remount-fs.service sys-kernel-config.mount \
    sys-kernel-debug.mount sys-fs-fuse-connections.mount \
    display-manager.service graphical.target systemd-logind.service

ADD dbus.service /etc/systemd/system/dbus.service

VOLUME ["/sys/fs/cgroup"]
VOLUME ["/run"]
VOLUME ["/opt/project"]

RUN systemctl enable dbus.service

ADD .install.sh /.install.sh

RUN bash -x /.install.sh Apache:MirrorBrain:development

WORKDIR /opt/project

ENTRYPOINT  ["/usr/lib/systemd/systemd"]
