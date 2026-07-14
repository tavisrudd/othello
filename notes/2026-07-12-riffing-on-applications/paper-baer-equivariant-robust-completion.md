# Equivariant extension and robust completion of finite-geometric arcs

Status: major-revision paper-development draft; the Q25 theorem is checked, but release gates remain
Sources: `RIFF_14`, `RIFF_17`, `RIFF_74`, `RIFF_76`, `RIFF_176`, and the Baer-extension and
completion-core theorem notes
Lean lane: [`FiniteGeom/BaerCompletion/`](../../lean/FiniteGeom/BaerCompletion/)

Adversarial reviews:
[`baer-completion-adversarial-review.md`](baer-completion-adversarial-review.md) audits proof
validity; [`2026-07-13-baer-completion-adversarial-novelty-review.md`](../2026-07-13-baer-completion-adversarial-novelty-review.md)
audits every theorem and Appendix A novelty claim.

## Scope decision still required

The Baer orbit-extension criterion and its uniform `PG(2,25)` theorem are the geometric headline.
This development draft also contains the completion-core material, but the present robustness
theorem is a generic obstruction-persistence companion rather than a family-specific bridge to the
Q25 conjugate-pair theorem. Before submission, either focus the paper on the Baer/Q25 theorem or add
a genuine theorem evaluating deletion robustness or multi-insertion for the same invariant-arc
family. The current draft does not claim that bridge has already been proved.

Working title: *Equivariant extension and robust completion of finite-geometric arcs*.

## Objects and notation

Let `C` be feasible in a finite hereditary independence system. For `x ∉ C` such that the singleton
`{x}` is feasible, let `H_x(C)` be the family of minimal subsets `A ⊆ C` for which `A ∪ {x}` is
dependent. Define

```text
δ_x(C) = min{|D| : D ⊆ C and (C \ D) ∪ {x} is feasible},
δ(C)   = min_{x ∉ C, {x} feasible} δ_x(C),
```

whenever the indexing set in the second minimum is nonempty. The singleton hypothesis excludes
loops: without it, no deletion need make insertion possible and the natural-valued minimum used
here is not the appropriate convention.

For a planar arc, the edges of `H_x(C)` are the occupied secant pairs through `x`. Write
`σ(x,C)` for their number. Over `PG(2,s²)`, let `φ:z↦z^s` be the Baer involution. A
`φ`-invariant arc is a disjoint union of fixed points and conjugate pairs.

## Theorem package and prose proofs

### Theorem A — completion distance is a circuit-transversal number

For every `x ∉ C` with feasible singleton `{x}`, `δ_x(C)=τ(H_x(C))`.

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
systems under the displayed singleton-feasibility hypothesis. `Obstruction.lean` uses all dependent
traces, and Proposition A.1 justifies passage to their minimal members. The projective-plane arc
instance is checked in `RelativeConicArcs/CompletionDistance.lean`; exact evaluation for particular
classical families is separate.

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

Let the supplied finite facet family be Sperner, let `C` be one of its facets, and assume it has at
least one alternative facet. Define the facet-separation radius
`ρ(C)=min_{F≠C}|C\F|`. If `D⊆C` and `|D|<ρ(C)`, then `C` is the unique facet containing `C\D`, and
`core(C\D)=C`. If `F≠C` realizes `ρ(C)` and `D=C\F`, then `core(C\D)=C\D`. Thus `ρ(C)-1` is the
exact adversarial-deletion radius for forced completion. The notation distinguishes this supplied-
facet quantity from the insertion minimum `δ(C)` above; identifying them requires the family to
contain all facets of the underlying independence system.

#### Prose proof

If another facet `F` contains `C\D`, then `C\F⊆D`, and therefore
`ρ(C)≤|C\F|≤|D|`, contradicting `|D|<ρ(C)`. Hence `C` is the unique facet through `C\D`, so its
intersection-of-facets core is `C`. For sharpness, let `F` realize the minimum and put
`D=C\F`. Then `C\D=C∩F`. Both `C` and `F` contain this set, so its core lies inside their
intersection; extensivity gives the reverse inclusion. Hence `core(C\D)=C\D`.

Formalization boundary: the checked theorem is conditional on the supplied finite facet family and
an explicit alternative-facet witness. It does not manufacture an alternative facet or define a
minimum over an empty family. The complementary insertion formula and its local transversal cost
are represented by Theorem A.

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

