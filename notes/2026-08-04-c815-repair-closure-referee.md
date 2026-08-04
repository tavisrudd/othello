# Referee report: closure of the Paper III gate-audit repairs (commit 092b94c5)

**Lane:** `clebsch`
**Date:** 2026-08-04
**Task:** C815

Cold adversarial re-review. The specification is the previous referee report,
`notes/2026-08-04-c815-repin-and-repair-referee.md`, whose ten numbered repairs commit
092b94c5 claims to close. The commit message was treated as an unverified assertion
throughout; every count, hash and sentence below was recomputed from the files on disk or
reproduced by an independent script. Read-only: no repository file other than this report
was created or modified, nothing was staged or committed, and no Lean build was run. Tamper
experiments ran on a copy in a scratch directory outside the repository.

---

## Baseline measurements (recomputed, not read)

Parsing the three committed axiom reports with an independent parser, treating
`propext`, `Classical.choice` and `Quot.sound` as the standard base:

| gate | audited terminals | carriers of a non-standard axiom | distinct non-standard constants |
|---|---|---|---|
| `Gates.ClebschPassages`        | 50 | 9 | 9  |
| `Gates.ClebschGoldenReturn`    | 28 | 8 | 27 |
| `Gates.FourShadowRecognition`  | 18 | 0 | 0  |

The declaration counts agree with `grep -c '#print axioms'` on each gate module
(50 / 28 / 18). Every non-standard constant is a `..._native.native_decide.ax_1_1`. The
two constant sets are disjoint, so the union is 36. Twenty of the golden-return constants
are `ClebschMiddleExterior.middleExterior_sq_row_*`; collapsing that family to one gives 17.
By emitting module there are five: `GoldenQuadraticCharacters`, `ClebschInvariantCubic`,
`AlignedTwoGraph`, `ClebschMiddleExterior`, `ClebschGoldenDescent`.

All pins re-verified independently: for each of the three gates, `axiom_report_sha256`,
`source_closure_sha256` and `verifier_sha256` match the files; `source_sha256` is exactly the
`{path: sha256}` projection of the closure inventory's `sources`; every hash and every
`bytes` field matches the file on disk under `lean/`; and `audited_declarations` equals the
report's declaration set (50 / 28 / 18). One presentational difference, not a defect: the
four-shadow manifest lists `audited_declarations` in sorted order while the other two use
gate source order. The verifiers compare as sets, so this passes, but it means the
four-shadow manifest cannot be diffed against its report line by line.

---

## Repair 1 — the gap inventory's native-source count: **CLOSED**

`notes/2026-08-03-c815-paper-iii-formalization-gap-inventory.md` now reads: "The seventeen
remaining carriers depend on thirty-six distinct native axiom constants — nine reached by the
passages gate, twenty-seven by the golden-return gate, with no constant shared between them.
Twenty of the golden-return constants are the `middleExterior_sq_row_*` lemmas behind a
single square identity; collapsing that family to one gives seventeen independent native
sources." Every figure in that sentence is what I measure, including the disjointness. The
counting convention is stated in the same sentence, both conventions are given, and the
module-level count of five is also stated and correct. The note additionally records the old
figure as wrong and names the exact slip. That is more than the repair required.

The two smaller inaccuracies were fixed substantively, not reworded:

- The conference claim is now "`ClebschGoldenConference.lean` — which is in all three
  closures — contains no `native_decide` at all, which is stronger than the axiom reports
  alone show." I confirmed both halves: the file is in all three closure inventories, and
  `native_decide` occurs zero times in it. This is the stronger statement the previous
  referee asked for, not a paraphrase of the weaker one.
- The unreconstructible intermediate "forty-six" is gone; the sentence now reads "went from
  forty-three audited terminals to fifty," which is the transition actually visible in git.

**New defect introduced here.** The per-gate table two paragraphs above still reads
`FourShadowRecognition | 16 | 0 | 4`. Repair 6 raised that gate to eighteen printed
terminals in the same commit, so the note's own table is now stale against the artifact the
same commit shipped. The carrier column (0) is still right; only the terminal count is
wrong, and it is wrong by exactly the two declarations repair 6 added. Minor, but it is the
same class of error — a count in a committed note that no longer matches the measurement —
that repair 1 existed to fix.

---

## Repair 2 — the two stale gate module headers: **PARTIALLY CLOSED**

