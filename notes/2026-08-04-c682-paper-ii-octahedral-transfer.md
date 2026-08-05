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

If \(A=C C^{\mathsf T}-4I\), then \(A\) is the four-regular graph joining two
matchings when they share a chord, and

\[
 As=-4s.
\]

The graph is bipartite across the two projective sheets.  This exhibits the
trade as the unique defect of an octahedral--toric double-coset transform,
rather than only as a null vector of quadratic evaluation.

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

1. Derive \(\operatorname{rank}(C^{\mathsf T})=13\) from the permutation
   characters of \(G/S_4\) and \(G/D_{12}\).
2. Express the quadratic moment map of Paper II as a factor of, or refinement
   of, the chord-incidence transform.
3. Formulate a single octahedral--toric Hecke interface whose specializations
   contain both the \(q=7\) defect line and the \(q=13\) frame equivalence.
4. Determine whether the shared-chord graph or its incidence subdivision is a
   standard named coset graph.

