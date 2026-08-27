# C962 application opportunities and the orbit-compiler programme

**Date:** 2026-08-25
**Status:** private working memo; no manuscript, export, release, or priority claim
**Scope:** applications of the C962 exact recovery optimizer, with a deeper
assessment of orbit-structured finite-geometry and algebraic-code search

## Executive verdict

C962 is best viewed as a theorem-aware compiler for repeated structured exact
optimization.  It is not a generic replacement for CP-SAT.  It wins when the
mathematics exposes a quotient, conserved grading, generated-span state,
bounded moment alphabet, or reconstructible coefficient block that a generic
model sees only as many correlated variables.

The broadest near-term application is capacitated batch repair.  The most
paper-specific application is exact hierarchical-recovery compilation.  The
largest prospective search leverage is an **orbit compiler** for symmetric
finite-geometric code design: normalize and quotient the geometry, compile
each orbit choice into additive and bounded-local contributions, reconstruct
variables forced by a few seed fibers, and send only the surviving spatial
core to a custom enumerator or CP-SAT.

The strongest integrated product is therefore not merely a solver for an
existing code.  It is an exact **code-and-repair co-design loop**: construct a
symmetric projective code under geometric constraints, compute its recovery
costs and witnesses, optimize concurrent repair under capacities, and return a
checkable construction plus repair plan.

## 1. Ranked application map

| Problem | C962 feature that matters | Expected advantage | Current maturity |
|---|---|---|---|
| capacitated batch repair | positive grading, shell-ranked capacity states, Pareto/dense dispatch, retained assignments | largest measured warm-solve gains where repair options have equal total mass | Rust solver and strengthened CP-SAT controls exist |
| repeated hierarchical recovery | generated-span leaf tables, exact min-plus substitution, tower screens, recursive witnesses | amortizes one inner compilation across many labels, outer codes, and tower levels; avoids lift enumeration | exact Python/Rust kernels and replayable certificates exist |
| operational repair-policy compilation | canonical witnesses and hierarchy-addressed resource loads | expensive discovery offline, cheap plan verification and lookup online | scalar-support model exists; vector bandwidth remains open |
| orbit-structured code construction | semilinear quotienting, packed modular syndromes, moment gates, incremental ledgers, witness transport | replaces a large raw incidence model by a small exact quotient plus residual spatial search | strong front end; full C949 hybrid remains open |
| functional projective-code reconfiguration | generated-span materialization, candidate uniqueness, capacity scheduler | jointly selects replacement columns, helpers, coefficients, and concurrent plans | exact small-instance layer and projective-MDS corollary exist |
| projective/simplex reliability | shared exact-span/Tutte specialization | computes the whole recovered-rank profile together instead of sweeping failure subsets rank by rank | exact specialized evaluator exists |
| generator-presentation co-design | coefficient-sensitive graph identification plus exact confinement objective | distinguishes operationally different presentations of the same abstract code | exhaustive small-width search; structural optimizer is open |

## 2. Where the measured speedups should transfer

### 2.1 Equal-mass concurrent repair

The best existing CP-SAT comparisons describe a concrete systems problem.
There are many demands, each demand has several legal repair protocols, helper
resources have integral capacities, and every protocol has one certified
positive total mass.  At a fixed repair count, two distinct capacity states
then have the same total load and cannot dominate one another.  This deletes
generic Pareto work and turns the live frontier into an exactly graded shell.

The likely beneficiaries are batch erasure repair, degraded-read scheduling,
maintenance-window planning, and rack/link allocation when a scalar or fixed
subpacket repair downloads the same total amount through different helpers.
The strongest cases have many repeated warm solves, small integral capacities,
and a capacity box much larger than its reachable graded shells.  The current
bounded comparisons show wins from `2.526x` through `560.936x`, with wins on
all 26 seeded phase-grid profiles (`48.10x` median, `5.10x` minimum).  These
figures predict the best-fit shape, not a universal solver ranking.

### 2.2 Repeated inner-code queries

For a fixed inner recovery map, the prescribed-coset cost depends on the image
subspace of the demand label.  A generated-span catalogue is therefore shared
by every query and every outer code using that inner constituent.  Duplicate,
zero, and proportional columns disappear at compilation time.  This is most
valuable in constituent search, parameter sweeps, and concatenation towers,
where a one-time table replaces repeated lift or coefficient enumeration.

The advantage can be asymptotic rather than merely constant-factor: the
recorded cyclic binary family keeps five generated spans while direct lifts
grow through `2^128`.  The correct application is offline structural analysis
or a reusable policy table, not one isolated tiny query.

### 2.3 Additive orbit-choice problems

The orbit meet-in-the-middle backend is a multiple-choice zero-sum solver.
For orbit blocks `i=1,...,N`, option `a` contributes

