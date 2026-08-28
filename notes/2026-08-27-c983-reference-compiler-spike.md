# C983 deterministic reference-compiler spike

**Lane**: `complete-ports`  
**Date**: 2026-08-27  
**Disposition**: implementation stage accepted; C983 remains open  
**Scope**: private Rust/Python research artifact; no manuscript, mirror, export,
push, deposit, novelty, or performance claim

## Verdict

The first implementation gate passed.  One unchanged generic Rust compiler and
independent verifier handle two genuinely unrelated noncoding adapters:

1. a bounded tropical weighted-tree evaluator; and
2. a determinized finite resource-batch process.

Both exhibit compression beyond terminal-output deduplication, replay every
admitted context exactly, and retain or recompute valid domain witnesses.  This
establishes a real shared deterministic backend, not the full C983 architecture.
Recovery through the same artifact, a common witness-sidecar contract, measured
economics, and an independent cold hostile review remain open.  C985 therefore
stays queued after C983.

## Implemented boundary

`ergodis::observational` accepts:

- finite state sorts stored as contiguous ranges;
- a scalar interned observation per state;
- total unary generators with explicit source and target sorts; and
- flat global successor tables.

It emits:

- the coarsest stable observation partition relative to that presentation;
- contiguous class ranges, state-to-class IDs, class observations, and
  representatives;
- flat quotient generator tables;
- deterministic compile and storage metrics; and
- a flat pairwise separator certificate: every separated same-sort state pair
  has a shortest typed generator path ending at unequal observations.

The cold verifier does not trust the refinement routine.  It checks partition
coverage and sort discipline, representative membership, observation constancy,
generator compatibility for every concrete state, quotient-table replay, and
complete/valid separator coverage.  The certificate is pairwise minimality
evidence, not the refinement transcript proposed in the earlier design note.

This v1 backend is deliberately a finite multi-sorted Moore-machine backend.
Multi-input contexts must be compiled into unary one-hole generators with all
admissible coarguments; horizons/grammars belong in the sorts.  Output vectors
must currently be interned by an adapter into scalar observation IDs.  The
artifact is always verified against the exact presentation, so changing the
observations or admitted context set invalidates it.

## Exact fixture results

| adapter | raw carrier | output fibres | quotient | rounds | separators / path steps | quotient bytes | certificate bytes |
|---|---:|---:|---:|---:|---:|---:|---:|
| bounded tropical WTA | 13 | 4 | 6 | 1 | 60 / 4 | 1,148 | 1,456 |
| resource batches, sorts 0/1/2 | 35/51/44 | 5/5/5 | 22/14/5 | 2 | 2,321 / 369 | 1,224 | 57,180 |

The byte counts are exact `size_of_val` payload counts for the dense quotient
and certificate pools.  They exclude Rust allocation headers and adapter
witness storage.  This spike makes no runtime, memory-win, or break-even claim:
the exhaustive per-state-pair certificate is intentionally simple and is much
larger than the resource quotient.  A class-pair or split-DAG certificate is an
obvious later compaction, subject to the same hostile verifier.

### Weighted-tree adapter

For radius 4, three automaton states, and the registered nullary/final/binary
weights, exact closure gives 13 truncated valuation vectors.  Four terminal
cost fibres refine to six classes of sizes `6,3,1,1,1,1` in one strict round.
The states `(1,3,0)` and `(1,4,2)` both initially observe 2; right composition
with `(1,3,0)` separates them with outputs 2 and 4.  The adapter retains a
concrete tree for every reachable valuation, replays the valuation bottom-up,
and independently replays an optimal weighted run.

### Resource-batch adapter

For three identical machines, capacity 4, jobs `{1,2}`, and horizon 2, the
adapter does not choose a greedy successor.  It determinizes the assignment
relation into Boolean subsets of sorted load profiles.  The typed carriers have
sizes `35,51,44`; the quotient has `22,14,5` classes.  Direct response vectors
over all words `epsilon,1,2,11,12,21,22` independently give 22 classes at the
initial sort.  `(0,0,1)` and `(0,1,1)` require the depth-two context `[1,1]`,
which yields costs 1 and 2.  Exhaustive DP reconstructs and replays an assignment
for every initial profile and admitted word, checking capacity, final load, and
makespan; infeasible words return the registered infinity value.

