# C856 — Paper II Lean standards closure

**Lane:** `clebsch` · **Date:** 2026-08-02

## Objective

Repair every gap found by the 2026-08-02 standards audit of the Paper II Lean
surface, then re-audit the complete project-owned closure of the four Paper II
gates against the Lean workspace standards.

## 1. Fixed-line inheritance: assumption replaced by derivation

The audit's one substantive finding was that
`RelativeConicArcs.ClebschFixedLineRadialTranslation` assumed the three
parameterwise Radical--Hadamard premises as fields of a `RadicalHadamardFamily`
structure: for every parameter `t`, that the two sheet restrictions cover their
zero-sum hyperplanes, that every coordinatewise product has equal sheet sums,
and that some product has nonzero sheet sum. The manuscript and trust manifest
nevertheless claimed that Lean checks noncoalescent Radical--Hadamard
*inheritance*. Nothing was inherited: the conclusion-bearing hypotheses were
supplied at each parameter.

The repair presents the evaluation space instead of assuming it. The new
`RadialEvaluationFamily` carries a parameter-independent `topSpace`, the
reference outer constant, and the three Radical--Hadamard hypotheses **at the
reference parameter only**. The evaluation space at a parameter is defined as

```
radialEvaluationSpace data topSpace t
  = topSpace ⊔ (span {constantLevel} ⊔ span {radialLevel data t})
```

where `radialLevel data t` has sheet values `0` and `c - 2t`. The mechanism is
that the only parameter-dependent generator rescales: for parameters `s`, `t`
with nonzero outer constant,
`radialLevel data t = ((c-2t)/(c-2s)) • radialLevel data s`, so the two spans
coincide and

```
radialEvaluationSpace data topSpace s = radialEvaluationSpace data topSpace t.
```

The three hypotheses are then *derived* at every noncoalescent parameter by
rewriting along that equality
(`restrictsOntoZeroSum_of_noncoalescent`,
`productsHaveEqualSheetSums_of_noncoalescent`,
`hasNonzeroSheetProduct_of_noncoalescent`), and the existing conclusions
(`hadamardSquare_eq_equalSheetSum_of_noncoalescent`,
`annihilates_hadamardSquare_iff_eq_sheetSignLine_of_noncoalescent`,
`nonmatchingNoncoalescentParameters_tradeLine_and_card`) now consume the derived
forms. No parameterwise conclusion-bearing assumption survives in a structure
field.

The residual mathematical hypothesis is stated rather than hidden: identifying
the *geometric* evaluation spaces with this presentation — top space, constant
function, radial level — is a human input. That boundary is now recorded in the
module header, the gate header, the manuscript's formal-correspondence
paragraph, and the trust manifest's evidence role and boundary entry.

`RadialEvaluationFamily.evaluationSpace_eq_reference` was added as a gate
terminal so the derivation step is itself audited. The Paper II structural gate
therefore has twenty-nine terminals and the four-gate axiom audit has
fifty-five.

## 2. Public docstrings

Every scholarly-public declaration in the fifty-six-file project-owned
`RelativeConicArcs` closure of the four Paper II gates now has a self-contained
mathematical docstring. This covers both audit classes: the ten declarations
added in the audited delta (`ClebschFixedLineRadialTranslation`,
`ClebschOuterParityInjection`, `ClebschPolynomialTopSliceDetection`) and the
pre-existing gaps in `Arc`, `Certificate`, `ClebschBalancedSheets`,
`ClebschConicMatchingQuotient`, `ClebschGateway`, `ClebschHarmonicQuotient`,
`CodingBridge`, `Conic`, `Defect`, `Moments`, `Plane`, `ProjectiveBridge`, and
`SyndromeGeometry`. The recount before repair was 127 declarations, one more
than the audit's 126; the audit list was otherwise exact.

No generated Lean source required a prose repair, so no generator was rerun.

## 3. Derived expected-metadata check

`verification/verify_release.py` pinned the expected success line
`metadata: 28 statements, 14 evidence bundles: CHECK OK` while the manifest
contains and reports 29 statements, and nothing compared the two.

The runner now derives that line from the counts it observes
(`metadata_success_line`), builds the fingerprint's `expected_success.metadata`
from the same function, and rejects any fingerprint whose recorded line
disagrees with the observed counts before the metadata-only run returns.
Verified both directions:

- the standalone path rejects a hand-edited `28`-statement line with
  `evidence fingerprint pins a stale expected metadata line`;
- both the monorepo and a standalone copy pass with the corrected
  `metadata: 29 statements, 14 evidence bundles: CHECK OK`.