```text
s(i,a) in A,        t(i,a) in Z^d,
```

where `A` is a small finite abelian syndrome group and `t` records exact
integer totals or moments.  The target problem is

```text
sum_i s(i,a_i)=s*,       sum_i t(i,a_i)=t*.
```

Direct enumeration uses `product_i b_i` assignments.  A balanced exact
meet-in-the-middle split uses time and stored keys on the scale of

```text
product_(i in left) b_i + product_(i in right) b_i,
```

before collision checks and bounds; the implemented splitter minimizes this
sum for unequal option counts.  Packed residues, suffix bounds, and exact-key
tables reduce constants without weakening the predicate.  On the current
orbit fixture, meet-in-the-middle is `40.4x` faster than coordinate DFS and
`3,229x` faster than the Python oracle.  Transfer is most plausible when the
global constraints are additive after orbit compilation and the remaining
nonadditive geometry has a cheap local ledger.

## 3. The orbit compiler

### 3.1 Exact intermediate representation

An orbit-compiled instance should expose six kinds of information explicitly:

1. a group or semilinear action, its normalized cases, stabilizer chain, and
   witness-transport maps;
2. orbit blocks and their labelled options;
3. additive channels over small finite groups, packed when safe;
4. bounded integer totals and Newton-binomial moment functionals;
5. local incidence ledgers with prefix-feasibility bounds; and
6. functional dependencies saying that selected seed fibers determine later
   coefficients, fibers, or options.

The output is either a transported concrete witness, a replayable rejection
certificate at a named exact gate, or a smaller residual model.  Quotienting
must be joint: a mapping representative cannot be discarded while an
arbitrary carrier is held fixed unless the carrier is transported with it.

The corresponding generating function is

```text
F = product_i sum_a X^[s(i,a)] Y^[t(i,a)].
```

The desired configurations are the coefficient of the target monomial.  This
identity gives three interchangeable exact backends: sparse dynamic
programming, meet-in-the-middle coefficient matching, and, when many orbit
types repeat, truncated group-algebra convolution.  The first two already
have direct analogues in C962.  Repeated-type convolution is a genuine future
algorithm, not a current performance claim.

### 3.2 Best-fit problem families

#### Invariant arcs, caps, and bounded-intersection sets

This is the closest fit.  Point or line orbits become choices; line spectra,
secant counts, defect moments, and Fourier/Witt coordinates become compiled
channels; local line degrees become bounded ledgers.  Candidate problems
include invariant arcs and caps, two-intersection sets, blocking and saturating
sets, and other projective configurations specified by a short intersection
alphabet.

The decisive feature is that an indicator such as `1[d>=3]` on a bounded
degree alphabet is an exact integral linear combination of binomial moments.
Moves can therefore update a threshold count without branching on every line.
This is useful whenever the geometry supplies low-degree moment identities or
small intersection alphabets.

#### Symmetric projective, divisible, and few-weight code construction

A projective point set is a generator-column presentation.  Orbit selection
can impose length, divisibility, hyperplane-intersection spectrum, and
automorphism constraints.  C962 can then evaluate generated-span recovery
costs, confinement, reliability, and helper loads on each surviving code.

This is the highest-value paper-adjacent application: optimize an operational
recovery objective subject to exact geometric/code constraints.  It joins
code construction and repair analysis rather than treating them as separate
pipelines.

#### Difference families and cyclic incidence designs

Base blocks modulo a cyclic or abelian group have additive difference
histograms.  Selecting orbit representatives under exact multiplicity targets
is naturally a multiple-choice syndrome/total problem.  Difference sets,
cyclic block designs, optical orthogonal-code candidates, and related
correlation-constrained families are plausible users of the same compiler.
The packed ternary kernel is not itself universal; the intermediate
representation should generalize to small prime moduli and mixed integer
channels.

#### Quasi-cyclic LDPC and protograph-lift search

Circulant shifts are orbit-labelled choices.  Many short-cycle conditions are
modular sums of edge shifts, and trapping-set or local-spectrum screens add
bounded combinatorial ledgers.  A meet-in-the-middle or memoized residue engine
could screen lift assignments before a SAT/CP-SAT search.  This is potentially
broad, but it requires a dedicated compiler from protograph cycles and a fair
comparison with specialized QC-LDPC construction software; it is not yet a
C962 result.

#### Symmetric storage placement and functional reconfiguration

Replacement columns or conjugate pairs form candidate orbits.  A choice
contributes placement resources, helper-download loads, and future incidence
properties.  Orbit compilation can select distinct replacements under rack,
carrier, and bandwidth capacities, while the generated-span layer supplies
exact materialization coefficients.  This connects the orbit search directly
back to storage rather than using geometry only to produce examples.

