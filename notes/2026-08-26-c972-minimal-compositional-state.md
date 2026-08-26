# C972: Minimal compositional state and rank-one complete transfer

**Lane**: `complete-ports`

**Status**: MATHEMATICS COMPLETE; RANK-ONE COMPLETE-TRANSFER EQUIVALENCE AND THE
COARSEST RANK-ONE OUTER-OBSERVABLE STATE PROVED; EXISTING BINARY/QUATERNARY
EXAMPLE UPGRADED TO A FIXED-CODE, FIXED-PAIR LABEL SEPARATION; VALIDATED
MANUSCRIPT PATCH PREPARED BUT INTENTIONALLY UNCOMMITTED; POST-GOAL EJ/TT ADDS
THE GENERAL RANK-`t` LOW-DIMENSIONAL OUTER-TEST THEOREM

## Goal

Determine exactly how much labelled prescribed-coset information arbitrary
finite concatenation can observe.  Strengthen the paper only after the
converse, rank-one consequences, and finite separation have independently
survived mathematical and computational checks.

## Work order

1. **Lock the observational notion.**  Define compatibility of represented
   inner and outer codes, the natural relabellings that preserve min--sum
   composition, and contextual equivalence under all compatible outer codes.
   Separate numerical cost state from stored minimizing lifts and witnesses.
2. **Prove or delimit the converse.**  Start at rank one.  Given a differing
   labelled cost, try to construct a probe outer functional dual that exposes
   that label while suppressing competing zero and nonzero sectors.  Record
   the exact field, realizability, nondegeneracy, and target-surjectivity
   hypotheses.  Extend to general target subspaces only if the probe argument
   survives.  A counterexample to the proposed universality statement is a
   first-class result, not permission to weaken definitions silently.
3. **Close the rank-one package.**  Prove the strongest correct equivalence
   between rank-one confinement through radius `r` and simultaneous
   confinement at every recoverable rank.  Audit separately which downstream
   objects follow from the resulting restriction/zero-extension bijection:
   coefficient-labelled equations, exact helper supports, all minimum-union
   costs, bounded reliability, and support-determined service/scheduling
   regions.  State additional hypotheses where required.
4. **Search for the sharp fixed-outer separation.**  Seek two inner
   presentations with isomorphic `(K_P,D_P)`, identical complete RGHWs and
   dual distance, identical unlabelled bounded helper-support families where
   feasible, and identical scalar costs for every relevant target subspace,
   but unequal `Gamma` for one fixed represented outer code.  Use exhaustive
   small-field search with replayable witnesses, then replace search evidence
   by a transparent hand-checkable example.
5. **Synthesize only validated results.**  Decide whether the correct headline
   is universality, a restricted probe theorem, or a sharp obstruction to
   universality.  Prepare theorem statements, proof dependencies, the finite
   example, and editorial placement as a manuscript proposal; do not mutate
   the public paper or mirrors during the investigation.

## Acceptance gates

- The observational equivalence and allowed natural relabellings are explicit.
- Every claimed probe outer code is a realizable represented code, not merely
  an arbitrary min--plus test functional.
- Rank-one consequences are derived from exact support-system transfer rather
  than from equality of scalar minima alone.
- Any finite separation has an independent exhaustive replay and a compact
  human verification.
- The report cleanly separates proved theorems, conditional statements,
  counterexamples, and manuscript-only editorial recommendations.

## Main risk

The full minimality claim may be false because distinct labelled tables can be
indistinguishable to every realizable compatible outer functional dual.  The
correct universal object may therefore be a quotient by contextual min--sum
observability rather than the raw labelled table.  Establishing that quotient
is part of the task, not a fallback wording change.

## Result 1: rank-one criterion for complete bounded transfer

Fix an outer block `j` with nonzero projection and an integer radius `r`.  The
following are equivalent:

1. every cost-at-most-`r` normalized recovery system on every nonzero
   internally recoverable target subspace `T <= W_P` is confined to block `j`;
2. the same assertion holds for every one-dimensional `T <= W_P`; and
3. `r < Gamma_{j,1}(O,I)`.

Under these conditions, for every nonzero `T <= W_P`, restriction to block
`j` and zero-extension are inverse bijections between the inner and
concatenated cost-at-most-`r` normalized systems.  They preserve every
coefficient and the exact helper support.  Consequently they preserve:

- the complete coefficient-labelled and exact-support families truncated at
  radius `r`;
- every bounded reliability law defined from those support families, for
  arbitrary helper-availability probabilities;
