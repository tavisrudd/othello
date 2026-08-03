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

Create the paper-only and exact 17-source-file Lean fresh-history candidates
from a clean development revision with:

```text
python3 supplement/prepare_release_export.py /disk-backed/output/path
```

The command refuses an existing destination or dirty release-owned source,
archives only the committed paper tree and exact 17-source-file Lean closure,
and
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

In the export layout, `lean/` is a separately initialized repository
containing the exact paper-facing formal closure and its pinned build flake.
Its eventual immutable public commit in
`https://github.com/tavisrudd/finitegeom` is release metadata in
`RELEASE-MANIFEST.md`.  The version-independent archival locator for that
repository is the Zenodo concept DOI
[`10.5281/zenodo.21650878`](https://doi.org/10.5281/zenodo.21650878).
The exported repository is not a path into the development monorepo.  Every
certificate consumed by the adopted theorem set
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
| Certificate R7 direct locus | fourteen-field candidate-domain exhaustion | direct-locus reconstruction with declared shared engine/R5/R6 inputs; checker is not a second field implementation |
| Certificate SC | integral factorization and bridge identities in every characteristic; saturation over \(\mathbf Z[1/6]\); fibres \(2,3\) | dependency-free identity/factorization replay plus Singular primary decomposition |
| Certificate R8 | threshold, modular supports, and witness data | generator plus separately written replay |
| Certificate R9 | residual-quadratic and characteristic-seven bridge data | generator, independent residual replay, and exact q=49 Rust record |
| Certificate R10 | threshold and persistent orbit arithmetic | generator plus independent cyclic-orbit replay |
| Certificate Lucas M9 | rank-two twists and complete q=16,32,64 carrier witnesses | exact certificates plus independent action/Hankel replay |

## Exact replay commands

Run these from the paper directory.  Each subshell changes only to the
paper-local directory containing the named certificate.  The top-level
`--replay` option runs the complete Python replay list; the two Singular commands are
separate checks in the same evidence bundle.

```text
(cd supplement/evidence/r5 && python3 2026-07-22-redundancy-five-deep-hole-replay.py --json 2026-07-22-prs-deep-hole-census.json)
(cd supplement/evidence/r6 && python3 2026-07-22-redundancy-six-deep-hole-replay.py --json 2026-07-22-prs-deep-hole-census.json)
(cd supplement/evidence/r6-normal-forms && python3 2026-07-23-small-exceptional-normal-forms.py --summary)
(cd supplement/evidence/r7 && python3 2026-07-23-prs-deep-hole-calibration-replay.py)
(cd supplement/evidence/r7 && python3 2026-07-26-r7-independent-arithmetic-replay.py)
(cd supplement/evidence/r7 && python3 2026-07-26-r7-direct-locus-replay.py --check 2026-07-26-r7-direct-locus-replay.json)
(cd supplement/evidence/r7-direct-locus-v2 && python3 2026-08-02-r7-direct-locus-generator.py --check)
(cd supplement/evidence/r7-direct-locus-v2 && python3 2026-08-02-r7-direct-locus-checker.py 2026-08-02-r7-direct-locus-certificate.json --compare-public ../../CLASSIFICATION-RECORDS.json --output-comparison 2026-08-02-r7-direct-locus-public-comparison.json --check-comparison)
(cd supplement/evidence/r8 && python3 2026-07-23-prs-redundancy-eight.py --check)
(cd supplement/evidence/r8 && python3 2026-07-23-prs-redundancy-eight-replay.py)
(cd supplement/evidence/r9 && python3 2026-07-23-prs-redundancy-nine.py --check)
(cd supplement/evidence/r9 && python3 2026-07-23-prs-redundancy-nine-replay.py)
(cd supplement/evidence/r9 && rustc -O 2026-07-23-prs-redundancy-nine-q49.rs -o /tmp/prs-r9-q49 && /tmp/prs-r9-q49 | cmp - 2026-07-23-prs-redundancy-nine-q49.txt)
(cd supplement/evidence/r10 && python3 2026-07-23-prs-redundancy-ten-synthesis.py --check)
(cd supplement/evidence/r10 && python3 2026-07-23-prs-redundancy-ten-synthesis-replay.py)
(cd supplement/evidence/lucas-m9 && python3 2026-07-24-degree-nine-rank-two-artin-schreier-avoidance.py --check)
(cd supplement/evidence/lucas-m9 && python3 2026-07-24-degree-nine-rank-two-artin-schreier-avoidance-replay.py)
(cd supplement/evidence/lucas-m9 && python3 2026-08-02-higher-lucas-modular-carriers.py 16 --check 2026-08-02-higher-lucas-modular-carriers-q16.json)
(cd supplement/evidence/lucas-m9 && python3 2026-08-02-higher-lucas-modular-carriers.py 32 --check 2026-08-02-higher-lucas-modular-carriers-q32.json)
(cd supplement/evidence/lucas-m9 && python3 2026-08-02-higher-lucas-modular-carriers-replay.py)
(cd supplement/evidence/stable-components && python3 2026-07-24-r10-integral-bad-scheme-sc11.py --check)
(cd supplement/evidence/stable-components && python3 2026-07-24-stable-component-fano-elimination.py --check)
(cd supplement/evidence/stable-components && Singular -q 2026-07-24-r10-integral-bad-scheme-sc11.sing)
(cd supplement/evidence/stable-components && Singular -q 2026-07-24-stable-component-fano-elimination.sing)
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
