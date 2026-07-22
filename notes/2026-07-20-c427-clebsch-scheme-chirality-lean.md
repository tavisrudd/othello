# C427 / F8 — Lean intrinsic chirality and replacement-spine gate

**Lane:** `clebsch`

**Status:** complete by explicit user override after initial independent-review repairs

This file is both the cold-read task specification and the required durable result report. Complete
it in place; do not substitute a chat summary or a second transient document. The finished report
must contain the result, exact theorem types and owned artifacts, validation and axiom evidence,
trust/exclusion boundary, every judgment call, independent review and dispositions, and the C320
ledger delta.

## Required outcome and trust route

Formalize intrinsic recovery of the six scalar-line blocks, the two ten-element three-subset
orbits, and the unordered chirality torsor. The projective stabilizer uses the bounded frame
transport route. Full color-preserving automorphism and no-outer-lift claims are full-trust Lean
only if their sound completeness checker lands; otherwise their external boundary is explicit.
Rank-16 eigenmatrix and minimal coherent-refinement claims remain certificate-backed and outside the
replacement-spine Lean label unless separately formalized. The aggregate gate does not upgrade any
import's trust tier merely by importing it.

## Cold-read execution brief

- Own only `lean/RelativeConicArcs/ClebschSchemeChiralityData.lean`,
  `ClebschSchemeChirality.lean`, `lean/RelativeConicArcs/Gates/ClebschReplacementSpine.lean`, and
  the same-stem `.md/.py/.json/.sha256` evidence bundle.
- Import the committed C425/F6 and C426/F7 gates plus the existing
  `RelativeConicArcs.Gates.ClebschGateway`; do not modify stable C380 modules or regenerate their
  data.
- Prove intrinsic recovery of the six scalar-line blocks, their two ten-element three-subset
  orbits, and the unordered chirality torsor. Reuse the existing abstract two-sheet character
  theorem; do not import new outside-S5 research.
- For `Stab(hexagon)=A5`, use the frame-transport bound: enumerate at most the `6*5*4*3=360`
  projectivities determined by ordered four-point images. Never enumerate all of `PGL_3(11)`.
- Full color-preserving automorphism and no-outer-lift claims require either a compact affine proof
  or a completeness checker whose soundness and coverage Lean proves. Otherwise record them as
  external exact evidence; the equitable-refinement bound on the 1331-vertex graph is external by
  design.
- Record rank-16 clauses separately: the existing `M_odd^2=1331 I_4` and four exchanged pairs may
  be Lean-backed; `P_16^2=1331 I`, the full rank-16 eigenmatrix, and minimality of the common
  coherent refinement remain certificate-backed unless new checked leaves explicitly prove them.
- The replacement-spine aggregate imports every claimed F1--F8 terminal. Importing a mixed-trust
  module does not upgrade its external clauses. Run the exact gate confirmation and terminal axiom
  audit, then hand the complete claim-level delta to C320.

## Required judgment-call record

Before review, add a completed section here for every implementation or scope choice a later agent
could reasonably question. For each choice record: the question; admissible options; chosen option;
mathematical and measured evidence; effect on theorem statement, trust tier, imports, gate, and
paper claim; rejected alternatives; and the exact condition for reopening it. Include decisions to
omit an optional theorem, use or reject a certificate, weaken or generalize a statement, add a
hypothesis, choose a finite representation, stop after a measured failure, or classify a result as
external. “Obvious,” “standard,” “if feasible,” and an unrecorded absence of work are not
dispositions. If no judgment call occurred, state that explicitly and explain why execution was
fully forced by this brief.

## Implemented result

Pinned repaired artifact commit: `4a7845b8` (the original pinned artifact was
`8bdde98687366c58e1cbed0968036d55c2c4c048`; Lean sources landed in
`e5b2046c28bfb6da30adc896aba81427415a01be`; bounded frame replay landed in
`eedef80d9f4439ae4adb4b755ded86958e0730a1`; the pinned descendant adds the complete terminal
axiom audit and final hashes).

