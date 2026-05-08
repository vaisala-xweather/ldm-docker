#!/bin/bash
set -eo pipefail

cd ~ldm
curl -fsSLO "https://downloads.unidata.ucar.edu/ldm/${LDM_VERSION}/ldm-${LDM_VERSION}.tar.gz"
chown ldm:ldm "ldm-${LDM_VERSION}.tar.gz"
gunzip -c "ldm-${LDM_VERSION}.tar.gz" | pax -r '-s:/:/src/:'
rm "ldm-${LDM_VERSION}.tar.gz"
cd "ldm-${LDM_VERSION}/src"
./configure
make
make install
make clean
