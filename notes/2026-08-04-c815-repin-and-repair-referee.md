# Referee report: Paper III gate re-pinning and Lean repairs (commits a1a9bc07, 0260aba8)

**Lane:** `clebsch`
**Date:** 2026-08-04
**Task:** C815

Cold adversarial review of the Paper III ("Golden descent and operator realizations of the
Clebsch cubic") verification artifacts. Nothing the author claims was assumed true; every
number, hash and sentence below was recomputed or re-derived from the files on disk.
Read-only: no repository file was edited, staged or committed by this review, and no Lean
build was run. Tamper experiments were performed on a minimal copy in a scratch directory
outside the repository.

---

## A. The two new generators — grade B

### A.1 `extract_axiom_report.py`

The regex is

```
INFO_RE = ^info: [^:]+\.lean:\d+:\d+: (?='.* (?:depends on axioms|does not depend))
CONTINUATION_RE = ^ 
```

**What is right.** The empty-axiom case is handled: the lookahead alternation includes
`does not depend`, and it matters in practice — `passages_axioms.txt` line 30 is
`'RelativeConicArcs.AlignedTwoGraph.alignedAnchor_of_ramseyTriple' does not depend on any
axioms`. The verifier's `parse_axioms` maps that to the empty list. The continuation
format was checked against the pre-normalization file (`git show
a1a9bc07^:...golden_return_axioms.txt`): Lean wraps with exactly one leading space per
continuation line, which `CONTINUATION_RE` matches, and rejoining with a single space
reconstructs the flat form byte-for-byte. I confirmed the round trip: re-wrapping the
committed `passages_axioms.txt` at every `", "`, wrapping it in synthetic `info:` prefixes,
and running `extract` returns the committed file's exact bytes.

**Faithfulness against the gates.** The strongest evidence, and it is strong: for all three
gates the report's declaration names and their order are byte-identical to the `#print
axioms` lines of the gate module, in source order.

| gate | `#print axioms` lines | report lines | names and order |
|---|---|---|---|
| `Gates.ClebschPassages` | 50 | 50 | identical |
| `Gates.ClebschGoldenReturn` | 28 | 28 | identical |
| `Gates.FourShadowRecognition` | 16 | 16 | identical |

Nothing was dropped or merged in the reports actually committed.

**Where it can silently drop or truncate.** I drove the extractor with synthetic stdout.
Four failure modes are real:

1. *A declaration name long enough that the pretty-printer wraps before `depends on
   axioms`.* `INFO_RE` requires the phrase on the same line as the `info:` prefix, so such a
   declaration is skipped entirely and its continuation lines are skipped too (`inside`
   stays `False`). Silent drop. The docstring's own premise — that the wrap width is
   environment-dependent — is exactly what makes this reachable; the current longest name
   (`...pfaffianSix_bracketMatrix_eq_matchingEvaluation`, 76 characters plus prefix) is not
   far from a narrow terminal's wrap point.
2. *Any non-continuation line interleaved between a declaration and its continuations*
   (a `warning:`, a Lake progress line, another job's stdout under parallel builds). Output
   is a truncated, unclosed axiom list: `'X' depends on axioms: [propext,`. Silent
   truncation.
3. *A continuation line that is not indented.* Same silent truncation.
4. *A build `error:` anywhere in the log.* Ignored; the extractor happily writes a report
   from whatever printed. It cannot tell a successful gate build from a partial one.

Mitigation, which I verified: all four are caught downstream, not by the generator.
`check_axiom_log` compares `set(expected)` against `manifest["audited_declarations"]`, so a
dropped declaration fails as `[manifest/report declaration mismatch]`, and a truncated
unclosed list makes the declaration unparseable, which is the same failure. This is real
defence in depth, but it depends on `audited_declarations` being maintained by hand and
never regenerated from the same log. There is no generator for it, so today the guard holds.

Two smaller points. `[^:]+\.lean` rejects any path containing a colon — that is a loud
`SystemExit`, so it is safe, not silent. And junk appended by an *indented* foreign line
gets merged into a declaration but is ignored by `parse_axioms` (its `\[(.*?)\]` is
non-greedy), so it can change the report bytes without changing the parse; harmless today
but it means byte-identity and parse-identity are not the same relation.

**Provenance gap.** The stdout the reports were built from is named only as
`run-20260804-040512-9965a2e4` in a note. No log is tracked in the repository, and no hash
of one is recorded anywhere. The generator's replay command therefore cannot be run by
anybody but the author, and the repository's own research-reproducibility convention
(commit the report, the generator, and a compact certificate with hashes) is not met for
this step.

### A.2 `extract_source_closure.py`

I wrote an independent closure walker with a different import regex (leading whitespace
tolerated, block comments stripped, trailing text tolerated) and ran it against the Lean
tree. **All three inventories reproduce exactly**: same module sets (15 / 17 / 7), same
per-module SHA-256, same `external_imports` lists (8 / 11 / 11), and every recorded `bytes`
matches `stat().st_size` on disk. Every `path` field is the mechanical
`module.replace(".", "/") + ".lean"`.

Cross-check against Lean: I confirmed by hand that `Gates/ClebschPassages.lean`'s thirteen
imports, `Gates/ClebschGoldenReturn.lean`'s seven and `Gates/FourShadowRecognition.lean`'s
one all appear as closure roots' children, and that the transitive additions are real (for
example `RelativeConicArcs.ClebschMiddleExterior` and the four
`ClebschMiddleExteriorSquareRows*` modules reach the golden-return closure only through
`ClebschMiddleExteriorSquare`/`Support`, and `GoldenMatchingCubics` /
`WeightedMatchingEvaluation` reach four-shadow only through `GoldenCommutatorPfaffian`).
I also confirmed every audited declaration's namespace is a module in its gate's closure.

**Bare-root import.** `lean/RelativeConicArcs.lean` does exist (a 30-line aggregator). The
generator handles `import RelativeConicArcs` correctly and by design —
`imported == LOCAL_PREFIX` sends it to `pending`, and `module_path` resolves it. No module
under `RelativeConicArcs/` currently imports the bare root, so the case is untested in
practice, but the code is right. A module reachable only through another paper's file is
likewise handled: the walk is purely by import edge and does not care which paper owns the
file — and I confirmed `ClebschGoldenConference` and `ClebschTwoGraph`, which are shared
with Paper I and the golden-operator lane, are pinned in the Paper III closures.

**Where it is fragile.** `IMPORT_RE` is `^import\s+(\S+)\s*$` with no tolerance for the Lean
module-system forms `public import` / `meta import`, for a trailing comment on an import
line, or for leading whitespace; and it will falsely pick up an `import` line at column zero
inside a `/- ... -/` block comment. I checked the whole `RelativeConicArcs` tree: none of
these forms occurs today, so the inventories are correct now. They would become silently
*incomplete* — a module dropped from the closure, hence unpinned and unpoliced — the day
someone writes `public import`. That is a silent under-count, the worst failure direction
for this artifact, and it deserves a hard failure rather than a miss.

---

## B. Is the one-line-per-declaration normalization safe? — grade A

Yes, and I verified it two ways rather than reading the code alone.

`parse_axioms` compiles `'([^']+)' (does not depend on any axioms|depends on axioms: \[(.*?)\])`
with `re.DOTALL`, then splits the body on commas and strips each part after
`replace("\n", " ")`. Wrapped and flat forms therefore normalize to the same list. Running
`parse_axioms` on the committed `passages_axioms.txt` and on the same text re-wrapped at
every `", "` gives **identical dictionaries**. So the normalization changes bytes and not
meaning, and the author's stated reason for it — that Lean's wrap width is
environment-dependent and would otherwise break the byte comparison — is correct.

Nothing else byte-compares these files. Searching the verification tree, the only byte
comparison is `sha256(AXIOM_REPORT) != manifest["axiom_report_sha256"]` inside each
`verify_*_lean.py`; `verify_release.py` and `verify_scaffold.py` do not touch them (see
section I). `check_axiom_log` compares *parsed* dictionaries, not text, so a live log that
arrives wrapped still passes against the normalized pin — which is the property the
normalization was for.

One residual asymmetry worth stating: `--axiom-log` mode is parse-tolerant of wrapping, but
the *pinned file itself* is compared by hash, so a re-generation on a machine with a
different wrap width would still produce a different file unless it goes through
`extract_axiom_report.py`. The normalization makes the generator, not the format, the
invariant. That is fine but it is another reason the generator's fragility (A.1) matters.

---

## C. Are the re-pinned hashes right? — grade A

Recomputed independently. Every pin is correct.

| gate | `axiom_report_sha256` | `source_closure_sha256` | `verifier_sha256` | `source_sha256` map |
|---|---|---|---|---|
| passages | OK | OK | OK | 15/15 OK |
| golden_return | OK | OK | OK | 17/17 OK |
| four_shadow | OK | OK | OK | 7/7 OK |

Specifically: each `source_sha256` map is exactly the `{path: sha256}` projection of its
closure inventory's `sources` — no path added, none dropped, no value differing — and every
value also matches the file on disk under `lean/`. `roots` in each inventory equals
`[gate_module]` in its manifest. `audited_declarations` equals the report's declaration set
exactly in all three manifests (50 / 28 / 16).

Claim 5 (statement identity refreshed) also checks out: `python3
verification/extract_statement_identity.py --check` returns `CHECK OK`, all ten section
hashes match the `.tex` files on disk, no section on disk is unpinned, and the main source
hash matches.

---

## D. Are the two rewritten `trust_boundary.native` sentences accurate and complete? — grade A−

I parsed all three axiom reports and computed, per gate, which audited declarations carry a
non-standard axiom (anything outside `propext`, `Classical.choice`, `Quot.sound`) and which
axiom constants those are.

**Measured native surface.**

| gate | audited terminals | carriers | distinct `_native.native_decide.ax` constants |
|---|---|---|---|
| `ClebschPassages` | 50 | 9 | 9 |
| `ClebschGoldenReturn` | 28 | 8 | 27 |
| `FourShadowRecognition` | 16 | 0 | 0 |

Passages carriers: the three `GoldenQuadraticCharacters` terminals
(`exchanger_eq_reflection_mul`, `exchanger_reflection_factorization`,
`two_not_square_zmod11`), `ClebschInvariantCubic.eq_gauntCoefficient_mul_sigmaThree`, the
two `ClebschPassagesCorrespondence` terminals, and the three `AlignedTwoGraph` terminals
(`pairSignature_classification`, `anchorSignature_eq_false_iff_balanced`,
`normalizedSevenSignature_injective`). Their axiom sources are five in
`GoldenQuadraticCharacters`, two in `ClebschInvariantCubic`
(`markedFixedVector_sum`, `sigmaThree_markedFixedVector`) and two in `AlignedTwoGraph`.

Golden-return carriers: six in `ClebschMiddleExterior` (`hodgeMatrix_sq`,
`middleExterior_sq`, `middleExterior_diagonal`, `middleExterior_mod_two_eq_one_iff`, the two
`commonIntersectionOneNeighbors_*`) and the two `ClebschGoldenDescent` degree-ten claims.
`middleExterior_sq` alone pulls in the twenty `middleExterior_sq_row_*` axioms.

**Passages sentence — accurate and complete.** It names the reflection matrices and the
`F_11` nonsquare leaf, the marked fixed vectors and their third elementary symmetric values,
and the aligned two-graph's pair and anchor signature classifiers "over the 16,384
normalized two-cut cases." That count is exactly right: `pairSignature_classification`
quantifies over `p s p' s' : Fin 8` and `e e' : Bool`, so 8⁴·2² = 16,384. Every measured
carrier falls under one of the three named families, and nothing named is in fact
kernel-checked. The second sentence — conference matrix, its square, transpose and the
twenty triangle signs are now kernel-checked — is confirmed by the report.

**Golden-return sentence — accurate and complete.** Every one of the eight carriers is
either `ClebschMiddleExterior` or one of the two degree-ten comparisons, as claimed, and
`conferenceMatrix_sq`, `conferenceMatrix_transpose`, `conference_triangleSigns` and
`conference_triangleCubic_translate` all carry only the three standard axioms. Nothing is
claimed kernel-checked that is not.

**Four-shadow claim of zero compiled evaluation — true, and stronger than it needed to be.**
All sixteen audited declarations depend only on the three standard axioms. I went further
and grepped the whole seven-module closure: `native_decide` occurs **zero** times in any
four-shadow source. (For contrast, the passages closure has 11 occurrences and the
golden-return closure 27.) So the claim is true at module level too.

**Why the grade is A− and not A.** The `native` field is measured and correct; the
neighbouring `symbolic` field is not. `four_shadow_formal.json` says "Translation
extraction, pair moments, diagonal and scalar square, pentagon degree, ten inner products,
cubic homogeneity, the pentagon classification, and each polynomial identity and coefficient
comparison are kernel-checked." Several of those — pentagon degree, the ten inner products,
the pentagon classification — correspond to no audited terminal in the sixteen and are
`private` in the module (see G). They may well be kernel-checked, but the gate exhibits no
evidence for them, and a trust ledger should not assert what its own audit does not print.

Two structural remarks about the trust ledger that a referee will make:

- **`golden_return_formal.json` carries no `claim_map`.** `passages_formal.json` and
  `four_shadow_formal.json` both do. The golden-return gate therefore states a trust
  boundary but no correspondence between manuscript rows and Lean declarations, which is
  precisely the bidirectional map the Paper I standard requires.
- The claim-map defect the author's own gap inventory records (`signedTriangle_sq`,
  `triangleSign_four_point`, `switch_eq_reconstructed_triangleSign` assigned to gates that
  do not audit them) is still open in this commit pair.

