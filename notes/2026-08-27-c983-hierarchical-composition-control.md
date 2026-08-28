# C983 hierarchical labelled-recovery composition control

**Lane**: `complete-ports`  
**Date**: 2026-08-27  
**Disposition**: bounded hierarchy control accepted; C983 remains open  
**Scope**: private Rust/Python research artifact; no manuscript, export, push,
deposit, novelty, or performance claim

## Verdict

The generic observational compiler now sits over actual Ergodis
`CostTable`/`CompositionTable` min-sum composition, including distinct ordinary
and target-normalized tables and recursively replayed local labels.  This
closes the gap left by the earlier request-projection recovery control: the
recovery adapter now exercises genuine hierarchical algebra rather than only
linear demand projections.

The fixture is still bounded and synthetic at its leaves.  It proves the API
and witness chain, not competitiveness or realization of every leaf profile by
a concrete code.

## Fixture and exact result

A scalar binary recovery profile stores

```text
(ordinary(0), ordinary(1), target(0), target(1)).
```

The nine depth-zero profiles are `(0,a,b,0)` with `a,b in {1,2,3}`.  Three
typed one-hole hierarchy constructors use outer scalar block pairs

```text
(1,0), (0,1), (1,1),
```

always placing the target-normalized child in block 0.  Depth is represented by
three sorts.  Every transition is computed by the production
`CompositionTable::compose` and `compose_with_target` paths; no quotient or
manual response transition is fed back into the Rust carrier.

| quantity | value |
|---|---:|
| raw profiles by depth | `9 / 12 / 12` |
| contextual classes by depth | `3 / 6 / 4` |
| total raw / quotient states | `33 / 13` |
| strict refinement rounds | 1 |
| separators / stored generator steps | `114 / 54` |
| dense quotient bytes | 464 |
| certificate bytes | 2,952 |
| provenance nodes/payload/children | `21,024 / 10,512 / 2,160` bytes |
| replay records/paths | 4,500 bytes |

All depth-zero target observations are initially zero, yet the three quotient
classes distinguish the ordinary nonzero costs `a=1,2,3` because later outer
contexts expose them.  The zero-sector leaf cost `b` is irrelevant to this
particular bounded observation grammar and is correctly quotiented away.

## Witness and oracle chain

For every one of the 117 depth-zero queries of length at most two, the adapter:

1. follows the concrete typed generator path and quotient path in lockstep;
2. queries the production ordinary or target `CompositionTable` for its exact
   minimizing local labels;
3. exports a binary provenance tree whose leaves are the original ordinary or
   target table entries;
4. replays every outer label equation over `GF(2)`;
5. recomputes every internal cost as the sum of its child costs; and
6. binds the root to the concrete terminal profile and compiled observation.

The Python oracle independently implements the scalar min-plus convolution,
enumerates the three bounded carriers, performs typed observation refinement,
and checks registered response cases.  Existing composition parity tests retain
their independent local-label controls.

The sidecar is intentionally expansive because every exhaustive query exports
its own tree.  DAG hash-consing and trace factoring are future optimization
work; this result makes no size win.

## EJ / TT / red-team / VB closeout

**EJ.** The `(1,0)` and `(0,1)` constructors are useful semantic probes, not
only test conveniences: they expose whether ordinary and target sectors have
been accidentally conflated.  The fixture also shows that a leaf parameter can
be provably irrelevant for a bounded hierarchy even when it is present in the
raw labelled table.

**TT.** The real invariant is a two-sector labelled response under a typed
context grammar.  Ordinary scalar costs become latent state even when the
current target query is constant.  This is the precise recovery analogue of a
hidden automaton state becoming visible only after continuation.

**Red team.** The transitions and witnesses use the production composition
kernel, while Python uses a separately written convolution.  Depth sorts block
unlicensed unbounded iteration.  Remaining limitations are synthetic leaf
profiles, tiny dimensions, duplicated provenance trees, and no specialized or
decision-diagram performance control.

**VB.** GREEN for exact hierarchical API/witness closure.  AMBER for SOTA or
application claims: the examples remain tens to hundreds of states, while
modern automata/DD systems operate at far larger scales and provide mature
search integrations.

## Mystery Ledger

### Settled

- Actual ordinary/target min-sum composition factors through the unchanged
  observational artifact on a bounded typed hierarchy.
- Ordinary costs can be future-observable despite a constant current target
  observation.
- The common concrete sidecar can replay a full hierarchical witness tree, not
  merely a terminal support or assignment.

### Open

- Generate the leaf profile family from concrete represented codes rather than
  registering scalar cost tables directly.
- Replace the quadratic pairwise certificate and duplicated witness trees with
  independently checkable class-pair/split-DAG and hash-consed provenance.
- Benchmark compilation, verification, artifact size, query throughput, and
  reuse break-even against optimized coalgebraic partition refinement,
  weighted-automata tooling, exact decision diagrams/CODD, and specialized
  recovery composition.
- Obtain a cold implementation review and define the versioned payload-schema
  registry if the artifact becomes external.

### Deferred

- effectful, Pareto, game, tensor, and learned backends remain outside this
  deterministic hierarchy control.

### Dead route

- treating request projection as if it already exercised hierarchical
  composition; and
- treating the current tiny exact fixtures as performance evidence.
