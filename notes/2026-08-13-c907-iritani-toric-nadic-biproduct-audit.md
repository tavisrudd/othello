# C907 audit: Iritani does not yet give the strict toric `N`-adic biproduct

**Lane:** `clebsch`

**Verdict:** **NO-GO unconditionally; exact conditional theorem below.**
Iritani's two blowup results supply complementary pieces of the toric pilot,
but not a strict biproduct in the coarsened integral `N`-adic Rees category.
They give (i) a formal quantum-`D`-module direct sum after mirror/Laurent base
change and (ii) a global Gamma/Orlov residual subgroup.  Neither identifies
the bounded value-localized four-thimble object with that subgroup while
preserving hyperplane action and its `N` filtration, nor proves that the
sectorial extension between target and center is split.

This audit uses only the already source-backed C907 records for Iritani,
arXiv:2307.13555v3 and arXiv:1906.00801.

## 1. The exact source output

For a codimension-`r` blowup, Iritani's Theorem 5.18 gives, after a formal
invertible mirror map and Laurent coefficient extension, an isomorphism of
quantum `D`-modules

\[
 \operatorname{QDM}(\operatorname{Bl}_Z Y)
 \simeq \operatorname{QDM}(Y)\oplus
 \operatorname{QDM}(Z)^{\oplus(r-1)}. \tag{1}
\]

It intertwines the quantum connection and symmetric Poincare pairing.  It is
enough for formal monodromy and the scalar `nu_6` calculation.  It is not an
integral Gamma-lattice isomorphism, a fixed-sector Stokes splitting, an Euler
pairing splitting, or an `N`-filtered Rees statement.

In the codimension-two pilot, equation (5.28) has the precise basepoint form

\[
 \Phi_0=
 \begin{pmatrix}I&0\\ \iota^*&I\end{pmatrix}
 +\begin{pmatrix}O(t)&O(t^2)\\O(t)&O(t)\end{pmatrix}. \tag{2}
\]

After first taking the `t`-adic associated graded and then the
exceptional-first dominance associated graded, it becomes

\[
 \operatorname{gr}^{\rm dom}\operatorname{gr}_t\Phi_0=I_Y\oplus I_Z.
 \tag{3}
\]

Thus the sources provide a valuable **associated-graded pilot**.  The
off-diagonal `iota^*` in (2) is exactly why (3) cannot be promoted to a
strict filtered biproduct without a new splitting theorem.

Separately, Iritani's toric Theorem 7.5 and Remark 7.6 identify the Gamma
lattice and its Euler form with toric Lefschetz thimbles.  Theorem 7.31
identifies the exceptional satellite subgroup in the present pilot with

\[
 K(\mathbf P^3)_{-1}=
 i_{E*}\bigl(p_E^*K(\mathbf P^3)\otimes\mathcal O_E(-1)\bigr). \tag{4}
\]

Consequently the source does supply an honest *candidate central filtered
lattice*: tensoring by the pulled-back hyperplane preserves (4), and hence
so does

\[
 N=1-H,\qquad F^k=N^kK(\mathbf P^3). \tag{5}
\]

The fully faithful Orlov functor preserves the restricted Euler pairing.
This is a strict statement about the center block itself, not yet a
strict biproduct for the blowup packet.

## 2. Why the internal `P^3` pairing does not close the seam

The internal proper-support theorem and intrinsic Seifert transport give the
bounded four-thimble lattice its `P^3` directed Euler/Seifert matrix.  That
does not provide either of the following maps:

\[
 \Lambda_{\rm loc}\longrightarrow K(\mathbf P^3)_{-1},
 \qquad
 H_{\rm loc}\text{ or }F^\bullet_{N,\rm loc}. \tag{6}
\]

In particular, a Gram match does not create a base-hyperplane continuation
on the localized value-disk system.  The source satellite thimbles use global
strips and an exceptional loop, whereas the four internal thimbles use a
bounded value disk after parameter-dependent normalization.  Iritani's
Theorem 7.33 permits path continuation/mutation, and Remark 1.4(3) explicitly
leaves equality of the residual Stokes structure with the center's Stokes
structure open.

