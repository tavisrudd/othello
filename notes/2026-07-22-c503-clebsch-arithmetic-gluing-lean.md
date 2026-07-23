# C503 / F10 — Lean rank-three arithmetic gluing

**Lane:** `clebsch`

**Status:** implementation complete; exact Lean validation and independent review in progress

This file is both the cold-read task specification and the durable result report. Complete it in
place with exact theorem names, artifacts, validation, axiom evidence, trust boundaries, judgment
calls, review dispositions, and the proposed C320 ledger delta.

## Required outcome and trust route

Formalize the bounded arithmetic-gluing theorem used by Paper 1 from C441, C442/C458, C444, C445,
C449, and C460: the frozen A3/B3/H3 reductions, their sheet or fused-fibre actions, the q=11 golden
matching orbit and q=7 silver pair, the stated stabilizer/intersection facts, and the split/inert
trichotomy at `q=5,7,11`.

The preferred route is symbolic finite-field and group-action lemmas plus small checked data leaves.
Classical group names, orthogonal/spinor terminology, and reciprocity language must be isolated
behind exact proved interfaces or cited inputs; they may not be inferred from orders alone.

## Owned surface and dependencies

- Own only `lean/RelativeConicArcs/ClebschArithmeticGluingData.lean`,
  `lean/RelativeConicArcs/ClebschArithmeticGluing.lean`,
  `lean/RelativeConicArcs/Gates/ClebschArithmeticGluing.lean`, this report, and a same-stem
  `.py/.json/.sha256` bundle only if a new normalized certificate is necessary.
- Consume the committed F5/F8 APIs and frozen upstream certificates read-only.
- Exit through `RelativeConicArcs.Gates.ClebschArithmeticGluing`.

## Required theorem boundary

The gate must distinguish:

- literal finite reductions, orbit sizes, sheet swaps, stabilizers, intersections, and generation;
- the exact polynomial root/splitting checks at `5,7,11`;
- any named abstract-group or spinor-norm identification;
- any broader number-field or all-prime statement, which is excluded.

No integral cubic lift, universal cubic-sign readout, or Paper-2 descent mechanism is in scope.

## Validation and closing review

Before proof work read `lean/AGENTS.md` and the routed named-expert dossier. Every finite leaf needs
generator/schema/data/hash provenance, independent replay, a checker-soundness theorem, and an
exact axiom audit. Use only guarded/unattended exact-target builds.

Completion requires artifact/report/checklist/C320 delta, user-launched independent review,
resolution or narrowing of every finding, user-launched post-fix review after changes, and recorded
final `GO`. The implementer may not select or simulate the reviewer.

## Result

The owned Lean slice now reconstructs `PGL₂(F_q)` from normalized nonsingular matrices at
`q=5,7,11` and kernel-checks the bounded arithmetic-gluing row.  Its exact finite conclusions are:

- both frozen coordinate reductions enumerate all of `P¹(F_q)` without repetition;
- `x²-2` has no root over `F_5`, has exactly roots `3,4` over `F_7`, and `x²-5` has exactly roots
  `4,7` over `F_11`; the two golden residues `φ=8,4` are exactly the roots of `x²-x-1`;
- the reduced affine vertex polynomials `X^q-X` vanish at every field element for `q=5,7,11`;
- the executable matching-edge lists encode exactly the frozen unordered matchings and define
  fixed-point-free involutions on the complete projective lines;
- the `A3` marker is fused; `x↦-x` exchanges the two `B3` matchings; and
  `(x-1)/(x+1)` exchanges the two `H3` matchings;
- the Coxeter-square multipliers have the literal `1+1+(q-1)/2+(q-1)/2` orbit partitions;
- the normalized projective group orders are `120/60`, `336/168`, and `1320/660`;
- the `A3` stabilizer has order 24, square-determinant intersection 12, and one five-element orbit
  under both projective groups;
- the two `B3` stabilizers have orders `24,24`, intersection 6, lie in the square-determinant
  subgroup, and give disjoint `7+7` halves of one 14-element orbit;
