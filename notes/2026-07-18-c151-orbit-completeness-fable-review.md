# C151 residual-orbit plan — critical review (Fable, 2026-07-18)

**Lane**: `alt-orbit-repair`

Scope: review of the proposed repair plan for
`lean/RelativeConicArcs/Q25ResidualMinimumOrbits.lean` (untracked, all `decide`s fail).
Read-only review; no Lean elaboration was run (shared build tree in use), so every cost figure
below is an estimate from term structure, not a measurement. The first action once a build
window opens should be the two probes in §6.

## Verdict in one paragraph

The diagnosis is correct but incomplete: the stuck atom is the `ZMod 5` inversion inside
`scale`, and Step 0 (a fast evaluator) is mandatory — but even after Step 0, the file's
current shape (`Finset.univ.image` producing a `Finset (Finset Idx25)`, then `card`,
`Disjoint`, and a 1600-element union, all by `decide`) is very likely fatal on kernel dedup
cost alone. Plan B inherits that cost profile and should be dropped in favor of a cheaper
keyed variant (§3). Plan A is sound in outline and genuinely better than literal blocks, but
step 1 as written hides the two real proof obligations (a parameter-level multiplication that
provably matches function composition, and the Mathlib `MulAction`/`Finset` bridging), and one
of its sub-costs (action-compatibility by `decide`) is infeasible unless factored per
coordinate slot. A concrete factored route is given in §2.

## 1. Diagnosis: correct on opacity, incomplete on size

**The opaque atom is precisely `(imagPart x)⁻¹ : ZMod 5`, nothing else.** Verified from
source:

- `Q25Normalization.lean:42` — `scale x = algebraMap F5 K25 (imagPart x)⁻¹`. The `⁻¹` is
  `ZMod.inv`, which routes through `Nat.gcdA`/`xgcdAux` (well-founded recursion, kernel-
  irreducible). The Q11 file docstring states this rationale verbatim
  (`Q11A5PointOrbitsArithmetic.lean:6-9`).
- `algebraMap F5 K25` is **not** opaque: the instance is `baseRingHom.toAlgebra`
  (`FiniteFields.lean`), with `toFun a = encode a.val 0`, and
  `Q25Normalization.lean:31-35` (`assemble`) is proved `by revert a b; decide` — direct
  evidence that `algebraMap` kernel-reduces here.
- `imagPart` alone reduces: `card_admissibleCoordinate = 20 := by decide` succeeds
  (`Q25ResidualAction.lean:28`), and that forces the subtype `univ`, so the
  `Subtype.fintype`/`instFintypeProd` route to `Finset.univ : Finset ResidualParameter` is
  also not a blocker (`card_residualParameter := by decide` at `:30`).
- The `(scale y)⁻¹` in the `.infinity` branch is `GF25.inv`, a 25-entry literal table
  (`FiniteFields.lean:152-154`) — reducible.

So Step 0 needs only a 5-entry `F5` inverse table (Q11's `scalarInvCode` has 11 entries;
yours needs `![0,1,3,2,4]`), a lemma `f5_inv_eq_code`, then
`scaleFast x := GF25.encode ((f5InvCode (imagPart x)).val) 0`, `shiftFast`,
`residualApplyFast`, and `residualApply_eq_fast`. This is exactly the repo's sanctioned
"one reducible table evaluator + symbolic bridge" pattern. No objection; it is a
prerequisite for every plan.

**But size is a second, independent problem.** Estimate the kernel cost after Step 0,
using: one `Finset Idx25` equality = one `Multiset` equality = a `List.Perm`-style decision
over two 8-element lists ≈ 64 `Idx25` comparisons; each `Idx25` comparison is a constructor
match plus one or two `Fin 25` equalities — call one `Finset`-equality "unit" ≈ a few
thousand kernel steps once the images themselves are reduced.

- **Plan A step 2 (stabilizer filter)**: 400 units per row. Trivial. Add the cost of
  computing 400 mapped images (400 × 8 `residualApplyFast` evaluations, each GF25 table
  arithmetic) — also trivial. **Fine.**
- **Plan B / current file, one orbit `image`**: `Finset.image` is
  `Multiset.dedup ∘ Multiset.map`; dedup is quadratic membership testing, ≈ 400²/2 = 80,000
  units per orbit ≈ low 10⁸ kernel steps, times five orbits. Borderline-fatal on time and,
  worse, on the size of the accumulated dedup term the kernel must hold. The Q11 authors hit
  exactly this at *smaller* scale and documented it: `Q11A5PointOrbitsData.lean:246` records
  literal blocks specifically to avoid "the large kernel term produced by repeatedly
  constructing and deduplicating 133-element images" — and their elements were `Fin 133`
  points, not 8-element `Finset`s with permutation-equality.