The formal endpoint models the sixty neighbors of the origin as `Fin 6 × Fin 10`: a displayed
projective direction and a nonzero scalar. Adjacency is computed from coordinatewise difference
modulo eleven. Lean checks that the six reflexive-adjacency neighborhoods obtained from one
representative per direction are exactly six scalar-line blocks of cardinality ten. It also checks
a complete repetition-free enumeration of all twenty three-subsets, the semantic action of two
degree-six generators, their two closed generated orbits of sizes `10+10`, and a displayed
order-four normalizer element that exchanges those sheets. The abstract two-sheet character
terminal directly reuses `ClebschGateway.twoSheetCharacter_eq_of_ker_eq`.

The frozen-to-geometric identification and the name `A5` for the displayed order-60 action are an
exact-replay boundary. Full color-preserving automorphism and no-outer-lift remain external because
no Lean sound completeness checker for the 1,331-vertex scheme landed. The gate does not upgrade
those claims or any imported mixed-trust claim.

## Exact public surface

Load-bearing definitions are `neighborVector`, `vectorSub`, `columnAdjacent`,
`sameIntrinsicComponent`, `intrinsicComponent`, `scalarLineBlock`, `intrinsicComponents`,
`orbitStep`, and `generatedOrbit` in namespace
`RelativeConicArcs.ClebschSchemeChirality`. Public terminal types are:

```lean
intrinsicComponents_eq_scalarLineBlocks :
  intrinsicComponents = Finset.univ.image scalarLineBlock
scalarLineBlock_card (i : Fin 6) : (scalarLineBlock i).card = 10
triple_card (t : Fin 20) : (triple t).card = 3
triple_range_complete :
  Finset.univ.image triple =
    (Finset.univ : Finset (Finset (Fin 6))).filter fun s => s.card = 3
triple_list_nodup : (List.ofFn triple).Nodup
generatorTripleAction_semantics (g : Fin 2) (t : Fin 20) :
  triple (generatorTripleAction g t) = (triple t).image (blockGenerator g)
positive_generatedOrbit : generatedOrbit 0 = Finset.univ.filter fun t : Fin 20 => t.val < 10
negative_generatedOrbit : generatedOrbit 10 = Finset.univ.filter fun t : Fin 20 => 10 ≤ t.val
generator_preserves_sheet (g : Fin 2) (t : Fin 20) :
  (generatorTripleAction g t).val < 10 ↔ t.val < 10
sheetExchangeTriple_semantics (t : Fin 20) :
  triple (sheetExchangeTriple t) = (triple t).image sheetExchangeBlock
sheetExchange_swaps_sheets (t : Fin 20) :
  (sheetExchangeTriple t).val < 10 ↔ ¬ t.val < 10
sheetExchange_fourth_power :
  (∀ i, sheetExchangeBlock (sheetExchangeBlock (sheetExchangeBlock
    (sheetExchangeBlock i))) = i) ∧
  ∀ t, sheetExchangeTriple (sheetExchangeTriple (sheetExchangeTriple
    (sheetExchangeTriple t))) = t
unorderedChiralityCharacter_unique {G : Type*} [Group G]
  (χ₁ χ₂ : G →* Equiv.Perm (Fin 2)) (κker : χ₁.ker = χ₂.ker) : χ₁ = χ₂
```

Thus the exact Lean claim is: the displayed coordinate neighbor graph has six ten-vertex blocks;
all twenty triples occur once; the displayed generators give two ten-element sheets and preserve
them; the displayed normalizer exchanges them; and two two-sheet characters with equal kernels
coincide.

## Trust and exclusion ledger