### 3.3 Why C949 is the right flagship

C949 has every feature the compiler is supposed to exploit:

- a 702-cell raw incidence model and an alternative 9,126-row-pair model;
- Frobenius and projective normalization;
- four normalized ratio fibers reduced to two semilinear cases;
- 2,120 mappings reduced by a joint Burnside quotient to 714 weighted tasks;
- 25 nominal spectral coordinates thinned to 17;
- the first new Witt condition compiled to table lookups and then collapsed to
  a four-coefficient carrier equation;
- nine high fibers whose first two suitable factorizations determine the
  remaining coefficient data;
- a 16-byte prefix ledger for cubic/quartic capacities and overlap; and
- direct CP-SAT baselines still `UNKNOWN` after 1,800 seconds, with carrier
  baselines still `UNKNOWN` after 600 seconds.

The significance is not the `2.969x` mapping quotient by itself.  The larger
gain should come from composing several exact reductions before branching:
case quotient, seed-fiber reconstruction, seven-fiber verification, fourth-Witt
gate, and high-fiber prefix bounds.  CP-SAT currently rediscovers weak shadows
of these dependencies inside a much larger variable system.

There is not yet an end-to-end speedup ratio.  The front end is lossless and
sub-microsecond at its hot gates, but it is not a complete carrier solver.

### 3.4 Does this route land the C949 theorem?

**Not the main C949 sharpness theorem by itself.**  C949 asks a field-uniform
asymptotic question: construct displacement `q/3+eta(q)` with
`1<=eta(q)=o(q)`, or prove a stronger obstruction for all sufficiently large
ternary fields.  The orbit-compiled route below is presently an exact decision
procedure for the finite `q=27` balanced endpoint branch.  It settles that
finite branch only when one of two terminal artifacts exists:

1. a concrete carrier/configuration whose transported witness independently
   replays every incidence, mapping, high-fiber, elementary-symmetric, and
   Witt condition; or
2. an exhaustive rejection certificate covering all 714 weighted joint
   carrier--mapping tasks, with every symmetry quotient, seed reconstruction,
   prefix rejection, and terminal contradiction independently checkable.

The existing work proves that the finite normalization and front-end gates are
lossless.  It does **not** prove that the residual carrier search is small, and
the direct CP-SAT `UNKNOWN` statuses prove neither existence nor
nonexistence.  Thus “the C949 route is concrete” means that the missing
algorithmic interfaces and acceptance artifacts for the `q=27` branch are
specified.  It does not mean that C949's asymptotic sharpness theorem is
computationally settled.

The intended theorem-closing chain is:

```text
four ratio fibers
  -> two semilinear representatives
  -> 714 jointly transported mapping/carrier tasks
  -> two high-fiber seed factorizations
  -> reconstructed coefficient data and seven verification fibers
  -> fourth-Witt, elementary-symmetric, and overlap-ledger gates
  -> residual canonical carrier search
  -> witness or exhaustive task ledger.
```

Any CP-SAT stage is subordinate to this certificate boundary.  A solver
timeout, infeasibility status without a replayable proof, or collection of
failed heuristic searches cannot even close the finite branch.

The finite computation can still help land C949 indirectly.  Its rejection
ledger may reveal a short obstruction shared by both semilinear cases, a
stabilizer-invariant local contradiction, or a coefficient identity that
generalizes from `q=27` to `q=3^h`.  That uniform extraction would be a new
mathematical step and would require a human proof.  Conversely, a finite
witness can identify a construction ansatz to test symbolically over the
tower, but one `q=27` witness is not an asymptotic construction.

For that reason the finite solver should be instrumented as a theorem-discovery
engine, not only a yes/no engine.  Every rejected task should record its first
canonical exact reason: affine-span annihilator, Smith congruence, impossible
seed pair, failed divided difference, fourth-Witt mismatch, high-fiber deficit,
or final spatial contradiction.  Then:

1. minimize each rejection to the smallest seed/fiber/row subset that still
   proves it;
2. quotient these cores under the residual stabilizer;
3. test whether all 714 tasks fall into a bounded number of symbolic core
   types;
4. rewrite each core without the `q=27` table encoding; and
5. check whether its degrees and identities are uniform in `q=3^h`.

A bounded-degree, field-symbolic core shared by all tasks is a plausible bridge
to the missing C949 obstruction.  A core that uses enumeration of
`X^26-1`, exceptional `GF(27)` factorization, or a growing number of rows is
only a finite result.  The rejection ledger must preserve that distinction.

## 4. A harder algorithmic plan for C949 and successors

### 4.1 Compress the constraint groups before choosing a backend

