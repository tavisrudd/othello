# C855 step 2a — Paper I assertion inventory and paper-to-Lean correspondence map

**Date:** 2026-08-02
**Lane:** `clebsch` (Paper I stream)
**Task:** C855 — Paper I Lean referee-artifact standards remediation
**Scope of this record:** the first two bullets of checklist section 2 — a
sentence-level inventory of every mathematical assertion in the main paper and the
computational companion, and the bidirectional correspondence against the current
formal surface. No Lean source, manuscript, manifest, or generated leaf was edited,
and no gate was built.

Sources read in full: `papers/clebsch-rigidity/clebsch_rigidity.tex` and
`papers/clebsch-rigidity/clebsch_rigidity_computational_companion.tex`.
Formal surface read: the 51 `#print axioms` terminals of
`RelativeConicArcs/Gates/ClebschRigidityTrust.lean` in the q11 certificate package.

Rows are keyed by the manuscript's own LaTeX labels where one exists, since those are
the stable identifiers a referee can follow, and by section plus a short descriptive
phrase where the assertion is unlabelled prose.

## Part A — Main paper assertions

### Abstract and introduction

| assertion | current mode | existing Lean terminal | gap |
|---|---|---|---|
| For a six-arc in the plane of order eleven, the uncovered locus lies on a conic exactly when the arc is projectively a Clebsch hexagon, and then the locus is exactly a nonsingular conic | Lean relative to two Dye axioms | `ClebschDye.isClebschHexagon_of_uncovered_subset_planeConic`, `ClebschDye.sixArc_cards_of_uncovered_subset_conic` | the two Dye axioms must be discharged |
| Nearest-codeword data reconstruct the non-GRS Clebsch code up to monomial equivalence | Lean relative to the same axioms | `ClebschDye.deepHoleLocus_rigidifies_witnessCode` | as above |
| The reconstructed conic determines its polarity, and Dye's theorem identifies the stabilizer as the alternating group of degree five | cited only | none | full gap; no formal statement of polarity determination or stabilizer identification |
| The syndrome locus reconstructs an unordered orientation torsor on six axes whose signed orbital operator squares to five times the identity | Lean | `PaperIOrientationPentagon.signedOrbitalMatrix_sq` | none |
| Triangle holonomy gives the support cubic as the product of the three signed entries | Lean | `PaperIOrientationHolonomy.supportSign_eq_triangleProduct` | none |
| The support cubic is the sole nonsymmetric term of the diagonal determinant pencil | Lean | `PaperIOrientationDeterminant.det_signedOrbital_add_diagonal`, `PaperIOrientationDeterminant.determinantPencil_oddPart_eq_supportCubic` | none |
| Any arc whose uncovered locus is a nonsingular conic has odd field order in the window from twice the arc size minus three to one third of the arc size times its predecessor plus three | mixed; partly Lean | `ClebschChordDefect.orders_of_clebsch_uncovered_conic_card` covers the Clebsch family specialization only | the general uniform window over arbitrary arc size is not formalized |
| The coset-leader definition of a deep hole, the syndrome weight function, and the identity between coset distance and syndrome weight | definitional prose | none | needs formal definitions if the abstract's coding statements are to be self-contained |
| For an MDS code of redundancy three, syndrome weight is one, two, or three according as the direction is on the arc, on a secant, or on neither | cited to Davydov, Marcugini, and Pambianco | none as a general theorem | external transfer; must be proved or imported as an audited theorem |
| If the uncovered locus is nonempty, the code has covering radius three and the locus is the projective deep-hole locus | Lean for the displayed witness only | `Q11Coding.witness_code_coveringRadius_three`, `Q11Coding.projective_distanceThreeDirections_eq_standardConic` | the general implication for arbitrary arcs is not formalized |
| Six-arcs with uncovered locus equal to a fixed conic form one orbit under the conic stabilizer, by a Bézout argument on the twelve shared rational points | human proof | none | full gap |
| Projective equivalence of unordered parity-check column sets equals monomial equivalence of the codes | human proof | none | full gap; used to convert the geometric theorem into the coding theorem |

### The Clebsch hexagon and the chord-defect identity

