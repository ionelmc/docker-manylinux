FROM quay.io/pypa/manylinux1_x86_64

RUN yum install -y libffi-devel libmagic-devel \
 && rm /opt/python/cp26-*
RUN for variant in /opt/python/*; do $variant/bin/pip install cffi==1.11.2 pycparser==2.18; done \
 && rm -rf /root/.cache/pip

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
