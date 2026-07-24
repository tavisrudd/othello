# C537 — Flatland--Gale multi-view comparison

**Lane:** `reed-solomon`

**Date:** 2026-07-24

**Status:** complete — bridge killed by incompatible inverse inputs.

## Result

Agarwal--Connelly--Crannell--Duff--Thomas and C481 use exactly the same invariant for one
projection of six labelled planar points: the bracket array

```text
d_ij(X,a)=det(x_i,x_j,a)
```

modulo a common scalar and the six vertex scalings, equivalently the labelled
`M_0,6` point of the projected sextic. Flatland's Joubert coordinates are a linear coordinate
system on the degree-one perfect-matching monomials in these brackets. Thus, on the common
generic locus,

```text
g'(X,a) ~ g'(Y,b)    iff    c_X(a)=c_Y(b) in M_0,6.     (1)
```

This exact one-view identification does **not** extend to the proposed multi-view bridge.
The two problems use (1) in opposite incidence directions:

```text
Flatland:
  several fixed planar configurations X_j
  + one centre a_j in each plane
  -> the same line image p:
       c_X1(a_1)=...=c_Xm(a_m)=p;

C481--C485:
  one unknown planar six-arc A
  + several co-embedded centres u_s in its one plane
  -> generally different line images:
       (c_A(u_1),...,c_A(u_r)).
```

Flatland's open consistency question asks whether pairwise fundamental-matrix reconstructions of
the several `X_j` arise from one point set in `P3` and one jointly compatible family of pinhole
cameras. C481--C485 have no `X_j`, pinhole cameras, fundamental matrices, or world points as
input. They reconstruct one planar parent from several abstract line images. Consequently their
diagonal label compatibility cannot impose Flatland's missing joint `P3` realization.

There is a decisive algebraic obstruction to treating the two functors as merely differently
presented versions of the same inverse. Feeding Flatland's common image into C482 produces the
repeated tuple `(p,...,p)`. After the common normalization to `(A,B,C)`, every C482 compatibility
row is the same:

```text
m(p)=(-B(A-1),-A(1-B),C(A-1),A(1-C),C(1-B),-B(1-C)).
```

Hence `rank(M_r)=1` for every number of Flatland views. C483's exact residual table then gives a
three-dimensional cubic residual family, not the rank-four quadratic fibre and not a Gale pair.
Adding more copies of the same line image never reaches the four-independent-view gate.

The verdict is therefore the task's **kill** outcome:

> C481--C485 neither solve nor strictly refine Flatland's three-or-more-camera joint-consistency
> gap. They share the one-view labelled `M_0,6` quotient, but their inverse inputs, ambient
> geometry, equivalence relations, and nondegenerate loci are incompatible.

There is nevertheless an exact geometric residue behind the superficial similarity. On
Flatland's generic complex locus, every planar six-point configuration `X` determines a
hexahedral cubic surface

```text
S_X = T intersect H_X,
T = {sum z_i=sum z_i^3=0} subset P5,                    (7)
```

where `T` is the Segre cubic threefold and `H_X` is one hyperplane. Flatland fixes several
hyperplanes `H_Xj` and seeks a common colour `p in T`; C482 fixes several colours `p_s in T` and
seeks one hyperplane `H_A` through them. They are the two projections of the same point--hyperplane
incidence correspondence, but only the former carries Flatland's fixed planar configurations and
neither construction carries its missing joint `P3` lift. This incidence transpose explains C482's
residual dimensions and Gale pair without repairing the killed joint-consistency bridge.

No finite-field descent comparison is activated, because the geometric functors already fail to
match.

## 1. Source and evidence boundary

The Flatland source was read end to end from the persistent literature cache:

```text
key:     arXiv:2501.05429
title:   A Computer Vision Problem in Flatland
authors: Sameer Agarwal; Erin Connelly; Annalisa Crannell;
         Timothy Duff; Rekha R. Thomas
version: arXiv v2, 10 January 2025
sha256:  c1e2b8908474795f3eb6a11cca24228960ddd1dd81326cd6c9c28d2f595d9654
```

The comparison uses Flatland Theorems 4 and 6, Lemmas 13--14, Theorem 16, equations
(3), (8), and (48)--(57), and the explicit warning immediately after Theorem 6. On the
C481--C485 side it uses C481's bracket-quotient inverse and coherent-atlas functor, C482's
compatibility rows and rank/dimension theorem, and C483's Gale and exceptional-fibre theorems.
C484's finite-field descent is deliberately not invoked after the geometric mismatch.

This is a comparison of the stated functors, not a literature-priority audit and not a claim that
Flatland's open multi-camera problem has no solution elsewhere.

## 2. Exact one-view dictionary

Let `X=(x_1,...,x_6)` be a labelled planar configuration and let a full-rank flatland camera with
centre `a` send it to `P=(p_1,...,p_6)` on `P1`. Flatland Lemma 14 gives, up to one common
nonzero scalar,

```text
[ij]_P = det(p_i,p_j) ~ [ija]_X = det(x_i,x_j,a).       (2)
```

