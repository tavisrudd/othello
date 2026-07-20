# Adversarial review — Clebsch replacement-spine Lean formalization plan (C420–C428)

**Lane:** crowns

**Date:** 2026-07-20

**Reviewed documents:** `notes/2026-07-20-clebsch-lean-formalization-plan.md` (plan) and
`notes/2026-07-19-clebsch-hexagons-are-the-bestagons-spine.md` (spine), against the C368, C372,
C373, C378, C379, C380, C399, C403, C406, C409, and C411 source reports, the committed Lean
modules under `lean/RelativeConicArcs/`, the live queue rows C420–C428, and the original paper
`papers/clebsch-hexagon-code/clebsch_hexagon_code.tex`.

**Overall verdict.** The plan is sound to proceed with the listed revisions; no blocking defect
was found. Every load-bearing parameter I checked in both documents matches its source report,
and several I recomputed independently (the C411 cubic witness `2((-6)^3+4(-3)^3+6*3^3) = 6` in
`F_11`, the weighted relation `v1+4v2+6v3=0`, both plane equations, the four-endpoint secant
identity on explicit endpoints, the rank-16 valency sum 1331, the norm `-2^8*5` of `16(3tau-4)`,
and the uniform parameter formula `[(q-h/2)(q-h+1),3,(q-h/2-1)(q-h+1)]_q` against exponents
`(1,h/2,h-1)` and `d=n-q-1+h`). The plan's inventory of the existing Lean base is accurate
line-by-line against the committed modules, no slice duplicates existing terminals, and nothing
contradicts the original paper or its prior formalization. The residual risk is concentrated in
three places: the F5 balanced-half uniqueness leaf (the one finite claim in the campaign with no
obviously compact kernel design), the F6 checker-theorem shape (the J-negation and fibre-constancy
statements must not be true-by-construction), and the F7 intersection-tensor obligation (needed
for the Krein consequence but not named as a leaf).

## Errors

Ranked most severe first. I found no mathematical error in the plan itself; both findings below
are in the spine or a source report, and neither propagates into a plan exit theorem.

