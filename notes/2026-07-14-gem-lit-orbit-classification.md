# Literature check: PGL(2,11)-orbits on 6-subsets of P^1(F_11)

**Date**: 2026-07-14
**Status**: COMPLETE for Q1 and Q2; Q3 is a weak NOT FOUND (limited search, by design).

Tiering convention used throughout:
- **VERIFIED** — I opened the source; URL + quote given.
- **INFERRED** — abstract/search-snippet only; flagged per item.
- **NOT FOUND** — searched, nothing found.
- **NOT SEARCHED** — not attempted.

---

## Q1 verdict — SUBSTANTIALLY YES, the converse closes by citation

**The classification in (A) is published, in general-q form, by Cameron–Omidi–Tayfeh-Rezaie (2006).**
It is published as a *method plus a stabilizer-indexed orbit theorem*, not as a q=11, k=6 table.
Our exact table is not printed anywhere I found — but it is a **routine substitution** into their
Theorem 4, and the paper says so in as many words ("only the simple problem of substituting the
appropriate values"). I performed that substitution by hand and **it reproduces our table exactly,
all four orbits, both sizes and stabilizer types, including completeness** (see the derivation
section below).

What the citation gives us, precisely:

- **Gives us:** for every subgroup type H ≤ PGL(2,q), the number g_k(H) of k-subsets whose
  stabilizer is *exactly* H, hence the complete orbit list with sizes and stabilizer types. For
  q=11, k=6 this is exactly our four-row table. This is the whole of (A), and it is the part our
  proof currently gets by exhaustive computation.
- **Does NOT give us:** the involution-content statement our theorem actually turns on — that each
  of the three non-C5 stabilizers contains an involution acting *without fixed points* on the
  6-set, while C5 has no involution at all. That invariant is ours, not theirs; the paper has no
  reason to state it. **We still argue that step ourselves** — but it is now a short argument about
  four named groups, not an exhaustive search. (It is close to immediate from their Lemma 8, which
  gives the orbit structure of each D_2d on the projective line; see the "what remains" note below.)

So: **the converse's classification step closes by citation; the parity/involution step remains
ours** and is a few lines given the table. See "What still has to be argued" below.

**Recommended citation.** P. J. Cameron, G. R. Omidi, B. Tayfeh-Rezaie, "3-Designs from PGL(2,q)",
Electron. J. Combin. 13 (2006), #R50 — Theorem 4 (orbit counts indexed by stabilizer type),
with Theorem 2 (subgroup census), Lemmas 7–14 (orbit structure of each subgroup on P^1), Theorem 3
(Möbius function, quoted from the companion PSL paper [2]), and Lemma 15 (orbits ↔ g_k).
The companion — Cameron, Maimani, Omidi, Tayfeh-Rezaie, "3-Designs from PSL(2,q)", Discrete Math.
306 (2006) — is the natural co-citation and is where the Möbius values and a table of f_k live.

---

## Primary candidate source (Q1)

**VERIFIED.** P. J. Cameron, G. R. Omidi, B. Tayfeh-Rezaie, "3-Designs from PGL(2,q)",
*Electronic Journal of Combinatorics* **13** (2006), #R50.
URL: https://www.combinatorics.org/ojs/index.php/eljc/article/download/v13i1r50/pdf/
(Local text extract: scratchpad `cameron-3designs.txt`.)

Abstract, quoted verbatim:

> "The group PGL(2, q), q = p^n, p an odd prime, is 3-transitive on the projective line and
> therefore it can be used to construct 3-designs. In this paper, we determine the sizes of orbits
> from the action of PGL(2, q) on the k-subsets of the projective line when k is not congruent to
> 0 and 1 modulo p. Consequently, we find all values of λ for which there exist 3-(q + 1, k, λ)
> designs admitting PGL(2, q) as automorphism group. In the case p ≡ 3 (mod 4), the results and
> some previously known facts are used to classify 3-designs from PSL(2, p) up to isomorphism."

**Our case is inside the hypothesis.** q = p = 11, k = 6; 6 ≢ 0, 1 (mod 11). So the paper's main
computation applies directly to PGL(2,11) on 6-subsets.

**The method is stabilizer-resolved, not merely a count.** The paper defines (Section 2, quoted):

> "f_k(H) := the number of k-subsets fixed by H,
>  g_k(H) := the number of k-subsets with the stabilizer group H."

with f_k(H) = Σ_{H≤U≤PGL(2,q)} g_k(U), inverted by Möbius inversion over the subgroup lattice:
g_k(H) = Σ_{H≤U≤PGL(2,q)} f_k(U) μ(H,U). This is exactly the invariant our table records — the
number of 6-subsets whose stabilizer is *exactly* H — so the paper's output is of the right type
to close the converse, not just to check orbit sizes.

### NOTATION CLASH: RESOLVED — this settles the "S3" worry in the task

**VERIFIED.** Cameron–Omidi–Tayfeh-Rezaie use **D_n = dihedral group of ORDER n**, not order 2n.
Direct evidence from Theorem 2 and Lemma 8 (quoted):

> Theorem 2(iii): "Two conjugacy classes of dihedral subgroups D_4. One (class 1) consisting of
> q(q^2 − 1)/24 of them which lie in the subgroup PSL(2, q) ..."

> Lemma 8: "Let H be the dihedral group of order 2d ... (i) Let d = 2." — i.e. D_4 is the d=2 case,
> a group of order 4.

So in this paper's convention:
- `D_4`  = dihedral of order 4 = **Klein four group V4**
- `D_6`  = dihedral of order 6 = **S_3**
- `D_12` = dihedral of order 12

**Consequence for our table.** Our stabilizer list {C5, V4, S3, D12(order 12)} is, in the paper's
notation, exactly **{C5, D_4, D_6, D_12}**. The "S3 appears in our table but not on the classical
char-0 genus-2 list" worry in the task is very likely a **notation clash**, as suspected: an author
writing D_6 for order 6 and an author writing D_6 for order 12 disagree by a factor of two
throughout. Any comparison against the genus-2 reduced-automorphism list must first pin the
convention. (See the genus-2 section below for the reconciliation.)

Note also Theorem 2 gives the count of subgroups of each type, and Lemma 8 gives their orbit
structure on the projective line — both are ingredients our converse would otherwise re-derive.

---

## THE DERIVATION: our table, obtained from CO-TR's published theorems

**Result up front: the substitution reproduces our table exactly. No discrepancy, nothing forced.**
I also ran an independent brute-force enumeration as a cross-check (below); all three — our table,
the CO-TR substitution, and the brute force — agree.

### Setup

CO-TR's conventions: "we let p be a prime, q = p^n and q ≡ ε (mod 4), where ε = ±1".
For q = p = 11: 11 ≡ 3 ≡ −1 (mod 4), so **ε = −1**. Then:

- |PGL(2,11)| = q³ − q = **1320** (CO-TR §2) ✓
- q + ε = 10  (= q−1, the *split* torus order) and q − ε = 12 (= q+1, the *nonsplit* torus order)
- (q+ε)/2 = 5, (q−ε)/2 = 6
- k = 6, and **6 ≢ 0, 1 (mod 11)** — so Theorem 4's hypothesis holds and our case is in scope.

Machinery used, all from the paper:

- **Theorem 2** — census of subgroups of PGL(2,q) with conjugacy-class counts u(H).
- **Lemmas 7–14** — the orbit sizes of each subgroup acting on P^1(F_q). Feeds f_k.
- **§6 formula** — f_k(H) = Σ_{Σ mᵢlᵢ = k} Π_i C(rᵢ, mᵢ) where H has rᵢ orbits of size lᵢ.
- **Theorem 3** — the Möbius function μ(H,U) of the subgroup lattice (quoted from companion [2]).
- **Möbius inversion** — g_k(H) = Σ_{H≤U} f_k(U) μ(H,U).
- **Theorem 4 / Lemma 15** — number of orbits with stabilizer conjugate to H
  = u(H)·g_k(H)·|H| / |PGL(2,q)|.

### Row 1 — the 264-orbit, stabilizer C5

- **Census (Thm 2(ii)):** Cd with d | q±ε, d>2 → one class of q(q∓ε)/2 subgroups. d = 5 divides
  q+ε = 10 (upper sign), so u(C5) = q(q−ε)/2 = 11·12/2 = **66**.
  This is precisely the "66 split tori" of our writeup — and it is *split* exactly because
  5 | q−1, consistent with ε = −1 putting the split torus at q+ε.
- **Orbits on P^1 (Lem 7(ii)):** d>2 → N₁ = 1 ∓ ε = 1−(−1) = **2 fixed points**. Remaining
  12 − 2 = 10 points fall into regular orbits of size 5 → **2 orbits of size 5**.
  So C5 has orbit profile {1, 1, 5, 5} — exactly the "two fixed points, two 5-point orbits"
  our writeup asserts. ✓
- **f₆(C5):** 6 = 5 + 1 → C(2,1)·C(2,1) = **4**. (No other partition works.)
- **Overgroups:** C10 (Lem 4(i), unique), D10 (Lem 4(ii)), D20, A5 (exists since 11 ≡ 1 mod 10).
  Their f₆ all vanish: C10 has profile {1,1,10} → f₆=0; D10 has {2,10} (c1) or {2,5,5} (c2) →
  f₆=0 both; D20 has {2,10} → f₆=0; A5 is **transitive on all 12 points** (Lem 11: N₁₂ = (1∓ε)/2
  = 1) → f₆=0. And μ(C5,A5) = 0 anyway (Thm 3(v)).
- **g₆(C5)** = 4·1 + 0 = **4**.
- **Orbits** = u·g₆·|H|/|G| = 66·4·5/1320 = **1**, of size 1320/5 = **264**. ✓

Equivalently 66 × 4 = 264 six-sets, all in one orbit — matching our seed count
"66 split tori × 2 fixed points × 2 orbits = 264" exactly. Note g₆ = f₆ here, i.e. all four
C5-invariant hexads have stabilizer *exactly* C5, no larger.

### Row 2 — the 330-orbit, stabilizer V4 = D_4 (class 2)

- **Census (Thm 2(iii)):** D_4 class 1 (inside PSL): q(q²−1)/24 = **55**; class 2 (outside PSL):
  q(q²−1)/8 = **165**.
- **Orbits on P^1 (Lem 8(i), d=2):** class 1 → N₂ = 3(1+ε)/2 = **0**, so profile {4,4,4} → f₆ = 0.
  Class 2 → N₂ = (3−ε)/2 = **2**, so profile {2,2,4,4}.
- **f₆(D_4, c2):** 6 = 2 + 4 → C(2,1)·C(2,1) = **4**.
- **Overgroups of D_4(c2)** (Lem 3 column D_4(c2)): D_12(c2) ×1, D_8 ×1, D_24 ×1, D_20 ×2.
  Not A4 (A4 ⊂ PSL, its V4 is class 1); μ(D_4, A5) = 0; the D_4's inside S4 that are *non-normal*
  have μ = 0 (Thm 3(iv): "μ(D_4,S_4) = 3 for normal subgroup D_4 of S_4 and μ(D_4,S_4) = 0
  otherwise"), so S4 contributes nothing.
  f₆: D_12(c2) profile {6,6} → **f₆ = 2**; D_8 {4,8} → 0; D_24 {12} → 0; D_20 {2,10} → 0.
  μ(D_4, D_12) = μ(6/2) = μ(3) = −1.
- **g₆(D_4, c2)** = 4·1 + 1·2·(−1) = **2**.
- **Orbits** = 165·2·4/1320 = **1**, of size 1320/4 = **330**. ✓
- **Class 1 gives nothing:** f₆(D_4,c1) = 0 and every overgroup's f₆ vanishes (A4 profile {12},
  S4 profile {12} by Lem 10(iv) — since 3 | q−ε and 8 | q+3ε = 8 → N₈ = 0, N₁₂ = 1), so
  g₆(D_4,c1) = **0**. Exactly one V4 orbit, as we have.

**Order-4 stabilizer is V4, not C4 — checked.** C4: d=4 | q−ε, u = q(q+ε)/2 = 55, N₁ = 1+ε = 0 →
profile {4,4,4} → f₆ = 0; overgroups C12 {12}, D_8 {4,8}, D_24 {12} all have f₆ = 0; μ(C4,S4) = 0.
So **g₆(C4) = 0** — no C4 orbit. The order-4 stabilizer is Klein four. ✓

### Row 3 — the 220-orbit, stabilizer S3 = D_6 (class 1)

- **Census (Thm 2(iv)):** d = 3 | (q−ε)/2 = 6 → two classes of q(q²−1)/(4d) = 1320/12 = **110** each.
- **Orbits on P^1 (Lem 8(ii), d=3):** 3 | q−ε → lower sign → N₂ = (1+ε)/2 = **0**.
  N₃: class 1 → 1+ε = **0** → profile {6,6}; class 2 → 1−ε = **2** → profile {3,3,6}.
- **f₆:** class 1: 6 = 6 → C(2,1) = **2**. Class 2: 6 = 3+3 (C(2,2)=1) or 6 = 6 (C(1,1)=1) → **2**.
- **Overgroups:** D_12 (unique, same class, Lem 4(iii)), D_24 (unique) with μ(D_6,D_24) = μ(4) = **0**.
  Lem 6(ii): D_6(c1) lies in 2 subgroups A5 (11 ≡ 1 mod 10) and in **0** subgroups S4
  (needs q ≡ ±1 mod 8; 11 ≡ 3). Lem 6(iii): D_6(c2) lies in 2 subgroups S4 (11 ≡ 3 mod 8 ✓).
  μ(D_6, D_12) = μ(2) = −1; μ(D_6,S4) = μ(D_6,A5) = −1.
- **g₆(D_6, c1)** = 2·1 + 1·f₆(D_12,c1)·(−1) + 2·f₆(A5)·(−1) = 2 − 0 − 0 = **2**.
  → orbits = 110·2·6/1320 = **1**, of size 1320/6 = **220**. ✓
- **g₆(D_6, c2)** = 2·1 + 1·f₆(D_12,c2)·(−1) + 2·f₆(S4)·(−1) = 2 − 2 − 0 = **0** → no orbit.

**Order-6 stabilizer is S3, not C6 — checked.** C6: d=6 | q−ε, N₁ = 1+ε = 0 → profile {6,6},
f₆ = 2. Overgroups C12 (f₆=0), D_12 (one per class, see note), D_24 (f₆=0).
g₆(C6) = 2 + 1·f₆(D_12,c1)·(−1) + 1·f₆(D_12,c2)·(−1) = 2 − 0 − 2 = **0** — no C6 orbit. ✓

> **Note on a genuine ambiguity in Lemma 4(ii).** Its parenthetical — "if this latter group has
> more than one conjugacy classes, then Cd is contained in the same number of groups for each of
> classes" — can be read as "(q±ε)/(ld) per class" or "(q±ε)/(ld) in total, split evenly".
> The per-class reading gives **g₆(C6) = −2**, which is impossible (g_k counts subsets). The
> total-split-evenly reading gives 0. An independent geometric check settles it in favour of the
> latter: N(C6) = D_24 = ⟨r⟩⋊⟨s⟩ with r of order 12, whose order-12 subgroups are C12 and exactly
> **two** D_12's — one inside PSL (class 1), one not (class 2). So C6 lies in 2 subgroups D_12
> total, one per class. Anyone re-deriving this should take the total reading.

### Row 4 — the 110-orbit, stabilizer D_12 (order 12, class 2)

- **Census (Thm 2(iv)):** d = 6 | (q−ε)/2 = 6 → two classes of 1320/24 = **55** each.
- **Orbits on P^1 (Lem 8(ii), d=6):** 6 | q−ε → N₂ = (1+ε)/2 = **0**.
  N₆: class 1 → 1+ε = **0** → profile {12}; class 2 → 1−ε = **2** → profile {6,6}.
- **f₆:** class 1 → **0**; class 2 → C(2,1) = **2**.
- **Overgroups:** only D_24 (Lem 4(iii), unique), μ(D_12,D_24) = μ(2) = −1, f₆(D_24) = 0.
  No A4/S4/A5 contains a dihedral group of order 12 (A5's maximals are A4, D_10, S3; S4's
  order-12 subgroup is A4).
- **g₆(D_12, c1)** = 0 → no orbit. **g₆(D_12, c2)** = 2·1 − 0 = **2**.
- **Orbits** = 55·2·12/1320 = **1**, of size 1320/12 = **110**. ✓

### Completeness

Every other subgroup type has f₆ = 0 and hence contributes nothing: C2 (both classes),
C3, C4, C10, C12, D_8, D_10, D_20, D_24, A4, S4, A5; and Thm 2's classes (vii)–(x) — the
PSL/PGL subfield subgroups, elementary abelian p-groups and their normalizers — are killed
outright by the hypothesis, as §6 states: "The latter condition imposes f_k(H) and g_k(H) to be
zero for any subgroup H belonging to one of the classes (vii)-(x) in Theorem 2."

The four orbits found already total **264 + 330 + 220 + 110 = 924 = C(12,6)**, and orbit counts
are non-negative, so **no further orbit can exist**. Completeness is forced by the sum, not
assumed.

### Reproduction table

| orbit size | \|Stab\| | stabilizer (our notation) | CO-TR notation | class | u(H) | g₆(H) | matches? |
|-----------:|---------:|---------------------------|----------------|-------|-----:|------:|----------|
| 264 | 5  | C5             | C5   | —  | 66  | 4 | ✓ |
| 330 | 4  | V4 (Klein four)| D_4  | c2 | 165 | 2 | ✓ |
| 220 | 6  | S3             | D_6  | c1 | 110 | 2 | ✓ |
| 110 | 12 | D12 (order 12) | D_12 | c2 | 55  | 2 | ✓ |

**All four rows reproduce. Sum = 924 = C(12,6). Each size = 1320/|Stab|.**

A bonus the paper's machinery gives that our table did not record: **the PSL-class of each
stabilizer.** The S3 is class 1 (inside PSL(2,11)); the V4 and D12 are class 2 (outside). This is
extra structure available free from Theorem 2, and may be worth stating in the paper.

### Independent brute-force cross-check — VERIFIED

Enumerated PGL(2,11) as permutations of P^1(F_11) and computed orbits on all C(12,6) = 924
six-subsets directly (script: scratchpad `check.py`). Output:

```
|PGL(2,11)| = 1320
num 6-subsets = 924
orbit size | stabilizer order
       330 | 4
       264 | 5
       220 | 6
       110 | 12
sum = 924
```

This confirms sizes and stabilizer *orders* independently of the paper. The stabilizer *types*
(V4 not C4; S3 not C6) come from the CO-TR derivation above, where I checked both alternatives
explicitly and both were excluded by g₆ = 0.

---

## What still has to be argued (the part the citation does NOT cover)

Our theorem is: *H is a hexad of S(5,6,12) iff Stab_{PGL(2,11)}(H) has odd order.* CO-TR gives the
table; it does not give the parity/involution reading. Given the table, though, the remaining step
is short and does not need a search:

- The only odd stabilizer order in the table is **5**; the other three are 4, 6, 12 — all even, all
  containing an involution. So "odd order" ⟺ "stabilizer is C5" ⟺ "in the 264-orbit" is immediate
  *from the table alone*.
- The stronger fixed-point-free claim (if that is the form the paper needs) also falls out of
  **Lemma 8**, which we already used: for D_4(c2) the profile on P^1 is {2,2,4,4}, for D_6(c1) it is
  {6,6}, for D_12(c2) it is {6,6}. An involution in each of these acts on the relevant hexad with
  the orbit structure Lemma 8 dictates — i.e. the fixed points of the involution on P^1 (Thm 1:
  d = 2 gives f = 1 ∓ ε fixed points) determine whether they land inside the hexad. This is a
  finite check over three named groups.
- **What is genuinely ours:** the *identification* of the 264-orbit with the two S(5,6,12) systems
  (132 + 132, swapped by PGL \ PSL). CO-TR's §8 is about exactly this PSL-vs-PGL splitting
  mechanism — "all designs in F = S \ G admit PSL(2, p) as their full automorphism group ... the
  normalizer of PSL(2,p) in S_{p+1} is PGL(2,p)" — so it is the right tool, but their §8 is stated
  for p > 23 (it leans on PGL(2,p) maximal in S_{p+1}, which cites Liebeck–Praeger–Saxl [8]) and
  therefore **does not apply at p = 11**. p = 11 is precisely where PGL(2,11) is *not* maximal —
  M11 and M12 intervene. Do not cite §8 for our splitting; cite the Steiner-system literature
  (Q1-adjacent section below) or argue it directly.

---

## The genus-2 route: the correspondence HOLDS, but it is a cross-check, not the citation

The task's derived-but-unverified chain (6-subset ↔ squarefree binary sextic ↔ genus-2 curve;
PGL(2)-equivalence ↔ curve isomorphism; 6-set stabilizer ↔ reduced automorphism group) is
**correct as stated**, and I verified the consequences it predicts. But it should be the paper's
*remark*, not its *citation*, for a reason given at the end of this section.

