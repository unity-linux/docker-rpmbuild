#!/bin/bash

set -e
set -u

: "${MOCK_CONFIG:=$(basename $(readlink /etc/mock/default.cfg) .cfg)}"
: "${MOCK_CLI_OPTIONS:=}"

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

su builder -l -c "echo '%_topdir /rpmbuild/' >> ~/.rpmmacros"
su builder -l -c "rpmdev-setuptree"
su builder -l -c "spectool -R -g  /rpmbuild/SPECS/*spec"
su builder -l -c "find /rpmbuild/SPECS/*spec -print0 | xargs -0 mock -r ${MOCK_CONFIG} --resultdir=/tmp/ --buildsrpm --sources /rpmbuild/SOURCES/ --spec"
su builder -l -c "mock -r ${MOCK_CONFIG} --resultdir=/rpmbuild/results/${MOCK_CONFIG} ${MOCK_CLI_OPTIONS} --rebuild /tmp/*src.rpm"
