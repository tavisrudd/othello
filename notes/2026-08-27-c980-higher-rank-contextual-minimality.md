# C980 higher-rank contextual minimality and finite-state bounds

**Lane:** `complete-ports`
**Status:** IN PROGRESS; MATHEMATICS ONLY
**Date:** 2026-08-27

## Objective

Determine whether exact recovery admits a canonical small compositional
semantics beyond rank one.  The primary target is a higher-rank analogue of
the paper's contextual-minimality theorem: characterize the coarsest numerical
state observable by every compatible outer code, prove that its equivalence is
a congruence for further composition, and give an effective finite
representation with useful state-size bounds.

The task also tests, at the level of mathematics rather than implementation,
which parts of the state algebra survive for vector bandwidth/subpacketization
costs and for simultaneous failures with packing or capacity constraints.
Manuscript and software changes are out of scope until a theorem survives the
proof, literature, and hostile-review gates.

## Starting point

For a fixed target space `T` of dimension `t`, the paper assigns an inner
presentation two labelled functions on the finite alphabet

```text
A_T = Hom_Fq(T, L*):
    lambda(B) = minimum ordinary support in fibre B,
    mu(B)     = minimum target-normalized support in fibre B.
```

The exact outer optimization minimizes one target cost and the sum of the
ordinary block costs over maps `B : T -> D`, where `D = O^perp` is the outer
functional dual.  The existing rank-bounded test proposition shows that
`dim_L D <= t` suffices.  At rank one, the zero-truncated projective line-probe
profile is already proved to be the coarsest observable numerical quotient and
a congruence.

## First reduction: outer codes as finite column types

Put `Q = |L|`.  Let `D <= L^N` have `L`-dimension `1 <= s <= t`; the zero
sector `s=0` is handled separately.  Choose an isomorphism `G : L^s -> D`.
Its coordinate maps are linear functionals

```text
a_e : L^s -> L,       e = 1,...,N.
```

The complete coordinate list spans `(L^s)*`.  More precisely, the outer code
has nonzero projection onto the target coordinate exactly when the helper
functionals alone span `(L^s)*`: otherwise a vector of `D` can be supported
only at the target coordinate.  Every `Fq`-linear map `B : T -> D` has a unique
factorization `B = G X` with
`X : T -> L^s`.  Its label in coordinate `e` is `a_e X`.

For an arbitrary target type `a_0 in (L^s)*` and a multiplicity vector `n` on
the nonzero helper types in `(L^s)*`, define

```text
F[s,a_0](n) = min over nonzero X : T -> L^s of
              mu(a_0 X) + sum_a n_a lambda(a X).
```

The admissible vectors are those for which the helper types of positive
multiplicity span `(L^s)*`.  Zero helper functionals can be discarded because
`lambda(0)=0` and they do not affect spanning.  The target type may be zero.

### Candidate higher-rank response theorem

For every compatible outer code whose functional dual has dimension `s`, the
exact nonzero-sector cost is `F[s,a_j](n)`, where `n` records the helper-column
types of a generator of `D`.  Conversely, every admissible triple
`(s,a_0,n)` is realized by such an outer code.  Consequently the exact
contextual response is

```text
min(z, F[s,a_0](n)),       z = mu(0) + d(I^perp),
```

and equality of these truncated response functions for all `1 <= s <= t` is
the coarsest numerical equivalence observable by compatible outer contexts,
provided the zero-sector value `z` also agrees.  The `s=0` context observes
`z` directly.

### Proof mechanism

The factorization `B=GX` is bijective because `G` is an isomorphism onto `D`.
Substituting the coordinate identities `B_e=a_eX` in the exact two-sector
formula gives the displayed minimum.  Grouping equal helper functionals gives
the multiplicities `n_a`.  Conversely, a spanning list of coordinate
functionals defines an injective map `G : L^s -> L^N`, hence an `s`-dimensional
functional dual.  Requiring the helper list itself to span is equivalent to
nonzero target projection of the outer code.  The rank-bounded test theorem
then makes the family complete.  If two profiles differ on an admissible
triple, its corresponding outer code separates them; if they agree, the exact
formula gives the same cost in every context.