| assertion | current mode | existing Lean terminal | gap |
|---|---|---|---|
| `def:hexagon` — the Clebsch hexagon as poles of the six Sylow-five fixed chords, and Dye's general-field definition by exactly ten Brianchon points | definition | the `IsClebschHexagon` predicate underlying `ClebschDye` | the Sylow-five pole construction and its agreement with the Brianchon-count definition are not formalized |
| The displayed six-point representative is a six-arc disjoint from the conic whose fifteen joins also avoid it | Lean | `Q11Coding.witness_mds_columns` | none |
| Edge's vertices are external, joins exterior, concurring three at a time at ten internal Brianchon points | cited | none | external transfer |
| The hexagon is a complete exterior set in the sense of Blokhuis, Seress, and Wilbrink, and their list also contains a Pasch configuration excluded by the arc condition | cited plus prose | none | full gap |
| The displayed hexagon is the arc named in the Storme–Van Maldeghem classification and Dye's synthetic hexagon when five is a square | cited | none | external transfer |
| Dye's results give projective uniqueness, the unique associated polarity, and the alternating stabilizer; his calculation also shows the six vertices lie on no conic in characteristic eleven | cited | none | external transfer; the no-conic assertion is separately checked in the code section |
| `lem:chord-defect` — the universal chord-defect identity and the defect bound, with vanishing defect below six points | Lean | `ClebschChordDefect.chordDefect_identity_of_moments` | confirm the bound clause and the small-arc vanishing clause are both inside the formal statement |

### The rigidity theorem and the field window

| assertion | current mode | existing Lean terminal | gap |
|---|---|---|---|
| `lem:six-arc-line-bound` — every line meets the uncovered locus of a six-arc in at most the field order minus five points, over odd order | Lean | `OddSixArcPrismExtraction.sixArc_uncoveredOnLine_card_le_order_sub_five` | none |
| The one-factorization of the complete graph on six vertices is unique up to isomorphism | cited | none | external transfer used inside the line-bound proof |
| `thm:rigidity` — the three-way equivalence between conic containment, exact nonsingular conic filling, and Clebsch equivalence | Lean relative to Dye axioms | `ClebschDye.isClebschHexagon_of_uncovered_subset_conic`, `...subset_planeQuadraticLocus`, `...subset_planeConic` | Dye axioms |
| Dye's Brianchon bound of ten with the equality cases forming one projective orbit | axiom | the two declared Dye axioms | must be replaced by proof or an audited library import |
| The Brianchon-count identity relating the uncovered cardinality to twenty-two minus the concurrence count | Lean | `ClebschDye.sixArc_uncovered_add_brianchon_card`, `ClebschDye.sixArc_twelve_le_uncovered_card` | none |
| `rem:` extension-locus literature remark — Segre tangent-envelope results require arc sizes far from six and do not record this rigidity | literature claim | none, and none is appropriate | belongs to the literature-audit record, not the formal artifact |
| `cor:conic-filling-window` — the defect value under conic filling, the quadratic inequality, strict comparison of field order with the chord count, the even-order arc obstruction, the odd-order window, and the six-point specialization with the concurrence formula | mixed | partial: `ClebschChordDefect.orders_of_clebsch_uncovered_conic_card` | the even-order nucleus obstruction and the general upper window bound are not formalized |
| The nucleus theorem for ovals in even order | cited to Hirschfeld | none | external transfer |
| The exact conic-complement covering bound of Blokhuis, Brouwer, and Szőnyi | cited | none | external transfer supplying the upper window bound |
| `rem:` sharpness — the four-frame over the field of five elements and the Clebsch six-arc attain the two bounds, and no infinite family is known | mixed | the four-frame case is `SmallKGeometricBridge.fourArc_uncovered_card`, `...fourArc_conic_card_order` | the negative knowledge claim is not a mathematical assertion and should not be formalized |

### The Clebsch family across fields

| assertion | current mode | existing Lean terminal | gap |
|---|---|---|---|
| `prop:clebsch-family-uncovered` — the uncovered cardinality formula, the containment of the associated conic in the third residue class, the off-conic excess factorization, and the conclusion that the conic is the complete deep-hole locus exactly at order eleven | Lean | `ClebschChordDefect.clebsch_uncovered_formula`, `ClebschChordDefect.orders_of_clebsch_uncovered_conic_card` | the residue-class containment step cites Dye's non-secant edge discussion and is not formalized |
| Dye's existence theorem forcing characteristic not two and five a square | cited | none | external transfer |
| `rem:` three regimes — the uncovered polynomial factors with roots at five and nine; at nine the locus is empty so the arc is complete; at nineteen the twenty conic points remain uncovered and one hundred twenty further points escape, so the locus lies on no conic | mixed | none | full gap; arithmetic is elementary and should be formalized |

