# C1070 probe 8 — one leakage surface: unifying the five probe modules

**Lane**: `ergodis`
**Task**: C1070 probe 8 (brief: `notes/2026-09-06-c1070-ergodis-compositional-leakage-brief.md`)
**Code**: `~/src/ergodis-private` — new tier-1 module `src/leakage.rs`, mask support in
`src/hierarchical_leakage.rs`, new `tasks/tools` subcommand `leakage`; no change to the
`~/src/ergodis` core.
**Artifacts**: `notes/data/2026-09-06-c1070-probe8/`
**Scope**: the uniform linear model. Non-uniform priors, noisy observations, and computational
privacy are out of scope, as in every C1070 probe.

---

## 0. Verdict

| Item | Outcome |
|---|---|
| One `LeakageProblem` in, one analysis out | **Done.** `ergodis_private::leakage::{LeakageProblem, analyze}`. Probe 5's and probe 3's committed inputs load with **no conversion at all**, schema tag included; a probe 6 transcript loads through `jq '{transcript: .}'`. |
| Masks through label pinning | **Done.** A block declares `mask_dimension`; the compiler appends those coordinates to the message space and zero-extends the requested secret over them, which is probe 1's Proposition 1. The mask-free machinery then serves masked towers unchanged, and it reproduces probe 1 §4's shared-mask counterexample. |
| Profile from the probe 2 sweep | **Done.** The unified path computes the `t`-profile by one coalition sweep and never enumerates secret subspaces. Probe 5's direct method survives as a test oracle, and a test asserts the two agree. |
| Public-core Pareto types | **Partly.** The antichain *reduction* now goes through `CappedAdditiveMonoid` and `WitnessedParetoFront` and must agree with the private reduction; the private `CostVector` stays as the search accumulator for two exactly stated blockers (§4). |
| Old modules and subcommands | **Kept as engines, not re-exports.** All five subcommands still work and all five committed certificates regenerate byte-identically; the new `leakage` subcommand is the single surface. §6 says what deleting them would cost and why it was not done here. |
| Regeneration | **Byte-identical on every committed input**: six probe 5 reports and summaries, seven probe 3 vector reports, probe 1's certificate, probe 2's certificate, probe 6's certificate. §5. |

---

## 1. What was merged, and what stayed put

The five probe modules were written one per probe and each grew its own entry point. The unification
keeps every one of them as an engine and adds a single surface above them.

| Probe | Engine module | What the unified surface takes |
|---|---|---|
| 5 | `hierarchical_leakage` | tower compilation, per-class minimum-cost coalitions with coefficient witnesses, the brute-force oracle |
| 1 | `hierarchical_leakage` mask pinning, and `masked_leakage` for the min-sum comparison | per-block mask spaces |
| 2 | `leakage_structure` | the `t`-profile from one best-first coalition sweep |
| 3 | `vector_leakage` | Pareto antichains under per-level budgets |
| 6 | `transcript_leakage` | transcript state, mask-reuse alarms, dead-mask contraction |

Nothing was duplicated: `src/leakage.rs` contains the schema, the dispatch, the flattening from a
compiled encoding to probe 2's sweep instance, and the public-core Pareto bridge. Every algorithm
stays in the module that proved it.

---

## 2. The unified schema

```json
{
  "schema": "c1070-leakage-problem-v1",
  "name": "shared-mask-tower",
  "field": { "characteristic": 5, "degree": 1 },
  "message_dimension": 2,
  "levels": [ { "blocks": [ { "generator": {...}, "mask_dimension": 1 } ] } ],
  "secret": { "rows": 2, "cols": 2, "data": [1,0,0,1] },
  "observation": { "units": [ { "name": "y1", "cost": 1, "coordinates": [0] } ] },
  "options": { },
  "cost_model": { },
  "transcript": { }
}
```

* The encoding half is exactly probe 5's `LeakageInput`, field for field, and the older schema tag
  `ergodis.hierarchical-leakage.v1` is accepted, so probe 5's and probe 3's committed inputs are
  valid problems as they stand.
* `mask_dimension` on a block is the one new encoding field. The generator's **last**
  `mask_dimension` rows are that block's fresh mask coordinates; the earlier rows are the symbols
  arriving from the level above. It defaults to zero and is omitted when zero, so no existing input
  or output changes.
* `cost_model` is probe 3's `CostModelSpec`, present exactly when the units carry vector costs.
* `transcript` is probe 6's transcript, and it may be the *only* thing present: a transcript-only
  problem is legal and skips the encoding half entirely.

