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
| Local built PDF SHA-256 | `4772419076563339f466737e5d3a42319a4fb93b92c872742eabc02955027dd7` |
| Local built PDF bytes | `280554` |
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
| `EVIDENCE-MANIFEST.json` | `d6efa629650949a85f8578ff2ad69ff42c35733d5fab0dd80829fbaae54147e2` | 15869 |
| `EVIDENCE-ROWS.md` | `be9b2d94dc67827b1248bf43d0cad2ee689d52d640adc1c0dd19235a43a3569d` | 10472 |
| `package_evidence_bundle.py` | `40c3483185f9c21c41af5140a634f8ea422e2f163689d787f65577384a0607c6` | 14583 |

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
