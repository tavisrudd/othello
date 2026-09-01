# Ergodis target portfolio — where exact exhaustion with certificates is the right instrument

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-08-31
**Status**: **DESIGN ONLY, PROVISIONAL.** One session's judgement, unvetted, per the lane's standing
rule (`notes/handoffs/2026-07-14-gem-mining.md`). No computation launched, no literature newly
searched, no task IDs allocated, read-only outside this file. The vet is the user's to launch.

**Question answered.** Portfolio-level: across everything this repository knows and everything
Ergodis can do, what is worth pointing the machinery at — taking as established (from
`notes/2026-08-31-clebsch-hexagon-campaign-design.md`) that connection-hunting is reading-shaped and
Ergodis belongs downstream as the certificate-grade verification and census arm.

**Relation to prior slates.** This builds on, and does not re-derive, two existing ranked documents:
the C1018 target scout (`notes/2026-08-30-c1018-target-scout.md`, eight targets against the
open-problem catalogues) and the gem-corpus target mine
(`notes/2026-08-31-ergodis-target-mining-from-gem-reports.md`, eight targets inside conic geometry).
Where a target below appears there, this report adds the portfolio judgement — updated by what
landed since those were written — rather than repeating their specifications.

---

## 0. The instrument, restated from this week's evidence

What Ergodis has now *demonstrated*, beyond the older reports:

1. **Exact minimum distances at publication-replacing scale.** Closed exact distances for quantum
   codes up to length 1496, several replacing published upper bounds from randomized trials
   (`[[288,12,18]]`, `[[360,12,24]]`, `[[784,24,24]]`, the two length-1496 lifted-product codes;
   the coordinator's count of six open distances closed exactly against published upper bounds is
   carried here as relayed); `[[756,16,d]]` certified into `28 ≤ d ≤ 34`, `d ∈ {28,30,32,34}`
   (wave 3A). Sharded, resumable, service-shaped as of today (`certdist`, acceptance gate passed).
2. **Census scale.** ~2·10⁹ projective points per wave (`PG(8,13)` in 396 s), 10¹¹-node orbit
   exhaustions, 190-cell exhaustive parameter sweeps with committed per-cell certificates (C1025).
3. **Certified negatives with exact domains** — Hall-deficiency witnesses per rejection (order-12
   plane screen), SAT refutations with independently checked resolution proofs (`g(8) = 17`),
   randomized-witness phases that certify only in the sound direction with auditable fallback
   counters (C1025).
4. **The newest and most reusable lesson: proved reductions beat hardware.** C1025's Lemma A
   (deepness decided at a single level, not all levels) plus the Sylvester fast path took one cell
   from a 600 s timeout to 0.14 s and turned an out-of-budget region into a 190-cell sweep. The
   record contains several more named, scoped, unbuilt reductions (§2). A wave spent building one of
   those routinely buys more reach than ten waves of raw sweep.
5. **Commercial shape.** Two prototypes passed acceptance gates today by wrapping existing
   primitives: `certdist` (certified distance service) and `certiis` (explainable infeasibility —
   decomposed Hall certificates that restore feasibility where CP-SAT's minimal cores do not,
   ~100× faster, with a principled decline boundary).

Where the instrument is *weak*, from the same record: open-ended hunts (established in the previous
report); well-trodden classical geometry (three same-day pre-emptions); continuous or
structure-free search spaces (MUBs, SICs — already rejected by the scout); and problems whose
bottleneck is a proof idea rather than a computation (see §4).

---

## 1. Ranked targets

Each entry: what, why this rank, landing, miss value, pre-emption, cost. A target here is one I
would defend; the list is deliberately short.

### 1. The qLDPC exact-distance line, run as a sustained program

**What.** Finish `[[756,16,d]]` (the open band is weights 30–32; sharded resume via `certdist`
makes the multi-wave cost schedulable for the first time), then execute the scout's target 2: the
systematic sweep of every published bivariate-bicycle / lifted-product / La-cross code under
~1500 qubits whose printed distance is an upper bound from heuristic decoding.

**Why rank 1.** This is the machinery's designed use, the week's proven best return, and the one
place where *nobody else in the field runs the exact computation at all* — published tables say
"upper bound" in their own captions. Every closure is independently replayable, every witness
double-implemented. It also feeds the commercial line at zero marginal cost: each closed code is a
`certdist` demo artifact.

**Landing.** Named, numbered table entries in cited papers (Bravyi et al. arXiv:2308.07915 Table 3
and successors) — directly citable corrections or confirmations, entry by entry.

