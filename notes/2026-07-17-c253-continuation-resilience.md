# C253 — compensation-aware continuation resilience

**Lane:** `rp-next`
**Date:** 2026-07-17
**Status:** COMPLETE — operational diagnostic retained; new-invariant claim killed.

## Disposition

There is a real operational distinction, but not a new planning invariant. A static portfolio can
have two disjoint commit lineages while a reachable dirty prefix has only one compensation
substrate left. Once material effects, installed compensations, persistent failures, and switching
budget are put into the state, however, the exact score is the least failure weight at which that
state leaves the ordinary strong or strong-cyclic winning region. Standard FOND/model-checking
machinery computes it, with an outer search over failure weights.

The strict numerical warning also depends on the cost convention. The witness has a residual score
drop from `2` to `1`, where failures already incurred before the prefix are sunk. Charging the whole
failure history from the initial state gives `2` at the dirty prefix, so there is no `2 -> 1` total-
cost separation. This convention boundary rules out presenting “continuation resilience” as an
unqualified scalar invariant.

## Frozen semantics

An expanded state is

```text
q = (x, K, F, b),
```

where `x` is the material state, `K` is the installed compensation stack or partial order, `F` is
the persistent failure history, and `b` is switching cost already spent. The accepting set `A`
contains committed success and an explicitly clean compensated abort. An incomplete or dirty stop
is not accepting.

For an additional persistent failure set `D` disjoint from `F`, let `Win_D` be the winning set in
the expanded transition system. With strong semantics it is the least fixed point

```text
W_0     = A,
W_{i+1} = W_i union {q : some enabled action a has Post_D(q,a) subset W_i},
Win_D   = union_i W_i.
```

For strong-cyclic semantics, use the standard closed-policy condition together with reachability of
`A` from every policy-reachable state under fairness. The score is not a new recursion:

```text
lambda_res(q) = min { w(D) : q not in Win_D }
lambda_tot(q) = w(F(q)) + lambda_res(q)
rho_struct(P) = min { lambda_res(q) : q is any prefix reachable in supplied graph P }
rho_policy(P) = max_policy min { lambda_res(q) : q is reachable under that policy }.
```

`rho_struct` diagnoses exposed prefixes in a supplied workflow graph. `rho_policy` is the usual
controller/adversary quantity. An avoidable bad branch can lower the former without lowering the
latter. For dynamic failures, augment the state with the accumulated failed set and remaining
budget; the same fixed point answers each budget query.

## Seven-state strict witness

The domains `A`, `B`, and `C` have unit weight. `A` and `B` are the two forward lineages; `C` is the
compensation substrate. The accepting terminals are `commit` and `abort`; `unsafe` retains a
residual effect. Switching spends one unit of a separate switching-cost counter, not failure weight.

| State | Material / installed state | Action | Healthy outcome | Failed-domain outcome |
| --- | --- | --- | --- | --- |
| `start` | clean, no compensation, `b=0` | `start_A` | `reserved` | — |
| `start` | clean, no compensation, `b=0` | `run_B` | `commit` | `B`: `abort` |
| `reserved` | irreversible reservation, `cancel_A` installed, `b=0` | `finish_A` | `commit` | `A`: `failed` |
| `reserved` | same | `switch_to_B` | `switched` | `C`: `unsafe` |
| `switched` | clean, `b=1` | `finish_B` | `commit` | `B`: `abort` |
| `failed` | reservation remains, `cancel_A` installed, history `{A}` | `compensate` | `abort` | `C`: `unsafe` |

The initial commit-only portfolio has lineages `{A}` and `{B}`, hence initial `rho_w=2`. This
baseline deliberately asks for commit, whereas continuation viability accepts a clean abort; using
different terminal predicates without saying so is another source of false comparisons.

At `reserved`, both `A` and `C` must fail to remove every acceptable continuation, so
`lambda_res=2`. After the forward failure reaches `failed`, the only acceptable continuation is the
installed compensation, and `C` alone blocks it, so `lambda_res=1`. Since `F(failed)={A}`,
`lambda_tot(failed)=2`. Ordinary saga correctness under a reliable compensation substrate accepts
the `failed -> abort` execution; explicitly allowing `C` to fail exposes the unsafe residual.

The witness is also a useful structural-versus-policy counterexample: from `start`, choosing `B`
always reaches either commit or a clean abort, so the acceptable-terminal initial policy threshold
is infinite in this bounded model even though `rho_struct=1` over the full supplied graph.

## Exact certificate and minimality boundary