The Boolean subset representation is exact only because these assignment edges
carry zero incremental cost.  Weighted resource edges require tropical cost
vectors, not this adapter.

## Validation and controls

Accepted commands from the Ergodis crate directory:

```text
nix develop -c cargo fmt --all --check
cargo clippy --all-targets --all-features -- -D warnings
cargo test --all-features
nix shell nixpkgs#python3 --command python3 python/generate_fixtures.py --check
nix shell nixpkgs#python3 --command python3 python/check_observational_fixtures.py
```

The Rust suite includes malformed/non-total generator rejection and independent
artifact-corruption tests for observations, transitions, missing certificates,
and false certificates.  The new Python oracle independently reconstructs both
finite carriers, performs synchronous refinement and shortest-separator search,
and checks selected assignment witnesses against the checked-in JSON.  The
existing Python fixture check and complete Rust parity suite retain the recovery
cost, witness, and helper-load controls.

## EJ / TT / red-team / VB closeout

**TT.** Stable synchronous observation refinement plus generator compatibility
proves exact factorization.  Complete checked separators for cross-class
same-sort pairs prove coarseness only relative to the supplied finite
presentation.  Carrier closure and concrete witness lift remain adapter
obligations.  Classical Moore/Myhill--Nerode minimization is the backend control,
not a novelty claim; the WTA result is a finite response-function corollary, not
a claim about unrestricted weighted-automata minimization.

**EJ.** Cold compilation/verifying may allocate and hash; the resulting
evaluation path uses integer IDs and contiguous tables, with no domain branch,
allocation, hash lookup, or dynamic dispatch.  Value-state, quotient-transition,
certificate, and adapter-witness storage remain separately accountable.

**Red team.** The resource relation is determinized; the rejected
continuation-blind argmin route never entered the API.  Corruption tests exercise
the verifier independently.  Quotient representatives do not by themselves
lift witnesses, so both adapters replay domain witnesses separately.  The
largest present weakness is certificate size, followed by the lack of a
presentation/profile fingerprint and recovery adapter.

**VB.** GREEN for implementation stages 1 and 2: unchanged generic API,
nontrivial reductions, exact separator replay, independent oracle, and witness
checks.  AMBER for C983 and C985 until recovery uses the same artifact, the
witness/provenance contract is shared, reuse economics beat specialized
controls, and a fresh independent hostile review lands.

## Gate disposition

| gate | status |
|---|---|
| deterministic finite compiler + independent verifier | PASS |
| WTA adapter, contextual split, exact tree/run replay | PASS |
| resource adapter, relation determinization, assignment replay | PASS |
| unchanged minimizer/verifier across both adapters | PASS |
| recovery control through the same artifact | OPEN |
| common witness/provenance sidecar | OPEN |
| schema/profile fingerprint and migration rule | OPEN |
| bounded compile/runtime/RSS and repeated-query break-even | OPEN |
| specialized WTA/resource/recovery controls | OPEN |
| independent cold hostile implementation review | OPEN |

## Mystery Ledger

### Settled

- A finite deterministic observation quotient is a real shared backend for two
  noncoding fixtures.
- The WTA split is contextual, not terminal-output deduplication.
- Resource nondeterminism requires determinized relations/residuals; greedy
  successor selection is unsound.
- Pairwise separators plus congruence establish an exact minimal quotient only
  relative to the finite typed presentation.
- Classical finite minimization is attribution/control, not the novelty.

### Open

- Route a representative recovery instance through this exact artifact/API.
- Define one witness/provenance sidecar contract spanning recovery, WTA runs,
  and resource assignments.
- Certify domain lift/closure rather than assuming adapter enumeration.
- Add a canonical presentation/query-profile fingerprint.
- Compact certificates without weakening independent verification.
- Measure compile time, RSS, artifact size, query rate, reuse break-even, and
  specialized controls on larger fixtures.
- Obtain an independent cold hostile implementation review.

### Deferred

- potentials/Pareto frontiers;
- relational/Kleisli and probabilistic effects;
- controlled games and interface strategies;
- tensors and exact contraction planning; and
- learned/SSM approximate realizations.

### Dead route

- continuation-blind greedy resource successors;
- presenting generic finite partition refinement as a new theorem; and
- opening C985 from two fixtures without the recovery/economics/review gates.
