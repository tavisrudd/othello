# C756 defect-two star near-transversal: exact dual gate

**Lane:** `clebsch` · **Date:** 2026-08-09 · **Scope:** nonsaturated
structural reduction; no manuscript edit

## Verdict

The phrase "all-internal defect-two near-transversal" is too broad to be a
useful classification target.  Arbitrary examples exist immediately: from
an internal center, choose one internal point on every line of the pencil
except one fixed passant, then add two internal points in either allowed
collision profile.

The actual C756 object has much more structure.  At the first open boundary
\((q,k)=(53,12)\), it is the set of 55 pairwise intersections of 11 passants
in dual-arc position.  On a twelfth passant, each of its 16 internal
non-arrangement points must be a direction-complete center for those 55
nodes.  This is the exact star-realizable near-transversal gate.

The elementary pair budget for these centers is exact, but after separating
the 11 arrangement points it becomes precisely the masked diagonal count
closed in the preceding report.  It supplies no new parity obstruction by
itself.  Future work should therefore target a theorem about the number of
direction-complete centers of a star configuration, not classify arbitrary
all-internal near-transversals and not repeat the pair budget.

## 1. Dual star model

Let \(A=\{P_0,\ldots,P_{11}\}\) be a hypothetical all-internal
conic-filling arc in \(\mathrm{PG}(2,53)\).  Under conic polarity put
\[
 r_i=P_i^\perp.
\]
Every \(r_i\) is a passant.  The arc condition says that no three of these
lines are concurrent, while conic externality says that every arrangement
node
\[
 N_{ij}=r_i\cap r_j
\]
is internal.

Fix \(r_0\), and let
\[
 S_0=\{N_{ij}:1\le i<j\le11\}.
\]
Then \(|S_0|=\binom{11}{2}=55=q+2\), and all points of \(S_0\) are
internal.  The line \(r_0\) contains 27 internal points.  Eleven are the
arrangement nodes \(N_{0i}\); the remaining
\[
 27-11=16                                                     \tag{1}
\]
are in polarity-preserving bijection with the spare passants through
\(P_0\).

For an internal non-arrangement point \(L\in r_0\), projection from \(L\)
maps every node of \(S_0\) to one of the 53 lines through \(L\) other than
\(r_0\).  The primal covering condition on the corresponding spare line is
exactly
\[
 \text{every one of those 53 lines contains a point of }S_0.  \tag{2}
\]
Thus all 16 points in (1), not merely one selected center, must satisfy (2).

This formulation retains all three load-bearing inputs: the nodes are a
complete 11-line star, the arrangement lines are passants, and every node is
internal.

## 2. Why arbitrary internal near-transversals are not rigid

Let \(q=2m-1\), let \(L\) be an internal point, and let \(r\) be a passant
through it.  No tangent passes through \(L\).  Each other pencil line is a
secant or a passant and contains internal points other than \(L\) when
\(q\ge5\).  Choose one such internal point on each of the \(q\) lines other
than \(r\).  Adding two further internal points gives a size-\(q+2\) set
meeting every line of the punctured pencil, with either (for \(q\ge7\))

- two fibres of size two; or
- one fibre of size three.

These are exactly the two defect-two profiles.  Hence internality plus the
near-transversal condition cannot itself yield a contradiction.  Any valid
classification must use star realizability; omitting it enlarges the class
to an elementary family.

## 3. Exact collision budget on the arrangement line

For any \(L\in r_0\), define
\[
 \rho(L)=
 \sum_{g\ni L,\ g\ne r_0}\binom{|g\cap S_0|}{2}.            \tag{3}
\]
Every unordered pair of nodes in \(S_0\) determines a unique line meeting
\(r_0\), so
\[
 \sum_{L\in r_0}\rho(L)=\binom{55}{2}=1485.                \tag{4}
\]

If \(L\) is one of the 16 direction-complete internal centers, its fibre
profile is either \((3,1^{52})\) or \((2,2,1^{51})\).  Therefore
\[
 \rho(L)=3\quad\text{or}\quad2,                             \tag{5}
\]
and these centers contribute between 32 and 48 to (4).

