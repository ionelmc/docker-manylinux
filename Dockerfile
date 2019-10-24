FROM quay.io/pypa/manylinux2010_x86_64

RUN yum install -y libffi-devel libmagic-devel libzlib-devel libfreetype6-devel \
                   libpng-devel libxml2-devel libxslt-devel expect-devel liblzma-devel \
                   libenchant-devel libpq-devel libz-devel \
                   strace gdb lsof locate net-tools htop iputils-ping dnsutils \
 && rm /opt/python/cp27-cp27m
RUN for variant in /opt/python/*; do $variant/bin/pip install cffi==1.12.3 pycparser==2.19; done \
 && rm -rf /root/.cache/pip
RUN mkdir /wheelhouse \
 && chmod go+rwX /wheelhouse
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
