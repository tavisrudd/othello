# Reed--Solomon deep-hole programme

**Lane**: `reed-solomon`

**Date:** 2026-07-22

**Status:** C475--C483 complete; C484--C485 allocated.  C478's coherence upgrade identifies each
syndrome atlas with a projected sextic and proves that one diagonal support correspondence across
at most three syndrome fibres recovers every frozen C398 parent.  C481 proves that the determinant
atlas is exactly the projected labelled `M_0,6` point.  C482 proves exact residual dimensions two
and one for two/three projections, but corrects the four-view target: pure reconstruction is a
separable quadratic cover, not a rational inverse, even after diagonal `S6`.  C483 identifies its
deck swap with Gale association, proves that the reduced branch divisor is exactly the conic locus,
and expresses fixed-child recovery as an exact incidence cut explaining the frozen `3/3/2/3`
thresholds.  C484 now owns Frobenius-equivariant descent and the q=8 orientation.  Modular machinery
remains separate behind the matching, Gram, and Sylow gates.

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
                 -> C477 first q=11 collision fibre (complete)
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

## Closed base — C477

[`C477 first collision theorem`](../2026-07-22-c477-first-atlas-collision-fibre.md) independently
reconstructs the full Klein action and proves that nontrivial radical stabilizer is the sharp
cardinality-minimal intrinsic discriminator.  Quadratic evaluation rank is `5` on both extended
arcs, but the first extension-conflict statistic separates: legal continuation counts are `11`
and `7`.  The exact continuation graphs are `K5 union C5 union K1` on the external branch orbit and
`K5 union 2 K1` on the ordinary orbit.  The atomic certificate and structurally independent replay
cover all finite claims.  A requested second extra-juice pass further proves that the branch
involution acts with cycle type `1+2+2` on both five-vertex components and fixes the isolated
off-conic vertex.  No balanced edge monomial can refine the collision.

## Closed base — C478

[`C478 exceptional controls`](../2026-07-22-c478-exceptional-family-controls.md) evaluates the
universal edge-torus atlas on the four C398 non-GRS classes and the fixed `A3/B3/H3` conic phases.
It recovers the exact syndrome orbit profiles `4 / 6 / 1+6 / 12`.  Independent fibrewise
unlabelling retains only those child-orbit colours and no parent information, but the coherent
Galois-equivariant family—one diagonal `S6` across fibres—has exactly `6 / 8 / 2 / 22` parent
signatures and recovers all four fibres with minimum syndrome counts `3 / 3 / 2 / 3`.  The q=8
`3+3` collapse under a colourwise Frobenius quotient is exactly erased `Gal(F_8/F_2)` orientation.
The three full conics are complete arcs, so their own atlas domains are empty.  The q=9 cube still
fails at shared Gram rank `3` and a stably zero Sylow endpoint; the pointed q=7/q=11 carriers pass
Gram rank zero and Sylow endotriviality.  The next theorem gate is simultaneous projection
reconstruction with an explicit discriminant; modular machinery remains conditional downstream
structure.

Task card: `notes/reed-solomon-tasks/c478-exceptional-family-controls.md`.

## Closed base — C481

[`C481 projection-sextic theorem`](../2026-07-22-c481-projection-sextic-coherent-atlas.md)
constructs the quotient-line alternating form and identifies its determinant brackets, modulo the
exact edge torus, with labelled `M_0,6` in every characteristic.  Both the Pluecker-array inverse
and the normalized three-cross-ratio inverse are explicit.  Pointwise, diagonally coherent,
Frobenius-colour-orbit, and Galois-equivariant functors have exact semilinear transporter laws and
the common stabilizer recovery criterion.  The finite quotient lattice explains all C478
distinctions, but does not model C482's positive-dimensional pure-reconstruction fibres; the
Fable/RS template applies only after ambient-child data cuts the fibre to a finite set.

Task card: `notes/reed-solomon-tasks/c481-projection-sextic-coherent-atlas.md`.

## Closed base — C482

[`C482 synchronization theorem`](../2026-07-22-c482-three-centre-synchronization.md) normalizes
each quotient gauge and derives one exact compatibility equation per view.  Two and three views
leave complete-intersection residual families of dimensions two and one.  With four views, the
linearized compatibility matrix has a kernel line containing the universal forbidden collision
`h_5=h_6=h_4`; removing it from the product cubic leaves an explicit separable quadratic.  Exact
`F_101` and `F_256` witnesses have two deep parents and trivial common diagonal stabilizer, so the
proposed rational inverse is false in odd and characteristic two and remains false after diagonal
unlabelling.  A requested second closeout gives the rational source-side deck swap
`z -> rho(L_1 e-L_0 z)`, so both sheets of an `F_q` parent are `F_q`-rational.  C483 must express
that involution intrinsically, factor the quadratic branch divisor, and determine how fixed-child
side information selects a sheet.

Task card: `notes/reed-solomon-tasks/c482-three-centre-synchronization.md`.

## Closed base — C483