At the arrangement point \(N_{0i}\), the line \(r_i\) contains the ten
nodes \(N_{ij}\) with \(j\ne0,i\).  Consequently
\[
 \rho(N_{0i})\ge\binom{10}{2}=45,                           \tag{6}
\]
so the eleven arrangement points contribute at least 495.

Equations (4)--(6) are consistent: the 27 external points of the passant
\(r_0\) can absorb the remaining pair mass.  There is no parity conflict.
Moreover, after removing the forced pairs in (6), the contribution at a
spare internal center counts joins of opposite star nodes.  In the primal
plane these are exactly the four-subset diagonal indicators \(D_2(P_0)\).
Thus the apparent new budget is the same masked diagonal statistic already
identified by
\[
 32=D_2(P_0)-D_3(P_0).                                     \tag{7}
\]
It should not be pursued as a separate moment argument.

## 4. Adjacent direction theorems do not supply the star bound

For a prime field, Ghidelli's rich/poor direction theorem applies to an
arbitrary set \(U\subset\mathbf F_p^2\) of size \(np-r\).  At
\(|U|=p+2\), one has \(n=2\) and \(r=p-2\), so the general lower bound gives
only two special directions.  In this parameter range, a direction is poor
when it has an empty fibre and rich when it has a fibre of size at least
three.  Hence a direction-complete two-double profile is not special at all,
while a triple profile is special.  The theorem neither bounds the number of
direction-complete centers nor sees the common-line factorization of \(S_0\).

The later equidistribution results on special directions assume cardinality
divisible by \(p\); \(p+2\) lies outside that regime.  The available generic
Rédei theory is therefore adjacent vocabulary, not the missing theorem.

References checked at statement depth:

- L. Ghidelli, *On rich and poor directions determined by a subset of a
  finite plane*, Discrete Mathematics 343 (2020), arXiv:1903.03881,
  Theorem 1.3 and Definition 1.2;
- G. Kiss and G. Somlai, *Special directions on the finite affine plane*,
  Designs, Codes and Cryptography 92 (2024), 2587--2602, §1--3.

## 5. Sharpened theorem target

The nonsaturated defect-two problem is now the following finite-geometric
statement.

> **Star-center gate.**  Let \(r_0,\ldots,r_{11}\) be passants in
> \(\mathrm{PG}(2,53)\), no three concurrent, with every pairwise
> intersection internal.  Put
> \(S_0=\{r_i\cap r_j:1\le i<j\le11\}\).  Then at least one of the 16
> internal points of \(r_0\setminus\{r_0\cap r_i:1\le i\le11\}\) lies on a
> line other than \(r_0\) disjoint from \(S_0\).

The same statement for every defect-two solution of
\(q=\binom n2-2\), with \(m-n\) required centers on the distinguished
arrangement line, would close defect two uniformly.

This is equivalent to the original covering failure at this boundary, but
it isolates a classical-looking direction problem for a star configuration.
A useful next theorem must exploit the common 11-line realization of all 55
nodes.  A theorem for arbitrary size-\(q+2\) internal point sets cannot work,
as §2 shows.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| What is the dual defect-two object at \(q=53\)? | settled | 55 internal nodes of an 11-passant star |
| How many centers must be direction-complete? | settled | all 16 internal nonnodes on the twelfth passant |
| Are arbitrary all-internal near-transversals classifiable away? | no; target rejected | elementary constructions realize both local shapes |
| Does the elementary pair budget contradict the required centers? | no | equations (4)--(6) leave ample mass |
| Is that budget a new invariant? | no | its spare-center part is the closed \(D_2-D_3\) allocation |
| What is the live theorem? | open | bound direction-complete centers for internal star configurations |

## Next action

Search for a star-specific Rédei or direction theorem controlling the number
of direction-complete centers on an arrangement line.  The first acceptable
lemma must use the common-line factorization of the 55 nodes.  Stop if the
argument applies to arbitrary \(q+2\)-point sets or reduces only to
\(\sum_L\rho(L)=\binom{q+2}{2}\).
