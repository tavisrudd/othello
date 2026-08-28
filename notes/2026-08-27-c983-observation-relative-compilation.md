# C983 — Observation-relative exact interface compilation

**Lane**: `complete-ports`

**Date**: 2026-08-27
**Status**: CANDIDATE THEOREM AND BACKEND DESIGN; HUMAN PROOFS COMPLETE FOR THE
FINITE-ALGEBRA CORE; WEIGHTED-TREE SPECIALIZATION POSITIONED AS A CLASSICAL
COROLLARY/CAPABILITY; WITNESS-LIFT GATE OPEN

## 1. Finite ranked observational algebras

Let `Sigma` be a finite ranked signature and let `A` be a finite
`Sigma`-algebra.  Thus every symbol `f` of arity `k` has an operation

```text
f_A : A^k -> A.
```

Fix a finite observation set `V` and `o : A -> V`.  Restrict `A` to the
subalgebra `R` reachable from the nullary symbols; every element of `R` then
has a representing ground term.  A one-hole context is a `Sigma`-term with one
distinguished occurrence of a hole.  Substitution gives `c[a] in R`.

Define observational contextual equivalence by

```text
a ==_o b  iff  o(c[a]) = o(c[b]) for every one-hole context c.
```

### Theorem 1: coarsest exact quotient

`==_o` is the largest `Sigma`-congruence contained in the kernel of `o`.
Consequently `R / ==_o` is the unique smallest quotient algebra through which
the observation of every ground term factors.

#### Proof

Reflexivity, symmetry, and transitivity are pointwise.  The empty context shows
that `a ==_o b` implies `o(a)=o(b)`.

For congruence, suppose `a_i ==_o b_i` for `i=1,...,k`.  In any outer context
`c`, replace the arguments of
`c[f_A(a_1,...,a_k)]` one at a time.  At step `i`, fixing all other arguments
turns the expression into a one-hole context for `a_i` and `b_i`; its
observation is unchanged.  Chaining the `k` equalities proves

```text
f_A(a_1,...,a_k) ==_o f_A(b_1,...,b_k).
```

Now let `theta` be any congruence contained in `ker(o)`.  If `a theta b`, an
induction on contexts gives `c[a] theta c[b]`, hence equal observations.  Thus
`theta` is contained in `==_o`.  This proves maximality.  Quotients correspond
to congruences, so every exact observational quotient maps onto `R / ==_o`,
which proves the minimal factorization statement.  No novelty is claimed for
this standard syntactic-algebra argument.

### Theorem 2: effective refinement and separator bound

Start with the partition `P_0` of `R` into observation fibres.  Given `P_n`,
refine two states apart whenever some operation `f`, argument position `i`, and
tuple of fixed reachable states in the other positions sends them to different
`P_n` blocks.  The stable partition is exactly `==_o`.

If `N=|R|`, stabilization takes at most `N-|P_0|` strict refinements.  Every
inequivalent pair has a distinguishing one-hole context of height at most that
number.  Recording the operation, position, fixed arguments, and prior
distinguishing context at each split constructs an explicit separator
certificate.

#### Proof

Induct on `n`: two states are in the same `P_n` block exactly when contexts of
height at most `n` give equal observations.  The base case is the empty
context.  A context of positive height has a lowest operation surrounding the
hole; fixing its other reachable arguments gives precisely one refinement
test, and the remaining outer context has one smaller height.  This proves the
induction in both directions.  A stable partition is therefore stable under
all finite context heights and equals `==_o`.  Every strict refinement
increases the number of blocks, yielding the round and height bounds.

This gives a generic exact backend:

1. enumerate the reachable subalgebra;
2. refine observation blocks to the coarsest congruence;
3. emit quotient transition tables;
4. retain one split trace as a distinguishing context for every separated
   pair; and
5. replay quotient evaluation against the original algebra on bounded tests.

The worst-case refinement signature is large—each `k`-ary operation examines
all fixed tuples in `R^(k-1)`—so domain compilers should supply symmetry,
sparsity, generators, or separator bases rather than materializing it blindly.

