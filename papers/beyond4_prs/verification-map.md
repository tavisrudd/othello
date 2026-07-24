# Verification map

Paper-facing names are the stable labels `Certificate R5`, `Certificate R6`,
`Certificate R6-NF`, `Certificate R7`, `Certificate R8`, `Certificate R9`,
`Certificate R9-49`, `Certificate Hessian`, `Certificate Lucas`, and
`Certificate e7`.  Their schemas are defined in
`supplement/CERTIFICATE-SCHEMA.md`.  The C-numbers below are immutable internal
provenance only.

Artifact paths below are relative to `notes/`. Commands are run from the repository root unless a
subshell says otherwise. The manuscript’s mathematical claims are proved in its
source reports; these artifacts certify only the finite or symbolic domains stated here. The C538
audit rechecked every load-bearing generator, certificate, and replay hash. Those entries pass.
The C491 and C498 manifests also hash their living theorem reports, which were expanded after the
manifests were written; those two report-only entries are stale. All other listed manifests pass
as written. C538 does not silently refresh predecessor evidence bundles.

| Claim group | Generator | Certificate | Independent replay | Checksum |
|---|---|---|---|---|
| C491 redundancy-five census | `2026-07-22-c491-prs-deep-hole-census.py` | `2026-07-22-c491-prs-deep-hole-census.json` | `2026-07-22-c491-prs-deep-hole-replay.py` | `2026-07-22-c491-prs-redundancy-five.sha256` |
| C498 redundancy-six census | `2026-07-22-c498-prs-deep-hole-census.rs` | `2026-07-22-c498-prs-deep-hole-census.json` | `2026-07-22-c498-prs-deep-hole-replay.py` | `2026-07-22-c498-prs-redundancy-six.sha256` |
| C498 small semilinear normal forms | `2026-07-23-c498-small-exceptional-normal-forms.py` | `2026-07-23-c498-small-exceptional-normal-forms.json` | the generator is also the deterministic checker; no second implementation is claimed | `2026-07-23-c498-small-exceptional-normal-forms.sha256` |
| C509 redundancy-seven calibration | `2026-07-23-c509-prs-deep-hole-calibration.py` | `2026-07-23-c509-prs-deep-hole-calibration.json` | `2026-07-23-c509-prs-deep-hole-calibration-replay.py` | `2026-07-23-c509-prs-redundancy-seven.sha256` |
| C513 redundancy-eight specialization | `2026-07-23-c513-prs-redundancy-eight.py` | `2026-07-23-c513-prs-redundancy-eight.json` | `2026-07-23-c513-prs-redundancy-eight-replay.py` | `2026-07-23-c513-prs-redundancy-eight.sha256` |
| C516 redundancy-nine component theorem | `2026-07-23-c516-prs-redundancy-nine.py` | `2026-07-23-c516-prs-redundancy-nine.json` | `2026-07-23-c516-prs-redundancy-nine-replay.py` | `2026-07-23-c516-prs-redundancy-nine.sha256` |
| C516 `q=49` carrier closure | `2026-07-23-c516-prs-redundancy-nine-q49.rs` | `2026-07-23-c516-prs-redundancy-nine-q49.txt` | no second exhaustive implementation; the residual formula is independently replayed by the preceding C516 replay | `2026-07-23-c516-prs-redundancy-nine.sha256` |
| C525 ordered-Hessian regression | `2026-07-23-c525-ordered-hessian-arf-pullback.py` | `2026-07-23-c525-ordered-hessian-arf-pullback.json` | `2026-07-23-c525-ordered-hessian-arf-pullback-replay.py` | `2026-07-23-c525-ordered-hessian-arf-pullback.sha256` |
| C529 Lucas arithmetic | `2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.py` | `2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.json` | `2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic-replay.py` | `2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.sha256` |
| C530 degree-nine `e_7` cover | `2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.py` | `2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.json` | `2026-07-23-c530-degree-nine-lucas-e7-quotient-cover-replay.py` | `2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.sha256` |

## Trusted boundaries

- C491 has two independent exhaustive algorithms on
  `q={7,8,9,11,13,16,17,19,23,25,27,29,31,32,37,41,43,47,49}`. The stop condition is that every
  point of each `PG(4,q)` has been classified; the negative claim above `49` is theorem-derived.
- C498 searches exactly `q={7,8,9,11,13,16,17,19,23,25,27}`. The Rust stop condition is
  elementwise equality of the definition and Hankel scans over all of `PG(5,q)`. The theorem,
  not that census, supplies the all-field continuation.
- C498’s independent replay directly reconstructs the definition scan through `q=16`; for
  `q=17,19,23,25,27`, exhaustiveness rests on the Rust definition/Hankel agreement and the replay
  checks the structural and representative-level claims. The small normal-form checker is limited
  to the frozen exceptional fields `q={7,8,9,11,13}`.
