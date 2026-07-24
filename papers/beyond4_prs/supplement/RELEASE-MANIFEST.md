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
| Local built PDF SHA-256 | `cecd0b248c3a3a1b2264472f5f8818fb4c51fa4717b2d19cbcc0ccf78ddacc41` |
| Local built PDF bytes | `302857` |
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
| `EVIDENCE-MANIFEST.json` | `abf9840cc56a8f2dce44a74ad7b067a6dcdb7366771c1615d38dca3894ac1223` | 16388 |
| `EVIDENCE-ROWS.md` | `56850a0134847c45360b1f19df87e9bf9c64eb82f608c869fddbd84c1d6c243e` | 10787 |
| `package_evidence_bundle.py` | `63800ade4708f681c20090587035013fb5bd53efaad133ba39a317182f4bab55` | 14686 |
| `verify.py` | `dd9212ce619030f98e284f6e849e1a6ffb2cdf71289c5d020abceffeb577e7f0` | 5219 |

Verify the complete local bundle from the paper directory:

```text
python3 supplement/verify.py
```

Add `--replay` to run every paper-local replay, including the compiled
R9-49 comparison.

Predecessor manifests are historical evidence and are not rewritten.  This
release-level manifest supersedes their packaging defects by hashing the exact
released bytes, while retaining those manifests inside the archive as
provenance.

The development monorepo is not a publication dependency of either local
check: all consumed certificates and locks are inside `supplement/`.
