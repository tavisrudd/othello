# C526 — canonical Tate pairing versus the rigid C433 target

**Lane:** `crowns`

**Status:** `COMPLETE — NEGATIVE FLAG-ORBIT OBSTRUCTION`

**Date:** 2026-07-23

## Verdict

C412's relative-cubic Tate plane has no natural pairing that makes its ordered rank-one/rank-nine
flag isometric to C433's rigid depth/Fourier target.

The obstruction is stronger than failure to select one pairing.  Let `Q1` and `Q9` be the unique
rank-one and rank-nine members of C412's two-dimensional `PGL_2(11)`-invariant bilinear-form
pencil on `W`.  Every bilinear form on `Sym^3(W)` functorially induced from that frozen pencil is a
polarization in

```text
Sym^3 <Q1,Q9>.
```

After invariant/coinvariant evaluation and Tate descent, the image of this four-dimensional
polarization space is exactly the two-dimensional space of forms on the Tate plane for which the
ordered source flag is orthogonal.  C433's ordered doubled/residual target flag is nonorthogonal
for its valency metric.  Orthogonality is invariant under isometry and independent rescaling of
the two flag lines, so no source-to-target projective isometry exists.  This closes C526 without
choosing among C412's ten fitted flag maps.

## Complete source-pairing inventory

Write `T=R/im(N)`, identified canonically with `ker(N) <= M_G` by C412's projection `pi`.  Use the
contraction coordinates on `T`,

```text
C = [[8,1,0],
     [0,8,1]],
```

whose kernel is the norm line `[1:3:9]`.  The ordered source flag in these coordinates is

```text
u1=[1:9]       (rank one),
u9=[1:3]       (rank nine).
```

In C412's frozen invariant-form basis, the singular members are

```text
Q1 = Q0+7Q',       rank(Q1)=1,
Q9 = Q0+6Q',       rank(Q9)=9.
```

Pairing the three symmetric-tensor slots and polarizing gives all four canonical monomials.  Their
descended Gram matrices in contraction coordinates are

```text
Q1^3       -> [[5,2],[2,3]],      rank 1,
Q1^2 Q9    -> 0,
Q1 Q9^2    -> [[9,10],[10,5]],    rank 1,
Q9^3       -> 0.
```

In the ordered flag basis `(u1,u9)`, the two surviving matrices become

```text
Q1^3       -> diag(9,0),
Q1 Q9^2    -> diag(0,4).
```

They are independent.  Hence the image of the full polarized construction is exactly

```text
{ diag(9 alpha,4 beta) : alpha,beta in F_11 }.
```

This proves both completeness and the universal orthogonality statement; it is not a census of
maps or fields.

There is an equivalent group-theoretic form of the obstruction.  The reflection acting as `+1` on
`u1` and `-1` on `u9` has contraction-coordinate matrix

```text
S_src = [[9,4],
         [2,2]],          S_src^2=I.
```

It preserves every form in the induced pairing space and fixes both ordered flag lines
projectively.  Thus every perfect source metric-plus-flag package retains a nontrivial projective
`C2`.

For comparison, choosing an arbitrary pencil member `Q=cQ1+dQ9` gives the pure pairing

```text
Sym^3(Q)|T = diag(9c^3, c d^2)
```

in the flag basis.  It is perfect exactly when `cd != 0`, accounting for the ten nonsingular
projective pencil members.  Every such form has square determinant and is anisotropic, just like
the target metric.  Thus metric type alone would give a false positive: the ordered flag supplies
the decisive invariant.

The four canonical monomial lines are individually zero or degenerate.  A perfect element of their
two-dimensional image requires a relative normalization between the two surviving rank-one forms;
the projective lines `Q1,Q9` do not select such a normalization.  The final obstruction does not
depend on this naturality point, because even an arbitrarily normalized perfect combination keeps
`u1` and `u9` orthogonal.

## Evaluation, Tate descent, and adjoints

Let `B` be any polarized invariant ambient pairing.  For `r in R=M^G`, invariant/coinvariant
evaluation is

```text
<r,[m]> = B(r,m).
```

It is well-defined because `B(r,(g-1)m)=0`.  Symmetry and invariance give

```text
B(Nx,y)=B(x,Ny),
```

so the norm-induced form on coinvariants is symmetric.  Also

```text
B(r,pi(s))=B(r,s)=B(pi(r),s).
```

C412's exact cycle has `im(N)=ker(pi)` and `im(pi)=ker(N)`.  The norm line is in the radical of
the restricted form, so evaluation descends to

```text
(R/im(N)) x ker(N).
```

Pulling the second leg back through `pi:T -> ker(N)` gives exactly the symmetric two-dimensional
Gram forms displayed above.  Thus invariant/coinvariant evaluation, Tate duality, and the
same-plane pairing are three descriptions of one construction, not additional candidates.

## Exact target comparison

C433's target valency metric in its `e1=v2,e2=v3` basis is

```text
G = [[3,7],
     [7,10]],
```

with square determinant `3`; it is anisotropic.  Its ordered doubled/residual lines are

```text
d=[1:10],       r=[1:9].
```

Treating the displayed flag coordinates as vectors gives

```text
Gram_G(d,r) = [[10,2],[2,4]].
```

The cross-pairing is `2`, not zero.  Treating the cubic divisor intrinsically as a dual flag gives

