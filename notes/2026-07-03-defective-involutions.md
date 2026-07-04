# Defective involutions and bounded-interaction sums — the general theory (2026-07-03)

**Date**: 2026-07-03
**Status**: INTERIM-FINAL — all four backlog tasks (census, bounded-interaction, misère,
A344227 framing) are written with results; remaining polish only. One cut-short item: a
misère-queens n = 9 extension (the n = 8 DAG was ~70k positions — n = 9 likely cheap) was
not attempted; next step would be raising the memo cap in `misere_small.py` and running
`plane queens` to n = 9.
**Scope**: THEORY session. No builds, no solver runs. All computation = Python brute force
in `notes/scripts/2026-07-03-geometry/` (`involution_census.py`, `bounded_interaction.py`,
`misere_small.py`), seconds-to-minutes each, exact full-DAG values on ≤ 20-vertex graphs and
≤ 8×8 boards. Companion notes: [primer](2026-07-02-placement-games-primer.md) (Copying +
Mirror-Obstruction Lemmas), [cgt-laws](2026-07-03-cgt-laws-and-tricks.md) (Theorem S1,
Well-Covered Parity Law, the Lipschitz no-go), [implications](2026-07-02-theory-implications.md)
(Master Lemma, border battle, misère §4), [backlog](2026-07-03-external-review-and-backlog.md)
(this note owns its items: defective graph involutions; bounded-interaction sums; pairing with
bounded defects; the misère separation; A344227 behavior framing).

Status labels as usual: **PROVEN** / **COMPUTED** (exact, stated ranges) /
**TESTED-CONSISTENT** (exhaustive or sampled at stated sizes, no proof) / **CONJECTURE** /
**REFUTED** (with witness).

**Headline items:**

1. **Conjecture D1 does NOT generalize** (§4.4): a 4-vertex graph with an involutive
   automorphism and exactly ONE defect pair has G = 2, and one-defect values grow with size
   (G = 5 seen at 12 vertices). Any proof of queens-D1 must use queen geometry, not the
   pairing structure alone. This redirects the cgt-laws note's "most promising next theorem".
2. **The defect census** (§2–3): on even boards the queen is the ONLY standard piece whose
   obstruction set is nonempty on all three topologies (plane / cylinder / torus), and the
   reason is a one-line linear dependency in (Z₂)² (§1.4). Everything else is mirror-solved
   outright — including two new one-line solutions: **even-torus kings via half-period
   translation** and a uniform "parity dodge" for grid/knight/rook/bishop.
3. **Odd-torus ray pieces are solved exactly** (§2.3): center-steal + vertex-transitivity ⟹
   G = 1 (not just ≥ 1). This PROVES the odd half of torus conjecture T1: the torus sequence
   is `n mod 2` on odd n; only even torus values remain conjectural.
4. **Bounded-interaction impossibility map** (§4): one cross edge between two summands
   shifts G by up to 6 and flips outcome in ~26% of random instances; clique-interface
   "≤ 2 interaction events" structure does not help (worse: shifts to 7); P-preserving,
   simplicial, and dead-zone endpoint hypotheses all REFUTED with small witnesses. What
   survives: pairing-compatibility (Theorem X1), exact absorption, and a state-space
   product factorization (Lemma X2) — the sound content of "bounded interaction" is
   computational, not value-theoretic.
5. **Misère data** (§5): the misère A344227 analog begins `0,0,2,0,3,0,2,3` (n = 1..8, new);
   misère torus queens = exactly `1 − G` for n ≤ 9 with the {0,1} range PROVEN by
   transitivity; F-empty families do NOT have controlled misère outcomes (Q₂ vs Q₄;
   plane vs torus knights at n = 4) — the obstruction taxonomy is a normal-play tool, full stop.

---

## 1. The classification machinery

Fix a graph Γ and an involutive automorphism f. Write `Fix(f) = {v : f(v) = v}`,
`F(f) = {v : f(v) ≠ v and v ~ f(v)}` (the *defect set*), and
`Obs(f) = Fix(f) ∪ F(f)` (the *obstruction set*). The Copying Lemma (primer §2) says: if
`Obs(f) = ∅`, the second player wins (G = 0) by answering v with f(v). The whole game of
this section is computing `Obs` for natural involutions on natural families.

### 1.1 Lemma C (plane point census) — PROVEN

Board `∏ᵢ [0, nᵢ)`, piece with symmetric vector set V, point reflection
`ρ(s) = (n₁−1−s₁, …, n_d−1−s_d)`.

> (i) `Fix(ρ) = {p}` if all nᵢ are odd (p the center), else ∅.
> (ii) `F(ρ)` is the injective image of `{w ∈ V : wᵢ ≡ nᵢ−1 (mod 2) ∀i, |wᵢ| ≤ nᵢ−1}`
> under `w ↦ s = ((n₁−1−w₁)/2, …)`; in particular `|F(ρ)|` equals the number of such w.

*Proof.* `ρ(s) − s = (n₁−1−2s₁, …)`; s attacks ρ(s) iff this vector is in V. The i-th
coordinate ranges over `{nᵢ−1−2sᵢ : 0 ≤ sᵢ < nᵢ}` = the integers of parity `nᵢ−1` in
`[−(nᵢ−1), nᵢ−1]`, each hit exactly once — the map is a bijection onto that box slice. ∎

