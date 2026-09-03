# C1061 brief: Ergodis as a compiled dynamic decision engine (snapshot compile + delta update)

**Lane**: `complete-ports`
**Status**: allocated 2026-09-03; open-ended exploration, not a gated single spike; not started. Source: user + ChatGPT brainstorm, condensed
here as the task-facing design brief. Nothing below is a claim; everything is a hypothesis to test.
The deliverable shape is a running exploration log plus dated findings, with directions promoted
or dropped as evidence arrives; the candidate probes at the end are a menu, not a gate.

## Thesis

Ergodis compiles a static optimization problem into a dynamic algorithm specialized for a
*declared class of state changes*. The product surface is not "incremental reoptimization"
(Gurobi basis reuse, SCIP tree reuse, Z3 assertion scopes reuse *search state*); it is maintaining
the *mathematical sufficient state of the answer* and letting updates act on that state.

Three latency stages, to be measured separately:

| Stage | Input | Frequency | Target |
|---|---|---|---|
| Structural compile | topology / code / protocol / circuit (the schema) | rare | minutes to hours |
| Snapshot bind | failures / loads / capacities / parameters | per global state | microseconds to milliseconds |
| Delta update | one local event | per event | nanoseconds to microseconds |

Three execution regimes for stage 3: incremental recomposition over a retained composition
tree (recompute the leaf-to-root path only), parametric evaluation of compiled piecewise value
functions, and a fully compiled policy where `(q, Δ) -> (q', a*)` is a table or finite transducer
(software, SIMD, eBPF, FPGA ROM).

## Algebraic core

Two associative structures and an action connecting them:

- Optimization summaries `(Q, ⋆)`: min-plus / Pareto composition of boundary-indexed value
  functions; the existing associative min-sum machinery already has this shape.
- Updates `(M, ⊗)`: the event vocabulary as a monoid, so any stretch of the event log collapses to
  one equivalent update (segment trees, parallel prefix, crash replay in O(log n) chunks).
- A representation `ρ : M -> End(Q)` with `ρ(Δ1 ⊗ Δ2) = ρ(Δ2) ∘ ρ(Δ1)`.

The condition that makes this work is an **optimization congruence**: a quotient `x ~ y` on raw
states such that (1) the observable (optimal value + witness class) factors through it, (2)
composition descends to it, and (3) every allowed update descends to it
(`x ~ y ⇒ m·x ~ m·y` for all `m ∈ M`). This is Myhill–Nerode generalized from "indistinguishable by
future acceptance" to "indistinguishable by every future continuation w.r.t. optimal behavior".
If the quotient is finite, exact optimization becomes a finite weighted transducer.

Special cases with extra leverage: commutative `M` (shard and reorder), group `M` (algebraic
rollback, what-if), join-semilattice `M` (idempotent, CRDT-friendly, monotone pruning of
infeasibility), and a declared `REBASE_REQUIRED` exit for events outside the compiled envelope.

The same structural decomposition should admit reinterpretation in different target semirings
(min-plus for cheapest repair, Boolean for feasibility, counting, probability, Pareto), i.e. one
compiled topology, several functors.

Evolve's objective under this framing: find the smallest sufficient statistic `φ(x)` closed under
the update monoid, not merely a predicate for one static instance.

## Domain ranking (hypothesis, from the brainstorm)

| Domain | Compositional quotient | Delta algebra | Bounded interface | Overall |
|---|---|---|---|---|
| Coded checkpoint recovery (AI clusters) | 5 | 5 | 5 | 5 |
| Storage reliability / repair | 5 | 5 | 5 | 5 |
| Security FSM / policy | 5 | 5 | 5 | 5 |
| Finite-field FPGA/ASIC superopt | 5 | n/a | 5 | 5 (compile only) |
| ZK circuit optimization | 5 | 2 | 5 | 5 (compile only) |
| Network resilience / routing | 5 | 4 | 4 | 4.5 |
| Sparse expressive markets | 4 | 5 | 4 | 4 |
| GPU placement | 4 | 4 | 3 | 3.5 |
| Generic AI scheduling | 3 | 3 | 2 | 2.5 to 3 |
| Dense combinatorial auctions | 2 | 4 | 1 | 2 |
| Generic MILP | 1 | 2 | 1 | bad target |

The controlling parameter is interface width / coupling, not system size. Start where the repair
DAG and capacitated simultaneous-repair machinery already exist: coded recovery over a fixed
rack/pod hierarchy with a bounded fault universe compiled by orbit type under the rack/code
symmetry group, then failure and capacity events.

