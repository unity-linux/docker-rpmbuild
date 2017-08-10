FROM mageia:6
MAINTAINER JMiahMan <JMiahMan@Unity-Linux.org>
RUN dnf -y install kernel-desktop-latest
RUN rpm -e --nodeps systemd; dnf clean all 
RUN dnf -y install systemd
RUN dnf -y install dnf-plugins-core mock rpmdevtools rpm-sign cracklib-dicts rpmlint intltool && dnf clean all
RUN dnf copr enable jmiahman/Unity-Linux -y
RUN dnf clean all
RUN useradd builder -G mock -M -d /rpmbuild
RUN useradd live
RUN echo "config_opts['cache_topdir'] = '/rpmbuild/cache'" >> /etc/mock/site-defaults.cfg
RUN echo "root:Unity!" | chpasswd
RUN echo "live:Unity!" | chpasswd
RUN passwd -d root
RUN passwd -d live
VOLUME [ "/rpmbuild" ]
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