---

## E. Do the gap-inventory numbers hold up? — grade C

Checked line by line against the reports.

- **"Ten of the twenty-seven carriers are cleared" — correct.** Old table 10 + 13 + 4 = 27;
  new measured 9 + 8 + 0 = 17; cleared 1 + 5 + 4 = 10. Arithmetic sound. The note is also
  careful to say the passages denominator moved from 43 to 50, so the "ten cleared" is not
  smuggled through a changed base.
- **"Seventeen remain" — correct.** I measure exactly 17 carriers.
- **The per-gate table (50/9, 28/8, 16/0) — correct**, and the gate `#print axioms` counts
  independently confirm 50, 28, 16.
- **The three families — correct.** Passages: golden quadratic characters reach three
  terminals, `ClebschInvariantCubic` reaches three (two through the passages
  correspondence), the aligned two-graph's own two classifiers reach three. I confirmed each
  of those 3+3+3 = 9 attributions from the axiom lists. Golden-return: every carrier is
  middle-exterior or degree-ten, as stated.
- **"Fourteen distinct native sources" — WRONG.** The measured figure is **36** distinct
  `_native.native_decide.ax_1_1` constants across the two gates (9 passages + 27
  golden-return, with no overlap). Collapsing the twenty `middleExterior_sq_row_*` axioms
  into one family gives **17**, not 14. Counting distinct *modules* that emit native axioms
  gives 5. No grouping I can construct yields 14. The likeliest slip is 9 (passages) + 5
  (the non-row middle-exterior sources) = 14, which drops the twenty row lemmas and the two
  golden-descent sources — the very items the same paragraph then goes on to name. This
  number is in a committed note that feeds C800/C816/C823/C824, and it understates the
  compiled-evaluation surface by a factor of more than two. It must be corrected.