- the normalized `H3` certificate has two 60-entry stabilizer lists with intersection 12 inside
  the square-determinant subgroup and 22 distinct transported signatures split into disjoint
  `11+11` halves; the adjacent generator/replay verifies stabilizer semantics, coset completeness,
  and 660-element generation;
- the silver and golden transporters have nonsquare determinant.

The bounded exit is therefore the exact `A3` fused / `B3` split pair / `H3` split pair row.  The
module also reuses F8's equal-kernel uniqueness theorem for abstract two-sheet characters, while
requiring any concrete group-action identification to be supplied separately.

## Exact public surface

The gate is `RelativeConicArcs.Gates.ClebschArithmeticGluing`.  Its task-owned terminals, all in
namespace `RelativeConicArcs.ClebschArithmeticGluing`, are:

```lean
vertexReductions_are_bijective
a3_two_has_no_root
b3_two_roots
h3_five_roots
h3_golden_roots
reduced_vertex_polynomials_split
matchingEdgeLists_encode_frozen_matchings
frozen_matching_mates_are_fixedPointFree_involutions
a3_matching_is_fused
silverTransporter_swaps_matchings
goldenTransporter_swaps_matchings
coxeterSquare_orbits
projective_group_orders
a3_fused_stabilizer_and_orbit
b3_split_stabilizers_and_orbits
h3_split_stabilizers_and_orbits
h3_stabilizer_generation_word_data
transporters_are_outer
rankThree_split_fused_trichotomy
sheetCharacter_eq_of_kernel_eq
```

The data and checker definitions are self-contained in
`RelativeConicArcs.ClebschArithmeticGluingData` and
`RelativeConicArcs.ClebschArithmeticGluing`.  The matrix checker uses reducible `Fin q` arithmetic
with Fermat inversion; no imported group-order assertion or order-to-name inference occurs.

## Frozen provenance and independent replay

A normalized certificate was necessary for the `H3` leaves after direct kernel enumeration exceeded
the measured memory envelope.  The same-stem Python generator emits schema
`clebsch-arithmetic-gluing-lean-v1`, the canonical JSON, the generated certificate block in
`ClebschArithmeticGluingData.lean`, and a three-entry SHA-256 manifest.  Its `--check` and
`sha256sum -c` commands are green.  It hash-records the committed C441, C442, C444, C445, C449,
C458, and C460 JSON inputs.  Those seven primary `--check` commands all returned `OK`; the
independent C444, C445, C449, C458, and C460 replay programs also returned `OK`.

The correspondence is:

| Lean datum or theorem | Frozen source boundary |
|---|---|
| vertex tables and full projective-line images | C441 |
| golden base/conjugate matchings and sheet frame | C442/C458 |
| `A3/B3` matching rows, silver transporter, split/fused outcome | C444 |
| `H3` stabilizers, intersection, orbit split, closure, outer transporter | C445 |
| Coxeter-square multipliers and moving orbits | C449 |
| common finite golden point set and matching-level gluing | C458 |
| triangle/group-name interpretation only | C460, retained outside the Lean conclusion |

`matchingEdgeLists_encode_frozen_matchings` is the checker-soundness seam between the executable
edge-list representation and the unordered mathematical matchings.  For `H3`, Lean checks the
certificate list sizes, intersection, determinant half, transported-signature distinctness and
disjoint `11+11` split, plus the shape and bounds of all 660 three-letter generation words.
Evaluation of the coset and generation certificates is an explicit generator/replay boundary.

## Trust and exclusion ledger

| Claim | Lean route and exact boundary |
|---|---|
| literal reductions, roots, and polynomial splitting | kernel `decide` over displayed finite domains |
| matchings are complete fixed-point-free involutions | kernel `decide` after edge-list/unordered-set equivalence |
| projective group orders and square-determinant halves | exhaustive normalized-matrix reconstruction |
| `A3/B3` stabilizers, intersections, and orbit splits | exhaustive Lean action on `P¹(F_q)`; no group name inferred |
| `H3` stabilizer and orbit rows | Lean checks certificate cardinality/intersection/determinant and distinct `22=11+11` signatures; stabilizer semantics and coset completeness are generator/replay |
| `H3` generation | Lean checks the 108-generator union and 660 bounded word rows; word evaluation and coverage of the 660-element subgroup are generator/replay |
| abstract two-sheet character uniqueness | reused F8 theorem from equal kernels |
| `S4/A5/A4/S3` names | cited-input boundary; absent from Lean conclusions |
| orthogonal/spinor terminology and spinor norm two | cited-input boundary; absent from Lean conclusions |
| number-field split/inert terminology | the exact finite root/no-root rows are Lean; broader arithmetic language is cited input |
| integral cubic, reciprocity, all-prime, descent, Paper-2 mechanisms | excluded |

