# ergodis for optimization researchers

ergodis is an exact finite-domain optimizer for problems whose apparent
combinatorial size hides a much smaller algebraic state space. It was developed
for linear-code recovery and hierarchical composition, but its organizing idea
is familiar in optimization:

> Derive the correct interface state mathematically, eliminate equivalent
> decisions before search, solve the remaining finite problem exactly, and
> retain enough information to reconstruct an original-space witness.

The companion paper,
[Exact Compositional Transfer of Bounded Linear Recovery](../compositional_recovery.pdf),
proves which state is sufficient for exact composition, when scalar summaries
lose information, and when a rank-one test controls every target dimension.
ergodis turns those results into algorithms. It also includes exact schedulers
and application front ends for storage repair, dependent repair tasks,
sparse-code searches, and resource-constrained recovery.

This introduction assumes no coding-theory background. The first half explains
the mathematical results in optimization language. The second explains what
ergodis implements, where it can outperform general solvers, and where it is
the wrong tool.

## Start with a two-state example

Suppose a block can expose either interface state `a` at cost 1 or interface
state `b` at cost 2. If we retain only the scalar minimum, the block appears to
cost 1. A linking constraint in the next layer may require state `b`; the true
cost is then 2.

This is the basic obstruction studied in the paper. A scalar optimum is a
lossy projection of a conditional value function:

```text
interface state       a       b
minimum local cost    1       2
```

The next layer does not see an interchangeable collection of local optima. It
sees particular interface states constrained by an outer system. Exact
composition therefore requires the value indexed by the interface state, not
only the minimum over states.

Linear recovery supplies a nontrivial version of this example. A feasible
solution is a linear equation that reconstructs a requested quantity from
available helper coordinates. Its cost is the number of distinct helpers it
uses. When several coded blocks are composed, a recovery equation induces a
linear functional on each block. Those induced functionals are the interface
states.

## A dictionary for optimization readers

| Coding-theory term              | Optimization interpretation                                      |
| :------------------------------ | :--------------------------------------------------------------- |
| recovery equation               | feasible linear certificate reconstructing a requested quantity  |
| helper support                  | active-variable set; its cardinality is the objective            |
| represented inner code          | finite linear block with a chosen interface parametrization      |
| induced functional              | interface state passed between adjacent blocks                   |
| prescribed-coset support cost   | conditional value function at a fixed interface state            |
| outer functional dual           | feasible set of linking-state assignments                        |
| confinement                     | every feasible solution below a cost limit stays in one block    |
| nonconfinement cost             | least cost of a solution that crosses a block boundary           |
| concatenation tower             | hierarchical structured instance with repeated block interfaces  |
| coefficient witness             | original-space feasible solution reconstructed from stored lifts |
| relative generalized weight     | rank-indexed minimum active-set cost after labels are minimized  |

The chosen representation matters for composition because it assigns concrete
interface labels to coefficient fibres. Two representations can describe the
same unlabelled feasible supports while presenting different conditional value
functions to the next layer.

### The separation proved in the paper

The paper gives an explicit example over GF(4), the finite field with four
elements, in which two representations have all of the following in common:

- the underlying binary code;
- its dual code, the algebraic orthogonal complement that records parity
  relations, not an LP or Lagrangian dual;
- all scalar recovery data relevant to the one-dimensional target;
- the complete relative-weight hierarchy;
- the smallest support of a nonzero parity relation; and
- the unlabelled family of minimum helper supports.

The labelled conditional costs differ. The same outer linking constraint then
gives exact costs 1 and 2. Nothing except the alignment between costs and
interface labels has changed.

## The mathematical results in optimization language

### 1. Exact local value by recovered dimension

Fix a target set and a helper set inside one linear block. The paper restricts
the parity relations to helper coordinates, once directly and once after
forcing the target coordinates to zero. Coding theory calls these operations
puncturing and shortening. The resulting canonical nested pair has relative
generalized Hamming weights equal to the minimum numbers of helpers required to
recover target subspaces of dimensions `1, 2, ...`.

For an optimizer, this says that the rank-indexed local objective is not a new
ad hoc recovery statistic. It is a standard quotient-support value function
applied to the canonical target/helper pair.

This value is complete for one question:

> What is the minimum union of active helpers needed to recover a subspace of a
> given dimension inside one block?

It is not complete for composition or for reliability under random helper
failures.

### 2. Exact finite composition has two sectors