[`2026-07-17-c253-continuation-resilience-certificate.py`](2026-07-17-c253-continuation-resilience-certificate.py)
exhausts all eight failure-domain sets, recomputes the strong winning fixed point, checks the
commit-only and acceptable-terminal scores, and enumerates all 877 partitions of the seven states.
Only the identity partition preserves the observable phase tuple

```text
(material state, compensation stack, failure history, switching cost, terminal kind).
```

Thus seven states are minimal among feature-preserving quotients of this phase automaton. This is
the appropriate bounded claim: it is not a global theorem that no differently encoded transition
system can use fewer control nodes. In this acyclic deterministic-by-`D` witness, strong and
strong-cyclic winning coincide.

Validation command and result:

```text
python3 notes/2026-07-17-c253-continuation-resilience-certificate.py
commit-only initial blocker cost: 2 (A+B)
acceptable-terminal residual threshold at reserved: 2
acceptable-terminal residual threshold after A failure: 1 (C)
acceptable-terminal initial policy threshold: infinity (clean abort via B)
strong and strong-cyclic coincide here: every fixed-D transition is deterministic
feature-preserving quotient check: 877 partitions, identity only
```

## Primary-source boundary

- Cimatti, Pistore, Roveri, and Traverso's
  [weak/strong/strong-cyclic planning paper](https://doi.org/10.1016/S0004-3702(02)00374-0)
  already defines the qualitative policy semantics and symbolic preimage/fixed-point algorithms.
  C253's expanded state changes the modeled domain, not the winning-set theory.
- Aineto et al.'s
  [Action-Failure Resilient Planning](https://doi.org/10.3233/FAIA230252) defines recursive
  `k`-resilient states, requires every state on a selected trajectory to be `k`-resilient, searches
  augmented states `(s,k,V)` with failed actions `V`, and gives a FOND compilation. Its failure
  outcome leaves the material state unchanged, so it does not directly model the irreversible
  witness; adding `(x,K,F,b)` is the standard state-augmentation repair.
- Jensen, Veloso, and Bryant's
  [fault-tolerant planning](https://pure.itu.dk/en/publications/fault-tolerant-planning-toward-probabilistic-uncertainty-models-i/)
  already places bounded fault policies between weak and strong/strong-cyclic planning and derives
  them with the strong algorithm. Weighted failure domains are an outer optimization variant.
- Fox, Gerevini, Long, and Serina's
  [plan-repair comparison](https://cdn.aaai.org/ICAPS/2006/ICAPS06-022.pdf) optimizes stability of a
  replacement plan after context divergence; it does not supply the adversarial guarantee, but it
  confirms that switching/replanning cost is an ordinary planning objective rather than a new
  semantic layer.
- Acu and Reisig's
  [Compensation in Workflow Nets](https://doi.org/10.1007/11767589_5) installs compensations only
  after their forward tasks, orders backward recovery, and represents failure and compensation
  inside the workflow net. Compensable-workflow-net work also explicitly model-checks task and
  compensation behavior. These models already provide the control-state substrate represented by
  `K` and the dirty/abort terminals.
- Current durable-workflow systems preserve execution history and route retries, catches, and
  redrives from a failed state; for example, AWS documents that
  [redrive preserves successful steps](https://docs.aws.amazon.com/step-functions/latest/dg/redrive-executions.html)
  and exposes explicit [retry/catch transitions](https://docs.aws.amazon.com/step-functions/latest/dg/concepts-error-handling.html).
- Stonebraker et al.'s 2026
  [AC/DC workflow paper](https://www.vldb.org/cidrdb/papers/2026/p9-stonebraker.pdf) combines durable
  execution, alternative steps, physical backout, and saga compensation. It argues that durability
  ensures compensations run, but leaves a formal isolation model for saga-style workflows as future
  work. It is therefore a systems baseline, not prior ownership of this scalar; the older planning
  semantics already kill the scalar's novelty.

The shared literature cache contained none of the four DOI-keyed planning/workflow papers checked
for this task. Load-bearing statements above were checked against the papers' indexed full text or
official proceedings copies; no cache hash is claimed.

## Gate decision

**Kill the new-theory claim.** Retain two engineering checks:

1. compute residual continuation exposure at every persisted workflow prefix, not only static
   initial plan diversity; and
2. make the success predicate and the treatment of already-incurred failure cost explicit.

Implementation should compile workflow state, compensation state, persistent failures, and
switching budget into the controller state and call an existing strong/strong-cyclic solver or
finite-state model checker. No continuation-resilience paper or bespoke algorithm is allocated.
