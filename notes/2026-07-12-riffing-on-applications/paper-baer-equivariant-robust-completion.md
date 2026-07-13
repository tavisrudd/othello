# Equivariant extension and robust completion of finite-geometric arcs

Status: expanded paper-development draft
Sources: `RIFF_14`, `RIFF_17`, `RIFF_74`, `RIFF_76`, `RIFF_176`, and the Baer-extension and
completion-core theorem notes
Lean lane: [`FiniteGeom/BaerCompletion/`](../../lean/FiniteGeom/BaerCompletion/)

Adversarial review:
[`baer-completion-adversarial-review.md`](baer-completion-adversarial-review.md)

## Paper decision

This is the merged version of the Baer-equivariant-extension and completion-core-rigidity projects.
The Baer orbit-extension criterion is the geometric headline. Completion distance supplies the
robustness language, the exact transversal identity, and a family of applications. The elementary
completion formalism is useful mechanism but is unlikely to carry a paper alone; the orbit-valued
Baer theorem becomes more informative when it says not only whether an arc extends, but how many
deletions are required before a prescribed extension survives.

Working title: *Equivariant extension and robust completion of finite-geometric arcs*.

## Objects and notation

Let `C` be feasible in a finite hereditary independence system. For `x ∉ C`, let `H_x(C)` be the
family of minimal subsets `A ⊆ C` for which `A ∪ {x}` is dependent. Define

```text
δ_x(C) = min{|D| : D ⊆ C and (C \ D) ∪ {x} is feasible},
δ(C)   = min_{x ∉ C} δ_x(C).
```

For a planar arc, the edges of `H_x(C)` are the occupied secant pairs through `x`. Write
`σ(x,C)` for their number. Over `PG(2,s²)`, let `φ:z↦z^s` be the Baer involution. A
`φ`-invariant arc is a disjoint union of fixed points and conjugate pairs.

## Theorem package and prose proofs

### Theorem A — completion distance is a circuit-transversal number

For every `x ∉ C`, `δ_x(C)=τ(H_x(C))`.

#### Prose proof

A deletion set `D ⊆ C` permits insertion of `x` precisely when no obstruction trace survives in
`C \ D`. An obstruction `A` survives precisely when `A ⊆ C \ D`, equivalently `A ∩ D = ∅`.
Thus insertion succeeds exactly when `D` meets every edge of `H_x(C)`. The admissible deletion sets
are exactly its transversals, and minimizing cardinality proves the identity.

#### Lean support

[`FiniteGeom/Completion.lean`](../../lean/FiniteGeom/Completion.lean) proves the abstract identity as
`completionDistance_eq_transversalNumber`, using `not_subset_sdiff_iff` and
`insertIndep_iff_transversal`. [`FiniteGeom/Hypergraph.lean`](../../lean/FiniteGeom/Hypergraph.lean)
provides the transversal infrastructure.

[`FiniteGeom/BaerCompletion/Obstruction.lean`](../../lean/FiniteGeom/BaerCompletion/Obstruction.lean)
now defines a finite hereditary `IndependenceSystem`, its complete dependent-trace hypergraph, and
proves the missing semantic bridge as `insertion_indep_iff_no_surviving_trace`. Its theorem
`insertionDistance_eq_transversalNumber` is the genuine independence-predicate version of Theorem A.

Formalization boundary: Theorem A is kernel-checked for arbitrary finite hereditary independence
systems. Specializing the generic hypergraph to projective caps and identifying its minimal edges
with geometric circuit traces remains for the cap/arc instance layer.

### Proposition A.1 — minimal obstructions are the canonical presentation

Let `Dep_x(C)` contain every dependent trace for inserting `x`, and let `Min_x(C)` contain its
inclusion-minimal members. Then

```text
τ(Dep_x(C)) = τ(Min_x(C)).
```

Consequently completion distance depends only on the minimal-obstruction clutter, even though the
raw dependent-trace hypergraph may contain exponentially many supersets.

#### Prose proof

Every transversal of `Dep_x(C)` meets its subfamily `Min_x(C)`. Conversely, take any dependent
trace `A`. Finiteness lets us choose an inclusion-minimal dependent trace `B⊆A`. A transversal of
`Min_x(C)` meets `B`, hence also meets `A`. Thus the two families have exactly the same
transversals and the same minimum transversal size.

This distinction has three consequences. Edge counts and matching numbers should be taken on the
minimal clutter, because adding dependent supersets changes both without changing resilience.
Circuit traces, secant pairs, and minimal repair groups become instances of one canonical object.
Finally, algorithms may discard every edge containing another edge before solving the transversal
problem, often shrinking the instance dramatically without changing `δ_x`.