This proof is algebraically complete as a candidate lemma.  It still needs a
typed reread against the paper's trace identification, target normalization,
and repeated-field-tower conventions before promotion.

## Arity-independent finite representation

Although `n` ranges over unbounded outer lengths, each response is the lower
envelope of finitely many affine functions.  For every nonzero
`X in Hom_Fq(T,L^s)`, store

```text
intercept:  mu(a_0 X),
slopes:     (lambda(a X))_{a in (L^s)* minus {0}}.
```

There are at most `Q^(t s)-1` such forms for fixed `(s,a_0)`, and
`Q^s` target types, including zero.  Thus all finite outer arities are represented by a
finite family of tropical lower envelopes, with raw coefficient count bounded
by

```text
sum_{s=1}^t Q^(2s) (Q^(t s)-1).
```

The bound is deliberately raw.  The mathematical target is the canonical
lower hull after removing forms invisible on the admissible nonnegative
integer cone, modulo the natural `GL_s(L)` change of basis.  Proving an
effective equality test and a sharper bound for that hull is the first open
gate.

For `t=s=1`, the formula reduces to the zero-truncated projective line-probe
profile already in the paper: changing the generator of the one-dimensional
outer dual is exactly the scalar minimization in that theorem.

## Congruence and typed contexts

Define two rank-`t` inner states to be contextually equivalent when every
compatible finite outer context gives the same truncated exact cost.  Closure
of the outer contexts under composition should make this equivalence a
congruence at every rank: composing the same outer layer with two equivalent
states produces states that remain indistinguishable after any further layer.

The proof is formal once the field and interface types are stated correctly:
any purported distinguishing continuation composes with the fixed first layer
to give a context that already distinguishes the original states.  The work is
therefore not the congruence argument itself but the exact typed category of
interfaces, fields, target normalizations, and allowed outer projections.

## Extensions requested by the research feedback

1. **Towers and code synthesis.** Use the canonical lower-envelope state as
   the objective propagated through a tower; derive mathematical pruning and
   dominance laws before considering search software.
2. **Bandwidth and subpacketization.** Replace scalar costs by finite Pareto
   antichains in `N^k`.  Test whether block composition is Minkowski addition
   followed by Pareto minimization, and identify which subpacketization data
   must enter the interface rather than the cost monoid.
3. **Simultaneous failures and packing.** Replace one support cost by a resource
   vector or set-valued capacity profile.  Determine when the profile remains
   closed under min-sum/Pareto convolution and when helper-overlap information
   forces state explosion.
4. **General code operations.** Formulate the contexts as a typed algebra of
   code operations and identify the syntactic congruence of exact recovery
   cost, separating the automatic existence theorem from useful finite-state
   bounds.

## Red-team gates

- Do not call the higher-rank state minimal until every admissible separating
  profile is realized by an actual compatible outer code.
- Distinguish numerical cost semantics from coefficient-witness semantics;
  witness propagation may require argmins not present in the quotient.
- Treat infinity, zero-cost labels, nonspanning column lists, degenerate outer
  projections, and changes of field explicitly.
- A finite raw labelled table is not itself a useful finite-state theorem.  The
  value lies in an arity-independent canonical lower-envelope representation
  and a nontrivial complexity bound.
- Audit weighted automata, tropical rational series, valued CSPs, tensor
  networks, and algebraic dynamic programming before making a Myhill--Nerode or
  priority claim.

## Work order

1. Formalize the column-type response theorem and all-rank congruence with
   exact types and hypotheses.
2. Prove lower-envelope equality and canonical-hull criteria on the admissible
   integer cones; quotient by `GL_s(L)`.
3. Derive lower and upper state-complexity bounds and construct families that
   force large contextual states.
4. Test the Pareto-semiring extension for bandwidth and simultaneous requests;
   record a sharp failure theorem if closure breaks.
5. Run the full literature and hostile-referee gates, then decide whether the
   result belongs in the current paper or a separate sequel.
