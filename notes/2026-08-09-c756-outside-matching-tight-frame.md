# C756 outside matching tight frame

## Verdict

The global equality/simplex relation has a concrete contraction that survives
the passage to covering.  A hypothetical saturated-internal conic-filling
arc produces a tight frame in the root space \(A_m=\mathbf1^\perp\): one
nonzero signed matching vector for every outside internal point.

More precisely, after switching the equality support, the outside block
\(R\) of the signed elliptic-fusion matrix satisfies
\[
 \boxed{\qquad
 R\mathbf1=0,
 \qquad
 R^{\mathsf T}R=(m-2)((m+1)I-J).
 \qquad} \tag{1}
\]
Every row is a \(\{0,\pm1\}\)-vector whose nonzero coordinates occur in
oppositely signed disjoint pairs.  Covering is exactly the assertion that no
row is zero.  Thus the remaining saturated problem has a new finite-design
form:

> classify geometric tight decompositions of \((m-2)(m+1)I\) on \(A_m\)
> by \(2m(m-2)\) nonzero oriented matching vectors arising from conic
> chord pencils.

At \(m=3\), the four-frame gives the six roots \(e_i-e_j\) of \(A_3\).
This makes the exceptional case conceptually exact rather than merely small.

## 1. Block the signed fusion identity

Let \(Y\) be a coherent saturated support of size
\(n=m+1=(q+3)/2\).  Choose switching signs \(\eta_P\), put
\(D=\operatorname{diag}(\eta_P)\), and order the internal points with \(Y\)
first.  On \(Y\), the signed fusion matrix has block
\[
 D K_{YY}D=\epsilon(J-I),
 \qquad \epsilon=\chi_q(-1). \tag{2}
\]
Define the switched outside block
\[
 R=K_{\mathcal I\setminus Y,Y}D. \tag{3}
\]

The equality vector is a \(\lambda=\epsilon m\) eigenvector of \(K\), so
every outside row is balanced:
\[
 R\mathbf1=0. \tag{4}
\]
Now take the \(Y\times Y\) block of
\[
 K^2=\epsilon K+m(m-1)I. \tag{5}
\]
Using (2), one obtains
\[
\begin{aligned}
 R^{\mathsf T}R
 &=m(m-1)I+J-I-(J-I)^2\\
 &=(m-2)((m+1)I-J),
\end{aligned} \tag{6}
\]
which proves (1).  The nonzero eigenvalue in (6) is
\((m-2)(m+1)\) with multiplicity \(m\); hence the rows of \(R\) form a
tight frame for \(\mathbf1^\perp\).

## 2. Covering is absence of zero rows

For an outside internal point \(X\), let
\[
 t_X=\#\{P\in Y:XP\text{ is passant}\}.
\]
The squared norm of the row \(R_X\) is \(t_X\).  The dual star-blocking
equivalence and \(t_X=2d_X\), where \(d_X\) is the number of chords through
\(X\), give
\[
 X\text{ is covered}\iff R_X\ne0. \tag{7}
\]
Therefore internal-point covering is exactly the no-zero-row condition on
the tight frame (1).  There are
\[
 |\mathcal I\setminus Y|=2m(m-2) \tag{8}
\]
rows, and (6) gives the fixed total weight
\[
 \sum_X t_X=\operatorname{tr}(R^{\mathsf T}R)
 =m(m+1)(m-2). \tag{9}
\]
The mean nonzero row weight under covering is \((m+1)/2\).

## 3. Each row is an oriented matching

Suppose a chord \(P_iP_j\) passes through an outside internal point \(X\).
The three points lie on one passant.  The signed triangle on a passant line
is anti-coherent, whereas the edge \(P_iP_j\) inside \(Y\) is coherent.
Consequently
\[
 (R_X)_i(R_X)_j=-1. \tag{10}
\]
Distinct chords through \(X\) have disjoint endpoint pairs because \(Y\) is
an arc.  Hence
\[
 R_X=\sum_{(i,j)\in M_X}\sigma_{ij}(e_i-e_j), \tag{11}
\]
where \(M_X\) is a matching on the \(n=m+1\) support labels and
\(|M_X|=d_X=t_X/2\).  Equation (4) is therefore not merely aggregate
balance: cancellation occurs chord by chord.

