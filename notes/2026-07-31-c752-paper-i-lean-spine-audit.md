# C752 — Paper I Lean proof-spine correspondence audit

**Status:** complete.  The reviewed C753 interface is frozen below.

## Frozen inputs

- Final C751 source history: `66484219`, `283e3509`.
- Referee-approved source blob: `7ec1f4c1aa78f58729039ae4bd18ab4ac1c15662`.
- Paper-I certificate repository: `42ab1a2db30178cf23aa8393d886c63ded24bfbd`.
- Pinned `finitegeom` dependency: `ef6317c5e1a348a91a1928104f9c8e1831bfb03d`.
- Pinned mathlib: `571b8a8e54219b4d393f75f4b8653fac08197fcc`.
- Paper terminal gate: `RelativeConicArcs.Gates.ClebschRigidityTrust`.

The audit credits a Lean declaration as corresponding to a manuscript step
only when its definitions and causal mechanism agree, or when an explicit
bridge theorem connects the two mechanisms.

## First-pass spine verdict

| Manuscript stage | Current formal surface | Initial verdict |
|---|---|---|
| Six-arc chord moments and `|U|+c=22` over `F_11` | `SixArcDefectBridge.sixArc_uncovered_add_brianchon_card` derives the equality from the first and second secant moments and the index bound `r<=3` | Same mechanism, specialized exactly to `PG(2,11)` |
| Universal chord-defect identity | `ClebschChordDefect.chordDefect_identity_of_moments` proves only the algebraic elimination from three supplied moment/partition equations | Partial bridge; the universal geometric hypotheses are not assembled here |
| Odd six-arc line bound `|l intersect U| <= q-5` | `OddSixArcLineBound.uncoveredOnLine_card_le_order_sub_five` assumes the disjoint-line equality case is impossible | Human-only affine seam remains; the scalar contradiction alone does not construct the triangular-prism bridge |
| Exclusion of a degenerate containing conic | Not imported or stated by `ClebschRigidityTrust` | Gap relative to manuscript implication (i) to (ii) |
| Twelve-point upper/lower-bound trap inside a nonsingular conic | `Q11DyeConsequences.sixArc_cards_of_uncovered_subset_conic` combines the proved defect identity, Dye's bound, and the twelve-point conic cardinality | Same mechanism |
| Equality to the Clebsch hexagon | `Q11DyeAxioms.dye1991_equality_classification` and `isClebschHexagon_of_uncovered_subset_conic` | Exact declared classical seam, specialized to `PG(2,11)` |
| Associated conic, code equivalence, decoder, and counts | `Q11Coding`, `Q11SemanticLeaders`, `Q11DecodingSynthesis`, and the q11 certificate modules | Mostly exact finite/kernel checks of the displayed witness; definition bridges and causal ordering still under audit |
| `A5/C5 -> A5/D5`, self-paired orbitals, signed pentagon, and `B^2=5I` | No Paper-I Lean terminal; the separate `ClebschOrientationMechanisms` gate contains only generic involution splitting and the Petersen pair-sum eigenspace | Human-only at the paper-specific level |
| Holonomy, switching, determinant pencil, trace-dual complement, cubic, nodes, and integral commutant | No corresponding Paper-I Lean declarations found in either terminal gate | Human-only |

## Material findings already settled

1. The current rigidity gate proves the nonsingular-conic containment
   implication, not the manuscript theorem whose first condition permits a
   degenerate conic.  The manuscript's line-bound route is therefore not yet
   represented by the gate.
2. `OddSixArcLineBound` is unusually honest about the missing step: its final
   theorem takes `hfiveImpossible` as an argument.  C753 must formalize the
   affine triangular-prism construction, not merely reuse
   `triangularPrism_parallelism_contradiction` and call the line bound closed.
3. The q11 defect/equality trap is genuinely the same proof as the manuscript:
   the first and second secant moments give `|U|+c=22`, Dye gives `c<=10`, and
   nonsingular-conic containment gives the opposite cardinal bound.
