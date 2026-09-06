# Proof and claim audit

## Analytic claims proved in the paper

1. The first and second secant-index equations are proved by direct double counting and identified as classical.
2. The prescribed-hole defect formula is an exact identity, not an estimate:
   \[
   m\Delta_H(A)=
   \sum_{x\in X_H(A)}(r(x)-1)(m-r(x))+
   \sum_{y\in H}r(y)(m-r(y)).
   \]
   On required points, its first sum is exactly \(m\) times the slack in
   \[
   \mathbf 1_{\{r>0\}}\le r-\frac2m\binom r2,\qquad 0\le r\le m,
   \]
   whose positive-index equality cases are \(r=1,m\). Thus “sharp two-moment
   certificate” in the manuscript refers to this pointwise equality structure,
   not to an unproved global optimality theorem.
3. Coverage, uncovered-locus, equality, and quantitative stability statements are immediate corollaries of the exact identity.
   The stability weights also give the discrete alternative
   \(m\Delta_H(A)=0\) or \(m\Delta_H(A)\ge m-2\); the intrinsic-defect proposition
   (`prop:intrinsic-defect`, C1071) sharpens this to \(m-1\) in the plane by integrality of
   \(D(A)=\Delta_\varnothing(A)\), with the split
   \(\Delta_H=D(A)+\sum_{y\in H,\,r(y)>0}(1-r(y)/m)\). The Lean gate checks the \(m-2\) form only.
   The new equality capstone adds three checked consequences:
   - concurrence points canonically partition \(E(KG(k,2))\) into matching cliques, because each
     pair of disjoint secants has one projective intersection;
   - zero defect makes every nontrivial clique a maximum matching and hence a simple
     \(\operatorname{MATCH}(k,\lfloor k/2\rfloor,1)\) design; the high-index-centre and
     per-secant counts follow from the second index equation and the degree of \(KG(k,2)\);
   - the bad-concurrence graph has the secants as vertices and the Kneser edges in nonmaximum
     concurrence cliques as edges; its edge estimate is the pointwise bound
     \(\binom r2\le (m-1)(r-1)(m-r)/2\), with the larger hole weight handled separately.
   - its vertex-cover estimate retains one secant through each nonmaximum concurrence centre and
     deletes the rest; the local cost \(r-1\) is bounded by the corresponding required-point or
     hole defect weight, so the union has size at most \(m\Delta_H(A)\).
   - the displayed slack identity is an algebraic refinement of the same construction: its three
     terms are respectively overlap among local deletion sets, off-hole local slack, and hole
     local slack. This refinement is proved in the manuscript but is not a separate Lean theorem.
   - when the full matching-design block count is integral, maximum-index centres form a packing
     of maximum-matching cliques. A packing one block short always completes because its leave has
     $\binom m2$ edges, all positive degrees divisible by $m-1$, and is therefore one $K_m$.
     Thus abstract design nonexistence forces
     $2m\le m\Delta_H(A)$, equivalently $\Delta_H(A)\ge2$. This implication is kernel-checked by
     `RelativeConicArcs.two_mul_half_le_scaledDefect_of_no_disjointness_decomposition`.
   The incidence decomposition, simplicity, zero-defect maximum index, both exact double-count
   identities, the bad-edge inequality, and the deletion statement are kernel-checked
   respectively by
   `disjoint_arcPairs_existsUnique_concurrence`, `concurrence_matching_injective`,
   `concurrenceCenter_pointIndex_eq_half`, `concurrenceCenters_card_mul_choose_half`,
   `concurrenceCentersOnPair_card_mul_sub_one`, with the displayed quotients exposed by
   `concurrenceCenters_card_eq_quotient` and
   `concurrenceCentersOnPair_card_eq_quotient`, and
   `two_mul_badConcurrenceEdgeCount_le` and `exists_secantDeletionSet` in
   `RelativeConicArcs.MatchingDesignRigidity`.
   The six-point realization is proved by a projective frame normalization: the first diagonal
   determinant is `-2`, and the second quadrangle has diagonal line
   `t(1+t)x+(1+t)y+tz=0`, whose passage through the remaining frame point gives
   `t^2+t+1=0`. The seven-point design nonexistence is not claimed as new: it is
   Alspach--Heinrich, Theorem 3.1. Combining it with the formal packing theorem gives the
   quantitative conclusion $\Delta_H(A)\ge2$.