### Source

**VERIFIED.** T. Shaska, "The arithmetic of genus two curves", RISAT preprint (2010-1).
URL: https://www.risat.org/pdf/2010-1.pdf (extract: scratchpad `shaska-genus2.txt`)

**Lemma 1**, quoted verbatim:

> "The automorphism group G of a genus 2 curve C in characteristic ≠ 2 is isomorphic to
> C₂, C₁₀, V₄, D₈, D₁₂, C₃⋊D₈, GL₂(3), or 2⁺S₅. The case G ≅ 2⁺S₅ occurs only in characteristic 5.
> If G ≅ Z₃⋊D₈ (resp., GL₂(3)), then C has equation Y² = X⁶ − 1 (resp., Y² = X(X⁴ − 1)).
> If G ≅ C₁₀, then C has equation Y² = X⁶ − X."

Note this lemma is stated for **characteristic ≠ 2**, so it covers char 11.

### Reducing mod the hyperelliptic involution reproduces our stabilizer list

The hyperelliptic involution is central of order 2, so the reduced group is the quotient (order
halves). Applying this to Lemma 1's list:

| full Aut (Shaska Lem 1) | order | reduced = Aut/⟨ι⟩ | order | in our table? |
|-------------------------|------:|-------------------|------:|---------------|
| C₂            | 2   | 1               | 1   | no (would need trivial stabilizer) |
| V₄            | 4   | C₂              | 2   | no |
| **C₁₀**       | 10  | **C₅**          | 5   | **yes — the 264-orbit** |
| **D₈**        | 8   | **V₄**          | 4   | **yes — the 330-orbit** |
| **D₁₂**       | 12  | **S₃ (= D₆)**   | 6   | **yes — the 220-orbit** |
| **C₃⋊D₈**     | 24  | **D₁₂ (order 12)** | 12 | **yes — the 110-orbit** |
| GL₂(3)        | 48  | S₄              | 24  | no |
| 2⁺S₅          | 240 | S₅              | 120 | no (char 5 only anyway) |