### Proof-carrying quotient artifact

The compiled table can carry a small independently checkable proof transcript.
For the finite generator presentation, a verifier checks:

1. sort ranges and state/class maps form a partition;
2. observations are constant on each proposed class;
3. every generator maps each class to a single target class and the emitted
   quotient table matches that action;
4. the recorded refinement transcript starts from observation fibres, and
   every later split is justified by a generator whose target states were
   separated at an earlier certified stage; and
5. the final partition is stable.

Items 1--3 prove sound exact evaluation.  Items 4--5 prove that the partition
is the coarsest compatible observation quotient rather than an arbitrary finer
congruence.  The split transcript reconstructs a distinguishing typed context
on demand by following its justification chain; storing a separate full
context for every state pair is unnecessary.

This certificate verifies the generic minimizer against its finite input.  It
does not prove that a domain compiler's finite presentation correctly models
the original problem; that lift needs an exhaustive small oracle, a theorem,
or its own adapter certificate.  Keeping those two trust boundaries separate
turns “formal methods” into a concrete application feature: an exact optimizer
can ship a replayable compilation/minimality certificate even when its domain
front end is not formally verified.

### Theorem 2A: exact compiler soundness by factorization

The quotient theorem is one case of a more general typed compiler law.  Let
`A_i` be domain carriers and `B_i` compiled carriers by sort, with encodings
`e_i : A_i -> B_i`.  For every typed constructor or generator `g:i->j`, require

```text
e_j(g_A(x)) = g_B(e_i(x)),
```

and require every requested observation to factor as

```text
Obs_A(x) = Obs_B(e_i(x)).
```

Then every well-typed generated context evaluates identically before and
after compilation.  The proof is induction on the context construction.  If
the compiled artifact also provides representative-domain lifts or witness
callbacks commuting with constructors, the induction reconstructs a valid
domain witness as well.

This theorem is elementary and carries no novelty claim, but it broadens the
backend contract correctly:

- a surjective `e` is an exact quotient; the contextual quotient is coarsest
  among observation-exact congruence quotients;
- an injective/factored `e` may be a circuit or alternative representation
  with no semantic state merge;
- a potential compiler uses a compiled shape plus a scalar cocycle whose
  combined observation diagram commutes;
- a representative-family reducer does not encode individual states; instead
  it proves the analogous commuting law for aggregate optimum under each
  family operation; and
- an approximate compiler replaces equality by a quantified error diagram and
  must compose its error moduli.

Thus Ergodis can host several classical reduction passes without pretending
they are the same construction.  Each pass must state the object it reduces,
the operations under which its preservation law is closed, its observation or
query profile, and its witness/error side condition.  A pass pipeline is exact
only when these laws compose in the chosen order.

## 2. Exact bounded tropical weighted-tree compilation

Let a weighted bottom-up tree automaton have finite state set `Q`, finite ranked
alphabet `Sigma`, nonnegative integer or infinite transition weights, and
nonnegative final weights.  Fix a radius `r` and the finite tropical truncation

```text
T_r = {0,1,...,r,infinity},
a (+)_r b = min(a,b),
a (x)_r b = a+b if a+b <= r, and infinity otherwise.
```

This is a finite commutative semiring, and truncation from the nonnegative
tropical semiring is a semiring homomorphism.

For each ground tree `t`, define its valuation vector

```text
v_t(q) = truncated minimum weight of a run on t ending in q.
```

For a symbol `f` of arity `k`, the usual bottom-up recurrence is

```text
v_(f(t_1,...,t_k))(q)
  = min over transitions f(q_1,...,q_k)->q of
      transition_weight + sum_i v_(t_i)(q_i),
```

with every operation performed in `T_r`.  Hence the vector transition is a
deterministic ranked operation on `T_r^Q`.

### Corollary 3: finite exact bounded evaluator

The reachable valuation vectors form a finite ranked algebra of size at most