4. For an arbitrary prescribed hole set of size \(h\), completeness gives the corrected capacity
   inequality with required-locus size \(q^2+q+1-k-h\). The conic specialization uses only
   \(|C|=q+1\). In particular, every prescribed hole set \(H\) of cardinality \(q+1\) gives
   \(q^2-k\le\binom{k}{2}(q-1)-6\binom{k}{4}/\lfloor k/2\rfloor\), and hence the same
   scalar \(L_2(q)\) lower bound, without any conic geometry. For a line at infinity, every
   secant contributes exactly one hole incidence,
   so `I_L(A)=choose(k,2)` and the general theorem gives the displayed complete-affine-arc bound
   and its equality pattern.
   The even-size equality-spectrum corollary combines conic equality with the matching-design
   counts. For \(Q=k-2\), the number \(s\) of maximum-index conic centres satisfies
   \[
   s=q+1-\frac{(q-Q)(2q-Q(Q+1))}{2}.
   \]
   The arc bound gives \(q\ge Q\), while \(0\le s\le q+1\) reduces the possibilities to
   \(q=Q\) or \(q=Q(Q+1)/2+t\); positivity then forces \(t\in\{0,1\}\).
   Prime-power order excludes the resulting \(k=8,12\) candidates in Desarguesian planes and
   leaves only \(q=8,37\) at \(k=10\). The scalar-extension obstruction is also immediate.
   For complete affine arcs of even size, the fixed ideal incidence removes the middle conic
   value: direct factorization gives
   \(q\in\{k-2,\binom{k-1}{2}+1\}\).
   For odd \(k\), putting \(Q=k-1\), \(R=\binom Q2-1\), and letting \(s\) count the
   maximum-index conic points gives
   \(s=q-(q-Q)(q-R)\). The arc bound together with \(0\le s\le q+1\) leaves exactly
   \(q\in\{k-1,\binom{k-1}{2}-1,\binom{k-1}{2}\}\).
   In characteristic two the latter spectrum reduces to \(k=q+1\), and the standard oval
   secant-index distribution identifies equality exactly with a disjoint prescribed conic
   containing the oval nucleus. The parallel even first branch is a hyperoval disjoint from the
   prescribed conic.
   The discrete gap, the complete-affine roots, both three-value spectra, and their
   characteristic-two reductions are also Lean terminals in
   `RelativeConicArcs.EqualityConsequences`: respectively
   `scaledDefect_eq_zero_or_half_sub_two_le`, `completeAffine_equality_order`,
   `even_completeOutside_zeroDefect_order_spectrum`,
   `odd_completeOutside_zeroDefect_order_spectrum`,
   `even_equality_spectrum_power_two`, and
   `odd_standardConic_zeroDefect_charTwo_order`. The even spectrum theorem is stronger than the
   conic corollary: it assumes only a complete arc outside a hole set of cardinality \(q+1\).
   The final geometric identification with an
   arbitrary oval or hyperoval and its nucleus remains an analytic manuscript proof: the Lean
   conic API supplies the required nucleus geometry for the standard conic, not the converse
   classification for an arbitrary oval.
5. The additive lower bound is obtained from the parity-free necessary inequality
   \[
   q^2-k\le \frac{k-1}{2}\bigl(k(q-1)-(k-2)(k-3)\bigr),
   \]
   giving the explicit finite statement
   \(k\ge\sqrt{2q}+3/2-8/\sqrt{2q}\) and hence the asymptotic result.
6. The upper-bound transfer is an averaging argument over \(\operatorname{PGL}(3,q)\): an ordinary
   complete \(b\)-arc can be moved off any prescribed \(H\) when \(b|H|<q^2+q+1\).