1. **Spine, "broadest proved story" blockquote and copy-ready opening — the cross-incidence
   design is misnamed.** Spine lines 67–68 ("two `PSL_2(11)`-invariant one-factorizations whose
   cross-incidence is the eleven-point biplane") and lines 446–447 in the copy-ready opening
   (same phrasing). Per C379 item 6 (`notes/2026-07-19-c379-clebsch-deep-hole-extension.md`,
   lines 79–86), the share-an-edge cross-incidence between the two sheets is the symmetric
   `2-(11,6,3)` design; the `2-(11,5,2)` biplane is its complement (the disjointness matrix).
   A `2-(11,6,3)` design is not a biplane (lambda=3). The Hexagon Spine Theorem clause 3
   (spine line 164, "complementary `2-(11,5,2)` biplane cross-incidence") and Side 3 (lines
   257–258, "their disjointness matrix is the `2-(11,5,2)` biplane") state it correctly, so this
   is a wording defect in exactly the two most quotable sentences. Fix before any manuscript use.
2. **C378 report — impossible count of `J`-fixed relations (does not affect spine or plan).**
   `notes/2026-07-19-c378-clebsch-common-duality.md` line 94 says `J` "fixes eight nonzero
   relations and exchanges four pairs" in the rank-16 refinement. With an identity class and four
   exchanged pairs, 8 nonzero fixed + 8 exchanged + 1 identity = 17 > 16. The committed Lean data
   settles it: `ClebschGatewayQ11Fusion.commonJ` (lines 53–57) fixes indices
   `{0,2,4,5,7,8,12,15}` — eight relations *including* the identity, i.e. seven nonzero. The
   spine's "twelve-dimensional fixed algebra" (line 294) and the `12+4` decomposition are correct
   (1 identity + 7 fixed nonzero + 4 pair sums). Correct the C378 sentence to "eight relations,
   including the identity".

Checked and found correct (no action): C406 ranks `3,6,10` agree with the harmonic dimension
count `(2d+1)` plus radial line (`3; 5+1; 9+1`); C372's `Bell(7)=877` census, `P=Q`,
`P^2=1331I`, valencies `1,60,100,120,150,300,300,300`, Krein tensor = intersection tensor, and
exactly two proper fusions (rank 4 and rank 6, incomparable — the spine's branching diagram at
lines 279–284 is right, since `{3}` is not a union of rank-6 blocks); C373's
`Aut = F_11^3 x| (F_11^* x A5)` of order 798600 already on the 60-valent constituent; C411's
mark decomposition `X_+|_K = K/K + K/C3 + K/C2` (I verified uniqueness of the nonnegative
solution to the mark equations for permutation character `(11,3,2)`); C379's `[7,4,4]`
extensions, unique six-on-conic `E7` root, termination, `1,5,6,10` marked quotient, and the
`22 -> 2 -> 1` information levels; C399/C403's `max |B cap L| = q+1-h` and the two
counterexample pairs; C368's `+/-4` minors and characteristic-five determinant boundary; the
q>14 recovery threshold (`N-1=14` for H3); and the six-field ladder `5,9,11,19,29,59` frozen in
`ClebschGatewayA5FourierPhase.lean`.

## Red flags

Ranked most severe first.

1. **F5 balanced-half uniqueness is the one finite claim with no committed compact-checker
   design (plan §C424, lines 109–121; C406 report lines 83–85 and 276–278).** The claim
   quantifies over all complementary halves of the `2q` quotient points: `C(14,7)=3432` cases
   for B3 (kernel-feasible directly) but `C(22,11)=705432` for H3. A "compact certificate leaf"
   cannot carry a universal nonexistence claim by itself; either the checker theorem embeds the
   exhaustion (a raw `decide` at this scale is implausible against the measured C380 leaf costs
   of 1.8–5.4 GB RSS for far smaller enumerations) or the claim stays Python-backed — in which
   case F5's exit "unique complementary halves" is not achievable as worded, and the F6/F8
   composition text that leans on "balanced-sheet recovery" weakens. The stop rule (plan lines
   233–235) covers stopping, but the fallback exit is undefined. Note the rest of F5 is cheap:
   anti-invariance of `mu_3` needs no 220-dimensional linear algebra (it reduces, via the plan's
   own abstract index-two theorem, to the permutation action on the 22 quotient vectors — 22
   ten-coordinate checks — plus sheet parity), and `mu_3 != 0` needs one nonzero coordinate
   (a 22-term sum). The uniqueness exhaustion is the sole heavy piece. See revision 1.
2. **F6's equivariance statements risk being definitional rather than theorems (plan §C425,
   lines 123–139; C411 report lines 98–125).** In C411 the negative-sheet rows are the
   `J`-reversals of the positive rows *by derivation*; if F6 freezes only the six signed profile
   vectors, then `D(JM)=-D(M)` and `K`-orbit constancy become true by construction and the leaf
   silently trusts the Python generator for exactly the geometric content the slice exists to
   certify. A sound design exists and should be mandated: freeze the six representative secant
   unions, the sixteen relation cells, and the `K`/`J` generators as data; prove in-kernel that
   the cells partition the relevant projective sets, are scalar-closed and `K`-invariant, that
   the counts recompute to the frozen profiles, and that `J` maps each representative's secant
   union to its mate's — then derive the sign law. The plan's general contract ("a theorem
   connecting accepted data to the quantified proposition", line 223) covers this in spirit;
   F6 should state it concretely because it is the slice most tempted by sign-by-fiat.
3. **F7's intersection/Krein consequence needs the intersection tensor, which nothing supplies
   (plan §C426, lines 141–149).** C380 deliberately did not formalize the rank-8 or rank-16
   intersection tensors (`notes/2026-07-19-c380-clebsch-gateway-lean-foundations.md`, line 113),
   and `ClebschGatewayA5FourierPhase.lean` contains only rank/stabilizer arithmetic. `P=Q` and
   `P^2=1331I` are derivable from frozen class data via the scalar-line character sum (feasible:
   8 dual representatives x 133 projective lines), but Krein = intersection additionally
   requires the 512 numbers `p^k_ij`, i.e. roughly 512 counts over 1330 vectors with a frozen
   class-label table — at the top of the measured kernel scale and not assigned to any named
   leaf (the table gives F7 only `ClebschSchemeFourierData` + `ClebschSchemeFourier`). Either
   add an explicit tensor leaf or put the Krein clause behind the same "if kernel-feasible"
   qualifier as the census. Positive note: primitivity has a genuinely compact certificate the
   plan should prescribe — for each of the 126 proper nonempty unions of nonidentity classes,
   one witness pair `(x,y)` with `x,y` in the union and `x+y` outside it; that converts
   "if kernel-feasible" into a definite yes for that clause.
4. **F8's completeness alternative needs its concrete kernel route named (plan §C427, lines
   151–163).** The equitable-refinement upper bound certifying
   `|Aut(X)| <= 1331*60*10` runs over a 1331-vertex complete edge-colored graph (~1.77M edge
   colors); as one file this is beyond plausible kernel scale, and the plan already provides the
   external off-ramp. But the "compact affine-rigidity proof" branch also needs the exact
   projective stabilizer `Stab_PGL3(F_11)(hexagon) = A5` (order 60), and the only compact route
   is the frame argument: a stabilizing projectivity permutes the six arc points and is
   determined by four of them, so at most 720 candidates need checking — never an enumeration of
   `PGL_3(11)`. The task brief should name this, since a naive implementation stalls.
