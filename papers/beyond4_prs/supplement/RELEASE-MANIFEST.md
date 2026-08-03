# Release manifest

Status: **Version 1 published; Version 2 is the current local draft**

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
| Local built PDF SHA-256 | `9b0809d971890504cb5a2fef0117aeefe8c50cb1a62234080c10d3a8f110b224` |
| Local built PDF bytes | `367860` |
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
| `EVIDENCE-MANIFEST.json` | `a54fd6e76c5bdd7043cc7d92edbbd79bf2126fda0891478995ffe54bc165cccd` | 20506 |
| `EVIDENCE-ROWS.md` | `74daccf962468f03fe571209b1bba3b7a5583ab07bbe52b4389cfb61bc745334` | 13579 |
| `package_evidence_bundle.py` | `54559e6e94e59d1b3152c410151f14c3039fad307a5f318b39aa2d17d34db03a` | 14585 |
| `verify.py` | `fe9fdb9e1feafaad11667b7040e4e1bfdf2b81068495cc542357c83bf0a62dde` | 16488 |
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
