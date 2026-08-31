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

*(filled in below)*

## 7. Ergodis core interface requests

*(filled in below)*

## 8. What this would take to become a real service

*(filled in below)*