5. **Dependency diagram vs ownership table disagree on F6 -> F7 (plan lines 200–215 vs line
   191; queue row C426, `notes/2026-07-07-codex-task-queue.md` line 65).** The diagram and the
   queue serialize F7 after F6, but the table gives C426 no F1–F6 import — its only import is
   the existing `ClebschGatewayA5FourierPhase`. Logically F7 could run in parallel with the
   entire F1–F6 chain. Mark the arrow as dispatch-only (build-queue serialization), or a worker
   will block on a nonexistent logical dependency; conversely, if bounded parallelism is wanted,
   F7 is the natural candidate.
6. **Slice-internal module accounting drift (plan §C425 line 126 vs table line 190; §C423
   lines 101–102 vs table line 188).** F6's narrative promises "the six representative incidence
   leaves" but the table names two (`...Positive`, `...Negative`, presumably three rows each);
   F4's narrative makes the H3 symmetric-cube calculation "its own leaf" but the table names no
   `ClebschFactorizationH3Cube`-style module. Because the sharding stop rule (lines 196–198)
   binds to *named* leaves, this ambiguity has procedural teeth: align narrative and table
   before dispatch.

Trust-boundary assessment of the remaining certificate leaves (no flags): F4's ranks admit
sound compact certificates in both directions (a nonzero 10x10 minor for the lower bound; 22
membership witnesses in a frozen spanning set for the upper bound), and the quotient
construction itself is kernel-checkable (each `P_M - P_0` is a degree-6 ternary form, 28
monomials; verify `= Q * Phi_M` by polynomial arithmetic). F6's group content is small (the
`1+4+6` marks need only the 12-element `K` acting on 22 matchings plus one involution `J`; the
two 11-sheets are already frozen in `ClebschGatewayQ11Matching`). F7's fusion census is 877
cheap 8x8 row-sum tests. The entry boundary is stated plainly: C399 incidence/conic-set
equality, the C398/C400 census data, and the frozen C380 tables remain certificate-backed, and
the plan says so rather than claiming otherwise (lines 26–32, 50–54) — I found no place where
the plan calls externally certified content kernel-backed.

Scope-leakage check: clean. No slice pulls in C374/C375 quantum content, C376 cubic-surface
geometry, or full-group-closure work; F8 explicitly excludes new C207/outside-`S5` research;
F2 keeps the factorized-support census out; F9 treats orbit enumerators/Tutte consequences as
downstream surfaces. Ownership check: clean. All 18 new module paths and 9 gate paths are
absent from the current `lean/RelativeConicArcs/` tree (no collisions); no slice edits a
`ClebschGateway*` module, `ReflectionArrangementDecoding.lean` (present and committed; C222
active), or the stable C380 gate; the spine gate at F8 imports rather than widens
`Gates.ClebschGateway`. Queue check: C420–C428 rows exist, all pegged `[clebsch]`, with
dependency annotations matching the plan.

## Suggested revisions

1. **(F5, highest priority) Pre-commit the uniqueness verification design or split the exit.**
   Either specify a meet-in-the-middle checker theorem now (enumerate the 2^11 moment-vector
   sums over each half of a fixed 11+11 split of the 22 quotient points, with a sorted-join
   soundness lemma; every 11-subset splits uniquely across the two halves, so the join is
   exhaustive), or restate F5's exit in two tiers: kernel tier — B3 uniqueness (3432 cases,
   feasible), both sheets' moment vanishing, and the orientation theorem *conditional on* the
   uniqueness hypothesis; certificate tier — H3 uniqueness, declared Python-backed in the
   verification map. Decide before dispatch, not mid-task.
2. **(F6) Write the checker-theorem obligation into the slice text:** frozen secant unions +
   relation cells + `K`/`J` generators as data; partition/scalar-closure/invariance
   side-theorems; in-kernel recomputation of the six incidence rows; `D(JM)=-D(M)` derived, not
   frozen. Forbid freezing the signed profiles as the only data.
3. **(F7) Add an explicit intersection-tensor leaf (or scope the Krein clause under the
   kernel-feasibility qualifier), and prescribe the 126-witness-pair certificate for
   primitivity.**
4. **(F8) Name the frame-transport bound (at most 720 candidate projectivities via
   four-point determination) as the intended kernel route for the order-60 stabilizer; keep the
   1331-vertex refinement external with its declared boundary.**
5. **(Plan, presentation) Mark the F6 -> F7 arrow as dispatch-order-only; reconcile the F4/F6
   narrative leaf counts with the module table.**
6. **(F1) Check `lean/RelativeConicArcs/Moments.lean` (classical arc secant-index moment
   equations) before writing `ClebschMomentTrade.lean`:** no content conflict — the existing
   file is about unsigned arc/line index moments, F1 is about signed configuration tensor
   moments — but the names live in one namespace and the arc-moment lemmas may be partially
   reusable for F2/F9.
