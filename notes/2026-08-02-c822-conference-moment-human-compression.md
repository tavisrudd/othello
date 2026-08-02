# C822 — A two-count proof of the order-26 conference separator

**Lane:** `clebsch`  
**Date:** 2026-08-02  
**Verdict:** complete; the eight-coordinate profile is forced by its
five- and six-vertex entries, and the four construction classes reduce to
intercalate and Pasch counts

## The theorem

Let \(C=(c_{ij})\) be a symmetric conference sign matrix of order \(26\):
\(c_{ii}=0\), \(c_{ij}\in\{\pm1\}\), and \(C^2=25I\).  A four-set is
*aligned* when its four triangle products
\(c_{ij}c_{jk}c_{ki}\) agree.  These sets form a
\(3\text{-}(26,4,5)\) design \(\mathcal B\).

For three distinct aligned blocks, let \(x_s\) count the unordered triples
whose union has size \(s\).  Then the entire triple-union profile is
determined by the two local counts \(x_5,x_6\):

\[
\begin{array}{c|rrrrrrrr}
s&5&6&7&8&9&10&11&12\\ \hline
x_s&x_5&x_6&
26864500-20x_5-6x_6&
219189750+65x_5+15x_6&
1027130000-95x_5-20x_6&
2034201000+74x_5+15x_6&
1835593500-30x_5-6x_6&
573095250+5x_5+x_6.
\end{array}
\]

Consequently the third centred thirteen-cut moment is
\[
 \mu_3=-\frac{41624887590}{27509587}
       +\frac{1287}{74290}x_5
       +\frac{2574}{1300075}x_6.                 \tag{1}
\]
Thus C812's empirical affine plane is forced by the conference equation; it
is not an affine coincidence among four points.

The pivots have a direct local name.  A *coherent pentad* is a five-set all
five of whose four-subsets are aligned; if \(h_5\) counts coherent pentads,
then \(x_5=10h_5\).  A *spanning aligned hexad* is a six-set together with
three aligned four-subsets whose union is the whole six-set; their number is
exactly \(x_6\).  These are the only two irreducible local configurations in
the contraction below.  The pentad identity uses only the two-graph parity
law: a five-set contains \(0,1,2\), or \(5\) aligned four-subsets, so three
of them occur precisely in the coherent case and then contribute
\(\binom53=10\) triples.

For the two Latin-square constructions let \(I\) be the number of
intercalates of the order-five Latin square.  For the two Steiner
constructions let \(P\) be the number of Pasch configurations of the
\(S(2,3,13)\).  Direct local counting gives
\[
\begin{array}{c|cc}
&x_5&x_6\\ \hline
TD(3,5)&7800-40I&705250-896I\\
S(2,3,13)&8840+40P&686322-504P.
\end{array}                                      \tag{2}
\]
The two Latin classes have \(I=4,0\), and the two Steiner classes have
\(P=8,13\).  Their \((x_5,x_6)\) pairs and moments are therefore
\[
\begin{array}{c|c|c|c}
\text{class}&\text{primitive count}&(x_5,x_6)&\mu_3\\ \hline
\text{non-group Latin}&I=4&(7640,701666)&5824547586/687739675\\
\text{cyclic Latin}&I=0&(7800,705250)&504439650/27509587\\
\text{noncyclic Steiner}&P=8&(9160,682290)&-489762702/137547935\\
\text{cyclic Steiner}&P=13&(9360,679770)&-699456186/137547935.
\end{array}
\]
They are pairwise distinct.  The imported four-class classification and
these four construction-level counts therefore prove separation.

Within each construction family even the two-count answer collapses to its
single exceptional incidence flag:
\[
\begin{aligned}
 \mu_3(TD(3,5))
   &=\frac{504439650}{27509587}-\frac{458172}{185725}I,\\
 \mu_3(S(2,3,13))
   &=-\frac{771265638}{687739675}-\frac{56628}{185725}P.
\end{aligned}                                    \tag{2a}
\]
The Latin values are positive and the Steiner values negative; the distinct
primitive counts then separate the two classes inside each family.

## Why only two local counts survive

