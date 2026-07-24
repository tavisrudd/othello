# C505 / F12 — Lean torsor-Rosetta closing theorem

**Lane:** `clebsch`

**Status:** implementation and local review complete; user-launched independent review pending

## Required outcome and trust route

Define a reusable free-`C2` torsor interface and formalize the adopted closing theorem assembled
from C417, C448, C473, C474, C480, C486, and C487:

- C474's q=11 fixed-child quotient is torsor-isomorphic to `T_11`;
- the Čech/base-point obstruction, one-bit selector, and free torsor are three readouts of the
  determinant-square sign character with kernel `PSL_2(q)`;
- split working primes give a free two-point torsor at B3/H3, while the A3 prime is an inert,
  connected quadratic point with no bit;
- the q=11 swap agrees with the design polarity, signed Fourier-sector swap, and the forced-outer
  Hadamard/Mathieu hinge at the exact boundary delivered by C504;
- `Spec Q(sqrt5)` supplies the characteristic-zero row, whose two reductions at 11 map to the two
  finite sheets.

The theorem is an assembly of certified dictionaries, not a claim that all carriers are naturally
identical before the named maps are supplied.

## Owned surface and dependencies

- `lean/RelativeConicArcs/ClebschTorsorRosettaData.lean`
- `lean/RelativeConicArcs/ClebschTorsorRosetta.lean`
- `lean/RelativeConicArcs/Gates/ClebschTorsorRosetta.lean`
- this report

The theorem module imports the committed F8 replacement-spine gate, C503/F10 arithmetic-gluing
gate, and C504/F11 Witt--Hadamard gate. It consumes the C417/C448/C473/C474/C480/C486/C487
evidence bundles read-only. No upstream Lean source, generator, certificate, or manifest is
modified.

## Required theorem and exclusion boundary

The owned gate proves the explicit two-point actions, maps, equivariance squares, equal-kernel
sign-character theorem, bounded splitting checks, and reduction dictionary. The characteristic-zero
row separates what Lean checks after reduction at 11 from the external identification with
`Spec Q(sqrt5)`.

Excluded are an absolute-`H^1` classification, universal all-prime trichotomy, integral cubic
carrier, uniform period-to-cubic rule, signed genuine-Weil restriction, and any claim that
`PGL_2(11)` embeds in `M12`.

## Result

The implementation lands the requested three-module gate with no generated finite table.
`ClebschTorsorRosettaData` defines one phantom-tagged two-element carrier for each readout:

```text
fixed-child quotient
determinant sign
Čech obstruction
selector bit
design polarity
signed Fourier sector
Hadamard parent
golden reduction
B3 sheet
H3 sheet.
```

The phantom tags are load-bearing. They prevent the theorem from proving agreement by definitional
equality. Every comparison uses a displayed equivalence, and every equivalence is proved to commute
with the nontrivial involution.

`ClebschTorsorRosetta` defines:

- `FreeC2Torsor`, a two-element carrier with an involutive fixed-point-free permutation;
- `TorsorEquiv`, an explicit equivariant equivalence between two such carriers;
- the canonical tagged torsor and a general retagging equivalence;
- the no-invariant-point theorem and the exact “chosen point or swapped partner” sufficiency
  theorem;
- the fixed-child/sign torsor bridge;
- the Čech/selector/sign three-readout dictionary;
- the abstract equal-kernel theorem proving that three `G -> Perm(Fin 2)` actions are one
  character, with a variant that names the common subgroup;
- the exact finite rank-three row at `5`, `7`, and `11`;
- the two-root golden reduction and its `r -> 1-r` swap;
- the design/Fourier/Hadamard outer-readout dictionary;
- the exact C504 forced-outer boundary; and
- one paper-facing conjunction assembling all of these statements.

The result is deliberately mixed-verification. Lean proves the reusable torsor logic and the
complete displayed two-point dictionaries. The upstream finite-action gates prove the root rows
and the absence of an inner row/column witness. The semantic maps from the tagged carriers to the
fixed-child signatures, cocycle obstruction, selector cost, design polarity, Fourier sector, and
golden descent object remain the exact replay/certificate boundary.

## Exact public surface

The import gate is `RelativeConicArcs.Gates.ClebschTorsorRosetta`. Its audited terminals are:

