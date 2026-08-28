# C973 — simultaneous-marker PRS escape and all-level Lucas discriminator

**Lane:** `reed-solomon` · **Status:** active — arbitrary-`r` escape proved;
the multi-digit carrier module theorem is proved, characteristic seven is
pointedly closed, and exact GF(16)/GF(32) pointed quotients close binary
R11/R12 there; GF(64) is structurally closed; GF(27) and external review remain
open

**Current checkpoint:**
`c973-2026-08-28-gf27-switch-probe.md` is a bounded calibration of the
GF(27) two-point affine-plane switch, not a census-based closure: exhaustive
over every carrier class with quotient rank at most one (the wild
Frobenius-graph fibre, the off-graph fibre, and the kernel plane) and a
20,000-class sample of rank two, no class has fewer than 78 good switches
among 1404 candidates.  The three Frobenius-conjugate planes through each
removed line suffice everywhere measured; the distinguished `lambda=1` plane
and the one-point sections do not.  The 27 minimizers are exactly the upper
unipotent translation orbit of `e_3`, with the constant profile
`1326/156/546/78` (nonsingular, zero discriminant, split-distinct, good), so
the remaining lemma is a translation-invariant statement whose extremal
case is one explicit syndrome.
`c973-2026-08-27-carrier-nucleus-compression.md` identifies every maximal
adjacent-zero carrier `C_d` with the penultimate osculating nucleus
`N^(d-1) Gamma_(d+1)`.  At prime-power `d=p^s`, projection from that nucleus
is the Frobenius graph `[1:t:t^d:t^(d+1)]` on a split quadric, unifying the
first binary and ternary higher carriers.  The remaining carrier arithmetic
is intrinsically a pointed rational secant-saturation problem; GF(27)/R11 is
its first open nine-affine-secant instance.
`c973-2026-08-26-simultaneous-marker-theorem.md` proves direct composite
lifting, a degree-six Vandermonde selector, unconditional arbitrary-`r`
containment at
`6r-16+floor(2 sqrt(6r-18))`, its sharper binary refinement, and a fixed-`r`
witness-abundance lower bound.  The companion
`c973-2026-08-26-first-lucas-boundary.md` computes the exact R11 carriers in
characteristics `2,3,7`, closes the binary block for `q>=128` and the
nonpersistent characteristic-three block for `q>=81`, and closes the
characteristic-seven block for `q>=343` by a pointed R9 slice.  The same
report computes R12: its new characteristic-five block is transverse and
shallow outside the persistent locus for `q>=125`; the `2/3/7` blocks reduce
to one-extra-root versions of the R11 constructions.  The manuscript-frozen
`c973-2026-08-26-paper-successor-map.md` gives exact replacement statements,
the deletion/retention map, frontmatter and trust updates, and a target net
reduction of 2--5 pages for a separately allocated integration successor.
The author-side audit and explicit `ej`/`tt` mystery closeout are
`c973-2026-08-26-hostile-proof-audit.md` and
`c973-2026-08-26-sprint-closeout.md`.
The user-requested second Tao pass and its action gates are recorded in
`c973-2026-08-26-tao-second-pass.md`.  The two load-bearing arguments are
reconstructed in `c973-2026-08-26-two-seam-reconstruction.md`: the elementary
reductions pass, while five inherited geometric/counting inputs are explicitly
left for external reconstruction.  Finally,
`c973-2026-08-26-deterministic-selector.md` proves successive symbolic marker
selection using at most `(r-5)q` partial-specialization tests at fixed
redundancy.  `c973-2026-08-26-software-leverage.md` maps this into a certified
fast negative locator path and a separately gated parameterized R11+
classification route for the Projective Reed--Solomon Toolkit.  The
second-sprint verdict and revised mystery ledger are in
`c973-2026-08-26-second-sprint-closeout.md`.  C974 implemented and typed that
arbitrary-redundancy simultaneous locator.  Its C973 application is recorded
in `c973-2026-08-26-characteristic-seven-closure.md`: seven orbit-normalized
q=49 certificates make the R11 and R12 characteristic-seven carriers
pointedly shallow, while a strengthened R9 selector propagates through R13.
The unifying result is
`c973-2026-08-26-one-carry-module-theorem.md`, which identifies every carrier
with `r-2=p+a`, `0<=a<=p-3`, as the standard projective module
`P(Gamma^(p-a-3) E)`.  Consequently the only possible R11 modular exceptions
are now `q in {16,27,32,64}`; further level-by-level work is intentionally
deprioritized in favor of the multi-digit module theorem.  That theorem is now
proved in `c973-2026-08-26-digit-stripping-exact-sequence.md`: both the Pascal
nucleus and maximal carrier admit coupled least-digit exact sequences with
explicit determinant, divided-power, and Frobenius-twist factors.  The
remaining all-level gate is arithmetic transport of pointed witnesses through
those extensions, not identification of the carrier module.
The 30-minute continuation, structural/computational boundary, software
interface, explicit `ej`/`tt` pass, and revised mystery ledger are summarized
in `c973-2026-08-26-third-sprint-closeout.md`.
Preliminary literature positioning is in
`c973-2026-08-26-module-literature-preaudit.md`; it treats the module
filtration as likely classical pending full-text comparison and reserves the
PRS pointed-abundance application as the substantive open research claim.
The digit theorem's author-side seam review is
`c973-2026-08-26-digit-stripping-hostile-audit.md`; independent specialist
review remains required.
The cofinite-support transfer is proved in
`c973-2026-08-26-cofinite-grs-transfer.md`.  For a GRS support obtained by
deleting `s` projective evaluation points, it gives the pointed threshold
`6r+6s-16+floor(2 sqrt(6r+6s-18))`, an `r-2` locator avoiding every deletion,
and, in large characteristic, the exact distance-`r` and distance-`r-1`
shells and their counts.  In every characteristic it also converts the
digit-stripping dimension formula into an explicit upper bound for the
entire next-to-deep population.  The full-affine deep shell is classical in this
high-rate range; the next-to-deep shell and constructive separation require
a claim-specific prior-art audit.  Generic LDPC does not inherit the theorem,
but RS-local Tanner and lifted-code compatibility is recorded as a separate
open direction.
Its scoped primary-source comparison and exact no-novelty boundary are in
`c973-2026-08-26-cofinite-grs-literature-preaudit.md`.
The subsequent Tao pass is
`c973-2026-08-26-cofinite-grs-tao-pass.md`; it proves the universal identity
for a one-column extension and its GRS specialization
`d(ker[H_S|f])=d_S(f)+1`, upgrading the top-shell result to an exact
classification of MDS and NMDS one-column extensions.  It also isolates the
family-wise minimum-word/support count as the next enumerator gate.
That gate is closed in
`c973-2026-08-26-family-wise-minimum-support-count.md`: individual extension
columns are exact additive or cyclic-group subset-count problems, while a
double count gives configuration-free family aggregates and hence aggregate
minimum-word counts.  Arbitrary-deletion evaluation is exposed as a typed
group-DP software follow-up, not added to the frozen toolkit here.
The next exact arithmetic bridge is
`c973-2026-08-27-r11-gf16-pointed-closure.md`: normalizing the prescribed root
to infinity reduces the full GF(16) R11 carrier to 317 upper-Borel orbits.
All 317 have independently replayed finite locators (307 of degree nine and
10 of degree eight).  Hence GF(16) leaves the possible R11 modular-exception
set, and one-marker lifting also makes the GF(16) binary R12 carrier shallow.
The same marked-root quotient at GF(32) is closed in
`c973-2026-08-27-r11-gf32-pointed-closure.md`: all 1,129 upper-Borel orbits
have independently replayed degree-nine locators.  Hence GF(32) also leaves
the R11 exception set and its binary R12 carrier is shallow.  The exact
remaining R11 fields are GF(27) and GF(64).  A structural-compression audit
finds 795 affine support types and proves that the natural affine-three-space
plus one-root family misses 503 of the 1,129 GF(32) marked orbits.  The next
binary proof gate is therefore pointed avoidance inside the full C620
final-pair trace cover, not a small support atlas or a GF(64) in-memory census.
That reduction is now exact in
`c973-2026-08-27-gf64-pointed-trace-gate.md`: after the coherent contraction
`z2=0`, ramified pole counting leaves at most 48 bad rational points on the
genus-at-most-one final-pair curve, versus the GF(64) Hasse lower bound 49,
provided its quadratic final-product numerator `N(x)` is rootless.  This is
equivalent to one explicit Artin--Schreier trace bit on the five fixed roots.
The coefficient-space half of that gate is now proved in
`c973-2026-08-27-gf64-trace-balance.md`: on every chart with
`B3(B2^2+B1B3)!=0`, exactly half of the `B0` values make `N(x)` rootless.
The remaining binary operation is to realize that balanced direction inside
a split-quintic chart while retaining the C620 selector, plus the explicit
degenerate chart beginning at `e7`.  A binary-quartic slope pencil gives a
conditional exact realization with 32 rootless parameters versus at most 23
selector/zero exclusions, but it is not universal: the dense syndrome
`(1,1,1,1,1)` forces the slope quartic's constant and linear coefficients to
zero.  The next structural gate is the full one-variable trace function (or a
second split direction) on that forced-root stratum.
The dense obstruction now has its own structural chart: a normalized affine
two-space plus one root reduces rootlessness to a genuine cubic
Artin--Schreier trace with at least 24 good parameters, again exceeding the 23
selector/zero exclusions.  Taking the explicit `beta=1` chart makes the
moving-root denominator linear; at least 15 parameters survive the exact
trace/collision exclusions, and the resulting genus-zero curve has 65 points
against at most 45 deletions.  Thus the dense forced-root syndrome is
pointedly closed without a certificate.  The remaining GF(64) work is to
cover the other slope-degenerate strata by the balanced or cubic-trace charts.
The rigid slope pencil's entire forced-zero locus is now the explicit surface
`(1,u,v,u^3,u^4+v^2+u^2v)`.  The dense point `(u,v)=(1,1)` is closed above;
the next trace calculation is two-parameter only.  On that surface the whole
slope pencil factors through `t(t^2+ut+u^2+v)`, giving an exact
`1953+2016+63+64` split/irreducible/zero-root/double-root stratification.
Moreover, padding the split quadratic by seven points from an affine
three-space minus one point is structurally impossible: the two Hankel
equations force the subspace polynomial's nonzero linear coefficient to
vanish.  This removes another certificate-shaped support atlas from the
remaining search.  The marked torus acts by `(u,v)->(cu,c^2v)`, so the
surface has only 64 forms `(1,tau)` plus two `u=0` boundaries.  The entire
63-point curve `v=u^2` is the single `tau=1` form and is already closed by
the dense genus-zero calculation.
At the endpoint `(u,v)=(0,0)`, naively reusing that dense affine plane is
exactly impossible: after an explicit Artin--Schreier change, the final-pair
cover is `y^2+y=1/(a+1)`, while final-quadratic rootlessness requires that
same constant to have trace one.  Reversing the trace choice closes the
endpoint: trace zero splits the cover into two rational lines with 130
points, while all collisions including the two roots of `N` delete at most
54.  The remaining forced-root surface is now the 63 generic `tau!=1` forms
and the single `(0,1)` boundary.  That last boundary is also closed: taking
the added root in `GF(8)` with `a^3+a+1=0` gives a genus-one curve with 12
points over `GF(8)`, hence 72 over `GF(64)`, against 52 pointed deletions
including `N=0`.  Only the 63 generic `tau!=1` forms remain on the surface.
Among them, the six roots of `tau^6+tau^5+1` form another constant-cover
stratum: taking the added root `a=tau` forces `B0=0` and a trace-zero constant
cover.  Two rational lines again give 130 points against 54 deletions.  The
forced-root surface is down to 57 `tau` forms.
The specialization `a=tau` has a fully factored trace-zero locus.  It closes
nine more noncolliding roots, and `tau=0` reuses the endpoint argument.  The
surface remainder is exactly 47 forms: 42 trace-one values, the three roots
of `tau^3+tau^2+1` where `a=tau` collides with `H`, and the two roots of
`tau^2+tau+1` where its denominator vanishes.
Frobenius compresses those 47 values to nine semilinear cases: seven
irreducible sextics, the collision cubic, and the denominator quadratic.
Cross-ratio transformations cluster the seven sextics as `4+3` arithmetically
but do not act on the ordered pointed contraction problem: its residual torus
fixes `tau`, and a new marker depends on parent-syndrome data lost under
contraction.  Nine is therefore the sharp proved symmetry quotient.
The cubic and quadratic residual orbits are now closed by subfield elliptic
specializations with `a=tau+1`: their curves have respectively 12 points
over `GF(8)` and 6 over `GF(4)`, hence 72 and 54 over `GF(64)`, both above the
52-point budget including `N=0`.  Only the 42 trace-one values, seven
Frobenius sextics in one common genus-one family, remain.
The selector on that family is now proved nonzero: its pseudo-remainder has
leading coefficient `tau(tau+1)^3(tau^3+tau+1)^3`, which never vanishes on a
trace-one form.  Parity sharpens Hasse from 49 to 50 points.  Unless both
finite poles and infinity are rational, this yields at least 24 rootless
parameters against the 23-parameter selector/zero budget.  The simultaneous
exception is exactly the two sextics `tau^6+tau+1` and
`tau^6+tau^5+tau^4+tau+1`.  Thirty values close uniformly; only their twelve
roots remain.
The final one-point deficit is closed by a uniform torsion lemma.  Every
generic trace-zero companion is the Berlekamp sign-resolvent of the same cubic
pencil.  Its connected triple-root-free Galois root cover is an étale cyclic
cubic cover.  Its rational deck translation has order three, and the two
isogenous genus-one curves have equal finite-field point counts.  Thus all
seven sextics acquire rational order three at once, with no semilinear case
split.  The rootlessness twist has order `1 mod 3`; parity
and Hasse force at least 52 points, or 24 rootless parameters after removing
the two pole fibres and infinity.  This beats the 23-parameter selector budget
without a point-count certificate.  Explicit quartic divisors on the two
worst fibres remain as an independent audit in
`c973-2026-08-27-gf64-trace-balance.md`.
The isogeny core is characteristic-free.  The first GF(27) discriminator is
therefore a connected separable `S3` cubic carrier with genus-one sign cover
and no 3-cycle inertia; the binary Artin--Schreier coordinates themselves do
not transfer.
The first ternary carrier chart is now explicit in
`c973-2026-08-27-gf27-three-line-reduction.md`.  Two parallel affine
`F3`-lines plus one transverse line give a degree-nine split locator, and the
two Hankel equations reduce to a `2x2` linear solve in two elementary
parameters.  What remains is a one-parameter tower of two linearized-cubic
image conditions and one quadratic split condition, with two explicit
collision factors.  The dense determinant loses at most one parameter;
rational abundance is open.  The exact upper-Borel action now moves every
syndrome with `(z3,z6)!=(0,0)` into the dense chart.  Thus the true separate
boundary is only the invariant five-space `z3=z6=0`; its residual unipotent
action leaves three affine normal-form charts and one two-coordinate torus
endpoint.  The endpoint has four torus square-class orbits, all closed by
explicit products of three affine-line cubics.  The `z7` residual chart has
relative torus weight five and hence only two orbits; two further explicit
three-line products close both.  In the `z5` chart, the entire `z4=0` slice
closes uniformly as three parallel lines, while the complement reduces to
the torus invariant `lambda=(z4/z5)^2(z7/z5)`.  Frobenius has eleven orbits
on that parameter line; eleven explicit transverse products close them.
The `z8!=0` chart's `z4=z5=0` endpoint has only three torus orbits, all now
closed.  Its exact residue is `z5=1` with two affine coordinates, or
`z5=0,z4 in {1,nu}` with one affine coordinate.  Only those strata and the
dense abundance problem remain.  On those `z8` strata the determinant factors
as `p(ra+b)(pa-b)`, excluding at most two directions and no `u`; the condition
`s in W_r` is generically an affine-plane intersection of exactly three
points.  The residual gate is only the quadratic split and collision tests on
that three-point line.  More globally, the affine-plane locator
`t^9+gamma^6 t^3+gamma^8 t+C` closes every Borel-boundary syndrome with
`(z2,z4)=(0,0)` and the nonsquare-ratio half of all nonzero `(z2,z4)`,
independently of `z5,z7,z8`.  On the complementary ratio, a one-point switch
is structurally rank one and cannot help, while a two-point switch gives two
independent vectors `(x1,1),(x2,1)` and solves both Hankel equations uniquely.
The entire Borel residue is thereby reduced to one explicit quadratic split
and a seven-point collision test, with no trace-plane covers left.  The
quotient recurrence extends this verbatim to arbitrary `z3,z6`: two quotient
vectors form an explicit `2x2` matrix, and its unique solution again produces
one replacement quadratic.  Thus dense abundance and the Borel boundary now
share one universal split-switch gate; the cubic-cover tower is retained only
as an independent audit.  A degree-six coset argument proves that the switch
matrix is nonsingular for some pair in every fixed affine-plane direction.
Only splitting of the replacement quadratic and collision against the seven
retained plane points remain.

