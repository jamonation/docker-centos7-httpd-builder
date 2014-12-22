Docker Centos 7 HTTPD Builder
============================

This docker image will build a working Apache 2.4.x in Centos7 *without* suexec support. This approach is required to get around
issues ([1][bug1], [2][bug2], [3][bug3]) with ``cap_set_file`` calls that are made when the official httpd RPM is unpacked.

To use this image, run the usual docker build commands, e.g.

    docker build --rm -t centos:centos7-httpd-builder .

Then copy the RPMs out using the following:

    docker run --rm -v $PWD/rpmbuild:/tmp centos:centos7-httpd-builder cp -rv RPMS /tmp/RPMS

This command will copy the built RPMs out of the container into the ``rpmbuild`` directory for further reuse.

[bug1]: https://github.com/docker/docker/issues/8966
[bug2]: https://bugzilla.redhat.com/show_bug.cgi?id=1012952
[bug3]: http://bugs.centos.org/view.php?id=7489
