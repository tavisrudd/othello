# C910 — the discriminant pairing on the two-primary part, and the transported self-duality

**Lane:** `cubic-threefolds` · **Task:** C910 · **Date:** 2026-08-19

Follows `2026-08-19-c910-two-primary-lattice-model.md`, which identified the two
models of the two-primary discriminant as abelian groups and named this pass's
computation as the missing step.

## What this pass did

New module
`papers/cubic-stabilization-m1/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationM1/GraphLattices/SixAxisTwoPrimaryPairing.lean`
computes the `ℚ/ℤ`-valued discriminant pairing across that identification, in
four steps.

- The adjugate of the source polarization is `6⁷` times its integral cofactor.
  Both matrices multiply the polarization to `6⁸`, and a matrix that annihilates
  the polarization on the right is zero, because multiplying by the adjugate
  turns that into annihilation by the determinant.
- Hence the pairing of two classes vanishes exactly when six divides
  `v ⬝ C w`, the cofactor form of two representatives.
- The polarization form resolves into the elliptic homology coordinates as
  `Σ_{s,t} W(s,t) · (6 Σ_i y(i,s) z(i,t) − (Σ_i y(i,s))(Σ_i z(i,t)))`. For
  vectors with even axis coordinate sums — which is exactly the condition
  defining the kernel of the reduced polarization — halving that value and
  reducing modulo two kills the sum term and turns the six into a one, leaving
  `Σ_{s,t} W̄(s,t) Σ_i ȳ(i,s) z̄(i,t)`, the manuscript's normalized two-primary
  form `b₂` tensored with the reduced elliptic pairing.
- Writing two-torsion classes as halves of polarization images, `2 v = F y`,
  the comparison sends the class of `v` to `ȳ`, and the two-torsion pairing
  condition becomes divisibility of `y ⬝ F z` by four, which is exactly
  vanishing of that normalized form.

The conclusion is
`sixAxisSourceTwoPrimaryPairing_eq_zero_iff_reducedForm`: for two-torsion
classes the discriminant pairing vanishes exactly when the normalized form of
their comparison images does. Transporting the relative maximal isotropy proved
earlier gives `sixAxisSourceTwoPrimaryKernelImage_eq_perp`: the image of the
two-primary part of the lattice model of the isogeny kernel is exactly its own
orthogonal complement for the normalized form, inside the kernel of the reduced
polarization.

`Applications/RelativeSixAxis.lean` carries the per-fibre versions, and
`RelativeSixAxisConclusion` gains the field `twoPrimaryPairingAndKernelImage`.
One reviewer terminal was added,
`relativeSixAxis_twoPrimaryDiscriminantPairing`, registered on
`lem:relative-six-axis`; it reports `propext, Classical.choice, Quot.sound`.

## What remains for the packet

The normalized form is defined directly on `F₂`-valued source vectors. The
five-member `P¹(F₄)` packet classification is proved for
`sixAxisStandardDiscriminantForm` on the standard coordinates
`Fin 4 → Fin 2 → F₂`, the tensor of the six-point heart form with the standard
symplectic form. What is missing is that the coordinate equivalence already
available on the kernel of the reduced polarization is an isometry between
these two forms. Concretely, for heart coordinates `h`, `h'` with five-axis
representatives `r(h)`, `r(h')`, the identity needed is

    Σ_{i : Fin 5} r(h) i · r(h') i = sixPointHeartCoefficientForm h h',

a bilinear identity over `F₂` in four plus four coordinates, so it is decidable
on basis pairs. With it, the transported image would be a subspace of the
standard coordinates that is maximal isotropic for the standard form, and the
packet classification would apply to it, leaving only diagonal stability — the
`A₅`-side hypothesis — supplied.

## Validation

From `papers/cubic-stabilization-m1/`, `make lint formal-static` and
`make formal-audit` against the captured audit log of the guarded build of
`Verification.AxiomAudit` both pass, over 148 sources and 298 reviewer
terminals, with 62 claims, 48 machinery rows, and unchanged coverage counts
(5 absent, 27 fragmentary, 29 conditional, 1 complete). The claim-map row for
`lem:relative-six-axis` was extended across objects, conclusion, and cautions,
and its terminal digest refreshed after that review. The manuscript PDF was not
rebuilt: the only manuscript change is the `\lean` list of that lemma, whose
macros are typographically empty.

## Mystery ledger

- **Settled: why the six becomes a one.** The coefficient form on augmentation
  vectors is six times the dot product; halving leaves three, and three is one
  modulo two. The cross term, the product of the two coordinate sums, carries
  the factor four before halving, so it vanishes modulo two. Neither step needs
  the vectors to be normalized in any way beyond lying in the kernel.
- **Settled: where the adjugate goes.** The general discriminant pairing is
  stated through the adjugate, which for this polarization is a huge matrix
  numerically; the cofactor identity replaces it by `6⁷ C` and reduces every
  divisibility to one by six. No entry of the adjugate is ever computed.
- **Open: the isometry with the standard rank-eight form.** Stated above with
  the exact identity needed; nothing else blocks applying the packet
  classification to the lattice kernel.
- **Open, unchanged: `A₅`-stability, the orders of the primary parts, the
  commutator pairing, and the dictionary proposition.**
