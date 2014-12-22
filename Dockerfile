# Build an httpd without suexec to get around docker cap_set_file limitations:
# https://bugzilla.redhat.com/show_bug.cgi?id=1012952
# https://github.com/docker/docker/issues/8966

FROM centos:centos7

RUN yum install -y rpm-build gcc-c++ autoconf \
    xmlto zlib-devel libselinux-devel lua-devel \
    pcre-devel systemd-devel openssl-devel \
    libxml2-devel make apr-devel apr-util-devel \
    mailcap system-logos

# Grab the source rpm
RUN curl -O http://vault.centos.org/7.0.1406/os/Source/SPackages/httpd-2.4.6-17.el7.centos.1.src.rpm

# unpack it
RUN rpm -i httpd-2.4.6-17.el7.centos.1.src.rpm

WORKDIR /root/rpmbuild
# Patch the source to remove suexec support
ADD httpd.spec.diff /root/rpmbuild/SPECS/httpd.spec.diff
RUN patch -p0 < /root/rpmbuild/SPECS/httpd.spec.diff

# Build it, then use docker run to copy rpms out as needed
RUN rpmbuild -bb /root/rpmbuild/SPECS/httpd.spec
