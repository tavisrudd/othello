# C1061 brief: Ergodis as a compiled dynamic decision engine (snapshot compile + delta update)

**Lane**: `complete-ports`
**Status**: allocated 2026-09-03; spike not started. Source: user + ChatGPT brainstorm, condensed
here as the task-facing design brief. Nothing below is a claim; everything is a hypothesis to test.

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

## Spike deliverable (proposed acceptance gate)

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

Out of scope for the spike: HFT, crypto block building, FPGA emission, any public-surface claim.
