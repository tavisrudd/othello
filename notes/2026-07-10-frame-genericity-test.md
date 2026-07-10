# Frame: genericity test — is plane-P structural or generic?

**Date**: 2026-07-10
**Session**: 8b6d1419-df84-4895-8bec-907fb3a79c36 (Fable delegate)
**Question**: the program's main conjecture (`PG(2,q)` is P for all odd q) has no heuristic
argument. Is the P verdict at plane-like parameters STRUCTURAL (driven by the algebraic
geometry) or GENERIC (typical for boards with these densities)? Either answer redirects the
proof effort.

**Verdict up front**: **structural, decisively, at q=5 and q=7** — uniform random boards with
exactly the plane's vertex count and triple count are N in 200/200 samples at both orders,
while the planes are P. The deeper finding is that the generic outcome is not a constant at
all: it **oscillates in density bands** between near-0 and near-1 P-frequency, and the plane
parameter point sits in a hard generic-N band at q=5 and q=7 (with generic-P bands on both
sides at q=7) but in a generic-P band at q=9. The plane is P at every order regardless of
which band its parameters fall in — the conjecture's uniformity over q is itself the
strongest anti-generic feature. A soft/typicality proof shape is ruled out; the algebraic
structure is load-bearing.

## Three-way distinction (dedupe against adjacent probes)

Three superficially similar randomization probes attack different axes; none subsumes another:

| Probe        | Board population                                        | Axis tested                                                    |
|--------------|---------------------------------------------------------|----------------------------------------------------------------|
| C58 (queued) | The four true projective planes of order 9              | Same order, different algebra (Desarguesian vs not)            |
| Es1 (sweep)  | Random SUB-boards (point subsets) of the true plane     | Density thinning of the true structure                         |
| This frame   | Random BOARDS matched to the plane's (n, m) parameters  | Typicality of the parameter point (no plane structure at all)  |

This frame's band result feeds both: for Es1, sub-board thresholds must be measured as a full
retention curve (single-density samples will alias the bands); for C58, see §Implications.

## Game and solver

Game: players alternately select vertices of a 3-uniform hypergraph on `n` vertices; the
selected set must never contain a forbidden triple; the player unable to move loses (normal
play). Empty-position value P = second-player win. On the plane's collinearity-triple
hypergraph this is exactly the cap game.

Solver (`genericity.rs`, standalone Rust, `rustc -O -C target-cpu=native`): memoized negamax
over `u128` bitmasks (n ≤ 91), per-pair completion masks `comp[a][b]` = bitset of x with
{a,b,x} forbidden, blocked-set threaded incrementally down the DFS, memo keyed on the selected
set alone, early cutoff at the first losing child, per-board memo cap (default 200M entries;
cap hit ⇒ verdict UNKNOWN, never a guess). Per-board memo freed between samples.

### Validation gates (all machine-checked, all PASS)

1. **Plane construction**: points/lines of `PG(2,q)` built from GF(q) (GF(9) as
   GF(3)[t]/(t²+1)); asserted exactly: point count = line count = q²+q+1, every line has q+1
   points, every point pair on exactly one line, every line pair meets in exactly one point.
   Output: `VERIFY plane q={5,7,9}: PASS`.
2. **Free-placement parity**: boards with no triples, n = 1..8, must be P iff n even — PASS.
3. **Triangle board** (3 points, 1 triple): must be P — PASS.
4. **Reference planes**: the solver reproduces the known verdicts P for PG(2,5), PG(2,7),
   PG(2,9) (memo sizes 2,071 / 28,896 / 485,827; ≤ 0.07 s each).
5. **Independent cross-check**: a separate plain-recursion Python solver (`crosscheck.py`, no
   shared code beyond the RNG spec) replayed 50 uniform random boards (n=12, m=30, seeds
   777000..777049): 50/50 verdict agreement — PASS.
6. **Per-sample structure gates** (asserted on every sampled board before solving):
   - randh/randm: exactly m distinct triples, all indices < n;
   - nearlin: every line has exactly q+1 sorted distinct points, every point pair covered at
     most once;
   - perturb: triple count preserved (= m) and all triples distinct after every swap sequence.
   Any assert failure aborts the run; none fired.

### RNG and seeds

SplitMix64 (constants 0x9E3779B97F4A7C15 / 0xBF58476D1CE4E5B9 / 0x94D049BB133111EB), bounded
sampling by rejection. Per-board seed = base_seed + board_index; for perturb, seed =
base_seed + 100000·strength_index + board_index. Base seeds: randh q5/q7/q9 =
10000/11000/12000; nearlin q5/q7 = 20000/21000 (q7 boards 13..24 resumed as base 21013 after
an OOM kill, preserving the planned per-board seeds); perturb q5/q7/q9 = 30000/31000/32000,
refinement strengths q5/q7 = 33000/34000; density sweeps randm = 40000+m (n=31), 50000+m
(n=57), 60000+m (n=91); cross-check = 777000. Sizing probes (seeds 1000-5001) preceded the
production runs and are consistent with them; production tables below use only the documented
base seeds.

