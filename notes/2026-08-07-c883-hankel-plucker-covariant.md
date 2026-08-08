# C883 item 5 — the Hankel--Plücker map as a classical covariant

**Lane:** `reed-solomon` · **Date:** 2026-08-07 · **Card:**
`notes/reed-solomon-tasks/c883-r5-followups.md`

## Result

Kaipa and Pradhan attach two quartics to a line, and both are covariants of the syndrome
quartic.  The one their elliptic curve is built from is a classical covariant, and the
relation is an identity of integer polynomials rather than a numerical coincidence on a
stratum.

The two must be kept apart, and an earlier version of this report did not:

- their line quartic \(\varphi_L\), whose roots are the **contact** parameters of the
  tangent lines the line meets, is the **Hessian** \(H\) of the syndrome quartic;
- their \(D_L\), the discriminant of the residual quadratic, whose roots are the
  **residual** parameters and from whose invariants their curve \(E_L\) is built, has
  the same function-field square class as \(I H-J f_a\).

Both statements are verified below.  The degree count alone forces the first: \(\varphi_L\)
is linear in the line's coordinates, those are quadratic in the syndrome, and the space of
degree-two order-four covariants of a binary quartic is spanned by \(H\) alone.

Write a redundancy-five syndrome in divided-power coordinates as \(a=(a_0,\dots,a_4)\),
and let

\[
 f_a(x)=a_0x^4-4a_1x^3+6a_2x^2-4a_3x+a_4
\]

be the syndrome quartic in the dual variable, normalized so that the
normal-rational-curve point \((1,t,t^2,t^3,t^4)\) becomes \((x-t)^4\).  Let \(I\) and
\(J\) be its classical invariants and \(H\) its Hessian covariant.  For a point \(x\),
let \(g_x\) be the member of the Hankel pencil vanishing at \(x\), normalized by the
signed \(3\times3\) minors, and \(h_x=g_x/(t-x)\) the residual quadratic.  Then

\[
 \operatorname{disc}(h_x)=I\,H(x)-J\,f_a(x).
\]

Both sides are integer polynomials in \(a_0,\dots,a_4,x\) and the identity is exact, so it
holds in every characteristic, including two and three, where the elliptic model that
Kaipa and Pradhan build from a discriminant is unavailable.  This is the missing half of
the comparison: C881 proved the two genus-one curves coincide, and this identifies the two
parametrizations.

The earlier negative cheap test is explained rather than contradicted.  The syndrome
quartic is not the discriminant quartic up to square class; the discriminant quartic is
the specific covariant combination \(IH-Jf\), which is why the two agreed on only a small
fraction of the stratum.

## Why the fit failed twice before it worked

Two conventions had to be right at once, and each was wrong on the first attempt.

The covariants of a binary quartic that have degree four in the coefficients and order
four in the variable form a two-dimensional space spanned by \(IH\) and \(Jf\), so a
covariant of that bidegree is determined by two rational numbers.  The discriminant has
exactly that bidegree, yet no combination fitted.  A direct equivariance test settled why:
\(\operatorname{disc}\) transforms with the *inverse* substitution, with multiplier exactly
one.  Its variable is dual to the variable of the syndrome quartic, so the covariant basis
had to be built in the dual coordinate, which is the alternating reversal
\((a_0,-a_1,a_2,-a_3,a_4)\).  In that coordinate the fit is immediate and the coefficients
are \(1\) and \(-1\).

The lesson generalizes past this item: a covariant identity that fails to fit is more often
a coordinate on the wrong line than an absent relation, and the equivariance test is
cheaper than searching conventions.

## Three consequences

1. **\(J\) is the carrier cubic.**  The invariant \(J\) equals the determinant of the
   \(3\times3\) catalecticant of \(a\), which is exactly the cubic \(D\) whose vanishing
   cuts the first prime of the terminal bad carrier in the recursive-carrier section.  The
   carrier's cubic is therefore not an ad hoc determinant: it is the second classical
   invariant of the syndrome quartic, and the discriminant quartic degenerates to \(IH\)
   precisely on it.

2. **\(I\) is a linear complex.**  In the Plücker coordinates \(z\) of the pencil,
   \(I=z_3-3z_2\).  The first invariant of the syndrome quartic is a *linear* form in the
   Plücker coordinates, so its vanishing cuts the Klein quadric in a hyperplane section:
   the syndromes with \(I=0\) are exactly those whose pencil lies in one linear line
   complex.  Kaipa and Pradhan instead normalize a coordinate by \(z_5^2=I(\varphi)\); the
   two pictures differ by that choice, and in these coordinates no square root is needed.

