# C491 mathematics review — adversarial verification of the redundancy-five base report

**Lane**: `reed-solomon` · **Date:** 2026-07-23 · Referee pass over
`notes/2026-07-22-c491-prs-redundancy-five.md` (mathematics only; novelty/literature out of
scope). All computations below are a from-scratch re-implementation (field arithmetic, span
marking, Hankel pencils, osculating constructions, orbit BFS) sharing no code with the frozen
census/replay scripts; scripts at
`/tmp/claude-1000/-home-tavis-src-othello-rust/dafc425d-27b5-4511-8837-b4e56e329094/scratchpad/`
(`gf.py`, `verify.py`, `lemmas.py`), run 2026-07-23. Fields exhaustively re-enumerated from the
raw definition (points of PG(4,q) outside every plane spanned by 3 distinct points of the quartic
NRC): q ∈ {7, 8, 9, 11, 13, 16, 17, 19, 23, 25, 27}. Report moduli used (GF(8): t³=t+1, GF(9):
t²=−1, GF(16): t⁴=t+1, GF(25): t²=2, GF(27): t³=t−1).

## Verdict summary

| item | claim | verdict |
|------|-------|---------|
| 1a | Hankel deep-hole dictionary (Lemmas 1, 1′, 2, 3) | VERIFIED |
| 1b | covering radius 4 for all prime powers q ≥ 7 (Theorem 0) | VERIFIED WITH CAVEAT |
| 2a | T/S strata from pencil gcds + the three closed-form totals | VERIFIED |
| 2b | O± osculating-pair families, deep per q mod 3 | VERIFIED |
| 2c | char 3: nucleus + wild family W, square-class law | VERIFIED |
| 2d | Lemma 7: S₃ pencils split for q ≥ 23 (fiber-square Weil) | VERIFIED |
| 2e | sporadic tables at q ∈ {7,…,19}, empty at 16 and 23 ≤ q ≤ 49 | VERIFIED |
| 3  | completeness of the classification (Theorem 8) | VERIFIED |
| 4  | internal consistency of totals / census / double-certification | VERIFIED |

No mathematical error was found. Every claim I could decide by independent computation or
re-derivation checks out, including the two crux items (2d absolute irreducibility, 3
exhaustiveness of the case split). The caveats are dependence caveats, not gaps in reasoning.

## 1a. Deep-hole dictionary — VERIFIED

**Derivation.** Re-derived Lemmas 1–3 independently; all steps are correct:

- Lemma 1: c = Π(T−t_iU) ∈ ker H(f) is exactly the order-3 linear recurrence on both length-4
  windows of (a₀…a₄); the solution space has dimension 3 (the two conditions are independent
  when the leading coefficient is nonzero) and contains the Vandermonde-independent geometric
  sequences ν(t_i); the t₃ = ∞ case drops to an order-2 recurrence on indices 0..3 with
  solution space ⟨ν(t₁), ν(t₂), e₄⟩. Field-free as claimed.
- Lemma 2: rank H = 1 ⟺ rows proportional ⟺ geometric progression or the degenerate chain, i.e.
  f ∈ C; off C the kernel has dimension 4 − 2 = 2 (a pencil). Equivariance follows from
  M_g ν(t) ∼ ν(gt) (re-verified numerically for the divided-power representation at every field
  run, random g, t).
- Lemma 3 is immediate given ρ = 4 (weight ≤ 3 ⟺ lies in some 3-point span ⟺ split squarefree
  member; spans of ≤ 2 points sit inside 3-point spans).

**Computation.** Exhaustive cross-check raw-definition vs Hankel criterion over every point of
PG(4,q) off C at q = 7 (2793 pts), 8 (4672), 9 (7371), 11 (16093), 13 (30927): zero mismatches.
At q = 16, 17, 19, 23: all deep points plus 20000 random non-deep points each: zero mismatches.
Lemma 1′ (confluent cases) verified exhaustively at q = 7, 8, 9: for every ordered pair s ≠ t in
P¹, {f : (T−tU)²(T−sU) ∈ ker H(f)} = span(ν(t), ν^[1](t), ν(s)) and
{f : (T−tU)³ ∈ ker H(f)} = Osc(t), Hasse derivatives, including the ∞ chart and characteristics
2 and 3 (`lemmas.py`).

## 1b. Covering radius 4 — VERIFIED WITH CAVEAT

