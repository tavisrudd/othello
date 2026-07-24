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
| PDF artifact | `prs-beyond-redundancy-four.pdf` |
| Local built PDF SHA-256 | `fb3dd8d477e96af1854d51d0a6153f8046d9f11519ad0d92abcf6b21c675cf3e` |
| Local built PDF bytes | `306748` |
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
| `EVIDENCE-MANIFEST.json` | `132d006e87022c01cd230d728fcd87294707372ad05673e47d5038e52f0c0014` | 16666 |
| `EVIDENCE-ROWS.md` | `600a52518d7bb6d2eda1669acdcfb84fc06f92710c79f6e251703f1942eda69f` | 10963 |
| `package_evidence_bundle.py` | `e5e61b53c6a17c5a670131132e86cb07e6b5dcffe02aaedcee11a03f543dbc70` | 14755 |
| `verify.py` | `7a945645742e8f5e3f3db3056bafb3e7638450bbfc212ae058a2efac22cf88c5` | 7402 |

Verify the complete local bundle from the paper directory:

```text
python3 supplement/verify.py
```

Add `--replay` to run every paper-local replay, including the compiled
R9-49 comparison.

Add `--release` to require the immutable repository, revision, archive, DOI,
reviewed-PDF, and two-reader signoff fields.  It is expected to fail while any
field remains an external publication step.

Predecessor manifests are historical evidence and are not rewritten.  This
release-level manifest supersedes their packaging defects by hashing the exact
released bytes, while retaining those manifests inside the archive as
provenance.

The development monorepo is not a publication dependency of either local
check: all consumed certificates and locks are inside `supplement/`.
