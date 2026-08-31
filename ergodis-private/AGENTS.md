Read all of `../AGENTS.md` in a dedicated command before doing anything.

This package is the mandatory home for Ergodis work that is domain-specific,
task-specific, experimental, private, or not yet demonstrably reusable. It may
depend on the public core under `papers/complete-repair-ports/ergodis`; the
public core must never depend on this package or expose its adapters, fixtures,
campaign names, or research process.

Do not export, publish, synchronize, package, or add this directory to a public
release manifest. This `AGENTS.md` is itself private and must not be exported or
copied into any public tree.

Before extracting or editing a reusable public-core component, stop and read
the public core's `AGENTS.md` and private `PERFORMANCE.md` completely. Promote
only the domain-neutral kernel, contract, tests, and documentation; keep the
research adapter and private fixtures here.

Private solve adapters follow the same zero-allocation, iterative-search,
Tiger-style hot-record, contention-free parallelism, and single-/parallel A/B
counter discipline as the public core. Read the core `PERFORMANCE.md` in full
before changing or benchmarking any private solve hot path.
