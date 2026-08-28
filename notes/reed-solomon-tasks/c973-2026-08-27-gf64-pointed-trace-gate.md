# C973 checkpoint — structural GF(64) pointed trace gate

**Lane:** `reed-solomon` · **Date:** 2026-08-27 · **Status:** exact reduction
proved; one quadratic trace-selector lemma remains

## 1. Outcome

The remaining binary R11 field must not be attacked by copying the GF(32)
quotient.  A marked-root normalization and the C620 final-pair construction
reduce pointed shallowness over GF(64) to one explicit arithmetic statement:

> For every nonzero coherent contraction syndrome, choose five distinct
> nonzero fixed roots satisfying the existing C620 selector such that the
> resulting quadratic final-product numerator `N(x)` has no GF(64)-root.

If this trace-selector lemma holds, every R11 Lucas-carrier syndrome over
GF(64) has a split squarefree locator avoiding an arbitrary prescribed root.
One-marker lifting then closes the binary R12 carrier as well.

This is a structural reduction.  No GF(64) carrier or orbit census is run,
and no manuscript or software path is changed.

## 2. Coherent contraction hyperplane

Normalize the forbidden R11 root to zero and take the contraction marker at
infinity.  The infinity polar of

\[
 f\in\mathbf P\langle e_3,e_4,e_5,e_6,e_7\rangle
\]

lies in the C620 R10 carrier with

\[
                       z_2=0.                              \tag{1}
\]

If that polar is zero, choose another marker distinct from the forbidden
root; a nonzero divided-power tensor cannot have every first contraction
zero.  After a projective change of coordinates the same marked-pair
normalization applies.  It therefore suffices to treat nonzero points of (1).

For the lower octic choose five fixed finite roots, a sixth moving root `x`,
and a final quadratic.  Retain C620's notation

\[
 A_j=B_j+xB_{j+1},\quad
 \Delta=A_1A_3+A_2^2,\quad
 Q=A_0A_3+A_1A_2,\quad
 N=A_1^2+A_0A_2.                                          \tag{2}
\]

Here `B_j=\sum_{i=3}^{7}z_ig_{i+j-4}` is the syndrome functional applied to the
five-root quintic `g`, and `j` runs from 0 to **four**: `Delta` and `Q` both
depend on `B_4=\sum_{i=3}^{7}z_ig_i`, which is not zero in general, and only
`N` is a function of `B_0,\ldots,B_3` alone.  Always display `B_4` alongside
`(B_0,B_1,B_2,B_3)` when specializing a chart; omitting it is what produced the
error repaired in section 6.2 of the companion trace-balance note.

On `Delta Q != 0`, the final-pair sum and product are

\[
                   s=Q/\Delta,\qquad p=N/\Delta,           \tag{3}
\]

and rational splitting is the geometrically integral Artin--Schreier curve

\[
                   y^2+y=N\Delta/Q^2.                     \tag{4}
\]

The five-root selector still has coordinatewise degree at most 22.  Requiring
the fixed roots to avoid zero multiplies it by one linear factor in each
variable, so degree at most 23 remains below 64.  Thus the geometric slice
can be chosen with five distinct nonzero fixed roots.  It remains genus at
most one.

## 3. Sharp pointed deletion count

C620's unpointed deletion table has total base-coordinate degree 23 and used
the uniform bound of two cover points over every deleted coordinate, plus two
over infinity.  For the selected integral curve, the zeros of `Q` are the
simple poles after Artin--Schreier reduction.  Each such geometric base point
has one ramified point above it, not two.  Hence the exact geometric bound is

| condition | rational points removed |
|---|---:|
| moving root equals one of five fixed roots | at most 10 |
| `Q=0` | at most 2 |
| `Delta=0` | at most 4 |
| a final root equals a fixed root | at most 20 |
| a final root equals the moving root | at most 8 |
| points above infinity | at most 2 |
| moving root equals the forbidden root zero | at most 2 |
| **total before final-root avoidance** | **at most 48** |

The final pair contains zero exactly when its product vanishes, hence, away
from the already deleted denominator,

\[
                            N(x)=0.                        \tag{5}
\]

