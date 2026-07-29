# C682 normalized-graph deck exchange and the Schläfli row swap

## Outcome

The normalized-graph deck exchange is exactly the global extension of the
Schläfli apolar-polar row swap.

Fix a marked icosahedron and identify its six \(D_5\)-subgroups with the six
Sylow-five subgroups of \(A_5\). For such a subgroup \(D\), its four nonidentity
five-cycles split between the two \(A_5\)-conjugacy classes:
\[
 (C_D\setminus\{1\})=
 \{g,g^{-1}\}\sqcup\{g^2,g^{-2}\}.
\]
The first pair traces the five sides of a pentagon on the five Clebsch labels;
the second traces its five diagonals. The two edge sets are complementary.

Under the standard pentahedral marking of the Clebsch surface, the ten
\(S_3\)-labels also mark the ten Eckardt points. For each \(D\), one
five-element set lies on the exceptional Schläfli line \(E_D\), and the
complementary five-element set lies on its apolar-polar companion \(E_D'\).
Therefore
\[
 E_D\longleftrightarrow E_D'
\]
exchanges precisely the two thirty-edge \(A_5\)-orbits in
\[
 A_5/D_5\times A_5/S_3.
\]
Those are exactly the two golden cross-Gram fibres
\(\lambda_+\) and \(\lambda_-\). Hence the golden deck exchange and the
Schläfli row swap are the same involution.

There is no conflict with the earlier sum-versus-difference distinction. The
\(S_3\) mate lies over the pair-sum cubic \(q_\alpha+q_\beta\), which is off
the Clebsch surface. Its Schläfli incidence shadow uses the same
\(\{\alpha,\beta\}\) label on the Eckardt difference
\(q_\alpha-q_\beta\). The theorem identifies the two relations on the common
ten-element marking; it does not identify those two cubic points.

## Proof

There are two independent descriptions of the same two-orbit set.

First, every pair \((D,S)\) has stabilizer \(C_2\), so the diagonal
\(A_5\)-action on the sixty pairs has two orbits of size thirty. The
normalized apolar cross-Gram scalar separates them by the conjugate values
\(\lambda_\pm\), and the normalized saturated graph retains the two sheets
at the Mukai--Umemura boundary.

Second, choose one of the two conjugacy classes of five-cycles in \(A_5\).
For every Sylow-five subgroup \(C_D\), its intersection with that class is
\(\{g,g^{-1}\}\), and the five unordered pairs \(\{i,g(i)\}\) form a
pentagon. The other five-cycle class gives
\(\{g^2,g^{-2}\}\) and the complementary pentagram. Thus the two relations
on the six \(D_5\)-rows and ten \(S_3\)-edges have degrees \(5\) and \(3\),
are complementary, and each is one diagonal \(A_5\)-orbit.

The Schläfli double-six gives the geometric version of this exchange.
Every \(E_D\) contains five of the ten Eckardt points, every \(E_D'\)
contains five, and \(E_D\cap E_D'=\varnothing\). Equivariance makes either
row-incidence relation one of the two size-thirty orbits, so the polar
replacement \(E_D\mapsto E_D'\) exchanges them. The frozen common marking
from the preceding sign audit calls the stored orbit \(\lambda_+\);
the outer order-five-class swap gives \(\lambda_-\).

On the dense homogeneous locus the deck involution and row swap therefore
agree. The normalized saturated graph is separated and each component is
normal, so two morphisms agreeing on that dense locus agree everywhere.
Equivalently, the deck involution supplies the unique extension of the
dense-open apolar-polar swap across both normalized boundary closures.

This last statement is deliberately about the normalized correspondence.
It does not produce a regular row-swap involution on the coarse kernel-pair
image, where both sheets have the same limiting pair, nor does it claim that
the twelve individual line embeddings remain distinct on every coarse
boundary fibre.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-29-c682-normalized-graph-row-swap.py --check
python3 ../notes/2026-07-29-c682-normalized-graph-row-swap-replay.py
```

The primary checker imports the exact golden-fibre certificate and frozen
common-marking sign, constructs the six Sylow-five cyclic orders directly in
\(A_5\), and compares the two \(6\)-by-\(10\) relations up to independent
row and column marking. The replay independently enumerates \(A_5\), its two
five-cycle classes, the six Sylow-five subgroups, and the ten edges; it
verifies the two complementary \(30\)-element relations, degrees \(5/3\),
and their exchange by odd conjugation.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-normalized-graph-row-swap.py` | 7070 | `d4cdbac0e0e3f77ba78387dcfc6d2686a058ebab185ce85d05caf48c1582e42e` |
| `2026-07-29-c682-normalized-graph-row-swap-replay.py` | 2440 | `c6c927b7c9aa04e3d337656d298f4b1b3ba1121540be589b36ad414a4fff6f16` |
| `2026-07-29-c682-normalized-graph-row-swap.json` | 1400 | `f96ace411a70b9f45e245c0e519c09d39cc80284d0ecf50af2b7ed2e33204422` |

The computation certifies the finite-group identification and its agreement
with the already certified golden matrices. The geometric inputs are the
previously established apolar-polar construction of \(E_D'\), the
double-six/Eckardt incidence, and the normalized boundary extension. No
novelty or priority claim is made, and Paper III remains closed.

## `ej` + `tt` closeout and mystery ledger

- **Closed:** the normalized-graph deck exchange is the Schläfli
  apolar-polar row swap, not merely an abstract complement of the same
  incidence matrix.
- **Closed by `ej`:** the row swap is already encoded inside each
  \(D_5\): the two \(A_5\)-classes
  \(\{g,g^{-1}\}\) and \(\{g^2,g^{-2}\}\) are pentagon sides and diagonals.
- **Closed by `ej`:** the apparent pair-sum/Eckardt mismatch is resolved by
  keeping the point and its incidence shadow separate. They share the
  \(S_3\)-label but are not the same cubic.
- **Settled by `tt`:** “global” means global on the normalized saturated
  graph. A coarse ambient involution is impossible because the boundary
  kernel pair has forgotten the sheet.
- **No genuine row-swap mystery remains.**
- **Still open:** the minimal integral base and actual bad primes of the
  combined operator, polar, and golden-incidence package.

C682 remains open; completion is the user's decision.