Lean support: [`FiniteGeom/BaerCompletion/Clutter.lean`](../../lean/FiniteGeom/BaerCompletion/Clutter.lean)
proves `isTransversal_minimalEdges_iff` and `transversalNumber_minimalEdges` for arbitrary finite
hypergraphs.

### Theorem B — sharp deletion radius of a maximal completion

For a facet `C`, define `δ(C)=min_{F≠C}|C\F|`. If `D⊆C` and `|D|<δ(C)`, then `C` is the unique
facet containing `C\D`, and `core(C\D)=C`. If `F≠C` realizes `δ(C)` and `D=C\F`, then
`core(C\D)=C\D`. Thus `δ(C)-1` is the exact adversarial-deletion radius for forced completion.

#### Prose proof

If another facet `F` contains `C\D`, then `C\F⊆D`, and therefore
`δ(C)≤|C\F|≤|D|`, contradicting `|D|<δ(C)`. Hence `C` is the unique facet through `C\D`, so its
intersection-of-facets core is `C`. For sharpness, let `F` realize the minimum and put
`D=C\F`. Then `C\D=C∩F`. Both `C` and `F` contain this set, so its core lies inside their
intersection; extensivity gives the reverse inclusion. Hence `core(C\D)=C\D`.

Formalization boundary: paper-proved and targets `Core.lean`. The complementary insertion formula
and its local transversal cost are represented by Theorem A.

### Theorem C — secant resilience of a planar arc

For an arc `C` and `x ∉ C`,

```text
δ_x(C)=σ(x,C),             δ(C)=min_{x∉C} σ(x,C).
```

#### Prose proof

Every line through `x` contains at most two points of `C`. The obstruction edges for inserting `x`
are therefore the pairs cut out by its secants. Distinct lines through `x` meet only at `x`, which
is outside `C`, so these pairs are disjoint. A transversal must choose one point from every pair and
can do so independently. Its minimum size is exactly the number of pairs. Theorem A gives the first
identity; minimizing over external points gives the second.

#### Lean support

[`FiniteGeom/BaerCompletion/Secant.lean`](../../lean/FiniteGeom/BaerCompletion/Secant.lean) proves
`transversalNumber_eq_card_of_pairwise_disjoint` and the abstract secant theorem
`insertionDistance_eq_secantCount`: whenever a disjoint family of minimal secant pairs generates
all insertion obstructions, insertion distance equals its number. The distinction is deliberate:
`Obstruction.lean` stores all dependent traces, including supersets of minimal secant pairs, whereas
the secant count counts only the minimal generators.

Formalization boundary: the combinatorial content of Theorem C is kernel-checked. What remains is
no longer the projective-plane incidence step: [`RelativeConicArcs/CompletionDistance.lean`](../../lean/RelativeConicArcs/CompletionDistance.lean)
constructs the endpoint-pair secant hypergraph from Mathlib's abstract projective plane and proves
`arcInsertionDistance_eq_pointIndex` and its global minimum form
`arcGlobalInsertionDistance_eq_min_pointIndex`. Exact evaluation for each classical family remains.

### Theorem D — exact radii for classical configurations

The obstruction formula yields these standard values:

| configuration | completion distance |
|---|---:|
| nonsingular conic in `PG(2,q)`, `q` odd | `(q-1)/2` |
| hyperoval in `PG(2,q)`, `q` even | `(q+2)/2` |
| maximal degree-`d` arc | `q-q/d+1` |
| elliptic quadric in `PG(3,q)` | `q(q-1)/2` |
| ovoid of a generalized quadrangle of order `(s,t)` | `t+1` |
| spread of `PG(2n-1,q)` | `q+1` |

#### Prose proof pattern

For the planar rows, partition the configuration by lines through an external point: tangents
contribute one point, secants two, and external lines zero. Standard tangent/secant counts give the
displayed number of disjoint obstruction pairs. For quadrics, ovoids, and spreads, replace lines by
the relevant generators or incidence blocks. Their defining property makes the obstruction traces
uniform and disjoint; count them and apply Theorem A.

Formalization boundary: paper-proved from standard incidence parameters, not Lean-formalized. Each
row requires a primary citation and an incidence instance before being called machine checked.

### Theorem E — Baer secants form fixed blocks or conjugate pairs

Let `C ⊂ PG(2,s²)` be a `φ`-invariant arc and `P` a Baer-fixed point outside `C`. Every secant
through `P` is either fixed or lies in a two-element orbit `{ℓ,φ(ℓ)}`. A fixed secant meets `C` in
two fixed points or one conjugate pair; a nonfixed secant and its conjugate meet `C` in conjugate,
disjoint pairs.