If `N(x)` has no rational root, (5) costs no rational point.  The genus-one
Hasse lower bound at `q=64` is

\[
                    64+1-2\sqrt{64}=49>48.                \tag{6}
\]

Therefore a rational point survives every collision and both occurrences of
the prescribed root.  Its finite octic avoids zero and infinity; multiplying
by the retained infinity marker gives the required pointed nonic.

The sharpening of the table above --- charging the zeros of `Q` one cover point
each instead of the two that C620's unpointed table charged, so that the two
`Q`-fibres contribute 2 rather than 4 --- is structural: it uses ramification at
the simple poles, not a favorable finite-field count.  The same remark applies
to a rational ramified point at infinity when one occurs, which lowers the
`infinity` row from 2 to 1.

## 4. The one-bit selector

Write

\[
                    N(x)=n_2x^2+n_1x+n_0.                 \tag{7}
\]

From (2), in characteristic two,

\[
\begin{aligned}
n_0&=B_1^2+B_0B_2,\\
n_1&=B_0B_3+B_1B_2,\\
n_2&=B_2^2+B_1B_3.
\end{aligned}                                             \tag{8}
\]

Because Frobenius is bijective, a nonconstant quadratic with `n1=0` has a
rational root.  When `n1 != 0` and `n2 != 0`, (7) is rootless exactly when

\[
 \operatorname {Tr}_{\mathbf F_{64}/\mathbf F_2}
       \left(\frac{n_0n_2}{n_1^2}\right)=1.               \tag{9}
\]

The other rootless case is `n2=n1=0`, `n0!=0`, when `N` is a nonzero
constant.  Thus GF(64) pointed closure is reduced to selecting the five fixed
roots on the existing nonempty C620 selector open while satisfying the single
trace condition (9), or the constant alternative.

This is the exact next lemma.  It should be attacked as an Artin--Schreier
cover of the five-root selector space, preferably by fixing four roots and
proving that the remaining one-variable trace function is not of the form
`H^2+H+c`.  A bounded calculation may falsify a proposed specialization, but
cannot replace that nonconstancy proof.

## 5. Structural-compression verdict

The GF(16)/GF(32) certificates do not compress to a small divisor atlas: the
exact audit finds 55 and 795 affine support types.  Nor does the natural
affine-three-space-plus-one family cover: it misses 168 and 503 marked orbits.
Those failures explain why support-shape mining is low EV.

The final-pair equations compress the same evidence correctly.  They replace
thousands of marked orbits by the universal equations (2)--(4), the sharp
48-point deletion budget, and one trace bit (9).  If (9) is proved selectable,
the GF(16)/GF(32) certificates remain useful calibration but cease to be
load-bearing for the uniform binary statement.

## 6. `ej` + `tt` and mystery ledger

The `ej` pass used the coherent-contraction restriction `z2=0` and counted
ramified `Q=0` fibres singly, recovering exactly the six-point budget needed
for prescribed-root avoidance at q=64 once `N` is rootless.

The `tt` pass rejected a 17-million-point GF(64) carrier quotient and the
tempting small-support hypotheses.  It asks for the arithmetic reason that
the trace bit (9) can be made odd on every syndrome stratum.

| mystery | status | exact next gate |
|---|---|---|
| Why did the old q=64 Hasse margin look too small? | settled; uniform two-point charging overcounted the ramified `Q=0` fibres by two, while pointed avoidance costs six | sharp table above |
| What exact condition prevents the final pair from using zero? | settled; `N(x)` must be rootless | equations (7)--(9) |
| Is rootlessness Zariski-open? | no; over GF(64) it is an Artin--Schreier trace condition | prove trace nonconstancy on a selector slice |
| Can support-orbit compression replace the trace proof? | no | exact GF(16)/GF(32) negative audit |
| Does this already prove GF(64)? | no | the trace-selector lemma remains load-bearing |
| What happens after that lemma? | binary R11 becomes pointed and binary R12 shallow for every admissible binary field | combine GF(16)/GF(32), q=64, and q>=128 |

Vibe: the remaining binary problem is now one explicit arithmetic bit rather
than thousands of orbits; this is the right structural frontier.