This is the primer's Mirror-Obstruction Lemma with the counting made explicit.
Consequences: **step pieces** (finite V) have `|F| = O(1)`; **ray pieces**
(`V = {tu : t ≠ 0, u ∈ D}`) have F = a union of at most `|D|` discrete segments of the
lines through the board center — always *thin* (O(n) in an n² board).

### 1.2 Lemma W (wrap census: torus and cylinder) — PROVEN

Torus `∏ᵢ Z_{nᵢ}`, point reflections `ρ_a(s) = a − s` (one per center a — the pool grows
from one map to n^d maps; this is the structural gift of the wrap).

> (i) `|Fix(ρ_a)| = ∏ᵢ φᵢ` where `φᵢ = 1` if nᵢ odd, `2` if nᵢ even and aᵢ even, `0` if
> nᵢ even and aᵢ odd.
> (ii) `s ∈ F(ρ_a) ⟺ a − 2s ≡ v (mod n)` for some `v ∈ V`; for each v the coordinate
> congruence `2sᵢ ≡ aᵢ − vᵢ (mod nᵢ)` has exactly 1 solution when nᵢ is odd, and (2 if
> `aᵢ ≡ vᵢ (mod 2)` else 0) when nᵢ is even.

*Proof.* Elementary congruence arithmetic: 2 is invertible mod odd nᵢ; mod even nᵢ the
image of `s ↦ 2s` is the even residues, each hit twice. ∎

**The doubling law**: on an even torus each parity-compatible defect vector contributes
`2^d` squares (vs ≤ 1 on the plane), but the *range condition* `|wᵢ| ≤ nᵢ−1` disappears
and the center choice a is free. Odd torus: 2 invertible ⟹ every ρ_a has exactly one fixed
point and `F = N[p] ∖ {p}` for ray pieces (rays are closed under the scaling `v ↦ inv(2)·v`)
— the exact Master-Lemma structure, so the center-steal works verbatim (§2.3).

Cylinder (wrap one coordinate): apply Lemma C in the bounded coordinate and Lemma W in the
wrapped one. Verified against brute force for all pieces at n = 4..8
(`involution_census.py`; the census and the formulas agree everywhere).

### 1.3 The dodge criterion — PROVEN

For ray pieces on the even n×n torus, write `D̄ ⊆ Z₂² ∖ {0}` for the set of direction
parity classes `u mod 2` (both (1,1) and (1,−1) map to (1,1)). From Lemma W:

> Defects via direction u exist ⟺ `a mod 2 ∈ {0, ū}`; fixed points exist ⟺ `a ≡ 0 (mod 2)`.
> Hence an obstruction-free point reflection exists ⟺ some nonzero class of Z₂² avoids
> `D̄` — i.e. ⟺ `D̄ ≠ Z₂² ∖ {0}`.

*Proof.* `a − 2s ≡ tu` is coordinate-solvable iff `a ≡ tu (mod 2)`; t even gives `a ≡ 0`,
t odd gives `a ≡ ū`. Choose `a mod 2` outside `{0} ∪ D̄`. ∎

### 1.4 Lemma Q (queen parity-completeness) — PROVEN

> The queen's direction classes are `{(0,1), (1,0), (1,1)}` — ALL THREE nonzero classes of
> (Z₂)². No other standard piece covers all three. Consequently the queen admits no
> obstruction-free reflection on any topology, while rook (`{(0,1),(1,0)}`), bishop
> (`{(1,1)}`), and every step piece admit one on the even torus. Moreover, for even queens
> the minimum obstruction over the natural involution pool is **two maximal attack lines
> (2n squares, each line a clique)** on all three topologies; the topology only selects
> which lines:
>
> | topology | minimizer                | obstruction shape                          |
> |----------|--------------------------|--------------------------------------------|
> | plane    | ρ (the unique center)    | the two long diagonals                     |
> | cylinder | point, `a₂` even         | two wrapped columns, n/2 apart             |
> | torus    | point, `ā` mixed parity  | two parallel wrapped lines, any one class  |
>
> The three nonzero classes of Z₂² are linearly dependent (`(0,1) + (1,0) = (1,1)`):
> dodging rows and columns (a₁, a₂ both odd) FORCES the diagonal class `a₁+a₂ ≡ 0` to fire.
> The queen's hardness under mirrors is this one-line linear-algebra fact.

*Proof.* Direction classes: rows (0,1), columns (1,0), both diagonals (1,1). Coverage +
Lemma 1.3 give non-emptiness. Minimum: choosing `ā` equal to one nonzero class makes
exactly that direction class fire, with t odd only; by Lemma W(ii) each of the (at most
two) directions in the class contributes two wrapped lines when wrapped, and on the plane
the pinned center `ā = (1,1)` fires the two diagonal directions with t odd,
`|t| ≤ n−1`: n squares each. Axis mirrors and transposes are FAT for queens (an axis
image differs by a row/column vector, a transpose image by an anti-diagonal vector — every
off-axis square is a defect); translations (torus, `v ∈ {0, n/2}²`) are fully defective
(v is itself a row, column, or diagonal vector). Computed census confirms the minimum at
n = 4, 6, 8 on all three topologies. ∎

### 1.5 Lemma T (half-period translation) — PROVEN

> On the even n×n torus, `τ_v(s) = s + v` with `v ∈ {0, n/2}² ∖ {0}` is a fixed-point-free
> involutive automorphism for every piece, and `F(τ_v)` is empty iff `v ∉ V (mod n)`, else
> ALL squares. For any step piece of reach < n/2 some such v works ⟹ **G = 0 on the even
> torus**. For queens and rooks every such v is an attack vector (row/column/diagonal) —
> translations give nothing, consistent with Lemma Q.

