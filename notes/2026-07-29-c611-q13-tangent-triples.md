# C611 — the \(q=13\) tangent-triple gate

**Lane:** `clebsch`

**Date:** 2026-07-29

## Verdict

Segre tangent triples close the binary distance-ten gate, and the
extra-juice follow-up determines the exact distance:
\[
 \boxed{d(\ker M)=12}
\]
for the \(78\times78\) passant-line/internal-point incidence matrix over
\(\mathbf F_2\).

The proof is not another search through eight-point supports.  After one
internal point is fixed, Segre's identity turns the seven remaining support
points into a clique in a \(42\)-vertex tangent-compatibility graph.  A
cyclic order-\(14\) stabilizer reduces that graph to six difference sets in
\(\mathbf Z/14\).  Every four-clique has a unique common neighbor, and the
resulting fourteen five-cliques have no further extension.  Thus the local
clique number is five, whereas a weight-eight word would require a
seven-clique.

The tangent argument excludes weight eight.  A forced passant-pencil
meet-in-the-middle argument then excludes weight ten, and an explicit
dihedral twelve-point orbit supplies a weight-twelve word.

This is a conceptual reduction followed by a five-row finite-field lemma,
not a uniform all-\(q\) theorem.  It removes the binary-code mystery at
\(q=13\), but it does not prove the stronger maximum-six assertion for
arbitrary passant-join arcs and does not touch the unsaturated
\((k,q)=(7,13)\) case.

## The tangent reduction

Use
\[
 \mathcal C:XZ-Y^2=0
\]
in \(\operatorname{PG}(2,13)\).  For an internal point \(P\), let
\[
 T_P(X)=\prod_{\substack{\ell\ni P\\
                         \ell\text{ secant to }\mathcal C}}\ell(X).
\]
There are seven factors.  If \(P,Q\) have passant join, then neither
\(T_P(Q)\) nor \(T_Q(P)\) vanishes.  For a pairwise-passant triple define
the scaling-independent holonomy
\[
 h(P,Q,R)=
 \frac{T_P(Q)T_Q(R)T_R(P)}
      {T_P(R)T_R(Q)T_Q(P)}.
\]

Suppose that \(\ker M\) has a word of weight eight, with support \(A\).
C690's endpoint converse shows that \(A\) is an eight-arc, every join of
two support points is passant, and the passant pencil at every vertex is
saturated.  C662 then identifies the seven tangent lines of \(A\) at \(P\)
with the seven conic-secants through \(P\).  Segre's lemma of tangents has
\(t=7\), hence sign
\((-1)^{t+1}=1\), and gives
\[
 h(P,Q,R)=1
\]
for every three distinct points of \(A\).

Fix \(P\in A\).  Define \(H_P\) on the \(42\) internal points whose join
with \(P\) is passant, joining \(Q\) and \(R\) when \(QR\) is passant and
\(h(P,Q,R)=1\).  Then \(A\setminus\{P\}\) would be a seven-clique in
\(H_P\).

## The cyclic local lemma

The conic stabilizer is transitive on internal points, so take
\[
 P=(1:0:2).
\]
On the symmetric-square model, the projective matrix
\[
 g=\begin{pmatrix}1&3\\7&1\end{pmatrix}
\]
fixes \(P\) and has order \(14\).  Its action splits the \(42\) vertices
of \(H_P\) into three cyclic orbits \(A_i,B_i,C_i\), indexed modulo \(14\),
with seeds
\[
 A_0=(1:1:7),\quad B_0=(1:1:6),\quad C_0=(1:2:10).
\]
Their degrees are \(10,12,12\).  Direct substitution in the product
defining \(h\) gives the complete adjacency rule:
\[
\begin{array}{c|c}
\text{orbit pair}&j-i\pmod {14}\\ \hline
AA&4,6,8,10\\
AB&6,7,11,12\\
AC&1,3\\
BB&6,8\\
BC&3,5,6,8,9,11\\
CC&2,4,10,12.
\end{array}
\]

