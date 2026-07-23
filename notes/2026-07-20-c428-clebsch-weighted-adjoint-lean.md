# C428 / F9 — Lean weighted 2-adjoint arrangement-code closure

**Lane:** `clebsch`

**Status:** review repairs implemented and validated; post-fix review pending

This file is both the cold-read task specification and the required durable result report. Complete
it in place; do not substitute a chat summary or a second transient document. The finished report
must contain the result, exact theorem types and owned artifacts, validation and axiom evidence,
trust/exclusion boundary, every judgment call, independent review and dispositions, and the C320
ledger delta.

## Required outcome and trust route

After C222 and the spine are independently green, formalize the ambient line-section formula,
weighted 2-adjoint depth identity, punctured depth polynomial, and Hamming enumerator/minimum-distance
consequences. The A3/H3 specializations consume only C222's committed public theorem; B3 uses a
separate checked certificate leaf. Broader orbit enumerators, generalized weights, Tutte
consequences, and all-degree factorized-support counts remain certificate or downstream surfaces,
not implicit Lean exits.

## Cold-read execution brief

- Start only after C222 is committed and its public terminal is identified, and after the
  replacement-spine gate is independently green. Never edit
  `RelativeConicArcs/ReflectionArrangementDecoding.lean`.
- Own only `lean/RelativeConicArcs/ArrangementWeightedAdjoint.lean`,
  `ClebschWeightedAdjointB3.lean`, `lean/RelativeConicArcs/Gates/ClebschWeightedAdjoint.lean`, this
  report, and a same-stem `.py/.json/.sha256` bundle only if the B3 leaf needs generated data.
- Import C421's committed quotient API,
  `RelativeConicArcs.ClebschGatewayCoxeterPhase`, and C222's public terminal. State every field,
  characteristic, arrangement, multiplicity, puncturing, and nondegeneracy hypothesis explicitly.
- Prove the ambient line-section formula, weighted 2-adjoint depth identity, punctured depth
  polynomial, and Hamming enumerator/minimum-distance formula symbolically. Instantiate A3 and H3
  only through C222's theorem. Give B3 a separate sound checked leaf rather than freezing its output
  as an assumption.
- Do not claim broader orbit enumerators, generalized weights, Tutte consequences, or all-degree
  factorized-support counts. If mentioned, classify them as external/downstream and unused.
- Exit only through the separate `RelativeConicArcs.Gates.ClebschWeightedAdjoint` gate. Do not add
  F9 to the replacement-spine gate or let its failure weaken the already green spine.

## Required judgment-call record

Before review, add a completed section here for every implementation or scope choice a later agent
could reasonably question. For each choice record: the question; admissible options; chosen option;
mathematical and measured evidence; effect on theorem statement, trust tier, imports, gate, and
paper claim; rejected alternatives; and the exact condition for reopening it. Include decisions to
omit an optional theorem, use or reject a certificate, weaken or generalize a statement, add a
hypothesis, choose a finite representation, stop after a measured failure, or classify a result as
external. “Obvious,” “standard,” “if feasible,” and an unrecorded absence of work are not
dispositions. If no judgment call occurred, state that explicitly and explain why execution was
fully forced by this brief.

## Implemented result

The owned artifact is split across a symbolic module, one isolated finite `B3/F_11` leaf, and an
import-only gate:

- `lean/RelativeConicArcs/ArrangementWeightedAdjoint.lean`;
- `lean/RelativeConicArcs/ClebschWeightedAdjointB3.lean`;
- `lean/RelativeConicArcs/Gates/ClebschWeightedAdjoint.lean`.

The symbolic layer starts with a finite section profile: the distinct arrangement-line
intersections on one nonmirror test line, their positive multiplicities, and the equality saying
that the sum of those multiplicities is the number `N` of arrangement mirrors. Lean proves

```text
weightedDepth + numberOfDistinctIntersections = N
```

for `weightedDepth = sum_P (multiplicity(P)-1)`. If the test line has `q+1` points, deleting the
distinct intersections gives the ambient identity

```text
|B cap L| + N = q + 1 + weightedDepth(L).
```

The reusable numeric profile records `q`, `n`, `N`, a finite direction label type, the mirror
subset, depth, section size, and their arithmetic identities. It contains no field, projective
space, or evaluation map. At that explicitly conditional level Lean proves:

1. the full depth polynomial is `N * X^(N-1) + puncturedDepthPolynomial`;
2. the coefficient of `X^d` in the punctured polynomial counts the nonmirror directions of depth
   `d`;
3. a nonmirror label of depth `d` has formal weight `n+N-(q+1+d)`;
4. the formal profile polynomial is
   `1 + (q-1) N X^n + (q-1) sum_(L nonmirror) X^(n+N-(q+1+depth(L)))`;
5. an attained maximum nonmirror depth gives the minimum formal profile weight.

The actual Hamming enumerators and minimum distances are supplied only by the separate explicit
finite-field evaluation layer and its concrete coefficient-vector terminals described in the
review-repair section below. No characteristic-polynomial identity or complement-length formula is
assumed or claimed.

## Exact declarations and specialization boundary

The symbolic terminals are:

- `RelativeConicArcs.ArrangementWeightedAdjoint.SectionProfile.weightedDepth_add_card`;
- `RelativeConicArcs.ArrangementWeightedAdjoint.lineSection_card_add_mirrorCount`;
- `RelativeConicArcs.ArrangementWeightedAdjoint.CodeProfile.depthPolynomial_eq_mirror_add_punctured`;
- `RelativeConicArcs.ArrangementWeightedAdjoint.CodeProfile.puncturedDepthPolynomial_coeff`;
- `RelativeConicArcs.ArrangementWeightedAdjoint.CodeProfile.wordWeight_eq_weightAtDepth`;
- `RelativeConicArcs.ArrangementWeightedAdjoint.CodeProfile.hammingEnumerator_eq_weightedDepthSum`;
- `RelativeConicArcs.ArrangementWeightedAdjoint.CodeProfile.minimumDistance_of_maxDepth`.

The finite terminals are:

- `RelativeConicArcs.ArrangementWeightedAdjoint.CoxeterModels.a3_weightedAdjoint_specialization`;
- `RelativeConicArcs.ArrangementWeightedAdjoint.CoxeterModels.h3_weightedAdjoint_specialization`;
- `RelativeConicArcs.ArrangementWeightedAdjoint.CoxeterModels.b3_weightedAdjoint_certificate`.

The `A3/F_5` theorem includes C222's public `a3_intersection_spectrum` result and adds punctured
depth counts `4,6,15` at depths `0,1,2`, six mirrors of depth five, and the pointwise line-section
identity. The `H3/F_11` theorem similarly includes C222's public `h3_intersection_spectrum` and adds
punctured depth counts `40,12,66` at depths `3,4,5`, fifteen mirrors of depth fourteen, and the
pointwise identity. Both are exhaustive kernel checks over the public fixed normalized projective
tables.

The separate `B3/F_11` leaf defines the nine normals
`X,Y,Z,X+Y,X-Y,X+Z,X-Z,Y+Z,Y-Z`. Its exhaustive theorem checks point-multiplicity counts
`48,72,6,4,3` at multiplicities `0,1,2,3,4`; nine mirrors of depth eight; punctured depth counts
`24,36,24,40` at depths `0,1,2,3`; and every pointwise nonmirror line-section identity. There is no
generated data, external certificate, search, sampling, `native_decide`, or non-kernel evaluator.
The finite domain is all 133 fixed normalized representatives of `PG(2,11)` and the nine displayed
normals. Identifying each coordinate display with its abstract Coxeter arrangement remains a named
classical input, not a Lean conclusion.

The sole exit is `RelativeConicArcs.Gates.ClebschWeightedAdjoint`. It is independent of the
replacement-spine gate. `RelativeConicArcs/ReflectionArrangementDecoding.lean` is unchanged.

## Trust and exclusion boundary

The symbolic proofs use Lean kernel checking over finite sums, natural-number arithmetic, and
polynomial sums. The three finite specializations use exhaustive kernel reduction by `decide`.
Final gate validation and exact axiom output are recorded below.

The gate does **not** prove the classical coordinate-to-Coxeter identifications; a characteristic
polynomial or complement-length formula; a full abstract projective-plane API; broader orbit
enumerators or stabilizer strata; generalized Hamming weights; Tutte/coboundary consequences;
all-degree factorized-support counts; the extended-GRS identification; or matching, chirality, and
Fourier reconstruction results. None of those claims inherits the gate's Lean trust label.

## Judgment-call record

### Section-profile abstraction

