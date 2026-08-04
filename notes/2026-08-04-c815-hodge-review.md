# Adversarial review of the middle-degree Hodge sign structuralization

**Lane:** `clebsch`
**Date:** 2026-08-04
**Task:** C815 (review of commits 855fc774 and 7d0fb394)
**Reviewed:** `lean/RelativeConicArcs/ClebschMiddleExterior.lean`,
`ClebschMiddleExteriorDiagonal.lean`, `ClebschMiddleExteriorSquare.lean`,
`ClebschMiddleExteriorSupport.lean`, the four `ClebschMiddleExteriorSquareRows*.lean`,
`lean/RelativeConicArcs/Gates/ClebschGoldenReturn.lean`,
`papers/clebsch-passages/verification/*`, `sections/05-golden-operator.tex`,
`sections/08-verification.tex`, and `notes/2026-08-04-c815-hodge-sign-structuralization.md`.

## A. Mathematical correctness — nothing wrong

An independent enumeration of the twenty increasing three-subsets of `{0,…,5}`
(script under the session scratchpad, `check.py`; recomputed from
`itertools.combinations`, not from the Lean tables) confirms every arithmetic
claim in the change:

- the displayed `triple` table is exactly the twenty increasing triples in
  lexicographic order;
- `complementIndex = ![19, 18, …, 0]` sends each triple to its set complement,
  with no exceptions;
- for all twenty labels, the displayed `hodgeSign` equals `(-1)^inv`, where
  `inv` is the inversion count of the concatenation of the triple with its
  increasing complement;
- `inv = σ(S) − 3` for all twenty labels, where `σ(S)` is the label sum;
- `σ(S) + σ(Sᶜ) = 15` for all twenty labels;
- `hodgeSign S · hodgeSign (complementIndex S) = −1` for all twenty labels.