Both headers were rewritten and both are now far closer to the measurement than the prose
they replaced. The direct self-contradiction the previous referee found — pinned Lean prose
calling the conference matrix compiled-evaluated while the pinned JSON beside it called it
kernel-checked — is gone. The three affected hashes are re-pinned correctly: each gate module
is its own closure root, appears in its `source_sha256` map, and every recorded hash and byte
count matches the file on disk. All three verifiers pass in `--source-only` against the live
Lean tree.

**Counts: correct.** `Gates/ClebschPassages.lean` says "Nine of the fifty terminals printed
below inherit such an axiom" — measured 9 of 50. `Gates/ClebschGoldenReturn.lean` says
"Eight of the twenty-eight terminals printed below inherit such an axiom" — measured 8 of 28.
The golden-return enumeration of what native decision still evaluates ("its Hodge square, the
twenty row identities behind its own square, its diagonal, its parity criterion, and its two
common-neighbour counts — and the two displayed descent matrices") is exactly the eight
carriers I measure, family by family, with the row count of twenty confirmed.

**Three clauses are still not right.**

1. *Method misdescribed, golden-return.* The header says the conference matrix's "symmetry,
   its square, its twenty triangle signs, and its translation invariance are discharged by
   `decide` over the thirty-six index pairs." Only the first two are.
   `conferenceMatrix_transpose` and `conferenceMatrix_sq` are `ext i j; fin_cases i <;>
   fin_cases j <;> decide`, which is the thirty-six index pairs.
   `conference_triangleSigns` is a bare `decide` on a conjunction of twenty ordered triples —
   not an index-pair sweep. `conference_triangleCubic_translate` is not finite at all: it is
   universally quantified over an arbitrary `CommRing R`, an arbitrary `x : Fin 6 → R` and an
   arbitrary `u : R`, and is proved symbolically by transporting the twenty integral signs
   through `cast_conference_triangleSign` and rewriting. Describing a genuinely symbolic,
   ring-generic theorem as a finite `decide` understates it and misstates the mechanism. The
   previous referee's standard — the header must state the actual method — is not met for two
   of the four named facts. `Gates/ClebschPassages.lean` repeats the same conflation for the
   two facts it names.

2. *One native source is not named, passages.* The header says native decision is confined to
   "the displayed finite reflection matrices, one finite-field nonsquare check, the values of
   explicitly displayed finite vectors together with their third elementary symmetric
   function, and the 16,384 cases in the normalized two-cut signature classifier." The nine
   measured constants are five in `GoldenQuadraticCharacters` (reflection matrices), one
   `two_not_square_zmod11` (the nonsquare check), two in `ClebschInvariantCubic`
   (`markedFixedVector_sum`, `sigmaThree_markedFixedVector`), and *two* in `AlignedTwoGraph`:
   `pairSignature_classification` and `anchorSignature_eq_false_iff_balanced`. Only the first
   is the 16,384-case classifier — `pairSignature_classification` quantifies over
   `p s p' s' : Fin 8` and `e e' : Bool`, giving 8⁴·2² = 16,384.
   `anchorSignature_eq_false_iff_balanced` quantifies over a single `NormalizedCut := Fin 8`,
   so it is an eight-case decision and a distinct native source. The header names one
   classifier where there are two. `passages_formal.json`'s `native` field does name both
   ("the aligned two-graph's finite pair and anchor signature classifications"), so the Lean
   prose is now *weaker* than the JSON beside it — the same direction of drift as the original
   defect, in the opposite field.

3. *A claim the gate does not print, passages.* The header says the order-six conference
   matrix "is now kernel-checked throughout: its symmetry, its square, and its twenty oriented
   triangle signs …". The passages gate prints no axioms for
   `conferenceMatrix_transpose`, `conferenceMatrix_sq` or `conference_triangleSigns` — its
   only conference terminals are `TightFrameConference.conference_sq_of_gram`,
   `ClebschGoldenConference.conferenceMatrixOver_sq` and `triangleCubic_switch`. The claim is
   true (the golden-return report witnesses it) but it is not witnessed by the artifact whose
   header makes it. This is the exact criticism the previous referee levelled at
   `four_shadow_formal.json`'s `symbolic` field in its section D; applying it consistently,
   the passages header now has the same defect. The narrower clause the header also makes —
   "contributes no compiled-evaluation axiom to any terminal printed here" — is self-witnessing
   and correct, and is all the header needed to say.

None of this restores a contradiction, and the count claims — the substance of the repair —
are right. But two of the four method descriptions are wrong and one of the five native
source families is unnamed, so this is a header that is less wrong rather than one that
matches the measurement.

---

## Repair 3 — enforcing the no-compiled-evaluation claim: **PARTIALLY CLOSED**

The headline defect is fixed. A `mechanisms` regex was added to all three verifiers and is
tested against every pinned closure source alongside the existing `forbidden` regex. The
four-shadow verifier's copy is the only one that includes `\bnative_decide\b`; the passages
and golden-return copies deliberately omit it, which is correct — their closures contain 11
and 27 legitimate occurrences respectively. All three verifiers still pass in `--source-only`
against the live Lean tree, so nothing was strengthened onto the wrong gate and nothing was
weakened.

**The previous referee's T9 now fails.** Injecting
`theorem evil : 2+2=4 := by native_decide` into a pinned four-shadow closure source and
re-pinning every hash in the manifest and the closure inventory yields
`four-shadow formal replay: FAIL [source policy RelativeConicArcs/Gates/FourShadowRecognition.lean]`.
Reproduced on a scratch copy outside the repository. The claim is now a check.

**Five escapes I constructed still pass a full coordinated re-pin.** Same method: append the
line to a pinned four-shadow closure source, regenerate every hash, run `--source-only`.

| variant | injected | result |
|---|---|---|
| T9 (referee's) | `theorem evil : 2+2=4 := by native_decide` | FAIL — repaired |
| multi-line attribute | `@[` newline `implemented_by evilImpl]` | FAIL — the `[^\]]*` class spans newlines, so this is caught |
| reduce-bool axiom | `Lean.ofReduceBool _ _ _` | FAIL |
| **standalone attribute** | `attribute [implemented_by evilImpl] evilFn` | **PASS** |
| **`private opaque`** | `private opaque evilOpaque : Nat` | **PASS** |
| **`private axiom`** | `private axiom evilAx : 2+2=5` | **PASS** |
| **kernel bypass** | `set_option debug.skipKernelTC true in` | **PASS** |
| **`unsafe abbrev`** | `unsafe abbrev evilAb := 3` | **PASS** |

The causes are all anchoring, and all one-line fixes:

- `mechanisms` requires the literal `@[` before `implemented_by`/`extern`, so Lean's
  equally valid standalone `attribute [implemented_by f] g` form is invisible.
- `^\s*(?:opaque|partial)\b` and `^\s*(?:axiom|unsafe\s+(?:def|theorem))\b` both anchor on the
  keyword being first on the line. Any modifier in front of it — `private`, `protected`,
  `noncomputable`, `nonrec`, `@[simp]` on the same line — defeats them. `private axiom` is the
  worst of these: it is a pre-existing hole in `forbidden`, not a new one, but it means the
  oldest check in the file has never actually been able to stop an axiom.
- No check exists for `set_option` at all. `set_option debug.skipKernelTC true` disables
  kernel typechecking outright, which is a strictly stronger escape than anything the new
  regex bans, and it leaves no trace in `#print axioms`. For an artifact whose entire thesis
  is "kernel-checked," this is the gap that matters most.

A `sorry` check is a plain substring search and does catch `sorryAx`. The `mechanisms` regex
runs only over the pinned local closure, never over external `Mathlib` imports; that is
inherent to the design and not a defect.

So: the specific claim the previous referee attacked is now enforced, but the enforcement is
keyword-position-anchored and an author who wanted to smuggle a non-kernel proof past it
still can, without much ingenuity. Grade it closed on the letter of the repair and open on
its intent.

---

## Repair 7 — generator hardening: **PARTIALLY CLOSED**

Both generators were hardened, and I drove both with constructed inputs rather than reading
the diff.

`extract_axiom_report.py`. The `error:` guard and the unclosed-bracket guard both fire:

| input | result |
|---|---|
| clean log | report written |
| log containing `error: boom` | `SystemExit: the build log reports an error` |
| `warning:` interleaved between a declaration and its continuation | `SystemExit: truncated axiom list` |
| unindented continuation line | `SystemExit: truncated axiom list` |
| declaration name `A.error:b` | rejected — a loud false positive, safe direction |

That closes silent-truncation modes 2, 3 and 4 from the previous report. **Mode 1 is
untouched and still silently drops.** I fed the extractor a log in which the pretty-printer
wrapped a long declaration name before the phrase `depends on axioms`, together with one
normal declaration. It exited 0 and wrote a report containing only the normal declaration —
no warning, no error, a valid-looking file one declaration short. `INFO_RE` still demands the
phrase on the same physical line as the `info:` prefix, and a name that wraps produces no
truncated line for the new check to catch. The downstream mitigation still holds — the
verifier's `audited_declarations` comparison would reject the short report — but the
generator itself remains able to silently under-report, which is the failure direction that
matters.

`extract_source_closure.py`. The `LOOSE_IMPORT_RE` cross-check fires exactly where it was
asked to:

| input module | result |
|---|---|
| `public import RelativeConicArcs.B` | `SystemExit: has an import this tool cannot parse: ['public import …']` |
| `import RelativeConicArcs.B -- note` | `SystemExit: … ['import RelativeConicArcs.B -- note']` |
| `  import RelativeConicArcs.B` (indented) | `SystemExit`, but the offending-line list prints as `[]` |
| `import` at column zero inside `/- … -/` | still silently **included** in the closure |
| the word `importantly` in a docstring | correctly ignored |

Two residuals. The indented-import diagnostic is empty because `unmatched` filters with
`IMPORT_RE.fullmatch(line.strip())`, which succeeds on the very line that caused the count
mismatch; the run still fails hard, so this is a message defect, not a soundness one. The
block-comment false positive persists, but it over-pins a module rather than dropping one,
which is the safe direction. Under-counting — the direction the repair was for — is now
impossible for every import form I could construct.

---

## Repair 5 — `verify_release.py` replays the gates: **CLOSED**

`check_lean_gates` was added and is called from `main` before the manuscript build.

*With a Lean root:* it shells out to each of the three `verify_*_lean.py` scripts with
`--lean-root <root> --source-only` through the existing `run` helper, which raises on a
non-zero exit. I confirmed the three verifiers exit non-zero on tamper (repair 3 above), so
this path can genuinely fail, and I confirmed all three exit zero against the live tree, so
it does not fail spuriously. `--source-only` is the right mode for a release replay: it needs
no Lean build.

*Without a Lean root:* it prints
`clebsch-passages release: UNCHECKED [Lean gates: passages, golden return, four shadow] pass --lean-root to replay them`
and returns. The gates are named, so the omission is visible rather than silent.

*Artifacts.* `release_files.json` now lists all fifty-two entries including
`verification/verify_four_shadow_lean.py`, `four_shadow_axioms.txt`,
`four_shadow_formal.json`, `four_shadow_source_closure.json` and the three
`verification/evidence/gate_stdout/*.stdout.txt` logs. Every one of the fifty-two exists on
disk. The four-shadow gate is no longer the withheld one, so the asymmetry the previous
referee objected to — shipping the generators but not the gate they regenerate — is gone.

**One objection remains.** After the `UNCHECKED` line the run still ends with
`clebsch-passages release: ALL CHECKS PASS`. A reader who scrolls to the last line of a
no-Lean-root run is told everything passed when three of the artifacts were not examined. The
final banner should distinguish the two runs, e.g. `ALL CHECKS PASS [Lean gates unchecked]`.
This is a one-line presentation fix, not a soundness defect, since the `UNCHECKED` line is
printed by name.

---

## Repair 6 — the pentagon classification: **CLOSED**

`pentagon_bit_classification` and `pentagon_bits_balanced` both lost their `private` modifier
and both gained `#print axioms` lines in `Gates/FourShadowRecognition.lean`, which now prints
eighteen. Both appear in `four_shadow_axioms.txt`:
`pentagon_bit_classification` on `[propext, Classical.choice, Quot.sound]` and
`pentagon_bits_balanced` on `[propext]` — a clean base with no compiled-evaluation axiom, so
the gate's absolute claim survives the addition. The manifest's `audited_declarations` is
exactly the report's eighteen names (as a set; the manifest sorts, the report is in gate
order).

**The disclaimer is accurate, and I checked it rather than took it.** Both the docstring
("The count twelve and the pairwise distinctness of the listed patterns are read off the
displayed list; no Lean statement asserts either") and the trust boundary's version of the
same sentence are true: there is no `Nodup`, `List.length`, `Finset.card` or `Fintype.card`
anywhere in `FourShadowRecognition.lean`, so no Lean statement in the file makes a
cardinality or distinctness claim.

Three independent checks I ran that the artifact does not make for itself: the two theorems
list the *same* twelve patterns (extracted and compared as sets); those twelve are pairwise
distinct; and all twelve satisfy the five vertex balances under the pentagon's edge
indexing. So the human reading the disclaimer defers to is correct — it is just not Lean's.

**One internal tension.** The `native` field of the same JSON object still ends "...giving the
twelve labelled pentagons as a proved classification," while the `symbolic` field two lines
below says the count twelve is asserted by no Lean statement. Both sentences are defensible
in isolation, but placed in one object they read as a contradiction. The `native` field
should say "giving the listed sign patterns as a proved classification."

---

## Repair 9 — provenance: **CLOSED**

Each manifest gained an `axiom_report_provenance` object naming the tracked stdout log, its
SHA-256, the generator and the build run id. I verified all three end to end:

| gate | `gate_stdout_sha256` matches file | regenerated report byte-identical to committed |
|---|---|---|
| passages | yes | yes |
| golden_return | yes | yes |
| four_shadow | yes | yes |

Running `extract_axiom_report.py --stdout verification/evidence/gate_stdout/<g>.stdout.txt`
reproduces each committed `*_axioms.txt` byte for byte, exit code 0, no diagnostics. The logs
are genuine Lake stdout — they carry the `✔ [1249/1250] Built …` progress lines and the
pretty-printer's wrapped continuation lines — so this is a real replay of the normalization,
not a copy of the answer. The repository's reproducibility convention is now met for this
step: report, generator, input and hash are all tracked in one commit.

**Two residuals.** First, no verifier checks `gate_stdout_sha256`; the field is recorded but
unenforced, so a tampered log would be caught only by a human rerunning the generator.
Second, the build run id in the manifests is `run-20260804-044501-6e4a6456`, while
`notes/2026-08-03-c815-paper-iii-formalization-gap-inventory.md` still attributes the
regenerated reports to `run-20260804-040512-9965a2e4`. The reports were regenerated again for
this commit's header edits, so the note's run id is stale and now disagrees with the pinned
manifests.

---

## Repair 10 — `four_shadow_formal.json`'s `symbolic` field: **PARTIALLY CLOSED**

The previous referee named three items in the field with no audited terminal behind them:
pentagon degree, the ten inner products, and the pentagon classification. The rewrite fixes
one and a half of the three.

- *The pentagon classification* is fixed the right way — not by deleting the claim but by
  making the declarations public and audited, and the field now names them explicitly.
- *Pentagon degree* is defensible. The degree-two condition on the pentagon is the
  `pentagonGauge` predicate, and `pentagonGauge_of_firstRowBalanced` is an audited terminal.
- ***Ten inner products* is still unwitnessed.** The only declaration in the closure that
  matches is `five_sign_balances_force_inner_products` at line 454 of
  `FourShadowRecognition.lean`, and it is still `private` and still absent from the gate's
  eighteen `#print axioms` lines. The field continues to assert as kernel-checked something
  the gate exhibits no evidence for — the exact defect the repair was for, in one of the three
  places it was raised.

The remedy is the one the author already used for the pentagon pair: make it public and print
its axioms, or drop the clause.

---

## Repair 8 — the new `claim_map` in `golden_return_formal.json`: **CLOSED**

The map has three rows — `OPER-1` (21 declarations), `OPER-3` (3), `OPER-4` (4) — totalling
28. I verified mechanically that the union is exactly the gate's `audited_declarations`, with
no duplicate and no declaration left unmapped. Of the three gates, golden-return is now the
only one whose claim map is complete: the passages map covers 39 assignments with 2 duplicates
and leaves 13 audited terminals unmapped, and the four-shadow map covers 7 and leaves 11
unmapped. That is a pre-existing asymmetry, not something this commit broke, but it is now
the golden-return map that sets the standard the other two fail.

**Assignments, checked against the manuscript rows.** I read `trust_manifest.json`'s OPER-1,
OPER-3 and OPER-4 rows and `sections/05-golden-operator.tex` / `sections/08-verification.tex`.

- *OPER-1* (`thm:operator-shadows`, clauses: conference square and triangle holonomy;
  switching reconstruction; middle-exterior diagonal; commutator Pfaffian and
  determinant-square; cross-golden determinant over Q(√5)). The five
  `ClebschGoldenConference` matrix and triangle-sign declarations land on clause one; the nine
  `ClebschMiddleExterior` declarations on the middle-exterior clause; the two
  `ClebschOperatorShadows` declarations are exactly the Pfaffian identity Pf = 4Z_T; the five
  `ClebschGoldenDescent` declarations land on the cross-golden/descent clause. Section 08
  independently says "golden-descent mechanisms are checked by the pinned golden-return Lean
  gate," which is the same attribution, and no separate golden-descent claim row exists for
  them to belong to instead. Defensible throughout.
- *OPER-3* (`thm:balanced-exchange-rigidity`). `ConferenceCutSpectrum.signedTriangle_sq` is
  named almost verbatim by the row's own `proof_role` ("the three-vertex signed-matrix square
  identity used for the order-six converse"). `pairTriangleSum_eq_zero` and
  `triangleSign_four_point` support the signed closed-four-walk count and the aligned-four-set
  second moment, which are clauses of the same row. Correct.
- *OPER-4* (`thm:aligned-faithfulness`). `triangleSign_switch`,
  `switch_eq_reconstructed_triangleSign`, `reconstructed_triangle_root` and
  `reconstructed_triangle_nonroot` are the switching transport and signing reconstruction the
  row's `proof_role` lists. Correct.

**One assignment is arguably in the wrong row, and it is the same declaration both ways.**
OPER-1's first clause is literally "conference square, triangle holonomy, *switching
reconstruction*, and middle-exterior diagonal," and OPER-1 receives no switching declaration
at all — all four went to OPER-4, whose clause "conference-signing reconstruction" also fits
them. Either row is defensible for `triangleSign_switch` and
`switch_eq_reconstructed_triangleSign`; what is not defensible is that OPER-1 names a clause
it maps nothing to. This is a presentational flaw in a bidirectional map, not a false claim.

**The `excluded` prose understates one native carrier.** OPER-1's exclusion says "the
middle-exterior square, its diagonal, its parity criterion, its common-neighbour counts and
both degree-ten comparison claims are decided by the compiled evaluator rather than the
kernel." That is five middle-exterior items plus two descent items = seven. The measured count
is **eight**: `ClebschMiddleExterior.hodgeMatrix_sq` also carries a native axiom and is not
named. The gate module header written in the same commit does name it ("its Hodge square"), so
the two artifacts disagree by one carrier, and the JSON is the one that understates.
OPER-3's and OPER-4's `excluded` prose I found accurate; OPER-4's omits the anchor points'
"separation from the root" that the trust manifest names alongside distinctness, which is a
half-clause, not a claim.

**The previous referee's assertion about three misassigned entries was itself false — I
confirm the author's counterclaim independently.** The previous report stated that
`signedTriangle_sq`, `triangleSign_four_point` and `switch_eq_reconstructed_triangleSign` were
"assigned to gates that do not audit them." I checked every claim-map entry in all three
manifests, at HEAD and at both commits the previous referee reviewed (a1a9bc07 and 0260aba8),
for declarations outside their own gate's `audited_declarations`. The set is empty in all six
cases. All three declarations are audited golden-return terminals — `signedTriangle_sq` on
report line 28, `triangleSign_four_point` on line 6, `switch_eq_reconstructed_triangleSign`
in the same report. The previous referee appears to have repeated the author's own stale gap
inventory rather than checking it, which is the failure mode both reports exist to prevent.

---

## Repair 4 — Ramsey wording (deliberately not made): metadata **accurate**

No `.tex` file changed in this commit; I confirmed that with a scoped diff. Instead the trust
metadata was tightened in three places, and all three changes are accurate rather than
compensating overstatements:

- `formal_coverage.boundary` no longer says "both halves of the triangle Ramsey equality." It
  now says "both bounds behind the triangle Ramsey equality on six labelled points — the
  six-point pigeonhole and the pentagon colouring that shows five do not suffice — and the
  aligned anchor they produce." Both named facts are audited passages terminals with clean
  axiom bases: `exists_monochromatic_triple` on `[propext, Classical.choice, Quot.sound]` and
  `no_monochromatic_triple_five` on `[propext]`. The word "bounds" replacing "halves" is the
  right retreat, because there is still no Lean declaration for the equality.
- OPER-3's `proof_role` now adds "though no Lean declaration states the equality itself." I
  searched the passages closure: correct, there is none.
- OPER-4's `proof_role` now adds "and the distinctness of the six anchor points and their
  separation from the root" to the human inputs, and the over-paper ledger's row for
  `exists_alignedAnchor` was rewritten from "harvest: OPER-4's anchor step becomes fully
  formal" to "harvest, partially … The anchor step itself is not fully formal." Both match
  what `exists_alignedAnchor` actually proves — an arbitrary `v : Fin 6 → α` with no
  injectivity and no separation from the root. The over-promotion the previous referee found
  is withdrawn.

The remaining loose thread is small: "on six labelled points" is attached to a sentence one of
whose two bounds is about five points. It reads as a description of the equality rather than
of each bound, so it is not wrong, but it is the one phrase in the rewrite that could be
tightened.

**What the TeX owner must change**, stated precisely and unchanged by this commit:

1. `papers/clebsch-passages/sections/08-verification.tex`, line 42: "The classical Ramsey
   input \(R(3,3)=6\), finite-set extension to seven vertices, and the passage from arbitrary
   labels to the normalized cut coordinates remain human combinatorial steps." Both bounds
   behind \(R(3,3)=6\) are now kernel-checked Lean terminals of the passages gate, so this
   sentence contradicts `trust_manifest.json` in the same release. Remove the Ramsey clause.
2. In the same sentence, add the obligation that is genuinely still human, so the correction
   does not over-swing: the distinctness of the six anchor points and their separation from
   the root. No Lean declaration discharges it.
3. Do **not** touch line 35 ("The unrestricted inclusion-rank and Ramsey exclusion is a human
   proof"). That is the higher-order exclusion and remains correct.
4. Section 08 still never mentions compiled evaluation. Seventeen audited terminals across the
   passages and golden-return gates depend on a `native_decide` axiom outside the kernel,
   including the middle-exterior square and the degree-ten descent comparison that the section
   names as checked by the pinned golden-return gate. Papers I and II disclose this. One
   sentence is needed.
5. Line 52 still says "A paper-specific Lean gate now proves …" in the singular. There are
   three, and as of this commit all three are shipped, so the sentence can simply be made
   plural.

---

## What the repairs broke, and what a referee would still object to

Re-checked the whole artifact set for internal consistency — Lean prose against JSON, JSON
against JSON, notes against measurements. Nothing regressed in soundness: every hash pin is
correct, `extract_statement_identity.py --check` returns `CHECK OK` with all ten section
hashes and the refreshed `trust_rows_sha256` matching, `verify_scaffold.py` returns OK, and
all three Lean verifiers pass. The defects below are consistency and documentation gaps.

**Introduced by this commit.**

1. *The gap inventory's own table is now stale.* It still records
   `FourShadowRecognition | 16` terminals; repair 6 made it eighteen in the same commit.
2. *The shipped README documents two of the three gates.*
   `papers/clebsch-passages/verification/README.md` has replay instructions for
   `verify_passages_lean.py` and `verify_golden_return_lean.py` and describes
   `golden_return_*` by name. It never mentions the four-shadow gate, `four_shadow_axioms.txt`,
   `four_shadow_formal.json`, `four_shadow_source_closure.json`, or the three new
   `evidence/gate_stdout/*.stdout.txt` logs — all seven of which repair 5 and repair 9 just
   added to `release_files.json`. A reader of the shipped release now receives seven artifacts
   with no instructions for any of them, which is the mirror image of the asymmetry the
   previous referee objected to.
3. *`verify_scaffold.py` still knows nothing about the four-shadow gate*, so the scaffold
   summary line counts gates it can see and silently omits one that is now released.
4. *The gap inventory attributes the axiom reports to build
   `run-20260804-040512-9965a2e4`; all three manifests now say `run-20260804-044501-6e4a6456`.*
   The reports were regenerated for this commit's header edits, so the note's run id is wrong.
5. *`four_shadow_formal.json` contradicts itself by one word.* `native` ends "giving the
   twelve labelled pentagons as a proved classification"; `symbolic` says the count twelve is
   asserted by no Lean statement.
6. *`golden_return_formal.json`'s OPER-1 `excluded` names seven native carriers where the
   measurement is eight*, omitting `ClebschMiddleExterior.hodgeMatrix_sq` — which the gate
   header written in the same commit does name.

**Carried over, still open.**

7. Five constructed escapes defeat the new `mechanisms` and the old `forbidden` regexes
   (repair 3), of which `set_option debug.skipKernelTC true` is the serious one.
8. `extract_axiom_report.py` still silently drops a declaration whose name wraps before the
   phrase `depends on axioms` (repair 7).
9. `four_shadow_formal.json`'s `symbolic` still claims "ten inner products" are kernel-checked
   when the only matching declaration, `five_sign_balances_force_inner_products`, is `private`
   and unaudited (repair 10).
10. `verify_release.py` prints `ALL CHECKS PASS` after printing `UNCHECKED` for the gates
    (repair 5).
11. No verifier checks `gate_stdout_sha256`, so the new provenance pin is recorded but not
    enforced (repair 9).
12. The passages claim map leaves 13 audited terminals unmapped and duplicates 2 assignments;
    the four-shadow map leaves 11 unmapped. Only golden-return is now complete.
13. Section 08 of the manuscript is unchanged and remains the largest single defect in the
    release — the Ramsey sentence, the missing compiled-evaluation disclosure, and the
    singular "a paper-specific Lean gate." TeX-owner work; see repair 4 above.

---

## Grades

| repair | subject | grade |
|---|---|---|
| 1 | gap inventory's native-source count | **CLOSED** |
| 2 | two stale gate module headers | **PARTIALLY CLOSED** |
| 3 | no-compiled-evaluation enforcement | **PARTIALLY CLOSED** |
| 4 | Ramsey manuscript correction (deliberately deferred) | metadata **accurate**; TeX owner's work |
| 5 | `verify_release.py` replays the gates | **CLOSED** |
| 6 | pentagon classification made public and audited | **CLOSED** |
| 7 | generator hardening | **PARTIALLY CLOSED** |
| 8 | `claim_map` in `golden_return_formal.json` | **CLOSED** |
| 9 | provenance of the axiom reports | **CLOSED** |
| 10 | `four_shadow_formal.json`'s `symbolic` field | **PARTIALLY CLOSED** |

## Verdict: **ACCEPT WITH REPAIRS**

Six of the nine actionable repairs are closed outright and none of them cosmetically: the
"fourteen" is now a measured thirty-six with a stated convention, the pentagon classification
is public and audited in both directions with a disclaimer I confirmed against the source, the
axiom reports replay byte-for-byte from tracked build logs, the release gate now runs the three
Lean verifiers, and the golden-return claim map is the only complete one in the paper. The
previous referee's T9 tamper — a `native_decide` smuggled into the four-shadow closure behind a
full coordinated re-pin — now fails, which converts the paper's strongest claim from an
assertion into a check. The author was also right to push back on the three-misassigned-entries
finding: I reproduced the check at HEAD and at both reviewed commits and the previous referee
was wrong.

What holds this back from ACCEPT is that three of the repairs stopped at the letter of the
instruction. The rewritten gate headers get their counts right but misdescribe the method for
two of the four conference facts and leave one of the five native source families unnamed. The
enforcement regex catches the one tamper it was shown and misses five others I wrote in a few
minutes, including a `set_option` that turns off kernel typechecking entirely. And the
`symbolic` field still asserts one thing its own gate does not print. None of these makes a
false mathematical claim; all of them make the artifact say slightly more than it can show,
which is the standard this task exists to hold.

### Remaining repairs, in priority order

1. **Close the five escapes in `mechanisms`/`forbidden`** in all three `verify_*_lean.py`:
   allow modifiers before the anchored keywords (`(?:private|protected|noncomputable|nonrec|
   partial|unsafe)?\s*` before `axiom`/`opaque`), accept the standalone `attribute [...]` form
   as well as `@[...]`, cover `unsafe abbrev`/`instance`/`example`, and add a `set_option`
   check that at minimum refuses `debug.skipKernelTC` and `allowUnsafeReducibility`. Verify by
   re-running the eight-variant battery in repair 3 above.
2. **Fix the three header clauses** in `Gates/ClebschGoldenReturn.lean` and
   `Gates/ClebschPassages.lean`: say `conference_triangleSigns` is a `decide` over twenty
   ordered triples and `conference_triangleCubic_translate` is a ring-generic symbolic
   transport, not an index-pair sweep; name the anchor-signature classifier as the second
   `AlignedTwoGraph` native source; and either drop the passages header's claim about facts
   the passages gate does not print or attribute it to the golden-return gate. Re-pin the two
   hashes.
3. **Reconcile the six internal inconsistencies** listed above as items 1, 4, 5 and 6:
   the gap inventory's four-shadow terminal count (16 → 18) and its stale run id, the
   `native`/`symbolic` disagreement about "twelve" in `four_shadow_formal.json`, and the
   missing `hodgeMatrix_sq` in OPER-1's `excluded`.
4. **Document the newly shipped artifacts.** Add the four-shadow gate and the three
   `evidence/gate_stdout/*.stdout.txt` logs to `verification/README.md` with the same replay
   form the other two gates get, and teach `verify_scaffold.py` about the four-shadow gate.
5. **Fix `extract_axiom_report.py`'s remaining silent drop**: after extraction, require that
   the number of `info:` lines carrying a `#print axioms` diagnostic equals the number of
   emitted report lines, or match the declaration name across a wrap.
6. **Resolve "ten inner products"** in `four_shadow_formal.json`'s `symbolic`: make
   `five_sign_balances_force_inner_products` public and audited, as was done for the pentagon
   pair, or delete the clause.
7. **Make the no-Lean-root release banner state what it verified**:
   `ALL CHECKS PASS [Lean gates unchecked]`.
8. **Enforce `gate_stdout_sha256`** in the three verifiers when the log is present, so the new
   provenance pin is a check rather than a record.
9. **Complete the passages and four-shadow claim maps** to the standard golden-return now sets:
   every audited terminal mapped exactly once.
10. **Hand the TeX owner the five section-08 changes** enumerated under repair 4.
