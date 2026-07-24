# C533 — C525 threshold and deletion sharpening

**Lane:** `reed-solomon` · **Date:** 2026-07-24 · **Status:** complete

## Result

Put \(m=n-4\).  C525's characteristic-two carrier theorem is unchanged, but its effective
constants improve from
\[
 q\ge \min\left\{\frac{m(m+15)}2+1,\,9m\right\},
 \qquad \delta_n^{(2)}\le 3n-4
\]
to
\[
 q\ge \min\left\{\frac{m(m+11)}2+1,\,7m\right\}
 =\min\left\{\frac{(n-4)(n+7)}2+1,\,7(n-4)\right\},          \tag{1}
\]
and
\[
 \delta_n^{(2)}\le 3n-6.                                    \tag{2}
\]
Together with
\[
 q+1-2\sqrt q>3n-6,                                         \tag{3}
\]
these conditions give the same conclusion as C525: every characteristic-two split-free PRS
syndrome lies in the persistent catalecticant/Lucas-nucleus carrier union.  No exceptional locus
is enlarged, and the geometrically integral reduced ordered-Hessian slice is unchanged.

The coefficient \(7\) in (1) comes from a cubic, rather than quartic, equation for the bad union in
Pluecker coordinates.  This cubic degree is the smallest possible universal degree modulo the
Grassmannian relation.  The two-unit saving in (2) is an exact scheme-theoretic overlap: after one
fixed root is sent to a coordinate endpoint, the divisor \(D=0\) is already that root's
residual-collision divisor.

## 1. Exact union covariant

Use C525's Pluecker coordinates
\[
(z_0,z_1,z_2,z_3,z_4,z_5)
=(p_{01},p_{02},p_{03},p_{12},p_{13},p_{23})
\]
and write the six distinct \(2\times2\) minors of its symmetric matrix as
\[
\begin{aligned}
q_0&=z_0z_2+z_0z_3+z_1^2,&
q_1&=z_0z_4+z_1z_2,\\
q_2&=z_1z_4+z_2^2+z_2z_3,&
q_3&=z_0z_5+z_2^2,\\
q_4&=z_1z_5+z_2z_4,&
q_5&=z_2z_5+z_3z_5+z_4^2.
\end{aligned}                                                \tag{4}
\]
They cut out the persistent Veronese surface \(\Sigma\).

Inside the Grassmannian \(G(1,3)\), the complementary conic \(\mathcal N\) is cut out by the three
linear equations
\[
g_0=z_0,\qquad g_1=z_5,\qquad g_2=z_2+z_3.                   \tag{5}
\]
Indeed the remaining equation \(z_1z_4=z_2^2\) follows from (5) and the Pluecker relation
\[
\pi=z_0z_5+z_1z_4+z_2z_3=0.                                \tag{6}
\]

For a syndrome outside C525's carrier, the root-compatible family is contained in neither
\(\Sigma\) nor \(\mathcal N\).  Hence some pulled-back \(q_i\) and some pulled-back \(g_j\) are
both nonzero.  Their product
\[
H=q_i g_j                                                     \tag{7}
\]
is nonzero because the root-coordinate ring is a domain, and it vanishes on
\(\Sigma\cup\mathcal N\).  Thus \(H\ne0\) selects a line outside both bad components at once.
This repairs the global-union issue that forced C525's corrected degree-eight product.

## 2. Separate degree and minimality

For one root coordinate \(r\), write the consecutive contraction vectors as \(A,B,C\).  The line
has the exact form
\[
\langle A-rB,\ B-rC\rangle.                                 \tag{8}
\]
Every Pluecker coordinate is therefore quadratic in \(r\).  Equations (4) have separate degree at
most four, equations (5) have separate degree at most two, and (7) has separate degree at most
six.  Repeating this for all \(m\) roots gives total degree at most \(6m\).

