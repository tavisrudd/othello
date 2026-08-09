# C756 projective-incidence cap on the diagonal statistic

## Verdict

The bounded operator test succeeds.  It does not evaluate the diagonal
U-statistic, but it forces its sign.  For any hypothetical saturated-internal
conic-filling arc, the total diagonal character is strictly positive:
\[
 \boxed{\qquad
 T_4(Y)\ge
 \frac{m(m-2)(m-1)(m+1)}{8(2m-1)}>0.
 \qquad} \tag{1}
\]

The proof needs no detailed elliptic association-scheme spectrum.  It is the
singular-value bound inherited by the internal-point/passant-line incidence
matrix from the full projective plane.  Equivalently, it cuts at least about
half of the previously available triple-collision budget.

This gives the current highest-value saturated gate:

> Prove that every coherent saturated-internal support with \(q>5\) has
> \(T_4(Y)\le0\).

Such a theorem would contradict (1) and close the branch while using only a
four-point aggregate, not a classification of the support.

## 1. The internal passant graph

Let \(\mathcal I\) be the \(v=q(q-1)/2=(2m-1)(m-1)\) internal points of the
conic.  Let \(G\) be the zero-one adjacency matrix in which two internal
points are adjacent when their join is a passant.  Each internal point lies
on \(m\) passants, each containing \(m\) internal points, so \(G\) is
regular of degree
\[
 d=m(m-1). \tag{2}
\]

Let \(A\) be the incidence matrix between internal points and passant lines,
identified as a square matrix by conic polarity.  Two distinct internal
points have one common passant exactly when they are adjacent in \(G\), and
each point lies on \(m\) passants.  Hence
\[
 A^{\mathsf T}A=mI+G. \tag{3}
\]

## 2. Ambient singular-value bound

Embed \(A\) as the internal-point/passant-line submatrix of the full
point-line incidence matrix \(N\) of \(\mathrm{PG}(2,q)\).  The projective
plane identity is
\[
 N^{\mathsf T}N=qI+J. \tag{4}
\]
For a vector \(z\) on internal points with \(z\perp\mathbf1\), extend it by
zero to all projective points.  Restricting the output to passant rows can
only decrease its norm, so
\[
 \|Az\|^2\le\|Nz\|^2=q\|z\|^2. \tag{5}
\]
By (3),
\[
 z^{\mathsf T}Gz\le(q-m)\|z\|^2=(m-1)\|z\|^2. \tag{6}
\]
Thus every nonconstant Rayleigh quotient of the internal passant graph is at
most \(m-1\).  This elementary bound is enough; the many individual
association-scheme eigenvalues need not be resolved.

## 3. Edge cap for a star-vertex set

Let \(\mathcal B\subset\mathcal I\) be the \(b=m(m+1)/2\) dual star
vertices and let \(y=\mathbf1_{\mathcal B}\).  Decompose
\[
 y=\frac bv\mathbf1+z,qquad z\perp\mathbf1,qquad
 \|z\|^2=b-\frac{b^2}{v}. \tag{7}
\]
Using (2) and (6), the number \(E_G(\mathcal B)\) of passant joins within
\(\mathcal B\) satisfies
\[
\begin{aligned}
 2E_G(\mathcal B)=y^{\mathsf T}Gy
 &\le \frac{db^2}{v}+(m-1)\left(b-\frac{b^2}{v}\right),\\
 E_G(\mathcal B)
 &\le U_m:=
 \frac{m(m^2-1)(m^2+5m-2)}{8(2m-1)}. \tag{8}
\end{aligned}
\]

Every pair of star vertices on an arrangement line is a passant pair.  There
are
\[
 (m+1)\binom m2=\frac{m(m+1)(m-1)}2 \tag{9}
\]
such pairs.  Every other passant pair is counted by \(P\) in the
secant/passant allocation.  Under covering,
\[
 P=\frac{m(m-2)(m-3)}2+E_p. \tag{10}
\]
Combining (8)--(10) gives the uniform cap
\[
 E_p\le
 \frac{m(m-2)(m^3-9m^2+27m-11)}{8(2m-1)}. \tag{11}
\]
For \(m\ge7\), this is strictly smaller than the full collision budget by
\[
 \frac{m(m-2)(m-1)(m^2-7m+4)}{8(2m-1)}. \tag{12}
\]
Asymptotically, (11) retains only about half of the naive budget.

## 4. Positive diagonal bias

The previous pass gave
\[
 T_4(Y)=\frac{m(m-2)(m^2-8m+23)}8-2E_p. \tag{13}
\]
Substitution of (11) into (13) simplifies exactly to (1):
\[
 T_4(Y)\ge
 \frac{m(m-2)(m-1)(m+1)}{8(2m-1)}. \tag{14}
\]

> **Proposition 29 (positive-bias obstruction).**  If a saturated-internal
> conic-external arc is conic-filling, then its three diagonal-point types,
> summed over every four-subset as in \(T_4\), have strictly positive total
> external bias.

The right side of (14) need not be integral, but \(T_4\) is an integer, so
one may take the ceiling.  For the \(q=5\) frame, \(T_4=3\), consistent with
the bound.  The certified \(q=9\) quadrangle law would instead give
\(T_4=-15\), explaining its sharp incompatibility with covering.

## 5. Why this is stronger than a generic graph bound

The graph estimate alone applies to any internal point set of size \(b\).
Its force here comes from the star decomposition:

- the arrangement contributes the exact large block (9) of known passant
  edges;
- covering determines the baseline (10) for all remaining lines; and
- the residual edge count is exactly the local four-point collision variable
  \(E_p\).

Without these three inputs, (8) is only a routine expander-mixing inequality.
Together they turn it into the sign theorem (14).

## EJ + TT closeout

**EJ.**  The detailed elliptic spectrum is unnecessary for the uniform
result.  The full projective-plane identity (4) provides a clean
``forgetting'' argument: extend an internal vector by zero, apply the known
plane incidence norm, then forget all non-passant output rows.  This is both
short and likely manuscript-grade.

**TT.**  Positivity is a necessary condition, not yet a contradiction.  The
temptation is to assert that coherent supports should have negative diagonal
bias because the \(q=9\) local controls do; no such theorem has been proved,
and the \(q=5\) frame has positive bias.  The next pass must test the sign of
\(T_4\) on the exact coherent/simplex equations, not on arbitrary
pairwise-passant quadrangles.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Does the association scheme give a usable bound? | settled positive | ambient incidence already gives nonconstant eigenvalue at most \(m-1\) |
| How much collision slack survives? | settled | cap (11), asymptotically about half the raw budget |
| What sign must a covering support have? | settled | strictly positive \(T_4\), equation (14) |
| Is a detailed eigenvalue calculation necessary? | settled negative for this step | full-plane incidence dominates the required operator norm |
| What would close the saturated branch? | sharpened open | prove coherent saturated supports have \(T_4\le0\) for \(q>5\) |
| Is that sign claim currently evidenced uniformly? | no | \(q=9\) supports it locally; \(q=5\) is the required exception; larger coherent supports do not exist in the bounded census |

## Next action

Insert the equality-support/simplex relation into the Gram-cofactor formula
for \(T_4\).  Seek a sum-of-squares or signed-incidence expression whose
sign is nonpositive for \(m>3\) and degenerates at the four-frame.  Stop if
the calculation needs the nonexistent support as empirical input or merely
rephrases the full angle-row condition.
