# C504 / F11 — Lean Witt–Hadamard–Mathieu capstone

**Lane:** `clebsch`

**Status:** implementation and exact gate green; awaiting user-launched initial independent review

This file is both the cold-read task specification and the durable result report. Complete it in
place with exact theorem names, artifacts, validation, axiom evidence, trust boundaries, judgment
calls, review dispositions, and the proposed C320 ledger delta.

## Required outcome and trust route

Translate the Paper-1 C452/C464/C469/C470 chain into sound finite checker leaves:

- QR/Barker incidence and the perfect-code substrate used by the paper;
- the twelve full-support projective points and their `1+11` frozen `PSL_2(11)` action;
- all 66 secants and their complete Witt-design shadow;
- parity extension, the exact order-12 Hadamard identity, and minimum-word secant exhaustion;
- the `S(5,6,12)` support design, two degree-12 parent actions, their exact frozen
  `PSL_2(11)` intersection, their join, and the row/column outer hinge.

Use definitions-only data and theorem-bearing checkers. GAP and ATLAS may identify classical names
in the paper ledger, but neither is a Lean axiom.

## Owned surface and dependencies

- Own the definitions-only
  `lean/RelativeConicArcs/ClebschWittHadamardData.lean` and
  `lean/RelativeConicArcs/ClebschWittHadamard.lean`; the bounded
  `ClebschWittHadamardSequences`, `ExtendedCode`, `PuncturedCode`, `CodeStructure`,
  `Geometry`, `FrozenAction`, `ParentActions`, `RowAction`, and `Closures` leaves; the light
  `ClebschWittHadamardCode` and `ClebschWittHadamardActions` aggregators; the import gate
  `lean/RelativeConicArcs/Gates/ClebschWittHadamard.lean`; and this report.
- Consume C452/C464/C469/C470 scripts, replays, JSON, and manifests read-only.
- Exit through `RelativeConicArcs.Gates.ClebschWittHadamard`.

## Required theorem boundary

The gate must prove literal finite incidence, code, matrix, permutation-action, subgroup,
intersection, join, normalizer, and non-inner-witness statements. It may call a group `M12`,
`M11`, or `2.M12` only if the exact identification is formalized; otherwise export the explicit
finite group properties and leave the classical name to C320's cited-input column. Do not import
C471's operator complex or C472's genuine-Weil claims.

## Validation and closing review

Before proof work read `lean/AGENTS.md` and the routed named-expert dossier. Shard finite data across
module boundaries, retain independent replay, connect every accepted table to its quantified
theorem, and audit every terminal for axioms. Use guarded/unattended exact-target builds only.

Completion requires artifact/report/checklist/C320 delta, user-launched independent review,
resolution or narrowing of every finding, user-launched post-fix review after changes, and recorded
final `GO`. The implementer may not select or simulate the reviewer.

## Result, judgment calls, validation, review, and C320 delta

### Implemented finite surface

The owned Lean surface now has definitions-only literal-data and evaluator modules, bounded
theorem-bearing leaves, two light aggregators, and the required import gate.  This module-boundary
sharding replaced a monolithic native decision procedure that did not complete in more than ten
minutes.  The isolated definitions base builds in 12--14 seconds, the complete 95,040-action leaf
in 25 seconds, the geometry leaf in 58 seconds, and the parity/Gram leaf in 17 seconds on the
measured single-thread profile.  The leaves derive:

- the cyclic `2-(11,5,2)` QR incidence design and its off-zero periodic correlation `-1`;
- the punctured ternary code's exact weight distribution and radius-two packing equality;
- the parity-extended code's exact weight distribution, generator Gram zero, and parity rule;
- all 132 minimum supports and the exhaustive `5-(12,6,1)` property;
- all twelve projective full-support points, the integer identity `H H^T = 12 I`, and equality
  between the 132 projective minimum words and the interior points of all 66 sign-row secants;
- literal preservation and point-orbit checks for the frozen and parent generators;
- explicit positive-word closures of orders `660`, `7920`, `7920`, and `95040`, equality of the
  parent intersection with the frozen closure, and equality of the parent join with the design
  closure; and
