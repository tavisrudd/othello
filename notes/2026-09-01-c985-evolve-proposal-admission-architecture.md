# C985 Evolve proposal/admission architecture

**Lane:** `complete-ports`

**Status:** design accepted; common envelope and further adapters remain implementation work

**Date:** 2026-09-01

## Decision

Use the optional CSS automorphism-discovery adapter as the reference systems
pattern for Ergodis Evolve:

```text
untrusted proposer
    -> bounded typed proposal
    -> canonical normalization
    -> exact replay of the claimed obligations
    -> role-specific admission
    -> source-bound persistent artifact
    -> compiled allocation-free consumer
```

The proposer is replaceable and has no proof authority. It may be nauty,
AlphaEvolve, an LLM, a stochastic search, a SAT/MIP solver, a domain script, or
another Ergodis campaign. Ergodis owns the semantic checks. A proposal can be
valuable after rejection because its counterexample or measured cost feeds the
next generation, but it cannot prune, merge states, reduce anchors, or support
a certificate until the corresponding admission contract passes.

This generalizes two already-landed boundaries:

- `css_automorphism_adapter` accepts backend-neutral permutation proposals,
  binds them to the exact CSS source fingerprint, and independently admits
  only actions preserving both the physical row space and the observable row
  space while strictly reducing the orbit partition;
- `RankedEvolutionDriver` separates candidate evaluation and parent selection
  from admission, so an inadmissible candidate may remain useful evolutionary
  material without becoming a theorem.

The reusable abstraction is not “run Evolve and trust its answer.” It is a
typed translation-validation boundary around every candidate kind.

## Common protocol

Every proposal family should expose the following logical fields, regardless
of whether its transport is the typed plan language, a compact binary schema,
Python bindings, or a control socket:

1. **Identity.** Schema version, proposer identity/version, source fingerprint,
   canonical payload digest, and deterministic proposal ID.
2. **Resource envelope.** Maximum payload bytes, records, term nodes, degree,
   generators, verifier work, and output work. Bounds are checked before bulk
   allocation or execution.
3. **Intended role.** Diagnostic feature, ordering hint, witness candidate,
   exact reduction, contextual quotient, or structural theorem candidate. A
   weaker role must never be silently promoted.
4. **Typed payload.** A permutation, feature DAG, predicate, decomposition,
   bound, rewrite, witness, or proof composition—not an untyped bag of JSON
   fields.
5. **Claimed obligations.** The exact invariance, equivalence, implication,
   feasibility, dominance, or coverage statements the admission checker must
   replay.
6. **Canonical normalization.** Range checks, stable ordering, deduplication,
   and canonical encodings happen before semantic evaluation. Normalization
   must not erase information needed to verify the original claim.
7. **Admission result.** Accepted role, independently recomputed metrics,
   compact counterexample on failure, verifier version, and fingerprints of
   every dependency.
8. **Persistence.** Create-only/source-bound artifacts with strict trailing-
   byte and version checks. Human-readable syntax may be a view, but one typed
   IR must underlie file, Python, daemon, and CLI paths.

Admission is family-specific. There should not be one generic `verified=true`
bit. A verified witness, verified symmetry, verified necessary predicate, and
verified exact quotient grant different capabilities.

## Context available at each step

Context is deliberately asymmetric. Discovery benefits from broad summaries;
authority requires the complete exact source; the hot consumer should receive
almost none of the campaign context.

