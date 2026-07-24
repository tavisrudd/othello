# Reproducing the computational supplement

The complete local evidence bundle is under this `supplement/` directory.
`EVIDENCE-MANIFEST.json` records every stable path, SHA-256 value, byte count,
and replay class; `EVIDENCE-ROWS.md` is its human-readable rendering.  Verify
the bundle without access to the development monorepo by running, from the
paper directory:

```text
python3 supplement/verify.py
```

Run every paper-local independent replay, including the compiled R9-49
comparison, with:

```text
python3 supplement/verify.py --replay
```

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
`https://github.com/tavisrudd/finitegeom`.  The separately distributed Q25
certificate payload is assigned to
`https://github.com/tavisrudd/finitegeom-q25-certificates`.  Their immutable
commit revisions are release metadata in `RELEASE-MANIFEST.md`.  They are not
silently replaced by paths into the development monorepo.  Until those
repositories and revisions are published, the local bundle checks the
paper-local evidence and Lean interface described in the manuscript but does
not claim an externally fetchable formal replay.

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
| Certificate R7 | \(q=7,8,9,11\) census and the finite coherent-polar bridge below 37 | independent five-secant and orbit checks |
| Certificate R8 | characteristic cases and numerical bounds, not an ambient census | independent algebra/nucleus replay |
| Certificate R9 | residual algebra, all recorded slice normal forms, and the public Bezout vectors | independent residual/slice replay plus exact supplement transcription check |
| Certificate R9-49 | the characteristic-seven carrier at \(q=49\) | one exhaustive carrier implementation |
| Certificate Hessian | bounded algebra regression | does not replace the geometric proof |
| Certificate Lucas | recorded Lucas arithmetic parameter domain | independent arithmetic replay |
| Certificate e7 | recorded quotient-cover open set and additive specialization | independent quotient-cover replay |

## Exact replay commands

Run these from the paper directory.  Each subshell changes only to the
paper-local directory containing the named certificate.

```text
(cd supplement/evidence/r5 && python3 2026-07-22-c491-prs-deep-hole-replay.py --json 2026-07-22-c491-prs-deep-hole-census.json)
(cd supplement/evidence/r6 && python3 2026-07-22-c498-prs-deep-hole-replay.py --json 2026-07-22-c498-prs-deep-hole-census.json)
(cd supplement/evidence/r6-normal-forms && python3 2026-07-23-c498-small-exceptional-normal-forms.py --summary)
(cd supplement/evidence/r7 && python3 2026-07-23-c509-prs-deep-hole-calibration-replay.py)
(cd supplement/evidence/r8 && python3 2026-07-23-c513-prs-redundancy-eight-replay.py)
(cd supplement/evidence/r9 && python3 2026-07-23-c516-prs-redundancy-nine-replay.py)
(cd supplement/evidence/hessian && python3 2026-07-23-c525-ordered-hessian-arf-pullback-replay.py)
(cd supplement/evidence/lucas && python3 2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic-replay.py)
(cd supplement/evidence/e7 && python3 2026-07-23-c530-degree-nine-lucas-e7-quotient-cover-replay.py)
```

The R9-49 generator is the sole exhaustive implementation of that carrier,
not an independent replay.  Compile it into a disposable build directory and
compare its complete output:

```text
mkdir -p .replay-build
rustc -O supplement/evidence/r9-q49/2026-07-23-c516-prs-redundancy-nine-q49.rs -o .replay-build/r9-q49
.replay-build/r9-q49 > .replay-build/r9-q49.txt
cmp .replay-build/r9-q49.txt supplement/evidence/r9-q49/2026-07-23-c516-prs-redundancy-nine-q49.txt
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