Let `beta_h` denote the interface functional induced in block `h`. Write
`c_target(beta_j)` for the least normalized recovery cost in the target block,
where normalized means that the recovery equation acts as the prescribed
identity on the requested target subspace. Write `c_helper(beta_h)` for the
least cost of realizing the prescribed functional in another block. Let `D(O)`
be the set of label assignments allowed by the outer linking constraints, and
let `delta` be the least nonzero internal dual support.

The first solution that leaves the target block has cost

```math
\Gamma = \min\!\left\{
  c_{\mathrm{target}}(0)+\delta,
  \min_{0\ne\beta\in D(O)}
  \left(c_{\mathrm{target}}(\beta_j)
  +\sum_{h\ne j}c_{\mathrm{helper}}(\beta_h)\right)
\right\}.
```

The first term is the **zero-interface sector**: start with an internal recovery
and add the cheapest nonzero null perturbation in another block. The second is
the **nonzero-interface sector**: the outer constraints select compatible
nonzero labels, and each block pays its conditional realization cost.

This is an exact finite characterization. It is not a relaxation, lower bound,
or sufficient condition. A cost limit `r` confines every relevant recovery to
its target block exactly when `r < Gamma`.

### 3. The conditional value functions close under composition

Suppose block type `B` is used inside block type `A`. For an output interface
state `c`, the composite conditional cost has the Bellman form

```math
\Lambda_{A\circ B}(c)
=\min_{X:\,\phi_A X=c}\sum_e \Lambda_B(X_e).
```

Here `X` ranges over compatible intermediate interface states and `e` indexes
the inner blocks. The target-normalized version also tracks which part of the
requested quantity is supplied by target coordinates.

The paper proves that this min-sum substitution is exact and associative through
every finite tower. Either parenthesization eliminates the same intermediate
states and sums the same leaf costs. In dynamic-programming language, the
label-conditioned local value functions form a closed state representation for
hierarchical composition.

Numerical values and witnesses are separate layers:

- storing one minimum per interface state is enough to propagate exact values;
- storing an argmin lift per attained state reconstructs one optimal
  coefficient-level witness; and
- retaining every lift is necessary only when the full feasible family is
  wanted.

ergodis follows this separation so that witness support does not enlarge every
hot numerical state.

### 4. Strong outer constraints collapse the labelled state to a scalar

The labelled state is needed for unrestricted finite composition. The outer
dual distance is the least number of blocks participating in a nonzero linking
relation. If it is large enough, every competitive nonzero-interface assignment
is too expensive. Only the zero-interface sector remains, and the exact answer
collapses to

```text
rank-indexed local recovery cost + internal dual distance.
```

This explains when the familiar scalar threshold is exact and why it can fail
without the outer-distance condition. The scalar is not intrinsically wrong;
it is the correct projection after a structural condition removes the states it
forgets.

### 5. Rank one controls complete bounded transfer

A recovery of a higher-dimensional target subspace restricts to a target line
without increasing its helper support. The paper proves the resulting exact
criterion:

> Every recoverable target dimension is confined through a fixed cost limit if
> and only if every rank-one target is confined through that limit.

The conclusion concerns the complete bounded recovery systems, including their
coefficients and exact helper supports, not only a scalar locality parameter.
This turns an all-ranks certification problem into a rank-one obstruction test.

At rank one, the paper goes further. It compares represented inner codes over
the same extension field after their target lines have been identified. Across
compatible outer contexts of every finite arity, the coarsest observable
numerical response consists of the zero-sector cost and the zero-truncated
line-probe values for every projective label tuple with a nonzero external
part. This is a response family, not one fixed finite table. Equivalent states
remain equivalent after further concatenation. At rank `t`, the paper proves
that outer tests whose linking-state (functional-dual) dimension is at most `t`
suffice; it does not claim a general minimal state at higher rank.

The line-probe profile records the best nonzero-interface cost along each
one-dimensional projective direction, truncated when the zero-interface sector
already wins. Thus it identifies precisely which numerical distinctions an
outer composition can expose and which distinctions can be merged safely.

### 6. Different questions require different projections

The full recovery equations can be projected in two directions:

```text
coefficient-labelled recovery equations
              |
              +--> conditional costs by interface label --> composition
              |
              +--> exact helper-support families --------> reliability and capacity sharing

both branches --> rank-indexed minimum support values
```

The paper proves two information-loss results that matter computationally:

- the complete rank-indexed minimum hierarchy need not determine bounded
  reliability, because it forgets overlaps between feasible helper supports;