1. `RelativeConicArcs.ClebschTorsorRosetta.no_invariant_point`
2. `RelativeConicArcs.ClebschTorsorRosetta.point_or_swapped_point`
3. `RelativeConicArcs.ClebschTorsorRosetta.retag_intertwines_swap`
4. `RelativeConicArcs.ClebschTorsorRosetta.fixedChildQuotient_is_signTorsor`
5. `RelativeConicArcs.ClebschTorsorRosetta.three_readout_dictionaries`
6. `RelativeConicArcs.ClebschTorsorRosetta.one_sign_character_three_readouts`
7. `RelativeConicArcs.ClebschTorsorRosetta.one_sign_character_with_named_kernel`
8. `RelativeConicArcs.ClebschTorsorRosetta.rankThree_split_inert_orientation_row`
9. `RelativeConicArcs.ClebschTorsorRosetta.golden_characteristic_zero_reduction_dictionary`
10. `RelativeConicArcs.ClebschTorsorRosetta.q11_three_outer_readouts`
11. `RelativeConicArcs.ClebschTorsorRosetta.q11_hadamard_hinge_is_forced_outer`
12. `RelativeConicArcs.ClebschTorsorRosetta.torsor_rosetta_closing_theorem`

The aggregate theorem contains six blocks:

```text
fixed child ≃ determinant-sign torsor
three obstruction/readout dictionaries and no fixed point
rank-three split/inert finite reduction row
design/Fourier/Hadamard swap dictionaries
forced-outer row/column boundary
golden quadratic reduction dictionary.
```

The separate abstract character terminals are intentionally not hidden inside the finite
conjunction: a concrete classical `PGL/PSL` identification requires a named group action and
subgroup supplied by the cited input. Given that input, the theorem proves all three readout
homomorphisms equal and proves their common kernel is the supplied subgroup.

## Source evidence and exact certificate boundary

No new normalized certificate is required. The owned data module contains only ten tagged copies
of `Fin 2`, their swaps, explicit retagging equivalences, and the two literal roots in `ZMod 11`.
All of those data are transparent and checked by Lean.

The semantic sources are:

| source | consumed conclusion | route in this gate |
|---|---|---|
| C417 | base-point obstruction has a two-sheet sign shadow and no equivariant origin | external exact certificate; represented by the tagged Čech carrier and abstract no-fixed-point theorem |
| C448 | the selector obstruction costs one bit on a freely swapped two-fibre | deductive selector lemma plus external q=11 identification; represented by the tagged selector carrier |
| C473 | determinant-square sign, sheets, split primes, and lower constituents form one torsor | external exact certificate; abstract equal-kernel theorem checks the character comparison once the actions are supplied |
| C474/C486 L1 | q=11 fixed-child 22-parent fibre has a `11+11` quotient identified with the golden matching torsor | external exact conic/signature replay; Lean checks the resulting tagged torsor equivalence |
| C480 A1/A2 | design polarity and signed Fourier sector carry the same outer swap | external exact finite certificate; Lean checks both displayed two-point equivariance squares |
| C504/C480 F | row/column hinge has no inner realization | full imported Lean native terminal over the checked 95,040-element closure |
| C486 L3/C503 | inert row at 5 and split rows at 7 and 11 | exact imported Lean root/no-root terminals; Coxeter/spin interpretation remains cited input |
| C487 | the golden descent involution reduces to the two sheets at 11 | external exact descent certificate; Lean checks roots `8,4` and the complete `r -> 1-r` finite dictionary |

The C504 terminal proves a finite group-action boundary, not a Mathieu naming theorem. In
particular the gate says that the displayed row/column generator assignment is an automorphism
graph, has the checked inner square, and has no inner conjugating witness in the finite closure.
The classical `M12`, `M11`, and normalizer names remain cited inputs.

The characteristic-zero wording is similarly exact: Lean does not construct a number field or
absolute Galois torsor. It checks that the two finite golden roots are `8` and `4`, that the
involution exchanges them by `r -> 1-r`, and that the reduction carrier maps equivariantly to the
sign carrier. C487's exact rational descent and Hilbert-90 replay supplies the identification of
the source as `Spec Q(sqrt5)`.

## Trust and exclusion ledger