- C509 calibrates exactly
  `q={7,8,9,11,13,16,17,19,23,25,27,29,31,32}` and stops after every pointed-bad affine orbit and
  its `q` extensions have been tested at all `q+1` contractions. Its replay uses five-point spans
  rather than the pointed-contraction criterion. At `q=7,8,9` this certifies split-freeness, not a
  covering-radius gate.
- C513 is a symbolic algebra/nucleus/threshold certificate, not a syndrome census. Its finite
  controls are the degree-six nucleus lifts, the `q=7` rootless-quartic count, and the recorded
  `q=49` witness; completion means every listed symbolic identity and finite control passes.
- C516’s `q=49` pass is one exhaustive carrier implementation. It is deliberately not described
  as independently exhaustive. It stops when all `5,884,901` projective carrier quartics have a
  witness. The component certificate covers the six squarefree normal slices, four multiple-root
  normal forms, their explicit Bezout identity, the `q=7` count, and the displayed thresholds.
  Its replay also checks that the vectors transcribed in
  `supplement/R9-SLICE-DATA.md` equal the certificate.
- C525 enumerates all `357` lines of `PG(3,4)` as a regression test, not the algebraic-closure
  proof.
- C529 computes every nucleus/overlap through lower degree eight and records the power-of-two
  controls through `s=4`. C530 checks subspace-polynomial controls for every `3<=m<=12`.
  The all-field normalization, monodromy, and subspace-polynomial statements are hand proofs.

## Exact replay commands

From the repository root:

```text
python3 notes/2026-07-22-c491-prs-deep-hole-census.py
python3 notes/2026-07-22-c491-prs-deep-hole-replay.py
rustc -O notes/2026-07-22-c498-prs-deep-hole-census.rs -o /tmp/c498-census
C498_JSON_OUT=/tmp/c498-census.json /tmp/c498-census
cmp /tmp/c498-census.json notes/2026-07-22-c498-prs-deep-hole-census.json
python3 notes/2026-07-22-c498-prs-deep-hole-replay.py
python3 notes/2026-07-23-c498-small-exceptional-normal-forms.py --summary
python3 notes/2026-07-23-c509-prs-deep-hole-calibration.py --jobs 3 --output notes/2026-07-23-c509-prs-deep-hole-calibration.json --check
python3 notes/2026-07-23-c509-prs-deep-hole-calibration-replay.py
python3 notes/2026-07-23-c513-prs-redundancy-eight.py --output notes/2026-07-23-c513-prs-redundancy-eight.json --check
python3 notes/2026-07-23-c513-prs-redundancy-eight-replay.py
python3 notes/2026-07-23-c516-prs-redundancy-nine.py --output notes/2026-07-23-c516-prs-redundancy-nine.json --check
python3 notes/2026-07-23-c516-prs-redundancy-nine-replay.py
rustc -O notes/2026-07-23-c516-prs-redundancy-nine-q49.rs -o /tmp/c516-q49
diff <(/tmp/c516-q49) notes/2026-07-23-c516-prs-redundancy-nine-q49.txt
python3 notes/2026-07-23-c525-ordered-hessian-arf-pullback.py --output notes/2026-07-23-c525-ordered-hessian-arf-pullback.json --check
python3 notes/2026-07-23-c525-ordered-hessian-arf-pullback-replay.py
python3 notes/2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.py --check notes/2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.json
python3 notes/2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic-replay.py
python3 notes/2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.py --check notes/2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.json
python3 notes/2026-07-23-c530-degree-nine-lucas-e7-quotient-cover-replay.py
```

The C513 manifest is checked from the repository root because its entries are prefixed `notes/`.
The C491, C498, C509, C516, C525, C529, and C530 manifests are checked from `notes/`. C491/C498
require excluding their disclosed stale report-only rows to validate the unchanged load-bearing
artifacts. The C530 manifest omits the byte counts claimed by its report; C491 and C516 likewise
do not record byte counts. This is a predecessor packaging defect, not hidden evidence.

## Lean boundary

- aggregate import closure:
  `RelativeConicArcs.Gates.PRSBeyondRedundancyFour`;
- aggregate tracked audit:
  `RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit`;
- declaration-level manuscript reconciliation and supported replay command:
  `supplement/LEAN-STATEMENTS.md`.

The aggregate gate imports the shared foundation, redundancy-five through redundancy-nine, and
characteristic-two Hessian/Lucas gates.  Its audit covers the paper-adopted algebraic, contraction,
arithmetic, finite-table, and conditional synthesis terminals.  It reports no project-specific
axiom or opaque computational oracle; only the standard `propext`, `Classical.choice`, and
`Quot.sound` dependencies occur.  The R5--R7 transcription modules name the current public
classification record, SHA-256
`b3441d983798793f211878de7e72b976be9170b580041f460cf981a73dbf66a2`.
