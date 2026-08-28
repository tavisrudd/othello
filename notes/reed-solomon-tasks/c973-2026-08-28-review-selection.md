# C973 — independent cold-read review of the finite-field selection arguments

**Lane:** `reed-solomon` · **Date:** 2026-08-28 · **Reviewer role:** independent
cold read (finite fields / arithmetic of curves over finite fields), read-only
except for this file

Scope: the rational split-witness selection arguments of C973 on the modular
carriers, in the five files
`c973-2026-08-26-deterministic-selector.md`,
`c973-2026-08-27-gf64-pointed-trace-gate.md`,
`c973-2026-08-27-gf64-trace-balance.md`,
`c973-2026-08-27-gf27-three-line-reduction.md` (sections 1--3 plus the switch
machinery it forward-references) and
`c973-2026-08-27-gf27-four-plane-switch-pencil.md`.
All five files were present.

## 1. Summary verdict

The algebra is in very good shape and the arithmetic is, with two exceptions,
exactly right: every closed-form identity I could re-derive or recompute
checked out, including the delicate ones (the exact trace balance, the
Berlekamp sign-resolvent identity, the two `GF(8)`/`GF(4)` base-change point
counts, the full Weierstrass 3-torsion audit, and the entire `GF(27)`
two-point-switch and four-plane-pencil apparatus).

Two things are wrong, and one headline claim is not supported.

1. **Wrong (repairable):** the dense-chart cover in `(14)--(19)` is **not**
   genus zero with 65 points. It is ramified over the root of `Q` **and** over
   infinity, hence genus one, with 54, 60, 66 or 78 points depending on `a`.
   The conclusion survives (`45 < 49 <= #C`), the stated reason does not.
2. **Wrong (repairable, but it invalidates four separate closures as written):**
   identity `(25)` is an identity only when the fifth functional value
   `B_4` vanishes. On the chart the note actually uses, `B_4 = 1`, so the
   displayed `Delta` and `Q` for the `(0,0)` boundary are wrong and the
   "constant cover / two rational lines / 130 points" conclusion is false.
   The true counts are 54--72, not 130; in one case the count is exactly the
   claimed budget 54, so the stated inequality `130 > 54` fails twice over.
   The conclusions again survive under a corrected budget of 52.
3. **Not supported:** the boundary claim "This checkpoint now closes the GF(64)
   pointed R11 problem." Only the *forced-root surface* `(22)` is closed. Off
   that surface the note falls back on the slope-pencil gate `(6)`, which it
   explicitly leaves unproved in section 3 --- and which **provably fails** for a
   positive fraction of syndromes: for `z=e_4`, `z=e_5`, `z=e_7`, 19 of the 27
   zero-one syndromes, and 102 of 1500 random off-surface syndromes, the slope
   kernel contains no split squarefree quartic at all (for `e_5` and `e_7` it
   contains no degree-four element at all). The degenerate chart `B_3D=0` is
   also deferred by the note's own ledger. The correct status line is
   "forced-root surface closed", not "GF(64) closed".

Nothing I found breaks the mathematics that the surface analysis actually
establishes, and every closure I could test end-to-end does hold numerically.

## 2. Claim table

Labels are the equation tags of the source files.

