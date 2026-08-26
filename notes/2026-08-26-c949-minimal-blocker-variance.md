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

The actual tight-line embedding gives one further exact identity.  Every
`ell in D` satisfies

```text
sum_(P in ell) u_P=4-j.                              (MV4)
```

Indeed `sum_(P in ell)d_P=q+T`, while `|A intersect ell|=2r+1`.  If a point
`P` has tight degree `h` and `Star(P)` is the disjoint union, off `P`, of its
`h` incident tight lines, then

```text
sum_(Q in Star(P))u_Q
 =h(h-j),       P in A,
 =h(h+3-j),     P in B.                             (MV5)
```

This converts a high-degree point into a forced signed mass on its embedded
pencil.  It still does not cap the degree-seven case: each incident line
meets the three generator lines, and their core values can absorb the first
bounded levels of `(MV5)`.

There is also a sharp ledger-level switch symmetry.  Suppose `P in A` has
degree `h` and on each incident tight line choose a distinct degree-one
point `Q_i in B`.  Relabel `P` into `B` and all `Q_i` into `A`.  Every line
of `D` retains exactly `r` points of `B`, the residue word is unchanged, and
`eta` increases by `h-1`.  The norm changes by exactly

```text
[(1-h)^2-(4-h)^2]+9h=15(h-1),
```

exactly matching `(MV1)`.  The reverse switch exchanges a high `B` degree
for a high `A` degree.  This need not preserve blocking on non-tight lines or
arc completeness, so it is not a geometric counterexample.  It proves that
the tight-line arrangement, its first two moments, and the ternary core
cannot by themselves yield a pointwise cap.  The missing input is
non-tight-line slack/minimality or the carrier/mapping equations.

## Non-tight variance and safe donors

The line-intersection version of the same variance ledger supplies exactly
that slack information.  Put

```text
epsilon=(1-eta)/(3r),
c=2r+epsilon,
Pi=2r+(-3r+1)epsilon-epsilon^2.
```

If `n_ell=|B intersect ell|`, the exact Section-5 re-centering is

```text
sum_(ell notin D)(n_ell-c)^2
 =3cPi-(r+epsilon)^2
       (j+2-(1-eta)/r).                              (MV6)
```

For fixed SR11 `j` and `eta=o(r)`, this becomes

```text
sum_(ell notin D)(n_ell-2r)^2=(10-j)r^2+o(r^2).      (MV7)
```

In particular, every non-tight `(r+1)`-secant contributes
`(r-1+o(1))^2`; hence for all sufficiently large fields there are at most
`10-j` such lines.

Call a degree-one point `Q in B` **individually safe** if no non-tight
`(r+1)`-secant contains it.  Moving one individually safe `Q` from `B` to
`A` cannot make a non-tight line deficient.  Equation `(MV1)` gives

```text
sum_(P in B: beta_P!=1) beta_P <=2(MV1),             (MV8)
```

because `beta_P-1<=(beta_P-1)^2`.  On each tight line, at most `10-j`
degree-one points are individually unsafe, one at its intersection with
each fragile line.  Consequently the number of tight lines containing fewer
than `r/2` individually safe degree-one points is at most

```text
2(MV1)/(r/2-(10-j))=O(1).                            (MV9)
```

Thus all but a bounded number of the `2q+O(1)` tight lines contain at least
`r/2` individually safe donors.  For every fixed degree `h`, if the `h`
tight lines through `P in A` avoid this bounded bad set, the donors in the
formal switch can be chosen compatibly.  Greedily, after choosing fewer than
`h` donors, a non-tight line can be saturated only if it already contains at
least two of them, so it forbids at most one point of the next tight line;
there are at most `binom(h,2)` such forbidden points.  For large `r`, one of
the `r/2` choices remains.  The simultaneous switch then preserves every
line's `r`-fold blocking inequality and all old tight lines, hence preserves
minimality/completeness while increasing `eta` by `h-1`.

This still does not remove a high-degree point: the switch changes its side
but preserves the tight arrangement.  The next obstruction must exploit the
direction of the move, the target value of `eta`, or the carrier/mapping
data.  No simultaneous-move claim is made for `h` growing with `r`.

## Direction of the augmentation

The typical degree `h=4` gives a genuine three-point augmentation: under the
safe-line hypotheses above, one may replace one arc point by four blocker
donors and obtain another complete arc with repair `eta+3`.  The proof is
sign-free and applies throughout the sublinear regime.

This is **not** a sharpness construction for C949.  The quantity
`t_(2q/3+1)(2,q)` is the *minimum* size of a complete arc.  The switch moves
upward, so a larger complete arc does not improve the required construction
upper bound and does not exclude the original smaller arc.  Reverse moves
need a high-degree blocker point with suitable degree-one arc donors and are
not supplied by `(MV9)`.  The augmentation is retained as a structural
normalization/no-go boundary only; no `base+1` bound follows from it.

What is **not** proved:

- no zero triangle is located;
- no pointwise cap `alpha_P<=4` is known in the general signatures;
- no mixed correlation with a particular Mason root is supplied;
- first and second degree moments admit many formal integer models.

Thus `(MV1)` is a field-uniform global compression and a plausible input to
a stability/classification theorem, but it is not itself Mason attraction or
the full C949 asymptotic upper bound.