#### Prose proof

Frobenius preserves incidence, so it permutes lines through fixed `P` and preserves secancy. Its
line orbits have size one or two. If a fixed line contains nonfixed `Q ∈ C`, it also contains
`φ(Q)`; hence its two arc points form a conjugate pair unless both are fixed. If `ℓ` is nonfixed and
`ℓ∩C={Q,R}`, then `φ(ℓ)∩C={φ(Q),φ(R)}`. The pairs are disjoint: a shared point would lie on both
distinct lines, hence equal their unique intersection `P`, contrary to `P∉C`.

Formalization boundary: paper-proved; target `BaerPlane.lean`.

#### Lean support

[`FiniteGeom/BaerCompletion/BaerPlane.lean`](../../lean/FiniteGeom/BaerCompletion/BaerPlane.lean)
formalizes incidence-preserving point and line involutions. It proves conjugate transport of line
traces, invariance of traces on fixed lines, the fixed-points-or-conjugate-pair classification for
invariant two-point traces, and disjointness of conjugate line traces from unique intersection at an
external point.

[`RelativeConicArcs/BaerIncidence.lean`](../../lean/RelativeConicArcs/BaerIncidence.lean) instantiates
these results in Mathlib's abstract projective-plane API: distinct conjugate lines through an
external common point have disjoint selected traces, and a fixed invariant secant has the asserted
fixed-points-or-conjugate-pair classification.

[`RelativeConicArcs/ProjectiveConjugation.lean`](../../lean/RelativeConicArcs/ProjectiveConjugation.lean)
constructs the coordinatewise semilinear projective action of every field automorphism and proves
that it preserves point-line orthogonality incidence.
[`RelativeConicArcs/QuadraticFrobenius.lean`](../../lean/RelativeConicArcs/QuadraticFrobenius.lean)
proves relative Frobenius involutive when the finite-field extension has degree two and supplies the
concrete incidence structure on `PG(2,s²)`. It also formalizes Hilbert-90 normalization, identifies
the fixed locus with the embedded `PG(2,s)`, and proves the exact `(s²-s)/2` candidate count on each
fixed line. `QuadraticLineCounting.lean` proves the exact occupied/empty fixed-line formula, and
`QuadraticForbidden.lean` constructs the forbidden-orbit charge and closes the semantic arc
extension theorem.

### Theorem F — quantitative conjugate-pair extension criterion

Let `C` be a `φ`-invariant `k`-arc. For nonfixed `P`, insertion of `{P,φ(P)}` fails only if:

1. `P` lies on a secant of `C`;
2. `φ(P)` lies on a secant of `C`; or
3. `Pφ(P)` contains a point of `C`.

Write `f=|C∩PG(2,s)|`, `e=(k-f)/2`, `I=binom(f,2)+e`, and

```text
M=(binom(k,2)-I)/2=fe+e(e-1).
```

The number of subfield lines containing no point of `C` is exactly

```text
E=s²+s+1-(f(s+1)-binom(f,2)+e).
```

The number of legal conjugate-pair extensions is at least

```text
E * ((s²-s)/2-M)_+.
```

#### Prose proof

There are `f(s+1)-binom(f,2)` subfield lines through at least one fixed selected point: inclusion-
exclusion is exact because an arc has no three fixed selected points on one line. Each conjugate
selected pair contributes its distinct mate line, and no mate line contains a fixed selected point.
Subtracting these occupied lines proves the formula for `E`.

Each empty subfield line contains `s²+1` extension-field points, of which `s+1` are fixed. Its
remaining points form `(s²-s)/2` conjugate candidate pairs. An invariant old secant meets the empty
line at a fixed point and destroys no candidate. The noninvariant old secants form `M` conjugate
line-pairs; each pair destroys at most one candidate, because its two intersections with the empty
line are conjugate. At least `((s²-s)/2-M)_+` candidates survive on each empty line. A survivor lies
on no old secant and its mate line contains no old selected point, so the three-case criterion makes
it legal. Every nonfixed conjugate pair has a unique subfield mate line, so summing over the `E`
empty lines introduces no double counting.

Formalization boundary: the complete coordinate theorem is Lean-proved, including the occupied-line
formula, exact empty-line count, nonfixed-secant orbit count, injective forbidden charge, and the
fact that a surviving candidate really preserves the arc property.

#### Lean support