The output `LeakageAnalysis` carries the exposed and pinned-mask dimensions, the observation units,
probe 5's functional classes with witnesses, the sweep profile, the vector report when a cost model
is present, the transcript report when a transcript is present, and the brute-force verdicts.

### Loading the committed corpora

| Corpus | How it loads |
|---|---|
| `notes/data/2026-09-06-c1070-probe5/*.json` (six tower inputs) | directly, unchanged |
| `notes/data/2026-09-06-c1070-probe3/tradeoff-block-against-leaves-f3.json` | directly, unchanged; its cost model is passed as `cost_model` |
| `notes/data/2026-09-06-c1070-probe6/*.transcript.json` (five transcripts) | `jq '{transcript: .}' <file>` |

---

## 3. Masks are label pinning, in the compiler

Probe 1's Proposition 1 says the masked theory *is* the mask-free theory over the enlarged message
space, restricted to labels that vanish on the mask coordinates. The compiler now implements exactly
that sentence:

1. the compiled tower's message space is the exposed message coordinates followed by every block's
   mask coordinates, in `(level, block)` order;
2. at each level the carried encoding matrix is widened by one indicator column per mask coordinate
   that level's blocks inject, so a mask enters the composition only at the level that draws it; and
3. the requested secret rows are zero-extended over the mask block, which is the pinning.

A mask-free tower compiles exactly as before — the widening is skipped and the carried matrix is the
old identity — which is why every probe 5 and probe 3 certificate regenerates byte for byte.

**The check that this is the right reduction.** The shared-mask tower
`notes/data/2026-09-06-c1070-probe8/shared-mask-tower.problem.json` is probe 1 §4's counterexample
and probe 6's first transcript as a one-level masked tower: leaves `s1 + r` and `s2 + r` over `F_5`
with one shared mask. The unified analysis reports six projective classes of secret functional, of
which five are private and only `s1 + 4·s2` — that is `s1 − s2` — is recoverable, at cost 2, with the
brute-force oracle agreeing. The profile is `Gamma_1 = 2` and `Gamma_2` unreachable. That is the
same object probe 1 computed through `masked_leakage`'s min-sum tables and probe 6 computed through
transcript row spaces, now obtained from the mask-free tower machinery with no masked code path.

---

## 4. Vector costs and the public core

The final antichain is now rebuilt through `ergodis::ordered_resource::CappedAdditiveMonoid` and
`WitnessedParetoFront`, with caps taken as the componentwise maximum over the reported points, and
the unified analysis records whether the core reduction reproduced the private one
(`core_antichain_agrees`). A unit test also checks the core reduction against `minimal_antichain` on
an explicit four-point set.

**The blocker, stated exactly.** The private `CostVector` remains the *search accumulator* inside
`vector_leakage` for two reasons, both concrete:

1. `CappedAdditiveMonoid` addition saturates at the declared caps. The best-first search pops on the
   unsaturated total order and compares frontier nodes by their true sums, so a saturating
   accumulator would reorder the frontier whenever a partial sum reached a cap. Choosing caps above
   every attainable total avoids saturation but makes the monoid's element count
   `Π (cap + 1)`, which must fit in `u32`; with several components whose totals run to the low
   hundreds that bound is reached quickly, and the search would then have no monoid at all.
2. `ParetoWitness::witness` is a single `u32`. A search point carries a `u64` coalition mask and a
   coefficient witness matrix. Indirecting through a side table is possible, but it moves the
   witness out of the hot record, which the core's own performance rules forbid.

So the division is: the core owns the antichain reduction and is checked against the private one;
the private type owns the accumulator, with a comment in `src/leakage.rs::core_antichain` naming
these two blockers at the point of use.

---

## 5. Regeneration of every committed input

All checks were run from the release binary built at the probe 8 tree.

| Corpus | Command | Result |
|---|---|---|
| probe 5, six stems | `ergodis-tools leakage-profile --input <stem>.json --json-out … --summary-out …` | six reports and six summaries **byte-identical** |
| probe 3, six stems plus the tradeoff input | `ergodis-tools leakage-vector --input … --cost-model … --json-out … --summary-out …` | seven vector reports **byte-identical** |
| probe 1 | `ergodis-tools masked-leakage-report --check --out notes/2026-09-06-c1070-probe1-mask-quotiented-associativity.json` | certificate matches |
| probe 2 | `ergodis-tools leakage-structure-report --probe5 notes/data/2026-09-06-c1070-probe5 --check --out notes/2026-09-06-c1070-probe2-leakage-profile-from-quotient.json` | certificate matches |
| probe 6 | `ergodis-tools transcript-leakage-report --check --out notes/data/2026-09-06-c1070-probe6/transcript-leakage.report.json` | certificate matches |