Changing representatives of the six `x_i` introduces the six vertex scalings. Changing the
line-image basis introduces the common determinant factor. These are exactly C481's torus action

```text
x_ij -> lambda alpha_i alpha_j x_ij.                    (3)
```

The nonzero Pluecker arrays modulo (3) are labelled `M_0,6`. Flatland's six Joubert invariants
`(A,...,F)` are linear combinations of perfect-matching monomials

```text
[ij][kl][rs],
```

so their pullbacks replace every bracket by `[ija]_X`. On the stable locus of six distinct
projected points, Flatland Lemma 13 and C481's explicit bracket-array inverse both show that these
coordinates separate the same `PGL_2` orbit. This proves (1), including its labels.

The fundamental matrix does not enlarge this quotient. For a pair `(X_i,X_j)`, Flatland
Theorem 4 factors a rank-two `F^{ij}` into two flatland cameras; its epipoles are their centres,
and the equations

```text
(x_k^i)^T F^{ij} x_k^j=0
```

say that the two projected labelled sextics agree. Flatland Theorem 6 uses the shared epipole in
each plane to choose one camera there, up to the common output `PGL_2`. Thus the pairwise
fundamental-matrix condition becomes equality of the points in (1), not C481's compatibility
condition for several different points of `M_0,6`.

## 3. Variance and equivalence-group mismatch

Write

```text
psi_X : P2 -->> M_0,6,       a |-> c_X(a).              (4)
```

Flatland studies fibre products of several maps with **fixed, generally different sources**:

```text
(a_1,...,a_m) in P2_1 x ... x P2_m
such that psi_X1(a_1)=...=psi_Xm(a_m).                  (5)
```

C481--C485 instead invert several values of **one unknown map**:

```text
(A;u_1,...,u_r) |-> (psi_A(u_1),...,psi_A(u_r)).        (6)
```

One diagonal `S6` in (6) means that the six labels arise from the same parent across all views. It
does not mean that the values in `M_0,6` are equal. In (5), equality of the values is the entire
common-line-image condition, while the parents remain different.

The ambient quotients differ in the same way:

- Flatland permits an independent planar homography on each `X_j`, plus a common change of
  coordinates on the output line.
- C481--C485 permit one `PGL_3` on the single parent plane, co-transporting every centre, plus one
  diagonal label permutation.
- Flatland's missing datum is a common `P3` world configuration and jointly compatible pinhole
  cameras. C481's source has only a planar parent and quotient-line cameras.

The common domain is narrower than either full theorem: six projected points must be distinct for
`M_0,6`; C481 additionally assumes a six-arc and centres off all its secants, while Flatland's
generic camera-locus results do not use that arc/deep condition. Restricting Flatland to this
common open does not repair the variance mismatch.

## 4. Why the four-view Gale theorem degenerates

Normalize a line image `p` so its first three points are `infinity,0,1` and write the remaining
three as `(A,B,C)`. C482 associates the row `m(p)` displayed in the Result. If Flatland provides
one common image, all normalized triples agree, so

```text
M_r =
  [m(p)]
  [m(p)]
  [...]
```

has rank one. C482's rank-four theorem requires four independent rows and then cuts the
parent-coordinate cubic to the universal collision plus a residual quadratic. Rank one instead
leaves

```text
P(ker M_r) intersect
V(x_X x_a x_d-x_Y x_b x_c),
```

a three-dimensional cubic residual family on the generic open. The factorization into two
Gale-associated parents is therefore unavailable.

This is not a removable choice of gauge. Identical labelled `M_0,6` points have identical
canonical normalized rows; a common `PGL_2` change merely chooses another presentation of the same
repeated row. The pairwise fundamental matrices contain planar ray correspondences and epipoles,
but C482's target does not accept those data. Supplying them would define a new inverse problem,
not an application of C481--C485.

## 5. Camera cubics and C482 residual families are incidence-dual

For six points, Flatland's map `psi_X` is expressed in pulled-back Joubert coordinates and its
image is the Cremona hexahedral cubic surface `S_X` in (7). Given a second fixed configuration
`Y`, equality in (1) asks for

```text
p in S_X intersect S_Y
  = T intersect H_X intersect H_Y.                     (8)
```

The inverse image of (8) under `psi_X` and `psi_Y` gives Flatland's plane cubic centre loci
`C_X` and `C_Y`; a centre on one determines the centre on the other. Thus the centre cubics live
in the two fixed camera planes, while their common colour lives on the two-hyperplane section of
`T`.

C482's residual cubic surface and curve instead live in the four parameters of an **unknown
single planar parent** after two or three prescribed line images. However, the hexahedral model
now gives an exact indirect relation. A prescribed colour `p_s` is compatible with a parent `A`
exactly when

```text
p_s in S_A, equivalently p_s in H_A.                   (9)
```

Hyperplanes in the ambient `P4={sum z_i=0}` form a dual `P4`. Therefore `r` linearly independent
colours impose `r` independent linear conditions on `H_A`, leaving hyperplane-family dimension

