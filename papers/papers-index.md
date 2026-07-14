# Papers index

Publication-track staging. Each subdirectory is a **candidate paper**: a curated view (symlinks
into `../notes/`) of the source notes for one result, plus a `README.md` status map. A directory
is a staging area, **not** a commitment to a separate publication. The Fable review (2026-07-12)
resolved the decomposition to five papers (+1 conditional) + two OEIS. The provisional Baer +
completion merge was superseded by the focused Baer/Q25 ruling on 2026-07-14,
dihedral bundles the D₂ₘ family, continuation is N1-only, and coding proceeded after its internal
audit. **Clebsch was added 2026-07-13, after that review, bringing it to six (+1)** — it spun out of
the `arcs` q=11 material, and the 2026-07-14 seam ruling makes it ship after `arcs`. See
`papers-planning.md` for the rulings, the ship order, and per-paper guardrails.

**Numbering.** The `#` on each directory row is that paper's **ship-order number, 1–7**, and is the
one numbering scheme in use — `papers-planning.md` → *Papers — decomposition and ship order* is the
authoritative list (it carries the gate distances and the dependency rulings); this registry carries
the same numbers and does not restate them. Directory rows appear in ascending `#` across both tracks
below. `—` marks a staging view that is not itself a paper. The public mirror and the two OEIS
entries are **not** papers and are deliberately outside this numbering; see the planning doc's
*Non-paper deliverables*.

## Games track — impartial cap / Nofil / Node-Kayles

**1 · `nofil-finite-geometry-outcomes`** — Outcome classes of cap/Nofil games on finite
geometries (pairing/mirror)
- *Status:* partial draft; projective proven but unwritten.
- **Owns the game reading** of the shared q=11/q=9 material (`thm-relative-game-localization`,
  `comp-q9-terminal`, `comp-q11-icosahedral`); see *Arcs vs Nofil* in the planning doc.

**2 · `dihedral-schreier-node-kayles`** — Node Kayles on fixed-point-deleted Schreier graphs
from conic involutions
- *Status:* draft near-complete, committed.

*Split by technique:* Schreier-residual nimbers vs the pairing/mirror ⇒ P method.

## Geometry / coding track — Package 2 (arc extension & reconstruction)

**3 · `arcs_complete_outside_conic`** — Arcs complete outside a prescribed conic (secant-defect
identity, bounds, MDS syndrome form)
- *Status:* self-contained manuscript + PDF + independent checkers + strict-trust Lean
  formalization; strengthened q11 code/extension spectrum included; near submission-ready.
- **Owns the q=11 deep-holes=conic identification** (`comp-q11-mds-deep-holes`), which
  `clebsch` builds on, and the arc/extension reading of the material shared with `nofil`.

**4 · `clebsch-hexagon-code`** — The Clebsch hexagon code: a rigidity theorem for deep holes
(an MDS code over 𝔽₁₁ whose deep holes are exactly a conic)
- *Status:* full LaTeX working draft + PDF + six independent Python checkers (coverage
  incomplete — see *Manuscript state*); Lean partially built (deep-holes/radius/leaders +
  Schreier=icosahedron certified strict-trust; chirality/gap/TFAE open).
- **Ships after `arcs` — hard dependency**, not a preference: `arcs` owns the deep-holes=conic
  identification that `clebsch` takes as its starting point (*Clebsch after Arcs*). Claims only
  the reading (rigidity TFAE, gap, chirality, why-11). *Added 2026-07-13, after the Fable
  decomposition ruling, so not among its five+1.*

**5 · `coding-repair-hypergraphs`** — Complete repair hypergraphs under concatenation: a
twisted-cubic–axis family
- *Status:* self-contained manuscript + proof/novelty ledgers + strict-trust Lean package;
  internal adversarial audit complete, external specialist priority check remains.

**6 · `equivariant-robust-completion`** — Frobenius-equivariant pair extension of eight-arcs in
`PG(2,25)`
- *Status:* focused LaTeX submission source + bibliography + cleanly compiled PDF; exact quadratic
  criterion, semantic global count, collision inverse, and uniform Q25 theorem Lean-built.
- *Staging/library views, not themselves papers:* `baer-equivariant-extension` feeds this paper;
  `completion-core-rigidity` is reusable generic infrastructure outside the submission.

**7 · `continuation-graph-rigidity`** — Semilinear rigidity/reconstruction from cap
continuation graphs
- *Status:* theorem-package plan; N1 headline survives.

*Common parentage:* all descend from "Package 2" in `../notes/2026-07-10-codex-publishable-spinout-audit.md`
and share the `lean/FiniteGeom/` base. `clebsch-hexagon-code` is the exception: it descends from the
`arcs` q=11 witness (`comp-q11-mds-deep-holes`) rather than from Package 2, and shares that witness's
`lean/RelativeConicArcs/` library rather than owning one.
Venue target is Designs, Codes and Cryptography / Finite Fields and Their Applications / J. Geometry —
explicitly **not** IEEE-TIT. Lane map — the single live doc to read first (status, Lean gallery, open
lit, remaining work): `../notes/handoffs/2026-07-13-clebsch-paper.md`. Lane alias `clebsch`
(CLAUDE.md routing), same word as this directory's alias.

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
- **Complete LaTeX manuscript (+ PDF + proof/novelty ledgers + Lean package):**
  `coding-repair-hypergraphs` — internally audited; specialist citation-chain review remains a
  submission preflight gate.
- **Complete LaTeX manuscript (+ PDF + independent Python checkers + partial Lean):**
  `clebsch-hexagon-code` — six standalone re-checking scripts in the paper directory
  (`check_rigidity_degenerate_conic.py`, `check_q9_exclusion.py`, `check_q19_nonexample.py`,
  `check_dual_code.py`, `check_mathieu_hexads.py`, `check_ten_arc_foil.py`), each independent of the
  manuscript's own computation. **Coverage is not complete:** three finite claims ship with no
  checker — the gap theorem's 252-perturbation spectrum (§4 Thm 4.2), the chirality orbit
  computation (§5 Prop 5.1), and the mod-11 syzygy (§7, task C128). All three were independently
  re-derived during the 2026-07-14 adversarial review and hold exactly as stated, but no reproducible
  artifact ships with the paper. Lean covers the deep-holes/radius/leader facts and the §7
  Schreier=icosahedron witness; chirality, the gap theorem, and the rigidity TFAE remain open and are
  release-blocking under the gate below (see *Lean state*).
  Builds with texliveFull — texliveSmall/Medium lack `enumitem`.
