# C756 diagonal character as a Gram-cofactor statistic

## Verdict

The four-point statistic exposed by the star-blocking profile has an exact
coordinate-free formula.  It is a quadratic-character evaluation of the
kernel cofactors of the four-point Gram matrix.  Summed over all four-subsets,
it becomes a fourth-order U-statistic for which covering forces an explicit
interval.

This is not the old cross-ratio-rank test in disguise.  The earlier matrix
asked whether a distinguished global kernel line is constant; the new
statistic reads three quadratic values from the cofactor kernel of every
four-point Gram matrix.  It is nevertheless close enough to the existing
adjugate machinery that a future proof can try a compound-matrix identity
without inventing another coordinate system.

## 1. Point type from the quadratic form

Let \(V\) be a three-dimensional vector space over \(\mathbb F_q\), let
\(Q\) define the nonsingular conic, and let \(H\) be the matrix of its polar
bilinear form in any basis.  For an off-conic point \(x\), put
\[
 \tau(x)=\chi_q\!\left(-\det(H)Q(x)\right). \tag{1}
\]
Changing basis multiplies the argument by a square, and rescaling \(x\)
does the same.  Thus (1) is projectively intrinsic.  With this convention,
\[
 \tau(x)=+1\iff x\text{ is external},
 \qquad
 \tau(x)=-1\iff x\text{ is internal}. \tag{2}
\]

## 2. Four-point cofactor formula

Let \(P_1,\dots,P_4\) be a quadrangle, choose representatives \(p_i\), and
form the rank-three Gram matrix
\[
 G_A=(\langle p_i,p_j\rangle)_{1\le i,j\le4}. \tag{3}
\]
Its kernel is the unique projective dependence
\[
 \lambda_1p_1+\lambda_2p_2+\lambda_3p_3+\lambda_4p_4=0. \tag{4}
\]
Every \(\lambda_i\) is nonzero.  The diagonal point obtained from the
opposite sides \(P_iP_j\) and \(P_kP_\ell\) is represented by
\[
 x_{ij\mid k\ell}=\lambda_i p_i+lambda_jp_j
 =-(\lambda_kp_k+\lambda_\ell p_\ell). \tag{5}
\]
Consequently its type is
\[
 \boxed{\quad
 \tau_{ij\mid k\ell}
 =\chi_q\!\left(-\det(H)
   (\lambda_i^2G_{ii}+2\lambda_i\lambda_jG_{ij}
       +\lambda_j^2G_{jj})\right).
 \quad} \tag{6}
\]

No arbitrary kernel choice enters (6): scaling \(\lambda\) changes its
argument by a square.  Moreover \(\lambda\lambda^{\mathsf T}\) is, up to
one scalar, \(\operatorname{adj}(G_A)\).  Formula (6) is therefore a genuine
Gram-cofactor invariant of the quadrangle.

If \(r(A)\) is the number of internal diagonal points, (2) gives
\[
 r(A)=\frac{3-
   (\tau_{12\mid34}+\tau_{13\mid24}+\tau_{14\mid23})}{2}. \tag{7}
\]
This also explains why a universal parity guess is unsafe: the three
cofactor values are individually variable even when all four vertices are
internal and all six sides are passants.

## 3. The global forced interval

Define the diagonal-character U-statistic
\[
 T_4(Y)=\sum_{A\in\binom Y4}
  (\tau_{12\mid34}+\tau_{13\mid24}+\tau_{14\mid23}). \tag{8}
\]
The labeling inside each four-set does not matter.  Since
\(T_4=3\binom n4-2\sum_A r(A)\), the type-refined blocking equations imply:

> **Proposition 28 (covering interval).**  If the dual star vertices of a
> saturated-internal arc block every non-tangent line, then
> \[
> -\frac{m(m-2)(m-1)(m-7)}8
> \ \le\ T_4(Y)\ \le\
> \frac{m(m-2)(m^2-8m+23)}8. \tag{9}
> \]
> More exactly,
> \[
> T_4(Y)=\frac{m(m-2)(m^2-8m+23)}8-2E_p, \tag{10}
> \]
> where \(E_p\ge0\) is the passant share of the triple-collision budget and
> \[
> E_p\le \frac{m(m-2)(m-3)(m-5)}8. \tag{11}
> \]

For the \(q=5\) frame, \(m=3\) and \(T_4=3\): all three diagonal points are
external.  At \(q=9\), blocking would force \(T_4=15\), while the exact
quadrangle census gives \(T_4=-15\) for any hypothetical six-arc because
every four-subset has two internal diagonals.  Thus the sign, not just the
magnitude, carries the endpoint contradiction.

## 4. Relation to the signed-resultant programme

For two representatives, the binary restriction discriminant
\[
 \Delta_{ij}=G_{ij}^2-G_{ii}G_{jj} \tag{12}
\]
detects whether the join \(P_iP_j\) is secant or passant.  The saturated
branch fixes the character of every \(\Delta_{ij}\), so pairwise data alone
cannot determine (6).  The new information is the rank-three dependence
\(\lambda\), equivalently a cofactor column of (3).

This positions (8) between two previous C756 objects:

- it is finer than the support of the signed elliptic-fusion matrix \(K\),
  because all six pair supports on a quadrangle are already fixed; and
- it is lower-order than the full angle-matrix condition
  \(\mathsf A\mathbf1=0\), because it uses only four-point Gram cofactors.

The promising algebraic question is whether summing the three character
expressions (6) over all four-subsets collapses through a second-compound or
exterior-square identity.  A bare expansion into cross-ratios is not enough;
the needed output is a bound incompatible with (9).

## EJ + TT closeout

**EJ.**  The star gate has supplied the missing target for a cofactor attack:
not “show a cross-ratio matrix is singular,” but bound the signed sum (8) of
three explicitly identified cofactor quadratic values.  This is a plausible
finite-geometry or character-sum spinoff even if the all-\(k\) classification
needs a stronger input.

**TT.**  Formula (6) does not itself save degree.  Summing it naively ranges
over \(\Theta(q^4)\) matchings and produces a fourth-order character sum with
moving cofactors.  The route should continue only if exterior algebra,
association-scheme harmonic analysis, or a known quadrangle theorem reduces
that statistic.  Generic Weil bounds at the raw degree are unlikely to beat
the interval (9).

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Is diagonal type projectively computable from four points? | settled | Gram-kernel formula (6) |
| Is the kernel arbitrary? | settled negative | its square is encoded by \(\operatorname{adj}(G_A)\) |
| What exact aggregate does covering constrain? | settled | the U-statistic \(T_4\) must lie in (9), with exact form (10) |
| Is this identical to the old rank test? | settled negative | old gate is a global constant-kernel condition; this is a local cofactor-character sum |
| Does raw expansion provide a bound? | open but low-EV | degree grows at fourth-order scale |
| Highest-EV next test | open | look for an exterior-square/association-scheme collapse of \(T_4\), otherwise move to a targeted literature theorem on relative blocking star configurations |

## Next action

Audit the operator form of (8): express it as the signed edge energy of the
star-vertex set in the internal-point passant graph, subtracting the known
arrangement-line contribution.  Apply the exact elliptic association-scheme
spectrum to test whether a Delsarte bound can violate (9).  Stop immediately
if the unrestricted spectral interval contains the full covering interval.
