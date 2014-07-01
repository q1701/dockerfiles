FROM centos:centos6

MAINTAINER q1701 <q1701@outlook.com>

# Update yum packages.
RUN yum -y update

# Reinstall locales.
RUN yum -y reinstall glibc-common

# Create a working directory.
RUN mkdir /tmp/build
ENV BUILD_TMP /tmp/build
WORKDIR /tmp/build

# Install the Git.
RUN yum -y install git

# Build the checkinstall.

## download the original version
RUN git clone http://checkinstall.izto.org/checkinstall.git
WORKDIR /tmp/build/checkinstall

## apply some patches
RUN yum -y install patch
### [Change installation directory of installwatch.so to /usr/local/lib64 on a 64bit system.]
### http://d.hatena.ne.jp/pcmaster/20120916/p1
ADD patches/checkinstall.lib64.patch $BUILD_TMP/checkinstall.lib64.patch
RUN patch -p1 -d . < ../checkinstall.lib64.patch
### [Change the location of configration files to /usr/local/etc.]
### http://d.hatena.ne.jp/naga_sawa/20120410/1334024586
ADD patches/checkinstall.confdir.patch $BUILD_TMP/checkinstall.confdir.patch
RUN patch -p1 -d . < ../checkinstall.confdir.patch
### [Changed setting not to use Slackware's native "makepkg".]
### http://blog.toor.jp/2012/03/checkinstall_on_centos-6-2-64bit/
ADD patches/checkinstall.makepkg.patch $BUILD_TMP/checkinstall.makepkg.patch
RUN patch -p1 -d . < ../checkinstall.makepkg.patch
### [Exclude "/selinux" by default. (--exclude=/selinux)]
### http://checkinstall.izto.org/cklist/msg00776.html
ADD patches/checkinstall.selinux.patch $BUILD_TMP/checkinstall.selinux.patch
RUN patch -p1 -d . < ../checkinstall.selinux.patch
### [Set "RPM" as a default package type.]
### http://d.hatena.ne.jp/akishin999/20130220/1361316887
ADD patches/checkinstall.rpm.patch $BUILD_TMP/checkinstall.rpm.patch
RUN patch -p1 -d . < ../checkinstall.rpm.patch
### [Add a option "autoreqprov" to turn on/off automatic dependencies feature of the RPM.]
### http://checkinstall.izto.org/cklist/msg00574.html
ADD patches/checkinstall.autoreqprov.patch $BUILD_TMP/checkinstall.autoreqprov.patch
RUN patch -p1 -d . < ../checkinstall.autoreqprov.patch
### [Include 'checkinstallrc' into the checkinstall's rpm file.]
### http://qiita.com/hnakamur/items/55ed1bc496b2e72a5ca6
ADD patches/checkinstall.rc.patch $BUILD_TMP/checkinstall.rc.patch
RUN patch -p1 -d . < ../checkinstall.rc.patch

## meke install
RUN yum -y install gcc gettext
RUN make install
## checkinstall itself
RUN yum -y install file which tar rpm-build
ENV HOME /root
RUN mkdir -p $HOME/rpmbuild/SOURCES
### identify the version string ("x.y.z")
RUN (checkinstall --version|grep "^checkinstall"|sed "s/checkinstall \(.*\), .*/\1/" > $BUILD_TMP/checkinstall_version.txt)
### build a rpm
RUN checkinstall --type=rpm --pkgname=checkinstall --pkgversion=$(cat $BUILD_TMP/checkinstall_version.txt) --default
### save the full path of the rpm file into a file
RUN (echo "$HOME/rpmbuild/RPMS/x86_64/checkinstall-$(cat $BUILD_TMP/checkinstall_version.txt)-1.x86_64.rpm" > $HOME/checkinstall_rpmpath.txt)

## yum install (to test the rpm file)
RUN yum -y localinstall $(cat $HOME/checkinstall_rpmpath.txt)
WORKDIR /tmp/build

# Clean up.
WORKDIR /
RUN yum clean all
RUN rm -rf $BUILD_TMP

# Export the generated rpm file.
CMD ["/bin/bash", "-c", "cp \"$(cat $HOME/checkinstall_rpmpath.txt)\" /mnt/out"]