**No diff anywhere**, so there is nothing to justify: the unification is behaviour-preserving on
every committed artifact.

### The unified path against probe 5, on the same input

For `tower-two-level-f3`, the unified analysis reports the same minimum cost for every one of the
thirteen projective classes as probe 5's committed report, and the sweep profile `(1, 2, 3)` equals
probe 5's direct profile entry for entry, avoiding 13, 13 and 1 subspace searches at `t = 1, 2, 3`.

### Replay

Working directory `~/src/ergodis-private`:

```
cargo build -p ergodis-tools --release
D=~/src/othello/notes/data
T=~/.cache/ergodis/target/ergodis-private/release/ergodis-tools
$T leakage --input $D/2026-09-06-c1070-probe8/shared-mask-tower.problem.json \
  --check --out $D/2026-09-06-c1070-probe8/shared-mask-tower.analysis.json
$T leakage --input $D/2026-09-06-c1070-probe5/tower-two-level-f3.json \
  --check --out $D/2026-09-06-c1070-probe8/tower-two-level-f3.analysis.json
$T leakage --input $D/2026-09-06-c1070-probe8/shamir-repair.problem.json \
  --check --out $D/2026-09-06-c1070-probe8/shamir-repair.analysis.json
```

The second command is the point of the exercise: probe 5's committed input, passed by path with no
conversion, analyzed by the unified surface. `shamir-repair.problem.json` was produced from probe 6's
third transcript by `jq '{transcript: .}'`. Runs are deterministic and canonical: no randomness, no
timestamps, no host paths.

### Hashes

Recorded in `notes/data/2026-09-06-c1070-probe8/SHA256SUMS`, checkable with `sha256sum -c` in that
directory. The generator is committed in `~/src/ergodis-private` at `8bb9f76`.

---

## 6. Tests, and what was deliberately not done

Every test moved with its code: the probe modules keep their own tests and `src/leakage.rs` adds
four — label pinning reproducing the shared-mask counterexample, the sweep profile equalling the
direct profile, a transcript-only problem analyzing, and the core monoid reproducing a private
antichain. All pass, and no existing test was changed.

Counts, measured in this checkout: the library test suite went from 945 to **949**, the four added
being probe 8's. Filtering to the leakage modules (`cargo test --lib leakage`) runs **28 tests,
all passing**, up from 24 before probe 8. One library test fails and is **not** probe 8's:
`fabric_routing::tests::the_retained_tree_agrees_with_dijkstra_at_every_separator_width` fails at the
parent commit `de53b6c` with no probe 8 code in the build, in a module this task does not touch and
whose last commit is another lane's. It is raised, not fixed here.

**The old modules were not reduced to re-exports.** Requirement 4 allowed either. Keeping them is
the right call here for one reason that is not conservatism: their committed certificates are the
evidence for probes 1, 2, 3, 5 and 6, and each certificate is produced by its own subcommand, whose
output schema is part of that probe's reproducibility bundle. Collapsing the subcommands would
either change those schemas — invalidating the byte-identical regeneration that §5 relies on — or
require the unified command to emit five legacy schemas, which is the same code in a worse place.
The unification that matters is the library surface, and that is done.

---

## 7. Status and remaining work

Done: items 1, 2, 3 (with the stated blocker), 4 (subcommands kept working, unified `leakage` added),
and 5.

Remaining, none of it blocking:

* **Deleting the old subcommands** once each probe's certificate is regenerated under the unified
  schema. That is a schema migration with a documented diff, not a refactor, and it should be one
  task with the report updates.
* **A menu-quotient mode** for probe 6's Proposition 4, which the unified surface now has the right
  input shape for.
* **Multi-level masked towers** are compiled and analyzed correctly by construction, but the only
  committed masked instance is one-level. A two-level masked instance cross-checked against
  `masked_leakage`'s min-sum tables would close that gap.

**Workspace hygiene.** `cargo fmt --check` is clean. `cargo clippy --all-targets -- -D warnings`
reports exactly two findings, both in `src/gadget_corpus.rs`, which is another session's uncommitted
work in the same checkout and is not mine to edit; with that file's findings excluded, the workspace
is clean, and none of the probe 8 files produce a finding.