*Proof.* `τ_v(s) − s = v` for every s, so the defect condition is uniform in s.
Fixed-point-free since v ≠ 0 and 2v ≡ 0. ∎

This is how the census solves **even-torus kings** (v = (n/2, 0) is not a king vector for
n ≥ 4) — the king's plane obstruction (the central 2×2) is an artifact of pinning the
center, not of the king's V.

---

## 2. The census — COMPUTED (n = 4..8 all families, exact) + PROVEN (general n via §1)

`involution_census.py` enumerates the natural involution pool (point reflections, axis
reflections, transposes, half-period translations), filters to graph automorphisms, and
minimizes `|Obs|`. Classes: **EMPTY** (mirror-solved: G = 0 for even boards),
**STEAL** (`Obs = N[p]` for a unique fixed p: center-steal ⟹ G ≥ 1),
**THIN** (O(n) obstruction — the queens-class hard case), **FAT** (Θ(n²) — mirror useless).

### 2.1 Even boards

| piece  | plane                     | cylinder                    | torus                          |
|--------|---------------------------|-----------------------------|--------------------------------|
| grid   | EMPTY via ρ               | EMPTY via point dodge       | EMPTY via point dodge          |
| knight | EMPTY via ρ               | EMPTY via point dodge       | EMPTY via point dodge          |
| king   | THIN: central 2×2 (4)     | THIN: two dominoes (4)      | EMPTY via translation (§1.5)   |
| rook   | EMPTY via ρ               | EMPTY via point dodge       | EMPTY via point dodge          |
| bishop | EMPTY via axis mirror     | EMPTY via point dodge       | EMPTY via point dodge          |
| queen  | THIN: 2 diagonals (2n)    | THIN: 2 columns (2n)        | THIN: 2 wrapped lines (2n)     |

Notes, each cheap but worth having on record:

- **Plane even rooks are mirror-solved by ρ directly** (rook vectors have a zero
  coordinate, never all-odd — Lemma C): the mirror proof is independent of the fixed-length
  proof. Also, the rook graph's automorphism group is huge (`(S_n × S_n) ⋊ Z₂` — any row
  pairing × column pairing), so for even n ANY fixed-point-free row-involution ×
  column-involution has F = ∅: the rook is mirror-solved without any geometry at all.
- **Plane even bishops are mirror-solved by the axis mirror** `φ(r,c) = (r, n−1−c)`:
  `φ(s) − s` is a row vector, never a bishop move, and even n leaves no fixed column —
  `Obs(φ) = ∅`. This *is* the primer's two-isomorphic-components proof, re-read as a
  defective-involution instance with empty obstruction: the taxonomy subsumes it.
- **King, cylinder**: the four defect squares split into two vertically-adjacent dominoes
  on the two special columns (census at n = 6: (2,0),(3,0) and (2,3),(3,3)) — the same
  O(1) budget as the plane but a different shape; the plane kings closure program
  (implications §3.2) should target both shapes at once.
- **The queen row is Lemma Q**: same 2n budget everywhere, different line types. The
  torus/cylinder obstructions are PARALLEL non-crossing cliques; the plane diagonals cross
  (share no square for even n but attack each other at the crossing region). Structural
  consequence in §3.

### 2.2 Odd boards

