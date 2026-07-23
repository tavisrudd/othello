# C498 polar-line reduction and char-at-least-five split-member theorem — adversarial math review

**Scope:** mathematics only (not novelty) of the polar-line reduction and the
characteristic-at-least-five split-member theorem in `notes/2026-07-22-c498-prs-redundancy-six.md`,
with C491 (`notes/2026-07-22-c491-prs-redundancy-five.md`) internals treated as given except where
C498 needs a specific property. Date: 2026-07-23. Reviewer: Fable (referee subagent).

**Convention pinned down first:** C498's `H_f` is the 2×5 matrix with rows `(a0..a4)`, `(a1..a5)`
acting on the 5 coefficients of a binary quartic (confirmed against the census generator header,
`notes/2026-07-22-c498-prs-deep-hole-census.rs` lines 6–8). Its kernel `W` is a net (3-dim) for
`f` off `C`. Downstairs, C491's `H(b)` is 2×4 acting on cubics; kernel a pencil for `b` off `C`.

**Verification scripts** (scratchpad, not committed):
`scriptA_symbolic.py` (sympy identities), `scriptB_f7.py` (exhaustive P^5(F_7)),
`scriptC_lines.py` (lines vs squares surface, F_7/F_11), `scriptD_f29.py` (200 random
trivial-gcd f over F_29, per-r budget audit), `scriptE_cyclic.py` (exhaustive P^4(F_29) deep
gcd-0 scan). All under
`/tmp/claude-1000/-home-tavis-src-othello-rust/dafc425d-27b5-4511-8837-b4e56e329094/scratchpad/`.

---

## 1. Syndrome contraction identity (2) — VERIFIED

Claim: for a quartic `(t−r)g`, `g = Σ d_j t^j`, membership `(t−r)g ∈ ker H_f` is equivalent to
`g ∈ ker H(b(r))` with `b(r) = (a1−ra0, …, a5−ra4)`, and `b(∞) = (a0..a4)` for the factor `U`.

Symbolic sympy check: expanding the two upstairs Hankel conditions on the coefficient vector
`c = (−rd0, d0−rd1, d1−rd2, d2−rd3, d3)` gives exactly the two downstairs conditions
`Σ_j d_j b_{i+j} = 0`, `i = 0,1`, as polynomial identities (residuals identically 0), and
likewise on the ∞ chart `c = (d0,d1,d2,d3,0)` against `b(∞) = (a0..a4)`. Both directions follow
since the identity is between the linear conditions themselves, not just their zero sets.

Line parametrization: `b(r) = row2 − r·row1`, `b(∞) = row1`, so `r ↦ b(r)` is a bijection
`P^1 → ℓ_f = P⟨row1,row2⟩` when the rows are independent; row dependence forces `(a_i)` geometric,
i.e. `f ∈ C` — excluded for a net. Pencil claim: `dim{g : (t−r)g ∈ W} = dim ker H(b(r)) = 2` iff
`b(r) ∉ C ∪ {0}`; for `f` off `C`, `b(r) ≠ 0` always, and `b(r) ∈ C` implies `D_f(r) = 0`
(catalecticant rank ≤ 1), so every `r` where the pencil claim is used in the theorem is off the
budgeted locus. In `scriptD_f29.py` the downstairs kernel had dimension exactly 2 at every
non-budgeted fibre. No gap.

## 2. Cauchy–Binet identity (3) — VERIFIED

Symbolic check: the product of the 3×4 quintic catalecticant `C_f` with the stated 4×3 matrix
`M(r)` equals entrywise the 3×3 catalecticant of `b(r)` (row `i` gives `(b_i, b_{i+1}, b_{i+2})`),
and its determinant expands to exactly

    D_f(r) = −Δ012 r³ + Δ013 r² − Δ023 r + Δ123,

with `Δ_I = det` of columns `I` of `C_f` — signs confirmed by exact sympy expansion (difference
identically zero). The `r = ∞` value is consistent: the leading coefficient `−Δ012` vanishes iff
`det Cat3(b(∞)) = det Cat3((a0..a4)) = Δ012 = 0`, so the homogenized binary cubic counts ∞
correctly among the ≤ 3 zeros.

## 3. rank C_f ≤ 2 ⟺ line in secant cubic ⟺ quadratic-gcd — VERIFIED