| # | claim (one line) | verdict |
|---|---|---|
| S1 | successive-specialization lemma: `mq` partial substitutions suffice for nonzero `Q` with `deg_{x_i}Q<q` | ACCEPT |
| S2 | `(4)` `deg_{x_i} Q_f <= d+m-1+s`; `(5)` selector phase costs at most `(r-5)q` tests | ACCEPT |
| S3 | `(6)` dense ordered-root representation has `(d+m+s)^m` slots | ACCEPT |
| S4 | terminal pencil: at most `m+s` of the `q+1` members carry a forbidden root | ACCEPT |
| S5 | "the exact R5 count guarantees success under the pointed threshold" | UNVERIFIED (external) |
| B1 | `(8)` `n_0,n_1,n_2` are the coefficients of `N` in the moving root | ACCEPT |
| B2 | `(9)` rootlessness `<=> Tr(n_0n_2/n_1^2)=1` when `n_1n_2 != 0`; `n_1=0` always splits | ACCEPT |
| B3 | trace-balance theorem: `B_3D != 0` implies exactly `q/2` rootless `B_0` | ACCEPT |
| B4 | sharp deletion table totalling 48, against genus-one Hasse `49` | ACCEPT (conditional on genus `<=1` and integrality) |
| B5 | `(6)`--`(7)` slope pencil, `32>23` | ACCEPT (as a conditional statement) |
| B6 | `(8)` dense syndrome forces `p_0=p_1=0` in the slope pencil | ACCEPT |
| B7 | `(9)`--`(11)` normalized affine coset, `(B_0,..,B_3)=(a+1,1,beta a,beta)` | ACCEPT |
| B8 | `(12)` `Tr(beta a^3+(beta^16+1)a+beta^{-1})`; `(13)` at least 24 values | ACCEPT |
| B9 | `(14)`--`(15)`: `Tr(a^3)=1`, at least 15 admissible `a` | ACCEPT |
| B10 | `(16)` `Q=1+ax`, `Delta=(a+1)^2(1+x)^2`, `N=(a^2+1)x^2+x+(a^2+a+1)` | ACCEPT |
| B11 | `(17)` `R=(a+1)^6(a^4+a^3+1)/a^4` | ACCEPT |
| B12 | "genus zero and exactly 65 rational points" for the dense chart | **BROKEN** (genus one; 54/60/66/78) |
| B13 | `(18)`, `(19)` `45 < #C` closes the dense syndrome | ACCEPT (via the corrected bound 49) |
| B14 | `(25)` `NDelta/Q^2 + (c^2x/Q)^2 + c^2x/Q = (c^2+bd)/c^2` | **BROKEN as used** (true only if `B_4=0`) |
| B15 | `(0,0)` boundary closed by "130 > 54" | **BROKEN** (true counts 60/66/72, three cases 130) |
| B16 | six roots of `tau^6+tau^5+1` closed by "130 > 54" | **BROKEN** (true count 72) |
| B17 | `(31)` and the nine further `a=tau` closures by "130 > 54" | **BROKEN** (true counts 72, 72, 54) |
| B18 | `n_0n_2=tau^9n_1^2`, `Tr(tau^9)=0` on `tau^6+tau^5+1` | ACCEPT |
| B19 | `(0,1)` boundary: `(28)`, 12 points over `GF(8)`, `(29)` 72 over `GF(64)`, `72>52` | ACCEPT |
| B20 | `tau^3+tau^2+1` collision cubic: 12 over `GF(8)`, 72 over `GF(64)`, `72>52` | ACCEPT |
| B21 | `tau^2+tau+1`: 6 over `GF(4)`, cubic base change to 54, `54>52` | ACCEPT |
| B22 | `(20)`--`(22)` forced-root surface `z_6=z_4^3`, `z_7=z_4^4+z_5^2+z_4^2z_5` | ACCEPT |
| B23 | `(23)` `P(t)=t q_{u,v}(t)(lambda+mu(t+u))` on that surface | ACCEPT |
| B24 | quadratic stratification `1953+2016+63+64` | ACCEPT |
| B25 | 42 trace-one values, seven Frobenius sextics `P_1,...,P_7`, factorization `(31)` | ACCEPT |
| B26 | `(32a)`--`(32b)` cubic pencil, Hankel minors, Berlekamp identity | ACCEPT |
| B27 | `(32c)`--`(32e)` `A,C`, `Res_T(A,C)`, `d/da n_1`, `Res_a(n_1,n_0n_2)` | ACCEPT |
| B28 | `(32f)` connected etale cyclic cubic cover; rational deck translation; 3-isogeny forces `3 | #C_0` | ACCEPT |
| B29 | `#C_0+#C_1=130`, `#C_1` even, `#C_1 = 1 mod 3`, hence `#C_1>=52` and `>=24` rootless | ACCEPT |
| B30 | `(33a)`--`(33g)` Weierstrass rows, `psi_3`, order-three points | ACCEPT |
| B31 | `(34)`--`(36)` affine-three-space-minus-one padding forces `gamma=0` | ACCEPT (given `(34)`) |
| B32 | `(32)` selector pseudo-remainder leading coefficient `tau(tau+1)^3(tau^3+tau+1)^3` | UNVERIFIED (C620 selector unavailable) |
| B33 | `(39)` endpoint `e_7`: `B_3=0`, `D=1`, `Tr(1+g_3/g_4^2)` | ACCEPT |
| B34 | boundary statement "closes the GF(64) pointed R11 problem" | **BROKEN** (only the forced-root surface is closed) |
| T1 | three-line `(2)` coefficient table for `g` | ACCEPT |
| T2 | three-line `(5)` `A,...,F`; `(6)` Cramer solution; `(7)` `u`-coefficient `z_2z_3(r-p)` | ACCEPT |
| T3 | three-line `(8)`--`(11)` split and collision conditions | ACCEPT |
| T4 | `(41)`/`(48)`--`(51)` quotient columns, `(53)`--`(54)` fixed-direction nonsingularity | ACCEPT |
| T5 | `(47)`, `(47a)` denominator-free discriminant and its norm form | ACCEPT |
| T6 | `(56)`--`(58)` eighth nucleus by Lucas | ACCEPT |
| T7 | 819 sublines, 702 avoiding infinity | ACCEPT |
| P1 | pencil `(2)`--`(5)`: `P_kappa=R(R^2-kappa)`, four planes, partition of the 24 off-line points | ACCEPT |
| P2 | pencil `(4)`: the four `kappa` are the roots of `X^4+aX+b` | ACCEPT |
| P3 | normalized pencil `lambda^4+lambda+1=(lambda-1)(lambda^3+lambda^2+lambda+2)` over `F_3` | ACCEPT (with `kappa=gamma^2 lambda`) |
| P4 | pencil `(6)`--`(10)`: `P_kappa` expansion, `gamma^6,gamma^8,C`, `F_i`, affine `phi,Z,R`, quadratic `D(kappa)` | ACCEPT |
| P5 | `(10a)` and the `z_2=0` / `z_2=z_3=0` branches; universal switch nonsingularity | ACCEPT |
| P6 | `(13)`--`(15)` Cramer numerators, cleared discriminant, two norm forms | ACCEPT |
| P7 | `(16)` retained-third-point collision `<=> n_1-n_2+dD=0` | ACCEPT |
| P8 | `(16a)`--`(16c)` one-point switch sections | ACCEPT |
| P9 | `(17)`, `(18)` incidence ledger counts `1404`, `702`, `1023`, `1012` | ACCEPT |

