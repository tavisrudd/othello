# Middle-degree Hodge complementation made structural, and the manuscript prose it touches

**Lane:** `clebsch`
**Date:** 2026-08-04
**Task:** C815 (continuing), feeding C800/C816

## What was displayed data before

`RelativeConicArcs.ClebschMiddleExterior` carried two tables on the
lexicographically ordered basis of increasing three-subsets of six labels:

- `complementIndex : Fin 20 → Fin 20`, written out as `![19, 18, …, 0]`;
- `hodgeSign : Fin 20 → ℤ`, written out as twenty signs.

Everything downstream — `hodgeSign_mul_complement`, `hodgeSign_complement`,
`hodgeMatrix_complement_entry`, `complementIndex_involutive` — was a
twenty-case `rfl` or `fin_cases` on those tables. The docstrings said so, and
the golden-return gate header disclosed it: the Hodge square was called
"structural" because the matrix has one nonzero entry per row, but the sign it
collapses to was checked label by label. The names `complementIndex` and
`hodgeSign` asserted meanings that Lean nowhere verified.

## What is proved now

Both names are now earned, and the sign identity is a parity computation.

*Complementation is set complement.* `tripleSet_complementIndex` proves
`tripleSet (complementIndex S) = (tripleSet S)ᶜ`, and `tripleSet_injective`
upgrades it to the characterization `eq_complementIndex_iff`:

```
T = complementIndex S ↔ tripleSet T = (tripleSet S)ᶜ
```

So the table records complementation rather than choosing a pairing.
`complementIndex_involutive` is now derived from that characterization and
`compl_compl`, not from twenty reflexivity checks, and it moved from
`ClebschMiddleExteriorSupport` to `ClebschMiddleExterior` alongside the
definition it is about.

*The sign table is the concatenation permutation's sign.* `concatenation S`
is the map of the six positions sending `0, 1, 2` to the increasing labels of
`S` and `3, 4, 5` to the increasing labels of its complement;
`concatenation_injective` and `concatenation_bijective` make it a permutation.
`concatenationInversions S` counts its inversions, and

```
hodgeSign_eq_neg_one_pow_inversions : hodgeSign S = (-1) ^ concatenationInversions S
```

is the identification the name always claimed. Minus one to the inversion
count is the sign of a permutation, so this is that sign.

*The Hodge lemma is now a parity computation.* Two further identities carry
it: `concatenationInversions_add_three` (the inversion count is three less
than the sum of the triple's labels, because the label `triple S k` exceeds
exactly `triple S k − k` of the complementary labels) and
`tripleSum_add_tripleSum_complementIndex` (complementary triples partition the
six labels, so their label sums add to `0+1+2+3+4+5 = 15`). Together they give
`hodgeSign S = (-1)^(tripleSum S + 1)`, whence

```
hodgeSign S * hodgeSign (complementIndex S) = (-1)^17 = -1.
```

That is the whole content of middle-degree Hodge complementation squaring to
minus the identity, and it is now four rewrites rather than a table.
`hodgeSign_complement` and `hodgeMatrix_complement_entry` are derived from it
by ordinary algebra instead of twenty cases.

Six statements remain kernel decisions, and they are about the *basis tables
themselves* rather than about the Hodge square: that distinct labels have
distinct subsets, over the four hundred ordered pairs of labels; that the
concatenation map is injective, over the seven hundred and twenty
label-position-pair triples; and, over the twenty labels, that the index table
is set complement, that the sign table is the inversion sign, that the
inversion count is the label sum less three, and that complementary label sums
are fifteen.

The exhaustive checking did not go away — it moved down a level and changed
subject. What genuinely improved is that each of the four twenty-case
statements is now something a reader can verify directly from the displayed
tables by a two-line argument, instead of an opaque list of twenty signs, and
that the Hodge square itself is no longer among them. That is the sense in
which "structural" is now closer to literally true; it is not the claim that
nothing is checked case by case.

Two limits of the strengthening should be stated plainly. First, the
identification of "minus one to the inversion count" with a library
permutation-sign function is not formalized: it is used as ambient convention,
and the module, the `hodgeSign` docstring, and the gate header all say so.
Formalizing it is the stronger form of the referee's suggestion and remains
open — the route is `Equiv.ofBijective` on the concatenation map, which is
what `concatenation_bijective` exists for, together with a reusable lemma
relating `Equiv.Perm.sign` to an inversion count via Mathlib's `signAux`, whose
definition is already a product over ordered pairs. Note that `decide` cannot
close that equation, because `Equiv.ofBijective` routes through
`Function.surjInv` and is noncomputable. Second, `triple` itself remains
displayed data: nothing yet proves each of its rows is increasing, that each
`tripleSet` has three elements, or that the twenty labels exhaust the
three-subsets, and increasingness is the tacit hypothesis of the whole
inversion argument. A `triple_strictMono` decision would close the first and,
with injectivity and cardinality three, the rest.

## Files changed

