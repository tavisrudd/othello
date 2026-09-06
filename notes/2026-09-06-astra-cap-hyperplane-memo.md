# Astra memo: integral secant distributions in higher dimension (2026-09-06)

**Lane**: `relconic`

Source: pasted by the user on 2026-09-06 from a ChatGPT (Astra) session, after Astra read both
`papers/arcs_complete_outside_conic/` and `papers/integral_secant_arcs/`. Verbatim except for
Markdown fencing of displayed mathematics. This is an external research memo, not a repository
result: nothing here is verified until replayed and audited under a C-task. The claim assessment and
routing decision are in the user-facing review of 2026-09-06 and in the C1075–C1078 queue rows.

Assessment at intake (checked by hand, 2026-09-06): Propositions 1, 2, 4, 5 and the three
`PG(4,q)` exclusions are arithmetically correct. Proposition 4 duplicates the envelope `φ_m` already
in the arcs paper's secant-local coverage theorem. The lower constraint `Q(s) ≥ 0` in
Proposition 1 is the classical hyperplane-coverage count; the upper constraint `Q(s) ≤ L` and the
fixed-secant moment transform are the new ingredients. No literature check has been done.

---

## Part 1: overlap assessment against Integral Secant Arcs

Yes, but mostly at the level of methodological overlap, not duplication of the specific suggestions
I made for arcs-complete-outside-conic.

The closest overlap is the idea of replacing a coarse real-valued moment/incidence relaxation by an
integer-sensitive convexity remainder. Integral Secant Arcs explicitly makes that its main
mechanism: it splits exact incidence counts into integer degree distributions, applies sharp
integer convex envelopes, and extracts positive corrections that disappear under the real
relaxation. That is philosophically very close to my suggested "second remainder"

```
6 c_4(A) = N B_n(k,q) + (1/2) Σ_{ℓ, π ⊃ ℓ} (z_{ℓ,π} − s)(z_{ℓ,π} − s − 1),
```

because this is exactly an integer-balancing defect for plane-pencil occupancies. So I would not
present that idea as conceptually new relative to your own body of work. Instead, I would
explicitly say that the higher-dimensional pencil remainder imports the integer-envelope philosophy
of Integral Secant Arcs into the secant-collision setting.

There is also significant overlap with my suggestion to use stability of near equality rather than
only the scalar inequality. Integral Secant Arcs goes much further in that direction: near equality
is converted into bounded modular repair, then geometric/code constraints on the repair support
yield additional excess. So my earlier proposal for arcs-complete-outside-conic (prove that a
positive fraction of second-moment mass occurs away from maximal concurrence, or equivalently
control the distribution of the local defects) is very much the same research pattern. The actual
statistic is different, but the strategy is already developed in your other paper.

The coding-theory broadening is also partly covered. Integral Secant Arcs already treats projective
codes as a genuine application rather than a dictionary: it derives small-weight line-code
obstructions and also translates its incidence theorem to robust nonextendibility of projective
codes. Therefore, if you add my observations `A_4(C) = (q−1) c_4(A)` and the pair-local refinement
`(q−1) T_{ab} = #{weight-4 codewords whose support contains a, b}`, I would position these as a
different coding bridge: weight-four support distribution for cap codes, rather than
line-code/modular-repair machinery. They are complementary, but "coding applications" by itself is
no longer a novelty claim across the two papers.

There is also some overlap with the proposed reconstruction application. The README of Integral
Secant Arcs says that a two-character duality corollary reconstructs an exact complete arc and its
full maximal-secant family from the high-character lines. That is not the same theorem as my
proposed noisy reconstruction criterion `|T △ S| ≤ e`, `2e < q + 1 − C(k,2)`, but it means you
should distinguish the two clearly. The new angle would be robust reconstruction under adversarial
symmetric-difference errors, not reconstruction per se.

What appears not to be covered by Integral Secant Arcs is more substantial:

- the higher-dimensional identity `Σ_{x ∉ A} C(r(x),2) = 3 c_4(A)`;
- the secant-local statistic `T_ℓ` counting coplanar quadruples through a given pair;
- the plane-pencil lower bound `c_4(A) ≥ (1/6) C(k,2) B_n(k,q)`;
- the corresponding local overlap bound `L_ℓ ≥ max{T_ℓ/m, T_ℓ/(T_ℓ+1)}`;
- the resulting `PG(3,q)` complete-cap estimate and its additive constant;
- the interpretation of free pairs as `T_ℓ = 0` and the quantitative continuation beyond the
  free-pair threshold;
- the characteristic-zero line-arrangement obstruction to rank-three matching-design realizability;
- the stronger finite-field evaluation-space equivalence;
- the graph-theoretic reduction of ordinary completion outside a conic to maximal independent sets /
  independent domination;
- the intrinsic-hole defect decomposition and the sharpened discrete defect gap.

Those are genuinely different from the maximal-n-secant degree-distribution problem treated in
Integral Secant Arcs. The latter is fundamentally planar and studies incidences between points and a
selected family of maximal secants; your conic paper studies collisions among ordinary secants
themselves. The appearance of `c_4(A)` in higher dimension is precisely the manifestation of that
difference: two secants collide exactly when their four endpoints have rank at most three.

I would actually exploit the relationship between the papers rather than try to hide it. There is a
clean hierarchy: Integral Secant Arcs = integer defects of point–block degree distributions; Complete
Outside a Conic = integer/local defects of secant–secant collisions; and the proposed
higher-dimensional extension adds integer defects of secant–plane-pencils, i.e. the
coplanar-quadruple distribution. That makes the two projects look like parts of a broader program
rather than overlapping papers.

One thing I would change from my previous recommendation in light of this repository: I would not
make "integer convexity / integer remainder" itself a headline novelty of the conic paper. You
already have a much more developed paper devoted to that principle. Instead, emphasize what is
specific here: exact local secant-collision remainders, equality structures, prescribed holes,
matching-design realizability, and, if you add it, the higher-dimensional `T_ℓ`/`c_4` theory.

The potentially strongest cross-paper synthesis is worth pursuing separately: the machinery in
Integral Secant Arcs may be adaptable to the distribution `{T_ℓ : ℓ ∈ C(A,2)}`. If one can
formulate the `T_ℓ` as one side of an appropriate incidence structure and obtain both their sum and
a second constraint, the integer-envelope machinery could give exactly the sort of "`c_4` is not too
concentrated on a few secants" result identified as the missing ingredient in dimensions `n ≥ 4`.

---

## Part 2: research memo — unconditional bounds through hyperplane excess

Date: 6 September 2026. Status: research draft with proofs and exact checks; not formally verified
and no literature-priority claim.

### Executive finding

The transfer works, but the useful intermediate structure is not the bare secant–plane incidence
system. It is the hyperplane-section distribution through a fixed secant, restricted by
completeness. The resulting argument gives an unconditional, finite-parameter lower and upper bound
on every secant-local collision count `T_ℓ`. Combining its integer feasibility conditions with a
sharp local overlap envelope excludes complete caps of sizes 31, 37, and 97 in `PG(4,7)`,
`PG(4,8)`, and `PG(4,16)`. These are illustrations of the method, not claims to improve the best
published bounds.

This does not establish the previously proposed uniform positive proportion of secants with
`T_ℓ ≥ cq` in every dimension. A formal incidence construction below shows why the direct
plane-pencil degree constraints cannot establish that statement on their own.

### 1. Setup

Let `A` be an ordinary complete `k`-cap in `PG(d,q)`, `d ≥ 3`, `k ≥ 4`. Put
`θ_j = 1 + q + … + q^j` for `j ≥ 0`, `θ_j = 0` for `j < 0`, `N = C(k,2)`, `m = ⌊k/2⌋`, `K = k − 2`.
For `x ∉ A`, let `r(x)` count the secants through `x`. Completeness gives `1 ≤ r(x) ≤ m`. Define
the total overlap loss

```
L = Σ_{x ∉ A} (r(x) − 1) = N(q − 1) − θ_d + k.                                   (1)
```

For `ℓ = ab`, define `T_ℓ = #{coplanar four-subsets of A containing a, b}`. Then

```
T_ℓ = Σ_{x ∈ ℓ \ A} (r(x) − 1),        Σ_ℓ T_ℓ = 6 c_4(A).                        (2)
```

