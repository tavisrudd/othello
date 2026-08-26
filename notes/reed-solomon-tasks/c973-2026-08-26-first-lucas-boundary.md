# C973 checkpoint — first unresolved all-level Lucas block

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Status:** exact R11
reduction proved; binary and characteristic-three blocks closed
asymptotically; one characteristic-seven pointed gate remains

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
Lucas union: after the binary argument below, it is the pointed-witness
problem on the already known characteristic-seven lower carrier in the third
row of (3).

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

## 2. Binary closure from the affine C620 constructions

For `p=2`, contract at infinity.  A syndrome supported on
`{3,...,7}` remains nonzero and contracts into
`M^max_(10,2)=P<e_2,...,e_7>`.  Every proof stratum of the lower carrier has
an affine, monic degree-eight witness for `q>=128`:

- C530's graph construction uses monic three-space subspace polynomials;
- C531's off-graph construction uses the finite inverses of the seven
  nonzero points of a three-space, again giving eight finite roots;
- C578's rank-two construction is the monic six-root/final-pair system for
  every `q>=128`; and
- C620's two-moduli complement construction is the same monic system and is
  already uniform from `q>=64`.

Thus the lower octic avoids infinity.  Multiplication by the upper infinity
marker gives a split squarefree nonic in the R11 kernel.  Therefore

\[
 \mathcal M^{\max}_{11,2}(F_q)
 \cap\operatorname{SplitFree}_{11}(F_q)=\varnothing
 \qquad(q\geq128).                                        \tag{7}
\]

The fields `q=16,32,64` are not inferred from the unpointed certificates.
Closing them would require checking that a certified lower witness can be
chosen away from the prescribed upper marker, or producing a new compact
pointed certificate.  This finite bridge does not affect the asymptotic R11
theorem.

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

The R11 audit rules out a vague digit-pattern search.  The sole remaining
asymptotic input is pointed propriety of the characteristic-seven R10 lift.
Characteristics two and three close above `128` and `81`, respectively.  If
the characteristic-seven gate closes, R11 contributes no new nonpersistent
split-free family above the maximum of the three explicit field bounds.  The
next Lucas level should then be computed only after this pointed recursion is
packaged as a reusable lemma.

No claim is made here for the small binary fields, for characteristic-seven
fields below the future bound, or for an all-digit-pattern theorem.  No
computation or manuscript edit was used.