[`FiniteGeom/BaerCompletion/PairExtension.lean`](../../lean/FiniteGeom/BaerCompletion/PairExtension.lean)
proves the linewise `E*(N-M)` counting theorem, the positive-surplus existence criterion, and the
exact quadratic wrapper `quadraticBaer_pairExtension_lowerBound` with
`N=(s²-s)/2`, the displayed `E`, and the noninvariant-secant-orbit `M`.
[`RelativeConicArcs/QuadraticPairExtension.lean`](../../lean/RelativeConicArcs/QuadraticPairExtension.lean)
constructs the coordinate candidates and discharges `candidate_count` automatically.
[`RelativeConicArcs/QuadraticLineCounting.lean`](../../lean/RelativeConicArcs/QuadraticLineCounting.lean)
and [`RelativeConicArcs/QuadraticForbidden.lean`](../../lean/RelativeConicArcs/QuadraticForbidden.lean)
discharge the remaining fields; the latter proves the end-to-end theorem
`exists_quadratic_pair_extension`.

### Theorem F.1 — heterogeneous pair-extension bound

The uniform count is a corollary of a sharper linewise statement. Let `𝓔` be the empty subfield
lines. For each `ℓ∈𝓔`, let `N_ℓ` be the number of conjugate candidate pairs on `ℓ` and let `M_ℓ`
be the number of those candidates destroyed by old noninvariant secant orbits. Then

```text
N_pair(C) ≥ Σ_{ℓ∈𝓔} (N_ℓ-M_ℓ)_+.
```

If the locally forbidden candidates are recorded without duplication, equality holds with the
linewise surviving-candidate count. In the quadratic Baer plane, `N_ℓ=(s²-s)/2` and `M_ℓ≤M`, so
Theorem F follows immediately.

#### Prose proof

On a fixed empty line `ℓ`, removing at most `M_ℓ` forbidden elements from `N_ℓ` candidates leaves
at least `(N_ℓ-M_ℓ)_+`. Candidate sets belonging to distinct subfield lines are disjoint because a
nonfixed conjugate pair has a unique invariant mate line. Summing the local lower bounds therefore
introduces no double counting. If each forbidden set is literally a subset of its local candidate
set, elementary set subtraction gives exactly `N_ℓ-M_ℓ` survivors on that line, proving the
equality refinement.

#### Implications

- The theorem survives nonuniform fixed loci, deleted subplanes, weighted candidate restrictions,
  and higher-degree orbit types where different invariant carriers have different capacities.
- Equality and near-equality can be studied locally: a globally weak bound must arise from many
  lines with large `M_ℓ`, rather than being hidden inside one global union bound.
- Computations should output the distribution of `M_ℓ`, not only its maximum. This gives a
  stability statistic and may expose sharper extension criteria even when the uniform theorem is
  inconclusive.
- In coding language, the same sum measures heterogeneous coordinate-orbit lengthening capacity.

Lean support: `PairExtensionData.sum_card_sub_le_legalCount` proves the heterogeneous lower bound,
and `PairExtensionData.legalCount_eq_sum_card_sub` proves the equality refinement.

### Corollary G — equivariant saturation has square-root scale

For `s≥7`, every invariant 8-arc admits an equivariant conjugate-pair extension. More generally, an
equivariantly complete invariant `k`-arc satisfies

```text
k ≥ 1 + ceil(sqrt(2s(s-1))).
```

#### Prose proof

Insert `k=8` into the exact inequality underlying Theorem F; for `s≥7`, the available nonfixed locus
strictly exceeds the bad union. In general, if no pair extension exists, the bad sets cover every
nonfixed orbit. Rearranging that quadratic covering inequality gives
`(k-1)² ≥ 2s(s-1)`, and integrality gives the display.

Novelty boundary: the asymptotic constant matches the classical Lunelli–Sce square-root scale. The
contribution is the orbit-valued criterion and equivariant packaging, not a new constant. This is
paper-proved and not yet Lean-formalized.

#### Lean support

[`RelativeConicArcs/BaerArithmetic.lean`](../../lean/RelativeConicArcs/BaerArithmetic.lean) proves
the profile identity `M=fe+e(e-1)`, the uniform eight-arc bound `M≤12`, and
`12<(s²-s)/2` for `s≥7`. It also proves the completed-square occupied-line identity and that
full occupation forces `k=s²+1+(f-s-1)²`, hence is impossible when `k<s²+1`.
[`FiniteGeom/BaerCompletion/OrbitSaturation.lean`](../../lean/FiniteGeom/BaerCompletion/OrbitSaturation.lean)
proves the denominator-free quadratic conclusion `2s(s-1)≤(k-1)²` from the pair obstruction and
split-product bounds. The ceiling/square-root presentation remains prose arithmetic.