## Objective

Replace the stagewise one-step lower-package hypothesis in the Beyond Four
projective Reed--Solomon theorem by a direct simultaneous-marker argument, prove
the strongest resulting arbitrary-redundancy split-free/deep-hole theorem, and
determine how far the same method reduces the remaining small-characteristic
problem to an explicit classification of the maximal Lucas carrier.

This is a mathematics, proof, and theorem-boundary task.  It does not edit the
manuscript.  If the theorem succeeds, manuscript integration, compression,
verification-map changes, and release review belong to a separately allocated
follow-up C item.

## Primary theorem target

For redundancy `r >= 6`, put `m = r - 5`.  For a degree-`m` marker form `R`,
define the composite contraction

\[
  \kappa_f(R)=\iota_R f\in\Gamma^4E.
\]

Prove directly that, outside the exact reduced carrier

\[
  \mathcal P_r\cup\mathcal M^{\max}_{r,p},
\]

there is a completely split squarefree `R` over `F_q` for which the terminal
redundancy-five system has a split squarefree cubic avoiding every root of `R`.
The direct contraction identity must then lift their product to a split
squarefree degree-`r-2` member of `W_f`, without invoking any intermediate
one-step lower package.

The desired numerical consequence is an unconditional containment

\[
  \operatorname{SplitFree}_r(\mathbb F_q)
  \subseteq
  \mathcal P_r(\mathbb F_q)\cup
  \mathcal M^{\max}_{r,p}(\mathbb F_q)
\]