## 3. Findings by severity

### 3.1 Mathematical errors

**F1 (`gf64-trace-balance`, lines 256--259). The dense chart's cover is genus
one, not genus zero, and does not have 65 points.**
The text argues that because `Q` is linear and the reduced simple-pole test
`(17)` is nonzero, "the normalized Artin--Schreier curve is geometrically
integral of genus zero and has exactly 65 rational points". The pole at
infinity is overlooked: `deg(N Delta)=4` and `deg(Q^2)=2`, so `N Delta/Q^2`
has a double pole at infinity, and after Artin--Schreier reduction it is a
*simple* pole for every admissible `a`. With two rational ramified places
Riemann--Hurwitz gives `2g-2 = -4+2+2 = 0`, so `g=1`. Direct computation of
the smooth model gives 54, 60, 66 or 78 points (six admissible `a` each),
never 65.
*Repair:* genus one and Hasse give `#C >= 49`, and the note's own budget is 45
(indeed 44, since both the `Q`-root and infinity are ramified and contribute
one point each rather than one and two). `45 < 49` closes the dense syndrome
exactly as intended. I also confirmed the conclusion directly: for each of the
24 admissible `a` there are between 18 and 30 moving roots `x` producing an
octic with eight distinct nonzero roots satisfying both Hankel equations.

