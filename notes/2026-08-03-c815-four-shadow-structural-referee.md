# Referee report: structural pentagon replacement for the four-shadow orientation classifier

**Lane:** `clebsch`
**Date:** 2026-08-03
**Task:** C815

## Verdict

**ACCEPT WITH REPAIRS.** The mathematics is correct and exhaustive, the public API is
byte-identical, and the compiled-evaluation step is genuinely gone. The repairs are (a) the
paper-local trust metadata, which is now stale and would fail its own replay verifier, (b) a
missing gate elaboration, and (c) three prose statements that overclaim relative to what the
declarations prove.

Independent checks performed for this report (source-level reasoning plus an external
recomputation, no Lean build):

- The five balance equations `r1…r5` in the ten edge signs have exactly twelve `±1` solutions,
  and that solution set equals, as a set, the twelve ten-fold conjunctions listed in
  `pentagon_bit_classification` (FourShadowRecognition.lean:695-718). No balanced signing escapes
  the list, and the list contains no spurious entry.
- For each of the twelve, with the scalar chosen by the corresponding branch of
  `cubicsProportional_orientation_of_firstRowBalanced` (lines 768-875): the Pfaffian of the bracket
  matrix minus `mu * triangleCubic` is identically zero as a polynomial in `x₀…x₅`; the matrix
  squares to `5I`; and `shadowCoefficient012 = mu * triangleSign … 0 1 2`. Six branches take `4`
  and six take `-4`, matching the frozen human theorem's 6/6 split.
- The twelve patterns and their orientation assignments coincide exactly with the twelve codes and
  the two six-element fibres that the removed `native_decide` classifier returned
  (`PositiveSixTestCode` / `NegativeSixTestCode` at 57cb3e86^:653-675). The new proof reproduces
  the old computed answer, it does not silently change it.
- `pairMoment_add_one_eq_zero_of_signBalances` (line 400) is true as an integer statement over all
  `±1` ten-tuples satisfying its five hypotheses.
- In all ten instantiations inside `five_sign_balances_force_inner_products` (lines 470-499) the
  substituted conclusion is exactly the stated conjunct, and each of the five substituted
  hypotheses lies in the linear span of `r1…r5` over ℚ, so the `by linarith` placeholders are
  discharageable.

## Findings

### 1. Trust metadata is stale and the verifier would now fail (must fix)

`papers/clebsch-passages/verification/four_shadow_formal.json` had its prose updated by the
follow-on commit 1e9f6bda, but none of its hashes were. `verify_four_shadow_lean.py:70-97` compares
all of them, so the recorded replay no longer passes:

- `source_sha256["RelativeConicArcs/FourShadowRecognition.lean"]` is
  `77fc5459958eb377e1c3110ee0f36c593cc083a86112d4510fc0002a6d75dae9`; the file is now
  `b4d7c1706399dab1a89f51d3390f8b0972875b74cdad7dbd748b4a37a4eb782e`.
- `source_sha256["RelativeConicArcs/Gates/FourShadowRecognition.lean"]` is
  `ef1825b3d36b1f90b85349dad0ced74b6606693ab47a77b21d4e4260f6c93a27`; the file is now
  `f20d03f793169d259d150345b822c700c63cbe7d5af0ce5b352bb5c60b47b26b`.
- `four_shadow_axioms.txt` still records
  `RelativeConicArcs.FourShadowRecognition.sixTestCode_classification_of_balanced._native.native_decide.ax_1_6✝`
  on `cubicsProportional_four_of_sixTests`, `cubicsProportional_neg_four_of_sixTests`,
  `exists_nonzero_cubicsProportional_iff_conferenceSquare` and
  `exists_nonzero_cubicsProportional_smul_iff_conferenceSquare`. That declaration no longer exists.
- `axiom_report_sha256` (`68a19380…`) matches the stale axiom report, and
  `source_closure_sha256` (`d7c0d0ed…`) matches the stale closure inventory.

The json's `trust_boundary.native` and `trust_boundary.symbolic` sentences already describe the new
structural proof correctly and need no further edit.

### 2. The gate build and the real axiom audit were not run (must fix)

The author's own record states that only `guarded-lean` single-file elaboration was run, against
last-built dependencies, and that the gate build of `RelativeConicArcs.Gates.FourShadowRecognition`
under the unattended queue "was not run." Everything in Finding 1 therefore rests on a smoke test.
`four_shadow_axioms.txt` must be regenerated from the actual gate stdout, not hand-edited: the
verifier compares the recorded report against a live `--axiom-log` byte for byte
(verify_four_shadow_lean.py:113-116).

