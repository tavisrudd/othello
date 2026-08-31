# C1014 -- marking loss and reconstruction for the Phi_{2m,4} square-class coloring

**Lane:** clebsch
**Task:** C1014 threads 4 and 6 (automorphism groups of the induced colorings;
exact marking fibres and query complexity) -- the family-level generalization of
Paper V's excess-automorphism mechanism from m = 2 to all m.
**Scope:** research note only.  No manuscript, Ergodis, or Lean source edited.
**Generator:** `notes/clebsch-tasks/c1014_marking_reconstruction.py`.

Replay (whole note's computational content, about four minutes):

```text
uv run --with sympy python3 notes/clebsch-tasks/c1014_marking_reconstruction.py
```

Every claim below carries one of three labels: **PROVED** (human proof given
here), **COMPUTED-EXACT (range)** (exhaustive machine verification over a stated
finite range, no sampling), **CONJECTURED**.

---

## Executive summary

1. The four-point Gram invariant has GL_2-weight `det^{4d}`, a perfect square,
   and point-weight `2d`, also even.  So the square-class coloring of unordered
   4-subsets of P^1(F_q) is **never twisted** by chi o det: it is honestly
   PGL_2(F_q)-invariant for every degree d and every odd q, and also invariant
   under Gal(F_q/F_p).  There is no PSL_2 case to handle (section 1).
2. The coloring of a 4-set is `chi(G_r(lambda))` with `r = 2m mod (q-1)`, a
   function of the anharmonic S_3-orbit of the cross-ratio alone, so it descends
   to the j-line (section 1).
3. **Reconstruction dichotomy (main theorem, section 3).**  For every odd prime
   power q and every m, exactly one of the following holds:
   * the coloring is constant, and `Aut = Sym(q+1)`: total marking loss;
   * the coloring is nonconstant, and `Aut = PGammaL_2(F_q)` exactly: the
     shadow recovers the entire projective structure.

   Nothing in between ever occurs.  The exceptional set is exactly the strata on
   which the coloring is constant *including its zeros*, a proper subset of the
   constant-character strata classified in the C1014 modular-structure report;
   no further exceptional (m, q) exists.  In particular the earlier report's
   lone unexplained stratum `(p, r) = (47, 30)` reconstructs perfectly.
4. **Exact marking fibre (section 4).**  In the reconstructing case the fibre is
   `Aut / PGL_2 = Gal(F_q/F_p)`, cyclic of order e = log_p q -- **independent of
   m**.  Over a prime field the marking is recovered on the nose; over F_{p^2}
   the residual ambiguity is exactly one Frobenius torsor of order two.  This is
   the family-level analogue of Paper V's residual C_2, and it is a genuine
   torsor under an explicit group.
5. **New degenerate stratum, visible only over non-prime fields (section 2.4).**
   Over F_{p^2} at `r = p+1` the coloring becomes the **Baer-subline coloring**:
   color 0 exactly on the 4-sets lying on a Baer subline, color +1 elsewhere,
   the color -1 never occurring.  The zero-locus blocks are the circles of the
   Miquelian inversive plane of order p.  This is the unique place in the entire
   sweep where partition refinement fails, and the only case needing the
   inversive-plane recognition theorem (or exhaustive search) rather than
   refinement.
6. **New collapse stratum (section 2.3).**  Over F_{p^e} the total-collapse
   stratum of Theorem B has Frobenius twists: `r = 2 p^i` also gives
   `G_r == 0` identically.  Over a prime field these coincide with r = 2; over
   F_{p^2} the extra stratum r = 2p is a second, previously unrecorded, total
   collapse.
7. Paper V / C1011 is reproduced exactly as the (m, q) = (2, 11) point:
   165 positive 4-sets forming a 3-(12,4,3) design on the harmonic orbit
   {2, 6, 10} = {2, -1, 1/2}, and `|Aut| = 1320 = |PGL_2(11)|`.

**Query complexity (section 5).**  Reconstruction up to the fibre needs at least
`ceil((q-1)/4)` queries (touching bound, PROVED) and at least
`log_3( (q+1)! / |PGammaL_2(q)| ) = Theta(q log q)` queries (counting bound,
PROVED); `(q-2)(3q-7)/2 = O(q^2)` non-adaptive queries suffice for every
nonconstant (m, q) with q <= 121 except the five Baer instances
(COMPUTED-EXACT), where a cubic query set is needed and the quadratic one
provably is not.

---

## 0. Setup and conventions

V is 2-dimensional over F_q, q odd.  For v, w in V write [v,w] = det(v,w).  The
degree-d Veronese carries the invariant form normalized by
`B_d(l^d, m^d) = [l,m]^d`.  For four points p_1..p_4 of P^1(F_q) with
representative vectors v_1..v_4,

```
G_{d,4}(v_1..v_4) = det( [v_i, v_j]^d )_{i,j}      (a hollow 4x4 determinant).
```

Normalizing (p_1..p_4) = (infty, 0, 1, lambda) with vectors
(1,0), (0,1), (1,1), (lambda,1) gives `G_{d,4} = Delta * Phi_{d,4}(lambda)`,
`Delta = lambda^2 (1-lambda)^2`, and for d = 2m the compact form used throughout
the C1013/C1014 reports,

```
G_{2m,4}(lambda) = ( 1 - lambda^{2m} - (1-lambda)^{2m} )^2
                   - 4 ( lambda(1-lambda) )^{2m}.
```

The coloring under study is, for an unordered 4-subset S of P^1(F_q),

```
c(S) = chi( G_{2m,4}(S) )  in  {0, +1, -1},   chi the quadratic character of F_q.
```

Symbolic validation (COMPUTED-EXACT, m = 2..6): the hollow determinant equals
the compact form on the nose; Phi = G/Delta lies in Z[lambda];
`Phi(1-lambda) = Phi(lambda)`; `lambda^{4m-6} Phi(1/lambda) = Phi(lambda)`;
and the determinant scales by `s^{2d}` when one representative vector is scaled
by s.

---

## 1. Invariance, normal form, and the exact dictionary

### 1.1 Weight of the invariant, and why there is no twist

**Theorem 1 (weights).  PROVED.**  Let r be the number of points and d the
Veronese degree.  In the expansion of the hollow r x r determinant only
fixed-point-free permutations sigma contribute, and the term
`prod_i [v_i, v_{sigma(i)}]^d` uses each index once as a left and once as a
right bracket argument.  Hence:

* `G_{d,r}` is homogeneous of degree **2d** in each v_i separately;
* for g in GL_2(F_q), `G_{d,r}(g v_1, .., g v_r) = det(g)^{rd} G_{d,r}(v_1,..,v_r)`,
  because each of the r bracket factors of a term picks up one det(g)^d.

**Corollary 1.1 (no chi o det twist at r = 4).  PROVED.**  Rescaling
representatives `v_i -> c_i v_i` multiplies G by `(prod_i c_i^d)^2`, a square;
and for r = 4 the group weight is `det(g)^{4d} = (det(g)^{2d})^2`, also a square.
Therefore

```
S |-> chi( G_{d,4}(S) )
```

is a well-defined function of the *unordered 4-subset* S of P^1(F_q), and it is
invariant under the full PGL_2(F_q) for **every** d and every odd q.  There is no
(m, q) for which the four-point coloring is only PSL_2-invariant.

*Remark (where a twist would occur).*  The general rule from Theorem 1 is that
the r-point coloring is twisted by chi o det exactly when `rd` is odd.  With
r = 4 that never happens; the first twisted case is r = 3 with odd d, which does
not arise in the family `d = 2m`.  So the correct group here is PGL_2, not
PSL_2, uniformly.

**Corollary 1.2 (semilinear invariance).  PROVED.**  The Frobenius x -> x^p acts
on P^1(F_q), commutes with taking square classes (chi(x^p) = chi(x)), and sends
G to its Frobenius image.  Hence `Aut(coloring) contains PGammaL_2(F_q)`, of
order `e * (q+1) q (q-1)` with `e = log_p q`.  (Randomized sanity check,
200 PGL_2 elements and 200 Frobenius tests at q = 9, 11, 13, 23, 25, 49: zero
failures.)

### 1.2 Normal form: the coloring is a function on the j-line

Since `Delta = (lambda(1-lambda))^2` is a square whenever the four points are
distinct, `chi(G) = chi(Delta * Phi) = chi(Phi)`, and Corollary 1.1 forces
`chi o Phi` to be constant on anharmonic S_3-orbits.  Directly:
`Phi(1-lambda) = Phi(lambda)` and `lambda^{4m-6} Phi(1/lambda) = Phi(lambda)`
with `4m-6` even.  This re-derives the anharmonic invariance (the modular
report's Theorem H) as an immediate consequence of the bracket weight, rather
than as a computation.

**Exponent reduction (PROVED, restating Theorem 0 over F_q).**  For
lambda in F_q^*, `lambda^{2m}` depends only on `r := 2m mod (q-1)`.  Hence the
coloring depends only on r, and the fundamental window is `m = 1..(q-1)/2`,
mapping bijectively onto the even residues r mod (q-1).  (COMPUTED-EXACT: zero
mismatches between `chi(Phi_{2m,4})` and `chi(G_r)` for m = 2..8 over
q = 5, 7, 9, 11, 13, 17, 25.)

**The dictionary.**  Writing `I = lambda^2 - lambda + 1` and
`j = 256 I^3 / Delta`:

```
{4-subsets of P^1(F_q)}  --cross-ratio-->  F_q \ {0,1}
                         --anharmonic S_3-->  j-line
                         --chi o G_r-->  {0, +, -}
```

The middle arrow is the PGL_2-orbit map: PGL_2(F_q) is sharply 3-transitive, so
4-subsets modulo PGL_2 correspond exactly to anharmonic orbits (S_4 acts on the
orderings and the Klein group acts trivially on lambda, so S_4/V_4 = S_3 acts).
Orbit data (PROVED, verified COMPUTED-EXACT for q <= 25):

| lambda-orbit | size | 4-set stabilizer in PGL_2 | 4-set orbit size |
|---|---|---|---|
| generic                            | 6 | V_4 (order 4)  | \|PGL_2\|/4  |
| harmonic, lambda in {-1, 2, 1/2}   | 3 | D_4 (order 8)  | \|PGL_2\|/8  |
| equianharmonic, I(lambda) = 0      | 2 | A_4 (order 12) | \|PGL_2\|/12 |

The equianharmonic orbit exists iff q = 1 mod 3; in characteristic 3 the
harmonic and equianharmonic orbits fuse into the single point lambda = -1.
Number of PGL_2-orbits on 4-subsets, for q not divisible by 3:

```
  N(q) = (q - 5 - 2 eps)/6 + 1 + eps,      eps = 1 if q = 1 mod 3, else 0,
```

giving 1, 2, 2, 3, 3, 5 at q = 5, 7, 11, 13, 17, 25 (COMPUTED-EXACT, matches).

**Consequence (PROVED).**  A PGL_2-invariant coloring can be nonconstant only if
N(q) >= 2, i.e. only for `q >= 7`.  At q = 3 and q = 5 the coloring is constant
for every m, with no arithmetic input at all.

---

## 2. Automorphism census

### 2.1 Method and why the certificate is exact

`Aut` denotes the group of permutations of P^1(F_q) preserving the 4-set
coloring.  Since `Aut` contains the 3-transitive PGL_2(F_q),

```
|Aut| = |H| * (q+1) q (q-1),    H := Aut fixing infty, 0, 1 pointwise,
```

and `H` contains Gal(F_q/F_p), of order e.  So the whole question is
whether `|H| = e`.

H acts on `X = F_q \ {0,1}`, which is identified with the remaining points by
`lambda <-> {infty, 0, 1, lambda}`.  Two sound invariants are used:

* vertex color `v(lambda) = c({infty,0,1,lambda}) = chi(G_r(lambda))`;
* edge color `e(lambda,mu)` = the ordered triple of colors of
  `{infty,0,lambda,mu}`, `{infty,1,lambda,mu}`, `{0,1,lambda,mu}`, i.e.
  `chi(G_r)` evaluated at `mu/lambda`, `(1-mu)/(1-lambda)` and
  `lambda(1-mu)/(mu(1-lambda))`.

One-dimensional Weisfeiler--Leman refinement on (X, v, e) is then iterated; every
element of H preserves the stable coloring, so **a discrete stable partition is a
proof that H = 1**, and more generally iterated individualization gives the sound
bound `|H| <= prod_i |C_i|` over the cells C_i of the individualized points.  Two
cases:

* if the bound equals e, then `H = Gal` and `Aut = PGammaL_2(q)` **exactly**,
  with no appeal to the classification of finite simple groups;
* otherwise an exhaustive backtracking enumeration of H is run.  It extends a
  partial map only when *every* 4-set inside the already-mapped domain keeps its
  color, so it is complete (prunes no automorphism) and sound (a completed leaf
  is a genuine automorphism).

### 2.2 The sweep

Range: every odd prime power `q <= 121` that is a prime or the square of a prime
(29 primes 3..113, plus 9, 25, 49, 121), and every r in the fundamental window
`m = 1..(q-1)/2`.  That is **881 pairs (q, r)**, i.e. the complete family modulo
the proved periodicity.  The fields 27 and 81 (extension degree 3 and 4) are
outside the sweep, so every statement below labelled COMPUTED-EXACT is for
`e <= 2`; Theorem 4 itself has no degree restriction.

**COMPUTED-EXACT (all 881 pairs):**

| outcome | count | conclusion |
|---|---|---|
| coloring constant                           |  77 | `Aut = Sym(q+1)` (immediate) |
| nonconstant, refinement discretizes to e    | 799 | `Aut = PGammaL_2(q)`, CFSG-free certificate |
| nonconstant, refinement insufficient        |   5 | all five are the Baer stratum, section 2.4 |

**There is no partial collapse anywhere in the range**: not a single (m, q) has
`PGammaL_2(q) < Aut < Sym(q+1)`.  This is the sharpest empirical statement of
the section, and section 3 proves it holds for all q.

Per-field counts of constant r (COMPUTED-EXACT):

| q | # r in window | # constant r | constant r, with stratum |
|---|---|---|---|
| 3 | 1 | 1 | 0 (A) |
| 5 | 2 | 2 | 0 (A), 2 (B) |
| 7 | 3 | 2 | 0 (A), 2 (B) |
| 9 | 4 | 3 | 0 (A), 2 (B), 6 (B o Frob) |
| 11, 13, 19, 29, 31, 37, 41, 43, 47, 59, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107 | -- | 2 | 0 (A), 2 (B) |
| 17, 53, 61, 109, 113 | -- | 3 | 0 (A), 2 (B), (q-1)/2 (C) |
| 23 | 11 | 3 | 0 (A), 2 (B), 12 (G) |
| 25 | 12 | 3 | 0 (A), 2 (B), 10 (B o Frob) |
| 49 | 24 | 4 | 0 (A), 2 (B), 14 (B o Frob), 24 (C) |
| 121 | 60 | 4 | 0 (A), 2 (B), 22 (B o Frob), 60 (C) |

This reproduces every stratum of the prime-field classification (Theorems A, B,
C, G of the earlier C1014 reports) and adds the prime-power rows, which had not
been computed before.

### 2.3 A new total-collapse stratum: Frobenius twists of Theorem B

**Theorem 2 (Frobenius-twisted collapse).  PROVED.**  Let `q = p^e` and
`r = 2 p^i mod (q-1)` for any `0 <= i < e`.  Then `G_r == 0` identically on
`F_q \ {0,1}`, so every 4-set has color 0 and `Aut = Sym(q+1)`.

*Proof.*  Let `phi(x) = x^{p^i}`, a field automorphism fixing 4 and 1.  For
lambda in F_q^*, `lambda^{2p^i} = phi(lambda^2)`, and likewise for `(1-lambda)`
and for `u = lambda(1-lambda)`.  Hence

```
G_{2p^i}(lambda) = ( phi(1 - lambda^2 - (1-lambda)^2) )^2 - 4 phi(u^2)
                 = phi( (1 - lambda^2 - (1-lambda)^2)^2 - 4u^2 )
                 = phi( G_2(lambda) ) = phi(0) = 0,
```

using Theorem B (`G_2 == 0`) in the last step.  QED

Over a prime field this collapses back to r = 2.  Over F_{p^2} the value i = 1
gives the second collapse stratum r = 2p, which is exactly the extra constant
row observed at q = 9, 25, 49, 121 (r = 6, 10, 14, 22).  COMPUTED-EXACT for
p = 3, 5, 7, 11: the color value set at r = 2 and at r = 2p is {0} in both cases.

In m-language the collapse strata are `m = p^i mod (q-1)/2`.

### 2.4 A new degenerate-but-reconstructing stratum: the Baer/inversive coloring

All five residual cases of the sweep are `q = p^2` with `r = p+1` (and, at
q = 25, also `r = 3(p+1) = 18`, whose coloring is literally identical to the
one at r = 6).  Their common structure:

**Theorem 3 (Baer stratum).  PROVED.**  Let `q = p^2` and `r = p+1`, so
`lambda^r = N(lambda)` is the norm to F_p.  Then

1. `G_r(lambda)` lies in F_p for every lambda, hence is either 0 or a square in
   F_q; the color -1 never occurs.
2. `G_r(lambda) = 0` if and only if `lambda in F_p`.

*Proof.*  (1) `G_r = (1 - N(lambda) - N(1-lambda))^2 - 4 N(u)` is built from
norms, so it lies in F_p; and every element of F_p^* is a square in F_{p^2}
because `x^{(q-1)/2} = (x^{p-1})^{(p+1)/2} = 1` there.

(2) If lambda is in F_p then `N(lambda) = lambda^2`, `N(1-lambda) = (1-lambda)^2`,
`N(u) = u^2`, and `G_r = (2u)^2 - 4u^2 = 0` -- the exponent acts like r = 2, i.e.
Theorem B restricted to the subfield.  Conversely suppose `G_r(lambda) = 0`.
Since `r = p+1` is even, put `t = lambda^{(p+1)/2}`, `w = (1-lambda)^{(p+1)/2}`;
then `G_r = (1-t^2-w^2)^2 - 4 t^2 w^2 = (1-(t+w)^2)(1-(t-w)^2)`, so
`t + eps w = eta` for some signs eps, eta in {+1,-1}.  Now
`t^2 = N(lambda)` lies in F_p^*, so `t^{p-1} = +-1` and therefore t lies in
`F_p` or in `nu F_p` where `nu^2` is a non-square of F_p; same for w.  If both
lie in `nu F_p` then `t + eps w` lies in `nu F_p` and cannot equal
`eta = +-1`; if exactly one does, the `nu`-component must vanish, forcing
lambda = 0 or 1.  So t, w lie in F_p.  Applying Frobenius to
`1 - lambda = (1-lambda)` gives `1 - N(lambda)/lambda = N(1-lambda)/(1-lambda)`,
i.e.

```
   lambda^2 - lambda ( 1 + t^2 - w^2 ) + t^2 = 0.
```

Substituting `t = eta - eps w` and setting `c = eta eps w in F_p` gives
`t^2 = 1 - 2c + c^2` and `1 + t^2 - w^2 = 2(1-c)`, so the quadratic becomes
`(lambda - (1-c))^2 = 0`, i.e. `lambda = 1 - c in F_p`.  QED

**Corollary 3.1 (the coloring is an inversive plane).  PROVED.**  Four points of
P^1(F_{p^2}) have cross-ratio in F_p exactly when they lie on a common Baer
subline (the PGL_2(p^2)-images of P^1(F_p)); three points determine a unique
subline.  So the color-0 4-sets of the r = p+1 coloring are precisely the
4-subsets of Baer sublines, the circles are recovered as the maximal sets all of
whose 4-subsets have color 0, and the coloring is equivalent to the block
structure of the **Miquelian inversive (Mobius) plane of order p**.  Its
automorphism group is `PGammaL_2(p^2)` by the classical recognition theorem
(Dembowski, *Finite Geometries*, section 6.4), so `Aut = PGammaL_2(p^2)`.

COMPUTED-EXACT for q = 9, 25, 49, 121: the zero locus equals `F_p \ {0,1}` on the
nose; the only other color is +1; the circle through infty, 0, 1 is
`P^1(F_p)`, has p+1 points, all of its 4-subsets have color 0, and no point
outside it extends the circle; the number of circles is
`(q+1)q(q-1) / ((p+1)p(p-1))` = 30, 130, 350, 1342.

**Independent exhaustive certificate.**  For q = 9, 25, 49 the backtracking
search over all of H returns exactly two elements, the identity and the
Frobenius, i.e. `|Aut| = 2 |PGL_2(p^2)|` (nodes explored: 65, 3393, 225825).
At q = 121 the search is not run; the case rests on Theorem 3 plus
Corollary 3.1, and independently on Theorem 4 below.

*Why refinement fails exactly here.*  The Baer coloring is the most homogeneous
nonconstant member of the family: it is a 3-design-like structure whose
2-anchored data are coset-regular, so 1-WL cannot separate.  It is also the case
where the query complexity genuinely jumps (section 5).

### 2.5 The m = 2 row and Paper V

At `(m, q) = (2, 11)`, i.e. `r = 4`, `Phi_{4,4} = 16 I` and the coloring is
`chi(I(lambda))`.  COMPUTED-EXACT reproduction of C1011 / Paper V:

* 495 four-subsets split as 165 positive, 330 negative, 0 zero;
* the positive lambda values are {2, 6, 10} = {2, -1, 1/2}, the harmonic orbit;
* the positive class is a 3-(12,4,3) design: every point in 55 blocks, every
  pair in 15, every triple in 3;
* refinement discretizes with no individualization, so `H = 1` and
  `|Aut| = 1 * 12 * 11 * 10 = 1320 = |PGL_2(11)|`.

So Paper V's `q = 11` statement is the (2, 11) point of the general theorem, and
its "excess automorphisms" are excess **relative to A_5**, not relative to
PGL_2: at the level of the projective structure the m = 2 shadow at q = 11 is a
perfect reconstructor.  The audit's phrase "A_5-related fibre" refers to the
index-22 coset space `PGL_2(11)/A_5`, which lives strictly below the
family-level fibre computed in section 4.

---

## 3. The reconstruction theorem

**Lemma 4 (overgroups of PGL_2 on q+1 points).  PROVED, modulo CFSG.**  Let q be
an odd prime power and `PGL_2(q) <= G <= Sym(P^1(F_q))`.  Then either
`G = Sym(q+1)` or `G <= PGammaL_2(q)`.

*Proof.*  G contains PGL_2(q), which is 3-transitive, so G is 3-transitive of
degree n = q+1.  The classification of finite 3-transitive groups (a standard
consequence of CFSG via the 2-transitive classification) lists: `A_n`, `S_n`,
`AGL_d(2)` with `n = 2^d`, `2^4 : A_7` with n = 16, the Mathieu groups
`M_11` (degrees 11 and 12), `M_12`, `M_22`, `M_22:2`, `M_23`, `M_24`, and the
groups `PSL_2(q') <= G <= PGammaL_2(q')` of degree q'+1.

The non-split torus of PGL_2(q) is cyclic of order q+1 and acts freely on
P^1(F_q), so PGL_2(q) contains a `(q+1)`-cycle.  Since q is odd, q+1 is even and
that cycle is an **odd** permutation; hence `G` is not contained in `A_n`, and
`G = A_n` is impossible.  All of `AGL_d(2)` (d >= 3), `2^4:A_7`, and every
Mathieu group in the list lie inside the alternating group of their degree, so
none can contain G.  The degrees also rule most of them out arithmetically:
`n = 2^d` forces `q = 2^d - 1`; n = 16, 22, 23 force q = 15, 21, 22, none a prime
power.  The only remaining entry is the last family, with `q' + 1 = q + 1`, so
`q' = q` and `G <= PGammaL_2(q)`.  The degenerate small degrees are consistent:
at q = 3, `PGL_2(3) = S_4 = Sym(n)`; at q = 5, `PGL_2(5) = S_5` is maximal in
`S_6`.  QED

**Theorem 4 (family-level marking dichotomy).  PROVED (modulo CFSG; and
CFSG-free COMPUTED-EXACT for q <= 121).**  Let q be an odd prime power, m >= 1,
and `r = 2m mod (q-1)`.  Let `Aut` be the automorphism group of the
`chi(G_{2m,4})`-coloring of the 4-subsets of `P^1(F_q)`.  Then

```
  Aut = Sym(q+1)          if  lambda |-> chi(G_r(lambda)) is constant on F_q \ {0,1};
  Aut = PGammaL_2(F_q)    otherwise.
```

*Proof.*  If the coloring is constant, every permutation preserves it.  Suppose
it is nonconstant.  By Corollary 1.2, `PGammaL_2(q) <= Aut`, so Lemma 4 gives
`Aut = Sym(q+1)` or `Aut <= PGammaL_2(q)`.  The first is impossible: `Sym(q+1)`
is transitive on 4-subsets, so an `Sym(q+1)`-invariant coloring is constant.
Hence `PGammaL_2(q) <= Aut <= PGammaL_2(q)`.  QED

**Corollary 4.1 (the exceptional set is exactly the constant strata).  PROVED.**
Reconstruction fails for (m, q) if and only if r = 2m mod (q-1) lies in

```
  E(q) = { r even : chi(G_r) constant on F_q \ {0,1} },
```

the sub-collection of the C1014 modular-structure report's constant-character
strata on which the coloring is constant **including its zeros** -- Theorem A
(r = 0), Theorem B and its Frobenius twists (r = 2p^i, Theorem 2 above),
Theorem C (r = (q-1)/2) when chi(-15) = +1 and G_r has no zero, Theorem G
(r = (q-1)/2 + 1) when chi(I) is never +1 on the doubly-nonsquare set and G_r has
no zero, and those small-image `(n, j)` members of the same reduction family with
no zero.  Strata that are constant only off their zero locus -- for instance
`(p, r) = (19, 10)` and `(47, 30)` -- are *not* in E(q) and do reconstruct
(section 7, item 1).  No additional exceptional (m, q) exists; in particular
**the exceptional set is purely arithmetic**, with no geometric or sporadic
exception at any q.

**Corollary 4.2 (harmonic-quadruple route, m = 2).  PROVED.**  At m = 2 the
coloring is `chi(I)`, whose positive class is the harmonic-quadruple design
whenever `chi` separates I-values; Theorem 4 gives `Aut = PGammaL_2(q)` for
every q with `chi(I)` nonconstant, generalizing C1011's q = 11 computation to
all q at one stroke and removing that report's `9!`-candidate finite check.

*Remark on the proof strategy suggested in the task card.*  Attempting to
reconstruct the cross-ratio function directly from the color classes (via the
Dickson factors of `Phi`) is possible in principle but is strictly harder than
needed: once one knows the coloring is `PGammaL_2`-invariant and nonconstant,
3-transitivity plus the 3-transitive classification finishes the job with no
arithmetic input at all.  The arithmetic enters only in deciding *which* (m, q)
are constant, which is exactly the already-solved stratum classification.  The
independent CFSG-free certificate for `q <= 121` (section 2) is what keeps the
result from resting on the classification alone.

---

## 4. Exact marking fibres

Define a **marking** of an abstract (q+1)-set carrying the coloring to be a
bijection with P^1(F_q) compatible with it, taken modulo PGL_2(F_q).  Then the
set of markings indistinguishable from a given one is the coset space
`Aut / PGL_2(F_q)`.

**Theorem 5 (uniform fibre).  PROVED (from Theorem 4).**  For every m and every
odd prime power `q = p^e`:

```
  nonconstant stratum:  Aut / PGL_2(F_q) = Gal(F_q / F_p) = C_e,
                        so exactly e markings are indistinguishable;
  constant stratum:     Aut / PGL_2(F_q) = Sym(q+1) / PGL_2(F_q),
                        of size (q+1)! / ((q+1) q (q-1)) -- total loss.
```

In particular the fibre in the reconstructing case **is always a torsor under an
explicit group, namely the Galois group, and it does not depend on m at all.**
Over prime fields it is trivial: the coloring recovers the marking exactly.  Over
`F_{p^2}` it is the Frobenius `C_2` -- the family-level analogue of Paper V's
residual `C_2`, but arising from a different mechanism (a field automorphism, not
a chordal-line choice).

Selected values (COMPUTED-EXACT, q <= 121):

| q | e | nonconstant r | \|Aut\| | fibre |
|---|---|---|---|---|
| 11 | 1 | 3 of 5   | 1320 | trivial |
| 13 | 1 | 4 of 6   | 2184 | trivial |
| 23 | 1 | 8 of 11  | 12144 | trivial |
| 9  | 2 | 1 of 4   | 1440 | C_2 (Frobenius) |
| 25 | 2 | 9 of 12  | 31200 | C_2 |
| 49 | 2 | 20 of 24 | 235200 | C_2 |
| 121 | 2 | 56 of 60 | 3542880 | C_2 |

**Relation to Paper V's ledger (PROVED).**  Paper V's information-loss ledger
has three entries: a 22-element carrier ambiguity from forgetting the `H_3`
matching, a residual `C_2` from forgetting the chordal line, and a
conference/Frobenius `C_2`.  All three live *below* PGL_2(11): they are the
index of a marked subgroup `A <= PGL_2(q)` inside PGL_2(q).  The family-level
statement is the complementary one: for any marked subgroup A of
`PGammaL_2(q)`, the coloring's marking fibre relative to A is the coset space
`PGammaL_2(q)/A`, of index `[PGammaL_2(q) : A]`.  At `(m,q) = (2,11)` with
`A = A_5` this is `1320/60 = 22`, reproducing C1011's first ledger entry
exactly.  So the correct general slogan is: **the Phi-coloring never loses more
than the field automorphisms, and never less than nothing; every finer marking
is lost in full.**

---

## 5. Query complexity

A query names a 4-subset and returns its color (a ternary answer).

### 5.1 Lower bounds

**Bound L1 (touching).  PROVED.**  If two points x, y appear in no query, the
transposition (x y) preserves every answer, so the transcript cannot separate the
true marking from its (x y)-twist.  No transposition lies in `PGammaL_2(q)` for
odd `q >= 5`: a nonidentity element of PGL_2 fixes at most 2 of the q+1 points
and so moves at least q-1 >= 4 of them, while an element outside PGL_2 has its
fixed set inside a proper subline, so it moves at least `q - sqrt(q) > 2`
points.  Each query touches 4 points, so at most one point may go untouched:
`#queries >= ceil((q-1)/4)`.

**Bound L2 (counting).  PROVED.**  There are `(q+1)! / |PGammaL_2(q)|`
distinguishable markings and at most `3^k` transcripts of k ternary queries, so

```
  #queries >= log_3( (q+1)! / (e (q+1) q (q-1)) ) = q log q / log 3 * (1 + o(1)).
```

L2 dominates L1 for all q >= 11.  Sample values (COMPUTED-EXACT): the pair
(L1, L2) is (3, 12) at q = 11, (6, 42) at q = 23, (12, 118) at q = 47, and
(30, 412) at q = 121.

### 5.2 Upper bounds

**The 2-anchored non-adaptive set.**  Fix any three points and call them
infty, 0, 1 (free, by 3-transitivity).  Query every 4-set meeting that anchor in
at least two points:

```
  |Q_2| = (q-2) + 3 * C(q-2, 2) = (q-2)(3q-7)/2 = (3/2) q^2 + O(q).
```

**COMPUTED-EXACT (q <= 121):** `Q_2` determines the marking up to the fibre for
every nonconstant (q, r) except the five Baer instances -- this is exactly the
statement that the refinement of section 2.1, which reads only `Q_2`, is
discrete-up-to-Gal.  Values: 117 queries at q = 11, 651 at q = 23, 3015 at
q = 47, 21182 at q = 121.

**The Baer stratum needs more (COMPUTED-EXACT, q = 25).**  Restricting the
exhaustive search to `Q_2`-consistency at `(q, r) = (25, 6)` returns
`|H| = 12`, not 2: the quadratic query set genuinely fails there.  Enlarging to
the 1-anchored set (4-sets meeting the anchor in at least one point,
`3 C(q-2,3) + 3 C(q-2,2) + (q-2) = O(q^3)` queries) restores `|H| = 2`.  At
q = 9 even `Q_2` suffices.  So the Baer stratum is the unique place in the
family where the query complexity of reconstruction provably rises from
quadratic to cubic in the anchored model.

**A linear-size adaptive heuristic.**  Pick k further reference points and give
each remaining point the signature consisting of the colors of the 4-sets
`{T, y}` for the `C(3+k,3)` triples T inside the anchor-plus-references.  Let
`k*(q,r)` be the least k making that signature injective up to the Galois orbit,
for the greedy reference choice used by the script.  COMPUTED-EXACT over all
nonconstant r with q <= 121:

* `k* <= 8` for every (q, r) except a short list of coarse strata
  (q, r) = (61, 40), (79, 52), (89, 44), (97, 48), (101, 50) and the Baer point
  (121, 12), where `k* > 8`;
* at m = 2 (r = 4) the measured k* is 1..4 for `q <= 113`, giving
  `C(3+k,3)(q-2-k) = O(q)` queries -- 70 at q = 11, 190 at q = 23, 2160 at
  q = 113.

So the practical adaptive cost is `Theta(q)` on generic strata, within a
constant factor of the `Theta(q log q)` counting lower bound, while the coarse
strata force the quadratic (or, for Baer, cubic) fallback.  **CONJECTURED:**
`k* = O(1)` on every stratum whose reduction parameter n (in the `(n,j)` family)
is unbounded, and `k* = Theta(log q / log n)` on the small-image strata.

### 5.3 Distinguishing the coloring from a random one

Five points carry five 4-subsets whose colors are strongly constrained: the
number of realizable color multisets, out of the 21 multisets of size five from
three colors, is small.  COMPUTED-EXACT at m = 2:

| q | realizable multisets / 21 | probability a uniform random coloring lands inside |
|---|---|---|
| 7   | 1 / 21  | 0.041 |
| 11  | 2 / 21  | 0.045 |
| 13  | 3 / 21  | 0.185 |
| 23  | 3 / 21  | 0.086 |
| 47  | 5 / 21  | 0.128 |
| 97  | 12 / 21 | 0.502 |

So **five queries on a single 5-subset** reject a uniformly random 3-coloring
with probability between 0.5 and 0.96 in this range, and `O(1)` independent
5-subsets suffice for any constant confidence.  The realizable fraction grows
with q, so this particular O(1)-query distinguisher weakens as q grows; the
color-class densities (which are exactly the bias census of the earlier reports,
`N+ : N- : N0`) give a second, sample-based distinguisher whose cost is
`O(1/delta)` with delta the minority-color density -- measured minority
densities at m = 2 range from 0.017 (q = 121) to 0.49 (q = 107).

---

## 6. Novelty boundary

The C1013 classicality audit lists "the excess-automorphism and
marking-reconstruction consequences" among its **no-predecessor-located** items,
and its mystery ledger records "whether the Paper V reconstruction consequence
is pre-empted" as *not located, still qualified*, with MathSciNet, Google
Scholar and zbMATH recorded as coverage gaps.  Against that boundary: to our
knowledge the family-level dichotomy (Theorem 4), the uniform Galois marking
fibre (Theorem 5), the Frobenius-twisted collapse stratum (Theorem 2), and the
identification of the `r = p+1` coloring over `F_{p^2}` with the Miquelian
inversive plane (Theorem 3 and Corollary 3.1) have no located predecessor.  Every
one of those sentences must stay behind "to our knowledge" and behind the
audit's coverage gaps until a dedicated literature audit under
`notes/literature-audit-conventions.md` is run for this note specifically; none
has been run yet, so **no priority claim is made here**.

What is *not* new, and must be cited rather than claimed: the classification of
finite 3-transitive permutation groups and the maximality consequences used in
Lemma 4; the fact that four points of `P^1(F_{p^2})` are cocircular in a Baer
subline iff their cross-ratio lies in `F_p`; the recognition theorem that the
automorphism group of the Miquelian inversive plane of order q is
`PGammaL_2(q^2)`; the harmonic-quadruple design and its `PGL_2(q)` symmetry; and
Kaipa--Patanker--Pradhan's quartic square-class computation `36 I(f) = beta^2 I`,
which the audit already identified as pre-empting the m = 2 invariant itself.
The `q = 11` statement of Paper V / C1011 is a **restatement**, now a corollary
(Corollary 4.2), not a new result; the contribution there is that the general
theorem removes its finite `9!` verification.

---

## 7. Open observations

Each is stated with its exact searched range.

**(1) "Constant on the nonvanishing locus" is strictly weaker than "constant",
and only the latter destroys reconstruction.**  The earlier reports classified
strata by constancy of `chi(G_r)` on the *nonvanishing* locus; the marking
dichotomy is governed by constancy of the full three-valued coloring, zeros
included.  The gap is not empty and it is favourable.  Concretely, the single
unexplained stratum of the earlier `p <= 300` sweep, `(p, r) = (47, 30)`
(i.e. m = 15, inside the present fundamental window), has color counts
`(N+, N0, N-) = (0, 6, 39)`: it takes two colors, so it is nonconstant here, and
refinement discretizes with no individualization, giving `Aut = PGL_2(47)`
(COMPUTED-EXACT).  **The reconstruction problem at (47, 30) is not exceptional at
all**, even though the character-sum problem there is.  The same reasoning
removes Theorem G's zero-carrying instances -- for example `(5, 19)` and the
`A* (r = -2)` rows at p = 11, 13, 19 -- from the reconstruction-exceptional set.
`E(q)` is therefore strictly smaller than the earlier constant-character list,
and the per-field counts in section 2.2 are the correct ones for marking
purposes.

**(2) The Baer stratum is the extremal reconstructing member.**  It is the only
coloring in the family that is nonconstant yet defeats 1-WL refinement, the only
one whose query complexity is cubic rather than quadratic in the anchored model,
and the only one whose color set is `{0, +1}` with a geometrically named
zero-locus.  Whether an analogous stratum exists over `F_{p^3}` at `r` equal to
`(q-1)/(p^2+p+1)`-type exponents (the subfield/Baer analogue for cubic
extensions) is untested: the sweep covers only e <= 2.  **CONJECTURED:** over
`F_{p^e}` the exponent `r = (p^e - 1)/(p^{e'} - 1) * something` giving
`lambda^r = N_{F_q/F_{p^{e'}}}(lambda)` produces the subline coloring of the
corresponding subfield, with `Aut = PGammaL_2(q)` again.

**(3) Absence of the color -1 over non-prime fields.**  COMPUTED-EXACT for
`q = 9, 25, 49, 121`: whenever `(p+1) | r`, the coloring omits the color -1
entirely, because `G_r` then lands in `F_p` and every element of `F_p^*` is a
square in `F_{p^2}`.  The converse fails: `r = 2` and `r = 2p` also omit -1
(they are identically zero), and at `q = 25` the exponents `r = 8, 16` omit -1
without being divisible by `p+1 = 6`.  A clean characterization of the
`-1`-free exponents is open.

**(4) The reconstruction theorem makes the bias census informationally
redundant for marking purposes.**  The exact Frobenius bias, its Weil-bound
behaviour, and the modular identification of the descent quotients determine
*which* stratum one is in, but once the coloring is nonconstant the automorphism
group is the same regardless of how large or small the bias is.  Two colorings
with wildly different bias (say `q = 113` at `r = 4` with density 0.487 and
`q = 121` at `r = 4` with density 0.017) have isomorphic automorphism groups.
Whether any finer invariant of the coloring -- for instance the coherent closure
or the Bose--Mesner algebra of the induced 4-uniform association structure --
does see the bias is untested and is the natural bridge back to the C1005 /
C1008 fusion-algebra criterion.

**(5) Odd degree.**  This note treats `d = 2m` only.  By Theorem 1 the
four-point coloring is untwisted for odd d as well, so the same dichotomy
argument applies verbatim once the constant strata for odd d are classified; the
Pfaffian residual `pi` with `Phi = pi^2` (flagged in the C1014 card's tt pass)
would then supply a *finer* coloring whose automorphism group could conceivably
be smaller than `PGammaL_2` -- which is the only visible route in this circle of
ideas to a shadow that over-determines rather than under-determines the marking.
Untested.

---

## Mystery ledger -- `ej` + `tt` closeout

| Feature | Status after closeout | Evidence gap / owning successor |
|---|---|---|
| Why no partial collapse ever occurs | **settled** -- 3-transitivity of PGL_2 plus the 3-transitive classification leaves no room (Lemma 4); confirmed CFSG-free for q <= 121 | none |
| Why the marking fibre is m-independent | **settled** -- it is `Aut/PGL_2 = Gal`, and Aut is m-independent off the constant strata | none |
| The five refinement failures | **settled** -- all are `r = p+1` over `F_{p^2}`, the Baer/inversive coloring (Theorem 3); three of them independently confirmed by exhaustive search | q = 121 exhaustive search not run; rests on Theorem 3 + Corollary 3.1 + Theorem 4 |
| The extra constant stratum at `r = 2p` | **settled** -- Frobenius twist of Theorem B (Theorem 2) | none |
| `(p, r) = (47, 30)` | **settled for marking purposes** -- it has six zeros, so the coloring is nonconstant and `Aut = PGL_2(47)` (COMPUTED-EXACT) | its *character-sum* mechanism remains the earlier C1014 report's open item; unchanged here |
| Characterizing the `-1`-free exponents over `F_{p^2}` | **open** | `(p+1) | r` is sufficient, not necessary (q = 25, r = 8, 16) |
| Whether `k*` (star separation) is bounded on generic strata | **open** | measured `k* <= 8` for q <= 121 off six coarse strata; no proof |
| Whether the coloring's finer algebraic invariants see the Frobenius bias | **open** | untested; natural bridge to the C1005/C1008 fusion-algebra criterion |
| Whether any Gram-type shadow can *under*-determine less than PGL_2 | **open** | would need the odd-degree Pfaffian residual `pi`, not `Phi = pi^2` |

No manufactured mysteries: items marked open have a stated evidence gap.

---

## Status: complete

All seven task items are answered.  The two computational gaps that remain are
explicitly labelled (the q = 121 exhaustive search, superseded by two
independent proofs; and the `-1`-free exponent characterization over `F_{p^2}`).
Nothing in this note was promoted to a manuscript,
and no literature audit was run, so every novelty sentence stays behind
"to our knowledge" plus the C1013 audit's recorded coverage gaps.
