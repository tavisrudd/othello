# C505 / F12 — Lean torsor-Rosetta closing theorem

**Lane:** `clebsch`

**Status:** initial independent review `NO-GO`; repairs implemented, validated, and pinned at
`4c01ea83`; user-launched post-fix review pending

## Outcome and exact trust route

C505 provides a mixed-verification assembly theorem for the Paper-1 torsor close. The formal
surface now distinguishes three kinds of evidence:

1. **Full-trust Lean deductions:** the reusable free-`C2` interface, actual split-root torsors,
   fixed-child quotient consequences, equal-kernel character uniqueness, inert Frobenius-orbit
   control, and every equivariance consequence of a supplied certificate.
2. **Imported finite Lean terminals:** the characteristic-five no-root row and the current
   degree-twelve row/column finite-graph and no-inner-witness checks.
3. **Explicit external certificate inputs:** the semantic indexing of actual fixed-child parents,
   the three concrete character actions and their kernel, the design/Fourier/Hadamard readout
   maps, and the characteristic-zero golden descent/reduction object.

The closing theorem no longer manufactures semantic bridges by retagging fresh copies of `Fin 2`.
Every semantic bridge is an argument whose structure records the actual carrier, action, and
equivariance map that external replay must supply.

## Owned surface and dependencies

- `lean/RelativeConicArcs/ClebschTorsorRosettaData.lean`
- `lean/RelativeConicArcs/ClebschTorsorRosetta.lean`
- `lean/RelativeConicArcs/Gates/ClebschTorsorRosetta.lean`
- this report

The theorem module imports:

- `RelativeConicArcs.Gates.ClebschReplacementSpine`;
- `RelativeConicArcs.Gates.ClebschArithmeticGluing`; and
- `RelativeConicArcs.Gates.ClebschWittHadamard`.

No upstream Lean source, generator, certificate, or manifest is modified.

## Formal result

### Reusable torsor API

`FreeC2Torsor X` contains:

- a permutation `swap`;
- involutivity;
- fixed-point freeness;
- transitivity in the exact form `y=x or y=swap x`; and
- cardinality two.

`TorsorEquiv` is an explicit equivalence commuting with the two swaps. The public consequences
`no_invariant_point` and `point_or_swapped_point` formalize respectively why zero advice is
impossible and why one bit suffices.

### Actual finite split and inert carriers

The split carriers are subtypes of finite fields:

```text
BinaryRoot = {x : F_7  | x^2 = 2}
GoldenRoot = {x : F_11 | x^2 - x - 1 = 0}.
```

Their swaps are `x -> -x` and `x -> 1-x`. The displayed equivalences
`binaryRootToOrientation` and `goldenRootToOrientation` label the literal roots
`{3,4}` and `{8,4}` and are proved equivariant. Thus the B3/H3 torsors are root-derived, not
unrelated two-element carriers. `splitRoot_values` exports both literal root sets.

The A3 control consists of:

- imported no-root evidence for `x^2=2` over `F_5`;
- a two-point geometric label set;
- Frobenius acting by the nontrivial swap; and
- a single displayed Frobenius orbit.

The standard identification of that geometric pair with the roots of the irreducible quadratic
algebra is a named arithmetic input; Lean checks the exact finite no-root and one-orbit statements.

### Fixed-child to `T_11`

`FixedChildCertificate Parent` requires:

- an actual finite parent carrier `Parent`;
- an equivalence `Parent ≃ Fin 22`;
- its actual outer permutation; and
- proof that the indexing carries that permutation to the explicit paired-parent involution.

The theorem `fixedChildQuotient_is_t11` then proves:

- the parent carrier has size 22;
- each quotient fibre has size 11;
- both quotient values occur; and
- the actual outer permutation induces the nontrivial swap on the quotient.

This is the exact formal consequence of the C474/C486 semantic indexing. The certificate premise,
not a phantom tag, owns the external identification with deletion-trace signatures.

### One sign character, three readouts

`SignCharacterCertificate G` requires:

- a supplied subgroup `inner`;
- determinant-sign, Čech, and selector homomorphisms `G -> Perm(Fin 2)`; and
- proofs that all three kernels equal `inner`.

`one_sign_character_three_readouts` proves both readout homomorphisms equal the determinant
homomorphism and re-exports its exact kernel. In the intended application, the external finite
group dictionary names `G=PGL_2(q)` and `inner=PSL_2(q)`. Lean does not infer those classical names
from cardinalities.

Unlike the initial implementation, this character theorem is a conjunct of
`torsor_rosetta_closing_theorem`.

### q=11 design/Fourier/Hadamard and forced outer

