# C907 uniform pair-of-pants circuit lemma

**Lane:** `clebsch`

**Status:** a conditional compression lemma for the *geometric smoothness*
part of the full-initial replay.  It neither constructs the regular
modification nor proves a control/Fitting statement for the value map.

## Scope and exact hypothesis

Put

\[
 \mathcal U_0=\{\delta\ne0,\ y_1y_2y_3BC\ne0\}.
 \tag{1}
\]

The marked variables `U=1-B`, `V=1-C` are retained as pair-of-pants
relations; their zero loci are **not** removed from (1).  Fix a cone and a
residue stratum of a proposed regular log modification.  This lemma applies
only after the following data have already been proved chartwise:

1. the full initial complete intersection of the homogenized graph and
   `B+U-1`, `C+V-1`, saturated only by the pullback of the complement of
   (1), is the scheme-theoretic special fibre of a flat saturated Rees
   degeneration;
2. removal of the exact exceptional multiplicity gives the strict-transform
   equation on that chart; and
3. after eliminating the two pair-of-pants equations and inverting precisely
   the residue units of that stratum, the reduced graph equation has one of
   the normal forms below.

Thus this is not a support-mask assertion.  Its premises retain all residue
coefficients, pair-of-pants relations, and the true saturation set.

## Unit-circuit lemma

Let `k` have characteristic zero.  On a residue torus suppose the
positive-order strict initial graph is, up to multiplication by a unit,

\[
 H=\sum_{i\in I} c_i x_i+c_P P+c_RR=0,
 \qquad
 P=\frac{q}{x_1x_2x_3},\quad q\in k^*,
 \tag{2}
\]

where `I` is a subset of `{1,2,3}`, each displayed coefficient is a unit,
and absent terms have coefficient zero.  Here `R`, when present, is a residue
unit monomial admitting a logarithmic derivation `D_R` with

\[
 D_RR=R,\qquad D_Rx_i=D_RP=0.
 \tag{3}
\]

Condition (3) is an explicit chartwise hypothesis, not a consequence of
`R` merely being a Laurent monomial in the displayed coordinates.  It holds
when a verified unimodular monomial change makes `R` an independent residue
coordinate while leaving `P` fixed.  For example, writing
`R=b(1-c)` does not by itself prove (3): a derivation that also fixes a
`P` containing `bc` can degenerate along an additional residue locus.  Such
loci must be split into their own residue strata or discharged by the
reciprocal--linear alternative below.  This independence check is part of
the full-initial attachment record required later in this note.

Then `H=0` is smooth (or empty) on the residue torus.

**Proof.**  A singleton support is a nonzero unit and is empty.  If `R` is
present, (3) gives the unit derivative `D_RH=c_RR`.  If `R` is absent and
`P` is absent, any occurring `x_i` has unit derivative.  If `P` is present
but some `x_j` is absent, `D_{x_j}H=-c_PP` is a unit.  The only remaining
case contains `x_1,x_2,x_3,P` and not `R`.  Its logarithmic tangent equations
give

\[
 c_ix_i=c_PP\quad(i=1,2,3),
\]

so its graph equation would give `4c_PP=0`, impossible.  \(\square\)

The reciprocal--linear alternative is likewise uniform: the local tangent
equations identify all occurring reciprocal/linear terms with one nonzero
unit multiple, and the graph equation then gives `nP=0` for an integer
`n>=2`.  Its coefficient-uniform verification remains the two Laurent
circuit lemmas already cited by the relevant local reports; this note does
not replace those identities.

## Feasibility at positive normalization order

For the normalized six-weight system, suppose the `x_1,x_2,x_3,P` terms are
all maximal at a positive normalization order `m`.  Then

\[
 p_1=p_2=p_3=m,\qquad -p=m,qquad p=p_1+p_2+p_3.
 \tag{4}
\]

Hence `3m=p=-m`, so `m=0`.  Therefore this four-term circuit cannot occur at
positive order.  This is a useful feasibility compression, independent of
the smoothness proof above.  Every other positive-order support is discharged
by the unit-circuit lemma or by the reciprocal--linear alternative.

At order zero the strict initial graph is instead monic in `L`:

\[
 L-H=0.
 \tag{5}
\]

It is geometrically smooth as a graph because `partial_L` is a unit.  This
does **not** say that `L` is submersive relative to the chosen base or control
stratum; that requires the separate tangent-Fitting calculation.

## Nine coarse pair-of-pants types

Let `g=P^1 minus {0,infinity}`; it includes the auxiliary marked value `1`.
The following table is the finite attachment target for the full-initial
replay.  Each entry is further indexed by every regular support cone, its
faces, and its residue strata.  “Circuit” means (2)--(3) or the already
proved reciprocal--linear alternative, after the three hypotheses above have
identified the *full* initial complete intersection.

| `B` / `C` | `0` | `g` (including `1`) | `infinity` |
| --- | --- | --- | --- |
| `0` | two-pole circuit | one-pole circuit; attach the `(0,1)` seam before coarsening | zero/infinity circuit |
| `g` | symmetric one-pole circuit | generic, one-marked, and double-marked charts; positive order is circuit, order zero is monic in `L` | generic/infinity circuit; attach the `(1,infinity)` seam |
| `infinity` | symmetric zero/infinity circuit | symmetric generic/infinity circuit | double-infinity circuit |

The table proves no more than this conditional statement: once every entry
has been attached to an identified full initial complete intersection, all
its strict initial graphs are geometrically smooth or empty.  It can replace
cellwise smoothness eliminations across the 81,367 support cells; it does not
remove the need for a finite attachment proof that every cell has one of the
listed full initial forms.

## Why arbitrary resolution does not close the value-map gate

Regularizing an ambient pair can create new restricted critical loci for a
map even when the original map is a submersion.  Take

\[
 L=x:\mathbf A^2_{x,y}\longrightarrow\mathbf A^1
\]

and blow up the origin.  In the chart `x=u`, `y=uv`, the exceptional divisor
is `u=0` and `L|_{u=0}=0` is constant.  Thus the induced map on that boundary
stratum has zero differential, although `dL=dx` was everywhere nonzero
before the blowup.

Consequently a canonical wonderful compactification, barycentric regular
subdivision, or functorial embedded log resolution can provide a proper
regular ambient model and—under the full-initial hypotheses above—a smooth
strict graph.  It cannot by itself prove the desired relative
tangent-Fitting/submersivity theorem.  The coarse-control ledger remains
load-bearing: interior residual coordinates and the marked divisors `B=1`,
`C=1` must not be promoted automatically to control strata.

## Exact remaining replay

The minimal finite proof object is one attachment record

\[
(\sigma,\tau;I_{\sigma,\tau}^{\rm full},
 \text{saturation},\text{exceptional multiplicity},
 \text{normal form},\text{face maps})
\]

per cone, face, and residue stratum.  The circuit lemma can identify records
only after a coefficient-uniform chart isomorphism proves they have the same
full initial complete intersection.  The separate coarse-control record must
then recompute

\[
 \Omega^1_{(\mathcal G\cap T)_{\rm red}/\Delta}/\mathcal O\,dL
\]

on each globally defined control stratum `T`.

## Mystery ledger

- **Settled:** positive-order smoothness has a five-term circuit proof once
  the full pair-of-pants initial has been identified; the four-term support
  is infeasible at positive order.
- **Open:** the finite full-initial attachment replay, including residue
  coefficients and face maps.
- **Open:** every coarse-control Fitting calculation and the proper collar
  theorem.  Smooth strict graph does not imply either one.
