# Release manifest

Status: **complete local evidence bundle — external publication not performed**

The manuscript, public certificates, generators, replays, classification
records, and toolchain locks are present under stable paper-local paths.  The
fields explicitly marked `external publication step` are intentionally not
claimed by this local bundle.

| Field | Value |
|---|---|
| Paper-export repository URL | external publication step |
| Release tag | external publication step |
| Release commit | set from the final paper-export commit |
| Public Lean repository / export path | `https://github.com/tavisrudd/finitegeom` / `../lean` |
| Public Lean revision | set from the immutable public verification commit |
| Public Q25 certificate repository | `https://github.com/tavisrudd/finitegeom-q25-certificates` |
| Public Q25 certificate revision | set from the immutable public certificate commit |
| Archive identifier | external publication step |
| DOI | external publication step |
| Source archive SHA-256 | computed from the immutable export archive |
| Source archive bytes | computed from the immutable export archive |
| PDF SHA-256 | computed from the immutable export build |
| PDF bytes | computed from the immutable export build |
| Toolchain lock | `supplement/toolchain/`; five pinned files with hashes below |

## Artifact rows

`EVIDENCE-ROWS.md` contains one row for every bundled generator,
certificate, replay, predecessor checksum, toolchain lock, and public
supplement input.  Its machine-readable source is
`EVIDENCE-MANIFEST.json`.  Both use paths relative to this supplement and
record SHA-256 plus exact byte count.

| Manifest object | SHA-256 | Bytes |
|---|---|---:|
| `EVIDENCE-MANIFEST.json` | `ea5b6e42c07530e88172a4f8033ed08dc571da0f09d5102937ce90031ecc1c43` | 15236 |
| `EVIDENCE-ROWS.md` | `2b218eaa230e99523692b8d660f61f525fbc497263583b455771ca3043bec8f9` | 10043 |
| `package_evidence_bundle.py` | `2a727bc2f7a76b3c1b65bb62ef25002f6064b6570d5e9c256c2425aa28b26855` | 14124 |

Verify the complete local bundle from the paper directory:

```text
python3 supplement/package_evidence_bundle.py --check
python3 supplement/build_classification_records.py --check
sha256sum -c supplement/CLASSIFICATION-RECORDS.sha256
```

Predecessor manifests are historical evidence and are not rewritten.  This
release-level manifest supersedes their packaging defects by hashing the exact
released bytes, while retaining those manifests inside the archive as
provenance.

The development monorepo is not a publication dependency of either local
check: all consumed certificates and locks are inside `supplement/`.
