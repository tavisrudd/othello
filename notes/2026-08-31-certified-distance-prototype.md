# Certified exact minimum-distance service — first prototype (`certdist`)

**Lane:** `gem-mining` (commercial prototype, not a math task)

**Date:** 2026-08-31

**Status:** prototype complete; acceptance gate passed.

## 1. What this is

`certdist` is a job-level driver that turns the Ergodis one-shot exhaustive CSS
distance search into a service-shaped workflow. It computes nothing the Ergodis
core cannot already compute: every exhaustion is performed by the core's own
`css_distance_native`, driven as a subprocess exactly as shipped. What it adds
is the operational layer a paying user needs and the current tooling lacks.

1. A live `[lower, upper]` **bracket with provenance on each side**, so an
   interrupted job still yields a usable answer instead of nothing.
2. A **competitive upper-bound pass**, pluggable and always recorded.
3. **Durable resume** across process, session and machine boundaries, built on
   the core's deterministic search sharding.
4. A **checkable certificate** plus a `verify` mode whose cost is measured
   against production cost.
5. An **up-front feasibility estimate** obtained by sampling shards of the
   target radius, so a job can be declined honestly before hours are spent.

The whole prototype is one file, `ergodis-private/src/bin/certdist.rs`. Nothing
under `papers/complete-repair-ports/ergodis/` is modified.

## 2. What the core actually exposes

The two prior reports are stale on the two points that most affect this design.
Both were checked by reading the current core source, not by re-reading the
reports.

### 2.1 Sharding exists, and it is the whole reason this prototype works

Section 7 item 3 of `notes/2026-08-31-c1018-hunt-756-distance.md` records "there
is no way to split one radius across invocations" as the binding constraint that
left `[[756,16,d]]` unfinished. **That constraint is gone.**
`css_distance_native` now takes `--shard-index` and `--shard-count` (1 to 4096),
backed by `CssSearchShard` in `src/css_distance.rs`. The doc comment states the
contract exactly: "Running every index in `0..count` with identical source,
radius, anchors, and build semantics covers the unsharded search exactly. A
single shard's result is partial and must not be reported as a global distance
result." A shard's run record declares `result_scope: "partial-shard"` and
carries its `search_shard` identity, so a partial result cannot be mistaken for
a global one by accident.

Mechanically, on the syndrome-driven backends the search expands depth-limited
prefixes until it holds at least `16 * shard_count` of them, then keeps the
prefixes whose index is congruent to `shard_index` modulo `shard_count`; on the
compact backend the same modular filter is applied to the depth-one root
branches. Sharding is applied inside every anchor, so each shard covers all
anchors and a partial prefix set, rather than a subset of anchors.

Three consequences matter for a service:

- **Shards are unbalanced.** They are a modular partition of a branch list whose
  members have wildly different subtree sizes. Measured spread on one code below.
- **Candidate counts do not add up to the unsharded count.** Each shard repeats
  the prefix expansion and counts it, and shards do not share improved bounds, so
  a sharded run explores a somewhat different candidate set than one process
  would. The *conclusion* is identical; the counter is not a replay fingerprint.
  (The 756 report already found `candidates` unstable across core revisions for a
  different reason.)
- **Sharding is the resume mechanism.** A shard either completed or it did not;
  there is no half-finished shard state to persist.

### 2.2 `css_distance_random` is no longer plain Prange

Section 7 item 4 of the same report says the core's witness finder "inspects
single kernel basis vectors with no combination step". As of core commit
`b10993f4a` (*perf: add bounded osd to css witness search*, today) it takes
`--osd-order` (1 or 2) and `--osd-window` (default 96) and performs bounded
ordered-statistics decoding over the lightest induced basis vectors. The
"two million trials found nothing at weight 34" figure in the brief was measured
against the older order-0 behaviour.

`certdist` therefore ships **two** upper-bound sources and a hook for a third,
and records which one produced every witness.

### 2.3 Things the core still does not expose

- **Compiled filter artifacts are not versioned in a forward-compatible way.**
  Confirmed unchanged. `certdist` treats the artifact as job-local cache, never
  as durable evidence, and rebuilds it when the recorded radius does not match.
- **The input format carries no automorphism generators.** The anchor set is the
  single largest cost reduction available (42x to 60x on the abelian candidates)
  and it is also the one load-bearing fact a verifier cannot re-derive. See
  §7 interface request 1.
- **`large-css` is a feature of the dependency, not a runtime switch.** The
  `ergodis-private` crate declares `features = ["control-plane", "parallel"]` and
  the brief forbids editing its `Cargo.toml`, so a binary inside that crate can
  never link the large backends. Driving the core binary as a subprocess is
  therefore not merely a convenience: under the stated constraints it is the only
  way for a private-crate tool to reach instances above 384 coordinates.

## 3. Design

### 3.1 Job shape