- **Markdown manuscript exists:** `dihedral-schreier-node-kayles` (the committed submission).
- **LaTeX manuscript exists (partial):** `nofil-finite-geometry-outcomes`
  (`paper-sumfree-capgame/main.tex` — sum-free ℤₙ + affine cap written; projective unwritten).
- **Focused LaTeX manuscript + PDF + Lean lane:** `equivariant-robust-completion`, with the exact
  coordinate quadratic extension theorem and completed internal referee closeout. Continuation
  rigidity remains theorem-package only.
- **Sequence packages (ready/draft):** the two `oeis-submissions/` entries.

## Shared blocker

Several deliverables want a **public code/preprint URL** that does not exist yet (the repo has no
public remote): the A344227 `%H` link and n=18 comment, the sequences' program links, and any
arXiv posting of the manuscripts. One public mirror or preprint unblocks them together.

## Lean state at a glance

- **Formalized, `sorry`-clean:** the pairing/mirror geometry outcomes (`lean/ProjectiveCap/`,
  `lean/CapGame/`); the dihedral reduction + V₄→K₄ core (`lean/DihedralSchreier/`); the
  Baer pair-extension proof spine (`lean/FiniteGeom/BaerCompletion/`) and its projective-plane,
  coordinate-conjugation, and quadratic-Frobenius consumers (`lean/RelativeConicArcs/`); the
  completion δ_x = τ base identity (`lean/FiniteGeom/Completion.lean`); the coding/LRC seed
  (`lean/RepairCodes/`); and the complete arcs-outside-a-conic theorem/certificate package
  (`lean/RelativeConicArcs/`).
- **Partially formalized — `clebsch-hexagon-code` (Lean gallery, plan A = small `decide` pieces
  first):** the deep-holes=conic, covering-radius-three, and 20-leader facts are already certified in
  `RelativeConicArcs/Q11Coding.lean` + `Q11Semantic*.lean` (shared with `arcs`, see
  `comp-q11-mds-deep-holes`); `Q11Coding.lean` `residual_graph_icosahedral` certifies the §7
  Schreier=icosahedron witness — 5-regular, 30 edges, every vertex link a 5-cycle, pure `decide`,
  standard axioms, **no `native_decide`**, strict-trust clean. Still open, hence release-blocked under
  the gate below: **chirality ℤ/2** (needs new infra — no `A₅`-on-columns action exists in Lean; the 60
  matrices are in `check_ten_arc_foil.py`); **gap theorem** (252 perturbations) and **rigidity TFAE**
  (1548 arcs), both gated on an open `native_decide`-vs-strict-trust decision. Lane map:
  `notes/handoffs/2026-07-13-clebsch-paper.md`.
- **Planned, not built:** `ContinuationRigidity`. The exact quadratic Baer pair-extension data and
  semantic arc extension are Lean-proved; see `lean/FiniteGeom/BaerCompletion/TRUST.md`.
- **Axiom-clean bar:** `KleinFourBridge.explicit_pairProducts` now uses kernel `decide`; the former
  `native_decide` exception is closed. The coding/LRC chain is likewise `native_decide`-free; see
  `lean/RepairCodes/TRUST.md` and its dated adversarial review.
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
`dihedral-schreier-node-kayles`; `arcs` = `arcs_complete_outside_conic`; `baer` =
`equivariant-robust-completion`; `completion` is library-only; `continuation` =
`continuation-graph-rigidity`; `queens-n18` = `non-formal-bloggy/queens-n18`; `oeis:*` =
`oeis-submissions/*`; `coding` = `coding-repair-hypergraphs`; `clebsch` = `clebsch-hexagon-code`.

