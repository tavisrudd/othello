# C907 hostile audit: value-disk assembly and the `m=2` carrier threshold

**Lane:** `clebsch`

**Verdict:** the positive Krull--Schmidt conclusion for the `m=2` telescope
is correct under its stated strict-biproduct hypotheses.  A length-two center
cannot merge into the endpoint length-three block.  The value-disk note is
correct that a common collar is not intrinsically required *after* one has a
properly normalized constructible/duality package, but support on four Morse
points alone does not yet establish the advertised relative group and does
not determine its Seifert pairing.

## 1. The exact compact-support object

Let `a:U_Omega -> Omega` be the value map over a closed disk, put

\[
 K=Ra_!A_{U_\Omega},\qquad i_0:\{u_0\}\hookrightarrow\Omega,
 \tag{1}
\]

and keep cohomological conventions explicit.  The intrinsic relative
compact-support **cochain** complex is

\[
 \mathsf R(K;u_0)=
 \operatorname{Cone}\!\left(
 R\Gamma(\Omega,K)\longrightarrow i_0^*K
 \right)[-1].
 \tag{2}
\]

By the defining property of `a_!` and proper base change, (2) is the
compact-support relative cochain complex of
\((U_\Omega,a^{-1}(u_0))\).  It is this cone--not the unqualified notation
`H_*^c` in the target note--which has the path-star Morse filtration.

For a complex `n`-fold with a holomorphic Morse function, raw vanishing
cohomology is in Milnor-fibre degree `n-1`, while the relative thimble occurs
in degree `n`.  Thus the cone in (2) contributes the necessary one-degree
shift.  Converting (2) to the homological thimble convention further uses
the chosen Poincare--Verdier/relative-duality normalization.  In the C907
pilot `n=5`, this is the convention behind the earlier `H_5` statement.
The target's phrase "the usual one-degree shift" is directionally right but
is not a substitute for (2).

The locally constant summand is harmless, but it must be disposed of in this
form.  After cutting the disk along a distinguished star, the complement is
a contractible tree containing `u_0`.  For every locally constant complex
`L` on that tree,

\[
 R\Gamma(\text{tree},L)\xrightarrow{\sim}L_{u_0},
 \tag{3}
\]

so its cone (2) is zero.  Consequently a local-system part of `K` neither
adds nor subtracts thimbles.  This validates the intended rank argument,
provided that it is made on (2) and the value vanishing cycles are understood
as those of the constructible complex on the **value disk**.

## 2. What four supported Morse cycles do and do not give

Suppose the normalized value vanishing-cycle attachments at the distinct
`c_i` are free rank one in one degree and there are no boundary singular
values.  Repeated cutting and the standard specialization triangles give a
finite filtration of (2) whose quotients are those four attachment groups,
with the shift just described.  As they lie in a common degree, no differential
between different degrees survives.  Since `A=Z[1/6]` is a PID and the
quotients are free, the resulting group is free of rank four.

So the **rank-four** conclusion needs no common toroidal collar once the
following intrinsic data are in hand:

1. `Ra_!A` is constructible over the closed value disk and has no unrecorded
   boundary-value singularity;
2. the support statement concerns the value-disk vanishing cycles of this
   complex (with the convention in (2)), not only critical points on an
   auxiliary compactification; and
3. `psi_delta` gives four reduced local systems/sections with the same
   normalized local Morse group.  Merely knowing the special-fibre support
   does not rule out a parameter jump without this nearby-cycle statement.

The pairing assertion is stronger.  Verdier duality does **not** make
`K=Ra_!A_U` self-dual automatically:

\[
 D_\Omega(Ra_!A_U)\simeq Ra_*D_U(A_U),
 \tag{4}
\]

and for an open compactification `D(j_!A)=j_*D(A)`.  Thus duality naturally
pairs a compact-support object with its ordinary-support dual; it does not by
itself manufacture the relative Seifert form on `j_!A`.  Support and rank
also do not determine that form: the variation/canonical maps and the
chosen orientations of the rank-one local groups remain data.

