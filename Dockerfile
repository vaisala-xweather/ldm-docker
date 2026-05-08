FROM public.ecr.aws/amazonlinux/amazonlinux:2023 AS builder

LABEL org.opencontainers.image.description="Unidata Local Data Manager (LDM) on Amazon Linux 2023, supervised by s6-overlay"

# Software versions
ARG LDM_VERSION=6.15.0
ARG S6_OVERLAY_VERSION=3.2.0.2

# Install system packages
RUN dnf -y install \
        chrony \
        cronie \
        gcc \
        git \
        libxml2-devel \
        logrotate \
        make \
        net-tools \
        procps-ng \
        spax \
        sysstat \
        tar \
        vim \
        xz \
        zlib-devel \
    && dnf clean all

COPY ./util/install-s6.sh /opt/install-s6.sh
RUN /opt/install-s6.sh "${S6_OVERLAY_VERSION}" && rm /opt/install-s6.sh

# Add LDM user
RUN groupadd -g 1000 ldm && \
    useradd -g ldm -u 1000 -m -d /home/ldm -s /bin/bash ldm

# Install LDM
USER ldm
WORKDIR /home/ldm

COPY ./util/install-ldm.sh /opt/install-ldm.sh
RUN /opt/install-ldm.sh "${LDM_VERSION}"

# Set special permissions
USER root
WORKDIR /home/ldm/ldm-${LDM_VERSION}/src
RUN make root-actions

# Squish to a single layer for the final image
FROM scratch
COPY --from=builder / /

# Clean up build
USER ldm

WORKDIR /home/ldm
ENV PATH="/home/ldm/bin:$PATH"

ENTRYPOINT [ "/init" ]
