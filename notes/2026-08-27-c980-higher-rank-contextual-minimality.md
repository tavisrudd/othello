# C980 higher-rank contextual minimality and finite-state bounds

**Lane:** `complete-ports`
**Status:** IN PROGRESS; MATHEMATICS ONLY; BOUNDED HIGHER-RANK FINITE-STATE,
CONGRUENCE, AND ORDERED-MONOID THEOREMS PROVED AS CANDIDATES
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

Put `Q = |L|` and `V_s=L^s`.  Let `D <= L^N` have `L`-dimension
`1 <= s <= t`; the zero sector `s=0` is handled separately.  Choose an
isomorphism `G : V_s -> D`.  Its coordinate maps lie in the `L`-linear dual
`V_s^vee=Hom_L(V_s,L)`:

```text
a_e : V_s -> L,       e = 1,...,N.
```

The complete coordinate list spans `V_s^vee`.  More precisely, the outer code
has nonzero projection onto the target coordinate exactly when the helper
functionals alone span `V_s^vee`: otherwise a vector of `D` can be supported
only at the target coordinate.  Every `Fq`-linear map `B : T -> D` has a unique
factorization `B = G X` with
`X : T -> V_s`.  Under the trace identification `L isomorphic to L*`, its
label in coordinate `e` is the `Fq`-linear map corresponding to `a_e X`.

For an arbitrary target type `a_0 in V_s^vee` and a multiplicity vector `n` on
the nonzero helper types in `V_s^vee`, define

```text
F[s,a_0](n) = min over nonzero X : T -> V_s of
              mu(a_0 X) + sum_a n_a lambda(a X).
```

The admissible vectors are those for which the helper types of positive
multiplicity span `V_s^vee`.  Zero helper functionals can be discarded because
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
functionals defines an injective map `G : V_s -> L^N`, hence an `s`-dimensional
functional dual.  Requiring the helper list itself to span is equivalent to
nonzero target projection of the outer code.  The rank-bounded test theorem
then makes the family complete.  If two profiles differ on an admissible
triple, its corresponding outer code separates them; if they agree, the exact
formula gives the same cost in every context.

This proof is algebraically complete as a candidate lemma.  It still needs a
typed reread against the paper's trace identification, target normalization,
and repeated-field-tower conventions before promotion.

## Radius truncation: one universal finite test family

The operationally natural truncation is fixed by the recovery radius, not by
the inner zero-sector value.  Fix an integer `R >= 1`; recovery through radius
`r` corresponds to `R=r+1`.  Write `[c]_R=min(c,R)`, including
`[infinity]_R=R`, and put

```text
Z_R = [z]_R,
C_R[s,a_0](n) = [ min(z, F[s,a_0](n)) ]_R.
```

The table must store `C_R`, rather than `[F]_R` alone: a smaller zero-sector
cost can mask a difference between two nonzero-sector lower envelopes.  The
full outer code, whose functional dual is zero, observes `Z_R` directly.

Cap every helper-type multiplicity by

```text
nbar_a = min(n_a, R).
```

For a fixed map `X`, each slope `lambda(a X)` is either zero, a positive
integer, or infinity.  A zero slope is unaffected.  If the slope is positive
and `n_a >= R`, both the original and capped affine forms are already at least
`R`; an infinite slope has the same property as soon as the multiplicity is
positive.  Thus term by term, and hence after taking both minima,

```text
C_R[s,a_0](n) = C_R[s,a_0](nbar).
```

Capping preserves the positive support of `n`, hence the helper-spanning
condition.  This argument does not require `z` to be finite.

### Bounded higher-rank contextual-state theorem

Fix `Fq <= L`, an identified target space `T` of dimension `t`, and `R >= 1`.
Two represented inner recovery problems have the same truncated exact
nonconfinement cost in every compatible finite outer context if and only if
they have the same `Z_R` and the same values

```text
C_R[s,a_0](n)
```

for `1 <= s <= t`, every target type `a_0 in V_s^vee`, and every spanning
multiplicity vector