- **Question/options:** use a new full projectivization hierarchy, a coordinate-only theorem, or
  isolate the exact section-incidence data and check the fixtures separately.
- **Choice/evidence:** use the section profile. The proof needs exactly positive multiplicities,
  total multiplicity `N`, containment in a `q+1`-point line, and finite cardinality subtraction.
- **Effect:** the general theorem is reusable and full-trust for explicit hypotheses, but does not
  claim an abstract projective plane or derive unique line intersection.
- **Rejected/reopening condition:** the coordinate-only route hides the mechanism and a new
  hierarchy expands scope. Reopen only when a successor must derive these hypotheses directly from
  mathlib projectivization.

### Projective-direction code interface

- **Question/options:** add a new linear-code image wrapper, omit nondegeneracy, or use the natural
  projective coefficient-direction interface with exact spanning.
- **Choice/evidence:** use projective directions and require `sectionCard(L) < n`. Every direction
  represents `q-1` nonzero scalars, and spanning is exactly what excludes a zero nonzero-direction
  word.
- **Effect:** the enumerator and minimum-distance statement are exact at the rank-three interface;
  no general-purpose linear-code API is claimed.
- **Rejected/reopening condition:** omitting spanning overcounts zero; a new wrapper duplicates
  infrastructure. Reopen if the paper needs literal equality with an existing library
  weight-enumerator definition.

### Compact `B3` kernel leaf

- **Question/options:** generated `.py/.json/.sha256` data, a compact kernel theorem, or an external
  `B3` row.
- **Choice/evidence:** one separate kernel `decide` theorem; the full 133-point/nine-normal check
  fits the existing heartbeat budget.
- **Effect:** the displayed finite statement is full-trust Lean, with only the classical
  coordinate-to-abstract identification outside Lean.
- **Rejected/reopening condition:** generated data enlarge the surface without reducing trust;
  external classification misses the checked-leaf requirement. Reopen if a stronger census
  requires cross-module certificate sharding.

### Bounded exit

- **Question/options:** add the available orbit, generalized-weight, Tutte, or factorized-support
  consequences, or stop at the required depth/enumerator/distance surface.
- **Choice/evidence:** stop; none is needed for this closure and each has a separate trust surface.
- **Effect:** all optional extensions remain explicitly external/downstream and unused.
- **Reopening condition:** the manuscript adopts one under a separately allocated acceptance gate.

## Validation, axioms, and source identity

The repaired source is pinned at commit
`a00f9062f3d807e2da563fc431b5ab5cd70f69c8`.  The guarded dependency-aware build

```text
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.Gates.ClebschWeightedAdjoint \
  --profile single --threads 1 --cores 20-23 --wait-quiet-seconds 3600 --detach
```

completed successfully in run
`~/.cache/othello-lean-build/run-20260723-161137-4ebd53be`: the target built in
`8:45.12` wall time with `10194116 kB` measured peak RSS, and the runner's final aggregate
`lake build --no-build RelativeConicArcs.Gates.ClebschWeightedAdjoint` replay ended
`All targets up-to-date (8665 jobs)`.  The earlier failed run found one unsolved distributive-ring
identity in `projectiveEvaluationWord_injective_of_positive`; commit `a00f9062` repairs it with
kernel-checked ring normalization.  The successful run is after that source change and is the
authoritative validation.

The gate contains 22 explicit `#print axioms` probes: the seven conditional profile terminals,
the generic evaluation injectivity bridge, projective-table completeness, and the four
specialization/depth/evaluation terminals for each displayed model, together with the upstream
`F_11` table completeness theorem.  Every probe reports only a subset of
`propext`, `Classical.choice`, and `Quot.sound`.  In particular, there is no `sorryAx`, project
axiom, or non-kernel oracle in the reported terminal surface.  The finite checks use exhaustive
kernel reduction by `decide`; `native_decide`, generated data, search, sampling, and an independent
non-kernel evaluator are not used.  A separate numerical replay is therefore not applicable: the
committed theorem terms themselves exhaust the fixed finite domains, and the successful independent
elaboration is their replay.

Final committed source identities are:

| path | bytes | SHA-256 |
|---|---:|---|
| `lean/RelativeConicArcs/ArrangementWeightedAdjoint.lean` | 24183 | `0424e072d76f10cbc224cb5cdef89af91e77be7a94ec3e21a720a8e7962a1197` |
| `lean/RelativeConicArcs/ClebschWeightedAdjointB3.lean` | 5806 | `aeaae5515689ccfcd545d726106b7744bb49aa15aeb15c537846eeaeaaf55634` |
| `lean/RelativeConicArcs/Gates/ClebschWeightedAdjoint.lean` | 2786 | `c39228cec02cce07a304bec3d8f39ee9f533dad3f9628ba16716b188f886c6a1` |

The hashes were recomputed from both the working files and the blobs at `a00f9062`; they agree.
They establish source identity, not mathematical correctness.  The only cited mathematical input
left outside the gate is the classical identification of the displayed coordinate normals with
the abstract `A3`, `B3`, and `H3` Coxeter arrangements.  Without that identification, every
coordinate-table, incidence, depth, coefficient-distribution, injectivity, and distance theorem
remains unconditional for the displayed finite models.

## Independent review

The user-authorized independent Codex referee returned `NO-GO` on 2026-07-23. Its six findings are
accepted:

1. the numeric `CodeProfile` does not yet construct an actual finite-field evaluation code or prove
   the projective scalar/injectivity bridge;
2. the three finite rows do not yet instantiate concrete enumerator and distance corollaries;
3. validation, axiom, commit, hash, and checklist evidence is pending;
4. the section-profile result must be classified as a combinatorial incidence lemma unless its
   geometric bridge is formalized;
5. completeness/nonduplication and incidence semantics of the fixed projective tables require exact
   upstream terminals or an explicit conceptual boundary;
6. the exact-statement adequacy appendix is missing and the current projective-interface judgment
   overstates the type.

Disposition: add the genuine finite-field coefficient/evaluation/projective-direction bridge and
concrete `A3/B3/H3` profile/enumerator/distance exits; narrow the section lemma's trust label; name
the full fixed-table boundary; complete all evidence and exact statements; then request post-fix
review. No finding is waived.

### Implemented repair

The symbolic section-profile theorems are now classified only as conditional combinatorial
incidence lemmas. The actual code surface is separate:

- `projectiveEvaluationWord` evaluates a coefficient vector in `K^3` on a finite set of displayed
  projective representatives over an explicit field `K`;
- `projectiveEvaluationWeight` is its actual Hamming weight;
- `coefficientVectorsOfWeight` is the finite coefficient-vector fibre at a given weight;
- `projectiveEvaluationWord_injective_of_positive` proves that positivity for every nonzero
  coefficient makes the evaluation map injective, so coefficient distributions are distributions
  of distinct codewords.

The repaired concrete terminals are
`CoxeterModels.a3_evaluationCode_weightDistribution`,
`CoxeterModels.b3_evaluationCode_weightDistribution`, and
`CoxeterModels.h3_evaluationCode_weightDistribution`. They state actual coefficient-vector counts,
nonzero lower bounds, and attained minima:

| model | field | length | exact Hamming enumerator | minimum distance |
|---|---:|---:|---|---:|
| displayed `A3` | `F_5` | 6 | `1 + 60z^4 + 24z^5 + 40z^6` | 4 |
| displayed `B3` | `F_11` | 48 | `1 + 400z^42 + 240z^43 + 360z^44 + 240z^45 + 90z^48` | 42 |
| displayed `H3` | `F_11` | 12 | `1 + 660z^10 + 120z^11 + 550z^12` | 10 |

For the fixed projective tables, the gate now includes the new
`CoxeterModels.affineRayVec5_bijective` completeness/nonduplication terminal and the existing
`RelativeConicArcs.Examples.Q11Coding.affineRayVec_bijective` terminal. Incidence remains the
explicit coordinate convention `dot(normal, point)=0`; identifying the displayed normals with
abstract Coxeter arrangements remains the named classical input.

## Exact statement-adequacy appendix

The load-bearing actual-code definitions have these types:

```lean
projectiveEvaluationWord
  (pointVector : P → Fin 3 → K) (evaluationSet : Finset P) (a : Fin 3 → K) :
  {p : P // p ∈ evaluationSet} → K

projectiveEvaluationWeight
  (pointVector : P → Fin 3 → K) (evaluationSet : Finset P) (a : Fin 3 → K) : ℕ

coefficientVectorsOfWeight
  (pointVector : P → Fin 3 → K) (evaluationSet : Finset P) (w : ℕ) :
  Finset (Fin 3 → K)
```

