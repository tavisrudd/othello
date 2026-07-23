# C498 math review — characteristic-2/3 closes and exceptional families (adversarial referee pass)

**Lane**: `reed-solomon` · **Date**: 2026-07-23 · **Scope**: mathematics only (not novelty) of the
char-3 and char-2 fourth-order closes and the exceptional-family sections of
`notes/2026-07-22-c498-prs-redundancy-six.md`, with C491 imports read from
`notes/2026-07-22-c491-prs-redundancy-five.md`.

**Method**: full independent re-derivation plus computation. All finite-field code below is an
independent implementation (shares nothing with the census generator or its replay). Main script:
`/tmp/claude-1000/-home-tavis-src-othello-rust/dafc425d-27b5-4511-8837-b4e56e329094/scratchpad/c498_verify.py`
(run: `python3 c498_verify.py`; ~4 min). Symbolic checks:
`uv run --with sympy python3` inline (conic reduction, coefficient equations, Cauchy–Binet).
Census cross-reads: direct JSON queries on `notes/2026-07-22-c498-prs-deep-hole-census.json`;
field models read from `notes/2026-07-22-c498-prs-deep-hole-census.rs` (element = base-p digits,
low degree least significant; GF(9): t²=−1).

## Verdict summary

| # | Claim block                       | Verdict                                             |
|---|-----------------------------------|-----------------------------------------------------|
| 1 | Characteristic-three close        | VERIFIED WITH CAVEAT (two statement-level nits)     |
| 2 | Characteristic-two close          | VERIFIED (same derivative-minor caveat as item 1)   |
| 3 | Frobenius-trinomial family        | VERIFIED                                            |
| 4 | Isolated q=11 echo                | VERIFIED                                            |
| 5 | Other q=11 orbit                  | VERIFIED WITH CAVEAT (a=0 case of one sentence is false; q=11 conclusions unaffected) |
| 6 | C502 hexad verdict                | VERIFIED                                            |

No error was found that affects any theorem statement, budget, or the all-field inventory. The two
caveats are localized wording/scope defects with easy fixes.

## 1. Characteristic-three close — VERIFIED WITH CAVEAT

**W_3 = Join(n=e2, C_4) as closure of C491's wild family.** C491 Lemma 6(2c): wild family =
PGL₂-orbit of f_a = e₂ − a·ν(∞), −a nonsquare, size (q²−1)/2. Computed the full orbit over F₉
in the degree-4 substitution representation: size 40 = (81−1)/2, and **all 40 points lie on a
line ⟨e₂, ν(t)⟩ with t ∈ P¹(F₉)** (script, item-1 block). Over F̄_q the orbit sweeps all ratios
λe₂+μν(t), so the Zariski closure is the cone over C₄ with vertex e₂ — degree 4 (cone over a
degree-4 curve). Matches C491's description. The nucleus n and the curve are on the cone /
secant locus respectively, so they are inside the 4+3 budget.

**Lines on the cone are the rulings.** Re-derived: let ℓ ⊂ Join(v, C₄), π = projection from the
vertex v, which maps the cone minus v onto C₄. π(ℓ) is a point or a line (linear image of a
line). If a point p, then ℓ ⊂ Join(v,p) = that ruling, so ℓ is the ruling. If a line, it is an
irreducible curve inside the irreducible quartic C₄, hence equals C₄, forcing deg C₄ = 1 —
contradiction (C₄ nondegenerate quartic). VERIFIED.

**No ruling is a polar line.** Sharper than the report: I did the linear algebra for the general
ruling directly, no equivariance needed. Rows (a₀..a₄), (a₁..a₅) ∈ span{e₂, ν(t)} forces (row-1)
a₀=μ, a₁=μt, a₃=μt³, a₄=μt⁴ and (row-2) a₂=μt², a₅=μt⁵, i.e. **f = μ·ν(t) ∈ C** — Hankel rank
≤ 1, no polar line. At t=∞ (the report's test case P⟨e₂,e₄⟩): a₀=…=a₄=0 with **a₅ free**, i.e.
f ∼ e₅ = ν(∞) ∈ C, again rank ≤ 1. *Caveat (cosmetic)*: the report says the overlap "forces all
a_i = 0"; the actual solution set is f ∈ ⟨ν(∞)⟩, not 0. Conclusion (no trivial-gcd net has a
ruling as polar line) unchanged. The equivariance reduction it invokes is also fine (e₂ is
PGL₂-fixed, curve transitive on rational points; rulings to irrational t are not F_q-rational
lines, while a polar line of a rational f is rational).

