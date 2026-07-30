# C611 — the \(q=13\) tangent-triple gate

**Lane:** `clebsch`

**Date:** 2026-07-29

## Verdict

Segre tangent triples close the binary distance-ten gate:
\[
 d(\ker M)\ge 10
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

The independent replay starts only from the six displayed difference sets.
It reconstructs the \(42\)-vertex graph by separate code, verifies the
four-clique profiles
\[
 (0,2,2)^{14},\quad(1,1,2)^{28},\quad(1,2,1)^{28},
\]
checks unique closure, and independently obtains \(\omega=5\).
The pre-existing C605 C++/Python bundle is an independent end-to-end
cross-check: its larger domain finds no seven-point passant-join arc over
\(\mathbf F_{13}\).

The mathematical trust boundary is exact prime-field arithmetic, the
coordinate realization of the conic stabilizer, the displayed
finite-difference lemma, C662's saturation/tangent reconstruction, and
Segre's lemma of tangents.  The result proves the \(q=13\) incidence-code
lower bound only; it neither determines whether the actual distance is
\(10\) or \(12\), nor supplies a uniform conic-code distance theorem.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c611-q13-tangent-triples.py` | 10,754 | `5fe0747428a64605e4b561fa5f8f3ddc71306ba0945849446718d68083340cb5` |
| `2026-07-29-c611-q13-tangent-triples-replay.py` | 1,946 | `a1ec0046ebbc533adf2f8364999f95ce6129a8c7dab4f82438485a06ad831ac2` |
| `2026-07-29-c611-q13-tangent-triples.json` | 3,246 | `d0584d722502a660119e91ab8d2a6e32691e960ef3be56c58015f7e02bf7c708` |

## Disposition

| surface | disposition |
|---|---|
| Paper I v1 | closed; no change and no release delay |
| Paper I human core v2 | candidate one-field proposition only if the five-row cyclic lemma fits the eventual v2 narrative |
| computational companion v2 | natural immediate owner; it replaces the \(q=13,k=8\) support exclusion, but not the stronger maximum-six claim or \((7,13)\) |
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
| weight-eight nullword at \(q=13\) | settled negatively | none; \(d(\ker M)\ge10\) |
| local clique number five | settled with unique closure | six difference sets and five representatives are the exact proof boundary |
| actual code distance \(10\) versus \(12\) | not needed and not settled | construct a weight-ten word or prove its absence |
| uniform source of unique closure | unexplained | derive the local graph from a general torus/two-graph identity rather than \(q=13\) substitution |
| \((7,13)\) unsaturated terminal case | untouched | its tangent polynomial has one additional factor at each vertex |
| \(q=17,19\) terminal exclusions | untouched by this certificate | C611 coherent-configuration or rational-dual step |

Vibe check: this is a real proof compression and closes the exact binary
gate, but it is honestly a sharp one-field tangent theorem rather than the
uniform exterior-set explanation C611 ultimately wants.