- **Each `Disjoint` decide** (if the `Finset.decidableDisjoint`-style instance is even what
  `decide` picks up — no `Disjoint` is decided anywhere in the repo, so this is untested):
  ≈ 200×400 = 80,000 units per pair, ×10 pairs, *plus* re-deduplicating both orbit images
  inside every theorem, since nothing shares the reduced term between decides.
- **`card_minimumOrbitUnion`**: `∪` on `Finset` is `ndunion` — quadratic again across 1600
  elements ≈ 1.3M units ≈ 10⁹–10¹⁰ steps. **This one is fatal even if everything above
  squeaks through.** The `maxHeartbeats 300000000` already in the file is a tell that
  thrashing was anticipated.

So: yes, the answer to your Q1 conditional is the important one — **Plan A's step-2 filter
is fine; Plan B's dedup (and the current file's shape generally) is not.** That kills Plan B
as written and means even Plan A must not prove disjointness or the union card by deciding
`Finset (Finset Idx25)` operations.

## 2. Plan A step 1: feasible, but only in factored form

Three things the plan states too casually:

**(a) The multiplication must be *defined to* match composition, then proved.** There is no
sense in which `parameterEmbedding` composition "corresponds" to a product until you define
one. The composite of `u ↦ shift y₂ + scale y₂ · u` after `u ↦ shift y₁ + scale y₁ · u` is
`u ↦ (shift y₂ + scale y₂ · shift y₁) + (scale y₂ · scale y₁) · u`. You must exhibit the
parameter `y₃` with that scale and shift. Solvability: `x ↦ (scale x, shift x)` is a
bijection from the 20 admissible coordinates onto `{(a,b) : a ∈ F5*, b ∈ F5}` ≅ AGL(1,5)
(recover `imagPart = a⁻¹`, `realPart = -b/a`), and AGL(1,5) is closed under composition, so
the recovered-parameter formula exists. But `apply (g*h) = apply g ∘ apply h` is a theorem
you must prove, not a definitional fact — it is *the* soundness lemma of the whole design.
The plan's step 4 ("orbits are equal-or-disjoint") is unsound without it plus identity and
inverses: reflexivity of the orbit relation needs an identity parameter (it exists: `x = ω`
gives `imagPart = 1`, `realPart = 0`, hence `scale = 1`, `shift = 0` — worth stating in the
file), and "X ∈ orbit C ∩ orbit D ⟹ orbits equal" needs inverses and closure, not just
closure.

**(b) Do the group on the 20-element factor, never on the 400-element product.**
`mul_assoc` by `decide` over `ResidualParameter` triples is 400³ = 6.4·10⁷ cases — dead.
Over `AdmissibleCoordinate` it is 20³ = 8,000 cases — trivial after Step 0. Define
`Mul`/`One`/`Inv`/`Group` on `AdmissibleCoordinate` (all axioms by `decide`), and
`ResidualParameter` gets the product group for free.

**(c) The `MulAction` compatibility law cannot be decided directly either.**
`∀ g h i, (g*h) • i = g • (h • i)` over `ResidualParameter × ResidualParameter × Idx25` is
400×400×651 ≈ 10⁸ cases. Factor it:

- Prove by `decide` over 20×20 = 400 pairs the two *parameter-level* composition facts:
  `scale (mul a b) = scale a * scale b` and
  `shift (mul a b) = shift a + scale a * shift b`.
- The `.affine` case of compatibility then follows by `ring`-level rewriting; the
  `.infinity` case (`(scale y)⁻¹ * scale z * v`) follows from scale-multiplicativity plus
  `mul_inv` in the field `K25` — symbolic, no enumeration; `.vertical` is `rfl`.
- `one_smul` is a 651-case `decide` or three constructor cases with `simp` — trivial.

With (b) and (c), Mathlib's orbit–stabilizer
(`MulAction.card_orbit_mul_card_stabilizer_eq_card_group` / the `Nat.card` versions) applies.
Budget real time for the remaining plumbing the plan does not mention: Mathlib's orbit is a
`Set`, its stabilizer a `Subgroup`; you need `(Finset.univ.image (· • C)).card =
Nat.card (MulAction.orbit G C)` and `(Finset.univ.filter (· • C = C)).card =
Nat.card (MulAction.stabilizer G C)` bridges, plus the pointwise-`Finset` action instance
(`open Pointwise`, or your own `SMul` via `Finset.image` — prefer `Finset.image` of the
*fast* function over `.map` with the proof-carrying embedding, to keep decided terms small;
add a one-line lemma equating it with the existing `parameterEmbedding` map, in the style of
`map_residualEmbedding`, `Q25ResidualAction.lean:91`). None of this is hard; all of it is
scaffolding the plan currently prices at zero.

