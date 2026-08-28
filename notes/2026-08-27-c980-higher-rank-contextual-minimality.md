# C980 higher-rank contextual minimality and finite-state bounds

**Lane:** `complete-ports`
**Status:** IN PROGRESS; MATHEMATICS ONLY; SCALAR HIGHER-RANK SMALL-MODEL,
UNIVERSALITY, CONGRUENCE, AND EXACT ORBIT-CENSUS THEOREMS SURVIVED STRUCTURAL
COMPRESSION, HOSTILE PROOF REVIEW, AND AN INDEPENDENT REREAD; THE OMITTED
NONZERO-TARGET HYPOTHESIS AND ORDERED-MONOID PROOF ARE REPAIRED; MANUSCRIPT
PROMOTION OF THE SCALAR SMALL-MODEL CORE IS RECOMMENDED
**Date:** 2026-08-27

The structural compression, hostile proof review, and literature audit are
recorded in
`notes/2026-08-27-c980-structural-compression-hostile-proof-literature-audit.md`.

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

## Candidate theorem package

1. **Column-type response.**  Every rank-`t` outer optimization is a tropical
   lower envelope over `L`-linear column types in functional-dual dimension at
   most `t`, and every admissible column-type context is realized by an outer
   code.
2. **Bounded small model.**  Through helper radius `r`, contextual equivalence
   is decided by outer codes of length at most `max(2,r+1)` and
   functional-dual dimension at most `min(t,r)`.  The orbit-normalized finite
   table is the exact coarsest observable numerical quotient.  For a fixed
   large outer code, its response is the minimum over dual shortenings to the
   target and at most `r` helpers; the same shortenings cover every bounded
   coefficient witness and exact helper support.
3. **Universality and congruence.**  Every invariant predicting all bounded
   outer responses factors through this quotient, and the quotient is a
   congruence for compatible concatenation.  A finite layer library therefore
   acts through a finite transformation category.
4. **Exact probe-orbit census.**  `GL_s(L)` reduces the target type to zero or one
   nonzero covector; Burnside averaging and Möbius inversion on invariant
   subspaces give the exact number of basis-free probes.
5. **Ordered-monoid and Pareto closure.**  Every finite extensive ordered cost
   monoid has a finite contextual quotient.  For `k` additive resources the
   sharp universal repetition cap is `1+k(R-1)`; when helper count is tracked,
   the stronger radius-`r_h` small model has length at most `max(2,r_h+1)`.
6. **Fixed-batch packing compression (not yet a full state theorem).**  A batch with per-request budgets `r_i` and
   per-helper capacities has a relational small model on at most
   `max(2,p+sum_i r_i)` blocks, retaining exact load and overlap patterns.
7. **Multi-target-block compression.**  With `p` target blocks and surjective
   outer target projection, any cost-`r` joint witness compresses to at most
   `max(2,p+r)` blocks.  The missing piece is the corresponding multi-block
   target-normalized labelled-cost interface.
8. **Finite-interface criterion.**  The same small model holds for any
   associative linear gluing with a finite label interface, injective active
   boundary observation, block-independent lifts, and a positive active-block
   budget.

## Starting point

For a fixed nonzero target space `T` of dimension `t>=1`, the paper assigns an
inner presentation two labelled functions on the finite alphabet

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

This proof is algebraically complete as a candidate lemma.  A typed reread
against the paper's trace identification, target normalization, and
repeated-field-tower formula found no mismatch; the literature and independent
hostile-proof gates remain before promotion.

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

### Rank--radius reduction

The fixed radius sharpens the manuscript's rank-bounded outer-test theorem.
Suppose a nonzero map `B:T->D` has total cost `c<R`, and put
`D_B=span_L B(T)`.  Let `A` be the external blocks on which `B_h` is nonzero.
Every such block costs at least one because `lambda(B_h)=0` only for the zero
label.  Hence `|A|<=c`.

The coordinate maps indexed by `A` span `D_B^vee`.  Indeed, coordinates
outside `A` vanish on `B(T)` and therefore on `D_B`.  A vector in `D_B`
annihilated by the coordinates in `A` would consequently be supported only on
the target block, which compatibility excludes.  Thus

```text
dim_L D_B <= |A| <= c <= R-1.
```

It follows that the response after truncation at `R` is completely determined
by functional-dual dimensions

```text
s <= u_R = min(t,R-1).
```

If no sector of those dimensions has cost below `R`, every omitted sector is
truncated to `R`.  This is an exact rank--radius reduction, not merely a search
heuristic.

There is a matching cutoff on the target side.  A normalized recovery system
for a `t`-dimensional target subspace expresses that subspace in the span of
its helper generator columns: orthogonality and target normalization give
`v=-G_H beta(v)` for every `v in T`.  A helper union of size `c` spans
dimension at most `c`, so every such system satisfies

```text
t <= c.
```

At recovery radius `r=R-1`, target ranks above `r` therefore have no bounded
systems, while every relevant outer functional-dual image also has rank at
most `r`.  The complete bounded demand diagram is confined to a
rank-`r`-by-rank-`r` window.  This target-rank cutoff concerns existence and
exact bounded costs; the manuscript's stronger rank-one bottleneck says that
rank-one targets alone control the yes/no confinement threshold across all
recoverable ranks.

### Small separating-context theorem

There is a stronger simultaneous reduction.  Suppose two inner problems have
different `R`-truncated responses in some outer context, and orient them so
that the first response is `c` and the second is larger.  Then `c<R`.

If the first minimum is in the zero sector, the full outer code (`D=0`)
already separates the two zero-sector costs.  Otherwise choose a minimizing
nonzero map `B` for the first problem and put `D_B=span_L B(T)`.  Let `A` be
the external coordinates on which `B_h` is nonzero.  As above,
`|A|<=c<=R-1`, and the coordinate maps in `A` span `D_B^vee`.  Puncture
`D_B` to the target coordinate together with `A`.  This puncturing is
injective, remains a compatible functional dual, and deletes only coordinates
that vanish identically on `D_B`.  It therefore preserves every sector cost
for maps into `D_B`, for either inner problem.

For the first problem, restriction to `D_B` cannot lower the original minimum
but contains its minimizing map, so its cost remains `c`.  For the second,
restricting from the original functional dual to `D_B` can only increase its
minimum, so its cost remains strictly greater than `c`.  The punctured context
still separates the two states and has

```text
functional-dual dimension <= min(t,c),
outer length <= 1+c <= R.
```

Together with the two-block zero-sector context, every distinction after
truncation at `R` is therefore witnessed at outer length at most `max(2,R)`.
This small-model theorem is stronger than coordinatewise multiplicity capping:
the total helper multiplicity, not merely each type multiplicity, is at most
`R-1`.

