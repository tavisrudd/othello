# C690 — Paper I rigidity-upgrade exploration

**Lane**: `clebsch`

**Date**: 2026-07-29

## Verdict

One compact Paper I v2 proposition survives, one terminal-field reduction
sharpens, and two proposed crowns close negatively.

1. The syndrome locus intrinsically reconstructs the **unordered**
   support-orientation torsor. In the frozen common marking, its exchange is
   simultaneously support complementation, six-point Gale duality, and golden
   conjugation. Its signed moments vanish through degree two and first separate
   in degree three, so the intrinsic oriented datum is a cubic line rather than
   a chosen cubic. Independently, the twelve continuation directions recover
   the golden quadratic algebra on their fibre-odd \(3\oplus3'\) module.
2. At \(q=13\), the terminal eight-arc exists exactly when the binary
   passant/internal incidence code has a word of weight eight. The code has
   length \(78\), dimension \(36\), and even weights. Thus the desired
   exclusion is exactly the minimum-distance assertion \(d\ge10\).
   C665's trade and first-wall mechanisms do not apply: they use a
   defining-characteristic transitive matching-sheet module and a
   one-dimensional trade quotient, while this is a cross-characteristic
   \(36\)-dimensional binary support problem with no assumed support
   stabilizer. This reduction belongs to C611.
3. Paper I's twelve continuation directions are not the Schläfli double-six
   as an \(A_5\)-set. Their permutation characters already differ on
   involutions, and their natural five-regular incidence graphs differ by
   twenty versus zero triangles.
4. The first open all-size full-conic case reduces exactly to nine-arcs over
   \(\mathbf F_{23}\) and \(\mathbf F_{25}\). The existing terminal searches
   eliminate \(\mathbf F_{17}\) and \(\mathbf F_{19}\). Exact cover moments
   give a small certificate shape for either remaining falsifier, but do not
   exclude it. No larger classification task is warranted before this gate.

None of these conclusions modifies or holds Paper I v1.

## 1. The terminal \(q=13\) problem

Use the conic
\[
 \mathcal C:\ XZ-Y^2=0
\]
in \(\operatorname{PG}(2,13)\). A point \(P=(x:y:z)\) is internal when
\(y^2-xz\) is a nonsquare. A line
\(\ell=[a:b:c]\) is passant when \(b^2-4ac\) is a nonsquare. Let
\[
 M_{\ell,P}=\mathbf1_{\ell(P)=0}
 \quad\text{over }\mathbf F_2,
\]
with rows indexed by the \(78\) passants and columns by the \(78\) internal
points.

Every row and column of \(M\) has weight seven. Conic polarity identifies
the two index sets and makes \(M\) symmetric. The exact checker gives
\[
 \operatorname{rank}_{\mathbf F_2}M=42,\qquad
 \dim\ker M=36,
\]
agreeing with the published conic-code dimension formula.

The saturation endpoint is sharper than an arc-supported-codeword
reduction.

**Proposition.** A conic-filling eight-arc exists over \(\mathbf F_{13}\)
if and only if \(\ker M\) contains a word of weight eight.

**Proof.** C662 proves the forward implication. Conversely, let \(S\) be
the support of a weight-eight word and fix \(P\in S\). Each of the seven
passants through \(P\) must contain another point of \(S\), because every
row meets \(S\) evenly. The seven remaining support points lie on seven
distinct lines through \(P\), so each passant through \(P\) contains
exactly one of them. Hence every join of two points of \(S\) is passant
and no line contains three support points. Thus \(S\) is an arc and its
passant pencil is saturated at every vertex. C662's converse then makes
it conic-filling. \(\square\)

Summing all row equations gives the all-one functional because every
column has odd weight. Every word in \(\ker M\) therefore has even
weight. C662's Tanner argument excludes nonzero weights below eight, so
the terminal exclusion is precisely
\[
 d(\ker M)\ge10.
\]

### Why C665 stops before this gate

C665's unique-trade and projective-head arguments require a transitive
matching sheet \(H/K\), a permutation module in defining characteristic,
and a one-dimensional common quotient detected by the quadratic trade.
None is present here:

- the incidence equations are over \(\mathbf F_2\), not
  \(\mathbf F_{13}\);
- a hypothetical weight-eight support has no assumed nontrivial stabilizer
  and is not a prescribed \(H/K\)-orbit; and
- the ambient nullspace has dimension \(36\), not one.

The first-wall affine-socle and spill calculations consequently have no
map whose nonsplitting would imply \(d\ge10\). Translating the same binary
matrix into projective-head language would rename the minimum-support
problem rather than exclude its weight-eight words. This is a sharp
negative applicability result, not evidence that a different
Terwilliger, tangent-triple, or support-classification argument cannot
work.

## 2. Intrinsic orientation and Gale reconstruction

Paper I reconstructs the code, its six-coordinate \(A_5\)-action, the five
self-polar matchings, and the unordered bipartition
\[
 \{\mathcal O_+,\mathcal O_-\}
\]
of the twenty three-coordinate leader supports. This already constructs
a two-sheet torsor from decoder ambiguity, without choosing a sign.

C682 supplies the exact missing comparison. In the common six-column
marking, one orbit is the ten supports of opposite icosahedral face pairs
and the other is its complementary orbit. For the golden axis matrix
\(A_t\), its exact Gale kernel satisfies
\[
 A_tK_t^{\mathsf T}=0,\qquad HK_t=-tA_{1-t}.
\]
Golden conjugation \(t\mapsto1-t\) exchanges the face and opposite-face
support classes. Therefore the exchange of the reconstructed torsor is
simultaneously
\[
 \text{support complementation}
 =\text{Gale duality}
 =\text{golden conjugation}
\]
on this marked fibre. Since the degree-six \(A_5\)-set has self-normalizing
\(D_5\) point stabilizer, the equivariant comparison is unique once the
reconstructed coordinate action is fixed.

Choose a temporary sign \(\epsilon=+1\) on one sheet and \(-1\) on the
other, and let \(x_S\in\{0,1\}^6\) be the incidence vector of a support.
The exact support calculation proves
\[
 \sum_{|S|=3}\epsilon(S)x_S^{\otimes d}=0
 \quad(d=0,1,2),\qquad
 \sum_{|S|=3}\epsilon(S)x_S^{\otimes3}\ne0.
\]
Changing the temporary sign negates the last tensor. Hence the syndrome
locus reconstructs an intrinsic cubic **line**, together with its
orientation torsor, but not a preferred cubic generator.

This is the reader-level v2 theorem package earned by C690. It adds an
intrinsic orientation/Gale interpretation to the recovered decoder
structure. It does not assert an ambient characteristic-zero lift of an
arbitrary code, identify Paper II's global factorization cover, or choose
one golden embedding.

## 3. Schläfli double-six kill test

The twelve Paper I continuation directions form the transitive
\(A_5\)-set \(A_5/C_5\). The two rows of C682's Schläfli double-six are
separately equivariant six-sets, so their union is
\[
 (A_5/D_5)\sqcup(A_5/D_5).
\]
On the conjugacy classes
\[
 1A,\ 2A,\ 3A,\ 5A,\ 5B
\]
the two permutation characters are
\[
\begin{array}{c|rrrrr}
 &1A&2A&3A&5A&5B\\ \hline
 A_5/C_5&12&0&0&2&2\\
 2(A_5/D_5)&12&4&0&2&2.
\end{array}
\]
Thus no equivariant bijection exists. The orbit partitions already differ:
\(12\) versus \(6+6\).

The incidence fingerprint makes the negative geometric. Either
five-valent orbital graph on \(A_5/C_5\) is an icosahedral graph with
thirty edges and twenty triangles. The double-six intersection graph is
\(K_{6,6}\) with a perfect matching removed: it also has thirty edges and
valency five, but it is bipartite and has no triangles. The equality of
the coarse counts was therefore a genuine temptation; the character and
triangle fingerprints kill it exactly.

The failed identification nevertheless has a canonical common quotient.
The normalizer inclusion \(C_5\triangleleft D_5\) gives
\[
 A_5/C_5\longrightarrow A_5/D_5.
\]
Its six fibres are the opposite pairs of Paper I continuation directions,
and the nontrivial element of \(D_5/C_5\) exchanges the two points in each
fibre. The Paper I twelve-set is therefore the connected, transitive
two-cover of the six-axis carrier. Each row of the double-six is itself
\(A_5/D_5\), so projection to the common axis label gives
\[
 (A_5/D_5)\sqcup(A_5/D_5)\longrightarrow A_5/D_5,
\]
the split two-cover. The involution-character difference \(0\) versus
\(4\) is exactly the distinction between fibre exchange in the twisted
cover and fibre fixation in the split cover.

Thus the correct relationship is stronger than “different twelve-sets”:
Paper I supplies the nontrivial axis-orientation cover, while the
double-six supplies two globally separated rows over the same six axes.
No choice of marking can turn one cover into the other.

This also separates two orientation structures that could otherwise be
conflated. The twenty leader supports form a split \(A_5\)-cover of the
ten-point Petersen carrier: its two sheets are separately \(A_5\)-stable,
and complementation/Gale conjugation is an external exchange. The twelve
continuation directions form the twisted cover of the six-axis carrier:
\(A_5\) is transitive and the stabilizer involution exchanges the two
directions above an axis. Hence the support-orientation torsor is not
realized by pairing the twelve continuation directions, even though both
are reconstructed from the same syndrome data.

### Golden algebra from the twisted cover

The representation discarded by passage to the six-axis quotient is
exactly the golden pair. Over characteristic zero,
\[
\begin{aligned}
 \mathbf Q[A_5/C_5]&\cong
 \mathbf1\oplus\mathbf3\oplus\mathbf3'\oplus\mathbf5,\\
 \mathbf Q[A_5/D_5]&\cong\mathbf1\oplus\mathbf5.
\end{aligned}
\]
Therefore the fibre-even part of the twelve-point permutation module is
\(\mathbf1\oplus\mathbf5\), while its fibre-odd part is
\[
 W^-=\mathbf3\oplus\mathbf3'.
\]
For the split double-six, both the row-even and row-odd modules are instead
\(\mathbf1\oplus\mathbf5\). This module fingerprint explains the geometric
failure more precisely than the total permutation character.

There is also an intrinsic operator form. Let \(R\) be the antipodal deck
involution on the twelve continuation directions, and let \(A,A'\) be the
adjacency matrices of the two five-valent \(A_5\)-orbitals. The unordered
pair \(\{A,A'\}\) is intrinsic, and exact association-algebra multiplication
gives
\[
 (A-A')^2=10(I-R).
\]
On \(W^-\), where \(R=-I\), the operator
\[
 T=\frac{A-A'}2
\]
satisfies
\[
 T^2=5.
\]
Thus the continuation locus reconstructs the quadratic algebra
\(\mathbf Q[T]\cong\mathbf Q(\sqrt5)\) on \(W^-\). Exchanging the two
five-orbitals sends \(T\) to \(-T\), which is golden conjugation; choosing
one orbital chooses one of the two ternary summands
\(\mathbf3,\mathbf3'\). Modulo \(11\), the two eigenvalues are
\(\pm4\), the two values of \(2t-1\) for the golden roots \(t=4,8\).

This upgrade needs no characteristic-zero golden marking. The integral
twelve-point association scheme reconstructed by Paper I already contains
the golden algebra and its conjugation. The marked support/Gale calculation
then identifies its two embeddings with the previously certified support
sheets.

### Integral refinement and the forced prime \(2\)

Let
\[
 L^-=\{f\in\mathbf Z^{12}:f(Rx)=-f(x)\}
\]
be the natural fibre-odd continuation lattice. Choosing one point from
each antipodal pair identifies \(L^-\) with \(\mathbf Z^6\). On this basis
either five-orbital adjacency operator restricts to a signed matrix \(B\)
with entries in \(\{0,\pm1\}\), zero diagonal, an off-diagonal unit, and
\[
 B^2=5I.
\]
Character theory gives
\(\operatorname{End}_{\mathbf Q A_5}(L^-\otimes\mathbf Q)=\mathbf Q[B]\).
If \(aI+bB\) preserves \(L^-\), its diagonal entries force
\(a\in\mathbf Z\), while an off-diagonal unit entry forces
\(b\in\mathbf Z\). Therefore
\[
 \boxed{\operatorname{End}_{\mathbf Z A_5}(L^-)
 =\mathbf Z[B]\cong\mathbf Z[\sqrt5].}
\]

This is the conductor-two order of discriminant \(20\), not the maximal
golden order
\[
 \mathcal O_5=\mathbf Z\!\left[\frac{1+\sqrt5}{2}\right]
\]
of discriminant \(5\). Normalization adjoins
\((I+B)/2\). Consequently the association order and its normalization
agree away from \(2\), while at \(2\)
\[
 \mathbf Z[\sqrt5]\otimes\mathbf F_2
 \cong \mathbf F_2[u]/(u-1)^2
\]
is a dual-number point and
\[
 \mathcal O_5\otimes\mathbf F_2\cong\mathbf F_4
\]
is the inert étale normalization.

Thus prime \(2\) is not merely a denominator introduced by the projector
\((I-R)/2\): it is the exact conductor prime of the integral continuation
commutant. This is compatible with C682's independently proved structural
bad prime \(2\), but identifying the two integral lattices requires a
separate integral comparison and is not asserted here.

## 4. Full-conic crown gate

Let \(A\) be a conic-filling \(k\)-arc and put
\(m=\binom{k}{2}\). C662 gives
\[
 2k-3\le q\le\frac{k(k-1)+3}{3}.
\]
For the first unclassified size \(k=9\), this leaves exactly
\[
 q=17,19,23,25.
\]
The existing passant-edge searches over \(17\) and \(19\) have maximum
six, so only \(23\) and \(25\) remain. At \(q=23\), the \(36\) chord
lines exceed the universal elliptic-cover bound by three; at \(q=25\)
they attain it exactly.

There is a compact necessary certificate. For an off-conic point \(X\),
let \(r_X\) count chord lines through \(X\), and let \(n_j\) count
nonvertices with \(r_X=j\). Every nonvertex has \(1\le r_X\le4\), while
the nine vertices have \(r_X=8\). Line and line-pair counting gives
\[
 \sum_X r_X=36(q+1),\qquad
 \sum_X\binom{r_X}{2}=\binom{36}{2}.
\]
Writing \(t=n_4\), the only possible nonvertex distributions are
\[
\begin{array}{c|rrrr|c}
q&n_1&n_2&n_3&n_4&\text{range of }t\\ \hline
23&354-t&60+3t&106-3t&t&0\le t\le35\\
25&498-t&-12+3t&130-3t&t&4\le t\le43.
\end{array}
\]
The type-sensitive C662 identity adds
\[
 \sum_{X\ {\rm external}}(r_X-1)
 =
 \begin{cases}
 156,&q=23,\\
 143,&q=25.
 \end{cases}
\]

Accordingly, a nine-arc over either remaining field whose \(36\) joins are
passant, cover all \(q^2\) off-conic points, and realize the displayed
moment/type ledger is a sharp falsifier of E3. Conversely, excluding all
such certificates closes the first case beyond Paper I.

A deletion induction cannot begin: removing a vertex \(P\) makes \(P\)
itself newly uncovered, because no chord of the remaining arc passes
through it. Any all-size proof therefore needs a genuine
replacement/contraction operation or a structural classification of
minimal chord covers; it cannot iterate the through-eight theorem by
subsets. The \(q=23,25\) nine-point gate should be settled before a
larger classification project is allocated.

## Disposition

| candidate | result | owner |
|---|---|---|
| terminal-field C665 transfer | sharp negative; exact \(d\ge10\) support gate retained | C611 |
| orientation/Gale reconstruction | proved v2 proposition | C690 / Paper I v2 |
| twelve-point double-six | closed negatively by character and incidence | C690 |
| all-size full-conic crown | exact \(k=9,\ q=23,25\) falsifier gate; no allocation | parked E3 |

No manuscript-facing priority claim is made, so no novelty-absence sentence
is proposed. A targeted novelty audit remains mandatory before the v2
orientation proposition is described as new in a manuscript.

## Reproducibility

From the repository root:

```text
python3 notes/2026-07-29-c690-rigidity-fingerprints.py --check
python3 notes/2026-07-26-c682-transvectant-bridge.py --check
python3 notes/2026-07-28-c682-operator-schlafli.py --check
sha256sum -c notes/2026-07-29-c690-rigidity-fingerprints.sha256
```

The C690 checker independently constructs the \(q=13\) point-line
incidence matrix, verifies its polarity symmetry, and computes its exact
binary rank. It also enumerates \(A_5\), constructs the two coset actions,
computes their characters and subdegrees, and checks the two graph
fingerprints. It also constructs both five-orbitals and the antipodal
relation, verifies \((A-A')^2=10(I-R)\) entrywise, and recovers the signed
six-axis matrix \(B\) with \(B^2=5I\). The rank agrees with
the independent published dimension
formula; the character values also have the closed coset-fixed-point
derivation given above. No independent program is needed for the
load-bearing claims because each is proved in the report; the checker is a
bookkeeping replay.

The two pre-existing C682 certificates independently own the marked
support/Gale calculation and the exact cyclotomic double-six construction.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c690-rigidity-fingerprints.py` | 15279 | `bb84fe9a320a816f2c518464229dfb57d35848fd1422304784da6f0354eefd8c` |
| `2026-07-29-c690-rigidity-fingerprints.json` | 3733 | `a7e7fc29cd3126285998121ca0039c8aedc7c491312adf5a4da1966b9fc31eaa` |

## Extra-juice and Tao closeout

The `ej` pass sharpened C662's “arc-supported word” seam: at the endpoint,
weight eight alone forces the arc and saturation conditions. Together
with parity, this turns the terminal problem into the single exact
minimum-distance gate \(d\ge10\). It also extracted the one-parameter
intersection ledgers for the first open E3 fields.

The `tt` pass tested whether the shared cardinality twelve concealed a
classical double-six. The fixed-point character shows that involutions
distinguish the sets before coordinates, while the triangle count explains
why their equal valency and edge count were misleading. The `ej` follow-up
then recovered their common quotient: they are respectively the twisted
and split two-covers of the same six-axis carrier. The `ej2` pass decomposed
the two covers and recovered the golden algebra intrinsically from
\((A-A')^2=10(I-R)\): the twisted cover's odd part is
\(\mathbf3\oplus\mathbf3'\), while the split cover's odd part is
\(\mathbf1\oplus\mathbf5\). The `ej3` integral pass then identified the
full continuation-lattice commutant as the conductor-two order
\(\mathbf Z[\sqrt5]\), with dual-number special fibre at \(2\) and
\(\mathbf F_4\) after normalization. The pass also exposed
the obstruction to the obvious all-size induction: deleting a vertex
necessarily enlarges the extension port off the conic.

## Mystery ledger

| feature | status | exact remaining gate |
|---|---|---|
| q=13 one-unit Delsarte miss | reduced to \(d(\ker M)\ge10\), not settled | C611: exclude binary weight-eight words using triple/tangent or support information |
| C665 transfer | settled negatively | none; a new cross-characteristic support mechanism would be a different method |
| support/Gale/golden exchange | settled on the frozen marked fibre | novelty audit and concise Paper I v2 integration only |
| intrinsic source of \(\sqrt5\) | settled by `ej2` | the continuation association scheme gives \(T^2=5\) on \(\mathbf3\oplus\mathbf3'\) |
| integral golden order | settled by `ej3` | \(\operatorname{End}_{\mathbf Z A_5}(L^-)=\mathbf Z[\sqrt5]\), of conductor \(2\) in \(\mathcal O_5\) |
| relation to C682's bad prime \(2\) | compatible but not identified | compare the continuation lattice with C682's integral golden/operator lattice |
| preferred orientation sign | settled negatively | the syndrome locus reconstructs only the torsor and cubic line |
| twelve-point double-six | settled negatively as an identification; common quotient recovered | Paper I gives the twisted \(A_5/C_5\to A_5/D_5\) cover, while the double-six gives the split cover |
| two Paper I orientation structures | settled as distinct | the support/Petersen cover is split under \(A_5\); the continuation/axis cover is twisted |
| E3 first new size | sharply reduced, not settled | exclude or construct the \(q=23,25\) nine-point certificates |
| all-size induction | naive deletion settled negatively | find a genuine replacement/contraction operation only after the first-size gate |

Vibe check: the strongest proposed geometric identification fails cleanly,
but the surviving orientation theorem is intrinsic and the two open
classification problems now have much narrower, exact targets.
