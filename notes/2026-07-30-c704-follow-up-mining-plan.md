# C704 follow-up — exhaustive operator-shadow mining plan

**Lane:** `clebsch`

**Mode:** exploratory mining

**Status:** planning surface only.  No successor C-IDs are allocated and
C704 remains complete.  Each work package below must receive its own
globally allocated C-ID before execution or dispatch.

## Mandate

Mine the productive seam opened by C704 until its exact geometric,
categorical, arithmetic, invariant-theoretic, and ADE consequences are
either proved, sharply obstructed, or placed behind explicit external
gates.  Preserve the distinction among:

1. classical Segre--Igusa, determinantal-cubic, and double-six geometry;
2. exact new consequences of the paired-\(E_8\) return;
3. analogies suggested by dimensions or exceptional-group names; and
4. publication-priority claims, which require their own audit.

This is a successor portfolio, not permission to reopen Papers I--III or
to turn C682 back into an unbounded exploration.  A work package may
continue after a failed first conjecture only within its stated mining
boundary.  Promotion beyond that boundary requires a new package and
C-ID.

## Frozen starting package

Every successor imports the following C704 results without recomputing
their discovery history:

- the all-degree restriction-of-scalars pair
  \((\widehat\Delta,J)\), \(J^2=5\);
- the degree-ten conference operator \(C^2=5I\);
- the middle-exterior operator \(K=*\Lambda^3C\), \(K^2=125I\);
- the six signed outer Joubert coordinates
  \(Z_T=\frac14\operatorname{diag}K_T\);
- the Segre relations and centered-square Segre--Igusa polar map;
- the five-syntheme/Clebsch identity;
- the Cartan restriction
  \[
  \operatorname{Pf}[D_x,C_T]=4Z_T(x);
  \]
- the branch determinant
  \[
  \det[D_x,C_T]=16Z_T(x)^2;
  \]
- the cross-golden determinant
  \[
  Z_T(x)=\pm10\sqrt5\det(P_-D_xP_+);
  \]
- the linear--quadratic matrix factorization, conjugate small
  resolutions, Ulrich/MCM descent, and projective-bundle model;
- the determinantal double-six on smooth hyperplane sections;
- the bounded later-\(E_8\) obstruction through degree \(50\); and
- the first exact affine-\(E_6\) and affine-\(E_7\) separator gates.

The authoritative evidence bundle is
`notes/2026-07-30-c704-functorial-operator-shadows.md` and its adjacent
scripts, JSON certificate, replay, and checksum manifest.

## Mining discipline

Each package follows the same loop:

1. **Freeze the category and marking.**  State the base ring, lattice,
   group action, orientation line, and whether objects are affine,
   projective, normalized, or only generic.
2. **Run the cheapest falsifier.**  Test dimensions, equivariant Hom
   spaces, degrees, ranks, fields of definition, and one exact witness
   before global construction.
3. **Build the intrinsic object.**  Coordinates may fix a scalar, but may
   not be the definition of the claimed functor.
4. **Separate theorem levels.**  Record object-level coincidence,
   equivariant isomorphism, functorial diagram, integral model, and
   moduli interpretation separately.
5. **Certify computation atomically.**  Report, exact generator,
   canonical certificate, checksum manifest, and independent replay move
   together.
6. **Run double `ej` + double `tt`.**  Every promoted package receives
   four explicit closeout passes in the order `ej1`, `tt1`, `ej2`, `tt2`.
   The second pair begins only after the first pair's cheap upgrades and
   counterchecks have been incorporated; it is not a restatement of the
   first pair.
7. **Classify the result.**
   - `crown`: supports a successor theorem or paper-level synthesis;
   - `bridge`: exact and reusable but not independently publishable;
   - `inventory`: bounded data with a clear consumer;
   - `negative`: structural obstruction plus the full negative-yield
     protocol and one adjacent-crown extraction.
8. **Stop at the package boundary.**  Incidental observations go to the
   Clebsch discovery track only when they were not part of the package's
   named questions.

### No-early-bail rule

A failed first conjecture, zero Hom space, mismatched marking, bad fibre,
or literature pre-emption is an intermediate verdict, never package
closeout.  Before a promoted package may close, it must:

1. execute every listed first falsifier or gate whose hypotheses remain
   meaningful;
2. run the explicitly named adjacent variants and cheap upgrades;
3. complete `ej1` and `tt1`, implement or exactly obstruct every
   package-owned lead they expose, and update the evidence;
4. rerun the main acceptance tests against that strengthened object;
5. complete `ej2` and `tt2` from the strengthened state, again resolving
   every in-scope cheap lead; and
6. record a final mystery ledger separating settled questions, exact
   obstructions, and successors that genuinely exceed the package
   boundary.

The four passes must be substantively distinct:

- `ej1` mines immediate formulas, degenerations, markings, and free
  consequences;
- `tt1` challenges definitions, functoriality, hidden hypotheses, and
  alternative structural explanations;
- `ej2` mines the repaired or negatively classified object for the next
  layer of consequences; and
- `tt2` attacks the final theorem level, tests uniformity and converse
  directions, and looks for a stronger formulation or decisive
  counterexample.

Negative acceptance therefore means exhaustion of the package's stated
route family, not failure of its preferred route.  “No early bailing” does
not authorize unbounded parameter sweeps or silent scope growth: when the
listed route family is exhausted, further work requires a separately
allocated package.

### Negative-yield protocol

Negative results are first-class outputs, not consolation prizes.  When a
candidate construction fails, the package must mine the failure through
all four closeout passes and determine, as far as its bounded domain
allows:

1. the **minimal obstruction**: the first wrong rank, character, twist,
   field, conductor, ramification index, Ext group, or singularity type;
2. the **obstruction locus**: whether failure is generic, divisorial,
   confined to special markings or fibres, or caused by one exceptional
   isotypic summand;
3. the **nearest positive locus**: the maximal subspace, localization,
   normalization, cover, twist, or weakened functorial statement on which
   the construction becomes exact;
4. the **converse content**: whether vanishing of the obstruction
   characterizes the classical object or selects a canonical sister;
5. the **propagation law**: whether the obstruction repeats by degree,
   McKay phase, prime splitting type, or categorical periodicity; and
6. the **adjacent crown**: one exact theorem extracted from the failure,
   with its consumer and novelty status stated.

A negative package is complete only when it gives a structural explanation
or proves that no sharper explanation exists within the enumerated route
family.  Its final report must distinguish a computational nonexample, a
representation-theoretic impossibility, a moduli-boundary theorem, and a
literature pre-emption; these are not interchangeable verdicts.

## Dependency map

```text
                         C704 frozen core
                 ┌────────────┼─────────────┐
                 │            │             │
          WP1 adjugate   WP2 marking   WP5 arithmetic
                 │            │             │
                 ├──────┬─────┘             │
                 │      │                   │
          WP3 incidence WP4 category/flops  │
                 │      │                   │
                 └──┬───┘                   │
                    │                       │
              WP10 synthesis/algorithm ─────┘

 C704 frozen core ── WP6 later E8
 C704 frozen core ── WP7 tetrahedral E6 ─┐
 C704 frozen core ── WP8 octahedral E7 ──┼─ WP9 uniform ADE
                                         │
 exact crowns from WP1--WP10 ────────────┴─ WP11 priority audit
                                               │
                                         WP12 disposition
                                               │
                                         WP13 formalization
```

WP1 and WP2 are the highest-EV launch pair.  WP3 should not begin until
at least one of them fixes the relevant map or marking.  WP9 is forbidden
until both sister packages have exact positive or sharply negative
verdicts.

## Work packages

### WP1 — adjugate realization of the Segre--Igusa polar map

**Question.**  Do the six adjugates
\(\operatorname{adj}(B_T(x))\), with
\(B_T=P_{T,-}D_xP_{T,+}\), assemble into the polar map without passing
through six scalar squares?

**First falsifiers.**

- Decompose the span of all quadratic \(2\times2\) minors under the
  signed outer \(S_6\)-action.
- Compute the equivariant Hom space from that span to the outer-standard
  Igusa carrier.
- Test whether contraction with the six frozen coefficient tensors gives
  \(W_T\) up to one scalar.

