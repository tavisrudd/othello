# C1016 — adversarial status review of the campaign and the paired-move plan

**Lane**: `complete-ports` · **Task**: C1016 · 2026-09-05.

This is a read-only adversarial review of the C1016 state, taken by a
sub-agent before the paired transfer was built, and it is recorded verbatim
below its own heading. It is a second opinion, not a task deliverable: its
exact re-derivations of the fifteen aggregates, the congruence verdict and the
floor were checked independently, but its rankings, its bit estimates for the
carrier rung and its literature suggestions are its own and are not gated.

Two of its calls have since been settled by measurement, both in its favour.
The two-transfer census it proposed as a falsifier came back empty on every
banked state, and the paired engine lost the equal-wall-clock A/B
(`2026-09-05-c1016-paired-transfer-and-the-two-opt-census.md`).

---

# C1016 status review (adversarial, read-only) — 2026-09-05

Sources read: handoff C1016 paragraph (lines 789–1087), the five dated reports named in the brief,
`src/order6_q174_congruence.rs` in full, outline + score/view code of `src/order6_phase_two.rs`,
`evidence/phase-two-q174-congruence.json`, gamma-fit lines of the `phase_two_congruence.rs` driver.
No builds, no edits. Tree at `2b7a0a0` (`c1016-full-2092-campaign`).

## 1. Status, plainly

**Proved (structural, exact):**
- Fourteen private multiplier-sector reductions (orders 2/3/6/9/18 quotient PAF equations, CRT
  norm equations, Burnside quotients); the ten `Z/18` integer equations and defect profiles.
- Plain `Z/523`: admissible parameter sets = representations of `4·523` as four positive odd
  squares (33); size-congruence exclusion of every multiplier-invariant plain 4-SDS with subgroup
  order ≥ 18; spin-shard identity (261 → 87 equations).
- Bordered ladder: character factorisation of `q58`/`q87` through fluctuations; the aggregation
  law (one carrier correlation `(2088, −4)`, every registered target its aggregate); the
  orthogonal identity for the order-six pair; the `q174` invariants (`4 | D(g)`, `8 | D(0)`, the
  fifteen `q29` aggregates); the four-letter restatement.

**Exact-computational (independently replayed):**
- `g53` mod-seven fibre empty at q4; `g91` `Z/18` fibre empty; `g41` q0–q9 filters to 768 roots and
  a common witness for all 768 (quotient pruning exhausted there, not the sector); `g133` 42 cells
  empty; twelve exact `q29` margin shells; rank-73 sweep over 78,498 primes; floor count 422.

**Heuristic / sampled:**
- Every search result and every plateau (walk, tabu, all sectors). Every solution-count and
  "bits of descent" figure. All are labelled as such in the reports — provenance discipline is
  good throughout, and no negative is claimed as authority.

**Where it stands on order 2092:** no witness, and nothing excluded about unrestricted existence.
Two live heuristic routes, both stalled at roughly 0.1–0.2σ per equation of residual: plain-523
spin tabu at 184–196 on 87 equations; bordered `q174` tabu at ≈3,680 on 88 equations above an exact
`q29` shell. The exact `q29` shell (plus exact `q174` energy) is the only exact object achieved on
the bordered ladder. The ladder's top rung — carrier `Z/522` above a `q174` hit — has never been
scored, and (section 5) is the largest rung.

**Overstatements to flag:**
- Handoff: "That plateau is now settled as search depth rather than arithmetic." The congruence
  door is closed exactly; "search depth" is a label, not an explanation. Keep the first half.
- "about 130 bits into that 400-bit descent" — a model number from a two-moment gamma fit
  extrapolated 130 bits into its lower tail; my independent Gaussian-ball estimate is ≈195 bits
  (§2d). Either way "bits descended" is not a progress metric (the first 100+ bits of any such
  descent are free; the remaining ones are the whole problem).
- Handoff and reports call the final rung "the carrier-522 *replay*" and "the last factor of
  three". It is not a replay and not a factor of three in difficulty; see §5.
- "thirty to seventy times closer" — closer in score units; in bits the objective change is a
  redefinition, not progress on a common scale.
