# Changelog

## v6.15.1-1

- LDM 6.15.0 -> 6.15.1, a build-only fix upstream (it removes the blender
  files so that LDM compiles).
- Rebuild on current Amazon Linux 2023 packages. v6.15.0-2 carried the May
  2026 package set. The base is now pinned by digest, so a rebuild is
  reproducible and a later bump also invalidates the build cache.
- s6-overlay 3.2.0.2 -> 3.2.3.2.
- CI: build and smoke-test pull requests without publishing; pin actions by
  commit SHA.

## v6.15.0-1

- Initial build of LDM in Docker!