Plane: every family is STEAL-class via ρ (Lemma C: F = the both-even slice of V = the
center's attack set for ray pieces; empty or O(1) for step pieces) ⟹ **G ≥ 1**, the
classical center-steal (Lemma 2 / Master Lemma — nothing new, now uniformly derived).

Torus, odd n: 2 is invertible, so every ρ_a has exactly ONE fixed point and, for ray
pieces, `Obs = N[p]` exactly (rays are inv(2)-scaling-closed). STEAL applies. For step
pieces the steal is NOT generic: `F = p − inv(2)·V` need not sit inside `N[p]`
(census: odd torus knights at n = 5 happen to satisfy `2V = V (mod 5)` — accidental steal;
at n = 7, `3V ⊄ V` and the best involution is an axis mirror with a fixed row of 7).

### 2.3 Odd-torus ray pieces: solved EXACTLY — PROVEN (new)

> **Theorem O1.** For every odd n and every ray piece (rook, bishop, queen — any direction
> set), the n×n torus game has **G = 1** exactly.

*Proof.* G ≥ 1: play the fixed point p of ρ = ρ_{2p}; the residual is ρ-invariant, its
available set avoids `Obs(ρ) = N[p]`, and no available square is fixed or defective, so
the Copying Lemma makes the mover (now responder) win the residual — the residual is a
P-position. G ≤ 1: the torus is vertex-transitive, so all root options are isomorphic with
a common value g, and `G = mex{g} ≤ 1` (cgt-laws §2.5). ∎

Consequences: **the odd half of Conjecture T1 (`G(torus queens) = n mod 2` for n ≥ 4) is
now a theorem**; only even torus values (computed 0 at n = 4,6,8,10) remain conjectural.
Torus bishops and rooks are now solved for ALL n: odd ⟹ 1 (O1), even ⟹ 0 (census EMPTY +
Copying); for rooks this reproduces `G = n mod 2` (the torus rook graph IS the plane rook
graph — rook lines do not wrap — a consistency anchor with the Well-Covered Parity Law).

### 2.4 Beyond boards — COMPUTED + PROVEN

| graph family        | involution              | Obs                    | value                             |
|---------------------|-------------------------|------------------------|-----------------------------------|
| hypercube Q_d, d≥2  | `x ↦ x+a`, wt(a) ≥ 2    | EMPTY                  | G = 0 (PROVEN); computed d ≤ 4    |
| hypercube Q_1 = K₂  | only wt-1 translations  | FAT (all)              | G = 1                             |
| Kneser K(2k, k)     | complement `A ↦ Aᶜ`     | FAT (all: A ∦ Aᶜ)      | K(6,3) = matching ⟹ G = 0         |
| Petersen K(5,2)     | best: double transposes | fixed vertices (≥ 2)   | G = 1 (COMPUTED)                  |
| circulant, n even   | `ρ_a(x) = a−x`          | see dichotomy below    | e.g. cycles: C₃..C₁₂ = 1,0,0,0,1,0,0,0,1,0 |

- **Hypercube**: `F(τ_a) = {x : x ~ x+a}` is everything if wt(a) = 1, empty otherwise —
  so every Q_d, d ≥ 2 is mirror-solved (G = 0, second player copies across any weight-≥2
  translation). One line. (The value itself is in scope of the Brown et al. Node-Kayles
  nimber-sequences paper — cite as known if used in a paper; the *proof route* via
  defective involutions is the point here.)
- **Circulant dichotomy — PROVEN**: for `Cay(Z_n, S)`, n even: if S ⊆ even residues the
  graph is two disjoint isomorphic circulants ⟹ G = g ⊕ g = 0 (the bishop mechanism);
  otherwise some generator is odd and EVERY point reflection is obstructed (a even ⟹ fixed
  points; a odd ⟹ each odd generator contributes two defect vertices). Connected even
  circulants are therefore never mirror-solved by reflections — but their obstruction is
  THIN (O(|S|)), the queens-class shape. Node-Kayles on cycles (computed above, the
  `n ≡ 3 (mod 4)` pattern) is the 1-D instance and is classical (§6).
- **Odd order without steal**: C₅ has G = 0 — odd "boards" are NOT automatically
  first-player wins once the piece/graph lacks the ray structure (`inv(2)S ≠ S`: the
  defect set of ρ_a is not the fixed point's neighborhood, so the steal argument has no
  purchase). A useful counterweight to the "odd ⟹ N" intuition from ray boards.
- **Kneser complement is maximally defective**: every vertex attacks its image — the
  formal opposite of a mirror. Fat class; nothing from this machinery (K(6,3) collapses
  for the unrelated matching reason).

### 2.5 The general taxonomy

| class | definition                  | what it buys                       | members (even boards)                          |
|-------|-----------------------------|------------------------------------|------------------------------------------------|
| EMPTY | Obs(f) = ∅ for some f       | G = 0 outright (Copying)           | knights, grid, rooks, bishops (all topologies); torus kings; hypercubes d ≥ 2 |
| STEAL | Obs(f) = N[p], p unique fix | G ≥ 1 (steal + Copying); on vertex-transitive graphs G = 1 exactly | all odd ray boards (plane + torus)             |
| THIN  | 0 < |Obs| = O(n) of n²      | Theorem-3-style reduction: wins must route through Obs; the "repairable defect" frontier | even queens (all topologies, 2n on lines); plane/cylinder kings (O(1)); connected even circulants |
| FAT   | |Obs| = Θ(n²) for all f     | nothing                            | Kneser complement; axis mirrors for rook-like pieces; torus translations for queens |

The even-queens problem is the minimal THIN case that resists: O(1)-obstruction THIN
members (kings) are expected to close via finite scar analysis (implications §3.2), and
the 2n-line obstruction is exactly the "border battle" difficulty. The census sharpens
WHERE the hard families live: **thin obstruction + no transitivity + no fixed length**.

---

## 3. What the wrap changes, structurally

The torus collapse (G ∈ {0,1}, conjecturally `n mod 2`) was previously explained by
transitivity alone. The census adds mirror-theoretic structure:

1. **The involution pool explodes**: one legal center on the plane vs n² point reflections
   + translations + offset transposes on the torus. EMPTY solutions for king/bishop/etc.
   exist *only* because of this freedom (the plane's pinned `ā = (1,1)` is the worst
   possible parity for a diagonal-attacking piece; the torus lets you pick `ā` mixed).
2. **The queen is invariant to the freedom** (Lemma Q): 2n obstruction everywhere. What
   changes is the SHAPE — two parallel wrapped cliques instead of two crossing diagonals —
   and the repair environment: the plane's phantom-row obstruction B2a (the pairing-repair
   square of a border intrusion solves to row −1) does not exist on the torus, since there
   is no row −1 to fall off. So the torus queen game has the same defect budget but a
   repairable geometry, and (empirically, n ≤ 10) the defender holds it: even torus G = 0.
3. **The defect lines are cliques in both cases** ⟹ at most one queen ever stands on each
   obstruction line (≤ 2 obstruction events per game, the B1 mechanism verbatim). The
   even-board queen problem on EVERY topology is a bounded-defect-events problem; §4 is
   about whether any general theorem can exploit that. (Answer: not without geometry.)

---

## 4. Bounded-interaction sums — the impossibility map and the survivors

Setting: `Γ = A ⊔ B + E_x`, a disjoint sum plus cross edges; endpoint sets X_A, X_B. k = 0
is Sprague–Grundy XOR. The border battle, the even-queens defect lines (§3.3), and the
scar calculus all need SOME sound statement for small k. The cgt-laws note §2.2 already
killed raw Lipschitz laws (one edge inside a 9-vertex graph moves G by 5). New results
(`bounded_interaction.py`, seeded, exact Grundy throughout):