- Every "compute is not the lever / insensitive to budget" statement is measured at 30–120 s ×
  12 workers with per-lift budget varied, never total wall clock at the hours scale for the tabu
  on `q174`. The four-hour run that plateaued at 96 was the walk on a different rung.

## 2. Adversarial pass on the four frontier claims

**(a) Fifteen aggregates, free rank 73 — airtight.** `q29_group_of` folds `g mod 29` by `v ↔ −v`;
groups partition 88 canonical classes as `4 + 14·6`; multiplicities `1,2,2,1` on `{0,29,58,87}`
and 2 elsewhere are right (`D(g)=D(−g)`, the two self-inverse classes appear once in `Z/174`).
Relations have disjoint supports ⇒ independent ⇒ rank `88−15=73`. `invariant_coordinates` is a
lattice isomorphism `H ≅ Z^73`: it drops the last member of each group (determined by the
relation, automatically a multiple of 4; for group 0 the dropped `D(87)` is automatically a
multiple of 8, so that check is redundant, as the report says). The derivation "a transfer fixes
every column total ⇒ fixes the whole `q29` view ⇒ aggregates stay zero on an exact shell" is
correct and gated (`the_invariants_survive_every_phase_two_transfer`).

**(b) No congruence below a million — airtight in the claimed direction, and conservative.**
Generators are transfer deltas at 24 *sampled* uniform lifts (2/shell). The lattice `L''` they span
is a sublattice of the true achievable-difference lattice `L`; full rank of `L''` mod `p` ⇒ full
rank of `L` mod `p`. Sampling can only fail to prove absence, never fabricate it. `modular_rank`
is a correct left-to-right elimination (pivot rows may carry nonzeros at later pivot columns; that
is handled since the incoming row is processed column by column). `u64` products `< 10^12` — no
overflow. Fermat inverse needs a prime modulus — supplied. Full rank at every `p` ⇒ `H/L` finite
with no prime factor `< 10^6` — in practice trivial. Caveat the report already states: moduli with
only prime factors `≥ 10^6`. Not a real caveat. One genuine gap the report does not name: "no
congruence" excludes *linear/modular* obstructions only. Positivity of the power spectrum
(`D̂(χ) ≥ −4·523`) is an inequality obstruction, harmless for the floor but real for the
landscape; and nothing about torsion in `H/L` says anything about a *nonlinear* reason the search
can't get below 3,680.

**(c) Floor 32, 422 vectors — airtight.** Score `= Σ D(g)²` over unweighted canonical classes
(`direct_q174_score`), `16 | score`. Objective 32 = two classes at `±4` in one group, same
multiplicity, neither self-inverse: `14·6·5 + 2 = 422` ordered vectors. 48 empty: three `±4`
entries (weight 2 each) cannot cancel; mixing weight-1 classes forces `±8` there, objective ≥ 80.
Checked by hand. Note it is a floor on the *nonzero* values of the objective over `H`, not a
statement that any score-32 state exists.

**(d) Plateau ≈130 bits into a 400-bit descent — the 400 is defensible, the 130 is not.**
`log2_constraint_cost = 73·log2(σ√2π)` with median `σ ≈ 17.9` lattice units gives 399.8 — a
standard Gaussian-density heuristic, same as used on plain-523; fine as an order of magnitude.
The plateau rarity comes from `shape = mean²/var` of the uniform-lift objective and a lower
incomplete-gamma tail evaluated 130 bits out. Independent check: score 3,680 ⇔ `Σ d² ≤ 230` in
lattice units over 73 dims; lattice points in that ball ≈ `π^36.5·230^36.5/Γ(37.5)` ≈ `2^206`;
Gaussian weight per point ≈ `2^−401` ⇒ `P ≈ 2^−195`, states at/below ≈ `2^1527`, remaining
descent ≈ `1527 − 1322 ≈ 205` bits, not 258–285. The two-moment gamma fit is pulled toward a
fatter lower tail by coordinate correlation inflating the sampled variance. Treat "130" as
"130–200, model-dependent". None of this changes the qualitative verdict; it does mean the
"descent so far" framing should not be repeated as if it measured anything.

Summary: (a),(b),(c) exact and correct; (d) is a heuristic whose one specific number is soft.
Nothing is wrong; one number is over-precise.

## 3. The paired within-group transfer move, critiqued