A free pair (Farr–Lisoněk) is exactly a pair with `T_ℓ = 0`.

### 2. What transfers directly, and why it is insufficient

For each plane `π ⊃ ℓ`, put `z_{ℓ,π} = |(A \ {a,b}) ∩ π|`. There are `t = θ_{d−2}` such planes,
and

```
Σ_π z_{ℓ,π} = K,        T_ℓ = Σ_π C(z_{ℓ,π}, 2).                                  (3)
```

Writing `K = at + b`, `0 ≤ b < t`, the balancing lemma yields `T_ℓ ≥ B_pencil := t C(a,2) + ab`
(4), with exact remainder `T_ℓ − B_pencil = (1/2) Σ_π (z_{ℓ,π} − a)(z_{ℓ,π} − a − 1)`. At the
covering scale `k ≍ q^{(d−1)/2}`, for fixed `d ≥ 4`, `K < θ_{d−2}` eventually, so
`B_pencil = 0`. The symmetric-design selected-block theorem cannot be applied with secants as
blocks: higher-dimensional secants can be skew, so intersection cardinalities are not constant.

### 3. Completeness creates an admissible set of hyperplane sizes

Set `e(x) = r(x) − 1` outside `A`, `e(x) = 0` on `A`. Then `e ≥ 0` and `Σ_x e(x) = L`. For a
hyperplane `H`, put `s_H = |A ∩ H|` and

```
Q(s) = N − θ_{d−1} + q C(s,2) − (k − 2) s.                                           (5)
```

**Proposition 1 (hyperplane excess identity).** For every hyperplane,
`Σ_{x ∈ H} e(x) = Q(s_H)`, hence `0 ≤ Q(s_H) ≤ L` (6).

Proof. Extend the secant multiplicity to points of `A`, where it equals `k − 1`. Every secant meets
`H` once, except a secant contained in `H`, which contributes `q + 1`. Exactly `C(s_H,2)` secants
are contained in `H`, so the sum of extended multiplicities over `H` is `N + q C(s_H,2)`. Subtract
the all-one vector and then `(k − 2) 1_A`. Nonnegativity and total mass `L` give both bounds.

Thus the allowed hyperplane sizes lie in `S_L = {0 ≤ s ≤ k : 0 ≤ Q(s) ≤ L}` (7).

### 4. The exact bridge from hyperplanes to `T_ℓ`

Fix `ℓ = ab`; for each hyperplane through `ℓ` write `w_H = |A ∩ H| − 2`. Put `t = θ_{d−2}`,
`R = K θ_{d−3}`, `C_0 = C(K,2) θ_{d−4}`, `D = q^{d−3}`.

**Proposition 2 (secant–hyperplane moments).**

```
#{H ⊃ ℓ} = t,    Σ_{H ⊃ ℓ} w_H = R,    Σ_{H ⊃ ℓ} C(w_H, 2) = C_0 + D T_ℓ.          (8)
```

Proof. Each further cap point lies with `ℓ` in a plane, contained in `θ_{d−3}` hyperplanes. For a
pair `u, v ∈ A \ {a,b}`, the span of `ℓ, u, v` is a plane for exactly `T_ℓ` pairs (contained in
`θ_{d−3}` hyperplanes through `ℓ`) and otherwise a solid (contained in `θ_{d−4}`). The difference
is `q^{d−3}`.

Consequently `T_ℓ = (Σ_{H ⊃ ℓ} C(w_H,2) − C_0) / D` (9).

### 5. An unconditional integer feasibility theorem

Define `Z_L = {s − 2 : s ∈ S_L, s ≥ 2}`. For every secant, the multiplicities
`b_z = #{H ⊃ ℓ : w_H = z}` satisfy

```
b_z ∈ Z_{≥0},    Σ_{z ∈ Z_L} b_z = t,    Σ_{z ∈ Z_L} z b_z = R.                    (10)
```

If this finite integer system is infeasible, no complete cap with the proposed parameters exists.
When feasible, let `P_min`, `P_max` be the extrema of `Σ_z b_z C(z,2)` over (10).

