#!/usr/bin/bash

set -x
set -e
set -u

: "${MOCK_CONFIG:=$(basename $(readlink /etc/mock/default.cfg) .cfg)}"
: "${MOCK_CLI_OPTIONS:=}"


if [ -d /rpmbuild/mock/ ]; then
   cp -v /rpmbuild/mock/* /etc/mock/ 2>/dev/null
fi

if [ ! -e /rpmbuild/*.spec ]; then
   cd /rpmbuild
   make spec
fi

# The Dockerfile adds a user named 'builder'. Right now that UID is 1000 when
# the container is created. The CI tool might run under a different UID, for
# example 500. When the CI tool shares the rpmbuild directory to the docker
# container, the builder user won't be able to read the files due to it being
# UID 1000 while the files are UID 500. So we change the UID of the 'builder'
# user to match the directory shared.
rpmbuild_dir_uid="$(stat -c '%u' /rpmbuild/)"
rpmbuild_dir_gid="$(stat -c '%g' /rpmbuild/)"
builder_uid="$(id -u builder)"
builder_gid="$(id -g builder)"

if [[ $rpmbuild_dir_uid != $builder_uid ]]; then
    usermod -u $rpmbuild_dir_uid builder
fi
if [[ $rpmbuild_dir_gid != $builder_gid ]]; then
   groupmod -g $rpmbuild_dir_gid builder
fi

if ! grep -q '%_topdir /rpmbuild/' ~/.rpmmacros; then
    su builder -l -c "echo '%_topdir /rpmbuild/' >> ~/.rpmmacros"
fi
su builder -l -c "rpmdev-setuptree"
su builder -l -c "rpmbuild \""--undefine=_disable_source_fetch\"" \""--define\"" \""_sourcedir\ /rpmbuild\"" \""--define\"" \""_topdir\ /rpmbuild\"" -bs *.spec"
su builder -l -c "mock -r ${MOCK_CONFIG} --resultdir=/rpmbuild/${MOCK_CONFIG} ${MOCK_CLI_OPTIONS} --rebuild /rpmbuild/SRPMS/*.src.rpm"
su builder -l -c "sed -i '/%_topdir \/rpmbuild\/ # docker-rpmbuilder/d' ~/.rpmmacros"
