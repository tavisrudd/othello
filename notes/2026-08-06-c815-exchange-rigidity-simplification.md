# C815 — a shorter proof of balanced exchange rigidity, and the manuscript edit it proposes

**Date:** 2026-08-06
**Task:** C815
**Lane:** `clebsch`
**Status:** the new argument is formalized and gated
(`RelativeConicArcs.BalancedExchangeRigidity.not_forall_sum_closedFourWalkWeight_eq`); the
manuscript edit below is a proposal for the Paper III integration task and is
not applied

## The point

Paper III's balanced exchange rigidity theorem closes its main direction —
cut-independence of the second exchange moment forces `d ≤ 3` — by normalizing
the conference matrix at a root, reading the four-set weight on a rooted
four-set as `xy + xz + yz`, and then splitting into a monochromatic case
excluded by a row inner product and a triangle-free case excluded by
`R(3,3) = 6`.

That case split is unnecessary. Once the four-set weight is known to be
constant, applying the fourth-trace count to the *whole* matrix instead of to a
half determines the constant outright, and the two exceptional orders fall out
of one linear equation. The switching normalization and the Ramsey bound both
disappear from this proof, and what replaces them identifies order six rather
than merely excluding the other orders.

## The argument in prose

Let `C` be a symmetric conference matrix of order `N`: zero diagonal, entries
`±1`, and `C² = qI`. Reading the diagonal of `C² = qI` gives `q = N - 1`, so
`tr(C⁴) = N(N-1)²`.

Sorting the closed four-walks of `C` by the size of their support gives, for
any set of labels and in particular for all `N` of them,

```
tr(C⁴) = N(N-1) + 12·C(N,3) + 8·Σ_K w(K),
```

the sum running over the four-element subsets and `w(K)` being the sum of the
three signed Hamilton-cycle products of `K`, which is `3` when `K` is aligned
and `-1` otherwise.

Suppose every four-set carries the same weight `w`. Then

```
N(N-1)² = N(N-1) + 12·C(N,3) + 8w·C(N,4).
```

Now `N(N-1)² - N(N-1) = N(N-1)(N-2)` and `12·C(N,3) = 2N(N-1)(N-2)`, so the
left side collapses to `-N(N-1)(N-2)`, while `8·C(N,4) = N(N-1)(N-2)(N-3)/3`.
Dividing by `N(N-1)(N-2)`, which is nonzero for `N ≥ 3`, leaves

```
(N - 3)·w = -3.
```

Since `w` is `3` or `-1`, either `w = 3` and `N = 2`, or `w = -1` and `N = 6`.
So a symmetric conference matrix of order `N ≥ 7` cannot have all its four-set
weights equal — and at the one surviving order the equation also tells us which
constant it must be: at `N = 6` every four-set carries weight `-1`, so the
order-six conference matrix has no aligned four-set at all. Direct computation
on the normalized order-six matrix agrees: rooted four-sets have weight
`xy + xz + yz = -1` for each pentagon sign pattern that occurs, and the
four-sets inside the pentagon give `-1 + 1 - 1 = -1`.

For the theorem this means: if the second exchange moment is independent of the
balanced half `Y`, then the aligned counts `c_Y` agree, hence by the swap
descent the four-set weight is constant, hence `(2d - 3)w = -3`, hence
`2d ∈ {2, 6}`, hence `d ≤ 3`.

## What is formalized

`RelativeConicArcs.BalancedExchangeRigidity.not_forall_sum_closedFourWalkWeight_eq`: for a
symmetric zero-diagonal sign matrix with `C * C = q • 1` on `2d` labels with
`4 ≤ d`, over a commutative ring of characteristic zero with no zero divisors,
the fourth walk sums

```
Σ_{i,j,k,l ∈ Y} C i j * C j k * C k l * C l i
```

over the balanced halves `Y` are not all equal. That sum is the fourth trace of
the principal block on `Y`; the passage from it to the second exchange moment
is the spectral step, which remains unformalized.

