# C708 — doily codes and the exceptional six-point exchange

**Date:** 2026-07-30

**Lane:** `clebsch`

**Status:** complete; the operator realizes the exceptional outer twist of
the two six-point representations, but does not select an involutory finite
polarity without an additional normalization.

## Outcome

The stabilizer gate is positive.  The six C706 Clifford charts are indexed
by the six synthematic totals, while the six conference axes carry the
ordinary six-letter action.  If \(A_X\) denotes the ordinary augmentation
module and \(O_X\) the outer augmentation module, C705's assembled
differential has the intrinsic type
\[
 \bar G_x:O_X\longrightarrow A_X^\vee
\]
and its fourth compound is
\[
 \operatorname{adj}A(x)=6W(x)q(x)^{\mathsf T},
\]
where \(W\) has synthematic-total coordinates and \(q\) has ordinary
six-axis coordinates.  Thus the Segre--Igusa operator couples precisely
the two inequivalent degree-six actions.

This is an exceptional exchange, not a direct equivariant bijection.  The
stabilizer of a chart is an outer \(S_5\): it fixes that chart and is
transitive on the six ordinary axes.  Under the automorphism induced by the
operator's total action, it becomes an ordinary point stabilizer.  This is
exactly the required exchange of the two conjugacy classes of \(S_5\) in
\(S_6\).

There is also a sharp finite qualification.  Transporting the frozen
lexicographic row/column marking to the ten \(W_{10}\) nodes gives the
unique compatible exchange
\[
 (0,1,\ldots,9)\longmapsto(7,6,5,8,4,0,2,3,1,9),
\]
which has order \(8\), not order \(2\).  Hence the operator itself does not
select one of the \(36\) involutory \(W_{10}\) polarities.  Inner
normalization gives all \(36\) possibilities.  The golden conference
marking cuts these to the already frozen orbit \(6+30\), and the compatible
small orbit consists of six polarities indexed by the six axes.  The
strongest exact conclusion is therefore:

> the Segre--Igusa operator realizes the exceptional outer exchange of the
> chart and axis representations; the conference structure selects its
> six golden involutory normalizations, but neither structure canonically
> selects one member of that six-pack.

The order-\(8\) phenomenon has an exact cocycle form.  If \(f\) is the
frozen exchange and \(\alpha\) is its outer automorphism, then
\[
 f^2=\rho(h),\qquad h=(0\,1)(2\,5\,3\,4).
\]
An inner correction \(k\in S_6\) makes \(\rho(k)f\) involutory exactly
when
\[
 k\alpha(k)=h^{-1}.
\]
This twisted norm equation has exactly \(36\) solutions.  Their cycle-type
distribution is
\[
 (4,2)^8(5,1)^{16}(3,3)^4(3,1,1,1)^4(2,2,1,1)^4.
\]
The golden six contain two corrections of each type
\((4,2)\), \((5,1)\), and \((2,2,1,1)\).  Thus the finite polarity torsor
is explained by one nonabelian normalization equation, not only by
enumeration.

The `tt` orbit audit removes the two remaining numerical coincidences.
The \(36\) solutions form one orbit under twisted conjugation
\[
 k\longmapsto gk\alpha(g)^{-1}.
\]
The stabilizer of one solution has order \(20\), so
\[
 36=\frac{|S_6|}{20}.
\]
Restricting ordinary conjugation to the conference \(S_5\) leaves the same
order-\(20\) stabilizer on a golden solution, giving
\[
 6=\frac{120}{20}.
\]
Thus both the full polarity class and the golden six-pack are forced by
one stabilizer, viewed globally and inside the conference subgroup.

The stabilizer is not an unnamed order-\(20\) group.  Its element-order
distribution is
\[
 1^1\,2^5\,4^{10}\,5^4,
\]
so it is the Frobenius group
\[
 F_{20}=C_5\rtimes C_4\cong\operatorname{AGL}(1,5).
\]
For every golden polarity, its stabilizer inside the conference \(S_5\)
is literally equal—not merely conjugate—to the stabilizer of its indexed
axis.  Consequently the golden polarity six-set and the axis six-set are
the same homogeneous space
\[
 S_5/F_{20}.
\]
This supplies the canonical axis indexing by shared subgroup and explains
why the order-\(20\) stabilizer appeared on both sides.

The third-order orbit decomposition recovers the golden phase boundary
inside this stabilizer.  Under \(F_{20}\), the duads and synthemes each
split as \(5+10\), and the ten nodes are transitive.  Passing to
\[
 D_{10}=F_{20}\cap A_5
\]
refines both fifteen-sets to
\[
 5+5+5:
\quad
\text{axis star}\ \sqcup\ \text{pentagon sides}\ \sqcup\
\text{pentagram diagonals},
\]
and splits the nodes as \(5+5\).  The golden polarity exchanges those two
node orbits.  The orientation-reversing coset
\(F_{20}\setminus D_{10}\) merges sides with diagonals and makes the nodes
transitive.  Thus C706's loss of the distinguished conference phase at
\(A_5\subset S_5\) is visible here as the exact fusion
\[
 (5+5+5,\;5+5)\longrightarrow(5+10,\;10).
\]

