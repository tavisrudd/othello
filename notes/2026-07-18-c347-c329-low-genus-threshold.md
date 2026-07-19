# C347: ordered-root quotients lower the C327/C329 odd-tower thresholds

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `THEOREM; 2^41 -> 2^39 AND 2^45 -> 2^43`.

## Result

C327 and C329 count simultaneous no-root specializations of two correlated
pentics by applying effective Chebotarev to their full `S5 times S5` Galois
closure.  The respective legality covers have degrees `d=16` and `d=64`; the
full closures have genus at most `455701` and `1838101`.  Their Hasse--Weil
terms, not the skeleton opens or finite deletions, set the published odd-tower
thresholds `2^41` and `2^45`.

The full closure is unnecessary for existence.  Fifth-order Bonferroni on the
ten rational-root events uses only the geometrically connected ordered-root
quotients marking `a` roots of the first pentic and `b` roots of the second,
with

```text
1 <= a+b <= 5.
```

These quotient covers have degree at most `1200`, rather than `14400`.  Direct
Hasse--Weil bounds on the twenty quotients give the following improved lower
bounds for legal common translations `h`, after all finite branch points and
the two seed-zero values are deleted:

```text
C327, d=16:
  N_h >= (Q+1-395983*sqrt(Q))/240 - 1042.              (1)

C329, d=64:
  N_h >= (Q+1-1602703*sqrt(Q))/960 - 1030.             (2)
```

Consequently C327's simultaneous-pentic theorem holds on the odd tower for
`Q>=2^39`, and C329's collision-free four-layer arc theorem holds on the odd
tower for `Q>=2^43`.  The other hypotheses and conclusions of C327 and C329
are unchanged.  In particular, C329 remains a fresh-per-field existence
theorem and does not acquire relative completeness.

## First falsifier: what set the old thresholds

C327's lower bound was

```text
(121/14400)*(Q+1-911402*sqrt(Q)) - 65/16 - 2,          (3)
```

where `911402=2*455701`.  C329's was

```text
(121/57600)*(Q+1-3676202*sqrt(Q)) - 257/64 - 2,        (4)
```

where `3676202=2*1838101`.  In both cases the skeleton-open requirement
(`Q>732` or `Q>1470`) and constant deletions are tiny compared with the
quadratic inequality forced by `2g*sqrt(Q)`.  The old thresholds are therefore
genuinely genus-driven.

C329's jump by four binary exponents is also structural.  Enlarging the
legality cover from degree sixteen to degree sixty-four replaces the `64`
finite geometric branch points of the pentic compositum by `256`, raising the
full-closure genus by approximately a factor of four.

## The quotient curves

Fix either C327 or C329 and let `C` be its rational legality curve.  Consume
their proved geometrically connected `S5 times S5` splitting cover `M/C`, its
constant field `F`, its four finite pentic branch values before legality base
change, and its infinity filtration.  Put `d=16` for C327 and `d=64` for C329.

For `0<=a,b<=5`, let `X_(a,b)` be the quotient of `M` that marks an ordered
`a`-tuple of distinct roots of the first pentic and an ordered `b`-tuple of
distinct roots of the second.  Its degree is

```text
n_(a,b)=(5)_a*(5)_b.                                  (5)
```

The product group acts transitively on these tuples, so every `X_(a,b)` is
geometrically connected and has constant field `F`.  It is therefore an
absolutely irreducible curve to which Hasse--Weil applies directly.

There are `2d` finite transposition branch points for each pentic factor.  A
transposition in the first factor fixes

```text
f_1=(3)_a*(5)_b                                        (6)
```

marked tuples, and a transposition in the second fixes

```text
f_2=(5)_a*(3)_b,                                       (7)
```

with `(3)_j=0` for `j>3`.  Since the lower filtration at a finite branch point
is `C2,C2,1`, its different contribution on the quotient is `n-f_i`.
Therefore the total finite contribution is exactly

```text
Delta_fin=2d*((n-f_1)+(n-f_2)).                        (8)
```

At infinity C327/C329 prove either `I_0=A4,I_1=V4` or
`I_0=(V4 times V4) semidirect C3,I_1=V4 times V4`; in both cases
`|I_0:I_1|=3` and `I_2=1`.  For any permutation quotient its infinity
contribution is

```text
(n-#orbits(I_0))+(1/3)*(n-#orbits(I_1)) < 4n/3.        (9)
```

Riemann--Hurwitz, (8), (9), and integrality now give the uniform explicit
bound

```text
g_(a,b) <= floor(1+Delta_fin/2-n/3).                   (10)
```

For `a+b<=5`, the maximum degree is `1200`.  The largest bound in (10) is
`30321` for `d=16` and `122481` for `d=64`, both far below the corresponding
full-closure genus.

## Fifth-order Bonferroni

Delete from `C(F)` the `4d` finite branch points and infinity, leaving `U`.
For `c in U`, let `r_1(c),r_2(c)` be the numbers of rational roots of the two
pentics and put `R(c)=r_1(c)+r_2(c)`.  The exact fifth Bonferroni inequality is

```text
1_(R=0) >= sum_(k=0)^5 (-1)^k*binom(R,k).              (11)
```

Indeed the right side is `1` for `R=0` and `-binom(R-1,5)<=0` otherwise.
Vandermonde expands

```text
binom(R,k)=sum_(a+b=k) binom(r_1,a)*binom(r_2,b).       (12)
```

Over the unramified locus, rational points of `X_(a,b)` are exactly ordered
tuples of `a` distinct rational roots of the first pentic and `b` of the
second.  Thus the sum in (12) is counted by

```text
#X_(a,b)(F)/(a!*b!).                                   (13)
```