Two smaller inaccuracies in the same section. "The conference module contributes none" is
true of the axiom reports but `ClebschGoldenConference.lean` is in all three closures and
contains no `native_decide` — that is stronger and worth saying. And the sentence
"Passages grew from forty-three to forty-six terminals with the Ramsey and anchor additions,
and then to fifty" is not reconstructible from anything committed; the gate went 43 → 50 in
the tree and the intermediate 46 exists only in the author's memory of the session.

---

## F. Can the verifiers still fail? — grade B

Nine tamper experiments on a minimal scratch copy (verification directory plus only the
pinned Lean sources and `lean-toolchain`). Baseline: all three pass in `--source-only`, all
three pass in `--axiom-log` against their own pinned report.

| # | tamper | result |
|---|---|---|
| T1 | delete one native axiom from the supplied log | FAIL [axiom report mismatch] |
| T2 | add a bogus axiom to a declaration in the log | FAIL [axiom report mismatch] |
| T3 | delete a whole declaration from the log | FAIL [axiom report mismatch] |
| T4 | append one space to a pinned Lean source | FAIL [hash RelativeConicArcs/AlignedTwoGraph.lean] |
| T5 | bump one `bytes` field in the closure inventory | FAIL [source closure hash] |
| T6 | corrupt `axiom_report_sha256` in the manifest | FAIL [axiom report hash] |
| T7 | edit a Lean source **and** re-pin every hash in manifest and closure | **PASS** |
| T8 | append a comment to the verifier itself | FAIL [verifier hash] |
| T9 | inject `theorem evil : 2+2=4 := by native_decide` into `FourShadowRecognition.lean`, then re-pin every hash | **PASS** |

