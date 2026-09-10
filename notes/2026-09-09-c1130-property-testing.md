# C1130: generated contracts for core, JS and WASM

PRIVATE / not-to-ship. Ergodis lane. Requested two-hour testing work period.

## Decision and scope

Property-based testing is productive at the semantic boundaries: checked reduction
admission, quotient/readout compilation, retained provider lifetimes, campaign
revision and retry state, cross-language arithmetic and serialization. Generate
structured models and operation histories, shrink those inputs directly, and keep
independent small exhaustive oracles outside the implementation. Native/WASM
agreement complements those oracles; agreement alone cannot establish correctness.

Private design: `ergodis-private/analysis/property-tests/design.md`. Replay commands,
coverage limits and dated evidence are alongside it in `README.md`,
`2026-09-09-validation.md` and `validation.json`. This is a testing design and
validation record, not a new solver abstraction or a public shipping document.

## Delivered

- Ten generated contract groups spanning JS, WASM and native: reduction admission, Worker
  schedules, composition, arithmetic, campaign sessions, retained composition,
  module lifetimes, bundles, resource allocation and retry-cache histories.
- Native multi-sort quotient/readout tests use independent paired-state
  reachability. Native configurable cache budgets check rejected creation leaves
  no campaign and successful operations preserve revision and retry semantics. A
  valid proposal rejected only by retry reservation must preserve the entire
  campaign view; the same proposal must succeed in an unconstrained control.
- Composition transformations cover reordered blocks, repeated labels and uniform
  cost translations over seven fields. Service results, receipts and refutations
  have independent GF(2) enumeration. Retained resource models have exhaustive
  assignment and capacity-monotonicity checks.
- All six provider families receive generated lifecycle operations and high-bit
  handle corruption. LRC/QEC/CSS/Hadamard still use fixture model inputs; their
  mathematical input generators remain a follow-up.
- Source mutation controls must fail, shrink and replay; real code must pass the
  same minimized case. Reports include relevant source and binary hashes.

## Defects found and fixed

Core `72611e2` closes a CampaignSessionClient immediately when synchronous
postMessage fails, clearing pending state and timers. Its minimal regression is
ready → post failure → request.

Private `d69ea36` fixes a learned-rerun race clock: epoch conversion could put the
start after observed readiness and produce negative elapsed time. A 225-case
clock cross product fails on the old code and passes the fix; browser learned
reruns also pass. Timing still begins in ready workers.

Worker schedules and resource-cover admission are JavaScript contracts; bundle
properties exercise WASM. Native/WASM parity applies to the service, composition,
arithmetic and retained-provider groups. Native quotient and configurable-limit
properties are not described as browser coverage.

No production solver hot loop, kernel dispatch or optimization policy changed.
No native performance improvement or regression-free benchmark claim is made.

## Evidence and limits

Five held-out seeds completed 50,000 generated cases in each of the original
seven groups, with regression replays counted separately. The final two seeds
also covered 20,000 bundle models and 20,000 resource-provider models. Service
requests total 1,537,312 and module-lifecycle calls total 2,157,536. Native typed
quotient testing separately passed 100,000 models. The 43-check integrated suite passed, including browser and mutation controls.
Core formatting, all-target/all-feature Clippy and all-feature tests passed.
Exact counters and report
hashes are in the private validation manifest.

The native transport executable is copied into each new run directory so later
Cargo builds cannot replace evidence under a running test. The first three long
seeds predate that retention fix; their original hashes are preserved and the
controller transition is documented. No failing mathematical case was discarded.

An intermittent Chromium Worker/WASM fetch abort remains reproducible in a small
cache-only stress harness, including serial bundle inspections. A later full-suite
pass does not resolve it. No retry or delay workaround hides that limitation.
Actual Safari execution remains untested. Private all-target Clippy has four
pre-existing findings, documented separately; core mandatory gates are distinct.

## Next frontier

Prioritize valid certificate mutations with independent rejection expectations,
then generated family-specific QEC/CSS/LRC/Hadamard inputs. Keep browser transport
stress separate from deterministic Worker schedules. Extend mutation sensitivity
when adding a new semantic assertion family; do not substitute large case counts
for an oracle. Follow up the minimal Chromium fetch-abort reproducer before
calling browser lifecycle reliability closed.

Concrete verifier follow-up is specified in the private design: binary-composition
`verify`/`replay` with independent assignment enumeration, followed by authenticated
min-plus snapshot/transition replay with an independent small tree model. These
are explicitly planned properties, not included in the delivered coverage count.
