# C494 — Lean C434 middle-stratum information lattice

**Lane:** `clebsch`

**Status:** local gate complete; user-launched post-fix review required

This file is both the cold-read task specification and the durable result report. Complete it in
place with exact theorem names, owned artifacts, validation, axiom evidence, trust boundaries,
judgment calls, review dispositions, and the proposed C320 ledger delta.

## Required outcome and trust route

Consume the frozen C434 certificate without changing it. Kernel-check, at B3 (`q=7`) and H3
(`q=11`) only, the clause-2 statement that the `(sheet,D')` fibres are exactly the `K`-orbits
obtained from shared-edge counts, and the invariant-subalgebra tower

```text
1 subset 2 subset 6 subset 2q.
```

This task adds compact finite leaves to the already green C425 depth-profile interface. It proves no
new geometry and does not generalize beyond the two frozen cases.

## Owned surface and dependencies

- Own only `lean/RelativeConicArcs/ClebschInformationLatticeB3.lean`,
  `lean/RelativeConicArcs/ClebschInformationLatticeH3.lean`,
  `lean/RelativeConicArcs/Gates/ClebschInformationLattice.lean`, and this report.
- Import C425's public terminal and definitions-only data translated from C434's committed,
  hash-pinned certificate. Do not modify C425, C434, or their replay bundles.
- Exit only through `RelativeConicArcs.Gates.ClebschInformationLattice`.

## Trust and exclusion boundary

Each finite table requires a theorem connecting accepted data to the quantified fibre and
subalgebra statements. Literal `native_decide` or equivalent checks must be accompanied by exact
provenance and an axiom audit. No claim of a general `K\G/H` theorem, arbitrary `q`, or canonical
association-scheme identification is included.

## Validation and closing review

Before any Lean action read `lean/AGENTS.md` and the routed named-expert dossier. Use the guarded
single-file and unattended exact-target commands required there. Record every terminal
`#print axioms` result; neither `sorryAx` nor a project-local axiom may appear.

Completion requires: finished artifact and report; local checklist and proposed C320 delta;
user-launched independent review; disposition of every issue; user-launched post-fix review after
any change; and recorded final `GO`. The implementer may not choose, spawn, or simulate the
reviewer.

## Result, judgment calls, validation, review, and C320 delta

### Formal result

The implementation uses two finite leaves and one import-only gate:

- `RelativeConicArcs.ClebschInformationLatticeB3` displays the fourteen perfect matchings of eight
  vertices, the two sheet labels, all eight permutations in the accepted `K`-action, and the six
  accepted orbit labels.
- `RelativeConicArcs.ClebschInformationLatticeH3` displays the twenty-two perfect matchings of
  twelve vertices, the two sheet labels, all twelve permutations in the accepted `K`-action, and
  the six accepted orbit labels.  It imports the public
  `RelativeConicArcs.ClebschDoubleCosetDepth` terminal but does not identify that module's depth
  coordinates with the shared-edge coordinates checked here.
- `RelativeConicArcs.Gates.ClebschInformationLattice` is the sole exit gate and prints the axioms
  of every paper-facing terminal.

Both leaves define the relative shared-edge count from the displayed mate maps rather than
accepting a precomputed count table.  They prove:

- every matching row is a fixed-point-free involution;
- all fourteen/twenty-two displayed matching rows are distinct;
- the displayed `K`-action contains the identity and is closed under composition and inversion;
- all eight/twelve displayed action rows are distinct, so they are the full faithful action tables;
- `SameKOrbit` is an equivalence relation and has exactly the fibres of the displayed orbit label;
- for every pair of matching indices, equality of
  `(sheet, sharedEdgeCount(-, M0), sharedEdgeCount(-, JM0))` is equivalent to `SameKOrbit`;
- the two shared-edge counts without the sheet coordinate merge distinct `K`-orbits; and
- the fibre-constant rational function algebras for the constant, sheet, `K`-orbit, and singleton
  labels form strict towers with dimensions `1 < 2 < 6 < 14` and `1 < 2 < 6 < 22`.

The generic terminal
`RelativeConicArcs.ClebschInformationLattice.fibreSubalgebra_finrank` identifies the algebra of
functions constant on the fibres of any surjective finite label map with the full function space
on its label set.  The concrete dimension statements are:

- `B3.constantInvariant_finrank`, `B3.sheetInvariant_finrank`,
  `B3.kOrbitInvariant_finrank`, and `B3.fullFunctionAlgebra_finrank`;
- `H3.constantInvariant_finrank`, `H3.sheetInvariant_finrank`,
  `H3.kOrbitInvariant_finrank`, and `H3.fullFunctionAlgebra_finrank`.

The quantified clause-2 terminals are
`B3.intrinsicProfile_eq_iff_sameKOrbit` and
`H3.intrinsicProfile_eq_iff_sameKOrbit`.  The complete strict-tower terminals are
`B3.invariantSubalgebra_strictTower` and `H3.invariantSubalgebra_strictTower`.

### Provenance and trust boundary

The accepted matching, sheet, orbit-label, and full action tables were deterministically
reconstructed with the frozen C434 source checker, using its canonical sorted matching order and
canonical maximal-`|K|` involution choice.  They were then independently compared with that
reconstruction: the matching, sheet, and orbit-label tables agree entrywise, and each displayed
action table agrees as a row set.  The canonical aggregate JSON has SHA-256
`6d0e0106aa04dfcfe694f74494eaf86743a3254c62c6c1e878000301ec2f0899`; it records the clause
results and orbit-profile summaries, not the full translated tables.  The source checker has
SHA-256 `b1ba013747d9fa1d9c9b4f6055a26a7dc53a953babca366057c7094f46549d27`; the independent replay
has SHA-256 `1285cf4d23878b3798834dae2eb4d16777651ab5395b0477c93e0e644dc7ccaf`.
The tracked checksum manifest verifies all three files.

Final Lean source hashes at code commit `48dfa0a6`:

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| `ClebschInformationLatticeB3.lean` | 10,991 | `cbfe737bcd3eeef6b0ac2c6c3a5f92b6ba4653927c8db3f6cb79f5e7a5f4af7f` |
| `ClebschInformationLatticeH3.lean` | 11,147 | `928d5e23bf2595e9a50979ea35d311331266de3611c4ccf9905f0763c37b1698` |
| `Gates/ClebschInformationLattice.lean` | 3,358 | `f6423e1200dd70608e52c0c6c8d955784c32231cf4deafd8bffcf882c01e5d7d` |

Lean checks the displayed data exhaustively at B3 and H3 only.  Kernel `decide` proves the finite
propositions; the generic subalgebra argument is symbolic.  The artifact does
not reconstruct `PGL₂(q)`, derive `K` from projective coordinates, prove a general `K\G/H` theorem,
identify a canonical association scheme, or generalize beyond `q=7,11`.  It also does not identify
the shared-edge middle labels with C425's depth coordinates.  The projective construction and the
translation of the four accepted tables remain the explicit certificate boundary.

### Reproducibility and validation

From `/home/tavis/src/othello`, the frozen input bundle was rechecked without regeneration:

```bash
python3 notes/2026-07-22-c434-double-coset-information-lattice.py --check
python3 notes/2026-07-22-c434-double-coset-information-lattice-replay.py
sha256sum -c notes/2026-07-22-c434-double-coset-information-lattice.sha256
```

All three commands passed.  The independent replay recovered B3
`|K|=8`, orbit sizes `[1,1,2,2,4,4]`, and chain `[1,2,6,14]`, and H3
`|K|=12`, orbit sizes `[1,1,4,4,6,6]`, and chain `[1,2,6,22]`.

Scoped Lean validation passed through the required guarded workflow:

- guarded single-file elaboration passed for B3 and H3 after conversion from native evaluation to
  kernel `decide`;
- the exact-target queue rebuilt both leaves successfully under the serial `single` profile;
- `RelativeConicArcs.Gates.ClebschInformationLattice` built successfully as the sole exit gate;
- a second exact-target queue invocation reported the gate already trace-current and skipped it;
- all 31 gate `#print axioms` probes were inspected: 2 report `[propext]`, 7 report
  `[propext, Quot.sound]`, and 22 report `[propext, Classical.choice, Quot.sound]`;
- no probe reports `sorryAx`, a native-evaluation axiom, or any project-local axiom.

The successful gate build is recorded under
`~/.cache/othello-lean-build/run-20260723-211709-368fcbbd`; the trace-current confirmation is
`~/.cache/othello-lean-build/run-20260723-211732-1ad549ca`.  These machine-local logs are
diagnostic records only; the committed source and gate are the scholarly evidence.