**F2 (`gf64-trace-balance`, equation `(25)` and its four applications).
Identity `(25)` holds only when the fifth functional value `B_4` is zero, and
`B_4 = 1` on the chart used.**
In the final-pair formalism `A_j = B_j + xB_{j+1}` for `j=0,...,3`, so
`Delta = A_1A_3+A_2^2` and `Q = A_0A_3+A_1A_2` both involve `B_4`; only
`N = A_1^2+A_0A_2` does not. The displayed
`Delta = bd+c^2+cdx+d^2x^2` and `Q = bc+c^2x+cdx^2` are the `B_4=0`
specializations. Symbolically, the cleared identity
`c^2 N Delta + c^6x^2 + c^4xQ + (c^2+bd)Q^2 = 0`
is an identity in `F_2[b,c,d,x]` for the `B_4=0` forms and is **not** an
identity once `B_4=e` is carried. On the chart `H(t)(t+a)` with
`H=t^4+t^2+t+1` one has `B_4 = 1` both at the `(0,0)` boundary (syndrome
`e_3`, `B_4=g_3=1`) and at every `a=tau` specialization on `(u,v)=(1,tau)`
(`B_4 = 1+a+tau`, which is `1` at `a=tau`). Consequently:

* `(0,0)` boundary: the cover is not the disjoint union of two rational lines.
  Over the 27 parameters with `Tr(1/(a+1))=0`, `a != 0`, `H(a) != 0`, the true
  counts are 60 (6 values), 66 (12), 72 (6) and 130 (only 3). The claimed
  "130 > 54" is false for 24 of the 27.
* `tau^6+tau^5+1` (six forms): true count 72, not 130.
* `tau^3+tau+1` (three forms): true count 72, not 130.
* `tau^6+tau^5+tau^2+tau+1` (six forms): true count **54**, not 130 --- and 54
  does not exceed the note's own stated budget of 54, so the inequality fails
  even after correcting the count.

*Repair:* these covers are integral genus-one curves with `N` split, for which
the correct budget is the sharp pointed table 48 plus 4 for `N=0`, i.e. 52,
not the reducible-cover budget 54. All the true counts (54, 60, 66, 72) exceed
52, so every one of these strata does close --- by the same mechanism already
used successfully for the `(0,1)` boundary and the two subfield cases, not by
a constant cover. I verified the conclusion end-to-end: each of these forms
admits between 15 and 56 valid moving roots. The `(25)`-based "reducible
rational cover rather than a rootless final quadratic" narrative, and the
associated ledger rows, need rewriting.

### 3.2 Unsupported status claim

**F3 (`gf64-trace-balance` section 4 and ledger, versus section 3, lines
1026--1030). The GF(64) pointed R11 problem is not closed; only the
forced-root surface is.**
Section 3 states plainly that off the surface `(22)` "the remaining issue there
is complete splitting and selector nonvanishing", and that the slope-pencil
gate must still be shown to contain "a split squarefree quartic avoiding zero
with `U_0 != 0`". Section 4 nevertheless asserts closure. That gate is not
merely unproved --- it is false on a positive-density set. Computing the kernel
of `(20)` and searching all of its projective points:

* `z = e_4` (`z_4=1`, rest zero): kernel is `{p_1=p_2=p_3=0}`, every element is
  a fourth power `p_4(t+c)^4`, so no squarefree quartic exists.
* `z = e_5`: kernel is `{p_2=p_3=p_4=0}`; no element has degree four at all.
* `z = e_7`: kernel is `{p_4=0}` (dimension four); again no quartic.
* 19 of the 27 zero-one syndromes off `(22)` admit no usable quartic.
* 102 of 1500 uniformly random syndromes off `(22)` admit none (about 7%).

The note's own ledger also leaves `B_3D=0` open ("same C973 proof, by explicit
lower-dimensional charts beginning with (6)"), and `e_7` is exactly that
degenerate chart. So two disjoint pieces of the syndrome space are outstanding.
The status supported by the evidence is: *forced-root surface `(22)` closed,
generic stratum and `B_3D=0` open*. The `ej`/`tt` ledger row "How many
marked-torus forms remain? none" is correct as stated (it is about the
surface); the section-4 sentence and the file header are not.

