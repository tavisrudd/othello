# C856 review verification — independent audit of the standards-closure claims

**Lane:** `clebsch` · **Date:** 2026-08-03

Independent three-part review of the completed C856 Paper II Lean standards
closure (`2026-08-02-c856-paper-ii-lean-standards-closure.md`), run read-only
with no builds. Each part re-derived the claims from source rather than
trusting the closeout report.

## 1. Fixed-line derivation — confirmed

`RelativeConicArcs/ClebschFixedLineRadialTranslation.lean` matches the claim:
`RadialEvaluationFamily` carries only parameter-independent data plus the three
Radical--Hadamard properties at the reference parameter; the three
`*_of_noncoalescent` lemmas take only `outerRadialConstantAt … t ≠ 0`; the
downstream conclusions consume the derived forms; the span rescaling genuinely
divides by the reference outer constant with every coalescent and
characteristic-two degeneracy excluded by explicit hypothesis. The structural
gate has exactly twenty-nine terminals including
`RadialEvaluationFamily.evaluationSpace_eq_reference`. No `sorry`, `axiom`,
`unsafe`, `native_decide`, or `decide` in the module.

Caveats, disclosed but worth keeping visible:

- the transport is shallow by construction — all parameter dependence is
  defined into the single span generator with sheet values `(0, c−2t)`, so the
  equality is a one-line rescaling; the mathematical content lives in the
  stated human input that the geometric evaluation spaces have this
  presentation, which is disclosed in the module header, gate header,
  manuscript, and trust manifest in matching words;
- no `RadialEvaluationFamily` instance is ever constructed and nothing links
  it to `affineEvaluationSpace`, so non-vacuity of the structure is not
  kernel-checked.

## 2. Verification and trust surface — confirmed empirically

`verify_release.py` derives the expected metadata line from observed counts
(`metadata_success_line`), builds the fingerprint expectation from the same
function, and rejects a mismatched fingerprint. The rejection was exercised on
a scratch copy of the paper tree: hand-editing only the fingerprint line back
to 28 statements fails with
`evidence fingerprint pins a stale expected metadata line` and exit 1, while
`--metadata-only` on the real tree passes with
`metadata: 29 statements, 14 evidence bundles: CHECK OK` and no Lean
invocation. The fifty-five-terminal axiom count with allowlist
`propext`, `Classical.choice`, `Quot.sound` was independently reproduced.

Nuances: on the monorepo path the new derived-line comparison is technically
vacuous (both sides come from observed counts) and staleness is caught instead
by the older byte-compare with a generic message; and the axiom audit is a
live gate replay checked against runner constants — there is no tracked
fifty-five-row axiom report artifact under `verification/`.

## 3. Closure docstrings and negative checks — confirmed for the project-owned closure

Across the fifty-six `RelativeConicArcs` files, 887 public declarations all
carry docstrings except three section-`local` instances and one anonymous
`local instance`, none scholarly-public API. Negative checks are clean over
the full closure: zero hits for `sorry`, `axiom`, `unsafe`, `native_decide`,
task identifiers, lane/agent/session/status vocabulary, and machine-local
paths; every "first" hit is the mathematical ordinal.

## 4. State of the C860 cap-closure boundary

The Paper I C855 pass performed the structural half of the C860 cleanup: the
five "Separate the …" commits (`ef5f9d2c`–`a14fefa1`) split the cap library so
the game modules (`CapGame.BuildGame`, `FrameGridBridge`, `GridGame`,
`GridSeed`) are no longer in the paper gates' transitive closure, and the
`Sym2ConicBridge` reverse references reported by C856 are gone. The closure of
the four Paper II gates is now sixty-one files: the fifty-six project-owned
`RelativeConicArcs` files plus five cap geometry modules —
`ProjectiveCap.Grid`, `PlaneAffineChart`, `PlaneTransitivity`, `Projective`,
`Sym2ConicBridge`.

What has not landed is the documentation half over those five residual
modules: 89 public declarations lack docstrings, including plain theorems and
definitions (`Grid.lean` monotonicity lemmas, `PlaneAffineChart.lean`
definitions), not only decidability instances. The C860 queue row is also
still marked QUEUED at HEAD. So the "referee-ready on the project-owned
closure only" boundary in the C856 report still stands until those
docstrings are closed, though the remaining work is far smaller than the
C860 plan's original eight-module, 106-declaration inventory.

Minor observation: no file under `papers/clebsch-factorization/verification/`
lists the transitive closure; the `.sha256` files are partial per-gate lists
and there is no `arithmetic_gluing.sha256`. The closure had to be recomputed
from imports.

## Verdict

The C856 closure work is sound: every substantive claim in its closeout report
was independently confirmed, including the one empirical gate (stale
fingerprint rejection). The residual open item is the documentation of the
five cap geometry modules still in the closure, the surviving sliver of the
C860 boundary after the Paper I dependency split.