The claim that no compiled evaluation survives is nevertheless well supported by the source.
`native_decide` appears in the import closure only in ClebschGoldenConference.lean:39, 52, 141, all
three about the fixed `conferenceMatrix`; FourShadowRecognition uses only
`pairTriangleSum_eq_mul_mulApply`, `pairTriangleSum_eq_zero`, `matchingEvaluation_translate`,
`pfaffianSix_bracketMatrix_eq_matchingEvaluation` and the plain definitions, all symbolic. The
pre-change axiom report already showed every declaration other than the four classifier consumers
at `[propext, Classical.choice, Quot.sound]`, which confirms those three native facts are outside
the gate's closure.

### 3. Module header overstates what is proved (should fix)

FourShadowRecognition.lean:30-33 says "the five equations have exactly twelve solutions, one for
each labelled pentagon." `pentagon_bit_classification` proves only the forward inclusion: a
balanced signing is one of the twelve. Neither it nor any other declaration proves that all twelve
are balanced, so "exactly twelve" is not witnessed by a type. (It is true — I checked externally —
but the header must not imply a theorem Lean does not check.) Either add the trivial converse
(twelve `by decide` checks of `r1…r5` on the listed patterns, which would also justify the name
`pentagon_bit_classification` under the strength-bearing-name rule) or weaken the sentence to "every
solution of the five equations is one of the twelve listed labelled pentagons."

The same header sentence, and the `PentagonGauge` docstring at lines 525-529, assert "two-regular,
hence a pentagon." No pentagon object exists in the formalization; `PentagonGauge` is a
degree-two predicate. That reading is fine as mathematical orientation but should not be phrased as
part of the chain of things established here.

### 4. "The only finite search in the module" is false (should fix)

FourShadowRecognition.lean:38 claims the `6 × 64` split is "the only finite search in the module."
It is not:

- `pentagonGauge_of_firstRowBalanced` (lines 556-597) runs a sixteen-way Boolean split at each of
  the five non-root vertices and closes each leaf with `decide` after simping through
  `pairTriangleSum`, `triangleSign` and `normalizedSignMatrix` — eighty leaves that do carry matrix
  arithmetic, contradicting "carrying no matrix arithmetic" in the same sentence.
- `triangleMixedDifference_eq_pairCoefficientTable` (lines 169-208) discharges sixty `Fin 6`
  disequalities by `decide`.
- `four_bool_sum_zero_cases` (line 543) is itself sixteen `decide` leaves.

None of these is expensive or fragile, but the header sentence should say that the `6 × 64` split is
the largest finite case analysis, and the "no matrix arithmetic" qualifier should be attached to
that step alone.

### 5. Residual finite work is small, but it is not all `decide` (minor)

The docstring of `pentagon_bit_classification` (lines 686-687) and the json's `trust_boundary.native`
sentence both say the `2^6` residue "is checked by kernel reduction." The actual closing tactic is
`first | omega | simp` (lines 724-726): `omega` refutes the 372 inconsistent assignments by a
linear-arithmetic certificate and `simp` closes the twelve surviving goals by rewriting. Both
produce ordinary kernel-checked proof terms, so the trust claim is sound, but "kernel reduction"
names the wrong mechanism. Say "kernel-checked case analysis" or name the tactics.

The residual finite search, stated exactly: after the sign lemma fixes the four edges at vertex 1 to
one of six two-positive patterns, the search ranges over the remaining six Boolean edge parameters
`b4…b9`, i.e. `6 × 64 = 384` assignments of the ten edge signs, each tested against the four
remaining balance equations as integer literals. No matrix, cubic, or polynomial arithmetic occurs
inside that search. This is comfortably within kernel budget and is not fragile.

### 6. Docstring of `pairMoment_add_one_eq_zero_of_signBalances` misdescribes two of its own hypotheses (should fix; pre-existing)

Lines 390-393 say `h`, `i`, `j` are indexed so that they "avoid `b, e`, then `c, f`, then `d, g`
respectively." The hypotheses say the opposite for `h` and `j`: `hst : j = a + b + e` (line 406)
pairs `j` with `b, e`, and `hrs : h = a + d + g` pairs `h` with `d, g`. Only `i` matches the
docstring. With the edge order used at the call site, `h`, `i`, `j` are the edges `34`, `35`, `45`,
so the correct sentence is that `h`, `i`, `j` avoid `d, g`, then `c, f`, then `b, e` respectively.
This region is untouched by the commit, but the review gate forbids grandfathering docstrings in a
touched module.

### 7. API preservation: clean

Mechanical comparison of every non-`private` declaration's signature block, old file against new:
no public declaration removed, added, renamed, or altered. All twenty-seven public signatures are
character-identical, so no hypothesis was added and no quantifier narrowed. Everything removed
(`sixTestCode_classification_of_balanced`, `six_test_code_classification`,
`positive_six_test_codes`, `negative_six_test_codes`, `PositiveSixTestCode`, `NegativeSixTestCode`,
the twelve `cubicsProportional_*Pentagon_*` lemmas, `four_bool_signs_sum_zero_positive_count`) was
`private`. The gate's sixteen `#print axioms` targets are unchanged.