| Claim | Final route and boundary |
|---|---|
| six blocks | Lean coordinate check plus external identification with the unmarked scheme |
| complete `20=10+10` split | full-trust Lean on the frozen block action; `A5` identification external |
| displayed sheet exchange | full-trust Lean for its action; replay proves it normalizes and lies outside the order-60 action |
| projective stabilizer order `60` | exact replay of all `6*5*4*3=360` frame transports; not a Lean theorem |
| full affine automorphism/no outer lift | external C373 evidence only; no new Lean declaration |
| quotient-character uniqueness | full-trust abstract Lean; concrete kernel identification external |
| rank-16/minimal refinement | existing certificate boundary; explicitly excluded from the new terminal |

No `sorryAx`, `native_decide`, project axiom, opaque oracle, or non-kernel execution occurs in the
new Lean terminals. The finite proofs use kernel `decide`. Every axiom output is a subset of
`[propext, Classical.choice, Quot.sound]`; the sheet-preservation, sheet-swap, and fourth-power
terminals use only `[propext]`. Python replay is outside the Lean trust base.

## Artifacts and validation

| artifact | bytes | SHA-256 |
|---|---:|---|
| `ClebschSchemeChiralityData.lean` | 2,240 | `42092cd7c83598f300b1302ffd7be1b2a2b3fbb2b07458cab94aeaa493200a1b` |
| `ClebschSchemeChirality.lean` | 6,488 | `dd08e796feae5b06bf5666adeb59d3e100e262cff12c3e37fe9930ea66be5fc5` |
| `Gates/ClebschReplacementSpine.lean` | 1,959 | `17edb28f4b4c77929973eada93eacb92ea03bb17b8c2b7604fcfa567d0134e3a` |
| `ClebschSchemeChirality.py` | 6,964 | `dbfcdb66debce12b166b7b0c77c014c47053de302f84ff34941c4c786ab46d8e` |
| `ClebschSchemeChirality.json` | 732 | `f7f1bdf691ddf45ac036c4a37308e5dc19e8074f3d2d7caff58d9e9f778f5748` |
| `ClebschSchemeChirality.sha256` | 479 | manifest; not self-hashed |

All paths above are under `lean/RelativeConicArcs/`. Exact replay:

```bash
python3 lean/RelativeConicArcs/ClebschSchemeChirality.py --check
(cd lean/RelativeConicArcs && sha256sum -c ClebschSchemeChirality.sha256)
```

The standard-library replay exhausts all sixty neighbor vertices and their adjacency, obtains six
components of size ten, closes the generators to exactly sixty permutations, exhausts all twenty
triples and gets `10+10`, verifies the normalizing sheet exchange, and enumerates exactly 360
frame-determined projectivities, exactly sixty of which stabilize the six directions.

Lean validation command:

```bash
lean/scripts/lean-build-queue.py run RelativeConicArcs.Gates.ClebschReplacementSpine \
  --profile single --threads 1 --cores 20-23
```

Final run `run-20260722-164222-4760d31e` passed the target (`0:21.17`, peak RSS `3,216,616`
kB), all 8,693 targets, and the trace-only exact aggregate gate. Replay and manifest checks
returned `OK` after the final evidence edit.

Post-repair run `run-20260722-220023-7b07daf6` passed the exact replacement-spine target
(`2:00.48`, peak RSS `3,465,168` kB) and the trace-only aggregate gate.  Independent replay and
all five manifest checks returned `OK` against the repaired sources.

## Judgment calls

1. **Finite representation.** Options were the full 1,331-vertex scheme, a generated adjacency
   table, or computed direction/scalar coordinates. The coordinate model was chosen: it is the
   smallest mathematical domain for the six-block endpoint and avoids baking adjacency into a
   Boolean table. The main-module check peaked near 3.49 GB. Effect: block combinatorics is Lean;
   unmarked-scheme identification is external. Reopen only if a paper claim must begin from the
   abstract colored scheme.
2. **Arithmetic carrier.** `ZMod 11`, reducible `Fin 11`, and a Boolean table were admissible.
   `Fin 11` with explicit modular reduction was chosen after `ZMod` function equality blocked
   kernel reduction. It changes no domain or claim, avoids prohibited `native_decide`, and adds no
   axiom. Reopen when the pinned toolchain supplies an equally small reducible `ZMod` route.
