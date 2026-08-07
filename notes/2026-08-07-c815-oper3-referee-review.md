# Referee review: OPER-3 balanced exchange spectrum (Lean arc of 2026-08-06)

**Reviewer stance:** cold, adversarial; no prior contact with this work.
**Scope:** commits 121b2316..c485adfc (all Lean changes fall in the seven files
below); Lean modules `SubsetInclusionSums`, `ConferenceCutBlocks`,
`BalancedExchangeRigidity`, `BalancedExchangeSpectrum`,
`BalancedExchangeEigenvalues`, `BalancedExchangeHalfCut`,
`Gates/ClebschGoldenReturn`; the dated C815 notes of 2026-08-05/06; the OPER-3
material in `papers/clebsch-passages/sections/05-golden-operator.tex`; the
verification artifacts (`README.md`, `golden_return_formal.json`,
`golden_return_axioms.txt`, `passages_formal.json`, `trust_manifest.json`,
`evidence/gate_stdout/golden_return.stdout.txt`).
**Method:** every statement in the seven Lean files read in full, hypotheses
included; load-bearing arithmetic recomputed by hand; an independent numeric
replay of the whole mechanism on the order-10 Paley conference matrix
(scratch script, all 252 balanced halves; not repository evidence, reviewer's
cross-check only). No Lean or Lake was run.

## Headline verdict

**Accept with required repairs, all of them documentation-side.** The Lean
statements say what the notes and the updated verification artifacts claim
they say, the hypotheses are satisfiable (non-vacuously, first at order ten),
the two negative theorems cannot be true for a degenerate reason, and every
load-bearing constant I recomputed independently is correct. The required
repairs are: the stale OPER-3 row of `trust_manifest.json`, and keeping
visible — until the manuscript integration task lands — that the manuscript's
*printed proof* (rank formula + switching + Ramsey) is not the formalized
argument, only its conclusion is.

## Findings, ordered by severity

### F1 (moderate — stale referee-facing trust map; repair required)

`papers/clebsch-passages/verification/trust_manifest.json`, row OPER-3, was
not updated in this arc. Its `proof_role` still reads "... Lean checks the
three-vertex signed-matrix square identity used for the order-six converse",
and its clauses attribute order-six uniqueness to "inclusion rank and Ramsey
exclusion". Both statements describe the state before 2026-08-05/06. After
this arc the golden-return gate covers the entire exchange mechanism —
cut-block identity, support-sorted fourth trace, swap descent, weight pin,
cut-dependence, both moments, order-six polynomial, order-four exclusion,
isometry existence, eigenvalue reading, and the half-to-cut transport — as
`golden_return_formal.json`'s OPER-3 row correctly records. The README calls
`trust_manifest.json` "the nine-row claim/evidence map"; a referee reading
only it will radically under-count the formal coverage and will be told the
formal work follows a proof route (Ramsey) that the Lean deliberately avoids.
**Repair:** refresh the OPER-3 `proof_role`/clauses (or add an explicit note
that the manifest lags the supplemental gate until the manuscript integration
task). The row's evidence list already points at `golden_return_formal.json`,
which limits the damage but does not remove the contradiction.

### F2 (moderate — manuscript proof route differs from the formal proof; keep visible)

`sections/05-golden-operator.tex` lines 159–174 close the rigidity direction
via (i) the full-column-rank theorem for inclusion matrices (cited to
Jolliffe), (ii) a switching normalization, and (iii) `R(3,3) = 6`. None of
these three steps is formalized. The Lean proves the same *conclusion* by a
different route: the swap descent (`SubsetInclusionSums`) replaces (i), and
the whole-matrix trace pin `(N-3)w = -24` (`BalancedExchangeRigidity`)
replaces (ii)+(iii). The replacement text exists in
`notes/2026-08-06-c815-exchange-rigidity-simplification.md` and is explicitly
*not applied*. This is honestly disclosed everywhere I looked, and the
verification claim maps say "partial mechanism; no full row claim", so
nothing currently overstates. But until the manuscript edit lands, the
correct description is: *the formal artifact certifies the theorem, not the
manuscript's printed argument*. Any wording that says "the proof is
formalized" would be wrong today. The README's closing list of "human proof
boundaries" includes "The Ramsey exclusion behind exchange rigidity" — true
of the printed proof, but a reader may take it as a gap in the formal
conclusion, which it is not. One clarifying clause there would remove the
ambiguity.