**Positive deliverable.**  A coordinate-free diagram in which the
Segre gradient is the trace/adjugate pairing of the cross-golden blocks,
with the scalar fixed exactly and the base locus identified.

**Negative acceptance.**  Identify the missing isotypic component,
wrong twist, or unavoidable choice of trace functional.  A failed raw
adjugate may be replaced once by its trace-free, compound-matrix, or
exterior-square version.

**Cheap upgrades.**

- Recover the fifteen singular Igusa lines as rank conditions on the
  assembled adjugates.
- Test whether the ten Segre nodes and fifteen planes have direct kernel
  descriptions.
- Express the inverse Igusa-to-Segre map in the same operator language.

**Stop.**  One intrinsic polar construction or one exact
representation-theoretic obstruction.  Do not sweep arbitrary quadratic
functions of \(B_T\).

### WP2 — marked determinantal double-six

**Question.**  Which hyperplane section and six-point blow-up marking
identify the determinantal double-six with C695's
transvectant/apolar double-six?

**First falsifiers.**

- Compute the five-dimensional hyperplane parameter space
  \(H^0(\mathcal E_+^\vee)\) in the frozen six-axis marking.
- Express the six zeros of a section by maximal minors of the
  \(3\times5\) evaluation matrix.
- Test the C695 surface equation and its twelve line ideals against the
  resulting blow-up/down maps at one exact cyclotomic point and one
  independent finite-field marking.

**Positive deliverable.**

