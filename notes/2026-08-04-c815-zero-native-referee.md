# Referee report: elimination of compiled evaluation from the three Paper III Lean gates (commit b6fc9694)

**Lane:** `clebsch`
**Date:** 2026-08-04
**Task:** C815

Cold adversarial review. The specification is the commit message of b6fc9694, which claims
that every one of the twenty-seven compiled-evaluation (`native_decide`) carriers in the three
Paper III gates is gone. Everything below was recomputed from the files on disk with
independently written scripts, or reproduced by driving the shipped tools; nothing was taken
from the commit message, the notes, or the two earlier referee reports. Read-only: no
repository file other than this report was created or modified, nothing was staged or
committed, and no Lean build was run. Tamper experiments ran on a copy outside the repository.

The two earlier reports are `notes/2026-08-04-c815-repin-and-repair-referee.md` (commit
092b94c5's predecessor) and `notes/2026-08-04-c815-repair-closure-referee.md` (commit
092b94c5). Between the second of those and the commit under review there is one intervening
commit, c990213b, "Paper III: close the second referee pass on the gate audits". Findings
attributed below to c990213b rather than b6fc9694 are marked as such.

---

## 1. Is the zero-native claim true?

**Yes.** Every part of it that I could measure, I measured, and it holds.

I parsed the three committed axiom reports with my own parser, which accepts exactly two line
forms — `'<decl>' depends on axioms: [<list>]` and `'<decl>' does not depend on any axioms` —
and fails loudly on anything else. All ninety-seven lines parsed; none was malformed, and no
declaration appeared twice in any report.

| gate | audited terminals | terminals with a non-standard axiom | distinct non-standard constants | terminals on no axiom at all |
|---|---|---|---|---|
| `Gates.ClebschPassages`       | 50 | 0 | 0 | 4 |
| `Gates.ClebschGoldenReturn`   | 28 | 0 | 0 | 0 |
| `Gates.FourShadowRecognition` | 19 | 0 | 0 | 0 |

Treating `propext`, `Classical.choice` and `Quot.sound` as the standard base, the set of
non-standard constants reached by any audited terminal is **empty** in all three gates. The
previous referee measured 9 + 8 + 0 = 17 carriers over 36 distinct native constants; all of
them are gone. The counts 50 / 28 / 19 in the commit message are correct.

The four zero-axiom passages terminals are real and are the ones the commit implies:

- `RelativeConicArcs.AlignedTwoGraph.aligned_complement_iff`
- `RelativeConicArcs.AlignedTwoGraph.triangle_eq_rooted_xor`
- `RelativeConicArcs.AlignedTwoGraph.alignedAnchor_of_ramseyTriple`
- `RelativeConicArcs.AlignedTwoGraph.sixPointAnchor_testCount`

**`native_decide` occurs nowhere in any pinned closure source.** I read every source listed in
the three `*_source_closure.json` inventories (15, 17 and 7 files) directly from `lean/` and
counted the literal string: zero occurrences in all thirty-nine file-gate pairs. Every recorded
`sha256` and `bytes` field matches the file on disk.

**The reports match the tracked gate stdout logs.** Re-running the shipped
`extract_axiom_report.py` against each `verification/evidence/gate_stdout/<gate>.stdout.txt`
reproduces the committed `*_axioms.txt` **byte for byte**, exit 0, for all three gates. Each
`axiom_report_provenance.gate_stdout_sha256` matches the log on disk. The passages and
golden-return logs carry build run id `run-20260804-060023-d43735f6`; four-shadow, which this
commit did not touch, carries `run-20260804-050416-1085523f`.

**The manifests' audited declaration sets match the reports exactly** — as sets, 50 / 28 / 19,
with no extra and no missing name in any gate. Each `axiom_report_sha256` and
`source_closure_sha256` matches its file.

---

## 2. Are the statements unchanged, and are the new proofs sound?

**Every audited statement is byte-identical to its parent-commit form.** I diffed
`b6fc9694^..b6fc9694` over all eleven converted Lean files and inspected every changed
hunk. Across all thirteen changed Lean files the total is 115 insertions and 65 deletions,
and **not one of them touches a theorem signature**. The change reduces to:

- Twenty-seven tactic bodies replaced. Fifteen of them are the identical substitution
  `native_decide +revert` → `decide +revert` in the four row files (five each in three of
  them, and the fourth pattern-identical); the remaining twelve are `native_decide` replaced
  by `decide`, `ext i j; fin_cases i <;> fin_cases j <;> decide`, `simp [Matrix.det_…]`, or a
  `norm_num` with an explicit simp set.
- One new declaration, `hodgeSign_mul_complement`, and one new import
  (`ClebschMiddleExteriorSupport` into `ClebschMiddleExteriorSquare`, needed for
  `complementIndex_involutive`).