The proof uses `ConferenceCutBlocks.sum_closedFourWalkWeight_eq_add_sum_powersetCard` for
the support-sorted count on a half and on all labels,
`ConferenceCutBlocks.closedFourWalkSum_eq_of_sum_eq` for the swap descent,
`ConferenceCutBlocks.closedFourWalkSum_eq_twentyFour_or_neg_eight` for the
dichotomy, and `ConferenceCutBlocks.trace_mul_self` for `q = N - 1`. In the
Lean normalization the four-set weight is `8w`, so the pinning equation reads
`(N - 3)·(8w) = -24`.

## Proposed manuscript edit

In `papers/clebsch-passages/sections/05-golden-operator.tex`, the closing
paragraph of the proof of the balanced exchange rigidity theorem currently
reads:

> Suppose now that \(d\geq4\) and even the second exchange moment is
> independent of \(Y\).  Then the sums of the aligned-four-set indicator over
> all balanced halves are equal.  The characteristic-zero inclusion matrix from
> four-sets to \(d\)-sets has full column rank
> \cite[Theorem~1]{JolliffeInclusion}; hence the indicator itself is constant on
> four-sets.  Switch \(C\) so that all edges incident with one vertex
> \(\infty\) are positive.  On \(\{\infty,i,j,k\}\), if the remaining edge signs
> are \(x,y,z\), then \(w=xy+xz+yz\).  If the common value is \(3\), every
> triangle on the other \(2d-1\) vertices is monochromatic.  All its edges have
> one sign, making the inner product of two corresponding conference rows equal
> to \(2d-2\), a contradiction.  If the common value is \(-1\), that
> two-colouring has no monochromatic triangle; the elementary equality
> \(R(3,3)=6\) gives \(2d-1\leq5\), again a contradiction.

Proposed replacement:

```tex
Suppose now that \(d\geq4\) and even the second exchange moment is independent
of \(Y\).  Then the sums of the aligned-four-set indicator over all balanced
halves are equal, and the indicator is therefore constant on four-sets.  Only
this consequence of the rank formula for inclusion matrices
\cite[Theorem~1]{JolliffeInclusion} is needed, and it follows from a
one-element exchange: two balanced halves differing in \(a\) versus \(b\) have
equal sums, so
\[
 \sum_{\substack{S\subset Y\cap Y'\\ |S|=3}}
   \bigl(f(S\cup\{a\})-f(S\cup\{b\})\bigr)=0
\]
for the aligned indicator \(f\).  That is the same hypothesis one subset size
lower, for the difference function on the remaining \(2d-2\) points; descending
on the subset size makes the difference vanish pointwise, and one-element
exchanges connect all four-sets.

Let \(w\) be the common value of \(w(K)\) and apply the closed-walk count to
the whole matrix rather than to a half.  Reading the diagonal of \(C^2=qI\)
gives \(q=2d-1\), so \(\operatorname{tr}(C^4)=2d(2d-1)^2\), while the count
gives
\[
 \operatorname{tr}(C^4)=2d(2d-1)+12\binom{2d}3+8w\binom{2d}4 .
\]
Since \(2d(2d-1)^2-2d(2d-1)-12\binom{2d}3=-2d(2d-1)(2d-2)\) and
\(8\binom{2d}4=2d(2d-1)(2d-2)(2d-3)/3\), dividing by
\(2d(2d-1)(2d-2)\neq0\) leaves
\[
 (2d-3)\,w=-3 .
\]
Hence \(w=3\) forces \(2d=2\) and \(w=-1\) forces \(2d=6\), and neither is
compatible with \(d\geq4\).  At the surviving order the same equation says
that every four-set of the order-six conference matrix carries weight \(-1\),
so that matrix has no aligned four-set.
```

Notes for whoever applies it:

- The replacement is shorter than the text it replaces and removes the
  switching normalization and the appeal to `R(3,3)=6` from this proof. The
  Ramsey bound is still used in the aligned-design part of the paper and its
  citation there is unaffected.
- The Jolliffe citation is kept, now as attribution for the general rank
  formula rather than as the step the proof depends on. That matches the Lean
  surface, where the descent is proved and the rank formula is not used.
- The last sentence is new information rather than a restatement: the same
  equation that excludes the large orders identifies the exceptional one.
- The verification section's claim rows for this theorem should move from
  partial to full mechanism coverage for everything except the spectral
  translation, which is still not formalized.