| Step | Context available | Context deliberately unavailable |
|---|---|---|
| Campaign controller | problem identity, budgets, prior proposal ledger, compact progress/root histograms, exceptional-state samples, accepted/rejected summaries, literature/user hints | mutable search-worker state, unbounded traces, implicit proof authority |
| Proposer | typed problem schema, permitted grammar, resource limits, selected training/holdout views, compact counterexamples, cost/pruning feedback, optional domain metadata explicitly granted by the adapter | verifier internals as an oracle unless the campaign explicitly studies them; private fields not declared in its schema; live hot memory |
| Candidate scorer | canonical candidate, bounded corpus or probe roots, exact work/cost counters, coverage bitmaps and target labels appropriate to the candidate role | authority to prune; hidden evaluation set when a genuine holdout is required |
| Normalizer | candidate payload, schema/version, source fingerprint, declared bounds and role | campaign history, scores, solver state; normalization is deterministic and context-free beyond its declared inputs |
| Semantic verifier | complete authoritative source/model, normalized proposal, claimed obligations, independent replay/oracle inputs, hard resource limits | proposer confidence, fitness, names, or narrative as evidence |
| Admission policy | normalized proposal, verifier report, capability/role lattice, measured cost and exact coverage, existing admitted artifacts for dominance/conflict checks | raw backend status or unverifiable prose; no role promotion beyond the verified obligations |
| Persistence layer | admitted payload/report, exact dependency fingerprints, schema and verifier versions, hashes, byte limits | live pointers, caches, unbounded logs, or disposable executable paths |
| Cold compiler | admitted typed artifact plus validated source model and pre-sized workspace hints | proposer process, socket protocol, evolutionary archive; it produces the fixed consumer representation once |
| Search worker | immutable compiled representation, worker-owned preallocated state, and at most a guarded validated-plan inbox | proposal syntax, serialization, verifier, archive, strings, allocation, I/O, global mutable counters, or proposer dispatch |
| Feedback reducer | worker-local counters after join, admission failures, smallest counterexamples, compile/verify/search costs, bounded exceptional-state samples | full event streams by default; verbose local traces require an explicit bounded diagnostic request |
| Human/agent view | compact delta brief, top candidates, reasons for rejection, smallest falsifiers, uncertainty and next suggested probes; drill-down by proposal/root ID | automatic transcript dumps or per-node telemetry that swamp attention/token budgets |

Standalone mode uses the same stages with a deterministic built-in proposer and
file-backed ledger. Interactive mode may add literature-derived shapes or steer
the proposer through the control plane, but it does not change admission. A
campaign can therefore run unattended without needing continual model calls,
while an agent can add intelligence at proposal boundaries rather than sitting
inside the search loop.

Training context and verification context must be separately fingerprinted.
For theorem discovery, the proposer may see a selected corpus, while admission
replays against the complete declared corpus and any direct-model holdout. For
symmetry and semantic-equivalence candidates, sampling is useful only for
ranking: exact admission always sees the full defining relations.

## Runtime and performance boundary

Proposal generation, normalization, serialization, counterexample reduction,
and verifier diagnostics are cold work. An admitted proposal is compiled once
into the existing fixed-capacity representation before search. The solve hot
loop remains allocation-free, nonrecursive, and free of I/O or proposer
dispatch.

If a proposal changes search work, admission requires exact verdict/witness
parity and an independent replay boundary. If it changes the hot loop, it also
requires the Ergodis one-/parallel-mode counter A/B and zero-allocation gates.
If it only changes ordering, stale or rejected advice may add work but may not
change correctness. Runtime steering swaps only already-validated, preallocated
plans at guarded safe points.

The proposer receives bounded feedback rather than raw traces: admission
status, exact work reduction, compile/memory cost, smallest counterexample,
coverage bitmap digest, and a compact exceptional-state sample. This keeps the
loop useful to an automated daemon or an interactive agent without producing
token- or I/O-scale transcripts.

## Highest-value proposer inventory

Ranked by expected near-term leverage for Ergodis, not by general novelty:

