# C904 — the marked oriented companion round trip

**Date:** 2026-08-09  
**Lane:** `clebsch`  
**Status:** exact theorem; manuscript proof drafted; cold re-review pending

## Result

Let `G=A_5` act on the six-axis augmentation `A`, and put

\[
 \mathcal I=\operatorname{Sym}^3(A^*)^G.
\]

The exact Paper-V calculation gives `dim I=2`.  In the normalized basis
`(C,H)` consisting of the conference cubic and the Paper-II chordal cubic,
the nontrivial coset of `N_{S_6}(G)/G` acts by

\[
 q(C)=-C,\qquad q(H)=8C+H,
 \qquad
 q=\begin{pmatrix}-1&8\\0&1\end{pmatrix}.
\]

This action is independent of the odd representative: two representatives
differ by an element of `G`, and `G` fixes `I` pointwise.

Put `Delta=q-1`.  Its image is the conference line, and for either chordal
line `L` the restriction

\[
 \Delta|_L:L\xrightarrow{\sim}\mathbf F_{11}C
\]

is an isomorphism.  In the frozen normalization,

\[
 h\longmapsto c=8^{-1}\Delta h,
 \qquad
 c\longmapsto h=(\Delta|_L)^{-1}(8c)
\]

are inverse.  Linearity gives `-h -> -c`.  Thus the chosen Paper-II sheet
generator and the conference orientation are not merely abstract binary
characters: the outer-difference operator supplies the canonical marked
comparison.

## Exact scope

The round trip is between companion-marked packages

\[
 (G\curvearrowright A,L,h)
 \longleftrightarrow
 (G\curvearrowright A,L,c).
\]

The selected chordal line `L` is returned and is load-bearing.  If `L` is
forgotten, the conference package retains only the unordered pair of chordal
lines exchanged by `q`; it cannot select one.  Paper II supplies `L` through
its projected tensor.  Any transport from Papers I or III must declare `L`
as part of its bridge marking.

This closes the earlier orientation-torsor gate at the correct marked level.
It does not claim that the unmarked conference cubic reconstructs the full
Paper-II matching quotient, its endpoints, or a preferred chordal member.

## Evidence

The paper-owned certificate

`papers/clebsch-round-trip/verification/evidence/paper_ii_chordal_axis.py`

checks the complete coefficient identities and outer action.  Replay:

```text
python3 papers/clebsch-round-trip/verification/evidence/paper_ii_chordal_axis.py --check
```

Expected output is `CHECK OK (NO_MATCH)`: the literal cubic lines do not
match, while the companion and outer-action assertions do.