- equality of the transported row-action closure with the design closure, a 95,040-pair
  simultaneous-word graph certifying that the generator assignment is a bijective automorphism,
  an explicit inner conjugator for its square, and exhaustive absence of an inner conjugator
  carrying both coordinate generators to the aligned row generators.

No theorem assigns the names `M11`, `M12`, `2.M12`, or `PSL_2(11)`.  Those names remain a
classical cited-input boundary for C320.  In particular the Lean terminal proves the exact
finite closure orders and relations used by the paper without importing GAP or ATLAS output.

The theorem-bearing module is `RelativeConicArcs.ClebschWittHadamard`; the import-only exit is
`RelativeConicArcs.Gates.ClebschWittHadamard`.  Its 23 audited terminals are:

- `residueBlocks_two_design`, `residueSign_periodic_correlation`,
  `barker_aperiodic_correlations`, `code_card`, `code_weight_distribution`,
  `punctured_weight_distribution`, and `punctured_perfect_parameter_identity`;
- `parity_extension_rule`, `generator_gram_zero`, `hexads_steiner_five`,
  `fullSupportPoints_complete`, `hadamard_gram`, and `secant_exhaustion`;
- `displayed_maps_are_permutations`, `frozen_action_literal_checks`,
  `frozen_fullSupport_action`, `parent_generators_preserve_hexads`,
  `parent_action_discriminator`, and `row_column_hinge`; and
- `parent_intersection_and_join`, `row_action_has_design_closure`,
  `row_column_assignment_is_automorphism_graph`, and
  `row_column_hinge_has_no_inner_witness`.

### Trust route and judgment calls

The small and medium code/design statements are executable exhaustive checks over the displayed
generator matrix.  The degree-twelve group statements use bounded work-list closure over explicit
permutation image lists.  Each finite leaf uses `native_decide`; in the pinned Lean toolchain its
projected terminals expose a declaration-local `_native.native_decide.ax_1_1` dependency rather
than a literal `Lean.ofReduceBool` name.  The separate two-orbit parent discriminator uses kernel
`decide`.  Native evaluation was chosen after direct kernel reduction of the combined
729-word/design checker reached roughly 10 GB RSS.  The native evaluator is a declared trust
boundary, not described as kernel reduction.

Two table-shape bridges avoid repeating earlier performance failures.  The parity theorem checks
all 729 coefficient vectors and transports the result through the image definition of `codewords`,
rather than deciding membership in a `Finset` of function-valued words.  Frozen code preservation
likewise checks equality with the coefficient vector read from the systematic first six
coordinates and transports that equality to code membership.  The frozen coordinate generators
were corrected during this check to the exact C470 translation/inversion pair matching the
recorded row-action table; the previous pair generated the same order-660 subgroup but did not
match that table generator by generator.

The two named Mathieu parents and the nonsplit double cover are deliberately not formalized by
name.  The task-owned paper interface needs the finite parent/intersection/join and row/column
hinge properties; naming them from GAP/ATLAS would add a classical identification assumption
without strengthening those finite conclusions.

### Frozen provenance and independent replay

The exact C452, C464, C469, and C470 primary checks, independent Python replays, and checksum
manifests all passed together on 2026-07-23.  The Lean literals are the QR block, generator matrix,
Hadamard sign matrix, signed monomial generators, parent generators, frozen generators, and
row-action carriers checked by those bundles.  Lean rechecks the paper-facing finite consequences
from the literals and does not treat the JSON booleans or GAP names as axioms.

### Validation and axiom evidence

The final clean-source queue built every definitions/checker leaf under the measured single-thread
profile.  Representative exact timings and peaks were:

| target | wall | peak RSS |
|:--|--:|--:|
| definitions base | `0:05.25` | `1,822,736 kB` |
| sequences | `0:06.13` | `1,800,924 kB` |
| extended code | `1:08.31` | `1,789,452 kB` |
| punctured code | `1:21.37` | `1,798,832 kB` |
| parity/Gram | `0:08.12` | `1,801,892 kB` |
| geometry | `0:55.24` | `1,802,096 kB` |
| frozen action | `1:41.40` | `1,801,928 kB` |
| parent actions | `0:37.31` | `1,921,820 kB` |
| row action | `0:04.64` | `1,803,172 kB` |
| closure/outer hinge | `0:25.86` | `1,851,712 kB` |

