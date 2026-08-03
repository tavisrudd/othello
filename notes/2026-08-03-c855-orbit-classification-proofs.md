# C855 — structural proofs for the `A₅` point orbits, the balanced switching class, the orbital pentagon, the trace-annihilator family, and the odd `3+3'` splitting

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream)
**Task:** C855 — Paper I Lean referee-artifact remediation, structural-mathematics stream.
**Scope:** mathematics only. No Lean file was edited, no Lean build, generator, gate, or manifest was
run, and no manuscript text was changed. Lean sources were read read-only.

Targets, all carried in `notes/2026-08-02-c855-paper-i-assertion-inventory.md` as human-proof-only or
full-gap rows.

| target | manuscript location | verdict |
|--------|---------------------|---------|
| 1 | `prop:a5-point-orbits` structural derivation | **proved**, Brauer-free and Dye-free |
| 2 | `thm:orientation-two-graph`, switching-class uniqueness | **proved**, with the torsor sharpened |
| 3 | `thm:orientation-two-graph`, orbital connectivity and constant-sign exclusion | **proved** |
| 4 | `thm:orientation-two-graph`, tensor decomposition, trace annihilator, invariant cubic | **proved**, with one manuscript line to repair |
| 5 | `ClassicalOddA5ThreePlusThreeSplitting` | **proved**, in a form strictly stronger than the interface |

Standing conventions: `A` is the Clebsch six-arc with the manuscript's parity-check columns over
`F₁₁`; `G = Stab(A) ≅ A₅`; `V` is the three-dimensional `F₁₁`-module on which `G` acts through its
determinant-one lift; `Ω = 𝒞(F₁₁)` is the twelve-point conic orbit; `Ξ = Ω/R` the six axes; `L⁻` the
fibre-odd lattice; `B` the golden conference matrix. Inputs used as established:
`notes/2026-08-03-c855-dye-orbit-uniqueness.md` (normal form, polarity, `A₅` stabilizer) and
`notes/2026-08-03-c855-support-bipartition-proofs.md` (concurrence, the five triangles, the monomial
extension `MAut(C) ≅ C₁₀ × A₅`).

Mathlib constraint honoured throughout: **no modular character theory is used anywhere below.** Where
the manuscript invokes Brauer characters, the replacement is a submodule argument; where it invokes
ordinary characters, either the character computation is retained (Mathlib has ordinary character
theory) or an equivalent rank computation is offered as a cheaper formal route.

---

## Target 1 — the structural derivation behind `prop:a5-point-orbits`

The manuscript proves the orbit lengths `6, 10, 12, 15, 30, 30, 30` from Maschke plus Brauer
characters, elementwise fixed-point counts, a subgroup fixed-point table, and orbit–stabilizer, and
then identifies four of the orbits by citing Dye. Both the Brauer step and all four Dye
identifications can be removed.

### 1.1 Absolute irreducibility without modular characters

**Lemma 1.1 (no faithful two-dimensional representation in odd characteristic).** Let `K` be a field
with `char K ≠ 2`. Then `GL₂(K)` contains no subgroup isomorphic to `A₅`.

*Proof.* Suppose `W ≤ GL₂(K)` with `W ≅ A₅`. Since `A₅` is perfect and `det` lands in an abelian
group, `W ≤ SL₂(K)`. An element `t ∈ SL₂(K)` with `t² = 1` and `char K ≠ 2` is diagonalizable with
eigenvalues in `{±1}` and determinant one, so its eigenvalue multiset is `{1,1}` or `{−1,−1}`, i.e.
`t = ±I`. Hence `SL₂(K)` has exactly one involution, and it is central. But `A₅` has fifteen
involutions. ∎

This is the elementary substitute for "`SL₂(5)` is a nonsplit central extension"; it needs no Schur
multiplier and no character theory.

**Proposition 1.2 (absolute irreducibility).** Let `K` be a field with `char K ∤ 60`, and let `V` be a
faithful three-dimensional `K`-representation of `A₅`. Then `V ⊗ K̄` is irreducible; in particular
`A₅` fixes no point of `P(V ⊗ K̄)`, hence none of `P(V)`.

*Proof.* Since `char K ∤ |A₅|`, Maschke's theorem makes `V ⊗ K̄` semisimple, so it is a direct sum of
irreducibles of dimensions summing to three: either `1+1+1`, or `1+2`, or `3`. `A₅` is perfect, so
every one-dimensional constituent is trivial. In the `1+1+1` case the representation is trivial, which
is not faithful. In the `1+2` case the kernel of the two-dimensional constituent equals the kernel of
`V ⊗ K̄`, which is trivial, so the two-dimensional constituent is faithful, contradicting Lemma 1.1
(`char K ≠ 2` because `2 ∣ 60`). So `V ⊗ K̄` is irreducible. A projective fixed point of the induced
`PGL(V)`-action is a one-dimensional submodule of `V`, which would survive base change. ∎

Applied with `K = F₁₁`: the determinant-one lift of `G ≤ PGL₃(F₁₁)` is a faithful three-dimensional
representation of `A₅` (the lift exists and is a group isomorphism because `gcd(3, 10) = 1`, which is
the splitting argument of the monomial extension, `notes/2026-08-03-c855-support-bipartition-proofs.md`
Proposition 8). So `V` is absolutely irreducible and `G` fixes no point of `PG(2,11)`.

**What this replaces.** The manuscript's sentence "*5 is a square in `F₁₁`, so the two ordinary
ternary icosahedral characters are realized over `F₁₁`, and the ordinary and Brauer characters agree
on every class*", together with the inner-product computation `⟨χ,χ⟩ = 1`, is deleted. Nothing about
`√5 ∈ F₁₁` is needed for irreducibility; that hypothesis is needed later, for the *eigenvalue* counts,
and it is cleaner to see it there.

**Alternative route (Burnside/enveloping algebra), recorded but not preferred.** Absolute
irreducibility is equivalent to the `K`-span of the sixty matrices being all of `M₃(K)`. That is a
rank-nine check on a `60 × 9` matrix over `F₁₁` and is `decide`-scale; it is corroborated in the
replay script. It is the cheaper formal route if Lemma 1.1 turns out to be awkward, but it is
`q`-specific and unenlightening, so the submodule argument is the one the manuscript should carry.

### 1.2 Elementwise fixed-point counts

Throughout, `g ∈ SL(V)`, `V` three-dimensional over `F₁₁`, `g` of prime order `ℓ ∈ {2,3,5}`. In each
case `ℓ ≠ 11`, so `g` is semisimple: its minimal polynomial divides `T^ℓ − 1`, which is separable.