4. The two Dye assumptions are exposed by name and downstream axiom audits.
   They are specialized to `PG(2,11)`, so the manuscript's local field
   hypotheses are discharged by specialization rather than represented as a
   general theorem.
5. The orientation trust boundary is accurately disclosed in the paper
   manifest and certificate README: exact Python replay plus human proof, with
   no claim that the Paper-I Lean gate formalizes orientation.  This is honest
   release prose, but it confirms that C753 needs a new paper-specific formal
   spine rather than a renaming pass.

## Initial C753 dependency order

1. Close the affine triangular-prism seam over odd Desarguesian planes and
   instantiate the complete six-arc line bound at `F_11`.
2. Formalize the classification/cardinality bridge for degenerate plane
   conics and prove the manuscript's possibly-degenerate containment theorem.
3. Package the q11 defect, line, twelve-point, and Dye stages into one terminal
   theorem whose implication graph matches the manuscript.
4. Freeze exact bridges from projective points and uncovered loci to syndrome
   directions, cosets, leaders, and the displayed code before changing the
   orientation surface.
5. Build the orientation spine in dependency-sized packets: coset cover and
   orbitals; pentagon and golden operator; holonomy and switching; determinant
   pencil; representation/trace complement; cubic geometry and commutant.
6. Only then extend the Paper-I gate, axiom audit, trust manifest, generated
   repository, and standalone release root.

## Prose and naming audit — open checklist

The transitive referee-facing closure includes the certificate repository,
its pinned `finitegeom` dependency, generators, manifests, axiom output, and
paper verification metadata.  Module headers and public docstrings examined
so far are strongest at the two trust seams: `Q11DyeAxioms`,
`SixArcDefectBridge`, `OddSixArcLineBound`, and both import gates state their
residual hypotheses plainly.  The full generated/private comment census and
artifact-reference check remains in progress; no prose repair is authorized
under C752.

Early prose defects to route to the owning sources in C753:

- the q11 generator writes `Generated by
  lean/scripts/generate-q11-a5-point-action.py` into 66 leaves/aggregators,
  but the released repository contains the generator at
  `scripts/generate-q11-a5-point-action.py`; the reverse repository-relative
  reference is stale;
- `Q11A5PointOrbits` calls every nonsingular projective matrix a “reflected
  lift,” although the declaration proves only nonsingularity of the sixty
  normalized lifts;
- the same module calls kernel-checked row theorems “opaque certificates.”
  This is not a trust error, but “bounded row certificates” would state the
  mechanism more accurately.

## Final bidirectional correspondence map

The final audit distinguishes a theorem about the displayed q11 witness from a
theorem reconstructing an arbitrary six-arc.  The former is already strong;
the latter is where the two geometric seams occur.