There is no `sorry`, project axiom, opaque oracle, or `native_decide` in the owned modules.  The
generated `H3` data leaf is hash-pinned and has the exact mixed-verification boundary above.

## Judgment calls

1. **Arithmetic carrier.**  The first implementation used `ZMod`, but equality of transported
   nested finite sets blocked kernel reduction in the pinned toolchain.  The final checker uses
   `Fin q` with explicit modular arithmetic and Fermat inversion, the established repository
   pattern for reducible finite checks.  This changes no domain or theorem and avoids a native
   evaluation axiom.
2. **Matching representation.**  Unordered finite sets are retained as the mathematical data
   surface, while ordered edge lists supply the executable mate involution.  A kernel theorem proves
   the two representations equal and another checks fixed-point-free involutivity, preventing the
   optimized checker from silently changing the object.
3. **Group names.**  Exact small-field actions and the stated `H3` mixed certificate boundary are
   checked.  Conventional abstract-group and spinor names are not inferred from orders and are not
   represented by a vacuous Lean proposition; they remain explicit cited-input rows.
4. **Certificate choice.**  Direct `H3` orbit and closure proofs exceeded the measured memory
   envelope even after module separation.  The final route keeps `A3/B3` fully kernel-reconstructed
   and uses a compact normalized `H3` certificate, with Lean checking its cheap semantic invariants
   and independent replay checking coset and generation completeness.

## Validation and axiom evidence

Exact current-source validation:

- normalized generator `--check`: `CHECK OK`;
- three-entry SHA-256 manifest: all `OK`;
- all seven frozen primary checks and five available independent replays: `OK`;
- data/kernel shard: green (`1:16.68`, peak 4,709,276 kB in
  `run-20260723-072106-fbec7e83`; the current generated data were subsequently confirmed by the
  exact gate trace);
- `RelativeConicArcs.ClebschArithmeticGluing`: green (`3:58.23`, peak 6,602,308 kB,
  `run-20260723-081451-db0b801b`);
- final current-source `RelativeConicArcs.Gates.ClebschArithmeticGluing`: green (`1:20.72`,
  peak 4,476,296 kB, `run-20260723-082529-04f3c85e`) with the trace-only aggregate gate.

The gate audits 19 terminals.  One uses `[propext]`; the other 18 use exactly
`[propext, Classical.choice, Quot.sound]`.  No terminal uses a project axiom, `sorryAx`, or a
native-evaluation axiom.

## Independent review

Pending user-authorized independent review after the exact gate passes.

## Proposed C320 ledger delta

Add one claim-level row for `RelativeConicArcs.Gates.ClebschArithmeticGluing`:

- **full-trust finite terminals:** literal reductions, finite root/splitting rows, matching
  soundness, sheet exchanges, Coxeter-square orbits, normalized projective orders, complete
  `A3/B3` stabilizer/orbit rows, the checked `H3` list/intersection/determinant and distinct
  `11+11` signature rows, bounded generation-word data, and nonsquare-determinant transporters;
- **exact external certificate/replay:** `H3` stabilizer semantics, coset completeness, and
  evaluation of the 660 words onto the square-determinant group;
- **reused symbolic terminal:** equal-kernel uniqueness of a two-sheet character;
- **external/cited inputs:** the identifications with classical `S4/A5/A4/S3`, orthogonal/spinor
  terminology, rational spinor norm, and number-field interpretation;
- **excluded:** every all-prime, reciprocity, integral-cubic, and Paper-2 descent claim.
