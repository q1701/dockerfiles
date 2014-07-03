#!/bin/bash

# Abort if error.
trap "exit 1" ERR

#====================================
# Build the checkinstall's RPM file.
#====================================

# Download the original version.
yum -y install git
git clone http://checkinstall.izto.org/checkinstall.git
cd $BUILD_TMP/checkinstall

# Apply patches.
yum -y install patch
patch -p1 -d . < $BUILD_TMP/checkinstall.lib64.patch
patch -p1 -d . < $BUILD_TMP/checkinstall.confdir.patch
patch -p1 -d . < $BUILD_TMP/checkinstall.makepkg.patch
patch -p1 -d . < $BUILD_TMP/checkinstall.selinux.patch
patch -p1 -d . < $BUILD_TMP/checkinstall.rpm.patch
patch -p1 -d . < $BUILD_TMP/checkinstall.autoreqprov.patch
patch -p1 -d . < $BUILD_TMP/checkinstall.rc.patch

# Make and install.
## Install dependencies to build.
export BUILD_REQUIRES=gcc,gettext
yum -y install ${BUILD_REQUIRES//,/ }
## Make and install.
make install

# Run checkinstall to create its rpm.
## Install dependencies to run.
export REQUIRES=gettext,file,which,tar,rpm-build
yum -y install ${REQUIRES//,/ }
## Prepare environment to run the rpm-build.
export HOME=/root
mkdir -p $HOME/rpmbuild/SOURCES
## Identify the version string. ("x.y.z")
export VERSION=$(checkinstall --version | grep "^checkinstall" | sed "s/checkinstall \(.*\), .*/\1/")
## Build a rpm.
checkinstall --type=rpm --pkgname=checkinstall --pkgversion=$VERSION --default --requires=$REQUIRES
## Save the full path of the rpm file into a file
export RPM_PATH="$HOME/rpmbuild/RPMS/x86_64/checkinstall-$VERSION-1.x86_64.rpm"
## Install the generated rpm file to test it.
yum -y localinstall $RPM_PATH
cd $BUILD_TMP

# Export
# (Environment "CONTAINER_VOLUME" must be specified when 'docker run'.)
mv $RPM_PATH $CONTAINER_VOLUME
echo "========================="
echo "Created: $(basename $RPM_PATH)"
echo "========================="

# Clean up.
cd /
yum clean all
rm -rf $BUILD_TMP