The cubic in (7) cannot be replaced uniformly by a nontrivial quadratic Pluecker equation.
Parametrize \(\mathcal N\) over the algebraic closure by
\[
[z_0:\cdots:z_5]=[0:s^2:st:st:t^2:0].
\]
The restrictions of \(q_0,\ldots,q_5\) are respectively
\[
s^4,\quad s^3t,\quad s^2t^2,\quad s^2t^2,\quad st^3,\quad t^4.
\]
Their only linear relation is \(q_2+q_3=\pi\).  Consequently the degree-two part of
\(I(\Sigma)\cap I(\mathcal N)\), modulo \(I(G(1,3))\), is zero.  Degree three is the first
universal common degree, and the products \(q_i g_j\) realize it.

The certificate also finds a consecutive-pencil specialization attaining separate degrees
\((4,2,6)\).  This is a sharpness check for the universal degree accounting, not a claim that
every syndrome specialization attains degree six.  Any improvement below seven-point blocks must
therefore use an additional identity specific to the constrained syndrome pullback, not another
universal Pluecker equation.

## 3. Deterministic base selection

Let \(\Delta=\prod_{a<b}(r_a-r_b)\).  The nonzero polynomial \(H\Delta\) has total degree at most
\[
6m+\binom m2=\frac{m(m+11)}2.
\]
Affine Schwartz--Zippel therefore supplies a rational tuple of distinct roots when
\[
q>\frac{m(m+11)}2.
\]

Alternatively, partition any \(7m\) field elements into disjoint seven-element sets
\(S_1,\ldots,S_m\).  Since \(H\) has degree at most six in each variable, successive univariate
interpolation shows that it cannot vanish on all of
\(S_1\times\cdots\times S_m\).  Disjoint blocks make every selected tuple collision-free.  These
two arguments give (1).

Vertical twisted-cubic intersections are still removed before this test, exactly as in C525.
The condition \(H\ne0\) avoids both complete reduced bad components, so the selected moving
component remains geometrically integral.

## 4. Scheme-theoretic deletion overlap

After the good fixed-root base \(R\) is selected, choose one of its roots and apply a projective
root-coordinate change sending it to \([0:1]\).  This is harmless because the ordered-Hessian
construction, the carrier union, and all collision conditions are projectively equivariant.

On
\[
N_u(u,v)X^2+N_s(u,v)XY+D(u,v)Y^2=0,
\]
incidence with that fixed root is exactly \(D(u,v)=0\), scheme-theoretically.  Thus the former
separate degree-two \(D=0\) deletion is a factor of the degree-\(2m\) fixed-root collision union.
The actual union degree is bounded by

| divisor union | degree |
|---|---:|
| moving/fixed diagonal | \(m\) |
| inseparability \(N_s=0\) | \(2\) |
| residual/fixed collisions, including \(D=0\) | \(2m\) |
| residual/moving collision | \(4\) |
| **total** | **\(3m+6=3n-6\)** |

Only a duplicate divisor has been removed.  In particular, branch points are not reclassified as
collisions and no rational point previously forbidden becomes admissible.  Equations (2)--(3)
then follow from the same genus-at-most-one normalization and Hasse--Weil argument as C525.

## 5. Prime-power consequences

The table gives representative first powers of two satisfying both the base-selection condition
and the corresponding exact Hasse inequality.  It is a consequence of the uniform proof, not
finite-level evidence for it.

| \(n\) | base before | base after | deletion before/after | first \(q\) before | first \(q\) after |
|---:|---:|---:|---:|---:|---:|
| 5 | 9 | 7 | 11 / 9 | 32 | 32 |
| 6 | 18 | 14 | 14 / 12 | 32 | 32 |
| 7 | 27 | 21 | 17 / 15 | 32 | 32 |
| 8 | 36 | 28 | 20 / 18 | 64 | 32 |
| 9 | 45 | 35 | 23 / 21 | 64 | 64 |
| 10 | 54 | 42 | 26 / 24 | 64 | 64 |
| 12 | 72 | 56 | 32 / 30 | 128 | 64 |
| 16 | 108 | 84 | 44 / 42 | 128 | 128 |
| 20 | 144 | 112 | 56 / 54 | 256 | 128 |
| 24 | 180 | 140 | 68 / 66 | 256 | 256 |
| 32 | 252 | 196 | 92 / 90 | 256 | 256 |

