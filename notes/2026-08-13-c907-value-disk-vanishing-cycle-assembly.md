# C907 value-disk vanishing-cycle assembly

**Lane:** `clebsch`

**Status:** theorem-grade topological compression.  Once proper-support
descent proves that the value vanishing cycles of the original open graph are
supported only on the four residual Morse sections, the value-localized
relative group is the four-thimble group.  A common boundary collar or common
toroidal model is not an additional logical requirement.  The remaining
analytic hypotheses are the two-model bad-locus exclusion, simple Morse
identification, and labelled parameter transport.

## Proper-support Morse assembly on a disk

Let

\[
 a:U\longrightarrow\Omega
 \tag{1}
\]

be a complex algebraic or analytic map to a closed disk, and set

\[
 K=Ra_!A_U,
 \qquad A=\mathbf Z[1/6].
 \tag{2}
\]

Choose a regular value `u_0` on the boundary and pairwise disjoint
distinguished paths from `u_0` to interior values `c_1,...,c_r`.  Suppose:

1. `K` is constructible and its value vanishing-cycle support is exactly the
   points `c_i`;
2. each local vanishing-cycle group is a free rank-one Morse group in the
   same middle degree; and
3. no singular value lies on the boundary of the disk or on the interiors of
   the chosen paths.

Then stratified Morse attachment along the path star gives a filtration of
the intrinsic relative compact-support cochain complex

\[
 \mathsf R(K;u_0)=
 \operatorname{Cone}\!\left(
 R\Gamma(\Omega,K)\longrightarrow i_0^*K
 \right)[-1],
 \qquad i_0:\{u_0\}\hookrightarrow\Omega .
 \tag{3}
\]

whose successive quotients are the `r` local Morse groups.  Consequently the
middle group is free of rank `r`, all other reduced relative groups vanish,
and the chosen paths give its directed thimble basis.

### Proof

By the defining property of `a_!` and proper base change, (3) is the
compact-support relative cochain complex of
`(a^{-1}(Omega),a^{-1}(u_0))`.  After any proper compactification
`U -> X -> Omega`, it is computed by `R\bar a_*j_!A`.  Cut `Omega` along the distinguished paths and remove small
disks around the `c_i`.  On the complement the vanishing-cycle support is
empty, so the constructible complex is locally acyclic and the cut complement
is a product over a contractible tree.  Its relative contribution against the
reference fibre is zero: for every locally constant complex `M` on the
contractible tree, `R\Gamma(tree,M) -> M_(u_0)` is an isomorphism.  Attaching
the small disks one at a time gives the standard vanishing-cycle
distinguished triangle; the relative cone at the `i`-th step is the local
Morse group, shifted from Milnor-fibre degree `n-1` to thimble degree `n` for
a holomorphic function on a complex `n`-fold.  Passing to homological
thimbles uses the chosen Poincare--Verdier relative-duality convention.  The
groups are free and concentrated
in a common degree, so the filtration has no possible torsion extension and
its middle rank is `r`.  The attaching paths are precisely the thimble
marking.  This argument is on `K`; it is independent of how any chosen
compactification stratifies its exceptional divisors.  \(\square\)

The rank conclusion does not by itself recover the directed
intersection/Seifert pairing.  In fact
`D(Ra_!A_U)=Ra_*D(A_U)`, so Verdier duality pairs the compact-support object
with its ordinary-support dual rather than making `K` canonically self-dual.
To transport the pairing one must additionally transport the chosen relative
Poincare--Verdier duality, Picard--Lefschetz `can/var` maps, orientations of
the rank-one local groups, and the ordered nonbraiding path star.  This is an
intrinsic pairing package on the value-disk complex; it still does not require
a common boundary compactification.

## Parameter version

Let the graph also depend on `delta` and put

\[
 \mathcal K=R(p,L)_!A.
 \tag{4}
\]

Suppose the iterated complex

\[
 \psi_\delta\phi_{L-u}(\mathcal K)
 \tag{5}
\]

is supported on four reduced sections, their values remain distinct in the
chosen disk, and the local total-space Hessians stay nondegenerate.  Assume
also that proper nearby-cycle comparison transports the normalized local
Morse groups.  Then the parameterized holomorphic Morse lemma transports the
four local systems from `delta=0` to every sufficiently small nonzero
`delta`.  No residual braid occurs after shrinking the parameter disk.  The
directed pairing is transported only when the preceding relative-duality,
`can/var`, orientation, and path-label data are part of this comparison.

This is weaker than a product of the whole total family across `delta=0` and
is exactly what the value-localized theorem needs.

## C907 consequence

For the toric pilot, the protected central potential is

\[
 f_Q(y)+ZW.
 \tag{6}
\]

It has four reduced nondegenerate critical points

\[
 Z=W=0,qquad y_1=y_2=y_3=a,qquad a^4=Q,qquad L=4a.
 \tag{7}
\]

Therefore the following implication is exact.

> **Four-thimble support theorem.**  If the exterior/ratio proper models prove
> that the support of (5) is contained in (7), `K` is constructible on the
> closed value disk with no boundary-value singularity, and nearby cycles
> transport the four normalized local Morse groups, then (3) is free of rank
> four in thimble degree five and its path-star basis consists of the four
> residual thimbles.  If, in addition, relative duality, `can/var`,
> orientations, and the nonbraiding labels are transported, then
> Thom--Sebastiani identifies the central directed pairing with the `P^3`
> pairing and the parameter transport preserves it for small `delta`.

In particular, the earlier demand for a common Whitney interface and an
excisive collar decomposition is a sufficient geometric implementation, but
not a necessary extra gate after the proper-support support theorem.  The
two-model closed bad-image inclusion is enough to kill every exterior value
cycle intrinsically.

This theorem still does not identify the compact-support/value-localized
thimbles with Iritani's individual global satellite thimbles.  The
monodromy-normalized satellite-to-localized map and its point-class shear
remain the Gamma marking gate.

## EJ/TT and mystery ledger

- **EJ:** once the intrinsic vanishing-cycle support is known, stratified
  Morse attachment assembles the relative group directly; an explicit common
  collar becomes redundant.
- **TT:** prove a statement about `Ra_!A`, not about every exceptional
  boundary component.  The path-star filtration is the natural unit of the
  value-localized theorem.
- **Settled:** under the explicit constructibility, boundary, and nearby-cycle
  hypotheses, support on four Morse sections gives a free rank-four thimble
  group through the intrinsic relative cone.
- **Open:** transport relative duality, `can/var`, orientations, and the four
  nonbraiding labels; then compare the resulting localized object with
  Iritani's residual Gamma/Orlov object.  Support alone does not determine the
  Seifert pairing.