```text
(r+2)^|Q|.
```

The truncated final value is an observation of that algebra.  Theorems 1--2
therefore give its unique minimal deterministic observational quotient and an
explicit distinguishing tree context for every pair of distinct quotient
states.

This is an observation-relative application of established weighted-tree
Nerode/crisp-determinization theory.  It is valuable to Ergodis as a backend,
not offered as a new automata theorem.  The Boolean case recovers ordinary
powerset-style tree determinization; a unary ranked alphabet gives bounded
tropical string behavior; tree-shaped min-sum/GDL computations with finite
messages fit the same evaluator.

The finite truncation is also priority judo against the unbounded branching
obstruction: weighted tree automata can generate every element of an infinite
finitely generated semiring, but a compositional finite observation quotient
restores a finite exact evaluator for the bounded question actually asked.

## 3. Restricted contexts beyond algebra homomorphisms

The genuinely broader C983 target replaces all tree contexts by a typed regular
or otherwise finitely presented grammar `C` of admissible futures.  Define

```text
a ==_(C,o) b  iff  o(c[a])=o(c[b]) for every c in C.
```

This relation need not be a congruence for every `Sigma` operation: plugging a
component may leave `C`.  It is a congruence for exactly the operations under
which the typed context grammar is closed.  A compiler must therefore expose
closure as data and validate it, not infer it from observed examples.

A finite separator certificate `B subset C` satisfying

```text
agreement on B  implies  agreement on all of C
```

gives an exact response signature in `V^B`, at most `|V|^|B|` quotient states,
and a distinguishing context coordinate for every unequal pair.  C980's
bounded outer-code probes instantiate this pattern through a nontrivial small-
model theorem.  Weighted automata over fields instantiate a linear variant in
which a basis of Hankel columns replaces a literal finite test list.

### Theorem 4: finite multi-sorted context machines

Let `I` be a finite set of interface sorts, let each reachable carrier `X_i`
be finite, and let `G` be a finite family of typed total context generators
`g : X_i -> X_j`.  Give each sort an observation `o_i : X_i -> O_i`.  For
states `x,y in X_i`, define

```text
x ~= y  iff  o_j(p(x)) = o_j(p(y))
             for every well-typed path p : i -> j generated by G.
```

Then `~=` is the largest sort-respecting equivalence contained in the
observation fibres and preserved by every generator.  The quotient is the
coarsest exact deterministic context machine, hence has no more states in any
sort than any other quotient of the same reachable carrier that preserves all
generated-path observations.

It is effective: initialize each sort by the fibres of `o_i`, then repeatedly
split a source block whenever some generator maps two members into different
target blocks.  With `N = sum_i |X_i|` and `b_0` initial blocks, refinement
stabilizes after at most `N-b_0` strict splits.  Recording the generator that
caused each split recursively constructs a distinguishing typed path of height
at most the number of refinement rounds.

The proof is the same induction as Theorem 2, now indexed by sorts and typed
paths.  Stability gives generator compatibility.  Induction on path length
gives agreement under all generated contexts.  Conversely, every split trace
extends a previously distinguishing path by its recorded generator.  Any
other exact quotient must identify only pairs agreeing under all paths, so its
kernel is contained in `~=`.

This theorem deliberately makes several classical constructions corollaries
of one compiler contract:

- deterministic Moore/Myhill--Nerode minimization is the one-sort unary case;
- finite ranked-algebra minimization is obtained by taking every basic
  operation, hole position, and tuple of fixed reachable coarguments as a
  context generator;
- bounded weighted-tree evaluation first constructs the finite valuation
  carrier and then applies the ranked-algebra case;
- a finite semantics for typed open systems supplies sorts as boundaries and
  generators by serial/parallel plugging with fixed reachable components.
- finite-state boundaried-graph or hypergraph DP supplies sorts as boundary
  types and generators as the parse-tree constructors; the Boolean case is
  the established graph/hypergraph Myhill--Nerode theorem.

