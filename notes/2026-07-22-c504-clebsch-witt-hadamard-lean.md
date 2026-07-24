# C504 / F11 — Lean Witt–Hadamard–Mathieu capstone

**Lane:** `clebsch`

**Status:** complete; exact-validation green and independent post-fix review `GO`

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
sharding replaced a monolithic native decision procedure that did not complete.  Exact
single-thread timings are recorded only in the validation table below.  The leaves derive:

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
- equality of the transported row-action closure with the design closure; a 95,040-pair
  simultaneous-word finite graph with indexed source and target coverage, mutually inverse total
  lookups, and quantified generator transitions; membership of the square conjugator in the design
  closure and its square formula on every graph element; literal finite normalization of the
  design closure; and exhaustive absence of an inner conjugator carrying both coordinate
  generators to the aligned row generators.  No abstract outer-automorphism inference is exported.

No theorem assigns the names `M11`, `M12`, `2.M12`, or `PSL_2(11)`.  Those names remain a
classical cited-input boundary for C320.  In particular the Lean terminal proves the exact
finite closure orders and relations used by the paper without importing GAP or ATLAS output.

The theorem-bearing module is `RelativeConicArcs.ClebschWittHadamard`; the import-only exit is
`RelativeConicArcs.Gates.ClebschWittHadamard`.  Its repaired gate audits 25 terminals:

- `residueBlocks_two_design`, `residueSign_periodic_correlation`,
  `barker_aperiodic_correlations`, `code_card`, `code_weight_distribution`,
  `punctured_weight_distribution`, and `punctured_perfect_parameter_identity`;
- `parity_extension_rule`, `generator_gram_zero`, `hexads_steiner_five`,
  `fullSupportPoints_complete`, `hadamard_gram`, and `secant_exhaustion`;
- `displayed_maps_are_permutations`, `frozen_action_literal_checks`,
  `frozen_fullSupport_action`, `parent_generators_preserve_hexads`,
  `parent_action_discriminator`, `row_column_hinge`, and
  `rowCarrierRelabelling_twoSidedInverse`; and
- `parent_intersection_and_join`, `row_action_has_design_closure`,
  `row_column_assignment_finite_graph_certificate`,
  `row_column_assignment_normalizes_design_closure`, and
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

The exact predecessor crosswalk is:

| input | primary / replay / certificate / manifest | Lean literals or boundary consumed |
|:--|:--|:--|
| C452 | `notes/2026-07-21-c452-qr-barker.py`; `notes/2026-07-21-c452-qr-barker-replay.py`; `notes/2026-07-21-c452-qr-barker.json`; `notes/2026-07-21-c452-qr-barker.sha256` | `residueBlock`, `barkerWord`, cyclic incidence and correlation conventions |
| C464 | `notes/2026-07-21-c464-perfect-code-spans.py`; `notes/2026-07-21-c464-perfect-code-spans-replay.py`; `notes/2026-07-21-c464-perfect-code-spans.json`; `notes/2026-07-21-c464-perfect-code-spans.sha256` | punctured `[11,6,5]` row space, punctured weight distribution, and radius-two packing data |
| C469 | `notes/2026-07-21-c469-witt-golay-equivariance.py`; `notes/2026-07-21-c469-witt-golay-equivariance-replay.py`; `notes/2026-07-21-c469-witt-golay-equivariance.json`; `notes/2026-07-21-c469-witt-golay-equivariance.sha256` | parity-extension/Hadamard boundary, Hadamard rows, secant shadow, frozen coordinate and full-support actions |
| C470 | `notes/2026-07-22-c470-golay-hadamard-automorphisms.py`; `notes/2026-07-22-c470-golay-hadamard-automorphisms-replay.py`; `notes/2026-07-22-c470-golay-hadamard-automorphisms.json`; `notes/2026-07-22-c470-golay-hadamard-automorphisms.sha256` | exact 6×12 extended generator and extended targets; parent/design/row generators, carrier relabelling, square conjugator; classical names remain cited-input only |

Replay from the repository root:

```bash
python3 notes/2026-07-21-c452-qr-barker.py --check
python3 notes/2026-07-21-c452-qr-barker-replay.py
python3 notes/2026-07-21-c464-perfect-code-spans.py --check
python3 notes/2026-07-21-c464-perfect-code-spans-replay.py
python3 notes/2026-07-21-c469-witt-golay-equivariance.py --check
python3 notes/2026-07-21-c469-witt-golay-equivariance-replay.py
python3 notes/2026-07-22-c470-golay-hadamard-automorphisms.py --check
python3 notes/2026-07-22-c470-golay-hadamard-automorphisms-replay.py
sha256sum -c notes/2026-07-21-c452-qr-barker.sha256
sha256sum -c notes/2026-07-21-c464-perfect-code-spans.sha256
sha256sum -c notes/2026-07-21-c469-witt-golay-equivariance.sha256
sha256sum -c notes/2026-07-22-c470-golay-hadamard-automorphisms.sha256
```

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

After the initial-review prose repair, all nine affected leaves, both aggregators, and the import
gate rebuilt from the exact source below in run `20260723-232726-3fc64082`; its trace-only
aggregate gate also passed.

The adversarial-review repair rebuilt the evaluator base, row-action leaf, closure leaf, and
25-probe import gate from the exact source below in run
`20260724-002809-a9fa0428`; its trace-only aggregate gate also passed:

| repaired target | wall | peak RSS |
|:--|--:|--:|
| evaluator base | `0:05.17` | `1,825,136 kB` |
| row action | `1:42.46` | `1,807,040 kB` |
| closure/finite assignment | `0:46.46` | `1,869,092 kB` |
| import gate | `4:04.85` | `1,892,984 kB` |

All 25 gate probes completed.  Twenty-four terminals list only `propext`, `Classical.choice`,
`Quot.sound`, and the appropriate declaration-local native-decision axiom or axioms.  The
kernel-decided `parent_action_discriminator` lists exactly `propext`, `Classical.choice`, and
`Quot.sound`.  `displayed_maps_are_permutations` and `frozen_action_literal_checks` each expose two
declaration-local native-decision axioms; the other native terminals expose one.  No terminal
depends on `sorryAx`, a project axiom, GAP, ATLAS, a JSON boolean, or an opaque oracle.

The exact validated Lean repair is commit
`42683dff12835cef50094f2495a5a9103bb30d02`.

Exact source SHA-256 hashes:

```text
aa62fb900fb5298551281dff1ab1976d368634c02db4a7c11cb5457d4b0a974a  ClebschWittHadamardData.lean
71175d30db2f5cf5651c3905f0a367ac3b601597b1c500d9add3d3e399ca8614  ClebschWittHadamard.lean
a5a1fc822c4049c2234007090473a348f9304129f44f4588d22254373d057af7  ClebschWittHadamardSequences.lean
8a5b86b804cda57fdbbcdbafe2e3273d7d6b76b15a6f1c741781babb32c425da  ClebschWittHadamardExtendedCode.lean
23467cb527f0b52d38abe09ee079202ae3c4ac4906a06da940172029629af6df  ClebschWittHadamardPuncturedCode.lean
8194216d28aed2f739a6f9d80e0bd242a5eb16629a3f66ec25cfdc0e382e33b1  ClebschWittHadamardCodeStructure.lean
a39ef17a7df31b9b3107b56a74b26619960ff5749aacf9ddf08818d2e64d25c7  ClebschWittHadamardGeometry.lean
03db0c96d6ca056b737d2c44869cbdc86edf5b3de30c3c8842cc4369d9f2cb99  ClebschWittHadamardFrozenAction.lean
1d7a590c27a7ade7c16660e3a42ded2a2d9d438b47d9f7c0bcf3fd1ba3edf01f  ClebschWittHadamardParentActions.lean
99e621b9a4e7d2ef4b84791c0e9d091ac3f2d9231a0bf31174f5b0a3284eca3d  ClebschWittHadamardRowAction.lean
662aea5731da49a5274e06b484988fa4f4fed8abb07462461fb35f35ee5558cb  ClebschWittHadamardClosures.lean
4a19066c9546ea344485e6c9eec300f8dd2f48f0886aeb475d3d76cbe557bd42  ClebschWittHadamardCode.lean
91be8803581b06be53adeb990b0cc47a40d9680b8b4ea30650ed27379749d208  ClebschWittHadamardActions.lean
192570efea371c4f33fe48008f273d98588de512c34628945b4ad2e6d207d72e  Gates/ClebschWittHadamard.lean
```