**What the report proves.** Theorem 0 rests on Dür's criterion (ρ ∈ {4,5}, ρ = 4 ⟺ the quartic
NRC is a complete arc) plus the Seroussi–Roth completeness range k ≥ ⌊(q−1)/2⌋ as quoted through
ZWK, with the even-q exceptional dimensions {2, q−2} checked inapplicable. The internal
arithmetic is correct: q−4 ≥ ⌊(q−1)/2⌋ ⟺ q ≥ 7 (odd; ⟺ q ≥ 6 even, so all even prime powers
≥ 8 are covered), q−4 = 2 forces q = 6 (not a prime power), q−4 = q−2 impossible. So q = 7, 8
are inside the quoted range, not below it; there is no parity or small-q hole in the report's own
logic.

**Computation.** I verified ρ ≤ 4 independently and constructively at every field I ran
(q = 7…27): for each deep point f, an explicit split squarefree quartic c with Σ c_j a_j = 0 was
found (solving linearly for the fourth root given a triple), i.e. f lies in a span of 4 distinct
curve points; zero failures across all 44 006 deep points checked. This extends the report's own
direct check (census V1, q ≤ 16) up through 27. ρ ≥ 4 follows from the deep sets being nonempty
(T ≠ ∅ at every field). So ρ = 4 is unconditionally certified for 7 ≤ q ≤ 27 by this review and
7 ≤ q ≤ 49 by the (spot-confirmed) census.

**Caveat.** For q > 49 the claim rests on the Seroussi–Roth completeness theorem as cited via
ZWK. The application is correct if the quoted statement is; verifying that citation is a
literature question outside this review's scope. This is a dependence on a named published
theorem, correctly applied — not a gap in the report's reasoning.

## 2a. T/S strata and the three totals — VERIFIED

**Which total is which.** The three closed forms are the *grand deep-hole totals for q ≥ 23* (no
sporadics), each equal to T + S = q²+q + (q³−q)/2 = q(q+1)²/2 plus the arithmetic family:

| congruence class | extra family | total |
|------------------------|-------------------------|-------------------|
| q ≡ 1 (mod 3), char ≠ 3 | O⁻, q(q−1)/2 | q²(q+3)/2 |
| q ≡ 2 (mod 3) | O⁺, q(q+1)/2 | q(q+1)(q+2)/2 |
| char 3 | {n} ∪ W, 1 + (q²−1)/2 | (q³+3q²+q+1)/2 |

All three algebraic identities re-derived and confirmed; e.g. q(q+1)²/2 + q(q−1)/2 = q²(q+3)/2.

**Lemma 4 derivation.** gcd degree 2 forces L(f) = g·⟨T,U⟩; the trichotomy split/irreducible/
square on g is exhaustive and gives weight-2 / S-deep / T-deep exactly as stated; the converse
(T and S points have these pencils) follows from Lemma 1′ resp. the conjugate-secant span over
F_{q²}. Correct.