```text
n in {0,...,R}^(V_s^vee minus {0}).
```

Every distinguishing context may be chosen with functional-dual dimension at
most `t` and with at most

```text
1 + R (Q^t - 1)
```

blocks.  In particular, exact numerical behaviour through any fixed radius
has a finite, outer-arity-independent contextual state even when the
untruncated zero-sector cost is infinite.

To prove necessity, `D=0` exposes `Z_R`.  A differing table entry is realized
by the outer code whose functional dual is generated by the corresponding
spanning column list, so it exposes that entry.  For sufficiency, first use
the rank-bounded outer-test proposition to reduce every map to an outer
functional dual of dimension at most `t`; the column-type formula then applies,
and the cap replaces every multiplicity by one in the displayed finite grid.
This also proves the block bound.  The theorem is therefore a genuine
coarsest-observable-state statement, not only a sufficient encoding.

The number of raw nonzero-sector probes is at most

```text
P_t(R,Q) = sum_{s=1}^t Q^s (R+1)^(Q^s-1),
```

before removing nonspanning vectors and quotienting by changes of basis.  Each
entry, including `Z_R`, lies in `{0,...,R}`.  Hence there are at most

```text
(R+1)^(1+P_t(R,Q))
```

contextual classes for the fixed interface.  This is a coarse existence
bound, not a claim that the state is practically small.

The basis quotient immediately improves this count.  `GL_s(L)` has two
orbits on target types: zero and nonzero.  Normalize a nonzero target type to
one fixed covector and leave the zero type fixed.  Before even quotienting the
remaining multiplicity vectors by the appropriate stabilizer, the number of
probe orbits is therefore at most

```text
Pbar_t(R,Q) = 2 sum_{s=1}^t (R+1)^(Q^s-1).
```

Thus `(R+1)^(1+Pbar_t(R,Q))` is the sharper immediate class bound.  Removing
nonspanning vectors and taking stabilizer orbits only decreases it.

There is also an exact state-dependent cap.  Put `C=min(R,z)` and, for fixed
`(s,a_0,a)`, write `u_X=mu(a_0 X)` and `c_Xa=lambda(a X)`.  Forms with
`u_X >= C` are already masked.  For every remaining form with finite positive
slope, the relevant threshold is `ceil((C-u_X)/c_Xa)`; an infinite positive
slope has threshold one, and a zero slope needs no cap.  The maximum relevant
threshold, with one included to preserve positive support, gives a cap
`R_a <= C <= R`.  Replacing the uniform factor `(R+1)` by `(R_a+1)` for each
type yields the corresponding sharper probe bound.

At `t=1` this strictly strengthens the manuscript's current rank-one theorem:
the projective probes over all outer arities reduce, through radius `r`, to one
finite table with outer length at most `1+(r+1)(Q-1)`.  No manuscript change is
proposed until the typed proof and literature gates close.

## Arity-independent finite representation

Although `n` ranges over unbounded outer lengths, each response is the lower
envelope of finitely many affine functions.  For every nonzero
`X in Hom_Fq(T,V_s)`, store

```text
intercept:  mu(a_0 X),
slopes:     (lambda(a X))_{a in V_s^vee minus {0}}.
```

There are at most `Q^(t s)-1` such forms for fixed `(s,a_0)`, and
`Q^s` target types, including zero.  Thus all finite outer arities are represented by a
finite family of tropical lower envelopes, with raw coefficient count bounded
by

```text
sum_{s=1}^t Q^(2s) (Q^(t s)-1).
```

The bound is deliberately raw.  The finite capped truth table above is already
canonical as a response function, while the lower-envelope form can be much
smaller computationally.  Distinct affine descriptions can agree on every
integer probe, so an ordinary real convex lower hull is not by itself a
correct canonicalization.

There is, however, an intrinsic basis quotient.  The group `GL_s(L)` acts by

```text
(a_0,n) . g = (a_0 o g, n'),
n'_(a o g) = n_a.
```

