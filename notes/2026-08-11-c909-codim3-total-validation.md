# C909 — codimension-three total formula validation and counting correction

Date: 2026-08-11  
Status: exact split support-block audit; no manuscript, PDF, mirror, Lean, or
commit change

## Verdict

The codimension-three block formula is numerically consistent, but the
five-slot multiplicity must be written with a factor \(5\).

For a support set of five distinct slots, type
\((2,1,1,1,1)\) has one doubled slot, so there are
\[
5\binom g5
\]
components, not \(\binom g5\).  Each contributes one \(\mathbf Z/p^a\)
defect.  Every six-distinct-slot component contributes
\[
(\mathbf Z/p^a)^3\oplus \mathbf Z/p^{2a}.
\]
Therefore
\[
I_A^3/P_A^3\cong
(\mathbf Z/p^a)^{\,5\binom g5+3\binom g6}
\oplus
(\mathbf Z/p^{2a})^{\,\binom g6}.
\tag{1}
\]

The resulting totals are
\[
\begin{array}{c|c|c}
g&\text{exponent-one copies}&\text{exponent-two copies}\\ \hline
5&5&0\\
6&33&1\\
7&126&7
\end{array}
\tag{2}
\]

This corrects the earlier shorthand \(\binom g5+3\binom g6\).  The
underlying squarefree profile and repeated-support profiles are unchanged.

## Exact block tests

Using Teichmuller/distinct integer-root lifts and the integral scaled
contraction matrix:

\[
\begin{array}{c|c|c}
\text{support type}&\text{matching columns}&\text{Smith valuations at }a=1\\ \hline
(2,1,1,1,1)&9& (0,1)\\
(2,2,1,1)&6& (0)\\
(2,2,2)&5& (0)\\
(1,1,1,1,1,1)&15&(0,1,1,1,2)
\end{array}
\tag{3}
\]

Here \((0,1)\) means one saturated direction and one \(p\)-defect
direction, and \((0)\) means complete saturation.  Replacing \(p\) by
\(p^a\) scales every positive valuation by \(a\), as independently checked
for the squarefree block.

The rational matching ranks are respectively \(2,1,1,5\); the first three
rows are precisely the repeated-support decomposition, and the last row is
the six-slot squarefree component.

## Dimensions \(g=5,6,7\)

The formula follows by direct support counting:

* \(g=5\): five choices of the doubled slot on the unique five-set, hence
  \((\mathbf Z/p^a)^5\).
* \(g=6\): \(5\binom65=30\) five-slot defects plus the six-slot block
  \((\mathbf Z/p^a)^3\oplus\mathbf Z/p^{2a}\), giving
  \((\mathbf Z/p^a)^{33}\oplus\mathbf Z/p^{2a}\).
* \(g=7\): \(5\binom75=105\) five-slot defects plus seven six-slot blocks,
  giving \((\mathbf Z/p^a)^{126}\oplus(\mathbf Z/p^{2a})^7\).

No full \(g=7\) matrix is needed: the multidegree decomposition is direct,
and each support block depends only on its local support size.

## Scope

This validates the codimension-three formula in the split one-depth
finite-etale model.  It does not repair the all-\(k\) primitive-pivot gap in
the Dyck-height theorem, and it makes no Chow or non-etale claim.