The theorem itself is a classical finite-machine fact, not the novelty claim.
Its value is to isolate what every Ergodis adapter must provide: finite exact
reachable carriers, typed generator closure, observations, and a lift back to
domain components.  Structured/decorated cospans or operads can supply the
composition syntax; they do not supply the finite observational compiler.

Partial generator actions fit the same theorem only after definedness is made
observable.  Totalize each partial `g:i->j` with a typed undefined sink whose
output records failure; then a context defined for one state and not another
distinguishes them.  Silently dropping undefined paths can merge states whose
admissible future languages differ and is not an exact implementation.

The intended Ergodis abstraction is consequently not “all contexts.”  It is a
typed `SeparatorSystem` whose completeness proof can be finite exhaustive,
linear-algebraic, orbit/symmetry based, logical, or domain-theoretic.

### Theorem 5: potential-bearing or projective response quotients

Absolute observation is not the only exact notion.  Let a component `x` have
an integer extended-cost response

```text
R_x(c) = Opt(c[x]) in Z union {infinity}
```

over its admissible contexts.  Define projective contextual equivalence by

```text
x ~=pot y  iff  there exists delta in Z such that
                R_x(c) = delta + R_y(c) for every c,
```

with `delta + infinity = infinity`.  This is an equivalence relation (the
all-infinite class merely has a non-unique offset).  Whenever every context
constructor is additively homogeneous, replacing `x` by `y` shifts every
result by the same `delta`; consequently a compiled state may consist of a
normalized response class plus a scalar potential.

For a **projectively complete** finite separator `B`—meaning agreement up to
one common shift on `B` implies agreement by that shift on every context—let
`m(f)` be the minimum finite entry of `f|_B`, with a distinguished convention
for the all-infinite response, and normalize every finite entry by
`f(b)-m(f)`.  Two responses are projectively equivalent exactly when they have
the same infinite support and the same normalized separator vector.
Composition computes an unnormalized result, extracts its new minimum, and
carries the extracted scalar as a potential.  Thus the absolute bound
`|V|^|B|` can be replaced by the number of reachable normalized shapes, while
exact absolute answers remain recoverable.

An equality-complete separator is not automatically projectively complete:
the shifted comparison function need not itself be the response of a reachable
component.  A domain compiler must prove the projective separator property or
work with the full finite context family; normalization observed on an
arbitrary test set is not an exact certificate.

Finite integer index for parameterized graph problems is a Boolean-threshold
corollary.  If

```text
(G,k) is YES  iff  Opt(G) <= k,
```

then the established graph equivalence

```text
(G1 glue F,k) is YES  iff  (G2 glue F,k+c) is YES
```

for every `F,k` is, by equality of all integer threshold cuts, equivalent to
`R_G1(F) = R_G2(F)-c` (including the common-infinite case).  Hence finite
integer index is finiteness of the projective contextual response quotient for
this threshold observation.  Its progressive representative is a choice of
gauge/canonical potential representative.

This theorem both generalizes the classical shift relation and narrows the
research burden.  Additive gauge is established territory in graph
kernelization and tropical computation.  In the unary deterministic weighted-
automaton case, shortest-distance weight pushing followed by ordinary
labelled-automaton minimization is already an effective normalization-and-
quotient algorithm under established semiring hypotheses.  It is another
classical corollary/control, not an Ergodis novelty claim.

The Ergodis capability is to expose
potential-bearing quotienting uniformly across adapters, combine it with
typed separators and provenance, and measure normalized-state reduction.
The earlier coordinate-selector obstruction remains exact for absolute table
observations; for threshold observations it weakens from raw equality to
equality up to the permitted potential action.

### Lemma 6: contextual pseudometric and nonexpansive generators

Assume each observation space has a bounded metric `rho`.  For same-sort
states define

```text
d_i(x,y) = sup { rho(Obs(c[x]), Obs(c[y])) : c is an admissible context from i }.
```

