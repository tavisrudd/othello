# Reed--Solomon deep-hole programme

**Lane**: `reed-solomon`

**Date:** 2026-07-22

**Status:** C475--C478 QUEUED/GATED as the first theorem ladder; the C398 four-class theorem and
C474 decorated-fibre computation are the frozen base. C475 moves from exceptional non-GRS parents
to the standard redundancy-three GRS deep-hole problem.

## Goal

Develop intrinsic, computable invariants for projective deepest-syndrome directions of
redundancy-three generalized Reed--Solomon codes, prove exactly what they remember modulo the full
projective-semilinear code automorphism group, and isolate the first exceptional fibres where a
coarser invariant fails. Use the C398 non-GRS examples as controls, not as substitutes for the
standard-GRS problem.

The coding dictionary is fixed. If `H` is a `3 x n` parity-check matrix whose projective columns
form an arc `A` in `PG(2,q)`, then a projective syndrome `u` has coset weight three exactly when it
lies on no secant of `A`; equivalently, adjoining `u` gives a one-column MDS extension. For a
standard redundancy-three GRS code, `A` lies on a nonsingular conic.

## Context map

```text
C398 classification + certificate
  -> C474 decorated-fibre theorem + replay
       -> C475 coefficient atlas for standard GRS parents
            -> only after a collision: modular/descent discriminators
```

| Role | Read | What C475 imports |
|---|---|---|
| Immediate precursor | [`C474 Reed--Solomon companion`](../2026-07-22-c474-reed-solomon-decorated-deep-holes.md) | Deep-hole/MDS-extension dictionary, determinant-atlas question, four orbit profiles, and exact stop rule. |
| Control theorem | [`C398 classification`](../2026-07-20-c398-conic-deep-hole-classification.md) | The exhaustive four non-GRS controls at `q=8,9,9,11` and the controlling literature boundary. |
| Control evidence | C398 [`data`](../2026-07-20-c398-conic-deep-hole-classification.json) / [`checker`](../2026-07-20-c398-conic-deep-hole-classification.py) / [`hash`](../2026-07-20-c398-conic-deep-hole-classification.sha256); C474 [`data`](../2026-07-22-c474-reed-solomon-decorated-deep-holes.json) / [`checker`](../2026-07-22-c474-reed-solomon-decorated-deep-holes.py) / [`replay`](../2026-07-22-c474-reed-solomon-decorated-deep-holes-replay.py) / [`hash`](../2026-07-22-c474-reed-solomon-decorated-deep-holes.sha256) | Frozen regression inputs; do not regenerate them. |
| Conditional discriminator | [`C474 modular gateway`](../2026-07-22-c474-modular-gateway-theory.md) | Gram and Sylow gates to use only if coefficient-atlas fibres leave a nontrivial incidence carrier. |
| Idea provenance, not an input theorem | [`gateway brainstorm`](../2026-07-20-clebsch-gateway-chain-brainstorm.md) §§G3--G4 | Separates decorated-transform inversion from the distinct higher-order-MDS/list-decoding branch. |
| Candidate language, not assumptions | [`C417 cocycle audit`](../2026-07-20-c417-affine-cocycle-line-bundle-audit.md) and [`Weil-roof ledger`](../2026-07-21-clebsch-weil-roof-results-ledger.md) | Possible descent/cubic vocabulary after the elementary atlas is known; neither is part of the C475 proof base. |

The older [`C121 q=11 checks`](../2026-07-13-c121-icosahedral-mds-checks.md) and
[`C122 deep-hole audit`](../2026-07-13-c122-deep-hole-novelty-audit.md) are archaeology only; C398
and C474 supersede them for lane entry.

Use the [`papers index`](../../papers/papers-index.md) as the cross-paper theorem registry. Adjacent
banks are opt-in, by obstruction shape:

| Bank | Exact handles | Use in this lane |
|---|---|---|
| `arcs_complete_outside_conic` | `thm-arc-mds-syndrome`, `thm-relative-syndrome-confinement`, `thm-extension-conflict-hypergraph`, `thm-defect-leader-collision`, `thm-evaluation-dichotomy` | Foundational syndrome/extension semantics, moment constraints, and evaluation-rank obstructions. See the [`arcs` handoff](done/2026-07-12-arcs-complete-outside-conic-formalization.md) and [proof audit](../../papers/arcs_complete_outside_conic/arcs_complete_outside_conic_proof_audit.md). |
| `clebsch-hexagon-code` | `thm-clebsch-rigidity`, `thm-conic-filling-kle7`, `thm-clebsch-reflection-arrangements`, `thm-rank3-reflection-complement-code` | Rigidity and reflection-family controls beyond the four-class certificate; do not import paper claims by folklore. |
| `relconic` | [`C312 determinant/trace criterion`](../2026-07-18-c312-c297-seed-repair-legality.md), [`C314 invariant atlas`](../2026-07-18-c314-c297-invariant-moduli-stratification.md) | Model for separating scaling, gauge, Frobenius, stabilizers, and degeneracy divisors when a C475 fibre becomes an algebraic moduli problem. |
| `complete-repair-ports` | `thm-repair-coefficients` | Warning/control: raw recovery coefficients vary under monomial rescaling, so only gauge-invariant combinations can classify. |
| Higher-order-MDS branch | [`C295`](../2026-07-17-c295-intrinsic-continuation-reconstruction.md), plus `comp-q11-extension-complex` | Simultaneous-extension input only; not needed for the one-column C475 gate. |

Do not recompute the four C398 fibres, their deletion traces, the q=9 cube, or their automorphism
orbits unless a new invariant exposes a concrete inconsistency. They are regression controls.

## Current frontier — C475