**Miss value.** There is no miss: an exact value equal to the published bound is still the first
certificate for it; a narrowed interval (as at 756 today) is still a strict improvement.

**Pre-emption.** Low, and structurally so — the field's own convention is heuristic bounds. The
trust-tier language the snapshot uses (enumeration by one implementation, witness replayed by a
second) must travel verbatim with every new entry.

**Cost.** One wave yields several small/medium codes; 756 is multi-wave but resumable. Reuses
existing drivers; no new mathematics.

### 2. The reduction slate, then the PRS `k`-versus-`q` boundary

**What.** First buy the named, unbuilt reductions (§2 below), starting with C1025's σ-elimination —
a `q²` speedup on the stratum sweep's phase 1, estimated at half a day with no new mathematics,
which lifts the `M = 3` ceiling from `q = 127` to the field layer's limit of 251 and shrinks every
entry in C1025's out-of-budget table. Then run the sharpest cheap experiment the record names
(C1025 `ej` item 1 and mystery 4): sweep carriers with small `k` at large `q` (`r ≈ q` at
`q = 31, 61, 127`) to decide whether exceptional deep holes track the dimension clause `k` or the
field clause `q ≥ 16` — the two hypotheses of Conjecture PRS-1 that may be shadows of one condition
on the pair.

**Why rank 2.** This is the "bottleneck is a reduction, not compute" case in its purest form, with
the reduction already specified and the question already named as the most interesting one the
falsification task exposed. The PRS deep-hole programme is repository-owned frontier (Zhang–Wan
lineage, committed literature audits at redundancies 5–9), so the pre-emption exposure that killed
three geometry claims today does not apply.

**Landing.** Conjecture PRS-1's statement — either a sharpened two-variable law or a genuine
counterexample region — inside the recognized PRS deep-hole classification frontier
(`COD-PRS-deep-holes`), plus the scout's target 4 (`r = 10`, fate of Conjecture B′) which the same
driver family serves.

**Miss value.** Over exhaustive cells a miss *is* the product: verified-domain extension with exact
searched ranges, the same theorem-shape C1025 just banked (171 clean cells in scope).

**Pre-emption.** Low. The one hygiene item: the GF(16) field-labelling artifact logged in the PRS
wave is a standing certificate-recheck hazard and must be cleared before new extension-field
censuses are trusted (scout note 6).

**Cost.** Half a day of engineering, then single waves per experiment.

### 3. Finite-size transversal-gate no-go census (level versus check weight)

**What.** The scout's target 3, which I endorse with its down-scoping made mandatory: over an
explicitly stated structured family of CSS codes (quasi-cyclic / bicycle pairs at fixed circulant
size, or bounded-weight seeds under a fixed permutation group), decide by exact computation whether
any code carries a diagonal transversal gate at Clifford-hierarchy level three or higher, as a
function of length and stabilizer check weight. The framework driver exists and reproduced nine
known classifications exactly, including three new exact ones.

**Why rank 3.** It is the reachable finite shadow of the field-level `BIG-709` frontier, and the
outcome the attack portfolio explicitly prefers — a reusable no-go lemma rather than a larger
table. It converts an observed tension (level rises with parameter while minimum check weight rises
to meet it, exact in two families) into either a family theorem or a counterexample code, both of
which land on names.

**Landing.** A no-go statement in the transversal-gate literature's own terms (hierarchy level,
check weight, named code families); a counterexample would be a new code with a high-level
transversal gate, immediately interesting to that community.

**Miss value.** Over a complete structured family, "no code in family F with `n ≤ N`, `w ≤ W`
admits a level-3 diagonal transversal gate" is a finite no-go theorem with per-code witnesses.

**Pre-emption.** Moderate and must be audited before the write-up: asymptotic no-gos
(Bravyi–König class) and scattered exact analyses exist; a *census* over a stated finite family is
the unclaimed shape, but that claim needs the standard three-index pass. Budget the audit before
the second wave, not after.

**Cost.** One wave per subfamily after the down-scoping choice; the choice itself is a half-day
design note.

### 4. Commercial: harden `certiis` toward a pilot, with its differentiator audited