## Incidence-code table

Let \(C_{cp}\), \(C_{gp}\), and \(C_{gc}\) be the row codes of the
context--point, grid--point, and grid--context incidence matrices.  Their
length is \(15\).  The exact parameters are:

| field | \(C_{cp}\) | hull | \(C_{gp}\) | hull | \(C_{gc}\) | hull |
|---|---:|---:|---:|---:|---:|---:|
| \(\mathbf F_2\) | \([15,10,3]\) | \(5\) | \([15,5,5]\) | \(4\) | \([15,5,6]\) | \(5\) |
| \(\mathbf F_3\) | \([15,10,3]\) | \(1\) | \([15,9,4]\) | \(0\) | \([15,10,3]\) | \(1\) |
| \(\mathbf F_5\) | \([15,10,3]\) | \(0\) | \([15,10,3]\) | \(0\) | \([15,10,3]\) | \(0\) |

The certificate records the complete weight enumerator and dual weight
enumerator of all nine codes.  Their pairwise rowspace-intersection
dimensions are
\[
\begin{array}{c|ccc}
 &C_{cp}\cap C_{gp}&C_{cp}\cap C_{gc}&C_{gp}\cap C_{gc}\\ \hline
2&5&0&0\\
3&9&6&5\\
5&10&5&5.
\end{array}
\]
Thus \(C_{gp}\subset C_{cp}\) in characteristics \(2,3\), and
\(C_{gp}=C_{cp}\) in characteristic \(5\), while \(C_{gc}\) remains a
different isodual copy.

Every code has full coordinate permutation automorphism group \(S_6\) of
order \(720\).  This follows directly from its minimum-support geometry:
the supports reconstruct synthemes, the six stars, the \(45\) four-cycles
of \(K_6\), or the ten grid incidence blocks.  In every case that geometry
reconstructs the six letters and hence has no additional coordinate
automorphisms.

The Pauli and Clebsch signed context matrices introduce no new code
parameters.  Context signs are row scalings, and C705's exact gauge
comparison differs further by a point-column rephasing.  Over odd fields
the codes are therefore equal or monomially equivalent; over
characteristic \(2\) all signs coincide.  Any arithmetic effect visible
only in those signs is a sign-lift effect, not a new incidence code.

## CSS and symplectic test

Among the task's incidence rowspaces, the only nonzero orthogonal pair is
\[
 C_{gc}\subseteq C_{gc}^{\perp}
 \quad\text{over }\mathbf F_2.
\]
It gives the binary CSS code
\[
 [[15,5,3]]_2.
\]
Indeed \(C_{gc}\) has parameters \([15,5,6]\), and its dual is an isodual
copy of the \([15,10,3]\) context--point code.  Equivalently,
\(\operatorname{diag}(C_{gc},C_{gc})\) is symplectically
self-orthogonal.  No odd-characteristic member of this incidence family is
self-orthogonal, and there is no other CSS inclusion among the three
rowspaces.  This is a standard incidence-derived code; no new quantum-code
claim is made.

## Comparison with the C705 bad primes

The incidence ranks do not explain the C705 arithmetic boundary.

- At \(2\), the three incidence ranks are \(10,5,5\), whereas
  \((\operatorname{rank}G,\operatorname{rank}A)=(1,0)\).  The sign
  coalescence is shared, but the much stronger operator collapse is not
  forced by an incidence-code rank.
- At \(3\), only \(C_{gp}\) drops, from rank \(10\) to \(9\);
  \(C_{cp}\) and \(C_{gc}\) retain rank \(10\).  In contrast \(G\) and
  \(A\) both have rank \(3\), so \(\bigwedge^3A\) has rank \(1\) and
  \(\bigwedge^4A=0\).  This is the scalar-\(6\)/compound boundary of the
  polar factorization, not a doily-code degeneration.
- At \(5\), all three incidence codes have rank \(10\) and zero hull, and
  \(G,A\) retain their generic rank \(4\).  The bad behavior belongs to
  the ramified golden eigenspace/sign lift; it is absent from both the
  descended polar operator and the unsigned incidence codes.

Accordingly the three negatives classify cleanly: characteristic \(2\)
has an incidence-only overlap but no incidence explanation;
characteristic \(3\) is an unrelated compound-scalar degeneration; and
characteristic \(5\) is sign-lift/golden-splitting arithmetic.

## `ej` + `tt` closeout

The first extra-juice pass upgraded the rank table to complete primal and
dual weight enumerators, hulls, rowspace intersections, and exact CSS
inclusions.  It exposed two initially easy-to-conflate facts: equal
parameters need not mean equal rowspaces, and the binary
\([15,5,6]\) code has a dual *copy* of \(C_{cp}\), not the frozen
\(C_{cp}\) itself.

