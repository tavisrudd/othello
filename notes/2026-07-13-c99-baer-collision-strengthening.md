# C99 — exact collision accounting and the order-five boundary

**Date:** 2026-07-13

Session history: [`2026-07-13-c99-baer-collision-strengthening-archive.md`](2026-07-13-c99-baer-collision-strengthening-archive.md).

## Result

The carrier correction is now an exact, subtraction-free theorem in Lean.  In the quadratic
Frobenius model it identifies the distinct forbidden support with the support of the secant-orbit
charge and gives, both linewise and in aggregate,

```text
L + E M = E N + B + R,
```

where `L` is the number of legal candidate pairs, `E` the number of empty fixed carriers, `M` the
number of nonfixed secant orbits, `N` the candidates per carrier, `B` the total invisible
orbit/carrier incidence, and `R=Σ(μ-1)` the collision redundancy over visible charge fibers.

For invariant eight-arcs over `PG(2,25)`, the exceptional profile `(f,e)=(2,3)` is now proved by
the Lean declaration `Q25PairResult.f2_pair_extension`.  The theorem does not trust either external
enumerator: Lean proves the `GF(25)/GF(5)` model, both projective normalizations, orbit coverage,
the determinant certificate, and transport back to the paper-facing projective point model. Its conclusion
explicitly makes both members of the added conjugate pair fresh. The proposed
`f=4` consequence is kernel-checked by `Q25ProfileFour.profile_four_pair_extension`. The
certificate-free `Q25ProfileZero.profile_zero_pair_extension` proves the `f=0` case with at least
five legal pairs, and `Q25AllProfiles.pair_extension` now closes the uniform order-five conclusion.

No novelty claim is attached to the order-five profile result until a targeted literature check is
complete.  The exact Frobenius-restricted assembly remains the candidate contribution; fiber
counting, second secant moments, and capped-multiplicity inequalities are classical ingredients.

## Claim ledger

| ID | Claim | Mathematical status | Lean status | Novelty status |
|---|---|---|---|---|
| C99.1 | `visible mass = support + collision redundancy` | proved | proved in `CollisionProfile.lean` | classical finite-fiber identity |
| C99.2 | `all orbits = invisible + support + redundancy` | proved | proved in `CollisionProfile.lean` | classical bookkeeping |
| C99.3 | `legal + orbits = candidates + invisible + redundancy` | proved | proved linewise and in aggregate | paper-specific specialization; priority open |
| C99.4 | visible quadratic charge support equals the coordinate forbidden-candidate set | proved | proved in `QuadraticCollision.lean` | assembled from checked coordinate infrastructure |
| C99.5 | aggregate invisible capacity forces a genuine arc extension | proved | proved in `QuadraticCollision.lean` | paper-specific consequence; priority open |
| C99.6 | a cross-pair secant orbit is invisible on at least `s+3-f-e` empty carriers | proved | `QuadraticInvisible.s_add_three_sub_f_sub_e_le_card_empty_through_crossPair_center`; the occupied-line bound is `card_occupied_through_crossPair_center_le` | elementary incidence candidate |
| C99.7 | for `s=5`, profile `(f,e)=(0,4)` has at least five legal conjugate-pair extensions | proved | `Q25ProfileZero.five_le_sum_card_legal_profile_zero`; semantic extension in `profile_zero_pair_extension` | targeted search found no exact statement; priority not definitive |
| C99.8 | for `s=5`, profile `(f,e)=(4,2)` has at least four legal conjugate-pair extensions | proved | `Q25ProfileFour.four_le_sum_card_legal_profile_four`; semantic extension in `profile_four_pair_extension` | targeted search found no exact statement; priority not definitive |
| C99.9 | every invariant eight-arc in `PG(2,25)` pair-extends | proved | `Q25AllProfiles.pair_extension`, combining the checked `f=0,2,4,6,8` cases | targeted search found no exact statement; priority not definitive |
| C99.10 | the normalized `(2,3)` profile has minimum legal-pair count `32` | computed datum, not a theorem | not formalized | computational evidence only |
| C99.11 | every `(f,e)=(2,3)` invariant eight-arc in `PG(2,25)` has a fresh conjugate-pair extension | proved | `Q25PairResult.f2_pair_extension`; both new points are explicitly outside the old arc | targeted search found no exact statement; priority not definitive |

In this ledger, **proved means Lean kernel-checked**.  Prose derivations and independently agreeing
programs are recorded only as proof-search evidence.

## Targeted priority check

