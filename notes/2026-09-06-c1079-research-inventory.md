# C1079 research inventory — evolve, C985, core, and C1016

**Lane:** `ergodis`
**Date:** 2026-09-06
**Scope:** recovered evidence only; no source or design change. Line references identify the
version read on this date. “Implemented” below means a report says it landed or source exposes
the boundary; it is not an assertion that all proposed architecture is integrated.

## Authoritative reconciliation rule

C1079’s brief is the controlling product statement: autonomous discovery of structure, applicable
theorems and parameters, and effective quotients; Unix socket steering is a control surface, not
the product boundary (2026-09-06-c1079-ergodis-evolve-brief.md:8-13). Its explicit three-way
separation is search mode, candidate provenance, and validation status/scope
(2026-09-06-c1079-ergodis-evolve-brief.md:54-73). Earlier C985 material describing `evolve` as
a finite-corpus sound-necessary-condition finder describes the then/current implementation scope,
not necessarily a conflicting product intent. It is useful as one engine arm and cannot let finite
observations grant general negative coverage.

Several C985 files still say `Lane: complete-ports` (for example
2026-09-01-c985-evolve-proposal-admission-architecture.md:3-6), while the current ergodis handoff
assigns C985 and C1079 to `ergodis` (handoffs/2026-09-05-ergodis-lane.md:150-154). This is stale
routing metadata, not evidence against the C1079 objective.

## Recovered capability map

| Area | Implemented/reported evidence | Original intent and remaining boundary |
|---|---|---|
| Core theorem safety | `semantic_theorems.rs` makes discovered output `Candidate`, bounded exhaustive evidence `FiniteCertified`, and independent checking `Proved` (ergodis/src/semantic_theorems.rs:1-42). Composition clamps to its weakest premise (ergodis/src/semantic_theorems.rs:100-126). The core theorem archive marks snapshots `proof_authority: false` and rejects forged authority (ergodis/src/theorem_search.rs:631-761). | Strong reusable status/proof boundary. The visible status model does not itself express generated/imported/composed origin or parameter derivation, so C1079 needs a separate per-candidate lineage record rather than overloading status. |
| Core campaign and proposal control | The historical C985 spike reports a feature-gated `ergodis-campaign`/`ergodisctl`, typed postfix VM and prefix source form, ledger, batch/evolutionary evaluation, decision-tree proposer, and private Unix datagram epoch notification (2026-08-30-c985-ergodis-campaign-control-spike.md:6-32). Current core evidence supersedes its v0-status language: daemon-owned bounded low-priority predicate evolution is implemented in `src/control/mod.rs:1404-1745`, with frozen-batch/low-priority worker mechanics in `src/control/evolution.rs:1981-2025` (2026-09-06-c1079-core-inventory.md:7-12). | Current loop evolves bounded predicate plans over a frozen feature batch. It does not yet establish an autonomous theorem-schema plus parameter-instance quotient loop over a changing solve space (2026-09-06-c1079-core-inventory.md:53-58). |
| Unix-socket steering | Watcher blocks on a per-solver datagram, fetches/validates/compiles after semantic epoch change, and the solver only swaps preallocated arenas at a safe point (2026-08-30-c985-ergodis-campaign-control-spike.md:6-25). Socket exercise covered activation, bad identity rejection, deactivation, and unchanged empty snapshot (ibid.:25-32). | This supports autonomously running campaigns plus human/agent steering. It must remain observation/control/persistence plumbing, with no socket I/O, compilation, allocation, or serialization in search workers. |
| Search/control learning | Historical audit records typed lineage fields, compiled/outcome hashes, structural-repeat rejection, exact outcome-class expansion, 64-row monotone early rejection, deterministic impact/cost selection, semantic niches, and an explicitly untrusted theorem DAG (2026-08-30-c985-ergodis-evolve-sota-literature-audit.md:8-37, 108-229). Current core also retains exact unsound/incomplete failure cores and a persistent hard-example replay front in `src/theorem_search.rs:920-1220` (2026-09-06-c1079-core-inventory.md:13-17). | Cross-campaign hard-example replay is landed, so “minimal separating cores not landed” is inaccurate. Durable checkpoint/restart, richer theorem/parameter lineage, changing-domain evaluation, independent islands, broad proposal generation, and learned policy remain separate evidence/integration questions. |
| Admission and reusable theorem/quotient artifacts | Accepted C985 reference pattern is untrusted proposer → bounded typed proposal → normalization → exact obligation replay → role-specific admission → source-bound artifact → compiled consumer (2026-09-01-c985-evolve-proposal-admission-architecture.md:9-32). It requires identity, source digest, resource envelope, intended role, obligations, independent result, and dependency fingerprints (ibid.:44-76). | This is the direct bridge from discovery to theorem/parameter-driven quotienting. It correctly makes the proposer replaceable and authority-free; a rejected candidate can still feed counterexamples/cost to the next generation. |
| C1016/private quotient/search work | C1016’s recovered memo proposes cold validation → private typed witness → branch-free fixed-shape kernel, prioritizing residual aggregation, shift packs, packed quotient profiles, and only then runtime theorem registries (2026-08-31-c985-c1016-zero-cost-witness-handoff.md:10-43). `ValidatedRegistry` is proposed for evolved runtime programs, where a disposable A/B found validation-once materially cheaper; it is explicitly not a reason to replace specialized static adapters (ibid.:121-148). | This is a performance/admission substrate, not the autonomous discovery system. It supplies candidate representations and compile-time quotient specialization after an independent cold validator. C1016 provenance rule in the live handoff remains: heuristics/evolved predicates do not provide negative coverage (handoffs/2026-09-05-ergodis-lane.md:47-50). |
| Private adapters and parallel roots | Private research adapters were separated from reusable core; core retained domain-neutral independent-root execution. Reported q=11 control has exact single/24-worker metrics and 10.18x geometric-mean speedup across seven pairs (2026-08-30-c985-ergodis-private-adapters-and-parallel-roots.md:3-38). | It provides a realistic control/dispatch target, but its next gate is precisely cacheline-isolated heartbeat, compiled root-to-plan dispatch, and off-thread merging (ibid.:118-121); it should not dictate the general C1079 architecture. |

