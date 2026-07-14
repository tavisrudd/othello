# Frobenius-equivariant pair extension of eight-arcs in `PG(2,25)`

Status: focused paper-development manuscript; theorem spine kernel-checked, release audit in progress
Sources: the Baer-extension theorem notes and C99/C133–C136 proof ledgers
Lean lane: [`FiniteGeom/BaerCompletion/`](../../lean/FiniteGeom/BaerCompletion/) and the quadratic
consumers under [`RelativeConicArcs/`](../../lean/RelativeConicArcs/)

Adversarial reviews:
[`baer-completion-adversarial-review.md`](baer-completion-adversarial-review.md) audits proof
validity; [`2026-07-13-baer-completion-adversarial-novelty-review.md`](../2026-07-13-baer-completion-adversarial-novelty-review.md)
audits the claim boundary and prior art.

## Abstract

Let φ be the quadratic Frobenius involution of `PG(2,s²)`. We give an exact carrierwise count
for fresh conjugate pairs `{P,φ(P)}` that extend a φ-invariant arc. The count combines the exact
number of empty Baer lines with a charge from noninvariant secant orbits; an exact correction
separates invisible secant centers from charge collisions and classifies equality and every
first-order excess level. We then prove that every φ-invariant eight-arc in `PG(2,25)` admits a
fresh conjugate-pair extension. The exceptional two-fixed-point profile is discharged by a
kernel-checked normalized finite reduction, while the zero- and four-fixed-point profiles have
certificate-free incidence proofs. The full theorem, the semantic global pair count, and the
profile split are formalized in Lean without `sorry`, custom axioms, or `native_decide`.

## Scope and contribution

The paper is focused on the quadratic-Frobenius extension criterion, its exact collision balance,
and the uniform order-five theorem. Generic completion distance, completion cores, weighted
hitting sets, and broad application translations are reusable background but are not part of this
submission. No family-specific robustness theorem strong enough to connect that package to the Q25
result is presently proved.

The defensible novelty claim is limited: the individual projective, Frobenius, Hilbert-90,
line-counting, and union-bound ingredients are classical. The candidate contribution is their exact
assembly into a quantitative orbit-valued extension theorem and the uniform `PG(2,25)` consequence.
A bounded search found no exact precursor for the uniform Q25 theorem; no historical-first claim is
made.

## Objects and notation

Let `F=𝔽_s`, let `E=𝔽_{s²}`, and let `φ:z↦z^s` act coordinatewise on
`PG(2,E)`. Its fixed points and fixed lines form the embedded Baer subplane `PG(2,F)`. A
`φ`-invariant `k`-arc `C` is a disjoint union of `f` fixed points and `e` nonfixed conjugate
pairs, so `k=f+2e`.

A fresh conjugate-pair extension is an unordered pair `q={P,φ(P)}`, disjoint from `C`, for which
`C∪q` remains an arc. Write `N_pair(C)` for the number of such pairs. Every nonfixed conjugate
pair lies on a unique fixed mate line. The proof partitions candidates by the mate lines disjoint
from `C`, then charges forbidden candidates to noninvariant secant orbits.

## Theorem package and proofs

### Theorem A — Baer secants form fixed blocks or conjugate pairs

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

### Theorem B — quantitative conjugate-pair extension criterion

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

### Theorem B.1 — heterogeneous pair-extension bound

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

In the quadratic Baer plane, `N_ℓ=(s²-s)/2` and `f_ℓ≤M`, so Theorem B follows immediately. The
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

### Theorem C — profile-sensitive order-five extension

If `C` is a Frobenius-invariant eight-arc in `PG(2,25)` and its fixed-point count `f` is not two,
then `C` admits a conjugate-pair extension. The checked lower bounds are five for `f=0` and four for
`f=4`; the profiles `f=6,8` already follow from Theorem B. Both exceptional
bounds and semantic extensions are kernel-checked, and `Q25AllProfiles.pair_extension` proves the
uniform statement (together with Theorem C.1 for `f=2`).

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
does not close that profile; Theorem C.1 supplies a separate finite, kernel-checked proof, while the
stronger census and minimum remain external data in C.2.

Formalization and novelty boundary: the exact accounting, capped arithmetic, center-incidence,
the generic `s+3-f-e` cross-pair bound, and moment-partition geometry above are Lean-proved. A
targeted search found adjacent Baer-involution, arc-completeness, and
conjugate-addition literature, but no exact profile-sensitive statement; this is a priority-search
result, not a claim of definitive historical novelty. The detailed proof and claim ledger are in
[`2026-07-13-c99-baer-collision-strengthening.md`](../2026-07-13-c99-baer-collision-strengthening.md).

