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
   residual prime is the locus where the syndrome quartic \(f_a\) is a perfect square of a
   binary quadratic.  That locus satisfies all four printed generators of the residual
   prime, and on it \(27J^2=I^3\), so it lies inside the quartic discriminant, as a locus
   of quartics with repeated roots must.  This answers the standing question of why a
   projected Veronese surface appears in the recursive-carrier elimination: a Veronese is
   what the squaring map \(Q\mapsto Q^2\) produces, and the elimination is finding it
   because the symmetric-factor branch of the ordered-root incidence is the branch on
   which the syndrome quartic acquires a square.

## A manuscript defect this exposed

In the reduced terminal carrier proposition, the displayed parametrization of the residual
prime and the displayed generating set of the same prime are written in different
coefficient conventions, so as printed the parametrization does not lie on the variety its
own generators define.

- The generators are stated in the bottom coordinates the proposition uses elsewhere, the
  same divided-power coordinates as the Hankel matrix in its proof.  The perfect-square
  locus, written in those coordinates as
  \([u^2:-uv/2:(v^2+2uw)/6:-vw/2:w^2]\), satisfies all four.
- The printed parametrization \([u^2:2uv:v^2+2uw:2vw:w^2]\) is the perfect-square locus in
  plain rather than divided-power coefficients.  Substituted into the printed generators it
  gives \(10vw^3(v^2-uw)\) for the first, and fails the second and third as well; only
  \(c_0c_3^2-c_1^2c_4\) vanishes on it.

The repair is to restate the parametrization in the bottom coordinates, since the
generators agree with the coordinates used throughout the proof and with the intrinsic
description above.  This is a defect in a printed theorem statement, so it is left for an
explicit decision rather than repaired here.

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
  `6a16072b28d9695ca578417e7c37a409c127562f558ff702e4c039738d51366a`.
- Certificate: `notes/2026-08-07-c883-hankel-plucker-covariant.json`, SHA-256
  `90fe8dbf2a179733ae149c8c5e726d85b7f26adddeab4b1a149d1c66fb1ce86e`.
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