`Q11OuterReadoutCertificate Design Fourier Hadamard` requires the actual three carriers, their
actual involutions, three equivalences to the determinant-sign carrier, and all three equivariance
squares. The theorem `q11_outer_readouts_agree` extracts those certified squares.

The separate full-trust finite terminal `q11_hadamard_hinge_is_forced_outer` uses the current
upstream declarations:

```text
RelativeConicArcs.ClebschWittHadamard.row_column_assignment_finite_graph_certificate
RelativeConicArcs.ClebschWittHadamard.row_column_hinge_has_no_inner_witness.
```

It proves the exact row/column finite-graph and no-inner-witness boundary. The external q=11
readout certificate is responsible for identifying its `hadamardSwap` with that row/column
operation. Classical `M11/M12` names and self-normalizer language remain cited inputs.

### Characteristic-zero row

`GoldenCharacteristicZeroCertificate K` now contains an actual characteristic-zero field:

- `[Field K] [Algebra Q K] [FiniteDimensional Q K]`;
- a generator `phi` satisfying `phi^2-phi-1=0`;
- `Q(phi)=K`;
- degree two;
- a `Q`-algebra conjugation carrying `phi` to `1-phi`; and
- an equivariant equivalence from the two reduction labels to the actual `GoldenRoot` subtype.

Thus `golden_characteristic_zero_reduction_dictionary` mentions and constrains the
characteristic-zero object, its conjugation, and the finite reduction map. The intended
`K=Q(sqrt5)` identification and the Hilbert-90 transport are exact external C487 evidence rather
than an unstated interpretation of a hand-defined finite function.

## Public gate

The import gate is `RelativeConicArcs.Gates.ClebschTorsorRosetta`. It audits:

1. `RelativeConicArcs.ClebschTorsorRosetta.no_invariant_point`
2. `RelativeConicArcs.ClebschTorsorRosetta.point_or_swapped_point`
3. `RelativeConicArcs.ClebschTorsorRosetta.splitRoot_values`
4. `RelativeConicArcs.ClebschTorsorRosetta.pairedParentSwap_exchanges_sheets`
5. `RelativeConicArcs.ClebschTorsorRosetta.fixedChildQuotient_is_t11`
6. `RelativeConicArcs.ClebschTorsorRosetta.one_sign_character_three_readouts`
7. `RelativeConicArcs.ClebschTorsorRosetta.rankThree_split_inert_orientation`
8. `RelativeConicArcs.ClebschTorsorRosetta.q11_outer_readouts_agree`
9. `RelativeConicArcs.ClebschTorsorRosetta.q11_hadamard_hinge_is_forced_outer`
10. `RelativeConicArcs.ClebschTorsorRosetta.golden_characteristic_zero_reduction_dictionary`
11. `RelativeConicArcs.ClebschTorsorRosetta.torsor_rosetta_closing_theorem`

The aggregate theorem takes all four semantic certificates explicitly and includes every one of
the five required rows: fixed-child quotient, three-character equality/kernel, rank-three
split/inert models, q=11 outer readouts plus finite no-inner boundary, and characteristic-zero
golden reduction.

## External evidence, hashes, and replay

The semantic certificate fields are supplied by the following exact bundles. Hashes below are the
current SHA-256 values of their canonical JSON files.

| semantic input | canonical certificate and SHA-256 | replay command |
|---|---|---|
| affine/Čech obstruction | `notes/2026-07-23-c417-affine-cocycle-line-bundle.json`, `524ef0b1d8c0ba773ac8bdc3ed2763999be703d1272adf5365746997201b9786` | `python3 notes/2026-07-23-c417-affine-cocycle-line-bundle-replay.py` |
| selector obstruction | `notes/2026-07-21-c448-orbit-valued-selector.json`, `02f8d75f4972732126fe583510cc6ef99e090cf4c1f1133a97e3d89de2ee1233` | `python3 notes/2026-07-21-c448-orbit-valued-selector.py --check` |
| arithmetic orientation | `notes/2026-07-22-c473-arithmetic-orientation.json`, `0f7c8e94d68640d85e8a91c1b973b5e12e728a568742fa4334a20af7b8834765` | `python3 notes/2026-07-22-c473-arithmetic-orientation-replay.py` |
| fixed-child fibre | `notes/2026-07-22-c474-reed-solomon-decorated-deep-holes.json`, `02cb69e2d26deb9f9ab8c2953de4fa244f45d1f190336ac075f3a5c6fdffd8b1` | `python3 notes/2026-07-22-c474-reed-solomon-decorated-deep-holes-replay.py` |
| design/Fourier/outer hinge | `notes/2026-07-22-c480-close-gap-certificates.json`, `08a89e884b1b1a6bdc0ebd6ddf64375bd6d75feb5ab4324d40228d3e50bce942` | `python3 notes/2026-07-22-c480-close-gap-certificates-replay.py` |
| torsor bridge and trichotomy | `notes/2026-07-22-c486-close-upgrade-battery.json`, `3e009659a78b9a282357f833dc1b9af98a557d9034a76f7d0e9116fdf4eb480f` | `python3 notes/2026-07-22-c486-close-upgrade-battery-replay.py` |
| characteristic-zero row | `notes/2026-07-22-c487-char-zero-realization-row.json`, `65e8067ba69a993a1d54044de4f76719192f7ad10ae154331cb6267d3049fee3` | `python3 notes/2026-07-22-c487-char-zero-realization-row-replay.py` |

