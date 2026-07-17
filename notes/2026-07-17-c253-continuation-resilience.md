# C253 — compensation-aware continuation resilience

**Lane:** `rp-next`
**Date:** 2026-07-17
**Status:** IN PROGRESS — checkpoint for a fresh session; no success/kill decision yet.

## Question and current lean

C253 asks whether a prefix-indexed failure-blocker score adds a genuinely new invariant beyond
contingent/fault-tolerant planning and compensating-workflow semantics. The current evidence leans
toward the **kill** outcome: once irreversible effects, installed compensations, persistent failed
domains, and switching state are included in the transition-system state, the proposed score looks
like a quantitative query over standard nondeterministic planning reachability. This is a working
hypothesis, not a completed literature or minimality result.

## Candidate exact semantics

Use an expanded workflow state `q = (x, K, F, b)`, where `x` is the material world state, `K` is the
installed compensation stack or partial order, `F` is the set of persistent failed domains, and `b`
records switching cost/budget. Acceptable terminals include both committed success and a specified
safe compensated-abort state; merely stopping is not success.

For a fixed workflow portfolio `P`, let `V(q)` be its viable continuations from `q`. In a deterministic
lineage specialization, define

```text
lambda(q)   = min { w(D) : D disables every C in V(q) }
rho_cont(P) = min { lambda(q) : q is a reachable prefix state of P }.
```

For general nondeterministic actions this must be stated through a winning-state test rather than
as a bare lineage intersection. Augmenting the state by `F` makes persistent failures Markovian;
for each budget `B`, compute whether an acceptable terminal is winning against every admitted
outcome whose accumulated failure-domain cost is below `B`. Then the local score is the least
failure cost for which the state is not winning. Strong versus strong-cyclic semantics determines
the usual least/greatest fixed-point convention. This is the main reason to suspect that the
algorithmic object is established FOND/robust-planning machinery with a weighted outer query.

Two conventions still need to be separated cleanly:

1. **structural exposure:** minimum over every reachable prefix in the supplied portfolio graph;
2. **controller-guaranteed exposure:** maximize over policies before taking the adversarial prefix
   and failure minima.

Conflating them can make an avoidable bad branch lower the score of an otherwise robust policy.

## Small witness under construction

The candidate strict witness begins with two static alternatives having disjoint failure lineages,
so initial `rho_w = 2`. Executing one alternative crosses an irreversible reservation boundary and
installs a compensation. A forward failure then leaves only the compensation path to safe abort;
failure of its substrate gives a one-domain blocker, so the reachable-prefix score is `1`. A switch
to the untouched alternative is available before that failure but has explicit switching state/cost.

This already demonstrates the operational warning—static portfolio diversity can disappear after
partial execution—and ordinary saga correctness can still hold under its assumed reliable
compensation substrate. It is **not yet a certified smallest witness**. The next session must freeze
the exact action/outcome table, check separation from both strong and strong-cyclic success, and
exhaust the smaller bounded transition systems before claiming minimality.

## Literature boundary opened this session

- Cimatti--Pistore--Roveri--Traverso, “Weak, strong, and strong cyclic planning via symbolic model
  checking,” DOI [`10.1016/S0004-3702(02)00374-0`](https://doi.org/10.1016/S0004-3702(02)00374-0):
  qualitative strong and fairness-based strong-cyclic policy semantics.
- Aineto et al., “Action-Failure Resilient Planning,” DOI
  [`10.3233/FAIA230252`](https://doi.org/10.3233/FAIA230252): defines `k`-resilient states, carries
  failed actions in augmented state, and compiles the problem to FOND planning. Its bounded model
  assumes a failed action leaves the world state unchanged, so irreversible effects and explicit
  compensations require the expanded C253 state rather than a verbal identification.
- Acu--Reisig, “Compensation in Workflow Nets,” DOI
  [`10.1007/11767589_5`](https://doi.org/10.1007/11767589_5): compositional compensation semantics
  for acyclic workflow nets and complete recovery under its stated assumptions.
- Rabbi--Wang--MacCaull, “Compensable WorkFlow Nets,” DOI
  [`10.1007/978-3-642-16901-4_10`](https://doi.org/10.1007/978-3-642-16901-4_10): explicitly
  distinguishes successful compensation from compensation failure with residual effects.
- Stonebraker--Zhou--Kraft--Li, “Consistency and Correctness in Data-Oriented Workflow Systems,”
  [CIDR 2026](https://www.vldb.org/cidrdb/2026/consistency-and-correctness-in-data-oriented-workflow-systems.html):
  AC/DC combines durable execution, physical backout, and saga compensation; the paper presents a
  mandatory systems baseline, while acknowledging remaining formal-model work for saga isolation.

The shared literature cache was checked for the four DOI-keyed papers above; none was cached. The
session used publisher/proceedings metadata and indexed paper text. A final novelty disposition
requires reading and recording the load-bearing full text, not relying on search snippets.

## Exact restart point

1. Freeze the structural-versus-policy score convention and the acceptable-abort predicate.
2. Write the smallest explicit transition table including irreversible effect, forward failure,
   switching cost, compensation, and compensation-substrate failure.
3. Build a bounded enumerator/certificate that verifies the claimed scores and rules out smaller
   witnesses in the declared class.
4. Complete the primary-source audit, especially the fixed-point equivalence to FOND/action-failure
   resilience and the treatment of compensation failure in workflow models.
5. Apply C253's gate: retain the operational diagnostic but kill a new-theory claim if the expanded
   state plus standard winning-set algorithm gives the same invariant.