### 4.1 One cross edge is already unbounded-looking — COMPUTED

Random A, B on 4–6 vertices each (p = 0.4), one uniform cross edge, per-size samples:

| experiment                          | shift histogram `|G_joined − G_A⊕G_B|`          | outcome flips | max shift |
|-------------------------------------|--------------------------------------------------|---------------|-----------|
| one cross edge (4500 samples)       | 0: 2329, 1: 769, 2: 879, 3: 400, 4: 31, 5: 80, 6: 12 | 1194/4500     | 6         |
| pendant special case A = K₁ (4800)  | 0: 712, 1: 1232, 2: 1749, 3: 676, 4: 247, 5: 182, 6: 2 | —             | 6         |
| clique-interface complete cross (4500) | 0: 1376, 1: 1135, 2: 761, 3: 668, 4: 280, 5: 223, 6: 56, 7: 1 | 1595/4500     | 7         |

- The **minimal outcome flip is trivial and tiny — PROVEN**: A = B = two isolated vertices
  (G = 0 each); one cross edge makes `K₂ ⊔ 2K₁`, G = 1. Four vertices, one edge.
- The **pendant row** is the fully-reduced form of "one cross edge" (a cross edge with
  |A| = 1 is exactly pendant addition), and it already realizes shift 6 by 10 vertices —
  the shift grows with size in the sample; no bound `f(k=1)` is plausible. TESTED, not
  proven unbounded; but the burden is now firmly on any boundedness claim.
- **The "≤ k interaction events" hypothesis alone is dead**: with X_A, X_B cliques and a
  complete bipartite interface, at most one vertex of each side's interface is ever played
  and the FIRST interface move disentangles the position completely (everything after it
  is an exact disjoint sum) — the tightest possible event bound short of k = 0. The
  histogram is *wider* than the unstructured case (max 7, flips 35%). Event-counting
  hypotheses do not bound values. COMPUTED.

### 4.2 Endpoint-condition hypotheses — all REFUTED

Each candidate "the cross edges only touch harmless squares" hypothesis, tested for
outcome preservation under a single cross edge (60k-trial random fields over graphs on
3–6 vertices per side):

| hypothesis on endpoints u ∈ A, v ∈ B                      | verdict                                             |
|-----------------------------------------------------------|------------------------------------------------------|
| P-preserving: `G(A−u) = G(A)`, `G(B−v) = G(B)`             | REFUTED — flip witness at 5+5 vertices (gA=3, gB=3, gJ=5) |
| simplicial (closed neighborhood a clique) on both sides    | REFUTED — flip witness at 4+5; shifts up to 6 persist |
| dead zone: all A-endpoints inside one closed nbhd N_A[w]   | REFUTED — flip witness at 5+5 (gA=3, gB=3, gJ=6)      |

Reading: *local* softness of the endpoints — in value terms, in clique terms, or in
coverability terms — licenses nothing. Adjacency is symmetric (cgt-laws §1.1 remark), and
one live cross edge re-times the whole sum: the opponent can use the interaction as a
tempo move whose cost is paid on the other board. Any sound hypothesis must control the
strategy, not the squares.

### 4.3 What survives — PROVEN

1. **Theorem X1 (pairing-compatible interaction).** Let π_A, π_B be closed pairings
   (Theorem S1) of A and B. If for every vertex v the cross-neighborhood of the pair,
   `xN(v) ∪ xN(πv)`, is π-invariant on the other side, then `π_A ∪ π_B` is a closed
   pairing of Γ and **G(Γ) = 0** — outcome preserved for ANY number of cross edges.
   *Proof*: S1(a) holds (pairs stay within sides, cross edges join sides); S1(b): the
   joint deleted set `(N_Γ[v] ∪ N_Γ[πv]) ∩ avail` splits into a same-side part
   (π-invariant, S1 on the side) and a cross part (π-invariant by hypothesis); unions of
   π-invariant sets are π-invariant. Apply S1. ∎
   The 4500 m=0 symmetric-double samples of §4.4 (all G = 0) instantiate it. This is the
   *only* value-sound bounded-interaction statement found, and it is exactly "the
   interaction respects the symmetry" — i.e. the k > 0 theory collapses back into the
   k = 0-with-symmetry theory. The queens border fails its hypothesis at B2a/B2b (no
   closed pairing of the border arms is cross-compatible with τ; the phantom row is the
   obstruction) — consistent with the border battle being genuinely open.
2. **Absorption (trivial but exact).** If the cross-edge endpoints have no same-side
   neighbors outside the endpoint set, the interface is a union of connected components of
   Γ and `G(Γ) = G(A′) ⊕ G(B′) ⊕ G(C)` exactly (C the interface component, A′/B′ the
   stripped sides). The correction is a GAME value, not a bounded number — the correct
   general expectation for any future statement.