Each adjacent `.sha256` manifest checks its complete primary/replay/report bundle. These dated
paths are current project evidence, not referee-facing Lean artifacts. C320 must either pin them
as exact external evidence or migrate adopted semantic data into stable workflow-free verification
paths before the paper artifact is cut.

The imported C503 stable finite source is under
`lean/verification/clebsch_arithmetic_gluing/`, with generator `generate.py`, canonical
`source.json`, normalized `certificate.json`, and `manifest.sha256`. Its checker command is:

```text
python3 lean/verification/clebsch_arithmetic_gluing/generate.py --check
(cd lean/verification/clebsch_arithmetic_gluing && sha256sum -c manifest.sha256)
```

## Trust and exclusion ledger

| claim | route |
|---|---|
| free-`C2` API, zero-bit obstruction, one-bit sufficiency | full-trust Lean |
| B3/H3 root carriers and swaps | full-trust Lean over explicit subtypes |
| A3 no root and one geometric Frobenius orbit | imported/full-trust finite Lean; quadratic-algebra interpretation cited |
| fixed-child quotient is the sign torsor | full-trust consequence of `FixedChildCertificate`; certificate populated by C474/C486 replay |
| one sign character and common kernel | full-trust consequence of `SignCharacterCertificate`; concrete actions/kernel populated by C417/C448/C473/C486 |
| design/Fourier/Hadamard swaps | full-trust consequence of `Q11OuterReadoutCertificate`; concrete maps populated by C480 |
| finite row/column assignment and no inner witness | imported native Lean terminals |
| `M11/M12/PGL_2/PSL_2` classical names | cited-input boundary |
| characteristic-zero degree-two golden field and reduction | full-trust consequence of `GoldenCharacteristicZeroCertificate`; concrete field/descent data populated by C487 |
| absolute `H^1`, universal all-prime theorem, integral cubic, uniform period-to-cubic rule, genuine-Weil restriction, `PGL_2(11)<M12` | excluded |

## Initial independent review and repairs

The user-launched independent reviewer returned `NO-GO` with one critical, six major, and one
minor finding.

1. **Current build failure:** replaced the removed upstream assignment theorem with
   `row_column_assignment_finite_graph_certificate`; current direct elaboration is green.
2. **Tautological fixed-child/readout tags:** removed all phantom tags and retagging maps.
   Fixed-child and q=11 readouts now require actual carriers and explicit semantic certificates.
3. **Character row absent from the close:** introduced `SignCharacterCertificate` and made its
   equality/kernel conclusion a conjunct of the aggregate theorem.
4. **Disconnected rank-three facts:** B3/H3 carriers are now the actual polynomial-root subtypes,
   with explicit equivariant torsor equivalences; A3 records no rational root and one geometric
   Frobenius orbit.
5. **Hadamard swap disconnected from forced outer:** the q=11 certificate now designates its
   `hadamardSwap` as the externally certified row/column readout; the aggregate consumes that
   certificate alongside the exact finite no-inner terminal.
6. **No characteristic-zero object:** added the degree-two generated field, conjugation, and
   reduction equivalence to the formal certificate and theorem type.
7. **Imprecise trust/C320 route:** added exact artifacts, current hashes, replay commands, imported
   theorem names, and the stable C503 verification path.
8. **Undocumented public tags:** all ten tags were deleted; every remaining public declaration has
   an individual docstring.

A user-launched post-fix review is required after final validation and commit.

## Judgment calls

1. **Certificate structures instead of axioms or duplicated tables.** External semantic maps are
   explicit theorem parameters. This prevents Lean from claiming it reconstructed upstream
   geometry while allowing it to check every downstream implication. Duplicating the 22-parent,
   rank-16, or 95,040-element tables would violate upstream ownership.
2. **Actual roots for the split rows.** Root subtypes connect splitting to the torsor carrier
   definitionally and eliminate the earlier unrelated-cardinality defect.
