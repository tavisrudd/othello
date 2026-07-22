# Reed--Solomon deep-hole programme

**Lane**: `reed-solomon`

**Date:** 2026-07-22

**Status:** C475--C476 complete; C477 and C478 queued.  C476 found the first raw-atlas collision at
the first canonical q=11 support and proved that C475's radical marker resolves its two rank-one
syndrome orbits.

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
       -> C475 coefficient atlas for standard GRS parents (complete)
            -> C476 bounded standard-GRS atlas pilot (complete)
                 -> C477 first q=11 collision fibre
            -> C478 frozen exceptional controls
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

## Closed base — C475

[`C475 determinant atlas`](../2026-07-22-c475-reed-solomon-determinant-atlas.md) proves the
homogeneous Veronese factorization in all characteristics, including infinity; the full integral
edge-torus quotient; exact finite-field orbit separation; and projective-semilinear descent.
Four-cycles reconstruct every rank-two syndrome for supports of size at least five.  They contract
exactly the rank-one/conic locus, where the unique missing datum is the radical point in
`P1(F)-S`.  C476/C478 must retain the raw four-cycle fibres for collision detection, then use the
support-stabilizer orbit of the radical point as C475's proved rank-one discriminator.  No higher
edge monomial is permitted as a purported repair of that structural contraction.

## Closed base — C476

[`C476 bounded pilot`](../2026-07-22-c476-standard-grs-atlas-pilot.md) exhausts every six-support
class through q=9 and the first canonical q=11 support, where the stop rule fires.  For
`S={0,1,2,3,4,infinity}`, the full semilinear stabilizer is Klein four and its complement orbits
are `{5,10}` and `{6,7,8,9}`.  The associated rank-one syndromes `(1,5,3)` and `(1,6,3)` share the
all-one raw atlas but are separated by their radical orbits.  All five rank-two syndrome orbits on
that support have distinct atlases.  The unique external two-point orbit is also the rational fixed
set of the unique stabilizer involution whose fixed points both avoid `S`.  The
[`C476 extra-juice review`](../2026-07-22-reed-solomon-c476-ej-review.md) identifies the exact Klein
quotient: the two-point collision orbit is a ramified fibre and the four-point orbit is ordinary,
so nontrivial syndrome stabilizer is a canonical one-bit discriminator.

## Current frontier — C477

Freeze only C476's support and collision fibre.  Reconstruct the two orbits independently, record
the complete stabilizer/fixed-point geometry, and test the card's discriminators in order:
evaluation rank, extension-conflict, then continuation graph.  C475's radical orbit and C476's
unique-external-fixed-pair description are already exact candidate answers.  The leading cheap
candidate is now the stabilizer/ramification bit: order two on `{5,10}`, trivial on
`{6,7,8,9}`.  C477 must derive that distinction intrinsically from the unlabelled support/fibre,
then use the card's prescribed discriminators as controls or prove the smallest successful one
sharp.  Do not open another support or field and do not invoke modular/Picard or higher-order-MDS
language without passing the card's explicit gate.

Task card: `notes/reed-solomon-tasks/c477-first-atlas-collision-fibre.md`.

## Execution ladder

| Step | Target | Entry gate | Exit gate | Level unlocked |
|---|---|---|---|---|
| C475 | Veronese factorization, torus quotient, and semilinear descent | complete | four-cycles generate; rank two reconstructs; rank one needs its radical | finite atlas is well-defined |
| C476 | all six-point GRS supports for `q in {5,7,8,9,11}` | complete | first collision is the q=11 rank-one `2+4` radical split | honest exceptional mechanism |
| C477 | intrinsic theorem for C476's first collision | gate passed | full fibre/stabilizer theorem plus minimal discriminator or sharp obstruction | candidate discriminant geometry |
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

`go C477`