Choose a baseline option `a_i^0` for every orbit block and write each other
option as a difference from that baseline.  If the modular differences span
only an `r`-dimensional subspace of `F_p^w`, then every attainable syndrome
lies in one affine coset of that subspace.  Row reduction gives an immediate
infeasibility certificate when the target is outside the coset, and otherwise
re-encodes every contribution in `F_p^r`.  The generic state factor falls from
`p^w` to `p^r`; this is an exact change of coordinates, not a relaxation.

Do the analogous operation for the integer channels.  The option differences
generate a lattice `L <= Z^d`.  Smith normal form first tests whether the
target difference lies in `L`, exposes every forced congruence, and replaces
redundant totals by independent lattice coordinates.  Interval bounds should
then be computed in the reduced coordinates when they remain useful, with the
original totals retained only for witness replay.

These two compilation passes should precede DFS, dynamic programming,
meet-in-the-middle, or CP-SAT.  They also produce short rejection
certificates: a dual linear functional annihilating the modular difference
span, or a violated Smith congruence.

For `N` binary orbit families, the option-difference span has rank at most
`N`; a synthetic 32-family, 102-coordinate fixture therefore compresses to at
most 32 ternary coordinates and from five packed words to at most two.  This
bound must **not** be transferred to C949's balanced carrier: its 102 Reed--
Solomon parities range over 26 high-arity row-pair families.  The separate
C949 signed-word layer has 31--32 active nonfixed orbits but is not the source
of those 102 parities.  Each real contribution table must be compiled and its
actual rank reported; mixing the two layers would give a false bound.

The balanced-carrier table has now been extracted independently for the
unrestricted 9,126-option model and for transversal index zero in each of the
`kappa=2,18` representatives (7,550 options each).  All three option-
difference spans have full rank 102.  Thus affine compression is an
instructive negative on those three carrier tables: it supplies no smaller
syndrome key.  This strengthens the algorithm ordering.  Two-fiber
reconstruction, which removes the need to search the 102 parity coordinates
rather than merely changing their basis, is the correct balanced-carrier
lever.

The negative in fact extends to every fixed mapping.  A mapping marks only
three of the 26 rows, leaving 23 rows whose root pair avoids the marked row
value.  Exhaustive local arithmetic shows that at each of the 26 possible
unmarked rows, differences of the allowed pair choices span all six `F_3`
coordinates of `(A,C)`.  Cubing permutes the 26 nonzero field elements, and
the 17 moment evaluations on any 23 distinct nonzero `x=u^3` values have
Vandermonde rank 17 over `GF(27)`.  The `A` and `C` channels therefore have
rank `17*3` each, for total ternary rank 102.  Affine rebasing cannot shrink
any of the 714 fixed-mapping balanced carrier tasks.

### 4.2 Seed-fiber reconstruction first

The high-fiber coherence law should be treated as a functional dependency,
not as another equation in a generic solver.  Choose two cubic/quartic fiber
factorizations with the smallest branching product, reconstruct `(A,C)`, and
verify the other seven fibers.  The search state should store only the two
seed witnesses, reconstructed coefficients, the high-fiber ledger, and the
packed spectral prefix.

Seed selection should be adaptive but exact: precompute every candidate
fiber's factorization count, choose the compatible pair minimizing the product,
and break ties by the number of independent remaining gates it immediately
determines.  This is a deterministic ordering choice, not heuristic pruning.

The first executable join now exists in both Python and Rust.  Given nine
nonempty candidate families, it chooses the pair with minimum candidate-count
product, reconstructs `(A,C)` for every seed pair, and checks the other seven
through exact coefficient indexes.  Rust returns a 64-byte witness containing
the carrier, two seed slots, nine candidate indices, and the exact number of
seed pairs examined.  The remaining missing input is the complete, deduplicated
cubic/quartic factorization catalogue for each high-fiber value; the join no
longer needs a generic solver once those lists are supplied.

A bounded Criterion shape test gives every family 64 candidates, places the
unique coherent candidate last in both selected seed families, and therefore
examines all 4,096 seed pairs.  The indexed join takes 215.11 us.  This is a
candidate-join component measurement; it says nothing yet about the cost or
cardinality of generating the genuine factorization families.

The factorization bottleneck admits a stronger representation.  A high-fiber
root incidence `(x,y)` is exactly the affine equation

```text
C(x)-yA(x)=-y^2
```

in the 18 `GF(27)` coefficients of the degree-eight pair `(A,C)`.  The search
can therefore branch on the cubic/quartic root incidences themselves while
maintaining a rollback row-echelon basis.  An inconsistent equation rejects a
prefix immediately; rank 18 reconstructs the unique carrier, after which all
remaining high cells, fourth-Witt data, and mapping constraints are direct
checks.  No cofactor `L_y` is enumerated.  Python and Rust now implement the
cell-to-carrier solve and independently reconstruct `A=X+X^2,C=X^3` from its
18 displayed root cells, then reject a third root on the same row.
The complete rank-18 reconstruction takes 5.5344 us in the bounded Criterion
probe.  A production DFS should retain this basis transactionally rather than
recompute it at every prefix.