**Category slip in the motivation.** The fifteen relations constrain the *net* deviation vector to
`H`; every single transfer already satisfies them (its delta is in `H`, gated). "A move the
relations permit but a single transfer cannot make" is really "a small-support delta (e.g. the
`±4,∓4` floor vector) that one transfer's 88-coordinate delta `2(W_k − W_i) + …` cannot realise".
The residue groups do not define a move class; they define which sparse deltas are legal. The
proposed lever is therefore just a 2-opt neighbourhood (two transfers per step, Gram-coupled via
`2⟨δ₁,δ₂⟩` plus a ≤4-class cross term from the `u_x u_{x+g}` interaction). Naming it "paired
within-residue-group" implies a targeting the algebra does not supply: a pair's delta is confined
to one residue group only if the two 88-vectors cancel outside it, which is a rare accident of
state, not a property of pairing.

**Move space per step.** Singles ≈ 3,480. All pairs ≈ 6·10^6. Same-block pairs ≈ 1.5·10^6.
Same-column pairs ≈ 116 columns × C(30,2) ≈ 5·10^4 (and many same-column pairs collapse to
singles). "Top-K singles × top-K singles" with K=64 ≈ 2·10^3.

**Cost.** Current `q174` step: 2.69M instr / 652k cycles for 3,480 candidates, dominated by
compiling the 3,480 × 88 delta table (~9 instr/entry); a candidate is then `2⟨D,δ⟩ + |δ|²`, both
cheap once the table exists. A pair needs `⟨δ₁,δ₂⟩` (88 MACs) per pair: all pairs ≈ 1.1·10^9
MACs ≈ 1,000–2,000× the step; same-column pairs ≈ 4.4·10^6 MACs ≈ 3–8× the step; top-K² ≈ free.
Maintaining the full Gram matrix incrementally is a rank-few update per accepted move on a
3,480² matrix (≈12M entries, 48 MB) — feasible but a real engineering item.

**Will it break the plateau?** Expect a modest shift (plateau ~3,680 → perhaps 2,500–3,000), not
a hit. Two reasons. (i) This is a periodic-autocorrelation / LABS-type landscape ("golf course");
in that literature moving from 1-flip to 2-flip neighbourhoods improves constants, never the
exponent, and tabu with kicks already composes moves across steps. (ii) The residual is spread
evenly over the 15 groups and the 3 character blocks; nothing indicates a structured trap of the
kind the `q29` margin floor-96 was (116 cells, 15 equations — a regime where neighbourhood
geometry *is* the problem). At 696 cells / 88 equations the plateau is generic ruggedness.

**Fast falsifiers (minutes).**
1. On the 12 banked `q174` plateau states (`evidence/phase-two-q174-corpus.jsonl`), enumerate
   *all* same-column pairs and all top-64² pairs exactly, count strictly improving pairs and the
   best pair delta. Seconds per state with the existing delta table. If most states have zero
   improving pairs, they are 2-opt local optima and the lever is dead before it is built. If there
   are improving pairs, record the improvement distribution — if the best pair beats the best
   single by less than the tabu's kick noise, same verdict.
2. Then, only if (1) is positive: 30 s × 12 workers A/B, same seeds, pair step vs single step; the
   go/no-go line is best-of-12 below ≈2,800 (outside the 3,680–4,048 plateau spread) at equal wall
   clock.

## 4. Alternatives, ranked by EV

1. **Score the carrier `Z/522` rung now (highest).** Lift banked `q174` plateau states to the
   carrier, measure the 174 free residuals' σ, run the same full-neighbourhood tabu on the carrier
   objective (moves = paired flips inside one column that keep column totals, ≈10^4 per step; or
   unconstrained flips scoring carrier + `q174` jointly). Decides whether the bordered ladder is
   viable at all (§5): if the carrier rung plateaus at its own 0.1σ/equation, the total remaining
   depth is ≈1,200 bits and the route should be demoted. Same delta algebra, hours to build.
