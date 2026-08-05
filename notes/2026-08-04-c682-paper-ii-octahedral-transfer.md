# Paper II's octahedral matching--chord transfer

**Date:** 2026-08-04  
**Task:** C682  
**Lane:** `clebsch`  
**Status:** Exact research bundle; no manuscript, Lean, or release file changed

## Result

The Paper-IV octahedral--toric Radon transform has a precise Paper-II
counterpart.  Its defect is exactly the two-sheet sign line underlying Paper
II's quadratic trade.

Let

\[
 G=\operatorname{PGL}(2,7).
\]

Let \(\Omega\) be the fourteen-element \(B_3\) orbit of perfect matchings of
the eight conic points.  A matching stabilizer is the self-normalizing
octahedral subgroup \(S_4\), so \(\Omega\cong G/S_4\).  Let \(\mathcal E\)
be the twenty-eight chords of the conic.  A chord stabilizer is the split-
torus normalizer \(D_{12}\), so \(\mathcal E\cong G/D_{12}\).

Define incidence by chord membership.  Equivalently,

\[
 M\sim e
 \quad\Longleftrightarrow\quad
 \left|\operatorname{Stab}_G(M)\cap\operatorname{Stab}_G(e)\right|=6.
\]

The flag stabilizer has element-order profile \(1^1 2^3 3^2\), hence is
\(S_3\).  The resulting connected, flag-transitive coset geometry is

\[
 S_4\longleftarrow S_3\longrightarrow D_{12}.
\]

Each matching is incident with its four chords, while each chord occurs in
exactly two \(B_3\) matchings.  An incident pair of stabilizers generates all
\(336\) elements of \(G\).

Let \(C\) be the \(14\)-by-\(28\) matching--chord incidence matrix.  The
\(B_3\) orbit splits into two seven-element
\(\operatorname{PSL}(2,7)\)-orbits.  Every chord occurs in one matching from
each sheet.  Therefore the sheet-sign vector \(s\), with values \(+1,-1\) on
the two sheets, satisfies

\[
 C^{\mathsf T}s=0.
\]

Exact rank calculation gives

\[
 \operatorname{rank}_{\mathbf F_7}(C^{\mathsf T})=13,
 \qquad
 \ker(C^{\mathsf T})=\mathbf F_7s.
\]

The rank is also thirteen over \(\mathbf F_2\).  Hence the sheet partition is
recovered from the matching--chord incidence alone: it is the unique signed
relation annihilating every chord column.

Paper II independently proves that its one-dimensional strength-two trade
space is this same sheet-sign line.  Thus the quadratic trade admits a new
combinatorial recovery:

\[
 \boxed{
 \text{Paper-II trade line}
 =\text{sheet-sign line}
 =\ker(C^{\mathsf T}).}
\]

The quadratic moment map \(\mu\) therefore factors canonically through the
chord transform on its image.  Indeed, Paper II gives
\(\ker\mu=\mathbf F_7s=\ker C^{\mathsf T}\), so there is a unique injective
linear map

\[
 \bar\mu:\operatorname{im}C^{\mathsf T}\longrightarrow\operatorname{im}\mu
 \quad\text{with}\quad
 \mu=\bar\mu\,C^{\mathsf T}.
\]

Both images have dimension thirteen, so \(\bar\mu\) is an isomorphism.  This
does not yet give a coordinate formula for \(\bar\mu\), but it settles the
existence of the incidence factorization without another computation.

If \(A=C C^{\mathsf T}-4I\), then \(A\) is the four-regular graph joining two
matchings when they share a chord, and

\[
 As=-4s.
\]

The graph is bipartite across the two projective sheets.  This exhibits the
trade as the unique defect of an octahedral--toric double-coset transform,
rather than only as a null vector of quadratic evaluation.

There is also a classical identification.  The bipartite complement of the
shared-chord graph is three-regular, and every two vertices on one side have
exactly one common neighbor.  It is therefore the incidence graph of the Fano
plane, namely the Heawood graph.  The shared-chord graph is the bipartite
complement of Heawood.  This makes the rank argument conceptual: \(C\) is the
ordinary unoriented vertex--edge incidence matrix of a connected bipartite
graph.  Over any field of odd characteristic, the equations
\(x_u+x_v=0\) along its edges force one alternating value on the two color
classes.  Hence its left kernel is the sheet-sign line without calculation.

## Comparison with Paper IV

The two papers now have parallel invariant operations:

\[
\begin{array}{c|c|c}
 & \text{Paper II at }q=7 & \text{Paper IV at }q=13\\ \hline
\text{octahedral space} & G/S_4\ (14) & G/S_4\ (91)\\
\text{toric/chord space} & G/D_{12}\ (28) & G/D_{24}\ (91)\\
\text{flag stabilizer} & S_3 & D_8\\
\text{degrees} & 4\mid2 & 3\mid3\\
\text{algebraic effect} & \text{one-dimensional defect} &
  \text{inverse maps on the code image}
\end{array}
\]

At \(q=7\), the transform's unique kernel recovers the quadratic-trade
orientation.  At \(q=13\), the transform identifies two homogeneous
factorizations of the same hidden-field scalar \(A_9\).  This is a genuine
common mechanism: both papers extract exceptional structure through a local
double-coset transfer between an octahedral stabilizer and a split-torus
normalizer.

The conclusion is stronger than the previously known common-carrier statement.
Paper II and Paper IV do not merely decorate the same abstract cube in two
ways; their exceptional data are recovered by parallel Hecke/Radon operators.
The operators have different ranks and local degrees, so no uniform
invertibility theorem is asserted.

The change of shape is forced by orbit sizes.  In general the ratio of the
octahedral-marking space to the split-chord space is \((q-1)/12\).  It is
one half at \(q=7\), producing the rectangular defect transform here, and one
at \(q=13\), where Paper IV's transform becomes square and recovers the code
constituent as a two-step fixed space.

## Evidence and replay

The committed checker constructs \(G\), the \(B_3\) matching orbit, all
twenty-eight chords, and every stabilizer.  It independently defines incidence
by chord membership and by stabilizer-intersection order and checks equality.
It computes the two projective sheets, verifies one occurrence of every chord
in each sheet, calculates ranks over \(\mathbf F_7\) and \(\mathbf F_2\),
identifies the unique kernel with the sheet-sign vector, and verifies the
shared-chord eigenvalue and group generation.

Replay from the repository root:

```sh
python3 notes/2026-08-04-c682-paper-ii-octahedral-transfer.py --check
sha256sum -c notes/2026-08-04-c682-paper-ii-octahedral-transfer.sha256
```

The computation is deterministic, uses no randomness and only the Python
standard library, and completes in under one second on the present host.  Its
load-bearing input is Paper II's tracked
`verification/evidence/matching_module.py`.  The calculation proves the stated
facts for the complete \(q=7\) action.  The identification with the
strength-two trade uses Paper II's separately established theorem that this
trade is the sheet-sign line; the new checker does not recompute the quadratic
evaluation space.

No novelty claim is made.  A paper-facing promotion should first identify the
double-coset operator in the existing literature and replace the finite group
enumeration by the short orbit-stabilizer proof it visibly suggests.

## Open questions

1. Find a geometric coordinate formula for the canonical isomorphism
   \(\bar\mu\) between chord incidence and quadratic moments.
2. Formulate a single octahedral--toric Hecke interface whose specializations
   contain both the \(q=7\) defect line and the \(q=13\) frame equivalence.
3. Determine whether the full matching--chord incidence subdivision has a
   useful standard name beyond its Heawood-complement contraction.
