# C973 — deterministic extraction from the simultaneous selector

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Status:** theorem proved;
implementation deferred to the classifier successor

## Result

The Vandermonde existence proof is constructive at fixed redundancy.  Given
the explicit nonzero terminal selector, one can choose the `m=r-5` marker
roots successively while preserving symbolic nonvanishing.  This replaces a
search over `q^m` ordered marker tuples by at most `mq` partial-specialization
tests, followed by enumeration of one R5 pencil.

The result is an algebraic extraction theorem, not a claim that arbitrary
redundancy has polynomial complexity in `r`: dense selector size is
exponential in `m`.  For every fixed `r`, it is polynomial in the field size
and input representation.

## 1. Successive-specialization lemma

Let

\[
 Q(x_1,\ldots,x_m)\in\F_q[x_1,\ldots,x_m]                 \tag{1}
\]

be nonzero and satisfy `deg_(x_i) Q < q` for every `i`.  Suppose `Q` is given
in a representation supporting exact partial substitution and a zero-
polynomial test.  Then a tuple `a in F_q^m` with `Q(a) != 0` can be found with
at most `mq` partial substitutions and zero tests.

### Proof

Start with the nonzero polynomial `Q_0=Q`.  At step `i`, regard

\[
 Q_{i-1}=\sum_{j=0}^{d_i}C_j(x_{i+1},\ldots,x_m)x_i^j     \tag{2}
\]

as a polynomial in `x_i` over the integral domain
`F_q[x_(i+1),...,x_m]`.  If the specialization `Q_(i-1)(a,...)` were the zero
polynomial for more than `d_i` distinct values `a`, then (2) would be
divisible by more than `d_i` distinct linear factors in that coefficient
domain, forcing it to be zero.  Thus at most `d_i<q` field values are bad.

Test field values until one leaves a nonzero residual polynomial and fix it
as `a_i`.  After `m` steps the residual is the nonzero scalar
`Q(a_1,...,a_m)`.  At most `q` candidates are tested per variable.

The proof needs symbolic residual nonvanishing.  Pure black-box evaluation at
fully assigned points would not justify the same `mq` bound.

## 2. Application to marker selection

Let `S_f` be the degree-`d` marker selector reconstructed in the companion
two-seam report, with `d<=6`, and let `A` be a prescribed set of `s` rational
roots to avoid.  Work in an affine chart and put

\[
 Q_f=S_f
 \prod_{i<j}(x_i-x_j)
 \prod_{i=1}^m\prod_{a\in A_{\rm aff}}(x_i-a).             \tag{3}
\]

Then

\[
                  \deg_{x_i}Q_f\le d+m-1+s.               \tag{4}
\]

Under the pointed selector bound `q>d+m-1+s`, the successive-specialization
lemma constructs a tuple where (3) is nonzero.  Its roots are pairwise
distinct, avoid `A`, and give terminal syndrome outside the reduced R5
carrier.

For the unpointed main theorem, `d<=6` and `m=r-5`, so the selector phase uses
at most

\[
                              (r-5)q                       \tag{5}
\]

partial-specialization tests after the selector has been expanded.

## 3. Terminal extraction

The selected terminal syndrome has a base-point-free `S_3` cubic pencil.
Enumerate its `q+1` projective members.  Test each cubic for complete
squarefree splitting and reject the at most `m+s` members containing a
forbidden root.  The exact R5 count guarantees success under the pointed
threshold.

Multiplication by the marker product gives the upper locator, and the direct
contraction identity is its exact membership certificate.  Thus the complete
fixed-`r` algorithm has:

- `O(mq)` symbolic partial-selector tests;
- `O(q)` terminal cubic splitting and root-avoidance tests; and
- one direct Hankel membership verification of the returned locator.

Field-operation costs inside a partial-selector test depend on the chosen
representation.  A dense ordered-root representation has at most

\[
                   (d+m+s)^m                              \tag{6}
\]

coefficient slots up to a harmless constant shift.  Hence the theorem is
polynomial in `q` for fixed `r,s`, but no uniform polynomial-in-`r` claim is
made.

## 4. Paper and software boundary

For the mathematics paper, this is at most a corollary or remark after the
Vandermonde lemma: simultaneous escape is effectively witness-producing at
fixed redundancy.  It should not lengthen the main proof.

The classifier successor may use it to replace marker-tuple enumeration only
after:

1. the selector equations and characteristic branch are represented exactly;
2. symbolic zero testing is implemented fail-closed;
3. the proved field and radius domains are preserved; and
4. returned locators pass the existing exact certificate verifier.

C973 makes no software edit and does not broaden C969/C970's theorem registry.
