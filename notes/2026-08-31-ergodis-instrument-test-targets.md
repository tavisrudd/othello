# Ergodis instrument-test targets — new mathematical ground chosen to stress the machinery

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-08-31
**Status**: **DESIGN ONLY, PROVISIONAL.** One session's judgement, unvetted, per the lane's
standing rule (`notes/handoffs/2026-07-14-gem-mining.md`). No computation launched, no literature
newly searched. Read-only outside this file; no task IDs. **Every concrete table, record, and
parameter value below is recall-level (knowledge cutoff, no fetches this session) and each target
carries a mandatory verification gate before any wave.** The vet is the user's to launch.

**Question answered.** Problems this repository has never worked on, chosen and ranked by what they
would teach about Ergodis itself — what they strengthen, what they break, what they leave
untouched. The instrument is the deliverable; the theorem is the exhaust.

---

## 0. The shape of a good instrument test

One pattern recurs in every strong candidate, so it is stated once: **a published ladder with a
stalled rung.** A classification or table computed and published up to parameter `N`, open at
`N+1`. The published rungs are the ground truth — replaying them is the calibration run, and a
discrepancy there is a bug found cheaply, which is exactly how this week's campaign caught its own
errors. The stalled rung is the frontier — unclaimed by construction, so the pre-emption discipline
and the instrument goal stop fighting each other: the *computation* we run first is published (that
is the point), the *result* we aim at is not.

Ranking criterion, per the brief: teaching value about Ergodis, not mathematical prestige. The miss
test is applied per target and stated honestly where it is weak.

## 1. What the instrument currently assumes — so "break" is well-defined

Read from source and this week's reports; this inventory grounds every "stresses" claim below.

1. **Algebra:** finite fields only, table-backed `u8` elements, order ≤ 256 (`SmallField`). Rank =
   dimension via Gaussian elimination (`matrix.rs`); projective indexing assumes every nonzero
   vector has exactly `q−1` associates (`ProjectiveIndex`). No rings with zero divisors, no
   characteristic-zero arithmetic, no bignums, no p-adics, no lattices.
2. **Search:** exhaustion with hand-rolled symmetry reduction and bounding, written per driver.
   No generic canonical-augmentation / orderly-generation engine; no dynamic programming layer; no
   fixpoint-closure engine beyond orbit BFS; `zdd.rs` and `sat.rs` exist but no ranked target this
   week made either load-bearing.
3. **Certificates:** witnesses, symmetry-reduced exhaustion domains, Hall-deficiency sets, and
   (once, externally) checked SAT resolution proofs. Everything certified so far is cheap to
   *replay*. No bound-shaped certificates, no rigorous-numerics certificates, no parametric
   certificates covering infinitely many cases, no certificates for computations too large to
   replay.
4. **Solvers:** external and ad hoc (the `g(8) = 17` SAT refutations); no institutional pipeline
   with proof logging, cube-and-conquer, or incremental interfaces.
5. **Weights/metrics:** Hamming only, in every distance kernel.

---

## 2. Ranked targets

### 1. Arcs and linear codes over finite chain rings — projective Hjelmslev planes over `ℤ₄`

**The ground.** Coding theory and finite geometry over `ℤ₄`, `ℤ₉`, `F₂[u]/(u²)` — Galois/chain
rings. Two published ladders with stalled rungs, both recall-level and to be verified at the gate:
the Honold–Landjev/Kiermaier-school tables of maximal `(n, r)`-arcs in projective Hjelmslev planes
`PHG(2, R)`, which carry explicitly open cells (bounds, not values); and the online `ℤ₄`-code
tables (Aydin school), likewise with gap entries. Settled cells and the classical `ℤ₄` landmarks
(Kerdock/Preparata Lee distances) are the calibration rungs.

**Exact first question.** Pick, at the verification gate, the smallest open cell in the
`PHG(2, ℤ₄)` arc table; close it by exhaustive census up to the ring-linear symmetry group, with
per-cell certificates in the C1020 style.

**What it stresses.** This is the direct answer to "the finite-field kernels just went generic;
what would rings break?" — and the answer is precise:

- *Breaks* `matrix.rs`: over `ℤ₄` rank ≠ dimension, Gaussian elimination is invalid (zero
  divisors), and the canonical row-span form is the **Howell form** (with Smith form for module
  invariants) — a genuinely new kernel, the ring analogue of `canonical_row_basis`.
- *Breaks* `ProjectiveIndex`: module lines over a chain ring have unequal associate classes (unit
  versus non-unit coordinates), and Hjelmslev geometry adds the neighbour relation — two distinct
  points can fail to determine a unique line. Indexing, incidence, and orbit machinery all need a
  ring-aware layer.
- *Breaks* the distance kernels' Hamming assumption: the natural metrics are Lee and homogeneous
  weights, which is a weight-function abstraction the CSS engine would inherit.
