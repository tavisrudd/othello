# C907 — a punctual Fourier corner is a full-support output

Date: 2026-08-13

Status: exact two-boundary singular-shadow no-go and sharper replacement
target.  Support at the intersection of the two deleted Fourier axes is not
a rank-zero condition.  A punctual Fourier module is killed by either
one-wall localization, but inverse Fourier transform turns it into a
constant module of generic rank one.  Thus the unlocalized boundary object
is necessary data, while its bare boundary support does not prove the
rank-zero-target statement.

## 1. The rank-one Weyl-algebra countermodel

Let

\[
 D_x=\mathbf C\langle x_1,x_2,\partial_{x_1},\partial_{x_2}\rangle,
 \qquad
 D_\tau=\mathbf C\langle \tau_1,\tau_2,
                    \partial_{\tau_1},\partial_{\tau_2}\rangle.
\]

Use the algebraic Fourier transform with

\[
 x_i\longmapsto-\partial_{\tau_i},
 \qquad
 \partial_{x_i}\longmapsto\tau_i.                              \tag{1}
\]

The constant connection and the punctual delta module are

\[
 \mathcal O_{\mathbf A_x^2}
   =D_x/D_x(\partial_{x_1},\partial_{x_2}),
 \qquad
 \delta_0=D_\tau/D_\tau(\tau_1,\tau_2).
\]

Equation (1) gives the exact identities

\[
 \operatorname{FL}(\mathcal O_{\mathbf A_x^2})=\delta_0,
 \qquad
 \operatorname{FL}^{-1}(\delta_0)=\mathcal O_{\mathbf A_x^2},   \tag{2}
\]

up to the harmless conventional signs and cohomological shift.

Let `j_i` invert `tau_i`.  Since `tau_i` acts nilpotently on `delta_0`,

\[
 j_i^*\delta_0=0\quad(i=1,2),
 \qquad
 j_{12}^*\delta_0=0.                                            \tag{3}
\]

Thus every receiver which localizes at either Fourier coordinate deletes
this object.  Nevertheless the inverse transform in (2) has generic rank
one.  On characteristic cycles, the same statement is the symplectic
exchange

\[
 [T_0^*\mathbf A_\tau^2]
 \longleftrightarrow
 [T_{\mathbf A_x^2}^*\mathbf A_x^2].                            \tag{4}
\]

The coefficient of the punctual cotangent fibre before inverse transform
is exactly the coefficient of the output zero section afterward.

This is already a two-wall countermodel: it is invisible on both punctured
axes and lives only at their common boundary, but it becomes a full-support
output rather than a boundary-supported output.

## 2. The primitive-sixth, paired, and tagged versions

Let `E_(1/6)` be any rank-one meromorphic `z`-connection with formal
monodromy `zeta_6`, and form

\[
 \mathcal B=\delta_0\boxtimes E_{1/6}.                           \tag{5}
\]

Both localizations in (3) still kill `B`, whereas

\[
 \operatorname{FL}^{-1}(\mathcal B)
   =\mathcal O_{\mathbf A_x^2}\boxtimes E_{1/6}                 \tag{6}
\]

has a generic-rank-one primitive-sixth output.  Hyperbolically doubling
(5) with its dual gives a flat nondegenerate self-dual object.  Tensoring
with

\[
 \mathbf Q[N]/(N^3)
\]

gives the length-three projective-space tag and commutes with (2)--(6).
Consequently pairing, self-duality, primitive-sixth formal monodromy, and
the common nilpotent tag do not turn double-boundary support into output
rank zero.

The model is algebraic and holonomic, but it is not asserted to be a quantum
connection of a smooth projective peak.  Its role is logical: any proposed
singular proof must impose more than support at `tau_1=tau_2=0`.

## 3. The exact scalar shadow

Let `B_corner` denote the **relative complete oriented correction** left by
the two Fourier localizations after subtracting the common point column,
including its `! -> *`, duality, and `can/var` maps.  Write

\[
 \mu_{00}(B_{\rm corner})
\]

for its signed punctual multiplicity: the alternating multiplicity of
`delta_0` in the derived Jordan--Holder class.  Fourier transform and (4)
give

\[
 \mu_{00}(B_{\rm corner})
 =\operatorname{mult}_{T_Y^*Y}
   CC\bigl(\operatorname{FL}^{-1}B_{\rm corner}\bigr).          \tag{7}
\]

Therefore the singular form of the desired rank-row theorem is not

```text
the correction is supported at the Fourier corner,
```

