# C904: full Kunneth parity for the unordered-theta multisection

Date: 2026-08-11

Status: theorem-grade reduction and correction; Paper V research only; no
manuscript or Lean change

## Verdict

An odd codimension-three multisection of

\[
       s:\operatorname {Sym}^2 M\longrightarrow J,
       \qquad M=\operatorname {Bl}_0\Theta,
\]

is **not formally equivalent** to an odd curve supported on $\Theta$.
There are two integral middle-Kunneth escape lattices.  Their two-primary
sizes are exact:

\[
\begin{array}{c|c}
\text{channel}&\text{dyadic residual lattice}\\ \hline
H^1(M)\otimes H^5(M)&(\mathbf Z/2)^{10},\\
H^2(M)\otimes H^4(M)&(\mathbf Z/2)^{44}.
\end{array}
\]

The $H^3\otimes H^3$ channel is always even.  The
$H^0\otimes H^6$ channel is exactly the already known odd
theta-supported-curve route.  In the $H^2\otimes H^4$ channel, every
decomposable algebraic divisor/surface tensor is again an actual
theta-supported curve; only a non-split integral Kunneth correspondence can
escape.  The genuinely new odd-cohomology possibility is
$H^1\otimes H^5$.

The correction to the tempting trace argument is important.  On the marked
$E^5$ Hodge structure, an integral Hodge endomorphism has square
characteristic polynomial on the rank-ten $H^1$ lattice, so its ordinary
trace is even.  But that is the **ordered** trace.  Passage to the symmetric
square divides it by two.  The downstairs degree is the five-dimensional
coefficient trace, which can be odd; the identity has degree five.  Thus
generic $\mathrm {SL}_2$ Hodge symmetry does not kill the
$H^1\otimes H^5$ route.

What it does require is exactly the old missing two-local projector.  The
diagonal gives the identity in codimension four.  To realize the odd
degree-five class in codimension three one must apply an integral inverse to
cup product by theta.  That inverse has ten elementary divisors two in the
$H^1/H^5$ sector.  Rationally it exists and the Hodge tensor is algebraic;
integrally its algebraicity is precisely what is not known.  The
$H^2/H^4$ sector has forty-four analogous dyadic directions.

Equivalently, every proposed odd multisection produces an integral Hodge
curve class $\lambda$ on $M$ with odd theta degree and with $2\lambda$
algebraic.  It produces an actual odd theta-supported algebraic curve if and
only if this half class is algebraic.  A middle-Kunneth escape would be an
algebraic symmetric correspondence whose half anti-graph class is the
nonalgebraic primitive class.  This is the exact remaining channel, not a
new free source of odd degree.

## 1. The half anti-graph formula

Choose the symmetric theta divisor and let $\iota$ be the lift of inversion
to $M$.  Put

\[
 q:M\times M\longrightarrow\operatorname {Sym}^2M,\qquad
 j=(1,\iota):M\longrightarrow M\times M.
\]

Let $Z\in CH^3(\operatorname {Sym}^2M)$ and write
$s_*Z=d[J]$.  Components supported in the exceptional locus do not
dominate $J$ and may be discarded for this calculation.  Set

\[
             \Gamma=q^*\operatorname {cl}(Z)\in H^6(M\times M,\mathbf Z).
\]

The free integral cohomology in total degree six has Nakaoka--Gugnin's
transfer lattice.  In bidegree $(r,6-r)$ its generators are

\[
 x\otimes y+(-1)^{r(6-r)}y\otimes x.
\]

For $r=3$ these are exterior, not symmetric, tensors.  Inversion acts by
$(-1)^k$ on the inherited odd group $H^k(M)$ and trivially on the
exceptional even summands.  Pulling every transfer generator to the
anti-graph therefore gives twice an integral class.  Hence

\[
             \lambda(Z):=\frac12j^*\Gamma\in H^6(M,\mathbf Z)
             \tag{1.1}
\]

is integral.  It is a Hodge class, and $2\lambda(Z)$ is the class of the
algebraic anti-graph intersection.

There is also an exact degree formula.  The ordered addition map
$\mu:M^2\to J$ satisfies

\[
                 \mu_*\Gamma=2d[J].
\]

At zero its fibre has the excess anti-graph.  Compute the refined excess
before resolving the isolated theta singularity: since
$\Theta\hookrightarrow J$ is a Cartier divisor, the excess line is
$\mathcal O_\Theta(\Theta)$, whose pullback is
$h=f^*\Theta$.  Therefore

