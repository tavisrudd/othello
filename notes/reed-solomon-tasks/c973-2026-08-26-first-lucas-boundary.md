# C973 checkpoint — first unresolved all-level Lucas block

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Status:** exact R11
reduction and all three asymptotic Lucas blocks proved

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
The three rows are all closed below.  Their different mechanisms identify the
reusable all-level interface: transverse blocks use the pointed simultaneous
theorem, while coherent descendants need a pointed version of the already
proved lower-carrier arithmetic.

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

## 3. Characteristic-seven closure by a pointed R9 slice

For `p=7`, choose the upper contraction marker at infinity.  A syndrome in
`P<e_4,e_5,e_6>` contracts into the proved R10 carrier.  Its marker-collision
divisor is proper in characteristic seven; after the existing exact-gcd route,
the collision and fixed-factor exclusions are contained in the proved R10
parameter budget below `3r-5=25`.  Choose a finite internal R10 marker away
from them.  An affine translation, which fixes the retained point at infinity,
moves that internal marker to zero.  The second contraction lies in the
characteristic-seven R9 binary-quartic carrier `P<e_2,...,e_6>`, and zero is
not a fixed factor of its septic system.

The current R9 rational-base selector has total degree at most `102` in four
ordered finite roots.  In the residual-quadratic notation, at least one
coefficient of `N_u(x)` as a polynomial in the moving root is nonzero on the
base space.  Otherwise every squarefree member parametrized by the nonempty
good-slice open would contain zero, forcing zero to be a fixed factor of the
whole pencil.  Such a coefficient has total base degree at most `8`.
Multiplying the existing selector by this coefficient and by the four factors
which require the fixed roots to avoid zero raises the total degree to at most
`102+8+4=114`.  Hence a good distinct rational base with a nonzero
fixed-root resultant exists for `q>114`.

On the resulting genus-at-most-one moving-root slice, the existing deletion
degree is `32`.  Requiring the moving root to avoid zero removes at most two
points of the double cover.  Requiring neither residual-quadratic root to be
zero is the nonvanishing of

\[
                         N_u(x),                            \tag{8}
\]

after clearing the already deleted determinant; it has degree at most two in
the moving parameter and removes at most four points of the cover.  Thus the
pointed deletion is at most

\[
                              32+2+4=38.                   \tag{9}
\]

For the first characteristic-seven field above the selector bound,
`q=343`,

\[
                         q+1-2\sqrt q>38.                  \tag{10}
\]

The R9 slice therefore gives a split squarefree septic with seven finite
roots, none zero.  Multiplication first by the zero marker gives a finite
split squarefree octic, which avoids the retained upper marker at infinity;
multiplication by that upper marker gives a split squarefree nonic.  Hence

\[
 \mathcal M^{\max}_{11,7}(F_q)
 \cap\operatorname{SplitFree}_{11}(F_q)=\varnothing
 \qquad(q\geq343).                                        \tag{11}
\]

## 4. Consequence for the all-level programme

The R11 audit rules out a vague digit-pattern search.  Characteristics two,
three, and seven close above `128`, `81`, and `343`, respectively.  Thus R11
contributes no new nonpersistent split-free family above those explicit
characteristic-wise bounds.  The next Lucas level should be computed only
after the two reusable operations exposed here are packaged: pointed
simultaneous escape on a transverse contraction, and one-extra-root avoidance
on a coherent lower-carrier slice.

No claim is made here for the small binary fields, for characteristic-seven
fields below `343`, or for an all-digit-pattern theorem.  No computation or
manuscript edit was used.

## 5. Next digit block: exact R12 reduction

For redundancy twelve, `d=r-2=10`.  Lucas' criterion gives

\[
\begin{array}{c|c|c}
p&\text{nonzero positions in Pascal row }10
 &\mathcal M^{\max}_{12,p}\\ \hline
2&\{0,2,8,10\}&\mathbf P\langle e_4,e_5,e_6,e_7\rangle,\\
3&\{0,1,9,10\}&\mathbf P\langle e_3,\ldots,e_8\rangle,\\
5&\{0,5,10\}&
 \mathbf P\langle e_2,e_3,e_4,e_7,e_8,e_9\rangle,\\
7&\{0,1,2,3,7,8,9,10\}&\mathbf P\langle e_5,e_6\rangle.
\end{array}                                                \tag{12}
\]

All other characteristics have empty maximal carrier.  Contraction takes the
three coherent rows to the already computed R11 supports:

\[
\begin{aligned}
\{4,5,6,7\}&\longmapsto\{3,4,5,6,7\} &&(p=2),\\
\{3,\ldots,8\}&\longmapsto\{2,\ldots,8\} &&(p=3),\\
\{5,6\}&\longmapsto\{4,5,6\} &&(p=7).
\end{aligned}                                              \tag{13}
\]

The characteristic-five support is fresh: its contraction support is
`{1,...,4} union {6,...,9}`, while the lower R11 characteristic-five carrier
is empty.  Outside the persistent intersection, choose a contraction away
from the at-most-three persistent parameters and apply the pointed
simultaneous theorem at lower redundancy eleven with one forbidden root.  Its
budget is

\[
 12+6((11-5)+1)=54,
\]

so the integer threshold is `54+2+floor(2 sqrt(54))=70`; the first
characteristic-five field above it is `125`.  Therefore

\[
 (\mathcal M^{\max}_{12,5}\setminus\mathcal P_{12})(F_q)
 \cap\operatorname{SplitFree}_{12}(F_q)=\varnothing
 \qquad(q\ge125).                                         \tag{14}
\]

The exact next obstruction is consequently pointed abundance on the three
R11 coherent constructions: their unpointed witnesses are now proved, but an
R12 lift must avoid one newly retained root.  This is a reusable one-extra-root
gate, not a request for R12 ambient enumeration or new orbit classification.
