# Certified exact minimum-distance service — first prototype (`certdist`)

**Lane:** `gem-mining` (commercial prototype, not a math task)

**Date:** 2026-08-31

**Status:** in progress — written incrementally as results land.

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

*(filled in below)*

## 5. Resume

*(filled in below)*

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

*(measurements below)*

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
2. **A shard range, so one process can run several shards.** Every shard is a
   fresh process that reloads the compiled filter. Measured at 0.22 s per shard
   on a 1428-coordinate instance, which is 14% of that job's wall time at
   32 shards and would be far worse at higher shard counts, which is precisely
   where a service wants to be for fine resume granularity. Requested:
   `--shard-range a..b`, or repeatable `--shard-index`, emitting one record per
   shard from one artifact load.
3. **Separate the prefix-expansion candidate count from the shard-owned count.**
   Each shard repeats the prefix expansion and folds it into its own
   `candidates`, so per-shard counts are not additive: the 32-shard total on
   `R1Elite01`'s X side is 767,874,405 against the unsharded 764,931,405, an
   inflation of 0.38%. Small here, but it means a sharded run has no reproducible
   additive counter, and a counter is the only cheap consistency check a verifier
   has. Requested: report `prefix_candidates` and `shard_candidates` separately.
4. **Expose the branch list so a driver can balance the schedule.** Sharding is a
   modular partition of a branch list the core has already built and whose
   subtree sizes it could cheaply estimate. Measured spread on one job was 1.01 s
   to 1.66 s per shard, so the modular partition is better balanced than expected
   — but a service scheduling shards across machines needs the sizes, not luck.
   Requested: a `--shard-plan` dry run that prints the branch count and, if
   affordable, a per-branch cost proxy.
5. **Make `large-css` a runtime capability rather than a feature of the
   dependency.** `ergodis-private` declares `features = ["control-plane",
   "parallel"]`; a binary inside that crate cannot link the large backends at
   all, and under the constraint that its `Cargo.toml` is untouchable there is no
   workaround except driving the core binary as a subprocess. That happens to be
   the right architecture here, but the constraint is real and would bite any
   downstream consumer. Requested: compile the large backends in by default and
   select at runtime, or ship a default-on `full` feature.
6. **Let the core state the bound it certifies, including the parity lift.** A
   completed run reports `distance: null`, and every consumer has to know that
   this means "no logical operator at or below `searched_maximum_weight`", then
   separately re-derive the even-weight parity fact to gain the extra unit.
   `certdist` recomputes the all-ones row-space membership itself rather than
   trust `kernel_weights_even`, which is the right call for a verifier but is
   duplicated work. Requested: a `certifies_lower_bound` field, with the parity
   fact and its justification stated in the record.
7. **Raise the `css_distance_random` OSD order cap, and add class breadth.**
   The new bounded OSD accepts order 1 or 2 only. The 756-coordinate work found
   that breadth over logical classes beats OSD depth on hard instances, so a mode
   that decodes toward randomly chosen logical classes would help more than a
   higher order. Both would be useful; either would be better than the current
   cap.
8. **Artifact format versioning** (carried over from the 756 report, still
   true). The compiled filter's magic and version are not forward compatible and
   the suggested filename does not encode them. `certdist` sidesteps this by
   treating the artifact as job-local cache that is rebuilt whenever its recorded
   radius does not match, and never as evidence — but that is a workaround for a
   feature advertised as a checkpoint.
9. **Minor, carried over:** `python/generate_bb_native.py --out` is create-only,
   so a provenance re-check needs the previous file deleted first.
10. **Positive.** The sharding contract is documented precisely where it matters
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