The bounded witness-cover theorem below gives a uniform version of this proof:
choose an actual minimizing coefficient system `Y`, retain every external
block on which `Y_h` is nonzero, and use `span_L(Phi_I Y)(T)` as the small
functional dual.  This handles the zero and nonzero sectors in one argument
and yields the same separating inequality for the second inner state.

### Bounded dual-minor formula

The same proof gives an exact evaluator for one fixed large outer code.  Let
`D=O^perp`, put `r=R-1`, and for `D'<=D` let `esupp(D')` be the set of
nonzero coordinate projections outside the target block.  Then

```text
[Gamma_T(O,I)]_R
  = min over D'<=D with
        dim_L D'<=min(t,r) and |esupp(D')|<=r
      [Gamma_T((D')^perp,I)]_R,
```

where `D'=0` supplies the zero sector.  Every candidate on the right is a
restriction of the original functional dual, so its minimum cannot be below
the left-hand minimum.  Conversely, any left-hand minimum below `R` supplies
`D_B=span_L B(T)` with the stated dimension and support bounds and has the
same cost there.  If the left-hand side is `R`, every candidate is also
truncated to `R`.

Puncturing the identically zero external coordinates of each `D'` turns its
term into one of the finite column-type probes.  This formula is therefore the
explicit decoder from the contextual state to the response of an arbitrary
large outer code.

Equivalently, for each helper set `S` put

```text
D_S = D intersect L^({j} union S),
```

the shortening of the outer functional dual to the target and `S`.  Then

```text
[Gamma_T(O,I)]_R
  = min_{S subseteq [N] minus {j}, |S|<=r}
      [Gamma_T((D_S)^perp,I)]_R.
```

Every `D_S` is a subspace of `D`, while a minimizing map of cost below `R`
lies in `D_A` for its active external set `A`.  This proves both inequalities.
Moreover `dim_L D_S<=|S|`, since its helper projection is injective.  Thus
bounded transfer depends only on the radius-`r` local shortening profile of
the outer dual around the target coordinate.  This is often the more useful
form for computation or outer-code preprocessing.

For fixed `r`, the outer-code side therefore requires at most

```text
sum_{k=0}^r binom(N-1,k)
```

shortenings.  Puncture each shortening to `{j} union S`, canonicalize its
column list under `GL_s(L)`, and cache one response per orbit.  The exact
bounded response is then a minimum of table lookups.  This is a theorem-led
`N^r` outer preprocessing algorithm; fibre evaluation may still dominate, and
minimum-support or pointed-GHW information can prune empty ranks and subsets.

Define the numerical radius-`r` outer signature at target `j` by

```text
Sig_r,j(D) = set of pointed column-type orbits of the punctured shortenings
             D intersect L^({j} union S),  |S|<=r.
```

Here a pointed column-type orbit means the orbit of the target covector and
the helper-column multiplicity function under change of basis in the
shortened dual; helper permutations are forgotten, but the target coordinate
is not.  Merely recording an unpointed subspace-isomorphism type would not
determine the response.

Duplicates are irrelevant for a minimum.  The dual-shortening formula becomes
the exact pairing

```text
[Gamma_T(O,I)]_(r+1)
  = min_{K in Sig_r,j(O^perp)} sigma_(r+1)(I)(K).
```

Consequently two outer codes with the same signature give the same bounded
nonconfinement cost for every compatible inner recovery problem.  This is the
outer counterpart of the minimal inner contextual state and suggests code
synthesis over shortening signatures rather than full generator matrices.
For witness counts, reliability, or scheduling, duplicates and the labeled
placements `S` can matter; retain the labeled multiset signature instead of
the numerical set in those semantics.

### Bounded witness-cover theorem

The small-model mechanism is not limited to numerical minima.  Let
`Y:T->(O o I)^perp` be one normalized coefficient system of helper cost at
most `r`, and let `B=Phi_I Y:T->D`.  Define

```text
D_Y = span_L B(T),
S_Y = {external blocks h : Y_h is not the zero coefficient map}.
```

Every block in `S_Y` contains at least one helper coordinate in the union
support, so `|S_Y|<=r`.  The nonzero coordinate maps of `B` are a subset of
`S_Y` and span `D_Y^vee`; zero-label blocks may still carry inner-dual
coefficients, which is why `S_Y` is defined from `Y` rather than from `B`.
Projection of `D_Y` to the target and `S_Y` is injective.

Restricting `Y` to those blocks therefore gives the same coefficient system,
with the same exact helper support and cost, in an outer context of length at
most `max(2,r+1)` and functional-dual dimension at most `min(t,r)`.  Conversely,
because `D_Y<=D`, zero-extension of this restricted system is the original
system.  The pair `(D_Y,S_Y)` is intrinsic to `Y`, so this is a canonical
compression of each witness, not only an existence proof.

For `B=0`, take `D_Y=0`; the active external blocks carry inner-dual maps and
the same argument applies.  Thus the complete family of cost-`<=r`
coefficient systems in an arbitrary outer code is covered by zero-extensions
from its shortenings to the target and at most `r` active external blocks.
Retaining the label span and active block set makes the cover disjoint at the
level of compressed witness data.

This theorem explains the semantics boundary precisely.  The minimal
numerical quotient discards argmins, but a witness-bearing compiler can retain
the bounded systems themselves without ever needing a larger outer context.
Comparing witnesses across different inner codes still requires an explicit
identification of their coefficient coordinates; no such identification is
implicit in numerical contextual equivalence.

For a fixed represented inner code and outer code, enumerating these
shortenings, expanding their bounded witnesses, zero-extending, and
deduplicating reconstructs the complete bounded coefficient family and its
exact helper-support projection.  Bounded reliability, service allocation,
and scheduling models derived from those support or coefficient families can
therefore use the same local shortening cover.  This does not contradict the
paper's reliability separation: the witness families are strictly richer
than the minimal numerical response state.

Writing `Sys_<=r(D)` for the normalized coefficient systems in the outer
functional dual `D`, the cover has the compact exact form

```text
Sys_<=r(D)
  = union_{S subseteq helpers, |S|<=r}
      zero_extend_S Sys_<=r(D intersect L^({j} union S)).
```

Duplicates correspond to a system whose active external set is contained in
more than one enumerated `S`; selecting `S=S_Y` gives its canonical member.

It also recovers the standard outer-distance gate transparently.  A nonzero
eligible `D'` has total block support at most `r+1`; hence none exists when
`d(O^perp)>r+1`.  In that case the bounded response is exactly the zero-sector
response.  The dual-minor formula retains all low-support sectors when the
distance gate does not remove them.

For rankwise pruning, define the pointed outer support numbers

```text
delta_j,s(D) = min_{D'<=D, dim_L D'=s} |esupp(D')|.
```