### Theorem H — robust holes survive nonfixed perturbations

Let `P` be a Baer-fixed external point of invariant `C`, and suppose its incident obstruction pairs
have transversal number `r`. If fewer than `r` points are deleted from `C`, then `P` remains blocked.
Changes supported away from all obstruction pairs do not change this conclusion.

#### Prose proof

By Theorem E, the secant traces through `P` are fixed blocks or conjugate pairs. By Theorem A,
enabling insertion of `P` requires a transversal of those traces. A deletion set smaller than `r`
misses some obstruction, whose secant survives and continues to block `P`. Changes away from every
trace destroy none of them and cannot create a deletion transversal, so the certificate persists.

This is the bridge theorem: Baer orbit structure identifies symmetry-compatible obstruction blocks,
while completion distance measures their robustness.

#### Lean support

[`FiniteGeom/BaerCompletion/RobustHole.lean`](../../lean/FiniteGeom/BaerCompletion/RobustHole.lean)
proves that fewer than `τ` deletions leave an obstruction alive, the secant-count specialization,
and the stronger stability result that only the old obstructions need persist. The coordinate
Frobenius incidence instance has now landed; a family-specific robustness statement still needs
the chosen invariant arc and its obstruction-persistence hypotheses.

## Proposed paper spine

1. Equivariant arcs, orbit-valued extension, and completion distance.
2. Minimal-obstruction clutters and the Lean-backed identity `δ_x=τ`.
3. Secant resilience and exact classical examples.
4. Baer-fixed versus conjugate secant blocks.
5. Heterogeneous conjugate-pair extension, its uniform corollary, and saturation bounds.
6. Robust fixed holes under nonfixed perturbations.
7. Computed spectra for small invariant arcs and a sharpness search.
8. Coding interpretation through projective columns and MDS extension.

## Lean development order

1. `Obstruction.lean`: **landed** — hereditary systems, dependent traces, the semantic insertion
   equivalence, and `insertionDistance_eq_transversalNumber`.
2. `Secant.lean`: **landed** — pairwise-disjoint transversals and abstract secant resilience.
3. `BaerPlane.lean`, `ProjectiveConjugation.lean`, `QuadraticFrobenius.lean`: **landed** — abstract
   involution and trace results, coordinate semilinear incidence preservation, and the degree-two
   Frobenius instance, including fixed-locus normalization and exact fixed-line candidate counts.
4. `PairExtension.lean`: **landed end to end** — `E*(N-M)`, existence, and exact quadratic data
   wrapper; `QuadraticPairExtension.lean`, `QuadraticLineCounting.lean`, and
   `QuadraticForbidden.lean` discharge all coordinate fields and prove semantic arc extension.
5. `RobustHole.lean`: **landed** — below-`τ` survival, secant-count robustness, and preservation.
6. `Core.lean`: **landed** — completion cores and the sharp unique-completion deletion theorem.
7. `ClassicalFamilies.lean`: add exact radii as incidence APIs become available.

[`FiniteGeom/MomentCurve.lean`](../../lean/FiniteGeom/MomentCurve.lean) supplies
`momentCurve_linearIndependent` and `twistedCubic_linearIndependent`; these support an NRC/MDS
application, not the Baer counting claims. [`FiniteGeom/Code.lean`](../../lean/FiniteGeom/Code.lean)
supplies the column-code dictionary.

## Release gates

- Keep Theorem F synchronized with the checked declarations and trust manifest.
- Audit every classical-family radius against primary finite-geometry literature.
- Produce a sharp or near-sharp invariant family, or present the extension theorem as structural.
- Run targeted prior-art review on the heterogeneous criterion and robustness coupling; do not
  treat re-proved classical coordinate geometry as discovery.
- Keep enumerations as discovery/regression artifacts, never substitutes for proofs.

## Strengthenings discovered during formalization

- Replace the raw dependent-trace hypergraph by its minimal-obstruction clutter whenever edge count
  or packing structure matters; their transversal semantics agree, but their edge counts do not.
- State the heterogeneous pair-extension bound `Σℓ(N_ℓ-M_ℓ)_+`; the uniform `E(N-M)` theorem is a
  corollary.
- Formulate Baer structure for arbitrary incidence-preserving involutions of projective planes;
  finite fields enter only for the now-formalized fixed-locus and exact coordinate counts.
- Perturbation stability requires only persistence of old obstructions, not equality of complete
  obstruction hypergraphs.
- View facet separation as a directed completion distance, aligning the result with asymmetric
  codes and one-sided erasure decoding.

## Appendix A — second-order corollaries, extensions, and application queue

Status: speculative research queue; novelty claims require literature audits.
Tracking task: `C99`.