for an explicit linear-in-`r` field threshold.  First try to retain

\[
  Q_r=6r-15+\lfloor2\sqrt{6r-17}\rfloor;
\]

if the simultaneous rational-selector bound forces a larger constant, prove
the sharpest honest bound and isolate exactly what would be needed to recover
`Q_r`.  When `p > r-1`, combine the containment with the already imported
Seroussi--Roth--Dür radius gate to obtain an unconditional arbitrary-redundancy
tangent/conjugate-secant deep-hole classification.

## Proof programme

### 1. Composite contraction and direct lifting

- Define contraction by an arbitrary binary form `R`, including the infinity
  chart and base change, and prove
  `g in W_(iota_R f)` if and only if `R g in W_f`.
- Treat zero or rank-deficient composite contractions explicitly; do not hide
  them behind a projectivized rational map.
- Prove that squarefreeness of `R g` is exactly squarefreeness of both factors
  plus root avoidance.  Intermediate marker collisions must disappear from the
  logical interface rather than be silently retained.

### 2. Global terminal selector

- Use C820's marker-catalecticant row-space theorem to identify the closure of
  the composite-contraction image with the projectivized row space of
  `Cat_(m,4)(f)`.
- Pull back the complete reduced R5 terminal carrier, characteristic by
  characteristic: the Hankel determinant plus the generic projected Veronese,
  the characteristic-two cyclic plane, or the characteristic-three wild cone.
