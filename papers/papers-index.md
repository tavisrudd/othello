# Papers index

Publication-track staging. Each subdirectory is a **candidate paper**: a curated view (symlinks
into `../notes/`) of the source notes for one result, plus a `README.md` status map. A directory
is a staging area, **not** a commitment to a separate publication. The Fable review (2026-07-12)
resolved the decomposition to **five papers (+1 conditional) + two OEIS**: baer + completion merge,
dihedral bundles the D₂ₘ family, continuation is N1-only, coding is conditional on its audit. See
`papers-planning.md` for the rulings, submission sequence, and per-paper guardrails.

## Games track — impartial cap / Nofil / Node-Kayles

| Directory                        | Working title                                                              | Status                                        |
|----------------------------------|----------------------------------------------------------------------------|-----------------------------------------------|
| `dihedral-schreier-node-kayles`  | Node Kayles on fixed-point-deleted Schreier graphs from conic involutions  | Draft near-complete, committed                |
| `nofil-finite-geometry-outcomes` | Outcome classes of cap/Nofil games on finite geometries (pairing/mirror)   | Partial draft; projective proven but unwritten |

*Split by technique:* Schreier-residual nimbers vs the pairing/mirror ⇒ P method.

## Geometry / coding track — Package 2 (arc extension & reconstruction)

| Directory                     | Working title                                                     | Status                                          |
|-------------------------------|------------------------------------------------------------------|-------------------------------------------------|
| `equivariant-robust-completion` | Equivariant extension and robust completion in finite geometry | Canonical merged paper; exact quadratic extension and completion spine Lean-built |
| `baer-equivariant-extension`  | Equivariant extensions of finite-geometric arcs                  | Source/staging view folded into canonical merged paper |
| `completion-core-rigidity`    | Robust completion of finite-geometric packings and codes         | Source/staging view folded into canonical merged paper |
| `continuation-graph-rigidity` | Semilinear rigidity/reconstruction from cap continuation graphs   | Theorem-package plan; N1 headline survives      |
| `arcs_complete_outside_conic` | Arcs complete outside a prescribed conic (secant-defect identity, bounds) | Self-contained manuscript + verifier + strict-trust Lean formalization; near submission-ready — *related but separate* |

*Common parentage:* all descend from "Package 2" in `../notes/2026-07-10-codex-publishable-spinout-audit.md`
and share the `lean/FiniteGeom/` base.

## Sequence submissions (OEIS) — see `oeis-submissions/`

| Subdirectory                             | Sequence                                                  | Status                                            |
|------------------------------------------|-----------------------------------------------------------|---------------------------------------------------|
| `oeis-submissions/A344227-queens-nimbers` | Node-Kayles nimbers of the n-queens game (extend a(14..17)) | Ready-to-paste; priority-stamp subset can go now  |
| `oeis-submissions/sumfree-Zn-nimbers`     | Grundy values of the sum-free game on ℤₙ (new entry)      | Draft, not submitted (no A-number yet)            |

## Non-formal / blog-style outputs — see `non-formal-bloggy/`

| Subdirectory                | Output                                                        | Status                        |
|-----------------------------|--------------------------------------------------------------|-------------------------------|
| `non-formal-bloggy/queens-n18` | n=18 Non-Attacking Queens solve: write-up + HTML report + explorable demo | Near-finished; dormant program |

## Manuscript state at a glance

- **Complete LaTeX manuscript (+ PDF + verifier + Lean package):**
  `arcs_complete_outside_conic` — near submission-ready.
- **Markdown manuscript exists:** `dihedral-schreier-node-kayles` (the committed submission).
- **LaTeX manuscript exists (partial):** `nofil-finite-geometry-outcomes`
  (`paper-sumfree-capgame/main.tex` — sum-free ℤₙ + affine cap written; projective unwritten).
- **Combined Markdown development draft + Lean lane:** `equivariant-robust-completion`, with the
  exact coordinate quadratic extension theorem. Continuation rigidity remains theorem-package only.