- **Four maximal minors of a 3×4 matrix vanish ⟺ rank ≤ 2:** standard, and since the four
  coefficients of `D_f` are exactly the four maximal minors (up to sign, item 2),
  `rank C_f ≤ 2 ⟺ D_f ≡ 0 ⟺ ℓ_f ⊂ {secant cubic}`, and `rank C_f = 3 ⟹ D_f ≢ 0 ⟹` at most three
  rational `r` (including ∞) on the secant cubic.
- **Secant-cubic identification:** C491 §6 states `J(f) = 0` cuts the secant variety in char ≥ 5
  (via KPP), `J` being the quartic catalecticant determinant up to scalar. Independently of that
  citation, the property C498 actually needs is: `D_f(r) = 0 ⟺ b(r)` is on `C`, degenerate, or in
  the quadratic-gcd (T/S/rational-secant) stratum. Direct proof: an apolar quadratic `h` for a
  quartic `b` off `C` gives `h·⟨T,U⟩ ⊆ ker H(b)` and hence pencil `= h·⟨T,U⟩`, i.e. gcd `h`;
  conversely gcd-2 pencils have the gcd as apolar quadratic; so `det Cat3(b) = 0 ⟺ rank ≤ 2 ⟺`
  gcd-2 or `b ∈ C`. **Computationally verified at every one of the 6,000 fibres** `(f, r)` in
  `scriptD_f29.py`: `D_f(r) = 0` held exactly when the downstairs pencil had gcd 2 or was
  degenerate — zero mismatches.
- **Upstairs: trivial-gcd ⟹ rank C_f = 3, and rank ≤ 2 ⟺ quadratic gcd:** same apolarity
  argument one level up (an apolar cubic `g` gives `g·⟨T,U⟩ ⊂ W`; two independent apolar cubics
  force a common quadratic factor by the dimension count `dim(g1⟨1,t⟩ + g2⟨1,t⟩) ≤ 3`, hence
  `W = Q·Sym²`). **Exhaustive F_7 check** (`scriptB_f7.py`, all 19,608 points of `P^5(F_7)`):
  off `C` (8 points, all rank ≤ 1), gcd-degree 2 ⟺ rank `C_f` ≤ 2 with zero exceptions
  (392 gcd-2 points, all rank ≤ 2; all 19,208 others rank 3). Also confirmed on all 200 F_29
  samples.
- **Bonus finding (needed later, §5):** gcd-degree exactly 1 **cannot occur** at redundancy six:
  the F_7 scan found none, and the reason is structural — if gcd `= (t−t₀)` then the full
  3-dimensional cofactor space lies in `ker H(b(t₀))`, forcing `rank H(b(t₀)) ≤ 1`, i.e.
  `b(t₀) ∈ C ∪ {0}`; then the cofactor space is `(t−u)·Sym²` and the gcd has degree ≥ 2,
  contradiction. C498 nowhere states this; see §5.

## 4a. Secant-cubic budget ≤ 3 — VERIFIED

Immediate from items 2–3: for trivial-gcd `f`, `D_f` is a nonzero binary cubic, ≤ 3 zeros on
`P^1(F_q)` including ∞. Observed maximum in the F_29 audit: exactly 3 (bound is sharp).

## 4b. Projected Veronese surface: degree 4, no lines, ≤ 4 intersection — VERIFIED WITH CAVEAT

- **Degree 4 (char ≥ 5):** the parametrization `q = αs²+βst+γt² ↦ q²` is `P^2 → P^4` by the
  degree-2 system `(α², 2αβ, β²+2αγ, 2βγ, γ²)`; it is injective on points (char ≠ 2: `q² = λq'²`
  forces `q ∼ q'`), so `deg V = (2H)² = 4`.
- **No lines:** a line `L ⊂ V` would pull back to a curve `D ⊂ P^2` of degree `d ≥ 1` with image
  degree `2d ≥ 2 > 1` (the map is birational onto `V`), contradiction. Char ≥ 5 only needs
  char ≠ 2. Empirical: `scriptC_lines.py` scans all lines through pairs of surface points over
  F_7 and F_11: **no full line; maximum rational intersection 3** (≤ 4 as claimed).
- **≤ 4 intersection for `ℓ_f ⊄ V`:** a line not contained in a degree-4 surface meets it in a
  scheme of length ≤ 4 (cut with a generic hyperplane through the line: the residual degree-4
  curve contains the intersection). Rational points ≤ 4. Observed maximum in the F_29 audit: 2.