### The code and its projective syndrome locus

| assertion | current mode | existing Lean terminal | gap |
|---|---|---|---|
| The displayed parity-check matrix defines a code of the stated MDS parameters | Lean | `Q11Coding.witness_mds_columns` | none |
| The six columns lie on no conic, so the code is not monomially equivalent to a generalized Reed–Solomon code | mixed: the nonsingular evaluation minor is displayed; the dual-GRS and normal-rational-curve dictionary is cited | none | the minor computation should be formalized; the dictionary is an external transfer |
| Each uncovered direction lifts to field-order-minus-one weight-three cosets, each with twenty minimum-weight leaders | cited to the same dictionary | `Q11Coding.brianchon_weightTwo_leaderSupports` covers the Brianchon stratum only | the leader-count clause is an external transfer |
| The worked example syndrome, its weight-three error, and its twenty supports | Lean | covered by the decoder terminals | none |
| `prop:deep-holes-conic` — covering radius three and equality of the uncovered locus, the projective deep-hole locus, and the conic's rational points | Lean | `Q11Coding.witness_code_coveringRadius_three`, `Q11Coding.projective_distanceThreeDirections_eq_standardConic` | none |
| `cor:named-variety` — twelve directions, one hundred twenty deep-hole cosets, twenty leaders each, two thousand four hundred leaders, and one hundred fifty-nine thousand seven hundred twenty received-word deep holes | arithmetic corollary of the above | none | full gap; elementary counting that should terminate in Lean |
| `prop:a5-point-orbits` — the seven orbit lengths, the identification of the first four orbits, and uniqueness of the twelve-point orbit | Lean for the explicit action | `Q11A5PointOrbits.point_orbit_partition`, `...unique_six_orbit`, `...unique_twelve_orbit`, `...brianchon_points_one_orbit` | the manuscript's structural derivation by Maschke, Brauer characters, eigenspaces, and orbit–stabilizer is not formalized; the Lean route checks the displayed order-sixty action instead, and the identification of that action with the classical icosahedral one uses Dye |
| The Maschke and Brauer-character step proving absolute irreducibility of the cross-characteristic reduction | human proof | none | full gap |
| The elementwise fixed-point counts for involutions and elements of order three and five | human proof | none | full gap |
| The subgroup fixed-point table and its exhaustiveness under the standard subgroup classification of the alternating group of degree five | human proof plus cited classification | none | full gap |
| The monomial automorphism extension with cyclic kernel and split alternating quotient, of total order six hundred | human proof | none | full gap |
| `prop:deep-hole-orbit` — transitivity on the one hundred twenty cosets, the semidirect product order, transitivity on all received-word deep holes, and cyclic stabilizer of order five | human proof | none | full gap |
| The coset-leader weight distribution and the codeword weight enumerator forced by MDS parameters | stated | none | full gap |
| `prop:decoding-oracle` — the four-case distance oracle, the four ambiguity counts, the secant-index rule, and the twenty-support leader statement | Lean | `Q11Coding.totalSyndromeDistance_exact`, `...ambiguity_strata_sound`, `...ambiguity_strata_counts`, `...brianchonDirectionIndices_eq_indexThree` | none |
| The five self-polar triangles of Edge and Dye and their matching partition of the fifteen pairs | cited | none | external transfer feeding the support-bipartition section |

### The invariant support bipartition

| assertion | current mode | existing Lean terminal | gap |
|---|---|---|---|
| The twenty three-element supports split into two complementary orbits of size ten | human proof | implicit in the orientation spine's support signs | needs an explicit terminal |
| `prop:brianchon-support` — the alternating six-cycle construction, the opposite-edge matching, the two equivariant bijections onto Brianchon points and complementary support pairs, and the Petersen adjacency rule | human proof, with Edge's concurrence cited | none | full gap |
| `cor:decoder-brianchon` — the ten triple-ambiguity directions are exactly the Brianchon points, their three supports form a perfect matching, and the ten matchings are exactly those outside the five self-polar ones | human proof, resting on the preceding proposition | partially `Q11Coding.brianchonDirectionIndices_eq_indexThree` and `...brianchon_weightTwo_leaderSupports` | the matching-theoretic conclusion is not formalized |
| `prop:invariant-support-bipartition` — only the bipartition is intrinsic, each coset has ten leaders in each class, the global split is twelve hundred and twelve hundred, every monomial automorphism preserves the unordered bipartition, and the outside normalizer coset exchanges the classes but is not an automorphism | human proof | none | full gap |

