# C910 — the two-primary discriminant as the kernel of the reduced polarization

**Lane:** `cubic-threefolds` · **Task:** C910 · **Date:** 2026-08-19

## What this pass did

The companion carried two different objects both standing for the two-primary
discriminant of the six-axis source. The lattice one is the two-torsion part of
the discriminant group, that is of the cokernel of the integral source
polarization; that is where the isogeny kernel and its relative maximal
isotropy live. The coefficient one is the kernel of the same polarization
reduced modulo two, an `F₂`-subspace of `F₂^ι`; that is where the coefficient
heart, the rank-eight tensor form, and the classification of the five stable
maximal-isotropic subspaces live. This pass identifies them.

New module
`papers/cubic-stabilization-m1/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationM1/GraphLattices/SixAxisTwoPrimaryLatticeComparison.lean`.
The comparison is division free. The polarization `F` has the integral cofactor
`C` of the previous pass, with `F C = C F = 6`, so the reduction modulo two of
`C v` depends only on the class of `v` and gives a map from the whole
discriminant group to `F₂^ι`. Three facts about it are proved:

- it lands in the kernel of the reduced polarization, because `F C v = 6 v` is
  even;
- its kernel is exactly the three-primary part, because `C v = 2 z` forces
  `6 v = F (2z)` hence `3 v = F z`, and conversely `3 v = F y` forces
  `3 C v = 6 y` hence `C v = 2 y`;
- it is onto that kernel: an integral lift `w` of a kernel vector has `F w`
  even, say `F w = 2 u`, and then the class of `u` is two-torsion with
  `C u = 3 w`, which reduces to `w`.

Hence `sixAxisSourceTwoPrimaryLatticeEquiv`, an isomorphism of abelian groups
from the two-primary part of the discriminant group onto the kernel of the
reduced polarization, and `sixAxisSourceTwoPrimaryLatticeCoordinates`, its
composite with the coordinates already available on that kernel, which presents
the lattice two-primary discriminant as four copies of the rank-two two-torsion
module. That is the manuscript's `𝒟₂ ≃ H₂ ⊗ 𝒱₂` starting from the lattice
discriminant rather than from the reduced kernel.

The two sides are annihilated by two, so an additive isomorphism between them
is `F₂`-linear; the equivalences are stated additively for that reason.

One reviewer terminal was added,
`relativeSixAxis_twoPrimaryDiscriminantLatticeModel`, registered on
`lem:relative-six-axis`. It reports `propext, Classical.choice, Quot.sound`.

## What this does not yet give

The identification is of abelian groups only. No compatibility with the
discriminant pairing is proved, so the classification of the five stable
maximal-isotropic subspaces is not yet transported to the lattice model of the
isogeny kernel, and the relative maximal isotropy proved for `𝒦₂ ⊆ 𝒟₂` at
lattice level does not yet reach the rank-eight `F₂` form.

The missing step is one computation, and the algebra is settled. On classes
`[v], [w]` the discriminant pairing vanishes exactly when `6` divides
`v ⬝ (C w)`, because the adjugate of the polarization is `6⁷ C`. For
two-torsion classes with `2v = F y` and `2w = F z` this reads
`4 ∣ y ⬝ (F z)`, and the halved quantity `(y ⬝ (F z))/2` reduces modulo two to

    Σ_{s,t} W̄(s,t) · Σ_i ȳ(i,s) z̄(i,t),

the tensor of the dot product on axis coordinates with the reduced elliptic
pairing — the manuscript's normalized two-primary form. Proving that identity
turns the lattice isotropy statement into an isotropy statement for the
explicit `F₂` form; matching that form with the rank-eight tensor form through
the existing coordinates is a further step, and requires those coordinates to
be shown an isometry.

## Validation

From `papers/cubic-stabilization-m1/`, `make lint formal-static` and
`make formal-audit` against the captured audit log of the guarded build of
`Verification.AxiomAudit` both pass, over 147 sources and 297 reviewer
terminals, with 62 claims, 48 machinery rows, and unchanged coverage counts
(5 absent, 27 fragmentary, 29 conditional, 1 complete). The claim-map row for
`lem:relative-six-axis` was extended across objects, conclusion, and cautions,
and its terminal digest refreshed after that review. The manuscript PDF was not
rebuilt: the only manuscript change is the `\lean` list of that lemma, whose
macros are typographically empty.