- every fractional service-rate or exact capacity-aware scheduling region
  whose allowed recovery systems have cost at most `r`; and
- the truncated minimum-union profile `min(rho_T,r+1)` for every `T`, hence
  `min(M_t,r+1)` at every rank `t`.

If `r` is at least every finite inner minimum under consideration, the last
statement is equality of the untruncated minimum-union quantities.

### Proof

The implication from all target subspaces to lines is immediate.  Conversely,
if a nonconfined system exists on a nonzero `T`, one external block map is
nonzero on some `u in T`.  Restriction to the line spanned by `u` remains
nonconfined and cannot enlarge the helper union.  Thus the least cost over all
nonzero target subspaces equals the least cost over target lines, namely
`Gamma_{j,1}`.  This proves the equivalence with the exact confinement theorem.

Once every bounded system is confined, restriction deletes only zero external
blocks.  Zero-extension is its inverse, so it preserves the full coefficient
array and support, not only a scalar minimum.  Every listed consequence is a
function of this bounded family.  For the minimum profile, either the inner
minimum is at most `r` and the bijection gives equality, or both inner and
concatenated minima exceed `r`; this is exactly equality after truncation at
`r+1`.

## Result 2: coarsest rank-one state observable by outer concatenation

Fix a one-dimensional target-message space `T`, choose a nonzero vector in
`T`, and use the trace pairing to identify its label maps `T -> L*` with
elements of `L`.  Put

```text
z_I(T) = rho_T(I) + d(I^perp).
```

For a projective tuple `[b]=[b_j,b_1,...,b_m]` over `L` with at least one
nonzero external coordinate, define its line-probe cost

```text
theta_I,T([b]) = min_{s in L^x}
  ( mu_I,P,T(s b_j) + sum_h lambda_I,T(s b_h) )
```

and its zero-sector truncation

```text
hat_theta_I,T([b]) = min(z_I(T), theta_I,T([b])).
```

These definitions do not depend on the chosen generator of `T` or on the
projective representative of `[b]`.

**Rank-one contextual-state theorem.**  Let `D=FD(O)=O^perp` under the trace
identification.  If the projection of `O` onto block `j` is nonzero, then

```text
Gamma_{j,T}(O,I) = min(
  z_I(T),
  min_{L b <= D} theta_I,T([b])
).
```

The inner minimum is over the projective lines of `D`; it is empty when
`D=0`.  Hence two represented inner codes have the same exact rank-one
nonconfinement cost in every compatible finite outer context if and only if
their `z_I(T)` values agree and their truncated line-probe profiles
`hat_theta_I,T` agree for every projective tuple with nonzero external part.
Consequently this pair is the coarsest numerical state observable through all
rank-one exact-confinement contexts.  Any invariant determining those costs
must refine this contextual quotient.
Moreover, the full outer code together with outer codes having
one-dimensional functional dual forms a complete separating family; larger
outer duals introduce no additional rank-one tests.

### Proof

For one-dimensional `T`, a nonzero map `T -> D` is determined by one nonzero
tuple `b in D`.  The nonzero-sector summand in the exact confinement formula
is its labelled target cost plus its labelled external costs.  Partitioning
`D minus {0}` into its `L`-lines gives the displayed formula: minimization
inside the line `L b` is exactly the minimization over `s in L^x` defining
`theta`.

The converse uses realizable outer codes, not formal min--plus tests.  The full
outer code `O=L^N` has `D=0` and exposes `z_I(T)`.  Given `[b]` with nonzero
external part, take `D=L b` and `O=D^perp`.  This `O` has nonzero target-block
projection: otherwise `D` would contain the target coordinate line, forcing
`b` to have zero external part.  Its exact cost is
`hat_theta_I,T([b])`.  Equality in every outer context therefore forces, and
is forced by, equality of `z` and every truncated line probe.

This theorem corrects the proposed raw-table minimality statement.  The full
labelled functions are sufficient, but exact nonconfinement can observe them
only through projective min--sum probes and after truncation by the
zero-functional escape.  A raw label difference is necessarily detectable
only when it changes one of these exposed probes.

## Result 3: fixed-code separation isolating functional labels

The binary/quaternary scalar counterexample already holds all the desired
unlabelled data fixed.  Let `a=1`, `b=omega`, and `c=omega^2=a+b` in `F_4`,
and represent the two encoders by columns

```text
I_1 : (a,a,b),       I_2 : (a,a,c),
```