A job is a directory. Everything needed to resume it lives there.

```
<job>/
  job.json                  code identity, parity gate, anchors, input sha256
  input.json                byte-identical copy of the input
  filter.ergocsl            compiled filter (job-local cache, not evidence)
  filter.json               the compile run record
  upper/<source>-<seed>.json   one record per upper-bound pass, best kept
  w016-n0032/shard-0000.json   one core run record per completed shard
  metrics.jsonl             append-only timings and peak RSS
  certificate.json          the canonical, timing-free certificate
```

A shard record is written by rename from a temporary file, so a kill at any
instant leaves either a complete record or none at all. Resume is therefore
trivially correct: `run` walks `0..shard_count`, skips every index whose record
exists and declares the matching shard identity and radius, and executes the
rest. Nothing is checkpointed mid-shard, so shard count is the resume
granularity knob, traded against the per-shard prefix-expansion overhead.

### 3.2 The bracket

`certdist` never reports a bare number. Every job reports

- `lower`, with provenance. A complete shard cover through searched weight `R`
  that found nothing gives `d >= R + 1`; when the all-ones vector lies in the row
  space of the physical checks every logical operator has even weight, so an odd
  `R + 1` lifts to `R + 2`. `certdist` recomputes that membership test itself
  from the input rather than trusting the core's `kernel_weights_even` flag.
- `upper`, with provenance, from the best **re-verified** witness across the
  enumeration and every upper-bound pass. A witness whose re-verification fails
  is recorded and refused, never used.
- `exact`, and the list of admissible values under the parity gate.

A complete cover that *does* find a witness at weight `w` pins the distance
exactly, because everything lighter was enumerated; that case collapses the
bracket to `[w, w]`.

Partial covers are honest: an interrupted job keeps the lower bound of the
deepest *complete* level and the best witness found so far, and `status` prints
both plus the shard progress.

### 3.3 Upper-bound sources

Pluggable, selected by `--upper`, and the source string is written into the
certificate with every witness.

- `builtin-osd` — a multi-threaded ordered-statistics information-set decoder
  written for this prototype: random column order, Gaussian elimination to
  reduced row echelon form, induced systematic kernel basis, then every
  combination of up to `--upper-order` of the `--upper-window` lightest basis
  vectors. Order 1 is plain Prange. The logical syndrome of each basis vector is
  accumulated during construction as a `k`-bit mask, so testing a combination
  costs one exclusive-or and one population count rather than a matrix product,
  which is what makes order 2 and 3 affordable.
- `core-random` — the core's own `css_distance_random`, including its new
  bounded OSD.
- `external:<command>` — any command that prints JSON with a `witness` array.
  Intended for a Python BP-OSD pass via `uv run --with ldpc`; the exact command
  is recorded.

Every witness from every source, including the core's, is re-verified over
GF(2) from the input by `certdist` itself — zero physical syndrome and at least
one logical observation triggered — before it is allowed to move the bracket.

### 3.4 Feasibility estimate

`certdist plan` does not extrapolate a growth model across radii. It compiles
the filter and then **runs a sample of shards at the target radius itself**,
reporting the mean, the observed spread, the projected total, and the sampled
peak resident set. Sampling `s` of `N` shards costs about `s/N` of the job.
Because the sampled shards are real work, they are kept and counted toward the
job: planning is not wasted effort.

The report prints the anchor reduction factor next to an explicit statement that
it is structure-dependent and taken on trust from the input, so a 42x cut is
never silently assumed to generalise.

## 4. Acceptance: the six Liu–Marquardt lifted-product codes

The regression set is the six structured-concept-evolution lifted-product
candidates of Liu and Marquardt (arXiv:2606.24808v1, Section S7) closed by
`notes/2026-08-31-c1018-hunt-qldpc-sweep.md`. Every one was re-derived here
through the `certdist` job interface — sharded exhaustion, built-in
ordered-statistics upper-bound pass, certificate, code-level combination — using
the same twelve input files and the same core.

### 4.1 Verdicts

| code | published QDistRnd bound | committed exact value | `certdist` verdict | match |
|:---|---:|---:|:---|:--|
| `R1Elite01`  | <= 18 | 18 | d = 18 (exact) | yes |
| `R1Elite02`  | <= 16 | 16 | d = 16 (exact) | yes |
| `R3Elite01`  | <= 16 | 16 | d = 16 (exact) | yes |
| `R3Elite02`  | <= 14 | 14 | d = 14 (exact) | yes |
| `R3EliteP01` | <= 18 | 18 | d = 18 (exact) | yes |
| `R3EliteP02` | <= 20 | 20 | d = 20 (exact) | yes |

All six agree exactly with the committed results. Nothing here is a new
mathematical result; the point of the exercise is that the service pipeline
reproduces them end to end.

Per side, showing which side of each code is the binding one and where its upper
bound came from:

| code | side | lower | upper | side verdict | witness source |
|:---|:--|---:|---:|:---|:---|
| `R1Elite01`  | x | 18 | 20 | 18 <= d <= 20 | builtin OSD |
| `R1Elite01`  | z | 18 | 18 | d = 18 | builtin OSD |
| `R1Elite02`  | x | 16 | 16 | d = 16 | enumeration |
| `R1Elite02`  | z | 18 | 20 | 18 <= d <= 20 | builtin OSD |
| `R3Elite01`  | x | 16 | 18 | 16 <= d <= 18 | builtin OSD |
| `R3Elite01`  | z | 16 | 16 | d = 16 | builtin OSD |
| `R3Elite02`  | x | 14 | 14 | d = 14 | enumeration |
| `R3Elite02`  | z | 16 | 16 | d = 16 | builtin OSD |
| `R3EliteP01` | x | 18 | 18 | d = 18 | builtin OSD |
| `R3EliteP01` | z | 18 | 20 | 18 <= d <= 20 | builtin OSD |
| `R3EliteP02` | x | 20 | 20 | d = 20 | builtin OSD |
| `R3EliteP02` | z | 20 | 20 | d = 20 | builtin OSD |

The built-in ordered-statistics decoder, at order 2 with a window of 96 and
20,000 trials per side, produced a witness at the true side distance on ten of
the twelve sides; on the other two the enumeration itself returned the witness
first. It never failed to close a side that the enumeration left open. On the
four sides where the code's own distance lives on the other side it returned a
weight two above the exhausted radius, which is the correct answer for that
side, not a failure.

### 4.2 Cost, sharding overhead, and memory

Timings are wall-clock on a 24-core host that was **heavily contended
throughout** by an unrelated concurrent job; load average ranged from 35 to 61
against 24 cores. They are upper bounds on the uncontended cost and should not be
compared with the timings in the earlier sweep report, which ran under different
contention. The candidate counts are exact and machine-independent.

| code | side | radius | shards | search s | wall s | shard overhead s | peak shard RSS MiB | upper pass s | candidates (32 shards) | candidates (one shot, prior report) | inflation |
|:---|:--|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `R1Elite01`  | x | 16 | 32 |  42.1 |  49.1 |  7.0 | 22.8 | 30.9 |    767,874,405 |    764,931,405 | +0.38% |
| `R1Elite01`  | z | 16 | 32 |  83.8 |  91.6 |  7.9 | 22.8 | 39.8 |  2,022,763,628 |  2,019,824,133 | +0.15% |
| `R1Elite02`  | x | 16 | 32 |  35.9 |  43.9 |  8.0 | 24.4 | 40.8 |    385,401,304 |    270,913,307 | +42.26% |
| `R1Elite02`  | z | 16 | 32 |  84.5 |  93.4 |  8.8 | 24.4 | 43.9 |  1,901,882,895 |  1,898,939,462 | +0.16% |
| `R3Elite01`  | x | 14 | 32 | 521.1 | 532.5 | 11.4 | 24.3 | 40.1 |  1,909,833,258 |  1,845,032,259 | +3.51% |
| `R3Elite01`  | z | 14 | 32 | 724.3 | 736.2 | 11.9 | 24.3 | 47.8 |  3,685,190,975 |  3,620,460,887 | +1.79% |
| `R3Elite02`  | x | 14 | 32 | 319.9 | 330.1 | 10.2 | 24.3 | 56.1 |    876,402,180 |    898,767,944 | -2.49% |
| `R3Elite02`  | z | 14 | 32 | 412.0 | 420.2 |  8.3 | 24.3 | 54.3 |  3,607,738,784 |  3,543,088,140 | +1.82% |
| `R3EliteP01` | x | 17 | 32 |  27.7 |  33.2 |  5.5 | 23.8 | 36.1 |    803,750,343 |    802,548,070 | +0.15% |
| `R3EliteP01` | z | 17 | 32 |  36.4 |  42.4 |  6.0 | 23.8 | 30.9 |  1,062,789,631 |  1,061,591,915 | +0.11% |
| `R3EliteP02` | x | 19 | 32 | 279.8 | 287.4 |  7.7 | 23.8 | 31.9 |  7,949,516,814 |  7,948,318,726 | +0.02% |
| `R3EliteP02` | z | 19 | 32 | 299.5 | 306.0 |  6.5 | 23.8 | 33.2 | 13,407,186,395 | 13,405,995,220 | +0.01% |

Three things in that table are worth stating plainly.