Here `K` is universally quantified with `[Field K] [Fintype K] [DecidableEq K]` where finiteness is
needed. The injectivity bridge is exactly:

```lean
(hpositive : ∀ a : Fin 3 → K, a ≠ 0 →
  0 < projectiveEvaluationWeight pointVector evaluationSet a) →
Function.Injective (projectiveEvaluationWord pointVector evaluationSet)
```

Each concrete distribution terminal states the complement cardinality, the cardinality of every
coefficient-weight fibre in its exhaustive weight list, an exhaustive disjunction placing every
coefficient in that list, a lower bound for every nonzero coefficient, and a nonzero coefficient
attaining the lower bound. The pointwise depth bridges are exactly:

```lean
∀ L ∉ a3Mirrors, ∀ s : NonzeroScalar5,
  a3EvaluationWeight (s.1 • projectiveVec5 L) = 6 - a3WeightedDepth L

∀ L ∉ b3Mirrors, ∀ s : NonzeroScalar,
  b3EvaluationWeight (s.1 • projectiveVec L) = 45 - b3WeightedDepth L

∀ L ∉ h3Mirrors, ∀ s : NonzeroScalar,
  h3EvaluationWeight (s.1 • projectiveVec L) = 15 - h3WeightedDepth L
```

Finally, `a3_evaluationWord_injective`, `b3_evaluationWord_injective`, and
`h3_evaluationWord_injective` instantiate the generic positivity bridge, so the three exhaustive
coefficient distributions are formally distributions of distinct evaluation codewords.

## C320 ledger delta

| claim | exact Lean terminal | route / residual boundary |
|---|---|---|
| weighted depth identity | `RelativeConicArcs.ArrangementWeightedAdjoint.SectionProfile.weightedDepth_add_card` | symbolic Lean; explicit incidence hypotheses |
| ambient line-section formula | `RelativeConicArcs.ArrangementWeightedAdjoint.lineSection_card_add_mirrorCount` | symbolic Lean; explicit `q+1` line and containment hypotheses |
| mirror puncture | `RelativeConicArcs.ArrangementWeightedAdjoint.CodeProfile.depthPolynomial_eq_mirror_add_punctured` | symbolic Lean; explicit mirror count/depth |
| depth coefficients | `RelativeConicArcs.ArrangementWeightedAdjoint.CodeProfile.puncturedDepthPolynomial_coeff` | symbolic Lean; finite directions |
| depth-to-weight | `RelativeConicArcs.ArrangementWeightedAdjoint.CodeProfile.wordWeight_eq_weightAtDepth` | symbolic Lean; section and spanning hypotheses |
| formal profile regrading | `RelativeConicArcs.ArrangementWeightedAdjoint.CodeProfile.hammingEnumerator_eq_weightedDepthSum` | conditional numeric identity only |
| formal profile extremum | `RelativeConicArcs.ArrangementWeightedAdjoint.CodeProfile.minimumDistance_of_maxDepth` | conditional numeric bound and witness only |
| evaluation injectivity | `RelativeConicArcs.ArrangementWeightedAdjoint.projectiveEvaluationWord_injective_of_positive` | full-trust finite-field Lean; explicit positivity hypothesis |
| displayed `A3/F_5` code enumerator/distance | `RelativeConicArcs.ArrangementWeightedAdjoint.CoxeterModels.a3_evaluationCode_weightDistribution` | exhaustive coefficient-vector kernel check + classical arrangement identification |
| displayed `H3/F_11` code enumerator/distance | `RelativeConicArcs.ArrangementWeightedAdjoint.CoxeterModels.h3_evaluationCode_weightDistribution` | exhaustive coefficient-vector kernel check + classical arrangement identification |
| displayed `B3/F_11` code enumerator/distance | `RelativeConicArcs.ArrangementWeightedAdjoint.CoxeterModels.b3_evaluationCode_weightDistribution` | exhaustive coefficient-vector kernel check + classical arrangement identification |
| `A3/F_5` row | `RelativeConicArcs.ArrangementWeightedAdjoint.CoxeterModels.a3_weightedAdjoint_specialization` | exhaustive kernel Lean + classical identification |
| `H3/F_11` row | `RelativeConicArcs.ArrangementWeightedAdjoint.CoxeterModels.h3_weightedAdjoint_specialization` | exhaustive kernel Lean + classical identification |
| `B3/F_11` row | `RelativeConicArcs.ArrangementWeightedAdjoint.CoxeterModels.b3_weightedAdjoint_certificate` | exhaustive kernel Lean + classical identification |