3. **Automorphism strength.** A new sound completeness checker, a conditional theorem, or explicit
   external classification were possible. The last was chosen because no Lean coverage theorem
   for all graph automorphisms exists. The replay still performs only the permitted 360 frame
   transports. No full-aut or no-outer-lift Lean claim is made. Reopen when checker soundness and
   exhaustive coverage land.
4. **Rank 16 and gate scope.** New rank-16 leaves or explicit exclusion were possible. Exclusion
   was chosen because those certificate claims are unnecessary for chirality. The aggregate imports
   every F1--F8 terminal but preserves each trust tier. Reopen only if the manuscript promotes a
   rank-16 clause to a Lean-labeled headline claim.

## C320 ledger delta

| Claim | Declaration/evidence | C320 route |
|---|---|---|
| six intrinsic blocks | `intrinsicComponents_eq_scalarLineBlocks`, `scalarLineBlock_card` | Lean + external scheme identification |
| complete triples | `triple_card`, `triple_range_complete`, `triple_list_nodup` | full-trust Lean |
| two sheets | `generatorTripleAction_semantics`, both `generatedOrbit` terminals, `generator_preserves_sheet` | Lean + external `A5` identification |
| unordered exchange | three `sheetExchange` terminals | Lean for displayed action + exact normalizer replay |
| two-sheet uniqueness | `unorderedChiralityCharacter_unique` | abstract full-trust Lean |
| stabilizer `60` | Python/JSON/hash bundle | exhaustive 360-frame replay |
| full automorphism/no outer lift | no declaration | external only |
| rank 16/minimal refinement | no declaration | existing certificate boundary |

C320 must add `RelativeConicArcs.Gates.ClebschReplacementSpine` as the verify-all target plus both
replay commands above, without upgrading any imported claim's trust tier.

## Mystery ledger and extra-juice closeout

- **Settled:** the first concrete normalizer representative found by the bounded data has order
  four, not order two. Lean now states and checks fourth power one rather than calling it an
  involution; its odd action still exchanges the two sheets. No paper claim requires a chosen
  involutory lift.
- **Settled cheaply:** the same independent replay used for the block action now performs the full
  permitted 360-frame transport enumeration and obtains projective stabilizer order 60, so that
  number is no longer a bare copied certificate field.
- **Open trust gap, not a mathematical mystery:** whether every color-preserving automorphism of
  the full 1,331-vertex scheme is affine and whether no outer normalizer element lifts. The exact
  evidence gap is a Lean sound completeness theorem for the full automorphism search; C320 must
  retain the external classification until such a checker exists.
- **Open trust gap, separately owned:** rank-16 eigenmatrix and minimal coherent-refinement claims
  remain certificate-backed. They are not needed by this endpoint and remain with their existing
  verification owner.

No further genuine task-owned mystery remains after the bounded frame replay and order-four
correction.

## Independent review

**Initial reviewer:** Codex, explicitly launched by the user on 2026-07-22.

**Initial verdict:** `NO-GO`.

1. `ClebschSchemeChiralityData.lean` and `ClebschSchemeChirality.lean` called the displayed
   sheet-exchanging permutation an involution in three referee-facing comments, while the table and
   `sheetExchange_fourth_power` exhibit an order-four element.  **Disposition:** repaired all three
   comments to say “order-four normalizer”; no theorem or data changed.
2. The frozen-data module banner called `ClebschSchemeChirality.py` its tracked generator, but that
   script independently replays the finite claims and checks the JSON certificate; it does not emit
   the Lean source.  **Disposition:** narrowed the banner to “tracked independent replay and
   semantic certificate”; no generated-source claim remains.

The reviewer otherwise found the theorem types, finite domains, gate imports, and reported trust
boundaries consistent.  The repaired sources, manifest, replay, gate, and hashes were revalidated
and committed in `4a7845b8`.

**Final disposition:** on 2026-07-22 the user explicitly overrode the separate post-fix-review
requirement, accepted the recorded repairs, and directed that C427 be marked done and archived.
This is an owner override, not a second independent-review `GO`; the distinction is retained here.