**Theorem 3 (unconditional local bounds).** Every secant satisfies

```
max{0, B_pencil, ⌈(P_min − C_0)/D⌉} ≤ T_ℓ ≤ min{(q−1)(m−1), ⌊(P_max − C_0)/D⌋},   (11)
```

and the system may impose the congruence `Σ_z b_z C(z,2) ≡ C_0 (mod D)` (12).

Closed form: if `a < b` bracket `R/t` with no admissible degree strictly between them, then
`C(z,2) = ((a+b−1) z − ab)/2 + (z−a)(z−b)/2` with nonnegative last term, so

```
T_ℓ ≥ ⌈((a+b−1) R − ab t − 2 C_0) / (2D)⌉.                                          (13)
```

With `τ_0 = ((a+b−1)R − abt − 2C_0)/(2D)`: `2D (T_ℓ − τ_0) = Σ_{H ⊃ ℓ} (w_H − a)(w_H − b)` (14), so
`#{H ⊃ ℓ : w_H ∉ {a,b}} ≤ 2D (T_ℓ − τ_0)/(b − a + 1)` (15), a quantified two-character stability
statement.

### 6. Converting local collision bounds into coverage bounds

Allocate overlap loss to secants by `L_ℓ = Σ_{x ∈ ℓ \ A} (r(x)−1)/r(x)`, so `L = Σ_ℓ L_ℓ`. Write
`T = u(m−1) + v`, `0 ≤ v < m−1`, `F_m(T) = u (m−1)/m + v/(v+1)` (16).

**Proposition 4 (filled overlap envelope).** `L_ℓ ≥ F_m(T_ℓ)` and `L ≥ Σ_ℓ F_m(T_ℓ)` (17).
[Intake note: this is the envelope `φ_m` already in the arcs paper.]

If the lower bound in (11) is `β`, a complete cap must satisfy `N(q−1) − θ_d + k ≥ N F_m(β)` (18).

### 7. Explicit exclusions in dimension four

| `q` | candidate `k` | `L` | admissible sizes `S_L` | `t`  | `R`   |
|----:|--------------:|----:|:----------------------:|-----:|------:|
| 7   | 31            | 20  | {2, 7}                 | 57   | 232   |
| 8   | 37            | 18  | {3, 7}                 | 73   | 315   |
| 16  | 97            | 32  | {4, 9}                 | 273  | 1615  |

For `(d,q,k) = (4,7,31)`: `Q(s) = (7s² − 65s + 130)/2`; `0 ≤ Q ≤ 20` allows only `s = 2, 7`, so
every `w_H ∈ {0, 5}`, but their sum `232` is not divisible by five. For `(4,8,37)`: degrees one or
five, `R − t = 242` not divisible by four. For `(4,16,97)`: degrees two or seven, `R − 2t = 1069` not
divisible by five. Hence

```
t_2(4,7) ≥ 32,    t_2(4,8) ≥ 38,    t_2(4,16) ≥ 98.                                 (19)
```

Even discarding `Q(s) ≤ L`, the one-sided support gaps and (13) force `T_ℓ ≥ 9, 2, 6` respectively
on every secant, and each resulting overlap budget contradicts (18).

### 8. An unconditional upper bound against concentration

**Proposition 5 (plane-fan concentration bound).** For every secant,
`L ≥ 2 T_ℓ + 2 T_ℓ² / (k − 2)` (20).

Proof. Each plane `π ⊃ ℓ` contains a planar arc of size `j = z_π + 2` whose intrinsic overlap loss
is at least `6 C(j,4)/⌊j/2⌋ ≥ (z_π + 1) C(z_π, 2)` (21) (planar secant-moment bound, then parity of
`j`). These planar secant families share only `ℓ`; off `ℓ` their point sets are disjoint, on `ℓ`
their excesses add. Hence `L ≥ (1/2)(Σ_π z_π³ − K)`. With `Σ z_π = K`, `Σ z_π² = K + 2T_ℓ`,
Cauchy–Schwarz gives `Σ z_π³ ≥ (K + 2T_ℓ)²/K`, which proves (20).