3. **Lemma X2 (interface product factorization).** Every reachable position of Γ is a pair
   `(S_A, S_B)` of side-availability sets, and a move at a ∈ S_A maps
   `(S_A, S_B) ↦ (S_A ∖ N_A[a], S_B ∖ xN(a))` with `xN(a) = ∅` unless a ∈ X_A. Hence the
   game DAG embeds in `R_A × R_B`, where R_A is the closure of {A} under the deletion
   operators of A plus the ≤ |X_B| cross-deletion operators (and symmetrically) — for
   small interfaces, barely larger than each side's own DAG. If moreover the interface is
   clique-complete (X_A, X_B cliques, complete cross), the first interface move ends the
   coupling and everything below it is exact XOR. *Proof*: immediate induction; cross
   edges are the only inter-side adjacencies. ∎
   This is the sound content of "bounded interaction": **not a value formula but a
   state-space collapse** — the joint game costs (product of sides), not
   (exponential in the union). It is also precisely the shape that makes the queens
   border battle *finite-per-n* (B1 bounds the interface plays at 2), and the shape a
   future R_n analysis should exploit computationally.

### 4.4 Pairing with bounded defects: Conjecture D1 does NOT generalize — REFUTED

The cgt-laws note §6 nominated **D1** (ρ-symmetric even-board queens position with exactly
one live diagonal pair ⟹ G ≤ 1; tested-consistent over all reachable symmetric positions
at n ≤ 8) as the most promising next theorem, hoping it was an instance of a general
"one-defect pairing" law. It is not:

> **General model.** A *symmetric double with m defects* is a graph on 2k vertices with an
> involutive automorphism ρ swapping two k-vertex sides (side edges mirrored, cross pairs
> in ρ-couples) whose defect set F(ρ) consists of exactly m pairs `{v, ρv}` with `v ~ ρv`.
> This abstracts "ρ-symmetric position with m live self-mirroring pairs".
>
> **REFUTED: m = 1 does not imply G ≤ 1.** Exhaustive at k = 2 (4 vertices): the diamond
> `K₄ − e` — vertices L = {0,1}, R = {2,3}, ρ = (02)(13), edges 0−1, 2−3 (mirror),
> 0−3, 1−2 (cross couple), 0−2 (the single defect) — has **G = 2**. At k = 3 (6 vertices,
> exhaustive) the maximum reaches **G = 3** (witness edges: 0−1, 3−4, 0−4, 1−3, 0−5, 2−3 +
> defect 1−4; ρ = (03)(14)(25); independently re-verified). Sampled at k = 5, 6:
> maxima **G = 5** at both m = 1 and m = 2 — the one-defect value grows with size.
> Sanity: every m = 0 instance in the exhaustive + sampled fields has G = 0 (Copying), as
> it must.

| k (per side) | m=0 max G | m=1 max G | m=2 max G | m=3 max G | method     |
|--------------|-----------|-----------|-----------|-----------|------------|
| 2            | 0         | 2         | 1         | —         | exhaustive |
| 3            | 0         | 3         | 3         | 2         | exhaustive |
| 5            | 0         | 5         | 5         | 5         | sampled    |
| 6            | 0         | 5         | 5         | 5         | sampled    |

Consequences, all load-bearing for the program:

- **Queens-D1, if true, is a fact about queen geometry** (the defect pair lies on a shared
  attack line whose deletion pattern is line-structured), not about symmetric positions
  with one defect. A D1 proof attempt should start from what the diamond witness LACKS:
  in queens, the defect pair's joint neighborhood is a union of full lines and the
  post-strike residual retains large symmetric structure; in the diamond, one defect move
  annihilates nearly everything asymmetrically.
- **The defect-budget hierarchy is not graph-generic at ANY budget** — m = 1 is already
  unbounded-looking. The n ≤ 8 queens data (`d=1 ⟹ G ≤ 1`, `d=2` reaching only 3) is
  therefore *evidence of queen-specific structure*, which raises rather than lowers its
  theorem value.
- Together with §4.1–4.2 this completes a clean impossibility map: **every purely
  combinatorial "small interaction ⟹ small value change" hypothesis tested fails at
  ≤ 12 vertices; the only survivors carry symmetry (X1) or are exact decompositions
  (absorption, X2).** For the border battle this predicts: no generic scar lemma will
  close it; the counting/potential argument must be about queen lines.

---

## 5. Misère separation, stated precisely

### 5.1 What breaks and why — PROVEN

The Copying Lemma's conclusion is "the copier makes the last move" — under misère rules
that is the LOSING condition, and the strategy does not flip into a first-player win
either (the copier is the second player by construction; declining to copy forfeits the
invariant). So every EMPTY-class result in §2 says NOTHING about misère play. Similarly
the steal (Lemma 2/O1 route) proves the wrong parity. This is implications §4 made
family-wide: the entire obstruction taxonomy is a normal-play instrument.

### 5.2 What survives — PROVEN

1. **Misère Well-Covered Parity Law.** If Γ is well-covered with parameter m (every
   maximal independent set has size m), the misère value is `G⁻ = (m+1) mod 2` and the
   misère outcome is the exact flip of normal play. *Proof*: the cgt-laws §3.1 induction
   verbatim — every position has fixed remaining length, single option value, terminal
   `G⁻ = 1`. ∎ Rooks: misère first player wins iff n is EVEN (computed `G⁻ = 0,1,0,1,0`
   at n = 1..5, matching).
2. **Transitivity (option-isomorphism) is convention-free.** All torus root options are
   isomorphic ⟹ `G⁻(torus) = mex{g⁻} ∈ {0,1}` for every n and every piece — same one-line
   proof as normal play. COMPUTED instance: misère torus queens `G⁻ = 1 − G` exactly for
   n = 1..9 (see table).
3. Lemma C/W/Q etc. are statements about GRAPHS and remain true; only their game
   consequences change convention.

### 5.3 F-emptiness does NOT control misère outcomes — REFUTED (by computation)