## Ensembles (generators, verbatim)

Plane parameters: n = q²+q+1 vertices, m = n·C(q+1,3) collinearity triples.
q=5: n=31, m=620. q=7: n=57, m=3192. q=9: n=91, m=10920.

- **(a) randh** — uniform random 3-uniform hypergraph: sample unordered vertex triples
  uniformly (three independent uniform draws, reject collisions and repeats) until exactly m
  distinct triples are collected.
- **(b) nearlin** — random maximal partial linear space with line size k=q+1: repeatedly grow
  a candidate line point-by-point, each next point uniform over the points whose pairs with
  all current line points are uncovered; a line stuck below size k is a failed attempt;
  accept full lines and mark their pairs covered; stop after 2000 consecutive failed attempts
  (or at n lines, never reached). Forbidden triples = all C(k,3) triples of each accepted
  line. Achieved line counts: q=5: 15-18 of 31 (triples 300-360 of the plane's 620); q=7:
  23-26 of 57 (triples 1288-1456 of 3192). Random greedy packing cannot reach the plane's
  line count — a full (q²+q+1)-line packing IS a projective plane — so this ensemble is
  structurally matched but density-deficient; read it with that confound in mind.
- **(c) perturb** — true plane triple set, s random swaps (remove one uniform present triple,
  add one uniform absent triple), preserving |T| = m exactly. Strength quoted in per-mille of
  m (s = round(pm·m/1000)); the effective distance |T \ T_plane| is recorded per board (swaps
  partially cancel, so eff_dist < s at large s).
- **(d) randm** — density sweep: uniform random 3-uniform hypergraphs at fixed n with m swept
  around the plane point (same generator as (a)).

## Results

P-frequency per (ensemble, order), exact counts, Wilson 95% CIs. Reference: the true planes
are P at all three orders.

### (a) Uniform random hypergraphs at exact plane parameters

| q | n  | m     | boards | P  | N   | P-freq | 95% CI          |
|---|----|-------|--------|----|-----|--------|-----------------|
| 5 | 31 | 620   | 200    | 0  | 200 | 0.000  | [0.000, 0.019]  |
| 7 | 57 | 3192  | 200    | 0  | 200 | 0.000  | [0.000, 0.019]  |
| 9 | 91 | 10920 | 50     | 50 | 0   | 1.000  | [0.929, 1.000]  |

The plane agrees with the generic verdict only at q=9; at q=5 and q=7 it contradicts it with
generic P-probability bounded below 1.9% per order (and the two orders jointly below ~4·10⁻⁴
under independence).

### (d) Density sweeps — the generic verdict oscillates in bands

n=31 (plane point m=620), 100 boards per m:

| m      | 155   | 310   | 465   | **620**   | 775   | 930   | 1240  | 1860  | 2480  |
|--------|-------|-------|-------|-----------|-------|-------|-------|-------|-------|
| P-freq | 0.120 | 0.020 | 0.780 | **0.000** | 0.060 | 0.920 | 0.000 | 0.530 | 0.960 |

n=57 (plane point m=3192), 50-200 boards per m:

| m      | 2394  | **3192** | 3990  | 4788  | 6384  |
|--------|-------|----------|-------|-------|-------|
| P-freq | 1.000 | **0.000**| 1.000 | 0.000 | 0.330 |
| boards | 50    | 200      | 100   | 100   | 100   |

n=91 (plane point m=10920; the m=10920 column is the ensemble-(a) q=9 run):

| m      | **10920** | 12285 | 13650 | 16380 |
|--------|-----------|-------|-------|-------|
| P-freq | **1.000** | 1.000 | 0.000 | 0.083 |
| boards | 50        | 12    | 12    | 12    |

(The m=12285 cell is 12 unique seeds; a timed-out first attempt duplicated 4 of them in the
raw TSV with identical verdicts — deduped by seed here. Sparser-than-plane m at n=91 was not
swept: the memo estimate exceeds the memory budget; see Compute record.)

The generic outcome is a band structure in density, swinging between near-0 and near-1. At
q=7 the plane's exact parameter point sits at the bottom of a generic-N band with all-P bands
on BOTH sides (m=2394 and m=3990 are 50/50 and 100/100 P). PG(2,7) being P is therefore not
"near-miss generic" — the generic verdict at its parameters is as firmly N as anywhere in the
sweep. [Speculation, labeled: the bands presumably track the parity of typical optimal game
length, which shortens as density grows; per-board search-depth parity does NOT predict the
verdict (cross-tab on the q=5/q=7 randh rows shows N at both parities), so the mechanism is
not a superficial max-cap parity and remains uncharacterized.]

### (b) Random maximal partial linear spaces

| q | boards | P | N  | UNKNOWN | P-freq | 95% CI         | lines achieved                  |
|---|--------|---|----|---------|--------|----------------|---------------------------------|
| 5 | 100    | 8 | 92 | 0       | 0.080  | [0.041, 0.150] | 15-18 of 31                     |
| 7 | 25     | 7 | 18 | 0       | 0.280  | [0.143, 0.476] | 23-26 of 57                     |
| 9 | 1      | 0 | 0  | 1       | —      | —              | infeasible (see Compute record) |

Local linear-space structure with the plane's exact line size does not reproduce P: the
ensemble is N-dominated at both solved orders. Confound, stated plainly: these boards carry
only ~half the plane's triple density (see generator note), so they are not at the plane
parameter point; at q=5 their density range (m≈300-360) spans randm bands with P-freq
0.02-0.78, and the observed 0.08 is compatible with the density effect alone. This ensemble
separates structure from density only weakly.

### (c) Perturbed true planes — the response curve

Strength in per-mille of m (swaps); eff = |T \ T_plane| range. All rows exact-solved, zero
UNKNOWN.

q=5 (m=620, 50 boards per strength):

| pm     | 2    | 5    | 10   | 20   | 50   | 100  | 200  | 250  | 300  | 350  | 400  | 450  | 500  | 1000 |
|--------|------|------|------|------|------|------|------|------|------|------|------|------|------|------|
| P-freq | 1.00 | 1.00 | 1.00 | 1.00 | 1.00 | 1.00 | 1.00 | 0.78 | 0.34 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |

q=7 (m=3192, 25 boards per strength):

| pm     | 2    | 5    | 10   | 20   | 50   | 60   | 75   | 85   | 100  | 125  | 150  | 200  | 300  | 400  | 500  | 700  | 850  | 1000 |
|--------|------|------|------|------|------|------|------|------|------|------|------|------|------|------|------|------|------|------|
| P-freq | 1.00 | 1.00 | 1.00 | 1.00 | 1.00 | 1.00 | 1.00 | 0.96 | 0.64 | 0.04 | 0.60 | 0.96 | 1.00 | 1.00 | 1.00 | 0.16 | 0.00 | 0.00 |

q=9 (m=10920, 20 boards per strength):

| pm     | 2    | 5    | 10   | 20   | 50   | 100  | 200  | 500  | 1000 |
|--------|------|------|------|------|------|------|------|------|------|
| P-freq | 1.00 | 1.00 | 1.00 | 1.00 | 1.00 | 1.00 | 0.00 | 0.90 | 1.00 |

Readings:

- **Stability plateau**: the exact plane's P survives every tested corruption up to 20% of
  triples swapped at q=5 (P-freq 1.00 through pm=200) and up to ~8.5% at q=7 (1.00 through
  pm=75, 0.96 at 85). The plane's P verdict is robust, not knife-edge — consistent with the
  W-L margin structure the escape censuses see (many P witnesses per size-3 class), and a
  constraint on proof shape: whatever mechanism forces P has slack.
- **Oscillatory decay, not collapse**: beyond the plateau the curve is non-monotone (q=7:
  dip to 0.04 at pm=125, recovery to 1.00 across pm=300-500, terminal fall to 0.00). The
  perturbation trajectory crosses the same generic bands as the density sweep rather than
  monotonically "losing structure". q=9 is the sharpest case: plane (pm=0) and fully-swapped
  (pm=1000) are both P, yet the curve passes through an exact-0.00 N band at pm=200 — even
  where the endpoints agree, the interpolation is band-driven, not a smooth structure decay.
- The terminal value matches the randh band verdict at each order's parameter point (N at
  q=5/q=7, P at q=9) even though a fully-swapped board still shares ~40% of its triples
  with the plane (eff_dist saturates near 0.6m) — the residual plane skeleton at that dilution
  contributes nothing detectable.