3. **The residual component is the perfect-square locus.**  The terminal carrier's
   residual prime is the locus where the syndrome quartic \(f_a\) is a scalar multiple of
   the square of a binary quadratic.  This answers the standing question of why a projected
   Veronese surface appears in the recursive-carrier elimination: a Veronese is what the
   squaring map \(Q\mapsto Q^2\) produces, and the elimination is finding it because the
   symmetric-factor branch of the ordered-root incidence is the branch on which the
   syndrome quartic acquires a square.

   The evidence divides.  That the square locus satisfies all four printed generators is
   checked here, and gives containment only.  Equality is the elimination statement in the
   stable-component certificate, which the coordinate review replayed.  The relation
   \(27J^2=I^3\) on the locus is supporting evidence and not a characterization, since the
   quartic discriminant hypersurface also contains nonsquare quartics with other
   repeated-root partitions.

## A manuscript defect this exposed, and its repair

In the reduced terminal carrier proposition, the displayed parametrization of the residual
prime and the displayed generating set of the same prime were written in different
coefficient conventions, so as printed the parametrization did not lie on the variety its
own generators define.  The printed map \([u^2:2uv:v^2+2uw:2vw:w^2]\) is the perfect-square
locus in plain coefficients, while the generators are in the bottom coordinates the
proposition uses everywhere else.  Substituted into the printed generators it leaves
\(-10vw^3(uw-v^2)\), \(-5w^2(uw-v^2)(7uw+3v^2)\) and \(-10uvw^2(uw-v^2)\); only
\(c_0c_3^2-c_1^2c_4\) vanishes.

An independent coordinate review confirmed the mismatch, replayed the stable-component
elimination certificates, and widened the repair.  Its record is
`notes/2026-08-07-c883-terminal-residual-coordinate-review.md`.  Three findings there were
not in this report's first version:

- **Characteristic five hides it.**  Every residual above carries a factor of five, and
  \(B(u,-v,w)\equiv A(u,v,w)\bmod 5\) for the corrected map \(B\).  The printed map
  therefore has the correct fibre in characteristic five, and the mismatch is visible only
  in characteristic zero and characteristics other than two, three, and five.
- **The identical display elsewhere is correct.**  The redundancy-eight appendix prints the
  same plain Veronese, but introduces \(z_i=\binom4ic_i\) first, so it is right there.  The
  defect was local to the proposition that labels its coordinates \(c_i\).
- **The irredundancy witness was also invalid.**  The printed witness \((1,0,2,0,1)\) is not
  on the residual prime at all: it gives generator values \((0,-35,0,0)\), with
  catalecticant \(-6\).  The replacement \((3,0,1,0,3)\), the image of \((u,v,w)=(1,0,1)\),
  lies on the prime and has catalecticant \(8\), so it witnesses irredundancy uniformly.

All three repairs are applied.  The proposition now prints
\([6u^2:3uv:v^2+2uw:3vw:6w^2]\), states that this is the locus of quartics that are scalar
multiples of squares with \(f_c=6(uX^2-vXY+wY^2)^2\) on it, records the rescaling to the
appendix's coordinates, and uses the corrected witness.  The generators, the
characteristic-two plane, the characteristic-three cone, the residual degrees, and the
two-prime decomposition are unchanged.  Both manuscript builds and the supplement verifier
are green afterwards.  The generator script now checks each of these facts, including the
two witness evaluations and the characteristic-five coincidence, and reproduced every
number the review reported.

## The two Kaipa--Pradhan quartics, and a rejected correction

A literature audit run against this report proposed a correction: that their quartic is the
syndrome quartic \(f_a\) itself, that they never form a discriminant of a residual
quadratic, and that this report's identification should be withdrawn.  The first two claims
are wrong, checked against the source, and the third does not follow.

- Their line quartic is not \(f_a\).  Numerically, the roots of \(f_a\) are neither the
  contact nor the residual parameters; the contact parameters are the roots of \(H\).
- They do form the discriminant of the residual quadratic.  It is their \(D_L\), defined in
  equation (20) of `arXiv:2509.15332`, and their Proposition 4.5 asserts it has nonzero
  discriminant.  Their curve is \(E_L: T^2=4S^3-g_2S-g_3\) with \(g_2=3I(D_L)\) and
  \(g_3=J(D_L)\), so it is built from that quartic and not from \(\varphi_L\).

The audit's underlying observation was still worth having: there are two quartics, and this
report's first version named one and described the other.  The repair is to distinguish
them, which the Result section now does.

The match must include the projective scale of the line representative.  Put
\(\Delta=a_0a_2-a_1^2\), and work first on the patch \(\Delta\ne0\).  Solving the
Hankel kernel with its last two ordinary cubic coefficients equal to \((1,0)\) and
\((0,1)\), converting to Kaipa--Pradhan's divided-power cubic basis, and then applying
their equations (8) and (20) gives the exact identities

\[
 \varphi_L=-\frac{H}{3\Delta},\qquad
 z_5=\frac{I(f_a)}{18\Delta},\qquad
 D_L=\frac{\operatorname{disc}(h_x)}{36\Delta^2}.
\]

Since the manuscript writes \(D_f=\operatorname{disc}(h_x)/4\), this is