[`C483 reconstruction discriminant`](../2026-07-22-c483-reconstruction-discriminant.md) identifies
the quadratic deck swap with the Gale association involution of the `3 x 6` parent matrix.  On the
normalized chart the kernel cubic is `st(L0 s+L1 t)`, with
`L0=-det(h4,h5,h6)` and `L1=det(v2(h1),...,v2(h6))`; hence the intrinsic reduced branch divisor is
exactly the conic locus in every characteristic, while the collision factor is only an arc-boundary
collinearity.  All rank drops are explicit cubic sections `P(ker M_r) intersect V(x_X x_a x_d-
x_Y x_b x_c)`.  Complete-child side information is the exact transporter/incidence cut
`g(L)=U(A)`, and its restriction map explains the frozen sharp `3/3/2/3` thresholds without a new
field census.  Primary symbolic certification and an independent Gale replay cover the new
computational checks.  Every further abstract view preserves the same Gale pair, since each
compatibility row annihilates both sheets; only common ambient-child placement can select one.
Locally `tau=L1/L0^2` is Gale-anti-invariant in odd characteristic, while characteristic two needs
the explicit Artin--Schreier coordinate `eta=L0/(L0+L0#)` with `eta#=eta+1`; q=8's `C3` colour
orientation is a distinct descent class.  On frame overlaps, odd `tau` coordinates differ by
invariant units and characteristic-two `eta` coordinates by invariant translations, so C484 owns
the resulting explicit Cech/Frobenius cocycle rather than discovery of the local cover.

C484's remaining work is globalization: coefficientwise Frobenius equivariance, the two-sheet
`C2` cocycle with Kummer/Artin--Schreier effectivity, finite diagonal-stabilizer descent, and exact
extraction of q=8's colour cycle `3+3` from the frozen replay.  The `C3` collapse is information
loss, not a Hilbert--90 obstruction.  C485 has one genuine unresolved gate: current results prove
at-most-three child-relative recovery only on the four frozen C478 fibres.  An all-field statement
needs a new uniform base-size theorem; otherwise its clause must remain conditional on injectivity
of `Sigma_T`.

The larger-conjecture bridge is now explicit but unallocated.  For redundancy `r`, deepest
syndromes are one-point arc extensions of the degree-`r-1` parity-check normal rational curve; at
full affine length the standard RS conjecture becomes unique completion of the punctured curve.
The conic (`r=3`) base case is immediately packageable, including the even-characteristic nucleus.
Beyond it, the six-point Gale involution does not scale: Gale is self-dual only at `n=2r`.  A new
higher-symmetric-power/Grassmannian atlas plus either a secant-covering theorem or a distinct-root
rational-point existence theorem is required.  This remains behind the handoff's arbitrary-
dimension pre-allocation gate.

Task card: `notes/reed-solomon-tasks/c483-reconstruction-discriminant.md`.

## Current frontier — C484--C485

C481 supplies the projection-sextic/coherent-atlas dictionary for an arbitrary six-arc in every
characteristic, C482 supplies the exact quadratic four-view reconstruction plus the
two/three-centre residual families, and C483 identifies Gale association, the conic branch divisor,
and the complete-child incidence cut.  C484 now proves Frobenius-equivariant descent and resolves
the q=8 `C3` orientation structurally; C485
assembles the all-field redundancy-three degree-two/child-selected reconstruction theorem and C475
GRS specialization.

The exact [`C482 generic-degree preflight`](../2026-07-22-c482-generic-degree-preflight.md) gives
Jacobian ranks `6,9,12`; C482 explains them structurally and shows why square dimension at four
views did not imply birationality.  Three abstract projections have no finite generic degree, and
four have generic degree two.  C478's smaller thresholds use the fixed ambient child as side
information.  The order is strict: no finite sweep may substitute for C483's intrinsic branch and
sheet-selection theorem, and C485 may not weaken an unresolved exceptional or descent hypothesis.

Task cards: `notes/reed-solomon-tasks/c482-three-centre-synchronization.md` through
`notes/reed-solomon-tasks/c485-all-field-reconstruction-synthesis.md`.

## Execution ladder

| Step | Target | Entry gate | Exit gate | Level unlocked |
|---|---|---|---|---|
| C475 | Veronese factorization, torus quotient, and semilinear descent | complete | four-cycles generate; rank two reconstructs; rank one needs its radical | finite atlas is well-defined |
| C476 | all six-point GRS supports for `q in {5,7,8,9,11}` | complete | first collision is the q=11 rank-one `2+4` radical split | honest exceptional mechanism |
| C477 | intrinsic theorem for C476's first collision | complete | Klein branch split, sharp stabilizer bit, and exact continuation graphs | candidate discriminant geometry |
| C478 | C398 and `A3/B3/H3` exceptional controls | complete | coherent Galois-equivariant atlases recover all frozen parents with thresholds `3 / 3 / 2 / 3`; Gram/Sylow still separate q=9 from q=11 | simultaneous reconstruction is the next theorem gate |
| C481 | projection-sextic and coherent-atlas theorem | complete | labelled `M_0,6` with explicit inverses and exact diagonal/Frobenius actions | intrinsic coherent data model |
| C482 | multi-centre gauge synchronization | complete | residual dimensions `2/1`; explicit four-view separable quadratic cover; rational inverse disproved | exact generic ambiguity |
| C483 | reconstruction discriminant and exceptional fibres | complete | Gale association; conic branch divisor; cubic residual-family table; exact complete-child cut | global theorem domain |
| C484 | coherent semilinear descent | C481--C483 | equivariant inverse/descent criterion; q=8 `C3` explained | all-field semilinear reconstruction |
| C485 | all-field redundancy-three synthesis | C481--C484 | separate pure four-projection degree-two and child-relative sheet-selected clauses, with algorithm, exceptions, descent, and GRS specialization | programme-level reconstruction theorem |

Closed cards: `notes/reed-solomon-tasks/c476-standard-grs-atlas-pilot.md` through
`notes/reed-solomon-tasks/c483-reconstruction-discriminant.md`.  Open cards:
`notes/reed-solomon-tasks/c484-coherent-semilinear-descent.md` and
`notes/reed-solomon-tasks/c485-all-field-reconstruction-synthesis.md`.

## Unallocated level-ups

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

`go C484`
