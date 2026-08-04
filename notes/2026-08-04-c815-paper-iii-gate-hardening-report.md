# C815 work report: Paper III gate audits brought to the Paper I/II standard

**Lane:** `clebsch`
**Date:** 2026-08-04
**Task:** C815

Paper III is `papers/clebsch-passages/`, "Golden descent and operator
realizations of the Clebsch cubic". The instruction was to find and record the
exact gaps between its manuscript mathematics and its Lean formalization, close
them by strengthening rather than by narrowing any manuscript claim, prefer
human-readable structural proofs over certificates, and have every Lean and
paper-mathematics change refereed cold. No manuscript TeX was edited; the
disagreements that need a TeX edit are listed at the end for the owner.

## What the three gates now are

| gate | terminals | carrying a compiled-evaluation axiom |
|---|---|---|
| `RelativeConicArcs.Gates.ClebschPassages` | 50 | 9 |
| `RelativeConicArcs.Gates.ClebschGoldenReturn` | 28 | 8 |
| `RelativeConicArcs.Gates.FourShadowRecognition` | 19 | 0 |

At the start of the task the same three gates had 43, 28 and 16 terminals,
with 10, 13 and 4 compiled-evaluation carriers. Ten of the twenty-seven
carriers are cleared and no new one was introduced.

## The mathematics that changed

**The four-shadow recognition packet lost compiled evaluation entirely.** The
twelve labelled pentagons had been obtained by running a compiled classifier
over the sign patterns. They are now a kernel proof: the four edges at the
first non-root vertex split into the six patterns with two positive edges, and
in each branch the remaining four vertex balances determine the six remaining
edge parameters over their sixty-four assignments. Both directions are public
and audited — `pentagon_bit_classification` derives the twelve patterns from
the five balances, `pentagon_bits_balanced` derives the five balances from each
pattern — so the solution set is pinned down from both sides in the artifact,
not only in the source. That the patterns number twelve and are pairwise
distinct is read off the displayed list; no Lean statement asserts either, and
the trust boundary says so.

**The order-six conference matrix became kernel-checked.** Its symmetry and its
square are `Matrix.ext` followed by `decide` on each of the thirty-six index
pairs; its twenty oriented triangle signs are one decision over the increasing
triples; its translation invariance is not finite at all, holding for an
arbitrary commutative ring, argument and shift. This module is shared with
Paper I's rigidity gate and both golden-operator gates, so the change was made
with explicit permission and validated against all six dependent gates, which
passed.

**The classical Ramsey input stopped being a human step.** `R(3,3) ≤ 6` is
proved for an arbitrary Boolean colouring read on increasing pairs, by the
pigeonhole argument rather than by enumerating colourings; `R(3,3) > 5` is
proved by exhibiting the pentagon colouring. Together they give the equality,
and `exists_alignedAnchor` carries it to anchor existence over an arbitrary
type. What did **not** become formal is the anchor step's distinctness
obligation: nothing in Lean forces the six points to be distinct from each
other or from the root, so a degenerate family satisfies the hypothesis. The
trust manifest and the over-paper ledger both state this; an earlier revision
of the ledger claimed the anchor step had become fully formal, which was wrong.

Formalizing a classical theorem confers no priority, so
`literature-boundaries.md` is deliberately unchanged: the attribution stays
classical while the trust ledgers record the proof mode.

## How the artifacts are now produced and checked

The three `*_axioms.txt` reports and three `*_source_closure.json` inventories
were being maintained by hand. They are now generated:
`verification/extract_axiom_report.py` from a gate build's standard output, and
`verification/extract_source_closure.py` from the Lean tree. Both generators
were validated by confirming they reproduce the committed files byte for byte
except where a change was intended. The reports are normalized to one
declaration per line, because Lean's pretty-printer wraps at a width that
depends on the invoking environment — an unnormalized report could differ
between two builds of identical sources and defeat the comparison the verifiers
exist to make.

The standard output of the gate build the reports came from is tracked at
`verification/evidence/gate_stdout/*.stdout.txt`, its bytes are pinned under
`axiom_report_provenance` in each manifest, and the verifiers check that pin.
Before this, the only provenance was a build identifier in a note, which the
repository's own reproducibility convention does not accept as evidence.

Replay, from the paper directory:

```text
python3 verification/verify_<gate>_lean.py --lean-root <lean tree> --source-only
python3 verification/verify_<gate>_lean.py --lean-root <lean tree> \
  --axiom-log verification/evidence/gate_stdout/<gate>.stdout.txt
python3 verification/verify_release.py --lean-root <lean tree>
```

for `<gate>` in `passages`, `golden_return`, `four_shadow`. The release
verifier previously ran no Lean gate at all; it now replays all three, and
without a Lean tree it names them as unchecked and qualifies its verdict rather
than printing an unconditional pass.

## The verifier can fail, and now fails on the right things

A cold referee showed that the four-shadow gate's headline claim — no compiled
evaluation anywhere — survived a direct violation: injecting a `native_decide`
theorem into a pinned source and re-pinning every hash passed both modes,
because the source policy never looked for it. The claim was metadata with no
mechanism behind it.

A second referee then defeated the first fix five different ways. The policy
now allows attributes and modifiers before a declaration keyword, accepts the
standalone `attribute [...]` form as well as `@[...]`, covers every unsafe
declaration form, and refuses `set_option debug.skipKernelTC` and
`allowUnsafeReducibility`. The battery, run against a scratch copy with a full
coordinated re-pin, is caught in all ten variants:

`native_decide`; a multi-line `@[implemented_by]`; `Lean.ofReduceBool`; a
standalone `attribute [implemented_by f] g`; `private opaque`; `private axiom`;
`set_option debug.skipKernelTC true in`; `unsafe abbrev`;
`noncomputable unsafe def`; and `@[simp] private axiom`.

`private axiom` had been defeating the oldest check in these verifiers since it
was written — that hole predates this task. Altering a tracked build log by one
byte is also caught, as is a coordinated source edit.

The passages and golden-return verifiers deliberately do **not** refuse
`native_decide`: their closures legitimately contain it and their trust
boundaries declare it. Refusing it there would be a false claim.

## What remains

**Seventeen compiled-evaluation carriers**, depending on thirty-six distinct
native axiom constants — nine reached by the passages gate, twenty-seven by the
golden-return gate, none shared. Twenty of the golden-return constants are the
`middleExterior_sq_row_*` lemmas behind one square identity; collapsing that
family gives seventeen independent sources, emitted by five modules:
`GoldenQuadraticCharacters`, `ClebschInvariantCubic`, `AlignedTwoGraph`,
`ClebschMiddleExterior` and `ClebschGoldenDescent`. The per-carrier map is in
2026-08-03-c815-paper-iii-formalization-gap-inventory.md.

**Gap classes B and C are untouched by this round**: nine manuscript clauses
with no formal counterpart, and the claims recorded as strengths without
matching statements — the explicit query family with its distinctness and
cardinality, the finite-set extension to a common seven-set, the
arbitrary-label to normalized-cut transport, four-shadow root normalization and
uniqueness of the conference switching class, and the rank-14 Jacobian.

**Paper III's gates are not extraction units of the repository trust spine**,
unlike Paper I's, so the paper-local verifiers are their only audit. That is a
build-system lane decision, not this task's.

## Work for the manuscript owner

Not edited here. `papers/clebsch-passages/sections/08-verification.tex`:

1. Lines 41–44 call the classical Ramsey input `R(3,3)=6` a human combinatorial
   step. Both bounds are now kernel-checked and the trust manifest says so, so
   the manuscript and its own metadata contradict each other. The correction
   must not over-swing: the finite-set extension to seven vertices, the
   normalization from arbitrary labels, and the distinctness of the six anchor
   points from each other and from the root are all still human inputs, and the
   sentence should gain the distinctness obligation as it loses the Ramsey
   clause. Line 35, about the higher-order inclusion-rank and Ramsey exclusion,
   is a different claim and remains correct — do not touch it.
2. The section never mentions compiled evaluation. Seventeen terminals across
   two gates rest on a compiled-evaluation axiom outside the kernel, including
   the middle-exterior square and the degree-ten descent comparison that the
   section names as checked by the pinned golden-return gate. Papers I and II
   disclose this; Paper III does not. This is the sentence a referee will
   circle.
3. Line 52 says "a paper-specific Lean gate now proves", singular. There are
   three.

## Mystery ledger

- **Native evaluation was used where the kernel was already cheap.**
  `two_not_square_zmod11` is a decision over eleven residues; the conference
  table is thirty-six entries; the four-shadow classifier had a structural proof
  available in the frozen human argument. None of these needed a compiled
  evaluator. Settled by the `ej`/`tt` pass to this extent: the uses appear
  habitual rather than forced, which predicts the remaining seventeen carriers
  are cheaper to clear than their count suggests. The prediction is untested —
  the middle-exterior square with its twenty row lemmas is the one that could
  refute it, and a structural Hodge-complementation proof is the route that
  would collapse the family to one argument.
- **The Lean is narrower than the paper exactly where the paper is general.**
  Every conference statement fixes the index type to six labels, while the
  manuscript states the four-point identity, switching invariance and pair
  balance for a symmetric conference matrix of arbitrary even order. The Lean is
  simultaneously stronger in ring generality and weaker in index generality.
  Open: generalizing the index type is a genuine strengthening nobody has
  attempted, and it is the one place where the formalization could overtake the
  manuscript on the manuscript's own axis.
- **The pair signature classifier decides 16,384 cases; the anchor signature
  decides eight.** The manuscript's anchor step is costed at twenty tests. Why
  the formal decomposition splits so unevenly against the human one is not
  explained anywhere. Open, owned by whichever task next touches
  `AlignedTwoGraph`; the evidence gap is that no note states what the twenty
  human tests correspond to formally.
- **The conference results hold in characteristics 2 and 5, where they
  degenerate.** In characteristic 5 the square is zero, in characteristic 2 the
  identity. The statements are true and the generality is real, but it carries
  no geometric content for the paper. Settled: recorded in the over-paper ledger
  as reusable interface, not as a harvestable strengthening.
- No mystery remains about the trust surface itself: every terminal, every
  native constant, and every unmapped claim row is now measured and named.

Companion records: the gap inventory named above,
2026-08-03-paper-iii-lean-over-paper-ledger.md for results stronger than the
manuscript and the counterweights where Lean is narrower, and the three cold
referee reports 2026-08-03-c815-ramsey-anchor-referee.md,
2026-08-03-c815-four-shadow-structural-referee.md,
2026-08-03-c815-conference-module-referee.md,
2026-08-04-c815-repin-and-repair-referee.md and
2026-08-04-c815-repair-closure-referee.md.