**Computation.** At every field run, my independent pencil-gcd classifier reproduced exactly:
gcd = ℓ² set == the directly constructed tangent-line union (sizes q²+q: 56, 72, 90, 132, 182,
272, 306, 380, 552, 650, 756 at q = 7…27; tangent lines pairwise disjoint off C including char
2); gcd-irreducible set == the directly constructed conjugate-secant rational-point union over
F_{q²} (sizes (q³−q)/2: 168, 252, …, 9828); zero deep points with split gcd or with gcd degree
1 at any field (Lemma 5's conclusion, including its q = 7 census fallback). Grand totals match
the formulas at every field after adding the certified sporadics (e.g. q = 25: 8750 =
625·28/2; q = 27: 10949 = (19683+2187+27+1)/2, both with zero sporadics).

Bonus (§5 orbit data spot-checks, matching the report): S orbits [42,42,84] at q = 7
(q ≡ 3 mod 4), [546,546] at q = 13 (q ≡ 1 mod 4), single 252 at q = 8 (char 2); T single orbit
in odd char, orbits [9,63] = [q+1, q²−1] at q = 8.

## 2b. O± mechanism — VERIFIED

**Derivation.** For f = Osc(t₁) ∩ Osc(t₂), Lemma 1′ puts both cubes (T−t_iU)³ in L(f), so after
normalizing {0,∞} the pencil is ⟨T³, U³⟩, φ_f the Kummer cubing map, deck ρ: t ↦ ζt. Lemma 6(1)
is sound: ρ irrational + Frobenius swapping ρ ↔ ρ² forces any rational same-fiber pair to be
diagonal (deep); ρ rational leaves ≥ q+1−2−6 > 0 witness pairs for q ≥ 8 (split member exists).
The multiplier bookkeeping is right: rational fixed pair ⟹ ρ rational ⟺ ζ^q = ζ ⟺ q ≡ 1 (3);
conjugate pair ⟹ Frobenius inverts the multiplier ⟹ ρ rational ⟺ q ≡ 2 (3). Hence O⁺ deep ⟺
q ≡ 2 (3), O⁻ deep ⟺ q ≡ 1 (3).

**Computation.** Constructed every osculating-plane pair intersection directly (rational pairs
over F_q; conjugate pairs over F_{q²}, checking the intersection point is a single point, is
Frobenius-fixed, and descends):

- O⁺ (all q(q+1)/2 points): all deep and exactly the classified two-rational-cube-point stratum
  at q = 8, 11, 17, 23 (q ≡ 2 mod 3); **none deep** at q = 7, 13, 16, 19, 25 (q ≡ 1 mod 3).
- O⁻ (all q(q−1)/2 points, rationality confirmed): all deep and exactly the classified
  two-conjugate-cube-point stratum at q = 7 (21), 13 (78), 16 (120), 19 (171), 25 (300); **none
  deep** at q = 8, 11, 17, 23.
- Single PGL₂ orbits with the stated stabilizer orders: O⁺ stab 2(q−1) (14 at q=8, 20 at 11,
  32 at 17, 44 at 23); O⁻ stab 2(q+1) (16 at q=7, 28 at 13, 34 at 16, 40 at 19).

## 2c. Char 3: nucleus and wild family — VERIFIED

**Derivation.** ν^[2](t) = (0,0,1,3t,6t²) ≡ e₂ in char 3 (C(3,2) = C(4,2) ≡ 0), so every
osculating plane contains n = ⟨e₂⟩; H(e₂) has kernel ⟨T³,U³⟩, whose members are exactly the
cubes of linear forms in char 3 (the cubes form that 2-dimensional linear space, and the cube
map on F_q is bijective since 3 ∤ q−1), so no member is squarefree: n is deep, PGL₂-fixed, and
is the unique all-cube pencil. The wild normal form is right: I re-derived the kernel of
H(e₂ − a·e₄) = ⟨U³, T³ + aTU²⟩, affine members z³ + az + s; deep ⟺ the additive map z ↦ z³+az
is bijective ⟺ its kernel roots ±√(−a) are irrational ⟺ −a nonsquare; for −a a square the
image members have 3 distinct rational roots (split). Deck-translation criterion (α = 0,
κ² = −β) and the stabilizer computation (translations fix e₂ and e₄; α² = 1) check out; orbit
size (q³−q)/2q = (q²−1)/2.

**Computation (q = 9 and q = 27, exhaustive).** All osculating-pair intersections — rational
and conjugate — collapse to the single point (0,0,1,0,0), which is deep (so O± indeed
degenerate to the nucleus). Direct law check: for **every** a ∈ F_q^×, f_a = (0,0,1,0,−a) is
deep ⟺ −a is a nonsquare (both fields, no exceptions). Classified wild stratum (single rational
cube point, cyclic normal form α = 0): 40 points at q = 9, 364 at q = 27 — one PGL₂ orbit each,
stabilizer order 18 = 2q resp. 54 = 2q; every deep member's normal form has −β nonsquare.
Totals: q = 9 deep = 1391 = 491 (families: 90+360+1+40) + 900 (sporadics, orbits [180,360,360],
stabs [4,2,2], the two 360s Frobenius-fused — matching the report's table); q = 27 deep =
10949 = families exactly, zero sporadics.

## 2d. Lemma 7 (S₃ stratum empty for q ≥ 23) — VERIFIED

This is the crux inherited by C498/C509/C512. Re-derived in full:

- **The (2,2) curve.** For trivial-gcd pencils, X = {(s,t) : c_s(t) = 0} has bidegree (1,3); a
  bihomogeneous factor of bidegree (0,e) would be a common factor of c₁, c₂ (excluded), so X is
  absolutely irreducible; p_a = (1−1)(3−1) = 0 forces X smooth rational, and projection to t is
  birational (the s solving c_s(t) = 0 is unique since c₁(t), c₂(t) never vanish together), so
  φ_f = (c₁ : c₂) is an honest degree-3 morphism P¹ → P¹. The (3,3) form
  c₁(t₁)c₂(t₂) − c₂(t₁)c₁(t₂) vanishes on the diagonal to order exactly 1 when φ is separable
  (a generic fiber has 3 distinct points, so G(t,t) ≢ 0), leaving Y_f = V(G) of bidegree (2,2),
  p_a = (2−1)(2−1) = 1, equal to the closure of the off-diagonal fiber square.
- **Absolute irreducibility: proved, not assumed.** Geometric components of the off-diagonal
  fiber square correspond to orbits of the geometric monodromy group on ordered pairs of
  distinct roots of a generic fiber; S₃ is 2-transitive on 3 letters, hence transitive on the 6
  ordered pairs: one component. (G is also reduced: a repeated factor would force ≤ 1 residual
  root per generic fiber, contradicting 3 distinct roots.) This standard argument is correct;
  it is exactly where the cyclic case must be — and is — excluded (there Y splits into the two
  graphs of ρ, ρ², which is Lemma 6's separate regime).
- **Point bound.** Geometric genus g ≤ p_a = 1; Aubry–Perret (#Y ≥ #Ỹ − (p_a − g)) plus Weil
  gives #Y(F_q) ≥ q+1 − 2g√q − (p_a−g) ≥ q − 2√q for both g = 1 (q+1−2√q) and g = 0 (q).
- **Deletion counts.** Diagonal: Y·Δ = (2,2)·(1,1) = 4 and Δ ⊄ Y: ≤ 4 rational points. Branch
  values: Riemann–Hurwitz with the different is exact in every characteristic for separable
  maps between genus-0 curves: deg 𝔡 = 2·3−2−3(−2)−… = 4, so ≤ 4 branch values; a
  non-squarefree cubic has ≤ 2 distinct roots hence ≤ 2 ordered distinct pairs: ≤ 8 off-diagonal
  bad points. Total discard ≤ 12. A surviving rational (t₁,t₂) has φ(t₁) = φ(t₂) = s rational
  and non-branch, so c_s is squarefree with two distinct rational roots; the third root is
  rational: a split member. All steps check.
- **Threshold arithmetic.** Need q − 2√q > 12. Scan of all prime powers 7 ≤ q ≤ 199: the
  inequality fails exactly on {7, 8, 9, 11, 13, 16, 17, 19} and holds for every prime power
  ≥ 23 (q = 19: 10.28; q = 23: 13.41). The failure set is precisely the seven sporadic fields
  plus 16 — matching the observed boundary, with q = 16's emptiness a census fact below the
  provable threshold, exactly as the report states.
- **Empirical sharpness.** My independent enumeration finds sporadics at 7, 8, 9, 11, 13, 17,
  19; zero at 16, 23, 25, 27; and all sporadic points lie in the trivial-gcd stratum with ≤ 1
  cube member and non-cyclic normal form (S₃ regime), consistent with Lemma 7's scope.

## 2e. Sporadic tables — VERIFIED

Independent enumeration + my own PGL₂ orbit BFS (generators t↦t+1, t↦gt, t↦1/t via the
divided-power representation, representation sanity-checked against ν(g·t)):

| q | my orbit sizes (stab) | total | report | frobenius fusion |
|----|---------------------------------------------|------|------|------------------|
| 7 | 28 (12), 112 (3), 168 (2), 168 (2), 168 (2) | 644 | ✓ | prime field |
| 8 | 252 (2), 252 (2), 252 (2) | 756 | ✓ | 3-cycle: all fuse ✓ |
| 9 | 180 (4), 360 (2), 360 (2) | 900 | ✓ | the two 360s swap ✓ |
| 11 | 330 (4), 660 (2) | 990 | ✓ | prime field |
| 13 | 182 (12), 546 (4) | 728 | ✓ | prime field |
| 17 | 1224 (4) | 1224 | ✓ | prime field |
| 19 | 570 (12) | 570 | ✓ | prime field |
| 16 | — | 0 | ✓ | deep = T ∪ S ∪ O⁻ exactly |
| 23 | — | 0 | ✓ | deep = T ∪ S ∪ O⁺ exactly |
| 25 | — | 0 | ✓ | deep = T ∪ S ∪ O⁻ exactly |
| 27 | — | 0 | ✓ | deep = T ∪ S ∪ {n} ∪ W exactly |

Every table row of the report is reproduced exactly, including stabilizer orders and PΓL fusion
patterns.

## 3. Completeness of the classification — VERIFIED

The case split is exhaustive: gcd degree ∈ {0,1,2} (Lemma 2 gives a pencil off C, so the gcd of
its members has degree ≤ 2 — degree 3 would mean a 1-dimensional system). Degree 2: Lemma 4's
split/irreducible/square trichotomy on a binary quadratic is exhaustive. Degree 1: Lemma 5
(never deep, q ≥ 8; the char-2 inseparable branch correctly collapses to f ∈ C — I re-derived
the window equations; q = 7 census, and my enumeration confirms zero gcd-1 deep points at every
field). Degree 0: φ_f is a genuine degree-3 morphism; either inseparable (only char 3; then
every member is a cube of a linear form, and the cubes form the 2-dimensional space ⟨T³,U³⟩, so
the pencil is the nucleus pencil — the uniqueness claim is correct), or separable with geometric
monodromy a transitive subgroup of S₃, i.e. C₃ or S₃ — a complete dichotomy. C₃: Lemma 6's
tame/wild split is forced (a separable degree-p cyclic cover in char p is wild; tame C₃ has
exactly two totally ramified points by RH, pinning f = Osc(t₁) ∩ Osc(t₂); wild char-3 has
exactly one, giving the W normal form — ramification bookkeeping re-derived, deg 𝔡 = 4 with
(p−1)(jump+1) ≥ 4 forcing a single jump-1 point). S₃: Lemma 7 for q ≥ 23; census for q ≤ 19
and 16. The "exceptional cover arithmetic" phrase resolves concretely to Lemma 6(1): a cyclic
φ_f is deep ⟺ its deck generator is Frobenius-twisted (irrational) — a precise, proved
statement, verified computationally in all three shapes (O± by q mod 3 at eight fields; the W
square-class law exhaustively over every parameter at q = 9 and 27). No stratum is unaccounted
for; disjointness of the families follows from distinct pencil signatures (gcd type / cube-point
configuration), which my classifier used and confirmed as a partition at every field.

The one structural dependence: for q ∈ {7, …, 19} the sporadic lists and the small-q fallbacks
of Lemmas 5–6 are census facts, not theorems — the report says so explicitly, and I have now
re-certified all of them with independent code, so the classification's evidential status is as
claimed (theorem for q ≥ 23 and q = 16-by-census; doubly-certified data below).

## 4. Internal consistency — VERIFIED

- The three closed forms match T+S+arithmetic-family algebra (re-derived, §2a above) and the
  frozen JSON's `deep_hole_count` at all 19 fields (checked all: e.g. 889 = 245+644 at q=7,
  4131 = 2907+1224 at q=17, 4541 = 3971+570 at q=19, 6900, 8750, 10949, 13485, 16337, 17952,
  27380, 37023, 42527, 55272, 62426 at q = 23…49 match the formulas with zero sporadics).
- JSON `tangent_count`/`sigma_secant_count` equal q²+q and (q³−q)/2 at all 19 fields and equal
  my independently constructed T and S sets at the eleven fields I enumerated.
- My eleven-field enumeration agrees with the JSON pointwise on (deep count, T, S, excess) —
  a third independent implementation beyond the census/replay pair, including q = 23 and 25, 27
  above the threshold (so the "double-certification 23 ≤ q ≤ 49" claim is now spot-confirmed by
  a triple at 23, 25, 27; 29 ≤ q ≤ 49 remain census+replay+formula-consistency only, and are in
  Theorem 8's proved range regardless).
- Covering radius: constructive ρ ≤ 4 witnesses for every deep point at every field run (§1b).

## Residual caveats (none blocking)

1. Theorem 0 for q > 49 rests on the Seroussi–Roth completeness range as quoted through ZWK
   (correctly applied; citation accuracy not audited here — literature scope).
2. The T/S counts are taken from ZWK Thms I.4–I.6; I verified them computationally at eleven
   fields and the derivation via Lemma 4 is complete anyway, so nothing rests on the citation.
3. Report line "Y_f … arithmetic genus 1, absolutely irreducible" in the Summary is proved in
   Lemma 7 only for the S₃ stratum — which is the only place it is used; the Summary phrasing
   could mislead a casual reader into thinking it holds for cyclic pencils (it does not — Y
   splits there). Cosmetic, not an error.
4. For q ∈ {29, 31, 32, 37, 41, 43, 47, 49} I did not re-enumerate; those fields are covered by
   the (verified) Theorem 8 proof, with the JSON as regression data consistent with the closed
   forms.

## Scripts and key run facts

- `gf.py` — finite fields p^m ≤ 729 with full tables, generic linear algebra.
- `verify.py <q>` — raw span-marking deep enumeration; Hankel cross-check; pencil-gcd + cube
  point classifier (over F_{q²} with verified embedding); direct constructions of T, S (conjugate
  secants), O± (osculating intersections over F_q / F_{q²}), nucleus, W-law; constructive ρ ≤ 4
  witnesses; PGL₂ orbit BFS + Frobenius fusion; JSON comparison. All eleven fields print
  `RESULT q=<q>: PASS`.
- `lemmas.py` — exhaustive Lemma 1′ check (q = 7, 8, 9); prime-power threshold scan for
  q − 2√q > 12.
