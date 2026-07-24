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
| Archive identifier | external publication step |
| DOI | external publication step |
| Source archive SHA-256 | computed from the immutable export archive |
| Source archive bytes | computed from the immutable export archive |
| PDF artifact | `prs-beyond-redundancy-four.pdf` |
| Local built PDF SHA-256 | `8da6ada72e18979512d51bc30eca9c3e1c70759c5115924dbaecdcc59f502e45` |
| Local built PDF bytes | `230468` |
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
| `EVIDENCE-MANIFEST.json` | `e16294d03c5bbfcfedf7001808deaa61a156b6134d7e30b5e1d3e45c14e7bd34` | 16933 |
| `EVIDENCE-ROWS.md` | `f35174fa7f06a1a3571373dea044aee2ce49d762445b885943f8f55b3b703d5e` | 11128 |
| `package_evidence_bundle.py` | `2a741041f1928ec4be1ad67dbdd0a124670abd58e68acb18959869e7231e6924` | 14814 |
| `verify.py` | `d36ab8f00856cd15404f72f0591aaca83dd1792d4482932282bfcf5c7d28755b` | 7773 |
| `build_r6_paper_table.py` | `b46a30752ea17d85093e6181d50ca8dbd6f12386416aedc3e8509406a2060f98` | 3878 |

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