\[
 D_f=(3\Delta)^2D_L.
\]

Thus the manuscript's identification of the fibre square with their incidence curve stands
without a twist: the two Kummer equations differ by an explicit square in the function
field.  The equality on one dense Plücker patch proves the rational-function square-class
identity; the other patches give the same projective statement by changing the kernel basis.
The earlier fixed factor \(3/2\) came from comparing invariants of differently scaled quartic
representatives.  Quartic invariants detect the scaling but do not determine the line's
projective normalization, so they could not by themselves establish the claimed polynomial
equality.

## Math check

Recorded against the standing gates on the card.

1. **Re-derive, do not transcribe.**  Every object is rebuilt from its definition in the
   script: the pencil member from the kernel of the bordered Hankel matrix, the residual
   quadratic by division, the invariants and Hessian from the classical coefficient
   formulas.  Nothing is copied from a displayed formula in either source.
2. **Closure identity.**  The Plücker vector is checked to satisfy the Klein relation
   \(z_0z_5-z_1z_4+z_2z_3=0\), which is the closure identity available here.
3. **Count the objects.**  The two-dimensional covariant space is the object count that
   makes the fit decisive: a degree-four order-four covariant has exactly two degrees of
   freedom, so a fit with zero residual is a proof, not a coincidence.
4. **Direction of the biconditional.**  Not applicable; no cited biconditional is used.
5. **Fix the convention first.**  This was the whole difficulty, and it is now stated
   explicitly: the discriminant's variable is dual to the syndrome quartic's, and the
   syndrome coordinate is divided-power. The manuscript defect above is a failure of
   exactly this rule inside the paper.
6. **Characteristic and field scope.**  The identity is an equality of integer
   polynomials, so it holds over every field. The recorded mod-two and mod-three flags
   restate that consequence and are not independent evidence.
7. **Exhaustive verification.**  The claim is a symbolic identity over \(\mathbb Z\),
   which is stronger than any finite verification, so no field census is required.

## Reproducibility

- Generator: `notes/2026-08-07-c883-hankel-plucker-covariant.py`, SHA-256
  `d4b2e62dd82c5be64fa2a9179375adf2ba79b8ee70e173b89822c6b23cea7509`,
  11,836 bytes.
- Independent replay:
  `notes/2026-08-07-c883-hankel-plucker-covariant-replay.py`, SHA-256
  `f3cf014046311f6d53cf944186595807d8ce44e5d08f793d875d01fafdb01955`,
  2,545 bytes.
- Certificate: `notes/2026-08-07-c883-hankel-plucker-covariant.json`, SHA-256
  `ba10ebf7ee6441960b4429c98e43666227d378d3f97c5cfd2078db08d126b53c`,
  1,390 bytes.
- Regenerate from the repository root with
  `uv run --with sympy python3 notes/2026-08-07-c883-hankel-plucker-covariant.py`;
  check without writing by appending `--check`; independently replay the square-class
  calculation with
  `uv run --with sympy python3 notes/2026-08-07-c883-hankel-plucker-covariant-replay.py`.
  The three `false` entries in `plain_parametrization_generator_vanishing` are the expected
  certificate of the repaired printed defect; every assertion flag is `true`.

## Literature status

The required literature check is
`notes/2026-08-07-c883-covariant-literature-audit.md`.  Across its recorded classical
and modern search boundary, \(IH-Jf\) has no located standard name.  In the basis
\(\{IH,Jf\}\) the two natural transvectants are \((H,H)_2=-24IH+72Jf\) and
\((f,T)_3=-23040IH+34560Jf\), so \(IH-Jf=\tfrac1{72}(H,H)_2-\tfrac1{17280}(f,T)_3\) and is
not a single transvectant in either normalization.  The neighbouring
\(2IH-3Jf\), not the covariant here, is the repeatedly named classical element.

## Mystery ledger

- **Why the coefficients are exactly \(1\) and \(-1\).**  The fit returned
  \(\alpha=1,\beta=-1\) with the minor normalization of \(g_x\), which is a choice made for
  convenience. That an arbitrary-looking normalization lands on the unit combination is
  unexplained; it suggests the minors are the canonical normalization for this pairing
  rather than a convenient one. Not settled.
- **\(I\) linear in the Plücker coordinates, \(J\) not expressible in them at all.**  \(I\)
  has even degree in the syndrome and becomes a linear form in \(z\); \(J\) has odd degree
  and so cannot be any polynomial in \(z\). The asymmetry is forced by parity, but its
  geometric content — that one invariant is a line complex and the other is not a condition
  on the line at all — deserves a sentence in the manuscript if this is promoted.
- **Settled by this pass:** why the residual component of the terminal carrier is a
  projected Veronese, and why the earlier cheap square-class test came back negative.
- **Settled by the normalization replay:** the Kaipa--Pradhan comparison has no quadratic
  twist; the exact function-field square factor is \((3\Delta)^2\) on the displayed patch.