**Involutions.** Eigenvalues lie in `{±1}` with product `1`; `g ≠ 1` forces the multiset `{1,−1,−1}`.
So the eigenspaces have dimensions one and two, and `g` fixes `1 + (11+1) = 13` projective points.

**Order three.** `T³ − 1` over `F₁₁` factors as `(T−1)(T²+T+1)` with the quadratic irreducible, since
`3 ∤ 10` so `1` is the only cube root of unity in `F₁₁`. The eigenvalue multiset is Frobenius-stable
and has product one; it cannot be `{1,1,1}` (that would make `g` unipotent of order three in
characteristic eleven, hence trivial), so it is `{1, ω, ω̄}` with `ω ∈ F₁₂₁ \ F₁₁`. Exactly one
eigenline is rational: `g` fixes **one** projective point.

**Order five.** `5 ∣ 10`, so `T⁵ − 1` splits with distinct roots over `F₁₁` and `g` is diagonalizable
over `F₁₁` with fifth-root-of-unity eigenvalues `ζ^{a}, ζ^{b}, ζ^{c}`, `a+b+c ≡ 0 (mod 5)`. In `A₅`
every element of order five is conjugate to its inverse — the conjugating permutation `(2 5)(3 4)`
inverts `(1 2 3 4 5)` and is even — so the exponent multiset `{a,b,c} ⊂ Z/5` is stable under
negation. A three-element negation-stable multiset in `Z/5` must contain the unique negation-fixed
point `0`, and the remaining two are `{a, −a}`. If `a = 0` then `g = 1`. Hence the eigenvalues are
`{1, ζ, ζ^{−1}}` with `ζ ≠ 1`, pairwise distinct: `g` fixes **three** projective points, and the
inverting involution fixes the `ζ⁰`-line and exchanges the other two.