Only ranks with `delta_j,s(D)<=r` can contribute.  Ordinary generalized
weights give the immediate sandwich

```text
d_s(D)-1 <= delta_j,s(D) <= d_s(D),
```

because deleting the distinguished coordinate changes a support size by at
most one.  Thus the outer GHW hierarchy is a safe prefilter, while the pointed
quantity records whether the target coordinate participates.  Neither scalar
profile replaces the labelled cost evaluation on the surviving subspaces.

### Bounded higher-rank contextual-state theorem

Under the manuscript conventions, fix `Fq <= L`, a proper represented inner
code, an identified nonzero target space `T` of dimension `t>=1`, and
`R >= 1`.  Outer contexts have at least two blocks and nonzero projection onto
the distinguished target block.  Two represented inner recovery problems have the same truncated exact
nonconfinement cost in every compatible finite outer context if and only if
they have the same `Z_R` and the same values

```text
C_R[s,a_0](n)
```

for `1 <= s <= u_R`, every target type `a_0 in V_s^vee`, and every spanning
multiplicity vector of total size at most `R-1`:

```text
n in N^(V_s^vee minus {0}),
sum_a n_a <= R-1.
```

Every distinguishing context may be chosen with functional-dual dimension at
most `u_R` and with at most

```text
max(2,R)
```

blocks.  In particular, exact numerical behaviour through any fixed radius
has a finite, outer-arity-independent contextual state even when the
untruncated zero-sector cost is infinite.

To prove necessity, `D=0` exposes `Z_R`.  A differing table entry is realized
by the outer code whose functional dual is generated by the corresponding
spanning column list, so it exposes that entry.  For sufficiency, first use
the small separating-context theorem: any difference outside the displayed
family would produce a difference inside it.  The column-type formula
identifies every member of that family with one displayed table entry.  The
theorem is therefore a genuine
coarsest-observable-state statement, not only a sufficient encoding.

The number of raw nonzero-sector probes is at most

```text
P_t(R,Q) = sum_{s=1}^u_R
             Q^s binom(Q^s+R-2,R-1),
```

before removing nonspanning vectors and quotienting by changes of basis.  Each
entry, including `Z_R`, lies in `{0,...,R}`.  Hence there are at most

```text
(R+1)^(1+P_t(R,Q))
```

contextual classes for the fixed interface.  This is a coarse existence
bound, not a claim that the state is practically small.

### Sharpness for unconstrained tropical fibre tables

The bounds `dim_L D_B<=r` and `N<=r+1` are simultaneously sharp if the
labelled fibre values are treated as unconstrained min-plus data.  Work over
`F2`, take
`T^*=span(f_1,...,f_r)`, put `b_0=f_1+...+f_r`, and choose a penalty
`M>r`.  Define the relevant costs by

```text
lambda(0)=0,
lambda(f_i)=1,
lambda(b)=M for every other nonzero b,
mu(b_0)=0,
mu(0)=M-1,
mu(b)=infinity for b notin {0,b_0},
d=1, so z=mu(0)+d=M.
```

Take `V_r=F2^r`, use the coordinate covectors as the `r` helper columns, use
their sum as the target column, and take `X` whose rows are `f_1,...,f_r`.
This context has response `r`.

Conversely, in any sector of cost at most `r`, every nonzero helper label must
be one of the `f_i`.  The helper column types span `V_s^vee`, so their images
under `X` span the row space of `X`; that row space contains the target label
`b_0`.  A subset of the basis vectors `f_i` spans `b_0` only when it contains
all `r` of them.  Hence the sector uses at least `r` helper blocks and its
label image has dimension at least `r`.  Equality follows from the displayed
construction.

Thus no smaller universal rank or length bound follows from min-plus
semantics alone.  The displayed assignment is not asserted to satisfy every
subadditivity and scalar-action identity forced by actual prescribed-coset
costs.  Sharpness for linear fibre systems, and then for represented codes,
remains a genuine coding-theoretic question; those extra identities might
permit a smaller bound.

One such identity gives an exact collapse.  Suppose ordinary fibre cost is
invariant under the scalar action:

```text
lambda(cB)=lambda(B) for every c in L^times.
```

In any compatible outer context, the target coordinate functional on `D` is
an `L`-linear combination of the helper coordinate functionals, say
`a_j=sum_h c_h a_h`.  Hence every sector satisfies

```text
B_j = sum_h c_h B_h,
lambda(B_j) <= sum_h lambda(c_h B_h)
             = sum_h lambda(B_h)
```

by subadditivity and scalar invariance.  If `B_j` is nonzero, the two-block
functional-dual line with labels `(B_j,-B_j)` has cost no larger than the
original sector.  If `B_j=0`, retain any one nonzero helper label in a
two-block line whose target coordinate is zero.  The zero sector is already a
two-block context with functional dual zero.

Therefore, under scalar invariance, the minimum nonconfinement cost over all
compatible outer contexts is attained at outer length two and functional-dual
dimension at most one.  This does not replace higher-rank states for a fixed
outer code: the constructed two-block context need not be a subcontext of the
given code.  It identifies scalar-action anisotropy as a necessary mechanism
for genuinely cheaper higher-rank contexts in the unrestricted family.

The nonspanning vectors can be removed in closed form.  In radius notation
`r=R-1`, Möbius inversion on the full subspace lattice of `V_s^vee` gives the
exact number

```text
S_s(r,Q) = sum_{d=0}^s GaussianBinom(s,d)_Q
             (-1)^(s-d) Q^binom(s-d,2)
             binom(Q^d+r-1,r)
```

of spanning multiplicity functions of total size at most `r`.  The binomial
factor counts multisets supported in one fixed `d`-subspace, and the displayed
coefficient is the Möbius function of the finite subspace lattice.  Thus the
exact pre-basis-quotient probe count is

```text
sum_{s=1}^u_R Q^s S_s(R-1,Q).
```

The basis quotient immediately improves this count.  `GL_s(L)` has two
orbits on target types: zero and nonzero.  Normalize a nonzero target type to
one fixed covector and leave the zero type fixed.  Before even quotienting the
remaining multiplicity vectors by the appropriate stabilizer, the number of
probe orbits is therefore at most

```text
Pbar_t(R,Q) = 2 sum_{s=1}^u_R binom(Q^s+R-2,R-1).
```

Thus `(R+1)^(1+Pbar_t(R,Q))` is the sharper immediate class bound.  Removing
nonspanning vectors and taking stabilizer orbits only decreases it.

In recovery-radius notation `R=r+1` and `u=min(t,r)`, this gives

```text
Pbar_t(r+1,Q)
  = 2 sum_{s=1}^u binom(Q^s+r-1,r)
  <= 2u binom(Q^u+r-1,r)
  <= 2r binom(Q^r+r-1,r).
```