The verifier is genuinely capable of failing, including on its own source (T8), which is
better than most paper-local gates. T7 is not a defect — a coordinated re-pin is
indistinguishable from a legitimate regeneration, and the real anchor is git history.

**T9 is a defect, and it is the one that matters here.** The four-shadow gate's headline
claim is "No compiled evaluation is used." I injected a `native_decide` theorem into a
pinned closure source and re-pinned; both `--source-only` and `--axiom-log` pass, because
the source-policy grep is

```
forbidden = ^\s*(?:axiom|unsafe\s+(?:def|theorem))\b       # plus a literal "sorry" search
```

which does not look for `native_decide`, `implemented_by`, `@[extern]`, `opaque`, `partial`,
or `Lean.ofReduceBool`; and the axiom report only covers the sixteen declarations the gate
chooses to print. The paper's strongest new claim — the one this whole task was for — is
therefore asserted by the metadata and *not enforced by the mechanism*. Given that the
property is currently true (D: zero occurrences in the closure), closing this is a one-line
addition to `forbidden` and it converts a claim into a check.

Two lesser notes. The `workflow_prose` regex rejects any pinned source containing the words
`pending`, `temporary`, `fallback`, `agent` or `lane`, and `workflow_id` rejects any
identifier matching `\bC[0-9]{3,}\b` — both are plausible in ordinary mathematical Lean
(`lane` and `agent` less so, but `C210`-shaped matrix names are not exotic in this project).
And `parse_axioms` does reject a duplicated declaration, which I confirmed.