**All four of our stabilizers are on the reduced list, and nothing is missing or anomalous.**

### The S₃ question — ANSWERED: it is a notation clash, not char-11, not rationality

The task's worry was that S₃ (order 6) appears in our table but not on the quoted char-0 reduced
list {1, C2, V4, D8, D12, S4, C5}. Resolution: **that quoted list mixes the two conventions** — D₈
and D₁₂ there are *full-Aut* entries (orders 8 and 12) sitting in a list otherwise of *reduced*
groups. The correctly-reduced list is {1, C₂, C₅, V₄, **S₃**, D₁₂(order 12), S₄, S₅}, and S₃ is on
it, as D₁₂/⟨ι⟩. Our table matches the classical list exactly, as the task suspected it might.

**The hazard is real and is worth a footnote in our paper.** Shaska's paper *switches conventions
internally*: Lemma 1 uses D_n = dihedral of order n (D₈ = order 8), but Proposition 1 and Remark 1
use D_n = dihedral of order 2n. Proof that it switches, from Remark 1 quoted verbatim:

> "Notice the singular point in both spaces of curves with automorphism group D₄ and D₆. Such
> points correspond to larger automorphism groups, namely the groups of order 24 and 48
> respectively. This can be easily seen from the group theory since D₄ ↪ Z₃⋊D₄ and D₆ ↪ W₁."