3. **Characteristic-zero field, finite reduction as evidence.** There is no ring homomorphism
   `Q(sqrt5) -> F_11`; reduction passes through an integral model at a prime. The certificate
   therefore records the characteristic-zero generated field and an equivariant labelling of its
   two prime reductions by `GoldenRoot`, leaving Hilbert-90/integral transport to C487.
4. **Classical group names remain external.** The formal kernel is a supplied subgroup and the
   finite row/column result is stated on its literal closure. No abstract group name is inferred
   from order.

## Mystery ledger / post-gate `ej`+`tt`

- **Settled by the post-gate pass — are the split carriers only abstractly two-element?** No.
  `splitRoot_values` now exposes the literal field elements `{3,4}` and `{8,4}` in addition to
  the torsor equivalences.
- **Settled by the post-gate pass — does the fixed-child quotient prove the exact `11+11`
  profile?** Yes. `fixedChildFiberEquiv` transports every actual fibre to the finite indexed
  fibre, and `fixedChildQuotient_is_t11` proves both have cardinality eleven.
- **Settled — what remains external?** The four certificate structures must still be populated
  from the pinned semantic bundles. This is an explicit mixed-verification boundary, not an
  unexplained theorem gap.
- **No genuine bounded formal mystery remains.** Absolute cohomology, classical group naming,
  Hilbert-90 transport, and integral reduction semantics are assigned external or excluded routes.

## Validation and axiom evidence

Exact repaired current-source validation:

- `RelativeConicArcs.ClebschTorsorRosettaData`: green (`0:04.39`, peak
  1,751,616 kB);
- guarded direct elaboration of `RelativeConicArcs/ClebschTorsorRosetta.lean`: green;
- `RelativeConicArcs.ClebschTorsorRosetta`: green (`0:14.06`, peak
  3,425,472 kB);
- `RelativeConicArcs.Gates.ClebschTorsorRosetta`: green (`0:13.32`, peak
  3,343,536 kB);
- exact-target trace probes and the trace-only aggregate gate: passed; and
- `git diff --check` plus the owned-module workflow/prose scan: clean.

The repaired gate audits eleven terminals:

- `no_invariant_point` and `point_or_swapped_point` use exactly
  `[propext, Quot.sound]`;
- seven terminals use exactly `[propext, Classical.choice, Quot.sound]`; and
- `q11_hadamard_hinge_is_forced_outer` and `torsor_rosetta_closing_theorem`
  additionally expose exactly:

```text
row_column_assignment_finite_graph_certificate._native.native_decide.ax_1_1
row_column_hinge_has_no_inner_witness._native.native_decide.ax_1_1.
```

No terminal uses `sorryAx`, a project-local axiom, or an undisclosed opaque oracle.

## Referee-facing checklist

- [x] Every owned public declaration has a self-contained mathematical docstring.
- [x] No owned Lean source mentions an internal task, lane, report, agent, session, or private path.
- [x] Semantic bridges are explicit certificate inputs, not fresh tagged carriers.
- [x] Split torsors use actual finite root subtypes.
- [x] The character equality/kernel row occurs in the aggregate theorem.
- [x] The characteristic-zero object and reduction equivalence occur in the theorem type.
- [x] Exact external artifacts, hashes, replay commands, and imported theorem names are recorded.
- [x] Repaired exact-target gate and trace-only aggregate are green.
- [x] Repaired gate axiom output is recorded.
- [ ] User-launched post-fix review returns final `GO`.

## Proposed C320 ledger delta

At the repaired commit, add one claim-level block for
`RelativeConicArcs.Gates.ClebschTorsorRosetta`:

- exact repaired commit: `4c01ea83`;
- exact terminal list: the ten fully qualified declarations under **Public gate** above;
- imported finite terminals:
  `RelativeConicArcs.ClebschArithmeticGluing.a3_two_has_no_root`,
  `RelativeConicArcs.ClebschArithmeticGluing.sheetCharacter_eq_of_kernel_eq`,
  `RelativeConicArcs.ClebschWittHadamard.row_column_assignment_finite_graph_certificate`, and
  `RelativeConicArcs.ClebschWittHadamard.row_column_hinge_has_no_inner_witness`;
- full-trust local route: generic torsor deductions, explicit root subtypes and swaps, finite
  22-parent quotient model, and consequences of the four certificate structures;
- external certificate route: the seven exact JSON/hash/replay rows under **External evidence**;
- stable finite source: `lean/verification/clebsch_arithmetic_gluing/`;
- cited inputs: classical group names, the quadratic-algebra interpretation of the inert geometric
  orbit, and the Hilbert-90/integral reduction semantics;
- exclusions: absolute cohomology, all-prime classification, integral cubic, genuine-Weil, and
  forbidden embedding claims; and
- exact commit, axiom output, and verify-all entry point to be inserted after repaired validation.