Thus, for fixed field size and radius, both the separating outer length and
the number of contextual probes are uniform in the target rank once `t>=r`,
and are independent of the inner block length.  This is a semantic state-size
bound, not an oracle-time bound: evaluating one prescribed-coset entry may
still be computationally difficult.

For a fixed recoverable target space `W` of dimension `ell`, the complete
radius-`r` numerical diagram over all nonzero `T<=W` needs only
`dim T<=min(ell,r)`.  A raw orbit-normalized probe bound is

```text
sum_{t=1}^min(ell,r) GaussianBinom(ell,t)_q
  * 2 sum_{s=1}^min(t,r) binom(Q^s+r-1,r).
```

The formula counts identified target subspaces separately and deliberately
ignores correlations among their response tables.

At the smallest nontrivial radius `r=1`, the state is especially concrete.
Only `s=1` and outer length two can occur.  Scale the unique helper column type
to one; the target/helper ratio is then one scalar `c in L`, including zero.
Thus a target line's complete radius-one numerical state consists of the
zero-sector value and exactly `Q=|L|` two-block probes.  Higher-dimensional
targets have no one-helper recovery systems.  This both checks the formulas
and gives the smallest worked instance of the all-rank construction.

For a second check, take `L=F2`, `r=2`, and `t>=2`.  At `s=1`, the helper
multiplicity is one or two and the normalized target/helper ratio is zero or
one, giving four orbits.  At `s=2`, spanning with at most two helpers forces an
unordered basis, on which `GL_2(F2)` is transitive.  Relative to that unordered
basis, the target type has three orbits: zero, one of the two basis covectors,
or their sum.  Hence there are seven nonzero-sector probe orbits and, with the
zero sector, eight state coordinates.  This agrees with the orbit and
rank--radius formulas without using their coarse binomial upper bound.

The theorem also gives finite certificates.  Inequivalence through radius
`r` has a separating outer code of length at most `max(2,r+1)`, together with
the two exact response values and a minimizing coefficient witness for the
smaller one.  Equivalence is certified by equality of the finite orbit-indexed
tables, provided each fibre optimum is itself certified.  A witness-producing
fibre oracle therefore turns the semantic theorem directly into replayable
contextual-equivalence and inequivalence certificates.

Indeed, constructing the state is NP-hard in general.  Its zero-sector
coordinate already contains exact recovery cost and inner-dual minimum-distance
information, and the lane's earlier complexity work gives NP-hard fixed
fibre problems even for a single binary demand.  The theorem bounds which
outer observations matter; it does not make the inner fibre oracle easy.

For direct evaluation of a fixed large context, there is also an exact
state-dependent coordinatewise cap.  Put `C=min(R,z)` and, for fixed
`(s,a_0,a)`, write `u_X=mu(a_0 X)` and `c_Xa=lambda(a X)`.  Forms with
`u_X >= C` are already masked.  For every remaining form with finite positive
slope, the relevant threshold is `ceil((C-u_X)/c_Xa)`; an infinite positive
slope has threshold one, and a zero slope needs no cap.  The maximum relevant
threshold, with one included to preserve positive support, gives a cap
`R_a <= C <= R`.  Replacing the uniform factor `(R+1)` by `(R_a+1)` for each
type yields the corresponding sharper probe bound.

This adaptive cap can accelerate evaluation, but the small-context theorem is
the stronger canonical-state result.

At `t=1` this strictly strengthens the manuscript's current rank-one theorem.
For `r=0` the zero sector alone suffices.  For `r>=1`, the projective probes
over all outer arities reduce to contexts of length at most `r+1`.  No
manuscript change is proposed until the typed proof and
literature gates close.

### Exact untruncated corollary for recoverable targets

In the manuscript's setting `T <= W_P`, so `rho_T(I)` is finite.  The inner
code is proper, hence `I^perp` is nonzero and `d(I^perp)` is finite.  Therefore

```text
z = rho_T(I) + d(I^perp) < infinity,
Gamma_T(C[I]) <= z
```

in every outer context.  Two inner problems with different `z` are separated
by the zero-functional context.  If their `z`-values agree, apply the bounded
theorem with `R=z`; truncation then changes no response.  Consequently full,
untruncated higher-rank contextual equivalence also has one finite complete
test table.  A distinguishing context has at most

```text
max(2,z)
```

blocks (or two blocks when the zero-sector values already differ).  In
particular, the manuscript's exact rank-one contextual quotient has a finite
outer-arity-independent realization, not only its bounded-radius shadow.
Taking `r=z-1` in the dual-shortening formula also recovers the manuscript's
exact outer-distance collapse: `d(O^perp)>z` leaves only the zero sector, so
`Gamma_T=z`.

## Arity-independent finite representation

Although `n` ranges over unbounded outer lengths, each response is the lower
envelope of finitely many affine functions.  For every nonzero
`X in Hom_Fq(T,V_s)`, store

```text
intercept:  mu(a_0 X),
slopes:     (lambda(a X))_{a in V_s^vee minus {0}}.
```

There are at most `Q^(t s)-1` such forms for fixed `(s,a_0)`, and
`Q^s` target types, including zero.  Thus all finite outer arities are
represented by a finite family of tropical lower envelopes, with raw
coefficient count bounded by

```text
sum_{s=1}^t Q^(2s) (Q^(t s)-1).
```

The bound is deliberately raw.  The finite bounded truth table above is already
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
orbit set of admissible bounded triples is a basis-free canonical contextual
state.  Choosing one lexicographically least representative per orbit is an
implementation choice, not additional mathematics.  The raw probe bound may
therefore be replaced by the exact number of these orbits; Burnside's formula
computes that number, with the spanning indicator retained.

The orbit count itself has an exact finite formula.  Let

```text
A_s = V_s^vee minus {0},
X_s(R) = {n:A_s->N : sum_a n_a<=R-1,
                     span(supp n)=V_s^vee},
G_s = GL_s(L),
P_s = stabilizer in G_s of one fixed nonzero covector epsilon.
```

The number of rank-`s` probes is exactly

```text
|X_s(R)/G_s| + |X_s(R)/P_s|.
```

The first term is the zero-target orbit count.  Transitivity on nonzero target
types identifies the second term with the nonzero-target orbit count.  Each
term is given by Burnside.  More explicitly, for `g` in either acting group,
let `L_g` be the lattice of `g`-invariant `L`-subspaces of `V_s^vee`, and let
`mob_g` be its Möbius function.  If `Orb_g(H)` is the set of `g`-orbits on
`H minus {0}`, define

```text
A_g(H,r) = coefficient sum through degree r of
           product_{C in Orb_g(H)} (1-x^|C|)^(-1).
```

