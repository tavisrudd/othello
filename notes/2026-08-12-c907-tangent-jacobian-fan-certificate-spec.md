# C907 tangent-Jacobian fan certificate specification

**Lane:** `clebsch`

**Status:** executable proof specification; no existence claim.

## Input graph

Put `Y=y_1y_2y_3`, `S=y_1+y_2+y_3`, and work with `Q!=0`.  The normalized
potential

\[
 F_\delta=S+\frac{Q}{YBC}+\delta^{-2}(1-B)(1-C)
\]

has cleared graph equation

\[
 P=\delta^2YBC(L-S)-\delta^2Q-YBC(1-B)(1-C)=0.
 \tag{1}
\]

The relevant closure is not the closure of `(P)` in an arbitrarily chosen
compactification.  In every chart it is the normalization of the closure of
the original torus graph, defined by

\[
 \sqrt{(I_{pullback}:(\delta y_1y_2y_3BC)^\infty)},
 \tag{2}
\]

where every factor is pulled back under the chart map.  This saturation removes
components disjoint from the original torus but retains genuine special-fibre
intersections of its closure.  Every chart certificate must display the map
from the original `delta*Y*B*C!=0` torus and verify that its defining ideal is
(2); otherwise an exceptional component may be spurious.

## Required modification

Construct one finite common refinement of:

1. the normalized blow-up of the residual ideal `(delta,B-1,C-1)`;
2. the graph modifications for the ratios among
   `delta`, `B`, `C`, `1-B`, and `1-C`;
3. a toric compactification of the `y`-torus refined by the Newton fans of
   `(1)` and all its relative logarithmic derivatives; and
4. a log resolution of the reduced saturated graph and its relative tangent
   logarithmic-Jacobian ideal.

The fourth item is essential.  Principalizing the individual polar summands or
their derivatives does not control cancellations in `P`.

Each affine chart `U_sigma` must have boundary coordinates `x_1,...,x_a`,
unit coordinates `u_1,...,u_b`, and equations `G_sigma`.  Record which
components of the original torus map to it and the exact transition maps on
every nonempty overlap.  Ramification used to clear rational cone weights is
part of the chart data.

## Tangent-Jacobian certificate

For every boundary stratum `T` of every chart, form the **reduced induced
subscheme of the saturated graph** on `T`; do not merely set the boundary
coordinates to zero in a possibly redundant equation list.  Let
`D_1,...,D_e` be a basis of logarithmic derivations in
the source directions tangent to `T`, excluding `delta` and `L`.  For a
hypersurface chart that remains reduced and of expected codimension on `T`,
the fibrewise critical ideal is

\[
 J_T=(P_T,D_1P_T,\ldots,D_eP_T).
 \tag{3}
\]

If the hypersurface equation vanishes identically on `T`, recompute the reduced
induced ideal: `L` may then be a free coordinate rather than a critical one.
The authoritative definition in every chart uses the reduced induced stratum
`S_T`, its relative dimension `d`, and

\[
 M_T=\Omega^1_{S_T/\Delta_\delta}/\mathcal O_{S_T}\,dL.
 \tag{4}
\]

The critical locus is the vanishing locus of
`Fitt_(d-1)(M_T)`.  Equivalently, if `I_T` is a smooth expected-codimension
`c` complete intersection in a smooth relative ambient chart, use the
`(c+1)`-minors of the matrix with rows `dI_T` and `dL`.  Formula (3) is only
the reduced expected-codimension hypersurface shortcut.  Compute this ideal
from the **whole transformed graph**, not termwise.
Saturate by chart units and by the ideals of deeper strata already assigned to
separate charts.

The certificate for `T` must prove exactly one of:

- **free:** the saturated critical scheme has empty intersection with the
  bounded `L`-window, so `L|_T` is a submersion.  This does not yet make `L` a
  product coordinate.  Algebraically, eliminate to
  the `L`-line and either obtain the unit ideal or isolate every root of the
  elimination polynomial outside `Omega`;
- **residual:** its support lies in the strict transform of
  `(delta,B-1,C-1)` and the exact `(Z,U)` or `(r,v,h)` transition identifies it
  with the retained `f_Q+ZU` core; or
- **empty:** the saturated initial graph ideal itself is the unit ideal.

An open-torus logarithmic gradient estimate is only a consistency check.  It
does not substitute for (3), because normal derivatives can remain nonzero
while `dL` vanishes on a boundary stratum.

## Finite replay object

For each cone/stratum store:

1. primitive ray generators and any ramification index;
2. the Laurent substitution and its inverse on the dense torus;
3. generators of the reduced saturated graph ideal;
4. the stratum ideal and tangent derivation matrix;
5. the saturated critical ideal and a Gröbner certificate for its assigned
   outcome;
6. the neighboring chart IDs and transition equalities; and
7. whether it meets the bounded value disk `Omega`.

The global replay must verify completeness of the fan, coverage of all faces,
and equality of the overlap ideals.  A finite list of individually correct
charts without those checks is not a compactification theorem.

## Topological acceptance after the algebra passes

Only after every stratum passes may one choose collars.  On the nonresidual
union and on every finite intersection, exhibit the pair

\[
 (N_I\times\Omega,N_I\times\{u_0\}),
\]

with `L` the second projection.  Relative Mayer--Vietoris then kills the
exterior fibrewise, including semistable charts such as `delta=et`.  The
remaining proper residual core may be transported by parameterized Morse
theory.  This yields the value-localized rank-four system, not the global
rank-ten rapid-decay group.

## Acceptance gate

The toric order-zero pilot passes only when:

- the finite algebraic replay above is green;
- a second implementation checks the same initial and saturation ideals;
- the collar cover and every intersection are explicit; and
- the four transported thimbles are shown to form the hyperplane-monodromy
  orbit in Iritani's residual Orlov/Gamma subgroup.

## EJ/TT and mystery ledger

- **EJ:** the new certificate targets the smallest finite datum that can prove
  the missing theorem; no global Stokes computation is needed at this gate.
- **TT:** compute the graph and tangent Jacobian together.  Any workflow that
  resolves derivatives first can miss cancellation strata.
- **Open:** finiteness and actual construction of a passing common fan.
- **Open:** product collars after the algebraic fan passes.
- **Open:** hyperplane-orbit marking of the four localized thimbles.