- unlabelled supports and scalar thresholds need not determine finite
  composition, because they forget which cost belongs to which interface
  functional.

Thus there is no single scalar recovery score that answers every downstream
question. ergodis retains the branch needed by the requested computation.

## From the theorem to an exact compiler

A generic finite-domain model exposes raw decisions and asks propagation or
search to rediscover their equivalences. ergodis moves deductions supported by
the algebra into a compilation phase:

```text
linear instance and resource constraints
                  |
                  v
quotients, functional labels, symmetries, and conserved quantities
                  |
                  v
small exact state space and conditional value functions
                  |
                  v
specialized dynamic program, enumerator, flow kernel, or external model
                  |
                  v
exact optimum + expanded original-space witness + work counters
```

Depending on the problem, compilation can use:

- quotienting by linear kernels and proportional columns;
- merging choices that generate the same subspace;
- preserving only reachable interface labels;
- cyclic or orbit symmetry;
- bounded load types rather than individual assignments;
- incidence masks and packed finite-field syndromes; or
- min-sum elimination through a hierarchy.

These reductions change the mathematical state space before low-level tuning
matters. The Rust implementation then uses compact contiguous states,
preallocation, allocation-free hot loops, specialized finite-field arithmetic,
and optional parallelism where independent work exists.

## What ergodis solves today

The application front ends are worked examples of the compilation model, not
claims that ergodis is a complete product for each industry.

The `transfer`, `transfer-subspace`, `transfer-tower`, `compose`, and `schedule`
commands expose the core recovery workflows. Most application rows below are
tagged models accepted by `ergodis application`; the final finite-field
construction row describes library machinery exercised by tests and benchmark
drivers rather than a separate general-purpose CLI.

| Example                    | Exact operational question                                      | Main compiled structure                         |
| :------------------------- | :-------------------------------------------------------------- | :---------------------------------------------- |
| linear recovery            | Which helpers and coefficients recover the requested quantity?  | quotient fibres and minimum support             |
| concatenation tower        | What is the exact composed cost and witness at every level?     | labelled min-sum state                          |
| storage repair scheduling  | Which simultaneous repairs fit node, rack, or link capacities?  | recurring load types and capacity vectors       |
| dependent repair tasks     | What is the shortest capacity-feasible repair schedule?         | equivalent ready-task sets                      |
| sparse-code search         | What is the smallest failure-causing support pattern?           | cyclic symmetry and graph components            |
| vector repair              | Which physical nodes span the requested symbols?                | generated-subspace aggregation                  |
| support reliability        | Which minimal supports survive a failure pattern?               | compressed support families and overlap counts  |
| finite-field construction  | Which orbit selections meet syndrome and incidence conditions?  | packed syndromes, orbit states, and elimination |

The storage examples include single and simultaneous erasure repair,
rack-aware helper assignment, local-reconstruction-code batches, and
placement-aware MDS checkpoint recovery. The sparse-code example searches
repeated parity-check structures for small trapping or stopping patterns. These
front ends solve the stated discrete models; they do not simulate storage
systems, networks, GPU execution, or iterative decoder dynamics.

## Relationship to established solver classes

ergodis is complementary to general optimization software.

| Solver class                | Natural strength                              | Where ergodis fits                                      |
| :-------------------------- | :-------------------------------------------- | :------------------------------------------------------ |
| CP-SAT / constraint solvers | broad models and mature propagation           | direct kernels; harnesses test compiled models          |
| MILP                        | relaxations; mixed discrete/continuous        | use when the residual problem is finite and algebraic   |
| network flow / matching     | specialized polynomial network models         | select when compilation exposes a network model         |
| BDD/ZDD tools               | compressed support-family enumeration         | reduce by linear structure before or within the diagram |
| dynamic programming         | exact recurrence over a chosen state          | derive a sufficient state from the mathematics          |
| coding packages             | construction, parameters, decoding, fields    | optimize recovery, capacities, composition, witnesses   |

CP-SAT remains the appropriate default when arbitrary side constraints dominate
and no useful algebraic quotient is available. For structured instances, the
compiled state can instead define a smaller external model after equivalences
and impossible states have been removed. Comparison adapters in the benchmark
harness exercise this pattern; the ergodis CLI does not expose a universal
CP-SAT model-export command.
Comparisons include both direct CP-SAT and controls given the same safe
preprocessing where that distinction applies.

## What the performance evidence means