- **CAVEAT (coordinates):** C498 writes `V = {[q(s,t)²]} ⊂ P^4` without specifying the coordinate
  dictionary. In **syndrome coordinates** the cyclic locus is `{b : Σ C(4,i) b_i s^i t^{4−i}` is a
  square`}` — the binomially rescaled image `diag(1,4,6,4,1)^{-1}·(squares)`, not the plain
  coefficient squares. Determined empirically: in the F_29 audit the deep gcd-0 fibres lay in the
  rescaled set (4/4) and not the plain set (0/4); then **exhaustively confirmed**
  (`scriptE_cyclic.py`): the 435 gcd-0 deep points of `P^4(F_29)` are **exactly** the rescaled
  squares of split rational quadratics (O⁺ at 29 ≡ 2 mod 3; count `q(q+1)/2 = 435`; the 406
  irreducible-quadratic squares are all non-deep, matching C491's `O⁻` rule; zero deep gcd-0
  points off the surface). Since the two sets differ by an invertible diagonal map (p ≥ 5),
  degree, line-freeness, and the ≤ 4 bound transfer; the caveat is presentational, not
  mathematical. The containment "tame cyclic stratum ⊂ V" itself is forced by C491 Lemma 6(2a):
  every tame cyclic point is `Osc(t1) ∩ Osc(t2)`, i.e. (a scaling of) `((T−t1U)(T−t2U))²` — a
  square — for rational or conjugate pairs alike.

## 4c. Pointed ramification budget ≤ 6 — VERIFIED

- **Equivalence:** "the quotient pencil at `r` has common root `r`" ⟺ every `W`-member vanishing
  at `r` equals `(t−r)g` with `g(r) = 0` ⟺ vanishes doubly at `r` (direct from item 1). Then the
  net's vanishing-order sequence at `r` is `(0, 2, ≥3)` (orders in a linear system are strictly
  increasing; order 0 occurs by basepoint-freeness), so the Wronskian vanishes at `r` (order
  ≥ 2, in fact). So pointed gcd-1 collisions are a subset of the Wronskian divisor.
- **Basepoint-freeness from trivial gcd:** gcd over F_q equals gcd over F̄_q (Euclid is
  field-stable), so trivial gcd ⟹ no common zero ⟹ base-point-free `g²₄`. Correct.
- **Degree 6:** sympy on three generic symbolic quartics: the Wronskian polynomial has raw degree
  exactly 6 (coefficients of `t^7, t^8, t^9` are identically zero; `t^6` coefficient generically
  nonzero). Matches Plücker: total ramification of a base-point-free `g^r_d` on genus-g curve is
  `(r+1)d + r(r+1)(g−1) = 3·4 − 6 = 6`, which is what `(2+1)(4+2(0−1))` computes. The ∞ chart is
  covered: when the affine Wronskian degree drops below 6, ∞ carries the missing multiplicity
  (implemented that way in the F_29 audit; max observed distinct Wronskian roots: 4 ≤ 6).
- **Not identically zero in char p ≥ 5:** Wronskian vanishing identically would force the three
  quartics linearly dependent over `F_q(t^p)`; writing the dependence and separating monomials by
  residue of degree mod p (all quartic degrees ≤ 4 < p) reduces it to dependence of constant
  coefficient vectors over `F_q(t^p)`, hence over `F_q` — contradiction with independence. Solid
  for p ≥ 5; confirmed nonzero on all 200 F_29 samples.

## 4d. S₃ fiber-square budget and q ≥ 29 — VERIFIED

- **Genus / bound direction:** `Y_b` has bidegree (2,2) on `P^1×P^1`, arithmetic genus
  `(2−1)(2−1) = 1`. Aubry–Perret as used in C491 Lemma 7:
  `#Y(F_q) ≥ q+1 − 2g√q − (p_a − g) ≥ q − 2√q` for `g ≤ p_a = 1` (worst case `g = 1`). Correct
  direction (lower bound on rational points of an absolutely irreducible possibly-singular curve).