### Discovery track for final review

This appendix was revisited after the final trust audit. Do not merge the categories: **proved corollaries**, **cheap
formal extensions**, **genuine paper strengthenings**, **applications**, and **speculative
directions** must remain explicitly distinguished. Promotion into the main theorem spine requires
both a proof-status check and a novelty/prior-art check.

Current classification:

- **Classical infrastructure, formalized but not discovered here:** Hilbert-90 normalization;
  identification of the quadratic-Frobenius fixed locus with `PG(2,s)`; the counts
  `s²+s+1`, `s+1`, and `s²-s`; elementary arc line-incidence double counting; and two-element
  orbit counting for fixed-point-free involutions. These declarations support trust and reuse but
  must not be entered as novel Discovery Track results.

- **Proved strengthening:** minimal-edge reduction preserves every transversal and `τ`; the paper
  may work canonically with the minimal-obstruction clutter rather than all dependent traces.
- **Proved strengthening:** the heterogeneous linewise bound
  `Σℓ(N_ℓ-M_ℓ)_+` implies the uniform `E(N-M)` theorem and becomes exact when local forbidden sets
  are represented without duplication.
- **Proved strengthening:** robust blockage requires only persistence of old obstructions; the
  perturbed configuration may acquire arbitrary new obstructions.
- **Proved reusable corollary:** projective-plane secant resilience is not coordinate-specific:
  `δ_x` equals the secant index in every finite abstract projective plane.
- **Proved reusable corollary:** the fixed/conjugate secant decomposition requires only an
  incidence-preserving involution of a projective plane; quadratic Frobenius is one instance.
- **Proved reusable corollary:** arbitrary nonnegative deletion weights preserve the exact
  completion/transversal identity (`weightedInsertionDistance_eq_weightedTransversalCostWithin`).
- **Proved reusable corollary:** simultaneous insertion of any prescribed independent finite set
  `X` has exact obstruction-transversal distance; singleton insertion is recovered as a checked
  specialization (`multiInsertionDistance_eq_transversalNumber`,
  `multiInsertionDistance_singleton`).
- **Proved compositional corollary:** weighted deletion and simultaneous insertion commute: their
  combination is exactly weighted transversal cost, with no hypothesis beyond finite hereditary
  independence (`weightedMultiInsertionDistance_eq_weightedTransversalCostWithin`).
- **Proved proof-spine strengthening:** the three quadratic count fields are discharged in
  coordinates. Candidate count follows from a two-to-one mate-pair map, empty-line count from an
  exact occupied/empty partition, and the forbidden bound from an injective charge into nonfixed
  secant orbits (`card_emptyFixedLines`, `card_nonfixedSecantOrbits`,
  `card_forbiddenCandidates_le_baer`).
- **Proved coordinate strengthening:** coordinatewise action of any field automorphism on
  projective points and dual lines preserves incidence. For a quadratic finite-field extension,
  relative Frobenius is proved involutive from its order theorem, so the actual coordinate
  `InvolutiveIncidence` used by the Baer secant decomposition is now kernel-checked
  (`ProjectiveConjugation.involutiveIncidence`, `QuadraticFrobenius.incidence`).
- **Formalization warning / structural observation:** a fixed projective point need not have the
  currently chosen homogeneous representative fixed coordinatewise. The exact checked criterion is
  semilinear eigenvectorhood, `σ(v)=a·v` (`projectiveEquiv_mk_eq_iff`). Thus identifying the fixed
  locus with `PG(2,s)` needs a normalization/Hilbert-90 step; silently replacing projective
  fixedness by coordinatewise fixedness would be a false shortcut.
- **Proved coordinate theorem:** the Hilbert-90 normalization step is now formalized. Projectively
  fixed points of quadratic Frobenius are exactly the image of `PG(2,F)`; fixed points and fixed
  dual lines number `s²+s+1`, and every fixed line has `s+1` fixed points and `s²-s` nonfixed
  points (`projective_fixed_iff_mem_range_baseChange`, `natCard_fixedProjectivePoint`,
  `natCard_fixedPointsOnFixedLine`, `natCard_nonfixedPointsOnFixedLine`).
- **Proved coordinate theorem:** conjugation acts fixed-point-freely on the nonfixed points of a
  fixed line, every mate-pair fiber has exactly two elements, and hence each fixed line has exactly
  `(s²-s)/2` conjugate candidates (`matePair_fiber_card`,
  `card_conjugateCandidatesOnFixedLine`). The coordinate quadratic wrapper now discharges
  `candidate_count` automatically.