| file | change |
|---|---|
| `lean/RelativeConicArcs/ClebschMiddleExterior.lean` | new definitions `tripleSum`, `concatenation`, `concatenationInversions`; new theorems `tripleSet_injective`, `tripleSet_complementIndex`, `eq_complementIndex_iff`, `complementIndex_involutive`, `concatenation_injective`, `concatenation_bijective`, `hodgeSign_eq_neg_one_pow_inversions`, `concatenationInversions_add_three`, `tripleSum_add_tripleSum_complementIndex`, `hodgeSign_eq_neg_one_pow_tripleSum`, `hodgeSign_mul_self`, `hodgeSign_mul_complement`; module header rewritten |
| `lean/RelativeConicArcs/ClebschMiddleExteriorSquare.lean` | `hodgeSign_mul_complement` removed (moved upstream); `hodgeMatrix_sq` docstring and module header corrected |
| `lean/RelativeConicArcs/ClebschMiddleExteriorDiagonal.lean` | `hodgeSign_complement` and `hodgeMatrix_complement_entry` derived rather than decided; module header corrected |
| `lean/RelativeConicArcs/ClebschMiddleExteriorSupport.lean` | `complementIndex_involutive` removed (moved upstream); module header corrected |
| `lean/RelativeConicArcs/ClebschMiddleExteriorSquareRows*.lean` (four files) | module headers corrected |
| `lean/RelativeConicArcs/Gates/ClebschGoldenReturn.lean` | five new audited terminals; header describes the parity route and drops the displayed-data disclosure |

The four row modules and the support and diagonal modules still described
their proofs as native decision, which stopped being true when compiled
evaluation was eliminated. Those headers are corrected here because the review
gate requires a touched module's whole prose to agree with its elaborated
statements; the correction is independent of the Hodge work and closes those
rows of gap class D.

## Validation state

Every new proof elaborates. Two smoke tests were run through the guarded
single-file entry point, which does not need the build lock:

1. A standalone module copying the four displayed tables verbatim and
   importing Mathlib alone — no `RelativeConicArcs` import — carrying all
   twelve new declarations plus the three that were rewritten downstream
   (`hodgeSign_complement`, `hodgeMatrix_complement_entry`, `hodgeMatrix_sq`).
   Exit zero in fourteen seconds, no errors or warnings. This reproduces the
   statements of the three rewritten downstream proofs but not their
   environment: the real modules open the conference and matrix namespaces, and
   the real `hodgeMatrix_sq` elaborates with the four row leaves in scope.
   `simp [hodgeMatrix, h, hodgeSign_complement]` in
   `hodgeMatrix_complement_entry` is exactly the kind of call whose behaviour
   can change under a larger simp set, so those three are validated
   synthetically only.
2. `RelativeConicArcs/ClebschMiddleExterior.lean` itself, in its real import
   context against the existing `ClebschGoldenConference` object file. Exit
   zero in four seconds, no errors or warnings, so the new names do not clash
   with the opened conference namespace.

Both are elaborations against last-built dependencies and are therefore smoke
tests, not the validation gate. The three risks flagged before they were run
are all settled: the `revert … ; decide` blocks reduce in the kernel within
`maxRecDepth 10000`, including the `Finset.filter` over `Fin 6 × Fin 6` inside
`concatenationInversions`; `Finite.injective_iff_bijective` applies to
`concatenation S` without an instance hint; and the `norm_num` closers
discharge the pow-arithmetic. No tactic needed adjusting.

Still required before this is claimed as green, all of it needing the build
lock:

1. elaborate `ClebschMiddleExterior`, then the diagonal, support, four row, and
   square leaves, then the golden-return gate, through the guarded queue;
2. regenerate `golden_return_axioms.txt` and the golden-return source closure
   inventory from the resulting tracked build log with the committed
   extractors — the audited terminal count rises from twenty-eight to
   thirty-three;
3. replace the pinned gate stdout,
   `verification/evidence/gate_stdout/golden_return.stdout.txt`, which is a
   release file whose bytes are pinned, and update the two provenance fields
   that describe it, `axiom_report_provenance.gate_stdout_sha256` and
   `axiom_report_provenance.build_run_id`. This is not optional bookkeeping:
   `verify_golden_return_lean.py` checks the stdout hash inside its source
   check, which runs even in `--source-only` mode, and that is the mode
   `verify_release.py` uses. Skipping it fails the paper-local replay and the
   release verifier;
4. update `golden_return_formal.json`: source hashes, axiom-report and closure
   hashes, `audited_declarations`, the OPER-1 declaration list, and the
   `trust_boundary.native` prose, which should now name the parity route for
   the Hodge square. All five new terminals must appear in some claim row —
   `verify_scaffold.py` requires the audited declarations to be contained in
   the union of the claim-map declaration lists, so omitting them fails with a
   complaint that the gate audits declarations no claim row names;
5. rerun the paper-local replay and the release verifier.