7. **(F6, cosmetic) The composition target is
   `ClebschGateway.Q11Matching.decorated_child_recovers_parent`** (it exists,
   `ClebschGatewayQ11Matching.lean` line 95, wrapping `DecoratedTransform.recovers_parent`);
   cite it fully qualified in the C425 brief so the worker does not search `ClebschGateway.lean`
   for it.
8. **(Spine) Fix the two biplane sentences (Errors item 1)** to "complementary `2-(11,5,2)`
   biplane cross-incidence" or "whose disjointness matrix is the eleven-point biplane".
9. **(C378 report) Correct the `J`-fixed relation count (Errors item 2).**
10. **(Verification map, when F8 lands) Record that spine clause 4's rank-16 statements are
    only partially kernel-backed:** `M_odd^2 = 1331 I_4` and the exchanged pairs are formal
    (existing leaf); `P_16^2 = 1331 I`, the full rank-16 eigenmatrix, and minimality of the
    common coherent refinement remain certificate-backed and are not brought in-kernel by any
    F1–F9 slice. The plan never claims them, but the paper's verification table must not
    conflate the two levels.

## Consistency: plan vs spine

The plan formalizes the spine's replacement chain at the right strength — neither weaker nor
stronger — with three deliberate, documented reductions:

- **Faithful coverage.** Every arrow of the spine's replacement chain (spine lines 16–24) has
  an owning slice: C399 entry (existing terminals), C403 quotient (F2), C406 harmonic/balanced/
  cubic (F3/F4/F5), C409 generic lemmas (F1), C411 double-coset bridge (F6), C378 odd-sector
  composition (F6 + existing fusion leaf), C379 decorated recovery (F6 + existing matching
  leaf), C372/C373 endpoint (F7/F8). The specific quantities match everywhere I checked:
  profiles and fibre sizes `1,4,6 / 1,4,6`, the two plane equations `2a+2b+c=0`, `9a+8b+d=0`,
  rank-two image/dimension-four kernel with set-theoretic separation only, ranks `3,6,10`,
  degrees `1,2,4` over `F_5/F_7/F_11`, the `2r=q+1` boundary, `5/14/22` decorations, and the
  `877`-partition census.
