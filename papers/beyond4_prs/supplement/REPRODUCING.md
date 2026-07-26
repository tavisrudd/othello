# Reproducing the computational supplement

The complete local evidence bundle is under this `supplement/` directory.
`EVIDENCE-MANIFEST.json` records every stable path, SHA-256 value, byte count,
and replay class; `EVIDENCE-ROWS.md` is its human-readable rendering.  Verify
the bundle without access to the development monorepo by running, from the
paper directory:

```text
python3 supplement/verify.py
```

The quick check also verifies that the local PDF and the five
supplement-artifact rows printed in `RELEASE-MANIFEST.md` match the
current files.  It deliberately does not fill or validate the external
repository, archive, DOI, or immutable-release fields.

Run every paper-local Python replay with:

```text
python3 supplement/verify.py --replay
```

Create the paper-only and exact R5--R7 Lean fresh-history candidates from a
clean development revision with:

```text
python3 supplement/prepare_release_export.py /disk-backed/output/path
```

The command refuses an existing destination or dirty release-owned source,
archives only the committed paper tree and exact 17-file Lean closure, and
prints the source, paper, and Lean commit identifiers.  The output contains a
paper repository at its root and a separately initialized Lean repository
under `lean/`; the paper repository excludes that adjacent Lean checkout.

## Pinned environment

The exact Lean, Lake, Nix, and Rust dependency locks used by the development
tree are copied into `supplement/toolchain/` and hashed in the evidence
manifest:

- `lean-toolchain`;
- `lake-manifest.json`;
- `export-flake.lock` and `export-flake.nix`;
- `Cargo.lock`.

The Python replays use only the standard library.  The two Rust generators
require a Rust compiler compatible with the copied lock.  External repository,
tag, archive, and DOI fields belong to the immutable publication step and are
listed separately in `RELEASE-MANIFEST.md`.

The paper-export root also contains `flake.nix`, `flake.lock`, and
`lean-toolchain`.  Enter the pinned environment before building or replaying:

```text
nix develop
```

Build the manuscript with `make check`.  The canonical output is
`prs-beyond-redundancy-four.pdf`;
`main.pdf` is not part of the export.

In the export layout, `../lean` is the repository root of the public
formal-verification checkout
`https://github.com/tavisrudd/finitegeom`.  Its immutable commit revision is
release metadata in `RELEASE-MANIFEST.md` and must also be resolved by the
release flake and lock.  It is not silently replaced by a path into the
development monorepo.  Every certificate consumed by the adopted theorem set
is already paper-local; no separate certificate-package input belongs in the
release flake.  Until the public Lean repository and revision are published,
the local bundle checks the paper-local evidence and Lean interface described
in the manuscript but does not claim an externally fetchable formal replay.

## Replay semantics

The release manifest assigns every replay one of the schema labels
**rederive**, **reconstruct**, or **compare** from
`CERTIFICATE-SCHEMA.md`.  A successful comparison-only replay is never
described as an independent derivation.

## Replay map

| Public label | Domain/stop condition | Replay boundary |
|---|---|---|
| Certificate R5 | nineteen recorded fields; pointwise and orbitwise exhaustion | independent Python replay |
| Certificate R6 | direct scan through \(q=16\); structural bridge thereafter | independent replay plus radius gate |
| Certificate R6-NF | recorded small exceptional normal forms | same-file deterministic checker |
| Certificate R7 | \(q=7,8,9,11\) census and the finite coherent-polar bridge below 37 | primary quotient enumeration, representative/orbit replay, independent-arithmetic reconstruction, and an independent direct-locus enumeration of the complete split-free sets and orbit partitions |
| Companion Certificate SC | non-adopted integral factorization and bridge identities in every characteristic; saturation over \(\mathbf Z[1/6]\); fibres \(2,3\) | companion-only dependency-free identity/factorization replay plus trusted Singular primary decomposition |

## Exact replay commands

Run these from the paper directory.  Each subshell changes only to the
paper-local directory containing the named certificate.  The top-level
`--replay` option runs the eight Python commands; the two Singular commands are
separate checks in the same evidence bundle.

```text
(cd supplement/evidence/r5 && python3 2026-07-22-c491-prs-deep-hole-replay.py --json 2026-07-22-c491-prs-deep-hole-census.json)
(cd supplement/evidence/r6 && python3 2026-07-22-c498-prs-deep-hole-replay.py --json 2026-07-22-c498-prs-deep-hole-census.json)
(cd supplement/evidence/r6-normal-forms && python3 2026-07-23-c498-small-exceptional-normal-forms.py --summary)
(cd supplement/evidence/r7 && python3 2026-07-23-c509-prs-deep-hole-calibration-replay.py)
(cd supplement/evidence/r7 && python3 2026-07-26-c656-r7-independent-arithmetic-replay.py)
(cd supplement/evidence/r7 && python3 2026-07-26-c545-r7-direct-locus-replay.py --check 2026-07-26-c545-r7-direct-locus-replay.json)
(cd supplement/evidence/stable-components && python3 2026-07-24-c597-r10-integral-bad-scheme-sc11.py --check)
(cd supplement/evidence/stable-components && python3 2026-07-24-c595-stable-component-fano-elimination.py --check)
(cd supplement/evidence/stable-components && Singular -q 2026-07-24-c597-r10-integral-bad-scheme-sc11.sing)
(cd supplement/evidence/stable-components && Singular -q 2026-07-24-c595-stable-component-fano-elimination.sing)
```

The public R5--R7 orbit tables are a deterministic projection of the
hash-pinned frozen certificates.  From the paper directory run:

```text
python3 supplement/build_classification_records.py --check
```

This verifies the embedded source hashes, every projected record, and every
orbit-size completeness sum.  It does not rerun the classifications.

## Public classification-record extraction

From the paper directory:

```text
python3 supplement/build_classification_records.py --check
jq -e 'all(.records[].fields[]; .exhaustion_identity == true)' \
  supplement/CLASSIFICATION-RECORDS.json
```

The builder reads only the bundled R5, R6, R6-NF, and R7 certificates.  It
stops after serializing all 19 R5 fields, 11 R6 fields, and 14 R7 fields, and
proves byte-for-byte agreement with the committed public record.  The `jq`
command independently checks every recorded orbit-size exhaustion identity.
This extraction does not rerun the underlying finite classifications.