| Paper object or inference | Exact formal object | Final status |
|---|---|---|
| projective point of `PG(2,11)` | `ProjectiveSpace.Point (ZMod 11) 2`; the finite package uses `PointIndex` and `pointVec` with `canonicalIndex` | Exact bridge for the 133 displayed representatives; a reusable equivalence theorem between the abstract point type and `PointIndex` is still required |
| six-arc and chord index | `Arc A` and `pointIndex A x` | Same definitions; `SixArcDefectBridge.uncovered_eq_indexZero` is private and must become a reviewed public bridge |
| uncovered locus | `uncovered A ∅`, equivalently the off-arc index-zero fibre | Same object after the preceding bridge |
| Brianchon concurrence locus | `Q11DyeAxioms.brianchonPoints A`, the off-arc index-three fibre | Same object; the injection into six-vertex perfect matchings and the bound `c ≤ 15` are kernel-checked |
| universal chord defect | `ClebschChordDefect.chordDefect_identity_of_moments` | Same algebraic elimination, but conditional on supplied moments and partition; the projective incidence assembly is not a terminal theorem |
| q11 identity `|U|+c=22` | `SixArcDefectBridge.sixArc_uncovered_add_brianchon_card` | Same mechanism and exact specialization |
| odd six-arc line bound | `OddSixArcLineBound.uncoveredOnLine_card_le_order_sub_five` | Partial: it assumes `hfiveImpossible`; the affine triangular-prism construction is absent |
| arbitrary containing conic | only `Conic.NonsingularConic` occurs in `Q11DyeConsequences` | Missing degenerate-conic exclusion |
| twelve-point equality trap | `sixArc_twelve_le_uncovered_card` and `sixArc_cards_of_uncovered_subset_conic` | Same mechanism once nonsingularity is available |
| equality classification | `Q11DyeAxioms.dye1991_equality_classification` | Exact published conditional input, with theorem/page/DOI pinpoint |
| Clebsch parity-check code | `Q11Coding.witnessCode`, the kernel of the six displayed columns | Exact displayed code; `witness_mds_columns`, dimension, distance, and covering radius are kernel-checked |
| projective deep-hole locus | `projective_distanceThreeDirections_eq_standardConic` | Exact displayed-witness equality, not an abstract reconstruction theorem |
| cosets and leaders | affine syndromes modulo the parity-check kernel; `syndromeDistance`, `leaderWords`, and the semantic leader-support tables | Exact code/coset dictionary and minimum-weight semantics |
| decoder and ambiguity counts | `Q11DecodingSynthesis.totalSyndromeDistance_exact`, `ambiguity_strata_sound`, and `ambiguity_strata_counts` | Exact finite/kernel checks; the causal order is code → syndrome distance → leaders → counts |
| associated conic and monomial equivalence | displayed standard conic plus projective equivalence of parity-check columns | The displayed witness is exact; the arbitrary-arc-to-code statement must use explicit projective-to-monomial and scalar-column bridges |
| orientation cover through integral commutant | no Paper-I terminal; `Gates.ClebschOrientationMechanisms` exposes only generic involutive splitting and the Petersen pair-sum eigenspace | Human-only at Paper-I strength |

No different-mechanism endpoint has been credited as correspondence.  In
particular, the exact q11 orbit tables do not replace the affine-prism proof,
and the generic orientation gate does not replace the paper's coset, pentagon,
holonomy, determinant, trace-dual, or commutant arguments.

## Completed referee-facing prose and naming audit

The audited closure consists of the 118 content-addressed q11 modules at
`42ab1a2d`, their sole generator, the gate/README/provenance/manifest/axiom
surfaces, and the project-owned `finitegeom` modules imported by the gate or by
the two proposed rigidity bridges.  Generated leaves were audited through the
owning generator and byte identity, rather than treated as 66 independent
prose sources.

The trust prose in `Q11DyeAxioms`, `Q11DyeConsequences`,
`SixArcDefectBridge`, `OddSixArcLineBound`, the import gate, README, manifest,
and tracked axiom output is accurate.  The package makes no orientation claim,
does not hide `native_decide`, and exposes the two Dye axioms.  The remaining
repairs are finite and source-owned:

1. In `scripts/generate-q11-a5-point-action.py`, repair the generated banner
   from the nonexistent `lean/scripts/...` path to the repository-relative
   `scripts/...` path.  Regenerate the 55 arithmetic leaves and 11 aggregators;
   do not hand-edit them.
2. In `Q11A5PointOrbits.lean`, replace “opaque certificates” by “bounded
   kernel-checked row certificates.”
3. In `Q11A5PointOrbits.lean` and `Q11A5PointOrbitsData.lean`, replace the ten
   uses of “reflected lift/projectivity/action” by “normalized projective
   lift/projectivity/action.”  The declarations prove normalization,
   nonsingularity, and the action tables; they do not define a reflection.
   Declaration names themselves are neutral and need not change.
4. In `SmallKChordMoments.lean`, replace the forecast “a later integration
   leaf can package ...” by a timeless statement of the exact conditional
   boundary.  This is the only status-language defect found in the relevant
   pinned dependency prose.
5. Give the new C753 bridge and orientation declarations self-contained
   docstrings and stable literature pinpoints.  The Hassett--Tschinkel input
   must be a named conditional interface for Proposition 10, not prose hidden
   behind a coordinate theorem.