That transactional state is now implemented as a six-cache-line, 384-byte
insertion-order echelon basis.  Independent pushes append one normalized row;
dependent or inconsistent pushes leave it untouched; rollback decrements the
rank and changes no prior row.  From a rank-17 prefix, push/pop takes 323.54 ns;
adding unique-carrier back-substitution takes 523--552 ns across two Criterion sessions.  The next
solver can therefore carry exact algebraic propagation at each incidence
branch without copying a matrix.

There is also a sharp terminal rank bound.  Let `(P,Q)` lie in the kernel of
the selected cell equations.  At every double-high row, its two distinct
fiber values force `P(x)=Q(x)=0`.  If there are `n_2` such rows, both
degree-eight polynomials are divisible by their degree-`n_2` root product.

- If `n_2>=9`, both vanish.
- If `n_2=8`, the residual factors are constants.  Every singleton row would
  force the same fiber value unless both constants vanish, but there are at
  least 11 singleton rows while one high fiber has degree at most four.
- If `n_2=7`, the residual factors are linear.  The singleton cells lie on
  their fractional-linear graph.  Their distinct row coordinates and at least
  four fiber values give rank at least three in the four-dimensional space of
  linear pairs: a projective line contained in the corresponding Segre quadric
  would fix one coordinate, and the row coordinate is already distinct.  Thus
  the carrier nullity is at most one.

Thus every terminal high-incidence system has a unique carrier except
possibly the seven-double-row case; even there only one `GF(27)` parameter,
at most 27 carriers, remains.  In C949's `g<=3` range, seven double rows force
exactly `g=3,n_0=0,n_1=19`.  The ledger now retains `n_0,n_2` in its previously
spare bytes and reports the exact zero/one nullity bound.  The Möbius defect
direction is also a promising symbolic rejection core for the field-uniform
theorem.

This changes the preferred finite solver again.  Use the family-root counts
and row capacity two as the combinatorial search, the affine basis as the
algebraic propagation state, and the existing 16-byte overlap ledger as the
cheap count screen.  If a complete incidence pattern has rank below 18, its
remaining affine carrier space must still be searched or constrained by the
other norm/Witt gates; underdetermination is not a rejection certificate.

### 4.3 Canonical augmentation under the residual stabilizer

After normalizing the frame or ratio fiber, use a stabilizer chain and accept a
partial carrier only when its next augmentation is canonical in its residual
orbit.  Recomputing the minimum over all group elements at every node is
unattractive; incremental canonical labels should be refined by the already
fixed rows/fibers.  Every rejected node carries a group element mapping it to
the accepted representative, so witness transport remains explicit.

This is the correct way to obtain more than a root-level Burnside reduction.
Adding symmetry equations to CP-SAT has already increased its deterministic
work on matched probes, showing that a sound normalization is not
automatically an effective generic-solver heuristic.

### 4.4 Bidirectional carrier search

Split the unforced fibers or row pairs into two sides.  Each half emits a key
containing:

```text
packed additive syndrome,
integer moment totals,
elementary-symmetric prefix data,
high-fiber deficits and overlap delta,
residual stabilizer signature.
```

Complementary keys meet only after exact collision checks.  The ledger
components are not all additive, so each half must retain boundary data needed
to replay cross-incidences; they must not be merged merely because their
syndrome keys agree.  If the boundary signature grows too large, retain DFS
for the spatial layer and use meet-in-the-middle only for the additive orbit
choices.

### 4.5 Exact hybrid with CP-SAT

The fair hybrid does not merely add the 714 case labels to the old model.  For
each weighted task it should:

1. prevalidate normalized mappings and cell avoidance;
2. enumerate or table-constrain compatible seed-fiber pairs;
3. reconstruct coefficient data outside CP-SAT;
4. inject fourth-Witt and terminal elementary-symmetric values as constants;
5. expose only surviving spatial carrier choices; and
6. independently replay any returned witness in the Python oracle.

The direct and hybrid models must receive identical safe preprocessing where
their representations overlap.  Report compilation, solve, and witness-check
times separately.  The meaningful outcome is reduction in residual variables,
allowed tuples, branches, and time-to-certificate, not just a favorable warm
kernel timing.

### 4.6 Reusable exact cuts for code-and-repair co-design

