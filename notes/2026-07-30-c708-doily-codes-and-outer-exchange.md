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
\(18354\), \(3664\), and \(10636\) bytes.  Their SHA-256 hashes are recorded
in `notes/2026-07-30-c708-doily-codes-and-outer-exchange.sha256`.