- **Absolute irreducibility — the crux question:** C491 **proves it for every S₃ fibre, not
  generically**: Lemma 7's proof — "components over F̄_q correspond to orbits of the geometric
  monodromy on ordered pairs of distinct roots, and S₃ is transitive on them" — applies to any
  `b` whose `φ_b` has geometric monodromy S₃, which is the definition of the stratum. So C498's
  char ≥ 5 theorem depends on no unproved irreducibility claim. (The C512-handoff remark about
  "level-specific monodromy of each new lower splitting cover" concerns the redundancy-seven
  program, not this theorem: here the only cover used is C491's, with Lemma 7 in hand.)
- **Deletions:** diagonal ≤ 4 (`Y·Δ = 4`, `Δ ⊄ Y` by separability — separability holds since
  p ≥ 5 excludes inseparable degree-3 maps) plus branch ≤ 8, total 12, exactly as C491 Lemma 7.
  Pointed deletion: for non-budgeted `r` the pencil member through `r` is unique (all-members
  case is the pointed collision, already in the Wronskian budget), a cubic has ≤ 3 distinct
  roots hence ≤ 6 ordered pairs; a surviving `Y`-point's member is well-defined (two members
  through the same distinct pair would force gcd ≥ 2) and distinct from the member through `r`,
  so avoids `r`. ≤ 6 is right.
- **Threshold:** `q − 2√q > 18`: q=25 gives 15.0 (fails), q=27 gives 16.608 (fails), q=29 gives
  18.230 (holds), increasing thereafter; no prime power in (27,29). So q ≥ 29 is exactly right
  for prime powers, and q=25 (char 5, below threshold) is correctly covered by census instead.

## 4e. Total budget logic and stratum trace — VERIFIED WITH CAVEAT

Trace of every possible C491 stratum of `b(r)`, p ≥ 5, q ≥ 29, trivial-gcd `f`:

| downstairs stratum of b(r) | budgeted / handled by | status |
|---|---|---|
| `b(r) ∈ C` or degenerate | secant cubic (`rank Cat ≤ 1 ⟹ D = 0`) | budgeted (≤ 3 total) |
| gcd-2: tangent T, sigma S (deep), rational secant | secant cubic (`gcd-2 ⟺ D = 0`, proved §3 and verified per-fibre) | budgeted (same ≤ 3) |
| tame cyclic O± — deep **or not** | `V` (Lemma 6(2a): cyclic point = square) | budgeted (≤ 4) |
| char-3 nucleus / wild | impossible, p ≥ 5 | — |
| inseparable φ | impossible, p ≥ 5 (degree 3 needs p = 3) | — |
| sporadic S₃ orbits | impossible for q ≥ 23 by C491 Lemma 7 (census-independent) | — |
| gcd-1, common root = r | Wronskian (pointed collision ⟹ ramification, §4c) | budgeted (≤ 6) |
| gcd-1, common root ≠ r | pointed graph argument | **caveat, see below** |
| S₃ | punctured Lemma 7, q ≥ 29 | supplies split member avoiding r |

Key point the prompt flagged: **the persistent tangent/sigma stratum downstairs is contained in
the secant cubic** — yes, exactly the gcd-2 ⟺ `D = 0` equivalence of §3, verified symbolically,
by the apolarity argument, and at all 6,000 F_29 fibres. So the "deep at every q" T/S fibres cost
at most the 3 secant-cubic points and can never silently absorb the whole line (that would need
`rank C_f ≤ 2`, i.e. quadratic gcd upstairs, excluded by hypothesis). Budget arithmetic:
`3 + 4 + 6 = 13 < q+1 = 30` at q = 29, so a good `r` exists; the overlap of budgets only helps.

**Caveat (only genuine one):** C498 writes "C491's gcd-one graph argument … gives a split cubic
avoiding r". C491 Lemma 5 proves existence of a split member of a gcd-1 pencil but has **no
avoiding-r refinement**; the pointed version needs two extra deletions (pairs with `t = r` or
`ιt = r`) plus `t₀ ≠ r` (guaranteed off the Wronskian budget), leaving `≥ q+1−10 > 0` witnesses —
immediate for q ≥ 29, but it is a (two-line) new lemma of C498, mis-attributed to C491. No error,
attribution/rigor caveat only.

**Direct computational test of the theorem's conclusion at the threshold field**
(`scriptD_f29.py`, seed 498): 200 random trivial-gcd `f` over F_29 —

- **200/200 have a totally split squarefree member** in `ker H_f` (direct scan of all 871
  projective members per net);
- per line: max #bad r (no split cubic avoiding r) = **2**, far under 13; max secant-cubic
  r's = 3, max V r's = 2, max Wronskian r's = 4;
- **every** bad `r` was in the stated budget (zero unbudgeted failures across 6,000 fibres);
- `trivial gcd ⟺ rank C_f = 3` held on all samples.

And exhaustively (`scriptE_cyclic.py`): the deep gcd-0 locus of `P^4(F_29)` is exactly the 435
O⁺ points, all on the (rescaled) Veronese surface — confirming that at q = 29 the only trapping
strata for `b(r)` are precisely the three budgeted ones.