When an orbit-selected code fails a recovery target, the generated-span layer
can return more than a scalar failure.  A separating functional for a target
image outside the current generated flat identifies a hyperplane of columns
that cannot repair the target.  The design master can then require a future
selection to add a column outside that hyperplane or alter the target
presentation.  Conversely, a successful plan returns the exact helper support
and coefficient witness, whose capacity load is fed to the scheduler.

This suggests a certificate-driven master/subproblem algorithm:

```text
orbit master proposes a symmetric code,
recovery subproblem returns a plan or separating-flat obstruction,
scheduler returns a feasible batch or a resource-cut obstruction,
master adds the exact obstruction and continues.
```

The separating-flat and resource-cut objects are mathematically meaningful
cuts, unlike opaque solver conflicts.  Proving completeness and choosing a
nonredundant cut basis are open work.

### 4.7 Fourier/group-algebra backend for low-rank repeated queries

After affine-span compression, suppose the modular channel is the group
`A=F_p^r`.  Ignoring bounded integer totals for the moment, the number of
assignments producing every syndrome is the group-algebra product

```text
product_i sum_a e_[s(i,a)].
```

A finite-group Fourier transform diagonalizes this convolution.  For small
`p^r`, it can compute counts for all syndrome targets in time essentially
linear in `N p^r` after transforms, rather than separately searching every
target.  Truncated Laurent-polynomial coefficients can carry small integer
totals.  Exact arithmetic requires suitable roots of unity and CRT or an exact
cyclotomic representation; a witness can be recovered by divide-and-conquer
self-reduction through a product tree.

This backend is attractive only after rank compression and when many targets
or repeated orbit types amortize the transforms.  Sparse meet-in-the-middle is
still preferable when `p^r` is large but few half-assignments are reachable.
The planner can compare exact state bounds before dispatch.  No Fourier
backend is currently implemented.

## 5. Highest-value concrete demonstrations

1. **C949 hybrid flagship.**  Complete the two-seed carrier solver and compare
   direct CP-SAT with the lossless orbit-compiled hybrid on both semilinear
   representatives.  Success means a complete witness or exhaustive
   certificate, or at minimum a decisive residual-state reduction with an
   honest common timeout.
2. **Small invariant projective-code co-design benchmark.**  Enumerate
   orbit-union point sets satisfying a prescribed line spectrum, then optimize
   target recovery/confinement and concurrent helper load.  Compare separate
   construction-plus-evaluation with the integrated compiler.
3. **Cyclic difference-family benchmark.**  Compile difference histograms as
   additive totals and compare direct enumeration, CP-SAT, DFS, and
   meet-in-the-middle.  This tests whether the orbit engine transfers beyond
   C949 geometry.
4. **QC-lift pilot only after the first three.**  Compile short-cycle modular
   equations for one public protograph family and compare with its specialized
   construction baseline.  This has broader reach but the largest integration
   and literature burden.

## 6. Boundaries and reception risks

- A root-level orbit quotient is only a constant-factor reduction unless it
  enables smaller downstream state or canonical augmentation.
- Packed modular arithmetic accelerates state transitions; it does not reduce
  NP-hard worst-case complexity.
- Moment identities are powerful only when they are complete enough to reject
  many partial states or reconstruct hidden variables.
- Quotienting a mapping without jointly transporting the carrier is unsound.
- C949 currently demonstrates an exceptionally cheap front end and stalled
  generic baselines, not an end-to-end solver victory.
- A cross-domain application needs its own nearest-competitor audit.  In
  particular, QC-LDPC, difference-family, and finite-geometry packages may
  already contain specialized symmetry machinery absent from a CP-SAT
  comparison.
- The robust-completion candidate pool supports functional low-rate code
  reconfiguration.  It must not be described as repair of the associated
  high-rate dual code.

## 7. Recommendation

Develop the orbit compiler first as the exact front end demanded by C949, but
design its intermediate representation around group actions, additive
channels, bounded ledgers, functional dependencies, and witness transport
rather than C949 nouns.  The first transfer benchmark should remain a small
projective code-design problem because it exercises the full C962 loop:
geometry, code construction, recovery cost, executable witness, and capacity
scheduling.

If that transfer succeeds, the companion's most distinctive application claim
becomes:

> Compile symmetry and finite-field identities into exact code-construction
> searches whose outputs already carry optimal recovery plans and operational
> load certificates.

That is stronger and more coherent than either “fast finite-geometry search”
or “fast storage scheduling” alone.

## 8. `ej` + `tt` closeout and mystery ledger

The closeout exposed a missing abstraction: raw syndrome width and raw integer
dimension are not the true parameters.  The correct parameters are the rank
of the affine option-difference span and the rank/index structure of the
option-difference lattice.  Modular row reduction and Smith compression are
therefore higher priority than another hot-loop optimization.  A second latent
backend is exact group-algebra coefficient extraction for low-rank,
many-target workloads.