- Prove the exact converse needed for escape: if every geometric split
  squarefree marker form lands in that terminal carrier, then
  `f in P_r union M^max_(r,p)` (including the rank-one, fixed-gcd, and collision
  boundaries at their correct logical locations).
- Construct an explicit nonzero selector on the split-marker parameter space
  outside that carrier.  Record its total degree, its degree in each ordered
  root, its behavior on diagonals and infinity, and the exact characteristic
  specializations.  No unspecified genericity clause is an exit gate.

### 3. Rational split-marker selection

- Prove a finite-field selection lemma for a nonzero symmetric/multiaffine
  selector on ordered distinct rational roots.  Compare coefficient-space
  counting, ordered-root grids with disjoint value blocks, and a direct count
  of rational split squarefree binary forms.
- Keep the selector bound separate from the terminal curve bound.  Establish
  whether it lies below `Q_r`; if not, identify the precise degree term that
  dominates and attempt to remove it.
- Do not replace this proof by an unstructured field census.  Small exact
  computations are permitted only as falsification tests or as compact
  certificates below a theorem-derived bound.

### 4. Terminal escape and arbitrary-r synthesis

- Apply the exact R5 quadratic-graph and `S_3` fiber-square packages to the
  selected terminal syndrome.
- Charge all retained roots at once.  The target deletion is
  `12 + 6(r-5) = 6r-18`, with every branch, diagonal, singular, marker, and
  fixed-factor contribution accounted for.