Then `d_i` is a pseudometric and `d_i(x,y)=0` is the exact contextual
equivalence.  If every target-sort context `c` may be prefixed by a typed
generator `g:i->j`, then

```text
d_j(g(x),g(y)) <= d_i(x,y).
```

Both statements follow immediately from the metric axioms and inclusion of
the prefixed context family.  Consequently any cluster of contextual diameter
at most `epsilon` changes every admitted future observation by at most
`epsilon`; this is a semantic error statement, not merely a latent-space
distance claim.

The computational burden is the supremum.  A finite exact separator computes
it only when it is also metric-complete; an ordinary equality separator does
not automatically preserve worst-case distances.  Otherwise the compiler
needs a sound upper relaxation, a Lipschitz/covering argument, or a coinductive
fixed-point metric.  Bisimulation metrics for MDPs are the classical control:
they compute behavioral distances from rewards and transported transition
metrics and prove optimal-value/aggregation bounds.  Approximate Ergodis work
must provide analogous domain-specific bounds before merging states.

### Lemma 7: query-profile monotonicity and incremental refinement

Write `E(C,O)` for equality under every context in `C` and every observation
coordinate in `O`.  Directly from the definition,

```text
E(C1 union C2, O) = E(C1,O) intersection E(C2,O)
E(C, O1 union O2) = E(C,O1) intersection E(C,O2).
```

Therefore adding admissible futures or requested query projections can only
split interface classes; removing them can only merge classes.  On a finite
presentation, partition refinement may start from an already compiled
quotient and add new observation fibres or generator/context tests.  Because
the stable result is the largest compatible equivalence contained in all
requested kernels, incremental refinement reaches the same partition as a
fresh compile for the union profile.

This supplies an application-level feature: compile a small interface for the
queries actually requested, then refine it monotonically when a caller adds
counting, a resource coordinate, or a larger future grammar.  Every refinement
retains the new distinguishing context/observation coordinate.  Coarsening
after query removal generally requires recomputation or retained refinement
history; merely hiding output columns does not justify merging states.

### Corollary 8: exact one-way boundary communication

Fix one interface sort.  In the deterministic one-way problem, Alice receives
a component state `x`, Bob receives an admissible future context `c`, and after
one message from Alice Bob must output `Obs(c[x])` exactly.  The minimum number
of distinct messages is precisely the number of contextual equivalence
classes.

For the upper bound, Alice sends the quotient class and Bob evaluates the
class under `c`.  For the lower bound, if two contextually inequivalent states
sent the same message, their distinguishing context would force Bob to return
two different observations from the same message/context pair.  Therefore
every inequivalent pair needs distinct messages.  A fixed-length encoding
needs at least

```text
ceil(log2(number of quotient classes))
```

bits, and the quotient class ID attains that structural bound up to integer
rounding.

This makes state minimization an operational interface result for distributed
systems, not only a DP optimization: it computes the smallest exact summary a
component must transmit across its boundary for the declared query profile.
For a potential-bearing quotient, the class count measures only structural
messages; the signed potential must also be encoded, so its range/bit cost must
be reported.  Approximate contextual metrics lead instead to covering/one-way
sketching questions and require an explicit error budget.

## 4. Witness obstruction and the required side-car law

Value contextual equivalence does **not** by itself preserve concrete argmin
identity.  Two components can have the same value in every future context and
different unique optimizers.  If literal witness identity is included in the
observation, the states become distinguishable; if it is excluded, the value
quotient contains no theorem selecting a common concrete optimizer.

Thus the following tempting statement is false without more hypotheses:

> A minimal value quotient automatically reconstructs an exact concrete
> witness using only quotient transitions.

Three honest implementation modes remain:

1. **Transient provenance.**  Evaluate the minimal value state while storing
   per-occurrence domain-specific backpointers.  The compiled state stays small,
   but witness memory is analyzed separately.
2. **Witness-liftable congruence.**  Require each quotient operation to provide
   a lift that composes child witness packages into a valid parent witness,
   invariant under the chosen representatives.  Prove this domain by domain.
