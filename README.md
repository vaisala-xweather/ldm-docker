# ldm-docker

Container image for [Unidata LDM](https://www.unidata.ucar.edu/software/ldm/) (Local Data Manager) on Amazon Linux 2023, supervised by [s6-overlay](https://github.com/just-containers/s6-overlay).

## Image

Published to GitHub Container Registry:

```
ghcr.io/vaisala-xweather/ldm:<LDM_VERSION>-<BUILD_NUMBER>
ghcr.io/vaisala-xweather/ldm:<LDM_VERSION>          # rolling, latest build
```

## Building locally

```sh
docker build -t ldm:local --build-arg LDM_VERSION=6.15.0 .
```

Build args:

| Arg                 | Default   |
| ------------------- | --------- |
| `LDM_VERSION`       | `6.15.0`  |
| `PYTHON_VERSION`    | `3.14`    |
| `S6_OVERLAY_VERSION`| `3.2.0.2` |

## Releasing

CI publishes on tags matching `vX.Y.Z-N`, where `X.Y.Z` is the LDM version and `N` is the build number. Push a new build number to rebuild for fresh OS packages without bumping the LDM version.

```sh
git tag v6.15.0-1 && git push origin v6.15.0-1
```

The workflow ([.github/workflows/build.yml](.github/workflows/build.yml)) builds, runs the smoke test, and pushes to GHCR.

## Smoke test

`util/test` builds the image, starts a container, waits for `/init`, and verifies LDM binaries run.

```sh
./util/test                                   # build + test
SKIP_BUILD=1 IMAGE=ldm:local ./util/test      # test an existing image
```
