# C759 — generated external trust exports

**Lane:** `build-sys`

**Status:** QUEUED

## Goal

Expose the existing trust spine in a compact, externally familiar form without creating a second
source of truth. Generate a `formalization.yaml`-compatible release manifest, a portfolio headline
results table, and a machine-readable headline-theorem list from the declared spine and extracted
facts already owned by C326/C681.

## Contract

- Generated exports only: titles, terminals, exact axiom sets, toolchain pins, source and
  certificate hashes, replay commands, and review status remain owned by their current registries
  and facts artifacts.
- Preserve the stronger existing checks for module classification, dependency closure, generated
  data provenance, paper/Lean reconciliation, and independent certificate replay.
- Add deterministic generation and a read-only stale/hand-edit rejection check; two generations
  from unchanged inputs must be byte-identical.
- Do not add a portfolio `All.lean`, copy proofs, or commit sorried Comparator challenge modules.
- After the Lean 4.32 final-version gate, run one bounded Nanoda/second-kernel feasibility pilot on
  a small public theorem bundle in disposable release state. It is an experiment, not a portfolio
  rollout, and must not weaken the monorepo's global no-`sorry` boundary.

## Acceptance

1. Every exported mathematical fact resolves to a stable trust-spine or paper-facts identifier.
2. The external manifest and headline table are generated, deterministic, and covered by `check`.
3. The theorem list agrees exactly with the adopted public terminals and records exact axioms.
4. Existing trust-spine and paper-facts fixtures remain green, with adversarial coverage for stale
   or manually edited exports.
5. The second-kernel pilot has an explicit pass/fail/blocked disposition and measured setup cost;
   no broad adoption follows without a separate decision.

## Owned paths

`lean/scripts/`, `lean/trust/`, narrow generated release-facing trust documents, this report, the
build-system handoff, and the live queue row. Mathematical Lean modules and certificate payloads
remain out of scope.
