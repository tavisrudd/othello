# C519 — universal residual-discriminant base-locus theorem

**Lane:** `reed-solomon` · **Status:** queued after C518

## Objective

Replace the fixed-redundancy ladder by one arbitrary-degree theorem. For every syndrome degree
`n`, factor a candidate split squarefree kernel member as

\[
 g=P Q,\qquad \deg P=n-3,\quad \deg Q=2,
\]

derive the universal residual-quadratic discriminant covariant, classify its zero/square base locus
scheme-theoretically in every characteristic, and use genus-at-most-one slices to prove the
strongest justified arbitrary-redundancy high-field PRS deep-syndrome theorem.

The task succeeds only if it identifies the complete persistent/modular carrier or the first
proved additional component. A field census, an unchecked genericity assertion, or a theorem
conditional on an unnamed exceptional locus does not pass.

Eventual report: `notes/2026-07-23-c519-universal-residual-discriminant.md`.

## Third-order structural reduction

For

\[
 P(t)=\sum p_it^i,\qquad
 H_j(P)=\sum_i a_i p_{i+j}\quad(j=-1,0,1,2),
\]

the residual system is

\[
 H_0-sH_1+uH_2=0,\qquad
 H_{-1}-sH_0+uH_1=0.
\]

Its minors are

\[
\begin{aligned}
D&=H_0H_2-H_1^2,\\
N_s&=H_{-1}H_2-H_0H_1,\\
N_u&=H_{-1}H_1-H_0^2,
\end{aligned}
\]

and

\[
K=N_s^2-4DN_u.
\]

Writing `(A,B,C,D_3)=(H_{-1},H_0,H_1,H_2)`, expansion gives

\[
K=A^2D_3^2-6ABCD_3-3B^2C^2+4AC^3+4B^3D_3.
\]

Away from the modular normalization issue at characteristics two and three, this is `-1/27`
times the ordinary discriminant of

\[
A X^3+3B X^2Y+3CXY^2+D_3Y^3.
\]

In divided-power coordinates the displayed integral polynomial is the definition in every
characteristic. Thus the universal branch object is the pullback of the binary-cubic discriminant
under the linear contraction map

\[
L_f:\operatorname{Sym}^{n-3}E^\vee\longrightarrow\Gamma^3E,\qquad
P\longmapsto(H_{-1},H_0,H_1,H_2).
\]

The geometric target is the discriminant surface/tangent developable of the twisted cubic. The
full problem becomes a classification of the linear maps `L_f` whose discriminant pullback is
zero, a square, inseparable, or has every root-compatible line slice degenerate.

## Quantitative dividend

Fix `n-4` roots of `P` and vary its final root `x`. Universally,

\[
\deg_xD,\deg_xN_s,\deg_xN_u\le2,\qquad \deg_xK\le4.
\]

After square factors are removed, every admissible slice has genus at most one. Its deletion
budget is

\[
\delta_n\le(n-4)+2+4+2(n-4)+4=3n-2.
\]

The crude rational-base bound is also explicit. The bad-slice discriminant has degree at most 24
in each of the `n-4` fixed roots, and their Vandermonde has degree
`\binom{n-4}{2}`. Hence

\[
B_n\le24(n-4)+\binom{n-4}{2}
   =\frac{(n-4)(n+43)}2.
\]

If the geometric base-locus theorem passes, then

\[
q>B_n,\qquad q+1-2\sqrt q>3n-2
\]

is an immediate arbitrary-degree sufficient range. Sharpening `B_n` by a finite covariant slice
family is an extra-juice gate after, not before, the base locus is classified.

## Execution order

1. **Integral intrinsicization.** Construct `L_f`, the three residual minors, `K`, the residual
   quadratic, and the determinant/branch/diagonal/collision divisors over `Z` using divided powers.
   Prove `GL2`, scalar, base-change, and Frobenius transport.
2. **Discriminant identification.** Identify `K` with the integral divided-power binary-cubic
   discriminant and its twisted-cubic tangent developable, with separate characteristic-two and
   characteristic-three statements rather than division by `27`.