- **Proved coordinate theorem:** fixed two-traces are identified exactly with invariant arc pairs;
  this yields exact occupied and empty fixed-line counts. `choose_fixedArcPoints_le_star` proves
  the side condition ensuring that natural subtraction does not silently truncate.
- **Proved coordinate theorem:** nonfixed secants have exact two-element conjugation orbits. Their
  intersection with an empty fixed line gives an injective forbidden-candidate charge, and
  `mem_forbiddenCandidates_iff_exists_covered` identifies forbiddenness exactly with endpoint
  secant coverage.
- **Proved semantic closure:** `arc_union_candidate_of_not_mem_forbidden` closes the gap between an
  abstract legal-count predicate and arc geometry; `exists_quadratic_pair_extension` constructs an
  actual conjugate-pair arc extension from the paper's two inequalities.
- **Proved arithmetic corollary:** for invariant eight-arcs, `M≤12`, while every empty subfield line
  has more than twelve conjugate candidates for `s≥7`.
- **Proved arithmetic strengthening:** the completed-square identity
  `2O=(s+1)²+k-(f-s-1)²` is formalized over the integers; full subfield-line occupation forces
  `k=s²+1+(f-s-1)²`, so `k<s²+1` guarantees an empty subfield line.
- **Cheap formal extensions:** blocker duality and orbit-level costs remain undeclared; the
  previously queued weighted and multi-insertion extensions are now kernel-checked, including
  their combined form.
- **Genuine paper-strengthening candidates:** heterogeneous-bound stability, collision-corrected
  extension counts, orbit-quotient clutters, and a symmetry-premium invariant.
- **Applications:** asymmetric erasure decoding, heterogeneous storage failures, reliability
  polynomials, symmetry-reduced hitting-set algorithms, and robust defining sets.
- **Speculative directions:** higher-degree Galois orbit extension, fractional/integral completion
  gaps, tensorization, and classification of near-equivariantly-complete configurations.
- **Post-formalization question asked again:** the completed proof exposes three especially useful
  follow-ups: characterize equality in the injective charge, retain the full linewise collision
  profile rather than its maximum, and generalize the semantic forbidden-set equivalence to
  higher Galois orbits. These are candidate research directions, not established novelty claims.

Update this classification whenever proof work exposes a new theorem, removes an assumption,
reveals a false generalization, or suggests a new consumer. The detailed entries below preserve the
research queue; this ledger records their current epistemic status.

### A.1 Blocker duality for completion

For the minimal-obstruction clutter `M_x(C)`, minimum deletion certificates are minimum edges of
its blocker clutter `b(M_x(C))`. Thus minimal reasons insertion fails and minimal ways to make it
succeed form a canonical dual pair. Since blocker duality satisfies `b(b(H))=H` for clutters, all
minimal insertion obstructions can in principle be reconstructed from the minimal successful
deletion certificates. This is stronger than the scalar identity `δ_x=τ` and suggests a dual
certificate theory for completion.

### A.2 Weighted completion distance

Assign a deletion cost `w(v)` and minimize `Σ_{v∈D}w(v)` over deletions enabling `x`. The proof of
Theorem A becomes a weighted-transversal theorem, kernel-checked as
`weightedInsertionDistance_eq_weightedTransversalCostWithin`. It also composes with prescribed-set
insertion in `weightedMultiInsertionDistance_eq_weightedTransversalCostWithin`. Applications include unequal code
puncturing costs, protected coordinates, geometric orbit costs, heterogeneous storage nodes, and
correlated administrative or hardware failure domains.

### A.3 Orbit-quotient obstruction clutters

For a group `G` preserving `C` and `x`, quotient the minimal-obstruction clutter by vertex orbits.
Equivariant deletion selects whole orbits, so equivariant completion distance becomes a weighted
transversal problem on the quotient. This unifies fixed-point extension, conjugate-pair extension,
higher Galois-degree orbits, symmetry-constrained puncturing, and rack/region correlated failures.

### A.4 The symmetry premium

Define

```text
premium_G(x,C)=δ_x^G(C)/δ_x(C),
```

where the numerator permits only `G`-invariant deletions. A large premium identifies configurations
that are ordinarily fragile but equivariantly rigid. This is a plausible new invariant for finite
geometry, symmetric designs, and symmetric code constructions.

### A.5 Fractional completion distance

Define `δ_x^*(C)=τ^*(M_x(C))`. The gap `δ_x/δ_x^*` measures how much resilience comes from
integrality rather than obstruction mass. Disjoint secants have gap one; higher-rank circuit
clutters may not. This creates LP bounds, approximation algorithms, asymptotic comparison tools,
and an extremal problem for geometric integrality gaps.

