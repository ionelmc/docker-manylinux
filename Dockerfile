FROM quay.io/pypa/manylinux1_x86_64

RUN yum install -y libffi-devel \
 && rm /opt/python/cp26-*

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