---

## G. Are the earlier Lean repairs real? — grade B−

**`ClebschGoldenConference.lean` — real repair, and the docstring is now correct.** The
module header states that every claim about the explicit integer table is discharged by
kernel reduction — symmetry, vanishing diagonal, unit squares, `C * C = 5 • 1`, the twenty
oriented triangle signs — with `Matrix.ext`, thirty-six index pairs by `Fin` case analysis,
and it says explicitly "No compiled evaluation … enters this module, so its results rest
only on `propext`, `Classical.choice`, and `Quot.sound`." Verified: `native_decide` occurs
zero times in the file, and the axiom reports back the claim. This is a genuine conversion,
not a re-labelling.

**Ramsey — the pairing is not overstated.** `exists_monochromatic_triple` proves R(3,3) ≤ 6
for an arbitrary `f : Fin 6 → Fin 6 → Bool` read only on increasing pairs, by the real
pigeonhole argument (a private `three_equal_of_five` isolates the 2⁵ Boolean word check, then
the classical three-case split), not by enumerating colourings.
`no_monochromatic_triple_five` exhibits `pentagonColouring` and kernel-decides that no
increasing triple is monochromatic, giving R(3,3) > 5. Together they are the equality, in
the increasing-pairs model that both statements share, and the docstring says exactly that
and no more. Both are audited passages terminals with no native axiom
(`[propext, Classical.choice, Quot.sound]` and `[propext]`).