### A.6 The local-to-global resilience spectrum

Retain the multiset

```text
Specδ(C)={δ_x(C):x∉C}
```

rather than only its minimum. For invariant configurations, refine it by external-point orbit. The
spectrum can distinguish configurations with identical size, completeness, and worst-case radius,
and should connect to secant distributions, syndrome/coset-leader distributions, orbitwise
lengthening capacity, and random-deletion robustness.

### A.7 Reliability polynomials

Under independent point survival or deletion, the probability that `x` remains blocked is the
reliability polynomial of its obstruction clutter. For `σ` disjoint secant pairs the probability
has a closed product form. General clutters introduce overlap corrections. This extends the paper
from deterministic adversarial resilience to stochastic robustness and may yield exact formulas for
classical families.

### A.8 Stability from the heterogeneous bound

If an invariant arc has few legal pair extensions, then most empty subfield lines must have local
obstruction count `M_ℓ` close to capacity `N_ℓ`. This is an inverse statement: near-saturation forces
noninvariant secants to distribute broadly across the empty-line locus. A stability theorem could
classify near-equivariantly-complete arcs or force approximation by a small set of structured
families. This is one of the strongest novelty candidates in the appendix.

### A.9 Second-moment collision corrections

The first-order bound subtracts one for every old secant orbit that may destroy a candidate. When
several old orbits destroy the same candidate, the true loss is smaller. Recording pairwise and
higher collisions yields inclusion–exclusion or second-moment corrections. This is the most direct
route to improving the extension threshold or proving stability at the existing square-root scale.

### A.10 Higher-degree Galois orbit extension

For extension degree `d>2`, candidate additions are full Galois orbits and their carrier geometry is
controlled by Galois rank rather than a mate line. The obstruction object should encode old flats
meeting candidate orbits improperly. The quadratic theorem is then the rank-two case of an
orbit-extension theorem parameterized by forbidden-flat rank-weight enumerators.

### A.11 Completion distance as asymmetric code distance

For facets define `d→(C,F)=|C\F|`. Then `δ(C)=min_{F≠C}d→(C,F)`. This is a directed one-sided
erasure metric, not generally a symmetric distance. Completion cores become forced-symbol closures;
defining sets become asymmetric information sets; weighted deletion becomes a weighted asymmetric
channel; and the facet family acquires a directed nearest-neighbor graph.

### A.12 Tensorization and composition

Determine how insertion spectra behave under direct sums, products, field reduction, concatenation,
and other compositions of independence systems. The expected operations include minima for
component-local insertions and sums or convolutions for coupled insertions. A clean tensorization
theorem would make completion spectra compositional and support modular code and reliability
calculations.

### A.13 Fixed-parameter and symmetry-reduced algorithms

Completion distance is hitting set in general, but geometric obstruction clutters have bounded
rank and large automorphism groups. Candidate consequences include FPT algorithms parameterized by
`δ_x`, kernelization by clutter minimization and twin/orbit quotienting, exact branching for
rank-two secant clutters, symmetry-reduced ILPs, and small Lean-checkable transversal certificates.

### A.14 Robust defining-set hierarchy

Call a defining subset `r`-robust if it continues to force the same facet after any further `r`
deletions. This interpolates between ordinary defining sets and error-correcting identification.
Natural test families include conics, normal rational curves, spreads, designs, and matroid bases.

### A.15 Multi-insertion and orbit insertion

For a prescribed feasible set or orbit `X`, let the minimal obstructions be traces `A⊆C` for which
`A∪X` is dependent. The kernel-checked multi-insertion theorem gives

```text
δ_X(C)=τ(M_X(C)).
```

This unifies single-point completion, conjugate-pair extension, full Galois-orbit extension, and
multi-coordinate code lengthening. The declarations
`multiObstructionHypergraph_singleton` and `multiInsertionDistance_singleton` verify that it is a
strict generalization of the original presentation rather than a parallel definition. Combining
it with deletion weights is also proved, which is a small but useful compositional surprise exposed
by the formalization.

### A.16 Ranked follow-up

The strongest current novelty bets are:

1. heterogeneous-bound stability and inverse theorems;
2. orbit-quotient clutters and the symmetry premium;
3. blocker duality and canonical dual certificates;
4. fractional/integral gaps for geometric circuit clutters;
5. collision corrections capable of improving the orbit-extension threshold.

Task `C99` is now unblocked by the completed formalization. Its next action is a targeted novelty
check and theorem-level development of the best two post-formalization candidates, using the
completed declaration graph and adversarial findings rather than treating this queue as evidence
of novelty.
