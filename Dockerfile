FROM jmiahman/cauldron
MAINTAINER JMiahMan <JMiahMan@Unity-Linux.org>
RUN dnf config-manager --set-disabled mageia-x86_64 --set-disabled updates-x86_64
RUN dnf -y install 'dnf-command(config-manager)'
RUN dnf config-manager --set-enabled cauldron-x86_64-nonfree cauldron-x86_64-nonfree
RUN dnf clean all
RUN mkdir -p /etc/yum.repos.d/
ADD https://raw.githubusercontent.com/unity-linux/unity-repos/master/Unity-Linux-mageia.repo /etc/yum.repos.d/Unity-Linux-mageia.repo
ADD https://raw.githubusercontent.com/unity-linux/unity-repos/master/RPM-GPG-KEY-Unity /etc/pki/rpm-gpg/RPM-GPG-KEY-Unity
RUN dnf update -y
RUN dnf -y install 'dnf-command(copr)'
RUN dnf copr enable jmiahman/Unity-Linux -y
#RUN dnf -y install --setopt=install_weak_deps=False kernel-firmware kernel-unity-desktop-latest kernel-unity-desktop-devel-latest basesystem-minimal 
RUN dnf -y install --setopt=install_weak_deps=False kernel-firmware basesystem-minimal 
RUN dnf -y install --setopt=install_weak_deps=False acpi acpid dhcp-client wget dnf-plugins-core mock rpmdevtools rpm-sign cracklib-dicts rpmlint intltool
RUN dnf clean all
RUN useradd builder -G mock -M -d /rpmbuild
RUN echo "config_opts['cache_topdir'] = '/rpmbuild/cache'" >> /etc/mock/site-defaults.cfg
RUN echo "root:Unity!" | chpasswd
RUN passwd -d root
ADD rpmbuilder.sh /usr/bin/rpmbuilder
RUN chmod +x /usr/bin/rpmbuilder
VOLUME [ "/rpmbuild" ]
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