## 4. Cross-lane blocker: the `ProjectiveCap`/`CapGame` closure

The four Paper II gates do not import only `RelativeConicArcs`. Through
`RelativeConicArcs.Conic`, `Certificate`, and `ProjectiveBridge` the transitive
closure also contains eight modules owned by the projective-cap lane:
`CapGame.BuildGame`, `ProjectiveCap.FrameGridBridge`, `ProjectiveCap.Grid`,
`ProjectiveCap.GridGame`, `ProjectiveCap.GridSeed`,
`ProjectiveCap.PlaneTransitivity`, `ProjectiveCap.Projective`, and
`ProjectiveCap.Sym2ConicBridge`.

Two standards violations remain there, outside this task's safe edit scope:

1. **Reverse references.** `ProjectiveCap.Sym2ConicBridge` names an internal
   work item three times, in its module header and in two docstrings. The
   reference-direction rule forbids any Lean source from citing an internal
   record.
2. **Missing public docstrings.** Those eight modules hold 106 scholarly-public
   declarations without docstrings, 38 of them in
   `ProjectiveCap.FrameGridBridge` and 37 in `ProjectiveCap.PlaneTransitivity`.

These are recorded, not waived. Until they are cleared, the Paper II formal
artifact cannot be called referee-ready on the transitive-closure standard,
even though every project-owned `RelativeConicArcs` file now passes.

A follow-on measurement showed this is not a Paper II problem: about half the
gate modules in the workspace carry `ProjectiveCap`/`CapGame` in their closure,
including the released Paper I and arcs papers, Paper IV in active release
preparation, AME/LU, and `beyond4_prs`. Paper III, the golden-operator paper,
and the transversal-groups paper are clean. The chosen response is therefore to
remove the dependency rather than audit the cap modules: C860 covers moving the
thirty-seven used projective-plane declarations into a shared referee-standard
base module under `RelativeConicArcs` and repointing the cap game at it. Plan:
`notes/clebsch-tasks/c860-projective-base-dependency-inversion.md`.

## 5. Negative checks re-run after repair

Across the fifty-six project-owned modules and the four gate files: no `sorry`,
no explicit `axiom`, no `unsafe` declaration, no `native_decide`, no task
identifier or placeholder, no lane/agent/session vocabulary, no machine-local
path, no status prose (`TODO`, `future work`, `for now`, `pending`,
`temporary`, `fallback`, `known issue`), no novelty or priority claim, and no
workflow-style name. The two apparent task-identifier hits in `CapGame.BuildGame`
are local hypothesis names (`c01`, `c12`, `c23`, `c34`), not identifiers.

## 6. Validation

All four gates were built through the guarded unattended queue and the
trace-only aggregate gate is clean:

```text
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.Gates.ClebschPaperIIStructural \
  RelativeConicArcs.Gates.ClebschArithmeticGluing \
  RelativeConicArcs.Gates.ClebschHilbertSymmetry \
  RelativeConicArcs.Gates.ClebschHyperplaneSquare \
  --profile single --threads 1 --cores 20-23
```

The complete authoritative aggregate then passed from the repository root:

```text
python3 papers/clebsch-factorization/verification/verify_release.py
```

It reported `metadata: 29 statements, 14 evidence bundles: CHECK OK`, every
certificate check and independent replay, the four gates through their guarded
entry points, `clebsch Lean-gate axiom allowlist: CHECK OK` at fifty-five
terminals with only `propext`, `Classical.choice`, and `Quot.sound`,
`clebsch factorization warnings: CHECK OK`, and
`clebsch factorization release: CHECK OK`.

Regenerating the statement identity after the manuscript edit changed only its
derived full-source hash; no theorem-like statement moved. The evidence
fingerprint and the Lean source checksum manifest were refreshed to match.

One process note: an earlier replay of this gate set failed its trace check
because the gate source was edited while that build was in flight. The rerun
above was made against frozen sources.

## Mystery ledger

No genuine mystery remains in the repaired surface. The one open question the
repair exposes is not a mystery but a stated boundary: whether the geometric
evaluation spaces of the fixed line can themselves be *derived* to have the
presented top-space-plus-constant-plus-radial-level form, rather than assumed.
The manuscript proves this by the character argument on the radial coordinate
(the radial character is trivial on the index-two subgroup and negated by the
outer coset); formalizing that step would need the group action and the
character decomposition, which the fixed-line module deliberately does not
carry. That is a scope decision, and it is now stated in the same words in the
module header, the gate header, the manuscript, and the trust manifest.

The cross-lane closure gap in section 4 is a genuine open defect with a named
owner, not an unexplained observation.