```text
4-r.                                                    (10)
```

For `r=2,3`, (10) is exactly C482's residual dimensions `2,1`. Four general colours determine
one hexahedral hyperplane. Its lifts to planar-parent moduli are C483's two Gale-associated
parents; on the conic locus those lifts coalesce. Indeed C483 shows
`S_A=S_Gale(A)` on a dense open, while C482's four-view theorem shows that these are generically
the only two lifts. Thus the map

```text
{six planar points}/PGL_3  -->>  {hexahedral H_A}
```

is generically the Gale double cover on this open. This is a conceptual explanation of both the
quadratic fibre and its conic branch.

The relation is an **incidence transpose**, not an identification of the inverse problems:

```text
Flatland: fixed H_X1,...,H_Xm; find common p.
C482:    fixed p_1,...,p_r; find common H_A.            (11)
```

In particular, a Flatland common image repeats one point `p`, so its conditions on an unknown
`H_A` still have rank one; the richer dual picture confirms rather than weakens the repeated-row
kill. The hexahedral argument here is confined to Flatland's generic complex setting. C482's
all-characteristic theorem remains the source for the integral statement; no naive use of (7) is
made in characteristic three, where the displayed cubic equations degenerate.

In particular, Flatland's missing joint consistency concerns lifting several planar configurations
to one `P3` scene. Gale association in C483 exchanges two planar six-point parents with the same
abstract line projections. It supplies neither the pinhole cameras nor the common world points
needed for the former problem.

## 6. Strongest valid transfer and portfolio boundary

The only exact transfer is the one-view dictionary (1):

> Flatland's common-line-image condition for six labelled points is equality of the C481
> projection-sextic colours.

This can be useful as notation: Flatland's camera-centre variety is a fibre product of the
projection-colour maps (4). It does not turn C481's multi-colour inverse into a theorem about
joint `P3` reconstruction.

The unfilled Flatland condition would require data detecting whether the pairwise fundamental
matrices arise from one compatible multi-camera system—equivalently, a higher multi-view tensor
or an explicit common-world/camera realization beyond the radial constraints quoted after
Flatland Theorem 6. Developing that object is outside C537. Per the task boundary, no manuscript
or successor is opened, and no claim is transferred to the pending `arcs` or `continuation`
papers.

## Closeout: extra juice and Tao stress test

The cheapest decisive discriminator was not another invariant calculation but a variance test:
ask what is fixed, what is reconstructed, and whether the several `M_0,6` values are equal or
independent. That exposes the mismatch before any finite-field or descent machinery.

The resulting free upgrade is the repeated-row certificate. It turns the conceptual objection
into an exact algebraic failure: Flatland's common image forces `rank(M_r)=1`, while the Gale pair
requires rank four. This also rules out the tempting claim that enough pairwise Flatland views
eventually enter C482's generic four-view regime.

A second free upgrade comes from reading Flatland's hexahedral equations contravariantly. Its
configuration `X` supplies a hyperplane section `S_X` of the Segre cubic. Flatland fixes such
hyperplanes and solves for a point; C482 fixes points and solves for such a hyperplane. Linear
point--hyperplane incidence gives the `4-r` dimension law, and the two lifts of the unique
four-point hyperplane are exactly the Gale pair. This explains why the dimensions and cubics looked
related without confusing the two inverse functors.

A further stress test by equivalence groups reaches the same verdict independently. Flatland
quotients each camera plane separately and seeks a common `P3` lift; C481 quotients one shared
plane and forgets all relative camera-plane embeddings. No relabelling, field extension, or
choice of Joubert coordinates can restore information absent from the source functor.

## Mystery ledger

| Feature | Status | Exact resolution or remaining gap |
|---|---|---|
| Why both papers display the labelled six-point `P1` quotient | settled | They use the same bracket-torus quotient for one planar projection; equation (1) is exact. |
| Whether C481 diagonal compatibility is Flatland joint consistency | settled negative | C481 keeps one parent across generally different colours; Flatland keeps one colour across generally different parents. |
| Whether four or more Flatland views activate the Gale pair | settled negative | The common colour repeats one C482 row, so `rank(M_r)=1` for every `r`. |
| Why Flatland's camera-centre cubics and C482's residual dimensions look related | settled | They are opposite projections of point--hyperplane incidence on the Segre cubic: fixed hyperplanes/find a colour versus fixed colours/find a hyperplane. They are not the same varieties. |
| Why four independent C482 colours give a Gale pair | settled conceptually | Four general points determine one hexahedral hyperplane; its generic planar-parent fibre is the Gale double cover, ramified on the conic locus. |
| Flatland's actual three-or-more-camera `P3` consistency criterion | open outside C537 | C481--C485 omit the pinhole cameras, world points, and multi-view tensor data needed to test it; no successor is authorized here. |

No mystery remains about the proposed Flatland--Gale bridge itself.

## Vibe check

The hoped-for theorem transfer fails, but cleanly and for a structural reason. The exact
one-view dictionary is real; the repeated-row obstruction prevents it from being overread as a
multi-view result.