| Feature | State | Evidence gap or owner |
|---|---|---|
| modular syndrome dimension | **Implemented in Python and Rust:** quotient to the affine span of option differences and certify excluded targets by an annihilating functional; local rank six plus Vandermonde rank proves every fixed-mapping balanced carrier remains full rank 102 | extract the signed-word table separately; no further balanced affine-rank sampling is needed |
| redundant integer totals | **Implemented in Rust:** Smith form exposes exact lattice membership, forced congruences, a reduced integer target, and a checkable violated row functional; bounded cases agree with the Python direct-search oracle | measure rank/diagonal data on the final C949 table; reduced-coordinate interval quality remains to be assessed |
| best orbit-search backend | **Partly settled:** exact bounds can dispatch among DFS, sparse DP, and meet-in-the-middle | group-algebra/Fourier backend remains unimplemented; needs an exact arithmetic design and crossover measurements |
| downstream value of the 714-task quotient | **Open:** the quotient and gates are exact, but their composed residual reduction is not measured | C962 joint carrier--mapping hybrid |
| two-seed carrier join | **Implemented:** least-product seed choice, exact reconstruction, indexed seven-family verification, and compact witness agree in Python/Rust | generate the complete per-task cubic/quartic candidate families and measure their sizes |
| cofactor-free carrier recovery | **Implemented kernel:** every high cell is an affine equation in 18 carrier coefficients; rank 18 reconstructs and inconsistency certifies rejection | integrate rollback elimination with family-degree/row-cap branching and handle terminal rank below 18 exactly |
| terminal carrier nullity | **Settled:** nullity is zero for at least eight double rows and at most one for seven; the latter is a Möbius defect on singleton cells | test the remaining norm/Witt gates along the at-most-27 exceptional carriers |
| high-incidence DFS and canonical rejection cores | **Implemented:** most-constrained-row branching, transactional rollback elimination, rank-17 square masks, ordered terminal gates, joint Frobenius core canonicalization, and the streaming 714-task shell; `(SR24z-Mobius)--(SR24z-Mobius''')` exclude the one-row core, any completed multirow-empty mask, and every genuinely completed rank-17 defect | classify the later-gate failures of the resulting unique rank-18 carriers; the probes remain `Incomplete` and no task verdict exists |
| code-and-repair co-design cuts | **Open mathematical programme:** separating flats and resource cuts are valid local certificates | completeness, cut strength, and a nontrivial benchmark remain to be established |
| transfer beyond finite geometry | **Partly implemented:** degree-two QC lifted-codeword search now has a bounded exact prototype; difference families and QC shift construction remain analogies | audit specialized QC competitors; build a shift-construction control before broader claims |

No current numerical anomaly is being hidden.  The exact engine now makes the
uncertainty measurable: one task contains `binom(26,9)=3,124,550` possible
high sets before algebraic pruning, and bounded runs have not exhausted even
one such task.  The first symbolic extraction is positive: an empty Möbius
row mask forces a common zero of the two kernel-direction polynomials over
every odd field of order at least five, and the seven double rows then exclude
the `q=27` direction.  Moreover, a completed exceptional profile has only 19
singleton rows, each excluding at most one parameter, so at least eight
parameters split simultaneously; a multirow-empty mask is only an exact
unfinished-node extension prune.  The remaining questions are how the later
gates reject the unique completed rank-18 carriers, not whether a cutoff can
be mistaken for a proof.  Indeed, after the seven double-row factors are
removed, a hypothetical completed kernel direction is fractional-linear on
at least 18 singleton rows; injectivity and the fiber cap four exclude its
nonconstant and constant cases respectively.

## 9. Storage, LDPC, and GPU-training application pass

The cross-domain prototypes now cover six exact front ends rather than a list
of analogies: recursive Ceph XOR layers, Azure LRC batch repair, unit-task
repair DAGs, QC-LDPC trapping/stopping searches, vector/subpacketized node-span
repair, and erasure-coded GPU checkpoints.  The main result of the pass is not
that one generic kernel happens to win six benchmarks.  Four different pieces
of mathematics delete four different generic models:

| application                 | structural reduction                                       | exact residual state                         |
| :-------------------------- | :--------------------------------------------------------- | :------------------------------------------- |
| RepairBoost-style RDAG      | schedule the whole ready set whenever it fits              | one completed-set state per precedence layer |
| degree-two QC-LDPC          | parity checks are equality components plus forced zeros    | component-size subset sum                    |
| vector/subpacketized repair | identical canonical helper-node subspaces are equivalent   | generated-subspace catalogue                 |
| MDS checkpoint batch        | complete helper eligibility leaves aggregate capacities    | cyclic realization of prescribed degrees     |