- **Sequence packages (ready/draft):** the two `oeis-submissions/` entries.

## Shared blocker

Several deliverables want a **public code/preprint URL** that does not exist yet (the repo has no
public remote): the A344227 `%H` link and n=18 comment, the sequences' program links, and any
arXiv posting of the manuscripts. One public mirror or preprint unblocks them together.

## Lean state at a glance

- **Formalized, `sorry`-clean:** the pairing/mirror geometry outcomes (`lean/ProjectiveCap/`,
  `lean/CapGame/`); the dihedral reduction + V₄→K₄ core (`lean/DihedralSchreier/`); the
  Baer/completion proof spine (`lean/FiniteGeom/BaerCompletion/`) and its projective-plane,
  coordinate-conjugation, and quadratic-Frobenius consumers (`lean/RelativeConicArcs/`); the
  completion δ_x = τ base identity (`lean/FiniteGeom/Completion.lean`); the coding/LRC seed
  (`lean/RepairCodes/`); and the complete arcs-outside-a-conic theorem/certificate package
  (`lean/RelativeConicArcs/`).
- **Planned, not built:** `ContinuationRigidity`. The exact quadratic Baer pair-extension data and
  semantic arc extension are Lean-proved; see `lean/FiniteGeom/BaerCompletion/TRUST.md`.
- **One exception to the axiom-clean bar:** a single `native_decide` in
  `DihedralSchreier/KleinFourBridge.lean` (`explicit_pairProducts`, a 4-element Klein-four
  enumeration) — an isolated witness with **no downstream dependents** (the V₄→K₄ reduction itself is
  clean); clear it to `decide`/manual before the dihedral paper ships. Everything else, including the
  `CertData` Q11/Q13 certs, is `native_decide`-free (the certs use a kernel-`decide` reflection route;
  `native_decide` was benchmarked and rejected to keep the axiom profile clean).
- **Release gate:** every lemma/proof must be Lean-formalized to the full `lean/TRUST.md` standard —
  `sorry`-free, `#print axioms` clean (no `sorryAx`/`native_decide`), statements adequate to the
  claim, with a trust-chain note — before its paper is published. The arcs-paper library is now
  complete; the remaining planned libraries and the dihedral paper-level theorems are
  release-blocking for their respective papers.
  Computational enumerations (queens, S₄/A₅ nimbers, ρ_𝒞 values) follow the `getK` pattern: a
  Lean-proved recurrence + a differential-tested reproducible solver, not `native_decide`. See
  `papers-planning.md` → *Authorship, provenance & reception*.

## Results → papers → proofs

Key computational results and proven lemmas/theorems, mapped to their paper and proof location.

**Paper aliases:** `nofil` = `nofil-finite-geometry-outcomes`; `dihedral` =
`dihedral-schreier-node-kayles`; `arcs` = `arcs_complete_outside_conic`; `baer` and `completion` =
`equivariant-robust-completion`; `continuation` =
`continuation-graph-rigidity`; `queens-n18` = `non-formal-bloggy/queens-n18`; `oeis:*` =
`oeis-submissions/*`; `coding` = the (unhomed) coding/LRC candidate (Lean `lean/RepairCodes/` +
`lean/FiniteGeom/` base).

**Proof-location key:** `lean <file>:<line> <ident>` = formalized, `sorry`-clean (paths under
`lean/`); `paper §N` = proven in that manuscript; `note <file>` = proven in a research note
(plan-stage, Lean deferred); `solver <path>` = computed by a cross-checked solver.

**Result-ID prefixes:** `thm-` = proven theorem/proposition (hand- or Lean-proven) · `lem-` =
supporting lemma · `comp-` = solver-computed value or machine-verified finite example. The ID
encodes result *type*; formalization status is in the proof-location column.

