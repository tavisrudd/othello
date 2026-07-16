# C144 — gate architecture for the shared `RelativeConicArcs` library

**Date**: 2026-07-14
**Lane**: `relconic` — see CLAUDE.md § Lane routing. (Cross-cutting infrastructure; pegged to the
lane that owns the deliverable and the blocked items. Re-peg if another lane should own it.)
**Status**: REPORTED 2026-07-16

## The problem

`lean/RelativeConicArcs/` is one Lake library shared by three concurrently-active lanes —
`relconic`, `baer`, `alt-orbit-repair`. C107/C110's only remaining gate is "rerun the top-level
`RelativeConicArcs` aggregate". That gate is unachievable as written:

- The aggregate passed green 2026-07-14 17:15 (11977 jobs, 0 errors, standard axioms, no `sorry`).
- By 17:35 `lake build --no-build RelativeConicArcs` exited 3 — **stale**. Another lane had
  regenerated ~1262 `Q25PairRows/*.lean`.

A lane's exit gate cannot depend on other lanes' write schedules. Regenerating a shared checker also
dirties its whole dependent leaf tree, which is simultaneously the OOM risk.

## Verified structural facts

- **The Q16 and Q25 subtrees are import-disjoint.** No `Q16* → Q25*` or `Q25* → Q16*` imports.
  `Results.lean` (the relconic paper's terminal) imports only `ExampleChecks.Q8/Q9/Q11/Q16` and
  `Q16Result` — it never reaches Q25. The umbrella `RelativeConicArcs.lean` is the *only* thing
  coupling the two sides.
- Therefore the Q25 churn is **entirely outside the relconic paper's closure**. The aggregate
  encodes "the whole shared library is green at this instant" — a repo-health property, not a
  property of C107/C110's claims.
- **Lake takes no build lock.** Only an exclusive *configuration* lock (`olean.lock`). Two
  concurrent `lake build`s race artifact writes on any shared closure and double-book RAM.
- `lake pack` archives the root package's whole `buildDir` and builds nothing — the supported
  snapshot route. `.lake/build/ir` (C/object outputs) sits beside `lib`, so a partial copy of
  `lib/lean` is not known to restore consistently.
- `lake cache` exists (local `add/stage/unstage` + remote services; only `reservoir` configured).
  How a local build is made to *consume* a local cache is **unverified**.

## Options

| Option | What | Effort | Risk | Disruption |
|---|---|---|---|---|
| **A. Per-lane gate targets** | One hand-written sub-umbrella per lane (e.g. `RelativeConicArcs/Gates/Relconic.lean`) importing that lane's claimed terminal modules. Gate = build it, confirm with `--no-build`, then axiom audit. Full transitive kernel checking by construction; no `--old`. | Hours | Scoping error (omitting a claimed module) — derive imports from the paper's claim ledger | None |
| **B. Aggregate → quiescence check** | The umbrella build becomes a scheduled repo-health check, run only when `git status --porcelain lean/` is clean and the build window is held. Never a lane's exit gate. | A CLAUDE.md paragraph | None — "main is green" is preserved, just re-owned | None |
| **C. Extra `[[lean_lib]]` targets per subtree** | Named subtree targets in `lakefile.toml` | Small | Glob misconfig | Low — buys little; module targets already exist (`lake build +RelativeConicArcs.Q25PairResult`), so A covers it |
| **D. Split into separate Lake packages** | core ← cert-data ← results, path `require`s; module names stay flat so imports don't change | Days: physical moves of thousands of tracked files, manifest/toolchain pin duplication | git-history churn; three live lanes touching moved paths | High — defer |
| **E. Build-window protocol** | One heavyweight build box-wide at a time: advisory `flock`/lock-file (lane, PID, target, N, started-at) before any generated-certificate or aggregate build; small hand-written leaf builds exempt. Formalizes the queue's existing "BUILD-WINDOW GATED" language. | A CLAUDE.md section + gitignored lock path | Cooperative only | None |
| **F. Generator hygiene** | Leaves stay git-tracked sources. Regeneration only inside a held window; checker change + regenerated leaves + green subtree build land as **one commit** — never leave a regenerated tree uncommitted across a window release. Generators against explicit roots. Do not check in oleans/pack archives. | Doc rules | Low | None |
| **G. Artifact reuse** | `lake pack` for snapshots (replaces hand-rolled copies). `lake cache` local reuse needs a two-worktree experiment before relying on it. | pack trivial | cache semantics unknown | None |

## Recommendation

**A + B + E + F now; G's `lake pack` as the snapshot tool; defer C and D.**

1. **Close C107/C110 under gate A.** The relconic closure excludes every file dirtied by the Q25
   regeneration, so `lake build` on `Results` + the paper's other terminal modules, `--no-build`
   confirmation, and `#print axioms` = `[propext, Classical.choice, Quot.sound]` (no `sorryAx`, no
   `native_decide`, TRUST.md form) passes green now, at a recorded commit. **Not a weakening:** the
   aggregate's extra content is other lanes' theorems, which C107/C110 never claimed. Record the
   gate as "targets + commit + toolchain", not "the aggregate was green at time T".
2. **Shared-core escape hatch.** If a lane's diff touches a module imported outside its subtree
   (e.g. `Plane`, `Quadratic*`), its gate widens to the direct reverse importers' gate modules
   (cheap to compute by grepping imports), or defers to the next quiescence aggregate. This is the
   one case where per-lane gating alone is genuinely weaker than the aggregate.
3. **Then:** add the per-lane gate modules, the build-window section, the atomic
   regeneration-commit rule, and re-home the umbrella as the quiescence check — one CLAUDE.md edit
   plus handoff/queue rewording for C107/C110 and C143.
4. **Only if churn persists:** run the `lake cache` local-reuse experiment, then reconsider D.

Cost: a few small files and doc edits. No RAM, no new hardware, no Lake patches, no gate weakening.
The aggregate stops being a moving target because no lane's closure is gated on other lanes' writes.

## Implemented architecture

- `RelativeConicArcs.Gates.Relconic` owns the relative-conic paper, C107's evaluation dichotomy,
  and the q=9/q=11 game and coding consumers without importing either Q25 subtree.
- `RelativeConicArcs.Gates.Baer` owns the public five-profile q=25 extension terminal.
- The alternate-orbit gate is a three-module compatible target set covering all six paper-facing
  targets named by that manuscript's reproduction protocol. A single umbrella is impossible at the
  current source boundary because independently compiled terminals synthesize a duplicate instance
  name when imported into one environment; the separate targets match the manuscript's valid build.
- The root workspace guide now makes these per-lane modules the exit gates, widens validation after
  shared-core edits, reserves the umbrella for a locked quiescent repo-health check, and requires
  atomic checker-plus-generated-leaf commits.
- C144 defines validation topology and policy only. The `build-sys` lane owns and supplies the
  queue, ownership lock, resource profiles, future reverse-import analyzer, pack/restore mechanics,
  and detached-run lifecycle; C144 neither duplicates nor changes those mechanisms.

## Validation

The `build-sys`-owned queue admitted the measured `q25-two-witness` profile and built the complete
five-module gate set under the shared ownership lock:

- `RelativeConicArcs.Gates.Relconic`
- `RelativeConicArcs.Gates.Baer`
- `RelativeConicArcs.Gates.AlternateOrbitRepairQ25`
- `RelativeConicArcs.Gates.AlternateOrbitRepairProfileEnvelope`
- `RelativeConicArcs.Gates.AlternateOrbitRepairParameterized`

Every target passed its exact build, and the queue's final trace-only confirmation passed. The gate
modules are import-only and introduce no declarations or axioms; their terminal declarations remain
covered by `lean/RelativeConicArcs/TRUST.md`'s strict audit.

The first attempted single-module alternate-orbit umbrella correctly failed at import composition:
independently compiled terminals synthesize the same instance name. Splitting the gate into three
compatible targets preserves all six manuscript targets without changing another lane's theorem
sources. All three split modules then passed guarded elaboration and the fresh queue gate.

## Deferred build-system questions

- `lake cache` local consumption — needs a two-worktree experiment.
- Whether restoring only `.lake/build/lib/lean` yields a consistent tree (`lake pack` sidesteps it).
- Mechanism of olean loss on OOM kill (Lake deleting incomplete outputs vs. kill mid-write) —
  observation accepted, mechanism unestablished; does not change the advice.
- The C143/checker RSS figures are the alt-orbit-repair lane's, not independently re-measured.

Origin: 2026-07-14 review by Fable, prompted by the aggregate going stale ~20 min after passing.
Handoffs affected: [relative-conic arcs strengthening](handoffs/2026-07-13-relative-conic-arcs-strengthening.md)
(its "Next step" instructs the now-known-unachievable aggregate rerun).
