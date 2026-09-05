# C1069: the same certificate read, for the predecoder path

**Lane**: `complete-ports` · **Date**: 2026-09-05 · **Code**: `~/src/ergodis-private`
**Contract**: `~/src/ergodis-contrib/PERFORMANCE.md` and the shared playbook it names
**Continues**: item 2 of `2026-09-05-c1068-touch-loop-and-certificate-closure.md`'s next list, and
the fourth entry of what `2026-09-05-c1068-qec-decoder-risk-review.md` could not check: "the
predecoder's certificate deserves the same read and has not had one here"
**Subject**: `src/margin_certificate.rs`, `src/sparse_margin_predecoder.rs`,
`src/predecoder_pipeline.rs`, and the region and metric machinery they use in
`src/local_commit_predecoder.rs`
**Code commits**: ergodis-private `489cfc5` (the corrections and their tests), `742059b` (the
retained probes and their evidence), `685fae4` (one lint in the predecoder's own bench)
**Evidence**: `benchmarks/tiger-blossom/2026-09-05-c1069-predecoder-certificate-probes.txt`,
hashed in that directory's `SHA256SUMS`
**Replay**:
`cargo test --release --test predecoder_certificate_probes -- --ignored --nocapture --test-threads=1`
**Status**: closed

## Headline

**The predecoder has no per-shot certificate to check, which is the first thing to say about it:
the sparse blossom matcher certifies each answer as it decodes, and the predecoder instead
compiles a policy table once and trusts it on every shot. Everything the exactness claim rests on
is therefore compile-time — the margin theorem, and an offline audit that fixes the margin `Δ` the
table is compiled at. Probe 28h already measured the load-bearing consequence: the smallest margin
the audit calls sound commits no correction at any radius that compiles, so the tiers that commit
are the unsound ones. The claims in the code had not caught up with that.**

The sharpest finding is the same shape as C1068's: **a permanent test asserted a property the code
does not have, and passed only because of its own budget.**
`the_pipeline_weight_equals_the_kernel_weight` asserted that the predecoder-plus-kernel weight
equals the kernel's on every one of 2,000 shots, at `Δ = 2` — the margin probe 28h reports as
wrong on 0 to 9 shots in 4,096 at 5% error. Run past its budget on its own surface tier at 3%
error, the first violation lands at shot 2,309 with seed 2, and 1 to 4 land in 200,000 depending
on the seed. The assertion was a coin flip against its seed, on the one gate that stands between
this path and a wrong answer.

Second, **the sparse sweep's cost lever is unlicensed on every surface tier at the audited-sound
margin.** Skipping a defect-free position is exact only when the local girth is at least the
margin; every surface tier has girth 2, so at `Δ = 3` sixteen of the eighty-one positions at
distance 9 defer on a clean ball and the sweep silently substitutes an empty commit. No correction
changes — a deferral and an empty commit both do nothing — but the defer census, the only
instrument probe 28h and probe 28c read for how often the certificate declines, is short by those
positions: 478,883 deferrals reported against 548,527, disagreeing on 9,791 of 10,000 shots.

Both are repaired, together with four smaller claim-versus-code gaps, and each is now a test.

## What the certificate is

Fix a commit region `R` — in every tier built so far, one data-error mechanism of the oldest round
— and a radius `r`. The ball `B` is the detectors within `r` of the ones `R` touches. The escaped
ball metric `W_a(s|_B)` is the least number of mechanisms, interior or crossing, whose boundary
inside the ball is the observed `s|_B` and whose restriction to `R` is the action `a`; a crossing
mechanism is an escape charged at its own weight. The margin condition commits `a` when

```text
W_a + Δ  ≤  min over a' ≠ a of W_a'
```

where `Δ` bounds the outside's advantage from preferring a different crossing pattern. The
splicing argument in the module is correct and I checked it against the code: `margin_decision`
compares the best against the second-best `W`, which is exactly `min over a' ≠ a`, and
`compile_margin_policy` tabulates that decision over every ball syndrome into one byte per
syndrome. The sweep reads the table, applies the commit, rewrites the syndrome, and hands the
residue to the kernel.

So the guarantee has three legs, and only the first is a theorem:

1. the margin condition is sound *given* a valid `Δ`;
2. `Δ` is valid for the deployed graph;
3. the sequence of commits composes.

Leg two is where it stands or falls. `outside_advantage_bound` computes the one `Δ` the module can
prove — `R_max`, the largest outside repair cost over the crossing subspace — and **nothing uses
it**: it is reported by one bench mode and never chosen from. The deployed `Δ` comes from
`audit_margin` / `audit_with_oracle`, an exhaustive scan of one region over low-weight syndromes,
which is evidence and not a proof, and which probe 28h then showed commits nothing at the smallest
value it endorses.

## Findings

### 1. The pipeline's exactness test asserted an equality the margin does not have

`the_pipeline_weight_equals_the_kernel_weight` ran three tiers for 2,000 shots each at 3% error
and asserted `alone.weight == together.weight` on every one. Two of the three tiers are at
`Δ = 2`. Probe 28h's own table reports 0 to 9 heavier shots per 4,096 for that margin, and probe
28c 3 to 6 per 65,536 at 1% error, so the test asserted the negation of a published measurement.

Measured on the test's own tiers and rate, 200,000 shots per seed:

| tier                                   | seed 0x28c | seed 1 | seed 2 | seed 3 | earliest violation, any seed |
|----------------------------------------|------------|--------|--------|--------|------------------------------|
| repetition `d = 7`, radius 1, `Δ = 3`  | 0          | 0      | 0      | 0      | none                         |
| repetition `d = 7`, radius 2, `Δ = 2`  | 3          | 2      | 3      | 2      | shot 17,204                  |
| surface `d = 5`, radius 1, `Δ = 2`     | 0          | 2      | 4      | 1      | **shot 2,309**               |

The shipped seed happens to reach neither violation inside 2,000 shots. Seed 2 on the surface tier
would have failed the test at shot 2,309.

The repair keeps the parts that are true and drops the part that is not. Never lighter than the
kernel is a theorem — whatever the sweep commits, the committed set spliced onto any residual
explanation explains the original shot, so `committed + residual ≥ globalmin`, and a lighter shot
would mean the kernel's own certificate had passed a suboptimal answer. That is now asserted at
every tier. Exact equality is asserted at the audited-sound tier. At `Δ = 2` the heavier shots are
counted and bounded at 3 in 2,000, a bound the measured rate of 1 to 4 per 200,000 cannot reach by
a seed change.

### 2. The clean-ball skip is not licensed on the surface tiers at `Δ = 3`

The sparse sweep evaluates only the positions whose ball holds a defect. The clean-ball lemma
licenses that: at ball syndrome zero `W_0 = 0`, so the table commits the empty action — **provided
the local girth `g_R`, the smallest boundary-free-in-ball mechanism set touching `R`, is at least
`Δ`**. Below that the table defers instead, and skipping the position is no longer the same
decision.

The girth of every published tier:

| family     | distance | radius | smallest girth |
|------------|----------|--------|----------------|
| repetition | 9        | 1      | 3              |
| repetition | 9        | 2      | 3              |
| repetition | 9        | 3      | 3              |
| repetition | 15       | 3      | 3              |
| surface    | 5        | 2      | 2              |
| surface    | 9        | 1      | 2              |

So the repetition tiers are licensed through `Δ = 3` and the surface tiers only through `Δ = 2`.
Probe 28h's surface rows at `Δ = 3` are exactly the unlicensed case. On surface `d = 9`, radius 1,
`Δ = 3`, sixteen of the eighty-one positions defer on a clean ball. Over 10,000 shots at 5%:

| quantity                          | value              |
|-----------------------------------|--------------------|
| shots where the defer counts differ | 9,791 of 10,000  |
| deferrals, sparse sweep           | 478,883            |
| deferrals, dense reference        | 548,527            |
| shots where the weight differs    | 0                  |
| shots where the residual syndrome differs | 0          |

The committed weight and the residual syndrome are identical, so probe 28h's load-bearing zero —
no correction committed at `Δ = 3` — stands untouched. What is understated by 12.7% is the defer
census, which is the column the two probes read as the certificate declining.

The repair states the shortfall as an identity rather than removing it: the sweep's skipped
deferring positions are exactly the difference, a new `clean_ball_deferrals` counts the positions
that defer on a clean ball, the pipeline bench prints that count in its header
(`clean_ball_deferrals 16` on the tier above), and a test pins
`dense.deferred - sparse.deferred == skipped deferring positions` shot by shot.

### 3. The dense reference sweep never accumulated the committed parity

`SweepOutcome.logical` is what `Pipeline::decode` exclusive-ors with the kernel's observable to
produce the shot's answer. `sparse_sweep` maintained it; `dense_sweep`, the reference the equality
test compares against, did not — it was left false on every shot, so the test could not compare it
and did not. The reference now maintains it and the test asserts it.

### 4. The two sweeps can only diverge through a woken position, and the test never woke one

The sparse sweep processes positions in index order, but a commit can turn a detector on inside
the ball of a position the initial pass skipped, and that position joins the tail. If its index is
below the committing position's, the dense sweep has already passed it with the clean ball it had
then. That is the only way the two orders can disagree, and the comment claimed instead that the
sparse sweep "makes exactly the same sequence of decisions as the dense one".

The wake path fires rarely and never on the tier the equality test used: zero wakes in 40,000
shots on surface `d = 5` at radius 1 and 5% error, zero on repetition `d = 9` at 8%, zero on
repetition `d = 15` at 25%, and 617 in 40,000 on surface `d = 7` at 20%. It also never fires
anywhere in the exhaustive repetition sweeps below. Where it did fire, the two sweeps agreed on
every shot.

The test now runs the surface `d = 7` tier at 20% and requires the wake path to fire, and a second
test compares the two sweeps over **every** syndrome of a repetition instance — 262,144 syndromes
at two radii, zero divergence — so the agreement is exhaustive on one family instead of sampled on
one tier.

### 5. The ball-and-shell audit's scope was stated as an argument

`audit_with_oracle` restricts the audited syndromes to the ball and its immediate shell, and gave
as the reason that a far defect cannot change the ball's decision. The decision, no; the identity
the commit is checked against, yes — a ball defect that would route to the boundary on its own can
pair with a far defect instead, and the two sides of `globalmin = |a| + residualmin` are not
obliged to move together. So the restricted audit can in principle call a margin sound that a
full-support audit refutes, and the margin it reports is a lower bound.

Measured, on six repetition configurations at five margins each, against the full-support closure
audit at the same syndrome weight: **the two agree on the soundness verdict at every margin and
therefore on the smallest sound margin, while the restricted audit examines 13% to 71% of the
syndromes** (299 against 988, 130 against 988, 176 against 697, and so on). The comment now says
what the restriction is, and the agreement test — which previously ran only on surface `d = 3`,
where the ball is nearly the whole graph and the restriction removes almost nothing — now runs
those instances and requires the restricted audit to have examined strictly fewer.

### 6. Two smaller gaps

`margin_decision`'s comment said a tie defers at `Δ = 0`. It does not: at `Δ = 0` the margin
condition is exactly "`a` is cheapest", which a tied action satisfies, so the lowest-indexed
cheapest action commits. A test now pins the tie behaviour at `Δ = 0` and `Δ = 1`.

`Pipeline::new` took regions and their policies as two parallel vectors and checked nothing, while
the sweep reads `policies[position]` against `regions[position]`'s ball; a policy compiled for a
different region would decide every shot silently. The pairing, the table width and the action
width are now checked cold, and a test hands it a policy from another radius and requires the
refusal. Separately, `compile_margin_policy` encodes an action in one byte beside a `255`
deferral sentinel, so a commit region of eight mechanisms or more would truncate action 256 to the
empty correction and read action 255 as a deferral; every region built so far commits one
mechanism, and the width is now asserted rather than left to that habit.

## Checked and clean

1. **The margin arithmetic matches the theorem.** Best against second-best is `min over a' ≠ a`;
   `second == UNREACHABLE` commits, which is the condition holding vacuously; the sign of the
   comparison is right.
2. **A commit mechanism is always interior.** `LocalRegion::new` seeds the ball with every
   detector the commit mechanisms touch and asserts the containment, so the escaped-ball metric
   never treats a commit as a crossing generator.
3. **The residual is decoded over the whole graph, not with the committed regions retired, and
   that is safe.** The handoff contract retires them and both audits do; the pipeline does not. It
   costs nothing: re-using a committed mechanism can only cancel against it, which costs two and
   surfaces as a heavier shot, and on a sound commit the two residual minima are equal. The
   argument is in the module now.
4. **Composition is unproved and unfalsified.** Each position's policy is compiled against the
   original graph, while the induction in the contract retires each region as it is committed;
   nothing audits the composition. Classifying every unsound commit at `Δ = 2` by its place in its
   shot: 2 unsound shots in 20,000 on repetition `d = 9`, 1 in 20,000 on surface `d = 5`, and in
   every one of them **the failure is the first correction of the shot**, never a later one. The
   `Δ = 2` failures are single-region certificate failures, which is what probe 28h assumed.
5. **A lighter shot never happened**, in any configuration measured here or in probe 28h's grid,
   as the splicing bound requires.
6. **The escaped-ball metric is finite everywhere and never above the interior metric**, an
   existing test that survives the changes.

## Gates

The full private library suite, 912 tests, passes in release; the module suites this task touched
pass in debug as well. Library clippy with `-D warnings` is clean, so is clippy on the retained
probe target, the bench file draws no finding in the workspace run, and `rustfmt` was applied to
every file this task touched. The pipeline bench was run once on the surface `d = 9`
tier to confirm the new header line. The probes are retained ignored and the run behind every
number above is the evidence file named at the top, hashed into the directory's `SHA256SUMS`,
which verifies all 83 entries.

Not run: `cargo clippy --workspace --all-targets`, which fails at `HEAD` with twelve findings in
four `tasks/tools` files this task does not own — `actual_cause_report.rs`,
`generic_certificate_bench.rs`, `profile_vocabulary_bench.rs` — plus unformatted working-tree edits
in `src/causal_*.rs`. Those belong to the causal-model work in flight and are left alone; the one
finding inside the predecoder's own bench is fixed in `685fae4`.

## Mystery ledger

- **Settled: whether the predecoder's certificate checks what it claims.** There is no per-shot
  check to be incomplete, which is the difference from the matcher C1068 read. The claims that
  outran the code were about the deployed margin, the clean-ball skip and the sparse-dense
  equality, and all three are now stated at their true strength with a test each.
- **Settled: whether the `Δ = 2` failures are single commits or composition.** Single, in every
  one observed. The un-audited composition step has produced no failure in 40,000 classified
  shots.
- **Settled: how large the surface `Δ = 3` defer shortfall is.** 12.7% at distance 9, and zero
  effect on any weight or syndrome.
- **Open: nothing computes a `Δ` that is proved.** `outside_advantage_bound` is the only proved
  bound in the module and no path chooses from it. Probe 28h's negative makes this cheap to leave
  open — a proved `Δ` would be at least 3, and `Δ = 3` commits nothing — but it means the phrase
  "certified predecoder" currently names an audited one. Owner: any successor that revives the
  path, and the first thing it should do is print `R_max` beside the audited margin for the tiers
  it wants.
- **Open, unchanged from probe 28h: whether the `Δ = 2` failures live inside a declarable fault
  bound.** That is the module's `BoundedSafe` tier and the only route left to a predecoder that
  commits. This task's classification narrows it usefully: the failures are single-region, so the
  bound would have to be stated per region rather than per shot.
- **Open: why the wake path fires on the surface family and never on the repetition family.** Zero
  wakes over every syndrome of two repetition instances and over 40,000 shots at 25% error, against
  617 in 40,000 on surface `d = 7` at 20%. There is presumably a short argument from the repetition
  ball's shape; nobody has made it, and it is the difference between "we tested the divergence
  path" and "the divergence path does not exist on this family".

## Vibe check

Good, and cheaper than C1068 because the risk review had already named the target. The useful part
is that the two findings that matter were both about a claim outrunning its evidence rather than
about arithmetic: a test that asserted the negation of a number published in its own lane, and a
cost lever whose precondition the deployed surface tiers do not meet. The predecoder stays a closed
negative either way — probe 28h's structural result is untouched — so this is hygiene on a shelved
path, not a revival.

## Next

1. The queue-struct borrow split in the matcher, which is C1068's first open item and the only
   remaining lever on its touch loop.
2. Re-running probe 28h's margin-radius grid on the repaired rotated-surface builder, still
   unreplaced, and now also worth re-reading with `clean_ball_deferrals` in the header.
3. The third code family for the mean-degree crossover rule, unchanged from C1064, C1065 and
   C1068.
