FROM centos:7
MAINTAINER Mark McKinstry <mmckinst@umich.edu>
RUN yum -y install epel-release && yum clean all
RUN yum -y install mock rpmdevtools && yum clean all
RUN useradd builder -G mock -M -d /rpmbuild
RUN echo "config_opts['cache_topdir'] = '/rpmbuild/cache'" >> /etc/mock/site-defaults.cfg
VOLUME [/rpmbuild]
ADD rpmbuilder.sh /root/rpmbuilder.sh
CMD ["/bin/bash", "/root/rpmbuilder.sh"]