Changing `G` to `G o g` and `X` to `g^(-1)X` shows that `C_R` is constant on
these orbits.  Conversely, an orbit is exactly the same column-type context
written in another basis of its functional dual.  Thus the function on the
orbit set of admissible capped triples is a basis-free canonical contextual
state.  Choosing one lexicographically least representative per orbit is an
implementation choice, not additional mathematics.  The raw probe bound may
therefore be replaced by the exact number of these orbits; Burnside's formula
computes that number, with the spanning indicator retained.

A unique smallest affine-form presentation does not follow.  On a finite
integer grid, distinct collections of tied forms can define the same lower
envelope and different minimal subcollections need not be unique.  The
canonical object proved here is the orbit-indexed response function; finding a
compact canonical circuit for that function is a separate representation
problem.

For `t=s=1`, the formula reduces to the zero-truncated projective line-probe
profile already in the paper: changing the generator of the one-dimensional
outer dual is exactly the scalar minimization in that theorem.

## Congruence and a finite typed algebra

Define two rank-`t` inner states to be `R`-equivalent when every compatible
finite outer context gives the same cost after truncation at `R`.  This is a
congruence at every rank.  Indeed, if a continuation `C` distinguished
`A o I_1` from `A o I_2`, associativity and the target-normalized composition
law would make the composite context `C o A` distinguish `I_1` from `I_2`.
The same argument works after truncation because equivalence quantifies over
the final exact response of every composite context, rather than trying to
push a truncated intermediate scalar through an unproved recurrence.

Consequently, compatible concatenation induces well-defined operations on the
contextual quotient.  For fixed `(Fq,L,T,R)` each quotient sort is finite by
the bounded-state theorem.  The collection is therefore a finite multi-sorted
algebra of bounded exact recovery responses.  This is the precise
Myhill--Nerode-style conclusion: contexts define observational equivalence,
the orbit-indexed table realizes its coarsest numerical quotient, and
composition respects that quotient.

The type restriction matters.  A composition must preserve the distinguished
target leaf and its induced target image, and its trace identifications must
be the ones supplied by trace transitivity.  The manuscript's existing
target-normalized composition theorem proves these requirements for its finite
field towers.  Arbitrary retargeting or a change of cost semantics is not part
of this congruence.

## Finite ordered-monoid and Pareto extensions

The finiteness argument is not specific to addition.  Let `M` be a finite
ordered commutative monoid whose operation is monotone and extensive:

```text
x <= x plus_M y.
```

Represent alternative feasible costs by their upward closures.  Union is
choice and setwise monoid multiplication is composition.  For a repeated
fibre value `A`, its powers satisfy

```text
up(A^(n+1)) subseteq up(A^n),
```

by extensivity.  This descending chain stabilizes within `|M|` strict steps,
and equality of consecutive powers propagates under multiplication by `A`.
Thus every column-type multiplicity can be capped at `|M|`.  The column-type
proof then gives a finite contextual quotient and a distinguishing-context
bound

```text
1 + |M| (Q^t - 1).
```

This is a general bounded-cost theorem.  It covers saturated additive costs,
finite bottleneck/max costs, and other finite monotone cost algebras whenever
the prescribed-coset fibres and block composition genuinely take values in
that monoid.  It does not cover a parameter that changes the interface or the
feasible composition law rather than merely accumulating as a cost.

For a fixed number of additive resource coordinates, the general bound can be
sharpened substantially.  Let

```text
M_R,k = {0,...,R}^k
```

with componentwise order and saturated addition.  Represent a set of feasible
cost vectors by its Pareto-minimal antichain.  Pareto union and saturated
Minkowski addition make these antichains a finite idempotent semiring.  Give
each prescribed-coset fibre its exact antichain of attainable resource costs;
the same blockwise lift argument then replaces scalar min--sum by semiring
addition and Pareto minimization.  Thus labelled Pareto fibres are closed
under concatenation and retain exact bounded tradeoffs.

For one repeated helper type with antichain `A`, let `U_n` be the upward
closure of the `n`-fold saturated Minkowski power `A^n`.  Nonnegativity gives