The checks use the integer-equivalent form of (3): with \(L=q+1-\delta>0\), require
\(L^2>4q\).  Thus no floating-point square-root comparison enters the table.

## Evidence and replay

The atomic bundle is:

- `notes/2026-07-23-c533-c525-threshold-deletion-sharpening.py`;
- `notes/2026-07-23-c533-c525-threshold-deletion-sharpening.json`;
- `notes/2026-07-23-c533-c525-threshold-deletion-sharpening-replay.py`; and
- `notes/2026-07-23-c533-c525-threshold-deletion-sharpening.sha256`.

From the repository root:

```text
python3 notes/2026-07-23-c533-c525-threshold-deletion-sharpening.py \
  --output notes/2026-07-23-c533-c525-threshold-deletion-sharpening.json --check
python3 notes/2026-07-23-c533-c525-threshold-deletion-sharpening-replay.py
(cd notes && sha256sum -c 2026-07-23-c533-c525-threshold-deletion-sharpening.sha256)
```

The generator performs exact polynomial arithmetic over \(\mathbf F_2\), records the six
restrictions to \(\mathcal N\), finds the one-dimensional quadratic kernel, searches the finite
set of consecutive pencils in \((\mathbf F_2^4)^3\) for the first nonzero sharp degree witness,
and computes the threshold table.  The replay independently row-reduces the restriction matrix,
enumerates its kernel, and recomputes every threshold and Hasse comparison.

The finite calculation checks the displayed algebra and arithmetic only.  The geometric
integrality, carrier equality, and divisor identification are the hand proofs above, imported
from C525 except for the exact refinements proved here.

## Extra-juice and Tao closeout

- The gain is not merely numerical: the complementary conic is a linear section of the
  Grassmannian.  Paying a quadratic conic generator was the entire extra two degrees in C525's
  corrected union product.
- The restriction calculation gives a clean method boundary.  No universal degree-four
  root-coordinate test can cut out the union, because there is no nontrivial common Pluecker
  quadric modulo the Grassmannian.
- The deletion saving is coordinate-free despite its endpoint proof: it says that evaluation at
  any chosen fixed root is already one member of the fixed-root collision union.
- The main failure modes were checked explicitly: neither component test may vanish identically;
  their product stays nonzero in the root-coordinate domain; the endpoint change is projective
  equivariance rather than an extra base restriction; and the Hasse table uses strict exact
  inequalities.

## Mystery ledger

Settled:

- **Can C525's bad union be tested below Pluecker degree four?** Yes, degree three suffices, by a
  Veronese quadric times a complementary-ruling linear form.
- **Is degree two universally enough?** No.  Its only common equation is the Grassmannian
  Pluecker relation.
- **Was \(D=0\) genuinely an additional deletion divisor?** No.  It is one fixed-root evaluation
  divisor after projective normalization.

Open:

- **Can the seven-point block be lowered using the constrained syndrome map?** The universal
  Pluecker method cannot do so, but the sharp-degree witness does not rule out a further
  syndrome-specific syzygy.  Evidence gap: an exact description of the image ideal of
  \((f,R)\mapsto L_f(\mathbf P(RE^\vee))\) in multiroot coordinates.  No successor is allocated;
  this is not needed for C533's acceptance gate.
- **Are there further uniform deletion gcds?** None follows from the universal ordered-Hessian
  geometry.  A further saving would require a proved gcd between branch, moving-root, and
  diagonal pullbacks for every constrained slice; C533 found no such identity and makes no
  generic-coprimality claim.

No mystery remains about the two improvements asserted in (1)--(2).
