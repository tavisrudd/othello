# C907 toric residual first jet

**Lane:** `clebsch`

**Status:** exact local calculation.  It identifies the first residual
Kodaira--Spencer class.  Internal Stokes rigidity is conditional on the still
open filtered analytic mirror identification; the calculation does not
control the ambient--residual extension or Gamma central connection.

## Calculation

In the residual chart for `Bl_(P^3)P^5`, the exact expansion is

\[
 g_\delta=g_0+\delta^2R_2+O(\delta^3),
 \qquad g_0=f_Q(y)+ZU,
\]

with

\[
 R_2=A(Z^2+ZU+U^2)-A^2,
 \qquad A=\frac Q{y_1y_2y_3}.
 \tag{1}
\]

The Jacobian ideal of `g_0` contains

\[
 \partial_Zg_0=U,
 \qquad \partial_Ug_0=Z.
\]

More explicitly, for

\[
 V_Z=A(Z+U),
 \qquad
 V_U=AZ,
\]

one has

\[
 V_Z\partial_Zg_0+V_U\partial_Ug_0
 =A(Z^2+ZU+U^2).
 \tag{2}
\]

Thus an infinitesimal coordinate change in the negative `V` direction removes
all `Z,U` terms in (1), and

\[
 [R_2]_{\operatorname{Jac}(g_0)}=-[A^2].
 \tag{3}
\]

The remaining `y` equations give `y_1=y_2=y_3=A` and `A^4=Q`, so

\[
 \operatorname{Jac}(g_0)
 \cong\mathbf C[A]/(A^4-Q).
\]

Under the standard `P^3` mirror identification, `[A^2]` is the `H^4`
miniversal/big-quantum direction.  The critical-value correction
`4a-a^2delta^2+O(delta^3)` is exactly its evaluation at `A=a`.

## Consequence

The first residual deformation is tangent to the ordinary big-quantum base of
`P^3`, after a local right-equivalence of the double suspension.  With the
`exp(g/z)` convention, the Gauss--Manin first variation is

\[
 \nabla_{\partial t}=\partial_t-z^{-1}A^2
   +\text{coordinate gauge},\qquad t=\delta^2,
\]

up to the opposite sign for `exp(-g/z)`.

If the residual Brieskorn lattice is analytically identified, as a filtered
meromorphic connection, with the `P^3` big quantum connection along this
direction, then big-QDM isomonodromy makes the first **internal Stokes**
cocycle zero in a continuously marked wall-free sector.  The Jacobian
calculation alone does not supply that filtered identification.

This does not imply that the full enriched first jet splits:

- the Gamma central-connection matrix varies along the `H^4` direction;
- the Rees/irregular-Hodge realization can record that variation;
- the coordinate gauge is local and need not preserve the global
  compactification or primitive form;
- higher terms include `O(delta^3)=O(t^(3/2))`, so this jet alone is not a
  holomorphic big-QDM curve in `t`;
- the global rank-ten system has ambient--residual Stokes extensions; and
- identifying the residual lattice with the exact Orlov functor still needs
  the calibrated hyperplane/seed marking.

The next first-order calculation should therefore project the full toric
Gauss--Manin connection to the off-diagonal ambient--residual block.  Repeating
the internal `4 x 4` Stokes calculation has zero expected value.

## Mystery ledger

- **Settled:** the first local residual jet is `-H^4` modulo coordinate gauge.
- **Conditional:** it creates no first-order internal Stokes mutation after a
  filtered analytic big-QDM identification.
- **Open:** the off-diagonal ambient--residual extension, Gamma central
  connection, and Rees placement.
