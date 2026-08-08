# Release manifest

Status: **Version 1 published; Version 2 is the current local draft and will supersede it**

Version 2 corrects a defect in Version 1: the inference from a split-free syndrome
direction to a one-column MDS extension, and the balanced quantum corollary at field
order eight that rested on it, are withdrawn.  The Version 2 release note must state
that correction before its new material.  Version 1's tag, commit, and Zenodo record
below remain immutable.

Version 1 was published on 2026-07-29 in the public GitHub repository and
archived by Zenodo.  Its immutable record is:

| Version 1 field | Value |
|---|---|
| Paper-export repository | `https://github.com/tavisrudd/beyond4-prs` |
| Release tag | `v0.1.0` |
| Release commit | `0d3cea228b852c45f048c3446604ee2146219144` |
| GitHub release | `https://github.com/tavisrudd/beyond4-prs/releases/tag/v0.1.0` |
| Zenodo record | `21682216` |
| Version DOI | `10.5281/zenodo.21682216` |
| Concept DOI | `10.5281/zenodo.21682069` |
| Source archive | `tavisrudd/beyond4-prs-v0.1.0.zip` |
| Source archive SHA-256 | `99c02781074a47c10cf2be75289900c1f4c15650a849ece96ce08b7feba8046b` |
| Source archive bytes | `900454` |
| Released PDF SHA-256 | `43315c95e51c95992a09ce133862824264f23611fa8090923fc469e5aad56bec` |
| Released PDF bytes | `238922` |
| Public Lean repository | `https://github.com/tavisrudd/finitegeom` |
| Public Lean revision | `77c0d6bb5a45a1aa15a0ab90b7db307e1a1804d2` |
| Public Lean concept DOI | `10.5281/zenodo.21650878` |

The fields below describe the current Version 2 working draft.  Values marked
`external publication step` are intentionally unset for Version 2 and do not
undo the completed Version 1 publication record.

## Current Version 2 local candidate

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
| Local built PDF SHA-256 | `52fa3d287401cb85c9023bcfe35abefef17f56a777f5efb725ad01378b5e9158` |
| Local built PDF bytes | `421731` |
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
| `EVIDENCE-MANIFEST.json` | `e987c3f85bcce7ea0fa0ef98f0c55db774e7fa95586ea1462c02cadf8e923d2e` | 21513 |
| `EVIDENCE-ROWS.md` | `23a6f884d5dbae9b0b6162685189ad4a591f5e6f0942d000640661713fb9f78b` | 14280 |
| `package_evidence_bundle.py` | `6d231b8b1d6c7384c482c6c408433400ae2f23305cf61514de17277e35574f79` | 15090 |
| `verify.py` | `12d4161b5401a34d24fb535efe8ec5dd72a464269d0621175c2b95778afe0d5f` | 16721 |
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