| claim | final route |
|---|---|
| reusable free two-point torsor and equivariant-map API | full-trust Lean |
| no invariant point on a free torsor | full-trust Lean |
| one bit suffices to select either a point or its swapped partner | full-trust Lean |
| every displayed retagging intertwines the swap | full-trust Lean |
| equal-kernel actions on `Fin 2` are one character | full-trust Lean, reusing the F8 theorem |
| common kernel equals a supplied named subgroup | full-trust conditional theorem; the concrete classical subgroup identification is cited input |
| A3 finite inert check at 5 | full-trust imported Lean |
| B3/H3 finite split checks at 7/11 | full-trust imported Lean |
| interpretation as connected spin marker/free Coxeter sheets | exact certificate plus cited number-field/spin input |
| fixed-child quotient is `T_11` | external exhaustive conic/signature certificate; Lean checks the resulting torsor dictionary |
| Čech, selector, and determinant sign are the same concrete class | external finite action maps plus full-trust equal-kernel theorem |
| design and signed Fourier swaps agree | external exact certificate; Lean checks the two-point dictionary |
| row/column hinge is forced outer in the checked degree-twelve closure | imported native Lean terminals |
| `M12/M11/PSL_2/PGL_2` names and self-normalizer interpretation | cited-input boundary |
| golden roots and finite reduction swap | full-trust Lean |
| source of the reduction is `Spec Q(sqrt5)` | external exact rational-descent certificate and standard number-field interpretation |
| absolute Galois classification, integral cubic, all-prime trichotomy, genuine-Weil restriction, `PGL_2(11) < M12` | excluded |

The owned modules contain no `sorry`, project-local axiom, opaque oracle, generated code, JSON
reader, or ad hoc native computation. The only native-decision dependencies arise through the
imported C504 closure terminals and remain visible in the gate axiom audit.

## Judgment calls

1. **Tagged rather than aliased carriers.** Using aliases of `Fin 2` would make every dictionary
   true by definitional equality and contradict the theorem's stated boundary. Phantom-tagged
   structures keep the carriers distinct while retaining a tiny transparent checker.
2. **No duplicate finite certificate.** Re-encoding the 22 fixed-child signatures, rank-16
   relations, or degree-twelve action would duplicate upstream owners and weaken provenance.
   C505 checks only the Rosetta maps; semantic completeness remains with the hash-pinned upstream
   bundles and the existing C503/C504 Lean gates.
3. **Character theorem kept abstract.** The exact square-determinant kernel comparison is expressed
   as a theorem parameterized by a group, three homomorphisms, and their common subgroup. This
   avoids inferring the classical `PSL_2(q)` name from a finite cardinality or silently trusting a
   generated action table.
4. **Characteristic-zero source remains external.** Building a new number-field/descent library
   would exceed the bounded finite task and would not internalize C459/C487's Hilbert-90 geometry.
   The gate therefore proves the full mod-11 reduction dictionary and states the `Spec Q(sqrt5)`
   source as an exact external row.
5. **Forced outer means the proved finite boundary.** The formal statement is absence of an inner
   conjugating witness for the checked row/column assignment. It does not promote the classical
   Mathieu labels or assert a nonexistent `PGL_2(11)` embedding.

## Mystery ledger / extra-juice and Tao closeout

- **Settled — how to prevent a tautological Rosetta theorem.** Distinct phantom-tagged carriers
  force every comparison through an explicit equivalence and equivariance square.
- **Settled by the post-gate `ej`+`tt` pass — exact one-bit sufficiency.** The reusable interface
  now proves that relative to any point every target is either that point or its swapped partner;
  together with the no-fixed-point theorem this captures the precise two-choice boundary instead
  of relying on the carrier cardinality in prose.
- **Settled — what “one class, three readouts” means formally.** On a two-sheet carrier, equality
  of kernels forces equality of the permutation characters. The named-kernel theorem records the
  exact common subgroup rather than merely comparing three booleans.
- **Settled — where the A3 row differs.** The exact finite statement is no root in `F_5` and one
  fused marker, versus two roots and a free two-point carrier at 7 and 11. The broader connected
  étale and spin-language interpretation remains outside Lean.