```text
U_(n+1) subseteq U_n:
```

every `(n+1)`-term sum is an `n`-term sum plus a nonnegative vector and is
therefore dominated by its prefix.  Finiteness alone would give the crude
stabilization bound `(R+1)^k`, but the additive structure gives a linear one.

Fix `x in M_R,k`, and call a coordinate saturated when `x_i=R`.  If some
`a in A` is supported entirely on saturated coordinates, then any realization
dominated by `x` can be extended by arbitrarily many copies of `a`; membership
of `x` in `U_n` is persistent.  Otherwise every summand consumes at least one
unit in an unsaturated coordinate.  Those coordinates have total capacity at
most `k(R-1)`, so no sum of more than `k(R-1)` terms is dominated by `x`.
Every point is therefore either already persistent or absent by step
`1+k(R-1)`.  Hence every column-type multiplicity can be capped at

```text
K_R,k = 1 + k(R-1),
```

and every Pareto-distinguishing context has at most

```text
1 + K_R,k (Q^t - 1)
```

blocks.  For `k=1` this is exactly the scalar cap `R`.

If `A` is empty, all positive powers are empty and the same conclusion is
immediate.  Equality of upward closures is equality of Pareto antichains, and
once consecutive powers agree, saturated Minkowski addition by `A` propagates
the equality.  These observations cover the remaining edge cases.

The cap is sharp for the abstract bounded resource semiring.  Take
`A={e_1,...,e_k}`, the standard unit vectors.  At multiplicity `k(R-1)`, the
unsaturated point `(R-1,...,R-1)` is attainable.  At the next multiplicity it
is not dominated by any attainable sum, so the Pareto response changes at
step `1+k(R-1)`.  For `k=1` this is the scalar example `A={1}`, proving that
the cap `R` cannot be reduced in general.  Whether every sharp semiring example
is realizable by prescribed-coset fibres of represented codes is a separate
coding-theoretic question.

The raw Pareto probe count is consequently at most

```text
P^par_t(R,Q,k)
  = sum_{s=1}^t Q^s (K_R,k+1)^(Q^s-1).
```

There are at most `2^((R+1)^k)` antichains in the truncated cost grid, so a
coarse class bound is that quantity to the power `1+P^par_t(R,Q,k)`.
Normalizing the target type to zero or one fixed nonzero covector replaces the
factor `Q^s` in `P^par_t` by `2`, exactly as in the scalar case.

This proves a finite higher-rank contextual algebra for any fixed finite list
of additive resources—for example helper count together with finitely many
fixed traffic or energy categories.  It also applies to a max- or
divisibility-based subpacketization statistic if that statistic has a finite
interface-independent monoid law.  It does not by itself cover two major
cases:

1. subpacketization is often an interface or feasibility parameter, rather
   than an independent cost with a closed monoid law; and
2. per-helper capacities for simultaneous failures introduce one resource
   coordinate per physical helper, so `k` grows with the instance and the
   finite-state bound is no longer uniform.

Those failures locate the extra state that a stronger theory must retain:
subpacketization needs an enriched interface law, while packing needs helper
identity and overlap rather than only a fixed-dimensional cost vector.

## Extensions requested by the research feedback

1. **Towers and code synthesis.** Propagate the finite orbit-indexed state or a
   verified compressed circuit through a tower; derive mathematical pruning
   and dominance laws before considering search software.
2. **Bandwidth and subpacketization.** The theorem above settles fixed
   additive resource vectors.  The next target is an enriched interface law
   for subpacketization, including maxima and divisibility constraints.
3. **Simultaneous failures and packing.** Fixed resource categories are
   covered by the Pareto theorem.  Per-helper capacity requires a labelled
   overlap state whose dimension grows with the physical helper set; determine
   whether symmetry or bounded incidence width restores a finite quotient.
4. **General code operations.** Formulate the contexts as a typed algebra of
   code operations and identify the syntactic congruence of exact recovery
   cost, separating the automatic existence theorem from useful finite-state
   bounds.

