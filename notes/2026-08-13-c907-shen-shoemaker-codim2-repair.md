# C907 — codimension-two repair in Shen--Shoemaker

Date: 2026-08-13

Status: source-local lemma.  The printed proof of the Gamma/Orlov asymptotic
theorem for standard flips has an `r-s=1` omission.  For a codimension-two
blow-up, the omitted `I`-to-`J` normalization follows directly from their
formula (35) and their stated cone membership.  Appendix A then supplies the
correct Meijer aperture.  No claim about the full ambient-Novikov comparison
is made here.

## 1. Source boundary

For a blow-up, Shen--Shoemaker use `s=1`; codimension two means

\[
 (r,s)=(2,1),\qquad \nu=r-s=1.
 \tag{1}
\]

Their Theorem 4.4 assumes `r-s>1` when identifying formula (35) with the
extremal `J`-function.  Remark 4.5(3) says that when `r-s<=1` the same series
lies on Givental's overruled Lagrangian cone, but claims it is not
`J`-normalized.  Section 7 again says `r-s>1` before applying the Barnes
asymptotic, even though Appendix A, Theorem A.1 explicitly includes `nu=1`
with `epsilon=1/2`.

Thus Theorems 1.4 and 9.14 are stated for blow-ups without repeating a
restriction, but their printed dependency chain does not literally cover
(1).

## 2. Exact `z`-order calculation

Specialize formula (35) to (1):

\[
 I^T(q,\mathbf t,z)
 =z e^{\mathbf t/z}q^{c_1(T)/z}
 \sum_{d\ge0}q^d
 \frac{\prod_{m=0}^{d-1}(\sigma-H-mz)}
 {\prod_{i=1}^{2}\prod_{m=1}^{d}(\rho_i+H+mz)}.
 \tag{2}
\]

The `d=0` summand is exactly

\[
 z e^{\mathbf t/z}q^{c_1(T)/z}.
 \tag{3}
\]

For `d>=1`, the factor with `m=0` in the numerator is `sigma-H` and has no
`z`.  The remaining `d-1` numerator factors have `z`-degree at most `d-1`.
The denominator has `2d` factors and, expanded at `z=infinity`, begins in
degree `2d`.  Including the leading factor `z`, the `d`th summand has maximal
`z`-order

\[
 1+(d-1)-2d=-d\le-1.
 \tag{4}
\]

Consequently

\[
 I^T(q,\mathbf t,z)
 =z e^{(\mathbf t+\log(q)c_1(T))/z}
  +O(z^{-1}).
 \tag{5}
\]

There is no curve-induced `z^0` term and hence no mirror-map correction.

## 3. Identification with the `J`-function

Remark 4.5(3) asserts that (2) lies on Givental's overruled Lagrangian cone.
The standard `J`-slice is the unique point of that cone with the asymptotic
normalization (5).  Therefore

\[
 \boxed{I^T(q,\mathbf t,z)=J^T(q,\mathbf t,z)}
 \tag{6}
\]

for `(r,s)=(2,1)` in the same formal variables and cohomological completion as
formula (35).  The blanket normalization warning in Remark 4.5(3) does not
apply to this specialization.

The proof of Theorem 4.6 uses formula (35), divisor derivatives, and the
finite-rank comparison.  With (6), the same proof gives the extremal quantum
ring presentation (37) for `(2,1)`.  The downstream tame argument in Section
8 and Proposition 9.1 may therefore use the actual `J`-normalized fundamental
solution in codimension two.

## 4. Correct `nu=1` aperture

The sector printed after Lemma 7.4 was derived only after the sentence
`For r-s>1` and must not be specialized to `nu=1`.  Appendix A, Theorem A.1
sets `epsilon=1/2` for `nu=1`.  Since the unique center eigenvalue is

\[
 \lambda=e^{-\pi i}q=-q,
 \tag{7}
\]

the center factor is `exp(q/z)`.  Appendix A gives the center expansion on

\[
 -\frac{5\pi}{2}<\arg(z/q)<\frac\pi2.
\]

The ambient Proposition 8.2 sector is

\[
 -\frac{3\pi}{2}<\arg(z/q)<\frac{3\pi}{2}.
\]

Their correct common sector for the `k=0`, `m=0` order is

\[
 -\frac{3\pi}{2}<\arg(z/q)<\frac\pi2.
 \tag{8}
\]

The intersection contains the tame ray `arg(z/q)=0`, the clockwise
pairing-flip ray `-pi`, and an open sector of width `2pi`.  It is therefore
wide enough for the oriented center-versus-ambient pairing and for
level-one sectorial uniqueness.

## 5. Exact consequence and non-consequence

Combining (6), Appendix A's `nu=1` expansion, and the unchanged reductions in
Sections 9.1--9.4 repairs the codimension-two extremal Gamma/Orlov asymptotic
statement claimed by Theorems 1.4 and 9.14.

This repair remains on the extremal slice: every non-exceptional Novikov
variable is zero.  It does not construct the common sectorial/formal receiver
or prove the ambient unit-column lemma required by Gold.  Those are recorded
in `2026-08-13-c907-gold-relative-cap-attack.md`.

## AA / EJ / TT

- **AA:** use the cone's `J`-slice uniqueness; no Birkhoff factorization is
  needed because the order calculation already excludes a mirror term.
- **EJ:** the first numerator factor is the regression.  Treating all `d`
  numerator factors as `z`-linear falsely creates a `z^0` term and reproduces
  the printed warning.
- **TT:** the corrected sector comes from Appendix A's `epsilon=1/2`, not by
  substituting `nu=1` into the Section 7 formula proved under `nu>1`.

## Source

Y. Shen, M. Shoemaker, *Quantum spectrum and Gamma structure for standard
flips*, arXiv:2502.08762v2, Theorem 4.4, formula (35), Remark 4.5(3), Theorem
4.6, Sections 7--9, and Appendix A.  Shared-cache SHA-256:
`2c1d25490d53d1eb04da11e4ad8eec2d9834b25e765462186181292e7f085cce`.