### The intrinsic orientation two-graph

| assertion | current mode | existing Lean terminal | gap |
|---|---|---|---|
| The coordinate identification of the support cubic with the published six-nodal symmetric equation of Cheltsov, Tschinkel, and Zhang | model identification, cited | none | external transfer; explicitly not used for singular-locus completeness |
| The antipodal quotient onto six axes and the suborbit lengths of a point stabilizer | Lean | `PaperIOrientationCover.antipodalQuotient_fiber_card_two`, `...fiveOrbitals_selfPaired`, `...fiveOrbital_one_mem_each_other_fiber` | none |
| `thm:orientation-two-graph` clause (i) — opposite signs on the two support orbits, vanishing signed moments below degree three, and the first nonzero moment being the cubic line | Lean | `PaperIOrientationHolonomy.supportCubic_translation_invariant`, `...pairBalance_iff_sq_five` | none |
| `thm:orientation-two-graph` clause (ii) — the signed matrix on the fibre-odd lattice with zero diagonal, unit entries, and square five times the identity, switching under representative change and negation under orbital exchange | Lean | `PaperIOrientationPentagon.signedOrbitalMatrix_sq` | the switching and negation clauses need explicit terminals |
| The triangle-product identity relating cubic coefficients to signed entries | Lean | `PaperIOrientationHolonomy.supportSign_eq_triangleProduct` | none |
| The determinant pencil identity and its homogeneous odd part | Lean | `PaperIOrientationDeterminant.det_signedOrbital_add_diagonal`, `...determinantPencil_oddPart_eq_supportCubic` | none |
| The four-point two-graph identity and the converse reconstruction of the switching class | Lean | `PaperIOrientationHolonomy.fourPoint_twoGraph_identity` | none |
| Uniqueness of the balanced switching class up to relabelling, via the pentagon of positive edges and the single class of twelve labelled pentagons | human proof inside the same theorem | none | gap |
| The orbital-difference identity relating the squared difference to ten times the identity minus the deck involution | Lean | `PaperIOrientationPentagon.orbitalDifference_sq_eq_ten_one_sub_deck` | none |
| Connectivity of the five-valent orbital graph and the exclusion of constant sign patterns | human proof | none | gap |
| The principal-minor values, Jacobi complementary-minor step, and the sign relation on complementary triples | human proof supporting the pencil | none | gap |
| The golden eigenmatrix identity, orthogonality of the two eigenspaces, and the cross-golden block determinant equalling the negated cubic | Lean | `PaperIOrientationTraceDual.det_crossGoldenBlock_eq_neg_supportCubic` | none |
| The tensor decomposition of the homomorphism space and the explicit four-dimensional trace-annihilator family with its determinant formula | human proof | none | gap |
| The invariant-dimension character computation showing a one-dimensional space of invariant cubics, hence identification with the Clebsch diagonal cubic, and smoothness of that surface | human proof | none | gap |
| Transfer of six ordinary nodes in linear general position through the Hassett–Tschinkel determinantal equivalence | Lean relative to a cited theorem | `PaperIOrientationTraceDual.hassettTschinkel_six_nodes_of_traceDual` | the cited proposition is an external transfer that must be proved or audited |
| `cor:orientation-cubic-geometry` — exactly six singular points forming a projective frame, all ordinary nodes, projective automorphism group the symmetric group of degree five, and the rational and integral commutants | Lean, with the commutants conditional | `PaperIOrientationNodes.supportCubic_singularLocus_eq_frame`, `...framePoints_ordinaryNodes`, `PaperIOrientationSymmetry` terminals, `PaperIOrientationCommutant` terminals | the classical odd three-plus-three splitting interface is a proposition-valued parameter and must become a theorem |
| The Hessian block computation, its characteristic polynomial, and the ordinary-double-point conclusion | Lean | `PaperIOrientationNodes.supportCubic_framePoints_ordinaryNodes` | none |
| The five-matching normalizer argument and the six-cubic-line bound giving the two stabilizers | Lean | `PaperIOrientationSymmetry.mem_supportCubicProjectiveStabilizer_iff_cubicLine`, `...supportCubic_projectiveStabilizer_equiv_S5`, `...mem_orientedSupportCubicStabilizer_iff`, `...orientedSupportCubic_stabilizer_equiv_A5`, `...orientedSupportCubic_index_two` | none |
| Schur's lemma and Galois descent giving the rational commutant | proposition-valued interface | `PaperIOrientationCommutant.oddModule_rationalCommutant_eq_adjoin_B` | conditional; the interface must be discharged |
| `rem:` conductor at two — the order has conductor two, all cubic coefficients become one modulo two, and the shifted matrix has rank one and square zero | human proof | none | gap; elementary and should be formalized |