A fixed multiplicity function is constant on each orbit `C`; assigning it
value `m` consumes total multiplicity `m|C|`.  Hence `A_g(H,R-1)` counts the
fixed functions supported in `H` with total multiplicity at most `R-1`.  The
number of fixed spanning multiplicity functions is

```text
Fix_g X_s(R)
  = sum_{H in L_g} mob_g(H,V_s^vee) A_g(H,R-1).
```

The span of a fixed function's positive support is `g`-invariant.  Möbius
inversion removes the functions whose support spans a proper invariant
subspace.  Averaging these
fixed-point counts over `G_s` and `P_s` gives the exact basis-free probe census.
For the Pareto table, which uses a coordinatewise cap rather than the scalar
total-size reduction, the fixed-point count instead assigns one of
`K_R,k+1` values independently to each group orbit before imposing spanning.

If `N_orb(R,Q,t)` denotes the sum of these two orbit counts over
`1<=s<=u_R`, the final exact census statement is: the canonical response
vector has `1+N_orb` coordinates including the zero sector, and its image has
at most `(R+1)^(1+N_orb)` contextual classes.  The actual image may be much
smaller because prescribed-coset cost tables satisfy realizability relations.

A unique smallest affine-form presentation does not follow.  On a finite
integer grid, distinct collections of tied forms can define the same lower
envelope and different minimal subcollections need not be unique.  The
canonical object proved here is the orbit-indexed response function; finding a
compact canonical circuit for that function is a separate representation
problem.

For `t=s=1`, the formula reduces to the zero-truncated projective line-probe
profile already in the paper: changing the generator of the one-dimensional
outer dual is exactly the scalar minimization in that theorem.

### Rank-stratified tropical recursion

For computation, split the envelope by the exact `L`-span of `X(T)`.  Define

```text
E_s(a_0,n) = min over X:T->V_s with span_L X(T)=V_s of
             mu(a_0 X) + sum_a n_a lambda(a X).
```

If a nonzero `X:T->V_s` has image span `H<V_s`, restrict every target and
helper covector to `H`.  Helper types whose restrictions agree must have
their multiplicities added, and types restricting to zero are deleted.  If
`res_H K` denotes this aggregated restricted context, then

```text
F_s(K) = min_{0 != H <= V_s} E_dim(H)(res_H K),
```

after choosing a basis of each `H` and deleting zero helper columns.  The
result is basis-independent.  This yields a triangular dynamic program in
functional-dual rank and prevents lower-rank sectors from being recomputed in
every higher-rank envelope.

The number of full-`L`-span `Fq`-linear maps `T->V_s` is itself

```text
sum_{d=0}^s GaussianBinom(s,d)_Q
  (-1)^(s-d) Q^binom(s-d,2) Q^(t d),
```

again by subspace-lattice Möbius inversion.  Exact-rank values `E_s` are useful
compiled intermediates, but they are not separately observable: lower-rank
contexts can mask them.  The contextual quotient must still store the final
responses `C_R`.

Storing one minimizing subspace `H`, full-span map `X`, and minimizing target
and helper fibre lifts at each step propagates a replayable coefficient
witness.  Combined with the minimizing outer shortening `S`, the witness path
records every reduction from the large outer code to the leaf coefficient
maps.  Retaining all ties gives the complete bounded witness family rather
than one argmin.

### Unbounded targets with no finite zero-sector ceiling

If `z=infinity` and no radius is fixed, the small-context theorem does not
give a uniform arity bound.  The finite tropical representation still gives a
decision procedure.  For two fixed envelopes

```text
F(n)=min_i (u_i+c_i.n),
G(n)=min_j (v_j+d_j.n),
```

the strict inequality `F(n)<G(n)` holds exactly when, for some form `i`,

```text
u_i+c_i.n < v_j+d_j.n    for every j.
```

Together with `n_a>=0` and the spanning condition, this is a finite disjunction
of integer-linear feasibility problems: express spanning by requiring one of
the finitely many bases of `V_s^vee` to have positive multiplicity.  Infinite
coefficients require only a finite preliminary split according to whether the
corresponding multiplicity is zero.  Testing both strict directions for every
`s<=t` and target type decides exact contextual equivalence; a feasible integer
point supplies a separating outer code.

No bound independent of the affine coefficients is possible at the abstract
min-plus level.  The functions `2n` and `min(2n,M+n)` agree through `n=M` and
differ afterward.  Whether represented-code fibres force a substantially
smaller coefficient-sensitive bound is open.  Thus radius truncation and the
finite recoverable-target ceiling are doing real mathematical work in the
small-model theorem.

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

### Universal property of the bounded contextual state

Let `S_T` be the class of represented inner recovery problems with the fixed
typed interface, let `Ctx_T` be the compatible outer contexts, and let

```text
obs_R(C,I) = [Gamma_T(C[I])]_R.
```

Define `sigma_R(I)` to be `Z_R` together with the orbit-indexed finite response
table above.  Then:

1. `sigma_R(I_1)=sigma_R(I_2)` if and only if
   `obs_R(C,I_1)=obs_R(C,I_2)` for every `C in Ctx_T`;
2. the kernel of `sigma_R` is the largest congruence on `S_T`, for the typed
   compatible layer operations just specified, that preserves every bounded
   observation; and
3. if an invariant `eta:S_T->H` predicts every bounded outer response—that
   is, for each context `C` there is a function `f_C` with
   `obs_R(C,I)=f_C(eta(I))`—then `sigma_R` factors through `eta` on its image.

For (3), equal `eta`-values force equal observations in every context, hence
equal `sigma_R`-values by (1).  Therefore

```text
bar_sigma_R(eta(I)) = sigma_R(I)
```

is well defined.  So every sufficient invariant refines the finite contextual
state, while distinctions within one `sigma_R`-fibre are invisible to every
compatible bounded outer optimization.  If `eta` is also fully abstract—its
equality is exactly contextual equivalence—then its effective image and the
image of `sigma_R` are canonically isomorphic as quotient sets, and as typed
algebras when `eta` respects composition.

This is the precise minimality/universality theorem suggested by the
Myhill--Nerode analogy.  The semantic kernel statement is formal; the
substantive coding-theoretic content is that the column-type reduction,
rank bound, radius cap, and basis quotient realize it by one explicit finite
test family with a bounded separating context.

Minimality here concerns observational equivalence, not storage layout.  The
displayed probe vector may contain coordinates computable from other
coordinates; quotienting its image by equality gives the canonical minimal
state, while finding the fewest probes or the smallest circuit representing
that image is a separate optimization problem.

### Finite tower-synthesis corollary

Fix finitely many interface sorts and a finite library of compatible outer
layers between them.  Each layer induces a well-defined map between the finite
`R`-contextual quotients.  Consequently:

1. all finite towers over the library act through a finite transformation
   category;