| ID                  | Result                                   | Description                                        | Paper               | Proof location |
| ------------------- | ---------------------------------------- | -------------------------------------------------- | ------------------- | -------------- |
| thm-mirror-general  | Mirror ⇒ P (general)                     | fpf line-preserving involution ⇒ 2nd player wins   | nofil               | lean `ProjectiveCap/Mirror.lean:246` `initialPStatement_of_fixedPointFree_collinearity_preserving_involution` |
| thm-cap-affine      | Cap game on AG(n,q) is P                 | affine cap game, every prime power q               | nofil               | lean `CapGame/Affine.lean:455` `initialP_of_nontrivial` |
| thm-cap-binary      | Cap game on PG(n,2) is P                 | binary projective cap game, all n                  | nofil               | lean `ProjectiveCap/Binary.lean:218` `initialPStatement_binary_of_finrank_ge_two` |
| thm-cap-elliptic    | Cap game on PG(2m−1,q) is P, q odd       | elliptic fpf involution ⇒ P                        | nofil               | lean `ProjectiveCap/EllipticMirror.lean:66` `initialPStatement_ellipticBlock_of_odd_card` |
| thm-cap-plane-even  | Cap game on PG(2,q) is P, q even         | even-characteristic plane ⇒ P                      | nofil               | lean `ProjectiveCap/PlaneOutcome.lean:54` `initialPStatement_of_even_card_finrank` |
| thm-cap-hyperbolic  | Cap game on Q⁺(2m−1,q) is P, q odd       | hyperbolic-quadric sub-board ⇒ P                   | nofil               | lean `ProjectiveCap/HyperbolicQuadricMirror.lean:192` `initialSubCapP_blockQuadric_of_odd_card` |
| thm-mirror-capc     | Capacity-c mirror                        | no-chord discharge ⇒ P at capacity c               | nofil               | lean `ProjectiveCap/CapCMirror.lean:158` `initialCapCP_of_no_chord` |
| thm-sumfree-law     | Sum-free ℤₙ outcome law                  | a(n)=0 iff n ≡ 0,1,5 (mod 6), n ≥ 5                | nofil, oeis:sumfree | paper `kernels/sumfree-zn.tex`; note `2026-07-04-sumfree-game-theorem.md` |
| thm-mirror-boundary | Mirror-method boundary (sharpness)       | parabolic & Hermitian carry no fpf involution      | nofil               | note `2026-07-09-mirror-method-boundary.md` |
| thm-capacity2-sharp | Capacity-2-only sharpness                | discharge fails for c ≥ 3 (PG(2,q) counterexample) | nofil               | note `2026-07-09-mirror-unification.md` |
| comp-pg43           | PG(4,3) is P (computed)                  | even-dim odd-q projective cap datum (frontier)     | nofil               | solver / note (open-frontier) |
| thm-v4-k4           | V₄ → K₄ residual                         | tame V₄ residual ≅ ((q+1−2s)/4)·K₄                 | dihedral            | paper §4 Thm 4.1; lean `DihedralSchreier/KleinFourBridge.lean:63` `live_orbitMap_injective` |
| thm-half-density    | Orbit-template ½-density                 | dihedral residual-template periodicity             | dihedral            | paper §12 |
| thm-burnside-phi    | Burnside invariant Φ_T                   | Φ_T : A(G) ⊗ F₂ → (ℕ₀, ⊕) homomorphism             | dihedral            | paper §11 Prop 11.1 |
| comp-s4-nimbers     | S₄ regular-template nimbers              | all four generating-triple classes 𝒢 = 0           | dihedral (App. A)   | solver `rust/scripts/nodekayles_cayley.rs` |
| comp-a5-nimbers     | A₅ regular-template nimbers              | 𝒢=1 for (2,3,5),(2,5,5); 𝒢=0 otherwise             | dihedral (App. A)   | solver `rust/scripts/nodekayles_cayley.rs` |
| thm-relative-complete | Relative completeness foundation      | maximal prescribed-hole arcs exist; `rho` is attained; incidence arcs agree with projective caps | arcs | lean `RelativeConicArcs/Arc.lean:141` `exists_completeOutside`, `:186` `exists_completeOutside_card_eq_rho`; `ProjectiveBridge.lean:154` `arc_iff_projectiveCap` |
| thm-relative-game-localization | Persistent cap-game localization | every cap continuation of `CompleteOutside A H` stays in `A∪H`; every later legal move lies in `H` | arcs, nofil | lean `RelativeConicArcs/ProjectiveBridge.lean:174` `projectiveCap_subset_union_of_completeOutside`, `:192` `move_mem_holes_of_completeOutside`, `:205` `legalExtensions_subset_holes_of_completeOutside` |
| thm-secant-moments  | Maximum index and secant moments         | `r_A(x)≤⌊k/2⌋`; `Σr=C(k,2)(q−1)`; `ΣC(r,2)=3C(k,4)` | arcs                | paper §2; lean `RelativeConicArcs/Moments.lean:202` `pointIndex_le_half_card`, `:290` `first_secant_moment`, `:510` `second_secant_moment` |
| thm-defect-identity | Prescribed-hole defect identity          | exact secant-index defect remainder identity       | arcs                | paper §3; lean `RelativeConicArcs/Defect.lean:214` `scaledDefect_eq_remainders` |
| thm-defect-corollaries | Defect equality, coverage, and stability | exact equality pattern, uncovered-locus bound, and quantitative bounded-defect control | arcs | paper §3; lean `RelativeConicArcs/Defect.lean:309` `scaledDefect_eq_zero_iff`, `:379` `uncovered_bound`, `:465` `stability_bound` |
| thm-conic-normalization | Nonsingular-conic normalization      | standard conic is `XZ=Y²`, has `q+1` points, and `rho` is invariant under projective normalization | arcs | lean `RelativeConicArcs/Conic.lean:286` `standardConic_card`, `:307` `mem_standardConic_iff_onConic`, `:422` `NonsingularConic.rho_points_eq` |
| thm-rho-finite      | Corrected finite lower bound             | arbitrary `q+1` holes obey the corrected capacity bound; `L₁(q)≤L₂(q)≤ρ_𝒞(q)` | arcs | paper §4; lean `RelativeConicArcs/Conic.lean:52` `corrected_capacity_bound_of_card_holes`, `:480` `L2_le_rho`, `:488` `L1_le_L2` |
| thm-rho-lower       | ρ_𝒞(q) asymptotic lower bound            | explicit `ρ_𝒞(q)≥√(2q)+3/2−8/√(2q)`, Big-O shortfall, and realized-field liminf wrapper | arcs | paper §4; lean `RelativeConicArcs/Asymptotic.lean:275` `rhoC_explicit_additive_lower_bound`, `:301` `additiveShortfall_isBigO`, `:410` `realized_three_halves_le_liminf` |
| lem-transitive-avoidance | Finite transitive-action avoidance | `|A||B|<|X|` gives a translate of `A` disjoint from `B` | arcs | lean `RelativeConicArcs/Averaging.lean:73` `exists_disjoint_smul` |
| thm-rho-transfer    | Averaging upper-bound transfer           | ρ_𝒞(q) ≤ t₂(2,q) when t₂(2,q) ≤ q; Kim–Vu remains an explicit hypothesis | arcs | paper §5; lean `RelativeConicArcs/Averaging.lean:267` `rhoC_le_t2`, `:288` `rhoC_le_of_kimVuBound` |
| lem-nucleus         | Even-char hyperoval and nucleus constraints | standard conic+nucleus is a hyperoval; tangents, nucleus-in/out incidence, and parity laws | arcs | paper §6; lean `RelativeConicArcs/Nucleus.lean:308` `standardHyperoval_arc`, `:377` `standardConic_tangent_iff_mem_nucleus`, `:475` `nucleus_mem_arc_constraints`, `:505` `nucleus_not_mem_arc_constraints` |
| thm-relative-cert   | Generic relative-arc certificate soundness | canonical `q²+q+1` coordinate checks imply semantic completeness and `rhoC≤witness.length` | arcs | lean `RelativeConicArcs/Certificate.lean:249` `check_sound`, `:255` `rhoC_le_length_of_check` |
| comp-rho-small      | ρ_𝒞 small values and arithmetic thresholds | `L₂(8)=L₂(9)=L₂(11)=6`, `L₂(16)=8`; ρ_𝒞(8)=ρ_𝒞(9)=ρ_𝒞(11)=6; 8 ≤ ρ_𝒞(16) ≤ 9 | arcs | paper §7 + verifier; lean `RelativeConicArcs/Results.lean:20`–`:90` |
| comp-q11-exterior  | q=11 exterior-secant design              | all 15 witness secants avoid the conic; required-point index distribution `(N₁,N₂,N₃)=(90,15,10)` | arcs | paper §7 + verifier `I_C=0` + paper moment equations |
| comp-q11-icosahedral | q=11 icosahedral residual P-position   | all 12 conic points live; determinant conflict graph has 30 edges and degree 5, is icosahedral, and is P by antipodal mirror | arcs, nofil | paper §7 remark; lean `RelativeConicArcs/Q11Residual.lean` `all_seed_legal`, `adj_iff_icosahedron`, `degree_five`, `isP` |
| thm-baer-criterion  | Orbit-valued extension criterion         | heterogeneous and uniform conjugate-pair bounds; exact coordinate theorem constructs an arc extension | baer | lean `FiniteGeom/BaerCompletion/PairExtension.lean` `PairExtensionData.sum_card_sub_le_legalCount`; `RelativeConicArcs/QuadraticForbidden.lean` `exists_quadratic_pair_extension` |
| thm-baer-saturation | Quadratic orbit-saturation bound         | denominator-free `2s(s−1) ≤ (k−1)²` core of the softened √2·s bound | baer | lean `FiniteGeom/BaerCompletion/OrbitSaturation.lean` `orbitSaturation_quadratic_bound_of_split` |
| thm-completion-tau  | δ(C) = τ                                 | semantic insertion distance = obstruction-transversal number in every finite hereditary system | baer, completion | lean `FiniteGeom/BaerCompletion/Obstruction.lean` `insertionDistance_eq_transversalNumber` |
| lem-completion-clutter | Minimal-obstruction reduction        | removing nonminimal dependent traces preserves every transversal and `τ` | baer, completion | lean `FiniteGeom/BaerCompletion/Clutter.lean` `transversalNumber_minimalEdges` |
| thm-completion-weighted | Weighted completion identity        | arbitrary nonnegative deletion cost = weighted transversal cost | baer, completion | lean `FiniteGeom/BaerCompletion/Weighted.lean` `weightedInsertionDistance_eq_weightedTransversalCostWithin` |
| thm-completion-multi | Multi-insertion identity               | simultaneous insertion of any independent finite set has exact transversal distance | baer, completion | lean `FiniteGeom/BaerCompletion/MultiInsertion.lean` `multiInsertionDistance_eq_transversalNumber` |
| thm-completion-weighted-multi | Weighted multi-insertion      | weighted deletion and prescribed-set insertion compose without extra hypotheses | baer, completion | lean `FiniteGeom/BaerCompletion/Weighted.lean` `weightedMultiInsertionDistance_eq_weightedTransversalCostWithin` |
| thm-secant-resilience | Arc insertion distance               | `δ_x` equals secant index in every finite abstract projective plane | baer, completion | lean `RelativeConicArcs/CompletionDistance.lean` `arcInsertionDistance_eq_pointIndex` |
| thm-baer-involution | Fixed/conjugate secant decomposition    | trace transport, fixed-pair classification, and disjoint conjugate traces | baer | lean `FiniteGeom/BaerCompletion/BaerPlane.lean`; `RelativeConicArcs/BaerIncidence.lean` |
| thm-baer-frobenius | Coordinate quadratic Frobenius           | incidence involution, Hilbert-90 fixed locus `PG(2,s)`, and exact `(s²−s)/2` linewise candidate count | baer | lean `RelativeConicArcs/QuadraticFrobenius.lean`; `RelativeConicArcs/QuadraticPairExtension.lean` |
| lem-baer-input-reduction | Quadratic count-input reduction   | exact count fields reduce to a 2-fiber map, complement, and injective charge | baer | lean `FiniteGeom/BaerCompletion/OrbitCounting.lean` |
| thm-baer-line-counts | Exact fixed-line occupation          | exact occupied/empty fixed-line formulas with nontruncating subtraction | baer | lean `RelativeConicArcs/QuadraticLineCounting.lean` `card_occupiedFixedLines`, `card_emptyFixedLines`, `choose_fixedArcPoints_le_star` |
| thm-baer-forbidden | Exact forbidden-candidate charging       | exact two-element secant orbits, injective charge, semantic coverage equivalence, and legal arc union | baer | lean `RelativeConicArcs/QuadraticForbidden.lean` `card_nonfixedSecantOrbits`, `card_forbiddenCandidates_le_baer`, `arc_union_candidate_of_not_mem_forbidden` |
| lem-baer-arithmetic | Quadratic Baer arithmetic                | `M=fe+e(e−1)`, eight-arc `M≤12`, candidate surplus, and occupied-line identity | baer | lean `RelativeConicArcs/BaerArithmetic.lean` |
| thm-completion-robust | Robust obstruction persistence        | below-`τ` deletions cannot unblock; only old obstructions need persist | baer, completion | lean `FiniteGeom/BaerCompletion/RobustHole.lean` `not_insertion_indep_of_obstructions_persist` |
| thm-completion-core | Sharp completion-core radius            | unique completion below facet separation, with a sharp alternative-facet witness | baer, completion | lean `FiniteGeom/BaerCompletion/Core.lean` `completionCore_sdiff_eq`, `completionCore_delete_difference_eq_intersection` |
| lem-nu-tau          | ν ≤ τ                                    | matching ≤ transversal (hypergraph base)           | completion (base)   | lean `FiniteGeom/Hypergraph.lean:53` `matching_card_le_transversal_card` |
| thm-frame-rigidity  | Frame-graph semilinear rigidity (N1)     | Aut = ambient semilinear group, q ≥ 13             | continuation        | note (Thm 7.4) [plan] |
| thm-complex-recon   | Continuation-complex reconstruction (N2) | recovers plane + secants + arc                     | continuation        | note (Thm 8.4) [plan; SOFTEN] |
| lem-transfer        | Concatenation transfer lemma             | bounded-weight dual-distance transfer              | coding (unhomed)    | lean `RepairCodes/Transfer.lean:136` `transfer_lemma` |
| thm-gf9-dualdist    | GF9 seed [10,4,6]₉ dual distance         | inner seed minimum distance = 6                    | coding (unhomed)    | lean `RepairCodes/Q9Seed.lean:657` `q9InnerCode_minDist` |
| lem-twisted-cubic   | Twisted-cubic / NRC independence         | moment-curve columns linearly independent          | coding/completion   | lean `FiniteGeom/MomentCurve.lean:92` `twistedCubic_linearIndependent` |
| thm-singleton-mds   | Singleton bound / MDS                    | minDist + dim ≤ n + 1; `IsMDS` predicate           | coding (base)       | lean `FiniteGeom/Code.lean:222` `singleton_bound` |
| comp-a344227        | A344227 a(14..17)                        | queens Node-Kayles nimbers 0, 1, 0, 2              | oeis:A344227        | solver `rust/src/queens/solver/nimber.rs` |
| comp-queens-n18     | n=18 Queens = first-player win           | witness opening I9 ⇒ a(18) ≠ 0                     | queens-n18          | `queens-n18-paper.md` + Rust solver |

*Continuation remains plan-stage. The Baer/completion mechanism and exact coordinate quadratic
pair-extension theorem are Lean-built. The Hilbert-90, Baer-subplane, incidence-counting, and
two-element-orbit ingredients are classical infrastructure, not Discovery Track claims.
`PG(4,3)=P` is a computed frontier datum, not a theorem.*
