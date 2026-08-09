# C756 two-species matching Gram and stop verdict

**Lane:** `clebsch` · **Date:** 2026-08-09 · **Scope:** saturated-internal
external-row gate; no manuscript edit

## Verdict

The outside external points do give a second family of matching rows, but
full projective incidence does **not** extend the signed tight frame
\[
R^{\mathsf T}R=(m-2)((m+1)I-J)
\]
to a new two-species signed identity.  It gives the unsigned type allocation
already measured by the secant/passant diagonal statistic.

More precisely, let \(n=m+1\), let \(E=\binom{Y}{2}\) index the star vertices,
and orient the edges of the complete graph on \(Y\) arbitrarily.  If
\(H\in\{0,\pm1\}^{E\times Y}\) is the resulting oriented edge--vertex
incidence matrix, then
\[
 H^{\mathsf T}H=L:=(m+1)I-J. \tag{1}
\]
The non-arrangement passants and the secants give matching-row matrices
\(U\) and \(V\) satisfying
\[
\boxed{
\begin{aligned}
 U^{\mathsf T}U&=(m-2)L+H^{\mathsf T}A_P H,\\
 V^{\mathsf T}V&=mL+H^{\mathsf T}A_S H,
\end{aligned}} \tag{2}
\]
where \(A_P\) and \(A_S\) record whether the line through two star vertices
from disjoint support edges is respectively passant or secant.  They partition
the Kneser adjacency:
\[
 A_P+A_S=A_{KG(m+1,2)}. \tag{3}
\]

The signed frame \(R\) is not \(U\): its chord-by-chord coefficients contain
the fusion holonomy that was deliberately discarded in forming \(U\).  The
extra external block therefore supplies no identity independent of the
existing line-type allocation.  The predeclared stop rule is triggered.

## 1. Star-edge coordinates

Let \(Y=\{P_1,\ldots,P_n\}\) be a hypothetical saturated-internal
conic-filling arc, and put
\[
 B_{ij}=P_i^\perp\cap P_j^\perp=(P_iP_j)^\perp.
\]
These \(\binom n2\) points are distinct and internal.  Fix an arbitrary
orientation of each edge \(e=\{i,j\}\) of \(K_n\), and let
\[
 h_e=\pm(e_i-e_j).
\]
Taking the \(h_e\) as the rows of \(H\) gives (1), independently of the
chosen orientations.

For a line \(\ell\) not among the arrangement lines \(P_i^\perp\), define
\[
 M_\ell=\{e\in E:B_e\in\ell\},
 \qquad
 w_\ell=\sum_{e\in M_\ell}h_e. \tag{4}
\]
The edges in \(M_\ell\) are pairwise disjoint.  Indeed, two star vertices
whose edges share \(i\) lie on the arrangement line \(P_i^\perp\); hence a
different line cannot contain both.  Thus every nonzero \(w_\ell\) is a
signed matching vector and
\[
 \lVert w_\ell\rVert^2=2|M_\ell|. \tag{5}
\]
In particular no cancellation can make a nonempty row vanish.

Split the rows (4) according as \(\ell\) is a non-arrangement passant or a
secant, and call the resulting matrices \(U\) and \(V\).  Under polarity,
these rows are indexed respectively by outside internal and outside external
points.  The star-blocking equivalence gives
\[
Y\text{ covers every off-conic point}
\quad\Longleftrightarrow\quad
\text{every row of both }U\text{ and }V\text{ is nonzero}. \tag{6}
\]

## 2. The two Gram matrices

Let \(P\) and \(S\) be the zero-one incidence matrices from the
non-arrangement passants and secants to the star points \(B_e\).  Then
\[
 U=PH,
 \qquad
 V=SH. \tag{7}
\]

