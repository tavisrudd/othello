# Ergodis architecture and design boundaries

This document is the public map of Ergodis components, ownership, and trust
boundaries. It distinguishes the implemented experimental control plane from
accepted follow-on design; neither should be inferred from benchmark or research
notes.

## Core and optional campaign layer

The ordinary library and CLI compile exact finite interfaces, compose them, and
reconstruct witnesses. They do not link the optional campaign controller.

The `control-plane` feature adds long-running search instrumentation and steering.
It may propose diagnostics and branch orderings, but it cannot prune or admit a
branch without a separately authorized theorem schema.

## Public-core boundary

This directory contains only domain-neutral, reusable Ergodis components.
Domain-specific, task-specific, experimental, private, or otherwise
non-reusable adapters, binaries, fixtures, campaigns, and research tooling must
live in the repository-top-level `ergodis-private/` package. That package may
depend on Ergodis; the public core must never depend on it or expose its private
names and process.

A feature belongs in the public core only when it has a domain-neutral contract,
at least one reusable implementation boundary, and public tests and
documentation that do not rely on private fixtures. Promote a proven reusable
kernel inward; do not move an entire research adapter with it.

## Execution topology

```text
search workers
    | fixed-size snapshots and scorecards
    v
solver-side watcher / isolated shadow sampler
    | bounded batched control messages
    v
ergodis-campaign daemon
    | validated plans and epoch notifications
    v
solver safe points
```

The ownership rule is:

- search workers perform exact search and only fixed-size, allocation-free
  publication at existing coarse safe points;
- one low-priority solver-side sampler may replay bounded shadow expansions in
  an isolated presized workspace, never the live seen table or mutable theorem
  caches;
- the campaign daemon owns candidate evolution, exact frozen-batch evaluation,
  durable ledgers, policy selection, and plan activation;
- the watcher owns socket interaction and installs already validated plans;
- `ergodisctl` is a human/agent steering and inspection client, not the eventual
  owner of unattended evolution.

## Current implementation status

The experimental v0 control protocol, campaign daemon, file-backed ledger,
single and bulk candidate evaluation, bounded create-only evidence streaming,
plan activation, event-driven watcher, and external `ergodisctl evolve` loop
are implemented.

The generic `theorem_search` module implements deterministic candidate
seed/mutate/test/rank evolution with either a retained result or a caller-owned
streaming trial sink. It is runner-neutral. Current domain demonstrations call
it from replay binaries.

Daemon-owned low-priority evolution and live snapshot/scorecard ingestion are
accepted design but are not yet implemented. Until that integration lands,
`ergodisctl evolve` and offline replay drivers remain explicit staging tools.

## Hot-path invariant

Candidate generation, mutation, ranking, plan compilation, JSON, socket I/O,
evidence hashing, and persistence never run in search-worker hot loops. A
controlled worker retains only the existing coarse safe-point check and direct
dispatch to an immutable validated plan.

No-op control traffic and an inactive controller must have no measurable search
effect. Shadow work starts with one low-priority sampler and a token-bucket duty
cycle; additional samplers require evidence that they do not steal CPU or memory
bandwidth from the exact solve.

## Exactness and promotion

Candidate evolution is an attack generator and falsifier, not a proof authority.
Frozen-domain perfection or a successful shadow race may select diagnostics and
ordering experiments. Promotion to a pruning theorem requires an independently
validated, presentation-bound proof schema.

The intended discovery loop is:

```text
candidate grammar -> evolve -> exact finite falsification -> proof-schema match
                  -> independently validated theorem -> optional fast path
```

Performance priors may decay or be recalibrated. Exact counterexamples and
validated semantic facts do not.

## Documentation map

- [README.md](README.md): entry points and user-facing workflows.
- [OPTIMIZATION.md](OPTIMIZATION.md): mathematical compiler model and solver
  relationships.
- [CONTROL_PROTOCOL.md](CONTROL_PROTOCOL.md): bounded local wire protocol and
  large-evidence rules.
- [BENCHMARKS.md](BENCHMARKS.md): benchmark scopes and recorded measurements.
- Rust API documentation: exact type and function contracts.

When these documents disagree, API behavior and tests describe what is currently
implemented; this document owns component responsibilities and accepted topology.