- **Stop rules exactly mirror the claim boundary.** Each "not yet safe" spine item with a
  formalizable shape is excluded by name (plan lines 236–239): cubic uniqueness (the outer-odd
  space is three-dimensional), Hessian/contraction recovery, quotient-point singular recovery,
  linear cubic-to-Fourier intertwiner (C406's scalar-weight obstruction), scheme separability.
  F5's stabilizer claim is correctly bounded to "inside the certified action", matching C406's
  caveat that nothing is claimed about the full `GL(W)` stabilizer. F1 formalizes only the
  bounded C409 lemmas, consistent with C409's own disclaimer that the filtration is
  classical/formal and not universal (a `3`-trade survives no earlier than degree four).
- **Documented weakenings (acceptable, but keep visible):** (i) spine clause 5's cubic-surface
  half (C376 blowdown exchange) stays outside the campaign; only the abstract
  `s5_quotientCharacter_inference` seam is formal (existing). (ii) Spine clause 6 (quantum) is
  excluded wholesale. (iii) Clause 4's rank-16 full self-duality stays certificate-backed
  (revision 10). (iv) C400's all-field theorem is consumed as an arithmetic interface, not
  internalized — exactly what the plan's entry-boundary paragraph says.
- **No parameter, quantifier, or ownership disagreement between the two documents was found.**
  The one wording defect (biplane sentence) is internal to the spine and contradicted by the
  spine's own theorem clause, not by the plan.

## Existing terminals and the original paper (coordinator's added checks)

**Does the plan correctly consume the already-formalized terminals?** Yes. I read all five
gateway modules the plan cites. The plan's inventory paragraph (lines 46–54) is accurate against
the committed files: `ClebschGateway.lean` supplies exactly the typed arc/MDS bridge
(`oneColumnMDS_of_mem_deepTransform`), decorated recovery (`DecoratedTransform.recovers_parent`),
two-sheet character inference (`twoSheetCharacter_eq_of_ker_eq`, `s5_quotientCharacter_inference`),
and orbit-fusion seam (`OrbitClassifier.fuse`); `Q11Fusion` freezes the fusion blocks
`{0},{3},{1,5,6},{2,4,7}`, sizes `1,120,660,550`, `commonJ` with odd pairs
`(1,10),(3,13),(6,14),(9,11)`, and `oddFourier_square : M_odd^2 = 1331 I_4`; `Q11Matching`
proves the 22 fixed-point-free involutions, injectivity, the two 11-sheets, and
`sheet_edge_unique` (one-factorization). No slice re-proves any of this: F6 composes with the
fusion/matching leaves; F7 adds `P=Q` content absent from `ClebschGatewayA5FourierPhase.lean`
(which holds only Burnside/rank/stabilizer arithmetic for the six-field ladder); F8 reuses the
abstract character theorem; F9 adds the weighted-adjoint incidence theorem beyond
`ClebschGatewayCoxeterPhase.lean`'s symbolic identities and frozen `5/14/22` profile. The only
near-miss is F1 vs `Moments.lean` (revision 6) — different content, shared namespace.

**Does any slice contradict or weaken the original paper or its formalization?** No. The paper
(`clebsch_hexagon_code.tex`) owns rigidity, decoding/bipartition, low-degree rigidity, q=11
isolation, and the `A3/H3` arrangement organization; the plan formalizes replacement-spine
content downstream of all of that and edits no manuscript. Numeric interfaces agree
(`|U(K)| = q^2-14q+45 = (q-5)(q-9)`, the H3 complement of C399/C403). One compatibility fact
worth recording: the paper's formal development deliberately axiomatizes two consequences of
Dye's Theorem 1 (`Q11DyeAxioms.lean`, verification section lines 1354–1358), whereas the plan's
gates forbid project-local axioms. This is consistent: none of the plan's declared imports
(`ClebschGateway*`, `CoxeterPhase`, `A5FourierPhase`, `ReflectionArrangementDecoding`) transits
through the Dye-axiom modules, and the C380 aggregate audit reports only
`propext`/`Classical.choice`/`Quot.sound`. Workers must simply not "helpfully" import the paper's
rigidity modules into any F1–F9 terminal, or the axiom audit fails; worth one line in the task
briefs.

## Missed upgrades, unification candidates, and doors opened

Requested addendum. Sources: the reviewed reports plus the crowns discovery track
(`notes/2026-07-17-c294-crowns-discovery-track.md`, read in full; entries cited by date/title).
Every item is marked with its evidence level; nothing here is a novelty or priority claim, and
promotion of any lead goes through the normal C-ID process.

### Free upgrades the Lean campaign can absorb at negligible cost

1. **State F6's pushforward for all degrees, not degrees ≤ 3.** The discovery entry
   "complete parity formula for the compressed moment tower" (2026-07-20) proves
   `M_k = (1-(-1)^k) sum_i n_i v_i^(sym k)` formally for all `k`: every even signed moment
   vanishes, degree one dies by the weighted relation, and the cubic is the first odd survivor.
   The Lean proof is the same three-term identity F6 already formalizes; quantifying over `k`
   costs one induction and yields a strictly stronger exit theorem. CHECKED (formal identity).
2. **Compress the F4/F5 cubic witnesses to a scalar probe.** Discovery entry "scalar cubic
   probes can compress the C406 sheet witness" (2026-07-20): since `q > 3`, `mu_3 != 0` in
   `Sym^3 W` implies its cubic function on `W^*` is nonzero at some functional `ell`, so
   `sum_M epsilon(M) ell(Phi_M)^3 != 0` is a sum of 22 cubes in `F_q` — a one-coordinate kernel
   witness replacing any 220-coordinate tensor comparison. One Python step picks and freezes
   `ell`; the Lean leaf shrinks by an order of magnitude. REASONED existence (from checked
   `mu_3 != 0` + polarization); explicit probe not yet computed.
3. **State F1's affine covariance at general strength `s`.** C409 proves it by one tensor
   expansion for arbitrary `s` (report lines 43–57); specializing to `s=2` in Lean saves
   nothing. The plan's own stop-rule exception ("unless the general proof is strictly cheaper",
   line 237) is satisfied — the general statement is the cheap one. CHECKED (C409).
4. **Add the "unique primitive positive dependence" lemma to F6.** Discovery entry "the profile
   plane intrinsically remembers the `1:4:6` orbit weights" (2026-07-20): `v1+4v2+6v3=0` is the
   unique primitive rational dependence, so the unlabeled three-ray configuration recovers the
   orbit sizes and stabilizer orders `12,3,2`. One elementary integral-linear-algebra lemma on
   data F6 already freezes; it is exactly the hook C413's intrinsic-recovery gate will want.
   CHECKED (exact over `Z`).
5. **Emit the B3 Smith-invariant discriminator from the F4/F6 generators.** Discovery entry
   "index-three integral profile lattice" (2026-07-20): H3's positive-profile lattice has index
   three in its saturation, possibly reflecting the `C3` stabilizer. Printing the B3 analogue's
   Smith invariants is one line in a generator that already exists and settles the
   falsifier-first test the entry prescribes before anyone theorizes. CHECKED for H3; B3 open.
6. **The primitivity witness-pair certificate** (already revision 3): 126 violating pairs
   convert F7's "if kernel-feasible" into a definite yes for that clause. REASONED design,
   trivially checkable.

### General theorems within reach but unallocated (ranked by expected value)

