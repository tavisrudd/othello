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
| Public Lean repository | `https://github.com/tavisrudd/finitegeom` |
| Public Lean concept DOI | [`10.5281/zenodo.21650878`](https://doi.org/10.5281/zenodo.21650878) |
| Public Lean revision | set from the immutable public verification commit |
| Archive identifier | external publication step |
| DOI | external publication step |
| Source archive SHA-256 | computed from the immutable export archive |
| Source archive bytes | computed from the immutable export archive |
| PDF artifact | `prs-beyond-redundancy-four.pdf` |
| Local built PDF SHA-256 | `43315c95e51c95992a09ce133862824264f23611fa8090923fc469e5aad56bec` |
| Local built PDF bytes | `238922` |
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
| `EVIDENCE-MANIFEST.json` | `55585b80891dcf109bc2bd1c8a86d10d35041d57c41fd67606764ae28e9520eb` | 13286 |
| `EVIDENCE-ROWS.md` | `176b4679fd4b80828534a898709fbb89f99eb8dfb324f2c94f2b55ae62eacac8` | 8807 |
| `package_evidence_bundle.py` | `1fa62402c1d0152a68104f03fcfa34fcca6b6419bc4c1c0801210e730b51c7c8` | 10913 |
| `verify.py` | `f6dfcbbf5e90724efa34cc65fcbdc9b7e146b90ff4634870019febb00b21fe0c` | 14147 |
| `build_r6_paper_table.py` | `b46a30752ea17d85093e6181d50ca8dbd6f12386416aedc3e8509406a2060f98` | 3878 |

Verify the complete local bundle from the paper directory:

```text
python3 supplement/verify.py
```

Add `--replay` to run every paper-local Python replay.  The two paper-local
Singular checks are listed separately in `REPRODUCING.md`.

Add `--release` to require the immutable repository, revision, archive, DOI,
reviewed-PDF, and two-reader signoff fields.  It is expected to fail while any
field remains an external publication step.

Predecessor manifests are historical evidence and are not rewritten.  This
release-level manifest supersedes their packaging defects by hashing the exact
released bytes, while retaining those manifests inside the archive as
provenance.

The development monorepo is not a publication dependency of either local
check: all consumed certificates and locks are inside `supplement/`.