## Compute record

Single box, all runs on 2026-07-10; ensembles ran as a few sequential command streams, at
most three concurrent, peak combined solver RSS ~6 GB (within the 8 GB gate; the one OOM
incident below happened at the concurrency peak). Totals across all
production TSVs: 3,195 board-solves, 2.23·10¹⁰ solver nodes, 2,817 s of solve time (~47
core-minutes) — far inside the 4 h budget. Every production row except the two noted
UNKNOWN/infeasible probes below is an exact solve (zero memo-cap aborts).

Incidents and infeasibility records:

- The first nearlin q=7 batch was OOM-killed at board 13 while running concurrently with two
  other streams (its largest boards reach ~1.6·10⁸ memo entries ≈ 5 GB); the 13 completed
  rows are valid (each printed post-solve), and boards 13-24 were rerun alone with the
  planned seeds (base 21013). Combined ensemble: 25 boards, all exact.
- nearlin q=9 is infeasible within the memory gate: the seed-23000 board (33 lines of 91
  achieved, 3,960 triples) exceeded a 2.5·10⁸-entry memo attempt (OOM-killed) and then hit a
  controlled 1.2·10⁸-entry cap at 3.3·10⁸ nodes with search depth already ≥ 19 — verdict
  UNKNOWN, recorded, ensemble dropped. Sparser-than-plane randm points at n=91 (m < 10920)
  were skipped for the same reason (the state count grows steeply as density falls below the
  plane point).

