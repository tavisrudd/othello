# C227 pointed Tutte identification for complete repair

**Lane:** `rp-next`
**Status:** COMPLETE — strong GO for the unbounded rank-jump port; exact filtered-refinement
boundary for bounded repair radius.

## Result at a glance

The distinguished-coordinate rank-jump polynomial is standard.  Let `M` be a matroid on
`E=V union {x}`, with `x` neither a loop nor a coloop, and put

```text
epsilon_x(A)=r_M(A union {x})-r_M(A),       A subset V.
```

Then the one-element set-pointed Tutte polynomial of `M` is exactly the Las Vergnas polynomial of
the elementary perspective

```text
D=M\x  -->  C=M/x.
```

Its third subset-expansion exponent is `epsilon_x(A)`: exponent zero is successful repair and
exponent one is failure.  Thus full repair reliability is not merely Tutte-like and needs no new
pointed invariant.

Two useful consequences pass the promotion gate.

1. Pointed duality exchanges repair with failure.  Minimal failure blockers for `(M,x)` are the
   minimal repair sets for `(M*,x)`, and

   ```text
   R_(M,x)(s) + R_(M*,x)(1-s) = 1.
   ```

2. If `U_K(u,y)=sum_A u^|A| y^r_K(A)` is the ordinary rank polynomial, then the successful-set
   enumerator is already the derivative difference of the two minors:

   ```text
   S_x(u) = d/dy [U_(M\x)(u,y)-U_(M/x)(u,y)] at y=1.
   ```

This is the exact bridge to Mazumdar's local-code rank polynomial.  His unpointed polynomial for
one local code does not distinguish a coordinate, but the deletion/contraction pair does.

The boundary is equally exact: the standard pointed polynomial sees **all** circuits through `x`.
It does not remember a repair-radius cutoff.  The C218 harmonic radius-four curves are therefore a
genuine filtered refinement, and the q=9 check below measures precisely what the unfiltered
polynomial adds.

## Standard identification

Write `r=r(M)=r(D)` and `r(C)=r-1`.  For every `A subset V`, contraction gives

```text
r_D(A)=r_M(A),
r_C(A)=r_M(A union {x})-1,
r_D(A)-r_C(A)=1-epsilon_x(A).
```

The rank drop of `D --> C` is one, so the Las Vergnas subset expansion becomes

```text
T_(D->C)(X,Y,Z)
 = sum_(A subset V)
     (X-1)^(r(C)-r_C(A))
     (Y-1)^(|A|-r_D(A))
     Z^(1-(r_D(A)-r_C(A)))

 = sum_(A subset V)
     (X-1)^(r-r_M(A union {x}))
     (Y-1)^(|A|-r_M(A))
     Z^epsilon_x(A).                                      (1)
```

Equation (1) is also Las Vergnas's one-element set-pointed polynomial `T_(M;x)`.  The
identification is literal, including normalization, not only an equality after setting `Z=1`.

The excluded degenerate cases are harmless.  If `x` is a coloop, it is never repairable and
`R=0`; if `x` is a loop, it is always in every closure, but projective code columns are nonloops.

## Reliability and the rank-polynomial identity

Define the cardinality/rank-jump specialization

```text
P_x(u,z)=sum_(A subset V) u^|A| z^epsilon_x(A),
S_x(u)=[z^0] P_x(u,z).
```

For a term of (1), if its three exponents are `a,b,c`, then

```text
|A| = r-a+b-c.
```

Consequently

```text
P_x(u,z)=u^r T_(D->C)(1+u^(-1), 1+u, z/u),               (2)
S_x(u)=u^r [Z^0]T_(D->C)(1+u^(-1),1+u,Z).                (3)
```

The apparent Laurent substitutions cancel termwise.  If `n=|V|` and helpers survive iid with
probability `s`, full symbol-MAP repair reliability is

```text
R_(M,x)(s)=(1-s)^n S_x(s/(1-s)).                         (4)
```

The multivariate form replaces `u^|A|` by `product_(v in A) u_v` and multiplies by
`product_v (1-s_v)` after setting `u_v=s_v/(1-s_v)`.  Splitting subsets according to an ordinary
helper `e` gives

```text
P_(M,x) = P_(M\e,x) + u_e P_(M/e,x),                     (5)
```

which specializes exactly to C219's probability-weighted deletion--contraction recurrence.

There is a smaller specialization when only reliability by survivor count is needed.  Since
`r_D(A)-r_C(A)` is the zero-one success indicator,

```text
d/dy [U_D(u,y)-U_C(u,y)] at y=1
 = sum_A u^|A| (r_D(A)-r_C(A))
 = S_x(u).                                                (6)
```

Equation (6) is a genuine compression: homogeneous repair reliability requires two ordinary rank
polynomials, not the full Boolean truth table or the full three-variable perspective polynomial.
The latter remains the natural home when rank/nullity, activity, or pointed duality is wanted.

## Pointed duality and blockers

Las Vergnas's pointed duality is

```text
T_(M*;x)(X,Y,Z)=Z T_(M;x)(Y,X,Z^(-1))                    (7)
```

for a nonloop `x`.  In the rank-jump language, if `F subset V` and `A=V-F`, the dual rank formula
gives directly

```text
epsilon_x^(M*)(F)=1-epsilon_x^M(A).                       (8)
```

Therefore a surviving set `F` repairs `x` in `M*` exactly when its complement fails to repair `x`
in `M`.  If

```text
S_x^M(u)=sum_(k=0)^n a_k(M,x) u^k,
```

then

```text
a_k(M,x)+a_(n-k)(M*,x)=binom(n,k).                        (9)
```