3. **Provenance algebra.**  Evaluate first in a free/join-union expression DAG
   and then apply value, count, optimal-count, or selected-witness measures.
   This is strongest semantically but may make the compiled object much larger.

Provenance semirings, algebraic model counting, and semiring-DP solution
expressions already establish the broad compile-once/evaluate-many idea.  They
should be used as backends, not relabelled as an Ergodis theorem.  The possible
Ergodis addition is a second, observation-relative compilation pass that
minimizes the reachable interface for an explicit context grammar and query
family.  Circuit factorization and contextual state minimization are distinct:
neither size bound implies the other.

For the weighted-tree control, valuation-vector evaluation can retain, for
each tree occurrence and original state `q`, one minimizing transition and its
child states.  This reconstructs an exact optimal run.  Further quotienting the
valuation vectors preserves final values, but does not automatically compress
those occurrence backpointers.  The experiment must report value-state and
witness-memory reductions separately.

## 5. Backend and exemplar decision

The first generic Ergodis backend should be a finite ranked observational
algebra with:

```text
reachable closure
observation-fibre initialization
congruence refinement
quotient transition construction
distinguishing-context traces
optional transient provenance callbacks.
```

It should support two front ends.  The explicit front end receives reachable
carriers and typed generator actions.  The oracle front end learns the finite
observational machine through context/value queries and exact distinguishing-
context counterexamples.  The latter is an application of established active
automata learning; it is useful because a legacy optimizer can become an
Ergodis adapter before its internal recurrence has been reimplemented.
It still requires effective access constructors for the target component
universe and a finite typed generator presentation; arbitrary sampled
component/context pairs do not certify a closed machine.

The first adapter is bounded tropical weighted-tree evaluation.  The second is
a symmetric finite resource-allocation/scheduling algebra, so a successful
common backend cannot be dismissed as an automata-only refactoring.  Neither
adapter is a novelty claim.  The research claim, if one survives, must concern
effective restricted-context separators, witness-liftable quotients, or a new
domain small-model theorem.

### Exact contract for exemplar A: bounded tropical weighted trees

Inputs are a finite ranked alphabet, a tropical WTA with `Q` states, and a
radius `r`.  The domain compiler constructs the reachable valuation vectors
in `{0,...,r,infinity}^Q`, the ranked operations, the final observation, and a
minimizing-run callback.  The generic engine must reproduce the direct WTA
oracle, minimize the reachable algebra, and emit a distinguishing tree context
for every split.  The report records original run-state count, ambient vector
bound `(r+2)^|Q|`, reachable vectors, quotient classes, transition-table bytes,
separator height, and transient witness bytes.  Boolean/unweighted and unary
weighted machines are regression corollaries; the unary potential mode must
agree with weight-push-then-minimize where its hypotheses hold.

An exhaustive temporary fixture confirms that refinement does more than group
equal final values.  Take radius `r=4`, three WTA states, three nullary
valuation vectors

```text
(3,infinity,1), (1,3,0), (3,3,4),
```

final weights `(1,1,3)`, and one binary symbol with transitions listed as
`(left_state,right_state,weight)` by output state:

```text
out 0: (0,1,1) (1,0,1) (2,0,2) (2,2,1)
out 1: (0,1,0) (1,0,2)
out 2: (0,2,2) (1,1,0) (1,2,0) (2,1,2) (2,2,2)
```

Reachable closure has 13 vectors and four final-observation fibres.  One
refinement round yields six contextual classes, of sizes `6,3,1,1,1,1`.
For a replayable split example, `(1,3,0)` and `(1,4,2)` both have final value
two, but using `(1,3,0)` as the right coargument gives final values two and
four.  The fixture is small enough for an independent exhaustive regression
test and exercises reachability, a genuine context split, a nontrivial merge,
and a height-one separator.

### Exact contract for exemplar B: symmetric resource batches