- One docstring extended (`hodgeMatrix_sq`'s), and the two gate module headers rewritten.

Concretely, running the diff filtered to changed non-context lines in the four row files
gives exactly `15 × "+  decide +revert"` and `15 × "-  native_decide +revert"` and nothing
else. No statement was weakened, strengthened, restated, generalized, specialized, renamed,
or made `private`. **No defect to report on this head.**

Two remarks on the substitutions, neither a defect:

- `decide +revert` is a kernel decision: the tactic reverts the free variables, evaluates the
  `Decidable` instance and emits `of_decide_eq_true rfl`, which the kernel rechecks. It leaves
  no axiom, which is exactly what the reports now show.
- Six of the conversions are `norm_num` with an explicit `Matrix.cons_val_*` simp set rather
  than `decide`, because the goals are over `ℚ` and `ℤ` where the `Decidable` instances are not
  reducible in the needed direction. That is a legitimate and stronger route, but see §5: the
  prose calls all of them "kernel reductions", which they are not.

One cosmetic wart is shipped in a pinned source. The golden-return gate log
`verification/evidence/gate_stdout/golden_return.stdout.txt` carries a build warning that the
committed report does not surface:

```
warning: RelativeConicArcs/ClebschMiddleExteriorSquare.lean:42:58: This simp argument is unused:
```

Line 42 column 58 is `eq_self_iff_true` in the `hodgeMatrix_sq` proof. Harmless, but a pinned
artifact that emits a warning on every replay is untidy, and the passages and four-shadow logs
are warning-free, so this is the one that stands out.

---

## 3. The one structural proof: `hodgeMatrix_sq`

**The proof is correct.** I worked it through by hand against the definitions in
`ClebschMiddleExterior.lean`, where `hodgeMatrix S T = if T = complementIndex S then -hodgeSign S else 0`.

After `ext S T` and `Matrix.mul_apply` the goal is `∑ U, hodgeMatrix S U * hodgeMatrix U T = (-(1)) S T`.

**`Finset.sum_eq_single` gets both side conditions discharged honestly.** Its signature is
`(a) (h₀ : ∀ b ∈ s, b ≠ a → f b = 0) (h₁ : a ∉ s → f a = 0) : ∑ x ∈ s, f x = f a`.

- `h₀` is `fun U _ hU => by simp [hodgeMatrix, hU]`. With `hU : U ≠ complementIndex S`, the
  first factor `hodgeMatrix S U` takes the `else` branch and is `0`, so the product is `0`.
  This is a genuine proof of the real side condition, not a `simp` that happens to close a
  restated goal.
- `h₁` is `by simp`. The hypothesis `complementIndex S ∉ Finset.univ` is refuted by
  `Finset.mem_univ`, so the implication holds vacuously. This is the honest discharge — the
  goal is an implication from a false premise, and `simp` closes it by that route, not by
  proving `f (complementIndex S) = 0`, which would be untrue.

The two branches are then both correct:

- `T = S`: after `subst`, the term is `hodgeMatrix T (complementIndex T) * hodgeMatrix (complementIndex T) T`.
  The first factor unfolds to `-hodgeSign T` (the `if` condition is reflexivity); the second
  needs `complementIndex (complementIndex T) = T`, which is exactly the supplied
  `complementIndex_involutive T`, and then unfolds to `-hodgeSign (complementIndex T)`. The
  right side is `-(1 T T) = -1`. `neg_mul_neg` turns the goal into
  `hodgeSign T * hodgeSign (complementIndex T) = -1`, which is the new lemma applied at `T`.
- `T ≠ S`: `hodgeMatrix (complementIndex S) T` unfolds, via the same involutivity rewrite, to
  `if T = S then … else 0`, and `if_neg h` gives `0`. `Matrix.one_apply_ne (Ne.symm h)` gives
  `0` on the right. Both sides are `0`.

**The new lemma's proof does what its docstring says — with one qualification.**
`hodgeSign_mul_complement` is `fin_cases S <;> rfl`: twenty goals, each closed by definitional
evaluation of two entries of the displayed twenty-vector `hodgeSign` and the displayed
`complementIndex`. The docstring says "The two concatenation signs of a triple and its
complement multiply to minus one", and that is what each of the twenty goals says. It is not
proved from a permutation-sign argument — nothing in the development connects `hodgeSign` to
`Equiv.Perm.sign` (see §8) — but the docstring does not claim it is.

The docstring's second clause, "which is the whole content of middle-degree Hodge
complementation squaring to minus the identity", overstates slightly: the involutivity of
`complementIndex` and the one-nonzero-per-row shape are also load-bearing, as the proof above
shows. Minor.

**The golden-return gate header's description is accurate, with one omission.** The header
says "the matrix carries one nonzero entry per row, so the product collapses to a single
term". By definition every row of `hodgeMatrix` is zero except at `complementIndex S`, where
the entry is `∓1` — I confirmed all twenty `hodgeSign` values are `±1` — so "one nonzero entry
per row" is exactly right, and "the product collapses to a single term" is a faithful
description of the `Finset.sum_eq_single` step. What the header does not say is that the
residual sign fact is itself a twenty-case `rfl`. The claim that the identity is "proved
structurally rather than decided" is therefore true of the 400-entry matrix product and only
partly true of the whole argument: the case count fell from 400 to 20, it did not fall to
zero. The `golden_return_formal.json` `native` field is better here — it names
`hodgeSign_mul_complement` explicitly — but it does not describe the lemma's method either.
This is a one-clause fix, not a false claim.

**I checked the mathematics under the literals independently.** In Python I enumerated the
twenty increasing triples of a six-element set in lexicographic order and confirmed they are
the list in `triple`; computed the complement map and confirmed it is the reversal `i ↦ 19-i`
that `complementIndex` displays; and computed the sign of the concatenation permutation
`(S, Sᶜ)` for each of the twenty labels and confirmed the result is the `hodgeSign` literal,
entry for entry. The identity `ε(S,Sᶜ)·ε(Sᶜ,S) = (-1)^{3·3} = -1` is the general fact
underneath the twenty cases, and it holds for all twenty. So the displayed data is faithful to
the mathematics it claims to encode; that fidelity is just not itself a Lean theorem.

---

## 4. The new enforcement: correct in direction, but four escapes remain, one of them fatal to the claim

**All three verifiers pass against the live Lean tree**, in `--source-only` mode with
`--lean-root ../../lean`: `passages formal replay: PASS`, `golden-return formal replay: PASS`,
`four-shadow formal replay: PASS`.

The three verifiers now carry an identical `mechanisms` regex. It bans `native_decide`,
`implemented_by`/`extern` in either the `@[…]` or the standalone `attribute […]` form,
`ofReduceBool`, and `set_option debug.skipKernelTC` / `allowUnsafeReducibility`; and the
`forbidden` regex now allows arbitrary attribute blocks and any of
`private|protected|noncomputable|nonrec|scoped|local` before `axiom|opaque|partial|unsafe`.
This is exactly what the previous referee's remaining-repair 1 asked for, and it works.

**Every escape the previous referee found is now closed.** Method: append the injection to a
pinned closure source of the gate under test, then perform a full coordinated re-pin — every
`sources[].sha256` and `bytes` in the closure inventory, the `source_sha256` map, and the
`axiom_report_sha256`, `source_closure_sha256`, `verifier_sha256` and
`axiom_report_provenance.gate_stdout_sha256` fields of the manifest — and run
`--source-only`. All work on a copy outside the repository.

| variant | passages | golden-return | four-shadow |
|---|---|---|---|
| `theorem evil : 2+2=4 := by native_decide` (the referee's T9) | refused | refused | refused |
| `attribute [implemented_by evilImpl] evilFn` | refused | refused | refused |
| `@[` newline `implemented_by evilImpl]` | refused | refused | refused |
| `Lean.ofReduceBool _ _ _` | refused | refused | refused |
| `private opaque evilOpaque : Nat` | refused | refused | refused |
| `private axiom evilAx : 2+2=5` | refused | refused | refused |
| `set_option debug.skipKernelTC true in …` | refused | refused | refused |
| `unsafe abbrev evilAb := 3` | refused | refused | refused |
| `noncomputable opaque evilO2 : Nat` | refused | refused | refused |
| `attribute [local implemented_by f] g` | refused | refused | refused |
| doc comment + `@[simp]` + `private` + newline + `axiom` | refused | refused | refused |
| indented `axiom` | refused | refused | refused |
| `set_option  debug.skipKernelTC  true` (double-spaced) | refused | refused | refused |
| `macro "nd" : tactic => \`(tactic\| native_decide)` | refused | refused | refused |
| `attribute` newline `[implemented_by f] g` | refused | refused | refused |
| `theorem evil : 2+2=5 := sorryAx _ _` | refused | refused | refused |
| `@[extern "c_evil"] opaque evilE : Nat` | refused | refused | refused |
| `@[simp, implemented_by f] def g2 …` | refused | refused | refused |
| `set_option maxRecDepth 40000` (benign control) | passes | passes | passes |

The benign control passing is the over-reach check: the policy does not refuse an ordinary
elaboration option, so it is not indiscriminately banning `set_option`.

**Four escape classes still get through, and the first one destroys the headline claim.**

### 4a. `decide +native` is `native_decide` under another name — **PASS on all three**

Lean 4.32's own documentation, in `Init/Tactics.lean` of the pinned toolchain
`leanprover/lean4:v4.32.0-rc1`, says it twice:

```
The instance is only evaluated once. The `native_decide` tactic is a synonym for `decide +native`.
...
`native_decide` is a synonym for `decide +native`.
```

`decide +native` produces exactly the same compiled-evaluation proof and exactly the same
`ofReduceBool` axiom. The `mechanisms` regex matches only the literal token `native_decide`, so
every one of these passes all three verifiers behind a full coordinated re-pin:

| spelling | passages | golden-return | four-shadow |
|---|---|---|---|
| `by decide +native` | **PASS** | **PASS** | **PASS** |
| `by decide  +native` (extra space) | **PASS** | **PASS** | **PASS** |
| `by decide +kernel +native` | **PASS** | **PASS** | **PASS** |
| `by decide (config := { native := true })` | **PASS** | **PASS** | **PASS** |

This is not a hypothetical bypass requiring ingenuity. It is the tactic's other official
spelling, documented in the very toolchain the manifest pins. The sentence the commit added to
three JSON fields and both gate headers — "The replay refuses compiled evaluation anywhere in
the pinned closure, so this is a checked property and not a declaration" — is **false as
stated**. What the replay refuses is one of the two spellings of compiled evaluation. The
claim that ought to be made is the one the axiom reports actually support: no audited terminal
depends on `Lean.ofReduceBool` or any other non-standard axiom. That is measured, true, and
robust; the source-policy sentence is neither necessary for it nor currently correct.

### 4b. Proof-eliding `set_option`s are unguarded — **PASS on all three**

The check covers `debug.skipKernelTC` and `allowUnsafeReducibility` but not the three other
registered options in this toolchain that replace proofs with `sorry`:

| variant | result |
|---|---|
| `set_option debug.byAsSorry true` | **PASS** on all three |
| `set_option debug.proofAsSorry true` | **PASS** on all three |
| `set_option debug.terminalTacticsAsSorry true` | **PASS** on all three |

These do leave `sorryAx` in `#print axioms`, so a live `--axiom-log` run would catch them. But
`--source-only` — the mode `verify_release.py` uses, and the mode a reader without a Lean build
must rely on — compares only pinned artifacts against each other, all of which a tamperer
performing a coordinated re-pin controls. In that mode the source policy is the entire defence,
and it does not cover these.

### 4c. A foreign-package import is followed by nobody — **PASS**

`extract_source_closure.py` sets `LOCAL_PREFIX = "RelativeConicArcs"` and follows only imports
under that namespace. `lean/` contains several other top-level libraries (`CapGame`,
`FiniteGeom`, `ProjectiveCap`, `Queens`, `NodeKayles`, …). I created
`lean/EvilPkg/Bad.lean` containing a `native_decide` theorem, added `import EvilPkg.Bad` to a
pinned passages closure source, and re-pinned. Result: `passages formal replay: PASS`.

Worse, this is not a re-pin trick. Running the shipped
`extract_source_closure.py --root RelativeConicArcs.Gates.ClebschPassages` **honestly** against
the tampered tree reports `15 modules` and does not list `EvilPkg/Bad.lean` at all. So the
generator itself would produce a closure inventory that omits a compiled-evaluation module the
gate genuinely depends on, and the verifier would then scan a closure that is not the closure.
The "transitive source closure" is really the transitive `RelativeConicArcs` closure, and
neither the inventory, the manifests, the README, nor the two gate headers say so.

### 4d. Scope note, not a defect

The `mechanisms` and `forbidden` regexes run only over the pinned local closure and never over
`Mathlib`. That is inherent to the design and correctly so.

### One over-reach worth naming

`workflow_prose` refuses any pinned source containing, case-insensitively, `TODO`, `FIXME`,
`pending`, `temporary`, `fallback`, `agent` or `lane`. Three of those are ordinary English —
a docstring writing "the pending obligation", "a temporary variable" or "the fallback branch"
would fail the gate for no soundness reason. It happens not to bite today. This is the one
place the enforcement is broader than its purpose, and it is cheap to narrow to comment-marker
forms.

---

## 5. Prose and metadata against the measurement

### What is now right

**The golden-return gate module header is accurate on all four conference facts.** This is the
defect the previous referee raised and it is genuinely closed. The header now says the
symmetry and square are "`Matrix.ext` followed by `decide` on each of the thirty-six index
pairs" — `conferenceMatrix_transpose` and `conferenceMatrix_sq` are both
`ext i j; fin_cases i <;> fin_cases j <;> decide`, and `Fin 6 × Fin 6` is thirty-six pairs. It
says the triangle signs are "one `decide` on the conjunction over the increasing triples" —
`conference_triangleSigns` is a bare `decide` on a conjunction, and I counted exactly twenty
`triangleSign conferenceMatrix` conjuncts. And it says translation invariance "is not finite at
all, holding for an arbitrary commutative ring, argument and shift" —
`conference_triangleCubic_translate` is `(R : Type*) [CommRing R] (x : Fin 6 → R) (u : R)` and
proceeds by `rcases conference_triangleSigns` and symbolic transport. All four descriptions now
match the sources.

**The passages gate header no longer claims what its own gate does not print.** The clause
that drew the previous objection is replaced by "The order-six conference matrix is
kernel-checked in `ClebschGoldenConference`", which is a locational statement about a file that
is in the passages gate's own pinned closure, so a reader can check it from the shipped
artifact. Acceptable.

**The second `AlignedTwoGraph` native source is now named.** The header says "the two aligned
two-graph classifiers over their 16,384 and eight cases". I confirmed
`pairSignature_classification` quantifies over `p s p' s' : Fin 8` and `e e' : Bool`, so
8⁴·2² = 16,384, and `anchorSignature_eq_false_iff_balanced` over one
`NormalizedCut`, which `AlignedTwoGraph.lean:215` defines as `abbrev NormalizedCut := Fin 8`,
so eight. Both counts correct, both classifiers named.

**Counts.** "four depend on no axiom at all" (passages header, passages `native`, both notes) —
measured 4. `trust_manifest.json`'s new `formal_coverage.boundary` sentence, "Every audited
terminal of all three gates depends only on propext, Classical.choice and Quot.sound; no
compiled evaluation is used anywhere in their pinned sources, and each replay refuses it" — the
first two clauses are measured true, and the third is the sentence §4a shows to be false.
The four-shadow `trust_boundary` (written in c990213b, not this commit) is accurate.

### What is wrong

**(D1) `golden_return_formal.json`'s OPER-1 `excluded` field is now flatly false, and the same
file contradicts it.** It still reads:

> "… the Hodge square, the middle-exterior square, its diagonal, its parity criterion, its
> common-neighbour counts and both degree-ten comparison claims are decided by the compiled
> evaluator rather than the kernel"

Not one of those seven is decided by the compiled evaluator any more; all seven are the
declarations this commit converted. Twenty-four lines below, the `native` field of the same
JSON object says "No compiled evaluation is used." This is a shipped release artifact
asserting and denying the same thing about the same seven declarations. It is the single
most serious bookkeeping defect in the commit.

It is also the exact field the previous referee flagged — for understating the carrier count by
one, `hodgeMatrix_sq`. That finding was never repaired; instead the commit made the whole
sentence untrue and left it. The remedy is to delete the clause from the semicolon onward,
leaving the two genuinely human exclusions that precede it.

**(D2) The "kernel reductions" description covers six proofs that are not reductions.** Both
rewritten headers and both rewritten `native` fields say the finite steps "are kernel
reductions". Six of the converted proofs are not:
`markedFixedVector_sum`, `sigmaThree_markedFixedVector`, `exchanger_reflection_norms`,
`reflectionE2_is_standardReflection`, `reflectionE2SubE3_is_standardReflection` are `norm_num`
with an explicit `Matrix.cons_val_*` simp set, and `exchanger_det` and
`degreeTenComparison_det` are `simp [Matrix.det_fin_three]` / `simp [Matrix.det_succ_row_zero]`.
These are rewriting procedures producing kernel-checked proof terms, not evaluations of a
`Decidable` instance. The passages `native` field is the worst offender: it says "the displayed
reflection matrices and the marked fixed vectors are checked entrywise", and the marked fixed
vectors are checked by rational arithmetic on a five-term sum, not entrywise. This is the same
failure mode the previous referee named — the counts are right and the method is misdescribed —
recurring in the two fields the commit rewrote. Milder than the previous instance, because the
misdescription understates rather than overstates the strength of the proof.

**(D3) One converted declaration is unaccounted for in every account of the conversion.**
`ClebschGoldenDescent.conference_mul_degreeTenComparison` was a golden-return carrier at the
parent commit and fell to `ext i j; fin_cases i <;> fin_cases j <;> decide`. The golden-return
header names only "the degree-ten comparison determinant by cofactor expansion"; the
golden-return `native` field says only "the degree-ten comparison by cofactor expansion"; and
the gap inventory's per-family account (§6) lists only the determinant. The intertwining
identity `C · D = D · Comp` is a second, differently proved claim and appears in none of them.
The previous referee found this same field short by one carrier; it is now short by one
conversion.

**(D4) The header's "proved structurally rather than decided" omits the twenty-case `rfl`.**
See §3. One clause.

---

## 6. Do the notes match?

`notes/2026-08-04-c815-paper-iii-gate-hardening-report.md` and
`notes/2026-08-03-c815-paper-iii-formalization-gap-inventory.md` were both rewritten. Almost
everything in them checks out. Three things do not.

### Verified correct

- Both tables' current columns: 50 / 28 / 19 terminals, 0 / 0 / 0 carriers. Measured.
- "every one depends only on `propext`, `Classical.choice` and `Quot.sound`, and four of the
  passages terminals depend on no axiom at all". Measured.
- "`native_decide` does not occur anywhere in any of the three pinned closures". Measured over
  all thirty-nine file-gate pairs.
- The "at task start" carrier column, 10 / 13 / 4. I recovered the state at the parent of the
  commit that created the gap inventory and parsed the three reports: 10, 13 and 4 carriers.
  Their sum is the twenty-seven the commit message claims, and 10 of them fell before this
  commit and 17 in it, which reconciles with the previous revision's "Ten of the twenty-seven
  carriers are cleared".
- **The Cauchy-Binet claim is fair.** The inventory says the twenty row lemmas "were expected to
  need a formalized Cauchy-Binet theorem, since Mathlib has no compound-matrix multiplicativity
  and the identity `K = 125 I` follows structurally from `C = 5 I` only through it. They
  kernel-decide as they stand." The mathematical claim is right: the middle-exterior matrix is
  the third compound of the conference matrix (`ClebschMiddleExterior.lean` builds it from
  `minorThree`/`detThree`), so `K² = (C²)^{(3)} = (5I)^{(3)} = 125 I` needs
  `(AB)^{(k)} = A^{(k)}B^{(k)}`, which is Cauchy–Binet and is absent from Mathlib. And no such
  theorem is used: the twenty lemmas are `decide +revert`, exactly as stated.
- **The per-family account of how each carrier fell is accurate**, with one omission (D3
  above). I reconstructed the parent commit's carrier inventory declaration by declaration and
  matched it against the four bullets. The families are right, including the subtle one: "which
  also cleared the seven-signature injectivity that inherited from it" — at the parent,
  `normalizedSevenSignature_injective` carried no native axiom of its own, only
  `pairSignature_classification`'s, so converting the classifier did clear it. That is a real
  inherited-carrier observation, not a guess.
- The Hodge bullet, "The matrix carries a single nonzero entry per row, at the complementary
  label, so the product collapses to one term and the entire content is that a triple's two
  concatenation signs multiply to minus one … `hodgeMatrix_sq` is a four-line argument from it
  and the involution." Accurate, modulo D4; the proof body after the `rw` is four lines.

### Wrong

**(D5) "10 of 43" is not a measured figure; the passages gate was never 43.** Both notes carry
it — `2026-08-04-c815-paper-iii-gate-hardening-report.md` line 19 and
`2026-08-03-c815-paper-iii-formalization-gap-inventory.md` lines 35, 55 and 119. I walked the
committed history of `passages_axioms.txt` and parsed every revision:

| commit | passages terminals |
|---|---|
| `b651e126` | 33 |
| `27ac009e` | 34 |
| `0ac4899c` | 47 |
| `a1a9bc07` | 50 |
| `b6fc9694` | 50 |

At the task-start commit the report has **47** terminals, not 43. The number 43 corresponds to
no committed state. It is also load-bearing for a sentence the previous referee explicitly
approved — "went from forty-three audited terminals to fifty, which is the transition actually
visible in git" — so this is a figure that has now survived two referee passes unmeasured. The
transition visible in git is 47 → 50.

**(D6) Two timings are asserted with no tracked evidence.** The inventory says the 16,384-case
classifier decides "in seventeen seconds" and the row lemmas at "five rows in fifteen seconds";
the hardening report repeats the latter. The three tracked gate stdout logs carry no per-module
timing for `AlignedTwoGraph` or any `…SquareRows…` module — the only timings in them are the
final gate lines (`Built RelativeConicArcs.Gates.ClebschPassages (271s)`,
`Built RelativeConicArcs.Gates.FourShadowRecognition (867ms)`) and `Replayed` lines with none.
The repository's reproducibility convention says a claimed run is never sole evidence. These
are minor performance figures, not paper-facing results, but they should be sourced or dropped.

**(D7) The rewrite deleted a still-true hygiene paragraph.** The inventory previously ended the
section with "The three axiom reports are regenerated by `extract_axiom_report.py` and the
three closure inventories by `extract_source_closure.py`; neither file may be edited by hand,
because the verifiers compare them byte for byte." That instruction is still correct and is now
recorded nowhere in the note. The `verification/README.md` covers regeneration, so this is a
loss of redundancy rather than of information.

The previous referee's two note defects are both closed: the four-shadow terminal count reads
19 everywhere, and the stale build run id `run-20260804-040512-9965a2e4` is gone (the paragraph
carrying it was removed, and the manifests now carry provenance themselves).

---

## 7. What regressed

I re-checked the whole artifact set for internal consistency: Lean prose against JSON, JSON
against JSON, notes against measurement, claim maps against audited declarations, provenance
pins against the tracked logs, and the earlier referees' closed items against the current tree.

**Nothing regressed in soundness.** Every hash pin is correct, every declaration set matches
its report, every axiom report replays byte-identically from its tracked log,
`extract_statement_identity.py --check` returns `CHECK OK`, `verify_scaffold.py` returns
`OK (10 sections, 9 claims; certified=4, literature-backed=1, proven=4)`, all fifty-two
`release_files.json` entries exist, and `verify_release.py --lean-root ../../lean` returns
`ALL CHECKS PASS` after passing all three Lean gates by name. The previous referee's closed
items stayed closed: `gate_stdout_sha256` is now enforced by all three verifiers (their
remaining-repair 8); the claim maps are complete in all three gates — passages 50 mapped with
two deliberate dual assignments, golden-return 28, four-shadow 19, none unmapped and none
assigned outside its own gate (remaining-repair 9); the four-shadow gate is documented and
`verify_scaffold.py` knows about it; and the release banner names the four-shadow gate.

**Two documentation regressions were created by this commit**, both in shipped release
artifacts, both by the same mechanism: prose describing the old measurement was left in place.

**(D8) `papers/clebsch-passages/verification/README.md` makes three claims that are now false.**
It ships — it is in `release_files.json` — and it was last touched by c990213b, so this commit
did not revisit it.

- Line 88, of the passages gate: "For aligned designs it checks the two-cut classifier **by
  native decision**". Both classifiers are now `decide`.
- Lines 128–129, of the golden-return gate: "`golden_return_axioms.txt` records the complete
  pinned `#print axioms` output, **including each native-decision terminal**". There are none.
- Line 148, of the four-shadow gate: "**Alone among the three gates** it claims no compiled
  evaluation at all". All three now do, which is the commit's entire point.

**(D1, restated)** `golden_return_formal.json`'s OPER-1 `excluded` field, §5 above. Same
mechanism, more serious, because it is a self-contradiction inside one JSON object rather than
a stale sentence in a prose file.

**One workspace-level inconsistency, noted rather than charged.** Twenty-four gate fact files
are tracked under `lean/trust/facts/`, covering the AME–LU, cap-game, projective-cap and
MDS–CSS gates. None of the three Paper III gates appears there, so the shared trust spine does
not know that Paper III has kernel-only gates at all. Papers I, II and IV declare theirs. This
predates the commit and may be out of the `clebsch` lane's scope, but it is the kind of thing a
reader comparing the three papers' formal artifacts would notice.

---

## 8. What a referee would still object to, including the mathematics

**(D9) The displayed combinatorial data is not connected to its stated meaning by any Lean
statement.** This is the structural weakness that a decide-heavy artifact carries, and it is
sharper now that everything is decided. Three definitions in `ClebschMiddleExterior.lean` are
displayed literals whose docstrings assert an interpretation nothing proves:

- `triple` is a list of twenty triples said to be "the increasing triples of `Fin 6`, in
  lexicographic order". No lemma says it is injective, that its values are increasing, or that
  its image is all twenty three-subsets.
- `complementIndex` is the reversal `![19, 18, …, 0]`, said to be "complementation on the
  lexicographically ordered triple basis". `complementIndex_involutive` is proved; nothing
  proves `tripleSet (complementIndex S) = (tripleSet S)ᶜ`, which is what the name means.
- `hodgeSign` is a twenty-vector of `±1` said to be the "sign of the permutation obtained by
  concatenating a triple with its increasing complement". Nothing connects it to
  `Equiv.Perm.sign`.

I verified all three externally in Python and all three are correct, so this is a
disclosure gap and not an error. But `hodgeMatrix_sq`, the one proof this commit promotes as
structural, rests on `hodgeSign_mul_complement`, which rests entirely on the third of these.
The general fact `ε(S,Sᶜ)·ε(Sᶜ,S) = (-1)^{3·3} = -1` is available with no case analysis once
`hodgeSign` is known to be a permutation sign, and it would make the proof genuinely structural
rather than twenty-cases-plus-structure.

The comparable definitions elsewhere are better handled and show the standard is achievable:
`detThree_eq_det` proves the hand-written 3×3 determinant formula equals `Matrix.det`;
`middleExterior_eq_hodge_mul_compound` proves the operator factors as
`hodgeMatrix * compoundThree conferenceMatrix`; and the conference matrix's defining properties
(`C = Cᵀ`, `C² = 5I`) are theorems rather than assertions. Only the triple-basis indexing is
left as displayed data.

**(D10) The structural story for `middleExterior_sq` is still not formalized, and the notes are
right to say so.** `K = 125 I` follows conceptually from `C² = 5I` through compound
multiplicativity (Cauchy–Binet), and that route is absent — the twenty rows are decided. The
gap inventory states this plainly, which is to its credit; the golden-return gate header does
not, saying only that "the middle-exterior return is decided row by row". A reader of the gate
alone learns the fact is checked but not that the paper's stated mechanism for it is not.

**(D11) Replay cost.** The passages gate now builds in 271 s according to its tracked log, with
a 16,384-case and a twenty-row kernel decision inside it. Moving from compiled evaluation to
kernel decision is the right trade, but the artifact should say what a replay now costs; nothing
in the README, the manifests or the headers gives a figure, and the two timings the notes do
give are unsourced (D6).

---

## What the TeX owner must change

`papers/clebsch-passages/sections/08-verification.tex` is unchanged and the author is forbidden
to edit it. Precisely:

1. **Line 42, the Ramsey clause, is false and must go.** "The classical Ramsey input
   \(R(3,3)=6\) … remain human combinatorial steps." Both bounds are audited passages terminals
   with clean bases: `AlignedTwoGraph.exists_monochromatic_triple` on
   `[propext, Classical.choice, Quot.sound]` and `AlignedTwoGraph.no_monochromatic_triple_five`
   on `[propext]`. Delete the Ramsey clause and keep the other two in the same sentence — the
   finite-set extension to seven vertices and the passage from arbitrary labels to normalized
   cut coordinates are both genuinely still human. This was false before this commit and is
   unchanged by it.
2. **Add the obligation that is genuinely still human**, so the correction does not over-swing:
   the distinctness of the six anchor points and their separation from the root.
   `exists_alignedAnchor` takes an arbitrary `v : Fin 6 → α` with neither hypothesis.
3. **Line 35 must not be touched.** "The unrestricted inclusion-rank and Ramsey exclusion is a
   human proof" is the higher-order exclusion and remains correct.
4. **Line 52's singular is wrong.** "A paper-specific Lean gate now proves …" — there are
   three, all shipped. Make it plural.
5. **The compiled-evaluation disclosure the previous referee demanded is no longer needed.**
   This is the one place where this commit changes the TeX owner's obligations. Section 08 never
   mentioned compiled evaluation; before this commit that was a nondisclosure of seventeen
   audited terminals depending on a `native_decide` axiom outside the kernel, and the previous
   referee correctly required one sentence. There is now nothing to disclose, so the section's
   silence has become accurate. **Withdraw that repair.** What the owner may now do instead —
   an upgrade, not an obligation — is state the positive fact: every audited terminal of all
   three gates depends only on `propext`, `Classical.choice` and `Quot.sound`. If that sentence
   is added it must not also claim the replay enforces the absence of compiled evaluation, for
   the reason in §4a.

**No statement in section 08 became false as a result of this commit**, and one — its silence
about compiled evaluation — became correct.

---

## Grades

| area | subject | grade |
|---|---|---|
| 1 | the zero-native claim itself | **VERIFIED** — every count and every axiom base independently reproduced |
| 2 | statement identity across the conversion | **CLEAN** — no statement changed in any way |
| 3 | the `hodgeMatrix_sq` structural proof | **CORRECT** — side conditions honestly discharged; one clause of its description is incomplete |
| 4 | the new enforcement | **FAILS ITS OWN CLAIM** — `decide +native`, three proof-eliding `set_option`s, and foreign-package imports all pass a full coordinated re-pin |
| 5 | prose and metadata | **PARTIAL** — headers now correct on the previously misdescribed methods, but one shipped field asserts the opposite of the measurement |
| 6 | the two notes | **PARTIAL** — the substance including the Cauchy–Binet account is right; one figure is unmeasured and two timings unsourced |
| 7 | regressions | **TWO**, both documentation, both in shipped artifacts |
| 8 | mathematics | **SOUND**, with an undisclosed definitional-fidelity gap in the triple-basis data |

## Verdict: **ACCEPT WITH REPAIRS**

The headline claim is true and I verified it independently rather than reading it. Fifty,
twenty-eight and nineteen audited terminals, every one on `propext`, `Classical.choice` and
`Quot.sound` or a subset, four on nothing at all, zero occurrences of `native_decide` across
all thirty-nine pinned closure files, all three reports replaying byte-for-byte from tracked
build logs, and not one theorem statement touched in the process. Twenty-seven carriers across
the task, seventeen of them in this commit, converted without weakening a single claim — that
is a real result, and the prediction it settles was recorded in advance in a committed mystery
ledger, which is the correct way to have made it. The `hodgeMatrix_sq` proof is correct and its
`Finset.sum_eq_single` side conditions are discharged honestly, not papered over. The two gate
headers now describe the four conference facts correctly, which is the previous referee's
sharpest open finding closed.

What holds this back is that the commit's *secondary* claim — that the replay now enforces the
property rather than declaring it — is not true, and the commit put that sentence in five
places. `decide +native` is the pinned toolchain's own documented synonym for `native_decide`,
and it walks past all three verifiers behind a full coordinated re-pin, as do three registered
`set_option`s that replace proofs with `sorry` and any import of a module outside the
`RelativeConicArcs` namespace. The enforcement is worth having and is much better than it was;
it is not the closed property the artifact says it is. Separately, the commit left a shipped
JSON field asserting that seven of the very declarations it converted "are decided by the
compiled evaluator rather than the kernel", twenty-four lines above a field saying no compiled
evaluation is used, and left three sentences in the shipped README describing the old state.
None of these makes a false mathematical claim. All of them make the artifact say something
that is not so.

### Remaining repairs, in priority order

1. **Delete the false clause in `golden_return_formal.json`'s OPER-1 `excluded`** (D1) — the
   text from "; the Hodge square" to "rather than the kernel". Re-pin the manifest hash. This is
   a release artifact currently contradicting itself.
2. **Close the compiled-evaluation escape or stop claiming enforcement** (D4a). Minimum:
   extend `mechanisms` to `native_decide|decide[^\n]*\+\s*native|native\s*:=\s*true`, and add
   `debug.byAsSorry`, `debug.proofAsSorry` and `debug.terminalTacticsAsSorry` to the
   `set_option` alternation. Then either teach `extract_source_closure.py` to fail on an import
   outside `RelativeConicArcs` (the safe direction, since it cannot follow it) or say in the
   inventory and both headers that the closure is the transitive `RelativeConicArcs` closure
   only. Re-run the battery in §4. If any of this is not done, weaken the five sentences that
   claim the replay "refuses compiled evaluation anywhere in the pinned closure" to what is
   measured: no audited terminal depends on `Lean.ofReduceBool` or any non-standard axiom.
3. **Fix the three stale sentences in `verification/README.md`** (D8): the passages two-cut
   classifier is no longer "by native decision", the golden-return report has no
   "native-decision terminal", and four-shadow is no longer "alone among the three gates".
4. **Correct "10 of 43" to "10 of 47" in both notes** (D5), in all four places.
5. **Fix the method descriptions** (D2, D3, D4): say that six of the finite steps are `norm_num`
   or cofactor `simp` rather than kernel reductions; name
   `conference_mul_degreeTenComparison` alongside the determinant in the header, the `native`
   field and the gap inventory; and add to the golden-return header that
   `hodgeSign_mul_complement` is itself a twenty-case `rfl`.
6. **Source or drop the two timings** (D6), and record what a replay of the passages gate now
   costs (D11).
7. **Remove the unused `eq_self_iff_true`** from `ClebschMiddleExteriorSquare.lean` line 42 so
   the golden-return gate replays warning-free like the other two; re-pin.
8. **Narrow `workflow_prose`** so `pending`, `temporary` and `fallback` are not refused as
   ordinary English in a Lean docstring.
9. **Consider proving the triple-basis fidelity lemmas** (D9) — `tripleSet ∘ complementIndex`
   is set complement, and `hodgeSign` is the concatenation permutation sign — which would make
   `hodgeSign_mul_complement` a one-line consequence of `(-1)^{3·3}` and make the "structural"
   description literally true. Alternatively disclose in the gate header that the triple basis,
   its complement map and its signs are displayed data.
10. **Hand the TeX owner the five items above**, noting that item 5 is a *withdrawal* of the
    previous referee's disclosure requirement.
