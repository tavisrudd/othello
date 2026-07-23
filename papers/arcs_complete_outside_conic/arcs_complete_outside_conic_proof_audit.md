# Proof and claim audit

## Analytic claims proved in the paper

1. The first and second secant-index equations are proved by direct double counting and identified as classical.
2. The prescribed-hole defect formula is an exact identity, not an estimate:
   \[
   m\Delta_H(A)=
   \sum_{x\in X_H(A)}(r(x)-1)(m-r(x))+
   \sum_{y\in H}r(y)(m-r(y)).
   \]
3. Coverage, uncovered-locus, equality, and quantitative stability statements are immediate corollaries of the exact identity.
4. For an arbitrary prescribed hole set of size \(h\), completeness gives the corrected capacity
   inequality with required-locus size \(q^2+q+1-k-h\). The conic specialization uses only
   \(|C|=q+1\). For a line at infinity, every secant contributes exactly one hole incidence,
   so `I_L(A)=choose(k,2)` and the general theorem gives the displayed complete-affine-arc bound
   and its equality pattern.
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
8. The finite-field evaluation dichotomy is exact for at most \(q\) selected points. Its reverse
   implication uses the anchored union bound for at most \(q\) proper hyperplanes; the \(q+1\)
   lines of a two-dimensional quotient prove sharpness. The arbitrary-feature statement includes
   every Veronese degree.
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

## Computer-assisted claims

The supplementary verifier checks explicit upper-bound witnesses for
\(q=8,9,11,16\). The C187 small-\(k\) checker independently verifies the
four-frame conic-filling identity at \(q=5\), and the C188 Lean leaf transports
that frame to the standard conic and checks the relative certificate. These
checks enumerate the relevant projective plane and verify the conic, arc
condition, and relative coverage; the general verifier also checks both
classical moment equations.

The lower bounds for \(q=5,8,9,11\), and the preliminary lower bound eight at
\(q=16\), are analytic. The exact value \(\rho_C(16)=9\) additionally uses an
exhaustive projective classification of eight-arcs.  The source
`search_rhoc16.cpp` reports 2633 frame-normalized classes.  Its Lean output
does not trust canonical labels: each augmentation is checked by an explicit
invertible projective matrix and pointwise scalar equalities.  Each parent
book has a `StepBook.coverage` theorem proving that every legal extension occurs among certified
entries, while `StepBooksValid` proves that the books cover the current parent list exactly;
`classifiedAt_level8_of_frame` composes the four layers, and frame reduction
maps an arbitrary eight-arc to a listed leaf.  Thus closure and exhaustiveness
of the lists are certified, not delegated to the generator.  At every leaf,
kernel-checked ordinary-uncovered points either give a full-rank six-row
quadratic evaluation matrix (2630 leaves), or force the unique kernel line
to hit the arc (three leaves). The three latter matrices are separately
proved to have exactly the displayed one-dimensional kernels. The semantic proof transports this
rejection to arbitrary eight-arcs and arbitrary nonsingular conics.

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
It also proves the extension polynomial `1+12t+36t²+20t³`, zero maximal extensions of sizes zero
and one, six of size two, twenty of size three, and none of size four. The determinant-defined
conflict graph is the 30-edge, degree-five icosahedral graph; its six witness-coloured five-edge
matchings partition the edges and each misses an antipodal pair.
`maximal_independent_extension_complete` upgrades every counted maximal residual set to an
ordinary complete arc. `completed_witness_matchings_oneFactorization` proves that the six missing
antipodal edges are distinct and that the augmented colour classes are six pairwise edge-disjoint
perfect matchings partitioning the augmented graph.

The auxiliary P-value conclusion remains in `RelativeConicArcs/Q11Residual.lean` and uses the
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

The exact-search report is frozen separately as `search_rhoc16_output.txt`;
the source and report hashes are recorded in `lean/RelativeConicArcs/TRUST.md`.

## Lean formalization

The standalone `lean/RelativeConicArcs/` package formalizes the theorem chain and the five finite
certificates. In particular, it proves the arbitrary-hole capacity theorem, the complete-affine
line-hole equivalence, ideal-line incidence identity, corrected affine bound and equality criterion, the generic
projective-averaging transfer, the explicit additive lower bound, and the universal
even-characteristic incidence loss. Its generic Boolean checker verifies conic disjointness, the arc
condition, and coverage on the (q^2+q+1) canonical projective representatives; `check_sound`
proves that acceptance implies semantic relative completeness. The accepted coordinate list need
not be normalized or duplicate-free.

The focused modules and the top-level `RelativeConicArcs.Results` aggregate build successfully.
No proof uses `sorry`, `admit`, a custom axiom, or
`native_decide`. The load-bearing certificate, arithmetic, and final numerical theorems report
exactly `[propext, Classical.choice, Quot.sound]`; see `lean/RelativeConicArcs/TRUST.md` for the
theorem map, provenance, and trust boundary. The Kim--Vu input remains an explicit named theorem
hypothesis and is not used by the finite results.

Three adversarial controls exercise distinct trust layers: changing a leaf member breaks its local
rejection proof, changing a projective transition scalar breaks the row proof, and omitting the
last parent book breaks the aggregate `StepBooksValid` parent-list equality. Each mutation was
rejected by Lean and the restored sources rebuilt through the final result registry.

## Claims intentionally omitted

- No claim that the classical first two index equations are new.
- No claimed association-scheme or spectral theorem.
- No claim that a lower bound on the conic-incidence term alone settles the
exact \(q=16\) value; the paper proves that this route is too weak and uses
  the independent uncovered-quadratic-rank obstruction instead.
- No exact values for orders whose witnesses were not independently included
  and checked by the supplementary verifier or the dedicated q=5 checker.
- No unconditional novelty certification for the parameter itself.
- No claim that the 2633-class ordinary eight-arc enumeration is new.
- No claim that the general evaluation lemma, or the use of quadrics and
  evaluation conditions in arc theory, is new.
- No claim that the sharp \(q+1\) vector-space covering threshold, the arc--MDS dictionary,
  the \(\binom{k}{3}\) farthest-coset leader count, the deep-hole/MDS-extension dictionary, or the
  Clebsch-hexagon/icosahedral interpretation is new.
- No unconditional novelty claim for the q=11 conjunction of conic deep-hole locus, refined coset
  distribution, coloured chord partition, and extension polynomial. The bounded search did not
  locate that exact conjunction, so it is presented only as a checked synthesis.
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
