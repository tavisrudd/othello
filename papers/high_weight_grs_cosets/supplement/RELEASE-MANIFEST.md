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
| Paper-export repository | `https://github.com/tavisrudd/high-weight-grs-cosets` |
| Release tag | `v0.1.0` |
| Release commit | `0d3cea228b852c45f048c3446604ee2146219144` |
| GitHub release | `https://github.com/tavisrudd/high-weight-grs-cosets/releases/tag/v0.1.0` |
| Zenodo record | `21682216` |
| Version DOI | `10.5281/zenodo.21682216` |
| Concept DOI | `10.5281/zenodo.21682069` |
| Source archive | `tavisrudd/high-weight-grs-cosets-v0.1.0.zip` |
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
| PDF artifact | `high-weight-grs-cosets.pdf` |
| Local built PDF SHA-256 | `b0ba9d55d3310e8c7ed5e9821a2273f238764609226a5640cbe2c947505203b0` |
| Local built PDF bytes | `340926` |
| PDF SHA-256 | computed from the immutable export build |
| PDF bytes | computed from the immutable export build |
| Toolchain lock | `supplement/toolchain/`; five pinned files with hashes below |
| Companion software | `software/projective-reed-solomon/`; independently locked and hashed by `supplement/SOFTWARE-MANIFEST.json` |

## Artifact rows

`EVIDENCE-ROWS.md` contains one row for every bundled generator,
certificate, replay, predecessor checksum, toolchain lock, and public
supplement input.  Its machine-readable source is
`EVIDENCE-MANIFEST.json`.  Both use paths relative to this supplement and
record SHA-256 plus exact byte count.

| Manifest object | SHA-256 | Bytes |
|---|---|---:|
| `EVIDENCE-MANIFEST.json` | `c3b93bd5ed6997c628ce31ef5ad719056a41a28621e2dbbca7b26b8d10ac1520` | 28314 |
| `EVIDENCE-ROWS.md` | `01ae87a5c700d249e1f69c840ddbebab781c025643b6eda52c57b799dfaf9a91` | 18939 |
| `package_evidence_bundle.py` | `a63ec1899ee81dd2b0ab5bad1e1ff82a29231032178f1f66bbdc8158e5c710c2` | 18102 |
| `verify.py` | `90d77a001600fb06899243345f2ad25973d01859c1382e316dae4ce5f7444c09` | 16520 |
| `build_r6_paper_table.py` | `b46a30752ea17d85093e6181d50ca8dbd6f12386416aedc3e8509406a2060f98` | 3878 |
| `package_software.py` | `f01c53a315c95ecafc96b4fb2402616cbb67322fd0ecd3adb512b16b60f7b8ef` | 2057 |
| `SOFTWARE-MANIFEST.json` | `48f879f564a497916d79e6e9836da1fb585d6712ce69a7b528c866406bfe335b` | 4583 |

Verify the complete local bundle from the paper directory:

```text
python3 supplement/verify.py
```

Add `--replay` to run every paper-local Python replay.  The two paper-local
Singular checks are listed separately in `REPRODUCING.md`.

Add `--release` to require the immutable repository, revision, archive, DOI,
and released-PDF fields.  It is expected to fail while any field remains an
external publication step.  Private reader correspondence is deliberately
outside both this manifest and the public release gate.

Predecessor manifests are historical evidence and are not rewritten.  This
release-level manifest supersedes their packaging defects by hashing the exact
released bytes, while retaining those manifests inside the archive as
provenance.

The development monorepo is not a publication dependency of either local
check: all consumed certificates and locks are inside `supplement/`.
