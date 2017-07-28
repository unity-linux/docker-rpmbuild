FROM mageia:6
MAINTAINER JMiahMan <JMiahMan@unity-linux.org>
RUN dnf clean all
RUN dnf -y install dnf-plugins-core mock rpmdevtools rpm-sign cracklib-dicts rpmlint intltool && dnf clean all
RUN dnf copr enable jmiahman/Unity-Linux -y
RUN dnf clean all
RUN useradd builder -G mock -M -d /rpmbuild
RUN useradd live
RUN echo "config_opts['cache_topdir'] = '/rpmbuild/cache'" >> /etc/mock/site-defaults.cfg
RUN echo "root:Unity!" | chpasswd
VOLUME [/rpmbuild]
ADD rpmbuilder.sh /root/rpmbuilder.sh
CMD ["/bin/bash", "/root/rpmbuilder.sh"]