This remains a problem after forgetting the point-class seed.  The shear
`1+rN^3` is harmless *once* an isomorphism of the coarsened objects in (6)
exists, but it cannot manufacture `H_loc`, the `N`-adic filtration, or the
comparison itself.

There is also a direct source-level obstruction to reading (1) as the desired
strict biproduct.  Iritani's Remark 1.5 says that the Stokes structure at
`z=0` does not have the corresponding orthogonal decomposition in the toric
case; it has a semiorthogonal Gamma/Orlov decomposition instead.  A
semiorthogonal decomposition or a `K`-group direct sum can retain precisely
the off-diagonal extension which a strict Rees biproduct must exclude.

## 3. Exact conditional toric theorem

Let `C_N` be the deliberately coarsened category whose objects retain an
integral lattice, Euler pairing, integral hyperplane action `H`, and the
filtration `F^k=(1-H)^k`; it forgets directed Stokes flags.  Then the
following implication is exact.

> **Conditional toric `N`-biproduct theorem.**  Suppose:
>
> 1. there is an integral filtered isometry
> \[
> \Theta:(\Lambda_{\rm loc},\chi_{\rm loc},H_{\rm loc},F^\bullet_{\rm loc})
> \xrightarrow{\sim}
> (K(\mathbf P^3)_{-1},\chi,H,F^\bullet)
> \tag{7}
> \]
> from the localized four-thimble object to Iritani's satellite block; and
> 2. the toric blowup comparison lifts from (1) to a block-diagonal
> `C_N`-isomorphism on the Gamma lattices, rather than only to (3) or a
> semiorthogonal Stokes decomposition.
>
> Then
> \[
> \mathscr A_N(\operatorname{Bl}_{\mathbf P^3}\mathbf P^5)
> \simeq
> \mathscr A_N(\mathbf P^5)\oplus
> T\mathscr A_N(\mathbf P^3) \tag{8}
> \]
> is a strict biproduct in `C_N`.  The point-class shear in (7) is an allowed
> filtered automorphism, so no marked Gamma seed is needed for (8).

The first hypothesis is the unmarked satellite-to-localized
hyperplane/Rees comparison; the second is the strict analytic functoriality
gate.  Neither follows from the two cited Iritani results.  Hypothesis 2 is
strictly stronger than formal block diagonalization: it must prevent an
extension of shorter pieces from becoming a longer indecomposable after the
coarsened `N` filtration is formed.

## 4. Best unconditional pilot statement

The strongest source-only statement is therefore the two-level calibration

\[
 \operatorname{gr}^{\rm dom}\operatorname{gr}_t
 \operatorname{QDM}(\operatorname{Bl}_{\mathbf P^3}\mathbf P^5)
 \cong
 \operatorname{QDM}(\mathbf P^5)\oplus
 \operatorname{QDM}(\mathbf P^3), \tag{9}
\]

together with the integral Orlov realization (4)--(5) of the would-be center
summand.  This is enough to calibrate the target and to show that the
point-class shear is not the issue in the coarsened category.  It is not a
strict C907 blowup formula, even for the toric pilot.

## EJ/TT and mystery ledger

- **EJ:** Iritani supplies exactly the formal associated graded and the
  integral target block; the remaining theorem is their strict filtered
  identification, not another Euler calculation.
- **TT:** a formal direct sum, a semiorthogonal decomposition, and a strict
  biproduct have different extension content.  The `iota^*` term and Remark
  1.5 locate that content explicitly.
- **Settled:** a source-backed toric center calibration with its own
  `N`-adic filtered Gamma lattice.
- **Open:** unmarked filtered satellite-to-localized comparison and a
  block-diagonal `C_N` lift of the toric blowup comparison; positive-order
  and arbitrary-center functoriality remain later gates.