### Verification section claims

The section's own assertions about what is proved where are metaclaims rather than
mathematics. They must be rewritten once the correspondence map is final, and every
count, hash, commit, and declaration name in it re-derived from the final tree.

## Part B — Computational companion assertions

| assertion | current mode | existing Lean terminal | gap |
|---|---|---|---|
| Restated chord-defect identity and bound | Lean | `ClebschChordDefect.chordDefect_identity_of_moments` | none |
| Restated conic-filling window and six-point specialization | partial Lean | `ClebschChordDefect.orders_of_clebsch_uncovered_conic_card` | the general window is not formalized |
| Restated geometric rigidity | Lean relative to Dye axioms | the `ClebschDye` terminals | Dye axioms |
| The conic-inscribed subcensus: all fifteen hundred forty-eight frame-normalized presentations, the two hundred fifty-two with vertices on a nonsingular conic, and their uncovered-size histogram | trusted execution | none | full gap |
| `tab:fifteen-classes` — the fifteen projective classes with stabilizer order, uncovered size, and least containing degree | finite certificate | none | full gap; every table entry is a mathematical assertion |
| The certificate identities relating stabilizer order to orbit mass, total mass, and uncovered size | finite certificate | none | full gap |
| `prop:low-degree-rigidity` — containment in a form of degree at most three characterizes the Clebsch class, with least degree two and the stated quadratic and cubic vanishing spaces | finite certificate | none | full gap; requires a verified Lean checker consuming the minors and the symbolic kernel |
| `cor:monomial-characterization` — uniqueness up to monomial equivalence of the code whose deep-hole locus lies on a curve of degree at most three, with alternating stabilizer | finite certificate plus cited Dye | none | full gap |
| `rem:degree-threshold` — the cutoff cannot be raised to four, with four named classes of least degree four and an explicit quartic whose rational zero set is the eighteen-point locus | finite certificate | none | full gap |
| `thm:gap` — the Clebsch class has uncovered size twelve, every other class at least sixteen, the equivalent characterization by size at most fifteen, and the consequence that larger loci lie on no conic | finite certificate plus exhaustive audit | none | full gap |
| The extension-count spectrum and its multiplicities across the normalized representatives | finite certificate | none | full gap |
| The assertion that no non-Clebsch uncovered locus lies on a nearer conic, checked over all one hundred sixty thousand nine hundred thirty nonsingular conics | trusted execution | none | full gap; this is the largest exhaustive domain in the companion |
| `lem:q9-polarity` — the polarity graph on the thirty-six internal points is the Sylvester graph with the stated intersection array, passant joins correspond to distance two, and the distance-two clique number is five | published theorem plus Lean | `Q9Sylvester.distanceTwo_clique_number_five` | the intersection-array computation and the Sylvester identification are external transfers |
| `thm:why11` — conic filling by a six-arc forces field order eleven, and then the arc is Clebsch | Lean plus the preceding lemma | combination of `ClebschChordDefect` and `Q9Sylvester` terminals | the arithmetic elimination of candidate orders needs an explicit terminal |
| `thm:q13-tangent-code` — the binary passant code has the stated parameters, exactly three hundred sixty-four minimum words in four orbits with named stabilizers, each spanning the code, and the minimum layer reconstructs the association scheme, the incidence matrix, and its automorphism group | mixed human proof, finite certificate, and trusted execution | none | full gap; the manuscript itself routes the current development to Paper IV |
| The Madison–Wu nullity formula and the Hollmann–Xiang elliptic scheme | cited | none | external transfers |
| The parity argument and the elementary weight lower bound of eight | human proof | none | gap; elementary |
| The weight-eight exclusion by Segre's lemma of tangents, the cyclic adjacency table, the five four-clique rows, and the local clique number five | human proof | none | full gap |
| The weight-ten exclusion by two exhaustive exclusive-or disjointness domains of the stated sizes, with an independent dynamic-programming replay | finite certificate | none | full gap |
| The twelve listed internal points with zero syndrome and dihedral stabilizer of order twenty-four, proving the exact distance | finite certificate | none | gap; the witness is small and should be directly checkable |
| The minimum-layer classification, pair and triple concurrence profiles, and identification of the seventy-eight zero-triple seven-cliques with the incidence rows | trusted execution | none | full gap |
| The invariant formulas, the six relation values, and the modulo-two intersection-algebra identities | human proof | none | full gap |
| The span argument by injectivity of one adjacency operator on the kernel | human proof | none | gap |
| The four-anchor rigidity argument, the simply transitive triple action, and the automorphism conclusion | human proof | none | full gap |
| `thm:small-k-conic-filling` — conic filling through eight points occurs only for the four-frame over the field of five elements and the Clebsch six-arc, and the maximum passant-arc size at the three terminal field orders is six and attained | mixed | `SmallKGeometricBridge.fourArc_uncovered_card`, `...fourArc_conic_card_order`, `...fiveArc_not_conic_card`, `...sevenArc_primePower_conic_card_spectra` | the seven-arc orbit exclusion, the eight-point terminal search, and the three-field bound are certificate-only |
| The seven-arc audit counts, orbit masses, and quadratic minors | finite certificate | partial: the spectra terminal | the orbit-level exclusion is not formalized |
| The exterior-set reduction and the conceptual exclusion at the first terminal order through the weight-eight impossibility | human proof | none | gap |
| The root-edge orbit DAG table, the rooted and global mass identities, the absence of a seven-point node, and the six-point witnesses | finite certificate | none | full gap |
| The coding restatement of the small-arc classification | human proof | none | gap |
| `tab:claim-modes` and `tab:replays` | metaclaims | none | must be rebuilt as a theorem-complete ledger |