All repository-local artifact references in the audited gate, README,
provenance file, manifest, and axiom audit resolve.  No internal note, task ID,
agent/session label, private URL, machine-local path, `TODO`, or `FIXME` occurs
in the reviewed closure.

## Frozen C753 rigidity interface

The rigidity work is dependency ordered and may not be replaced by the
existing finite endpoint checks.

1. **R1 — affine prism.**  In `OddSixArcLineBound.lean`, prove
   `disjointLine_fiveUncovered_impossible` by constructing the three affine
   connector directions and applying
   `triangularPrism_parallelism_contradiction`.  Then expose
   `sixArc_uncoveredOnLine_card_le_order_sub_five` without the
   `hfiveImpossible` argument and specialize it to `Point (ZMod 11)`.
2. **R2 — degenerate conics.**  In a new
   `SixArcDegenerateConicExclusion.lean`, classify a nonzero degenerate ternary
   quadratic over an odd field as a repeated line or two lines after scalar
   extension, prove that containment of `uncovered A ∅` forces a forbidden
   line intersection by R1, and export
   `sixArc_uncovered_subset_conic_implies_nonsingular`.  If the algebraic
   factorization cannot be kept within this file, freeze it as a separate
   exact conditional interface; do not silently strengthen “conic” to
   “nonsingular conic.”
3. **R3 — q11 causal terminal.**  In
   `Q11RigiditySpine.lean`, compose the public uncovered/index bridge, R1, R2,
   `sixArc_uncovered_add_brianchon_card`, the two Dye assumptions, and the
   twelve-point cardinality into
   `isClebschHexagon_of_uncovered_subset_planeConic`.  The printed axioms must
   be exactly the ordinary logical axioms plus the two named Dye inputs.
4. **R4 — code-language bridge.**  In `Q11CodeRigidityBridge.lean`, expose the
   equivalence from abstract projective points to canonical `PointIndex`, the
   equality between uncovered points and projective distance-three syndrome
   directions, projective column equivalence → monomial code equivalence,
   and coset/leader semantics.  Terminal
   `deepHoleLocus_rigidifies_witnessCode` must distinguish projective,
   monomial, and literal equality.

## Frozen C753 orientation packets

Each packet is a separately reviewable module and gate target.  A packet may
use earlier packets, mathlib, and the two generic mechanisms already printed
by `Gates.ClebschOrientationMechanisms`; it may not use the exact Python replay
as a substitute for the stated group/incidence argument.

1. **O1 — cover and orbitals** (`PaperIOrientationCover.lean`): construct the
   explicit `A5/C5 → A5/D5` quotient, deck involution, two self-paired
   five-valent orbitals, and one-point-per-other-fibre incidence.  Export
   `antipodalQuotient_fiber_card_two`, `fiveOrbitals_selfPaired`, and
   `fiveOrbital_one_mem_each_other_fiber`.  Proof mechanism: cosets, the two
   inverse-stable double cosets, and regular `C5` actions.
2. **O2 — signed pentagon and golden square**
   (`PaperIOrientationPentagon.lean`): define the fibre-odd orbital matrix,
   prove lift changes are diagonal switching and orbital exchange is negation,
   obtain opposite side/diagonal signs from connectivity and the absence of an
   `A5 → C2` quotient, and prove `signedOrbitalMatrix_sq` and
   `orbitalDifference_sq_eq_ten_one_sub_deck` by the paper's two cancellation
   cases.
3. **O3 — triangle holonomy and switching**
   (`PaperIOrientationHolonomy.lean`): prove triangle-product invariance,
   complementary sign exchange, the four-point identity, gauge reconstruction
   of the switching class, pair balance ⇔ `B^2=5I`, uniqueness via the
   two-regular graph on five vertices, and vanishing degree-zero/one/two signed
   moments.  Export `supportSign_eq_triangleProduct`,
   `fourPoint_twoGraph_identity`, `pairBalance_iff_sq_five`, and
   `supportCubic_translation_invariant`.