### Independent review

The user-launched initial independent review returned NO-GO on one narrow trust-boundary prose
defect: nine leaf headers named `Lean.ofReduceBool`, while the pinned toolchain's fresh 23-terminal
gate audit reported declaration-local `_native.native_decide.ax_1_1` dependencies.  The reviewer
found no mathematical, architectural, literal-table, replay, hash, hygiene, or axiom blocker.

All nine headers now use the actual declaration-local native-decision-axiom wording, and the exact
post-fix source passed the guarded build and aggregate gate recorded above.  Per the lane protocol,
the user launched a fresh post-fix reviewer.  That reviewer independently verified the nine
repairs, all fourteen source hashes, the terminal-by-terminal axiom shape, and the guarded run's
terminal success, and returned final `GO`.  No mathematical, architectural, trust-route,
provenance, hash, build, axiom, or hygiene blocker remains.

A later user-launched adversarial review reopened the task with five deeper interface findings:
the square conjugator lacked certified closure membership; the carrier inverse and frozen-row maps
were incompletely audited; the simultaneous-word graph did not expose quantified carrier,
generator-transition, inverse, and word-descent statements; the required literal normalizer
terminal was absent; and the provenance/commit pin and timing prose were incomplete or
inconsistent.  The current repair adds the missing carrier, square-membership, indexed graph, and
literal normalizer checks; narrows “automorphism” to the exact finite assignment certificate
actually checked; and adds the exact predecessor crosswalk and one authoritative timing table.
Exact validation and repaired source hashes are recorded above.  The repair commit pin is recorded
above.  The first post-fix pass found one remaining report-only provenance error: the crosswalk
assigned the exact extended generator and targets to C464.  Commit `1aac9554` corrected the rows so
C464 owns the punctured `[11,6,5]` data, C469 the parity-extension/Hadamard boundary, and C470 the
exact 6×12 extended generator and targets.  The reviewer confirmed that this commit changed only
the report, left the validated Lean surface byte-identical, matched the predecessor certificate
schemas, and returned final `GO`.

### Mystery ledger

- **Settled — monolithic evaluator stall.**  Cross-module certificate sharding and symbolic
  coefficient-vector transport replaced the greater-than-ten-minute monolith; the slowest exact
  leaf is now independently bounded and cacheable.
- **Settled — frozen-generator mismatch.**  The first literal pair generated the right
  660-element subgroup but did not equal C470's frozen coordinate generators.  The displayed data
  now match C470 exactly, with the subgroup and action properties rechecked.
- **Settled — native trust-route name.**  Lean 4.32 exposes declaration-local native-decision
  axioms rather than the older prose label; the gate, all leaf headers, and this report now state
  the observed route consistently.
- **Deliberate boundary, not an open mystery.**  The classical names `M11`, `M12`, `2.M12`, and
  `PSL_2(11)` remain cited/external identifications rather than Lean terminals.  The proposed C320
  ledger row below owns that release-facing distinction.  The `ej`+`tt` closeout found no further
  genuine task-owned mystery.

### Proposed C320 ledger delta

Add one F11 row pointing to
`RelativeConicArcs.Gates.ClebschWittHadamard`, with separate entries for QR incidence,
punctured/extended code parameters, Steiner support design, full-support points, secant exhaustion,
Hadamard identity, parent intersection/join, carrier inverse, the simultaneous-word finite graph,
literal closure normalizer, inner-square membership/formula, and the non-inner row/column witness.
Mark all computational terminals `native_decide` / declaration-local native axiom (the current
toolchain prints `_native.native_decide.ax_1_1`); place the classical names `M11`, `M12`, `2.M12`,
and `PSL_2(11)` in the cited-input column rather than the Lean-formalized column.
