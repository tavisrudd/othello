# C19 certcheck reflection report

Date: 2026-07-08

## Result

Implemented the Route-C reflected checker and generator path.

- Added `lean/ProjectiveCap/CertCheck.lean`, a Bool checker over concrete list-backed certificate data with soundness into `GridClassCert.Valid`.
- Updated `notes/2026-07-07-anchored-cert-to-lean.py` to emit `CertCheck.ClassData` plus split reflected proof obligations.
- Generated checked data modules:
  - `lean/ProjectiveCap/CertData/Q5.lean`
  - `lean/ProjectiveCap/CertData/Q7.lean`
  - `lean/ProjectiveCap/CertData/Q11.lean`
- Imported `ProjectiveCap.CertCheck` from `ProjectiveCap.lean`; generated data remains opt-in because Q11 takes ~25 minutes to elaborate.
- Fixed one stale `omit [DecidableEq K]` in `ProjectiveCap/GridCounting.lean` that blocked `lake build ProjectiveCap`.

## Final checker shape

The first direct generator shape (`exact ... (by decide)` per class) fixed q=5/q=7 but q=11 hit default `maxRecDepth`. Per C19 instructions, the final path does not set `maxRecDepth` and does not use `native_decide`.

The final generator splits the reduction:

- small `rfl` checks for size-three cap, witness move, root equality, root membership, and each node cap;
- per-node step checks split across global cell chunks;
- a Lean soundness assembly via `checkNodeStepOn_of_chunks`, `checkNodes_sound`, `checkSteps_sound`, and `validFor_of_finiteRows`.

## Validation

Commands run from `lean/`:

- `nix develop --command lake build ProjectiveCap.CertCheck` PASS.
- `time -p nix develop --command lake env lean /tmp/c19-q5-chunk.lean` PASS, `real 3.51`.
- `time -p nix develop --command lake env lean /tmp/c19-q7-chunk.lean` PASS, `real 10.56`.
- `time -p nix develop --command lake env lean /tmp/c19-q11-chunk.lean` PASS under default Lean settings, `real 1483.97` (~24m44s).
- `time -p nix develop --command lake env lean ProjectiveCap/CertData/Q5.lean` PASS, `real 13.86`.
- `time -p nix develop --command lake env lean ProjectiveCap/CertData/Q7.lean` PASS, `real 20.32`.
- `cmp -s /tmp/c19-q11-chunk.lean ProjectiveCap/CertData/Q11.lean` PASS; committed Q11 is byte-identical to the checked file.
- `nix develop --command lake build ProjectiveCap` PASS after the GridCounting omit repair.

Static adversarial grep:

- No `maxRecDepth`, `native_decide`, `sorry`, or `admit` in `CertCheck.lean`, generated `CertData`, or the generator.

## Adversarial review

Kernel skeptic: the final q=11 proof does not depend on a recursion-limit option. The proof terms are built from definitional Boolean reductions plus soundness lemmas; no native evaluator is used.

Certificate skeptic: q=5/q=7 committed-path modules were checked directly. q=11 was checked from `/tmp` and then byte-compared against the committed generated file, avoiding a duplicate 25-minute run while preserving exactness.

Performance skeptic: q=11 is just under the C19 stop threshold, not comfortably below it. q=13 was not attempted; the q=13 cert is much larger and should be split per class/file or otherwise further chunked before trying a full module.

Assembly skeptic: this completes the rules-only reflected book validity for anchored classes. It does not close the C19 transport-lemma item: anchor-normalization grid symmetries and assembly into `GridOddEscapeBookCertificate.represents` remain open.

## Next

C20 is the next queue item: winning-intrusion census on the on-conic buckets.