## Part C — Reverse direction

All 51 gate terminals have a paper-facing role in the map above. None is orphaned, so
the reverse coverage condition of checklist section 2 is currently satisfied. Three
terminals need their role restated once names change: the two `OddSixArcPrismExtraction`
and `PaperIOrientation*` families are scheduled for renaming under checklist section 3,
and the correspondence map must be regenerated after those renames rather than before.

## Part D — Gap ledger

Grouping the gaps by what closing them actually requires:

**External transfers that must become proofs or audited library imports.** The two Dye
axioms; Dye's polarity, stabilizer, existence, and non-secant-edge results; Edge's
concurrence construction; the Davydov–Marcugini–Pambianco arc–coset dictionary and its
leader count; the Hirschfeld nucleus theorem; the Blokhuis–Brouwer–Szőnyi
conic-complement bound; the Blokhuis–Seress–Wilbrink exterior-set characterization; the
Storme–Thas normal-rational-curve dictionary; the Storme–Van Maldeghem classification
entry; the uniqueness of the one-factorization of the complete graph on six vertices;
the Hassett–Tschinkel determinantal equivalence; the Brouwer–Cohen–Neumaier and
Jurišić–Vidali Sylvester identification; the Abiad–Jabal Ameli–Reijnders clique value;
the Madison–Wu nullity formula; the Hollmann–Xiang association scheme; Segre's lemma of
tangents; and the classical odd three-plus-three splitting interface. That is eighteen
distinct external dependencies, several of which are substantial theorems in their own
right.

**Elementary arithmetic and counting gaps.** The deep-hole count corollary, the three
Clebsch-family regimes, the conductor-at-two remark, the candidate-order elimination in
the cross-field uniqueness theorem, the parity weight bound, and the coding restatement
of the small-arc classification. These are cheap and should be closed first.

**Structural human proofs with no formal counterpart.** The orbit-classification
derivation by Maschke and Brauer characters, the monomial automorphism extension, the
deep-hole orbit theorem, the Brianchon–support dictionary and the invariant support
bipartition, the switching-class uniqueness argument, the trace-annihilator family and
invariant-cubic dimension count, and the companion's association-algebra span and
four-anchor rigidity arguments. These are the bulk of the genuinely new mathematical
work in the remediation.