## 5. Theorem-statement consistency (q ≥ 17 corollary) — VERIFIED WITH CAVEAT

- Char ≥ 5 prime powers with 17 ≤ q < 29 are exactly {17, 19, 23, 25} (27 = 3³ excluded by the
  characteristic hypothesis; 25 = 5² has characteristic exactly 5, which "at least five"
  includes — and the char-5 tangent-orbit split at q=25 affects orbit refinement only, not
  deepness). All four are census rows with **0 trivial-gcd exceptional points** (table lines
  58–61), so theorem (q ≥ 29) + census (17–25) covers every char ≥ 5 field q ≥ 17. ✓
- Persistent-stratum count `q(q+1)²/2` matches every relevant census row: 2754 (17), 3800 (19),
  6624 (23), 8450 (25); and at q=7 the deep gcd-2 subcount 224 = 56 tangent + 168 sigma matches
  the bundle derivation (the 392 total gcd-2 points minus the 168 split-quadratic non-deep ones).
- gcd-2 deepness itself (square or irreducible common factor blocks any totally split squarefree
  member) is immediate and characteristic-free. ✓
- **CAVEAT (silent step):** "deep set is exactly the persistent quadratic-gcd stratum" needs, in
  addition to the trivial-gcd theorem, that **no gcd-degree-1 deep net exists at q ≥ 29**. The
  report never addresses gcd-1 nets. They are in fact impossible at redundancy six (proof in §3
  bonus finding: a degree-1 gcd forces `b(t₀) ∈ C` and then a degree-≥2 gcd, contradiction;
  exhaustively confirmed at F_7 — zero gcd-1 points among all 19,608), so the corollary is true,
  but the report's argument as written has this unstated (easily repaired) step. Also, reading
  "deep" via the span definition at q ≥ 29 uses ρ = 5 from Seroussi–Roth (q ≥ 9 suffices), which
  the report invokes correctly.

## Summary of verdicts

| # | claim | verdict |
|---|---|---|
| 1 | contraction identity (2), pencil, line parametrization | VERIFIED |
| 2 | Cauchy–Binet identity (3) incl. signs | VERIFIED |
| 3 | rank ≤ 2 ⟺ line ⊂ secant cubic ⟺ quadratic gcd | VERIFIED |
| 4a | secant-cubic budget ≤ 3 | VERIFIED |
| 4b | Veronese: degree 4, no lines, ≤ 4 | VERIFIED WITH CAVEAT (coordinate dictionary unstated; rescaled coords pinned down, math unaffected) |
| 4c | pointed ramification ⟺ Wronskian, degree 6, tame nonvanishing | VERIFIED |
| 4d | punctured S₃ bound, q ≥ 29; absolute irreducibility is proved in C491 for all S₃ fibres | VERIFIED |
| 4e | total budget / stratum coverage; F_29 direct test 200/200 | VERIFIED WITH CAVEAT (pointed gcd-1 avoidance is a new easy lemma mis-attributed to C491) |
| 5 | q ≥ 17 corollary from theorem + census | VERIFIED WITH CAVEAT (gcd-1 impossibility needed and unstated, though provable and F_7-confirmed) |

No error was found in any load-bearing step. The two caveats in 4e/5 are gaps of exposition with
short proofs supplied above, not gaps of truth; 4b's caveat is purely notational. The theorem

> for every prime power q ≥ 29 of characteristic at least five, every trivial-gcd Hankel net of
> binary quartics contains a totally split squarefree member

stands as stated, and its q ≥ 17 corollary stands once the gcd-1 impossibility remark is added.

## Key numbers

- q − 2√q: 15.0 (q=25), 16.608 (q=27), 18.230 (q=29); threshold 18 crossed exactly at 29.
- Budget: 3 (secant cubic) + 4 (Veronese) + 6 (Wronskian) = 13 < 30 = q+1 at q=29.
- F_7 exhaustive: 19,608 points; 8 on C; 392 gcd-2 ⟺ rank ≤ 2 exact; 0 gcd-1.
- F_29 random audit: 200/200 split member; max bad r = 2; 0 unbudgeted bad fibres of 6,000.
- F_29 exhaustive downstairs: 435 deep gcd-0 points = O⁺ = split-quadratic squares, 0 off-surface.
- Lines vs squares surface: max rational intersection 3, no full lines (F_7, F_11).