The common collar is still not logically necessary.  It can be replaced by
an intrinsic **pairing transport** statement for the value-disk complex:
Poincare--Verdier duality with the chosen relative boundary condition,
Picard--Lefschetz variation maps, a distinguished nonbraiding path star, and
`delta`-nearby-cycle transport preserving all of them.  At `delta=0`,
Thom--Sebastiani then computes the `P^3` form; this enhanced transport, not
bare support, carries that form to small nonzero `delta`.

Accordingly, the safe consequence of the proper-support bad-image theorem is

\[
 \operatorname{rank}\mathsf H_{\rm th}=4
 \quad\text{conditional on (1)--(3),}
 \tag{5}
\]

whereas the directed `P^3` pairing remains conditional on the added
pairing/variation transport.  This is a genuine reduction of the old collar
gate, not a return to a common compactification.

## 3. The positive telescope and its exact threshold

Let `E` be the endpoint indecomposable `J_3`, and suppose the enriched
category is idempotent-complete Krull--Schmidt, the `m=2` endpoint calibration
has proved `E` indecomposable, and every Tate shift preserves its string
length.  The weak-factorization equality is an **actual finite biproduct**

\[
 \mathscr A(Y_0)\oplus\bigoplus T^j\mathscr A(Z_i^-)
 \simeq
 \mathscr A(Y_N)\oplus\bigoplus T^j\mathscr A(Z_i^+).
 \tag{6}
\]

If `E` is a summand of the left endpoint, the right endpoint has no cubic
packet, and every center indecomposable has length at most two, then (6) is
impossible.  Krull--Schmidt uniqueness forces an indecomposable isomorphic to
`E` on the right, but all its possible sources have length at most two.
Neither mixing by an isomorphism of a biproduct nor extensions internal to a
single length-two center can change that conclusion.  Such a merger is
possible only when the blow-up comparison is an exact sequence or an
associated graded with an uncontrolled off-diagonal extension; it is excluded
by the strict-biproduct hypothesis.

The indexing is correct when `ell` counts vertices in a consecutive Rees
string:

\[
 \ell=1\Longleftrightarrow N=0,\qquad
 \ell=2\Longleftrightarrow N\ne0,\ N^2=0,\qquad
 \ell=3\Longleftrightarrow N^2\ne0,\ N^3=0.
 \tag{7}
\]

Hence the landed one-step, square-zero/length-two formal countermodel is
indeed harmless for this telescope.  A nonzero second composite is the first
possible source of a `J_3`-type obstruction, subject to identifying the Rees
arrow with the relevant `N`.

There is one terminology correction.  The exact weakest carrier condition is
not the numerical bound `ell<=2`; it is

\[
 \text{no }T^jE\text{ occurs as an indecomposable summand of any center
 packet.}
 \tag{8}
\]

The uniform bound `ell<=2` is a clean sufficient condition for (8), but a
threefold might have a *different* length-three indecomposable and still be
harmless to the `m=2` contradiction.  Therefore the target note should call
`ell<=2` the sharp **numerical sufficient threshold**, not say it is
equivalent to exclusion of the endpoint signature.  It must also retain the
three independent hypotheses: actual enriched biproducts rather than graded
identities, Krull--Schmidt finiteness, and endpoint `J_3` indecomposability.

## EJ/TT and mystery ledger

- **EJ:** proper-support support eliminates the collar as a separate
  compactification problem, but the relative cone and its duality/variation
  data are the irreducible topological object.
- **TT:** rank is a support calculation after the locally constant summand is
  killed by (3); the Seifert matrix is an additional pairing calculation.
- **Settled:** length-two center strings cannot form a length-three endpoint
  inside a genuine Krull--Schmidt biproduct.  The square-zero countermodel is
  not an `m=2` obstruction.
- **Open:** normalized compact-support/duality and pairing transport for the
  four value cycles; the exterior bad-image descent; strict enriched blow-up
  biproducts; and either (8) or the stronger numerical carrier bound.
