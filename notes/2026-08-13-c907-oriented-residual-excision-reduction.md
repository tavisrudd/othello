# C907 oriented residual-excision reduction

**Lane:** `clebsch`

**Status:** exact reduction of the remaining internal order-zero Stokes gate.
The support/rank theorem is closed.  The directed `P^3` matrix is equivalent
to one morphism of compact/ordinary vanishing-cycle diagrams being an
isomorphism; no further fan, collar, or critical-point calculation is needed.

## The diagram

Let `N` be a compact residual tube in the simultaneous ratio model containing
the four Morse sections and no other bounded critical point.  Write `K_!` and
`K_*` for the intrinsic compact and ordinary extensions of the original open
graph, and `K_(N,!),K_(N,*)` for their residual-tube counterparts.  Fix a
regular boundary value, an ordered nonbraiding path star, the `can/var`
convention, and complex orientations.  The remaining theorem is that

\[
 \left(
 \psi_\delta\phi_{L-u}K_!
 \longrightarrow
 \psi_\delta\phi_{L-u}K_*;
 \operatorname{can},\operatorname{var}
 \right)
 \longrightarrow
 \left(
 \psi_\delta\phi_{L-u}K_{N,!}
 \longrightarrow
 \psi_\delta\phi_{L-u}K_{N,*};
 \operatorname{can},\operatorname{var}
 \right)
 \tag{1}
\]

is an isomorphism for every `u` in the residual value disk, compatibly with
Poincare--Verdier duality.

## Two-cone criterion

Let `C_!` and `C_*` be the cones of the two vertical arrows underlying (1).
Then (1) is an isomorphism if and only if

\[
 \psi_\delta\phi_{L-u}C_!=0,
 \qquad
 \psi_\delta\phi_{L-u}C_*=0,
 \tag{2}
\]

and these vanishings commute with the natural `! -> *` morphism.  Proper
duality identifies `C_*` with the Verdier dual of `C_!`, up to the fixed
dimension shift and twist, provided the actual-boundary constructibility
data are the same.  Thus the practical theorem is one self-dual exterior
acyclicity statement, not two independent calculations.

The landed whole-fibre logarithmic/ratio products prove the `!`-side support
vanishing.  To upgrade them to (2), record the controlled products for the
dual actual-boundary stratification and verify that the exterior inclusion
and retraction commute with `j_! -> Rj_*`.  Proper modification functoriality
then transports (2) between the two models.

## Central identification

At `delta=0`, the residual tube is the full Lefschetz pair of

\[
 f_Q(y)+ZU.
 \tag{3}
\]

It is not enough to identify only its four germs.  Identify the compact and
ordinary boundary map of the entire tube with that of (3), orient the `ZU`
thimble to have self-Seifert value `+1`, and use the fixed ordered path star.
Thom--Sebastiani then gives the Beilinson `P^3` matrix.  Contractibility of
the parameter disk and absence of braid transport that exact matrix.

## Logical endpoint

Equation (1) is necessary because a Hurwitz move preserves all local Morse
germs and rank but mutates the directed matrix.  It is sufficient because
proper pushforward already preserves `j_! -> Rj_*`, duality, and `can/var`.
Therefore the internal toric order-zero theorem has exactly one remaining
topological datum: prove the oriented residual-excision diagram (1).

This theorem is still prior to the integral hyperplane-equivariant
Orlov/Rees comparison and positive-order strict blow-up biproduct.

## EJ/TT and mystery ledger

- **EJ:** duality turns the compact/ordinary exterior problem into one
  self-dual cone vanishing, so the pairing gate is not twice the support gate.
- **TT:** local `A_1` data are invariant under Hurwitz mutation; the full
  `! -> *`, `can/var` diagram is the minimum object that remembers directed
  order.
- **Settled:** necessary and sufficient pairing-level residual-excision
  statement and its two-cone/duality reduction.
- **Open:** serialize dual-compatible actual-boundary products and the central
  full-tube Thom--Sebastiani identification.  No additional local critical or
  fan mystery remains.