Equivalently, `x notin cl_M(A)` iff there is a cocircuit through `x` disjoint from `A`.  Hence the
minimal failed-helper blockers of the primal port are precisely the circuits through `x` in `M*`,
with `x` removed.  This imports a useful operational duality rather than only a polynomial name.

## Exact examples

### Uniform matroid

For `M=U_(r,n+1)` with distinguished `x`, success means `|A|>=r`, and

```text
T_(M;x)(X,Y,Z)
 = Z sum_(k=0)^(r-1) binom(n,k)(X-1)^(r-1-k)
   + sum_(k=r)^n binom(n,k)(Y-1)^(k-r),

S_x(u)=sum_(k=r)^n binom(n,k)u^k.                         (10)
```

The certificate instantiates (10) at `U_(3,7)` and checks all subset-size coefficients.

### q=9 cubic target

For C202's cubic-infinity target, `M` has rank four and 19 helpers.  The independently reconstructed
full-rank-jump enumerator begins

```text
S_x(u)=36u^3+2502u^4+9486u^5+24654u^6+...+19u^18+u^19.
```

All 20 coefficients agree exactly with C219's complete radius-four profile.  This equality is
structural: in rank four every circuit has at most five elements, so helper radius four already
captures the full closure event.

### q=9 harmonic targets and the filtered boundary

For the rank-five quartic--nucleus system, the full pointed-Tutte specializations are

```text
S_N(u)
 = 30u^4+252u^5+210u^6+120u^7+45u^8+10u^9+u^10,

S_curve(u)
 = 12u^4+234u^5+210u^6+120u^7+45u^8+10u^9+u^10.         (11)
```

Relative to C219's radius-four profiles, the full nucleus port adds exactly `72u^5`.  The full
curve port adds

```text
162u^5+84u^6+36u^7+9u^8+u^9.                            (12)
```

Thus the standard pointed polynomial does not reproduce the truncated EXIT hierarchy: in rank
five, six-element circuits contribute five-helper repairs beyond C218's classified radius-four
circuits.  A bounded-radius theory must retain circuit size (equivalently the cheapest-repair
filtration from C226), not just the full closure rank jump.

## Verification

[`2026-07-16-c227-pointed-tutte-repair-polynomial.py`](2026-07-16-c227-pointed-tutte-repair-polynomial.py)
imports the established q=9 geometries but does not import their circuit truth tables for its main
check.  It enumerates projective hyperplanes nonzero at the target and marks every helper subset
contained in one of their sections; these are exactly the sets whose span misses the target.  It
then checks the cubic profile against C219, computes both full harmonic profiles, checks the
radius-four differences in (12), and materializes the dual coefficient relation (9).

The deterministic certificate is
[`2026-07-16-c227-pointed-tutte-repair-polynomial.json`](2026-07-16-c227-pointed-tutte-repair-polynomial.json).
The three q=9 checks use respectively 256, 356, and 302 distinct avoiding-hyperplane sections for
the cubic, harmonic-nucleus, and harmonic-curve targets.

## Prior-art boundary

- Las Vergnas defines the set-pointed polynomial, states that the one-element case recovers
  Brylawski's pointed invariant, proves helper deletion--contraction and duality, and identifies the
  equivalent matroid-perspective subset expansion in
  [*The Tutte polynomial of a morphism of matroids I*](https://doi.org/10.5802/aif.1702).
- Gioan gives a modern statement of the Las Vergnas perspective rank expansion and its activity
  expansions in
  [*On Tutte polynomial expansion formulas in perspectives of matroids and oriented matroids*](https://doi.org/10.1016/j.disc.2022.112796).
- Mazumdar defines `U(u,y)` by subset cardinality and generator-submatrix rank and uses its
  `y`-derivative in a BEC achievability bound in
  [*Capacity of Locally Recoverable Codes*](https://arxiv.org/abs/1808.10262).  That source uses one
  unpointed local-code rank polynomial; equation (6) is the coordinate-pointed
  deletion/contraction refinement required here.
- Chaiken's [ported Tutte framework](https://doi.org/10.1016/0095-8956(89)90010-5) develops
  sum/cosum composition for distinguished ports.  C227 does not claim that every such algebraic
  composition has already been given a repair-system realization; duality and the rank-polynomial
  identity are the imported consequences established here.

A bounded search found adjacent matroid reliability and BEC/rank-polynomial work, but no source
stating (4), (6), or the q=9 applications in complete-repair-port language.  This is a none-found
application boundary, not a priority claim.

The load-bearing cached sources were checked at:

```text
10.5802/aif.1702   sha256 645aeb2c003aecefc4f7ccec9e771bb287a9bbf5d79182fda2e848b8b235d19d
arXiv:1807.06559   sha256 3deaf15665fcad8bc4489d64ef584648741a552500a1a0f9250086f2e22de792
arXiv:1808.10262   sha256 7f64ef17db8d8bbea1c203f71baada40c8a431ca981bdfae33cf9b235f63e635
```

The shared cache verification reported 17 entries and zero hash problems.

## Disposition

C227 is a **strong GO** for the unbounded complete port.  The natural mathematical home is the
one-element pointed Tutte polynomial, equivalently the degree-one perspective `M\x --> M/x`.
Pointed duality turns C219 blockers into dual repairs, and the deletion/contraction rank-polynomial
derivative gives a compact coding-theoretic enumerator identity.

The result is also a clean stop on overextension: C226's bounded-radius EXIT hierarchy is not a
specialization of this unfiltered invariant.  Any later pointed-Tutte program should separate the
standard full-closure theorem from a genuinely filtered circuit-size refinement.  C228 is next.
