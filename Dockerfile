FROM mageia:6
MAINTAINER JMiahMan <JMiahMan@unity-linux.org>
RUN dnf clean all
RUN dnf -y install mock rpmdevtools rpm-sign rpmlint && dnf clean all
RUN useradd builder -G mock -M -d /rpmbuild
RUN echo "config_opts['cache_topdir'] = '/rpmbuild/cache'" >> /etc/mock/site-defaults.cfg
VOLUME [/rpmbuild]
ADD rpmbuilder.sh /root/rpmbuilder.sh
CMD ["/bin/bash", "/root/rpmbuilder.sh"]