## Required closing review process

**Reviewer-launch authority:** the implementing agent must not spawn, delegate to, select, simulate,
or substitute for the independent reviewer. After completing the artifact, durable report, checklist,
and proposed ledger delta, it must stop, keep the task live, and tell the user that the task is ready
for review. The user will launch Codex as the reviewer. After fixing review findings, the implementer
must stop again and ask the user to launch the post-fix review. Only a review explicitly launched by
the user counts toward the required final `GO`.


The implementer first completes the checklist and a claim-by-claim ledger delta. A separate
referee-style reviewer then reads the actual theorem types, module prose, proof/trust boundary, gate,
and evidence; issues a recorded `GO` or `NO-GO`; and lists every finding. The implementer resolves
each finding or narrows the claimed exit explicitly. The task cannot close until the final
disposition and ledger delta agree with the landed artifact.

**Archival gate:** keep the task row live. After implementation, explicitly request the independent
review; do not infer that review from a build, report, or agent self-check. Any finding or `NO-GO`
blocks completion and archival. Fix every issue, update the artifact/report/checklist/ledger delta,
and request post-fix review. Only a recorded final `GO` permits the task to be marked complete and
archived under the repository completion invariant.

- [x] State every claimed exit in ordinary mathematics, with exact domain, hypotheses, conclusion,
  and correspondence to the intended paper statement.
- [x] Assign each exit exactly one final route: full-trust Lean, exact replay/certificate,
  conceptual proof with named classical inputs, or an explicitly decomposed combination.
- [x] Read the definitions and theorem types themselves: rule out vacuous predicates, conclusions
  baked into definitions or frozen data, weakened quantifiers, hidden typeclass/characteristic or
  nondegeneracy assumptions, empty domains, and theorem names or prose stronger than the type.
- [x] Verify that every claimed terminal is actually imported by the named gate and that validation
  is trace-current for the final source; a green dependency, stale build, report verdict, or
  authoritative-sounding filename is not evidence for an omitted theorem.
- [x] Remove or separately classify every optional, conditional, failed, “standard,” “follows,” or
  “if feasible” clause; no such clause inherits the module or gate's strongest label.
- [x] Record exact owned files, fully qualified terminal names, import-only gate, pinned commit,
  validation command/result, and `#print axioms` output for every terminal.
- [x] Include the exact public theorem statements and load-bearing definitions, or a deterministic
  extraction committed with the report, for the paper's verbatim statement-adequacy appendix.
- [x] Confirm no `sorryAx`, `native_decide`, undisclosed project axiom, opaque oracle, or unreported
  non-kernel execution occurs in the claimed dependency closure.
- [x] For every finite/computational claim, record the checker and soundness theorem, finite domain,
  generator/schema/data/hash, independent replay, exhaustive-versus-search status, and residual
  trusted boundary; write “not applicable” only with a reason.
- [x] Recompute byte counts and hashes only after the final source/evidence edit and compare them to
  the committed files; hashes establish identity, not mathematical correctness or regeneration.
- [x] List every cited or axiomatized input and what remains unconditional without it.
- [x] Review the entire touched module, names, filenames, comments, docstrings, banners, diagnostics,
  and changed verification artifacts for mathematical accuracy and referee-facing self-containment.
- [x] Confirm internal records point to exact Lean declarations while Lean and verification
  artifacts contain no reverse references, task IDs, workflow language, or unsupported novelty or
  strength claims.
- [x] State exclusions and negative boundaries explicitly, including what the task and gate do not
  prove.
- [x] Complete the judgment-call record with evidence, trust impact, rejected alternatives, and
  reopening conditions; ensure the verification map and ledger use the chosen final route.
- [x] Record the independent reviewer's identity, date, `GO`/`NO-GO`, findings, and dispositions.
- [x] Supply C320 with one ledger row per claim and the exact verify-all entry-point delta.