1. **The split/inert/ramified outer-symmetry phase theorem over `Z[tau]`.** The spine's
   refrain (lines 336–374) and C373's research door 1 both point at it; C377 supplies the `J`
   identities and cocycle square, and the spine's claim boundary correctly lists the intrinsic
   all-prime Frobenius action as not yet safe. This is the single strongest unproved
   unification inside the paper's own scope: one descent datum controlling the two `A5`
   representations, the two arc chiralities, the monomial-equivalence obstruction, and the two
   scheme fibres, with the q=5 internalization and a Frobenius-semilinear inert statement. The
   plan defers it correctly; it deserves its own allocation after F8. REASONED, with the split
   and ramified endpoints already certified (C373/C377).
2. **A conceptual balanced-half rigidity theorem.** F5's uniqueness is the campaign's only
   brute-force exhaustion. The statement has a design-theoretic shape: the sheet split is the
   unique partition of the `2q` quotient points into halves whose difference indicator is
   orthogonal to degree ≤ 2 — a minimum-strength-two signed trade supported on one orbit pair.
   A Delsarte/interlacing-style proof (via the certified second-moment form ranks `5/9` with
   one-dimensional radical, C406 lines 145–151) would replace the 705432-case leaf with a
   symbolic one and generalize to any `PSL_2(q)` sheet pair. Adjacent read: the Chien–Kang
   two-orbit design classification already in C406's audit. If it works, F5's red flag 1
   dissolves. REASONED; no proof attempt yet.
3. **Rank-`r` weighted-adjoint enumerator law.** C403 proves the rank-three case; Liang–Wang–
   Zhao own general `k`-adjoints and Cai–Fu–Wang the extension classification. The bounded
   conjecture — the finite-field weighted `(r-1)`-adjoint depth spectrum, punctured at
   mirrors, determines the complement-code enumerator in rank `r` — is well-posed, and C403's
   incidence proof style looks portable. Caution: C403 itself shows depth alone stops sufficing
   for higher *degree*; the higher-*rank* analogue needs its own counterexample search first.
   REASONED conjecture; falsifier-first (one rank-four counterexample hunt) is the cheap gate.
4. **Structural classification of all C400 coherent fusions** (discovery entry, 2026-07-20):
   replace Bell-number partition enumeration by a centralizer/representation-algebra criterion
   reproducing the exact q=5/9/11 lattices. The entry itself flags this as a research
   programme, not a corollary; it is the right successor shape for spine future direction 4.
   OPEN.
5. **Modular (mod 11) identification of the depth map.** Second-order observation from C411:
   `PGL_2(11)` has cyclic Sylow-11, so its mod-11 category is Brauer-tree-controlled, and the
   22-dimensional permutation module `F_11[G/A5]`, the four-dimensional odd Fourier block, and
   the rank-two profile plane with dimension-four kernel all live where decomposition data are
   completely known. Identifying the rank drop with a named Brauer-tree constituent would give
   "cubic-first memory" a modular-representation-theoretic meaning and a second proof route.
   Bounded finite computation; REASONED, unallocated.
6. **A `K\G/H` information-lattice functor.** C403's matching quotient, C406's balanced
   recovery, C411's six profiles, and C379's decorated inversion compose into the exact lattice
   `22 -> 6 -> 2 -> 1`. The portable statement — for a subgroup `H <= PGL_2(q)` transitive on a
   decorated endpoint configuration, the recoverable-information levels are exactly the
   `K`-coset strata for the relevant scalar intersection subgroup `K` — is the natural
   second-paper theorem over the same machinery the campaign is about to formalize. REASONED
   synthesis.

### Doors opened, and standing open problems where progress is plausible

Tiered by strength of the connection; famous-problem adjacency is stated conservatively.

**Genuine new structure contributed now.**

- **Deep-hole classification for MDS codes.** The classification of deep holes of (extended)
  RS codes is a standing open problem area (Cheng–Murray line; the projective case the paper
  already cites as ZWK2020). Our results attack the reverse direction: which *non-GRS* MDS
  codes have deep-hole loci that are themselves arcs/conics/normal curves, when the transform
  terminates, and when a canonical decoration inverts it (spine future direction 2). This is a
  new, well-posed problem family seeded by a proved q=11 instance with a reversible decorated
  transform — a door we open rather than a problem we close. C405's twisted-cubic pilot (and
  its Hermitian near-miss, below) is the live growth direction into `PG(3,q)`, which is also
  the honest statement of any MDS-conjecture adjacency: the program supplies structured
  exceptional objects at the arc boundary, not leverage on the conjecture itself.
- **LU-classification invariants for AME states.** C374's holonomy signature and
  triple-marginal moments are transferable invariants in a field (LU classification of perfect
  tensors) with few tools; the discovery entry "marginal moments may detect nonlinear
  Bell-triangle factorizability" (2026-07-19) sketches the next invariant — a tensor-network
  elimination identity that would either kill nonlinear factorizations at the twenty
  symmetric layouts or prove the symmetry–factorizability tradeoff is a linear artifact.
  STRUCTURAL OPEN, with exact endpoint computations on both sides.