### 8. Statements stronger than the frozen human theorem (wanted, recorded)

- `exists_scalar_mul_self_of_offDiagonal_zero` (line 334) assumes neither symmetry nor a vanishing
  diagonal; only that every off-diagonal entry of `C` is nonzero and every off-diagonal entry of
  `C * C` vanishes. The human Theorem B carries symmetry and zero diagonal throughout.
- The whole converse chain is over an arbitrary commutative integral domain, and
  `matchingEvaluation_smul`, `triangleCubic_smul`, `cubicTerm_mixedDifference`,
  `triangleMixedDifference_eq_pairTriangleSum`, `triangleCubic_coordinateBump_eq_zero`,
  `triangleCubic_pairBump_eq_zero`, `pairTriangleSum_eq_zero_of_triangleCubic_translate` and
  `matrix_eq_diagonal_of_offDiagonal_zero` carry `omit [IsDomain R]`, so they hold over an arbitrary
  commutative ring. The human theorem is stated over a field.
- `pairTriangleSum_eq_zero_of_triangleCubic_translate` (line 270) takes translation invariance of
  the triangle cubic as a hypothesis instead of deriving it from proportionality, so it covers every
  symmetric zero-diagonal matrix with translation-invariant triangle cubic.
- `triangleMixedDifference_eq_pairTriangleSum` (line 218) needs only symmetry and zero diagonal, for
  every ordered pair of distinct labels.
- `cubicsProportional_smul_iff` (line 82) is an equivalence for every nonzero scalar of the domain.
- `pentagon_bit_classification` is matrix-free: it is a statement about two-regular graphs on five
  labelled vertices. Note that, unlike the author's report claims, it is `private` and therefore not
  reusable outside the module as it stands.

### 9. No conflict with the manuscript or the frozen theorem

`papers/clebsch-passages` contains no prose about the four-shadow trust boundary; the only record is
the verification json of Finding 1, and its sentences already match. Theorem
`thm:operator-shadows` in sections/05-golden-operator.tex:442-454 says that after fixing a vertex
the *negative* edges on the other five form a pentagon, whereas `PentagonGauge` and the frozen note
use the *positive* edges. Both are correct and complementary: each non-root vertex has two positive
and two negative edges among the other four, so the positive and negative graphs are complementary
pentagons. Nothing needs changing, but the two conventions should not be conflated in future prose.

The change strictly strengthens the trust boundary and reproduces the previously computed answer;
nothing in the frozen human theorem is weakened.

### 10. Minor: public declarations outside the audit (pre-existing)

`matchingEvaluation_smul`, `triangleCubic_smul` and `mul_self_apply_eq_zero_of_pairBalance` are
public but appear in neither the gate's `#print axioms` list nor `audited_declarations`. Harmless
here since all three are now trivially in the same axiom class, but worth folding into the audit
when the gate is next rerun.

## Required follow-on metadata edits

All under `papers/clebsch-passages/verification/`, to be done in the same build window as the gate
run, atomically:

1. Run the gate `RelativeConicArcs.Gates.FourShadowRecognition` through the unattended queue and
   capture its stdout.
2. Replace `four_shadow_axioms.txt` with that stdout. The four affected lines must become
   `depends on axioms: [propext, Classical.choice, Quot.sound]`, dropping
   `…sixTestCode_classification_of_balanced._native.native_decide.ax_1_6✝`. Do not hand-edit; the
   verifier compares the file against a live log.
3. In `four_shadow_source_closure.json`, update the `sources` entries for
   `RelativeConicArcs/FourShadowRecognition.lean` (sha256 →
   `b4d7c1706399dab1a89f51d3390f8b0972875b74cdad7dbd748b4a37a4eb782e`, bytes → `46075`) and
   `RelativeConicArcs/Gates/FourShadowRecognition.lean` (sha256 →
   `f20d03f793169d259d150345b822c700c63cbe7d5af0ce5b352bb5c60b47b26b`, bytes → `2777`), through its
   generator rather than by hand. All five other module hashes are current and must not change.
4. In `four_shadow_formal.json`: set the same two `source_sha256` values; set
   `axiom_report_sha256` to the sha256 of the regenerated `four_shadow_axioms.txt`; set
   `source_closure_sha256` to the sha256 of the regenerated `four_shadow_source_closure.json`.
   Leave `lean_toolchain`, `verifier_sha256`, `gate_module`, `schema`, `audited_declarations`,
   `claim_map`, `trust_boundary.excluded`, `trust_boundary.native` and `trust_boundary.symbolic`
   unchanged.
5. Rerun `verify_four_shadow_lean.py --lean-root … --axiom-log …` and record the PASS.
6. `trust_manifest.json` carries no four-shadow-specific field and needs no edit.