### 3.3 Unproved but plausible

* **B32.** The uniform selector-nonvanishing argument `(32)` rests on a
  pseudo-remainder of the C620 selector whose normalization is not reproducible
  from these files, so I could not confirm the leading coefficient
  `tau(tau+1)^3(tau^3+tau+1)^3` nor the degree bound 22. The *consequence* it
  is used for is comfortably true: the minimum number of rootless parameters
  over the 42 trace-one forms is 29, against 23 exclusions.
* **S5, B4.** "Genus at most one" for the selected final-pair slice, the
  coordinatewise selector degree 22, and the exact R5 count are all imported
  from C620/the two-seam report and were taken on trust.
* **B31 `(34)`.** The two reduced R11 Hankel equations on the split-quadratic
  stratum are quoted, not derived; given them, the elimination is correct
  (I re-derived `(36)` by synthetic division and confirmed that substituting it
  into `(34)` cancels everything except `gamma`).
* **Coherent-contraction step** (`gf64-pointed-trace-gate` section 2): "a
  nonzero divided-power tensor cannot have every first contraction zero" is
  standard apolarity but is asserted without reference.

### 3.4 Exposition

* `gf64-pointed-trace-gate` line 110: "The refinement from 48 to 46 in the old
  unpointed part" refers to numbers that appear nowhere else in the file.
* The `(0,0)`/`a=tau` passages would be much easier to check if `B_4` were
  displayed alongside `(B_0,B_1,B_2,B_3)`; its silent omission is what hides
  F2.
* `deterministic-selector` section 1: "divisible by more than `d_i` distinct
  linear factors in that coefficient domain" is a correct but roundabout way of
  saying "has more than `deg` roots in an integral domain".
* Four-plane note: the normalization is `kappa = gamma^2 lambda` with
  `a=gamma^6`, `b=gamma^8` (so `X^4+aX+b = gamma^8(lambda^4+lambda+1)`), not a
  sixth power. Worth stating explicitly, because it says something useful: the
  four planes through *any* affine line are canonically indexed by the same
  four `lambda`, namely `1` together with the three roots of the
  `F_3`-irreducible `lambda^3+lambda^2+lambda+2`. The Frobenius type of the
  pencil is therefore always `1+3`, never `4` or `2+2`, which is a genuine
  structural handle for the open split/collision gate `(12)` --- one member of
  every pencil is distinguished over the prime field.

## 4. Computations actually run

All in Python 3 (standard library only), `GF(64)=F_2[t]/(t^6+t+1)`,
`GF(27)=F_3[th]/(th^3-th-1)`; subfields `GF(8)`, `GF(4)` taken inside
`GF(64)`. Smooth-model point counts were done place by place on `P^1`, with
explicit Laurent reduction of even-order Artin--Schreier poles; the counter was
validated on `y^2+y=x^3` (81 over `GF(64)`, 9 over `GF(8)`), `y^2+y=x^3+x`
(65 over `GF(64)`, 5 over `GF(4)`) and `y^2+y=x` (65, genus zero).

1. `#{a in GF(64): Tr(a^3)=1} = 24` exactly (the note's Weil bound `>= 24` is
   attained).
2. Roots of `H=t^4+t^2+t+1` in `GF(64)`: four distinct, none zero. Admissible
   dense parameters (`Tr(a^3)=1`, `a != 0`, `H(a) != 0`, `a^4+a^3+1 != 0`):
   **24** (note claims at least 15).
3. `(11)`, `(16)`, `(17)` verified for all `a` and all `beta`; `(18)` verified
   by hand.
4. Dense-chart cover point counts over `GF(64)`: **54, 60, 66, 78**, six
   admissible `a` each. One point above the `Q`-root and one above infinity in
   every case (both ramified).
