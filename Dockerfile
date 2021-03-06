ARG CINDERLIB_TAG=master
ARG VERSION=master
FROM akrog/cinderlib:${CINDERLIB_TAG}
LABEL maintainers="Gorka Eguileor <geguileo@redhat.com>" \
      description="Ember CSI Plugin" \
      version=${VERSION}

# We need to upgrade pyasn1 because the package for RDO is not new enough for
# pyasn1_modules, which is used by some of the Google's libraries
RUN yum -y install xfsprogs e2fsprogs btrfs-progs && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    pip install --no-cache-dir --upgrade 'pyasn1<0.5.0,>=0.4.1'

# Copy Ember-csi from directory directory
COPY . /csi

RUN pip install --no-cache-dir /csi/ && \
    rm -rf /csi

# This is the default port, but if we change it via CSI_ENDPOINT then this will
# no longer be relevant.
# For the Master version expose RPDB port to support remote debugging
EXPOSE 50051 4444

# Enable RPDB debugging on this container by default
ENV X_CSI_DEBUG_MODE=rpdb

# Define default command
CMD ["ember-csi"]
