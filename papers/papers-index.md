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
| `baer-equivariant-extension`  | Equivariant extensions of Galois-invariant arcs over finite fields | Theorem-package plan; audit SOFTEN             |
| `completion-core-rigidity`    | Robust completion of finite-geometric packings and codes         | Theorem-package plan; swing (may fold into Baer) |
| `continuation-graph-rigidity` | Semilinear rigidity/reconstruction from cap continuation graphs   | Theorem-package plan; N1 headline survives      |
| `arcs_complete_outside_conic` | Arcs complete outside a prescribed conic (secant-defect identity, bounds) | Self-contained manuscript (LaTeX + PDF + verifier); near submission-ready — *related but separate* |

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

- **Complete LaTeX manuscript (+ PDF + verifier):** `arcs_complete_outside_conic` — near
  submission-ready.
- **Markdown manuscript exists:** `dihedral-schreier-node-kayles` (the committed submission).
- **LaTeX manuscript exists (partial):** `nofil-finite-geometry-outcomes`
  (`paper-sumfree-capgame/main.tex` — sum-free ℤₙ + affine cap written; projective unwritten).
- **Plan / theorem-package only (no manuscript):** the three Package-2 papers.
- **Sequence packages (ready/draft):** the two `oeis-submissions/` entries.

## Shared blocker

Several deliverables want a **public code/preprint URL** that does not exist yet (the repo has no
public remote): the A344227 `%H` link and n=18 comment, the sequences' program links, and any
arXiv posting of the manuscripts. One public mirror or preprint unblocks them together.

## Lean state at a glance

- **Formalized, `sorry`-clean:** the pairing/mirror geometry outcomes (`lean/ProjectiveCap/`,
  `lean/CapGame/`); the dihedral reduction + V₄→K₄ core (`lean/DihedralSchreier/`); the
  completion δ_x = τ identity (`lean/FiniteGeom/Completion.lean`); the coding/LRC seed
  (`lean/RepairCodes/`).
- **Planned, not built:** `BaerExtension`, `CompletionCore`, `ContinuationRigidity` libraries
  (see `../notes/handoffs/2026-07-11-lean-formalization-plan.md`).
- **One exception to the axiom-clean bar:** a single `native_decide` in
  `DihedralSchreier/KleinFourBridge.lean` (`explicit_pairProducts`, a 4-element Klein-four
  enumeration) — an isolated witness with **no downstream dependents** (the V₄→K₄ reduction itself is
  clean); clear it to `decide`/manual before the dihedral paper ships. Everything else, including the
  `CertData` Q11/Q13 certs, is `native_decide`-free (the certs use a kernel-`decide` reflection route;
  `native_decide` was benchmarked and rejected to keep the axiom profile clean).
- **Release gate:** every lemma/proof must be Lean-formalized to the full `lean/TRUST.md` standard —
  `sorry`-free, `#print axioms` clean (no `sorryAx`/`native_decide`), statements adequate to the
  claim, with a trust-chain note — before its paper is published. So these planned libraries, plus a
  new one for the arcs paper and the dihedral paper-level theorems, are release-blocking.
  Computational enumerations (queens, S₄/A₅ nimbers, ρ_𝒞 values) follow the `getK` pattern: a
  Lean-proved recurrence + a differential-tested reproducible solver, not `native_decide`. See
  `papers-planning.md` → *Authorship, provenance & reception*.

## Results → papers → proofs

Key computational results and proven lemmas/theorems, mapped to their paper and proof location.

**Paper aliases:** `nofil` = `nofil-finite-geometry-outcomes`; `dihedral` =
`dihedral-schreier-node-kayles`; `arcs` = `arcs_complete_outside_conic`; `baer` =
`baer-equivariant-extension`; `completion` = `completion-core-rigidity`; `continuation` =
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
| thm-defect-identity | Prescribed-hole defect identity          | exact secant-index defect remainder identity       | arcs                | paper §3 (Thm, `thm:defect`) |
| thm-rho-lower       | ρ_𝒞(q) asymptotic lower bound            | ρ_𝒞(q) ≥ √(2q) + 3/2 − O(q^(−1/2))                 | arcs                | paper §4 (Thm, `thm:asymptotic`) |
| thm-rho-transfer    | Averaging upper-bound transfer           | ρ_𝒞(q) ≤ t₂(2,q) when t₂(2,q) ≤ q                  | arcs                | paper §5 (Thm, `thm:transfer`) |
| lem-nucleus         | Even-char nucleus constraints            | nucleus in/out arc: tangent & parity laws          | arcs                | paper §6 |
| comp-rho-small      | ρ_𝒞 small values                         | ρ_𝒞(8)=ρ_𝒞(9)=ρ_𝒞(11)=6; 8 ≤ ρ_𝒞(16) ≤ 9           | arcs                | paper §7 + verifier `verify_relative_conic_arcs.py` |
| thm-baer-criterion  | Orbit-valued extension criterion         | Galois conjugate-pair arc-extension test           | baer                | note (Thm 3.1) [plan; Lean Phase 4] |
| thm-baer-saturation | √2·s orbit-saturation bound              | = classical Lunelli–Sce √(2q) (softened)           | baer                | note (Cor 3.4) |
| thm-completion-tau  | δ(C) = τ                                 | completion distance = circuit-transversal number   | completion          | lean `FiniteGeom/Completion.lean:78` `completionDistance_eq_transversalNumber` |
| lem-nu-tau          | ν ≤ τ                                    | matching ≤ transversal (hypergraph base)           | completion (base)   | lean `FiniteGeom/Hypergraph.lean:53` `matching_card_le_transversal_card` |
| thm-frame-rigidity  | Frame-graph semilinear rigidity (N1)     | Aut = ambient semilinear group, q ≥ 13             | continuation        | note (Thm 7.4) [plan] |
| thm-complex-recon   | Continuation-complex reconstruction (N2) | recovers plane + secants + arc                     | continuation        | note (Thm 8.4) [plan; SOFTEN] |
| lem-transfer        | Concatenation transfer lemma             | bounded-weight dual-distance transfer              | coding (unhomed)    | lean `RepairCodes/Transfer.lean:136` `transfer_lemma` |
| thm-gf9-dualdist    | GF9 seed [10,4,6]₉ dual distance         | inner seed minimum distance = 6                    | coding (unhomed)    | lean `RepairCodes/Q9Seed.lean:657` `q9InnerCode_minDist` |
| lem-twisted-cubic   | Twisted-cubic / NRC independence         | moment-curve columns linearly independent          | coding/completion   | lean `FiniteGeom/MomentCurve.lean:92` `twistedCubic_linearIndependent` |
| thm-singleton-mds   | Singleton bound / MDS                    | minDist + dim ≤ n + 1; `IsMDS` predicate           | coding (base)       | lean `FiniteGeom/Code.lean:222` `singleton_bound` |
| comp-a344227        | A344227 a(14..17)                        | queens Node-Kayles nimbers 0, 1, 0, 2              | oeis:A344227        | solver `rust/src/queens/solver/nimber.rs` |
| comp-queens-n18     | n=18 Queens = first-player win           | witness opening I9 ⇒ a(18) ≠ 0                     | queens-n18          | `queens-n18-paper.md` + Rust solver |

*Plan-stage rows (baer, continuation) are proven in the notes but their Lean libraries are not yet
built. `PG(4,3)=P` is a computed frontier datum, not a theorem.*