with the first coordinate targeted.  As binary subspaces of `F_2^3`, both
images are the same code

```text
I_1 = I_2 = {(x,x,y): x,y in F_2},
```

and both duals are the same line `span(1,1,0)`.  Thus they have identical
dual distance two, identical target/helper nested pair
`K_P=0 <= D_P=span(1,0)`, identical complete RGHW hierarchy `M_1=1`, and
identical unlabelled normalized helper-support family: the unique minimal
support is the first helper.  Since `W_P` is one-dimensional, their entire
scalar profile `rho_T+d(I^perp)` is the same value three.

Only the extension-field labelling differs.  On `(a,b,c)`, the ordinary costs
are `(1,1,2)` and `(1,2,1)`, while the normalized target costs are `(0,2,1)`
and `(0,1,2)`.  For the single fixed outer functional-dual line generated by
`(1,omega)`, the three scalar multiples have nonzero-sector costs

```text
I_1 : (1,4,2),       I_2 : (2,2,3).
```

Therefore their exact costs are respectively one and two.  This holds the
binary code, binary dual, abstract pair, RGHW, dual distance, unlabelled
bounded recovery supports, and every available scalar target cost fixed; the
alignment with the intermediate functional labels is the only changing data.

The existing exact evidence generator independently enumerates this instance
as `scalar_noncomposition`, and the unit test
`test_scalar_threshold_noncomposition_example` pins the exact costs `(1,2)`.

The independent replay commands, from
`papers/complete-repair-ports/algorithms`, are

```text
nix shell nixpkgs#python3 --command \
  python3 -m unittest \
  test_algorithms.TargetAndConfinementTests.test_scalar_threshold_noncomposition_example
nix shell nixpkgs#python3 --command python3 generate_evidence.py --check
```

Both pass.  The generator uses deterministic complete enumeration over the
two binary length-three functional maps and their two-block outer functional
dual.  It checks the two exact minima and winning sectors; it does not prove
the contextual-state theorem, whose proof above is independent of computation.

## First TT / EJ / red-team checkpoint

- **TT:** formulate the converse through contextual/Yoneda observability.
  Rank-one outer-dual lines are realizable probes and generate every nonzero
  vector of an arbitrary outer dual subspace.
- **EJ:** the universal transform is the zero-truncated projective line-probe
  profile.  It gives a genuine coarsest observable quotient rather than an
  unsupported claim that the raw table is minimal.
- **Red team:** target projection, `N>=2`, trace identification, projective
  scaling, the empty `D=0` sector, and competition with the zero sector are all
  explicit.  The theorem is fixed-`T`; line probes alone do not characterize
  higher-dimensional `T`, where a map into `D` can have image spanning several
  `L`-lines.

## Second and third TT / EJ / red-team checkpoints

- **TT:** the universal tests are not arbitrary tropical functionals.  They
  are the projective lines in realizable outer dual codes.  The proof constructs
  each test as `O=(L b)^perp` and checks the target projection.
- **EJ:** arbitrary outer codes are unnecessary for separating rank-one states.
  The full outer code exposes `z`, and outer codes with one-dimensional
  functional dual expose every truncated line probe.  These contexts form a
  complete separating family.
- **Red team:** the minimality conclusion concerns exact numerical
  nonconfinement costs.  It neither reconstructs minimizing coefficient lifts
  nor asserts raw-table equality.  Restriction to a target line preserves the
  normalization equation, and bounded consequences use the full
  restriction/zero-extension bijection rather than equality of scalar minima.
- **Red team:** the fixed-code separation compares two encoders of the same
  binary row space.  Their encoder identifications with `F_4` differ by an
  `F_2`-linear transformation that is not invisible to a fixed `F_4`-linear
  outer code; this is exactly the represented functional-label distinction the
  theorem measures.

## Uncommitted manuscript patch

The working tree contains an intentionally uncommitted patch to the paper
package.  It:

1. promotes the binary/quaternary example to Proposition
   `prop:functional-label-separation` with all fixed data stated explicitly;
2. adds Theorem `thm:rank-one-contextual-state`, including the projective
   line-probe transform, realizable converse, coarsest-state statement, and
   one-dimensional-dual separating family;
3. strengthens Corollary `cor:all-rank-bottleneck` to the complete bounded
   transfer equivalence and derives coefficient, support, reliability,
   scheduling, and truncated-minimum consequences; and