- **Settled — the strongest honest forced-outer statement.** C504 already proves the generator
  assignment and exhaustive no-inner-witness result. C505 reuses that terminal instead of
  rebuilding or overstating it as a classical group embedding theorem.
- **Settled — what survives from characteristic zero in Lean.** The complete two-root reduction,
  Galois-form involution `r -> 1-r`, and sheet dictionary are formal. The rational descent object
  itself remains the exact C487 certificate boundary.
- **No genuine bounded mathematical mystery remains.** The remaining gaps are deliberately named
  semantic identifications or excluded generalizations, each assigned to the external evidence
  row or C320 reconciliation rather than left unexplained.

## Validation and axiom evidence

Exact current-source validation:

- definitions-only data module: green (`0:03.52`, peak 1,028,648 kB);
- `RelativeConicArcs.ClebschTorsorRosetta`: green (`0:21.43`, peak 3,397,696 kB);
- `RelativeConicArcs.Gates.ClebschTorsorRosetta`: green (`0:09.10`, peak
  3,373,808 kB);
- trace-only aggregate gate: passed;
- the serialized runner's exact-target `--no-build` probes passed before each current build;
- source/prose audit over all three owned Lean modules found no internal task ID, workflow status,
  private path, agent/session reference, or unresolved status marker; and
- `git diff --check` is clean on the four owned paths.

The gate audits twelve terminals. Two (`no_invariant_point`,
`point_or_swapped_point`) use exactly `[propext, Quot.sound]`. Eight use exactly
`[propext, Classical.choice, Quot.sound]`. The forced-outer terminal and aggregate closing theorem
add exactly the two declaration-local native-decision axioms already exposed by C504:

```text
row_column_assignment_is_automorphism_graph._native.native_decide.ax_1_1
row_column_hinge_has_no_inner_witness._native.native_decide.ax_1_1
```

No terminal uses `sorryAx`, a project-local axiom, or an undisclosed opaque oracle.

## Referee-facing checklist

- [x] Every owned public definition and theorem has a self-contained mathematical docstring.
- [x] No Lean source mentions an internal task, lane, report, agent, session, private path, or
      workflow status.
- [x] No strength-bearing name claims more than its theorem type.
- [x] Separate tagged carriers prevent definitional identification of distinct objects.
- [x] Every computational statement names its finite domain and trust route.
- [x] Imported native-decision dependencies are disclosed.
- [x] Classical group and number-field semantic names remain explicit inputs.
- [x] Absolute cohomology, all-prime, integral-cubic, genuine-Weil, and embedding claims are
      excluded.
- [x] Exact-target gate build is green.
- [x] Gate terminal axiom output is recorded below.
- [ ] User-launched independent referee review has returned `GO`.

## Independent review

Pending. Per the campaign protocol, the implementer does not select, spawn, simulate, or stand in
for the reviewer. After the artifact, validation record, checklist, and proposed ledger delta are
complete, the user should launch an independent Codex review. Any finding will be repaired or the
claimed exit narrowed, followed by a user-launched post-fix review if the artifact changes.

## Proposed C320 ledger delta

Add one claim-level block for `RelativeConicArcs.Gates.ClebschTorsorRosetta`:

- **full-trust symbolic terminals:** free two-point torsor, no-fixed-point and exact one-bit
  sufficiency theorems, torsor equivalences, all explicit two-point equivariance squares, and
  equal-kernel character uniqueness;
- **full-trust finite terminals:** A3 no-root row, B3/H3 root rows, golden reduction roots and
  `r -> 1-r` swap;
- **imported mixed terminal:** C504 row/column assignment and exhaustive no-inner-witness closure
  check, retaining the gate's declaration-local native-decision axioms;
- **external exact certificate/replay:** fixed-child signature to golden-matching bridge,
  concrete Čech/selector/sign maps, design and Fourier identifications, and the rational
  `Spec Q(sqrt5)` descent source;
- **cited inputs:** classical `PSL_2/PGL_2/M11/M12` names, determinant-square kernel naming,
  number-field splitting language, and Coxeter/spin interpretation;
- **excluded:** absolute `H^1`, universal all-prime trichotomy, integral cubic carrier, uniform
  period-to-cubic rule, signed genuine-Weil restriction, and `PGL_2(11) < M12`.