**Proof-location key:** `lean <file>:<line> <ident>` = formalized, `sorry`-clean (paths under
`lean/`); `paper §N` = proven in that manuscript; `note <file>` = proven in a research note
(plan-stage, Lean deferred); `solver <path>` = computed by a cross-checked solver; `checker <path>`
= re-verified by a standalone script in the paper directory (independent of Lean and of the
manuscript's own computation — the `clebsch` rows rely on this grade, which does **not** meet the
release gate below).

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
| thm-relative-game-localization | Exact cap-game localization | every continuation stays in `A∪H`; off-hole moves equal the uncovered locus; any injective hole parametrization preserves the full normal-play value | nofil (arcs glosses) | lean `RelativeConicArcs/ProjectiveBridge.lean` `move_mem_holes_of_completeOutside`, `legalExtensions_sdiff_holes_eq_uncovered`, `win_parametrizedHoles_iff`, `isP_parametrizedHoles_iff` — the game predicates live in the `arcs` library for historical reasons (that is where the witness was formalized), which is a file-location fact, not a claim by the `arcs` paper |
| thm-secant-moments  | Maximum index and secant moments         | `r_A(x)≤⌊k/2⌋`; `Σr=C(k,2)(q−1)`; `ΣC(r,2)=3C(k,4)` | arcs                | paper §2; lean `RelativeConicArcs/Moments.lean:202` `pointIndex_le_half_card`, `:290` `first_secant_moment`, `:510` `second_secant_moment` |
| thm-defect-identity | Prescribed-hole defect identity          | exact secant-index defect remainder identity       | arcs                | paper §3; lean `RelativeConicArcs/Defect.lean:214` `scaledDefect_eq_remainders` |
| thm-defect-corollaries | Defect equality, coverage, and stability | exact equality pattern, uncovered-locus bound, and quantitative bounded-defect control | arcs | paper §3; lean `RelativeConicArcs/Defect.lean:309` `scaledDefect_eq_zero_iff`, `:379` `uncovered_bound`, `:465` `stability_bound` |
| thm-conic-normalization | Nonsingular-conic normalization      | standard conic is `XZ=Y²`, has `q+1` points, and `rho` is invariant under projective normalization | arcs | lean `RelativeConicArcs/Conic.lean:286` `standardConic_card`, `:307` `mem_standardConic_iff_onConic`, `:422` `NonsingularConic.rho_points_eq` |
| thm-rho-finite      | Corrected prescribed-hole lower bound    | arbitrary `h`-point holes obey the exact corrected capacity bound with required-locus size `q²+q+1−k−h`; `L₁(q)≤L₂(q)≤ρ_𝒞(q)` for conic holes | arcs | paper §3–4; lean `RelativeConicArcs/Conic.lean` `card_requiredLocus_general`, `completeOutside_bound_general`, `L2_le_rho`, `L1_le_L2` |
| thm-rho-lower       | ρ_𝒞(q) asymptotic lower bound            | explicit `ρ_𝒞(q)≥√(2q)+3/2−8/√(2q)`, Big-O shortfall, and realized-field liminf wrapper | arcs | paper §4; lean `RelativeConicArcs/Asymptotic.lean:275` `rhoC_explicit_additive_lower_bound`, `:301` `additiveShortfall_isBigO`, `:410` `realized_three_halves_le_liminf` |
| lem-transitive-avoidance | Finite transitive-action avoidance | `|A||B|<|X|` gives a translate of `A` disjoint from `B` | arcs | lean `RelativeConicArcs/Averaging.lean:73` `exists_disjoint_smul` |
| thm-rho-transfer    | Prescribed-hole averaging transfer       | an ordinary complete `b`-arc moves off arbitrary `H` when `b|H|<q²+q+1`; hence ρ_𝒞(q) ≤ t₂(2,q) when t₂(2,q) ≤ q; Kim–Vu remains explicit | arcs | paper §5; lean `RelativeConicArcs/Averaging.lean` `exists_completeOutside_of_completeArc`, `rhoC_le_t2`, `rhoC_le_of_kimVuBound` |
| lem-nucleus         | Even-char hyperoval and nucleus constraints | standard conic+nucleus is a hyperoval; tangents, nucleus-in/out incidence and parity laws; every relative-complete arc has `I_𝒞(A)≥1` | arcs | paper §6; lean `RelativeConicArcs/Nucleus.lean` `standardHyperoval_arc`, `standardConic_tangent_iff_mem_nucleus`, `nucleus_mem_arc_constraints`, `nucleus_not_mem_arc_constraints`, `complete_holeIncidence_pos` |
| thm-relative-cert   | Generic relative/ordinary arc certificate soundness | canonical coordinate checks imply relative completeness; stronger ordinary coverage implies completeness with no holes; raw determinant arcs equal projective caps | arcs | lean `RelativeConicArcs/Certificate.lean` `rawArc_iff_projectiveCap`, `check_sound`, `check_sound_empty`, `rhoC_le_length_of_check` |
| lem-rho16-projective-reduction | Eight-cap frame reduction | every eight-cap is carried by a retained linear projectivity to an indexed cap containing the standard four-frame; each `StepBook.coverage` theorem represents every legal move by a certified transition, and `StepBooksValid` covers the parent list exactly, so the four checked layers are closed and exhaustive | arcs | lean `RelativeConicArcs/Q16StepKernel.lean` `StepBook.coverage`, `StepBooksValid`; `Q16Reduction.lean` `exists_mapEquiv_of_caps_card_four`, `classifiedAt_level8_of_frame` |
| lem-uncovered-evaluation-obstruction | Linear-system obstruction from uncovered points | for any linear system of homogeneous forms, injective evaluation on the uncovered locus or a selected evaluation functional in its span excludes a zero locus containing the uncovered set and avoiding the selected set | arcs, algebraic geometry | paper Lemma `lem:evaluation-obstruction`; lean `RelativeConicArcs/EvaluationObstruction.lean` `eq_zero_of_evaluationMap_injective`, `evaluation_eq_zero_of_eq_sum`; quadratic instances in `Q16Reduction.lean` |
| thm-evaluation-dichotomy | Sharp finite-field evaluation avoidance | for any feature map (hence every Veronese degree), a form vanishing on `U` and avoiding `A`, `|A|≤q`, exists exactly when `span ν(U)` is proper and contains no `ν(a)`; quantitative rank-sensitive lower bound, equality model, and sharp `q+1` plane cover | arcs, algebraic geometry | paper Proposition `prop:evaluation-dichotomy`; lean `RelativeConicArcs/EvaluationDichotomy.lean` `card_outside_hyperplanes_factored_lower_bound`, `evaluation_avoidance_iff`, `feature_evaluation_avoidance_iff`, `card_outside_planeCoverHyperplanes` |
| thm-arc-mds-syndrome | Plane arc / codimension-three MDS syndrome dictionary | transparent parity-check kernel has dimension `n-3` and minimum distance four; projective syndrome distance is 1/2/3 on selected/secant/uncovered directions; actual affine leaders are in bijection with their supports through weight three; index is the exact weight-two leader count; every distance-three affine syndrome has exactly `choose(n,3)` leaders | arcs | paper Proposition `prop:syndrome-dictionary`; lean `RelativeConicArcs/CodingBridge.lean` `CodimThreeMDSColumns.code_finrank`, `minimumDistance_ge_four`, `card_syndromeLeadersOfWeight_eq_supports`, `card_syndromeLeadersOfWeight_three`; `SyndromeGeometry.lean` distance/support theorems |
| thm-relative-syndrome-confinement | Relative completeness as syndrome confinement | `CompleteOutside A H` iff the projective distance-three syndrome directions are confined to `H`; a fresh direction is a one-column MDS extension iff it has distance three | arcs | paper Proposition `prop:syndrome-dictionary`; lean `RelativeConicArcs/SyndromeGeometry.lean` `completeOutside_iff_distanceThreeDirections_subset`, `oneColumnExtension_iff_distance_three` |
| thm-extension-conflict-hypergraph | Exact simultaneous arc/MDS extension semantics | general simultaneous extensions are independent sets of the pair/triple conflict hypergraph; when the allowed locus is an arc, this reduces to pair-graph independence and maximality inside that locus; maximality upgrades to ordinary completeness when the locus is the full one-point extension set | arcs (nofil cites as the game's move-legality substrate) | lean `RelativeConicArcs/SyndromeGeometry.lean` `arc_union_iff_extension_hypergraph`, `arc_union_iff_pairExtensionIndependent_of_arc_locus`, `maximalExtensionIn_iff_maximalPairExtensionIndependent`, `completeOutside_empty_of_maximalExtensionIn_full` |
| thm-defect-leader-collision | Coding form of prescribed-hole defect | secant first/second moments and the exact defect are weight-two leader-count and leader-collision identities, yielding the same length obstruction for projective codimension-three MDS systems with prescribed distance-three locus | arcs | paper §`sec:coding`; lean `RelativeConicArcs/SyndromeGeometry.lean` `first_weightTwoLeader_moment`, `second_weightTwoLeader_collision_moment`, `scaledDefect_eq_weightTwoLeader_remainders` |
| thm-uncovered-quadratic-obstruction | GF(16) quadratic-avoidance theorem | for every eight-arc, no nonzero quadratic zero set—singular or nonsingular—contains its ordinary-uncovered locus while avoiding the arc; full-rank and forced-hit alternatives cover all 2633 normalized classes | arcs | paper Theorem `thm:q16-quadratic`; lean `RelativeConicArcs/Q16QuadraticAvoidance.lean` `QuadraticAvoidance`, `RejectsLevel.quadraticAvoidance`, `level8_quadraticAvoidance`; global conic corollary `Q16Result.lean` `no_completeOutside_GF16_card_eight` |
| comp-rho16-classes | PG(2,16) eight-arc quadratic-obstruction refinement | independently reproduces the known 2633 ordinary projective eight-arc classes (Al-Seraji--Al-Ogali 2018), then refines them into 2630 full-rank and 3 forced-hit uncovered-quadratic rejections | arcs | generator/report `arcs_complete_outside_conic/search_rhoc16.cpp`, `search_rhoc16_output.txt`; kernel data `RelativeConicArcs/Q16CertificateData*`, `Q16LeafData*`; novelty audit `notes/2026-07-13-rhoc16-novelty-check.md` |
| thm-rho16-exact | Exact relative-conic value over GF(16) | no eight-point arc is complete outside any nonsingular conic; the checked nine-point witness gives `ρ_𝒞(16)=9` | arcs | paper §7; lean `RelativeConicArcs/Q16Result.lean` `no_completeOutside_GF16_card_eight`, `rhoC_GF16`; registry alias `RelativeConicArcs/Results.lean` `Examples.rhoC_GF16` |
| comp-rho-small      | ρ_𝒞 small values and arithmetic thresholds | `L₂(8)=L₂(9)=L₂(11)=6`, `L₂(16)=8`; ρ_𝒞(8)=ρ_𝒞(9)=ρ_𝒞(11)=6; ρ_𝒞(16)=9 | arcs | paper §7 + verifier/classification; lean `RelativeConicArcs/Results.lean`, `RelativeConicArcs/Q16Result.lean` `rhoC_GF16` |
| comp-q11-exterior  | q=11 exterior-secant design              | all 15 witness secants avoid the conic; required-point index distribution `(N₁,N₂,N₃)=(90,15,10)` | arcs | paper §7 + verifier `I_C=0` + paper moment equations |
| comp-q11-mds-deep-holes | q=11 non-GRS MDS/deep-hole spectrum | projectively non-GRS `[6,3,4]₁₁` code of covering radius three; actual distance-three nonzero affine syndrome rays are exactly the standard conic; actual affine syndrome distribution `(1,60,1150,120)` and actual minimum-weight word split `(900,150,100)` | arcs | paper Proposition `prop:q11-code`; lean `RelativeConicArcs/Q11SemanticRayData.lean` `affineRayVec_bijective`; `Q11SemanticSynthesis.lean` `affine_distanceThree_iff_mem_standardConic`, `mem_affineSyndromesOfDistance_iff`; `Q11SemanticDistribution.lean` `affine_coset_distance_distribution`; `Q11SemanticLeaders.lean` `syndromeLeaderSupports_two_eq_raw`, `distance_two_leader_distribution`; `Q11Coding.lean` MDS/radius/deep-hole theorems and formal no-conic premise `no_nonzero_quadratic_vanishing`; projectively non-GRS conclusion uses the cited classical NRC/GRS dictionary |
| comp-q11-extension-complex | q=11 exact simultaneous-extension complex | independence polynomial `1+12t+36t²+20t³`; no maximal 0/1-extension, exactly six maximal 2-extensions and twenty maximal 3-extensions, no 4-extension; all 26 maximal sets are certified ordinary complete arcs, giving six complete eight-arcs and twenty complete nine-arcs over the fixed seed | arcs | paper Proposition `prop:q11-code`; lean `RelativeConicArcs/Q11Coding.lean` `extension_independence_spectrum`, `maximal_extension_spectrum`, `maximal_independent_extension_complete` |
| comp-q11-chord-decomposition | q=11 coloured icosahedral chord decomposition | each witness gives a five-edge matching missing an antipodal pair; six disjoint colour classes partition all 30 conflict edges; the six missing antipodal edges are distinct and augment the classes to a one-factorization | arcs (clebsch cites) | paper Proposition `prop:q11-code`; lean `RelativeConicArcs/Q11Coding.lean` `witness_chords_nearPerfect`, `witness_chords_miss_antipodes`, `witness_chords_partition`, `completed_witness_matchings_oneFactorization`; cited at `clebsch` paper §8 (the edge-level Schreier witness) |
| comp-q9-terminal   | q=9 terminal six-point P-position        | the witness is an ordinary complete arc; its legal-extension set is empty, hence the actual projective position is P | nofil | lean `RelativeConicArcs/Q9Terminal.lean` `complete`, `legalExtensions_eq_empty`, `isP`. The input fact — the `q=9` witness is a complete arc — is classical (Storme–Van Maldeghem 1995, Prop. 13), so `nofil` cites SVM, not `arcs`; `clebsch` reads the same completeness as deep-hole vacuity (`comp-q9-exclusion`) |
| comp-q11-icosahedral | q=11 icosahedral seeded P-position     | all 12 conic points live; every seeded continuation is exactly an independent set of the icosahedral graph; the actual projective seed is P by antipodal mirror and exact localization | nofil (the icosahedral identification itself is `arcs`') | lean `RelativeConicArcs/Q11Residual.lean` `continuation_rawArc_iff`, `isP`, `seed_isP`. The underlying graph identification `adj_iff_icosahedron` is `arcs`' (its paper §7 remark), also cited by `clebsch` §8; `nofil` owns only the P-position read off it |
| thm-clebsch-deep-holes | Deep holes of the Clebsch hexagon code are exactly a conic | projectively non-GRS `[6,3,4]₁₁` code of covering radius three; the fifteen secants cover all of `PG(2,11)` except the twelve points of the `A₅`-invariant conic `XZ=Y²`, so the complete deep-hole set *is* `𝒞(𝔽₁₁)`; affine count `120=12×10`, each deep-hole coset has `C(6,3)=20` leaders. **Owned by `arcs`** (`comp-q11-mds-deep-holes`), which holds the Lean certificate and ships first; `clebsch` reproves it self-contained as the setup for its rigidity theorem and claims no priority for it. Per the 2026-07-14 seam ruling this row carries **no novelty claim** — the earlier "first MDS code whose deep holes are the `𝔽_q`-points of a named variety" wording is retired | arcs (clebsch restates) | `arcs` paper Prop 4.6(i) + lean `RelativeConicArcs/Q11Coding.lean` (see `comp-q11-mds-deep-holes`); restated at `clebsch` paper §3 Prop 3.1 + Cor 3.2 via the DMP Thm 6.3 dictionary, with an independent check in `check_rigidity_degenerate_conic.py` |
| thm-clebsch-rigidity | Rigidity theorem (five-way TFAE)         | for a six-arc `A⊂PG(2,11)`: `U(A)` lies on some conic ⟺ `U(A)` is all `𝔽₁₁`-points of a nonsingular conic ⟺ `#U(A)≤15` (in fact `12`) ⟺ `A` is `PGL(3,11)`-equivalent to the Clebsch hexagon ⟺ `Stab(A)⊇A₅`. `A₅` is *recovered* from a purely coding-theoretic hypothesis, not assumed | clebsch | paper §4 Thm 4.1; exhaustive over the 1548 frame-normalized six-arcs; checker `clebsch-hexagon-code/check_rigidity_degenerate_conic.py`, which also closes (i)⇒(ii) by excluding degenerate conics; Lean planned (`native_decide`-grade) |
| thm-clebsch-gap     | Gap theorem (rigid, not merely stable)   | every non-Clebsch six-arc has `#U≥16` with `U` on no conic; each of the 252 single-point perturbations of the hexagon has symmetric difference `#(U Δ 𝒞) ≥ 18` (exact spectrum `{18,19,20,22,24}`), so at most seven of the twelve conic points survive; distance-to-phenomenon jumps `0 → ≥18` with nothing between | clebsch | paper §4 Thm 4.2. **No checker ships for the perturbation census** — `check_rigidity_degenerate_conic.py` covers only the first clause (`#U≥16`, on no conic) via the histogram; the 252-perturbation spectrum was independently re-derived in the 2026-07-14 review and holds, but has no committed artifact. Lean planned (`decide`-grade, small) |
| comp-clebsch-u-spectrum | Six-arc extension-count spectrum in `PG(2,11)` | `#U(A) ∈ {12,16,18,19,20,21,22}` with frame-normalized multiplicities `{6,30,150,300,630,360,72}` (Σ=1548); `#U=12` is attained by exactly one `PGL(3,11)` orbit (multiplicity `6=360/60`, consistent with `#Aut=60`) | clebsch | **priority granted outright to Hirschfeld–Sadeh 1984 / Sadeh thesis — recomputed here, claimed by us for neither the numbers nor the classification**; ours is only the deep-hole/covering *reading* of `U`. paper §4; verified by two independent code paths |
| thm-clebsch-chirality | Canonical chirality `ℤ/2` on the deep-hole leaders | the twenty weight-three coset leaders split into two complementary `A₅`-orbits of ten that no automorphism exchanges, since `Hom(A₅,ℤ/2)=0`; the sixty orbit-swapping permutations are exactly the odd elements of the exotic `S₅⊂S₆`. Gives a certified non-identifiable latent: fixed under all sixty symmetries yet not constant | clebsch | paper §5 Prop 5.1; Lean planned (`decide`-grade orbit computation + standard `Hom(A₅,ℤ/2)=0`) |
| lem-secant-covering | Secant-covering bound                    | a six-arc complete outside a disjoint conic forces `15(q−1) ≥ q²−6`, i.e. `q²−15q+9≤0`, hence `q≤14`. Overlap-free: fifteen sets of size `≤q−1` covering `q²−6` points bound the sum from below regardless of overlap | clebsch | paper §6 Lemma 6.1 — the paper's only genuine inequality argument; hand-proven, no computation |
| thm-clebsch-why11   | Uniqueness of `q=11`                     | `q≤14` by `lem-secant-covering`; icosahedral `A₅⊂PSL₂(q)` needs `q≡±1 (mod 10)` or `q=5` (Dickson), leaving candidates `5,9,11`; `q=5` is too small to carry the arc and `q=9` is excluded on its own terms, so `q=11` | clebsch | paper §6 Thm 6.2 |
| comp-q9-exclusion   | `q=9` icosahedral six-arc is complete    | `#U=0` at `q=9`: the analogous `A₅`-invariant six-arc has covering radius two, so its deep-hole locus is empty and the phenomenon is vacuous — closing the one candidate that passes the rationality filter but not the counting bound | clebsch | paper §6; independently re-verifies SVM 1995 Prop 13; checker `clebsch-hexagon-code/check_q9_exclusion.py`, over the Lean-certified GF9 tables and the `RelativeConicArcs/Examples.lean` `q9Witness` |
| comp-q19-nonexample | `q=19` icosahedral six-arc has exactly 140 deep holes | the recipe still yields a genuine six-arc disjoint from the conic — at `q=19`, `5∣q+1` so order-five elements are non-split and fix *no* rational conic point, but their `𝔽₃₆₁`-conjugate fixed pairs span Galois-stable rational chords, hence rational poles (verified, not assumed). `#U=140=20+120` against a 20-point conic, and `U` lies on no conic (quadratic-monomial rank 6/6). The conic stays *contained* in `U` but no longer exhausts it — the failure mode `lem-secant-covering` predicts, capacity `15(q−1)=270` against `q²−6=355` | clebsch | paper §6; checker `clebsch-hexagon-code/check_q19_nonexample.py` — **exact count; supersedes the earlier `≥105` counting bound** (2026-07-14) |
| comp-clebsch-dual   | The dual code is again a Clebsch hexagon code | dual arc `B={(1,5,5),(1,4,9),(1,9,3),(1,0,0),(0,1,0),(0,0,1)}`: a genuine six-arc meeting `𝒞` in two points, with `#U(B)=12` lying on a *second* nonsingular conic `4X²+7XY+10XZ+5Y²+2YZ+Z²=0`. By `thm-clebsch-rigidity`, `B` is `PGL(3,11)`-equivalent to `A`, so the phenomenon is self-dual — though not coordinate-for-coordinate | clebsch | paper §8; checker `clebsch-hexagon-code/check_dual_code.py` (exact nullspace reduction of `H` over `𝔽₁₁`) |
| comp-clebsch-mathieu | The two icosahedral hexads are transverse to `S(5,6,12)` | the six antipodal chords partition `𝒞`'s twelve points into complementary hexads `{0,1,2,3,5,6}` and `{4,7,8,9,10,∞}`; neither is among the 132 Mathieu hexads — both meet every block in 1–5 points with the identical histogram `{1:6,2:30,3:60,4:30,5:6}`, never 0 or 6. Shares substrate and the subgroup `PSL₂(11)<M₁₂` with the design, yet is combinatorially unrelated to its blocks: turns the "is this a Golay/Mathieu thing?" referee question into a stated negative | clebsch | paper §8; checker `clebsch-hexagon-code/check_mathieu_hexads.py`, which recomputes the `PSL₂(11)` orbit and confirms both size 132 and the `S(5,6,12)` design property |
| comp-clebsch-ten-arc-foil | Ten-arc foil: same `A₅`, empty deep holes | the explicit sixty-matrix `Stab(A)<PGL(3,11)` has orbits of sizes `{6,10,12,15,30,30,30}` on `PG(2,11)` (the 6 is `A`, the 12 is `𝒞`); the unique size-ten orbit is a genuine ten-arc, disjoint from `𝒞`, with *empty* deep-hole locus. Emptiness, not containment in a variety, is the generic covering behavior under icosahedral symmetry — so the hexagon's conic-filling locus is the exception, not an artifact of the symmetry | clebsch | paper §8; checker `clebsch-hexagon-code/check_ten_arc_foil.py` (verified `#Stab(A)=60`) |
| thm-baer-criterion  | Orbit-valued extension criterion         | plausibly unrecorded assembled quadratic-Frobenius criterion; exact coordinate theorem constructs an arc extension; heterogeneous support count specializes to uniform `E(N−M)` | baer | lean `FiniteGeom/BaerCompletion/PairExtension.lean` `PairExtensionData.sum_card_sub_le_legalCount`; `RelativeConicArcs/QuadraticForbidden.lean` `exists_quadratic_pair_extension`; novelty audit `notes/2026-07-13-baer-completion-adversarial-novelty-review.md` |
| lem-baer-linewise-correction | Exact carrier correction          | subtraction-free `legal(ℓ)+M=N+B_ℓ+Σ_q(μ_ℓ(q)−1)` separates invisible orbit mass from collision redundancy, linewise and in aggregate | baer | lean `FiniteGeom/BaerCompletion/CollisionProfile.lean`, `RelativeConicArcs/QuadraticCollision.lean`, `RelativeConicArcs/QuadraticInvisible.lean`; paper Theorem B.1; fixed-center interpretation kernel-checked |
| thm-baer-q25-f2 | Exceptional `PG(2,25)` pair extension | every Frobenius-invariant eight-arc with exactly two fixed selected points admits a fresh conjugate-pair extension, with both new points explicitly outside the old arc | baer | lean `RelativeConicArcs/Q25PairResult.lean` `f2_pair_extension`; concrete field, both normalizations, all 46,056 reflected rows, semantic transport, and axiom profile are kernel-checked and adversarially reviewed; census/minimum 32 not claimed |
| thm-baer-q25-f4 | Four-fixed-point `PG(2,25)` pair extension | every Frobenius-invariant eight-arc with exactly four fixed selected points admits a fresh conjugate-pair extension; aggregate legal-pair count is at least four | baer | certificate-free lean `RelativeConicArcs/Q25ProfileFour.lean` `profile_four_pair_extension`, `four_le_sum_card_legal_profile_four`; center incidence, exact balance, focused build, and axiom profile kernel-checked |
| thm-baer-q25-f0 | Zero-fixed-point `PG(2,25)` pair extension | every Frobenius-invariant eight-arc with no fixed selected points admits a fresh conjugate-pair extension; aggregate legal-pair count is at least five | baer | certificate-free lean `RelativeConicArcs/Q25ProfileZero.lean` `profile_zero_pair_extension`, `five_le_sum_card_legal_profile_zero`; endpoint moments, parity, focused build, and axiom profile kernel-checked |
| thm-baer-q25-all | Uniform `PG(2,25)` pair extension | every Frobenius-invariant eight-arc admits a fresh conjugate-pair extension | baer | lean `RelativeConicArcs/Q25AllProfiles.lean` `pair_extension`; exhaustive parity split over `f=0,2,4,6,8`, scoped build and axiom profile kernel-checked |
| thm-baer-saturation | Quadratic orbit-saturation bound         | denominator-free `2s(s−1) ≤ (k−1)²`; classical Lunelli–Sce/line-covering square-root scale under the weaker no-pair-extension hypothesis | baer | lean `FiniteGeom/BaerCompletion/OrbitSaturation.lean` `orbitSaturation_quadratic_bound_of_split` |
| thm-completion-tau  | δ(C) = τ                                 | standard conflict/correction-set hitting-set duality, formalized semantically for every finite hereditary system | completion (library-only) | lean `FiniteGeom/BaerCompletion/Obstruction.lean` `insertionDistance_eq_transversalNumber` |
| lem-completion-clutter | Minimal-obstruction reduction        | classical clutter reduction: removing nonminimal dependent traces preserves every transversal and `τ` | completion (library-only) | lean `FiniteGeom/BaerCompletion/Clutter.lean` `transversalNumber_minimalEdges` |
| thm-completion-weighted | Weighted completion identity        | standard weighted-hitting-set specialization, kernel-checked for arbitrary nonnegative deletion costs | completion (library-only) | lean `FiniteGeom/BaerCompletion/Weighted.lean` `weightedInsertionDistance_eq_weightedTransversalCostWithin` |
| thm-completion-multi | Multi-insertion identity               | standard prescribed-set correction/hitting-set schema, exposed as a checked API | completion (library-only) | lean `FiniteGeom/BaerCompletion/MultiInsertion.lean` `multiInsertionDistance_eq_transversalNumber` |
| thm-completion-weighted-multi | Weighted multi-insertion      | prescribed-set representation with standard nonnegative vertex weights | completion (library-only) | lean `FiniteGeom/BaerCompletion/Weighted.lean` `weightedMultiInsertionDistance_eq_weightedTransversalCostWithin` |
| thm-secant-resilience | Arc insertion distance               | classical secant-deletion/point-index fact, formalized in every finite abstract projective plane | completion (library-only) | lean `RelativeConicArcs/CompletionDistance.lean` `arcInsertionDistance_eq_pointIndex` |
| thm-baer-involution | Fixed/conjugate secant decomposition    | elementary involution-orbit decomposition, abstractly formalized for reuse | baer | lean `FiniteGeom/BaerCompletion/BaerPlane.lean`; `RelativeConicArcs/BaerIncidence.lean` |
| thm-baer-frobenius | Coordinate quadratic Frobenius           | classical semilinear/Hilbert-90 infrastructure and exact `(s²−s)/2` linewise candidate count, formalized for the criterion | baer | lean `RelativeConicArcs/QuadraticFrobenius.lean`; `RelativeConicArcs/QuadraticPairExtension.lean` |
| lem-baer-input-reduction | Quadratic count-input reduction   | proof infrastructure: exact count fields reduce to a 2-fiber map, complement, and injective charge | baer | lean `FiniteGeom/BaerCompletion/OrbitCounting.lean` |
| thm-baer-line-counts | Exact fixed-line occupation          | paper-specific bookkeeping assembly from classical incidence counts, with nontruncating subtraction | baer | lean `RelativeConicArcs/QuadraticLineCounting.lean` `card_occupiedFixedLines`, `card_emptyFixedLines`, `choose_fixedArcPoints_le_star` |
| thm-baer-forbidden | Exact forbidden-candidate charging       | core mechanism of the assembled criterion: injective support-to-orbit charge, semantic coverage equivalence, and legal arc union | baer | lean `RelativeConicArcs/QuadraticForbidden.lean` `card_nonfixedSecantOrbits`, `card_forbiddenCandidates_le_baer`, `arc_union_candidate_of_not_mem_forbidden` |
| lem-baer-arithmetic | Quadratic Baer arithmetic                | elementary paper-support arithmetic: `M=fe+e(e−1)`, eight-arc `M≤12`, candidate surplus, and occupied-line identity | baer | lean `RelativeConicArcs/BaerArithmetic.lean` |
| thm-completion-robust | Robust obstruction persistence        | standard transversal monotonicity: below-`τ` deletion cannot unblock and persistence of old obstructions preserves the lower bound | completion (library-only) | lean `FiniteGeom/BaerCompletion/RobustHole.lean` `not_insertion_indep_of_obstructions_persist` |
| thm-completion-core | Sharp completion-core radius            | standard defining-set/facet-separation lemma, conditional on an alternative-facet witness | completion (library-only) | lean `FiniteGeom/BaerCompletion/Core.lean` `completionCore_sdiff_eq`, `completionCore_delete_difference_eq_intersection` |
| lem-nu-tau          | ν ≤ τ                                    | matching ≤ transversal (hypergraph base)           | completion (base)   | lean `FiniteGeom/Hypergraph.lean:53` `matching_card_le_transversal_card` |
| thm-frame-rigidity  | Frame-graph semilinear rigidity (N1)     | Aut = ambient semilinear group, q ≥ 13             | continuation        | note (Thm 7.4) [plan] |
| thm-complex-recon   | Continuation-complex reconstruction (N2) | recovers plane + secants + arc                     | continuation        | note (Thm 8.4) [plan; SOFTEN] |
| lem-transfer        | Complete repair-hypergraph transfer      | exact blockwise preservation when `r+1<2d(I⊥)` and the outer functional-dual gate holds; every exact locality `s≤r` is preserved | coding | lean `RepairCodes/SeedLift.lean` `repairHypergraph_concatenatedCode_eq_embed`, `hasExactLocalityAt_concatenatedCode_iff_of_le` |
| thm-transfer-boundary | Uniform boundary of both transfer gates | nondegenerate `GF(3)` examples give literal complete-hypergraph failure at `r+1=2d(I⊥)` and at outer functional-dual distance `r+1`; no fixed-code necessity claim | coding | paper Proposition `prop:transfer-boundary`; lean `RepairCodes/TransferBoundary.lean` `innerDualDistanceGate_boundary_counterexample`, `outerFunctionalDualDistanceGate_boundary_counterexample` |
| thm-gf9-seed10      | GF9 seed `[10,4,6]₉`                     | exact minimum distance 6 and dual distance 4; formal-library result, not used in the manuscript | coding (library-only) | lean `RepairCodes/Q9Seed.lean` `q9InnerCode_minDist`, `q9InnerCode_dualDist` |
| thm-axis-uniform-code | Uniform axis–twisted-cubic code       | `[2q+1,4,q−1]₍q₎` in finite characteristic three  | coding    | lean `FiniteGeom/AxisTwistedCubic.lean` `axisTwistedCubic_code_parameters` |
| thm-axis-cubic-row | Exact cubic-coordinate repair row | every cubic coordinate has `(ν,τ)=((q−1)/2,q−2)` over every finite characteristic-three field | coding | paper §4; lean `RepairCodes/AxisTwistedCubicInvariants.lean` `cubicRepair_matchingNumber`, `cubicRepair_transversalNumber`; rainbow core `FiniteGeom/ExplicitRainbowMatching.lean` |
| thm-axis-q9-table   | Exact q9 all-symbol repair table         | `[19,4,8]₉`; rows `(ν,τ)=(4,7),(6,12),(7,13)`; repair counts `28`, `36+8`, `36+12` | coding | lean `RepairCodes/Q9Uniform.lean` `axisTwistedCubic_q9_row_invariants`, `cubicRepair_edge_count_q9`, `axisRepair_component_edge_counts_q9` |
| thm-axis-q9-circuits | Exact q9 small-circuit inventory       | 120 axis three-circuit supports and 84 completed cubic four-circuit supports | coding | lean `RepairCodes/Q9CircuitInventory.lean` `q9_smallCircuit_support_counts` |
| thm-axis-uniform-repair | Uniform all-symbol separation       | exact axis formulas, exact cubic row, and `τ>ν` at every coordinate for `q≥9` | coding | lean `RepairCodes/AxisTwistedCubicInvariants.lean` `minimalAxisRepair_nucleus_invariants`, `minimalAxisRepair_finite_invariants`, `cubicRepair_matchingNumber`, `axisTwistedCubic_allSymbol_tau_gt_nu` |
| thm-axis-q9-lift    | Conditional finite q9 seed-and-lift     | `[19N,4K,≥8D]₉`, all-symbol locality at most 3, exact row transfer, `7ν≤4τ` under explicit outer hypotheses | coding | lean `RepairCodes/Q9SeedLift.lean` `q9UniformLiftCode_parameters`, `q9UniformLiftCode_repairHypergraph`, `q9UniformLiftCode_ratio` |
| lem-axis-trace-bridge | Extension-field trace duality         | ordinary `GF(9⁴)` dual distance implies the restricted-scalar functional-dual gate with exact support | coding | lean `RepairCodes/TraceDual.lean` `hasFunctionalDualDistanceAtLeast_restrictScalars` |
| thm-axis-q9-extension-lift | Degree-four outer-code lift     | actual restricted-scalar `[19N,4K,≥8D]₉` lift; disjoint exhaustive type partition with counts `9N,9N,N`; exact locality three/two; exact row transfer and thresholds `6,11,12` | coding | lean `RepairCodes/Q9ExtensionLift.lean` `q9ExtensionLiftCode_parameters`, `q9Lift_coordinate_type_partition`, `q9Lift_coordinate_type_counts`, `q9ExtensionLiftCode_cubic_exact_locality_three`, `q9ExtensionLiftCode_axis_exact_locality_two`, `q9ExtensionLiftCode_row_invariants`, `q9ExtensionLiftCode_failure_thresholds` |
| thm-axis-q9-asymptotic | Fixed-alphabet asymptotic repair family | unbounded q9 family, exact rate `2/19`, every fixed eventual relative-distance bound `c<39/190`; bundled exact type distribution, mixed locality, rows, and thresholds; Lean-checked modulo Stichtenoth Thm 1.6(ii) | coding | lean `RepairCodes/Asymptotic.lean` `eventually_scaled_lift_distance_gt`, `concrete_q9_uniform_repair_family`; import `RepairCodes/Imported.lean` |
| thm-axis-projective-completion | Projectively completed cubic--axis seed | `[2q+2,4,q]_q`, dual distance three; radius four exhausts the full minimal inner port; uniform cubic row `((q−1)/2,q−1)` and axis row `((5q−3)/6,2q−3)` | coding | paper §projective completion; lean `FiniteGeom/ProjectiveAxisTwistedCubic.lean` `projectiveAxisTwistedCubic_code_parameters`; `RepairCodes/ProjectiveAxisTwistedCubicInvariants.lean` full-invariant theorems |
| thm-axis-projective-q9-lift | Completed q9 bounded-port lift | `[20N,4K,≥9D]₉`; exact `10N/10N` partition; exact locality three/two and radius-four rows `(4,8)`, `(7,15)` under outer dual distance six; no unbounded lifted-port claim | coding | lean `RepairCodes/ProjectiveAxisTwistedCubicLift.lean` parameter, partition, locality, and row theorems |
| thm-axis-projective-q9-asymptotic | Completed fixed-alphabet family | unbounded q9 family, exact rate `1/10`, every fixed eventual relative-distance bound `c<351/1600`, clean `≥1/5`, and exact bounded radius-four profiles; Lean-checked modulo Stichtenoth Thm 1.6(ii) | coding | lean `RepairCodes/ProjectiveAxisTwistedCubicAsymptotic.lean` `eventually_projective_scaled_lift_distance_gt`, `concrete_projective_q9_uniform_repair_family` |
| lem-twisted-cubic   | Twisted-cubic / NRC independence         | moment-curve columns linearly independent          | coding/completion   | lean `FiniteGeom/MomentCurve.lean:92` `twistedCubic_linearIndependent` |
| thm-singleton-mds   | Singleton bound / MDS                    | minDist + dim ≤ n + 1; `IsMDS` predicate           | coding (base)       | lean `FiniteGeom/Code.lean:222` `singleton_bound` |
| comp-a344227        | A344227 a(14..17)                        | queens Node-Kayles nimbers 0, 1, 0, 2              | oeis:A344227        | solver `rust/src/queens/solver/nimber.rs` |
| comp-queens-n18     | n=18 Queens = first-player win           | witness opening I9 ⇒ a(18) ≠ 0                     | queens-n18          | `queens-n18-paper.md` + Rust solver |

*Continuation remains plan-stage. The focused Baer/Q25 criterion and exact coordinate quadratic
pair-extension theorem are Lean-built. The completion/transversal, clutter, weighted, blocker,
secant-index, persistence, Hilbert-90, Baer-subplane, incidence-counting, and two-element-orbit
ingredients are classical infrastructure, not Discovery Track claims. The assembled exact
quadratic-Frobenius criterion is the principal plausibly unrecorded result; see the linked audit.
The external `GF(25)` census size and observed minimum 32 are not in this results table; they remain
computational evidence rather than Lean theorems.
`PG(4,3)=P` is a computed frontier datum, not a theorem.*