**Sharding is nearly free when the search finds nothing, and expensive when it
finds something.** On the nine sides where the exhaustion returned no witness the
inflation is between +0.01% and +1.8%, which is just the repeated prefix
expansion. On `R1Elite02`'s X side it is **+42%**, and the mechanism is clear:
the one-shot search finds a weight-16 logical operator early, publishes the
improved bound to every worker, and prunes the rest of the space hard, whereas 32
independent shards each have to rediscover it or run without it. `R3Elite02`'s
X side goes the other way, at -2.5%, because there a shard happens to find its
witness earlier than the one-shot search does. So sharding trades a bounded
amount of extra work for resumability, and the size of that trade depends on
whether the answer is a witness or a negative. **This is the single most
actionable finding for the core**: see interface request 11.

**Peak resident memory is flat and small.** 22.8 to 24.4 MiB per shard on the
1428- and 1496-coordinate instances, 23.8 MiB on the 1500-coordinate ones, across
a candidate range from 3.9e8 to 1.3e10. The `certdist` driver process itself
peaks around 87 MiB while parsing the input and running the OSD pass, which
dominates the job's total. Memory is nowhere near being a constraint; the whole
sweep would fit in a container with a 256 MiB limit.

**Per-shard process overhead is 0.17 s to 0.37 s**, entirely the compiled-filter
reload, and it is 11% to 18% of these jobs' wall time at 32 shards. That fraction
scales linearly with shard count, so it is the price of resume granularity and
the thing interface request 2 would remove.

### 4.3 The feasibility estimate, checked against the outcome

`certdist plan` sampled 3 of 32 shards of `R1Elite01`'s X side at the target
radius and projected 46.0 s of total search from a per-shard spread of 1.19 s to
1.91 s. The full 32-shard run took 42.1 s of search. The projection was 9% high
on a 3-shard sample, which is the accuracy a job-acceptance decision actually
needs, and it cost 3/32 of the job to obtain — work that was then kept and
counted toward the job rather than thrown away.

## 5. Resume

The single binding constraint recorded in the 756-coordinate work was that a
long radius must run as one uninterrupted process. This is the prototype's main
proof of value, so it is demonstrated adversarially: not by a clean shutdown but
by `SIGKILL` to the whole process group, twice, so the in-flight
`css_distance_native` child dies with the driver and no cleanup path runs.

Instance: `R1Elite02`'s Z side (`r1elite01-z.json`, 1428 coordinates), radius 16,
32 shards, 8 threads per shard, upper-bound pass disabled on both arms so the
certificates are directly comparable.

| arm | what happened | shards run | shards resumed | search seconds | wall seconds |
|:---|:---|---:|---:|---:|---:|
| A | uninterrupted | 32 | 0 | 111.72 | 127.10 |
| B, first attempt | `SIGKILL` to the process group after 25 s | 4 completed | 0 | — | 25 |
| B, second attempt | `SIGKILL` again after 40 s | 7 more | 4 | — | 40 |
| B, final restart | ran to completion | 21 | 11 | 68.67 | 77.23 |

```
9b94c2252a6ce53fc7416ef8d3e5f540c241589954afd72170b7346c18992608  resume/a/certificate.json
9b94c2252a6ce53fc7416ef8d3e5f540c241589954afd72170b7346c18992608  resume/b/certificate.json
RESUME MATCH: byte-identical certificates
```

The interrupted and uninterrupted certificates are byte-identical. Note that
this is stronger than "the same answer": the certificate carries every shard's
candidate count, kernel-support count and search conclusion, so byte equality
means all 32 shard enumerations reproduced across two process deaths.

Wasted work is bounded by the shards that were in flight when the kill landed —
one per kill, since shards run sequentially. Arm B spent 142 s of wall against
arm A's 127 s, so two hard kills cost 12% here; with a work queue running shards
concurrently the loss would be one shard per killed worker.

`certdist status` on the interrupted job reports the partial state honestly:

```
radius  16           4 / 32 shards, 249179535 candidates [PARTIAL]
bracket              d >= 1 (no witness yet)
```

That is the correct answer and also a product weakness. A partial shard cover
certifies nothing at all about the distance — a logical operator of weight 4
could be sitting in any unrun shard — so progress is visible but the bracket
does not tighten until the level completes. The way to get a moving bracket
during a long radius is to run a ladder of radii, each of which completes, which
is what the job directory is organised for.

## 6. Verification cost

### 6.1 The part that has to be said plainly

A minimum-distance lower bound is a non-existence claim over an exponentially
large set. There is no known succinct certificate for it, and this prototype
does not invent one. So the commercial slogan "verification is dramatically
cheaper than production" is **true for the upper bound and for integrity, and
false for the lower bound**, and no arrangement of JSON changes that.

What the certificate does change is the shape of the cost. Without it, a
sceptical third party has exactly one option: re-run the whole search. With it,
the same party has a dial:

| what is checked | what it costs | what it actually establishes |
|:---|:---|:---|
| structural verification | milliseconds | the certificate is internally consistent, the code identity and parity gate are correct, the shard cover is complete, every witness is a genuine logical operator, and the bracket follows from the records |
| `--recheck-shards K` | `K / N` of production | the enumerator reproduces `K` sampled shards' candidate, kernel-support and nontrivial-support counts exactly |
| every shard | 100% of production | the lower bound, independently |

