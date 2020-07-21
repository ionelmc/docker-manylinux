FROM quay.io/pypa/manylinux2014_x86_64

RUN yum install -y libffi-devel file-devel zlib-devel freetype-devel \
                   libpng-devel libxml2-devel libxslt-devel expect-devel xz-devel \
                   enchant-devel \
                   strace gdb lsof mlocate net-tools htop iputils bind-utils
RUN for variant in /opt/python/*; do $variant/bin/pip install cffi==1.14.0 pycparser==2.20; done \
 && rm -rf /root/.cache/pip
RUN mkdir /wheelhouse \
 && chmod go+rwX /wheelhouse
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