## Evolution of intent

1. The C985 literature/audit framing began with a compact typed predicate planner over exactly
   labelled finite corpora: zero false positives is a hard finite-corpus condition and coverage is
   the objective (2026-09-01-c985-evolve-sota-synthesis-lineages.md:15-31). It explicitly judged
   Ergodis weaker than broad evolutionary coding as an autonomous proposer, but stronger in exact
   finite evaluation and replay (2026-08-30-c985-ergodis-evolve-sota-literature-audit.md:8-37).
2. C985 then specified a durable campaign architecture: separate proposal, semantic evaluation,
   operational evaluation, and promotion; scope is part of the genome; paired root races measure
   search impact; semantic and performance stores are separate (2026-08-30-c985-ergodis-adaptive-search-learning-adr.md:63-171). The detailed store split preserves exact source/plan/output/counterexample/proof data separately from build/hardware-conditioned performance priors (ibid.:171-235).
3. The campaign-control spike implemented a bounded v0 and demonstrated that socket responsiveness
   can stay off the hot path, but it rejected its demonstrated ordering policy for production due
   to slower controlled runs (2026-08-30-c985-ergodis-campaign-control-spike.md:6-32). Its measured
   results are diagnostic controls, expressly not performance estimates (ibid.:25-32).
4. Before C1079, the accepted C985 proposal/admission architecture already required unattended
   campaigns and autonomous built-in evolution alongside opportunistic LLM proposals
   (2026-09-01-c985-evolve-proposal-admission-architecture.md:98-103, 229-235). C1079 makes the
   product intent and three-axis semantics controlling: autonomous structure/theorem/parameter/
   quotient discovery is the target; AlphaEvolve and CEGAR are inspirations; proof-generating and
   heuristic runs are independently selectable; generated origin never confers validation
   (2026-09-06-c1079-ergodis-evolve-brief.md:8-13, 54-73).

## Mode, provenance, and validation semantics

The evidence already supports much of the needed separation, but does not yet name all three axes
uniformly.

- **Mode:** C985 frozen-corpus evaluation can exactly decide labels on that declared finite corpus
  (2026-09-01-c985-evolve-sota-synthesis-lineages.md:15-31). This is appropriate for heuristic
  ranking or finite certification. C1079 requires a proof-generating run to discharge the
  reduction/coverage obligations beyond that corpus; heuristic use cannot turn pruning into proved
  negative coverage (2026-09-06-c1079-ergodis-evolve-brief.md:61-64).