### F3 (minor — "spectrum" vs second moment in the failure direction)

The manuscript theorem says "The spectrum is independent of the balanced half
Y if and only if d ≤ 3". The formalized failure direction is

```
theorem not_forall_trace_pow_two_exchangeCompression_half_eq ... (t : ℝ) :
    ¬ ∀ Y : Finset n, Y.card = d →
        ∀ U ..., Uᵀ * U = 1 → U * Uᵀ = fixedProjection (s⁻¹ • cutMatrix C Y) →
          Matrix.trace (exchangeCompression ... U ^ 2) = t
```

i.e. non-constancy of `tr(H²)`, a charpoly-level (multiset) invariant. If
"Spec" were read strictly as a *set*, set-level non-constancy is not literally
what is proved (equal sets with different multiplicities would falsify the
trace argument's sufficiency). The manuscript's own display
`{1/5, 4/5, 4/5}` shows the multiset convention is intended, so I read the
claim as proved; but the docstrings of `not_forall_alignedFourSetCount_eq`
(`BalancedExchangeSpectrum.lean:1123-1128`) and the module header assert "the
second moment, and with it the spectrum of the exchange operator, depends on
the half" — a corollary with no formal counterpart (one line classically, but
not a Lean theorem). Under the project's own comment standard ("do not use
comments to imply a stronger theorem than Lean checks") this deserves either
the one-line Lean corollary or a slightly more careful docstring clause
("hence the characteristic polynomial, and any spectrum reading with
multiplicity"). Not blocking.

### F4 (minor — vacuity boundary at d = 4 should be stated somewhere)

The bound `4 ≤ d` in the three cut-dependence theorems comes from the swap
descent's requirement `r + m ≤ |X|`, i.e. `4 + d ≤ 2d`, not from existence of
matrices. At `d = 4` exactly (order 8) the hypothesis class over ℝ is
*empty*: a symmetric conference matrix has order ≡ 2 (mod 4), and 8 ≡ 0. The
first non-vacuous instance is `d = 5` (order 10, Paley), then d = 7, 9, 13, …
(and even among orders ≡ 2 mod 4 some are empty, e.g. order 22 since 21 is
not a sum of two squares). This does not weaken the theorems — the family is
non-empty for infinitely many d, verified concretely at order ten — but a
referee will ask, and the paper's verification prose nowhere says that the
content of the d ≥ 4 clause at any *given* order is conditional on a
conference matrix existing there. One sentence would do. (The mystery ledger
in `2026-08-06-c815-fourth-trace-and-swap-descent.md` explains where `d ≥ 4`
comes from but not the order-8 emptiness.)

### F5 (minor — public names referencing a private definition)

`ConferenceCutBlocks.sum_walkTerm_eq_add_sum_powersetCard` and
`BalancedExchangeRigidity.not_forall_sum_walkTerm_eq` embed `walkTerm` in
their public names, but `walkTerm` is a `private def`
(`ConferenceCutBlocks.lean:166`) invisible to API readers. The statements
spell out the sum `C i j * C j k * C k l * C l i` explicitly, so there is no
mathematical ambiguity, but the names fail the "intelligible without the
private code" standard the project sets for public names. Cosmetic; rename
(e.g. `..._closedFourWalk...`) only if something else touches these modules.

### F6 (informational — terminals stated but not consumed)

`BalancedExchangeHalfCut.trace_pow_four_principalBlock` and
`ConferenceCutBlocks.fourSetWeight_eq_three_or_neg_one` are gate terminals
consumed by no other Lean proof (checked by search). Both are legitimate
referee-facing bridges — the first identifies the fourth trace of the
principal block with the fourfold sum over Y (what the rigidity theorem is
"about"), the second is the manuscript's `w(K) ∈ {3, -1}` in its own
normalization (the working dichotomy is the 8-scaled
`closedFourWalkSum_eq_twentyFour_or_neg_eight`). Not dead weight, but the
claim map could say they are bridges rather than dependencies.

### F7 (informational — small cross-module duplication)

Private helpers duplicated: `BalancedExchangeEigenvalues.transpose_of_isHermitian`
vs `BalancedExchangeHalfCut.isHermitian_of_transpose` (converse directions of
the same ℝ-fact), and the fourfold trace-expansion `htrace` appears both
inside `ConferenceCutBlocks.trace_pow_four` and inside
`trace_pow_four_principalBlock`. Harmless; consolidate only opportunistically.

## Satisfiability analysis (the vacuity question, answered)

Two separate questions: can the *quantified statements* be cheaply true, and
are the *hypothesis classes* inhabited?

**Polarity.** Both headline negatives have the right polarity to resist
degenerate truth. `¬ ∀ Y …` over an empty family of halves would be *false*
(a vacuous ∀ is true), so the theorems being proved forces halves to exist —
and `Fintype.card n = 2d` guarantees them. Likewise in
`not_forall_trace_pow_two_exchangeCompression_half_eq` the isometry `U` is
universally quantified inside the negated statement: a half with *no*
isometry would make the inner ∀ vacuously true and so *hurt* the ¬∀. The
theorem therefore genuinely requires (and its proof supplies, via
`exists_isometry_trace_pow_two_exchangeCompression_half`) a half and an
isometry witnessing a deviant trace. Neither theorem can be true for a
trivial reason.

**Inhabitation.** The hypothesis class (symmetric, zero diagonal, entries
squaring to 1, `C * C = q • 1`, order 2d, 4 ≤ d, s with `s² = q`) is
inhabited over ℝ at d = 5: the order-10 Paley conference matrix (verified in
my replay: `C² = 9I`, symmetric, ±1 off-diagonal, `s = 3`). It is *empty* at
d = 4 (order 8 ≢ 2 mod 4 — see F4) and at every even d; non-empty for
infinitely many odd d (orders q+1, q an odd prime power ≡ 1 mod 4). At order
six the class for the constancy theorems is inhabited by the explicit golden
conference matrix whose `C² = 5I` is itself a gate terminal
(`ClebschGoldenConference.conferenceMatrix_sq`). Conclusion: no statement in
the arc is a theorem about nothing, and the boundary case d = 4 being empty
should simply be said (F4).

**Numeric confirmation** (reviewer's own, order 10, all 252 halves): aligned
counts take both values 0 and 1 (36 and 90 projective cuts respectively —
matching the manuscript's classical-input split exactly); the second-moment
formula `(F_d + 32c)/q²` agrees with `tr((1 - A²/q)²)` to 2e-16 on every
half; the exchange operator assembled from the definitions
(`H = Uᵀ D P₋ D U`, `U` an orthonormal +1-eigenbasis of `C/3`) has spectrum
`{1 - αᵢ²/9}` to 1.3e-15 on sampled halves; first moment `d²/q` confirmed.

## No-witness analysis

The cut-dependence proof is by contradiction through the constant-weight
descent, and the half-cut note's mystery ledger says it "exhibits no pair of
halves with different second moments". Three sharpenings of that:

1. **The existential form is a two-line classical corollary, not a missing
   theorem.** Instantiate `not_forall_alignedFourSetCount_eq` at
   `c := alignedFourSetCount C Y₀` for any fixed half `Y₀` (exactly as the
   HalfCut proof itself does) and `push_neg`: one obtains
   `∃ Y, Y.card = d ∧ alignedFourSetCount C Y ≠ alignedFourSetCount C Y₀`,
   hence a *pair* of halves with different counts and (via the moment
   formula) different second moments. Nothing about the descent's classical
   contradiction blocks this; the proof is non-constructive only in the sense
   that it names no pair, not in the sense that the pair-existence statement
   is unavailable. If a downstream consumer ever wants the ∃-form in Lean it
   costs a few lines.

2. **A concrete witness is a per-matrix finite computation, and at order ten
   it is trivial.** For the Paley-10 matrix any half containing an aligned
   four-set versus any half containing none is a witness (both kinds exist:
   90 vs 36 projective cuts). Formalizing one such pair would be a finite
   kernel check on one explicit 10×10 integer matrix — a bounded, shardable
   `decide`-style task, well within this project's demonstrated tooling.
   Estimated cost: one small module. Worth doing only if the paper ever
   claims a specific pair or wants the 36/90 split formal; it currently
   claims neither in Lean's name.

3. **The manuscript needs only the negative form.** Its use of the theorem is
   "order six is the unique nontrivial realized order with a cut-independent
   spectrum" — for which non-constancy at every realized order 2d, d ≥ 4 is
   exactly sufficient. The quantitative statements the paper *does* make
   beyond non-constancy (ensemble mean, variance, and the order-ten 36/90
   purity split) are explicitly credited to Greaves–Suda and Johnson-scheme
   calculus as classical inputs, and the claim maps mark them
   `classical-input`, not Lean-backed. My numeric check confirms the 36/90
   split, for whatever a reviewer's replay is worth. No overstatement found.

## The trust boundary, checked

- The gate (`Gates/ClebschGoldenReturn.lean`) prints axioms for exactly 83
  declarations; the tracked report `golden_return_axioms.txt` has exactly
  those 83 lines; the tracked build stdout
  (`evidence/gate_stdout/golden_return.stdout.txt`) contains the same 83
  audit lines (identical declarations and axiom sets; the stdout wraps long
  axiom lists across lines and carries `info: file:line:` prefixes, which the
  extractor normalizes). Every terminal depends only on `propext`,
  `Classical.choice`, `Quot.sound`; several on strictly fewer; no
  `sorryAx`, no `ofReduceBool`/compiled evaluation anywhere.
- Coverage of the gate list against what the prose relies on: every
  declaration cited by the OPER-3 rows of `golden_return_formal.json` and
  `passages_formal.json`, every theorem named in the five dated notes, and
  every statement the README's operator-consolidation paragraph describes is
  a gate terminal. I looked for load-bearing declarations proved in the new
  modules but left off the gate and found none: the non-terminal
  declarations are private helpers or intermediate lemmas
  (`monic_eq_of_mul_self_eq`, projection algebra, `signCommutator` lemmas,
  `exchangeCompression_pow`, block/private sum lemmas), each consumed by a
  gated terminal. The definitional layer (`fixedProjection`,
  `antifixedProjection`, `exchangeOperator`, `exchangeCompression`,
  `cutInvolution`, `cutMatrix`, `alignedFourSetCount`, `closedFourWalkSum`,
  `fourSetWeight`) is exercised by the gated theorems' types.
- The claim maps say `"coverage": "partial mechanism; no full row claim"` and
  `"no manuscript theorem takes Lean as a proof dependency"` — appropriately
  modest given F2 and the classical-input clauses.

## The mathematics, independently recomputed

All checked by hand (and, where marked, numerically at order 10):

- **Fourth-trace decomposition.** Closed 4-walks i→j→k→l→i of a zero-diagonal
  matrix with `A i j * A j i = 1`: support-2 walks (k=i, l=j) contribute 1
  each, count d(d-1); support-3 walks (k=i, l≠j and l=j, k≠i) contribute 1
  each, count 2·d(d-1)(d-2) = 12·C(d,3); support-4 walks are the 4! = 24
  injective quadruples per four-set, i.e. the 3 Hamilton cycles × 4 starting
  points × 2 directions. Correct, and correctly proved *without* symmetry —
  a genuine strengthening over the manuscript display, cleanly documented.
- **Dichotomy.** The three cycle products square to 1 and multiply to 1 (each
  edge twice), so their sum is 3 or −1; the walk sum is 8× that, hence 24 or
  −8. Correct.
- **The pin.** `N(N-1)² = N(N-1) + 12·C(N,3) + C(N,4)·w` with
  `12·C(N,3) = 2N(N-1)(N-2)` and `24·C(N,4) = N(N-1)(N-2)(N-3)` reduces, for
  N ∉ {0,1,2}, to `(N-3)w = -24`; `w = 24` gives N = 2, `w = -8` gives N = 6.
  The Lean factorization (`hfactor`, `BalancedExchangeRigidity.lean:166-169`)
  and the nonzero-cofactor discharges (`hN0`,`hN1`,`hN2`,`hN6` with N ≥ 8)
  are exactly this. Correct, and sharp at N = 6 as the module header says
  (all fifteen order-six four-sets carry −8; my order-6 arithmetic agrees).
- **Second moment.** `tr((1 - A²/q)²) = d - 2·tr(A²)/q + tr(A⁴)/q²` with
  `tr(A²) = d(d-1)`, `tr(A⁴)` as above, and `Σ w-sum = 32c - 8·C(d,4)` gives
  `(dq² - 2qd(d-1) + d(d-1) + 12C(d,3) - 8C(d,4) + 32c)/q²`. Matches the Lean
  statement and the manuscript's `F_d` exactly; confirmed numerically on all
  252 order-ten halves. The order-six spot check `33/25 = 1/25 + 16/25 +
  16/25` in the second-moment note is right.
- **First moment.** `d - d(d-1)/q = d²/q` iff `q = 2d - 1`; the Lean takes
  `q = 2·card n - 1` as a hypothesis (`hqval`), which is honest — this
  theorem does not assume the off-half sign structure that would force it.
- **Order-six polynomial.** `A² = 2I + τA` on three labels (entrywise check
  read in full); `det(uI + vN) = u³ - 3uv² + 2v³τ'` with τ' = 1 gives
  `(u - v)²(u + 2v)`, u = X - 3v, hence `(X - v)(X - 4v)²`; at `5v = 1`
  this is `(X - 1/5)(X - 4/5)²`. The τ-cancellation trick (replace A by
  τ•A, whose edge product is τ⁴ = 1) is correct and slicker than the
  manuscript's two-case factorization. Confirmed numerically.
- **Order-four exclusion.** q = 3 from `tr(A²) = 12`, so `tr(A⁴) = 36`;
  support-sorted this is 12 + 48 + W, forcing W = −24 ∉ {24, −8}. Correct.
- **Eigenvalue reading.** Diagonalize `A = VDVᵀ`, conjugation invariance of
  charpoly via `charpoly_mul_comm`, product over the diagonal
  `1 - αᵢ²/q`. Correct; confirmed numerically end-to-end from the
  `exchangeCompression` definition.
- **Isometry existence.** Eigenvalues of a symmetric involution are ±1;
  `tr Q = 0` (from the zero diagonal) equalizes the eigenspace sizes; the
  +1-eigenvector columns of the eigenvector unitary, reindexed along a
  bijection with the half, satisfy `Uᵀ U = 1` and `U Uᵀ = (1+Q)/2`. The Lean
  proof (`exists_isometry_fixedProjection`, read in full) implements exactly
  this with no hidden strength; the antifixed case is the fixed case of −Q.
- **Swap descent.** The induction bounds check out: the exchange step needs
  `r + m ≤ |X \ {a,b}|`, supplied by `r + 1 + m + 1 ≤ |X|`; the base case
  reads the constant off one inclusion sum with nonzero binomial coefficient,
  using `CharZero` + `NoZeroDivisors` exactly where the cast and the product
  split need them. `eq_of_swap_invariant`'s strong induction on `|U \ V|` is
  a correct connectivity-by-swaps argument.
- **Half-cut transport.** `Equiv.sumCompl` relabelling, symmetry for the
  lower-left block, `submatrix_mul_equiv` for the square, subtype sums for
  the fourth trace, and a `card_bij'` between the filtered four-subset
  families for the aligned count. Read in full; no content smuggled.

## Statement strength versus claimed strength — summary table

| Manuscript clause (thm:balanced-exchange-rigidity) | Lean witness | Verdict |
|---|---|---|
| `Spec(H_Y) = Spec(RRᵀ/q) = {1 - αᵢ²/q}` | `charpoly_exchangeCompression_cut` + `charpoly_one_sub_smul_mul_self_eq_prod` + `exists_isometry_charpoly_exchangeCompression_half` | proved, in the *stronger* charpoly form; eigenvalue form over ℝ |
| `tr(H_Y) = d²/q` | `trace_exchangeCompression_cut` | proved (with `q = 2d-1` as hypothesis, appropriately) |
| `tr(H_Y²) = (F_d + 32 c_Y)/q²` | `trace_pow_two_exchangeCompression_cut`, `..._half` | proved, unconditional over ℝ |
| independence fails for d ≥ 4 | `not_forall_trace_pow_two_exchangeCompression_half_eq` | proved at the second-moment level (F3: multiset vs set reading) |
| independence holds for d ≤ 3 | `charpoly_one_sub_smul_mul_self_of_card_one/two/three`, `charpoly_exchangeCompression_cut_card_three` | proved (charpoly computed outright) |
| order six unique nontrivial realized order; spectrum {1/5, 4/5, 4/5} | assembly of the above + `ne_smul_one_of_card_four` + the explicit order-six matrix in the gate | proved as an assembly; no single Lean theorem states the uniqueness sentence (fine, but the claim map should not pretend otherwise — it does not) |
| ensemble mean/variance, order-ten 36/90 split | none (classical-input, credited) | correctly *not* claimed for Lean |

Hypotheses are nowhere stronger than the manuscript's: the fourth-trace count
even drops symmetry (`A i j * A j i = 1` only), and the descent is proved for
arbitrary subset sizes `r ≤ m`, `r + m ≤ |X|` — both strictly more general
than needed, and both noted as such in the artifact without overstatement.

## Checked and found sound (coverage list)

- All seven Lean files read in full, every hypothesis of every public
  statement compared against the manuscript display and the notes.
- Quantifier polarity and non-degeneracy of both `¬ ∀` theorems (see
  Satisfiability); neither is vacuously or trivially true.
- Gate terminal count (83) = axioms report lines = stdout audit lines; axiom
  sets identical; standard three axioms only; no compiled evaluation.
- Claim-map OPER-3 rows in both formal JSONs: declaration lists match the
  gate; coverage language ("partial mechanism; no full row claim") is
  accurate and modest; the "excluded" narrative correctly states that nothing
  in the row rests on an assumed hypothesis after the isometry-existence
  round.
- Arithmetic of every displayed constant recomputed independently (by hand
  and at order 10 numerically): the support decomposition, the {24, −8}
  dichotomy, the pin, `F_d`, the order-six polynomial, both moments, the
  eigenvalue reading, and the manuscript's 36/90 order-ten split.
- Lean naming/prose standard (`lean/CLAUDE.md`): no task IDs, dates, lanes,
  status prose, or internal-note references in any of the seven files
  (searched and read); docstrings are self-contained and — with the single
  F3 caveat — do not overstate; the Gottlieb/Jolliffe citation in
  `SubsetInclusionSums` is exemplary ("neither is used here").
- Redundancy: `BalancedExchangeHalfCut` is not a rewrite of
  `BalancedExchangeSpectrum` — it owns the subset-presentation transport that
  the sum-type modules cannot express; the dependency chain
  Rigidity → Spectrum(¬∀ aligned count) → HalfCut(¬∀ trace) adds a genuine
  layer at each step.

## Required repairs, consolidated

1. Refresh `trust_manifest.json` row OPER-3 (F1) — or record explicitly that
   it lags the supplemental gate pending manuscript integration.
2. Keep the printed-proof/formal-proof divergence visible until the proposed
   manuscript edit is applied or rejected (F2); one clarifying clause in the
   README's human-boundary list would help.
3. Optional but cheap: the ∃-pair corollary or a docstring touch-up (F3), a
   vacuity sentence for d = 4 (F4), and the two naming/duplication touch-ups
   (F5, F7) next time these modules are edited.
