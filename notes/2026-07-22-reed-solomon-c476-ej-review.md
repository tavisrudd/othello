# The Klein quotient behind the C476 first collision

**Lane:** `reed-solomon`

**Date:** 2026-07-22

**Status:** user-requested extra-juice review of the committed C476 certificate.  The statements
below are exact consequences of C475's rank-one theorem and C476's certified stabilizer
permutations.  No field or support beyond C476's stop point is opened, and no new certificate is
required.

## Result

C476's first collision has a smaller intrinsic description than “two radical orbits.”  Let

```text
S={0,1,2,3,4,infinity} subset P1(F_11),
G=Stab_PGL2(11)(S)=V4.
```

Then the quotient map `P1 -> P1/G` has one ramified rational fibre outside `S` and one ordinary
rational fibre outside `S`:

```text
ramified fibre:       {5,10},          point stabilizer order 2,
ordinary fibre:       {6,7,8,9},       point stabilizer order 1.       (1)
```

These are exactly the two rank-one syndrome orbits in C476's all-one atlas fibre.  Thus the
smallest evident intrinsic discriminator is one bit:

```text
epsilon(u)=1  iff  Stab_G(rad(beta_u)) is nontrivial.                    (2)
```

Equivalently, (2) asks whether the radical is a ramification point of the Klein quotient.  It
separates the two orbits as `1` versus `0`, without retaining a coordinate for the radical.

More generally, C475 immediately gives an all-field rank-one collision criterion:

> For any conic support `S`, the complete raw-atlas rank-one fibre is `P1(F)-S`, every atlas entry
> is one, and its projective-semilinear syndrome orbits are exactly the orbits of the semilinear
> support stabilizer on `P1(F)-S`.  Hence a rank-one raw-atlas collision occurs exactly when that
> complement action is nontransitive.

This criterion, rather than a higher binary-form covariant, explains the entire C476 collision.

## 1. Exact Klein action

In C476's coordinate convention a matrix `(a,b,c,d)` acts by

```text
t |-> (c+d*t)/(a+b*t).
```

The three certified nonidentity stabilizer elements are

```text
A(t)=4-t,
B(t)=(1-t)/(1+5t),
C(t)=(3-t)/(1+5t).                                      (3)
```

Their permutations and rational fixed sets are

```text
A: (0 4)(1 3)(5 10)(6 9)(7 8),             Fix(A)={2,infinity},
B: (0 1)(2 infinity)(3 4)(5 10)(6 8)(7 9), Fix(B)=empty,
C: (0 3)(1 4)(2 infinity)(6 7)(8 9),        Fix(C)={5,10}.             (4)
```

Thus `G` has the parallel orbit decompositions

```text
S                 ={2,infinity} disjoint-union {0,1,3,4},
P1(F_11)-S        ={5,10}      disjoint-union {6,7,8,9}.               (5)
```

The two-point complement orbit is uniquely recognizable as the rational fixed set of the only
nonidentity element whose fixed points both avoid `S`.  Each point in it has stabilizer `C2`; the
four points in the other complement orbit have trivial stabilizer.  Orbit--stabilizer already
recovers C476's rank-one syndrome orbit sizes `2+4`.

## 2. A degree-four quotient coordinate

Take the orbit product of the affine coordinate:

```text
J(t)=product_(g in G) g(t)
    =t*(4-t)*(1-t)*(3-t)/(1+5t)^2.                       (6)
```

The group permutes the four factors, so `J` is `G`-invariant.  Its degree is four, equal to
`|G|`; hence it generates the fixed field `F_11(t)^G` and is a quotient coordinate.

Its relevant rational fibres are

| quotient value | fibre in `P1(F_11)` | multiplicity | role |
|:---:|:---|:---:|:---|
| `0` | `{0,1,3,4}` | simple | four-point support orbit |
| `infinity` | `{2,infinity}` | double | two-point support branch fibre |
| `3` | `{5,10}` | double | two-point collision branch fibre |
| `10` | `{6,7,8,9}` | simple | four-point collision fibre |

The factor identities are

```text
numerator(J)-3*denominator(J)
  =10*(t-5)^2*(t-10)^2,

numerator(J)-10*denominator(J)
  =10*(t-6)*(t-7)*(t-8)*(t-9).                           (7)
```

The third geometric branch fibre lies over `J=4`:

```text
numerator(J)-4*denominator(J)
  =7*(5*t^2+2*t-1)^2.                                   (8)
```

The quadratic in (8) has discriminant `2`, a nonsquare in `F_11`, so this branch pair is rational
only over `F_121`.  The three involutions in (3) therefore account exactly for the three branch
fibres of the Klein quotient:

```text
support-rational,       complement-rational,       conjugate over F_121.
```

This explains the otherwise slightly mysterious coexistence of fixed-point profiles
`{2,infinity}`, `{5,10}`, and `empty` in C476's certificate.

## 3. What becomes cheaper for C477

C477 still owns the coordinate-free theorem for the frozen fibre, but several routes are now
strictly ordered.

1. **Stabilizer/ramification is the leading discriminator.**  The single bit (2) separates the
   two orbits before evaluation-rank, extension-conflict, or continuation-graph data are needed.
2. **Radical is the lossless refinement.**  C475's radical point reconstructs the rank-one
   syndrome; quotient ramification remembers only which of the two `G`-orbits it occupies.
3. **Binary covariants are unnecessary for this collision.**  They remain sensible language for
   a future rank-two resonance, but the frozen C476 fibre is already explained by the elementary
   quotient `P1/G`.
4. **The intrinsic target is sharp.**  Recover `G` from the unlabelled support, identify the unique
   rational branch fibre disjoint from `S`, and prove that nontrivial point stabilizer is the
   cardinality-minimal orbit discriminator.  The explicit `J` supplies a coordinate check, not the
   definition.

The prescribed C477 evaluation-rank and extension/continuation checks can now serve as controls:
if they agree across the two constituents, that proves they are coarser than ramification; if one
differs, its difference must still reduce to the same `2+4` orbit split.

## Extra-juice ledger

- **Settled — the general rank-one collision mechanism.**  It is precisely nontransitivity of the
  support stabilizer on the omitted conic points.
- **Settled — the smallest evident discriminator in the frozen fibre.**  Nontrivial syndrome
  stabilizer, equivalently ramification of `P1 -> P1/V4`, is one bit and separates `2` from `4`.
- **Settled — the three involution types.**  Their fixed pairs lie inside the support, outside the
  support, and over the quadratic extension, respectively.
- **Settled — why the complement split is `2+4`.**  It is one rational branch fibre plus one
  ordinary rational fibre of the degree-four quotient.
- **Open for C477 — coordinate-free minimality.**  The remaining work is to derive the same branch
  description from the unlabelled support/fibre and compare the card's prescribed control
  discriminators; no new census is needed.
- **Open beyond the current gate — rank-two resonance.**  C476 found none before its stop.  Joint
  sextic/quadratic covariants should remain gated until an actual rank-two collision exists.

## Vibe check

The collision has become simpler and more structural: it is a branch-versus-ordinary fibre of a
Klein quotient, not an unexplained coincidence of coefficient arrays.  C477 now has a short
group-geometric proof target and a canonical one-bit answer.