4. adds Proposition `prop:rank-bounded-outer-tests`, proving that
   functional-dual dimension at most `t` is a complete context family at
   target rank `t`; and
5. updates the abstract, introduction, conclusion, claim registry, formal
   boundary count, release gate, and generated PDF consistently.

The patch is 31 pages.  The abstract passes the 200-word cap.  The release gate
passes warning-free with 29 classified claims and the unchanged four Lean
terminals.  No manuscript, verification, or PDF file in this patch is staged
or committed.

## Result 4: outer tests of dimension at most the target rank suffice

Let `dim_Fq(T)=t`, let `D=FD(O)=O^perp`, and assume the target-block
projection of `O` is nonzero.  For every `L`-subspace `D' <= D`, put
`O_{D'}=(D')^perp`.  Then

```text
Gamma_{j,T}(O,I)
  = min_{D' <= D, dim_L(D') <= t} Gamma_{j,T}(O_{D'},I).
```

The minimum includes `D'=0`, which is the zero-functional sector.  Therefore
outer codes whose functional dual has `L`-dimension at most `t` form a
complete test family for exact rank-`t` contextual equivalence.  Rank one is
the projective-line theorem above.

### Proof

Every `F_q`-linear map `B:T -> D` has image generated by at most `t` vectors.
Its `L`-span

```text
D_B = span_L(B(T))
```

is therefore a subspace of `D` with `dim_L(D_B) <= t`.  The labelled block
cost of `B` is unchanged when it is regarded as a map into `D_B`.  Conversely,
every map into a subspace `D' <= D` is a map into `D`.  Minimizing the same
block-cost functional in both directions proves the formula, with `D'=0`
accounting for `z_I(T)`.  Since `D` contains no nonzero vector supported only
at the target block, neither does `D'`; hence every probe outer code
`(D')^perp` has the required nonzero target projection.

This is also an algorithmic state bound: an exact search may canonicalize and
cache the generated intermediate `L`-span and discard any state of dimension
greater than `t`.  The theorem does not bound the number of such subspaces or
replace the labelled costs within them.

## Post-goal EJ / TT / red-team checkpoint

- **TT:** every witness factors through the subobject generated by its image.
  Applied to the outer functional dual, this turns an arbitrary context into a
  rank-bounded test object.
- **EJ:** the rank-one line probes were not an isolated accident.  Functional
  dual dimension at most `t` is a complete test family at target rank `t`, and
  generated-span caching is therefore a theorem-level reduction rather than
  only an implementation heuristic.
- **Red team:** the dimension is over `L`, while `T` has dimension `t` over
  `F_q`; `t` image vectors still generate an `L`-space of dimension at most
  `t`.  Passing from `D` to `D_B` preserves every block label and cost.  Target
  projection survives because subspaces cannot create a target-supported dual
  vector absent from `D`.
- **Open sharpness:** no example here proves that the bound `t` cannot be
  replaced uniformly by `t-1`.  Such an example must force every minimizing
  map to have `L`-span dimension `t`; this is optional strengthening, not a
  hypothesis of the theorem.

## Remaining boundary

The explicit higher-rank analogue of the projective line-probe transform
remains open.  Result 4 reduces the test category to outer dual dimension at
most `t`, but a map `T -> D` can still span several `L`-lines.  Finding a
smaller intrinsic parametrization of these rank-bounded probes is a distinct
successor problem, not a gap in the exact test-dimension theorem.

## Mystery ledger

- **Settled — raw-table minimality.**  The proposed unrestricted converse was
  too strong.  Exact rank-one contexts observe the zero-truncated projective
  line-probe profile, and the realizable-probe theorem proves this quotient is
  both sufficient and coarsest.
- **Settled — all-rank transfer from lines.**  Restriction of a nonconfined
  system to a line preserves normalization and nonconfinement.  This proves the
  exact equivalence and the full bounded-family consequences; no higher-rank
  scalar assumption is missing.
- **Settled — source of the finite separation.**  The two encoders have the
  same binary image and dual.  Direct enumeration and the existing evidence
  replay show that the fixed outer line sees only their different
  extension-field functional labelling.
- **Partly settled — higher-rank context size.**  Functional-dual subspaces of
  `L`-dimension at most `t` form a complete test family at target rank `t`.
  What remains open is an intrinsic parametrization or smaller quotient of
  those rank-bounded probes; no successor ID is allocated.
- **No other genuine mystery remains** in the rank-one theorem, complete
  bounded-transfer corollary, fixed-code separation, or low-dimensional test
  theorem.
