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

The full minimum layer is also classified.  There are exactly \(364\)
weight-twelve words in four projective orbits.  Their support-incidence
numbers recover the full six-class elliptic association scheme.  Pair and
triple concurrence then recover all \(78\) passant-line incidence rows, so
the minimum-weight layer reconstructs the parity-check matrix \(M\) up to
row order.

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

### All minimum words

The same pencil split classifies every weight-twelve word.  For a support
through \(P\), let \(s\) be the number of its other points whose join with
\(P\) is secant.  The seven passant fibres must have positive odd
occupancies, so the only profiles are
\[
\begin{array}{c|c}
s&\text{passant-fibre occupancies}\\ \hline
0&5+1+1+1+1+1+1\ \text{or}\ 3+3+1+1+1+1+1\\
2&3+1+1+1+1+1+1\\
4&1+1+1+1+1+1+1.
\end{array}
\]
Exact syndrome matching finds no word in the first three rows and exactly
\(56\) words in the last row.  Thus every minimum word through \(P\) has
four secant-join neighbors and one point in each passant fibre.

Double counting point--word incidences gives
\[
 \frac{78\cdot56}{12}=364
\]
minimum words globally.  The full \(\operatorname{PGL}(2,13)\) action
splits them into four orbits of size \(91\):
\[
\begin{array}{c|c|c|c}
\text{stabilizer/action}&\text{orbit size}&
\text{normalized cyclic secant differences}&
\text{secant triangles}\\ \hline
S_4/C_2\text{ (transposition)}&91&--&4\\
D_{24}&91&\{2,3,9,10\}&0\\
D_{24}&91&\{1,4,8,11\}&4\\
D_{24}&91&\{1,3,9,11\}&0.
\end{array}
\]
The displayed witness belongs to the middle dihedral row.

This minimum layer remembers more than the distance.  Every coordinate
lies in \(56\) minimum supports.  For a pair of coordinates, let
\(\lambda(P,Q)\) be the number of minimum supports containing it.  The
complete concurrence spectrum is
\[
\begin{array}{c|rrrrr}
\lambda&6&7&8&9&12\\ \hline
\#\{P,Q\}&1092&546&273&546&546.
\end{array}
\]
Most importantly,
\[
 PQ\text{ is passant}
 \quad\Longleftrightarrow\quad
 \lambda(P,Q)\in\{7,9,12\},
\]
while secant pairs have concurrence \(6\) or \(8\).  Hence the family of
minimum-weight supports intrinsically reconstructs the passant graph, and
therefore recovers the exact geometric relation used to define the parity
checks.

Triple concurrence supplies the missing bit.  For a pair \(\{P,Q\}\), let
\[
 h_{P,Q}(j)=
 \#\{R\ne P,Q:\text{ exactly }j\text{ minimum supports contain }P,Q,R\}.
\]
The six pair classes have the following distinct fingerprints.  The
coordinate invariant
\[
\rho(P,Q)=
 \frac{\langle P,Q\rangle^2}{Q(P)Q(Q)}
\]
where \(\langle-,-\rangle\) is the polar form of \(Y^2-XZ\), is included
only to identify the reconstructed classes with the standard
elliptic-scheme labels:
\[
\begin{array}{c|c|c|l}
\rho&\#\text{ pairs}&\lambda(P,Q)&
\{j:h_{P,Q}(j)\}\\ \hline
0&273&8&0:16,\ 1:40,\ 2:20\\
1&546&6&0:26,\ 1:42,\ 2:6,\ 3:2\\
3&546&6&0:32,\ 1:28,\ 2:16\\
9&546&12&0:7,\ 1:34,\ 2:27,\ 3:4,\ 5:4\\
10&546&7&0:25,\ 1:36,\ 2:13,\ 4:2\\
12&546&9&0:18,\ 1:32,\ 2:24,\ 5:2.
\end{array}
\]
Thus the minimum-support hypergraph intrinsically partitions all coordinate
pairs into the six \(\operatorname{PGL}(2,13)\)-orbitals.  In particular it
recovers the full Hollmann--Xiang elliptic association scheme, not merely
the passant/secant fusion.

There is a final self-reconstruction step.  In the reconstructed passant
graph there are \(1716\) seven-cliques.  Exactly \(78\) of them have triple
concurrence zero on all of their \(\binom73=35\) triples.  These \(78\)
seven-sets are exactly
\[
 \{\{P:P\in\ell\}:\ell\text{ passant to }\mathcal C\}.
\]
They are therefore the row supports of \(M\).  Starting only from the
coordinate set and the family of minimum codeword supports, one recovers
\[
 \text{minimum hypergraph}
 \longrightarrow
 \text{six-class elliptic scheme}
 \longrightarrow
 \text{passant incidence rows}
 \longrightarrow M
\]
up to coordinate and row permutation.

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
\(-1\).  It also exhausts all weight-twelve pencil profiles, constructs the
four projective orbits, and verifies the complete pair-concurrence ledger.
It then verifies the six distinct triple-concurrence fingerprints and
reconstructs all \(78\) incidence rows from the \(1716\) seven-cliques in
the recovered passant graph.