Novelty boundary: this is a formally verified optimization-language packaging of a classical
secant-deletion maneuver. Alderson explicitly deletes one endpoint from each secant through a
proposed extension point before adjoining it; point index and bisecant multiplicity are standard
finite-geometry parameters. See [*Extending Arcs: An Elementary Proof*](https://doi.org/10.37236/1973).

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

### Provisional Table D — classical completion-radius translations

The obstruction formula is expected to yield the following standard values. This table is not part
of the verified theorem package: each row needs a primary finite-geometry citation, an explicit
hereditary system, and its incidence-count proof before publication.

| configuration | completion distance |
|---|---:|
| nonsingular conic in `PG(2,q)`, `q` odd | `(q-1)/2` |
| hyperoval in `PG(2,q)`, `q` even | `(q+2)/2` |
| maximal degree-`d` arc | `q-q/d+1` |
| elliptic quadric in `PG(3,q)` | `q(q-1)/2` |
| ovoid of a generalized quadrangle of order `(s,t)` | `t+1` |
| line spread of `PG(3,q)` | `q+1` |

#### Prose proof pattern

For the planar rows, partition the configuration by lines through an external point: tangents
contribute one point, secants two, and external lines zero. Standard tangent/secant counts give the
displayed number of disjoint obstruction pairs. For quadrics, ovoids, and spreads, replace lines by
the relevant generators or incidence blocks. Their defining property makes the obstruction traces
uniform and disjoint; count them and apply Theorem A.

The odd-conic row is the global minimum: external and internal off-conic point classes have
`(q-1)/2` and `(q+1)/2` secants respectively. The spread row is deliberately restricted to line
spreads of `PG(3,q)`. An `(n-1)`-spread in `PG(2n-1,q)` induces a subspace partition on a candidate
`(n-1)`-space, whose number of nontrivial parts is not generally `q+1`; a higher-dimensional row
requires the induced-partition parameter and additional hypotheses. See
[Heden et al., *Extremal sizes of subspace partitions*](https://arxiv.org/abs/1104.2706).

Formalization boundary: neither the family-specific incidence hypotheses nor these six evaluations
are Lean-formalized. Until the required primary citations and proofs are supplied, the table is a
release checklist rather than a theorem.

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

Formalization boundary: the abstract involution statements and their projective-plane incidence
instances are Lean-checked; the coordinate quadratic-Frobenius specialization is supplied by the
modules listed below.

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

Let `C` be a `φ`-invariant `k`-arc. For nonfixed `P`, insertion of `{P,φ(P)}` fails if and only if at
least one of the following holds:

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

The three-case conjugate-pair test is an elementary collinear-triple classification, and an
adjacent addition maneuver appears in Baker–Wantz,
[*An arc partition of the Hughes plane*](https://msp.org/iig/2005/2-1/iig-v2-n1-p04-p.pdf).
The paper-specific contribution claimed here is the assembled exact empty-carrier count and
quantitative quadratic-Frobenius orbit-extension bound, not invention of conjugate-pair addition.

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

Formalization boundary: the coordinate existence theorem is Lean-proved, including the occupied-
line formula, exact empty-line count, nonfixed-secant orbit count, injective forbidden charge, and
the fact that a surviving candidate preserves the arc property. `QuadraticGlobalCount.lean` defines
the semantic global finset of fresh Frobenius pairs whose union remains an arc, proves that every
such pair has a unique empty mate line, and proves its cardinality equal to
`PairExtensionData.legalCount`. The three-case classification remains prose motivation, while the
checked candidate semantics and global-count equivalence supply the theorem's quantitative content.

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
[`RelativeConicArcs/QuadraticGlobalCount.lean`](../../lean/RelativeConicArcs/QuadraticGlobalCount.lean)
proves `globalLegalPairs_eq_carrierwiseLegalPairs` and
`card_globalLegalPairs_eq_legalCount`.

### Theorem F.1 — heterogeneous pair-extension bound

The uniform count is a corollary of a sharper linewise statement. Let `𝓔` be the empty subfield
lines. For each `ℓ∈𝓔`, let `N_ℓ` be the number of conjugate candidate pairs on `ℓ`, let `F_ℓ` be the
set of distinct forbidden candidates on `ℓ`, and write `f_ℓ=|F_ℓ|`. Then

```text
N_pair(C) = Σ_{ℓ∈𝓔} (N_ℓ-f_ℓ).
```

More generally, if only upper bounds `f_ℓ≤U_ℓ` are available, then

```text
N_pair(C) ≥ Σ_{ℓ∈𝓔} (N_ℓ-U_ℓ)_+.
```

In the quadratic Baer plane, `N_ℓ=(s²-s)/2` and `f_ℓ≤M`, so Theorem F follows immediately. The
notation deliberately separates distinct forbidden support `f_ℓ` from secant-orbit charges counted
with multiplicity.

#### Prose proof

On a fixed empty line `ℓ`, removing the forbidden subset `F_ℓ` from `N_ℓ` candidates leaves exactly
`N_ℓ-f_ℓ`. Candidate sets belonging to distinct subfield lines are disjoint because a
nonfixed conjugate pair has a unique invariant mate line. Summing the local lower bounds therefore
introduces no double counting. Replacing each exact `f_ℓ` by an upper bound `U_ℓ` gives the stated
heterogeneous lower bound.

#### Exact linewise correction to the uniform charge bound

For a candidate orbit `q={p,φ(p)}⊂ℓ`, let `μ_ℓ(q)` be the number of old secants through `p`. Let
`A_ℓ=Σ_q μ_ℓ(q)` be the visible charge mass, and let `B_ℓ` count nonfixed secant orbits
`{m,φ(m)}` whose fixed center `m∩φ(m)` lies on `ℓ`. Such an orbit meets `ℓ` only at its fixed center
and destroys no nonfixed candidate; every other nonfixed secant orbit charges one candidate.
Consequently, with the displayed subtraction interpreted over the integers,

```text
A_ℓ = M-B_ℓ,
f_ℓ = A_ℓ-Σ_q(μ_ℓ(q)-1)_+,
N_ℓ-f_ℓ = N_ℓ-M+B_ℓ+Σ_q(μ_ℓ(q)-1)_+.
```

Thus correction to the integer first-order expression `N_ℓ-M` has two sources: invisible
centered-on-`ℓ` secant orbits (`B_ℓ`) and genuine charge collisions
(`Σ_q(μ_ℓ(q)-1)_+`). The checked statement uses the subtraction-free form

```text
legal(ℓ)+M=N_ℓ+B_ℓ+Σ_q(μ_ℓ(q)-1)_+,
```

and an aggregate identity over all empty carriers. Equality in the first-order identity
`legal(ℓ)+M=N_ℓ` holds exactly when both correction terms vanish. This is not an equality criterion
for the truncated lower bound `(N_ℓ-M)_+`: when `M>N_ℓ`, that bound is zero and can be attained with
nonzero correction. A raw second moment does not by itself control the forbidden support in the
needed direction; the order-five application below also uses the maximum fiber size `μ≤4` and a
geometric partition of the global second moment.

#### Aggregate equality and excess classification

Suppose every empty carrier has the same candidate count `N`. Let `E` be the number of empty
carriers, `L` the aggregate legal count, `B=Σ_ℓB_ℓ`, and
`R=Σ_ℓΣ_q(μ_ℓ(q)-1)_+`. Then the exact balance is

```text
L+EM=EN+B+R.
```

Consequently `L+EM=EN` holds exactly when every obstruction orbit is visible on every carrier and
each visible orbit-to-candidate charge is injective. In the quadratic geometry, this says that every
secant-orbit center avoids every empty fixed carrier and the visible charge is collision-free. More
generally,

```text
L+EM=EN+k  if and only if  B+R=k.
```

This is an exact algebraic equality/excess classification. It is not a structural inverse theorem
classifying invariant arcs with small legal count.

#### Implications

- The theorem survives nonuniform fixed loci, deleted subplanes, weighted candidate restrictions,
  and higher-degree orbit types where different invariant carriers have different capacities.
- First-order equality and excess are classified locally through `(f_ℓ,A_ℓ,B_ℓ)` and the
  multiplicity profile `μ_ℓ`, rather than a single global union bound.
- Computations should output these profiles, not only the global maximum `M`. This may expose
  sharper extension criteria even when the uniform theorem is inconclusive.
- In coding language, the same sum measures heterogeneous coordinate-orbit lengthening capacity.

Lean support: `PairExtensionData.sum_card_sub_le_legalCount` uses the cardinality of the actual
forbidden finset, and `PairExtensionData.legalCount_eq_sum_card_sub` proves exact set subtraction
when that finset is contained in the candidate set.
[`FiniteGeom/BaerCompletion/CollisionProfile.lean`](../../lean/FiniteGeom/BaerCompletion/CollisionProfile.lean)
proves the abstract support, invisible-mass, and collision-redundancy identities, including their
aggregate form, the equality/excess classification, and capped-multiplicity moment inequalities.
[`RelativeConicArcs/QuadraticCollision.lean`](../../lean/RelativeConicArcs/QuadraticCollision.lean)
identifies the visible charge support with `forbiddenCandidates`, instantiates both exact balances,
and proves that sufficient aggregate invisible capacity produces a genuine arc extension. The
geometric identification of invisible classes with fixed centers on a carrier is also checked in
`QuadraticInvisible.lean`. The final quadratic declarations are
`aggregate_firstOrder_equality_iff_centers_avoid_carriers_and_collisionFree` and
`aggregate_firstOrder_excess_eq_iff_centerIncidence_add_redundancy_eq`. That file also proves the
generic cross-pair bound: its two endpoint
orbits have distinct mate lines missing the fixed center, and occupied center-lines inject into
the `f` fixed selected points plus the remaining `e-2` conjugate selected-point orbits.
`Q25ProfileZero.lean` checks the endpoint-index bridge and the
order-five `f=0` moment partition, and `Q25AllProfiles.lean` packages the exhaustive uniform result.

### Theorem F.2 — profile-sensitive order-five extension

If `C` is a Frobenius-invariant eight-arc in `PG(2,25)` and its fixed-point count `f` is not two,
then `C` admits a conjugate-pair extension. The checked lower bounds are five for `f=0` and four for
`f=4`; the profiles `f=6,8` already follow from Theorem F. Both exceptional
bounds and semantic extensions are kernel-checked, and `Q25AllProfiles.pair_extension` proves the
uniform statement (together with Theorem F.3 for `f=2`).

A bounded priority search found no exact precursor for the uniform statement. The exhaustive
complete-arc classifications of Marcugini–Milani–Pambianco and Coolsaet–Sticker prove only that an
eight-arc in `PG(2,25)` has an ordinary one-point extension, because the smallest complete arcs
have size 12; they do not force a legal Frobenius-conjugate pair. Baker–Wantz provides genuine
precedence for Frobenius-invariant arc language and for considering a point with its conjugate in
a Hughes-plane maximality argument, but not this universal pair-extension conclusion. MDS
lengthening sources likewise omit the Galois-pair constraint. The defensible priority wording is
therefore “no exact precursor located in a bounded search,” not a historical first claim. See the
[C134 comparison](../2026-07-13-baer-completion-adversarial-novelty-review.md#c134-bounded-priority-search--uniform-pg225-theorem).

#### Proof

Write `f+2e=8`. For every secant orbit joining two distinct conjugate selected pairs, its fixed
center lies on neither participating mate line. At most `f` fixed-point star lines and `e-2` other
mate lines through that center are occupied. Thus each of the `e(e-1)` cross-pair secant orbits is
invisible on at least `s+3-f-e` empty carriers.

For `(f,e)=(4,2)`, one has `N=M=10` and `E=11`; the two cross-pair orbits are invisible on at least
two carriers each. Hence `B≥4`, and the aggregate exact balance gives `L=B+R≥4`. This argument,
including construction of the two distinct cross-pair orbits, the occupied-line bound at their
centers, and the resulting fresh arc extension, is kernel-checked by
`Q25ProfileFour.profile_four_pair_extension` without generated certificates.

For `(f,e)=(0,4)`, one has `N=10`, `M=12`, `E=27`, and `B≥48`. The global second secant moment is
`3·binom(8,4)=210`. At fixed external points, the first secant-index sum is `48`; since the index
is at most four and `2·binom(n,2)≤3n`, their second-moment contribution is at most `72`. The four
occupied carriers are exactly the mate secants. If `r_x` is the number of nonfixed secants through
an external nonfixed point on one of them, then the full index is `1+r_x≤4`. Every one of the 24
nonfixed secants has external nonfixed intersection with at most the two mate lines not containing
its endpoints, so `Σr_x≤48`. The inequality `binom(1+r,2)≤2r` for `r≤3` bounds this occupied
contribution by `96`.

The empty-carrier endpoint moment is therefore at least `42`. Conjugate endpoints contribute
equally, so `T=Σ_q binom(μ(q),2)≥21`. Since `μ≤4`,
`binom(μ,2)≤2(μ-1)` on nonzero fibers, whence `R≥11`. The aggregate balance yields
`L≥27(10-12)+48+11=5`.

The remaining profile `(f,e)=(2,3)` has `E=17`, `M=12`, and the center argument gives `B≥18`, but
the balance still needs `R≥17`. Ten of its occupied fixed lines have one-point trace, so the
four-mate-line moment estimate from the `f=0` case does not apply. This analytic route therefore
does not close that profile; Theorem F.3 supplies a separate finite, kernel-checked proof, while the
stronger census and minimum remain external data in F.4.

Formalization and novelty boundary: the exact accounting, capped arithmetic, center-incidence,
the generic `s+3-f-e` cross-pair bound, and moment-partition geometry above are Lean-proved. A
targeted search found adjacent Baer-involution, arc-completeness, and
conjugate-addition literature, but no exact profile-sensitive statement; this is a priority-search
result, not a claim of definitive historical novelty. The detailed proof and claim ledger are in
[`2026-07-13-c99-baer-collision-strengthening.md`](../2026-07-13-c99-baer-collision-strengthening.md).

### Theorem F.3 — the exceptional order-five profile extends

Every Frobenius-invariant eight-arc in `PG(2,25)` with profile `(f,e)=(2,3)` admits a
conjugate-pair extension.

#### Lean proof spine

Lean uses the concrete field `GF(5)[ω]/(ω²-2)` and proves that it is a degree-two extension. It
identifies all 651 canonical projective coordinates and all 310 nonfixed conjugate pairs. A
base-field projectivity normalizes the two fixed selected points. Their stabilizer then sends any
first admissible conjugate pair `[1:a+bω:c+dω]`, with `b,d≠0`, to
`[1:ω:ω],[1:-ω:-ω]`. Both transformations are proved to commute with Frobenius and to preserve
the cap and pair-extension predicates.

After those reductions,
`RelativeConicArcs.Q25PairCertificate.first_slice_005`, in module `Q25PairData.L_005`, checks the
remaining finite slice by kernel reduction of freshness and determinant conditions.
`Q25OrbitDecomposition` proves that an
arbitrary invariant eight-set with two fixed points consists of exactly three nonfixed orbits;
`Q25PairResult.f2_pair_extension` composes coverage, transports the checked survivor back, and
returns a nonfixed projective point, states explicitly that both it and its conjugate are outside
the old arc, and proves that adjoining the pair preserves the arc property. The reflected slice has
46,056 exhaustive rows: 39,012 carry checked non-arc witnesses and 7,044 carry checked legal-pair
witnesses. These are composed through 1,639 leaf modules and 303 row aggregates. Every finite leaf
uses kernel `decide`; the theorem does not assume the external census or its minimum. A second
adversarial proof audit found no proof-validity defect, and both public theorem axiom profiles are
exactly `[propext, Classical.choice, Quot.sound]`.

### Computed datum F.4 — census and minimum for the exceptional profile

External enumeration after fixed-point normalization reports `469600` invariant eight-arcs with
profile `(f,e)=(2,3)` and observed minimum `32`. The census size and minimum are computed data, not
theorems. The weaker universal existence conclusion is Theorem F.3 and is Lean-proved independently.

Two implementations agree on the census, minimum, minimizing orbit indices, and coordinate
witness. The C++ enumerator uses explicit point/line incidence and point marking; an independently
written Python verifier uses candidate bitsets. A subfield projectivity commutes with Frobenius and
preserves the legal-pair count, so normalizing the ordered fixed-point pair is exhaustive.

The data suggest that the `s≥7` theorem may extend to every finite-field order `s≥5`, but no such
theorem is claimed. Sources, hashes, the minimizing witness, and the formalization gap are in the
linked C99 proof ledger.

### Corollary G — equivariant saturation has square-root scale

For `s≥7`, every invariant 8-arc admits an equivariant conjugate-pair extension. More generally, an
equivariantly complete invariant `k`-arc satisfies

```text
k ≥ 1 + ceil(sqrt(2s(s-1))).
```

#### Prose proof

For `k=8`, Lean gives `M≤12<(s²-s)/2` when `s≥7`. There must be an empty fixed carrier: otherwise
the completed-square occupation identity would force `k≥s²+1>8`. Theorem F therefore supplies a
legal pair.

For the general bound, split into two cases. If every fixed carrier is occupied, the same identity
gives `k=s²+1+(f-s-1)²`, which already implies the displayed lower bound. Otherwise choose an empty
carrier. If no pair extension exists, all `N=s(s-1)/2` candidates on it are forbidden, so `N≤M`.
Writing `k=f+2e` gives `M=e((k-1)-e)`, and
`4M≤(k-1)²`. Hence `2s(s-1)≤(k-1)²`; integrality gives the display.

Novelty boundary: the asymptotic constant matches the classical Lunelli–Sce square-root scale. The
same line-covering scale is adjacent to Ng–Wild,
[*On k-Arcs Covering a Line*](https://combinatorialpress.com/article/ars/Volume%20058/volume-58-paper-27.pdf).
The possible contribution is obtaining the bound under the weaker no-conjugate-pair-extension
hypothesis, not a new constant or saturation paradigm. Its conceptual weight depends on separating
pair-saturation from ordinary completeness. The eight-arc `s≥7` instance appears plausibly
unrecorded but remains an elementary corollary. The ceiling presentation is paper-proved and not
yet Lean-formalized.

#### Lean support

[`RelativeConicArcs/BaerArithmetic.lean`](../../lean/RelativeConicArcs/BaerArithmetic.lean) proves
the profile identity `M=fe+e(e-1)`, the uniform eight-arc bound `M≤12`, and
`12<(s²-s)/2` for `s≥7`. It also proves the completed-square occupied-line identity and that
full occupation forces `k=s²+1+(f-s-1)²`, hence is impossible when `k<s²+1`.
[`FiniteGeom/BaerCompletion/OrbitSaturation.lean`](../../lean/FiniteGeom/BaerCompletion/OrbitSaturation.lean)
proves the denominator-free quadratic conclusion `2s(s-1)≤(k-1)²` from the pair obstruction and
split-product bounds. There is not yet one Lean declaration deriving the pair-obstruction premise
from geometric equivariant completeness; the case split above and the ceiling/square-root
presentation remain prose.

### Theorem H — generic robust holes survive nonfixed perturbations

Let `P` be a Baer-fixed external point of invariant `C`, and suppose its incident obstruction pairs
have transversal number `r`. If fewer than `r` points are deleted from `C`, then `P` remains blocked.
Changes supported away from all obstruction pairs do not change this lower-bound conclusion.

#### Prose proof

By Theorem E, the secant traces through `P` are fixed blocks or conjugate pairs. By Theorem A,
enabling insertion of `P` requires a transversal of those traces. A deletion set smaller than `r`
misses some obstruction, whose secant survives and continues to block `P`. Changes away from every
trace destroy none of them and cannot create a deletion transversal, so the certificate persists.

This is a generic robustness companion: Baer orbit structure identifies symmetry-compatible
obstruction blocks, while the standard transversal certificate measures their persistence.
Persistence of old obstructions preserves this noninsertability lower bound; it need not preserve
exact completion distance or characterize all successful deletion sets. In particular, this theorem
does not yet evaluate robustness for the Q25 arcs or connect deletion distance to the conjugate-pair
extension count.

#### Lean support

[`FiniteGeom/BaerCompletion/RobustHole.lean`](../../lean/FiniteGeom/BaerCompletion/RobustHole.lean)
proves that fewer than `τ` deletions leave an obstruction alive, the secant-count specialization,
and the stronger stability result that only the old obstructions need persist. The coordinate
Frobenius incidence instance has now landed; a family-specific robustness statement still needs
the chosen invariant arc and its obstruction-persistence hypotheses.

## Scope alternatives

The focused route requires no new bridge theorem: retain the minimum obstruction language needed for
the proof, then center the manuscript on the quadratic-Frobenius criterion, the exact collision
balance and equality/excess classification, the uniform `PG(2,25)` theorem, and the bounded priority
boundary. Keep the census explicitly computational.

The merged route may retain the broader completion-core and robustness package only after a
family-specific theorem couples deletion or prescribed-orbit insertion to the same Baer/Q25 arcs.
Theorem H alone does not meet that gate. The provisional classical-radius table and broad application
queue should not drive the scope until their citations and hypotheses are complete.

## Lean formalization inventory

1. `Obstruction.lean`: **landed** — hereditary systems, dependent traces, the semantic insertion
   equivalence, and `insertionDistance_eq_transversalNumber`.
2. `Secant.lean`: **landed** — pairwise-disjoint transversals and abstract secant resilience.
3. `BaerPlane.lean`, `ProjectiveConjugation.lean`, `QuadraticFrobenius.lean`: **landed** — abstract
   involution and trace results, coordinate semilinear incidence preservation, and the degree-two
   Frobenius instance, including fixed-locus normalization and exact fixed-line candidate counts.
4. `PairExtension.lean`: **landed end to end** — `E*(N-M)` and the exact quadratic data wrapper;
   `QuadraticPairExtension.lean`, `QuadraticLineCounting.lean`, and `QuadraticForbidden.lean`
   discharge all coordinate fields and prove semantic arc extension; `QuadraticGlobalCount.lean`
   identifies the semantic global finset and its cardinality with `legalCount`.
5. `RobustHole.lean`: **landed** — below-`τ` survival, secant-count robustness, and preservation.
6. `Core.lean`: **landed** — completion cores and the sharp unique-completion deletion theorem.
7. `ClassicalFamilies.lean`: add exact radii as incidence APIs become available.

[`FiniteGeom/MomentCurve.lean`](../../lean/FiniteGeom/MomentCurve.lean) supplies
`momentCurve_linearIndependent` and `twistedCubic_linearIndependent`; these support an NRC/MDS
application, not the Baer counting claims. [`FiniteGeom/Code.lean`](../../lean/FiniteGeom/Code.lean)
supplies the column-code dictionary.

## Release gates

- Choose the focused Baer/Q25 paper or land the family-specific theorem required by the merged route.
- Keep Theorem F and F.1 synchronized with the checked declarations and trust manifest, including
  the C136 semantic global-cardinality theorem.
- Audit every classical-family radius against primary finite-geometry literature and state its exact
  hereditary system; otherwise remove Provisional Table D from the submission.
- Produce a sharp or near-sharp invariant family, or pitch the extension theorem as a structural
  criterion without a sharpness claim.
- Use the completed
  [adversarial novelty review](../2026-07-13-baer-completion-adversarial-novelty-review.md) as the
  claim boundary. A database-level specialist search for the exact quadratic-Frobenius formula
  remains before any priority claim.
- Keep enumerations as discovery/regression artifacts, never substitutes for proofs.
- Replace development scaffolding with an abstract, bibliography, stable theorem numbering, and a
  submission-format manuscript.

## Proof consequences and formalization outcomes

- Replace the raw dependent-trace hypergraph by its minimal-obstruction clutter whenever edge count
  or packing structure matters; their transversal semantics agree, but their edge counts do not.
- State the exact distinct-support identity and its heterogeneous upper-bound form; the uniform
  `E(N-M)` theorem is a corollary.
- Formulate Baer structure for arbitrary incidence-preserving involutions of projective planes;
  finite fields enter only for the now-formalized fixed-locus and exact coordinate counts.
- Perturbation stability requires only persistence of old obstructions, not equality of complete
  obstruction hypergraphs.
- View facet separation through the standard directional set-difference/Z-channel quantity,
  aligning the result with asymmetric codes and one-sided erasure decoding.

## Appendix A — second-order corollaries, extensions, and application queue

Status: broad adversarial novelty audit complete; concrete follow-up theorems still require
targeted priority checks.
Completed tracking task: `C99`; no follow-up task is allocated here.

### Discovery track for final review

This appendix was revisited after the final trust and novelty audits. Do not merge the categories:
**classical formalized infrastructure**, **paper-specific proved assembly**, **applications of
established frameworks**, and **open paper strengthenings** must remain explicitly distinguished.
Promotion into the main theorem spine requires both a proof-status check and a targeted
novelty/prior-art check.

Current classification:

- **Classical combinatorial infrastructure, now formalized:** completion/correction distance as a
  transversal number; minimal-edge clutter reduction; weighted transversals; prescribed-set and
  weighted prescribed-set insertion; disjoint-edge evaluation; blocker duality; fractional
  transversals; orbit aggregation; and persistence of an old obstruction certificate. These are
  reusable checked interfaces, not Discovery Track claims.
- **Classical finite-geometry and coordinate infrastructure, now formalized:** point index as the
  secant count; fixed/two-element orbit decomposition; Hilbert-90 normalization; identification of
  the quadratic-Frobenius fixed locus with `PG(2,s)`; standard projective counts; elementary arc
  line-incidence double counting; and free two-orbit counting. Formalization establishes trust and
  reuse, not historical novelty.
- **Paper-specific proved assembly:** the exact empty-fixed-line formula, exact nonfixed-secant
  orbit count, injective forbidden-candidate charge, semantic identification of forbiddenness with
  endpoint secant coverage, and `exists_quadratic_pair_extension` together give the quantitative
  quadratic-Frobenius orbit-extension criterion. No exact precursor was located in the current
  bounded searches; its ingredients and union-bound mechanism are elementary or classical.
- **Paper-specific proved corollaries:** the invariant-eight-arc `s≥7` extension statement and the
  denominator-free orbit-saturation inequality. The former is plausibly unrecorded but elementary;
  the latter has the classical Lunelli–Sce/line-covering square-root scale and is not a new
  asymptotic phenomenon.
- **Paper-specific checked refinement:** on each empty carrier, the subtraction-free identity
  `legal+M=N+B_ℓ+Σ_q(μ_ℓ(q)-1)_+` separates invisible orbit mass from collision redundancy; its
  aggregate form and the geometric fixed-center interpretation of `B_ℓ` are Lean-proved.
- **Paper-specific checked first-order inverse:** aggregate equality holds exactly under universal
  visibility and collision-free charge; excess `k` is exactly invisible mass plus collision
  redundancy. In the quadratic geometry, invisible mass is center/empty-carrier incidence. This is
  an algebraic equality/excess classification, not a structural classification of near-saturated
  arcs.
- **Lean-proved zero- and four-fixed-point profiles:** the intended lower bounds of five and four
  legal pairs and the resulting semantic pair extensions are checked by `Q25ProfileZero` and
  `Q25ProfileFour`.
- **Lean-proved uniform order-five theorem:** `Q25AllProfiles.pair_extension` exhausts the
  parity-allowed profiles `f=0,2,4,6,8`. A bounded zbMATH Open, Crossref, OpenAlex, and
  source-level search located no exact prior theorem; this is a bounded negative result, not a
  certified historical novelty claim.
- **Lean-proved exceptional profile:** every `s=5,f=2` invariant eight-arc pair-extends, by
  `Q25PairResult.f2_pair_extension` and its fully checked normalization/coverage chain.
- **External computational evidence only:** two implementations report `469600` normalized arcs
  and observed minimum legal-pair count `32`; those stronger numerical claims remain unproved.
- **Proof-spine outcomes, not separate discoveries:** semilinear incidence preservation, the
  projective-fixed-versus-coordinate-fixed warning, exact mate fibers, natural-subtraction side
  conditions, the completed-square occupied-line identity, and semantic closure from an abstract
  survivor to an actual arc extension.
- **Best open paper strengthenings:** conceptually prove or kernel-certify the exceptional
  `s=5,f=2` census; a structural inverse theorem for near-saturation; an
  exact finite-geometric cost-of-symmetry family; an exact geometric integrality gap; and a new
  orbit-refined secant/completion spectrum.
- **Established frameworks available as applications:** coherent-system reliability, directional
  Hamming/Z-channel distance, bounded-rank hitting set, symmetry-reduced integer programming,
  fault-tolerant defining sets, database repair, diagnosis, and code lengthening/puncturing.
- **Speculative directions:** higher-degree Galois orbit extension and composition under products,
  field reduction, or concatenation. These require precise definitions and new theorems before a
  novelty claim.

Update this classification whenever proof work exposes a new theorem, removes an assumption,
reveals a false generalization, or suggests a new consumer. The detailed entries below preserve the
research queue; this ledger records their current epistemic status.

### A.1 Blocker duality for completion

For the minimal-obstruction clutter `M_x(C)`, minimum deletion certificates are minimum edges of
its blocker clutter `b(M_x(C))`. Thus minimal reasons insertion fails and minimal ways to make it
succeed form a canonical dual pair. Since blocker duality satisfies `b(b(H))=H` for clutters, all
minimal insertion obstructions can in principle be reconstructed from the minimal successful
deletion certificates. This is the classical blocker duality of clutters, specialized to insertion
obstructions; it retains more certificate information than the scalar identity but is not a new
duality. See [Edmonds–Fulkerson](https://doi.org/10.1016/S0021-9800(70)80083-7) and
[Reiter's diagnosis theorem](https://doi.org/10.1016/0004-3702(87)90062-2).

### A.2 Weighted completion distance

Assign a deletion cost `w(v)` and minimize `Σ_{v∈D}w(v)` over deletions enabling `x`. The proof of
Theorem A becomes a weighted-transversal theorem, kernel-checked as
`weightedInsertionDistance_eq_weightedTransversalCostWithin`. It also composes with prescribed-set
insertion in `weightedMultiInsertionDistance_eq_weightedTransversalCostWithin`. This is the standard
minimum-weight hitting-set specialization. Applications include unequal code puncturing costs,
geometric orbit costs, and heterogeneous storage nodes. Protected coordinates require a
prohibition or infinite-cost convention. Vertex weights do not model correlated stochastic
failures, which require a joint probability law.

### A.3 Orbit-quotient obstruction clutters

For a group `G` preserving `C` and `x`, quotient the minimal-obstruction clutter by vertex orbits.
Equivariant deletion selects whole orbits, so equivariant completion distance becomes a weighted
transversal problem on the quotient. This unifies fixed-point extension, conjugate-pair extension,
higher Galois-degree orbits, symmetry-constrained puncturing, and whole-rack or whole-region actions.
The quotient is standard orbit aggregation in symmetric covering/ILP; novelty requires a new
family-specific evaluation rather than the reduction itself.

### A.4 Cost of symmetry for completion obstructions

Define

```text
cost_G(x,C)=δ_x^G(C)/δ_x(C),
```

where the numerator permits only `G`-invariant deletions and the denominator is positive. This is
the established invariant-cover ratio `τ_G/τ`, already called the **cost of symmetry**; see
[Klyachko–Luneva](https://arxiv.org/abs/1908.03315). For `δ_x=0`, use the additive cost
`δ_x^G-δ_x` or leave the ratio undefined. A new result would be an exact value, extremal bound, or
unbounded gap for a natural finite-geometric family.

### A.5 Fractional completion distance

Define `δ_x^*(C)=τ^*(M_x(C))`. This is the standard fractional-transversal LP, and
`δ_x/δ_x^*` is its integrality gap when `τ^*>0`. Disjoint secants have gap one; higher-rank circuit
clutters may not. The credible new target is a sharp exact gap or unbounded family for a geometric
circuit clutter, not the definition.

### A.6 The local-to-global resilience spectrum

Retain the multiset

```text
Specδ(C)={δ_x(C):x∉C}
```

rather than only its minimum. For invariant configurations, refine it by external-point orbit. The
spectrum can distinguish configurations with identical size, completeness, and worst-case radius,
but for planar arcs it is the classical bisecant-multiplicity distribution under new terminology.
It connects to syndrome/coset-leader distributions and multiple coverings; see
[Davydov–Marcugini–Pambianco](https://arxiv.org/abs/2101.12722). A new result requires an uncomputed
orbit-refined distribution for a nonclassical family.

### A.7 Reliability polynomials

Under independent point survival, the probability that `x` remains blocked is the standard
coherent-system reliability function of its obstruction clutter. If every point survives with
probability `p`, then `σ` disjoint secant pairs give `1-(1-p²)^σ`. Heterogeneous independent
probabilities give a multilinear reliability function; correlation requires a joint law. The
translation is classical, while a new exact geometric polynomial or extremal comparison could be
publishable.

### A.8 Stability from the heterogeneous bound

The exact deficits `N_ℓ-f_ℓ` give an elementary averaging statement: few legal extensions force
most empty carriers to have large forbidden support. The exact first-order equality/excess theorem
now identifies the correction as invisible mass plus collision redundancy, but that algebraic
classification alone is not a structural stability theorem. The strong open target is an inverse
theorem classifying, or approximating by structured families, configurations with nearly saturated
forbidden support.

### A.9 Invisible-center and collision corrections

The exact correction has two parts, as derived after Theorem F.1: invisible-center orbits `B_ℓ`
and collision redundancy `Σ_q(μ_ℓ(q)-1)_+`. Inclusion–exclusion and secant multiplicity are
classical, including focused and hyperfocused-arc literature; the restricted Frobenius charge map
is the paper-specific target. The support/invisible/redundancy identity and its quadratic
instantiation are now Lean-proved, including exact aggregate equality and every excess level.
Combining the maximum fiber `μ≤4`, the classical second secant
moment, and the cross-center incidence bound suggest the `s=5` profile bounds, while external
enumeration suggests the `f=2` minimum is 32. The `f=2` existence statement is now Lean-proved;
the `f=4` bound and extension are also Lean-proved, as are the `f=0` bound and uniform existence
theorem. The minimum-32 claim remains outside the kernel.

### A.10 Higher-degree Galois orbit extension

For extension degree `d>2`, candidate additions are full Galois orbits and their carrier geometry is
controlled by Galois rank rather than a mate line. The obstruction object should encode old flats
meeting candidate orbits improperly. Candidate feasibility must first be separated from mixed
old-new obstruction charging: for `d>2`, an orbit may already contain a forbidden dependent subset.
Field reduction, linear sets, and Galois methods for arc completeness are established, so this
remains an open program rather than a novelty claim.

### A.11 Completion distance as asymmetric code distance

For facets define `d→(C,F)=|C\F|`. Then, when an alternative facet exists,
`ρ(C)=min_{F≠C}d→(C,F)`. This is the standard directional component of Hamming discrepancy for a
one-sided/Z-channel error model. Completion cores become forced-symbol closures and defining sets
become asymmetric information sets. The paper contributes a translation, not a new metric.

### A.12 Tensorization and composition

Determine how insertion spectra behave under explicitly defined direct sums, products, field
reduction, and concatenation. Direct-sum formulas are likely elementary; product and concatenation
behavior depends on the definitions, while reliability composition is classical. No tensorization
claim should be made until the operations and exact formulas are stated.

### A.13 Fixed-parameter and symmetry-reduced algorithms

Completion distance is hitting set in general, so bounded-rank FPT algorithms, `d`-Hitting Set
kernels, and symmetry-reduced ILPs are established tools. For a fixed external point of a planar
arc the secant clutter is a matching, making its optimum immediate. A contribution needs a
geometry-specific kernel, complexity dichotomy, improved algorithm, or compact verified
certificate theorem.

### A.14 Robust defining-set hierarchy

Deletion-resistant defining and identifying objects already appear as fault-tolerant or robust
defining/identifying/resolving sets. Bean–Cavenagh's 2026
[`k`-strong defining sets](https://arxiv.org/abs/2605.28027) are especially close. The paper should
specialize this established hierarchy to facet families; exact values or classifications for
conics, normal rational curves, spreads, or designs could still be new.

### A.15 Multi-insertion and orbit insertion

For a prescribed feasible set or orbit `X`, let the minimal obstructions be traces `A⊆C` for which
`A∪X` is dependent. The kernel-checked multi-insertion theorem gives

```text
δ_X(C)=τ(M_X(C)).
```

This unifies single-point completion, conjugate-pair extension, full Galois-orbit extension, and
multi-coordinate code lengthening. The declarations
`multiObstructionHypergraph_singleton` and `multiInsertionDistance_singleton` verify singleton
specialization. This is a useful checked prescribed-set API, but singleton recovery alone does not
establish irreducibly new mathematics. The prescribed-set representation also admits the standard
nonnegative vertex weights.

### A.16 Ranked follow-up

The strongest current novelty bets are:

1. a structural inverse theorem for near-equivariant saturation;
2. an exact finite-geometric cost-of-symmetry family;
3. a sharp geometric fractional/integral gap;
4. a new orbit-refined completion/secant spectrum for a nonclassical invariant family.

Blocker duality and orbit quotienting are enabling infrastructure, not novelty bets. Task `C99`
has completed the broad adversarial novelty check and landed the exact correction plus the
order-five proof targets. All profiles and the uniform order-five conclusion are now proved in
Lean. C135 adds the exact algebraic equality/excess classification; the structural inverse problem
in item 1 remains open. See the
[paper-specific novelty review](../2026-07-13-baer-completion-adversarial-novelty-review.md).