**What.** The explainable-infeasibility prototype passed its gate today with a genuine product
thesis: on rosters with several independent shortages, CP-SAT's minimal unsatisfiable core names a
set whose deletion leaves the roster still infeasible, while the decomposed Hall certificates
restore feasibility every time — and the tool knows which regimes it may answer and declines the
rest by name. Next steps in order: (i) a bounded audit of the differentiator claim against the MUS
/ IIS enumeration literature (Gurobi IIS, MARCO-style MUS enumeration) — if "all shortages, not one
conflict" is already a product elsewhere, better to know for the cost of a reading pass; (ii) a
real-instance corpus (public nurse-rostering and timetabling benchmarks) replacing generated
instances; (iii) the one bounded mathematical extension with a named theorem behind it — Gale–Ryser
/ flow-feasibility certificates for the currently declined degree-constrained regime, which would
move the decline boundary outward while keeping it principled.

**Why rank 4.** Two prototypes landing in one day on exactly this basis is evidence the
applied lane is real, and `certiis` is the one whose value does not depend on any mathematical
novelty — only on the certificate discipline the repository already practices. It is also the only
target on this list with a customer-shaped miss: if the audit finds the differentiator taken, the
prototype cost is already sunk and small.

**Landing.** A pilot-able tool; commercially, the landing is a demo against a named solver
(CP-SAT/Gurobi) on named public benchmarks.

**Pre-emption.** The audit in (i) is the pre-emption check, and it gates any external claim. Run it
first.

**Cost.** Reading pass plus days, not waves; no heavy compute.

### 5. Decide the equiangular-lines census `M(18) ∈ {57, 58, 59}` now — execute or drop explicitly

**What.** Queued work (`C1000(a)`/`C737`) with a completed feasibility spike recommending
execution; the spike's own risk line is that Greaves–Syatriadi published the enumeration speed-up in
April 2025 after naming `n = 59` as their blocker in 2021.

**My call.** Execute the elimination side within the next few scheduling windows or drop the row
explicitly. This is the one target whose expected value is visibly decaying: the race risk grows
with every idle week, the certificate story is the best on the board (integer-matrix constructions
checkable in milliseconds, rational Farkas vectors per elimination, no solver trust), and the spike
already measured the cost rather than guessing it. A half-executed queue row is the worst state —
it spends the pre-emption exposure without buying the result.

**Landing.** A named constant in a classified table (OEIS A002853; the equiangular-lines
literature). Miss value: the machine-readable census of feasible 58/59-line spectra with a stated
reason each candidate dies is valuable even if the final case resists.

**Cost.** Multi-wave, measured at roughly five times the settled `n = 60` case.

### 6. Pseudo-ovals of `E(5,q)`, Hirschfeld–Thas Problem 6 — audit-gated, now cheaper than when scouted

**What.** The scout's target 8: enumerate pseudo-ovals of `PG(5,q)` for small odd `q` and decide
pseudo-conic-ness — the one item in a named sixteen-problem list whose fixed-`q` instance is a
finite orbit computation. Since the scout was written, its stated blocker at `q = 9` (prime-field
rank oracle) has been closed by `SmallField`/`null_space_with`, so the target got cheaper without
anyone re-scoring it.

**Why this rank.** A numbered problem in a current named problem list is exactly "the answer lands
on something named", and the canonical-augmentation search shape is proven. But the mandatory
literature audit — which small `q` are already classified — is undone and can kill the target
outright; small-`q` pseudo-oval computer classifications are the likeliest already-done cases.

**Miss value.** Over a per-`q` exhaustion, "every pseudo-oval on `E(5,q)` is a pseudo-conic" is a
theorem at that `q`, citable against the problem list.

**Cost.** Audit first (cheap); then one wave at `q = 5, 7`, a second for `q = 9, 11`.

### 7. Order-12 planes: the order-13 collineation class — audit-gated, high variance, kept

