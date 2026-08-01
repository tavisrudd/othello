# C759 — generated external trust exports

**Lane:** `build-sys`

**Status:** COMPLETE — deterministic external views landed; Nanoda pilot blocked at the pinned
Lean 4.32 release-candidate gate

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

## Disposition

`lean/scripts/external-trust-exports.py` now generates and checks the v0.3-compatible manifest,
the compact portfolio table, and the exact machine-readable terminal list under
`lean/trust/external/`.  The 95 exported terminals are precisely the terminals adopted by the
three declared area spines.  Thirty-six have extracted axiom sets that match their declarations;
the other 59 are explicitly marked `declared-unextracted`.

The second-kernel pilot is **blocked by its version gate**.  The pinned toolchain is
`leanprover/lean4:v4.32.0-rc1`, not a final Lean 4.32 release.  No Nanoda checkout, download,
challenge module, or build was started, so setup cost at the blocked gate was zero downloads,
zero generated files, and no persistent pilot state.  Reconsidering the experiment after a final
toolchain pin is a new execution decision, not an implicit portfolio rollout.

Report: `notes/2026-08-01-c759-external-trust-exports.md`.

## Owned paths

`lean/scripts/`, `lean/trust/`, narrow generated release-facing trust documents, this report, the
build-system handoff, and the live queue row. Mathematical Lean modules and certificate payloads
remain out of scope.