## Interpretation

1. **The structural-vs-generic question has a clean answer at the solved orders: structural.**
   At q=5 and q=7 the plane is P while 400/400 parameter-matched random boards are N. P at
   plane-like parameters is rare, not typical. The algebraic geometry is load-bearing.
2. **The q=9 agreement is a band coincidence, not evidence of genericity.** The generic
   verdict itself flips with order (N-band at q=5/q=7, P-band at q=9 — with an N-band just
   above it at n=91, m=13650),
   while the plane is P at every order. Under the generic model the plane family's verdict
   would track the bands as q grows; the conjecture asserts it never does. The uniformity of
   the conjecture over all odd q is precisely the anti-generic content.
3. **Consequences for the proof-shape ranking**
   ([frame-proof-shape-census](2026-07-09-frame-proof-shape-census.md)): this is an
   independent, direct confirmation that S15 (first-moment / concentration / typicality) is
   dead — a typicality argument would derive the wrong verdict at q=5 and q=7. The two
   survivors are unaffected in ranking but sharpened in flavor: both S10 (discharging over a
   finite configuration alphabet) and S11 (entropy compression for the maintenance selector)
   must consume *geometric* structure (conic localization, incidence arithmetic), not
   density/counting structure, because density alone points the other way at two of the three
   solved-and-sampled orders. Conic localization is NOT disposable scaffolding; the data is
   consistent with the C42 negative (P holds orbit-by-orbit for geometric reasons, not by any
   uniform census/counting mechanism).
4. **Consequences for C58 (order-9 non-Desarguesian planes).** The order-9 parameter point is
   generic-P (random boards there are 50/50 P), so an all-P outcome across
   PG(2,9)/Hall/dual-Hall/Hughes would be band-consistent and only weak evidence about
   structure. An N verdict on any order-9 plane would now be doubly informative: a structured
   board defying a generic-P band, and the falsification-map constraint (conjecture is about
   Desarguesian structure, not order) simultaneously. [Speculation, labeled: the sharpest
   version of C58 would be a non-Desarguesian plane at an order whose parameter point is
   generic-N, like q=5/7 are; the smallest non-Desarguesian orders 9, 16 (even — closed P by
   theorem), 25, 27 make this currently out of exact-solve reach.]
5. **Connection to Es1 (random sub-boards of the true plane).** The band structure predicts
   Es1's retention-density curve will oscillate rather than cross one threshold; a
   single-density sub-board sample would alias the bands and mislead. Es1's informative
   content is where the *true plane's* thinned boards deviate from randm boards of matched
   (n, m) — the deviation, not the raw frequency, measures how far down the structure
   persists. The perturbation plateau here (P survives 8.5-20% triple corruption) is the
   analogous structure-persistence measurement in the swap direction.
6. **Bounded negative worth recording**: max-cap-depth parity does not explain the bands
   (verdict-vs-parity cross-tab is mixed in every randh ensemble), so the band mechanism —
   presumably a typical-optimal-game-length parity effect — is a real open micro-question,
   adjacent to the Es2/game-saturation spinoff (game length as an arc-theoretic quantity).

## Reproduction

All code and raw TSVs under the session scratchpad
(`/tmp/claude-1000/-home-tavis-src-othello-rust/8b6d1419-df84-4895-8bec-907fb3a79c36/scratchpad/genericity/`):
`genericity.rs` (solver + generators + gates), `summarize.py` (P-frequency/CI tables),
`crosscheck.py` (independent solver agreement). Build: `rustc -O -C target-cpu=native
genericity.rs -o genericity`. Modes: `calib`, `plane q`, `randh q count base_seed
[memo_cap]`, `nearlin q count base_seed [memo_cap]`, `perturb q count base_seed [memo_cap]
[strengths_pm...]`, `randm n m count base_seed [memo_cap]`. The scratchpad is
session-temporary; regenerate from the seeds above (every table is exactly reproducible from
the documented base seeds).