### Theorem C.1 — the exceptional order-five profile extends

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

### Computed datum C.2 — census and minimum for the exceptional profile

External enumeration after fixed-point normalization reports `469600` invariant eight-arcs with
profile `(f,e)=(2,3)` and observed minimum `32`. The census size and minimum are computed data, not
theorems. The weaker universal existence conclusion is Theorem C.1 and is Lean-proved independently.

Two implementations agree on the census, minimum, minimizing orbit indices, and coordinate
witness. The C++ enumerator uses explicit point/line incidence and point marking; an independently
written Python verifier uses candidate bitsets. A subfield projectivity commutes with Frobenius and
preserves the legal-pair count, so normalizing the ordered fixed-point pair is exhaustive.

The data suggest that the `s≥7` theorem may extend to every finite-field order `s≥5`, but no such
theorem is claimed. Sources, hashes, the minimizing witness, and the formalization gap are in the
linked C99 proof ledger.

### Corollary D — equivariant saturation has square-root scale

For `s≥7`, every invariant 8-arc admits an equivariant conjugate-pair extension. More generally, an
equivariantly complete invariant `k`-arc satisfies

```text
k ≥ 1 + ceil(sqrt(2s(s-1))).
```

#### Prose proof

For `k=8`, Lean gives `M≤12<(s²-s)/2` when `s≥7`. There must be an empty fixed carrier: otherwise
the completed-square occupation identity would force `k≥s²+1>8`. Theorem B therefore supplies a
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

## Lean formalization inventory

1. `BaerPlane.lean`, `ProjectiveConjugation.lean`, and `QuadraticFrobenius.lean`: involution
   incidence, coordinate Frobenius, fixed-locus normalization, and exact candidate counts.
2. `QuadraticLineCounting.lean`: exact occupied and empty fixed-line formulas.
3. `PairExtension.lean`, `QuadraticPairExtension.lean`, and `QuadraticForbidden.lean`: the
   carrierwise lower bound, forbidden charge, candidate semantics, and end-to-end arc extension.
4. `QuadraticGlobalCount.lean`: the semantic global legal-pair finset, unique empty mate-line
   decomposition, and exact equality with `PairExtensionData.legalCount`.
5. `CollisionProfile.lean`, `QuadraticCollision.lean`, and `QuadraticInvisible.lean`: exact
   linewise/aggregate correction, equality and excess classification, and center-incidence bounds.
6. `Q25ProfileZero.lean`, `Q25ProfileFour.lean`, `Q25PairResult.lean`, and
   `Q25AllProfiles.lean`: the five profile cases and the uniform `PG(2,25)` theorem.

The scoped builds and `#print axioms` audits report exactly
`[propext, Classical.choice, Quot.sound]`. The generated two-fixed-point leaves use kernel
`decide`; no public theorem depends on `sorryAx`, a custom axiom, or `native_decide`.

## Claim boundaries and remaining release gates

- The global count, uniform Q25 existence theorem, collision equality/excess classification, and
  profile-specific lower bounds stated above are Lean-checked.
- The external normalized census size `469600` and observed minimum legal-pair count `32` are
  computational evidence, not theorem inputs.
- The square-root constant in Corollary D is the classical Lunelli–Sce scale; only the weaker
  no-conjugate-pair-extension hypothesis is potentially paper-specific.
- C134 is a bounded search for the uniform Q25 statement. A specialist/database search for the
  general quadratic-Frobenius formula remains before any priority wording stronger than “no exact
  precursor located.”
- Sharpness is not claimed. Unless a near-sharp or pair-saturated family is proved, the general
  result is presented as a structural criterion.
- Final release still requires the literature closeout, stable bibliography and numbering,
  submission formatting, and a last manuscript-to-Lean referee audit.

## Focused manuscript spine

1. Quadratic Frobenius, fixed mate lines, and the pair-extension test.
2. Exact empty-carrier and noninvariant-secant counts.
3. The quantitative extension criterion and semantic global cardinality.
4. Invisible-center and collision corrections; equality and excess.
5. Uniform pair extension of invariant eight-arcs in `PG(2,25)`.
6. Saturation corollary, computation boundary, formalization, and prior art.
