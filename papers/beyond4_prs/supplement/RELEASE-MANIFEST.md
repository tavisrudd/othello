# Release manifest

Status: **development template — not an immutable release**

The fields below must be filled from the final committed tree.  A DOI release
is blocked while any required value is `TBD`.

| Field | Value |
|---|---|
| Paper-export repository URL | TBD |
| Release tag | TBD |
| Release commit | TBD |
| Archive identifier | TBD |
| DOI | TBD |
| Source archive SHA-256 | TBD |
| Source archive bytes | TBD |
| PDF SHA-256 | TBD |
| PDF bytes | TBD |
| Toolchain lock | TBD |

## Artifact rows

Every public certificate in `CERTIFICATE-SCHEMA.md` receives one row per
generator, certificate, replay, and checksum file:

| Public label | Role | Stable archive path | SHA-256 | Bytes | Replay class |
|---|---|---|---|---:|---|
| TBD | TBD | TBD | TBD | TBD | rederive/reconstruct/compare |

Predecessor manifests are historical evidence and are not rewritten.  This
release-level manifest supersedes their packaging defects by hashing the exact
released bytes, while retaining those manifests inside the archive as
provenance.

The development monorepo is not published.  Every path in the completed
manifest is relative to the reviewed paper-only export.