Fix `m` identical machines, integral load cap `r`, a finite job-size alphabet,
and an additive Markov assignment/penalty rule whose increment depends only on
the current load profile, chosen machine, and incoming job.  Let `P` be sorted
load profiles in
`{0,...,r}^m`.  A finite job batch `B` compiles to the min-plus relation

```text
K_B(p,q) = minimum cost of assigning every job of B,
           starting at profile p and ending at profile q,
```

with `infinity` for infeasibility and a concrete assignment backpointer for
each attained entry.  Concatenating batches is exactly min-plus relation
composition.  Labelled machine loads provide the deliberately redundant raw
control; sorting supplies the known permutation-orbit reduction.

The semantic experiment then fixes independently a finite grammar of future
job batches and terminal observations (for example feasibility and convex
terminal load penalty).  It compiles relation states into the multi-sorted
context presentation, applies absolute or potential-bearing minimization, and
replays an assignment witness.  Full initial/final coordinate selectors are a
negative control and must return entrywise matrix equality.  A claimed gain
requires a restricted application query family to merge more states than
sorting alone, or a capability gain from reusable batch composition and
multi-query/witness evaluation.  Compare against exhaustive assignment on
small instances and a generic exact solver on the benchmark envelope.

This exemplar forces all important boundaries at once: symmetry is not
contextual minimization, relation representation is not quotienting, bounded
future jobs are part of the specification, and witness memory is not value-
state memory.  The boundaried-network adapter found in the later audit is the
first stretch application after these two controls.

### Exemplar B cheap test

A temporary exhaustive oracle enumerated sorted load profiles, every future
job word through a fixed horizon, and the minimum attainable terminal makespan
(`infinity` when infeasible).  It produced:

| machines | cap | job alphabet | horizon | sorted profiles | absolute response classes | potential-normalized classes |
|---:|---:|---|---:|---:|---:|---:|
| 2 | 3 | `{1,2}` | 1 | 10 | 9 | 6 |
| 2 | 3 | `{1,2}` | 2 | 10 | 10 | 9 |
| 3 | 4 | `{1,2}` | 2 | 35 | 22 | 14 |
| 3 | 5 | `{1,2,3}` | 2 | 56 | 42 | 31 |

Thus the restricted application observations can merge profiles beyond
machine-permutation sorting, and projective normalization can merge more.  The
two-machine horizon comparison also confirms the monotonicity gate: adding
future contexts splits classes and can erase most of the apparent gain.

This is not yet the adapter proof.  Assigning a job has several possible
successor profiles, so a concrete profile is not a deterministic generator
state.  The exact adapter must use min-plus batch relations or determinized
residual response functions, with remaining horizon/query grammar represented
as a sort.  Selecting one locally optimal successor would be unsound because
the best choice can depend on the continuation.  The cheap test validates the
presence of semantic compression, not closure, witnesses, or runtime benefit.

## 6. Red-team gates

1. Do not call a finite observation quotient a determinization of the full
   weighted semantics.
2. Do not conflate initial-algebra and run semantics outside semirings or the
   established coincidence hypotheses.
3. Do not infer context-grammar closure from finite testing.
4. Report reachable-algebra size, minimal value quotient size, transition-table
   or circuit size, and provenance size separately.
5. Compare the finite-algebra backend with established crisp-determinization,
   tree-automata minimization, and semiring-DP implementations before making a
   systems contribution claim.
6. Require an independent exhaustive oracle for both values and reconstructed
   witnesses on the first two adapters.
7. For compile-once/multi-query claims, compare against the unquotiented
   provenance or knowledge-compiled DAG and report whether quotienting reduces
   an external interface, merely evaluation memoization, or neither.
8. Do not infer projective completeness from an equality separator; certify
   that one common shift on the tests forces that shift on all contexts.
9. For oracle compilation, state the reachable target universe and require
   counterexample search over that universe, not only the sampled components.
10. In optimizing adapters, determinize the whole residual/cost relation; do
    not turn an input into a single successor by a continuation-blind argmin.