but the strictly stronger signed identity

\[
 \boxed{\mu_{00}(B_{\rm corner})=0}                             \tag{8}
\]

on the carrier primitive-sixth component.  Individual punctual
constituents may occur: the `dP7` window calculation warns that complete
blocks can cancel only after aggregation.  Equation (8), not termwise
absence of punctual factors, has the correct granularity.

Equivalently, take the two-coordinate Cech square

\[
 \begin{matrix}
 B&\longrightarrow&B[\tau_1^{-1}]\\
 \downarrow&&\downarrow\\
 B[\tau_2^{-1}]&\longrightarrow&B[(\tau_1\tau_2)^{-1}].
 \end{matrix}                                                    \tag{9}
\]

The total cofiber is the corner local-cohomology object.  The next
structural theorem is **rank-row Cech exactness**: after the primitive-sixth
point-row projection, the signed punctual class of the total cofiber of
(9) is zero.  This is a precise double-boundary cleanliness statement.

## 4. Cheapest monodromy sieve and its failure at the peak

There is one immediate way to force corner acyclicity.  Let `L` be a local
system on `(Delta^*)^2` with commuting monodromies `T_1,T_2` on a vector
space `V`.  The derived stalk of `Rj_*L` at the corner is the Koszul complex

\[
 V\xrightarrow{d_0}V^2\xrightarrow{d_1}V,                      \tag{10}
\]

where

\[
 d_0(v)=((T_1-1)v,(T_2-1)v),
 \qquad
 d_1(a,b)=(T_2-1)a-(T_1-1)b.                                   \tag{11}
\]

If either `T_i-1` is invertible on a joint generalized eigenspace, (10) is
contractible there.  Hence only the joint `(1,1)` primary can contribute a
punctual corner class.  In rank one, a corner class is possible only when
both monodromies are one.

This sieve is exact but does not close C907.  The ambient block at the
intrinsic large-radius corner is unipotent in both exceptional variables;
the point row and the ambient primitive-sixth carrier therefore lie in the
joint `(1,1)` parameter primary.  In the extreme case `T_1=T_2=1`, (10) has

\[
 H^0=V,\qquad H^1=V^2,\qquad H^2=V.                             \tag{12}
\]

Thus the only primary which can carry the desired invariant is also exactly
the primary on which punctual Fourier escape is allowed.

## 5. Consequence and next attack

The first singular shadow is now completely classified.

1. One-wall localization cannot see the dangerous corner object by (3).
2. Double-boundary support does not make it rank zero by (2) and (4).
3. Nontrivial parameter monodromy kills it by (10), but the geometric
   ambient block is jointly unipotent, so that cheap sieve is unavailable.
4. Duality and the projective-space nilpotent tag do not kill it by (5)--(6).

There is an important marking refinement.  The common-open point column is
itself constant in the wall-frequency variables, hence becomes a canonical
punctual Fourier class.  Punctuality is therefore not the defect.  The defect
is an **additional or differently marked** punctual class in the relative
correction.  Algebraically, the window quotient has one ambient punctual
line generated by the point lift; all other punctual lines come from wall
strata and have rank zero.

The next viable shadow is therefore **marked punctual saturation**:

\[
 \frac{\text{punctual Fourier space}}
      {\text{wall-supported punctual space}}
 \quad\text{is one-dimensional and generated by the common point lift},  \tag{13}
\]

and both incident analytic receivers induce that same generator.  Equation
(13) implies the signed oriented corner identity (8).  A proof may come from
any of the following equivalent stronger inputs:

- the point-row image of the Cech total cofiber (9) is zero;
- the complete two-order Mellin--Barnes residues have zero punctual Fourier
  multiplicity after unstable-stratum grouping;
- the analytic transition and the algebraic window transition have the same
  augmentation row; or
- the unlocalized carrier component is clean at the corner in a way which
  controls the signed total complex, not merely its support.

The last clause is load-bearing.  A statement that the boundary object is
punctual proves nothing: `delta_0` is the counterexample.

## EJ / TT / AA

- **EJ:** the dangerous generic-rank output has the cheapest possible
  singular avatar: one punctual Fourier delta at the two-wall corner.
- **TT:** Fourier transform reverses the intuitive support direction.  A
  point at the Fourier boundary becomes a constant full-support object.
- **AA:** compute only the signed `delta_0` coefficient of the complete
  two-wall Cech/residue correction, or prove the marked multiplicity-one
  quotient (13).  Every other characteristic-cycle coefficient is
  irrelevant to the rank row.