Answering your Q2 directly: yes, the group structure is worth it, *provided* it is the
factored version above. The `card_image_of_injOn` alternative only covers the two
trivial-stabilizer rows cheaply (and even there injectivity-by-`decide` is 400²/2 = 80,000
units per row — an order worse than the stabilizer filter); for the stabilizer-2 rows you
would end up hand-rolling a 2-to-1 counting argument that is orbit–stabilizer with the
serial numbers filed off. An explicit `Equiv` to a coset quotient is the same work as the
Mathlib route without the library support. Take the Mathlib route.

## 3. A third design exists and should replace Plan B: sorted-rank keys

Your Q3 instinct is right, and the good version uses `List Nat`, not a packed `Nat`:

```
def rankKey (C : Finset Idx25) : List Nat := (C.image rank).sort (· ≤ ·)
def orbitKeys (C : Finset Idx25) : Finset (List Nat) :=
  Finset.univ.image fun g : ResidualParameter => rankKey (C.image (residualApplyFast g))
```

- The expensive dedup now happens over `List Nat` with length-8 lists: one equality is ≤ 8
  `Nat.decEq` calls, and the kernel has accelerated GMP arithmetic for `Nat` literals. The
  80,000-comparison dedup becomes ≈ 6·10⁵ cheap `Nat` equalities per orbit; the 1600-element
  union becomes similarly cheap. Everything in the current file becomes decidable at `List
  Nat` level: cards, the ten disjointnesses, the union card.
- The bridge back is one handwritten injectivity lemma: `rankKey` is injective on 8-element
  `Finset Idx25`s, from `rank_injective` (`Q25Coordinates.lean:265`) ⟹
  `Finset.image_injective` ⟹ sort determines the `Finset Nat` (`Finset.sort_toFinset` /
  the multiset-coercion lemma). No base-encoding digit lemma needed — that is why `List Nat`
  beats a single packed `Nat`. Then `(residualOrbit C).card = (orbitKeys C).card` via
  `orbitKeys C = (residualOrbit C).image rankKey` (`Finset.image_image`) and
  `Finset.card_image_of_injOn`; disjointness of key-sets lifts to disjointness of orbits by
  the same injectivity (both sides consist of 8-element sets, via `Finset.card_map`).

This is strictly better than Plan B: no generated literal blocks at all, one ~30-line
symbolic bridge, and it *is* the repo convention ("reducible evaluator + symbolic bridge")
applied at the set level rather than the point level. Versus Plan A: it delivers the same
five theorems more cheaply but with an encoding-flavored story. Recommendation: **build the
key layer regardless** — it is small, it de-risks everything, and Plan A can consume it
(stabilizer filter and non-conjugacy checks are cheaper as key comparisons than as
`Finset Idx25` equalities). If Plan A's scaffolding stalls, the key layer alone closes the
file. If Plan A lands, the key layer is an implementation detail beneath a group-theoretic
statement, which is the right layering per the strategic note's item 3.

## 4. Does Plan A deliver strategic item 4, or just relabel brute force?

Mostly delivers, with one caveat to state plainly in the eventual paper. What changes is not
the *presence* of kernel enumeration but its *shape and size*: O(|G|) pointwise checks per
row (stabilizer membership, non-conjugacy) plus handwritten theorems (orbit–stabilizer,
equal-or-disjoint, disjoint-union counting), instead of O(orbit²) opaque dedup or 1,600
literal set links. A referee can read the five stabilizer orders, check `400/2 = 200`, and
believe disjointness from non-conjugacy — that is a real five-arrow story. The caveat: the
stabilizer *orders* remain kernel facts, not conceptual derivations. The strategic note asks
for "conceptual stabilizer calculations"; you will have "kernel-verified stabilizer orders
with the stabilizing involution exhibited". For the two order-2 rows, name the involution
explicitly (a definition plus a one-line `decide` that it fixes the row) — that costs
nothing and moves the exposition most of the remaining distance. Do not claim more than
that; a 400-case membership check dressed in `MulAction.stabilizer` vocabulary is still a
computation, and saying so plainly is stronger than obscuring it.