Each internal star point lies on \(m\) passants, two of which are its
arrangement lines, and on \(m\) secants.  Two distinct star points from
adjacent edges share only their arrangement line.  Two from disjoint edges
share one non-tangent, non-arrangement line; it is either passant or secant.
Consequently
\[
 P^{\mathsf T}P=(m-2)I+A_P,
 \qquad
 S^{\mathsf T}S=mI+A_S, \tag{8}
\]
with (3).  Conjugating (8) by \(H\) proves (2).

This is exactly the full-projective-incidence calculation in star
coordinates.  If \(N\) is the complete point--line incidence matrix, the
restriction to the star columns satisfies
\[
 N_{\mathcal B}^{\mathsf T}N_{\mathcal B}=qI+J. \tag{9}
\]
Removing the two arrangement rows through each star point and then applying
\(H\) gives the same sum of the two equations in (2).  Equation (9) supplies
no further signed relation between the two species.

## 3. Exact relation to the diagonal statistic

For a four-subset \(A\subset Y\), its three pairs of opposite support edges
give the three diagonal points of the quadrangle.  If \(r(A)\) of those
points are internal, the corresponding lines between their dual star points
contribute \(r(A)\) entries to \(A_P\) and \(3-r(A)\) to \(A_S\).  Therefore
\[
 \mathbf1_E^{\mathsf T}(A_S-A_P)\mathbf1_E
 =2\sum_{A\in\binom Y4}(3-2r(A))
 =2T_4(Y). \tag{10}
\]

Thus the edge-space type-difference Gram contains exactly the statistic
already bounded by the projective-incidence cap.  Projection through \(H\)
in (2) changes its presentation but adds no sign or inequality.

## 4. Why the signed internal frame does not repair the gate

The signed fusion block has rows
\[
 R_X=\sum_{e\in M_{X^\perp}}\tau_{X,e}h_e,
 \qquad \tau_{X,e}\in\{\pm1\}, \tag{11}
\]
and its holonomy forces the global cancellation
\[
 R^{\mathsf T}R=(m-2)L. \tag{12}
\]
The unsigned internal matrix \(U\) instead sets every coefficient in (11)
to \(+1\) after the edge orientations are fixed.  Its defect is precisely
\(H^{\mathsf T}A_PH\) in (2).  Nothing in full point--line incidence assigns
compatible signs to the secant rows or relates them to the fusion
coefficients \(\tau_{X,e}\).

Any such relation would be a genuinely new spinor/holonomy theorem, not a
consequence of (9).  Without it, a proposed external signed tight frame is
an extra assumption.  The mixed row Gram \(UV^{\mathsf T}\) likewise depends
on the arbitrary edge orientations and on the full diagonal allocation; its
trace contractions reduce to (8)--(10).

## 5. Consequences for routing

The successful part is a clean two-species matching realization of covering:
all outside internal and external points index nonzero matching rows.  The
failure is equally sharp: projective incidence controls only the unsigned
type Grams, and their difference is the existing diagonal statistic.

Therefore:

- do not continue by adding higher contractions of \(U\) and \(V\);
- do not infer an external tight frame from the signed internal frame;
- reopen this route only if an independently proved secant-row sign cocycle
  couples the two species; and
- return the main all-\(k\) investment to the independent nonsaturated
  masked Rédei target \(h\ge1\).

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Do outside external points give matching rows? | settled | secant-polar rows (4) |
| Is covering the no-zero-row condition for both point types? | settled | equation (6) |
| What does full projective incidence give? | settled | the unsigned Grams (2) |
| Is the external block a second tight frame? | not implied | needs a new compatible secant-row sign cocycle |
| Does the two-species Gram add a scalar obstruction? | settled negative | its type difference contracts to \(2T_4\) in (10) |
| Should this route continue? | no under its stop rule | higher unsigned moments only repackage the line profile |

## Next action

Return to the nonsaturated branch and attack the masked Rédei theorem
\(h\ge1\).  Use the Frobenius graph/fixed-locus formulation from the
coordinate-free audit; do not retry one-line subresultants or naive global
divisor interpolation.