Here `Z₃⋊D₄` (Remark 1) must be the same order-24 group Lemma 1 calls `Z₃⋊D₈` — so Remark 1's `D₄`
is Lemma 1's `D₈`, i.e. dihedral of order 8. The same symbol means different groups in the same
paper. **Cameron–Omidi–Tayfeh-Rezaie, by contrast, are internally consistent throughout on
D_n = order n**, which is another reason to make CO-TR the citation of record.

### The C5 curve: y² = x⁶ − x — and it IS our 264-orbit. VERIFIED

Shaska's Lemma 1 answers the task's question directly: **G ≅ C₁₀ (reduced C₅) ⟹ Y² = X⁶ − X.**
That is the normal form. But the task's two candidates are *the same curve*:

- y² = x⁶ − x = x(x⁵ − 1) → Weierstrass 6-set = **{0} ∪ μ₅** (∞ is not a branch point, sextic).
- y² = x⁵ − 1 → Weierstrass 6-set = **μ₅ ∪ {∞}** (∞ *is* a branch point, quintic).

These are swapped by x ↦ 1/x (which preserves μ₅ and exchanges 0 ↔ ∞), so they are
PGL(2)-equivalent and the curves are isomorphic. Shaska picks the sextic model.

**Over F₁₁ this closes the loop with our seed.** F₁₁* is cyclic of order 10, so the 5th roots of
unity are exactly the index-2 subgroup — i.e. **μ₅(F₁₁) = QR(11) = {1,3,4,5,9}**. Hence
{0} ∪ μ₅ = **{0} ∪ QR(11)**, the classical hexad seed of our writeup. I checked both models
computationally against our own orbit data (scratchpad `check2.py`):