Use the standard conic chart `h(t)=(1,t,t^2)`. For `u=(u_0,u_1,u_2)`, direct expansion gives the
load-bearing factorization

```text
d_st(u) = det(u,h(s),h(t))
        = (t-s) B_u(s,t),
B_u(s,t) = u_0*s*t-u_1*(s+t)+u_2.                         (1)
```

Homogeneously, (1) is the Veronese bracket factorization
`det(u,nu(v_i),nu(v_j))=[v_i,v_j] B_u(v_i,v_j)`, up to the fixed coordinate convention. It
separates known support geometry from evaluations of one binary bilinear form representing the
syndrome.

Under `u -> b*u`, `h_i -> a_i*h_i`, and `g in GL_3`,

```text
d_ij -> b*a_i*a_j*det(g)*d_ij.                            (2)
```

Thus raw coefficients cannot classify monomial-equivalence classes. Balanced ratios, beginning
with

```text
R_ijkl = d_ij*d_kl/(d_ik*d_jl),                           (3)
```

cancel every factor in (2). Dividing (3) by the corresponding support cross-ratio leaves
`B_ij*B_kl/(B_ik*B_jl)`, a syndrome-only coordinate. Frobenius acts by powering and support
automorphisms permute indices, so the appropriate invariant is its permutation/Frobenius orbit.

C475 must now:

1. prove (1)--(2), including the point at infinity and characteristic two;
2. determine the rational torus quotient of the nonzero edge labels `d_ij`, including whether
   four-cycle ratios generate it in the required sense;
3. prove the descent of the support-normalized ratios under projectivities, Frobenius, and the
   conic-support automorphism group;
4. give exact labelled reconstruction and orbit-equality criteria; and
5. export a canonical comparison procedure and data schema to C476 and C478.

Import order is strict: use the `arcs` syndrome/evaluation theorems first, C312/C314 quotient-chart
discipline second, and `thm-repair-coefficients` as the gauge warning. Use C295 reconstruction only
after a scalar-atlas collision. C417, Weil-roof, higher-order-MDS, and C474 modular/Picard machinery
remain gated until that collision has a nontrivial structured fibre.

The deliverable is
[`notes/2026-07-22-c475-reed-solomon-determinant-atlas.md`](../2026-07-22-c475-reed-solomon-determinant-atlas.md),
with a symbolic checker beside it if computation supports the algebra. Finite orbit censuses belong
to C476 and C478, not this task.

Task card: `notes/reed-solomon-tasks/c475-veronese-cycle-quotient.md`.

## Execution ladder

| Step | Target | Entry gate | Exit gate | Level unlocked |
|---|---|---|---|---|
| C475 | Veronese factorization, torus quotient, and semilinear descent | none | exact invariant-generation/reconstruction theorem, including infinity and characteristic two | finite atlas is well-defined |
| C476 | all six-point GRS supports for `q in {5,7,8,9,11}` | C475 | first complete collision fibre, or certified separation on the entire bounded domain | honest evidence for generic separation or an exceptional mechanism |
| C477 | intrinsic theorem for C476's first collision | an actual C476 collision | full fibre/stabilizer theorem plus minimal discriminator or sharp obstruction | candidate discriminant geometry |
| C478 | C398 and `A3/B3/H3` exceptional controls | C475 | exact comparison of orbit recovery, Gram rank, and Sylow gate on the frozen cases | decision on whether modular machinery belongs in this lane |

Cards: `notes/reed-solomon-tasks/c476-standard-grs-atlas-pilot.md`,
`notes/reed-solomon-tasks/c477-first-atlas-collision-fibre.md`, and
`notes/reed-solomon-tasks/c478-exceptional-family-controls.md`.

## Unallocated level-ups

- **Generic all-field reconstruction:** allocate only if C475 proves a small generating atlas and
  C476 shows separation outside a describable degeneracy locus. Target: classify all syndrome
  orbits for six-point GRS supports away from an explicit discriminant.
- **Semilinear tower theorem:** allocate only if extension-field cases expose a Frobenius/Hilbert-90
  obstruction not already removed by taking Frobenius orbits.
- **Higher-order MDS/list decoding:** allocate only if atlas fibres or their adjacency recover the
  simultaneous-extension complex from C295; one-column extension data alone does not pass.
- **Modular/category/type bridge:** allocate only if C478 produces a nondegenerate complementary
  incidence carrier passing both the Gram and Sylow endotrivial gates.
- **Arbitrary-dimension Reed--Solomon:** allocate only after a claim-specific literature audit and
  a proved higher-symmetric-power analogue of (1); small-field success supplies no such bridge.

**Result ceiling:** the realistic large theorem is an all-field, redundancy-three orbit
reconstruction with an explicit discriminant and classified exceptional fibres. It would be a
substantial invariant-theoretic deep-hole result, but not the general Reed--Solomon deep-hole
conjecture.

## Boundaries

- This lane owns Reed--Solomon/GRS deep-hole and one-column MDS-extension invariants arising from
  the C398/C474 bridge.
- It does not own further Clebsch, crowns, type-theory, or stable-module development. Cross-lane
  consequences require their own routing and may not mutate the crowns handoff.
- Literature priority or a claim of progress on a famous conjecture requires a dedicated current
  literature audit. The present task is an internal theorem-and-discriminator programme.
- Avoid an unstructured field census. Normalize first, prove the group action, and enumerate only
  the resulting bounded quotient.
- No successor may enlarge C476's field/support domain. A larger range requires a theorem-derived
  bound and a newly allocated task.

Companions: [discovery log](../2026-07-22-reed-solomon-discovery-track.md) for incidental leads;
[session archive](done/2026-07-22-reed-solomon-deep-holes-archive.md) for dated or superseded lane
history.

## Next command

`go C475`
