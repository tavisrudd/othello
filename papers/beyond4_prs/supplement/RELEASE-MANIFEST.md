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
| Local built PDF SHA-256 | `4854c8466cfae309b4defe9c839fe5667b99e97f650ba8b6966cbc717b6b0eb9` |
| Local built PDF bytes | `296229` |
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
| `EVIDENCE-MANIFEST.json` | `35d22d3c1442d0abae4645b50d516ecb7ae25ab6c8315e127d63669a3dd095e9` | 12586 |
| `EVIDENCE-ROWS.md` | `a09020aec3531fd756ab76137dfad2f4a0dbd65210c964b8f055dc76044a7929` | 8311 |
| `package_evidence_bundle.py` | `8bf477b5492d1ca58e9dbb6b637e1ab02b0f201c3b690d1942bceee84972a9fd` | 12245 |
| `verify.py` | `3fa971869dd014b14376781c2e39bfcd24f51a56dc8dcc4889905e08a94724ae` | 12283 |
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