```
QR(11) = [1, 3, 4, 5, 9]
mu_5(F_11) = [1, 3, 4, 5, 9]  equal to QR?  True
{0} u QR(11)  (= y^2=x^6-x)      -> orbit size  264, |Stab| = 5
mu_5 u {inf}  (= y^2=x^5-1)      -> orbit size  264, |Stab| = 5
```

Both land in the **264-orbit with stabilizer of order 5**. The identification
"264-orbit = the C₅ / y² = x⁶ − x curve = {0} ∪ QR(11) seed" is confirmed. ✓

### Why this is a remark and not the citation — the rationality caution is REAL

The task flagged this and the flag is correct. The genus-2 literature classifies the **geometric**
automorphism group (over k̄). Our stabilizers are the **F₁₁-rational** ones, i.e.
Stab_{PGL(2,k̄)}(H) ∩ PGL(2,11), which can be *strictly smaller*. Concretely: our 110-orbit has
rational stabilizer D₁₂, and the geometric model for reduced-D₁₂ is Y² = X⁶ − 1 with 6-set μ₆ —
but **μ₆ ⊄ F₁₁** (6 ∤ 10, so only μ₂ = {±1} is rational). So the rational hexad in our 110-orbit is
*not literally* μ₆; it is only geometrically equivalent to it. The two classifications therefore
answer different questions, and coincide here only because the arithmetic happens to cooperate.

