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

The intended Ergodis abstraction is consequently not “all contexts.”  It is a
typed `SeparatorSystem` whose completeness proof can be finite exhaustive,
linear-algebraic, orbit/symmetry based, logical, or domain-theoretic.

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

The first adapter is bounded tropical weighted-tree evaluation.  The second is
a symmetric finite resource-allocation/scheduling algebra, so a successful
common backend cannot be dismissed as an automata-only refactoring.  Neither
adapter is a novelty claim.  The research claim, if one survives, must concern
effective restricted-context separators, witness-liftable quotients, or a new
domain small-model theorem.

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