3. **Linear-pullback classification.** Classify the possible image subspaces of `L_f` and determine
   exactly when `K_f=K\circ L_f` is zero, a square, or inseparable. Translate every case back to a
   syndrome condition.
4. **Carrier comparison.** Prove that the resulting locus is precisely the persistent
   catalecticant rank-two and Lucas-nucleus carriers, or exhibit and classify the first genuine
   additional component. Do not identify carriers from dimensions or finite-field points alone.
5. **Root-compatible line lemma.** Prove that outside the carrier there is a pencil
   `P=R(t)(t-x)` whose reduced quartic branch is geometrically integral. A general projective line
   is insufficient unless it is proved to come from `n-4` distinct fixed roots.
6. **Arithmetic theorem.** Retain all determinant, branch, repeated-root, and fixed/residual
   collision divisors; apply affine base selection and Hasse--Weil to obtain an explicit
   arbitrary-redundancy field bound.
7. **Orbit clause.** State the persistent `T/T^(n)` and tangent-cocycle law only where already
   proved uniformly. Any new modular carrier needs its own stabilizer and Frobenius analysis.
8. **Evidence and audit.** Commit the exact symbolic generator, compact certificate, independent
   replay, claim-specific literature delta, checksum manifest, mystery ledger, and exact
   regeneration commands atomically.

## Cheap first probes

- Verify the cubic-discriminant identity integrally and modulo `2,3,5,7`.
- Compute ranks and image-subspace types of `L_f` on the known C491/C498/C509/C513/C516 persistent
  and modular normal forms; use frozen representatives and do not regenerate their censuses.
- For `n=5,6,7,8`, compare the saturated square/zero locus of `K_f` with the already proved carrier
  ideals. Any disagreement is the stop signal and candidate new component.
- Test whether finitely many root-compatible pencils generate a unit discriminant ideal at each
  calibration level; this is evidence for, not a substitute for, the uniform line lemma.

## Acceptance gates

- One characteristic-free theorem statement over arbitrary base schemes.
- Exact zero/square/inseparable base-locus classification, with no unnamed generic open set.
- Root-compatible geometrically integral slice outside the classified carrier.
- Explicit field threshold derived from stated degrees and deletion divisors.
- Recovery of the proved fixed-level carrier boundaries through C516 without weakening them.
- No ambient projective census and no extrapolation from bounded degree.
- Claim-specific literature audit and atomic reproducibility bundle.

## Stop rules

- If `K_f` has an additional irreducible base-locus component, stop after proving its equations,
  dimension, generic image type, and distinction from persistent/Lucas carriers. That is a valid
  theorem, not a failure to be hidden.
- If a non-square `K_f` can nevertheless restrict to a square on every root-compatible pencil,
  stop with the exact incidence obstruction; do not replace root-compatible pencils by arbitrary
  lines.
- If characteristic two or three changes the discriminant surface scheme, retain the modular
  component and formulate a separate theorem. Do not infer it by reduction from characteristic
  zero.
- Do not allocate fixed-redundancy ten as a substitute for this base-locus gate.

## Extra-juice questions

- Does the image of `L_f` being contained in a tangent plane or secant plane to the twisted cubic
  recover exactly the persistent and nucleus carriers?
- Is the common-square locus governed by a classical Foulkes/Hermite covariant, making its ideal
  representation-stable in `n`?
- Can a bounded number of root-compatible pencils generate the saturated discriminant ideal
  uniformly, reducing the crude quadratic `B_n` to a linear threshold?
- Does the q=49 “last pure quartic” phenomenon generalize: are long finite-field survivor
  plateaus always distinguished-root slice artifacts detected by the determinant divisor?

## Nonclaims

- This task does not assume the full Reed--Solomon deep-hole conjecture.
- It does not claim that arbitrary projective lines in `P(Sym^(n-3)E)` are split-root pencils.
- It does not identify geometric integrality with nonsquareness before removing square factors
  and inseparable multiplicity.
- It does not classify bounded small fields unless the arbitrary-degree theorem leaves a finite,
  theorem-derived calibration band and a separate task is allocated.