2. an indefinitely repeated type-preserving layer has an eventually periodic
   bounded response, with preperiod plus period at most the number of states
   in its quotient sort; and
3. reachability of a desired bounded response, and minimum-layer synthesis
   with nonnegative layer costs, reduce to finite graph reachability and
   shortest path.

This is an exact mathematical consequence of finite contextuality, not a
claim that the raw state bound is computationally attractive.  A useful
compiler still needs orbit reduction or a certified compressed circuit for
the response function.

### Family-restricted contextual quotients

If applications allow only a class `C` of outer contexts, the union of small
shortening orbits occurring in members of `C` is a sufficient restricted
state.  The genuinely coarsest family state is the response vector

```text
I |-> ( min_{K in Sig_r,j(D_C)} sigma_R(I)(K) )_{C in C}.
```

Its kernel can be coarser than equality on every shortening coordinate,
because a probe that appears inside a family member need not be independently
observable as an admitted context.  The two notions agree when the family is
probe-separating—for example, when every relevant shortening orbit is itself
realized as a context in `C`.  When `C` is closed under compatible continuation
and composition, the continuation argument makes the true response-vector
equivalence a congruence.

This can collapse the state dramatically.  An outer family with
`d(O^perp)>r+1` realizes no nonzero radius-`r` shortening and observes only the
zero sector.  A locally recoverable outer family observes only the orbit types
of its low-support local dual shortenings through the minima over their
signatures.  Thus MDS-like large-distance
storage layers and sparse-local-parity layers reduce the universal state for
opposite structural reasons, both visible directly from the bounded
dual-shortening formula.

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

by extensivity.  The identity `0_M` is a least element, since extensivity
applied to `0_M plus_M x=x` gives `0_M<=x`.  If the first upward closure is
all of `M`, then it contains `0_M`, hence `0_M in A`, and every power is
already equal.  Otherwise the first upward closure has at most `|M|-1`
elements.  If `A` is nonempty, every power remains nonempty, so its descending
chain stabilizes by exponent `|M|-1`; if `A` is empty, all positive powers are
already empty.  Equality of consecutive powers propagates under
multiplication by `A`.  Thus every column-type multiplicity can be capped at

```text
K_M = max(1,|M|-1).
```

The column-type proof then gives a finite contextual quotient and a
distinguishing-context bound

```text
1 + K_M (Q^t - 1).
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

If one resource coordinate is helper count, truncated at `R_h`, every
nonzero external label consumes at least one unit in that coordinate.  The
rank--radius argument then also restricts the Pareto probes to
`s<=min(t,R_h-1)`.  Without such a positive rank-controlling resource, the
safe dimension bound remains `s<=t`.

There is a stronger budget-box version.  Let `r=(r_h,r_2,...,r_k)` be a
componentwise resource budget, with the first coordinate counting helpers.
Observe a context by its upward-closed feasible-budget set inside the box
`[0,r]` (equivalently, by the Pareto frontier of attainable costs in that
box).  If two inner problems have different observations, choose a budget
`b<=r` feasible in the first and not the second, then choose a first-state
witness whose attainable cost is dominated by `b`.

If this witness is in the zero sector, the zero-functional context separates
the states.  Otherwise its nonzero external blocks number at most `b_h<=r_h`.
Passing to the `L`-span of its label image and puncturing all identically zero
external coordinates preserves the first witness and can only remove feasible
options from the second state.  Hence the same budget distinction is witnessed
by a context with

```text
functional-dual dimension <= min(t,r_h),
outer length <= max(2,r_h+1).
```

The complete Pareto test table therefore needs only spanning multiplicity
vectors of total size at most `r_h`.  Its orbit-normalized probe count is at
most

```text
2 sum_{s=1}^min(t,r_h) binom(Q^s+r_h-1,r_h),
```

and each entry is an antichain in the box
`product_i {0,...,r_i}`.  This is the practically relevant multi-resource
small-model theorem: exact additive bandwidth, traffic, or energy tradeoffs
compose with no larger outer contexts once helper participation is one tracked
budget.
The generic `K_R,k` cap remains necessary only when no resource controls the
number of active blocks.

More generally, any scalar or vector resource admitting a nonnegative
rank-control gauge `nu` gives the same compression.  If every nonzero external
label has `nu`-cost at least `delta>0` and the allowed budget is `b`, then a
minimizing numerical sector has at most `floor(b/delta)` active external
blocks.  For the full witness-cover statement, impose the same lower bound on
every nonzero external coefficient block, including zero-label inner-dual
blocks.  Replace `r` by `floor(b/delta)` in the rank, length, shortening, and
probe-count bounds.  The unit helper-count coordinate is the sharp special
case `delta=1`; zero-cost active blocks invalidate this stronger bound but not
the generic finite-monoid cap.

This proves a finite higher-rank contextual algebra for any fixed finite list
of additive resources—for example helper count together with finitely many
fixed traffic or energy categories.  It also applies to a max- or
divisibility-based subpacketization statistic if that statistic has a finite
interface-independent monoid law.  It does not by itself cover two major
cases.  Concrete covered models include heterogeneous per-helper I/O weights,
additive bytes or symbols sent, energy, and a fixed list of rack or link
egress categories.  A fixed-subpacketization linear-repair model also fits
when each prescribed-coset fibre stores the Pareto costs of all allowed helper
response maps and different blocks remain independent.  Cross-helper network
coding or shared constraints do not satisfy that independence without a
larger interface state.

The two principal exclusions are:

1. subpacketization is often an interface or feasibility parameter, rather
   than an independent cost with a closed monoid law; and
2. per-helper capacities for simultaneous failures introduce one resource
   coordinate per physical helper, so `k` grows with the instance and the
   finite-state bound is no longer uniform.

Those failures locate the extra state that a stronger theory must retain:
subpacketization needs an enriched interface law, while packing needs helper
identity and overlap rather than only a fixed-dimensional cost vector.

### Fixed-batch packing small model

Packing nevertheless has a finite small model when the batch and helper
budgets are fixed.  Consider `m` normalized recovery systems, with request
`i` using at most `r_i` helpers, and let `p` be the number of distinguished
outer target blocks.  Assume the outer projection onto those targets is
surjective, equivalently `D intersect L^P=0`.  Let `S` be the union of their
active external blocks and let `D_joint` be the `L`-span of all their
functional-label images.  Then

```text
|S| <= R_sum = sum_i r_i,
dim_L D_joint <= min(sum_i dim T_i, R_sum).
```

The nonzero external coordinate maps of the joint label span inject
`D_joint`; retain all of `S` as well, including blocks carrying only
zero-label inner-dual coefficients.  Puncturing to the `p` target blocks and
`S` preserves every coefficient map, exact helper support, per-helper load,
and capacity comparison.  Zero-extension recovers the original batch.

Consequently any difference in feasibility of a fixed capacitated batch is
witnessed by an outer context of length at most

```text
max(2,p+R_sum).
```

If the batch has one total union budget `R_union`, replace `R_sum` by
`R_union`.  This gives the small-context half of a finite relational state
theorem for fixed batch size and budgets.  Completing that theorem requires
an explicit finite quotient of the bounded coefficient/overlap patterns
(including inner-helper relabeling) and a typed batch-composition law.  It
does not give a uniform fixed-dimensional Pareto state as `m` or the budgets
grow; the state must retain the labelled helper-overlap and load patterns on
those bounded active blocks.

Define two inner models to be batch-equivalent when every compatible context
has the same feasible bounded load patterns.  The compression above proves
that any distinction has a small separating context.  A congruence theorem
should follow only after the missing typed batch-composition law is stated
and proved; the scalar continuation argument cannot simply be imported
without that law.

## Extensions requested by the research feedback

### Multi-target-block compression lemma

The small-model mechanism extends algebraically to several distinguished
outer blocks.  Let `P` be a set of `p` target blocks and let `D<=L^N` satisfy

```text
D intersect L^P = 0.
```

This is dual to surjectivity of the outer code's projection onto all target
blocks.  For a joint functional-label map `B:T->D`, put
`D_B=span_L B(T)` and let `A` be the external coordinates on which `B` is
nonzero.  Coordinates outside `P union A` vanish on `D_B`; if an element of
`D_B` also vanishes on `A`, it is supported in `P` and hence is zero.  Thus
projection to `A` is injective on `D_B`.

Consequently any block-additive joint witness of helper cost at most `r`
compresses to the `p` target blocks and at most `r` active external blocks:

```text
functional-dual image dimension <= r,
outer length <= max(2,p+r).
```

The same restriction monotonicity used in the one-target proof preserves a
separation between two numerical states.  What is not yet supplied is the
multi-target-block analogue of the manuscript's target-normalized labelled
cost formula.  Once that interface is defined, this lemma gives its
small-context theorem immediately.  It is the clearest route from the present
theory to simultaneous multi-node repair across concatenation blocks.

The basis quotient also has a clean `p`-target form.  The target column tuple
is a linear map `a_P:V_s->L^p`.  Two such maps differ by a change of basis in
`V_s` exactly when they have the same image subspace in `L^p`; any two
surjections onto that image are related by an automorphism of `V_s` after
matching their kernels.  Thus target-type orbits are indexed by subspaces
`U<=L^p` of dimension at most `s`, in number

```text
sum_{d=0}^min(s,p) GaussianBinom(p,d)_Q.
```

For a helper budget `r`, a raw normalized probe bound for the future
multi-block state is consequently

```text
sum_{s=1}^min(t,r)
  (sum_{d=0}^min(s,p) GaussianBinom(p,d)_Q)
  binom(Q^s+r-1,r),