**Pointed-ramification budget (degree ≤ 6, not identically zero).** Re-derived precisely:
- The correct object is the rank-≤1 locus of the 2×3 matrix [[F₁,F₂,F₃],[F₁′,F₂′,F₃′]] for a
  basis of W. Each affine minor F_iF_j′ − F_jF_i′ has degree ≤ 6 (the t⁷ coefficient is
  a_i·4a_j − a_j·4a_i = 0 in every characteristic). Homogeneously, Euler's relation in char 3
  (F = s∂_sF + t∂_tF, since 4 ≡ 1) gives t·M_t = −s·M_s, so the projective ramification scheme
  is cut by a single binary form N of degree 6 including the point at infinity. So ≤ 6 bad r
  in P¹, as claimed.
- **Nonvanishing**: suppose all minors ≡ 0. Case A: F_i′ = 0 for all i ⟹ W ⊆ span{1, t³}
  (quartic monomials killed by d/dt in char 3), dimension ≤ 2 < 3. Contradiction — this is
  the report's "cannot consist entirely of polynomials in t³", and as a statement about
  quartics-in-t³ it is exactly right (only t⁰, t³ fit under degree 4). Case B: some F₁′ ≠ 0.
  Then F₁F_j′ = F₁′F_j for all j; writing d = gcd(F₁,F₁′) and g = F₁/d, g is coprime to F₁′/d
  and divides every F_j, with deg g ≥ deg F₁ − deg F₁′ ≥ 1 (derivative strictly drops degree
  when nonzero) — contradicting trivial gcd. *Caveat (real but small)*: the report's stated
  justification covers only Case A; Case B (rows proportional through a nonconstant rational
  function, equivalently φ_W factoring through Frobenius) is not addressed. It is closed by the
  three-line gcd argument above (or by 3 ∤ 4 = deg φ_W·deg image), so the budget stands.
- Numerical spot checks: all four q=9 trivial-gcd census reps have exactly 1 rational
  ramification point (≤ 6); 20 random F₂₇ nets max 0.