**Consequence:** citing Igusa / Cardona–Quer / Shaska for our table would be citing a theorem about
a different group (geometric vs rational) and a different equivalence. **Cite CO-TR for (A);
mention the genus-2 dictionary as an interpretation.** The genus-2 reading remains valuable as
narrative — it explains *why* the four groups are the ones that occur — but it is not the load-
bearing reference.

**INFERRED (not separately verified):** Cardona–Quer (arXiv math/0203165) classify genus-2 curves
with Aut ≅ D₈ or D₁₂ over an arbitrary field up to k-isomorphism — i.e. they *do* treat the
rational (k-isomorphism) refinement for two of our cases. I read only the abstract, which does not
fix their convention. If the paper wants a genus-2 co-citation with arithmetic content, this is the
one to chase; I did not verify its contents.

---

## Q1-adjacent: the S(5,6,12) hexad stabilizer is classical — partial

**INFERRED (search-snippet level; the primary source did not resolve).** The fact that the
stabilizer of a hexad of S(5,6,12) in PSL(2,11) has order 5 (660/132 = 5) is standard textbook
material. A search surfaced the statement in EAGTS ("Explorations in Algebraic Graph Theory with
Sage", Beezer et al.), §"The Steiner System S(5,6,12)": the 12 points are identified with PG(1,11),
blocks are generated from a starting block under PSL(2,11) of order 660, and "there are exactly
five elements of this group that leave the starting block fixed setwise, namely those such that
b = c = 0 and ad = 1 so that f(z) = a²z", giving stabilizer order 5.

**Caveat — I could not open this source.** `linear.ups.edu` failed to resolve (DNS ENOTFOUND) at
the time of the search, so the above is from the search engine's summary, **not** from my reading
the page. Treat as INFERRED. It is consistent with our computation and with the C5 row derived
above (the map f(z) = a²z is exactly the order-5 split-torus element fixing 0 and ∞ and permuting
QR(11)), but it is not a verified quote.

**For a citable source, use a standard text rather than this.** Not yet verified, but the expected
places (NOT SEARCHED in depth): Conway–Sloane, *SPLAG*, ch. 10–11 (the M12 / S(5,6,12) chapters);
Beth–Jungnickel–Lenz, *Design Theory*, 2nd ed. (which CO-TR itself cites as [1]); Curtis's
"kitten" papers. Given that our C5 row is now *derived* from CO-TR above, this citation is a
convenience, not a dependency.

---

## Q2 — citations for the tools in (B)

### Tool 2: pencil of quadratic forms ↔ involution — GOOD CITATION FOUND

**VERIFIED.** Nicholas Phat Nguyen, "A generalization of Desargues' involution theorem",
arXiv:1912.12200. URL: https://arxiv.org/pdf/1912.12200 (extract: scratchpad `nguyen.txt`)

The classical theorem, quoted verbatim from its Introduction:

> "Theorem (Desargues' Involution Theorem): Consider four points in general position in the real
> projective plane, i.e., no three of these four points are collinear. Let ℱ be the family of
> conics passing through these four points. Then for any line 𝓁 that does not pass through any of
> these four points, each conic in ℱ will, if it intersects 𝓁, do so in a pair of points that are
> conjugate under an involution of the line 𝓁."

More useful to us is §3, which establishes **exactly our correspondence** — quoted verbatim:

> "Because we can find at least two different pairs of such conjugate points, these elements of
> P(B) generate a subspace of projective dimension at least one. Since a Desargues bilinear form
> is non-degenerate by construction, the above proposition implies that all the symmetric bilinear
> forms associated with pairs of conjugate points of the involution generate a projective subspace
> of dimension 1 (a pencil) in P(B), and the Desargues bilinear form is the uniquely determined
> bilinear form up to a scalar factor that is orthogonal to that pencil."

and §4:

> "there is a natural bijection (independent of any basis or coordinates) between involutions of a
> projective line and non-degenerate bilinear forms on that line or, equivalently, the orthogonal
> complements of such non-degenerate bilinear forms."

**This is our tool.** The point-pairs of an involution on P¹ are precisely the members of a pencil
of binary quadratic forms; hence three point-pairs are pairs of a single involution **iff** their
three forms are linearly dependent. That is the statement our proof uses.

**Crucially for us, it is stated over any field of characteristic ≠ 2** — the paper's generalized
theorem opens "Consider a projective space of any dimension over a field K of characteristic ≠ 2".
So **char 11 is covered**, and we do not need to hand-wave from the real/classical case.

**Caveat on citing it:** this is an independent-author arXiv preprint, and I found no evidence of
journal publication. For a journal submission, pair it with (or prefer) a classical text. Nguyen
is safe as the statement we can point to for the char ≠ 2 generality.

### Tool 1: point off a conic ↔ involution on the conic — NOT VERIFIED to a specific theorem number

This is the projection-from-P involution: each line through P meets the conic twice, pairing its
points. Our count (121 involutions in PGL(2,11) = 66 with two fixed points ↔ 66 external points /
55 fixed-point-free ↔ 55 internal points) is **independently confirmed** by CO-TR's own machinery
above: Theorem 1 ("Let g be a nontrivial element in PGL(2,q) of order d and with f fixed points.
Then d = p, f = 1 or d | q ± ε, f = 1 ∓ ε") plus Theorem 2(i) (two classes of C₂, of sizes
q(q+ε)/2 = 55 and q(q−ε)/2 = 66). So with ε = −1: the class-2 involutions number
q(q−ε)/2 = 66 and have f = 1 − ε = 2 fixed points; the class-1 involutions number q(q+ε)/2 = 55
and have f = 1 + ε = 0. **55 + 66 = 121 ✓, and the fixed-point split matches the internal/external
split exactly.** This means Tool 1's numerology can be cited to CO-TR Theorem 1 + Theorem 2(i)
rather than needing Hirschfeld at all.

**NOT VERIFIED — the Hirschfeld reference.** I could not open the book (not online; Internet
Archive copy is lending-only) and therefore **cannot give a chapter/theorem number**. What I can
report:
- **INFERRED (publisher/search-summary level):** Hirschfeld, *Projective Geometries over Finite
  Fields*, 2nd ed., Clarendon Press 1998, ISBN 0-19-850295-8. Search summaries state **Chapter 8
  is titled "Ovals"**, which is the chapter treating conics in PG(2,q), tangent/secant/external
  lines and internal/external points. I did **not** confirm this from the book itself. Do not put
  a section number in the manuscript on my say-so — check a copy.
- **INFERRED:** Semple & Kneebone, *Algebraic Projective Geometry*, OUP 1952 — search summary of
  the MacTutor table of contents gives **Ch. 7 "Linear systems of conics"** and **Ch. 8 "Higher
  correspondences: apolarity, and the theory of invariants"** as the relevant chapters. Again
  unverified from the book. A scan exists at https://archive.org/details/dli.ernet.470072 —
  **NOT SEARCHED** (I did not open it); this is the cheapest way to nail the exact reference and
  I'd recommend it before submission.

**Bottom line for Q2:** the pencil↔involution tool has a solid, char-11-valid, quotable citation
(Nguyen). The point↔involution tool's *counts* are citable to CO-TR. The classical textbook
references exist but I could not open the texts, so **no chapter/theorem number in this report is
verified** — treat all of them as leads to check against a physical copy.

---

## Q3 — stabilizer-parity characterization of Steiner blocks: NOT FOUND

**NOT FOUND.** I searched for any precedent characterizing Steiner-system blocks by the parity or
involution-content of a stabilizer and found none. Effort here was deliberately limited (per the
task's priority ordering), so this is a **weak** NOT FOUND — it means "one round of searching
surfaced nothing", not "the literature has been swept".

One **near-miss worth flagging, so nobody mistakes it for a hit**: there is an established notion
of *parity* in Steiner systems, but it is a different notion. "On Sets of Fixed Parity in Steiner
Systems" (Ann. Discrete Math.; https://www.sciencedirect.com/science/article/abs/pii/S0167506008702346)
concerns sets **H of points** with |B ∩ H| of fixed parity for every block B — parity of an
*intersection size*, not of a *stabilizer order*. Not our statement. If the manuscript cites
anything for "parity in Steiner systems" it must not be this.

**Assessment.** Our formulation — *H is a hexad of S(5,6,12) iff Stab_{PGL(2,11)}(H) has odd
order* — reads as a repackaging of the orbit table rather than as an instance of a known family of
theorems. Given the table, it is a one-line corollary (5 is the only odd order among 5, 4, 6, 12),
so its novelty is presentational. I would **not** claim it as a new phenomenon in the paper
without a deeper search; describing it as a convenient reformulation is safe and defensible.

---

## Summary of citations, by tier

| Claim | Tier | Source |
|---|---|---|
| PGL(2,q) orbits on k-subsets, indexed by stabilizer type, k ≢ 0,1 mod p | **VERIFIED** | Cameron–Omidi–Tayfeh-Rezaie, EJC 13 (2006) #R50, Thm 4 (+ Thm 2, Lem 7–15, Thm 3) |
| Our q=11, k=6 table (264/330/220/110; C5/V4/S3/D12) | **VERIFIED** (derived by me from the above; not printed in any source found) | substitution into CO-TR Thm 4; cross-checked by brute force |
| D_n notation = dihedral of **order n** in CO-TR | **VERIFIED** | CO-TR Thm 2(iii), Lem 8 |
| Genus-2 full-Aut list, char ≠ 2 | **VERIFIED** | Shaska, "Arithmetic of genus two curves", Lemma 1 |
| C5-reduced curve is y² = x⁶ − x; = our 264-orbit = {0} ∪ QR(11) | **VERIFIED** | Shaska Lem 1 + own computation |
| Shaska switches D_n conventions internally | **VERIFIED** | Shaska Lem 1 vs. Remark 1 |
| Pencil of binary quadratics ↔ involution, char ≠ 2 | **VERIFIED** | Nguyen, arXiv:1912.12200, §3–§4 |
| S(5,6,12) hexad stabilizer has order 5 in PSL(2,11) | **INFERRED** | EAGTS §S(5,6,12) — *source did not resolve (DNS)*; also derivable from CO-TR |
| Cardona–Quer treat D₈/D₁₂ over arbitrary k | **INFERRED** | arXiv math/0203165 abstract only |
| Hirschfeld ch. 8 "Ovals" = conics/internal/external | **INFERRED** | search summaries; book not opened |
| Semple–Kneebone ch. 7/8 | **INFERRED** | MacTutor TOC summary; book not opened |
| Any Hirschfeld / Semple–Kneebone **theorem number** | **NOT VERIFIED** | — |
| Steiner blocks characterized by stabilizer parity | **NOT FOUND** (weak; limited search) | — |
| Cycle index of PGL(2,q) on P¹ tabulated for k=6 with stabilizers | **NOT SEARCHED** | superseded — CO-TR answers the question directly |
| Conway–Sloane SPLAG ch. 10–11; Curtis; Beth–Jungnickel–Lenz for the hexad stabilizer | **NOT SEARCHED** | — |
| Dolgachev *Classical Algebraic Geometry*; Clebsch/Salmon binary sextic invariant theory | **NOT SEARCHED** | — |

---

## Search log

- Searched: PGL(2,q) orbits on 6-subsets with stabilizers → found CO-TR 2006 immediately (top hit
  via the eljc listing). Fetched, extracted with pdftotext, read in full.
- Searched: genus-2 automorphism classification (Cardona–Quer, Shaska) → fetched Shaska RISAT
  2010-1, extracted, read Lemma 1 / Prop 1 / Remark 1.
- Searched: S(5,6,12) / PSL(2,11) hexad stabilizer → EAGTS page identified but **DNS failed**;
  left at INFERRED.
- Searched: Desargues involution theorem / pencil of conics → fetched Nguyen arXiv:1912.12200,
  extracted, read §1, §3, §4.
- Searched: Hirschfeld ch. 8; Semple–Kneebone → **books not accessible online**; no theorem
  numbers verified.
- Searched: Steiner blocks by stabilizer parity → **NOT FOUND** (one round only).
- Own computation: brute-force PGL(2,11) orbit enumeration on all 924 six-subsets
  (scratchpad `check.py`), and the QR-seed / genus-2 model check (`check2.py`).

### Scratchpad artifacts (session-local, will not persist)

`cameron-3designs.txt`, `shaska-genus2.txt`, `nguyen.txt`, `quadrics.txt`, `check.py`, `check2.py`
under the session scratchpad.