The natural salvage hope — "on mirror-solved (F-empty) families the misère outcome is at
least determined/uniform" — is false in both directions:

- Hypercubes (all F-empty, all normal G = 0): `G⁻(Q₂) = G⁻(Q₃) = 1` (first wins misère)
  but `G⁻(Q₄) = 0` (second wins BOTH conventions).
- Knights n = 4 (F-empty): plane `G⁻ = 1`, torus `G⁻ = 0` — same piece, same size, both
  mirror-solved in normal play, opposite misère outcomes.
- So misère outcomes on F-empty boards are genuinely position-specific; no obstruction-set
  statement can decide them. COMPUTED, minimal witnesses stated.

### 5.4 The misère A344227 analog — COMPUTED (new data, n = 1..8)

`G⁻` = misère Grundy value (mex recursion, terminal = 1; `G⁻ = 0 ⟺` mover loses the
single game — no additivity is claimed or used):

| n              | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|----------------|---|---|---|---|---|---|---|---|
| queens G (A344227) | 1 | 1 | 2 | 1 | 3 | 1 | 2 | 3 |
| queens G⁻ (new)    | 0 | 0 | 2 | 0 | 3 | 0 | 2 | 3 |

Observed pattern (n ≤ 8): `G⁻ = G` whenever `G ≥ 2`, and `G = 1 ⟺ G⁻ = 0` — i.e. plane
queens look **tame-shaped** so far (values agree except for the 0↔1 swap; the misère
outcome so far is simply flipped where normal G ≤ 1 and identical where G ≥ 2).
TESTED-CONSISTENT only — and the sibling families warn against extrapolating:

| family (n = 1..) | G sequence        | G⁻ sequence       | tame-shaped?                      |
|------------------|-------------------|-------------------|-----------------------------------|
| plane queens     | 1,1,2,1,3,1,2,3   | 0,0,2,0,3,0,2,3   | yes so far (n ≤ 8)                |
| torus queens     | 1,1,1,0,1,0,1,0,1 | 0,0,0,1,0,1,0,1,0 | yes (= exact flip; {0,1} PROVEN)  |
| plane knights    | 1,0,1,0,1         | 0,1,1,1,0         | NO (n = 3: G = 1, G⁻ = 1)         |
| plane grid       | 1,0,1,0,3         | 0,1,0,1,0         | NO (n = 5: G = 3, G⁻ = 0)         |
| plane kings      | 1,1,1,0,4         | 0,0,0,1,4         | yes so far (n ≤ 5); G(5) = 4 new  |
| plane bishops    | 1,0,2,0,1,0       | 0,1,2,0,1,1       | NO (n = 4: G = G⁻ = 0; n = 5: 1,1)|
| plane rooks      | 1,0,1,0,1         | 0,1,0,1,0         | yes (PROVEN, well-covered law)    |

The grid n = 5 entry is the sharpest warning: normal G = 3 (a rich position) with misère
G⁻ = 0. Bishops n = 4 gives a both-conventions P-position. A misère analog of Theorem 3
(diagonal reduction) is not derivable from any of this machinery (§5.1), and misère
Node-Kayles on general graphs is presumably wild; the queens misère sequence above is best
treated as an independent benchmark sequence. Extending it past n ≈ 9 needs a real misère
engine (whole-DAG, no heap-sum shortcut — implications §4.3); n = 9 is plausibly in reach
of an optimized version of the same Python (the n = 8 DAG here was ~70k positions,
seconds).

---

## 6. A344227 as a geometric octal-analog — framing (no new computation)

**The 1-D anchor is PROVEN territory**: Node-Kayles on paths is Dawson's chess, the octal
game 0.137, whose nim-sequence is eventually periodic with period 34 (preperiod 51); on
cycles (our even-circulant THIN family) the values are likewise classical. So the
*family* containing the queens game already has one member whose value sequence is fully
periodic — the periodicity question for A344227 is the 2-D analog, with the crucial
difference that the GAME changes with the index (a bigger board, not a bigger heap).

**Why there is no Guy–Smith licence.** For octal games, computed periodicity over a
sufficient window PROVES eventual periodicity because the heap recursion is
self-similar: G(n) depends on G of boundedly-smaller heaps. A344227 has no such
recursion: B_n does not decompose into smaller boards plus bounded glue. The
border-decomposition frame (implications §1–2) is exactly the attempt to MANUFACTURE one —
`R_n = (odd-center residual of B_{n−1}) ⊕ live border ⊕ cross-attack entanglement` — and
§4 of this note now says precisely what that costs: the entanglement term cannot be
controlled by any graph-generic bounded-interaction theorem (all tested hypotheses fail at
tiny sizes); a licence must be queens-specific (line structure, B1 clique-interfaces, X2
product form). **A Guy–Smith analog for A344227 = a queens-specific bounded-interaction
transfer theorem.** That is the cleanest statement of what "prove eventual periodicity"
would take.

**What would count as evidence (in increasing strength):**

1. *Value data consistent with C1* — G(17..22) ∈ {0,1} with odd terms 1: keeps the
   "eventually period 2 with a threshold defect" reading alive (P3/P4/P5). Any value ≥ 2
   at large n kills C1 and pushes toward the unbounded regime of general Node-Kayles.
2. *The torus baseline* — T1 (`G = n mod 2`, n ≥ 4): odd half now PROVEN (§2.3); if the
   even half is proven, the BORDERLESS sequence is exactly periodic, and "A344227 minus
   the torus" isolates the border as the sole aperiodic ingredient — the two-sequence
   comparison becomes a theorem-grade formulation of the border-defect view.
