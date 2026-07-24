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
| Local built PDF SHA-256 | `8c7e8ec1c355918ae3554a4f7474a0f427dac62274ded1641174220e8276054b` |
| Local built PDF bytes | `294534` |
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
| `EVIDENCE-MANIFEST.json` | `b6ea00955c0d0beae716778f37e4a7c7b4dd6ce94f5db3f5dd7fbbc592edbe7c` | 16388 |
| `EVIDENCE-ROWS.md` | `f2a9dfd198a0c5d1cfca73cf64c71ff165b4be3002b4ff18659c19d0ca64996c` | 10787 |
| `package_evidence_bundle.py` | `63800ade4708f681c20090587035013fb5bd53efaad133ba39a317182f4bab55` | 14686 |
| `verify.py` | `249a048015c1aadc018ae1d546c6e7300c163454d60da79720eb4e19ef6904ec` | 3536 |

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