Note that the exponent argument simultaneously delivers the `D₅` row of the subgroup table, which the
manuscript asserts separately ("*a `D₅` retains one of the three `C₅` eigenlines and exchanges the
other two*").

### 1.3 Burnside count: seven orbits, independently

Cauchy–Frobenius on the `133` points of `PG(2,11)`:
```
#orbits = (1/60)·[ 133 + 15·13 + 20·1 + 24·3 ] = (133 + 195 + 20 + 72)/60 = 420/60 = 7.
```
This is a **free upgrade** over the manuscript, which infers "seven orbits" only after the mass
bookkeeping closes. Burnside gives the orbit *count* from the elementwise data alone, so the
subsequent mass argument becomes a consistency check with an independent handle rather than the sole
support for the decomposition. It is also the cheapest thing in the whole proposition to formalize.

### 1.4 The subgroup fixed-point table

Only the following subgroup facts are used, and each is derived rather than tabulated.

- **`C₅`** (six conjugates, `|N(C₅)| = |D₅| = 10`): three fixed points, by 1.2.
- **`D₅`**: one fixed point — the `ζ⁰`-eigenline — by the inversion action in 1.2. The other two
  `C₅`-eigenlines therefore have exact stabilizer `C₅`, since a subgroup strictly between `C₅` and
  `A₅` is `D₅` (see 1.6 for the classification-free version of this step) and `D₅` exchanges them,
  while `A₅` fixes nothing by 1.2.
- **`C₃`** (ten conjugates): one fixed point. Its normalizer `S₃` permutes the `⟨s⟩`-eigenlines, and
  the rational one is unique, hence `S₃`-fixed. So `S₃` also has exactly one fixed point, and **no
  point has exact stabilizer `C₃`**.
- **`V₄`** (five conjugates): the restriction `V|_{V₄}` is a sum of three characters of `V₄` (all
  eigenvalues are `±1` and the three involutions commute and are semisimple). Each involution has
  trace `1 − 1 − 1 = −1`. If the trivial character occurred, the other two would have to sum to `−2`
  at all three involutions, i.e. both would be `−1` on all three involutions; no character of `V₄`
  does that. So `V|_{V₄}` is the sum of the three *distinct nontrivial* characters, giving exactly
  three `V₄`-invariant lines and hence exactly three fixed points.
- **`A₄ = V₄ ⋊ C₃`**: the three-cycle permutes the three involutions cyclically, hence the three
  characters, hence the three lines, cyclically. `A₄` has **no** fixed point, and the three
  `V₄`-lines have exact stabilizer `V₄`.

Distinctness across conjugates is uniform: if two distinct conjugates of `H ∈ {C₅, S₃, V₄}` fixed a
common point, its stabilizer would contain `⟨H, H'⟩`. For `C₅` two distinct Sylow five-subgroups
generate `A₅`; for `S₃` and `V₄` maximality of `S₃` and of `A₄ ⊃ V₄` (with `A₄` containing a unique
`V₄`) forces the same. In every case `A₅` would fix a point, contradicting 1.2.

Hence, exactly as in the manuscript's last table row:
```
6 points with stabilizer D₅      (6 conjugates × 1)
12 points with stabilizer C₅     (6 × 3 − 6)
10 points with stabilizer S₃     (10 × 1)
15 points with stabilizer V₄     (5 × 3)
```
giving orbits of lengths `60/10 = 6`, `60/5 = 12`, `60/6 = 10`, `60/4 = 15` — each a single orbit
because the point set of a fixed exact stabilizer type is `G`-stable and its size equals the orbit
length.

**Exact-`C₂` points.** An involution `t` lies in two `D₅`, two `S₃`, and one `V₄` (incidence counts
`6·5/15 = 2`, `10·3/15 = 2`, `5·3/15 = 1`). Of its thirteen fixed points, `2 + 2 + 3 = 7` already
appear above, and no point with exact stabilizer `C₅` is fixed by `t` (that would enlarge its
stabilizer past `C₅`). The remaining six have exact stabilizer `⟨t⟩`. Over fifteen involutions this is
`90` points, i.e. three orbits of length `30`. Totals: `6 + 10 + 12 + 15 + 90 = 133`, and
`4 + 3 = 7` orbits, matching 1.3. Both closures — the point mass and the orbit count — now hold
simultaneously, so neither carries the argument alone.

### 1.5 Identifying the four small orbits without Dye

The manuscript cites Dye's Theorems 2–3, Corollary 1 and Theorem 6(v) for the identification of the
orbits of lengths `6, 10, 15, 12`. Given the orbit-length list, all four identifications are forced by
cardinality alone, because the available lengths are `6, 10, 12, 15, 30`:

- `A` is `G`-stable of size six; the only representation of `6` as a sum of available lengths is `6`.
  So `A` **is** the six-orbit, and each arc vertex has stabilizer `D₅`.
- The ten Brianchon points are `G`-stable of size ten (distinctness is Proposition 3 of
  `notes/2026-08-03-c855-support-bipartition-proofs.md`); `10` is the only decomposition.
- The fifteen vertices of the five self-polar triangles are `G`-stable of size fifteen — they are
  exactly the fifteen simple intersections of disjoint chords, again Proposition 3 there, so they are
  distinct — and `15` admits no other decomposition (`6+9`, `10+5`, `12+3` are unavailable).
- The uncovered locus `𝒞(F₁₁)` is `G`-stable of size twelve, and `12` is the only decomposition
  (there is a single six-orbit, so `6+6` is impossible).

This closes the inventory row "*the manuscript's structural derivation … is not formalized; … the
identification of that action with the classical icosahedral one uses Dye*" **without Dye**, and it
independently reproves the step used in Target 4 Step 1 of the companion note (transitivity on the
twelve deep-hole directions).

### 1.6 Removing the subgroup classification

The manuscript says "*the standard subgroup classification of `A₅` shows that these exhaust the
possible nontrivial point stabilizers*". The classification can be avoided: the argument above never
needs the full lattice, only

1. a subgroup strictly containing `C₅` is `D₅` or `A₅` — because its order is `5k ∣ 60` with
   `k ∈ {2,3,4,12}`, and `A₅` has no subgroup of order `15` or `20` (index `4` and `3` embed `A₅` in
   `S₄` and `S₃`, impossible by order), so the proper case is order ten;
2. `S₃` and `A₄` are maximal, and `A₄` contains a unique `V₄` — both standard and elementary;
3. the closure of the count: `6 + 10 + 12 + 15 + 90 = 133` exhausts the plane, so no further
   stabilizer type can occur.

Item 3 is what actually replaces the exhaustiveness clause: once the masses close and the orbit
count matches Burnside, no unlisted stabilizer type has any points left to stabilize.

### 1.7 Formalization shape

Lean statement: fix the concrete `G ≤ SL₃(ZMod 11)` of order sixty already present in the development
(`Q11A5PointOrbits`). Quantification: the structural lemmas 1.1–1.2 should be stated for an arbitrary
field and an arbitrary faithful three-dimensional representation of `alternatingGroup (Fin 5)`, since
they are reusable and characteristic-generic; 1.2–1.6 are `q = 11` statements.

Remaining finite pieces and their sizes:

| piece | size |
|---|---|
| element orders and fixed-point counts over the sixty group elements | `60 × 133` incidences, `decide`-scale |
| Burnside sum | one arithmetic identity |
| conjugate counts for `C₅, S₃, V₄, A₄, D₅` | subgroup enumeration inside a sixty-element group |
| identification of the four small orbits | already available as `Q11A5PointOrbits` terminals |
| optional Burnside/enveloping-algebra route | rank of a `60 × 9` matrix over `ZMod 11` |

Mathlib inputs: `Maschke` (present), `alternatingGroup.isSimpleGroup_five` and perfectness (present),
`Equiv.Perm` machinery, and the orbit–stabilizer/Cauchy–Frobenius layer (`MulAction.card_orbit_mul_…`
and the Burnside lemma, present). No Brauer theory, no character table, no `√5` hypothesis.

**Verdict: proved.** Brauer characters are eliminated, all four Dye identifications are eliminated,
and the exhaustiveness clause is replaced by a Burnside count that the manuscript did not have.

### 1.8 What the argument says at other orders (`ej`)

The elementwise counts are the only `q`-dependent input, and they depend only on residues:

```
involution:      1 + (q+1)                     always
order three:     3 if q ≡ 1 (mod 3), else 1
order five:      3 if q ≡ 1 (mod 5), 1 if q ≡ −1 (mod 5)
```
so for `A₅ ≤ PGL₃(q)` with `char q ∤ 60`, Burnside gives
```
#orbits = ( q²+q+1 + 15(q+2) + 20·f₃ + 24·f₅ ) / 60.
```
At `q = 11` this is `7`. Integrality of the right-hand side across residue classes is a cheap
sanity check on the whole table, and the formula shows exactly where order eleven is special: it is
the smallest odd order at which both `f₃ = 1` and `f₅ = 3`, which is what produces the twelve-point
`C₅`-orbit that the paper needs. Recorded as a remark, not a manuscript claim.

---
## Target 2 — uniqueness of the balanced switching class

The manuscript's clause is: "*In the gauge `B₀ᵢ = 1`, the five equations `(B²)₀ᵢ = 0` say that the
positive edges on the remaining five vertices form a `2`-regular graph, hence a pentagon. The twelve
labeled pentagons form one class up to relabeling, proving uniqueness.*" The steps are right; what is
missing is the converse direction (that every pentagon *does* give `B² = 5I`), the transitivity
statement that "one class up to relabeling" abbreviates, and the interaction between the gauge and
relabellings that move the base vertex.

### 2.1 Setting

Let `ℬ` be the set of *balanced Seidel matrices* on the index set `{0,…,5}`: symmetric integer
matrices `B` with `Bᵢᵢ = 0`, `Bᵢⱼ ∈ {±1}` for `i ≠ j`, and `B² = 5I`. Two are equivalent if related by
a *switching* `B ↦ DBD` with `D = diag(±1)` and a *relabelling* `B ↦ PBPᵀ` with `P` a permutation
matrix. The group generated is `{±1}⁶/{±1} ⋊ S₆` of order `2⁵·720`.

**Theorem 2.2 (uniqueness).** `ℬ` is a single orbit under switching and relabelling; there are exactly
`12` switching classes inside `ℬ` on the labelled vertex set; `S₆` permutes them transitively with
point stabilizer of order `60`; and negation `B ↦ −B` is a fixed-point-free involution on those twelve
classes, so the six *unordered* pairs `{[B], [−B]}` carry a transitive `S₆`-action with point
stabilizer of order `120`.

### 2.3 Proof

*Gauge.* Given `B ∈ ℬ`, switch by `D₀ = 1`, `Dᵢ = B₀ᵢ`; the result satisfies `B₀ᵢ = +1` for all
`i ≠ 0`, and the gauge representative is unique in its switching class, because `D` is determined once
`D₀` is fixed and `D`, `−D` act identically.

*Pentagon.* In the gauge, for `i ≠ 0`,
```
0 = (B²)₀ᵢ = Σ_{k ∉ {0,i}} B₀ₖBₖᵢ = Σ_{k ∈ {1,…,5}\{i}} Bₖᵢ,
```
a sum of four terms `±1`, so exactly two are `+1`. Thus the graph `P` of positive edges on
`{1,…,5}` is `2`-regular, hence a disjoint union of cycles of length at least three covering five
vertices: a single five-cycle.

*Converse.* Let `P` be any pentagon on `{1,…,5}` and let `B` be the gauge matrix it defines. Then
`(B²)ᵢᵢ = Σ_{k≠i} Bᵢₖ² = 5`. For `i ≠ j` both nonzero, the `k = 0` term contributes
`Bᵢ₀B₀ⱼ = 1`, and the remaining three `k ∈ {1,…,5}\{i,j}` contribute `+1` exactly when `k` is
`P`-adjacent to both or to neither of `i, j`. If `i, j` are `P`-adjacent, the three remaining vertices
consist of one adjacent to neither and two adjacent to exactly one; if `i, j` are `P`-nonadjacent, one
is adjacent to both and two are adjacent to exactly one. Either way the three contributions are
`+1, −1, −1`, summing to `−1`, and `(B²)ᵢⱼ = 1 − 1 = 0`. So `B ∈ ℬ`. Hence **gauge classes at `0`
correspond bijectively to pentagons on `{1,…,5}`**, of which there are `5!/(5·2) = 12`.

*Transitivity.* The subgroup of `S₆` fixing `0` is `S₅` on `{1,…,5}`; it preserves the gauge and acts
on pentagons as on five-cycles, transitively, with stabilizer the dihedral automorphism group of the
pentagon, of order ten (`120/10 = 12` ✓). Given `B, B' ∈ ℬ`, gauge both at `0` and apply a permutation
of `{1,…,5}` carrying one pentagon to the other. So `ℬ` is one orbit, and since the whole gauge
analysis is base-point-free, no separate treatment of relabellings moving `0` is needed.

*Stabilizers.* `S₆` acts on the twelve switching classes; transitivity was just shown, so the
stabilizer of a class has order `720/12 = 60`. Negation acts on gauge classes by `D₀ = 1`,
`Dᵢ = −1`, which fixes the row and column through `0` and negates every other entry: the pentagon is
replaced by its complement, the pentagram, which is a different pentagon. So negation is
fixed-point-free on the twelve classes and pairs them into six, on which `S₆` acts transitively with
stabilizer of order `120`. ∎

### 2.4 What this buys the manuscript

The stabilizer computation is not decoration: it is exactly the frame-symmetry claim of
`cor:orientation-cubic-geometry`, obtained here from the two-graph side rather than from the
five-matching normalizer table. The order-sixty stabilizer of a switching class is the *oriented*
symmetry group `A₅` (it preserves every triangle product `cᵢⱼₖ = BᵢⱼBⱼₖBₖᵢ`, since triangle products
are switching invariants), and the order-one-hundred-twenty stabilizer of the unordered pair
`{[B], [−B]}` is `S₅`, its odd coset reversing every `cᵢⱼₖ`. The manuscript proves `Aut ≅ S₅` by a
matchings normalizer argument plus a six-cubic-line bound; the switching-class count gives the same
two groups with no geometry at all, and it explains the index two: **the orientation torsor is
exactly the pentagon/pentagram dichotomy.**

A second free consequence: the six unordered pairs are in canonical bijection with the six axes `Ξ`
(both are `S₆`-sets of size six with point stabilizer `S₅`), and the twelve classes with the twelve
points of `Ω` (both `A₅`-sets — indeed `S₆`-sets — of size twelve with stabilizer of order sixty
inside `S₆`, i.e. `C₅` inside `A₅`). The manuscript asserts a unique `A₅`-equivariant identification of
coordinate positions with `Ξ`; this exhibits its source.

### 2.5 Formalization shape

Statement over `Matrix (Fin 6) (Fin 6) ℤ`:

```
theorem balanced_seidel_unique
    (B B' : Matrix (Fin 6) (Fin 6) ℤ)
    (hB : IsBalancedSeidel B) (hB' : IsBalancedSeidel B') :
    ∃ (σ : Equiv.Perm (Fin 6)) (d : Fin 6 → ℤ), (∀ i, d i = 1 ∨ d i = -1) ∧
      B' = (fun i j => d i * B (σ i) (σ j) * d j)
```
with `IsBalancedSeidel B := B.IsSymm ∧ (∀ i, B i i = 0) ∧ (∀ i ≠ j, B i j = 1 ∨ B i j = -1) ∧
B * B = (5 : ℤ) • 1`.

Remaining finite pieces:

| piece | size |
|---|---|
| brute-force over all sign patterns (`decide` fallback) | `2¹⁵ = 32768` matrices, `6×6` products — feasible but heavy for kernel reduction |
| **preferred:** gauge first, then decide over the residual sign patterns | `2¹⁰ = 1024` patterns on `{1,…,5}` |
| `S₅`-transitivity on the twelve pentagons | `120 × 12` incidences |
| stabilizer orders `60` and `120` | orbit–stabilizer on the twelve-element set |

The gauge step and the `2`-regular-to-pentagon step are the only genuinely structural parts; both are
short. The recommendation is to prove the gauge lemma by hand and discharge the residual `1024`-case
statement with `decide`, rather than attacking `2¹⁵` directly.

**Verdict: proved**, with the converse direction supplied (missing from the manuscript) and the
torsor identification sharpened.

---

## Target 3 — connectivity of the five-valent orbital and exclusion of constant sign patterns

### 3.1 Connectivity

Model `Ω = A₅/H` with `H = ⟨r⟩ ≅ C₅`, base point `ω₀ = H`. The suborbits of `H` on `Ω` have lengths
`1, 1, 5, 5`; let `Γ` be the orbital graph of one five-suborbit, with `Γ(ω₀) = HaH/H` for a
representative `a`, and recall (manuscript, and independently checkable) that the orbital is
self-paired, so `Γ` is an undirected `5`-regular graph on twelve vertices.

**Proposition 3.2.** `Γ` is connected.

*Proof.* The connected component of `ω₀` is `K·ω₀` where `K = ⟨H, a⟩`: it is contained in that orbit
because every edge from `gω₀` goes to `gaʰω₀` for some `h ∈ H`, and it contains it because `K` is
generated by `H` and `a`, and `Γ` is symmetric. Now `H ≤ K`, so `|K·ω₀| = |K|/|H| = |K|/5`. The
component contains `ω₀` and its five neighbours, so `|K|/5 ≥ 6`, i.e. `|K| ≥ 30`. A subgroup of `A₅`
of order `30` would have index two, hence be normal, contradicting simplicity; so `|K| = 60` and
`K·ω₀ = Ω`. ∎

This is strictly cheaper than the manuscript's route ("*a representative of the five-point suborbit
lies outside `D₅`, and `D₅` is the only proper subgroup of `A₅` strictly containing `C₅`*"): it needs
no subgroup classification, only Lagrange plus the absence of an index-two subgroup.

### 3.3 The two sign values

Gauge as in the manuscript: fix `ω₀` over axis `0`, and choose the lift over each other axis to be the
unique point of `Γ(ω₀)` above it (unique because the projection of the five-suborbit to the five other
axes is an equivariant map of regular `H`-sets, hence a bijection). Then `B₀ᵢ = +1`. The stabilizer
`H` of `ω₀` fixes axis `0`, permutes the other five axes regularly, and permutes the chosen lifts
accordingly; so, labelling the five axes by `Z/5` along that regular action, `Bᵢⱼ` for `i, j ≠ 0`
depends only on `j − i mod 5`. With symmetry this leaves exactly two values,
```
s = B_{i,i+1}   (pentagon sides),        d = B_{i,i+2}   (pentagon diagonals).
```

**Proposition 3.4 (the two signs differ).** `s ≠ d`.

*Proof.* Suppose `s = d = ε`, and let `X = {ω₀, …, ω₅}` be the six chosen lifts, so that `Ω = X ⊔ RX`.

*Case `ε = +1`.* Every chosen lift is `Γ`-adjacent to every other chosen lift, and `Γ` is `5`-regular,
so `Γ(ωₐ) = X \ {ωₐ}` exactly. By `R`-equivariance of `Γ` (`Γ(Rω) = RΓ(ω)`), the same holds inside
`RX`. Hence `Γ` is the disjoint union of two copies of `K₆`, contradicting Proposition 3.2.

*Case `ε = −1`.* Every chosen lift is adjacent to `Rω_b` for every `b ≠ a`, and by regularity that
exhausts `Γ(ωₐ)`; also `ωₐ` is not adjacent to `Rωₐ`, which is the other `H_{ωₐ}`-fixed point and so
lies in a suborbit of length one. Hence `Γ` is `K_{6,6}` minus the antipodal perfect matching, which
is connected and bipartite with parts `X` and `RX`. A connected bipartite graph has a unique
bipartition, so the unordered partition `{X, RX}` is preserved by every automorphism of `Γ`, in
particular by `A₅`. That gives a homomorphism `A₅ → S₂`, necessarily trivial because `A₅` is perfect,
so `A₅` preserves the six-element set `X`, contradicting transitivity of `A₅` on the twelve points of
`Ω`. ∎

The two cases share a shape worth stating once in the manuscript: **a constant sign pattern makes
`{X, RX}` a graph-canonical partition of `Ω` into two halves, and `A₅` is perfect and transitive on
`Ω`, so no such partition exists.** In the `+` branch the canonicity is "components", in the `−`
branch "bipartition classes"; connectivity is what makes the second one canonical, so Proposition 3.2
is used in both branches.

### 3.5 Closing the loop to the pentagon gauge

With `s ≠ d`, after exchanging the two orbitals if necessary (which negates `B`, per the manuscript's
`A' = AR`) we may take `s = +1, d = −1`; the positive edges on `{1,…,5}` are then the pentagon sides
in the `Z/5` labelling. This is exactly the gauge of Target 2, and Target 2's converse computation
gives `B² = 5I` **without a separate verification**. The manuscript verifies `B² = 5I` on the displayed
six-by-six matrix; the pentagon converse proves it for the gauge as such, which is the statement the
later argument actually uses.

If instead `s = −1, d = +1`, the positive edges form the pentagram, which is a pentagon after the
relabelling `i ↦ 2i mod 5`; so both branches land in the single class of Target 2.

### 3.6 Formalization shape

`Ω` should be the concrete twelve-element `A₅`-set already in `PaperIOrientationCover`. Statements:

```
theorem fiveValentOrbital_connected : (orbitalGraph fiveSuborbit).Connected
theorem signedOrbitalMatrix_not_constant : ¬ (∀ i j, i ≠ j → i ≠ 0 → j ≠ 0 → B i j = B 1 2)
```

Remaining finite pieces: the suborbit lengths `1,1,5,5` and self-pairing (`60 × 12` incidences,
already terminal as `PaperIOrientationCover.fiveOrbitals_selfPaired` and
`...fiveOrbital_one_mem_each_other_fiber`); connectivity is then either the structural Proposition 3.2
or a direct twelve-vertex reachability `decide`. The structural route needs only "`A₅` has no subgroup
of index two", available from `alternatingGroup.isSimpleGroup_five`. The perfectness input in
Proposition 3.4 is the same lemma.

**Verdict: proved**, with connectivity obtained without the subgroup classification and the two sign
branches unified.

---
## Target 4 — tensor decomposition, the trace-annihilator family, and the invariant cubic

Work over `E = Q(√5)`, with `V₊, V₋` the two three-dimensional golden eigenspaces of `B` in
`L⁻ ⊗ E` (Target 5 proves they are the two nonisomorphic icosahedral representations `V₃, V₃'`).
Write `V₄, V₅` for the four- and five-dimensional irreducible representations of `A₅`.

### 4.1 The tensor decomposition

`Hom_E(V₊, V₋) ≅ V₊^* ⊗ V₋ ≅ V₃ ⊗ V₃'` because the icosahedral representations are self-dual. Its
character on the classes `1, 2, 3, 5A, 5B` is the product
```
(3, −1, 0, φ, φ̄) · (3, −1, 0, φ̄, φ) = (9, 1, 0, φφ̄, φ̄φ) = (9, 1, 0, −1, −1) = χ₄ + χ₅,
```
using `φφ̄ = −1`. So `Hom_E(V₊, V₋) ≅ V₄ ⊕ V₅`, which is the manuscript's "standard tensor-product
rule". This is *ordinary* character theory over a field of characteristic zero, so it is inside
Mathlib's reach; nothing modular is involved.

### 4.2 The five-dimensional summand is the augmentation module

The permutation action of `A₅` on the six axes `Ξ = A₅/D₅` is two-transitive (`|A₅| = 60 = 6·5·2`, and
`A₅ ≅ PSL₂(5)` acts two-transitively on the projective line over `F₅`), so its permutation character
is `1 + χ₅` and the augmentation quotient `Q⁶/Q1 ⊗ E` is irreducible, isomorphic to `V₅`. The map
`x ↦ Φ_x = U(t₋)ᵀ D_x U(t₊)` is `A₅`-equivariant and kills `1` (its value at `x = 1` is
`U(t₋)ᵀU(t₊) = 0`), so it descends to `Q⁶/Q1 ⊗ E` and is nonzero; by Schur it is injective, and its
image is the `V₅`-summand of `Hom_E(V₊, V₋)`.

**Formal shortcut.** Both facts can be replaced by one rank computation: the `6 × 9` matrix of
`x ↦ Φ_x` has rank five with kernel `Q1`. That is exact linear algebra over `E` and needs no
character theory at all. Recommended for the Lean route; the character statement is what the
manuscript should keep for readability.

### 4.3 The trace annihilator is four-dimensional

The trace pairing `Hom_E(V₋, V₊) × Hom_E(V₊, V₋) → E`, `⟨Ψ, Φ⟩ = tr(ΨΦ)`, is the standard perfect
duality between `Hom(W, U)` and `Hom(U, W)`, and it is `A₅`-invariant because the actions are by
conjugation-type transport. Hence
```
Λ := { Ψ ∈ Hom_E(V₋, V₊) : tr(Ψ Φ_x) = 0 for all x }
```
is a submodule of dimension `9 − 5 = 4`, and by 4.1 (applied to `Hom_E(V₋, V₊) ≅ V₄ ⊕ V₅`) it is the
`V₄`-summand. The manuscript's phrase "*solving the six coefficient equations `tr(ΨΦ_x) = 0` gives
the four-dimensional solution space*" is better replaced by **exhibit and count**: the displayed
family `Ψ_z` is manifestly linear and injective in `z ∈ E⁴`, and one checks `tr(Ψ_z Φ_x) ≡ 0`
identically; since `dim Λ = 4` is already forced, the family *is* `Λ`. That removes the only
"solve a linear system by hand" step from the proof.

### 4.4 The determinant is an invariant cubic, and why

`det : Λ → E` is a cubic form. Its `A₅`-invariance is not stated in the manuscript and deserves one
line: `A₅` acts on `Hom_E(V₋, V₊)` by `Ψ ↦ ρ₊(g) Ψ ρ₋(g)^{-1}`, so
`det(g·Ψ) = det ρ₊(g) · det Ψ · det ρ₋(g)^{-1}`, and `det ρ_±(g) = 1` because `A₅` is perfect and
`det` is a homomorphism to an abelian group. **Perfectness is the whole reason the determinant is an
invariant**, and it is the same input as in Lemma 1.1.

Nonvanishing: `det(Ψ_z) = a(z) z₁z₂ + b(z) z₀z₃`, and at `z = (1,0,0,1)` this is `b(1,0,0,1) =
(√5−5)/2 + (√5−3)/2 = √5 − 4 ≠ 0`.

### 4.5 One-dimensionality of the invariant cubics, and the Clebsch identification

With `χ₄ = (4, 0, 1, −1, −1)` on `1, 2, 3, 5A, 5B`, the symmetric-cube character
`χ_{Sym³}(g) = (χ(g)³ + 3χ(g)χ(g²) + 2χ(g³))/6` evaluates to `(20, 0, 2, 0, 0)`, so
```
dim (Sym³ V₄^*)^{A₅} = (1·20 + 15·0 + 20·2 + 12·0 + 12·0)/60 = 60/60 = 1.
```
The Clebsch diagonal cubic `Σ z_i³ = 0` on `{Σ z_i = 0} ⊂ E⁵` is a nonzero `A₅`-invariant cubic on a
four-dimensional module isomorphic to `V₄`, and `V₄` is the unique four-dimensional irreducible, so
`Λ ≅ V₄` and any `A₅`-isomorphism carries `det|Λ` to a nonzero scalar multiple of `Σ z_i³`. Hence
`det|Λ = 0` **is** the Clebsch diagonal cubic surface.

**Formal shortcut, again.** Instead of the symmetric-cube character one can compute the fixed space of
two generators acting on the twenty-dimensional space `Sym³` of cubics: that is the rank of a
`40 × 20` rational matrix, and it returns dimension one. This avoids character theory entirely and is
the recommended Lean route; the replay script does both.

### 4.6 Smoothness

At a singular point of `Σ z_i³ = 0` inside `{Σ z_i = 0}`, Lagrange gives `3z_i² = λ` for all `i`. If
`λ = 0` then `z = 0`; otherwise all `z_i²` are equal and nonzero, so `z_i = ±c` with `c ≠ 0`, and
`Σ z_i = 0` requires five signs to sum to zero, impossible since five is odd and the characteristic is
zero. So the surface is smooth. The manuscript's argument is correct as written; the only addition is
that the `λ = 0` branch should be named.

Smoothness then feeds the Hassett–Tschinkel determinantal equivalence, which remains an external
transfer — but the manuscript independently proves the node frame and its ordinary-node type, so
that transfer is a convenience, not a load-bearing step.

### 4.7 Formalization shape

Base ring: `E = Q(√5)`, available as `Algebra.adjoin` or as `ℚ⟮√5⟯`/`Polynomial.SplittingField`; the
concrete route is `Matrix (Fin 3) (Fin 3) K` for `K` a field with a chosen `s : K`, `s^2 = 5`,
`2 ≠ 0`, so every identity below is a polynomial identity in `s` modulo `s² − 5` and needs no field
theory. Statements:

```
theorem traceAnnihilator_eq_psiFamily : Λ = Set.range Ψ            -- 4.3
theorem det_psi_eq                 : det (Ψ z) = a z * z 1 * z 2 + b z * z 0 * z 3
theorem det_psi_ne_zero            : det (Ψ (1,0,0,1)) = s - 4 ≠ 0
theorem invariantCubics_rank_one   : finrank K (invariantCubics V₄) = 1
```

Remaining finite pieces:

| piece | size |
|---|---|
| `B U(t±) = ±s U(t±)` and `U(t₋)ᵀU(t₊) = 0` | `6×3` and `3×3` identities in `Z[s]/(s²−5)` |
| `det Φ_x = −C(x)` | one `3×3` determinant expansion, twenty cubic coefficients |
| `tr(Ψ_z Φ_x) ≡ 0` | six coefficient identities in `Z[s]/(s²−5)` |
| rank of `x ↦ Φ_x` equal to five | `6 × 9` rank over `E` |
| invariant-cubic dimension | rank of a `40 × 20` rational matrix |
| determinant pencil `e₆ − e₄ + 5e₂ − 125 − 2C` | already terminal in `PaperIOrientationDeterminant` |

Nothing here needs Brauer characters; the two places that use ordinary characters both have an exact
linear-algebra substitute, so the entire target can be formalized with no character theory at all if
that is preferred.

**Verdict: proved.** One manuscript line should change ("solving the six coefficient equations" →
"the displayed family lies in `Λ`, which has dimension four, hence exhausts it"), one line should be
added (perfectness gives `det ρ_±(g) = 1`, hence invariance of the determinant), and the `λ = 0`
branch of the smoothness Lagrange computation should be named.

---

## Target 5 — the classical odd `3 + 3'` splitting interface

`ClassicalOddA5ThreePlusThreeSplitting` in `lean/RelativeConicArcs/PaperIOrientationCommutant.lean`
is the single proposition-valued parameter
```
schur_galois_descent : rationalCommutant oddA5ActionMatrix ⊆ adjoinGoldenOperator,
```
i.e. every rational matrix commuting with the sixty displayed signed coset matrices is
`a·I + b·B`. The reverse inclusion is already proved there from equivariance, so discharging this
field turns `oddModule_rationalCommutant_eq_adjoin_B` into an unconditional theorem.

### 5.1 Identifying the module

`Ω = A₅/C₅` and the deck involution `R` is right multiplication by any `t ∈ D₅ \ C₅`, which is
well defined because `N(C₅) = D₅`. Hence, as `A₅`-modules over any field `K`,
```
K[Ω] = Ind_{C₅}^{A₅} 1 = Ind_{D₅}^{A₅}( Ind_{C₅}^{D₅} 1 ) = Ind_{D₅}^{A₅}(1) ⊕ Ind_{D₅}^{A₅}(ε),
```
with `ε` the sign character of `D₅/C₅`, and the two summands are exactly the `R`-eigenspaces. So
```
L⁻ ⊗ K ≅ Ind_{D₅}^{A₅}(ε),   of dimension 6.
```
Over `Q`, Frobenius reciprocity gives the decomposition immediately:
`⟨Ind ε, χ⟩ = ⟨ε, Res_{D₅} χ⟩`, and with `|D₅| = 10` (five rotations, five reflections),
```
χ₁ : (1 + 4·1 + 5·(−1))/10 = 0
χ₃ : (3 + 2 + 5)/10 = 1          χ₃' : likewise 1
χ₄ : (4 − 4 + 0)/10 = 0
χ₅ : (5 + 0 − 5)/10 = 0
```
so `L⁻ ⊗ E ≅ V₃ ⊕ V₃'`, the manuscript's claim. This is the character-theoretic route; the next
subsection gives a route that needs no characters at all and works in almost every characteristic.

### 5.2 A character-free splitting, valid in every characteristic other than two and five

Let `K` be a field with `char K ∉ {2, 5}` containing a root `s` of `s² = 5`, and let `M = L⁻ ⊗ K` with
the `A₅`-action and the equivariant operator `B` satisfying `B² = 5·1` (a finite identity on the
displayed integral matrices).

**(a) The eigenspace split.** `s ≠ −s` because `2s ≠ 0`, so `M = W₊ ⊕ W₋` with `W_± = ker(B ∓ s)`,
and both are `A₅`-submodules because `B` is equivariant. `tr B = 0` (zero diagonal), so
`s(dim W₊ − dim W₋) = 0` and `dim W₊ = dim W₋ = 3`.

**(b) `M` has no invariants.** An `A₅`-invariant function on `Ω` is constant because `A₅` is
transitive on `Ω`, and constants are fibre-*even*, so the only fibre-odd invariant is zero. This is
characteristic-free and needs no averaging, hence no Maschke.

**(c) `W_±` are absolutely irreducible.** Suppose `W₊ ⊗ K̄` has a proper nonzero submodule `N`.
If `dim N = 1`, then `A₅` acts on `N` by a character, which is trivial since `A₅` is perfect; that
contradicts (b). If `dim N = 2`, then `A₅ → GL(N)` has kernel `1` or `A₅` by simplicity; the kernel
cannot be `A₅` (that would put `N` in the invariants, contradicting (b)), so `A₅ ↪ GL₂(K̄)`,
contradicting Lemma 1.1 since `char ≠ 2`. The same argument applies to `W₋`. Note that **Maschke is
not used**, so this covers characteristic three as well.

**(d) `W₊ ≇ W₋`.** If they were isomorphic then `tr(g|W₊) = tr(g|W₋)` for all `g`, whence
`tr(gB) = s·(tr(g|W₊) − tr(g|W₋)) = 0` for all `g`. But for `r` of order five the displayed integral
matrices give `tr(rB) = ±5`, which is nonzero whenever `char K ≠ 5`. One integer trace computation
therefore separates the two summands in every characteristic other than five. (Over `Q` the value
`±5` is `√5·(φ − φ̄)`, which is why five is the only obstruction.)

**(e) The commutant.** By (c), (d) and Schur, `End_{K A₅}(M) = K × K`, acting as the two eigenvalue
scalars, i.e. `End_{K A₅}(M) = K[B]`, a two-dimensional commutative algebra.

**(f) Descent to `Q`.** `End_{Q A₅}(L⁻ ⊗ Q) ⊗_Q E = End_{E A₅}(L⁻ ⊗ E) = E[B]`, by flat base change
for `Hom` of finite-dimensional modules; taking dimensions, `End_{Q A₅}(L⁻ ⊗ Q)` is two-dimensional
over `Q`, and it contains `Q + QB`, which is already two-dimensional because `B ∉ Q·I`. Hence
```
End_{Q A₅}(L⁻ ⊗ Q) = Q[B] ≅ Q(√5).
```
That is precisely `rationalCommutant oddA5ActionMatrix ⊆ adjoinGoldenOperator`, the interface field.
Note that only a dimension count is needed — no Hilbert 90 and no Galois cohomology, contrary to what
"Galois descent" in the manuscript suggests. Galois descent would be needed to descend the *module*
`V₃`, which the argument never does.

**(g) The integral statement.** For `T = aI + bB` preserving `L⁻` in the displayed basis: the `(0,0)`
entry of `T` is `a`, so `a ∈ Z`; the `(0,1)` entry is `b·B₀₁ = ±b`, so `b ∈ Z`. Hence
`End_{Z A₅}(L⁻) = Z[B] ≅ Z[√5]`, as the manuscript states.

### 5.3 What is stronger than the interface

- The interface is stated over `Q`; 5.2 proves the splitting and the commutant over **every** field of
  characteristic other than two and five that contains `√5`, including characteristic three, where
  Maschke fails and the manuscript's semisimplicity-based phrasing does not apply.
- The manuscript's "Schur's lemma followed by Galois descent" is reduced to Schur plus a dimension
  count.
- The nonisomorphism of the two summands, which is the load-bearing hypothesis, is reduced to the
  single integer identity `tr(rB) = ±5`.
- No Brauer characters and, on the route of 5.2, no characters at all.

### 5.4 Formalization shape

```
theorem oddModule_summands_absolutelyIrreducible : ...
theorem oddModule_summands_not_isomorphic (h : (5 : K) ≠ 0) : ...
theorem classicalOddA5ThreePlusThreeSplitting : ClassicalOddA5ThreePlusThreeSplitting
```

Remaining finite pieces and sizes:

| piece | size |
|---|---|
| `B² = 5I` and `tr B = 0` | already terminal (`PaperIOrientationPentagon.signedOrbitalMatrix_sq`) |
| equivariance of `B` | already terminal (`integralGoldenOperator_commutes_oddA5Action`, sixty `6×6` products) |
| `tr(rB) = ±5` for one order-five `r` | one `6×6` product trace |
| no invariants | rank of a `(60·6) × 6` integer matrix, or the one-line transitivity argument |
| eigenspace dimensions | rank of `B ∓ s` over `K`, two `6×6` ranks |

Mathlib inputs: `Module.End.isSimpleModule…`/`bijective_or_eq_zero` for Schur (present),
`alternatingGroup.isSimpleGroup_five` and perfectness (present), and finite-dimensional `Hom` base
change (present). Lemma 1.1 is shared with Target 1, which is a reason to state it as a standalone
lemma about `A₅` and `GL₂` early in the file.

**Verdict: proved**, strictly more generally than the interface requires. Discharging the interface
needs no new external input.

---

## Mystery ledger

- *Why is the orientation torsor twelve-fold and not two-fold?* Settled. The balanced switching
  classes on a labelled six-set are in bijection with the twelve labelled pentagons; `S₆` is
  transitive on them with stabilizer of order sixty, and negation pairs them into six. So the
  "unordered orientation torsor" of the theorem is the `S₆`-set `S₆/A₅`, the sign being pentagon
  versus pentagram. The coincidence `|Ω| = 12` is therefore not a coincidence: both are `S₆`-sets of
  size twelve with the same stabilizer.
- *Why does `A₅` and not `S₅` preserve the orientation?* Settled, and it is the same mechanism as the
  golden-root dichotomy of `notes/2026-08-03-c855-dye-orbit-uniqueness.md`: an index-two kernel of a
  parameter map onto a two-element set. There the set was `{φ, φ̄}`; here it is
  `{[B], [−B]}`. Whether these two occurrences of the same index-two phenomenon are literally the same
  map was not checked. Evidence gap: one equivariant comparison between the golden-root parameter and
  the pentagon/pentagram sign. No owning successor; recorded as a descriptive question.
- *Why `tr(rB) = ±5` exactly?* Settled: it equals `√5·(φ − φ̄) = 5`, the discriminant again. The sign
  depends on which orbital is called `A` and on which of the two classes of order-five elements `r`
  lies in, so only `|tr(rB)| = 5` is invariant. The replay script sees `−5` for its own choices.
- *Does `prop:a5-point-orbits` really need `5` to be a square in `F₁₁`?* Settled: not for
  irreducibility, which holds for every field of characteristic not dividing sixty. It is needed only
  so that an element of order five has three *rational* eigenlines, which is the `q ≡ 1 (mod 5)`
  branch of the general formula in 1.8. The manuscript currently attaches the square hypothesis to
  the irreducibility step, which is where it does not belong.
- *Is characteristic three genuinely covered by the odd splitting?* Settled in the affirmative: the
  proof in 5.2 never averages, so it survives the failure of Maschke; the only excluded
  characteristics are two (where `±√5` collide and Lemma 1.1 fails) and five (where `√5 = 0`). Not
  used by Paper I, but it means the Lean statement need not carry a `char ∤ 60` hypothesis.
- *Why does the invariant-cubic space have dimension exactly one?* Settled by the symmetric-cube
  character, and independently by a rational rank computation. What is not explained structurally is
  why the determinant of the trace-annihilator family lands on the Clebsch cubic rather than on some
  other invariant — but with a one-dimensional invariant space there is nothing else to land on, so
  the question dissolves. No gap.
- *Open:* whether the six unordered pentagon/pentagram pairs can be matched with the six axes `Ξ`
  canonically, rather than merely abstractly as `S₆`-sets. Both are `S₆`-sets of size six with point
  stabilizer `S₅`, and there are two `S₆`-classes of such sets (the natural one and its outer twist),
  so the identification is canonical up to the outer automorphism of `S₆` and no further. Evidence
  gap: which of the two classes occurs was not determined. Owning successor: none allocated; it is a
  labelling question, and the manuscript's "unique `A₅`-equivariant identification" is unaffected
  because `A₅` has no outer twist of this kind.

## Computational corroboration (not the deliverable)

`notes/2026-08-03-c855-orbit-classification-checks.py` checks every finite clause above, in the five
parts named in its docstring; all sixty-six checks pass.

```
uv run --with sympy python3 notes/2026-08-03-c855-orbit-classification-checks.py
```

It reports: the projective stabilizer of the six columns has order sixty with determinant-one lifts
and element orders `1, 2, 3, 5` in counts `1, 15, 20, 24`; the sixty matrices span all of
`M₃(F₁₁)`; the projective fixed-point counts are `133, 13, 1, 3`; the Cauchy–Frobenius sum is `420`,
giving seven orbits; the orbit lengths are `6, 10, 12, 15, 30, 30, 30`; the subgroup table is
`D₅ (6, 1)`, `C₅ (6, 3)`, `S₃ (10, 1)`, `C₃ (10, 1)`, `V₄ (5, 3)`, `A₄ (5, 0)`, `C₂ (15, 13)`; the
exact-stabilizer census is `{D₅ : 6, C₅ : 12, S₃ : 10, V₄ : 15, C₂ : 90}`; the arc, the ten Brianchon
points, the fifteen triangle vertices and the twelve-point uncovered locus are exactly the orbits of
lengths six, ten, fifteen and twelve; there are `384` balanced Seidel matrices in `12` switching
classes of size `32`, matching the twelve labelled pentagons, with `S₆` transitive and stabilizer
orders `60` and `120`; the five-valent orbital on `A₅/C₅` has suborbit lengths `1,1,5,5`, is
self-paired and connected, the deck involution is fixed-point free and equivariant, and the derived
gauge matrix is a pentagon with `B² = 5I` and is switching-and-relabelling equivalent to the
manuscript's displayed matrix; `B U(t_±) = ±√5 U(t_±)`, `U(t₋)ᵀU(t₊) = 0`, `det Φ_x = −C(x)`, the
determinant pencil identity, `tr(Ψ_z Φ_x) ≡ 0` with a four-dimensional annihilator,
`det Ψ_z = a z₁z₂ + b z₀z₃` with value `√5 − 4` at `z = (1,0,0,1)`, a one-dimensional space of
invariant cubics on the four-dimensional representation, and equal `F₁₁` point counts `199 = 121 + 77
+ 1` for the determinant cubic and the Clebsch diagonal cubic; and for the fibre-odd module, no
invariants, `tr(rB) = ±5`, three-dimensional golden eigenspaces, and a two-dimensional rational
commutant.

## What this record does not establish

No Lean file was edited, no Lean build, generator, gate, or manifest was run, and no manuscript text
was changed. The five results are paper-grade human proofs and have not been formalized; the
manuscript still carries the Brauer-character step, the four Dye identifications inside
`prop:a5-point-orbits`, the abbreviated switching-class uniqueness clause, and
`ClassicalOddA5ThreePlusThreeSplitting` as a proposition-valued parameter. The Hassett–Tschinkel
determinantal equivalence remains an external transfer and is untouched here.