- Lift the terminal cubic directly by `R`; prove the unconditional split-free
  containment theorem and then the large-characteristic code theorem through
  the separate radius gate.
- Check R6--R10 as specializations, distinguishing a theorem-generated result
  from the existing sharper fixed-level or finite-certificate rows.

### 5. Quantitative witness abundance

- Count good ordered marker tuples and terminal split cubics rather than merely
  proving one exists.
- Divide by the exact multiplicity with which a degree-`r-2` split locator is
  represented by marker/terminal-root partitions.
- Seek an explicit lower bound for the number of split squarefree members of
  `W_f` outside the carrier, with the R5 exact count as its terminal case.
- State clearly whether the result is an exact identity, a lower bound, or a
  fixed-`r` Chebotarev/Weil asymptotic.  Record any algorithmic consequence for
  sampling or decoding, but do not edit C969/C970-owned code in this task.

### 6. Maximal Lucas-carrier discriminator

Once transverse escape is unconditional, make the sole remaining
small-characteristic problem explicit:

\[
  \mathcal M^{\max}_{r,p}(\mathbb F_q)
  \cap\operatorname{SplitFree}_r(\mathbb F_q).
\]

- Express the carrier by adjacent zero runs in Pascal row `r-2` and organize
  it by the base-`p` digits of `r-2`.
