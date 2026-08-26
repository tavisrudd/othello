# C949 minimal-blocker variance and the Mason-attraction boundary

**Lane:** `relconic`

**Date:** 2026-08-26

This note records the exact specialization of the degree/Cauchy ledger
underlying the minimal-multiple-blocker argument to the C949 near-sharp
regime.  It is a structural
reinterpretation of the existing C949 moment ledger, not a proof of Mason
attraction.

## Source and normalization

The source is Anurag Bishnoi, Sam Mattheus, and Jeroen Schillewaert,
*Minimal multiple blocking sets*, arXiv:1703.07843v3, Theorem 1.1 and Section
5.  The authenticated cached PDF has SHA-256

```text
4ca2ebf88bc90d94a88552092a9e69bcd0dcc9f234490994bfa4d5fa682694b9.
```

Write `q=3r`.  Let `A` be a hypothetical complete near-sharp arc and `B` its
minimal `r`-fold blocking complement:

```text
|A|=3r^2+5r+eta,
|B|=6r^2-2r+1-eta,
eta=o(r).
```

Let `D` be the set of `r`-secants of `B`, equivalently the maximal secants of
`A`, and put

```text
T=|D|=6r+j.
```

For `P in B` let `beta_P` be the number of lines of `D` through `P`; for
`P in A` write `alpha_P` for the same degree.  Minimality gives
`beta_P>=1`.

## Exact degree-variance identity

The projective-plane design identities give

```text
sum_B beta_P=rT,
sum_A alpha_P=(2r+1)T,
sum_all d_P^2=T(T+3r).
```

Consequently

```text
sum_(P in B) (beta_P-1)^2
 + sum_(P in A) (alpha_P-4)^2
 =T^2-(15r+8)T+|B|+16|A|
 =3(10-j)r+j^2-8j+1+15eta.                 (MV1)
```

This is exactly `||u||^2` for the C949 defect

```text
u=1+3 1_A-M1_D.
```

Thus the Cauchy ledger underlying the published bound and the C949 signed
three-line descent are measuring the same global defect in two coordinate
systems.  The centering in `(MV1)` is the C949 one/four centering, not the
literal centered variance used in the general theorem.

For every one of the nine fixed SR11 signatures, `(MV1)=O(q)`.  Hence all
but `O(q)` points of `B` have tight-line degree one, and all but `O(q)`
points of `A` have tight-line degree four.  The exceptional weighted count
is not merely bounded asymptotically: its exact leading coefficient is
`3(10-j)r`.

The corresponding tight-incidence excess on `B` is

```text
sum_(P in B)(beta_P-1)=rT-|B|=r(j+2)+eta-1.           (MV2)
```

Together `(MV1)--(MV2)` say that the `2q+O(1)` tight lines form an
`O(q)`-defect partition of `B` and an `O(q)`-defect fourfold covering of
`A`.  This is the correct global approximate-design normal form shared by
all nine signatures.

There is a free strengthening from the signed three-line core.  Let `L` be
the union of its three generator lines.  Off `L`, the residue word vanishes,
so

```text
beta_P=1 (mod 3) on B\L,
alpha_P=1 (mod 3) on A\L.
```

Every exceptional off-core point therefore costs at least nine units in
`(MV1)`, rather than one.  Explicitly,

```text
#{P in B\L: beta_P!=1}+#{P in A\L: alpha_P!=4}
 <=(10-j)r/3+(j^2-8j+1+15eta)/9.                    (MV3)
```

## Relation to the published upper bound

The Bishnoi--Mattheus--Schillewaert upper root specializes to

```text
b_+=(3r^2-r+3r sqrt(9r^2+2r+1))/2.
```

If `m=6r^2-2r` is the Mason size, then exactly

```text
b_+-m=12r^2/(sqrt(9r^2+2r+1)+3r-1)=2r+O(1).
```

Therefore `|B|=m+1-eta` is still a linear distance from equality in that
general upper bound.  The equality classification associated with the
bound cannot be promoted directly to near-Mason stability.

## TT/EJ and hostile boundary audit

The useful new viewpoint is the approximate embedded design, not the scalar
upper bound.  A possible next theorem would classify `2q+O(1)` projective
lines whose point degrees are one/four outside an `O(q)` weighted defect.
The three-line residue theorem supplies extra localization that the general
blocking-set theorem does not see.

The factor-nine gain `(MV3)` is still only a budget improvement.  Off-core
degrees differing by three preserve the ternary residue, and the three core
lines themselves contain `Theta(q)` points.  A genuine upgrade needs an
embedded-pencil restriction such as an `alpha_P<=4` theorem or expansion of
the tight-line incidence hypergraph.

What is **not** proved:

- no zero triangle is located;
- no pointwise cap `alpha_P<=4` is known in the general signatures;
- no mixed correlation with a particular Mason root is supplied;
- first and second degree moments admit many formal integer models.

Thus `(MV1)` is a field-uniform global compression and a plausible input to
a stability/classification theorem, but it is not itself Mason attraction or
the full C949 asymptotic upper bound.