Foreign Lean work appeared twice between targets; the guarded runner refused rather than overlap
it, and the remaining trace-current leaves were resumed through later owner-lock runs.  The light
code/action aggregators built in `0:03.59` and `0:03.50`.  The final import gate rebuilt from the
exact source below in run `20260723-231350-8219e40b` (`0:10.46`, `1,792,380 kB`) and its aggregate
`--no-build` confirmation passed.

All 23 gate probes completed.  Twenty-two terminals list only `propext`, `Classical.choice`,
`Quot.sound`, and the appropriate declaration-local native-decision axiom or axioms.  The
kernel-decided `parent_action_discriminator` lists exactly `propext`, `Classical.choice`, and
`Quot.sound`.  No terminal depends on `sorryAx`, a project axiom, GAP, ATLAS, a JSON boolean, or an
opaque oracle.

Exact source SHA-256 hashes:

```text
aa62fb900fb5298551281dff1ab1976d368634c02db4a7c11cb5457d4b0a974a  ClebschWittHadamardData.lean
1a4f1d7771c8f8d87c40a494dfa6d9d779ce9be70212bf9d7a4364bf68944b39  ClebschWittHadamard.lean
5c31224ecdf5a2cc23a1a716890eccd3e8c358cd77a3f0cfda3800513b137866  ClebschWittHadamardSequences.lean
c8ea472f5003df85e336f65e49d07a8e8fc62806a3c91c10d008cb660413e477  ClebschWittHadamardExtendedCode.lean
f69372187faef098675a88d286c5198b3d7d05643be44d5a8395caaf2b6f1e8f  ClebschWittHadamardPuncturedCode.lean
c4e12742c9b1e5e7dbcbb6b24e3724dfcfd943963dded647e88face41eaec4f4  ClebschWittHadamardCodeStructure.lean
116688ebbb8eaa1bb55dde9676bf5b0b88242fc9a49bc02dfb73932397a1fab1  ClebschWittHadamardGeometry.lean
21508de59aca87da266f7c3afd78aa37078cd6aaefa1bb22c2d072041bb14f1b  ClebschWittHadamardFrozenAction.lean
aa97ee550b92dc13a50dad74e42edabca45352e641222086095a211c7b56bcce  ClebschWittHadamardParentActions.lean
51c02af0da92bef6129336cb08d94ca30768cd89af8a78e40db4b37c665959d0  ClebschWittHadamardRowAction.lean
253d016ca610509600e7c970f18d7def4acb017c18ea33505eeea10023718e3b  ClebschWittHadamardClosures.lean
4a19066c9546ea344485e6c9eec300f8dd2f48f0886aeb475d3d76cbe557bd42  ClebschWittHadamardCode.lean
91be8803581b06be53adeb990b0cc47a40d9680b8b4ea30650ed27379749d208  ClebschWittHadamardActions.lean
efd8b64f9b9db1dab1a8d80db58957117477ceae9517027d65aa9553c9b0d1e3  Gates/ClebschWittHadamard.lean
```

### Independent review

The implementation, exact gate, source audit, replay, and axiom audit are ready.  The implementer
stops here for the user-launched initial review.  Any review-driven changes require a user-launched
post-fix review.

### Proposed C320 ledger delta

Add one F11 row pointing to
`RelativeConicArcs.Gates.ClebschWittHadamard`, with separate entries for QR incidence,
punctured/extended code parameters, Steiner support design, full-support points, secant exhaustion,
Hadamard identity, parent intersection/join, and the non-inner row/column witness.  Mark all
computational terminals `native_decide` / declaration-local native axiom (the current toolchain
prints `_native.native_decide.ax_1_1`); place the classical names `M11`, `M12`, `2.M12`, and
`PSL_2(11)` in the cited-input column rather than the Lean-formalized column.