Searches for `PG(2,25)` eight-arcs, Baer-involution-invariant arcs, Frobenius-invariant arc
extension, and conjugate-pair addition found no source stating C99.7, C99.8, or the exceptional
profile problem C99.9.  The closest located sources were:

- Baker–Wantz, [*An arc partition of the Hughes plane using a field-theoretic
  model*](https://msp.org/iig/2005/2-1/iig-v2-n1-p04-s.pdf), for adjacent field-theoretic/Baer-plane
  arc constructions and conjugate additions;
- Bartoli et al., [*Algebraic approach to the completeness problem for `(k,n)`-arcs in planes over
  finite fields*](https://doi.org/10.1016/j.jcta.2023.105851), for modern completeness methods and
  Frobenius-defined curve families;
- Giulietti–Montanucci, [*On Hyperfocused Arcs in `PG(2,q)`*](https://arxiv.org/abs/math/0601488),
  for the established study of secant collisions on small external supports.

This is a targeted negative search result, not a proof of priority.  In particular, it does not
cover unindexed theses, tables, or terminology that phrases the same configuration as code
lengthening or secant focusing.  The ledger therefore says “priority not definitive,” and no
discovery claim is made from absence of a hit.

## Exact accounting

For one empty fixed carrier `ℓ`, let `O` be the set of all nonfixed old-secant orbits and let
`V_ℓ⊆O` be those whose intersection pair on `ℓ` is a nonfixed candidate.  Write `c_ℓ:V_ℓ→Q_ℓ`
for that charge, `S_ℓ=image(c_ℓ)`, and

```text
μ_ℓ(q)=|c_ℓ⁻¹(q)|,
R_ℓ=Σ_{q∈S_ℓ}(μ_ℓ(q)-1),
B_ℓ=|O\V_ℓ|.
```

Finite fiber counting gives `|V_ℓ|=|S_ℓ|+R_ℓ`, while
`|O|=B_ℓ+|V_ℓ|`.  The coordinate forbidden-candidate theorem identifies `S_ℓ` with the forbidden
set.  Therefore

```text
legal(ℓ)+M=N+B_ℓ+R_ℓ.
```

Summing over all empty carriers gives the displayed aggregate identity.  This formulation avoids
natural-number subtraction and remains exact when `M>N`.

## Secant-orbit types and invisible mass

Write the invariant eight-arc as `f` fixed selected points and `e` conjugate selected pairs, so
`f+2e=8`.  The `M=fe+e(e-1)` nonfixed secant orbits have two types.

1. The `fe` mixed orbits join a fixed selected point to one conjugate pair.  The two conjugate
   secants meet at that selected fixed point.  Such a center lies on no empty carrier, so mixed
   orbits contribute no invisible incidence.
2. The `e(e-1)` cross-pair orbits join two distinct conjugate selected pairs.  Their two conjugate
   secants meet at an external fixed point `x`.  The center cannot lie on either participating mate
   line: otherwise that mate line would equal one of the secants and contain three selected points.

There are `s+1` fixed lines through `x`.  At most `f` of them are lines from `x` to fixed selected
points, and at most `e-2` further ones are mate lines of the other conjugate selected pairs.
Consequently each cross-pair orbit is invisible on at least

```text
s+1-f-(e-2)=s+3-f-e
```

empty carriers, with the displayed natural subtraction giving its positive part when the integer
expression is negative.  The existence of the cross-pair itself proves the implicit side condition
`e≥2`.  Hence

```text
B ≥ e(e-1)(s+3-f-e).
```

Coincidences among the listed occupied lines only increase the number of empty lines, so the upper
bound on occupied lines is safe. `QuadraticInvisible.lean` kernel-checks the generic argument by
injecting occupied center-lines into the disjoint union of the `f` selected fixed points and the
conjugate selected-point orbits other than the two cross-pair endpoint orbits.

## Candidate derivation for `(f,e)=(0,4)` at `s=5`

Here `N=10`, `M=12`, the four occupied fixed lines are precisely the four mate secants, and
`E=31-4=27`.  The preceding center bound gives `B≥12·4=48`.

The global second secant moment for an eight-arc is

```text
Σ_{x∉C} choose(σ(x),2)=3 choose(8,4)=210,
```

where `σ(x)` is the number of old secants through `x`; always `σ(x)≤4`.

At external fixed points, the four mate secants contribute `4·6=24` fixed-secant incidences.  The
twelve cross-pair orbits contribute two secants at their fixed center, hence another `24` secant
incidences.  Thus `Σσ(x)=48` over fixed points.  Since
`2 choose(n,2)≤3n` for `0≤n≤4`, their second-moment contribution is at most `72`.

Now consider external nonfixed points on the four occupied mate lines.  Their mate line is itself
one fixed old secant, so write `σ(x)=1+r_x`, where `r_x≤3` counts nonfixed old secants through `x`.
Every nonfixed old secant joins points from two of the four selected conjugate pairs.  It meets the
two corresponding mate lines at its selected endpoints, and hence has external nonfixed
intersection with at most the other two occupied mate lines.  There are `2M=24` nonfixed secants,
so `Σr_x≤48`.  For `0≤r≤3`,
`choose(1+r,2)≤2r`; the occupied-nonfixed second moment is therefore at most `96`.

It follows that the second moment on nonfixed points carried by empty fixed lines is at least
`210-72-96=42`.  Conjugate endpoints have equal secant index.  On an empty carrier every secant
through such an endpoint is nonfixed, and its secant-orbit charge fiber has exactly that size.
Thus, writing

```text
T=Σ_q choose(μ(q),2)
```

over candidate pairs on all empty carriers, the endpoint moment is `2T`, so `T≥21`.  Since
`μ≤4` and `choose(μ,2)≤2(μ-1)` on the nonzero fibers, `T≤2R`; hence `R≥11`.

The exact balance now gives

```text
L + 27·12 = 27·10 + B + R,
L ≥ -54+48+11 = 5.
```

## Checked derivation for `(f,e)=(4,2)` at `s=5`

Here `N=M=10` and

```text
E=31-[4·6-choose(4,2)+2]=11.
```

There are `e(e-1)=2` cross-pair secant orbits.  For either center, the two participating mate lines
cannot contain it, and there are no other mate lines.  At most the four fixed-point star lines are
occupied through the center, so at least two of its six fixed lines are empty.  Therefore `B≥4`.
The exact balance gives `L=B+R≥4` without a collision estimate.

This argument is kernel-checked in `QuadraticInvisible.lean` and `Q25ProfileFour.lean`. The public
theorem constructs a fresh conjugate pair and proves that adjoining both points preserves the arc;
it uses no generated certificate data.

## Candidate consequence and the exceptional profile before enumeration

For `(f,e)=(6,1)` and `(8,0)`, the old uniform count already has `M<10`; the existing
non-full-occupation theorem supplies an empty carrier.  Combining those cases with the two proofs
above yields:

The `f=0,2,4` profile theorems and the existing strict count for `f=6,8` exhaust the parity-allowed
fixed-point counts. `Q25AllProfiles.pair_extension` packages them into a uniform fresh-pair
extension theorem for every Frobenius-invariant eight-arc in `PG(2,25)`.

For `(f,e)=(2,3)`, `M=12`, `E=17`, and the center bound gives `B≥18`.  The exact balance requires
`R≥17` to force `L>0`.  The global moment route remains promising, but its occupied-line term must
distinguish four fixed secant carriers from ten one-point-trace carriers.

The rejected shortcut assigned a base secant to every occupied carrier and concluded that each
nonfixed secant had only two external occupied intersections.  This is correct for `(0,4)`, where
all occupied carriers are mate secants, but false for `(2,3)`: intersections with the ten fixed
star tangents also contribute.  None of C99.7 or C99.8 uses that shortcut.

## External computational evidence for `(f,e)=(2,3)`

Two separately written programs exhaust the remaining order-five profile after normalizing its two
fixed selected points.  Both report

```text
normalized invariant arcs: 469600
minimum legal conjugate-pair extensions: 32
minimizing orbit indices: 65, 93, 154
```

The shared minimizing arc, in the encoding `a+25b+625c` for normalized coordinates over
`GF(5)[w]/(w²-2)`, is

```text
625, 25,
3251, 13001,
5151, 14901,
12076, 9326.
```

The C++ enumerator additionally reports `min B=18`, `min R=42`, maximum fixed second moment `28`,
maximum occupied-nonfixed second moment `96`, and minimum empty-carrier endpoint moment `96` over
the census.  These extrema need not occur on the same arc.  The minimizing legal-count witness has
`B=23`, `R=43`, multiplicity distribution
`(n₀,n₁,n₂,n₃)=(32,101,31,6)`, and moment split `(18,94,98)` into fixed,
occupied-nonfixed, and empty-nonfixed points.

### Why normalization is exhaustive

The two fixed selected points are distinct points of `PG(2,5)`.  `PGL(3,5)` is transitive on
ordered pairs of distinct projective points: choose independent representatives, extend them to a
basis, and map that basis to one whose first two vectors represent the chosen standard pair.  A
matrix over `GF(5)` commutes with the `GF(25)/GF(5)` Frobenius action.  It therefore preserves
fixed points, conjugate pairs, arcs, empty fixed carriers, and the number of legal conjugate-pair
extensions.  It is enough to enumerate the three nonfixed selected orbits after fixing the two
standard points.

The enumerators first retain all nonfixed orbits individually compatible with the fixed pair, then
all compatible orbit pairs, and finally test the only remaining triples containing one point from
each of the three nonfixed orbits.  Thus every selected eight-set is tested for the arc condition.
For each accepted arc, a candidate orbit is legal exactly when its mate carrier is unoccupied and
neither endpoint lies on one of the 28 old secants.  The C++ implementation marks points line by
line; the Python verifier instead builds Python-integer bitsets of candidate orbits covered by each
line.  They agree on the census size, minimum, orbit indices, and coordinate witness.

### Reproducibility and trust boundary

Sources:

- [`2026-07-13-c99-f2-enumerator.cpp`](2026-07-13-c99-f2-enumerator.cpp), SHA-256
  `c6f134ff1f6544ca8612ad1e7959c936f82da56f6ab2f64cd39bb722eb3def90`;
- the audited 52 KiB GCC 14.3.0 executable
  [`2026-07-13-c99-f2-enumerator`](2026-07-13-c99-f2-enumerator), SHA-256
  `9012c938df2e0557e985745f8869d0559435e283a343dd2b7b401159fb175b04`;
- [`2026-07-13-c99-f2-verifier.py`](2026-07-13-c99-f2-verifier.py), SHA-256
  `2377757ebc923ddf2887b3d768c1233e79e593d21f3ffd5fb02523fab99be978`;
- the verifier's existing field primitive
  [`rust/scripts/r7_semilinear_q25.py`](../rust/scripts/r7_semilinear_q25.py), SHA-256
  `76cf21758ee1a7da47b6499c1a05c387375c0ba97a5c09eb6a9427d80cc135bf`.

Commands:

```text
g++ -O3 -std=c++20 -Wall -Wextra -pedantic \
  -o /tmp/c99_f2_enum notes/2026-07-13-c99-f2-enumerator.cpp
/tmp/c99_f2_enum
python notes/2026-07-13-c99-f2-verifier.py
```

The earlier recorded source hash
`dba28904de3a24cc8b5e6d4f4b9748d951d1adc891d1bd5d5368f04e179ffc39` was the census-only
source at 2026-07-13 09:32 PDT. Session history shows two later additive changes: the normalized
greedy-cover generator at 11:24--11:25 and the `--lean-row` certificate emitter at 11:52. The
pre-existing census report is byte-for-byte unchanged across those edits; only generator output
was appended. Two fresh builds of the current source produced the identical binary hash above, and
two fresh runs produced identical stdout and stderr with SHA-256
`42120c18ddc40412cf9e644dcd4dfd67eb301e0a93fe98c1faee5e0daa55550a` and
`9aaeebe9b31175fdb2c38aded6e56626e2cc6454182d9a99467f2cfbb23cc320`, respectively.

This remains reproducible external evidence for the census size and observed minimum `32`, neither
of which is a theorem.  The weaker existence statement for every `f=2` arc is now independently
Lean-proved by a kernel-checked checker with proved normalization, coverage, and semantics.  The
uniform order-five existence statement is now independently Lean-proved; it does not use the
census size or observed minimum.

## Lean inventory and validation

New checked declarations:

- `FiniteGeom.BaerCompletion.chargeSupport`, `chargeMultiplicity`,
  `collisionRedundancy`, and `invisibleOrbits`;
- `card_visible_eq_support_add_collisionRedundancy`;
- `card_legal_add_orbits_eq_candidates_add_invisible_add_redundancy` and its aggregate form;
- the capped-moment inequalities
  `choose_two_le_two_mul_pred_of_le_four`,
  `two_mul_choose_two_le_three_mul_of_le_four`, and
  `choose_two_succ_le_two_mul_of_le_three`;
- `RelativeConicArcs.QuadraticCollision.chargeSupport_visible_eq_forbiddenCandidates`;
- the linewise and aggregate quadratic exact balances;
- `exists_arc_extension_of_aggregate_invisible_capacity`;
- the fixed `secantOrbitCenter`, the exact
  `mem_invisibleSecantOrbitClasses_iff_center_mem` characterization, and the aggregate
  center-incidence double count in `QuadraticInvisible.lean`;
- `card_mul_le_sum_card_invisible_of_center_capacity` and the local `GF(5)` consequence that a
  center on at most four occupied fixed lines lies on at least two empty carriers;
- the cross-pair center occupied-line injection and
  `card_occupied_through_crossPair_center_le_four` in `QuadraticInvisible.lean`;
- `Q25ProfileFour.four_le_sum_card_invisible_profile_four`,
  `four_le_sum_card_legal_profile_four`, and the certificate-free semantic theorem
  `profile_four_pair_extension`;
- `Q25ProfileZero.five_le_sum_card_legal_profile_zero` and the certificate-free semantic theorem
  `profile_zero_pair_extension`;
- `Q25AllProfiles.pair_extension`, exhausting the parity-allowed profiles `f=0,2,4,6,8`;
- the three numerical balance tails in `RelativeConicArcs.BaerArithmetic`.
- the concrete quadratic field and degree-two extension in `RelativeConicArcs.FiniteFields`;
- canonical `PG(2,25)` coordinates and explicit Frobenius in `Q25Coordinates`;
- fixed-pair and stabilizer normalization in `Q25BaseNormalization` and `Q25Normalization`;
- exact three-orbit decomposition in `Q25OrbitDecomposition`;
- the reflected slice `Q25PairData.L_005.first_slice_005`, its reduction, and the paper-facing
  theorem `Q25PairResult.f2_pair_extension`.

Validated with:

```text
choom -n 1000 -- nix develop --command lake build \
  FiniteGeom.BaerCompletion.CollisionProfile \
  RelativeConicArcs.BaerArithmetic \
  RelativeConicArcs.QuadraticCollision \
  RelativeConicArcs.Q25ProfileFour \
  RelativeConicArcs.Q25PairResult \
  RelativeConicArcs.Q25AllProfiles
```

The focused builds pass.  Existing linter warnings replayed from
`QuadraticLineCounting.lean` and `QuadraticForbidden.lean`; the new collision module emits none.
`#print axioms` on both exact balances, the quadratic support theorem, the semantic aggregate
extension theorem, and the order-five arithmetic tails reports only the accepted Mathlib
foundations `propext`, `Classical.choice`, and `Quot.sound` (the arithmetic tails do not use
`Classical.choice`).

## Adversarial proof audit of the exceptional profile

- [x] The public theorem quantifies over an arbitrary invariant projective eight-arc with exactly
  two fixed selected points.
- [x] Its conclusion explicitly gives a nonfixed `p`, proves both `p∉C` and `φ(p)∉C`, and proves
  `C∪{p,φ(p)}` is an arc.
- [x] The concrete field, Frobenius action, 651-point coordinate equivalence, and 310 nonfixed
  conjugate-orbit equivalence are Lean-proved.
- [x] The fixed-pair normalization, stabilizer normalization, exact three-orbit decomposition,
  and inverse projective transports are semantic Lean theorems rather than enumerator assumptions.
- [x] The normalized slice has 46,056 expected rows with no duplicates or gaps: 39,012 explicit
  non-arc witnesses and 7,044 explicit legal-pair witnesses. All 1,639 leaves and 303 row
  aggregates are imported exactly once; `allRows` is the kernel-checked exhaustive composition.
- [x] Every finite leaf uses kernel `decide`; the Q25 source contains no `native_decide`, `sorry`,
  `admit`, custom `axiom`, or `unsafe` declaration.
- [x] The scoped `RelativeConicArcs.Q25PairResult` build passes, and both public theorem axiom
  profiles are exactly `[propext, Classical.choice, Quot.sound]`.
- [x] The 469600 census and observed minimum 32 are absent from the theorem and remain external
  computational evidence.

The complete proof-validity review is recorded in
[`baer-completion-adversarial-review.md`](2026-07-12-riffing-on-applications/baer-completion-adversarial-review.md).
No proof defect remains in the `f=0`, `f=2`, or `f=4` subtracks. The uniform theorem has the same
axiom profile, so C99's order-five existence track is closed.

## Next proof gates

1. Keep the census size and minimum-32 claim computational unless separately Lean-certified; the
   existence theorem is complete and does not require them.
2. Run a broader novelty search for the profile-sensitive order-five theorem before promotion as
   a discovery.
