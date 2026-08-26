# C973 checkpoint — first unresolved all-level Lucas block

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Status:** exact R11
reduction proved; two pointed lower-carrier gates remain

## Result

After the proved fixed R5--R10 classifications, the first all-level Lucas
test is redundancy eleven.  Put `d=r-2=9`.  The maximal carrier

\[
 \mathcal M^{\max}_{11,p}
 =\mathbf P\langle e_j:
   \binom9j=\binom9{j-1}=0\pmod p\rangle                  \tag{1}
\]

is nonempty only in characteristics `2`, `3`, and `7`, with exact supports

\[
\begin{array}{c|c|c}
p&\text{zero runs in Pascal row }9&\mathcal M^{\max}_{11,p}\\ \hline
2&2,3,4,5,6,7&\mathbf P\langle e_3,e_4,e_5,e_6,e_7\rangle,\\
3&1,2,3,4,5,6,7,8&\mathbf P\langle e_2,\ldots,e_8\rangle,\\
7&3,4,5,6&\mathbf P\langle e_4,e_5,e_6\rangle.
\end{array}                                                \tag{2}
\]

For every other characteristic, row 9 has no adjacent pair of zero binomial
coefficients, so the carrier is empty.

The contraction supports identify the exact arithmetic boundary:

\[
\begin{array}{c|c|c}
p&\operatorname{supp}(\iota_\lambda f)&\text{lower target}\\ \hline
2&\{2,\ldots,7\}&
  \mathcal M^{\max}_{10,2}=\mathbf P\langle e_2,\ldots,e_7\rangle,\\
3&\{1,\ldots,8\}&
  \mathcal M^{\max}_{10,3}=\varnothing,\\
7&\{3,\ldots,6\}&
  \mathcal M^{\max}_{10,7}=\mathbf P\langle e_3,\ldots,e_6\rangle.
\end{array}                                                \tag{3}
\]

Here the displayed support is the union of the support in (2) and its
one-step shift; endpoints may disappear for a special marker, but no new
coordinate appears.

Thus characteristic three is transverse after one contraction, whereas
characteristics two and seven are genuinely coherent contained descendants.
The first exact unresolved arithmetic object is not an unspecified higher
Lucas union: it is the pointed-witness problem on the two already known lower
carriers in the first and third rows of (3).

## 1. Characteristic-three transverse closure

Let `f` lie in `M^max_(11,3)` but outside the persistent scheme.  The polar
line cannot be contained in the lower persistent scheme by C536's coherent
Fano theorem.  Since the maximal lower characteristic-three carrier is empty,
all but at most three marker parameters give a lower redundancy-ten syndrome
outside both lower carriers; the degree-three bound is the pullback of the
terminal catalecticant minors to the polar line.

Choose such a rational marker `lambda`.  Apply the pointed simultaneous-marker
variant from the companion C973 checkpoint to the lower redundancy-ten
syndrome, with the one forbidden root `lambda`.  Its terminal budget is

\[
 12+6((10-5)+1)=48.                                      \tag{4}
\]

Hence the lift is split and squarefree whenever

\[
 q\geq1+\lfloor(1+\sqrt{48})^2\rfloor=63.                \tag{5}
\]

For characteristic-three fields this starts at `q=81`.  Consequently

\[
 (\mathcal M^{\max}_{11,3}\setminus\mathcal P_{11})(F_q)
 \cap\operatorname{SplitFree}_{11}(F_q)=\varnothing
 \qquad(q\geq81).                                        \tag{6}
\]

The intersection with the persistent scheme remains governed by the existing
tangent/secant arithmetic; (6) says that the Lucas carrier contributes no new
split-free direction outside it.

## 2. The binary pointed-C620 gate

For `p=2`, every first contraction of (2) lands in the degree-nine carrier
closed by C620.  C620 proves every lower carrier point shallow, and its
principal-open construction produces monic eight-root witnesses by a
six-root/final-pair Artin--Schreier curve.  What C620 does not state uniformly
on every invariant stratum is the pointed assertion needed here:

> for a prescribed contraction root `lambda`, the lower carrier syndrome has
> a split squarefree octic avoiding `lambda`.

This is the exact R11 binary gate.  It is strictly smaller than reclassifying
the degree-nine carrier: the unpointed classification, orbit strata, trace
criterion, and `q=16,32` certificates are already proved.  A positive proof
should add one fixed-root resultant to C620's final-pair system and obtain a
uniform Hasse--Weil deletion bound; the finite `q=16,32` bridge, if still
needed, must be a new task-owned pointed certificate rather than an inference
from the unpointed records.

## 3. The characteristic-seven pointed-R10 gate

For `p=7`, every first contraction lands in the proved R10 carrier
`P<e_3,...,e_6>`.  The current R10 proof makes it shallow by contracting at
infinity to the R9 binary-quartic representation and lifting its seven finite
roots with the infinity factor.  Reusing that witness blindly at R11 repeats
the retained marker.

The exact gate is therefore:

> choose the upper contraction marker and the lower R10 characteristic-seven
> lift coherently so that the lower octic avoids the upper marker.

This should be decidable on the existing binary-quartic normal slices by one
fixed-root resultant.  Until that resultant is proved proper and its rational
avoidance bound is recorded, the characteristic-seven block
`P<e_4,e_5,e_6>` is one of the two first unresolved R11 blocks and is the
exact odd-characteristic obstruction.

## 4. Consequence for the all-level programme

The R11 audit rules out a vague digit-pattern search.  The next proof has two
bounded inputs:

1. pointed witness abundance on C620's binary degree-nine carrier; and
2. pointed propriety of the characteristic-seven R10 lift.

Characteristic three already closes asymptotically through the new pointed
simultaneous theorem.  If the two pointed gates close, R11 contributes no new
nonpersistent split-free family above their explicit field bounds.  The next
Lucas level should then be computed only after this pointed recursion is
packaged as a reusable lemma.

No claim is made here for the small binary fields, for characteristic-seven
fields below the future bound, or for an all-digit-pattern theorem.  No
computation or manuscript edit was used.