**Endgame arithmetic.** Powers of 3 strictly between 27 and 81: none (3³=27, 3⁴=81). The q ≥ 29
theorem covers 81, 243, …; the census covers 27 (JSON: 2 orbits at q=27, both gcd-degree 2,
**0 trivial-gcd**) and 9 (4 trivial-gcd orbits, matching "the four q=9 orbits are the complete
exceptional table"). 27 − 2√27 = 16.61 < 18 confirms q=27 genuinely needs the census. The
sentence "closes the only gap before the next characteristic-three field q=81" is logically
sound (its only content: 27 is the sole char-3 field below the q ≥ 29 threshold); mildly
redundant since 81 itself is already inside the theorem.

Downstairs stratum coverage is complete for char 3: gcd-2 → secant cubic (≤3, via rank C_f = 3
and the degree-3 binary form (3), which cannot vanish identically when some maximal minor is
nonzero); cyclic = nucleus + wild ⊂ cone (≤4); pointed gcd-1 collision = ramification (≤6);
tame cyclic impossible in char 3 (C491 Lemma 6); S₃/gcd-1 punctured bounds apply (18 and
q−9 discards resp.), 29 − 2√29 = 18.23 > 18. Total 3+4+6 = 13 < q+1. VERIFIED.

## 2. Characteristic-two close — VERIFIED

**g·e₂ computation.** Hand-derived in char 2 ((x+y)⁴ = x⁴+y⁴, (x+y)² = x²+y²):
(M_g e₂)_k = [s²](αs+β)^k(γs+δ)^{4−k} gives exactly det·(0, γδ, αδ+βγ, αβ, 0). Verified
**exactly, for all 180 g ∈ GL₂(F₄)** by brute force against the substitution matrix: equality
on the nose with scalar det ≠ 0. Report's [0 : δγ : αδ+βγ : αβ : 0] VERIFIED.

**Closure = Π_cyc = P⟨e₁,e₂,e₃⟩.** The y-coordinate of the image is det ≠ 0, so the rational
image lies in the chart y≠0; a target (x:1:z) is hit iff δ² + δ + xz = 0 has a solution with
the right side data, solvable over F̄_q always (and over F_q iff Tr(xz)=0). Over F₁₆ the
computed image has exactly 136 points = 16 + 15·8, precisely the trace-condition count —
confirming both the formula and that the image is a 2-parameter (dense) family in the plane.
Hence Zariski closure = the full plane. The plane is PGL₂-invariant (M_g e₁, M_g e₂, M_g e₃
all have vanishing 0th and 4th coordinates in char 2, by the same [s¹],[s²],[s³] computations).
The orbit itself is only ≈ half the plane's rational points; the **closure** claim is what the
budget uses, and it is correct. VERIFIED.

**Polar line in Π_cyc ⟹ f ∈ N₃.** Row-1 (a₀..a₄) ∈ span{e₁,e₂,e₃} ⟺ a₀=a₄=0; row-2 ⟺
a₁=a₅=0. So f = (0,0,a₂,a₃,0,0) ∈ P⟨e₂,e₃⟩, exactly N₃. Every polar line not contained in the
plane meets it in ≤ 1 point (two points would span a line inside the plane). VERIFIED.

**Pointed budget.** Identically-zero differential: char-2 kernel of d/dt on quartics is
span{1,t²,t⁴} (dimension 3), so all-derivatives-zero forces W = ⟨1,t²,t⁴⟩ exactly. The Hankel
overlap for that space reads a₀=a₂=a₄=0 (row 1) and a₁=a₃=a₅=0 (row 2) ⟹ f = 0; brute force
over F₄ confirms **no nonzero f has ker H_f = ⟨1,t²,t⁴⟩** (0 hits among all 4095 f). The same
Case-B caveat as item 1 applies (rows proportional without vanishing derivatives), closed by
the identical gcd argument; the report again states only the Case-A justification.

**Budget and arithmetic.** 3 (secant cubic) + 1 (plane) + 6 (ramification) = 10 < q+1 = 33 at
q = 32. The punctured S₃ inequality is the same 18 = 12 (C491 Lemma 7 diagonal+branch discards)
+ 6 (ordered pairs on the unique pencil member through the prescribed r, ≤ 3 roots → ≤ 6
pairs): 32 − 2√32 = 20.686 > 18. Punctured gcd-1 graph argument needs q+1−2−4−2−2 = q−9 > 0 —
ample. q = 16: 16 − 8 = 8 < 18, so 16 correctly rests on the census (JSON: 0 trivial-gcd
orbits at 16); q = 8 census has the nucleus orbit (size 9, stab 56) plus 10 others, matching
"odd m" starting again at m=5. Downstairs C491 sporadics exist only for q ≤ 19 < 32, so they
never obstruct the pointed argument. VERIFIED.

**C491 char-2 arithmetic families are present and budgeted.** In char 2, q = 2^m ≡ 2 (mod 3)
for m odd (O⁺ deep) and ≡ 1 for m even (O⁻ deep), so deep tame-cyclic downstairs points do
exist. Both kinds are rational points of the geometric orbit closure of e₂: verified over F₈
that **every rational Osc(t₁)∩Osc(t₂) point (all pairs t₁≠t₂ ∈ P¹) lies in P⟨e₁,e₂,e₃⟩**.
They are therefore covered by the ≤ 1 plane-intersection term. The char-2 inseparable gcd-1
case (C491 Lemma 5) forces b(r) ∈ C ⊂ secant cubic — also budgeted. VERIFIED.

## 3. Frobenius-trinomial family — VERIFIED

- **Kernel.** Rows of (0,0,0,1,0,0) are (0,0,0,1,0) and (0,0,1,0,0); on quartics (d₀..d₄) they
  read d₃ = 0, d₂ = 0, kernel = span{1, t, t⁴} = ⟨s⁴, s³t, t⁴⟩. Confirmed by the independent
  solver at q = 8, 16, 32. Basepoint-free (1 and t⁴), trivial gcd. VERIFIED.
- **Additive argument.** For C≠0, two roots r,r′ of A+Bt+Ct⁴ give C(r⁴−r′⁴)+B(r−r′)=0, and in
  char 2 (r−r′)⁴ = r⁴−r′⁴, so u = r−r′ ∈ ker(u ↦ u⁴+αu), α=B/C, an F₂-subspace of size 1, 2,
  or 4. Four distinct roots need the coset r₁+K to hold all of them ⟹ |K| = 4 ⟹ all three
  roots of u³ = α rational. Conversely for μ₃ ⊂ F_q and α a nonzero cube, t⁴+αt = t(t³+α) has
  roots 0, β, ζβ, ζ²β, all rational and distinct. So split member ⟺ 3 | q−1 ⟺ m even. C=0
  members A+Bt are s³(As+Bt): triple root at ∞, never squarefree — correctly excluded by the
  "four distinct roots in P¹(F_q)" convention (stated in the report's Method section; my brute
  force uses the same convention and reproduces every census verdict). VERIFIED.
- **Brute force.** F₈ (m=3): deep. F₁₆ (m=4): not deep (witness member t+t⁴ = combination
  (0,1,1)). F₃₂ (m=5, model t⁵=t²+1): deep. Matches the law exactly. VERIFIED.
- **Stabilizer.** Degree-5 substitution: (M_g e₃)_2 = [s³](αs+β)²(γs+δ)³ = γ(αδ+βγ)² —
  verified exactly for all g ∈ GL₂(F₄). So an invertible stabilizer needs γ = 0; conversely for
  γ = 0, (M_g e₃)_k = C(k,3)α³β^{k−3}δ^{5−k} and C(4,3) = 4 ≡ 0, C(5,3) = 10 ≡ 0 (char 2)
  leave only k = 3: M_g e₃ = α³δ²e₃. Brute force over PGL₂(F₈): stabilizer order 56 = q(q−1),
  all upper triangular, orbit size 9 = q+1 — matches the frozen q=8 certificate (JSON: size 9,
  stab 56). VERIFIED.
- **Orbit = N₃.** Lower-unipotent (1,0,c,1) sends e₃ to (0,0,c,1,0,0) (computed exactly), the
  Weyl swap sends it to e₂; brute-forced orbit over F₈ equals {[0,0,c,1,0,0]} ∪ {e₂} =
  P⟨e₂,e₃⟩, all q+1 rational points of the line. Deepness of every point follows by
  equivariance. VERIFIED.
- **Nucleus criterion.** C(4,2), C(5,2), C(4,3), C(5,3) = 6, 10, 4, 10, all even. Internal
  consistency check (not a literature check): over F₈ the intersection of the osculating
  3-spaces span(ν, ν^[1], ν^[2], ν^[3]) of the quintic NRC over all t ∈ P¹ computes to exactly
  span{e₂, e₃}. So N₃ is genuinely the 3-nucleus line in the stated sense. VERIFIED.
- **Semilinear count and q=32 bound.** Coefficientwise Frobenius fixes (0,0,0,1,0,0); |PΓL₂| =
  m(q³−q), orbit q+1 ⟹ stabilizer m·q(q−1) (at q=32: 4960, and 33·4960 = 163,680 = 5·(32³−32)).
  32·33²/2 = 17,424; +33 = **17,457**. VERIFIED.

## 4. Isolated q=11 echo — VERIFIED

- **Monic reduction.** Monic members are t⁴+Bt+A: e₁ = e₂ = 0 automatic; conversely 4 distinct
  roots with e₁=e₂=0 give the member t⁴ − e₃t + e₄ ∈ W. VERIFIED (definition-level).
- **Conic reduction (sympy).** For r = (x+y+z, x−y−z, −x+y−z, −x−y+z): e₁ = 0 identically and
  e₂ = **−2(x²+y²+z²)** exactly. The correspondence is the invertible linear map
  x = (r₁+r₂)/2, y = (r₁+r₃)/2, z = (r₁+r₄)/2 on {Σr_i = 0} (inverse verified symbolically),
  char ≠ 2 — every e₁=0 quadruple arises, bijectively. Root scaling matches conic-point
  scaling, and scaled roots stay in the net (t ↦ λt maps monic members to monic members after
  renormalizing). VERIFIED.
- **Distinctness lines (sympy).** r_i − r_j = 2(y+z), 2(x+z), 2(x+y), 2(x−y), 2(x−z), 2(y−z):
  exactly the six lines x=±y, x=±z, y=±z. VERIFIED.
- **Line-conic sections.** On x=y: 2x²+z²=0 with x≠0 ⟹ (z/x)² = −2: rational ⟺ −2 ∈ QR;
  the other five lines are identical by symmetry. VERIFIED.
- **Field cases.** q=7: −2 = 5, Legendre −1 (QR₇ = {1,2,4}) — every conic point good; brute
  force confirms ⟨1,t,t⁴⟩ has a split member over F₇ (net not deep, consistent with the
  census: (0,0,0,1,0,0) is absent from the q=7 orbit list). q=9: −2 = 1 (char 3), a square, and
  the conic has only 10 points vs the ≤ 12 bad bound, so the generic argument is inconclusive —
  the explicit witness is required and works: in the frozen model (t² = −1, label n = c₀+3c₁),
  {1,2,3,6} = {1, 2, t, 2t} are distinct with e₁ = 0 and e₂ = 0 (computed in GF(9)); net has a
  split member. q=11: −2 = 9 = 3²; the conic has exactly 12 rational points, each of the six
  lines meets it in exactly 2, the six sections are pairwise disjoint, and their union is all
  12 points — computed exhaustively. Direct brute force: **no** split squarefree member over
  F₁₁ (deep), a split member exists over F₁₃. For −2 square and q ≥ 13: 12 < q+1 conic points,
  good point exists. Arithmetic law (q=11 or q=2^m, m odd, within q ≥ 7) VERIFIED.
- Census concordance: q=11 orbit of (0,0,0,1,0,0) has size 132 = 1320/10, stab 10 (JSON).

## 5. Other q=11 orbit — VERIFIED WITH CAVEAT

- **Kernel and normal form.** ker H_{(0,1,0,2,0,10)} over F₁₁: d₁+2d₃ = 0, d₀+2d₂+10d₄ = 0,
  basis {t²−2, t(t²−2), t⁴+1}; rref-equality with ⟨u, tu, u²+5⟩ confirmed (u²+4u+5 = t⁴+1 mod
  11, so the spans agree). General formula: for (0,1,0,a,0,b), kernel = ⟨u, tu, t⁴−b⟩ =
  ⟨u, tu, u²+c⟩ with u = t²−a, c = a²−b (t⁴−b = (u²+c) − 2au) — verified for **all 121 (a,b)
  over F₁₁** against the independent solver. VERIFIED.
- **Coefficient equations (2) (sympy).** (t²+pt+r)(t²+qt+s) ∈ W_{a,c} (monic, γ=1) ⟺ after
  eliminating α, β: p(s+a) + q(r+a) = 0 and (r+a)(s+a) + apq = c, i.e. pS+qR = 0, RS+apq = c
  exactly, signs included. Membership is equivalent to (2) since α, β are free. VERIFIED.
- **(a,c) = (2,5) enumeration.** Ordered 4-tuples (p,q,r,s) satisfying (2) with both quadratics
  split with distinct roots: exactly **15**, exactly **8** up to swapping the factors, and
  **every one** has the two quadratics sharing a root. Case analysis complete: a totally split
  squarefree quartic member with 4 finite roots factors as two split quadratics with disjoint
  root sets (would appear in the list); a member with ∞ as a root is cubic, γ=0, = u(α+βt),
  needing u split — but a = 2 is a nonsquare mod 11 (QR₁₁ = {1,3,4,5,9}); γ≠0 members scale to
  monic. Independent full brute force: the net has no split squarefree member (deep). Census:
  size 660 = 1320/2, stab 2. VERIFIED.
- **q=7 classes.** (0,1,0,3,0,5): a=3 (nonsquare mod 7), c=4, j = 4/9 = 4·4 = 2. (0,1,0,3,0,6):
  c=3, j = 3/2 = 3·4 = 5. Both brute-forced DEEP over F₇. Scaling t ↦ λt verified in the
  degree-5 representation over F₇ (all λ): (a,b) ↦ (λ²a, λ⁴b) projectively, so j = c/a² and
  χ(a) are scaling invariants and (for a ≠ 0) classify the scaling class (a sweeps its square
  class, then b = a²(1−j) is determined). q=11 orbit class: j = 5/4 = 5·3 = 4, χ(2) = −1,
  giving (4,−1) as stated. VERIFIED.
- **CAVEAT (statement error at a = 0).** The sentence "If a is a square, the cubic members
  u(A+Bt) already give a split squarefree divisor… Thus a deep interior point requires a
  nonsquare" is **false at a = 0** (0 is a square, but u = t² is not squarefree and the
  argument collapses). Concrete counterexamples in the frozen census: the chart points
  (0,1,0,0,0,b) with W = ⟨t², t³, t⁴−b⟩ are deep at q=7 for b ∈ {1,2,4} (= the certified orbit
  of rep (0,1,0,0,0,1), size 168), at q=9 for four b values (= the certified orbits of reps
  (0,1,0,0,0,4), (0,1,0,0,0,5)), and at q=13 for b ∈ {2,5,6} (= the certified orbit of rep
  (0,1,0,0,0,2)); empty at q=11 and q=27 (checked), so the q=11 analysis and the all-field
  theorem are untouched. Under the literal reading, "two calibrated deep scaling classes at
  q=7" and "No interior class survives at any other odd field" also fail (the a=0 scaling
  class survives at 7, 9, 13). These a=0 orbits are exactly ones the report elsewhere lists as
  open/unexplained ("the other 16/10/4/0/1 orbits"), so the census bookkeeping is consistent;
  the defect is that the split-involution dichotomy is asserted for the whole chart but proved
  only for a ≠ 0. Fix: state "a a nonzero square ⟹ not deep; deep interior points have a
  nonsquare **or a = 0**", or define "interior" as a ≠ 0.