## Operational shell: event sourcing and CQRS

Event sourcing supplies the authoritative delta stream; CQRS supplies the architectural slot for
specialized derived state; Ergodis supplies a derived state that is normally uncomputable
incrementally: the exact optimum, witness, and certificate. The framing sentence for systems
engineers: *Ergodis treats the optimal decision as a materialized view and compiles the problem's
structure so that an event updates the optimum instead of rerunning the optimizer.* This is
incremental view maintenance for exact optimization; the update rules are derived from algebraic
structure (quotients, min-sum composition, spans, symmetry, sufficient statistics) instead of from
relational algebra.

Correspondences:

| Event / CQRS concept  | Ergodis concept                                |
|-----------------------|------------------------------------------------|
| Event log             | authoritative delta sequence                   |
| Aggregate state       | raw domain snapshot                            |
| Projection            | quotient optimizer state `Q_t`                 |
| Materialized view     | current optimum and witness                    |
| Projection update     | `apply_delta()`                                |
| Projection snapshot   | serialized `Q_t`                               |
| Replay                | exact optimizer reconstruction                 |
| Projection version    | compiler / compiled-artifact version           |
| Command               | requested optimized action                     |
| Event                 | observed consequence                           |
| Rebuild projection    | cold snapshot solve or recomposition           |

Consequences worth exploring:

- **The event enum is the compilation contract.** A declared vocabulary such as `NodeFailed`,
  `NodeRecovered`, `LinkCapacityChanged`, `DemandAdded`, `DemandRemoved` tells the compiler the
  complete mutation algebra, so it can derive per-event-type affected components. Semantic events
  carry more optimization information than `set_variable(i, x)`.
- **Parametric vs structural events.** Most events stay inside the compiled envelope; events such
  as `RackAdded` or `CodingSchemeChanged` trigger partial or full recompile. The compiler could
  classify, or prove, which category an event type belongs to.
- **Crash recovery is replay.** Persist compiler version, artifact hash, event offset, `Q`,
  optimum, witness, certificate; on restart load, verify, replay from the offset. Full-history
  replay reproduces the identical state, matching the existing replay and certificate philosophy.
- **Event-sourced certificates.** `C_t --Δ_t--> C_{t+1}` as an auditable chain of small proof
  transitions (previous root, affected quotient nodes, new root, certificate delta): historical
  decision provenance on top of ordinary state provenance.
- **Commands are not events.** The projection recommends an action; the domain accepts or rejects
  it; only the resulting event feeds Ergodis. Optimizer state derives from facts, never from what
  the optimizer hoped would happen.
- **Concurrency by sequence number.** A decision stamped `based_on_event` can be rejected as stale
  by the command side, or the delta engine is fast enough to have already advanced past it.
- The three technologies are independent; event sourcing plus CQRS is the natural shell, not a
  requirement.

## Candidate probes (menu, not a gate)

Explore in whatever order the evidence favors; record each in a dated findings note and keep a
running exploration log. Suggested starting points:

1. One concrete domain (coded recovery over a small fixed hierarchy) expressed as
   `OpenProblem<Boundary, Summary>` with `compose`, `tensor`, `quotient`, `reconstruct`, and the
   associativity property tested.
2. A declared delta contract (stable schema vs. mutable parameters) and an event monoid with
   `apply_delta`, plus a `REBASE_REQUIRED` path.
3. A sequence benchmark `S_0, Δ_1, ..., Δ_N` against fresh solve and the best available generic
   reoptimization mode, reporting: compile cycles, p50 / p99.99 / worst delta cycles,
   instructions and allocations per update (target zero allocations), bytes of maintained state,
   fraction of state invalidated per update, rebase count, exact agreement at every event, and
   break-even update count `N = T_compile / (T_generic_reopt − T_Δ)`.
4. Incremental certificate sketch: `(C_t, d_t) -> C_{t+1}` touching only the changed leaf and
   affected ancestors; stated, not necessarily implemented.
5. A written verdict on whether an optimization congruence with finite quotient exists for the
   chosen domain, with the exact reason if it does not.

6. Event-sourcing shell: a typed event enum as the compilation contract, per-event-type affected
   component derivation, parametric vs structural classification, replay-based recovery.
7. Whether the same compiled decomposition supports several target semirings (min-plus, Boolean,
   counting, probability, Pareto) without recompilation.
8. Evolve objective: smallest sufficient statistic closed under the update monoid.

Not in scope for now: public-surface claims. HFT, crypto block building, and FPGA emission are
later directions, open for exploration if a finding points there.