```text
Gram_(G^-1)(d,r) = [[9,5],[5,2]],
```

whose cross-pairing is `5`, again nonzero.  Therefore the conclusion is independent of the
vector/dual coordinate convention:

```text
source ordered flag: orthogonal for every induced pairing,
target ordered flag: nonorthogonal for the canonical metric.
```

No isometry can carry the first ordered flag to the second.

Equivalently, a target isometry fixing both ordered lines must act on them by two scalars.  Their
nonzero norms force the scalars to have the same square, and their nonzero cross-pairing forces
their ratio to be `1`; it is therefore projectively scalar.  The target metric-plus-flag stabilizer
is trivial, whereas the source stabilizer contains `S_src`.  This residual-`C2` mismatch is the
structural form of the zero-versus-nonzero cross-pairing obstruction.

## Naturality and subgroup boundary

Each `Qi` is invariant under `PGL_2(11)`.  The outer character twisting `M` occurs twice in a
bilinear pairing, so it cancels; all four polarizations and their descended forms have the required
outer covariance.

Restriction to C492's `A5` Mackey interface adds no choice.  Since `11` does not divide
`|A5|=60`, Maschke applies and the restriction is semisimple.  It cannot normalize the two
surviving source rank-one forms or turn their zero cross-pairing into C433's nonzero target
cross-pairing.  The obstruction belongs to the ambient `PSL_2(11)` Tate extension and remains
distinct from an `A5` incidence-augmentation degeneration.

## `ej` closeout and mystery ledger

The closeout pass strengthened the initial naturality failure in two ways.

- It replaced a list of pencil cases by the closed formula
  `diag(9c^3,cd^2)`, proving that the ten nonsingular pure pairings all have the correct
  anisotropic metric type but the wrong flag orbit.
- It enlarged the stop from pure cubes to the complete polarized space
  `Sym^3<Q1,Q9>`: arbitrary mixed pairings still have zero cross-term.  Thus neither a different
  normalization nor a mixed polarization can reopen the bridge.
- It packages the orthogonal source flag as the pairing-independent involution `S_src`.  Every
  perfect source package keeps a projective `C2`, while the target ordered flag kills its last
  projective involution.  This makes the obstruction an automorphism-group mismatch, not merely a
  coordinate discrepancy.

No theorem-level mystery remains.  The exact finite calculation shows that the four polarized
restrictions collapse to two flag-supported rank-one forms; a basis-free representation-theoretic
explanation of that collapse is not needed for the obstruction and is not allocated.  C439 should
use either the zero-versus-nonzero cross-pairing or the residual-`C2` mismatch as a cheap seam
falsifier.  C527 should state the negative boundary: C433's target is rigid, but C412's natural
Tate pairings occupy the wrong ordered-flag orbit.

## Reproducibility

Run from `/home/tavis/src/othello` with Python 3.13:

```bash
python3 notes/2026-07-23-c526-tate-pairing-rigid-target-bridge.py --check
python3 notes/2026-07-23-c526-tate-pairing-rigid-target-bridge-replay.py
sha256sum -c notes/2026-07-23-c526-tate-pairing-rigid-target-bridge.sha256
```

Intentional regeneration is:

```bash
python3 notes/2026-07-23-c526-tate-pairing-rigid-target-bridge.py --write
```

The primary checker reconstructs the frozen H3 matching quotient and ten-dimensional module from
C406, derives the relative-cubic three-space and the invariant bilinear pencil, forms all four
polarized symmetric-cube pairings with the orbit-sum tensor multiplicities, descends them through
the C412 Tate kernel, proves their image has dimension two, and verifies the closed pure-pairing
formula for all twelve projective pencil members.  It consumes C412's contraction/flag certificate
and C433's target metric certificate with embedded byte counts and hashes.

The independent replay uses a separate two-by-two row reduction and direct bilinear evaluation.  It
checks all twelve projective combinations of the two surviving source forms, obtains exactly ten
perfect forms, verifies source orthogonality in every case, and independently obtains target
cross-pairings `2` and `5`.

The trusted boundary is exact integer/`F_11` arithmetic, C406's frozen matching geometry, C412's
canonical contraction coordinates, and C433's valency metric/ordered flag.  The certificate proves
the complete pairing inventory induced functorially by the frozen invariant bilinear pencil.  It
does not classify arbitrary bilinear forms unrelated to that data, search for fitted maps, or make
a literature-priority claim.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| primary checker | 19,862 | `42e5648c2b80952f67256b62fd6f4bf237be82fb228400f0e042dbbb8d2cd909` |
| independent replay | 3,578 | `b6511c3abd86727d83886d573f96a423ffd38b97d1d21920835b148585665e22` |
| canonical JSON | 17,346 | `b94a62adfa440dbb7234bd31b7d87f5d9d7c87aac6f6ee54df5a458f89e02b14` |

## Hand-backs

- **C433/crowns:** the missing source metric exists only after a noncanonical normalization, and
  every induced perfect metric puts the ordered source flag in the orthogonal orbit, unlike the
  rigid target.
- **C439:** use source cross-pairing `0` versus target cross-pairing `2` (or dual `5`) as the
  terminal modular-seam falsifier; equivalently, source retains `S_src` while the target
  metric-plus-flag stabilizer is projectively trivial.
- **C527:** Paper 2 may state the exact negative boundary; no fitted-map choice or further
  decomposition calculation remains.