The independent replay starts from the six displayed difference sets for
the tangent graph and independently reconstructs the projective incidence
matrix for the distance calculation.
It reconstructs the \(42\)-vertex graph by separate code, verifies the
four-clique profiles
\[
 (0,2,2)^{14},\quad(1,1,2)^{28},\quad(1,2,1)^{28},
\]
checks unique closure, independently excludes both forced weight-ten
profiles, independently enumerates the \(56\) minimum words through the
base, verifies that four explicit projective orbits partition them, and
replays the full six-class scheme and parity-check-row reconstruction from
all \(364\) words.  It obtains \(\omega=5\), \(d=12\), and the original
\(78\) row supports.
The pre-existing C605 C++/Python bundle is an independent end-to-end
cross-check: its larger domain finds no seven-point passant-join arc over
\(\mathbf F_{13}\).

The mathematical trust boundary is exact prime-field arithmetic, the
coordinate realization of the conic stabilizer, the displayed
finite-difference lemma, the exhaustive two-profile weight-ten split,
C662's saturation/tangent reconstruction, Segre's lemma of tangents, the
four-orbit minimum-word exhaustion, and the exact seven-clique selector.
The result determines the \(q=13\) incidence-code distance exactly, but
does not supply a uniform conic-code distance theorem.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c611-q13-tangent-triples.py` | 31,859 | `031a65abce1ab59fd3a4c0851937ae873c09c36b67d2975faa2f72b0a2a4e050` |
| `2026-07-29-c611-q13-tangent-triples-replay.py` | 14,490 | `2a581e528e1a3cd40b7291551188e0882d1a98f1cce8518cc85cc4c96b0f4f8b` |
| `2026-07-29-c611-q13-tangent-triples.json` | 13,577 | `1641cf22244cae216d2b59ef16537353da61f2b6e3361516e5b4201d4256a381` |

## Disposition

| surface | disposition |
|---|---|
| Paper I v1 | closed; no change and no release delay |
| Paper I human core v2 | the intrinsic minimum-layer-to-\(M\) reconstruction is thematically strong, but admission requires a concise presentation with the finite certificate kept in the companion |
| computational companion v2 | immediate owner for exact \(d=12\), four minimum-word orbits, full elliptic-scheme recovery, and parity-check self-reconstruction; these replace the \(q=13,k=8\) support exclusion, but not the stronger maximum-six claim or \((7,13)\) |
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

The `ej2` pass classified the entire minimum layer rather than assuming
the witness orbit was unique.  That assumption fails productively: there
are four orbits, one \(S_4\) and three \(D_{24}\), totaling \(364\)
minimum words.  Their pair-concurrence spectrum then yields a genuinely
intrinsic upgrade: minimum supports alone recover the passant/secant join
type.  The only information loss visible at this level is that two secant
orbitals share concurrence six.

The `ej3` pass resolves that loss.  The histogram of triple concurrence
over a fixed pair has six distinct values, one for each elliptic orbital.
The recovered passant graph still has \(1716\) seven-cliques, but the
minimum hypergraph selects exactly \(78\): those on which every triple has
concurrence zero.  They are precisely the passant-line row supports.
Thus the third-order pass upgrades geometric join recovery to complete
elliptic-scheme and parity-check-matrix self-reconstruction.

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
| classification of minimum words | settled | \(364\) words in four size-\(91\) orbits: one \(S_4\), three \(D_{24}\) |
| geometry from minimum words | settled through the full pair scheme | triple-concurrence histograms separate all six elliptic orbitals |
| parity-check rows from minimum words | settled exactly | among \(1716\) passant seven-cliques, the \(78\) all-zero-triple cliques are precisely the rows of \(M\) |
| conceptual proof of the 78-clique selector | computationally exact, structurally unexplained | replace the seven-clique enumeration by a uniform intersection-number argument |
| uniform source of unique closure | unexplained | derive the local graph from a general torus/two-graph identity rather than \(q=13\) substitution |
| \((7,13)\) unsaturated terminal case | untouched | its tangent polynomial has one additional factor at each vertex |
| \(q=17,19\) terminal exclusions | untouched by this certificate | C611 coherent-configuration or rational-dual step |

Vibe check: `ej3` lands the strongest result in the chain—the minimum layer
self-reconstructs the full parity-check geometry.  The limitation is still
honest: the 78-row selector is an exact one-field certificate, not yet a
uniform exterior-set explanation.