- **Provenance:** Existing artifacts bind source fingerprints, proposer identity/version, canonical
  payload digest, parent hashes/operator, and dependency fingerprints
  (2026-09-01-c985-evolve-proposal-admission-architecture.md:44-76;
  2026-08-30-c985-ergodis-evolve-sota-literature-audit.md:108-129). They are a partial lineage
  substrate. The recovered material does not establish an explicit origin enum plus mutation/
  composition/run/config lineage for *each theorem and each parameter*, which C1079 asks to add.
- **Validation:** Core statuses and role-specific admission are sound directionally, and the
  proposal architecture expressly rejects one generic `verified=true` bit
  (2026-09-01-c985-evolve-proposal-admission-architecture.md:44-76). What is still required is a
  first-class applicability domain, parameter side conditions, evidence scope, and explicit
  descendant revalidation/evidence-reuse rule. A parent’s trusted status must not automatically
  transfer through a parameter or program mutation.

## Concrete inherited ideas worth retaining, with evidence limits

- **CEGAR/CEGIS discipline:** targeted conflict-driven feature creation remains a suggested import
  (2026-09-01-c985-evolve-sota-synthesis-lineages.md:202-221), while exact hard-example replay is
  current core functionality (`src/theorem_search.rs:920-1220`; 2026-09-06-c1079-core-inventory.md:13-17).
  Retain the extension: refutations should also drive grammar/feature/quotient refinement.
- **AlphaEvolve-like search control:** retain replay graph, typed mutation/operator lineage,
  novelty/semantic niches, and exact evaluator cascade. The older audit recommended against
  reproducing AlphaEvolve around arbitrary source programs
  (2026-08-30-c985-ergodis-evolve-sota-literature-audit.md:8-37); that is an audit recommendation,
  not a current user requirement.
- **Theorem/parameter candidate admission:** retain canonical typed IR and independent
  translation-validation. It supports imported, hand-authored, generated, evolved, and composed
  candidates equally, since proposer identity has no proof authority
  (2026-09-01-c985-evolve-proposal-admission-architecture.md:9-32).
- **Operational quotient selection:** retain root-scoped, paired probation as an empirical policy
  gate only. Frozen labels rank theorem predicates; scoped ordering needs same-stratum operational
  evidence (2026-08-30-c985-ergodis-campaign-control-spike.md:221-276). This is distinct from any
  claim that a quotient is mathematically optimal.

## Conflicts and gaps for the C1079 synthesis

1. **Scope distinction, not product conflict:** older reports describe an implemented predicate engine over a fixed finite corpus; C1079 specifies the wider target. Interpret that corpus engine as one candidate generator/evaluator, and preserve its exact finite-domain boundary.
2. **Authority vocabulary conflict:** “sound” in finite labelled data must be qualified by its corpus/domain. The core’s `FiniteCertified` versus `Proved` distinction is the safer vocabulary (ergodis/src/semantic_theorems.rs:1-42); C1016’s no-heuristic-negative-coverage rule governs global search claims.
3. **Integration gap:** current daemon-owned low-priority predicate evolution and hard-example replay are implemented (2026-09-06-c1079-core-inventory.md:7-17). The remaining gap is the requested autonomous theorem/parameter quotient loop, its bridge to proof status/solver admission, live changing-domain inputs, and durable checkpoint/restart (ibid.:53-69, 79-84).
4. **Provenance gap:** source/proposal/digest fingerprints exist, but a uniform theorem-and-parameter lineage object with origin, parent versions, mutation/composition steps, run/input/config IDs, scope, and revalidation history is not established by the recovered reports.
5. **Evidence gap:** reported C880 policy results include a corrected 2.16x repeated-work repair but remain slower than no-plan controls and are explicitly rejected for production; only the event-driven idle-path protocol supports its narrow “no measurable overhead” claim (2026-08-30-c985-ergodis-campaign-control-spike.md:6-32).

## Sources recovered

Primary C985/C1016 records: 2026-08-29-c985-ergodis-theorem-import-roadmap.md,
2026-08-30-c985-ergodis-evolve-sota-literature-audit.md,
2026-08-30-c985-ergodis-campaign-control-spike.md,
2026-08-30-c985-ergodis-adaptive-search-learning-adr.md,
2026-08-30-c985-ergodis-private-adapters-and-parallel-roots.md,
2026-08-31-c985-c1016-zero-cost-witness-handoff.md,
2026-09-01-c985-evolve-proposal-admission-architecture.md, and
2026-09-01-c985-evolve-sota-synthesis-lineages.md. The C1079 brief and current ergodis handoff
are the controlling scope/routing records; source checks above are read-only corroboration, not a
new implementation audit.