The following five rows, together with simultaneous translation of all
indices, are every four-clique.  The last column is its unique common
neighbor.
\[
\begin{array}{c|c}
\text{four-clique}&\text{unique extension}\\ \hline
A_0,B_6,B_{12},C_1&C_3\\
A_0,B_6,B_{12},C_3&C_1\\
A_0,B_6,C_1,C_3&B_{12}\\
A_0,B_{12},C_1,C_3&B_6\\
B_0,B_6,C_9,C_{11}&A_8.
\end{array}
\]
This table is an elementary check against the six displayed difference
sets.  It accounts for all
\[
14+14+14+14+14=70
\]
four-cliques.  They close to fourteen translates of the single
five-clique
\[
 \{A_0,B_6,B_{12},C_1,C_3\},
\]
and each has no additional common neighbor.  Hence
\[
 \omega(H_P)=5.
\]
In particular \(H_P\) has no seven-clique, contradicting the consequence
of a weight-eight word.

All words in \(\ker M\) have even weight, and C662's Tanner argument
excludes nonzero weights below eight.  Excluding weight eight therefore
proves \(d(\ker M)\ge10\).

## Exact distance

The remaining \(10\) versus \(12\) question has a small exhaustive shape.
By transitivity, a hypothetical weight-ten support may be assumed to
contain \(P=(1:0:2)\).  Each of the seven passants through \(P\) must
contain an odd number of the other nine support points.  Consequently
there are exactly two profiles:

1. three points on one passant and one on each of the other six; or
2. one point on each passant and two further points whose joins with \(P\)
   are secant.

The seven passant fibres each have six available internal points, while
there are \(35\) secant-join neighbors.  Splitting the parity syndromes
into two halves checks respectively
\[
 7\binom63 6^6=6{,}531{,}840
 \quad\text{and}\quad
 6^7\binom{35}{2}=166{,}561{,}920
\]
supports without iterating through the \(2^{36}\) codewords.  Neither
profile has zero syndrome.

The following twelve internal points do have zero syndrome:
\[
\begin{gathered}
(1:0:2),(1:3:2),(1:4:5),(1:1:8),\\
(1:4:8),(1:1:7),(1:7:12),(1:3:3),\\
(1:9:11),(1:10:11),(1:0:5),(1:8:7).
\end{gathered}
\]
Every passant meets this set in zero or two points.  Its projective
stabilizer has order \(24\) and is dihedral: the matrices
\[
 r=\begin{pmatrix}0&1\\6&4\end{pmatrix},\qquad
 s=\begin{pmatrix}0&1\\7&0\end{pmatrix}
\]
satisfy \(r^{12}=s^2=1\) and \(srs=r^{-1}\), and the support is the
twelve-point orbit of \(r\).  In cyclic order, its four secant-join
differences are
\[
 \{\pm4,\pm5\}\pmod {12};
\]
the other seven differences are passant.  Thus the witness itself has a
compact structural construction rather than being an unlabelled list.

Together with parity, the Tanner lower bound, and the tangent exclusion of
weight eight, this proves \(d(\ker M)=12\).

## Evidence and trust boundary

From the repository root:

```text
python3 notes/2026-07-29-c611-q13-tangent-triples.py --check
python3 notes/2026-07-29-c611-q13-tangent-triples-replay.py
```

The primary checker constructs all projective points and lines over
\(\mathbf F_{13}\), classifies points and lines by the conic discriminant,
forms the seven-factor tangent products, derives the cyclic orbits and all
six difference sets, and verifies the four-clique closure table.  It finds
\(238\) local edges, \(70\) four-cliques, \(14\) five-cliques, and clique
number five.  Across all pairwise-passant triples of internal points the
holonomy counts are \(6188\) with value \(1\) and \(5642\) with value
\(-1\).

The independent replay starts from the six displayed difference sets for
the tangent graph and independently reconstructs the projective incidence
matrix for the distance calculation.
It reconstructs the \(42\)-vertex graph by separate code, verifies the
four-clique profiles
\[
 (0,2,2)^{14},\quad(1,1,2)^{28},\quad(1,2,1)^{28},
\]
checks unique closure, independently excludes both forced weight-ten
profiles, verifies the dihedral weight-twelve witness, and obtains
\(\omega=5\) and \(d=12\).
The pre-existing C605 C++/Python bundle is an independent end-to-end
cross-check: its larger domain finds no seven-point passant-join arc over
\(\mathbf F_{13}\).

