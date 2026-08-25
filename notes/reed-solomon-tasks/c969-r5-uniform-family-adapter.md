# C969 uniform R5 family adapter

## Boundary

This adapter recognizes the nonpersistent theorem families in redundancy five
without consulting a finite orbit row. The finite registry remains first in
the evidence order on its frozen fields, so its exact orbit and stabilizer
metadata are preserved there. Above that surface the positive certificate
records a formula invariant instead.

The input is the intrinsic cubic pencil

\[
 L(f)=\ker\begin{pmatrix}
 s_0&s_1&s_2&s_3\\
 s_1&s_2&s_3&s_4
 \end{pmatrix}.
\]

Persistent common-quadratic pencils are handled before this adapter.

## Tame osculating families

Assume the characteristic is not three and choose a basis `c,d` of `L(f)`.
The binary-quartic Jacobian

\[
 J(c,d)=c_Td_U-c_Ud_T
\]

changes only by a nonzero scalar when the pencil basis changes. Its divisor is
the ramification divisor of the associated cubic map. The geometrically cyclic
stratum has two totally ramified points, so

\[
 J(c,d)=\lambda Q^2
\]

for a squarefree binary quadratic `Q`. Conversely, this divisor shape gives
two total ramification points; Riemann--Hurwitz exhausts the degree-four
ramification divisor, and the degree-three cover is geometrically cyclic.

The implementation extracts `Q` coefficientwise and verifies the reconstructed
quartic, so it does not trust a discriminant shortcut. In characteristic two,
odd coefficients of a square vanish and inverse Frobenius gives the unique
coefficient square roots. In odd characteristic, the first nonzero coefficient
normalizes `Q` and the remaining coefficients are solved triangularly; direct
resquaring is the final check. Both affine and infinity roots are counted.

- Two rational roots give the rational ramification pair `O+`, which is deep
  exactly when `q mod 3 = 2`.
- No rational roots give the conjugate pair `O-`, which is deep exactly when
  `q mod 3 = 1`.
- A repeated rational root or a nonsquare Jacobian shape is not accepted by
  this adapter.

The emitted invariants are
`r5.cyclic_jacobian_square:rational_ramification_pair:q_mod_3=2` and
`r5.cyclic_jacobian_square:conjugate_ramification_pair:q_mod_3=1`.

## Characteristic three

In characteristic three a cube of a linear form has only its `U^3` and `T^3`
coefficients. Intersecting `L(f)` with this two-dimensional cube subspace is
therefore a two-by-two nullspace calculation.

- The fixed syndrome `e2` has an all-cube pencil and is the nucleus family.
- In the wild stratum the intersection is one-dimensional. If its cube is
  `ell^3`, choose a rational affine coordinate with `ell=1`. Modulo the cube
  generator, normalize the other pencil member to

  \[
  z^3+az+b.
  \]

  Changing the affine origin alters only `b`, and changing the coordinate
  scale multiplies `-a` by a square. Thus the square class of `-a` is intrinsic.
  The adapter accepts exactly the nonsquare class, equivalently the case where
  `z -> z^3+az` has irrational kernel and is bijective on the base field.

The emitted invariants are `r5.char3_cube_pencil:fixed_nucleus` and
`r5.char3_additive_kernel:minus_linear_nonsquare`.

## Certificate replay

The independent deep-certificate verifier recomputes the pencil and the same
formula invariant from the original normalized syndrome. It separately
recomputes the semilinear canonical transporter and checks the R5 radius-four
row in `c969-theorem-domain-v1.json`. A formula recognition is therefore not a
substitute for either canonical transport or covering-radius promotion.

Regression tests classify the rational osculating representative `e2` over
`F_53`, beyond the generated registry, and replay its positive certificate.
They construct a conjugate-pair syndrome over `F_61` from the two conjugate
cubic powers and recover `O-`. The characteristic-three nucleus and wild
normal forms are replayed over `F_9`.