One gap a referee will notice: the pentagon colouring *is* symmetric (I checked all ten
pairs), but no Lean statement says so, and no Lean declaration is named for or states
`R(3,3) = 6`. The equality is a human reading of two Lean facts. That is defensible and the
docstring does not claim otherwise, but the trust manifest's phrase "both halves of the
triangle Ramsey equality" is doing a small amount of unearned work.

**`exists_alignedAnchor` does not deliver what the manuscript's anchor step needs.** It
takes an arbitrary `v : Fin 6 → α` with no injectivity and no separation from the root, and
returns `i < j < k` in `Fin 6` with `Aligned tau r (v i) (v j) (v k)`. If `v` is not
injective the aligned four-set is degenerate. The manuscript's anchor step is about six
distinct labelled points distinct from the root. The docstring is candid — "whether the six
points themselves are distinct, and distinct from the root, is a property of `v` and `r`
that the caller supplies" — and the over-paper ledger repeats the caveat. So there is no
over-claim, but there is an over-*promotion*: the ledger's disposition for this row reads
"harvest: OPER-4's anchor step becomes fully formal," and it does not. What became formal is
the Ramsey input; the anchor step still has an unformalized distinctness obligation, and no
Lean declaration discharges it.

**`pentagon_bits_balanced` is a genuine converse but it is dead code.** The statement is
correct: given any of the twelve listed sign patterns, all five vertex balances hold, proved
by twelve `rfl` destructurings and `simp`. Paired with `pentagon_bit_classification` it does
make the twelve exactly the solution set of the five equations. But:

- it is `private`, so it can never be cited from outside `FourShadowRecognition.lean`;
- it is referenced nowhere in the file except in one docstring at line 699 — it has no
  consumer at all;
- it is consequently absent from `Gates/FourShadowRecognition.lean`'s sixteen
  `#print axioms` lines, so no gate audits it and no reader replaying the gate sees it;
- and neither direction proves the twelve patterns are pairwise *distinct*, so "exactly
  twelve labelled pentagons" is a count no Lean statement makes. The patterns are visibly
  distinct, but that is again a human reading.

So: the converse is real mathematics, correctly stated and proved. The claim that "exactly
twelve labelled pentagons is witnessed in both directions" is true of the source and false
of the artifact — a referee replaying the shipped gate cannot see either direction. The fix
is to make one of the two public and print its axioms.

The four-shadow `trust_boundary.native` prose describing the finite step — six patterns at
the first non-root vertex, then 2⁶ assignments of the remaining six parameters — matches the
proof exactly (`four_bool_sum_zero_cases` gives six cases, then `cases b4 <;> … <;> cases b9`
gives 64 each). That description is accurate.

**Module headers of two of the three gates are now stale, and stale in the direction that
over-claims compiled evaluation.** This is the sharpest defect in this commit pair, because
the author updated the JSON and left the Lean prose behind, producing a direct
self-contradiction inside the pinned artifact:

- `Gates/ClebschPassages.lean` still reads "Native decision is confined to the displayed
  finite conference/reflection matrices, …" — but `passages_formal.json` now says the
  conference matrix is kernel-checked and contributes no compiled-evaluation axiom, and the
  axiom report agrees.
- `Gates/ClebschGoldenReturn.lean` still reads "Native decision evaluates the explicit
  integral conference matrix, its twenty triangle signs, the determinant-defined
  middle-exterior operator, and the two displayed descent matrices." The first two clauses
  are now false; `golden_return_formal.json` says so in the same commit.