The upper bound genuinely is cheap to verify, and that is not a technicality:
the witness re-check is the only place where a claim in the certificate is
re-derived from the code itself rather than cross-checked against other records.
`certdist` performs it on every witness from every source, its own included, in
both `run` and `verify`, and refuses a witness that fails.

### 6.2 Measured

Two certificates, one small and one at the top of this sweep's cost range.
Production cost is the whole-job wall time from the acceptance sweep, including
the compile and the upper-bound pass.

| certificate | production wall | structural verify | ratio | 2-of-32 shard re-check | ratio |
|:---|---:|---:|---:|---:|---:|
| `R1Elite02` X side, radius 16, 3.9e8 candidates | 87.45 s | 0.005 s | **17,500x cheaper** | 1.13 s | 77x cheaper |
| `R3EliteP02` Z side, radius 19, 1.3e10 candidates | 345.14 s | 0.003 s | **115,000x cheaper** | 18.12 s | 19x cheaper |

Structural verification runs in a few milliseconds in about 3 MiB of memory,
independent of the size of the search it is checking — the ratio grows with the
job, which is the right direction. It checks five things on the first certificate
and four on the second: the code identity and parity gate re-derived from the
input, a complete 32-shard cover at a consistent radius and filter fingerprint
with additive totals, every witness re-verified over GF(2), and the bracket
recomputed from the records.

The `--recheck-shards` dial costs what it should: 2 of 32 shards is 6.2% of the
cover and cost 2.6% and 5.9% of the two jobs' shard wall time respectively.

### 6.3 A real finding: candidate counts are not always reproducible

The first version of the shard re-check compared candidate counts for equality
and **failed** on `R1Elite02`'s X side: shard 16 re-ran to 9,743,349 candidates
against 9,733,895 recorded, a drift of +0.9%. This is not a bug in the core and
not a bug in the driver. The parallel search shares improved bounds between
Rayon workers through an asynchronous mailbox polled at `--pulse-interval`, so
once a shard finds a witness the moment at which the improved bound reaches each
worker varies run to run, and with it the pruning and the candidate count.

The rule that came out of it, and that the verifier now enforces:

- a shard's **conclusion** — the distance it found, or that it found nothing —
  is deterministic and is checked for equality;
- a **witness-free** shard publishes no bound, so its counters are deterministic
  too and are checked for exact equality;
- a shard that **found a witness** has its counters reported as drift, not as a
  failure.

Both re-checked shards of `R3EliteP02`'s Z side, which is witness-free,
reproduced all 421,606,038 and 436,972,673 candidates exactly.

### 6.4 Negative control

A certificate with one coordinate of the enumeration witness flipped is refused:

```
[FAIL] radius 16: enumeration witness is not a logical operator of the claimed weight
Error: 1 verification failure(s)
```

The verifier exits non-zero on any failure, so it is usable as a gate.

## 7. Ergodis core interface requests

Things this prototype wanted and could not have without editing the core. Listed
in descending order of what they would be worth.

1. **Carry verified automorphism generators in the input format, and check the
   anchor set against them.** The anchor reduction is the largest cost lever in
   the whole system — 42x to 60x on the abelian lifted products — and it is the
   one load-bearing fact a certificate verifier cannot re-derive. Today `anchors`
   is an unexplained list of coordinates produced by a per-family Python helper;
   the core accepts it without question and so must every downstream verifier.
   Requested: an optional `symmetry_generators` field holding coordinate
   permutations, with the core verifying that each generator preserves the row
   space of the physical checks and permutes the nonzero logical classes, that
   the orbits are free and uniform, and that `anchors` is an orbit transversal —
   and recording all three verdicts in the run record. That single change turns
   the largest speedup in the system from a trusted input into a checked fact,
   which is exactly what a commercial certificate needs.
2. **Let a shard be seeded with a known upper bound.** This is the highest-value
   item after the automorphism generators, and it is the only one this sweep
   measured a hard number for. Sharding costs +42% of the enumeration on
   `R1Elite02`'s X side purely because 32 independent shards cannot share the
   improved bound that the one-shot search publishes as soon as it finds its
   weight-16 witness. A driver always has a candidate bound before it starts —
   `certdist` runs its ordered-statistics pass first precisely so that it does —
   and handing that bound to every shard would recover the loss and speed up
   ordinary unsharded searches too. The input's `incumbent_support` field is
   close to what is wanted, but the binary rejects it outright when combined with
   sharding (`search shards cannot be combined with incumbent certification`)
   because it is interpreted as a certification target rather than a pruning
   seed. Requested: a plain `--initial-bound <weight>` that is compatible with
   sharding and carries no certification semantics.
