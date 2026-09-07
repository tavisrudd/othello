# C1079 core ergodis-evolve inventory

**Lane:** `ergodis`
**Date:** 2026-09-06
**Scope:** read-only core evidence at `~/src/ergodis`, revision
`6cc96680c0c3251d094afb9b7b09bf6d1cfc8ce4` (working paths inspected clean).
This is input to the C1079 synthesis, not an implementation recommendation.

## What is implemented

1. **A bounded, daemon-owned predicate-plan evolution loop.** `src/control/mod.rs:1404-1745`
   accepts at most 32 predicate seeds, 1--32 generations, beam at most 256, and at most
   100,000 candidates. It creates a low-priority worker and a create-only JSONL evidence
   file; `src/control/evolution.rs:1981-2025` freezes the feature batch and lowers worker
   priority. The runner mutates bounded `PlanSpec` predicates, evaluates them over that
   frozen batch, selects outcome-distinct/niche-diverse elites, records failure shapes, and
   can resume compatible candidate archives. `CONTROL_PROTOCOL.md:318-469` documents exact
   replay, counterexample-targeted threshold mutation, diversity, hindsight fragments, and
   target-profile steering.

2. **The core has useful generic discovery primitives beyond the daemon.**
   `src/theorem_search.rs:1-310` supplies a runner-neutral deterministic seed/mutate/test/rank
   interface, exact finite-corpus separability probing (`:47-143`), soundness scoring
   (`:157-228`), and a quality-diversity cadence. `:620-910` has a bounded Pareto archive
   that admits only zero-false-positive corpus rules, while explicitly serializing it as
   `proof_authority: false`. `:920-1220` retains exact unsound/incomplete failure cores and
   a persistent hard-example replay front; comments correctly say these contract proposal
   space but grant no theorem authority.

3. **There is real typed proof-status scaffolding, added after the Sept. 2 survey.**
   `src/semantic_theorems.rs:1-128` defines `Candidate`, `FiniteCertified`, and `Proved`,
   clamps compositions to their weakest premise, and requires an `IndependentCheck` for a
   proved leaf or checked inference. `:189-345` records the decision in an append-only,
   replay-verifiable provenance DAG. `src/provenance.rs:1-315` provides the generic
   forward-verifiable DAG/sidecar. It is used by domain-neutral discovery-only predicate-cover
   selection (`src/predicate_cover.rs:1-132`) and one narrowly structural, independently
   rechecked complement-cycle proof (`src/mask_cycle_proof.rs:1-250`). This is status and
   derivation machinery, complementary to rather than a replacement for a scoped theorem
   registry/admission contract; it is not wired to `evolve` candidates or solver admission.

4. **Unix-socket steering exists and is deliberately cold-path.**
   `src/control/mod.rs:435-475` dispatches capabilities/status, candidate evaluation,
   target-profile operations, evolution start/refresh/status/cancel, and proposal-session
   operations. `CONTROL_PROTOCOL.md:1-51` specifies a nonce/run-bound, one request/response,
   bounded Unix-domain protocol; `:116-145` says the daemon is an optional low-priority
   campaign component and search workers do not run socket/evolution work. Live profile
   refresh applies only at a generation boundary (`src/control/mod.rs:1717+`; protocol
   `:415-469`).

## Exactness, mode, and provenance boundary

The current control plane is uniformly **non-proof-authoritative**: `DESIGN.md:7-12, 80-95`
and `CONTROL_PROTOCOL.md:116-126` say candidates can diagnose/order but cannot prune exact
search; promotion needs an independently validated, presentation-bound schema. This correctly
preserves the C1016 rule that evolved/heuristic predicates do not establish negative coverage.

However, C1079's three dimensions are not represented separately end-to-end:

| Dimension | Existing evidence | Gap |
|---|---|---|
| Run mode | `ProposalRole` has `Heuristic`, `NecessaryReduction`, and `ExactTransport` (`src/control/proposal_policy.rs:577-603`), but `evolve-start` has no `SearchMode` and all evolve output remains diagnostic. | A proposal role is not a run-wide proof-generating/heuristic obligation or coverage policy. |
| Candidate origin/lineage | `EvolutionSeed` records `parent_hash`, `source_hash`, `source_evidence`, and operator (`src/control/evolution.rs:91-116`); headers bind code, presentation, problem, fields, and optional feature-generator name/version/digest (`:41-88`; `src/control/vm.rs:26-33`). | This supplies partial plan lineage, but not an individual theorem-and-parameter origin taxonomy (human/imported/generated/evolved/composed) or a complete per-theorem/parameter derivation, validation, and reuse model. Feature-extractor provenance is not theorem/parameter provenance. |
| Validation/status/scope | `ClaimLedger` can record Candidate/FiniteCertified/Proved and proof composition; `SoundTheoremArchive` checks finite corpus soundness. | No adapter connects evolved plans to `ClaimLedger`; no theorem schema, applicability domain, parameter side conditions, parameter-instantiation status, or mutation evidence-reuse rule is carried through evolution evidence/control responses. Corpus perfection must not be mistaken for theorem proof. |

## Synthesis priorities from reconciliation

1. **High priority: current core lacks the requested autonomous theorem/parameter quotient loop.**
   The implemented loop evolves bounded Boolean/numeric plan predicates over one frozen feature
   batch, not theorem schemas plus parameter instances over a changing search/solve space.
   `DESIGN.md:53-76` itself calls live snapshot ingestion and durable checkpoint/resume accepted
   but unimplemented, and calls `ergodisctl evolve`/offline replay staging tools. Treat claims
   that this is already an autonomous prover/quotient engine as stale.

2. **High priority: proof-status machinery and evolve are disconnected.** The later core additions
   demonstrate a safe promotion boundary, but no `ClaimLedger` use occurs in
   `src/control/evolution.rs` or `src/control/mod.rs` (targeted reference search). A C1079
   plan may retain both, but needs an explicit typed bridge and a separately reviewed solver
   admission path; neither a `proof_authority: false` archive nor a `Proved` sidecar alone is
   that bridge.

3. **Medium priority: terminology currently risks conflating heuristic role with proof mode.**
   `ProposalRole` is per external proposal, while the daemon's capability remains globally
   non-authoritative. The next data model should expose mode, origin, validation status/scope,
   and admission decision independently in socket observations and durable artifacts.

4. **Medium priority: optimization is only a local proxy.** Evolution ranks frozen-batch weighted
   correctness, false positives, semantic complexity, and evaluation-cost proxy
   (`CONTROL_PROTOCOL.md:350-415`); target profiles prioritize measured mass × unit cost but
   explicitly cannot authorize pruning (`:396-469`). No implemented objective measures quotient
   construction cost plus end-to-end exact solve savings or proves optimal quotienting.

## Tests and evidence limits

Inline coverage exists for evolution at `src/control/evolution.rs:3875-5283`, control at
`src/control/mod.rs:2284+`, and the ledger/predicate-cover/mask-cycle modules. The code carries
many bounded/replay/counterexample tests (for example exact hindsight composition at
`src/control/evolution.rs:4997`). I did not run builds or tests under this read-only assignment.

No core evidence located here demonstrates: an evolve-generated theorem promoted through an
independent parameter-sensitive checker into an exact solver quotient; proof-generating versus
heuristic run-mode switching; provenance of evolved theorem parameters across campaigns; durable
evolution checkpoint/restart; or objective-measured end-to-end quotient improvement. These are
evidence gaps and synthesis inputs, not demonstrated implementation defects or negative claims
about C1016/private work.

## Documentation contradiction to carry forward

`DESIGN.md:53-76` is the clearest current source: implementation is a controlled experimental
worker and external/offline staging, with autonomous live ingestion/checkpointing accepted later
design. `CONTROL_PROTOCOL.md:136-145` agrees. The protocol's extensive external-proposer section
(`:151-317`) describes bounded dispatch infrastructure, yet explicitly leaves autonomous provider
selection outside the generic layer (`:243-244`). Its language should not be used to imply that
the core already autonomously discovers structural theorem/parameter quotients.