**Bounded, cheap, attractive checks (hours, not weeks).**

- **Mathieu `M_12` adjacency.** The two `PSL_2(11)`-invariant one-factorizations of `K_12`
  exchanged by `J`, with biplane cross-incidence, sit in the classical orbit of structures from
  which `M_12` and `S(5,6,12)` are built. One finite computation: the subgroup of `Sym(12)`
  generated by the two sheet stabilizers (or by `PSL_2(11)` and `J`'s edge action) — does it
  stay `PGL_2(11)`, or generate `M_12`? Either answer is informative for the paper's
  "one object, many languages" frame. REASONED question; not checked.
- **Perfect-one-factorization status.** `K_12 = K_{11+1}` has known perfect one-factorizations;
  checking whether the two invariant sheets are perfect (all 55 factor-pair unions Hamiltonian)
  is a trivial falsifier with either outcome citable in one line. Kotzig's conjecture itself
  gains nothing — say so explicitly if mentioned in the paper.
- **Bring's curve reduction** (discovery entry, 2026-07-19): compute the branch divisors of the
  two `A5`-equivariant trigonal maps and test whether their q=11 reductions are the C368
  deep-hole conic in C376 coordinates. A positive answer welds the finite code phase to
  classical genus-four geometry and strengthens spine Side 5's cubic-surface chord; the entry
  already states the exact falsifier. SOURCE-SPECIFIC OPEN.
- **The `21 < 168 < 6048` Hermitian tower** (discovery entry, 2026-07-20): identify C405's
  certified stabilizers with `7:3 < PSL_2(7) < PGU(3,3)` and test transitivity on the 36
  determinantal classes of the `F_9` Hermitian quartic. If it holds, the q=9 near-miss becomes
  a finite-field Cayley-octad theorem and the deep-hole program acquires its first
  genus-three/bitangent interface. CHECKED ORDERS / REASONED IDENTIFICATION.

**Adjacency to recognition-theoretic problem areas.**

- **Separability/CI and coherent-configuration recognition.** The rank-eight scheme fails the
  standard TI and quasiregular criteria (discovery entry "Separability/CI beyond the failed
  standard criteria", 2026-07-20), so a separability proof would need a genuinely new
  orbit-sensitive argument — a small worked instance of the recognition questions central to
  coherent-configuration theory. Related laboratory: all six-arc direction graphs in
  `PG(2,11)` are cospectral (four eigenvalues `k(q-1), 2q-k, q-k, -k`) while graph isomorphism
  recovers the arc and the chirality torsor (C373) — an explicit spectrum-vs-WL separation
  family for the inverse-spectral and WL-dimension literature. OPEN WITH NEGATIVE BASELINE.
- **Modular Hecke bimodules.** Via the mod-11 identification above: which `K\G/H` depth maps
  in nonsemisimple characteristic have canonical rank drops, and what do the drops measure?
  C411 is a complete worked example waiting for the general question. REASONED.

**Cross-lane unification (from the discovery track; log only, no scope expansion).**

- The entries "conic continuation as a shared-helper repair-port conflict game" (2026-07-17)
  and "C210 sharpens the common carrier and redundancy question" (2026-07-18) identify one
  carrier — off-conic centre, projection involution, conic matching, pointed repair port,
  binary quadratic form — across the cap/relconic/complete-ports/games programs. C403's
  matching quotient now adds the code-theoretic face of the same carrier: the four-endpoint
  switch kernel is literally the local move in those matching superpositions. The strongest
  question stands as logged: a multi-target port invariant preserving game value under
  superposition. SYNTHESIS; owned by its lanes, not by this campaign.
- Negative guardrails worth remembering when tempted by lattice-level unifications: the
  `132+3=135` `E8/D8` fit is representation-theoretically impossible for full `PGL_2(11)`
  equivariance (retired entry, 2026-07-19), and C382 closed the icosian path-independence
  route; the surviving bounded residue is the fixed-parent mod-two `D8` avatar question
  (open entry, 2026-07-19).

**Explicitly no claimed leverage:** the Hadamard conjecture (the `2-(11,5,2)`/Paley adjacency
is decorative), Kotzig's conjecture, and the MDS conjecture itself. If the paper mentions any
of them, it should be in exactly this dismissive register.

### Transfer to C294 and the cap lane's odd-q all-P kernel (user-requested)

Cross-lane analysis only; C294's silver classification and the `cap` lane own any follow-up.
Grounding reads: `notes/2026-07-17-c294-full-conic-continuation-crown.md` (result statement) and
the cap handoff's "Even Projective Dimension Over Odd Fields" section.

- **C294, direct object overlap: none at q=11.** C294's `Theta(q)` family requires
  `p ≡ 3,7,23,27 (mod 40)`; `11 ≡ 11`, so no C294 board is Clebsch-adjacent. The transfers are
  method-level, and three are concrete:
  (i) *Double-coset/marks compression of game values* — C411's technique (subgroup marks give
  orbit sizes; one representative evaluation per `K\G/H` class) applies verbatim to nimber
  computation on C294 residuals, whose positions are `Stab(S_b)`-invariant; this is the natural
  engine for the open silver classification. REASONED.
  (ii) *Pairing-forgetting for game values* — C403's four-endpoint switch generates all
  matchings on a fixed endpoint set with plane lifts in the conic ideal; the discovery track's
  multi-target port question (entries 2026-07-17/18) becomes a sharp falsifier-first test: does
  any single switch change a C294 residual nimber? If never, values factor through endpoint
  supports exactly as sections do. REASONED, cheap to falsify on small `q`.
  (iii) *Systematic normalizer-involution pairing* — the C388 lemma (fpf nonadjacent involution
  in the normalizer gives nimber zero) plus C403's stabilizer-stratified census template
  (diagonalize one representative per conjugacy class, sort fixed loci by depth — the proof is
  generic in the finite subgroup, not Coxeter-specific) yields a uniform inventory of candidate
  pairing involutions per residue class, matching the arithmetic-progression shape of C294's
  family. REASONED.
- **The plane cap game's move operator is already formalized.** At an arc position `A`, the
  legal moves are exactly `deepTransform A`
  (`ClebschGateway.oneColumnArcExtension_iff_mem_deepTransform`,
  `lean/RelativeConicArcs/ClebschGateway.lean` lines 43–47). The deep-hole program is, read
  game-theoretically, an endgame theory for the odd-`q` plane kernel: C379 gives the complete
  move fan at the Clebsch position (twelve moves, each to a `[7,4,4]` seven-arc), the companion
  arcs paper's completeness-outside-the-conic theorem prunes that subtree, and C399's
  complement law plus C403's stabilizer-stratified orbit tables are exactly the
  canonicalization data an orbit-canon solver (the `PG(4,3)` C43 style) needs to push an exact
  `PG(2,q)` solve to larger odd `q` — the cheapest new evidence for or against all-P on the
  stated main open kernel. Terminal positions are complete arcs, so the census infrastructure
  (frame-normalized enumeration, C398-style) enumerates terminal parities; note `q` odd makes
  the conic terminal even (`q+1` points), so odd-size complete arcs are the structures that
  would threaten a parity-based P argument. REASONED synthesis; no solve attempted.
- **One structural fact worth recording in the cap lane if not already there:** `PG(2,q)`
  admits no fixed-point-free element of even order in `PGL_3(q)` — a fixed-point-free
  projectivity has irreducible characteristic polynomial, hence lies in a Singer torus of odd
  order `q^2+q+1` — and Baer involutions fix a subplane. So the mirror/involution route is
  structurally impossible in the plane (consistent with C32's refutation), and the transfers
  above are of the correct non-mirror shape. CHECKED (elementary), stated here because it
  delimits which Clebsch tools can possibly help: orbit compression and endgame geometry, not
  pairing symmetry.

## What I could not verify

- **The frozen finite data itself.** I checked internal arithmetic consistency of the C406/C411
  profiles, plane equations, and cubic witness by hand, but did not rerun any Python checker or
  replay; the geometric correctness of the frozen incidence rows, matching tables, and orbit
  labels rests on the reports' committed primary/replay bundles and hashes.
- **Kernel feasibility judgments.** My scale assessments (F5 H3 uniqueness, F7 tensor, F8
  refinement) extrapolate from the C380 measured leaf costs (1.8–5.4 GB RSS) and the sharded
  `Q11A5PointOrbits*` precedent; none is a measurement. The plan's per-leaf stop rule is the
  right control; my flags identify where it is most likely to fire.
- **C374/C375 content** (450-entry holonomy signature, LC/LU separation, circuit family):
  outside the plan's scope and not read; spine clause 6 is taken on the reports' word.
- **C398/C400 external census data** behind `ClebschGatewayConicDeepHole.lean` and
  `ClebschGatewayA5FourierPhase.lean`: consumed as declared certificate interfaces; not
  re-derived.
- **C222's terminal shape.** `ReflectionArrangementDecoding.lean` exists and is committed, but
  C222 is active; F9's assumption that a stable "committed public terminal" for the A3/H3
  specializations will exist is a scheduling dependency I could not evaluate.
- **The original paper beyond its abstract, introduction, and verification architecture**
  (sections 2–8 were inventoried, not line-audited); no contradiction surfaced in the parts
  read.
- **Literature/priority claims.** The spine's bounded-priority language matches the C406/C411
  audits' qualified verdicts as written; I did not re-run any search or citation closure.