3. **A shard range, so one process can run several shards.** Every shard is a
   fresh process that reloads the compiled filter. Measured at 0.22 s per shard
   on a 1428-coordinate instance, which is 14% of that job's wall time at
   32 shards and would be far worse at higher shard counts, which is precisely
   where a service wants to be for fine resume granularity. Requested:
   `--shard-range a..b`, or repeatable `--shard-index`, emitting one record per
   shard from one artifact load.
4. **Separate the prefix-expansion candidate count from the shard-owned count.**
   Each shard repeats the prefix expansion and folds it into its own
   `candidates`, so per-shard counts are not additive: the 32-shard total on
   `R1Elite01`'s X side is 767,874,405 against the unsharded 764,931,405, an
   inflation of 0.38%. Small here, but it means a sharded run has no reproducible
   additive counter, and a counter is the only cheap consistency check a verifier
   has. Requested: report `prefix_candidates` and `shard_candidates` separately.
5. **Expose the branch list so a driver can balance the schedule.** Sharding is a
   modular partition of a branch list the core has already built and whose
   subtree sizes it could cheaply estimate. Measured spread on one job was 1.01 s
   to 1.66 s per shard, so the modular partition is better balanced than expected
   — but a service scheduling shards across machines needs the sizes, not luck.
   Requested: a `--shard-plan` dry run that prints the branch count and, if
   affordable, a per-branch cost proxy.
6. **Make `large-css` a runtime capability rather than a feature of the
   dependency.** `ergodis-private` declares `features = ["control-plane",
   "parallel"]`; a binary inside that crate cannot link the large backends at
   all, and under the constraint that its `Cargo.toml` is untouchable there is no
   workaround except driving the core binary as a subprocess. That happens to be
   the right architecture here, but the constraint is real and would bite any
   downstream consumer. Requested: compile the large backends in by default and
   select at runtime, or ship a default-on `full` feature.
7. **Let the core state the bound it certifies, including the parity lift.** A
   completed run reports `distance: null`, and every consumer has to know that
   this means "no logical operator at or below `searched_maximum_weight`", then
   separately re-derive the even-weight parity fact to gain the extra unit.
   `certdist` recomputes the all-ones row-space membership itself rather than
   trust `kernel_weights_even`, which is the right call for a verifier but is
   duplicated work. Requested: a `certifies_lower_bound` field, with the parity
   fact and its justification stated in the record.
8. **Raise the `css_distance_random` OSD order cap, and add class breadth.**
   The new bounded OSD accepts order 1 or 2 only. The 756-coordinate work found
   that breadth over logical classes beats OSD depth on hard instances, so a mode
   that decodes toward randomly chosen logical classes would help more than a
   higher order. Both would be useful; either would be better than the current
   cap.
9. **Artifact format versioning** (carried over from the 756 report, still
   true). The compiled filter's magic and version are not forward compatible and
   the suggested filename does not encode them. `certdist` sidesteps this by
   treating the artifact as job-local cache that is rebuilt whenever its recorded
   radius does not match, and never as evidence — but that is a workaround for a
   feature advertised as a checkpoint.
10. **Minor, carried over:** `python/generate_bb_native.py --out` is create-only,
   so a provenance re-check needs the previous file deleted first.
11. **Positive.** The sharding contract is documented precisely where it matters
    (the `CssSearchShard` doc comment states the completeness condition), and a
    shard record self-labels as `result_scope: "partial-shard"` with its
    `search_shard` identity attached. That is exactly the right shape: a partial
    result cannot be mistaken for a global one by a careless consumer. Peak
    resident set stayed flat and small throughout.

## 8. What this would take to become a real service

### Missing

- **A scheduler.** `certdist run` executes shards sequentially in one process.
  The sharding contract already supports running them anywhere, so the missing
  piece is a work queue, a worker pool, and a way to collect shard records from
  several machines into one job directory. That is the difference between "a
  radius is a scheduling problem" and "a radius is a long night".
- **Input importers.** `certdist` consumes the Ergodis native sparse JSON. A
  customer arrives with a stabilizer tableau, a `qecc`/`ldpc` Python object, a
  Stim circuit, or a pair of protograph matrices. Every input in this report was
  produced by a per-family Python helper that is not part of the service.
- **Anchor derivation.** Related, and worse: the anchors are produced by that
  same helper, from family-specific knowledge of the group action. A service
  handed an arbitrary code either finds a verified automorphism group itself or
  runs with every coordinate as an anchor and pays the 42x to 60x.
- **A first-class two-sided job.** A CSS code has two sides and `certdist`
  handles one input at a time; `certdist combine` folds two certificates into a
  code-level bracket afterwards. That works but it is a bolt-on, and it means the
  scheduler cannot balance work across the two sides of one code.