| Rank | Proposer | Candidate | Exact admission obligation | Expected value |
|---:|---|---|---|---|
| 1 | Equivalent-presentation proposer | row bases, check orders, variable orders, static tie orders | identical accepted solution/witness set under exact row-space or model equivalence | Immediate compile/search reductions on large CSS exhaustion; LP1768 already shows depth-growing gains |
| 2 | Automorphism/action proposer | coordinate, state, factor, or constraint generators | bijection plus preservation of every physical and observable relation | Directly reduces roots/anchors; already joins BB288/BB360 from two orbits to one |
| 3 | Aggregate-bound proposer | packing, residual hitting, moment, residue, parity, character-sum, or cut inequalities | one-sided implication checked against the exact model, with replayable bound witness where applicable | Theorem-driven node removal; residual hitting and parity bounds already dominate local micro-optimization |
| 4 | Decomposition/interface proposer | separators, component cuts, join trees, boundary alphabets, elimination orders | exact composition equivalence and witness lift | Extends Ergodis beyond flat search and can reduce both state count and memory through smaller interfaces |
| 5 | Contextual-quotient proposer | candidate signatures, congruences, state merges, abstract domains | indistinguishability for the admitted continuation class plus congruence under every composition operator | The core cross-domain thesis; potentially orders-of-magnitude state reduction |
| 6 | Feature/theorem proposer | typed term DAGs, predicates, implications, scoped decision lists | full-corpus replay, held-out/direct-model replay, zero false positives for sound roles, and explicit scope | Turns Evolve into theorem discovery rather than parameter tuning; current raw-DAG and archive machinery is ready |
| 7 | Incumbent/witness proposer | BP+OSD, ISD, local search, MIP/SAT solutions, learned policies | independent feasibility and observable replay only | Cheap upper bounds tighten exact search; never grants optimality or negative coverage |
| 8 | Certificate-structure proposer | repeated proof motifs, branch DAGs, structural lemmas, rewrite/composition plans | expansion to the original certificate plus independent replay | Converts large computational evidence into smaller structural results and cheaper verification |
| 9 | Counterexample/attack proposer | adversarial instances, separating contexts, mutation tests, exceptional states | exact reproduction against the claimed rule or verifier | High leverage for hardening theorem candidates and focusing conflict-driven synthesis |
| 10 | Backend/encoding proposer | SAT/MIP/CP encodings, specialized propagators, semiring/tensor contractions | bidirectional solution/witness translation and objective preservation | Broadens application reach while preserving Ergodis as semantic compiler/certifier |

## First implementation sequence

1. Define a small generic cold `ProposalEnvelope`/`AdmissionReport` substrate
   with typed payload traits, strict limits, source fingerprints, and canonical
   digests. Do not make it a universal serialized enum.
2. Adapt automorphism proposals without changing their current artifact bytes;
   this is the compatibility control.
3. Add equivalent-presentation proposals as the second family, because current
   LP1768 presentation autotuning supplies exact performance and replay tests.
4. Route feature-DAG proposals through the same lifecycle while preserving the
   existing `RankedEvolutionDriver`, Pareto/Dalmatian archive, failure cores,
   and separating front.
5. Expose the lifecycle through the typed plan/Python/control surfaces. JSON is
   allowed only as an optional external view, not as the internal theorem
   language.
6. Add proposer feedback records and deterministic replay tests before any
   autonomous daemon loop uses the interface.

The first two adapters are intentionally different: automorphisms prove model
invariance, while presentation candidates prove equivalent semantics but may
change traversal cost. If one common substrate expresses both without merging
their authority roles, it is general enough to admit the remaining proposer
families incrementally.

## Safeguards

- Never admit from score, corpus perfection, proposer confidence, or backend
  status alone.
- Never let a source fingerprint stand in for semantic replay.
- Never let an exact witness imply optimality or a necessary condition imply
  sufficiency.
- Preserve rejected candidates and their compact counterexamples so Evolve
  does not rediscover known failures.
- Measure compile cost, retained bytes, verification cost, exact work removed,
  and hot-loop cost separately; a proposal with fewer states can still lose.
- Keep private campaign semantics and C-task identities outside public Ergodis.

## Acceptance gate

The architecture is realized, rather than merely documented, when one common
cold lifecycle supports at least automorphism, equivalent-presentation, and
feature-DAG proposals; each family rejects a forged source, forged semantic
claim, malformed bounds, and role escalation; accepted artifacts replay after
restart; and their compiled consumers retain the existing hot-loop performance
contracts.
