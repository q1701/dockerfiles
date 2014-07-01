FROM centos:centos6

MAINTAINER q1701 <q1701@outlook.com>

# Update yum packages.
RUN yum -y update

# Reinstall locales.
RUN yum -y reinstall glibc-common

# Change the root password.
RUN echo root:root | chpasswd

# sudo settings (and vim-minimal is automatically installed.)
RUN yum -y install sudo
RUN sed -ri 's/^# *(%wheel\tALL=\(ALL\)\tNOPASSWD: ALL)/\1/' /etc/sudoers

# SSH settings.
RUN yum -y install openssh openssh-server openssh-clients
RUN sed -ri 's/^(session)(.+)required(.+)(pam_loginuid.so)/\1\2optional\3\4/' /etc/pam.d/sshd
RUN /etc/init.d/sshd start
RUN /etc/init.d/sshd stop

# Clean up.
RUN yum clean all

# Start sshd.
EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