- **Per-shard timeouts and retries.** A hung or crashed shard currently aborts
  the job. Resume makes that survivable rather than fatal, but a service needs
  the driver to notice and reschedule.

### Fragile

- **Job directories are bound to a core revision.** Candidate counts already
  drift across core revisions and the compiled artifact format is not forward
  compatible, so a job resumed after a core upgrade can silently mix records from
  two enumerators. `certdist` records the SHA-256 of the `css_distance_native`
  binary it used in every job and certificate and refuses to mix.
- **Shard count is chosen up front and cannot change.** Records from a 32-shard
  cover are useless to a 64-shard cover. A service that wants to add machines
  mid-job cannot re-shard without discarding work.
- **The upper-bound pass is not resumable.** It is a fixed trial budget in one
  process; killing it loses everything except the best witness already written.

### Does not generalise

- **The anchor reduction.** 42x on `Z_3 x Z_14`, 60x on `Z_30 x Z_2`, 2x on the
  dicyclic candidates, 378x on the `[[756,16,d]]` bivariate bicycle. It is a
  property of the code's verified automorphism group and nothing else. `certdist`
  prints it on every job with that caveat attached rather than folding it into a
  runtime estimate silently.
- **The even-weight parity gate.** Present on the four `Elite` candidates,
  absent on the two `EliteP` ones, which is why the latter need one extra
  enumeration radius. Recomputed per job, never assumed.
- **"Shards are cheap."** The prefix expansion runs until it holds
  `16 * shard_count` branches. At a deep radius with a small anchor set the
  branch supply is finite, and a high shard count would either fail to reach the
  target or push the expansion so deep that its repeated cost stops being a
  rounding error. The 0.38% inflation measured here is not a constant.
- **Verification cheapness.** Structural verification is cheap because it does
  not re-run the search. See section 6 for exactly what that buys and what it
  does not.

## 9. Evidence, hashes and replay

### 9.1 Committed

| path | role |
|:---|:---|
| `ergodis-private/src/bin/certdist.rs` | the whole prototype |
| `ergodis-private/evidence/certdist/certificates/*-x-certificate.json`, `*-z-certificate.json` | the twelve per-side certificates, one per input, each carrying the code identity, parity gate, all 32 shard records, the upper-bound records and the bracket |
| `ergodis-private/evidence/certdist/certificates/*-combined.json` | the six code-level brackets |
| `ergodis-private/evidence/certdist/scripts/` | the exact driver scripts for the acceptance sweep, the resume demonstration, the verification measurement, the certificate regeneration, and the summary tables, plus the out-of-tree build shim |
| `ergodis-private/evidence/certdist/SHA256SUMS.certificates` | hashes of the eighteen certificates; `sha256sum -c` passes in that directory |
| `ergodis-private/evidence/certdist/SHA256SUMS.scripts` | hashes of the driver scripts |
| `ergodis-private/evidence/certdist/SHA256SUMS.binaries` | hashes of the three binaries used, with their cache paths |
| this report | |

A separate `SHA256SUMS.*` set is used rather than appending to
`ergodis-private/evidence/SHA256SUMS`, because that file is being appended to by
concurrent sessions and this work has no business touching it.

### 9.2 Not committed, and why

The job directories under `/home/tavis/.cache/ergodis/certdist/jobs/` hold the
compiled filter artifacts, the per-shard core run records, and `metrics.jsonl`.
They are bulk, they carry wall-clock and host paths, and the certificates already
contain every shard's search result. The three run logs
(`acceptance.log`, `resume.log`, `verify.log`, `regen.log`) live there too.

### 9.3 Toolchain, and a live demonstration of why it is pinned

The core was built at Ergodis commit `b10993f4a` (*perf: add bounded osd to css
witness search*) with:

```sh
cd papers/complete-repair-ports/ergodis
CARGO_TARGET_DIR=~/.cache/ergodis/certdist/core-target RUSTFLAGS="-C target-cpu=native" \
  cargo build --release --features large-css,parallel \
    --bin css_distance_native --bin css_distance_random
```

By the time this report was written the Ergodis working tree had already moved to
`f968647b3` under a concurrent session. That is precisely the drift the
certificate's `toolchain.native_sha256` field defends against: every job and
every certificate records
`b5377e23e44c3ba8b241f7d62705a75f2443640bdf489156306c604e7573e37e`, the SHA-256
of the `css_distance_native` binary that produced every shard record, and
`certdist run` refuses to resume a job under a different enumerator rather than
silently mixing records from two searches.

### 9.4 Building the prototype

The authoritative source is `ergodis-private/src/bin/certdist.rs` and edition-2021
autobins picks it up, so the intended build is:

```sh
cd ergodis-private
CARGO_TARGET_DIR=~/.cache/ergodis/certdist/target cargo build --release --bin certdist
```