\[
          2d=\int_M h\,j^*\Gamma,\qquad
          \boxed{d=\int_M h\,\lambda(Z)}.
          \tag{1.2}
\]

The exceptional discrepancy $e$ in $K_M=h+e$ does not enter (1.2): the
excess theory uses the Cartier normal line of the singular theta divisor,
not the canonical line of its resolution.

Thus every odd multisection canonically produces an odd integral Hodge
curve class whose double is algebraic.  Formula (1.2) is the common
compression of all Kunneth channels.

## 2. Channel-by-channel parity

Let $f:M\to J$ be the theta resolution.  A transfer tensor
$\alpha\otimes\beta+(-1)^{p(6-p)}\beta\otimes\alpha$ in bidegree
$(p,6-p)$ contributes downstairs degree

\[
             \pm\int_J f_*\alpha\,f_*\beta.
             \tag{2.1}
\]

### 2.1 The axis channel $(0,6)$

The degree-six factor is isolated by restricting the algebraic cycle to
$M\times\{o\}$ for an algebraic base point $o\in M$.  It is therefore an
actual algebraic curve class on $M$.  If (2.1) is odd, this is precisely an
odd theta-supported curve.  Conversely such a curve gives the usual
degree-five multisection by pairing it with $[M]$.

### 2.2 The $(3,3)$ channel is even

Weak Lefschetz identifies $H^3(M,\mathbf Z)$ with $H^3(J,\mathbf Z)$.
Both Gysin factors in (2.1) therefore contain theta:

\[
 f_*\alpha=\Theta\alpha,\qquad f_*\beta=\Theta\beta.
\]

Since the square of an integral alternating form is twice its divided
square,

\[
 \int_J\Theta^2\alpha\beta\equiv0\pmod2.
\]

Thus no algebraic $H^3\otimes H^3$ correspondence can have odd
unordered-theta degree.

### 2.3 The $(1,5)$ residual is ten-dimensional

Write $\Lambda=H^1(J,\mathbf Z)$ and let
$L=\Theta\wedge-$.  Weak Lefschetz and Poincare duality identify
$H^1(M)=\Lambda$ and the Gysin image of $H^5(M)$ with
$\bigwedge^7\Lambda$.  If the latter class belongs to
$L\bigwedge^5\Lambda$, (2.1) contains $\Theta^2$ and is even.

The obstruction to making that replacement is exact:

\[
 \operatorname {coker}\left(
 L:\bigwedge^5\Lambda\longrightarrow\bigwedge^7\Lambda
 \right)\cong(\mathbf Z/2)^{10}.
 \tag{2.2}
\]

The Smith form is $1^{110}2^{10}$.  Modulo two, the residual quotient is
perfectly paired with $L\Lambda$: the pairing

\[
 (\alpha,[B])\longmapsto
       \int_J\Theta\,\alpha\,B\pmod2
 \tag{2.3}
\]

vanishes on $L\bigwedge^5\Lambda$ because $\Theta^2=0$ modulo two, and
both sides have dimension ten.

For the generic marked non-CM $E^5$ structure, (2.3) turns the Hodge
residue into an endomorphism of the five-dimensional coefficient lattice.
Its unordered degree is the coefficient trace.  The identity therefore has
degree five, not ten.  Algebraic realization of that identity in
codimension three is an integral inverse-Lefschetz correspondence; the
codimension-four diagonal does not supply it.

### 2.4 The $(2,4)$ residual and the divisor-cut boundary

The corresponding exact Smith form is

\[
 \operatorname {coker}\left(
 L:\bigwedge^4\Lambda\longrightarrow\bigwedge^6\Lambda
 \right)
   \cong(\mathbf Z/2)^{43}\oplus\mathbf Z/6.
 \tag{2.4}
\]

Its two-primary quotient has dimension forty-four.  It is perfectly paired
modulo two with the rank-forty-four image of
$L:\bigwedge^2\Lambda\to\bigwedge^4\Lambda$.

If an algebraic $(2,4)$ Kunneth tensor separates into an algebraic divisor
$D$ and an algebraic surface $S$ on $M$, its half anti-graph contribution
is the actual curve $D\cdot S$.  Odd degree then gives an odd
theta-supported curve and is not a new route.  A possible escape must be a
non-split integral Hodge correspondence whose Kunneth factors cannot be
separated algebraically.  Its half anti-graph is again an odd Hodge curve
with algebraic double.  Thus the forty-four residual directions are part of
the same two-local projector obstruction, not part of the already exhausted
divisor-generated subring.