The author's own gap inventory, class D, states the rule that was broken: "Module headers
currently describe native evaluation as an accepted internal method. Once class A is
cleared, every such sentence must be rewritten to the actual method, in the same change as
the proof." `Gates/FourShadowRecognition.lean` *was* updated correctly, and phrases its
claim more carefully than the JSON does ("No compiled evaluation … is used by the
declarations printed here"). The other two were not.

---

## H. Manuscript prose versus the trust metadata — work for the TeX owner

Not edited; reported only.

`papers/clebsch-passages/sections/08-verification.tex` lines 41–44 read:

> The classical Ramsey input \(R(3,3)=6\), finite-set extension to seven vertices, and the
> passage from arbitrary labels to the normalized cut coordinates remain human combinatorial
> steps.

and line 35:

> The unrestricted inclusion-rank and Ramsey exclusion is a human proof.

**Disagreement 1 (must fix).** `R(3,3)=6` is no longer a human input. Both halves are
audited passages terminals with no compiled-evaluation axiom, and the trust manifest already
says so twice — `formal_coverage.boundary` lists "both halves of the triangle Ramsey
equality and the resulting aligned anchor on six labelled points" among what Lean proves,
and the `thm:aligned-faithfulness` row says "anchor existence through both halves of the
triangle Ramsey equality." The manuscript and the manifest now contradict each other on the
same sentence. The over-paper ledger's row 24 anticipates this and prescribes the fix:
strengthen the trust side, keep the classical attribution in `literature-boundaries.md`.
Line 35 is about the *higher-order* inclusion-rank and Ramsey exclusion and remains correct
— do not touch it.

**Disagreement 2 (should fix).** The same sentence's other two clauses — finite-set
extension to seven vertices, and normalization from arbitrary labels — are still true, and
the anchor step's distinctness obligation (G) is still human. If the Ramsey clause is
removed, the sentence should gain the distinctness obligation rather than silently shrink,
or the manuscript will over-state the formal anchor coverage in the opposite direction.

**Disagreement 3 (disclosure gap, should fix).** Section 08 never mentions compiled
evaluation at all. Seventeen audited terminals across two gates rest on a
`native_decide` axiom outside the kernel, including the middle-exterior square and the
degree-ten descent comparison that the section names as "checked by the pinned golden-return
Lean gate." A reader of the released paper is told those mechanisms are Lean-checked and is
not told that some of them are checked by a trusted compiled evaluator. Papers I and II
disclose this; Paper III does not. That is the sentence a real referee will circle.

**Disagreement 4 (minor).** Line 52 says "A paper-specific Lean gate now proves …"
(singular). There are three, one of which is not shipped at all (section I).

---

## I. Other things that would embarrass the authors

1. **`verify_release.py` never runs the three Lean gate verifiers.** It checks the release
   allowlist, the public vocabulary, the statement identity, `verify_scaffold.py`, three
   exact-arithmetic evidence bundles and the manuscript build — and stops. So the commit
   message's "the paper release gate passes end to end" is true and beside the point: the
   release gate does not exercise a single one of the artifacts this task re-pinned. Anyone
   replaying the shipped release never checks the Lean pins.
2. **The four-shadow gate is not shipped.** `release_files.json` contains
   `verify_passages_lean.py`, `verify_golden_return_lean.py`, both their reports, manifests
   and closures, and both new generators — and none of `verify_four_shadow_lean.py`,
   `four_shadow_axioms.txt`, `four_shadow_formal.json`, `four_shadow_source_closure.json`.
   The gate whose compiled evaluation this task eliminated is the one a reader cannot
   replay. The author records this himself, which is to his credit, but shipping the two
   *generators* while withholding the gate they regenerate is a conspicuous asymmetry.
   `verify_scaffold.py` likewise knows nothing about the four-shadow gate.
3. **The axiom reports' provenance is an untracked log** (A.1). The only pointer is a run id
   in a note. Under the repository's own reproducibility convention a claimed run is never
   sole evidence.
4. **`golden_return_formal.json` has no `claim_map`** (D), so one of the three gates carries
   no manuscript correspondence at all.
5. Minor: the docstring on `three_equal_of_five` says the check "enumerates two values five
   times and never builds a function-space enumeration," which is accurate and a nice touch;
   nothing to fix, noted only because it is the kind of precision the two stale gate headers
   should be held to.

---

## Grades

| area | grade |
|---|---|
| A. generators correct and faithful | B |
| B. normalization safe | A |
| C. hashes correctly re-pinned | A |
| D. `trust_boundary.native` accurate | A− |
| E. gap-inventory numbers | C |
| F. verifiers can still fail | B |
| G. Lean repairs real, not cosmetic | B− |
| H. manuscript versus metadata | disagrees — TeX-owner work |
| I. other | — |

## Verdict: **ACCEPT WITH REPAIRS**

The substance is sound. The hashes are right, the closures reproduce exactly, the
normalization is meaning-preserving, the conference-matrix and four-shadow conversions are
real kernel proofs and not re-labellings, the Ramsey pair is a genuine two-sided result, and
the verifiers demonstrably fail on every uncoordinated tamper. What needs repair is a wrong
number in a committed note, two Lean docstrings the author's own rule required him to update
in the same change, a claim the verifier asserts but cannot check, and a release gate that
does not run the thing being released.

### Repairs, in priority order

1. **Fix "fourteen distinct native sources"** in
   `notes/2026-08-03-c815-paper-iii-formalization-gap-inventory.md`. The measured figure is
   36 distinct native axiom constants, or 17 if the twenty `middleExterior_sq_row_*` axioms
   are collapsed into one family. State which convention is used. This note feeds
   C800/C816/C823/C824 and currently understates the surface by more than half.
2. **Rewrite the two stale gate module headers** —
   `lean/RelativeConicArcs/Gates/ClebschPassages.lean` and
   `Gates/ClebschGoldenReturn.lean` — to the measured native surface, and re-pin the three
   affected hashes. As committed, the pinned Lean sources contradict the pinned JSON in the
   same directory. This is the repair a referee finds first.
3. **Make the "no compiled evaluation" claim enforceable.** Add `native_decide` (and
   `implemented_by`, `extern`, `opaque`, `Lean.ofReduceBool`) to the `forbidden` regex in
   the three `verify_*_lean.py`, at least in `verify_four_shadow_lean.py` where the claim is
   absolute. T9 shows the claim currently survives a direct violation.
4. **Report the Ramsey change to the TeX owner** as a manuscript defect: section 08 line 42
   calls `R(3,3)=6` a human combinatorial step where the trust manifest says both halves are
   kernel-checked. Include the anchor-distinctness caveat so the correction does not
   over-swing.
5. **Run the three gate verifiers from `verify_release.py`** in `--source-only` mode, and
   add the four four-shadow artifacts to `release_files.json` (or state in the manifest why
   the gate is deliberately withheld, since the generators for it are shipped).
6. **Export one direction of the pentagon classification.** Make
   `pentagon_bits_balanced` or `pentagon_bit_classification` public and add
   `#print axioms` lines for it, so the "exactly twelve labelled pentagons in both
   directions" claim is visible in the artifact rather than only in the source. Consider
   also a `Nodup`/cardinality statement so "exactly twelve" is a Lean claim.
7. **Harden `extract_source_closure.py`**: reject rather than ignore any line matching
   `^\s*(public |meta |private )?import\b` that the strict regex does not capture, so a
   future `public import` fails loudly instead of silently shrinking the pinned closure.
   Similarly, have `extract_axiom_report.py` refuse a stdout log containing `error:`, and
   refuse an axiom list whose bracket never closes.
8. **Add a `claim_map` to `golden_return_formal.json`**, and fix the three claim-map
   assignments (`signedTriangle_sq`, `triangleSign_four_point`,
   `switch_eq_reconstructed_triangleSign`) that point at gates which do not audit them.
9. **Pin the provenance of the axiom reports**: commit the six-gate stdout log, or a hash of
   it, alongside the reports so the generators' replay command is runnable by someone other
   than the author.
10. **Trim `four_shadow_formal.json`'s `symbolic` field** to what the sixteen audited
    terminals actually establish, or audit the declarations it names.