That build **cannot currently be run**, through no fault of this work: a
concurrent session's in-flight edits leave the `ergodis-private` library target
uncompilable (three `missing field best_quotient_residuals` errors in
`src/g53_search.rs`, a file this work must not touch). Since `certdist.rs` uses
no item from the `ergodis-private` library and needs only `anyhow`, `clap`,
`serde`, `serde_json` and `sha2`, it was built through an out-of-tree shim crate
that points a `[[bin]]` at the same file — committed as
`evidence/certdist/scripts/certdist-build-shim-Cargo.toml`:

```sh
cd ~/.cache/ergodis/certdist/build
CARGO_TARGET_DIR=~/.cache/ergodis/certdist/shim-target cargo build --release --bin certdist
```

The two builds compile the same file with the same dependency versions. Once the
library compiles again, the in-tree build is the one to use and the shim can be
discarded.

### 9.5 Replay

```sh
CD=~/.cache/ergodis/certdist
Q=~/.cache/ergodis/c1018/qldpc          # the twelve inputs, hashes in the qLDPC sweep report

# feasibility before committing to a radius
$CD/shim-target/release/certdist plan \
  --input $Q/r1elite01-x.json --job $CD/jobs/r1elite01-x \
  --radius 16 --shards 32 --sample 3 --threads 8 \
  --native $CD/core-target/release/css_distance_native

# a full job: upper-bound pass, then a resumable 32-shard exhaustion
$CD/shim-target/release/certdist run \
  --input $Q/r1elite01-x.json --job $CD/jobs/r1elite01-x \
  --radius 16 --shards 32 --threads 8 \
  --upper builtin-osd --upper-trials 20000 --upper-order 2 --upper-window 96 \
  --native $CD/core-target/release/css_distance_native

# the code-level bracket from the two sides
$CD/shim-target/release/certdist combine \
  --certificate $CD/jobs/r1elite01-x/certificate.json \
  --certificate $CD/jobs/r1elite01-z/certificate.json \
  --label r1elite01 --out $CD/jobs/r1elite01-combined.json

# verification: structural, then with a sampled shard re-run
$CD/shim-target/release/certdist verify \
  --certificate $CD/jobs/r1elite01-x/certificate.json --input $Q/r1elite01-x.json
$CD/shim-target/release/certdist verify \
  --certificate $CD/jobs/r1elite01-x/certificate.json --input $Q/r1elite01-x.json \
  --recheck-shards 2 --job $CD/jobs/r1elite01-x --threads 8 \
  --native $CD/core-target/release/css_distance_native
```

The four committed driver scripts run the whole sweep, the resume demonstration,
the verification measurement and the certificate regeneration in that order.
The twelve input files are not regenerated here; they are produced by
`notes/2026-08-31-c1018-qldpc-helper.py` and their SHA-256 hashes are listed in
`notes/2026-08-31-c1018-hunt-qldpc-sweep.md`. `certdist` re-derives and records
each input's hash itself, and every certificate's `code.input_sha256` matches the
value in that report.

### 9.6 What the evidence does and does not establish

- **Establishes.** For each of the twelve inputs, that a complete 32-shard cover
  of the stated radius was performed by the recorded enumerator, that no logical
  operator lighter than the recorded bound exists *given* that the enumerator is
  correct and the anchor set is sound, and that the recorded witness is a genuine
  logical operator of the recorded weight — the last of these independently, from
  the input, by `certdist`'s own GF(2) arithmetic.
- **Does not establish.** That the enumerator is correct: no second
  implementation re-runs a 1.3e10-candidate exhaustion, exactly as the earlier
  reports state for the same reason. That the anchor reduction is sound: the
  anchors come from the input and no automorphism generators accompany them
  (interface request 1). The upper bounds are in better shape than the lower ones
  and this is stated on the face of every certificate, in its `trust_boundary`
  field.

## 10. Verdict on the prototype itself

The resume mechanism works, is cheap, and is the piece with real commercial
value: two hard kills mid-radius cost 12% of the wall time and produced a
byte-identical certificate. The upper-bound pass is competitive on this family —
it closed ten of twelve sides at the true side distance in 30 to 56 seconds
apiece — but this family is one where the randomized bound was already known to
be tight, so it is not evidence that the decoder is strong on hard instances.
The 756-coordinate case remains the honest test of that and was not attempted
here.

The verification story is genuinely asymmetric and should be sold that way: the
upper bound and the certificate's integrity verify in milliseconds, four to five
orders of magnitude below production; the lower bound has no cheap check and the
certificate's real contribution there is turning an all-or-nothing re-run into a
dial with a measured price per notch.

The two things that would most change the economics are both in the core and
both are small: seed shards with a known bound (worth up to 42% of the
enumeration on witness-bearing instances), and carry verified automorphism
generators in the input (worth 42x to 60x, and worth more than that in
credibility, since it converts the largest speedup in the system from a trusted
input into a checked fact).
