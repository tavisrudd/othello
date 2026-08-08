# C883 item 5 — the Hankel--Plücker map as a classical covariant

**Lane:** `reed-solomon` · **Date:** 2026-08-07 · **Card:**
`notes/reed-solomon-tasks/c883-r5-followups.md`

## Result

The discriminant quartic that Kaipa and Pradhan attach to a line of `PG(3,q)` is a
classical covariant of the syndrome quartic, and the relation is an identity of integer
polynomials rather than a numerical coincidence on a stratum.

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
  `ecad4785c005786d925e7b718f7285cb9c8ee37f745ec869c1c2d99df348b203`.
- Certificate: `notes/2026-08-07-c883-hankel-plucker-covariant.json`, SHA-256
  `65cd44051eab65980a09b71980c379f19748de708e98e2eb61db657c14722798`.
- Replay: `uv run --with sympy python3 notes/2026-08-07-c883-hankel-plucker-covariant.py`.
  Every recorded flag is `true` except the last, which records the manuscript defect: the
  printed parametrization satisfies only the fourth of the four printed generators.

## Outstanding before promotion

The card requires a math check and a literature check per item, both recorded, before an
item may be promoted into the manuscript. The math check is above; the literature check is
not done. It must establish whether \(IH-Jf\) already carries a classical name in the
covariant theory of binary quartics. What is known so far is internal: in the basis
\(\{IH,Jf\}\) the two natural transvectants are \((H,H)_2=-24IH+72Jf\) and
\((f,T)_3=-23040IH+34560Jf\), so \(IH-Jf=\tfrac1{72}(H,H)_2-\tfrac1{17280}(f,T)_3\) and is
not a single transvectant in either normalization. Whether the combination is named
classically, and by whom, is the open question.

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