This distinction explains why the previous exact degree ideal
$8\mathbf Z$ for triple products of descended divisors does not classify
all of $CH^3(\operatorname {Sym}^2M)$.

## 3. Exact relation to the minimal-theta gate

Let

\[
 {\cal A}_1(M)\subset\operatorname {Hdg}^6(M,\mathbf Z)
\]

be the subgroup of algebraic curve classes.  The half anti-graph theorem
gives

\[
 [\lambda(Z)]\in
 \bigl(\operatorname {Hdg}^6(M,\mathbf Z)/{\cal A}_1(M)\bigr)[2].
 \tag{3.1}
\]

If $d$ is odd, this class has odd theta degree.  In the previously computed
theta lattice, every such class lies in the unique primitive parity coset
represented by the lift $a$ of
$\Theta^4/4!$, with

\[
                        2a=z+\ell
\]

for known algebraic curves $z,\ell$.  Therefore an odd middle-Kunneth
multisection has exactly two possibilities:

1. $\lambda(Z)$ is algebraic.  Then it is the desired odd
   theta-supported curve, and the axis construction already closes the
   gate.
2. $\lambda(Z)$ is not algebraic.  Then $Z$ is an integral algebraic
   codimension-three symmetric correspondence realizing the primitive
   two-torsion half without algebraizing the half itself.

The second possibility is precisely an integral-at-two Chow projector
phenomenon.  In motivic language, one must lower the algebraic diagonal by
one theta Lefschetz operator.  Rational inverse Lefschetz and rational
algebraicity are classical; the Smith forms (2.2)--(2.4) show exactly where
the integral inverse needs division by two.  This is the same obstruction
encountered in the universal-Ext diagonal approach.

Thus:

\[
\boxed{
\begin{array}{c}
\text{odd theta curve}\Longrightarrow\text{odd multisection},\\
\text{odd multisection}\Longrightarrow
  \text{odd algebraic theta curve or an integral two-local}\\
\text{inverse-Lefschetz correspondence with nonalgebraic half}.
\end{array}}
\]

There is no theorem reducing the second alternative to the first.  Claiming
such an equivalence would assume the very integral Hodge/Chow projector
statement still at issue.

## 4. Consequences for the live search

- **Closed:** $H^3\otimes H^3$ as an odd-degree route.
- **Closed:** decomposable $H^2\otimes H^4$ tensors as a route distinct
  from an odd theta-supported curve.
- **Not closed:** the ten dyadic $H^1/H^5$ inverse-Lefschetz directions.
- **Not closed:** forty-four dyadic non-split $H^2/H^4$ projector
  directions.
- **Invalid obstruction:** even rank-ten trace or square characteristic
  polynomial.  Symmetric descent halves that trace.
- **Sharp construction target:** an integral codimension-three
  correspondence on $M\times M$ whose mod-two Lefschetz residue is the
  identity on the coefficient lattice, followed by proof of symmetric
  Chow descent.  Equivalently, algebraize the needed one-step inverse
  Lefschetz operator at two.

An odd class obtained this way would be enough: by (1.2) it gives an odd
multisection, hence index one for the unordered-theta generic fibre.  The
degree-fifteen/$\operatorname {Sym}^2(E_3)$ relays then give index one for
the charge-three fibre and the relative identity by Bezout with the existing
multiplier two.

## 5. Source and replay boundary

The only external input newly used here is the already audited integral
symmetric-product pullback theorem:

- Dmitry V. Gugnin, *On Integral Cohomology Ring of Symmetric Products*,
  arXiv:1502.01862, Theorem 1, PDF pp. 4--7.  Cached PDF SHA-256
  74c1d9704d7ddd24f76f314162a44c05727db9770648f6d285679e23b67b4107;
  extracted text SHA-256
  bbf2266aaf41c7740fd9cbe0675c3ab96262b1cb729f847ef1f25c91b4ebe031.

The weak Lefschetz, Gysin, excess-intersection, and symplectic exterior
algebra steps are proved directly above.  The exact Smith forms are replayed
from the repository root by:

~~~bash
nix shell nixpkgs#sage -c sage -c 'exec(preparse(open("notes/2026-08-11-c904-symmetric-theta-kunneth-parity.sage").read()))'
~~~

Expected output is frozen in
notes/2026-08-11-c904-symmetric-theta-kunneth-parity.out.  The replay creates
no preparsed side file.