2. **Re-baseline against plain-523 with the engine upgrades already ledgered.** Plain-523 is one
   rung, a hit is a Hadamard matrix outright, density `2^−381` total versus the bordered route's
   `≈2^−1190` total (by the campaign's own yardstick). Cheapest upgrades: Gram-matrix maintenance
   for `⟨u_A,E_B⟩` (named in the tabu report, not done); PSD/Fourier-domain scoring and the
   per-block filter `PSD_b(χ) ≤ 523`, which is the standard instrument for 4-sequence PAF problems
   (Djoković–Kotsireas compression + PSD; check their DCC 2015 compression paper and whether they
   already attempted `(240; 257,257,257)` at 523 — a mandatory literature check before more
   compute, and cheap).
3. **The 2-opt / paired move on `q174`.** Gate on falsifier 3.1 first; modest EV.
4. **Multiplier-symmetric `q174` shards.** `(Z/174)^* ≅ Z/2 × Z/28`: no order-3 multiplier (so no
   spin shard), but involutions such as `m=115` (`≡1 mod 6, ≡−1 mod 29`) can pair blocks
   `X₁=115·X₀, X₃=115·X₂`, halving free cells and folding 88 → ≈46 equations; order-7 multipliers
   fixing a compatible shell would fold 14×. Must first be checked against the exact multiplier-
   shard emptiness results already banked (`g53`, `g91`, `g41`, `g133`) — I could not map those
   sectors to `Z/174` multipliers from the reports alone. Medium EV if not already excluded.
5. **Larger shell corpus.** `log2_fibre_size` varies 1,719–1,727 across 12 shells; expected
   solutions vary by 8 bits; plateau shell-independent so far. Generate 200 shells (seconds), keep
   the top decile by fibre size, use them as the default corpus. Cheap, marginal, do as a side
   effect only.
6. **Hours-scale tabu on `q174`** (background, 12 workers × 4 h). Low information but currently
   the only untested budget axis; cheap to launch, do not wait on it.
7. **Group-scoped search.** Negative EV: every transfer moves all 15 groups; scoping recreates the
   `q87` tie trap the phase-two report already documented.

## 5. What the campaign is fooling itself about

- **The ladder gets harder going up, and the top rung is the biggest.** Above a `q174` hit the
  carrier has 262 canonical classes, 88 pinned by `q174` ⇒ 174 free equations; 4-block PAF sums
  are multiples of 4 with conditioned σ ≈ 37 ⇒ ≈4.5 bits each ⇒ ≈790 bits of constraint against
  ≈770 bits of fibre states (`Σ log2 C(3,c)`). Expected carrier lifts per `q174` hit ≈ `2^±20` —
  order unity, model error ±50 bits. So a `q174` hit is nearly a coin flip to be a dead end, the
  carrier rung is ≈2× the `q174` rung in bits, and "last factor of three" / "replay" language hides
  the largest unsolved piece. Bordered total ≈ 400 + 790 ≈ 1,190 bits vs plain-523's 381.
- **Every objective so far turned out to be a fragment** (registered 1,500 → 0.5% of true error;
  `q58` half → `q87` half; `q87` → order-six pair; now `q174` → carrier). The pattern predicts the
  next reveal; the fix is to score the top rung before optimising a lower one further.
- **Solution counts are treated as reassurance.** `2^1322` solutions says nothing about local-search
  reachability; LABS has `2^N` states and exponential hardness with plentiful near-optima. Density
  is the campaign's own comparison metric, fine, but it is not evidence that a stronger local move
  will close the gap.
- **The one move-geometry success does not extrapolate.** Floor-96 → 0 on the `q29` margin shell
  was a 116-cell, 15-equation problem. Every larger sector (g41 fine orbit, plain-523, `q174`) saw
  the tabu step buy 20–70% of score and then plateau. Expect the same from 2-opt.
- **"Bits descended" is not progress.** See §2d; and the gamma-tail number carries ±60 bits.
- **Budget claims are seconds-scale.** No tabu run on `q174` has exceeded 120 s; "insensitive to a
  hundredfold per-lift budget" is a statement about restart policy, not total compute.
- **Credit where due:** provenance labelling, independent Python oracles, fail-closed lattice
  coordinates, planted-congruence test, and the SHA-pinned evidence are all in order; nothing is
  claimed as negative authority that is not exact.

Recommendation in one line: before or alongside the paired move, spend one afternoon scoring the
carrier rung from the banked `q174` states and run the seconds-scale 2-opt census on those same
states; the first decides whether the bordered ladder is worth another engine, the second decides
whether the paired move is worth finishing.