Verify-all delta: add `RelativeConicArcs.Gates.ClebschWeightedAdjoint` and the ten terminal axiom
probes above. Do not add the gate to `RelativeConicArcs.Gates.ClebschReplacementSpine`.

## Required closing review process

**Reviewer-launch authority:** the implementing agent must not spawn, delegate to, select, simulate,
or substitute for the independent reviewer. After completing the artifact, durable report, checklist,
and proposed ledger delta, it must stop, keep the task live, and tell the user that the task is ready
for review. The user will launch Codex as the reviewer. After fixing review findings, the implementer
must stop again and ask the user to launch the post-fix review. Only a review explicitly launched by
the user counts toward the required final `GO`.


The implementer first completes the checklist and a claim-by-claim ledger delta. A separate
referee-style reviewer then reads the actual theorem types, module prose, proof/trust boundary, gate,
and evidence; issues a recorded `GO` or `NO-GO`; and lists every finding. The implementer resolves
each finding or narrows the claimed exit explicitly. The task cannot close until the final
disposition and ledger delta agree with the landed artifact.

**Archival gate:** keep the task row live. After implementation, explicitly request the independent
review; do not infer that review from a build, report, or agent self-check. Any finding or `NO-GO`
blocks completion and archival. Fix every issue, update the artifact/report/checklist/ledger delta,
and request post-fix review. Only a recorded final `GO` permits the task to be marked complete and
archived under the repository completion invariant.

- [x] State every claimed exit in ordinary mathematics, with exact domain, hypotheses, conclusion,
  and correspondence to the intended paper statement.
- [x] Assign each exit exactly one final route: full-trust Lean, exact replay/certificate,
  conceptual proof with named classical inputs, or an explicitly decomposed combination.
- [x] Read the definitions and theorem types themselves: rule out vacuous predicates, conclusions
  baked into definitions or frozen data, weakened quantifiers, hidden typeclass/characteristic or
  nondegeneracy assumptions, empty domains, and theorem names or prose stronger than the type.
- [x] Verify that every claimed terminal is actually imported by the named gate and that validation
  is trace-current for the final source; a green dependency, stale build, report verdict, or
  authoritative-sounding filename is not evidence for an omitted theorem.
- [x] Remove or separately classify every optional, conditional, failed, “standard,” “follows,” or
  “if feasible” clause; no such clause inherits the module or gate's strongest label.
- [x] Record exact owned files, fully qualified terminal names, import-only gate, pinned commit,
  validation command/result, and `#print axioms` output for every terminal.
- [x] Include the exact public theorem statements and load-bearing definitions, or a deterministic
  extraction committed with the report, for the paper's verbatim statement-adequacy appendix.
- [x] Confirm no `sorryAx`, `native_decide`, undisclosed project axiom, opaque oracle, or unreported
  non-kernel execution occurs in the claimed dependency closure.
- [x] For every finite/computational claim, record the checker and soundness theorem, finite domain,
  generator/schema/data/hash, independent replay, exhaustive-versus-search status, and residual
  trusted boundary; write “not applicable” only with a reason.
- [x] Recompute byte counts and hashes only after the final source/evidence edit and compare them to
  the committed files; hashes establish identity, not mathematical correctness or regeneration.
- [x] List every cited or axiomatized input and what remains unconditional without it.
- [x] Review the entire touched module, names, filenames, comments, docstrings, banners, diagnostics,
  and changed verification artifacts for mathematical accuracy and referee-facing self-containment.
- [x] Confirm internal records point to exact Lean declarations while Lean and verification
  artifacts contain no reverse references, task IDs, workflow language, or unsupported novelty or
  strength claims.
- [x] State exclusions and negative boundaries explicitly, including what the task and gate do not
  prove.
- [x] Complete the judgment-call record with evidence, trust impact, rejected alternatives, and
  reopening conditions; ensure the verification map and ledger use the chosen final route.
- [ ] Record the independent reviewer's identity, date, `GO`/`NO-GO`, findings, and dispositions.
- [x] Supply C320 with one ledger row per claim and the exact verify-all entry-point delta.