For a pair of aligned blocks with union \(U\), put \(u=|U|\),
\(c_U=\#\{B\in\mathcal B:B\subseteq U\}\), and let \(N_j(U)\) count blocks
meeting \(U\) in \(j\) points.  The \(3\)-design equations give
\[
\begin{aligned}
N_4&=c_U,\\
N_3&=5\binom u3-4c_U,\\
N_2&=60\binom u2-3N_3-6c_U,\\
N_1&=500u-2N_2-3N_3-4c_U,\\
N_0&=3250-N_1-N_2-N_3-N_4.
\end{aligned}                                    \tag{3}
\]
Let
\[
 S_u=\sum_{\{B_1,B_2\}:|B_1\cup B_2|=u}c_{B_1\cup B_2}
 \qquad(5\le u\le8).
\]
Substitution in (3) shows that the variable contribution of \(S_u\) to
\(3x_s\), for \(s=u,\ldots,u+4\), has coefficients
\[
             1,-4,6,-4,1.                        \tag{4}
\]
The pair-union profile itself is fixed:
\[
 (p_5,p_6,p_7,p_8)=(26000,497250,2171000,2585375).
\]

It remains to remove two of the four \(S_u\).  This is exactly where the
conference equation enters.  On a four-set \(a,b,c,d\), the aligned-block
indicator is
\[
 A_{abcd}=\frac14(1+m_1+m_2+m_3),                 \tag{5}
\]
where \(m_1,m_2,m_3\) are the products of \(c_{ij}\) around the three
Hamilton four-cycles.  Their product is one, so (5) is one precisely when
all three are one.

Expand \(c_U=\sum_{Q\in\binom U4}A_Q\) in the four \(S_u\)'s.  Every
nonconstant term is an even signed graph.  An exposed bivalent vertex \(z\)
is eliminated by the off-diagonal conference identity
\[
 \sum_{z\ne i,j}c_{iz}c_{zj}=0,                  \tag{6}
\]
and a doubled edge by \(c_{ij}^2=1\).  Repeating this contraction leaves the
following two-row ledger; no signed core remains:
\[
\begin{array}{c|rrrr|r}
&S_5&S_6&S_7&S_8&\text{constant}\\ \hline
\text{first contraction}&2&2&1&0&22717500\\
\text{second contraction}&-1&-1&0&1&38837500.
\end{array}                                      \tag{7}
\]
In other words,
\[
 S_7=22717500-2S_5-2S_6,
 \qquad
 S_8=38837500+S_5+S_6.                           \tag{8}
\]
This contraction is the short structural step: (5) makes every monomial
Eulerian, and (6) removes every vertex outside the five- and six-vertex
cores.  Combining (3), (4), the fixed pair profile, and (8) gives the
displayed affine profile row.  Finally, with
\[
 \pi_s=\frac{\binom{26-s}{13-s}}{\binom{26}{13}},
\]
the standard factorial-moment conversion
\[
 E[(c_T)_3]=6\sum_s x_s\pi_s,
 \qquad
 E[(c_T)_2]=2\sum_s q_s\pi_s
\]
(where \(q_s\) is the fixed pair-union profile) gives (1).

## The four construction counts

The remaining work is local incidence counting, not a census of the fifteen
strongly regular descendants.

### Latin-square classes

Use the graph on the \(25\) cells of a \(TD(3,5)\), joining two cells when
they agree in row, column, or symbol, and adjoin an isolated vertex.  A
five-set contains \(0,1,2\), or \(5\) aligned four-sets.  Partitioning by
whether it contains the isolated vertex gives the complete flag ledger
below; \(I\) is the number of intercalates:
\[
\begin{array}{c|rrrr}
&0&1&2&5\\ \hline
\text{without root}&12600+36I&25200-90I&14700+60I&630-6I\\
\text{with root}&3000-12I&6000+30I&3500-20I&150+2I.
\end{array}                                      \tag{9}
\]
For six-sets, count triples of contained aligned four-sets that span the
six-set.  The same row/column/symbol collision partition gives
\[
 \begin{array}{c|cc}
 &\text{without root}&\text{with root}\\ \hline
 \text{spanning triples}&542500-476I&162750-420I.
 \end{array}                                     \tag{10}
\]
Equations (9)--(10) give the Latin row of (2).  The count is short because
every collision diagram is forced by the Latin property except the \(2\times
2\) diagram; the latter contributes exactly when it is an intercalate.

Representatives are
\[
\begin{pmatrix}
0&1&2&3&4\\1&0&3&4&2\\2&3&4&0&1\\3&4&1&2&0\\4&2&0&1&3
\end{pmatrix},
\qquad L(r,c)=r+c\pmod5.
\]
The first has exactly the four intercalates
\[
((0,1),(0,1)),\ ((1,2),(0,4)),\ ((1,3),(0,2)),\ ((1,4),(0,3)),
\]
where a pair records (rows, columns).  The cyclic square has none: the two
cross-equalities would imply \(2(c-d)=0\) modulo \(5\).

### Steiner classes

Use the intersection graph on the \(26\) blocks of an \(S(2,3,13)\).  A
selected five-set of graph vertices contains \(0,1,2\), or \(5\) aligned
four-sets.  Exposing intersections of the corresponding Steiner triples
gives
\[
\begin{array}{c|rrrr}
\text{aligned four-sets}&0&1&2&5\\ \hline
\text{five-sets}&14976-24P&32760+60P&17160-40P&884+4P.
\end{array}                                      \tag{11}
\]
The analogous six-set flag count gives
\[
 \#\{\text{spanning aligned triples on six vertices}\}=686322-504P.
                                                        \tag{12}
\]
Here linearity of the Steiner system forces every intersection diagram
except four blocks on six points with every point repeated twice, exactly a
Pasch configuration.  Thus (11)--(12) are incidence double counts with one
exceptional flag, not induced-subgraph enumeration.  They give the Steiner
row of (2).

For the cyclic representative, translate the base blocks
\(
\{0,1,4\},\{0,2,7\}
\)
modulo \(13\).  Its thirteen Pasches are one translation orbit, represented
by
\[
 \{014,027,179,249\}.
\]
For the second representative, the generator source lists all twenty-six
blocks and checks its eight Pasches directly.  Since the Pasch counts differ,
the two systems are nonisomorphic; the imported classification
that there are exactly two \(S(2,3,13)\)'s makes them complete
representatives.

## Reproducible four-representative check

The generator contains exactly the two Latin squares and two Steiner systems
above.  It independently checks the Latin/Steiner axioms, \(C^2=25I\), the
\(3\text{-}(26,4,5)\) design, the universal pair profile, the local five- and
six-set counts, (2), the affine conversion, and the four moments.  It does
not prove the contraction lemma (7); that is the human signed-graph argument
above.  The replay reads only the compact JSON certificate and independently
recomputes (1)--(2).

Replay from the repository root:

```sh
python3 notes/2026-08-02-c822-conference-moment-human-compression.py \
  --output /tmp/c822-conference-moment-human-compression.json
cmp /tmp/c822-conference-moment-human-compression.json \
  notes/2026-08-02-c822-conference-moment-human-compression.json
python3 notes/2026-08-02-c822-conference-moment-human-compression-replay.py
sha256sum -c notes/2026-08-02-c822-conference-moment-human-compression.sha256
```

The compact certificate contains four construction representatives, compared
with C812's fifteen-descendant certificate.  The evidence ledger is:

| artifact | bytes | SHA-256 |
|---|---:|---|
| generator | 10,058 | `d136a627307a9ae4595184b91481975aa29d0548b4175c26e788ae5dc3da99fe` |
| arithmetic replay | 2,688 | `413102f7ceb95876089e5420af4097e2c4c916099f75b7b4e8f39fd6188d866d` |
| four-representative JSON | 3,203 | `ab5beb13335a28b12d0216949944014eb4bbfda20831e4e73dc453c37d815e31` |

## Imported and proved boundaries

- **Imported classification:** Bussemaker--Mathon--Seidel, *Tables of
  two-graphs*, DOI `10.1007/BFb0092256`, Chapter 5 and Table 7, gives exactly
  four order-26 conference two-graphs, two from order-five Latin squares and
  two from Steiner triple systems of order thirteen.  The cached published
  PDF has SHA-256
  `ac9d300a4a0e5f46d4d4b36b66d5f620f616ffad3197ae93fad50b8ff224748a`.
- **Human derivation:** equations (3)--(8), the two-pivot profile, moment
  conversion (1), and the collision/Steiner flag reductions (9)--(12).
- **Finite orbit accounting:** four intercalates for the displayed
  non-group Latin square, one size-thirteen translation orbit of cyclic
  Pasches, and a direct eight-Pasch check for the noncyclic system.
- **Machine verification:** construction axioms, conference/design checks,
  all local ledger totals, and exact rational arithmetic for the four
  representatives.

No manuscript or public package is changed, and no novelty or all-order
claim is made.

## Mystery ledger

- **Settled — affine rank two.**  Conference contraction, rather than the
  four observed data points, forces the two-dimensional profile plane.
- **Settled — construction parameters.**  Intercalates and Pasches are the
  sole exceptional local flags in the two construction families.
- **Settled — why the scalar separates.**  Formula (1) is nonconstant in
  both pivots, and the four primitive counts land at distinct values.
- **Settled in the closeout pass — one-flag family formulas.**  Equation
  (2a) shows that no second unexplained construction statistic is hiding in
  either family.
- **Open only outside C822 — all-order behavior.**  Nothing here says that
  the same two cores control conference designs at other orders or that this
  moment is a complete invariant there.  Such a statement would require a
  separately allocated task and its own classification boundary.

No genuine mystery remains inside the order-26 human-compression objective.