## Red-team gates

- Every admissible scalar probe is realized by the functional dual generated
  by its spanning column list.  The full outer code realizes the zero-sector
  probe.  The rank-bounded theorem and multiplicity cap prove completeness, so
  the orbit-indexed response table is the coarsest observable bounded
  numerical quotient.
- This is numerical cost semantics only.  Coefficient witnesses and the full
  argmin family are not determined by the quotient; per-helper overlap and
  packing data are also absent.
- Infinity is absorbed by radius truncation; zero-cost labels are unchanged;
  zero helper column types are removable; capping preserves positive support
  and hence spanning; the target type may be zero; and helper spanning is
  exactly the nondegenerate-target-projection condition.
- The arity-independent bound is independent of inner length and zero-sector
  finiteness.  The `GL_s(L)` orbit table is canonical, while a smallest affine
  circuit need not be unique.
- The general finite-monoid theorem requires monotonicity and extensivity.  A
  parameter that changes the interface or whose resource dimension grows with
  the physical instance is outside it.
- Audit weighted automata, tropical rational series, valued CSPs, tensor
  networks, and algebraic dynamic programming before making a Myhill--Nerode or
  priority claim.

## Work order

1. **Done as a candidate theorem:** typed column response, bounded
   contextual-state characterization, and all-rank congruence.
2. **Done:** uniform and adaptive scalar caps, basis-free `GL_s(L)` quotient,
   outer-length bound, and explicit raw state bounds.
3. **Partly done:** the scalar and Pareto multiplicity caps are sharp in the
   abstract cost algebra.  Code-realizable and full state-complexity lower
   bounds remain open.
4. **Done at fixed cost dimension:** finite ordered-monoid closure and a sharp
   `1+k(R-1)` cap for bounded additive Pareto costs.  Growing per-helper
   resource dimensions and interface-valued subpacketization remain open.
5. Run the full literature and hostile-referee gates, then decide whether the
   result belongs in the current paper or a separate sequel.

## EJ + TT closeout and mystery ledger

The continuing EJ, TT, and red-team passes settled five points that were not
visible in the initial plan.  First, compatibility means that the helper
coordinate functionals span the outer-dual coordinate space; nonzero target
type is neither necessary nor sufficient.  Second, truncation at `R=r+1`, not
at the inner zero-sector cost, gives a universal finite theorem and also
handles an infinite zero-sector cost.  Third, the final response
`min(R,z,F)`, rather than `F` alone, is the minimal observable table.  Fourth,
the basis action reduces target types to zero and one nonzero representative.
Fifth, the Pareto cap is the sharp linear value `1+k(R-1)`, and the mechanism
extends to every finite extensive ordered cost monoid.

Open mysteries:

1. **Typed tower congruence — settled.**  The manuscript's
   target-normalized composition equation carries the same target leaf under
   either parenthesization, and trace transitivity supplies the field-tower
   identification.  A distinguishing continuation would already distinguish
   the original state via its composite context.
2. **Intrinsic canonical form — partly settled.**  The `GL_s(L)` orbit-indexed
   response function is basis-free and canonical.  A compact unique
   integer-envelope circuit remains open and may not exist without choosing a
   circuit model.
3. **Tightness — partly settled.**  The caps `R` and `1+k(R-1)` are sharp for
   the abstract scalar and Pareto cost algebras.  Code-realizable sharpness,
   the outer-length bound, and contextual-class lower bounds remain open.
4. **Witness semantics.**  Numerical contextual equivalence need not transport
   coefficient argmins.  The smallest compositional witness-bearing state may
   be strictly larger.
5. **Pareto closure — settled within a fixed resource interface.**  Finite
   antichains close under saturated Minkowski addition and Pareto choice.
   Per-helper packing has growing dimension and still requires labelled
   overlap state; subpacketization is covered only when it is an
   interface-independent finite monoid cost.
6. **Priority.**  The connection with syntactic congruences, tropical series,
   valued CSPs, and weighted tree automata requires a full literature audit
   before any novelty statement.