Under covering every \(M_X\) is nonempty.  The frame identity becomes
\[
 \sum_{X\notin Y}R_XR_X^{\mathsf T}
 =(m-2)((m+1)I-J). \tag{12}
\]
This is a eutactic decomposition of the \(A_m\) root-space metric by signed
matching vectors, with the additional constraint that the matchings are the
chord pencils of one projective arc.

## 4. The four-frame as the root-system endpoint

For \(q=5\), \(m=3\), there are six outside internal points and (9) has
total row weight 12.  Covering forces every nonzero even row to have weight
two.  Thus the six rows are precisely the six oriented edge roots of the
complete graph on four support labels, up to row signs:
\[
 \{R_X\}=\{\pm(e_i-e_j):1\le i<j\le4\}. \tag{13}
\]
Their frame operator is
\[
 \sum_{i<j}(e_i-e_j)(e_i-e_j)^{\mathsf T}=4I-J,
\]
which is (12) at \(m=3\).

This identifies the projective four-frame with the canonical positive-root
tight frame of type \(A_3\).  For \(m>3\), the available number of outside
points is too small to realize (12) by single roots repeated \(m-2\) times,
so larger matching vectors are compulsory.

## 5. Relation to the unsigned star indicator

Let \(u=\mathbf1_Y\), and let \(A\) now denote the unsigned
internal-point/passant-line incidence matrix, identified by polarity.  Since
every passant meeting \(Y\) is a chord and hence contains exactly two support
points,
\[
 \mathbf1_{\mathcal B}=\frac12 Au. \tag{14}
\]
This is the exact global contraction sought in the previous pass.  Since
\(A^2=mI+G\), it also gives
\[
 A\mathbf1_{\mathcal B}=\frac12(mI+G)u, \tag{15}
\]
whose outside coordinate is \(t_X/2=d_X\).

Equations (12) and (14) expose the remaining information loss.  The signed
equality relation controls \(R\), while the star set uses the unsigned support
of its rows.  Taking absolute values discards the orientations in (11).
However, it no longer discards the matching decomposition itself.

## 6. Collision budget as a row-weight statistic

For an outside internal point \(X\), the non-arrangement passant
\(X^\perp\) contains exactly \(d_X=t_X/2\) star vertices.  Therefore the
passant collision budget has the exact row form
\[
 E_p=\sum_{X\notin Y}\binom{d_X-1}{2}
 =\sum_{X\notin Y}\binom{t_X/2-1}{2}, \tag{16}
\]
under the covering assumption.  Proposition 29 bounds this convex statistic
from above through ambient incidence.  A classification or moment theorem for
the matching tight frame (12) can now attack the same quantity directly.

## EJ + TT closeout

**EJ.**  The exceptional \(q=5\) configuration is the \(A_3\) root frame.
That is a clean forgetting/reconstruction-compatible explanation: deleting
one projective point leaves the signed simplex relation, while the outside
points are exactly the roots recording its pairwise reconstructions.  The
matching-frame formulation is a credible independent spinoff in design/frame
theory.

**TT.**  Abstract matching tight frames of the form (12) may exist for many
\(m\); (12) alone is not yet an impossibility theorem.  The geometry carries
more data: each row matching comes from concurrent chord lines, and external
points supply a second family of secant-line rows not represented in \(R\).
Do not claim an abstract classification without checking constructions.  The
next high-EV move is a bounded literature audit for tight frames of matching
vectors / star configurations blocking relative to a conic, followed by a
direct attempt to add the secant-polar rows.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Does the global equality relation survive outside the support? | settled | outside block satisfies the tight-frame identity (1) |
| What is covering on that block? | settled | every row is nonzero |
| Is row balance merely aggregate? | settled negative | each chord gives one oppositely signed coordinate pair |
| What is the \(q=5\) object? | settled | the six oriented roots of \(A_3\) |
| Can the star indicator be recovered linearly? | settled | \(\mathbf1_{\mathcal B}=Au/2\) |
| Does the abstract tight-frame identity alone exclude \(m>3\)? | open and not assumed | larger matching vectors may support abstract decompositions |
| What extra geometry remains unused? | open | concurrency realization of every matching and the external-point/secant half of covering |

## Next action

Run a focused novelty/theorem audit on two exact interfaces: finite-field star
configurations that are relative blocking sets with respect to a conic, and
tight frames/eutactic decompositions of \(A_m\) by signed matching vectors.
Then synthesize the best theorem-sized next lemma and update the C756 card.