- Determine whether the R6/R7 binary families are the only infinite modular
  split-free exceptions, or exhibit the first genuine higher counterexample.
- Generalize the subspace-polynomial, projective-subline, and final-pair
  Kummer/Artin--Schreier constructions where the equations justify it.
- A positive all-level theorem is the gold exit.  A sharp counterexample or a
  proved obstruction that reduces the problem to an explicit new arithmetic
  cover is an authorized obstruction exit, but it must state the exact first
  unresolved Lucas block and cannot be replaced by a list of tested fields.

## Literature, proof, and evidence gates

- Before a novelty or priority verdict, run the dedicated current literature
  audit required by `notes/literature-audit-conventions.md`.  Wang's splitting
  families, Wang--Wu--Hu's projective-subline endpoint, normal-rational-curve
  nuclei, and the twisted-cubic line-incidence literature remain inputs at
  their already recorded boundaries.
- Before a paper-facing computational claim, follow
  `notes/research-reproducibility-conventions.md` and commit the report,
  generator, compact certificate, hashes, and independent replay together.
- Any Lean edit, generator run, build, or staleness probe requires reading and
  following `lean/AGENTS.md`; no Lean work is required merely to close the
  mathematical theorem.
- Before developing a nontrivial proof, consult only the routed applicable
  named-expert dossiers required by the workspace guide.