Also keep the plan's step 6 separation: correct that orbit–stabilizer proves nothing about
exhaustion. The union-card-1600 theorem is only useful once welded to the residual-cover
result that every minimizer lies in one of the five orbits; make sure the eventual statement
is "these five orbits partition the minimizer set", with the ⊇ direction cited from the
cover machinery, not implied by counting.

## 5. Correctness flags (wrong, not merely expensive)

1. **Equal-or-disjoint needs the full group-action package.** As written, step 4 assumes it.
   With `filter`/`image` definitions it holds only after: identity parameter (exists, `ω`),
   closure (`apply g ∘ apply h = apply (g*h)` — the soundness lemma of §2(a)), and inverses.
   None of these is currently proved anywhere; `Q25ResidualAction.lean` proves injectivity
   of each map but nothing about composition. This is the single place the plan could
   produce a *false-confidence* gap rather than a build failure, because a bespoke
   "equal-or-disjoint" lemma with a missing inverse hypothesis can be stated in a form that
   type-checks but doesn't yield step 5.
2. **Non-conjugacy direction.** Step 4's ten checks `∀ g, C.map g ≠ D` prove `D ∉ orbit C`;
   to conclude `Disjoint (orbit C) (orbit D)` you need the group laws again (if `X = C^g =
   D^h` then `D = C^(g h⁻¹)`). Fine once §2 lands; not before.
3. **Instance trap in the stabilizer/orbit `decide`s.** Decide through `Finset.image` of the
   *fast* function, not `Finset.map (parameterEmbedding g)`: the embedding bundles an
   injectivity proof whose statement mentions the noncomputable `mapIdx`; proofs are erased
   in reduction, but the unreduced `residualApply` (slow form) inside the embedding's
   `toFun` is exactly what fails today. Every decided statement must be phrased in the fast
   function with a `simp`-bridge to the embedding form, mirroring `map_residualEmbedding`.
4. **Untested `Disjoint` decidability.** No `Finset` `Disjoint` is decided anywhere in the
   repo; do not assume the instance `decide` finds is the efficient `∩ = ∅` one. Under the
   key design this disappears (decide `Disjoint` on `Finset (List Nat)` or, safer, decide
   `(A ∩ B) = ∅` explicitly and bridge).

## 6. Recommended ordering (risk first)

1. **Step 0** (fast `F5` inverse table, `scaleFast`/`shiftFast`/`residualApplyFast`,
   equational bridge). Blocking for everything; near-zero risk.
2. **Probe A (cheap, decisive for Plan A):** `decide` one stabilizer card, e.g.
   `(Finset.univ.filter fun g : ResidualParameter =>
   minimumRow0065.image (residualApplyFast g) = minimumRow0065).card = 2`. If this is slow,
   the per-unit cost estimate in §1 is wrong and the key layer becomes mandatory for the
   stabilizer too.
3. **Probe B (decisive for the fallback):** `decide`
   `(orbitKeys minimumRow0065).card = 200` with the §3 definitions. Success here means the
   file can close under the key design alone, whatever happens to Plan A.
4. **The composition law** on `AdmissibleCoordinate`: define `mul` by the recovered-parameter
   formula; `decide` the two parameter-level facts (`scale`-multiplicativity, `shift`
   composition) over 400 pairs; prove `apply (g*h) = apply g ∘ apply h` symbolically. This
   is Plan A's riskiest mathematics; if the recovered-parameter formula turns ugly, stop and
   ship the key design.
5. Group instance on the 20-element factor (`decide` axioms), product group, `MulAction` on
   `Idx25` via the factored compatibility proof of §2(c), pointwise action on `Finset`.
6. Orbit–stabilizer bridging to `Finset` cards; the five sizes.
7. Non-conjugacy decides (via keys), equal-or-disjoint, disjoint-union card 1600.
8. Separate exhaustion theorem against the residual-cover machinery.

Steps 1–3 are one short session once a build window opens and settle every open cost
question in this review before any scaffolding is written. Do not run them now — the shared
build tree is in use.

## File-level nits

- `Q25ResidualMinimumOrbits.lean:1` imports `Q25ExactMinimumRows.All`, needed only for the
  five `card_legalOrbitSet_*` transports (lines 26-54). If the orbit theorems move to their
  own module, keep that heavy import out of it.
- Drop `maxHeartbeats 300000000` once the decides are cheap; a huge budget in a "small
  kernel-reduced certificates" file (its own docstring, line 9) undermines the claim.
