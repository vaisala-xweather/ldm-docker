#!/bin/bash
set -eo pipefail

cd ~ldm
curl -fsSLO "https://downloads.unidata.ucar.edu/ldm/${LDM_VERSION}/ldm-${LDM_VERSION}.tar.gz"
chown ldm:ldm "ldm-${LDM_VERSION}.tar.gz"
gunzip -c "ldm-${LDM_VERSION}.tar.gz" | pax -r '-s:/:/src/:'
rm "ldm-${LDM_VERSION}.tar.gz"
cd "ldm-${LDM_VERSION}/src"
# The 6.15.1 tarball ships aclocal.m4 newer than configure and config.h.in, so
# make reruns autoconf and autoheader, which this image does not install. The
# shipped files are consistent: upstream only regenerated aclocal.m4 with the same
# tools (aclocal 1.16.5, Autoconf 2.71). Make the autotools inputs older than
# everything generated from them, so make uses the shipped build files.
find . \( -name configure.ac -o -name '*.am' -o \( -name '*.m4' ! -name aclocal.m4 \) \) \
    -exec touch -d '2000-01-01' {} +
touch -d '2000-01-02' aclocal.m4
./configure
make
make install
make clean