## 6. C502 hexad verdict — VERIFIED

- Census JSON, q=11 trivial-gcd orbits: sizes/stabs (132, 10) and (660, 2); 1320/132 = 10,
  1320/660 = 2. Neither stabilizer has order 60. VERIFIED.
- Brute-forced stab([e₃]) in PGL₂(11): order 10, equal to the diagonal split torus (all
  elements diagonal), and it contains **both** determinant square classes — outer elements
  present. Brute-forced stab((0,1,0,2,0,10)): order 2 = {id, diag(1,−1)}; diag(1,−1) is
  t ↦ −t with det −1, and −1 is a nonsquare mod 11 (11 ≡ 3 mod 4) — the order-2 stabilizer is
  itself outer. VERIFIED.
- PSL-transitivity: Stab_{PGL}(x) ⊄ PSL and [PGL:PSL] = 2 give Stab·PSL = PGL, so the PSL-orbit
  of x is the full PGL-orbit. Standard index-2 argument; applies to both orbits. VERIFIED.

## Reproduction

```sh
cd /tmp/claude-1000/-home-tavis-src-othello-rust/dafc425d-27b5-4511-8837-b4e56e329094/scratchpad
python3 c498_verify.py            # items 1-6 numeric/brute-force battery
uv run --with sympy python3 ...   # inline: e1/e2 reduction, six lines, eqs (2), Cauchy-Binet (3)
```

Key numbers reproduced: wild orbit 40/40 on rulings (F₉); ramification counts ≤ 6; image 136 =
16+15·8 in the F₁₆ plane; 0 nets with kernel ⟨1,t²,t⁴⟩ (F₄); orbit 9 / stab 56 (F₈); deep at
8, 32, not 16; conic 12 = 6×2 disjoint (F₁₁); 15 ordered / 8 unordered colliding candidates;
32−2√32 = 20.686 > 18; 29−2√29 = 18.23 > 18; 27−2√27 = 16.61 < 18; 17,457 = 17,424+33; JSON
trivial-gcd orbit counts 18/11/4/2/1/0/0/0/0/0/0 at q = 7…27.