7. The even-characteristic statements use only the standard nucleus/tangent facts for a
   nonsingular conic; combining the nucleus-in/out cases gives \(I_C(A)\ge1\) universally.
   On the upper even equality branch, write \(k=2m\). Since
   \(q=(m-1)(2m-1)+1\) is even, \(m\) is even, while the equality spectrum gives
   \(I_C(A)=\binom{k}{2}\) and \(k-1\) maximum-index conic points. Nucleus parity forces a tangent
   arc secant. Its two commuting conic involutions preserve that \(3\bmod4\) set and have, together
   with their product, the tangent contact as unique fixed point; permutation sign is contradictory.
   The manuscript supplies both bridges explicitly. If \(Y\) has maximum conic index, the
   secants through \(Y\) perfectly match the arc; pairing an arc point \(R\) with \(R'\) shows that
   the other conic point on \(RR'\), namely \(\sigma_R(Y)\), has positive index and therefore
   maximum index at zero defect. After moving the tangent contact to \((1,0,0)\) on
   \(XZ=Y^2\), write the finite conic points as \(c(u)=(u^2,u,1)\). The chord
   \(c(u)c(v)\) meets the tangent \(Z=0\) at \((u+v,1,0)\), so a centre
   \((a,1,0)\) acts by \(u\mapsto u+a\). The nucleus is \(a=0\); the two distinct
   nonnuclear arc centres therefore give distinct nonzero translations, and their product is the
   third nonidentity translation with the same unique fixed point.
   Lean checks the incidence identity in
   `RelativeConicArcs.upper_even_equality_branch_holeIncidence`, the invariant-set bridge in
   `ZeroDefectConicInvariance`, and the general terminal
   `TangentPairFourGroup.no_upper_even_equality_branch`. The composed terminal
   `TangentPairFourGroup.even_standardConic_zeroDefect_charTwo_order` concludes \(q=k-2\)
   directly. Thus the proof no longer uses the
   Ramanujan--Nagell classification. The reduction from a nonsingular conic to the standard conic
   is the projective normalization in the manuscript.
8. The former appendix on simultaneous evaluation avoidance has been cut from the shortened
   manuscript. Its exact \(q\)-hyperplane threshold and checker remain supplementary results; no
   paper theorem depends on them.
9. For a projective \(k\)-arc, the transparent parity-check kernel has parameters
   \([k,k-3,4]_q\). Projective syndrome distance is one/two/three on selected/secant/uncovered
   directions; the secant index is the exact weight-two leader count, while a distance-three
   affine syndrome has one leader on every three-column support, hence \(\binom{k}{3}\).
10. The prescribed-hole defect identity therefore has a literal coding interpretation as a
    weight-two-leader collision identity. The resulting MDS-code length obstruction is a
    reformulation of the proved geometric theorem, not a new independent inequality.
11. The exterior-set comparison uses only the two defining containments: complete exteriority
    gives `C(F_q) ⊆ U(A)`, while relative completeness is `U(A) ⊆ C(F_q)`. For the cited
    `q=7` exterior four-arc, the elementary four-arc identity
    `|U(A)|=(q-2)(q-3)` gives `20>8`, so the first inclusion is strict and the arc is not complete
    outside the conic. This is a framing distinction, not a new classification claim.
12. For `k`-arcs over `GF(q)` with `q+1>choose(k,2)`, the literal uncovered locus determines the
    unlabelled parent arc. Equality of uncovered loci gives equality of the two secant-line unions:
    a secant with no matching line on the other side would have its `q+1` points covered by at most
    `choose(k,2)` distinct intersections. The vertices are then exactly the points incident with
    `k-1` recovered secants, since secants through a nonvertex form a matching on `k` endpoints and
    therefore number at most `floor(k/2)<k-1`. This is a proof-only reconstruction statement; it
    does not recover labels and introduces no finite census. For six-arcs it applies at `q>=16`.
    The exact statement is kernel-checked as
    `RelativeConicArcs.eq_of_ordinaryUncovered_eq`.
13. The reconstruction is canonical: writing `S=PG(2,q)\U(A)` and `N=choose(k,2)`, the parent
    secants are exactly the lines containing more than `N` points of `S`; vertices are then the
    `(k-1)`-fold points. Equivariance gives equality of the `PGammaL(3,q)` stabilizers of `U(A)`
    and `A`. The two inverse stages and their equivariant consequence are kernel-checked as
    `RelativeConicArcs.canonical_reconstruction` and
    `RelativeConicArcs.stabilizes_iff_stabilizes_ordinaryUncovered`. The latter is stated for an
    abstract action preserving arc size, arc incidence, and ordinary uncovered loci; semilinear
    projectivities satisfy these hypotheses. The strict threshold is sharp in general: at
    `(q,k)=(5,4)`, the frame has conic uncovered locus and `q+1=N=6`; the order-120 conic
    stabilizer has an orbit of at least five frames because a frame stabilizer has order 24.
14. The reconstruction section now states the minimum-distance consequence first:
    distinct parents have locus distance at least `2*delta`. Quantitative reconstruction then
    separates line recovery from vertex recovery. For two `N`-line unions,
    put `delta=q+1-N`. Each lost line contains at least `delta` points in the one-sided union
    difference. Bonferroni gives `d >= r*delta-choose(r,2)`, while uniqueness of the line through
    two points gives `r*choose(delta,2) <= choose(d,2)` when `delta>=2`. Applying the latter to
    the smaller one-sided difference bounds the number `r` of lost secants in terms of
    `floor(|U(A) triangle U(B)|/2)`. A vertex of `A` absent from `B` has at most `floor(k/2)`
    common secants, because those secants form a matching on `B`; it is therefore incident with
    at least `floor((k-1)/2)` lost secants. Double-counting lost degrees gives the stated vertex
    bound. The separate degree-correction lemma partitions lost-line pairs by their unique
    intersection point; if a lost-edge degree is `e`, its forced vertex concurrence restores at
    least `choose(e-1,2)` of the pairwise Bonferroni subtraction. If `a=|A\B|`, a common secant
    through a missing vertex must use a point of
    `B\A`; hence there are at most `min(a,floor(k/2))` such secants and
    `2r>=a*(k-1-min(a,floor(k/2)))`. The no-triple-concurrence example attains the unrestricted
    Bonferroni line bound; concurrency is less adverse. No defect estimate or computational
    classification enters this theorem.

## Computer-assisted claims

The defect identity, equality criterion, matching rigidity, deletion stability,
and reconstruction theorem have ordinary proofs in the manuscript and
independent Lean formalizations.  The averaging and asymptotic arguments are
ordinary paper proofs.  The finite arguments have different trust boundaries.
The q=16 exclusion is a Lean-kernel-checked exhaustive certificate theorem; its
separate Python pattern certificate explains the generic leaves geometrically
but is not a premise of the Lean theorem.  The exact values at q=13,17,19 use
trusted exhaustive C++ classifications for their lower bounds and
kernel-checked Lean witnesses for their upper bounds.  The ten-point realization
classification imports Mathon's published abstract classification and trusts
exact Singular executions; it is not consumed by Lean.

The manuscript now reflects that division of labor explicitly.  The main body
ends after the defect mechanism, equality consequences, and conic lower bound.
The equality realizations, upper transfer, nucleus lemmas, finite classifications,
reconstruction theorem, witnesses, and verification contracts are appendices.
Generators, raw certificates, hashes, and replay scripts remain in the
electronic companion, so implementation detail does not interrupt the main proof.

The supplementary verifier checks explicit upper-bound witnesses for
\(q=8,9,11,16\), and the dedicated prime-field gate checks witnesses for
\(q=13,17,19\). The C187 small-\(k\) checker independently verifies the
four-frame conic-filling identity at \(q=5\), and the C188 Lean leaf transports
that frame to the standard conic and checks the relative certificate. These
checks enumerate the relevant projective plane and verify the conic, arc
condition, and relative coverage; the general verifier also checks both
classical moment equations.

The lower bounds for \(q=5,8,9,11\), and the preliminary lower bound eight at
\(q=16\), are analytic. The exact value \(\rho_C(16)=9\) additionally uses an
exhaustive projective classification of eight-arcs.  The generator in the
separately versioned `finitegeom-q16-certificates` package reports 2633
frame-normalized classes.  Its Lean output
does not trust canonical labels: each augmentation is checked by an explicit
invertible projective matrix and pointwise scalar equalities.  Each parent
book has a `StepBook.coverage` theorem proving that every legal extension occurs among certified
entries, while `StepBooksValid` proves that the books cover the current parent list exactly;
`classifiedAt_level8_of_frame` composes the four layers, and frame reduction
maps an arbitrary eight-arc to a listed leaf.  Thus closure and exhaustiveness
of the lists are certified, not delegated to the generator.  At every leaf,
the ordinary-uncovered locus gives one of two elementary obstructions.  On
2630 leaves it contains three collinear points and three noncollinear points
outside their line.  A quadratic through the first triple contains that
line, so its residual linear factor cannot contain the second triple.  The
independent pattern checker records one such six-point witness for every
generic leaf.  On the other three leaves, the unique quadratic kernel line
meets the arc; its generators and selected-point intersections are displayed
in the manuscript.  The same checker verifies the two split factorizations
and the middle form's invertible standard-conic coordinate change on all
4096 coordinate vectors.  Lean independently checks invertible six-row evaluation
matrices on the 2630 generic leaves, proves that the three exceptional
matrices have exactly the displayed one-dimensional kernels, and transports
the rejection to arbitrary eight-arcs and arbitrary nonsingular conics.
The field-uniform normalized mechanism is also kernel-checked by
`RelativeConicArcs.ternaryQuadratic_eq_zero_of_standardLine_and_offLineTriangle`;
the manuscript supplies the elementary projective normalization to its
standard line coordinates.

The ten-point equality refinement is separately computer-assisted.  Abstract
completeness is Mathon's two-class theorem, imported through
Alspach--Heinrich's published account because Mathon's primary proof was not
reached.  The paper-local certificate bundle independently constructs representatives of both
classes, forms the \(189\) normalized rank-three concurrency equations for
each, and checks the decisive Gröbner and integral-lift identities.  The
odd-characteristic lift certificates force a repeated frame point for both
designs; the characteristic-two certificate does the same for the second
design.  For the regular-hyperoval design, the nondegenerate triangular basis
forces \(T^3+T+1=0\), and the direct \(\mathbf F_8\) construction supplies the
converse and the conic-compatible equality case.  The exact script, JSON
certificate, and checksum manifest are
`check_match10_rank_three.{py,json,sha256}`.
The computation was replayed in two monomial orders and against direct
incidence over \(\mathbf F_8\); Singular's exact Gröbner bases and module lifts
remain trusted executions.

The total of 2633 projective eight-arc classes is not a new classification
claim: it independently reproduces Theorem 3.8.1 of Al-Seraji--Al-Ogali
(2018). The additional computation partitions those known ordinary classes
by a different invariant: 2630 full-rank ordinary-uncovered quadratic
evaluation systems and three systems with a checked one-dimensional kernel forced to meet the arc.

The classification proves a statement strictly stronger than the conic application: for every
eight-arc in `PG(2,16)`, no nonzero homogeneous quadratic, singular or nonsingular, contains its
entire ordinary-uncovered locus while avoiding the arc. Projective invariance is explicit:
normalizing by `g` replaces a form `Q` by `Q ∘ g⁻¹`, preserves nonzeroness, transports zero sets,
and carries the ordinary-uncovered locus bijectively. Lean checks the stronger alternative for
every canonical leaf and, in
`arbitrary_eight_arc_projectiveQuadraticAvoidance`, the complete arbitrary-eight-arc statement.
That theorem includes coefficient pullback, preservation of nonzeroness, projective transport of
zero sets, and the identity `U(gA)=gU(A)`. The full conic corollary is also formalized.

The exact values at orders 13, 17, and 19 have a separate finite boundary.
Projective-frame canonicalization enumerates all 80 seven-arc classes over
`GF(13)` and all 5,441 eight-arc classes over `GF(17)`. At order 19, all
20,361 canonical eight-arc classes and every one of their 1,053,996 legal
nine-arc extensions are tested; deleting one point from an arbitrary nine-arc
proves exhaustive coverage without deduplicating the extensions. Every tested ordinary-uncovered
quadratic evaluation system has rank six. An independent fixed-frame
enumeration checks the order-13 lower bound; the order-17 class reduction and
order-19 extension reduction have no second implementation. Lean checks the
three attaining witnesses and the inequalities `rhoC_ZMod13_le_eight`,
`rhoC_ZMod17_le_nine`, and `rhoC_ZMod19_le_ten`; it does not represent the
exhaustive lower classifications as theorems.

The manuscript now isolates the underlying linear-algebra argument as the
general uncovered-evaluation obstruction: injective evaluation on the
uncovered locus, or a selected evaluation functional in the span of the
uncovered evaluations, excludes a zero locus that contains the former and
avoids the latter. The quadratic certificate is its degree-two instance.
The displayed factorizations of the two singular exceptional forms and the
seven-point incidence of the nonsingular exception are direct `GF(16)`
arithmetic descriptions. `Q16ExceptionalArithmetic.lean` identifies them with the actual three
forced-hit records and checks their exact one-dimensional kernels, both factorizations, the three
arc-hit counts `(2,7,2)`, and an invertible standard-conic model for the middle form;
classification completeness does not depend on them.

For the (q=11) witness, the verified value (I_C=0) implies that all 15
secants are exterior to the conic. Completeness, the maximum index three, and
the two moment equations then force the required-point index counts
((N_1,N_2,N_3)=(90,15,10)).

The expanded q=11 result is kernel checked in `RelativeConicArcs/Q11Coding.lean`. It proves the
transparent `[6,3,4]₁₁` MDS parameters and exact minimum distance, covering radius three, equality
of the projective deep-hole locus with the conic, affine coset distances `(1,60,1150,120)`, and
distance-two leader histogram `(900,150,100)`. These affine counts are derived from the certified
projective secant-index spectrum only after proving that 133 canonical directions times ten
nonzero scalars biject onto all 1330 nonzero affine syndromes. Membership in the counted distance
sets is equivalent to actual parity-check distance. For distance two,
`syndromeLeaderSupports_two_eq_raw` identifies the determinant-zero pairs with supports of actual
weight-two coefficient words, `card_syndromeLeadersOfWeight_eq_supports` identifies supports with
words, and scalar multiplication transports the word count along each ray. Invertibility of the
six-by-six quadratic evaluation matrix proves the formal no-conic premise; the conclusion
"projectively non-GRS" uses the cited classical normal-rational-curve/GRS dictionary.
`Q11NonGRS.lean` makes this boundary explicit and kernel-checks the implication from the
dictionary's nonzero-quadratic consequence to the contradiction.
The named theorem `affine_distanceThree_iff_mem_standardConic` additionally identifies actual
distance-three affine syndrome rays directly with membership in the incidence-defined standard
conic, closing the quotient-level code/geometry bridge rather than relying on parallel counts.
The Lean supplement also retains the extension material cut from the manuscript: the polynomial
`1+12t+36t²+20t³`, zero maximal extensions of sizes zero
and one, six of size two, twenty of size three, and none of size four. The determinant-defined
conflict graph is the 30-edge, degree-five icosahedral graph; its six witness-coloured five-edge
matchings partition the edges and each misses an antipodal pair.
`maximal_independent_extension_complete` upgrades every counted maximal residual set to an
ordinary complete arc. `completed_witness_matchings_oneFactorization` proves that the six missing
antipodal edges are distinct and that the augmented colour classes are six pairwise edge-disjoint
perfect matchings partitioning the augmented graph.

The auxiliary P-value conclusion remains in `RelativeConicArcs/Q11ResidualGame.lean` and uses the
generic antipodal conflict-graph mirror theorem, not an exhaustive game-tree evaluator. It is not
used by the paper's bounds.

Verifier SHA-256:

`e9508958d604e68c6c3d09fd3afadfaa8a3126508a51f1dfa993e7a7aed5d36a`

Independent strengthening checkers and their source hashes:

- `check_evaluation_dichotomy.py`:
  `6ed309bd2461ce9998cbd3bcaa5396379e6973b7503ce2dcdfb32c9806386566`;
- `check_q11_structure.py`:
  `0abe909c9aadce0db4c75f296c8de25e929dd1065c906996da8dec017e534d69`;
- separately written `check_q11_structure.cpp`:
  `1753674172d48f1d056d350e30baa9eb67de0810c84a96da0440947768ae041c`.

The 2026-07-13 adversarial replay reproduced output hashes
`88be03eb8a81bb906083457a4b4201cfd1ef6bcaa9de01928175840f61ac55ff`,
`b096305a809b062c274129c157d51a57d65e9aec0e44662370ec53c8c773110f`, and
`380cab47923cbfb3a9bfcc54ee89cf0eb79aa551d936d2e91cbb4949ae56477d`, respectively. Coordinate
transport and relabelling preserve the results; replacing one witness point changes the extension
count from 12 to 20 and collapses the stabilizer from 60 to 2, while a mutated generator is
rejected.

The exact-search report is frozen in the public certificate package. Its
`MANIFEST.json` records the generator, replay evidence, and report hashes and
pins the human-scale `finitegeom` dependency.

## Lean formalization

The public `finitegeom` package formalizes the human-scale theorem chain, while the separately
pinned `finitegeom-q16-certificates` package contains the generated order-16 proof. In particular,
the human package proves the arbitrary-hole capacity theorem, the complete-affine
line-hole equivalence, ideal-line incidence identity, corrected affine bound and equality criterion, the generic
projective-averaging transfer, the explicit additive lower bound, and the universal
even-characteristic incidence loss. It also proves exact uncovered-locus reconstruction and its
equivariant stabilizer corollary, concurrence decomposition, zero-defect maximum-matching
rigidity, exact total and per-secant centre counts, and edge/vertex stability of the
bad-concurrence graph. It also formalizes the two-unit defect implication from matching-design
nonexistence and checks the three prime-field upper witnesses. Its generic Boolean checker verifies conic disjointness, the arc
condition, and coverage on the (q^2+q+1) canonical projective representatives; `check_sound`
proves that acceptance implies semantic relative completeness. The accepted coordinate list need
not be normalized or duplicate-free.

The stable manuscript-facing modules are imported and audited by
`RelativeConicArcs.Gates.ArcsCompleteOutsideConic` and
`RelativeConicArcs.Gates.ArcsCompleteOutsideConicAdditions`. The generated
order-16 theorem `RelativeConicArcs.rhoC_GF16` is exposed separately by the
certificate-package gate `RelativeConicArcs.Gates.ArcsCompleteOutsideConic`.
No proof uses `sorry`, `admit`, a custom axiom, or
`native_decide`. The load-bearing certificate, arithmetic, and final numerical theorems report
exactly `[propext, Classical.choice, Quot.sound]`; see
`trust/ARCS_COMPLETE_OUTSIDE_CONIC.md` and
`trust/ARCS_COMPLETE_OUTSIDE_CONIC_ADDITIONS.md` in `finitegeom`, together with
the certificate package's `README.md`, `PROVENANCE.md`, and `MANIFEST.json`, for the theorem maps,
provenance, and trust boundaries. The Kim--Vu input remains an explicit named theorem hypothesis
and is not used by the finite results.

Three adversarial controls exercise distinct trust layers: changing a leaf member breaks its local
rejection proof, changing a projective transition scalar breaks the row proof, and omitting the
last parent book breaks the aggregate `StepBooksValid` parent-list equality. Each mutation was
rejected by Lean and the restored sources rebuilt through the final result registry.

## Analytic claims added by C1071 (2026-09-06)

Verified by hand in `notes/2026-09-06-c1071-arcs-astra-review-upgrades.md` (Phase 1 verdicts);
numerics and certificate reruns in `notes/2026-09-06-c1071-sub-worklog.md`.

- `prop:intrinsic-defect`: \(D(A)\in\mathbb Z_{\ge0}\), the hole split, monotonicity in \(H\),
  and the gap \(m\Delta_H\in\{0\}\cup[m-1,\infty)\); sharp for the complete quadrilateral.
- `thm:large-holes`: \(\liminf(k-\sqrt{2q})\ge 3/2-\lambda/\sqrt2\) when \(|H|/q^{3/2}\to\lambda\);
  elementary expansion of `eq:arbitrary-holes` with the first moment supplying the lower bound on
  \(k-\sqrt{2q}\).
- `lem:evaluation-obstruction` (converse clause): over \(F_q\) with \(|A|\le q\), or over an
  infinite field, the two obstructions are necessary; proper-subspace covering count
  \(1+q(q^{d-1}-1)<q^d\); sharp boundary \(q+1\) lines cover \(F_q^2\)
  (`check_evaluation_dichotomy.py`).
- `cor:ten-point-uniqueness`: every rank-three realization of the regular-hyperoval design is
  \(\mathrm{PGL}(3,K)\)-equivalent to the regular hyperoval of \(\mathrm{PG}(2,8)\). Input: the
  tracked certificate's characteristic-two lexicographic basis (triangular, univariate factor
  \(t(t+1)(t^3+t+1)\), arc inequation removes \(t\in F_2\); three solutions, one Frobenius
  orbit), regenerated byte-identically with Singular 4.4.1 on 2026-09-06. Frobenius step is a
  paper proof.
- `thm:char-zero-obstruction`: no rank-three realization of any equality design with
  \(k\ge6\) in characteristic zero. Imported: Hirzebruch's inequality in the form
  \(t_2+\tfrac34 t_3\ge d+\sum_{r\ge5}(2r-9)t_r\) for \(d\ge6\), \(t_d=t_{d-1}=t_{d-2}=0\),
  as recorded in Pokora, arXiv:1808.09167v4, Remark 2.9 (read: partial; Hirzebruch 1983 not
  consulted directly). Bookkeeping \(t_{k-1}=k\), \(t_m=(\binom d2-k\binom{k-1}2)/\binom m2\)
  checked for \(k=4..12\). The weaker form \(t_2+t_3\ge d+\sum(r-4)t_r\) does not exclude
  \(k=7\) (equality \(35\ge35\)).
- `thm:cap-defect-identity`, `lem:pencil-bound`, `thm:secant-local-coverage`,
  `cor:pg3q-complete-caps`: the cap moments with \(3c_4(A)\), the pencil bound
  \(T_\ell\ge B_n(k,q)\) with exact remainder, the per-secant concave-minimum loss
  \(\varphi_m\), the \(\mathrm{PG}(3,q)\) inequality
  \(\theta_3-k-h\le\binom k2(q-2+1/(k-q-2))-I_H/m\) for \(k\ge q+3\), and the constant
  \(1/2+(3-\lambda)/\sqrt2\). Elementary; the \(q=3\) and \(q=13\) numbers are hand
  arithmetic reproduced in `notes/scratch/c1071/c1_pg3q_bounds.py`. The plane-section moment LP
  equals the pencil bound exactly up to \(k\approx2q+2\) (`c4_plane_lp.py`), so it is a check,
  not a strengthening.
- Remarks `rem:independent-domination` and `rem:noisy-reconstruction`: direct arguments, no
  external input.

## Claims intentionally omitted

- No claim that the classical first two index equations are new.
- No claimed association-scheme or spectral theorem.
- No claim that a lower bound on the conic-incidence term alone settles the
exact \(q=16\) value; the paper proves that this route is too weak and uses
  the independent uncovered-quadratic-rank obstruction instead.
- No exact values beyond the orders whose attaining witnesses and lower-bound
  arguments are explicitly identified in the manuscript.
- No unconditional novelty certification for the parameter itself.
- No unconditional novelty claim for the \(\mathrm{PG}(3,q)\) secant-local bound
  (`cor:pg3q-complete-caps`) or the per-secant coplanar-quadruple count; see the C1071 row under
  novelty closure for the searched domain and the four could-not-access sources.
- No claim that the 2633-class ordinary eight-arc enumeration is new.
- No claim that the general evaluation lemma, or the use of quadrics and
  evaluation conditions in arc theory, is new.
- No claim that the sharp \(q+1\) vector-space covering threshold, the arc--MDS dictionary,
  the \(\binom{k}{3}\) farthest-coset leader count, the deep-hole/MDS-extension dictionary, or the
  Clebsch-hexagon/icosahedral interpretation is new.
- No unconditional novelty claim for the q=11 conic deep-hole locus and refined coset
  distribution. The coloured chord partition and extension polynomial have been cut from the
  manuscript and remain supplementary checked facts.
- No claim that the q=11 exterior six-arc or the inclusion of its conic in the ordinary uncovered
  locus is new. Dye 1991, p. 281 (discussion preceding Theorem 6), and
  Blokhuis--Seress--Wilbrink 1992, pp. 143 and 146,
  supply that classical input. Exact equality follows after adjoining the elementary chord-defect
  count and Dye's ten Brianchon concurrences; it is described as an apparently unrecorded synthesis.
- No unconditional priority claim for the uncovered-locus quadratic
  obstruction, its `2630+3` profile, or the exact relative value. A targeted
  comparison found no predecessor, but it is not an exhaustive priority
  certificate; see `notes/2026-07-13-rhoc16-novelty-check.md`.

## Pre-publication novelty closure

- **C349 complete:** the introduction and bibliography now cite Korchmaros--Nagy--Szonyi,
  *Algebraic approach to the completeness problem for `(k,n)`-arcs in planes over finite fields*
  (JCTA 204 (2024), 105851; arXiv:2302.10162). Their Theorem 7.5 is credited as exact prior art for
  localization of an uncovered locus in the proper subplane `PG(2,q)`.
- The released boundary distinguishes that curve-derived `(k,q+1)`-arc theorem from this
  manuscript's exact arbitrary prescribed-hole defect identity, equality/stability consequences,
  and conic specialization. No priority is claimed from search absence.
- The primary-source, metadata, correction, forward-citation, and downstream-code checks are
  recorded in `notes/2026-07-18-c349-arcs-prepublication-novelty-closure.md`. C329 remains a
  structured incomplete `2`-arc; C337 does not infer nonextendibility from completeness, and C348
  does not claim priority for subgeometry-localized deep holes.
- **C1071 (2026-09-06), `PG(3,q)` complete-cap constant.** Manuscript sentence (the only novelty
  surface; Section `sec:caps`): "The same source calls \(\sqrt2\,q^{(n-1)/2}\) the trivial lower
  bound for complete caps of \(\mathrm{PG}(n,q)\) and cites no improvement, and we found none in
  the sources we could consult; the additive term in `eq:pg3q-asymptotic` is, to our knowledge,
  the first refinement of the counting bound for complete caps in \(\mathrm{PG}(3,q)\)."
  Evidence: `notes/2026-09-06-c1071-sub-worklog.md` Part D. Full text: Bartoli–Davydov–
  Kreshchuk–Marcugini–Pambianco arXiv:1610.09656 and Bartoli–Marcugini–Pambianco
  arXiv:1706.01941 (both state "the trivial lower bound" \(\sqrt2 q^{(N-1)/2}\) with no cited
  improvement), Farr–Lisoněk IIG 4 (2006), Pavese arXiv:2305.13838, Alabdullah–Hirschfeld DCC
  2019 (plane, first-moment only). Searched and found nothing: OpenAlex (nine queries), zbMATH
  Open (one), Semantic Scholar (one; a second rate-limited), arXiv API (two). Could not access:
  Davydov–Faina–Marcugini–Pambianco J. Geom. 94 (2009) 31–58 (source of the exact
  \(t_2(3,q)\) table for \(q\le7\)); Hirschfeld–Storme 1998 and 2001 surveys; Hirschfeld–Thas
  FFA 2014 open problems; Farr–Lisoněk J. Geom. 85 (2006) (the \(q+3\) free-pair bound, quoted
  secondary-only through IIG 2006). MathSciNet NOT COVERED. The "to our knowledge" qualifier is
  load-bearing until those five are read. Smallest-size comparison (\(8,12,17\) exact for
  \(q=3,5,7\); \(30,36\) known for \(q=11,13\)) is secondary-only through arXiv:1610.09656
  Tables 1–2. Indexing defect: zbMATH Zbl 1178.51009 links the 2009 J. Geom. paper to
  arXiv:1004.2817, which is a different paper.