5. End-to-end dense closure: 18 to 30 valid moving roots per admissible `a`,
   each yielding eight distinct nonzero roots satisfying both Hankel equations.
6. `(25)` checked as a symbolic identity in `F_2[b,c,d,e,x]`: **true** for
   `e=B_4=0`, **false** for general `e`.
7. `(0,0)` boundary, syndrome `e_3`: `B=(0,a,a+1,a+1)` confirmed, `B_4=1` for
   all `a`; true `(Delta,Q)` differ from the displayed ones for all 64 values
   of `a`; 27 parameters satisfy the trace-zero selection; cover counts
   **60 (x6), 66 (x12), 72 (x6), 130 (x3)**; end-to-end 15 to 56 valid moving
   roots.
8. `(0,1)` boundary with `a^3+a+1=0`: `(B_0,...,B_3)=(a,a+1,a+1,1)` and the
   `(28)` triple reproduced exactly; `#C(GF(8)) = 12`, `#C(GF(64)) = 72`;
   end-to-end 18 valid moving roots.
9. `tau^3+tau^2+1=0`, `a=tau+1`: `#C(GF(64)) = 72`; end-to-end 18.
   `tau^2+tau+1=0`, `a=tau+1`: `#C(GF(64)) = 54`; end-to-end 24. Both base
   changes `65-((-3)^2-16)=72` and `65-((-1)^3+12)=54` are arithmetically
   correct.
10. `a=tau` strata: `tau^3+tau+1` and `tau^6+tau^5+1` give **72**;
    `tau^6+tau^5+tau^2+tau+1` gives **54**; all have `B_4=1` and 24 valid
    moving roots each. `n_0n_2=tau^9n_1^2` and `Tr(tau^9)=0` confirmed on the
    sextic.
11. `T(tau)=tau+1/(tau^2+tau+1)`: trace-zero locus has 20 elements and equals
    the root set of `(31)` exactly; trace-one locus has 42 elements and equals
    the union of the roots of `P_1,...,P_7`.
12. For all 42 trace-one `tau`: `(#C_0,#C_1,#rootless a)` takes the values
    `(54,76,36) x12`, `(54,76,37) x6`, `(54,76,38) x6`, `(60,70,35) x6`,
    `(66,64,31) x6`, `(72,58,29) x6`. Hence `3 | #C_0` always, `#C_1` always
    even and `= 1 mod 3`, `#C_0+#C_1 = 130` always, minimum `#C_1 = 58 >= 52`,
    minimum rootless count **29 > 23**.
13. `(32d)` `Res_T(A,C) = tau^2(tau^9+tau^8+tau^7+tau^6+tau^5+tau+1)` confirmed
    as an identity in `F_2[tau]` by an exact Sylvester determinant; the
    degree-nine cofactor is irreducible over `F_2`; the resultant vanishes in
    `GF(64)` only at `tau=0`, which is not a trace-one value.
14. `(32e)` `d/da n_1 = (tau+1)(tau^3+tau+1)`, leading coefficient of `n_1`
    equal to `tau+1`, and `Res_a(n_1,n_0n_2)=tau^5(tau^2+tau+1)(tau^6+tau^5+1)^4`
    confirmed for all `tau`.
15. `(33a)`--`(33g)`: for `P_1=tau^6+tau+1` and `P_7=tau^6+tau^5+tau^4+tau+1`,
    for **all six** conjugate roots of each: `n_1(r)=0`; `d^2=n_0n_2(r)`; the
    substitution `a=r+1/(cx)`, `Y=d+y/(cx^2)` reproduces `(33c)` with the
    coefficient rows `(33d)` identically (checked over all `x != 0` and several
    `y`); the points `(33e)` lie on `E_i` and annihilate `psi_3`; the points
    `(33g)` lie on `C_0`, as does `(r,d)`. `(33f)` is the correct
    characteristic-two 3-division polynomial (`b_2=a_1^2`, `b_4=a_1a_3`,
    `b_6=a_3^2`, `b_8=a_1^2a_6+a_1a_3a_4+a_2a_3^2+a_4^2`).