The main coefficient through order five is

```text
sum_(a+b<=5) (-1)^(a+b)/(a!*b!) = 1/15.               (14)
```

For comparison, exact `S5 times S5` derangement density is `121/900`; the
Bonferroni main term is smaller but positive.

Apply the lower Hasse--Weil bound to the positive terms of (11) and the upper
bound to its negative terms.  The weighted genus sums from (10) are

```text
d=16: sum g_(a,b)/(a!*b!) <= 395983/30,
d=64: sum g_(a,b)/(a!*b!) <= 1602703/30.               (15)
```

For positive nonconstant terms, `a+b` is two or four.  Their total quotient
degree after division by `a!*b!` is

```text
binom(10,2)+binom(10,4)=45+210=255.                    (16)
```

Including the base term, deleting at most `4d+1` points therefore costs at
most `(4d+1)*256` points on the legality curve.  Divide by `d`, since every
acceptable translation has exactly `d` rational legality lifts, and delete the
two seed-zero translations.  Equations (14)--(16) give (1)--(2).

For the exact odd-tower endpoint, positivity of

```text
Q+1-A*sqrt(Q)-B
```

at odd `Q=2^e` is checked without floating point: when `Q+1-B>0`, square and
compare `(Q+1-B)^2` with `A^2*Q`.  The certificate records a negative margin
at `e=37` and positive margin at `e=39` for (1), and a negative margin at
`e=41` and positive margin at `e=43` for (2).  The expressions are increasing
thereafter.

## Why the proposed `(k,n)`-arc transfer stops

Korchmaros--Nagy--Szonyi, [*Algebraic approach to the completeness problem for
`(k,n)`-arcs in planes over finite fields*](https://arxiv.org/abs/2302.10162),
start from the full rational point set of an absolutely irreducible degree-`n`
curve with a transversal `n`-secant.  Their introduction explicitly separates
the established `n=2` theory from the `n>=3` curve programme, and their concrete
Hasse--Weil arguments concern Hermitian and rational BKS curves of degree
`q+1`.  C329 is a selected `2Q+Q+Q` subset of a reducible three-conic pencil in
characteristic two.  The full-rational-locus, absolute-irreducibility, and
degree/arc-parameter hypotheses all fail.  Thus that machinery does not
transfer to C329's rigid `n=2` setting.

This failure does not block the ordered-root quotient argument: its absolutely
irreducible curves are covers of the already proved C327/C329 legality line,
not a replacement carrier curve for the arc itself.

## Literature boundary

- Bary-Soroker--Entin, [*Explicit Hilbert's Irreducibility Theorem in Function
  Fields*](https://doi.org/10.1090/conm/767/15402), bound reducible
  specializations among tuples of monic polynomials of degree `d` by
  `O(d q^(-d/2))`.  That parameter space is not C327/C329's single scalar
  translation with four or six Artin--Schreier trace constraints, so it does
  not provide these constants or thresholds.
- Kosters, [*A short proof of a Chebotarev density theorem for function
  fields*](https://arxiv.org/abs/1404.6345), is the effective Frobenius-twist
  baseline used by C327/C329.  C347 does not improve that theorem; it avoids
  paying for the full Galois closure by applying ordinary Hasse--Weil to smaller
  transitive quotients.
- Korchmaros--Nagy--Szonyi is the closest thematic Hasse--Weil arc source, but
  the preceding object-level mismatch blocks transfer.  The exact C347
  contribution is instead the ordered-root/Bonferroni reduction for the two
  correlated C316 pentics.

No priority is claimed for Bonferroni sieves, ordered-root covers, quotient
curves, or Hasse--Weil.  The construction-specific theorem is the application
of those standard tools to C327/C329's exact monodromy and inertia data, with
the explicit bounds (1)--(2).

## Reproducibility and trusted boundary

The proof consumes C327/C329's `S5 times S5` monodromy, constant-field,
finite-branch, and infinity-filtration theorems read-only.  C347 independently
proves the quotient different and Bonferroni reduction above; it does not
recompute the pentic equations or monodromy.

The adjacent deterministic generator records all twenty quotient rows for each
legality degree, exact rational weighted-genus sums, boundary constants, and
integer-squared threshold margins.  It also independently enumerates all
`120^2=14400` elements of `S5 times S5`, obtaining Bonferroni density `1/15`
and exact derangement density `121/900`.

Regenerate from `/home/tavis/src/othello` with

```text
python3 notes/2026-07-18-c347-c329-low-genus-threshold.py \
  --output notes/2026-07-18-c347-c329-low-genus-threshold.json
```

Replay without changing the worktree with

```text
python3 notes/2026-07-18-c347-c329-low-genus-threshold.py --check
```

The committed checksum manifest is
`notes/2026-07-18-c347-c329-low-genus-threshold.sha256`.  Its recorded files are:

| artifact | bytes | SHA-256 |
|---|---:|---|
| generator | `6376` | `c1b43fc51ef24a4c7bfb37bd1572c5274934459497041fa600c3b3cb7f0d4d8f` |
| JSON certificate | `12657` | `bfb7b0c4a716b88935af56d5a1544eeb8b995760392a0b3e1a04954113c098a2` |

The generator was replayed with Python `3.13.12`; its trusted arithmetic boundary is Python integer
arithmetic, `fractions.Fraction`, and exhaustive permutation enumeration. It does not
certify the imported C327/C329 geometry; the report states that boundary
explicitly.

## Vibe check

Strong result.  The huge thresholds were not intrinsic to the construction;
they were largely the price of asking the full Galois closure an existence-only
question.  A small exact sieve removes two binary exponents from each theorem
without changing the geometry or relying on a speculative `n=2` transfer.
