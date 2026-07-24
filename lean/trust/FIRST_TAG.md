# First finite-geometry tag: trust manifest

This manifest covers the Lean sources supporting the finite-geometry outcome theorems cited by the
first manuscript release. Its boundary is the union of four import closures:

- `CapGame.Affine`
- `ProjectiveCap.Binary`
- `ProjectiveCap.EllipticMirror`
- `ProjectiveCap.PlaneOutcome`

The union contains 26 Lean modules. The generic projective mirror theorem is included through
`ProjectiveCap.EllipticMirror`; a redundant fifth gate is unnecessary.

## Terminal claims

| Mathematical scope | Lean declaration |
|---|---|
| Positive-dimensional finite affine spaces | `CapGame.Affine.initialP_fin` |
| Binary projective spaces of projective dimension at least one | `ProjectiveCap.Projective.initialPStatement_binary_of_projectiveDim_ge_one` |
| Fixed-point-free projective involution mirror principle | `ProjectiveCap.Projective.initialPStatement_of_fixedPointFree_collinearity_preserving_involution` |
| Odd-cardinality fields in positive even vector rank | `ProjectiveCap.Projective.initialPStatement_of_odd_card_finrank_eq_two_mul` |
| Rank-three projective models over fields of even cardinality | `ProjectiveCap.initialPStatement_of_even_card_finrank` |
| Projective plane of order five | `ProjectiveCap.ConicLocalization.initialPStatement_of_card_eq_five_finrank` |
| Projective plane of order seven | `ProjectiveCap.ConicLocalization.initialPStatement_of_card_eq_seven_finrank` |

## Trust boundary

`trust/areas/finitegeom_first_tag.toml` declares the expected axiom set of each terminal as
`Classical.choice`, `Quot.sound`, and `propext`. These are reviewer declarations, not observations.
The observed column in `trust/PORTFOLIO.md` remains unextracted until the pinned Lean environment
reports each terminal's exact axiom set. A mismatch is a failing trust-spine audit.

The tracked-source audit finds no project-local axiom declaration in this closure. It does not
establish the terminal axiom sets and does not replace Lean environment extraction.

## Exclusions

This tag does not include the uncited hyperbolic-quadric theorem, the `FiniteGeom` umbrella, a
general sum-free outcome classification, or generated projective-plane certificate families.
Those statements and packages are not implied by the terminals above.