The benchmark suite compares exact outputs: the same optimum, support family,
feasibility verdict, or replayed witness. Timings include input or model
construction. The headline cases illustrate different sources of advantage:

| Scenario                                  | Scale                            | ergodis | Exact control           | Control time | Speedup  |
| :---------------------------------------- | :------------------------------- | ------: | :---------------------- | -----------: | -------: |
| enumerate minimal XOR repair sets         | 8 repeated choices; 256 supports |  102 us | Graphillion ZDD closure |       864 us |       8x |
| compose a six-level recovery tower        | fanout 4; 4,096 leaves           |  766 us | direct CP-SAT           |     263.76 s | 344,300x |
| batch repair in a published local code    | 4,095 symbols; 2,718 dimensions  |  231 ms | direct CP-SAT           |        100 s |     432x |
| assign helpers for a training checkpoint  | 10,000 shards; 64 failures       |  100 us | OR-Tools bipartite flow |   103,061 us |   1,029x |

The table is evidence for these fixed instances, not a universal solver
ranking. The tower and local-recovery cases primarily demonstrate mathematical
state reduction. The support-family case combines compression with a tight
compiled kernel. The checkpoint case benefits from both aggregation and a
specialized witness construction.

See [BENCHMARKS.md](BENCHMARKS.md) for complete scales, control formulations,
peak resident memory, replay commands, hardware flags, and crossover data.
Machine-readable results and hashes are in `evidence/benchmarks.json`.

## Try the main workflows

Build the release binary from this directory:

```text
cargo build --release
```

The bundled four-element-field example demonstrates why labels matter:

```text
target/release/ergodis transfer \
  --input examples/data/f4-scalar-separation.json
```

The output reports the common scalar data, both labelled cost tables, the
outer label that exposes their difference, the exact composed costs, and
coefficient-level witnesses.

Compile an explicit target subspace or a hierarchy:

```text
target/release/ergodis transfer-subspace \
  --input examples/data/transfer-subspace.json

target/release/ergodis transfer-tower \
  --input examples/data/transfer-tower.json
```

Solve a capacitated allocation problem:

```text
target/release/ergodis schedule \
  --input examples/data/schedule.json
```

Every command accepts `--input -` for JSON on standard input and writes JSON to
standard output. Invalid algebraic dimensions, unsupported fields, exhausted
budgets, and inconsistent input fail closed with a nonzero exit status.

## Exactness, evidence, and trust

The mathematical theorems do not depend on ergodis or its benchmarks. The
paper proves the transfer and composition statements with human proofs. The
software evaluates finite instances of those statements and reconstructs
checkable witnesses.

The test suite contains focused library and CLI tests, exhaustive small-field
checks, seeded property tests, four-element-field transfer witnesses, and
independent differential fixtures. Work counters are reported separately from
wall-clock time so that an implementation benchmark is not presented as an
algorithmic complexity claim.

The Python implementation in `python/` is an independent reference and
evidence layer. The Rust library and `ergodis` executable are the production
solver.

## Scope and limits

ergodis is a good candidate when:

- the variables live in finite linear or algebraic domains;
- many raw assignments induce the same quotient, span, syndrome, orbit, or load
  state;
- the instance repeats a small interface through blocks or levels;
- an exact optimum and reconstructible witness are required; or
- a generic solver spends most of its effort rediscovering algebraic
  equivalences.

It is less suitable when:

- arbitrary business constraints dominate the algebraic core;
- continuous variables or strong linear relaxations drive the problem;
- no compact sufficient state or symmetry is known;
- approximate solutions are adequate and exact certification has little value;
  or
- the desired model is repair bandwidth, subpacketization, network timing, or
  another quantity not represented by the chosen finite support-cost model.

The current software is a specialized exact solver and research library. It is
not a general replacement for OR-Tools, MiniZinc, Gurobi, CPLEX, SCIP,
Graphillion, SageMath, or Magma.

## Where to read next

- [README.md](README.md) is the command-oriented entry point.
- [BENCHMARKS.md](BENCHMARKS.md) gives the complete experimental evidence.
- [`../compositional_recovery.pdf`](../compositional_recovery.pdf) contains the
  definitions, theorem statements, proofs, information-loss examples, and
  literature positioning.
- `cargo doc --all-features --no-deps --open` opens the Rust library API.

For the mathematical route, read the paper's introduction first, then the
sections on exact confinement under concatenation and sharp limits of coarser
recovery invariants. The exact-recovery-optimization section connects the
theorems back to the implementation.