- *Strengthens*: the group-action layer (ring-linear groups are a new action family on an indexed
  set), and the whole census/certificate discipline transfers unchanged — which is itself worth
  knowing.
- *Leaves untouched*: solvers, DP, numerics.

**Ground truth.** Settled table cells; Gray-map images of `ℤ₄` codes land on known binary
nonlinear codes, a free independent cross-check unique to this ground.

**Miss test.** Clean: cells are censuses; a miss is an exact value or improved bound in a
maintained public table — theorem-shaped either way.

**Pre-emption / gate.** The tables mark their own open cells; the gate is fetching the current
table state (my memory of which cells are open is not evidence) plus a forward pass on the
table-maintainers' recent papers.

**Cost shape.** Calibration wave (settled cells + Kerdock replay), then one wave per open cell.
The Howell-form kernel is days, not weeks, and is the reusable deliverable.

### 2. Exact rational certificates for semidefinite code bounds — the `A(n,d)` and `A(n,d,w)` tables

**The ground.** Brouwer-style tables of maximum binary code sizes `A(n,d)` and constant-weight
`A(n,d,w)`: many entries are ranges whose upper bound comes from Delsarte LP or
Schrijver-type semidefinite programming, computed in floating point by specialists and *not*
accompanied by exact certificates.

**Exact first question.** Build the pipeline: call an external SDP/LP solver, round its dual to
exact rational arithmetic, verify positive-semidefiniteness by exact `LDLᵀ` over `ℚ`, and emit a
bound certificate checkable without the solver. Calibrate on settled table entries (replay known
optimal bounds exactly); then attack range entries — first to *certify* the published bound
exactly, then, where block-diagonalization by symmetry allows a larger program, to lower it.

**What it stresses.**

- *Builds the missing certificate shape the brief names twice*: a **bound** certificate rather
  than a witness, verified by exact arithmetic.
- *Breaks* the `u8` table-backed arithmetic wholesale: this is characteristic-zero exact
  computation with big rationals — the first genuinely non-finite-field kernel.
- *Forces a genuine solver call where hand-rolled search would lose*, with the trust boundary in
  the right place: the solver is untrusted, the rational rounding and exact PSD check are the
  product. Interval/numerical-rigour discipline enters at the rounding step.
- *Strengthens*: the symmetry machinery (block-diagonalizing the SDP by the code's group is the
  same representation theory the repository already does well, aimed at a new object).
- *Leaves untouched*: search, DP, ring algebra.

**Ground truth.** Dozens of settled `A(n,d)` entries; the Delsarte LP bound at small `n` is
hand-checkable.

**Miss test.** Honest weakness: an entry where the exact certificate matches the published float
bound is a certification, not a new theorem — valuable to the instrument, modest as mathematics.
A lowered upper bound in a maintained table is a real result. Rank reflects instrument value.

**Pre-emption / gate.** The bounds themselves are published (that is the design); the gate is
confirming no one already ships exact rational certificates for these tables (the
verified-SDP/formal-proof community is the place to check) and pulling the current table state.

**Cost shape.** The rounding/verification kernel is the work — order of a week; each table entry
afterwards is cheap. The kernel is reusable for every future "bound, not value" target, including
this repository's own LP/SDP-shaped questions the C1018 record already declined for lack of it.

### 3. Sparse-space Grundy values of unsolved octal games — DP at streaming scale, with certificates for irreplayable computation

