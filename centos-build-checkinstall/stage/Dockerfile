FROM centos:centos6

MAINTAINER q1701 <q1701@outlook.com>

# Update yum packages.
RUN yum -y update

# Create a working directory.
RUN mkdir /tmp/build
ENV BUILD_TMP /tmp/build
WORKDIR /tmp/build

## place some patches
### [Change installation directory of installwatch.so to /usr/local/lib64 on a 64bit system.]
### http://d.hatena.ne.jp/pcmaster/20120916/p1
ADD patches/checkinstall.lib64.patch $BUILD_TMP/checkinstall.lib64.patch
### [Change the location of configration files to /usr/local/etc.]
### http://d.hatena.ne.jp/naga_sawa/20120410/1334024586
ADD patches/checkinstall.confdir.patch $BUILD_TMP/checkinstall.confdir.patch
### [Changed setting not to use Slackware's native "makepkg".]
### http://blog.toor.jp/2012/03/checkinstall_on_centos-6-2-64bit/
ADD patches/checkinstall.makepkg.patch $BUILD_TMP/checkinstall.makepkg.patch
### [Exclude "/selinux" by default. (--exclude=/selinux)]
### http://checkinstall.izto.org/cklist/msg00776.html
ADD patches/checkinstall.selinux.patch $BUILD_TMP/checkinstall.selinux.patch
### [Set "RPM" as a default package type.]
### http://d.hatena.ne.jp/akishin999/20130220/1361316887
ADD patches/checkinstall.rpm.patch $BUILD_TMP/checkinstall.rpm.patch
### [Add a option "autoreqprov" to turn on/off automatic dependencies feature of the RPM.]
### http://checkinstall.izto.org/cklist/msg00574.html
ADD patches/checkinstall.autoreqprov.patch $BUILD_TMP/checkinstall.autoreqprov.patch
### [Include 'checkinstallrc' into the checkinstall's rpm file.]
### http://qiita.com/hnakamur/items/55ed1bc496b2e72a5ca6
ADD patches/checkinstall.rc.patch $BUILD_TMP/checkinstall.rc.patch

## place scripts
ADD scripts/build_rpm.sh $BUILD_TMP/build_rpm.sh

# Export the generated rpm file.
CMD ["/bin/bash", "-c", "$BUILD_TMP/build_rpm.sh"]