The MDS reduction deserves emphasis.  For failures recovering into one rack,
with no surviving shard already local to a replacement node, every survivor
is an eligible helper for every failure.  A helper shard may be used once per
failure, so its aggregate degree is at most the number of failures.  Node and
rack capacities determine feasible aggregate degrees.  Listing each shard
degree consecutively in a circular sequence of failure indices realizes those
degrees: no shard repeats within a repair, and a total degree of `f k` gives
every one of the `f` failures exactly `k` helpers.  Thus neither the
`f x (n-f)` Boolean incidence model nor a max-flow graph is required.  The
implementation returns the complete slot-major helper witness.

Azure LRC(12,2,2) has a parallel counted-family reduction.  Its 12 data labels
have only six distinct load types.  If `L` local and `G` global repairs are
served and type `i` contributes `s_i`, the load on data domain `i` is exactly
`(L+2G)-s_i`.  For any proposed total, taking the maximum permitted `L`
weakly decreases every data-domain load.  Six lower bounds on the `s_i` then
decide feasibility, after which greedy type counts and a parity-7/parity-8
split reconstruct a witness.  This is exact for arbitrary nine-domain
capacity vectors, not just the uniform benchmark.  One thousand seeded small
instances agree with the enumerated exact scheduler.

The controlled application comparison is:

| application / control            | bounded instance                  | ERGO time | ERGO RSS | control time | control RSS | outcome                  |
| :------------------------------- | :-------------------------------- | --------: | -------: | -----------: | ----------: | :----------------------- |
| Azure LRC / direct CP-SAT        | 100,000 demands, domain cap 100k  |     <1 us |  2.2 MiB |       8.95 s |   916.6 MiB | CP quotient 5,168x       |
| Azure LRC / counted CP-SAT       | same six-type quotient            |     <1 us |  2.2 MiB |     1,732 us |    75.5 MiB | ERGO 61,799x faster      |
| Repair DAG / direct CP-SAT       | 3 layers x 21 tasks               |      2 us |  2.3 MiB |       1.20 s |   145.5 MiB | ERGO 494,061x faster     |
| QC-LDPC / direct CP-SAT          | lift 50,000, weight 4             |  1,517 us |  4.0 MiB |       1.52 s |   381.6 MiB | ERGO 1,001x faster       |
| vector node span / direct CP-SAT | 64 nodes, 2 symbols per node      |     10 us |  2.2 MiB |       1.21 s |    85.9 MiB | ERGO 117,097x faster     |
| GPU MDS / direct CP-SAT          | 10,000 shards, k=6,000, 64 failed |    100 us |  3.6 MiB |      11.82 s |     1.9 GiB | ERGO 118,014x faster     |

All values are bounded, deterministic, pinned-core comparisons with checksum
agreement.  Direct Azure and GPU use one completed CP-SAT proof; the counted
Azure control and the other CP-SAT rows use seven runs, as do all Rust rows.
The GPU case emits 384,000 helper assignments; it is not a feasibility-only
shortcut.  A 60,000-shard, `k=36,000`, 128-failure ERGO-only run emits
4,608,000 assignments in about 0.8 ms after warm-up and stays below 15 MiB.
CP-SAT was not run at that scale: its 10,000-shard process already peaked near
2 GiB.

The performance profile is consistent with output-bound execution rather than
hidden search.  On the 60,000-shard case, the warm kernel retired about 6.2
instructions per cycle, had roughly 0.01% branch misses, and about 5.6% L1D
load misses.  The remaining work is predominantly construction of the
4.6-million-entry replayable witness.  SIMD and parallelism are therefore not
the next priority; a caller-selectable feasibility-only mode or streamed
witness sink would remove more work than vectorizing the small capacity scan.

The most direct recent GPU-training connection is REFT, *Fault-Tolerant
Hybrid-Parallel Training at Scale with Reliable and Efficient In-memory
Checkpointing* (SC 2023, arXiv:2310.12670).  REFT uses asynchronous erasure
coding and topology-aware in-memory checkpoint protection for hybrid-parallel
training, and evaluates at 512 GPUs.  ERGO does not replace REFT's snapshot,
communication, or restart runtime.  It supplies an exact offline/online
planner for the discrete question left after placement is fixed: which
surviving checkpoint shards should serve simultaneous recoveries under helper
and rack/link budgets?  RepairBoost (USENIX ATC 2021) is the nearest storage
scheduling analogue because it represents chunk repair as RDAGs and schedules
multiple repair tasks under bandwidth constraints.  The Azure control uses
the published LRC(12,2,2) upgrade-domain layout from the 2012 Windows Azure
Storage paper.  These sources establish application relevance, not priority
for the reductions above; a full specialized-competitor audit remains needed
before any broad SOTA claim.