**The ground.** Combinatorial game theory's oldest computational frontier: octal games (Grundy's
game among them) whose nim-value sequences are conjectured eventually periodic, computed to ~2³⁵
values by published record computations (Flammenkamp's tables; recall-level, gate below). The
repository's `kayles` lane is dormant and never touched octal games; this is adjacent in flavour,
new in kind.

**Exact first question.** Reproduce a published record prefix for one unsolved game exactly
(calibration), then extend the record, with periodicity detection running online — a found period
plus the standard checkable window is a *theorem* (the game is solved).

**What it stresses.**

- *Builds the missing search shape*: this is pure dynamic programming over a growing table with a
  sparse working set — no exhaustion, no symmetry, no bounding. It exercises exactly the
  Tiger-style memory-hierarchy discipline the performance contract preaches, on a workload none of
  the current drivers resemble (streaming XOR-convolutions over multi-terabyte state).
- *Builds the missing certificate shape*: the computation is **too large to replay**, so the
  certificate must change kind — segment checkpoints with hashes, random spot-recomputation of
  segments from checkpoints, and an explicit statement of what the certificate does and does not
  establish. Ergodis has never had to certify anything it cannot re-run; this forces the design.
- *Strengthens*: the scheduler/resume layer (`certdist`'s durable-resume pattern, ported off the
  sharded-search special case).
- *Leaves untouched*: algebraic kernels entirely — which is fine; that is what targets 1 and 2
  are for.

**Ground truth.** The published record prefixes, value by value.

**Miss test.** Weak, and stated plainly: no census, so no miss theorem. Periodicity found = a
solved game (real theorem); not found = a record extension plus the instrument capabilities. This
target is ranked on the two capabilities alone, which are worth having for any future DP-shaped
problem.

**Pre-emption / gate.** Records are published and extending a record is unclaimed by definition;
the gate is fetching the current record state and confirming no recent closure of the chosen game.

**Cost shape.** Multi-wave and open-ended upward; the instrument value (DP layer + irreplayable
certificate design) is front-loaded in the first two waves.

### 4. A certified SAT pipeline: replay van der Waerden `W(2,6) = 1132`, then probe `W(2,7)`

**The ground.** Van der Waerden numbers: `W(2,6) = 1132` was settled by SAT (published, with the
computation reproducible); `W(2,7)` is open with only a lower bound. Not touched by this
repository; SAT-shaped by nature, with certificates (DRAT/LRAT proof logging) as first-class
published methodology.

**Exact first question.** Stand up an institutional SAT pipeline — cube-and-conquer splitting,
incremental solving, DRAT/LRAT emission, independent proof checking, shard-level resume — and
validate it by re-deriving `W(2,6) = 1132` end to end with checked proofs. Then run bounded
probes toward `W(2,7)`: raise the certified lower bound, and measure whether the upper-bound
search is within any believable budget before committing to it.

**What it stresses.**

- *Makes `sat.rs` (or its replacement) load-bearing for the first time*, and forces the choice:
  grow the in-house solver or integrate an external one behind a proof-checking boundary. The
  `g(8) = 17` result already lived on externally checked refutations; this institutionalizes that
  one-off into a capability.
- *Certificate at hostile scale*: DRAT proofs for problems this size run to terabytes; storing,
  trimming (to LRAT), and checking them is a certificate-engineering problem the current
  witness-sized formats have never met — complementary to target 3's irreplayable-computation
  problem (there the proof is too big to *produce*; here it is produced and too big to *keep*).
- *Strengthens*: the shard/resume/control-plane layer, under a workload with genuinely
  unpredictable shard costs.
- *Leaves untouched*: algebra, geometry, censuses.

**Ground truth.** `W(2,6)` itself, plus the smaller `W(2,k)` all the way down — a full calibration
ladder.

**Miss test.** The replay is calibration, not a result. `W(2,7)` itself may simply be out of
reach — say so now: the instrument value (pipeline + proof checking, which the transversal no-go
census and any future finite Ramsey-type probe would reuse) is the purchase; a certified
lower-bound improvement is the realistic mathematical exhaust.

**Pre-emption / gate.** Check the current SAT-community state on `W(2,7)` (this is an active
community with good public records); a closed or nearly-closed status kills the frontier half but
not the pipeline half.

**Cost shape.** Pipeline plus replay: one to two weeks. Frontier probes: explicitly budgeted
waves with a stop rule.

### 5. Perfect quadratic forms in dimension 9 — the target that names its own prerequisites

**The ground.** Voronoi's algorithm classifies perfect lattices/forms by exploring a finite graph:
dimension 8 is complete (10,916 forms; Dutour Sikirić–Schürmann–Vallentin — recall-level), and
dimension 9 is famously unfinished, with millions of forms known and the enumeration open. Integer
lattices and exact rational polyhedra: ground the repository has never stood on.

**Exact first question.** Not "finish dimension 9" — that is a field-scale project and pretending
otherwise would be dishonest. The question is scoped: re-derive a stated *slice* of the
dimension-8 classification (calibration), then run a certified frontier exploration of the
dimension-9 Voronoi graph from a published seed set, with exact certificates per node
(perfectness, contiguity, isometry-class distinctness).

**What it stresses — three missing capabilities, each named by the target itself:**

- **Exact rational polyhedral computation** (the Voronoi domain's dual description) — a kernel
  family Ergodis lacks entirely and that any future LP-with-exact-certificates work also wants.
- **Lattice/form isometry canonicalization** (Plesken–Souvignier-style) — the characteristic-zero
  analogue of the canonical forms the finite-field side just got.
- **Fixpoint graph closure at scale with isomorph rejection** — the search is neither exhaustion
  nor DP but a closure computation, `group_action`'s orbit BFS generalized to a world where node
  equality is itself an expensive algorithm.

*Leaves untouched*: solvers, weights, char-`p` machinery.

**Ground truth.** Dimension 8 complete; dimensions ≤ 7 tiny and classical.

**Miss test.** Weak at the frontier (a partial exploration is a record, not a census) and clean at
calibration. Ranked fifth because it teaches the most per capability but is the least likely to
produce a finished mathematical object; treat it as a capability forge with a known-good test bed.

**Pre-emption / gate.** The dimension-9 state must be pulled fresh (the Sikirić school has ongoing
work); if it is further along than my recall, the calibration value survives and the frontier
claim shrinks — the instrument case is unaffected.

**Cost shape.** The two kernels are weeks each; the exploration is then open-ended and can stop
anywhere with its certificates intact.

### 6. Erdős–Straus-type unit-fraction verification with residue-class certificates

**The ground.** `4/n = 1/x + 1/y + 1/z`: verified by published computation to around `10¹⁷`
(recall-level), with the classical method proving whole residue classes at a stroke via polynomial
identities and leaving a sparse exceptional set to machine search. Plain integers — no field, no
geometry.

**Exact first question.** Reproduce the residue-class covering system and the verified bound on a
smaller prefix (calibration), then extend the verified range with a two-layer certificate: the
**parametric layer** (each covering congruence is a checkable polynomial identity disposing of
infinitely many `n`) and the **finite layer** (explicit witnesses for the exceptional residues).

**What it stresses.** One thing, cleanly: the **parametric certificate** — a certificate whose
single checkable algebraic object covers infinitely many cases, composed with a finite witness
list. Ergodis has never emitted one, and the shape (identity + exceptional cells + the claim that
the union is everything) is exactly what several of the repository's own "the family stops here"
statements would want in machine-checkable form. Also exercises integer sieving kernels (cheap,
new). *Leaves untouched*: almost everything else — which is why it is last: narrow lesson, lowest
cost, lowest risk.

**Ground truth.** The published verification bound and the classical covering identities.

**Miss test.** Range extension is record-shaped, not theorem-shaped; the parametric-certificate
module is the real deliverable.

**Pre-emption / gate.** Verify the current record (active amateur-professional area; my `10¹⁷` may
be stale). A bigger published record just moves the start line.

---

## 3. Good mathematics, bad instrument tests

Named so they are not re-proposed; each fails the instrument criterion, not the prestige one.

- **Small Ramsey numbers (`R(3,10)`, `R(4,6)`, …).** SAT-and-isomorph-free-generation territory
  with a dedicated expert community and enormous budgets; everything it would exercise, target 4
  exercises cheaper with a full calibration ladder. Prestige high, marginal teaching near zero.
- **Counting Latin squares of order 12 / Steiner triple systems on 21 points / Dedekind `D(10)`.**
  Each stalled for want of a *method* breakthrough, not a capability Ergodis could plausibly build;
  "hopeless by current methods" without the "falls to one specific missing capability" half.
- **Hyperoval classification in `PG(2,128)`.** Scale-only stress inside the existing
  finite-geometry comfort zone — precisely the "runs entirely inside code paths we already stress"
  case the brief discounts — plus classical-geometry pre-emption exposure. (Recall says `q = 64`
  closed recently; even the gate read favours skipping.)
- **Transitive-group or CAS-adjacent tables (degree-49 transitive groups, class-group tables).**
  The only lesson available is that GAP/Magma/PARI win on their home ground, which we already
  know.
- **Maximal-determinant `{±1}` matrices.** The best table-with-gaps fit for exact search on new
  ground — and squarely inside the Hadamard-adjacent exclusion owned by another agent. Recorded,
  not judged.

## 4. Cross-cutting notes

1. **The calibration suite is a deliverable in its own right.** Whatever subset is pursued, the
   replayed rungs (Kerdock Lee distances, settled `A(n,d)` entries, a dimension-8 slice,
   `W(2,6)`, record prefixes) should be frozen into a permanent instrument regression suite — the
   ground-truth harness the brief says caught this week's errors, made systematic across every new
   kernel.
2. **Axes this list leaves uncovered, said rather than padded.** p-adic and number-field
   arithmetic: no target found this session where Ergodis would not simply lose to PARI on its
   home ground; the axis stays open for a better candidate. `zdd.rs`: no ranked target makes it
   load-bearing — the honest options are to find a hitting-set/exact-cover-shaped frontier
   later or accept the module as speculative.
3. **Complementarity with the standing portfolio.** Targets 2 and 4 build capabilities the
   existing portfolio already wants (bound certificates for LP/SDP-shaped questions the C1018
   record declined; a proof-logged SAT layer for the transversal no-go census); targets 1, 3, 5
   are pure new ground. Nothing here competes with any queued row.

## 5. Trust boundary

All target states — which table cells are open, current records, classification frontiers — are
recall-level from a January 2026 cutoff, fetched nothing this session, and each target's
verification gate exists precisely because of that. The §1 capability inventory is read from
source and this week's reports. Rankings are one session's judgement, provisional under the lane's
vet rule; this session did not self-vet and did not commission a vet.