The mathematical trust boundary is exact prime-field arithmetic, the
coordinate realization of the conic stabilizer, the displayed
finite-difference lemma, the exhaustive two-profile weight-ten split,
C662's saturation/tangent reconstruction, and Segre's lemma of tangents.
The result determines the \(q=13\) incidence-code distance exactly, but
does not supply a uniform conic-code distance theorem.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c611-q13-tangent-triples.py` | 16,839 | `f064e020dada882f6328427275bdbcff6cea753157b824099745ac3229911860` |
| `2026-07-29-c611-q13-tangent-triples-replay.py` | 4,777 | `e72693778890a9d3a9881cf7de4058fa5af1a62091aa0ad382f9cdeb3dceadd0` |
| `2026-07-29-c611-q13-tangent-triples.json` | 5,258 | `299319802a3c497dc7274934be2ddb0da85c613e35b6657b4b57ea5055af38b7` |

## Disposition

| surface | disposition |
|---|---|
| Paper I v1 | closed; no change and no release delay |
| Paper I human core v2 | candidate one-field proposition only if the five-row cyclic lemma fits the eventual v2 narrative |
| computational companion v2 | natural immediate owner for the exact \(d=12\) theorem; it replaces the \(q=13,k=8\) support exclusion, but not the stronger maximum-six claim or \((7,13)\) |
| Papers II and III | no logical ownership |
| C611 | \(q=13\) binary gate closed; \(q=17,19\) coherent/rational mechanisms remain |

No novelty or priority claim is made.  A literature audit is required
before manuscript prose calls this tangent-code argument new.

## Extra-juice and Tao closeout

The `ej` pass strengthened the raw clique bound to the unique-closure
statement: every local four-clique lies in exactly one of fourteen
five-cliques.  That removes general clique search from the proof and leaves
only six cyclic difference sets and five representatives.  It also
separates exactly what was earned: the tangent argument closes the
saturated \(k=8\) binary gate but cannot inherit C605's stronger
maximum-six statement for unsaturated arcs.

The explicit follow-up `ej` pass used the seven passant fibres through one
support point.  It found that weight ten has only two possible pencil
profiles, both admitting small syndrome meet-in-the-middle exhaustion.
Their failure, together with the dihedral twelve-point witness, upgrades
the result from \(d\ge10\) to the exact value \(d=12\).  The witness adds a
second structural surprise: its full projective stabilizer is \(D_{24}\),
and its secant relation is the cyclic difference set
\(\{\pm4,\pm5\}\).

The `tt` pass asked whether the cyclic table concealed a uniform theorem.
The answer is not yet justified.  The order-\(14\) torus and unique closure
are structural, but the six difference sets still use \(q=13\) arithmetic.
Promoting this to an all-\(q\) distance theorem would overstate the
evidence.  The highest-value next move is instead to test whether the
\(q=17,19\) local triple/coherent configurations admit equally small
rational dual certificates.

## Mystery ledger

| feature | status | exact remaining gate |
|---|---|---|
| weight-eight nullword at \(q=13\) | settled negatively | none |
| local clique number five | settled with unique closure | six difference sets and five representatives are the exact proof boundary |
| actual code distance | settled exactly | \(d(\ker M)=12\); both weight-ten profiles fail and a dihedral weight-twelve word exists |
| classification of minimum words | open beyond the task-owned witness | determine whether every weight-twelve word lies in the projective orbit of the \(D_{24}\) support |
| uniform source of unique closure | unexplained | derive the local graph from a general torus/two-graph identity rather than \(q=13\) substitution |
| \((7,13)\) unsaturated terminal case | untouched | its tangent polynomial has one additional factor at each vertex |
| \(q=17,19\) terminal exclusions | untouched by this certificate | C611 coherent-configuration or rational-dual step |

Vibe check: the pass overdelivered—the gate is closed and the exact code
distance is now known with a structured minimum word.  The limitation is
still honest: this is a sharp one-field theorem, not yet the uniform
exterior-set explanation C611 ultimately wants.