### Judgment calls and local checklist

- The leaves include the full action tables and check group laws; they do not reduce the fibre
  theorem to equality of two independently trusted label tables.
- Shared-edge counts are recomputed from displayed perfect matchings inside Lean.
- The function-algebra tower is formalized as actual `Subalgebra ℚ (Ω → ℚ)` inclusions, not only
  as a list of partition cardinalities.
- C425 is imported as the public interface boundary, while the unproved coordinate identification
  is stated as an exclusion.
- Module prose contains no internal task, lane, agent, session, or report references.
- Both leaves and the sole gate pass guarded elaboration, exact-target builds, trace-current
  confirmation, and the complete 31-terminal standard-axiom audit.

### Review disposition

The user launched the initial independent review during implementation.  Its verdict was
`NO FINAL GO; SOURCE NOT YET READY FOR ACCEPTANCE VALIDATION`, with one validation blocker and
three required source/evidence repairs:

1. H3/gate elaboration and the complete gate axiom transcript were still outstanding.
2. The matching tables needed pairwise-injectivity terminals.
3. The action tables needed pairwise-injectivity terminals to justify the full faithful-action
   wording.
4. The report incorrectly described the full finite tables as JSON translations, although the
   canonical JSON contains only aggregate clause results and orbit-profile summaries.

All source/evidence repairs are applied: `matchingMate_injective` and `kAction_injective` now exist
for both leaves and are printed by the gate; the provenance and proposed C320 boundary now describe
the deterministic reconstruction and exact comparison accurately.  The reviewer otherwise accepted
the quantified fibre equivalences, sheet-load-bearing witnesses, actual rational subalgebra tower,
finrank/strictness arguments, trust exclusions, and gate scope.

Because these are post-review source changes, completion requires a user-launched post-fix review
after the complete local gate passes.  Every post-fix issue and its disposition belongs here, and
completion requires recorded final `GO`.

### Mystery ledger (ej closeout)

Settled by the closeout pass:

- **Displayed indices versus genuine finite objects.**  The initial leaves proved that every row
  was a perfect matching and that the action table satisfied group laws, but did not prove row
  distinctness.  The two `matchingMate_injective` and two `kAction_injective` terminals now close
  that representation gap and are included in the gate audit.
- **Native checking was the wrong trust/performance boundary.**  The first gate audit exposed
  theorem-local native-evaluation axioms, and the H3 native compilation took over twelve minutes.
  Replacing every finite proof by kernel `decide` removes those axioms and reduces guarded
  elaboration to roughly 15 seconds for B3 and 19 seconds for H3.
- **Provenance of the full tables.**  The canonical JSON records aggregate results, not the full
  action tables.  The report now states the exact deterministic-reconstruction boundary and the
  independent entrywise/row-set comparisons rather than treating the JSON as a table source.

No genuine task-owned mystery remains.  The projective derivation of the accepted tables, general
`q`, abstract-group naming, association-scheme canonicity, and identification with C425's depth
coordinates are explicit exclusions rather than unresolved claims of this finite gate.

### Proposed C320 ledger delta

Add one row for `RelativeConicArcs.Gates.ClebschInformationLattice`:

- **Claims:** at B3 and H3 only, the `(sheet,D')` fibres equal the displayed `K`-orbits; the sheet
  coordinate is load-bearing; and the invariant function-algebra towers have dimensions
  `1,2,6,14` and `1,2,6,22`.
- **Exact terminals:** the two `intrinsicProfile_eq_iff_sameKOrbit` theorems, the two
  `sharedEdgePair_not_complete` theorems, the two `invariantSubalgebra_strictTower` theorems, and
  their matching/action injectivity, displayed group-law, orbit-label, inclusion, and finrank
  support terminals printed by the gate.
- **Method:** exhaustive kernel checking of explicitly displayed matchings and full action tables,
  followed by a symbolic finite-label/subalgebra dimension argument.
- **Accepted boundary:** deterministic reconstruction from the frozen, hash-pinned C434 checker
  using its canonical ordering and canonical involution choice; the aggregate JSON does not itself
  contain the full tables.
- **Excluded:** projective derivation of those tables, abstract-group naming, general `q`,
  association-scheme canonicity, and identification with the C425 depth coordinate system.