The first structural pass separated three meanings of “exchange”:
an \(S_6\)-equivariant direct bijection, an outer-twisted representation
intertwiner, and an involutory \(W_{10}\) polarity.  Stabilizers rule out
the first, the mixed operator proves the second, and the order-\(8\)
frozen exchange disproves automatic selection of the third.

The second extra-juice pass computed the complete normalization fibre:
there are \(720\) finite exchanges, \(36\) involutory ones, and the
conference \(S_5\) splits the latter as \(6+30\).  Thus the apparent
failure to select one polarity is not a loose negative; the nearest
positive locus is exactly the golden six-pack.

The post-closeout extra-juice pass explains the count structurally:
the frozen exchange squares to the inner element
\((0\,1)(2\,5\,3\,4)\), and the \(36\) involutory normalizations are
exactly the solutions of \(k\alpha(k)=h^{-1}\).  The golden six occupy
three correction cycle types evenly, so they are not a hidden conjugacy
class selected by ordinary cycle structure.

The post-closeout `tt` pass then identifies those \(36\) solutions as one
twisted-conjugacy orbit with stabilizer \(20\).  Restriction to the
conference \(S_5\) preserves that stabilizer, explaining the small orbit
by the paired formulas \(36=720/20\) and \(6=120/20\).

The second-order extra-juice pass identifies the common stabilizer as
\(F_{20}\cong\operatorname{AGL}(1,5)\) and verifies equality of the
polarity and axis stabilizers for all six golden members.  Thus their
indexing is canonical at the subgroup level:
\(S_5/F_{20}\), not a cardinality-based label matching.

The third-order pass then resolves the internal incidence orbits.
The orientation-preserving \(D_{10}\) distinguishes the axis star,
pentagon sides, and pentagram diagonals and gives two node pentagons
exchanged by polarity.  Extending to \(F_{20}\) fuses the last two duad
orbits and the two node orbits.  This is the same \(A_5\subset S_5\)
boundary that C706 found cohomologically, now recovered from finite
incidence alone.

The final structural pass checked converse content.  Any map conjugating
the chart action to the axis action lies in the exceptional exchange coset,
and trivial centralizer of the natural \(S_6\) node action makes the
exchange compatible with a fixed outer automorphism unique.  The
operator's order-\(8\) witness is therefore a genuine normalization
statement, not a missed second solution.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| Does the polar operator exchange the two six-actions? | settled positively at the representation and stabilizer level | none |
| Does it directly identify chart and axis elements equivariantly? | settled negatively: fixed-\(S_5\) orbit structures are \(1+5\) and \(6\) | none |
| Does it select a finite involutory polarity? | settled negatively without normalization: the frozen compatible exchange has order \(8\) | none |
| What is the nearest positive polarity locus? | settled: all \(36\) inner normalizations, cut to the axis-indexed golden six-pack by the conference marking | none |
| Why are there exactly \(36\) involutory normalizations? | settled structurally: the solutions of \(k\alpha(k)=h^{-1}\) form one twisted-conjugacy orbit with stabilizer \(20\), so \(36=720/20\) | none |
| Why does the conference marking leave exactly six? | settled by restriction of the same order-\(20\) stabilizer: \(6=120/20\) | none |
| Why are the golden polarities canonically indexed by axes? | settled: their stabilizers are literally the same \(F_{20}\) subgroups, so both six-sets are \(S_5/F_{20}\) | none |
| Where is the C706 orientation-phase boundary in the finite incidence? | settled: \(D_{10}\) has orbit pattern \((5+5+5,5+5)\), while its \(F_{20}\) extension fuses this to \((5+10,10)\) | none |
| Do the incidence codes explain primes \(2,3,5\)? | settled negatively with the exact classification above | none |
| Is there a CSS or symplectic code hidden in the incidence family? | settled: only the standard binary \([[15,5,3]]_2\) construction | none |
| Do equal field-\(3\) or field-\(5\) parameter tables imply equal codes? | settled by exact rowspace intersections | none |

No genuine C708 mystery remains.

## Reproducibility

Primary exact generator:

```sh
cd /home/tavis/src/othello
python3 notes/2026-07-30-c708-doily-codes-and-outer-exchange.py --check
```

Independent syndrome-dynamic-programming replay:

```sh
cd /home/tavis/src/othello
python3 notes/2026-07-30-c708-doily-codes-and-outer-exchange-replay.py
```

The primary generator uses exact finite-field elimination, enumerates the
small dual codes and applies the MacWilliams transform, checks all
rowspace and hull relations, exhausts all \(10!\) node permutations to
recover the \(720\) exchanges and \(36\) involutions, verifies the unique
operator-compatible exchange, and rechecks the conference \(6+30\) orbit
split.  The replay uses a different syndrome dynamic program to count
primal words directly over all three fields.

The generator, replay, and JSON certificate contain respectively
\(26523\), \(3664\), and \(12330\) bytes.  Their SHA-256 hashes are recorded
in `notes/2026-07-30-c708-doily-codes-and-outer-exchange.sha256`.