16. Slope-pencil survey off surface `(22)`: 1500 random syndromes, kernel
    dimension 2 in every case, **102 with no usable split quartic**; 27
    zero-one syndromes, **19 failures**; 600 syndromes with `z_3=0`, **33
    failures**. Explicit structural failures at `e_4` (kernel is all fourth
    powers), `e_5` and `e_7` (kernel contains no degree-four element).
17. `(23)` confirmed: `t q_{u,v}(t)(lambda+mu(t+u))` lies in the slope kernel
    for all `(u,v)` sampled on `(22)`.
18. `GF(27)`: three-line `(2)` coefficient table verified on 300 random
    `(p,q_1,q_2,r,s)`; `(5)` verified as the exact linear system in `(v,s)` and
    `(7)` as its `u`-coefficient, on 200 random `(p,r,z)`.
19. `GF(27)` four-plane pencil, over all 26 subspace scalings `gamma`:
    `P_gamma H` has subspace polynomial `t^9+gamma^6t^3+gamma^8t`; the four
    `kappa=u^2` are exactly the roots of `X^4+gamma^6X+gamma^8`; and
    `kappa = gamma^2 lambda` with `lambda` running over the roots
    `{1} u {roots of lambda^3+lambda^2+lambda+2}` of `lambda^4+lambda+1`
    (in my model of `GF(27)` these are `1, 9, 13, 16`). The factorization
    `lambda^4+lambda+1=(lambda-1)(lambda^3+lambda^2+lambda+2)` over `F_3` and
    the irreducibility of the cubic were checked by hand.
20. `GF(27)` pencil `(6)`, `(9)`, `(10)`, `(13)`--`(16)` verified numerically
    over 120 random `(line, syndrome, pair)` configurations and all four pencil
    values in each: the `P_kappa` expansion, `phi_i(kappa)=F_i-z_2kappa`,
    `Z(kappa)`, `R(kappa)`, the quadratic determinant, the cleared discriminant
    `(14)` against a direct `D^2 Disc(S)`, both norm forms `(15)`, and the
    retained-third-point criterion `(16)`. In the same loop I confirmed that
    the replacement quadratic `S` times the seven-point quotient satisfies both
    Hankel equations exactly --- i.e. `(46)`/`(55)` are right.
21. Hand verifications not needing code: three-line `(6)` Cramer, `(8)`, `(10)`
    (derived from scratch and matching term for term), `(38)`--`(40)`,
    `(42)`, `(47)`, `(47a)`, `(49)`, `(50)`, `(53)`--`(54)`, `(56)`--`(58)`
    (Lucas on `9=(100)_3`, `10=(101)_3`), the subline counts `819`/`702`, the
    `GF(64)` stratification `1953+2016+63+64=4096`, `(20)`--`(21)`,
    `(32b)`, `(36)` and the `gamma=0` elimination, `(39)`, the pencil `(10a)`
    branches and the incidence counts `1404`, `702`, `1023`, `1012`.

## 5. Taken on trust

* Every C620 input: the five-root selector, its coordinatewise degree 22, the
  claim that the selected slice has genus at most one, the exact R5 count, and
  the `(34)` reduction of the two R11 Hankel equations on the split-quadratic
  stratum.
* The identification of the R11 carrier and the coherent-contraction
  normalization `z_2=0` in `gf64-pointed-trace-gate` section 2.
* The `GF(16)`/`GF(32)` audit numbers (55, 795, 168, 503) quoted in section 5
  of the same file.
* The shortened-code parameters `[27,16,12] < [27,23,4]` in `(61)` and the
  Durante--Longobardi--Pepe citation.
* The claim that the Hankel functionals are `sum z_i g_{i-1}` and `sum z_i g_i`
  in the `GF(64)` setting. I did not find this stated; I inferred it, and it is
  confirmed by the fact that it reproduces the note's own `(B_0,...,B_3)` for
  three independent syndromes (dense, `(0,1)`, `(1,tau)`) and its `(16)` and
  `(28)` coefficient triples exactly. Every numeric statement above depends on
  that inference being the intended convention.