## Acceptance and stop rules

The task must produce a dated theorem/proof report with:

1. exact composite-contraction definitions and direct-lifting proof;
2. a complete characteristic-wise terminal-selector theorem;
3. a proved rational split-marker selection bound;
4. an unconditional arbitrary-r split-free containment theorem, or a precise
   proved obstruction showing why simultaneous selection cannot supply it;
5. the strongest justified large-characteristic deep-hole corollary;
6. the quantitative witness-count theorem or a documented exact obstruction;
7. the all-level Lucas verdict at the strongest proved boundary;
8. independent specialist review of the load-bearing geometry, finite-field
   selection, and coding promotion; and
9. an explicit `ej` plus `tt` closeout with a mystery ledger.

No ambient `PG(r-1,q)` census, fixed list of R11/R12/R13 experiments, or
restatement of C820's carrier theorem counts as progress on the primary gate.

## Paper-successor interface — no manuscript edits in C973

If the simultaneous-marker theorem succeeds, the final C973 report must give a
paper-integration map detailed enough for a separately allocated successor to
edit without reconstructing the research:

- the exact replacement statements for the current Theorems 1.1, 5.14, and
  6.4, including hypotheses, thresholds, radius boundary, and proposed stable
  semantic labels;
- which parts of Sections 5--7 become obsolete and which lemmas remain needed;
- which R8/R9 pointed-package proofs and R10 stage-budget arguments can be
  deleted, and which modular-carrier calculations or sharper finite-level
  thresholds must remain;
- how the quantitative witness theorem should replace or extend the current R5
  Chebotarev discussion and connect to the companion classifier without
  broadening its theorem registry prematurely;
- how the fixed R5--R10 results should be recast as corollaries and finite-field
  calibrations of the arbitrary-r theorem;
- the required updates to the abstract, introduction, reading map, scope/open
  problems, theorem map, formalization ledger, evidence registry, and
  verification boundary;
- a deletion/addition page-budget estimate showing how the stronger theorem
  reduces or preserves manuscript length; and
- every new literature, formal, computational, and external-reader gate the
  paper successor must run.

The paper successor must receive a newly reserved C ID.  C973 must not edit
`papers/beyond4_prs/`, its standalone mirror, public release metadata, the
software subtree, or any Version 1 artifact.

## Owned paths

- `notes/reed-solomon-tasks/c973-*`
- task-owned compact proof probes and certificates under a
  `notes/reed-solomon-tasks/c973-*` path, subject to the reproducibility gate
- the `reed-solomon` discovery track only for genuinely incidental findings
- the live queue and handoff only for C973 state transitions

All C915, C969, C970, manuscript, supplement, software, Lean, mirror, and
release paths are foreign unless a later explicit instruction expands scope.