For a complete cap, `T_ℓ ≤ U_L := ⌊(√(K² + 2KL) − K)/2⌋` (22) and
`Σ_ℓ T_ℓ² ≤ 6 U_L c_4(A)` (23). Its scale is not automatically `O(N q²)`.

A second restriction: `r(x)² − 1 ≤ L`. An index-`r` point gives `r` paired secants and `2r(r−1)`
cross-secants between their endpoints; each cross-secant has a collision and contributes at least
`1/2` to its allocated loss, and the original `r` secants contribute at least `r − 1`. When `L > 0`
one may replace `m` in (16) by `min{m, ⌊√(L+1)⌋}`.

### 9. What this does and does not prove asymptotically

In dimension three, `T_ℓ ≥ k − q − 3` recovers `k ≥ √2 q + 1/2 + 3/√2 − o(1)`. For fixed `d ≥ 4`
the admissible-support criterion need not force a positive lower bound at every parameter choice.

**A formal countermodel to the direct degree-only argument.** Fix `d ≥ 4`, `q → ∞`, and choose `k`
within a bounded displacement of the first-moment root with `L ≥ 0`, `L ≡ 0 (mod 3)`; then
`L = O(kq) = o(k²) = o(N)`. Take `M = L/3` edge-disjoint copies of `K_4` in `K_k` (a greedy packing
supplies `≥ k(k−1)/72` copies). Declare each four-set a coplanar quadruple with its three
opposite-edge intersections; each of its six secants has exactly one collision, every other secant
none; assign remaining external points multiplicity one. This gives formal data with `c_4 = M`,
`T_ℓ ∈ {0,1}`, `Σ T_ℓ = 6M`, overlap loss exactly `3M = L`, covered-point count exactly `θ_d − k`,
and plane-pencil occupancy rows that fit in the `θ_{d−2}` slots. So the plane-pencil integer sums
and remainders, secant capacities, quartet pairing rule, global collision moments, and scalar
completeness count are all satisfied while only `6M = 2L = o(N)` secants have any collision. This is
not a projective cap construction; its role is to prove that those direct degree constraints cannot
imply that a positive proportion of secants have `T_ℓ ≥ cq`. Additional ambient constraints are
indispensable; Proposition 1 is one.

Actual zero-`c_4` complete caps occur at the perfect-code exceptions: five points in `PG(3,2)` and
eleven points in `PG(4,3)` (Pavese's equality classification). The formulas accommodate both.

### 10. Prescribed holes

If `A` is complete outside a disjoint prescribed set `H` of size `h`, write
`L_0 = N(q−1) − θ_d + k` and let `u ≤ h` be the number of uncovered points. The nonnegative overlap
mass is `L_+ = L_0 + u ≤ L̄ := L_0 + h`. The hyperplane identity remains exact, with
`−|H ∩ H_plane| ≤ Q(s) ≤ L̄` (24); a uniform admissible set replaces `0 ≤ Q(s) ≤ L` by
`−h ≤ Q(s) ≤ L̄`. Fixed-secant moments are unchanged; replace the loss budget in (18), (20), (22)
by `L̄`.

### 11. Relationship to the two papers and evidence boundary

The chain is: completeness → hyperplane excess support → integer moments through each secant →
`T_ℓ` → coverage loss. The balancing and filled-sequence principles are reused from Integral Secant
Arcs; the secant-collision interpretation and planar loss inequality come from the arcs paper. The
additional ingredients are the hyperplane excess support, its fixed-secant moment transform, and the
plane-fan concentration bound. The modular-repair theorems have not been transferred; their
hypotheses concern specific point–line systems and modular exceptional sets.

Astra reports an accompanying standard-library verifier with 2,324 exact scalar checks, the three
displayed exclusions, and geometric identities on eight greedy complete caps over prime fields
2, 3, 5. None of that is in this repository; nothing counts until replayed here.

Sources named by Astra: Farr–Lisoněk, *Large caps with free pairs in dimensions five and six*,
Innovations in Incidence Geometry 4 (2006), 69–88; Pavese, *On 4-general sets in finite projective
spaces*, arXiv:2305.13838, Proposition 3.1, J. Algebraic Combin. 61 (2025),
DOI 10.1007/s10801-025-01383-w.