**Finite classifications currently backed only by certificates or execution.** The
fifteen-class census and its orbit ledger; the low-degree rigidity minors and symbolic
kernel; the numerical gap and its extension spectrum; the exhaustive conic-distance
check over all nonsingular conics; the weight-ten exclusive-or domains; the minimum-word
classification and concurrence profiles; the seven-arc orbit exclusions; and the
root-edge orbit DAG for the three terminal field orders. Each needs a Lean checker whose
soundness and coverage are themselves proved, not merely an imported data file.

The exhaustive conic-distance check and the root-edge DAG are the two largest domains
and should be scoped before any of the certificate work begins, since they determine
whether a verified-checker approach is feasible at all or whether the underlying
assertions need to be reproved structurally.

## Part E — What Mathlib supplies for the external transfers

Every external transfer must end either in a Lean proof or in an audited kernel-checked
library theorem, so the first question for each is whether Mathlib already has it. A
bounded survey of the pinned Mathlib checkout gives a sharp split.

Mathlib supplies the representation-theoretic layer. Maschke's theorem is in
`Mathlib/RepresentationTheory/Maschke.lean`. Schur's lemma is available both as
`bijective_or_eq_zero` for simple modules in `Mathlib/RingTheory/SimpleModule/Basic.lean`
and in the finite-dimensional representation category through
`Mathlib/CategoryTheory/Preadditive/Schur.lean`, re-exported by `FDRep`. Ordinary
character theory, including orthogonality, is in `Mathlib/RepresentationTheory/Character.lean`,
and Hilbert's theorem 90 is available for the Galois descent step. Strongly regular graphs
have a development in `Mathlib/Combinatorics/SimpleGraph/StronglyRegular.lean`.

Mathlib does not supply the finite-geometry layer. A search for arcs, ovals, hyperovals,
nuclei, conics in finite planes, and Segre's lemma of tangents returns nothing.
`Mathlib/Combinatorics/Configuration.lean` develops projective planes abstractly, as
incidence structures with nondegeneracy and existence axioms, not the coordinate conic
theory that Paper I needs. There is no Bézout theorem for plane curves, no theory of
exterior sets or complete arcs, no association schemes, and no Brauer character theory.

The practical consequence is that the eighteen external transfers do not form one class.
Maschke, Schur, ordinary characters, and Galois descent are library imports and should be
cheap. Everything geometric — Dye's four cited results, Edge's concurrence construction,
the Hirschfeld nucleus theorem, the Blokhuis–Brouwer–Szőnyi covering bound, the
Blokhuis–Seress–Wilbrink exterior-set characterization, the Storme–Thas
normal-rational-curve dictionary, the Storme–Van Maldeghem classification entry, Bézout's
bound on the two conics, Segre's lemma of tangents, the Sylvester-graph identification,
Madison–Wu's nullity formula, and the Hollmann–Xiang association scheme — has to be built
inside this development. The Brauer character step in the orbit classification likewise
has no library counterpart and needs an argument that avoids modular character theory or
develops the piece it uses.

That is not starting from nothing: the `RelativeConicArcs` namespace already carries a
homegrown projective plane, conic, arc, and certificate layer, which is where these
results belong. But it does mean the geometric transfers are original formalization work
rather than import work, and they dominate the remaining cost.

## Progress

The elementary arithmetic group is partly closed. The module
`RelativeConicArcs/ClebschFamilyRegimes.lean` in the base library now proves the
factorization of the Clebsch uncovered-cardinality formula, the characterization of the
orders at which the uncovered set is empty, the off-conic excess formula, the reduction of
exact conic filling to orders four and eleven, the order-nineteen values, and the
deep-hole counting layer with its specialization to the displayed code. All six terminals
depend only on the standard logical axioms, with no `sorry`, native execution, or project
axiom. The module is not yet imported by the aggregate gate; gate rewiring and the
manifest and hash refresh it forces are deliberately batched until more of the
formalization has landed, so that the heavy aggregate replay runs once rather than after
each module.

## What this step does not establish

No renaming, docstring, provenance, manifest, gate, axiom-audit, or release work was
performed. Checklist sections 3 through 11 remain open, and the remaining bullets of
section 2 — assigning stable declaration names to every inventoried assertion,
formalizing the gaps, and obtaining independent line-by-line reviewer sign-off — depend
on the scoping decisions above.
