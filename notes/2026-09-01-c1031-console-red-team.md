# C1031 — red-teaming and testing the Ergodis campaign console

**Lane**: `complete-ports`
**Task**: C1031
**Date**: 2026-09-01
**Status**: this block complete; console and its data layer now under three gates

Companion documents: the charter and survey `notes/2026-08-31-c1031-ergodis-visualization-goal.md`,
the data-model note `notes/2026-08-31-c1031-ergodis-visualization-data-model.md`, the architecture
recommendation `notes/2026-08-31-c1031-ergodis-visualization-architecture.md`, and the exploration
report `notes/2026-08-31-c1031-ergodis-visualization-report.md`, which this extends rather than
replaces.

Prototype source is on branch `c1031-ergodis-viz` in the worktree `/home/tavis/.cache/c1031-ergodis-viz`,
under `tools/c1031-viz`, in commits `ac55b3abc`, `17dc76a38`, and `ae22d015b`. No Ergodis core source
was modified.

## What this block did

The console had been built and shown to produce findings. It had not been attacked. This block
asked what it would take for the console to be confidently wrong, built the tests that would catch
that, and fixed what they found. Four defects surfaced, three of them silent — the console displayed
a plausible number rather than failing.

## The in-page evaluator disagreed with the Rust one, and the disagreement was reachable

The console re-implements the Ergodis plan virtual machine in JavaScript so it can evaluate a
selected plan over every object without a round trip, and it displays the result beside the score
the daemon recorded, calling the comparison an independent check. That claim is only worth anything
if the two evaluators actually agree, and agreement on the plan shapes a campaign happens to produce
is weak evidence: an evolution reaches a narrow corner of the grammar, so the shapes that never
appear in a lineage file are exactly the ones the console was never tested on.

`tools/c1031-viz/difftest.mjs` generates plans across the whole grammar — every operation, both
sorts, scopes, nested `select`, and constants chosen to provoke 64-bit overflow — evaluates each one
through `ergodisctl batch`, which is the same compiled Rust evaluator the campaign uses, and requires
the page to reproduce the weighted correct, false-positive, false-negative and predicted-true counts
exactly. The evaluator under test is extracted verbatim from a marked block in the template, so the
test cannot pass against code the page does not run.

It found two divergences.

**The `bool` operation was unimplemented, and an unimplemented operation corrupts the stack.** The
old evaluator's switch fell through to a binary default that pops two operands and pushes zero, so a
plan containing `bool` was not merely mis-scored on that operation — everything after it read the
wrong stack. This is not hypothetical: `learn_decision_tree` in `control/synthesis.rs` emits exactly
`PlanOp::Bool` for every leaf and `PlanOp::Select` for every branch, so every plan `ergodisctl
synthesize` produces was affected. Synthesizing a real decision tree on the 55-field semantic corpus
and putting it through both evaluators: the Rust VM scores it 829 of 1,024, the old console 819 —
and 819 is the majority-class count, so the console's own held-out panel would have reported the
system's decision-tree learner as having found nothing, when it beats the baseline by ten objects.

**Overflowing arithmetic was answered rather than refused.** The Rust VM works in `i64` with checked
arithmetic and rejects a plan whose arithmetic overflows; JavaScript would silently return an
inexact double. The evaluator now runs a double fast path, escalates that row to exact integers the
moment a value stops being exactly representable, and refuses exactly where the Rust VM refuses. On
the real corpora this escalation never triggers, so it costs nothing in practice.

Where the page genuinely cannot evaluate a plan it now says so and draws nothing, in the object
space and in the held-out check both. The previous behaviour — a fabricated column beside a real
recorded score — is the failure mode the whole console exists to prevent.

Results, all seeds and both corpus shapes:

| population | corpus | agreed | disagreed |
|---|---|---|---|
| 300 generated plans, seed 7 | 55 fields, unweighted, 1,024 objects | 261 | 0 |
| 200 generated plans, seed 3 | same | 167 | 0 |
| 250 generated plans, seed 11 | g=133 excluded cells, weighted to 1.57×10⁷ | 225 | 0 |
| 500 real lineage plans | g=133 excluded cells | 500 | 0 |
| one synthesized decision tree | 55 fields | 1 | 0 |

The same test against the previous evaluator disagrees on 37 of 300 generated plans and on the
synthesized tree, which is what makes the zeros above meaningful.

## The reader could not read a live run

`bake_run.py` raised a JSON decode error on a half-written final line. That is not an edge case: it
is the normal state of a file a campaign is appending to, so the live server returned nothing at all
whenever it read a run mid-write. Four further shapes crashed it outright — a damaged record in the
middle of a file, a record that parses but carries no candidate, a ledger event with no kind, and a
trace file the daemon was still writing.

The reader now drops what it cannot read and reports it. A damaged final line is treated as a write
in progress; damage anywhere else is counted as damage, because the two mean different things. The
counts travel in the payload and the console prints them in its signal list, so a run whose count is
short says why instead of quietly being short.