3. *Certificate uniformity* (implications §5) — a uniform strike-refutation rule for even
   P-boards would be the queens analog of an octal recurrence: a finite-state description
   of the defense that a periodicity argument could induct on.
4. *The real thing* — a bounded-interaction transfer for queen line-interfaces (the §4
   survivors X1/X2 as scaffolding + queen-specific scar control), giving G(B_n) as a
   finite-state function of G-data of B_{n−2}: eventual periodicity would follow from
   pigeonhole on the finite state space.

**What the border-defect view predicts**: odd terms 1 forever (PROVEN ≥ 1; C1 says
exactly 1); even terms 0 up to a threshold and then permanently nonzero (the battle, once
tipped by border-to-area ratio, stays tipped — P3's monotone reading), i.e. the plane
sequence is **eventually the period-2 word 1,g,1,g,…** with g ∈ {1,2,3} the stabilized
even value (mode prediction g = 1). The n = 8 anomaly (G = 3, first-player win at a SMALL
even size) is quarantined as pre-asymptotic tactics — the same quarantine the octal world
routinely applies to preperiods. A G(20) = 0 verdict would falsify the monotone reading
and re-open modular/regime readings of the even terms; that is the highest-information
single computation the framing identifies, consistent with the umbrella's P3.

---

## 7. Claims ledger

| # | claim                                                                | status                       |
|---|----------------------------------------------------------------------|------------------------------|
| 1 | Lemma C / W / dodge criterion / Lemma Q / Lemma T (§1)               | PROVEN (census-verified n≤8) |
| 2 | even-torus kings, knights, grid, rooks, bishops: G = 0               | PROVEN (+ computed anchors)  |
| 3 | Theorem O1: odd-torus ray pieces G = 1 exactly; T1 odd half          | PROVEN                       |
| 4 | even queens min obstruction = two attack-line cliques (2n), all topologies | PROVEN over the natural pool |
| 5 | hypercube Q_d (d ≥ 2) G = 0 via weight-≥ 2 translation               | PROVEN (values likely known — cite Brown et al.) |
| 6 | circulant dichotomy (even n: all-even S ⟹ split ⟹ 0; else obstructed)| PROVEN                       |
| 7 | one cross edge: shift ≤ 6 seen, outcome flips ~26%; clique-interface worse | COMPUTED (seeded, sizes stated) |
| 8 | P-preserving / simplicial / dead-zone endpoint hypotheses            | REFUTED (witnesses ≤ 5+5)    |
| 9 | Theorem X1 (pairing-compatible cross edges ⟹ G = 0)                  | PROVEN                       |
| 10| Lemma X2 (interface product factorization)                           | PROVEN                       |
| 11| D1-general (m = 1 defect ⟹ G ≤ 1 on symmetric doubles)               | REFUTED (diamond, G = 2 at 4 vertices; growth to 5 by 12) |
| 12| queens-D1 itself (n ≤ 8 data)                                        | unchanged: TESTED-CONSISTENT, now known to REQUIRE queen geometry |
| 13| misère: Copying/steal conclusions transfer nothing                   | PROVEN (§5.1)                |
| 14| Misère Well-Covered Parity Law (G⁻ = (m+1) mod 2)                    | PROVEN                       |
| 15| misère torus values ∈ {0,1}; torus queens G⁻ = 1 − G                 | PROVEN range; equality COMPUTED n ≤ 9 |
| 16| F-emptiness does not determine misère outcome                        | REFUTED-hypothesis (Q₂/Q₄; plane/torus knights n=4) |
| 17| misère queens sequence 0,0,2,0,3,0,2,3                               | COMPUTED (n = 1..8, exact)   |
| 18| plane queens tame-shaped (G⁻ = G except 0↔1 swap)                    | TESTED-CONSISTENT n ≤ 8 only; fails in sibling families |
| 19| kings G(5) = 4; grid G-sequence 1,0,1,0,3; cycles pattern            | COMPUTED (new small values)  |
| 20| Guy–Smith analog for A344227 ⟺ queens-specific interaction transfer  | framing (argued, §6)         |

## 8. Method note

All scripts in `notes/scripts/2026-07-03-geometry/`: `involution_census.py` (census +
special graphs; formulas of §1 asserted against brute-force obstruction sets for all
pieces/topologies at n = 4..8), `bounded_interaction.py` (seeded RNG 20260703; exhaustive
where stated, random fields where stated; the D1 witnesses re-verified by an independent
in-line recursion), `misere_small.py` (misère mex with terminal = 1; normal values
computed alongside and checked against A344227 n ≤ 8, the cgt-laws torus values n ≤ 10,
and the primer's knight/bishop/king values — all match). Memory-capped and
seconds-to-minutes per family on the busy box; no solver binaries touched.

Sources for the classical anchors: [Dawson's chess / 0.137 periodicity — octal games
overview](https://en.wikipedia.org/wiki/Octal_game); [Guignard–Sopena, Compound
Node-Kayles on Paths (Node-Kayles on paths ≡ Dawson's chess)](https://www.labri.fr/perso/sopena/web_gs08.pdf);
[OEIS A002187 (Dawson's chess nim-values)](https://oeis.org/A002187); Brown et al.,
"Nimber Sequences of Node-Kayles Games" ([JIS](https://cs.uwaterloo.ca/journals/JIS/VOL23/Wong/wong24.pdf))
for path/cycle/hypercube/Petersen families.
