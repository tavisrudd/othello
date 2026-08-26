# C969 terminal-hyperplane solver

## Scope

This note closes the absorbed C608 terminal-selector proof gate for
redundancies `r=5,6,7`. It uses the coefficient convention implemented by
`prs_classifier`: a locator is stored low coefficient first, and an affine
root `a` contributes `T-aU`.

Assume increasing-degree search has found no locator through degree `r-2`.
Put `d=r-4`, so `d` is respectively 1, 2, or 3. The terminal selector
enumerates the distinct projective supports of a degree-`d` prefix `P`, then
completes `P` by three roots. Prefix enumeration therefore has sizes

\[
 {q+1\choose d}=O(q),\quad O(q^2),\quad O(q^3).
\]

The implementation streams these supports and never materializes that set.

## Bilinear completion

First work in an affine chart and write

\[
 P=\prod_{i=1}^{d}(T-a_iU),\qquad
 C=(T-xU)(T-yU)(T-zU).
\]

If `s=(s_0,...,s_{r-1})` is the syndrome and
`P=sum p_i T^i U^(d-i)`, define

\[
 u_j=\sum_{i=0}^{d}s_{i+j}p_i\quad(0\leq j\leq3).
\]

The terminal Hankel equation is `sum u_j c_j=0`, where `c_j` are
the low-first coefficients of `C`. Fixing `x` turns it into

\[
 A yz+B(y+z)+C_0=0,
\]

with

\[
 A=-u_0x+u_1,\qquad B=u_1x-u_2,\qquad C_0=u_3-u_2x.
\]

Thus, with `D=Ay+B` and `N=By+C_0`, the last root is

\[
 z=-N/D.
\]

When `D=N=0`, every `z` solves the equation; the executable selector retains
every grid value distinct from the other roots. When `D=0` and `N!=0`, that
pair has no completion.

## Collision divisor and the 12-point grid

For the nondegenerate branch, all unwanted collisions are cut out by

\[
 D,\quad N+xD,\quad N+yD,\quad
 \prod_i(N+a_iD).
\]

Multiplying these by

\[
 \prod_{i<j}(a_i-a_j)(x-y)
 \prod_i(x-a_i)(y-a_i)
\]

gives a collision polynomial `F_s(a_1,...,a_d,x,y)`. In every variable its
degree is at most

\[
 2d+5\leq11.
\]

For an `a_i`, the factor groups contribute
`1+1+1+(d+1)+2+(d-1)=2d+5`; the `x` and `y` counts are the same.

At least one of the two projective charts makes `F_s` nonzero. Indeed, `D`
is identically zero in the displayed chart exactly when the first `r-1`
syndrome coordinates vanish; coordinate reversal handles that remaining
nonzero coordinate. Every other factor is nonzero: specializing it to zero
would say that the syndrome functional vanishes on all products with a named
double root. Over the algebraic closure those products span the full binary
form space--choose the prefix and repeated/single factors to obtain each
monomial--so this would force the syndrome itself to vanish. The remaining
Vandermonde factors are visibly nonzero. Since the polynomial ring is an
integral domain, their product is nonzero.

The elementary Cartesian-grid lemma says that a nonzero polynomial whose
individual variable degrees are smaller than the corresponding set sizes
cannot vanish on the whole grid. For `q>=13`, enumerate each `a_i` over
`F_q` and take `x,y` from any fixed set of 12 field elements. The degree
bound therefore supplies a prefix and a collision-free completion. The Rust
encoding uses elements `0,...,11` as that fixed set. Trying the reversed
coefficient chart covers the infinity root: under `T<->U`, zero and infinity
are exchanged and a nonzero affine root `a` becomes `a^-1`.

There is no field of order 12. For every remaining case `q<=11`, the same
grid is the entire field. The generic degree-`r-1` projective-hyperplane
enumerator is retained as the explicit bounded small-field branch. It also
remains a defensive correctness oracle if the optimized selector returns no
candidate.

## Exactness and operation count

Each terminal split locator produces the unique Vandermonde solution on its
support. If a recovered magnitude were zero, deleting that column would give
a representation of weight at most `r-2`, contradicting the exhausted lower
search. Hence the first terminal support found after that search is a valid
weight-`r-1` certificate.

The selector performs at most two 12-by-12 chart grids per prefix, with at
most 12 choices of `z` only on a degenerate pair. All polynomial arithmetic,
root checks, and magnitude recovery have degree bounded by seven. Suppressing
fixed-degree factorization and bounded-`r` work, the field-operation bounds
are therefore

\[
 O(q),\qquad O(q^2),\qquad O(q^3)
\]

for `r=5,6,7`. The lower-degree searches obey the same bounds. After failure
of degree `r-2`, the relevant projective kernel bounds are the cubic pencil
for R5, the quartic projective plane for R6, and the quartic plane plus quintic
three-space for R7. They follow from the Hankel rank being at least two; rank
below two would already supply a lower-degree locator.

If search also fails at degree `r-1`, choose any `r` distinct NRC columns.
Their projective Vandermonde matrix is invertible. Its solution cannot have a
zero coefficient, since that would be a locator-supported representation of
weight at most `r-1`. This proves the final weight-`r` branch used by the
exact decoder. It does not turn the R7 `q=7,9` radius gaps into a false claim.
At q=8, however, its exhaustive terminal replay resolves every frozen and
persistent orbit: only the diagonal tangent and central nucleus reach seven.

## Regression boundary

Tests independently replay terminal certificates for the R5 tangent, both R6
persistent representatives, and the frozen R7 representative. They also
exhaust all 781 projective R5 syndromes over `F_5`, requiring the fast
terminal selector whenever degree-three search fails. These tests are
regression evidence only; the grid argument above is the proof.