## 6. Applied repairs (2026-08-28)

Scope of the edit pass: the two `GF(64)` notes only. The `GF(27)` notes and the
deterministic-selector note needed no correction and were left untouched.

**`c973-2026-08-27-gf64-trace-balance.md`**

1. Header status changed from "GF(64) pointed closure proved structurally; no
   finite census or point-count certificate remains" to "forced-root surface
   (22) closed; generic stratum and `B_3 D = 0` open (2026-08-28 review)".
2. Five superseded sentences left in place and tagged
   `[withdrawn 2026-08-28; see Review repairs]` with a one-line correction: the
   genus-zero/65-point conclusion after `(17)`; the two-rational-lines reading
   of `(25)`; the `(0,0)` closure paragraph; the `130` in the
   `tau^6+tau^5+1` paragraph; and the `130>54` in the `(31)` paragraph.
3. The section-4 sentence "This checkpoint now closes the GF(64) pointed R11
   problem" tagged as withdrawn, with the corrected scope stated inline.
4. Four `ej`/`tt` ledger rows tagged: the `(0,0)` row, the `tau^6+tau^5+1` row,
   the `a=tau` extent row, and the affine-plane-plus-one row.
5. New appended section 6, "Review repairs (2026-08-28)", with subsections
   6.1 (F1: genus one, counts 54/60/66/78, the `45 -> 44` ramification
   bookkeeping, closure by `44 < 49 <= #C`), 6.2 (F2: `(25)` is the `B_4=0`
   specialization, `B_4=1` on the chart used, the table of true counts, the
   corrected budget `48+4=52`, all four strata still closing by the integral
   genus-one mechanism), 6.3 (F3: closure claim withdrawn, the explicit kernel
   descriptions for `e_4`, `e_5`, `e_7`, the 19-of-27 and 102-of-1500 failure
   counts, `B_3D=0` still open), and 6.4 (the load-bearing arithmetic that was
   independently confirmed).

**`c973-2026-08-27-gf64-pointed-trace-gate.md`**

6. The dangling "The refinement from 48 to 46 in the old unpointed part"
   replaced by a sentence saying exactly what is being sharpened: the zeros of
   `Q` are charged one cover point each instead of C620's two, so the two
   `Q`-fibres contribute 2 rather than 4, plus the analogous remark for a
   ramified point at infinity.
7. One paragraph added directly under `(2)` displaying
   `B_j = sum_{i=3}^{7} z_i g_{i+j-4}` with `j` running to four, noting that
   `Delta` and `Q` depend on `B_4 = sum_i z_i g_i` while `N` does not, and
   instructing that `B_4` be displayed beside `(B_0,...,B_3)` in every chart
   specialization.

**New files**

8. `notes/reed-solomon-tasks/c973-gf64-review-recount.py` --- self-contained,
   standard-library-only, deterministic (a fixed 64-bit LCG with seed
   20260828 replaces the ad-hoc sampler used during the review). It validates
   its Artin--Schreier point counter on five known curves, then prints the F1
   dense-chart data, the F2 counts, the strata that were already correct, the
   42-trace-one summary, and the F3 slope-pencil failures.
9. `notes/reed-solomon-tasks/c973-gf64-review-recount.out` --- captured stdout,
   42 lines.
10. `notes/reed-solomon-tasks/c973-gf64-review-recount.sha256` ---
    `sha256sum -c` passes on both files:

    ```
    8d4ba1f4f682d5a1e8867ffe54fb4683e42a043680667c9a0e568d0ee22b36cf  c973-gf64-review-recount.py
    3fd78af5221db9f26f29882d97fe8f6492491bab5bb9cff0664309d2dab6e566  c973-gf64-review-recount.out
    ```

    Replay: `python3 notes/reed-solomon-tasks/c973-gf64-review-recount.py`.

Every number quoted in sections 3 and 4 above is reproduced by that script,
including the 102-of-1500 off-surface failure rate, which the independent
deterministic sampler returns identically (6.8 per cent).