What the smoke tests do not cover is the seven leaf and gate modules that
import the changed one. Their proofs are unchanged, but they must be
re-elaborated against the new object file, and `hodgeMatrix_sq` in particular
now resolves `complementIndex_involutive` from a different module.

## Manuscript prose that should or could change

The instruction governing this pass is that Lean follows the paper, so none of
these is required for correctness of the manuscript. They are places where the
paper currently asks the reader to accept a convention that Lean now proves,
and where saying so costs a sentence.

### Should change

**`sections/08-verification.tex`, the operator-theorem paragraph (line 29).**
It lists "middle-exterior square and diagonal" among mechanisms "checked by
the pinned golden-return Lean gate" without saying how. It is now worth one
clause that the Hodge square is proved from the parity of complementary label
sums rather than from a stored sign table, because that is exactly the
distinction a referee reading "checked by a Lean gate" wants drawn. This lands
with the same paragraph's other three pending corrections, which are already
recorded and are not mine to make unilaterally: the Ramsey sentence at line 41,
the checking-method disclosure, and the singular "a paper-specific Lean gate"
at line 52 where there are three.

The checking-method sentence is now a positive statement rather than a
disclosure. Since compiled evaluation is gone from all three closures, the
sentence to add is that every finite step in the Paper III gates is a kernel
decision, a rewriting procedure, or a cofactor expansion, and that the replays
refuse `native_decide` — not the weaker admission the earlier audit expected.

### Could change

**`sections/05-golden-operator.tex`, line 36 and line 388.** Both say the
Hodge orientation is "transported with the ordered axis basis" and warn that
switching the matrix while holding the old convention fixed is illegitimate.
Neither states the convention. One display would fix that and make the
subsequent minor identification checkable:

\[
 \epsilon(S) = \operatorname{sgn}(S, S^c) = (-1)^{\sigma(S)-3},
 \qquad \sigma(S) = \textstyle\sum_{i \in S} i,
\]

with the immediate consequence that \(\epsilon(S)\epsilon(S^c) = (-1)^{9} = -1\)
in middle degree, since \(\sigma(S)+\sigma(S^c)=15\). The parity formula is
the reason the transport warning is needed, and stating it turns a warning
into a computation the reader can perform.

Two cautions if that display is added. It should say in the same breath that
the Lean matrix entry in row \(S\) is \(-\epsilon(S,S^c)\) because it realizes
\(\epsilon(S^c,S)\); a referee comparing the display against `hodgeMatrix`
will otherwise read a sign error where there is none. And the display's
exponent is \(9\) while the Lean module and `hodgeSign_mul_complement` carry
`17`, because Lean normalizes each exponent to \(\sigma+1\) to keep it a
natural number. Both are correct and the module header now records the shift,
but the paper should either use \(\sigma-3\) consistently or note it.

**`sections/05-golden-operator.tex`, line 509.** "The Hodge convention makes
this minor \((K_T)_{SS}\)" is the load-bearing use of the convention in the
Pfaffian argument. If the display above is added, this sentence can cite it
instead of the word "convention".

**`sections/05-golden-operator.tex`, line 203.** "These formulas also hold
modulo complementation because \(c_Y=c_{Y^c}\)" is a different, cubic-side
complementation, not the middle-degree Hodge sign. Worth checking that a
reader does not conflate the two once the Hodge sign becomes explicit; a
half-sentence distinguishing them may be warranted if the display is added.

No claim anywhere in the manuscript is narrowed or strengthened by this work.
The Hodge square, the diagonal identification, and the Pfaffian argument all
say exactly what they said before; what changed is that Lean now proves the
convention they rest on instead of stipulating it.

## Relation to the referee suggestion

This is the strengthening the referee proposed and the earlier closure pass
deliberately deferred as a scope decision rather than a repair. It is taken in
its parity form, not in full: the displayed tables are still displayed, but
they are now cross-checked against each other and against a parity invariant,
and the Hodge square no longer rests on the sign table directly. The full form
of the suggestion — a formal bridge to a library permutation-sign function —
remains open and is described above.

The gate header's interim disclosure accordingly changed subject rather than
being dropped. It no longer says the Hodge sign identity is a twenty-case
check on the displayed signs, because it is not; it now names the four
twenty-case decisions about the tables that the parity chain rests on instead.

## Independent review

An adversarial review of this change is
`notes/2026-08-04-c815-hodge-review.md`. It verified the mathematics by an
independent enumeration with zero mismatches, confirmed both declaration moves
break no consumer and create no import cycle, and confirmed every manuscript
line citation above. Its verdict was go-with-fixes. Every prose fix it asked
for is applied: the gate header's restored disclosure of the surviving
decisions, the qualification of the permutation-sign claim at all four sites,
the corrected decision domains and counts, the pinned gate stdout and its two
provenance fields added to the regeneration list, and the two cautions on the
proposed manuscript display. The one code fix it recommended, a
`triple_strictMono` decision closing the last unbacked displayed table, is
deferred only because no Lean may be elaborated at present; it is named in the
limits paragraph above.