4. **O4 — principal minors and determinant pencil**
   (`PaperIOrientationDeterminant.lean`): prove the size-three minor formula,
   Jacobi complementary-minor values in sizes four and five, determinant
   `-125`, the full diagonal expansion, and the homogeneous odd part.  Export
   `det_signedOrbital_add_diagonal` and
   `determinantPencil_oddPart_eq_supportCubic`.  Proof mechanism: multilinear
   determinant expansion and `B⁻¹=B/5`, not a six-variable normalization check.
5. **O5 — cross-golden trace dual** (`PaperIOrientationTraceDual.lean`): define
   the two displayed golden eigenspaces and the cross block, prove translation
   invariance and `det_crossGoldenBlock_eq_neg_supportCubic`, identify its
   five-dimensional image and four-dimensional trace annihilator, and expose
   `hassettTschinkel_six_nodes_of_traceDual` as the exact cited Proposition 10
   conditional interface.  The coordinate basis calculation may be
   kernel-checked, but the trace pairing and dimension bridge must be symbolic.
6. **O6 — singular locus and node type** (`PaperIOrientationNodes.lean`): use
   O5 only for completeness, then prove the six displayed frame points are
   singular and the Hessian has projective rank four from the deleted
   principal block of `B^2=5I`.  Export `supportCubic_singularLocus_eq_frame`
   and `supportCubic_framePoints_ordinaryNodes`.
7. **O7 — recovered symmetry** (`PaperIOrientationSymmetry.lean`): derive the
   permutation action on the complete frame, identify the regular two-graph
   automorphism group with `S5`, and its sign kernel with `A5`.  Export
   `supportCubic_projectiveStabilizer_equiv_S5` and
   `orientedSupportCubic_stabilizer_equiv_A5`.  Any group-order computation
   must be connected to the normalizer theorem, not left as enumeration.
8. **O8 — rational and integral commutants**
   (`PaperIOrientationCommutant.lean`): formalize the conjugate `3+3'`
   splitting, Schur/Galois descent, and the diagonal/off-diagonal integrality
   test.  Export `oddModule_rationalCommutant_eq_adjoin_B` and
   `oddLattice_integralCommutant_eq_ZsqrtFive`.  This packet may state a
   reviewed conditional interface for the classical `A5` irreducible
   decomposition, but must expose it in the axiom audit.

`PaperIOrientationSpine.lean` may import O1–O8 only after each packet's own
single-file elaboration, exact axiom audit, and prose review pass.  The Paper-I
release gate is extended only after R1–R4 and O1–O8 all pass.

## Validation and closeout decision

C753 must validate in this order: owning-module elaboration; packet gate;
reverse-import gates affected in `finitegeom`; exact Paper-I axiom audit;
q11 generated-source check; q11 package build; paper trust-manifest and
aggregate release; warning-free PDFs; authoritative-to-standalone forward
synchronization; and a context-free cold comparison of the human and Lean
dependency graphs.  The two Dye axioms, the exact Hassett--Tschinkel interface,
and any admitted classical `A5` representation interface remain separately
named in the final boundary.

The `ej` + `tt` pass found no cheaper theorem that collapses orientation into
the existing generic gate.  Its useful upgrade was the split of the former
“cubic geometry and commutant” bundle into trace-dual, nodes, symmetry, and
commutant packets; this removes the largest hidden implementation design
choice.  No incidental result crossed the discovery-track discriminator.

## Mystery ledger

- **Settled:** why the q11 equality trap looked complete while the manuscript
  theorem was not.  The gate begins after nonsingularity; R1 and R2 name the
  two missing implications.
- **Settled:** whether the orientation gap was merely naming.  It is not: O1–O8
  identify eight absent paper-specific mechanisms.
- **Open, owned by R2:** whether mathlib already supplies the exact odd-field
  projective classification of degenerate ternary quadratics.  The evidence
  gap is an import-level theorem with the repeated-line/two-line conclusion;
  R2 must either locate it or expose a narrow conditional interface.
- **Open, owned by O8:** the smallest existing formal interface for the
  rational `A5` decomposition and Schur/Galois descent.  This affects only the
  trust shape of O8, not O1–O7.