- the exact hyperplane;
- the six blow-up points;
- the dictionary
  \(e_i\leftrightarrow E_i\),
  \(2h-\sum_{j\ne i}e_j\leftrightarrow E'_i\);
- compatibility of golden conjugation, row exchange, and the order-four
  \(A_1\) Weyl lift; and
- the induced fifteen \(L_{ij}\) and \(45\) tritangent planes.

**Negative acceptance.**  Prove that the C695 surface is not a section
of this determinantal family in the frozen marking, or that every
matching requires an unowned scalar/twist.  Distinguish failure of the
specific marking from failure of the abstract double-six mechanism.

**Stop.**  One marked section or one exact obstruction.  Do not enumerate
all hyperplane sections.

### WP3 — comparison with the normalized two-parent incidence geometry

**Dependency:** WP1 or WP2 must supply a canonical map/marking.

**Question.**  Are the golden-conjugate small resolutions the pullback,
normalization, or a birational modification of Hitchin's two-parent
incidence cover on the Clebsch locus?

**Gate sequence.**

1. Draw the field-of-definition and function-field table for
   \(X_T\), \(\widetilde X_\pm\), the incidence cover, its normalization,
   and the descended Clebsch union.
2. Compare generic degree, branch divisor, deck action, and determinant
   square class.
3. Test codimension-one extensions and conductors.
4. Only then compare global schemes and boundary fibres.

**Positive deliverable.**  A universal-property diagram over an explicit
base, with normalization and base-change hypotheses stated, showing
exactly how the two kernel resolutions map to the two parent choices.

**Negative acceptance.**  A mismatch in function fields, ramification,
canonical classes, exceptional loci, or deck character.

**Boundary.**  Equality of the restricted branch equation
\(J_0=\det[D_x,C]\) is input, not proof of a global incidence
identification.

### WP4 — MCM, flop, and categorical operator shadow

**Question.**  What categorical structure is carried by the pair
\((\mathcal F_+,\mathcal F_-)\), and does golden conjugation coincide
with the flop between the two small resolutions?

**Subgates.**

- Compute the graded endomorphism and Ext algebras of
  \(\mathcal F_\pm\).
- Identify the rational descended object
  \(\mathcal E=\operatorname{Res}_{K/\mathbf Q}\mathcal F_+\) and the
  order generated by \(J_{\mathcal E}\).
- Compute the six local node modules and the action of the simultaneous
  flop.
- Determine whether the adjugate factorization is indecomposable and
  generator-minimal.
- Compare, only after those checks, with the binary-\(E_8\) MCM category
  or a preprojective/spherical corner.

**Positive deliverable.**  An exact functor or fully faithful subcategory
carrying the golden involution, not a resemblance between two ADE labels.

**Negative acceptance.**  Incompatible Grothendieck groups, Euler forms,
periodicity, or local contraction algebras.  Preserve any exact
rank-two descended MCM theorem.

**Cheap upgrade.**  Test whether the six exceptional curves give six
spherical objects whose twists generate the same outer \(S_6\) action.

### WP5 — minimal integral model and arithmetic fibres

**Question.**  Over what smallest natural base do the conference,
cross-block, matrix factorization, small resolutions, and descended MCM
object coexist?

**Required inventory.**

- integral lattices for \(V_\pm\) and their determinant lines;
- denominators in \(P_\pm\), \(B_x\), the scaled adjugate, and the
  projective-bundle maps;
- Fitting ideals and flatness of the cokernel sheaves;
- normality and smallness of the resolutions; and
- comparison with the conductor orders already known at \(2,5,11,23\).

**Prime gates.**

- \(2\): index-four companion/six-axis mismatch and collapse of signs;
- \(5\): ramified golden algebra and square-zero \(C\);
- \(11\): split scalar-image conductor, expected good operator model;
- \(23\): inert scalar-image conductor, expected good normalized operator
  model.

**Positive deliverable.**  A minimal base such as
\(\mathbf Z[1/N]\), exact special-fibre diagrams, and proof that
\(11,23\) are absent or present for a stated scheme-theoretic reason.

**Negative acceptance.**  Exhibit the first failed flatness,
normality, or lattice-conjugacy condition.  Do not infer geometry from a
matrix reduced modulo a prime without its integral model.

### WP6 — canonical structures on later balanced \(E_8\) slices

**Question.**  Can any later balanced slice recover a distinguished
support lattice by an operation functorial in the paired towers?

**Bounded domain.**

- multiplicity-one representatives: degrees \(14,18,20,24,28\);
- first repeated representative: degree \(30\);
- first multiplicity-three representative: degree \(50\);
- at most the first new modulo-\(20\) pattern beyond degree \(50\), and
  never beyond degree \(70\) without reallocation.

**Candidate support mechanisms.**

1. evaluation on a canonical orbit;
2. Krylov lattices of nearest returns;
3. exterior powers or determinant lines of multiplicity spaces;
4. kernels/cokernels of primitive Weyl operators; and
5. integral minimal vectors of the Fischer form.

**First falsifier.**  Compute the automorphism/commutant action on each
candidate.  If it acts transitively on all possible atomizations, no
support is canonical.

**Positive deliverable.**  One new canonical support scheme, its first
golden-odd invariant, singular scheme, symmetry group, and relation to
the degree-ten shadow.

**Negative acceptance.**  A theorem that the paired module plus canonical
returns has no invariant atomization in the bounded representatives.

### WP7 — tetrahedral / affine-\(E_6\) sister

**Starting data.**

\[
K=\mathbf Q(\zeta_3),\qquad J^2=-3,\qquad
\operatorname{Sym}^3=\mathbf2'\oplus\mathbf2''.
\]
The second transvectants with
\[
f_\pm=x^4\pm2\sqrt{-3}\,x^2y^2+y^4
\]
have rank two and select conjugate doublets.

**Gates.**

1. Construct the primitive integral paired operator over
   \(\mathbf Z[\zeta_3]\) and its rational restriction of scalars.
2. Identify the natural rank-four lattice and its conductor.
3. Find the lowest determinant, Pfaffian, or exterior-power shadow.
4. Compute its singular scheme, projective symmetry, and bad fibres at
   \(2,3\).
5. Compare with classical tetrahedral covariants only after the intrinsic
   object is fixed.

**Positive deliverable.**  One exact sister theorem with a functorial
operator diagram and a classical geometric shadow not introduced by
name matching.

**Negative acceptance.**  Prove that the separator has no canonical
support lattice or that every nonlinear shadow is already a scalar
relative invariant.

**Stop.**  First intrinsic nonlinear shadow.  A classification of all
tetrahedral slices requires another task.

### WP8 — octahedral / affine-\(E_7\) sister

**Starting data.**

\[
K=\mathbf Q(\sqrt2),\qquad J^2=2,\qquad
\operatorname{Sym}^7=\mathbf2_+\oplus\mathbf2_-\oplus\mathbf4.
\]
For \(f_8=x^8+14x^4y^4+y^8\), transvectant orders
\(1,2,3\) have ranks \(8,8,6\); the third transvectant kills one
conjugate doublet.

**Gates.**

1. Isolate the paired four-dimensional subslice intrinsically from the
   fixed \(\mathbf4\).
2. Build the primitive integral \(\sqrt2\)-descent operator.
3. Determine the first balanced lattice and lowest nonlinear shadow.
4. Compute singular scheme, symmetry, and the characteristic-\(2\)
   boundary.
5. Test compatibility with the octahedral invariant tower.

**Positive and negative acceptance** mirror WP7, with explicit proof that
the fixed \(\mathbf4\) is harmless or is the obstruction.

### WP9 — uniform ADE descent theorem

**Dependency:** crisp WP7 and WP8 verdicts.

**Question.**  Is there one theorem for conjugate McKay pairs explaining
the Eisenstein, \(\sqrt2\), and golden cases?

**Candidate template.**

- a quadratic or cyclotomic character field \(K/k\);
- a first balanced pair of conjugate irreducibles;
- a minimal semi-invariant transvectant separator;
- restriction of scalars with trace-zero operator \(J\);
- a cross-eigenspace determinant or Pfaffian;
- a conjugate matrix-factorization pair; and
- categorical descent of the associated MCM objects.

**Falsifiers.**

- nonquadratic Eisenstein descent requires a different trace-zero
  polynomial;
- the \(E_6\) relative-invariant twist may not fit the \(E_7/E_8\)
  invariant separator;
- support lattices may be exceptional rather than uniform; and
- singularity categories may have incompatible dimensions or periods.

**Positive deliverable.**  A theorem whose hypotheses visibly select the
three examples and whose conclusion is weaker where the data are weaker.

**Negative acceptance.**  A classification of exactly which arrows are
uniform and which are exceptional.  Never conflate affine McKay type with
exceptional Lie-group cubic forms.

### WP10 — arithmetic resolvent and exact algorithmic consequence

**Dependency:** WP1, with WP5 if integral claims are made.

**Question.**  Does the operator determinant give a genuinely useful
implementation of the outer sextic resolvent or Segre--Igusa polarity?

**Tests.**

- operation counts and coefficient growth for:
  twenty signed cubic monomials,
  five-syntheme/Clebsch evaluation,
  \(3\times3\) determinant/adjugate evaluation;
- exact bit complexity over \(\mathbf Z\) and finite fields;
- conditioning under floating-point root perturbations;
- recovery of the outer Galois action and subgroup tests; and
- behaviour at collisions and bad primes.

**Positive deliverable.**  A proved complexity, coefficient-height, or
stability improvement with a reference implementation.

**Negative acceptance.**  Exact evidence that the determinant packaging
is conceptual but not algorithmically superior.

**Boundary.**  A prettier formula is not an algorithmic theorem.

### WP11 — proportional priority and classical-source audit

**Trigger:** an exact crown from WP1--WP10.  Do not run a broad audit for
inventory-only outcomes.

**Source clusters.**

- Joubert, Coble, and explicit outer-\(S_6\) covariants;
- Segre--Igusa polarity and its quadratic-minor presentations;
- \(3\times3\) determinantal cubic threefolds with six nodes;
- small resolutions, Steiner/kernel bundles, and six-point blow-ups;
- linear determinantal representations and double-sixes;
- Ulrich/MCM sheaves on singular cubics;
- matrix factorizations and flops; and
- binary-polyhedral invariant differential operators.

**Required verdict matrix.**

For every claimed contribution, mark:

- classical identity;
- known geometric packaging;
- known categorical packaging;
- operator-derived identification not located;
- exact consequence beyond known duality; and
- unresolved access or indexing gap.

Every named source carries the required read depth.  Any absence claim
uses the full literature-audit conventions.

### WP12 — synthesis and paper disposition

**Trigger:** at least one of:

1. intrinsic adjugate-polar theorem plus a consequence beyond classical
   duality;
2. marked equality with C695's double-six;
3. global comparison with the normalized parent-incidence geometry;
4. categorical equivalence or new flop action;
5. a minimal integral theorem with nontrivial special fibres; or
6. a uniform ADE theorem with at least two genuinely geometric sisters.

**Possible dispositions.**

- research note independent of Papers I--III;
- appendix or v2 theorem only if the owning paper's release task admits
  it;
- C682 successor report with no manuscript promotion;
- sister-specific standalone project; or
- closed inventory with no paper.

**No-go.**  Shared exceptional vocabulary, a known double-six, or the
classical Segre--Igusa diagram alone cannot reopen a paper.

### WP13 — proof-assistant and trust-surface promotion

**Trigger:** a stable theorem selected for publication.

**Candidate formal core.**

- conference and middle-exterior identities;
- six-shadow outer action and Segre relations;
- Pfaffian/commutator/determinant formulas;
- cross-block determinant and matrix factorization;
- Chern-class/projective-bundle calculation; and
- finite group/McKay recurrences for sister gates.

Before any Lean action, scope a separate build-system-aware task and read
the nested Lean guide.  The present mining plan authorizes no Lean edit or
build.

## Launch tranches

### Tranche A — immediate exact closure

1. WP1 adjugate-polar map.
2. WP2 marked double-six.

These are independent after the common frozen bundle.  Both are bounded,
have cheap exact falsifiers, and directly test whether the seam rises from
a strong bridge to a new theorem.

### Tranche B — geometric and categorical depth

3. WP3 normalized incidence comparison, using whichever of WP1/WP2 fixes
   the better map.
4. WP4 MCM/flop package.
5. WP5 integral model, before any special-fibre claim.

### Tranche C — breadth without dilution

6. WP7 tetrahedral sister.
7. WP8 octahedral sister.
8. WP6 later-\(E_8\) support census.

WP7 and WP8 should be scoped separately; one sister's success does not
authorize expanding the other.  WP6 remains bounded even if a sister is
positive.

### Tranche D — synthesis

9. WP9 uniform ADE theorem.
10. WP10 algorithmic consequence.
11. WP11 priority audit.
12. WP12 disposition.
13. WP13 formalization if publication-facing.

## Portfolio kill and completion conditions

The C704 seam is exhausted when all promoted packages satisfy one of:

- theorem proved and disposition decided;
- exact obstruction with bounded adjacent-crown extraction complete;
- inventory delivered to a named consumer; or
- external access/authority gate recorded.

The portfolio stops without further allocation only after the relevant
packages have completed their full gate families and both `ej` + `tt`
pairs, and:

- WP1 has no intrinsic quadratic-minor polar construction;
- WP2 has no marked determinantal/C695 section;
- WP3 has a function-field or ramification mismatch;
- WP7 and WP8 both lack canonical support lattices; and
- WP6 proves the later-slice non-atomization obstruction in its bounded
  domain.

Conversely, one positive result does not keep every branch alive.
Continue only its downstream dependencies.  The strongest plausible
complete crown is:

> The paired binary-\(E_8\) return produces the Segre--Igusa polar
> correspondence, its determinantal cubic and golden-conjugate small
> resolutions, the marked Schläfli double-six on a canonical section, and
> the descended MCM object as successive functorial shadows; the same
> mechanism has precisely delimited \(E_6/E_7\) sisters.

Anything weaker is still successful if its theorem level and classical
boundary are explicit.

## Allocation recommendation

Do not reserve the whole portfolio.  On authorization, allocate only
Tranche A as two separate Clebsch-lane C-items.  Allocate WP3--WP5 after
the first Tranche A verdict, and allocate sister work separately.  This
keeps the live queue honest and prevents an exploratory map from becoming
thirteen implied commitments.

## Highest-EV next move

Launch WP1 first by a narrow margin.  Its Hom-space and quadratic-minor
tests are cheapest, it could close the only remaining gap in the primary
Segre--Igusa diagram, and either verdict immediately sharpens WP3 and
WP10.  Launch WP2 alongside it only after allocating a second task; its
marked double-six closure has the highest geometric upside.