`tools/c1031-viz/datatest.py` gates this, and also gates the property the lineage sampler has to
have for the drawn graph to be honest: aggregates computed over every record, no dangling edge in
the drawn subset, every behaviour class and every expansion parent kept. Twenty checks, all passing;
five of them were hard crashes before this block.

## The live server had been serving a dead page

Gating the served page rather than only the built snapshot found that `serve.py` substitutes the
payload and the cascade but never the cross-corpus screen, so the literal placeholder reached
`JSON.parse`. The boot script threw there and everything below that point in the script — the object
space, the held-out check, the plan selector, the boot block — never ran. The console had been broken
in its live mode since the screen panel was added, and the snapshot path masked it because `build.py`
does fill the placeholder. The server now fills it, refuses to serve a page with an unfilled
placeholder, and the panel parses defensively so an optional block cannot take the page down with it.

## Two display defects of the kind this task keeps finding

**A column that was never computed was counted as a zero.** The cross-corpus screen panel reported
"0 of 14 solvable" directly above its own caption saying that every one of the fourteen corpora is
solvable exactly. The screen file carried the campaign results but not the exhaustive-probe columns,
and the missing column defaulted to zero. It now reports what was enumerated and says plainly when
nothing was, and `merge_screen.py` joins the screen with the pairwise and conjunction probes so the
panel has the columns it describes. With the probes merged the panel reads "14 of 14 solvable · 3
found by the search", which is the finding this task established.

This is the third instance of one rule: **a missing quantity is not a zero.** The behaviour count
without its ceiling, the accuracy without its baseline, and now the reachability without its
enumeration all read as confident negatives when the truth was that nothing had been measured.

**The held-out ranking overstated its own coverage.** The baker truncates the archive to its 400
highest-scoring classes, and the panel labelled the result as though it had scored the whole
archive. It now says how many of how many, and that the scored ones are the archive's best on
training data.

## The live console reloaded itself out from under its operator

The served page polled for changes and reloaded on any advance. A running campaign appends
continuously, so this fired every two seconds and made the console unusable during a live run —
which is the case it exists for. Reading a table or following a lineage was impossible. A reload now
happens only while nobody is working the page; an operator who is mid-inspection gets an offer in
the corner instead of an interruption. The page also restores its own tab, selected plan and filters
across a reload, so the reloads it does make cost nothing.

## `ej` + `tt` closeout

**One evaluator now serves three purposes, which was not the plan.** It is the console's object
space, the held-out check's scorer, and — because `difftest.mjs` extracts it from the template — the
subject of a test that pins it to the Rust VM. Any future front end consuming the baked payload
inherits an evaluator with a differential proof attached.

**The gate got a real assertion for free.** The page already recomputed the selected plan's score and
compared it against the recorded one. That comparison was displayed and not checked, so `smoke.mjs`
now fails on a disagreement. The strongest available assertion was on screen the whole time, unused.

**The oracle is a production path, not a test harness.** `ergodisctl batch` is the campaign's own
evaluator, so the test cannot drift from the system it checks, and it needs no core change to run.

**What the difftest cannot reach.** Feature values beyond 2⁵³ are already inexact when the payload is
parsed, before any evaluator sees them, because the payload is JSON read by the browser. No corpus
in this tree has such values, and the fix would be a custom reviver at parse time. Recorded rather
than done.

## Mystery ledger

- **Settled — whether the console's independent check was independent.** It was, and it was also
  wrong on a reachable class of plans. Two evaluators over the same objects only check each other if
  someone makes them disagree on purpose.
- **Settled — why the served page differed from the snapshot.** An unfilled placeholder, one
  exception, and half a script that never ran. Gating one build path and not the other hid it for
  the whole of the previous block.
- **Open — whether the evolution ever emits `bool` or `select`.** The observed mutation operators
  rewrite leaves and comparisons inside a fixed skeleton, and no candidate in a hundred thousand
  contained a connective, so on present evidence it does not. The synthesis path certainly does. The
  question matters only if someone seeds an evolution from a synthesized tree, which is a plausible
  thing to want and would be the first test of whether the mutation operators handle those shapes at
  all. **Evidence gap**: no campaign has been seeded from a `synthesize` output.
- **Open, unchanged from the previous block** — the two evolution paths disagree on candidate count
  from identical seeds and bounds, 735 against 257. A question about the search, not the console.
- **No genuine mystery remains in the console's correctness surface.** Every number it displays is
  now either checked against the Rust VM, computed from records it says it read, or labelled as
  absent.

## Vibe check

Good, and sharper than expected. The console was pointed at itself and it was wrong in three places,
one of them silently mis-scoring every plan the system's own decision-tree learner produces. All
three are fixed and each now has a test that fails without the fix.

## Recommended next move

Unchanged from the previous block, and still cheap: one monotonic clock reading per durable ledger
event, which unlocks the completion estimate and the performance replay. The tests added here are
the thing to run before any further console change; the three commands are in
`tools/c1031-viz/README.md`.