```

before stabilizer-orbit reduction of helper multiplicities.

### Abstract finite-interface criterion

The small-model proof uses four structural properties, not a special identity
of concatenated codes:

1. local compatibility labels form a finite linear interface;
2. surjectivity at the distinguished target boundary is dual to the absence
   of a nonzero interface vector supported only on that boundary;
3. at fixed labels, block lifts are independent and their costs compose in a
   finite ordered monoid or relational product; and
4. every active external block consumes at least one unit of a tracked budget.

Any linear code operation or finite algebraic gluing problem with these
properties has the same conclusion.  A budget-`r` witness spans an interface
subobject injected by at most `r` active external blocks; puncturing
everything else gives a `max(2,p+r)` small model.  Contextual equivalence is
the kernel of the resulting finite response relation and is a congruence
whenever the gluings compose associatively.

This is a criterion for existence of a finite compositional state, not a claim
that every code operation satisfies it.  The proof fails exactly when active
blocks can have zero tracked cost, the boundary projection is not surjective,
block lifts are coupled by a nonlocal constraint, the label/interface alphabet
grows with the instance, or composition leaves the typed context family.
Bandwidth and fixed-batch extensions above fit by enriching the finite local
cost or relation; unbounded per-helper packing and general nonlinear repair do
not.

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
  probe.  The small separating-context theorem proves completeness, so the
  orbit-indexed response table is the coarsest observable bounded numerical
  quotient.
- This is numerical cost semantics only.  Coefficient witnesses and the full
  argmin family are not determined by the quotient; per-helper overlap and
  packing data are also absent.
- Numerical column-type canonicalization may delete zero functional columns.
  Witness, reliability, and scheduling states must retain a zero-label block
  whenever it carries a nonzero inner-dual coefficient map.
- In the numerical table, infinity is absorbed by radius truncation, zero-cost
  labels are unchanged, and zero helper column types are removable.  Capping
  preserves positive support and hence spanning; the target type may be zero;
  and helper spanning is exactly the nondegenerate-target-projection
  condition.
- The arity-independent bound is independent of inner length and zero-sector
  finiteness.  The `GL_s(L)` orbit table is canonical, while a smallest affine
  circuit need not be unique.
- The general finite-monoid theorem requires monotonicity and extensivity.  A
  parameter that changes the interface or whose resource dimension grows with
  the physical instance is outside it.
- For a restricted outer family, the union of its shortening probes is a
  sufficient state.  It is the coarsest state only under the additional
  probe-separation condition; otherwise the family observes only minima over
  probe signatures.
- The literature audit found close abstract precedents in weighted-tree
  Myhill--Nerode theory, finite-field matroid decomposition width, canonical
  minimal tree realizations of linear codes, generalized distributive-law
  elimination, generalized covering radii, and service-rate recovery
  polytopes.  Therefore the abstract contextual-kernel and min--sum ideas are
  not priority claims.  The bounded search found no predecessor for the
  explicit recovery-cost state together with the `max(2,r+1)` separator and
  dual-shortening/witness-cover formulas; any novelty wording must remain
  scoped and qualified by the audit's coverage limits.

## Proof-dependency audit

The scalar theorem package uses only the manuscript's exact two-sector
nonconfinement formula, its rank-bounded outer-test proposition, elementary
finite-dimensional duality, and the already-proved associative
target-normalized composition law.  The small-model, shortening, and witness
cover arguments are direct restrictions of a minimizing label or coefficient
map; no computation or classification theorem enters.

The orbit census additionally uses only Burnside's lemma and Möbius inversion
on a finite invariant-subspace lattice.  The ordered-monoid and Pareto results
are finite-poset arguments.  The hostile review repaired the identity-element
step in the finite-monoid stabilization proof and the aggregation step in the
rank-stratified recursion.  It also demoted the fixed-batch congruence to a
compression lemma pending a typed composition law.  No defect was found in
the scalar column-type, bounded separator, dual-shortening, witness-cover,
universality, congruence, or orbit-census proofs.

## Independent reread and manuscript-promotion decision

An independent reread checked the scalar package against the manuscript's
two-sector formula, rank-bounded restriction, target normalization, and typed
composition law.  It found one exact edge-case defect: the bounded
higher-rank contextual-state theorem did not explicitly require `t>=1`.  For
`T=0` there is no nonzero map from `T` to `I^perp`, so the stated zero-sector
cost need not be the least nonconfined cost.  The theorem now inherits the
manuscript's nonzero-target, proper-inner-code, at-least-two-block, and
nonzero-target-projection hypotheses.  No proof change is needed for `t>=1`,
and no other scalar defect was found.

The scalar core is ready for manuscript promotion, but the complete research
package is not the right unit to import.  The smallest coherent manuscript
upgrade is:

1. a short pointed column-type normal-form and realizability lemma;
2. one radius-`r` small-context theorem combining the separating-context and
   dual-shortening formulas;
3. the finite coarsest contextual-quotient corollary, with typed congruence;
4. the short exact untruncated corollary for `0!=T<=W_P`.

This block should replace the current all-arities qualification and strengthen
the existing rank-bounded outer-test proposition.  The bounded witness cover
is correct and can be included as a short operational corollary if it does not
increase the exposition burden.  The exact probe-orbit census,
rank-stratified evaluator, finite transformation-category consequences,
ordered-monoid/Pareto theory, and batch/multi-target extensions should remain
outside the current manuscript.

## Work order

1. **Done as a candidate theorem:** typed column response, bounded
   contextual-state characterization, and all-rank congruence.
2. **Done:** the rank--radius and small separating-context theorems replace
   coordinatewise capping by at most `r` total helpers at radius `r`; the
   basis-free `GL_s(L)` quotient, exact Burnside--Möbius orbit census, and
   explicit state bounds follow.
3. **Partly done:** the scalar and Pareto multiplicity caps are sharp in the
   abstract cost algebra.  Code-realizable and full state-complexity lower
   bounds remain open.
4. **Done at fixed cost dimension:** finite ordered-monoid closure and a sharp
   `1+k(R-1)` cap for bounded additive Pareto costs.  Growing per-helper
   resource dimensions and interface-valued subpacketization remain open.
5. **Done:** structural compression, hostile proof review, scoped literature
   audit, and independent theorem reread.  The scalar small-model core is
   accepted for a separate manuscript-promotion task.  Code-realizable
   sharpness remains a strengthening, not a correctness gate.

## Promotion recommendation after the remaining gates

The current paper should receive only the scalar core if it survives review:
the column-type theorem, the `max(2,r+1)` small separating-context theorem,
the universal factorization/congruence statement, and the exact recoverable-
target corollary.  These directly strengthen its existing rank-one contextual
theorem and can replace the present all-arities qualification rather than
opening a new application section.

The exact Burnside--Möbius census is appendix material.  The finite-monoid,
Pareto, multi-resource, and multi-target-block developments are a coherent
sequel or optimization-facing note; inserting them all into the current
37-page manuscript would obscure the scalar coding theorem.

## EJ + TT closeout and mystery ledger

The continuing EJ, TT, and red-team passes settled eight points that were not
visible in the initial plan.  First, compatibility means that the helper
coordinate functionals span the outer-dual coordinate space; nonzero target
type is neither necessary nor sufficient.  Second, truncation at `R=r+1`, not
at the inner zero-sector cost, gives a universal finite theorem and also
handles an infinite zero-sector cost.  Third, every bounded distinction has a
separating outer context of length at most `max(2,r+1)` and functional-dual rank at
most `min(t,r)`.  Fourth, the final response `min(R,z,F)`, rather than `F`
alone, is the minimal observable table, and the basis action reduces target
types to zero and one nonzero representative.  Fifth, the response vector has
the exact universal factorization property of a syntactic quotient and yields
a finite transformation category for tower synthesis.  Sixth, the exact
dual-shortening and witness-cover identities reconstruct every bounded
coefficient and support system from small contexts and expose a finite outer
signature.  Seventh, the Pareto cap is the sharp linear value `1+k(R-1)`, and
the mechanism extends to every finite extensive ordered cost monoid.  Eighth,
fixed-batch packing and several target blocks retain small models when their
active helper and target interfaces are bounded.

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
   the abstract scalar and Pareto cost algebras.  Code-realizable sharpness of
   the `r+1` separating-context bound is not proved; even sharpness under all
   subadditivity/scalar-action identities of linear fibres remains open.
   Scalar-invariant fibres collapse the unrestricted minimum to a two-block
   rank-one context, so any sharp code family must exploit scalar-action
   anisotropy.  Contextual-class lower bounds are also open.
   A concrete first search is the duplicated systematic representation
   `L->F2^(2m)`: here `lambda` is output-row support and `mu` is row support
   relative to the normalized target map.  For `L=F16`, test two-dimensional
   target images in Singer orbits avoiding coordinate planes.  A rank-two
   outer context can split such an image into two scalar-rotated one-row
   labels; the exact gate is whether every rank-one factorization has total
   cost at least three.
4. **Witness semantics.**  Numerical contextual equivalence need not transport
   coefficient argmins.  The bounded witness-cover theorem now proves that all
   coefficient systems and exact supports come from shortenings to at most `r`
   external blocks, including zero-label inner-dual perturbations.  The
   smallest compositional witness-bearing quotient, and comparison across
   nonidentical coefficient coordinate sets, remain open.
5. **Pareto closure — settled within a fixed resource interface.**  Finite
   antichains close under saturated Minkowski addition and Pareto choice.
   Fixed-batch per-helper packing now has a relational small model of size
   `max(2,p+sum r_i)`; unbounded batch size still has growing dimension and
   requires labelled overlap state.  Subpacketization is covered only when it is an
   interface-independent finite monoid cost.
6. **Priority — settled at bounded-audit strength.**  The semantic
   Myhill--Nerode pattern, semiring elimination, finite separator states for
   represented matroids, and canonical minimal code realizations all have
   clear predecessors.  No located source gives the recovery-specific
   labelled response, the radius-`r` separator of length `r+1`, or the exact
   dual-shortening/witness cover.  MathSciNet, Google Scholar, and complete
   citation-graph closure were not available, so every absence statement
   remains qualified.
7. **Tower dynamics.**  Finite-state iteration is eventually periodic.  It is
   unknown whether the recovery order forces aperiodicity or convergence to a
   fixed point for natural type-preserving outer layers.
8. **Multiple target blocks.**  The `p+r` compression lemma and target-type
   orbit classification are proved.  A full target-normalized labelled-cost
   interface across several outer blocks is the missing theorem before this
   becomes an exact multi-node-repair state algebra.