**What.** The scout's target 5: complete the orbit-matrix profile census and decide whether any of
the 133 surviving starters lifts, aiming at a certified nonexistence class ("if a plane of order 12
exists, it admits no collineation of order 13"). Hall-certificate machinery is already load-bearing
here (10,262 of 10,395 pairings rejected with explicit deficient-set witnesses).

**Why last among the kept.** The win meets the projective-planes dossier's promotion gate and the
conditional statement is honest, but the mandatory literature audit (collineation groups of
hypothetical order-12 planes have a real literature) is still undone, the lift's branching factor is
unmeasured, and the result bears on the prime-power conjecture not at all. Keep it as the
high-variance slot, strictly behind its audit.

**Cross-lane honourable mention, not ranked here.** Twisted Reed–Solomon deep-hole censuses (C510)
remain the best fit for the PRS driver family outside its own programme; they are `reed-solomon`
lane property, gated behind that lane's C509 entry theorem, and running them is that lane's call.

---

## 2. The engineering slate that multiplies the portfolio

Named in the record, scoped, unbuilt — each small, each unlocking multiple targets above:

1. **σ-elimination in the stratum sweep** (C1025 `ej` 2): `q²` phase-1 speedup, half a day. Unlocks
   target 2's entire out-of-budget table.
2. **Minimum-nonzero-weight mode for `css_distance`** (scout note 5): the natural primitive for
   target 3's check-weight axis.
3. **Automorphism/anchor generators in the `certdist` input format** (its §7 request): the anchor
   set is a 42–60× cost reduction and currently the one load-bearing fact a verifier cannot
   re-derive; closing it strengthens both target 1 and the commercial certificate story.
4. **A core clique engine and a `ProjectiveAction` adapter** (C1020 §7): every exterior-set,
   arc-clique, and cap census re-writes these per driver; targets 6 and 7 and the whole
   conic-geometry slate reuse them.
5. **Clear the GF(16) field-labelling hazard** before any new extension-field census (scout
   note 6).

If only one wave of effort is available, spend it here rather than on any single sweep: C1025's
600 s → 0.14 s cell is the measured argument.

---

## 3. Named problems I would not point Ergodis at

Called out because each looks like a fit and is not; reasons are the record's where cited, mine
where marked.

- **The cap game on odd projective planes** — the repository's own open programme, and a bad
  Ergodis target (my judgement): the missing piece is a single ranked-reply statement, a proof
  object; the record shows candidate survivors dying on located edges, and the live route is a
  Hall-type *rematching argument*, not a bigger search. Ergodis's role is control checks only.
- **Complete arcs of square-root size** — construction/obstruction programme running on monodromy
  and character sums; the closed strata were closed by theorems, not sweeps. Compute serves only as
  spot checks.
- **Latin-square transversals (Ryser, Brualdi–Stein)** — the scout is right: best pure Hall fit on
  the board, and still a bad target; exhaustive cases are done through order 9 and order 11 is out
  of reach by orders of magnitude. Revisit only if someone first designs a structured restriction
  worth a theorem.
- **Rank of 3×3 matrix multiplication over `F₂`** — rejected on scale, correctly; nothing this week
  changes the 10¹¹ envelope against that search space.
- **MUBs in dimension six, SIC-POVMs** — no finite census formulation; already marked negative.
- **Anything conic-hexagon geometric** as an object-level claim — the previous report's Dye rule
  stands; the surviving uses are the three narrow censuses specified there.
- **Everything Hadamard / Legendre-pair / conference-matrix adjacent** — owned by another agent;
  excluded, not judged.

---

## 4. The portfolio principle, generalised

The hexagon report's conclusion generalises cleanly. Ergodis earns its keep in exactly four
postures, and every kept target above is one of them:

1. **Replacing published heuristic numbers with certificates** where the field's own convention is
   not to compute exactly (target 1). Comparative advantage: absolute — the competition is not
   trying.
2. **Closing the repository's own named conjectures by census**, where the literature exposure is
   already audited and the domain is exhaustible (target 2, and the PRS programme generally).
3. **Finite no-go shadows of asymptotic open problems**, where a structured-family census yields a
   reusable lemma rather than a table (target 3).
4. **Selling the certificate discipline itself** (target 4, and `certdist` riding target 1).

Everything else — connection-hunting, classical geometry, proof-bottlenecked programmes — is
reading-led, with the machinery on call for minutes-scale verification. And across all four
postures, the binding growth variable is the reduction slate, not hardware: the week's largest
single capability change was two lemmas.

**Vibe check**: the instrument is in the best shape it has ever been and the highest-value uses are
unusually clear; the main portfolio risk is not technical but temporal — one race-exposed target
(M(18)) decaying in the queue, and audit gates standing undone in front of two others.

---

## 5. Trust boundary

Rankings and judgements are this session's, over the cited reports read today; no new measurements
were taken and no literature was searched (all pre-emption assessments are from the record's
existing audits plus stated exposure, and the MUS/IIS audit in target 4 is a *proposed* check, not
a performed one). The six-closed-distances count is relayed from the coordinator, with the five
individually named closures verified against the snapshot and scout texts. Capability claims are
from source and reports as of today's core state, which moved several times today. Provisional
under the lane's vet rule; this session did not self-vet and did not commission a vet.