Zero mismatches. The docstring justification at
`ClebschMiddleExterior.lean:144-147` ("the label `triple S k` exceeds exactly
`triple S k − k` of them") is also correct: below a label of value `v` sitting
at position `k` there are exactly `k` labels of `S`, hence `v − k` labels of
`Sᶜ`; summing over `k = 0,1,2` gives `σ(S) − 3`.

The final parity exponent is right. Lean states
`hodgeSign S = (-1)^(tripleSum S + 1)` (`ClebschMiddleExterior.lean:162-163`),
which is `(-1)^(σ−3)` shifted by `4`; the product exponent is then
`(σ(S)+1) + (σ(Sᶜ)+1) = 17`, odd, so `(-1)^17 = -1`. The `omega` step at
`ClebschMiddleExterior.lean:182-184` is sound and the `rw`/`norm_num` chains in
`hodgeSign_eq_neg_one_pow_tripleSum`, `hodgeSign_mul_self` and
`hodgeSign_mul_complement` all rewrite the intended occurrences.

## B. Does the Lean say what the prose says? — three findings

### B1. MAJOR — the gate header drops a still-applicable computational disclosure

`lean/RelativeConicArcs/Gates/ClebschGoldenReturn.lean:34-46`.

The old header said the Hodge square rests on `hodgeSign_mul_complement`,
"itself a twenty-case `rfl` on the displayed signs". The new header says the
sign identity "is in turn a parity computation" and then narrates the route —
set complement, inversion count, label sums, `(-1)^17` — without ever saying
that four of the five links in that chain are themselves exhaustive kernel
decisions over the twenty labels (`tripleSet_complementIndex`,
`hodgeSign_eq_neg_one_pow_inversions`, `concatenationInversions_add_three`,
`tripleSum_add_tripleSum_complementIndex`, plus `tripleSet_injective` and
`concatenation_injective`). The exhaustive checking did not disappear; it moved
one level down and changed subject. `lean/AGENTS.md:288-292` requires that for
every computationally discharged claim the artifact "state whether checking
occurs by kernel reduction … identify the finite domain … distinguish
exhaustive checking from sampled or search evidence". The header is now less
disclosive than the one it replaced, on a claim that is still computational.

Fix: append one sentence to the gate header, e.g. "Each link in that chain —
that the index table is set complement, that the sign table is minus one to the
inversion count, that the inversion count is the label sum less three, and that
complementary label sums are fifteen — is a kernel decision over the twenty
labels."

### B2. MAJOR — "the sign of the concatenation permutation" is not what Lean proves

Four places assert it:
`Gates/ClebschGoldenReturn.lean:41-43`; `ClebschMiddleExterior.lean:16-18`
(module header); `ClebschMiddleExterior.lean:65-67` (`hodgeSign` docstring);
`ClebschMiddleExterior.lean:138` (`hodgeSign_eq_neg_one_pow_inversions`
docstring, "The displayed sign table **is** the sign of the concatenation
permutation").

What Lean proves is `hodgeSign S = (-1) ^ concatenationInversions S`, where
`concatenationInversions` is a `Finset.filter … .card` defined three lines
above. `Equiv.Perm.sign` never appears in the module, and nothing formal
connects the two. The identity "sign = `(-1)^inversions`" is a true and
standard fact, but it is asserted in prose only — exactly the pattern
`lean/AGENTS.md:299-301` forbids ("Do not use comments to imply a stronger
theorem than Lean checks"), and it is the specific claim the referee's
suggestion was about. `concatenationInversions`' own docstring
(`ClebschMiddleExterior.lean:131-133`) states the inversion formula as ambient
convention, which is admissible; the theorem docstring turning it into what the
theorem says is not.

My judgement: this needs either a docstring qualification or a bridge, and a
bridge is the better answer because the referee's point was precisely that the
table should be tied to a permutation invariant rather than to another table.

*Minimum acceptable fix (qualification).* Restate the four sites as "minus one
to the number of inversions of the concatenation map", and add once, as a named
convention, "which is the sign of that permutation by the standard inversion
formula; that identification is not formalized here."

*Preferred fix (bridge), sketch.* Mathlib defines
`Equiv.Perm.signAux f = ∏ x ∈ finPairsLT n, if f x.1 ≤ f x.2 then -1 else 1`
(`Mathlib/GroupTheory/Perm/Sign.lean:175-176`), which is literally
`(-1)^(number of inversions)`, and relates it to `Equiv.Perm.sign` through
`signAux_eq_signAux2` (`ibid.:291`) and `signAux3` (`ibid.:320,358`). So:

1. `def concatenationPerm (S : Fin 20) : Equiv.Perm (Fin 6) :=
   Equiv.ofBijective (concatenation S) (concatenation_bijective S)` — this is
   also the first genuine use of `concatenation_bijective` (see B3).
2. One reusable lemma, stated for arbitrary `n` and proved once:
   `(Equiv.Perm.sign f : ℤ) = (-1) ^ (Finset.univ.filter fun p : Fin n × Fin n =>
   p.1 < p.2 ∧ f p.2 < f p.1).card`. Route: `sign f = signAux f` via
   `signAux_eq_signAux2` with `e := Equiv.refl _`; then `Finset.prod_ite` /
   `Finset.prod_const` on `signAux`'s product, with the order-reversing bijection
   `⟨a, b⟩ ↦ (b, a)` between `finPairsLT n`'s inverted members and the filter set.
   Check first whether Mathlib already carries this; if it does, the bridge is
   three lines.
3. `hodgeSign S = (Equiv.Perm.sign (concatenationPerm S) : ℤ)` then follows from
   step 2, `hodgeSign_eq_neg_one_pow_inversions`, and `Equiv.ofBijective_apply`.

Note for whoever attempts a shortcut: `decide` will not close the sign equation,
because `Equiv.ofBijective` goes through `Function.surjInv` and is noncomputable.

### B3. MINOR — `concatenation_bijective` is dead and is nonetheless audited

Declared at `ClebschMiddleExterior.lean:127-129`; a repository-wide search of
`lean/`, `papers/` and `notes/` finds no consumer other than the new
`#print axioms` line at `Gates/ClebschGoldenReturn.lean:64` and the report. It
proves the concatenation map is a bijection, which is *not* what makes
`(-1)^inversions` a permutation sign — that needs the sign lemma of B2. Sitting
in the audited-terminal list directly above
`hodgeSign_eq_neg_one_pow_inversions`, it reads as if the two together
established the permutation-sign claim. Fix: either consume it (step 1 of the
B2 bridge) or drop line 64 from the gate and leave the lemma unaudited.

### B4. `eq_complementIndex_iff` — the characterization claim is justified

`ClebschMiddleExterior.lean:89-95` proves
`T = complementIndex S ↔ tripleSet T = (tripleSet S)ᶜ`, a genuine both-ways
characterization on the full domain `Fin 20 × Fin 20`, resting on
`tripleSet_injective`. "Characterized by that property" is earned, and the
docstring's conclusion ("records complementation rather than choosing a
pairing") follows. One NIT: the docstring at line 86 calls `complementIndex`
"the index involution" before `complementIndex_involutive` (line 99) is proved;
say "the index table" there.

### B5. MINOR — the module header understates the decision domains

`ClebschMiddleExterior.lean:25-27`: "Every finite step here is a kernel decision
over the twenty labels or the thirty-six ordered pairs of positions." Two of the
six decisions are over neither domain: `tripleSet_injective` (line 73) reverts
both `S` and `T` and decides over the four hundred ordered pairs of labels, and
`concatenation_injective` (line 118) reverts `S`, `i` and `j` and decides over
the seven hundred and twenty label-position-pair triples. `lean/AGENTS.md:288-292`
asks for the finite domain to be identified. Fix: "over the twenty labels, their
ordered pairs, or the thirty-six ordered pairs of positions".

### B6. MINOR — `triple` itself remains unbacked displayed data

`ClebschMiddleExterior.lean:39-45`. The module header (line 12-14) says "Two
displayed tables carry the complementation datum … This module proves that
neither is an arbitrary choice." True as far as it goes, but there is a *third*
displayed table, `triple`, that both others are defined relative to, and its
docstring's claim — "The increasing triples of `Fin 6`, in lexicographic order"
— is nowhere formally supported. Nothing proves each `tripleSet S` has three
elements, that `triple S` is increasing, or that the twenty labels exhaust the
three-subsets. (`tripleSet_injective` plus `tripleSet_complementIndex` do not
imply it: they force cardinalities to pair up to six, not each to equal three.)
Increasingness is also the tacit hypothesis of the whole inversion argument.
Cheap fix, worth taking now: add `theorem triple_strictMono (S : Fin 20) :
StrictMono (triple S) := by revert S; decide`, and note in the header that
injectivity of `tripleSet` together with cardinality three makes the twenty
labels exactly the three-subsets.

### B7. Residual prose scan — clean

I read all seven middle-exterior modules and the gate in full. No task ID, lane
name, agent or session identifier, internal path, handoff or report reference,
`TODO`/`FIXME`, or status prose ("for now", "next", "pending", "future work")
appears in any of them. The four row-module headers, the support header and the
diagonal header now correctly say kernel decision rather than native decision,
which matches the sources (`decide`, `decide +revert`; no `native_decide`
anywhere in the closure). The gate's surviving limitation sentences ("The
higher-order inclusion-rank and Ramsey exclusion remains a human proof",
`Gates/ClebschGoldenReturn.lean:18-19`) are precise restrictions with no
forecast, which `lean/AGENTS.md:279-282` permits. The gate's blanket sentence
"every terminal printed below depends only on `propext`, `Classical.choice` and
`Quot.sound`" (lines 22-24) is an upper bound and will survive the five new
terminals, but it is an assertion about output that only the regenerated axiom
report can confirm — see E.

## C. Structural integrity — one finding, no breakage

### C1. Both moves are safe

`complementIndex_involutive` and `hodgeSign_mul_complement` both kept the
namespace `RelativeConicArcs.ClebschMiddleExterior`, so every fully qualified
reference outside the sources still resolves:
`papers/clebsch-passages/verification/golden_return_axioms.txt:18`,
`golden_return_formal.json:45` (audited declarations) and `:72` (OPER-1 claim
row), and `evidence/gate_stdout/golden_return.stdout.txt:32`. No Lean consumer
breaks: `ClebschMiddleExteriorSquare.lean:38,43` uses
`complementIndex_involutive` and imports `ClebschMiddleExteriorSupport`
(line 1) as well as, transitively, `ClebschMiddleExterior`, so the reference
resolves through the new home; `ClebschMiddleExteriorDiagonal.lean:37` imports
`ClebschMiddleExterior` directly. No circular import is possible: both
declarations moved *upstream* into the module all seven leaves already import,
and `ClebschMiddleExterior` imports only `ClebschGoldenConference` and Mathlib.
Module ownership is also improved — both declarations are now beside the
definitions they are about. Nothing wrong here.

### C2. MAJOR — the regeneration list omits the pinned gate stdout evidence

`notes/2026-08-04-c815-hodge-sign-structuralization.md:122-135`.

The list covers `golden_return_axioms.txt`, `golden_return_source_closure.json`,
and, in `golden_return_formal.json`, the source hashes, the axiom-report and
closure hashes, `audited_declarations`, the OPER-1 declaration list, and the
`trust_boundary.native` prose. It omits three things that the committed verifier
checks:

- `papers/clebsch-passages/verification/evidence/gate_stdout/golden_return.stdout.txt`
  — the tracked stdout of the gate elaboration. It is a release file
  (`release_files.json:27`) and its bytes are pinned;
- `golden_return_formal.json` `axiom_report_provenance.gate_stdout_sha256`, which
  `verify_golden_return_lean.py:62-73` verifies inside `check_sources`, i.e. even
  in `--source-only` mode, which is the mode `verify_release.py:118-131` runs;
- `axiom_report_provenance.build_run_id`, which names the build run the stdout
  came from and will be a different run.

Until the stdout is replaced and both fields updated, the paper-local replay
fails with `FAIL [gate stdout hash]` and so does the release verifier. Fix: add
these three to the regeneration list as step 2, alongside the axiom report they
are the provenance for.

### C3. No verifier asserts a terminal count, but one asserts a containment

`verify_golden_return_lean.py:152-161` requires the parsed axiom report's
declaration set to equal `audited_declarations` exactly, and the observed log to
equal the report exactly — a set equality, not a count, so the report's
"twenty-eight to thirty-three" is bookkeeping rather than a pinned number. I
counted the gate's `#print axioms` lines: 8 + 3 + 14 + 5 + 2 + 1 = 33, so that
figure is right. Separately, `verify_scaffold.py:174-187` requires
`audited_declarations ⊆ ⋃ claim_map declarations`, so all five new terminals
*must* be added to a claim row or the scaffold check fails with "golden-return
gate audits declarations no claim row names". The report's step 3 covers this
via the OPER-1 list. The source-policy regexes in
`verify_golden_return_lean.py:101-124` (`native_decide`, `decide … + native`,
`\bC[0-9]{3,}\b`, `TODO|FIXME|XXX|HACK`, `sorry`) all pass against the new
sources — `decide` and `decide +revert` do not match the `+ native` pattern.
Nothing in `lean/trust/` pins this gate's terminal list; `PORTFOLIO.md:278`
records the gate with no terminal inventory, and no companion-export config
covers these modules.

## D. The manuscript-prose note

### D1. Every cited line number is accurate

- `08-verification.tex:29` begins "The operator theorem has a separate
  structural route." and the sentence spanning lines 29-32 does list
  "middle-exterior square and diagonal" among mechanisms "checked by the pinned
  golden-return Lean gate", with no statement of method. As described.
- `08-verification.tex:41` is inside the Ramsey sentence ("The classical Ramsey
  input \(R(3,3)=6\), finite-set extension to seven vertices, …"), which begins
  at the end of line 41. As described.
- `08-verification.tex:52` reads "… claim-to-evidence correspondence. A
  paper-specific Lean gate now proves the", singular, while three gates exist.
  As described.
- `05-golden-operator.tex:36` — "transport the Hodge orientations with the
  ordered axis basis", with no statement of the convention. As described.
- `05-golden-operator.tex:388` — "The Hodge orientation is transported with the
  ordered axis basis. Thus an odd relabelling or switching transports both
  \(K_T\) and the sign of its diagonal; it is not legitimate to switch the
  matrix while holding the old Hodge convention fixed." As described.
- `05-golden-operator.tex:509` — "The Hodge convention makes this minor
  \((K_T)_{SS}\)", inside the Pfaffian expansion. As described, and it is indeed
  the load-bearing use.
- `05-golden-operator.tex:203` — "These formulas also hold modulo
  complementation because \(c_Y=c_{Y^c}\)", and this is cubic-side
  complementation, not the middle-degree Hodge sign. As described.

### D2. The proposed display is mathematically correct

`ε(S) = sgn(S,Sᶜ) = (-1)^(σ(S)-3)` with `σ(S) = Σ_{i∈S} i` agrees with the
`hodgeSign` table on all twenty labels (verified numerically), and
`ε(S)ε(Sᶜ) = (-1)^(σ(S)+σ(Sᶜ)-6) = (-1)^9 = -1`. No off-by-one.

There is also no convention clash with `hodgeMatrix`, whose row `S` entry is
`-hodgeSign S` (`ClebschMiddleExterior.lean:192-193`): that entry is
`ε(Sᶜ,S)`, and `ε(Sᶜ,S) = (-1)^{3·3} ε(S,Sᶜ) = -ε(S,Sᶜ)`, exactly as the
definition's docstring says. `hodgeMatrix_complement_entry`
(`ClebschMiddleExteriorDiagonal.lean:35-38`) recovers `ε(S,Sᶜ)` in the column
action, consistently.

Two NITs on the proposed display, both cheap:

- **NIT.** If the display is added, say in the same breath that the Lean matrix
  entry is `-ε(S,Sᶜ)` because it realizes `ε(Sᶜ,S)`; a referee comparing
  `\epsilon(S)` against `hodgeMatrix`'s `-hodgeSign S` will otherwise read a
  sign error.
- **NIT.** The paper display would carry exponent `(-1)^9` while the Lean module
  header and `hodgeSign_mul_complement` carry `(-1)^17`
  (`ClebschMiddleExterior.lean:22, 178`). Both are correct — the Lean form
  normalizes each exponent to `σ+1` to stay in ℕ — but two different exponents
  for the same product across paper and formalization invites a query. Either
  use `σ−3` in the Lean prose (the statement can keep `σ+1`) or note the shift.

### D3. MINOR — two overstatements in the report's own summary

- `notes/2026-08-04-c815-hodge-sign-structuralization.md:71-77`: "The three
  remaining finite steps are kernel decisions … " then lists four, and the
  module in fact contains six `decide` blocks (lines 77, 84, 124, 142, 151, 158
  of `ClebschMiddleExterior.lean`). Fix the count or drop it.
- Same paragraph, "Nothing about the mathematics of the Hodge square is checked
  case by case any more." The two mathematical inputs to the parity computation
  — that the inversion count is `σ−3`, and that complementary label sums are
  fifteen — are both twenty-case decisions. What changed, genuinely and
  valuably, is that these are now *statements a human can verify by a two-line
  argument*, rather than an opaque list of signs; the exhaustive checking of
  them did not go away. Restate as such.
- `:206-208` ("the dependency is gone rather than merely disclosed") overstates
  for the same reason and is the sentence that motivated finding B1. The
  displayed tables are still displayed; they are now cross-checked against each
  other and against a parity invariant.

## E. Validation claims — calibrated, with one soft spot

The report labels both runs smoke tests and says explicitly they are
elaborations against last-built dependencies and not the gate
(`:114-116`), which is exactly what `lean/AGENTS.md:195-196` requires. The
remaining-work list correctly identifies that seven importing modules must be
re-elaborated and that the gate replay needs the build lock. That is calibrated,
and the two commit messages are consistent with it (855fc774 says "Not yet
elaborated"; 7d0fb394 records the smoke tests without upgrading the claim).

One MINOR overstatement: `:107-108`, "This is the whole proof content of the
change, since every other edited file changed only its header prose." The
standalone Mathlib-only copy reproduces the *statements* but not the
*environment* of the two rewritten proofs in
`ClebschMiddleExteriorDiagonal.lean:24-38` or of `hodgeMatrix_sq` in
`ClebschMiddleExteriorSquare.lean:30-45`: the real modules `open
ClebschGoldenConference` and `open Matrix`/`open scoped Matrix`, and the real
`hodgeMatrix_sq` elaborates with the four row leaves in scope. `simp [hodgeMatrix,
h, hodgeSign_complement]` is precisely the kind of call whose behaviour can
differ under a larger simp set and additional instances. Say instead that the
new module elaborates for real and the three rewritten downstream proofs
elaborate only in a synthetic environment.

I did not run any Lean build, take the build lock, or invoke lake or the build
queue; no `guarded-lean` invocation was needed for this review.

## Verdict

**GO-WITH-FIXES.**

The mathematics is correct in every particular I could check independently, the
refactor is structurally clean, and the change is a real improvement on what it
replaces. Two prose defects must be fixed before this can be called
referee-ready — the gate header's dropped disclosure of the surviving exhaustive
decisions (B1) and the four-site "sign of the concatenation permutation" claim
that Lean does not prove (B2) — and one reproducibility gap must be closed in
the regeneration plan before the gate replay is attempted (C2, the pinned gate
stdout and its provenance fields). The rest are minors and nits, of which B6
(`triple` is still unbacked, two-line fix) is the one worth taking in the same
pass because it removes the last unverified displayed table in the family.

Categories with nothing wrong: A (mathematical correctness), C1 (move safety and
import structure), D1 (manuscript line citations), D2 (the proposed display's
correctness).
