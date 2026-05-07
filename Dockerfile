FROM public.ecr.aws/amazonlinux/amazonlinux:2023

LABEL org.opencontainers.image.description="Unidata Local Data Manager (LDM) on Amazon Linux 2023, supervised by s6-overlay"

# Software versions
ARG LDM_VERSION=6.15.0
ARG PYTHON_VERSION=3.14
ARG S6_OVERLAY_VERSION=3.2.0.2

# Install system packages
RUN dnf -y install git gcc make tar xz zlib-devel libxml2-devel spax python${PYTHON_VERSION} python${PYTHON_VERSION}-pip sysstat chrony procps-ng cronie vim net-tools logrotate
RUN dnf clean all

# Install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp/
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp/
RUN dnf install -y xz && \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz && \
    rm /tmp/s6-overlay-*.tar.xz

# Register python3.14 as the default python/pip
RUN alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VERSION} 1 && \
    alternatives --install /usr/bin/pip pip /usr/bin/pip${PYTHON_VERSION} 1

# Install Python dependencies
RUN pip install boto3 inotify-simple

# Add LDM user
RUN groupadd -g 1000 ldm && \
    useradd -g ldm -u 1000 -m -d /home/ldm -s /bin/bash ldm

# Install LDM
USER ldm
WORKDIR /home/ldm
ADD --chown=ldm:ldm https://downloads.unidata.ucar.edu/ldm/${LDM_VERSION}/ldm-${LDM_VERSION}.tar.gz .
RUN gunzip -c ldm-${LDM_VERSION}.tar.gz | pax -r '-s:/:/src/:' && \
    rm ldm-${LDM_VERSION}.tar.gz && \
    cd ldm-${LDM_VERSION}/src && \
    ./configure && \
    make && \
    make install

# Set special permissions
USER root
WORKDIR /home/ldm/ldm-${LDM_VERSION}/src
RUN make root-actions

# Clean up build
USER ldm
WORKDIR /home/ldm/ldm-${LDM_VERSION}/src
RUN make clean

WORKDIR /home/ldm
ENV PATH="/home/ldm/bin:$PATH"

ENTRYPOINT [ "/init" ]
