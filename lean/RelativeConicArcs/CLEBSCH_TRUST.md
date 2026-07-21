# Trust manifest — Clebsch reflection-arrangement decoding slice

This manifest covers the reflection-arrangement coordinate and decoding bridge exported by
`RelativeConicArcs.Gates.ClebschReflectionArrangementDecoding`. It is not a trust manifest for the
entire Clebsch manuscript.

## Machine-checked surface

| Layer | Main declarations | Boundary |
|---|---|---|
| field and coordinate tables | `tau11_relation`, `tau5_relation`, `h3_characteristic_two_boundary`, `h3_fivefold_points_arc`, `h3_joins_are_root_directions` | explicit `ZMod 11`, `ZMod 5`, and `ZMod 2` arithmetic; the abstract Coxeter-arrangement identification is external |
| coordinate transport | `h3_projectivity_det_ne_zero`, `h3_projectivity_inverse_apply`, `h3_projectivity_apply_inverse`, `h3_dual_projectivity_dot`, `h3_projective_index_bijective` | explicit three-coordinate maps and the fixed normalized enumeration, not Mathlib's projectivization quotient |
| incidence ledgers | `h3_multiplicity_eq_normalized_rawPointIndex`, `h3_fivefold_points_exact`, `h3_intersection_spectrum`, `h3_characteristic_five_spectrum`, `a3_frame_joins_are_braid_mirrors`, `a3_intersection_spectrum` | exhaustive kernel reduction over `Fin 133`, `Fin 31`, `Fin 15`, and `Fin 6`; no generated certificate or native evaluation |
| decoder bridge | `h3_affine_syndrome_injective`, `h3_affine_syndromes_card`, `h3_affine_syndrome_nearestLeaderCount`, `h3_one_leader_strata_card` | composes the normalized projective bijection with the existing affine-ray and semantic-leader theorems; covers every nonzero scalar on every projective direction |
| arithmetic companions | `h3_mobius_sum`, `h3_characteristic_polynomial`, `a3_characteristic_polynomial`, `h3_conic_size_factorization`, `a3_conic_size_factorization` | integer identities only; their arrangement-theoretic interpretation is not in the theorem types |

## Trust boundary

The full gate depends only on the standard Lean/Mathlib axioms reported by `#print axioms`:
`propext`, `Classical.choice`, and `Quot.sound`. The slice contains no `sorry`, `native_decide`, local
axiom, opaque oracle, generated certificate, or external data file. Finite checks use kernel
`decide`; symbolic identities use `ring`, `norm_num`, `field_simp`, and ordinary theorem composition.

The labels `A3` and `H3` connect the displayed coordinates to classical reflection arrangements.
That semantic identification, and the interpretation of the integer factorizations as arrangement
characteristic polynomials, are cited mathematical inputs outside this Lean slice. The gate proves
the displayed coordinate correspondences, incidence data, projective transport, and actual decoder
leader counts without assuming those labels.

## Validation gate

Build and trace-check the import-only target:

```text
RelativeConicArcs.Gates.ClebschReflectionArrangementDecoding
```

The pinned validated commit and exact replay record are maintained in the owning Clebsch trust
ledger; this file states the stable theorem and trust boundary.
