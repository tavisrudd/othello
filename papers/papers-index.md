# Papers index

Publication-track staging. Each subdirectory is a **candidate paper**: a curated view (symlinks
into `../notes/`) of the source notes for one result, plus a `README.md` status map. A directory
is a staging area, **not** a commitment to a separate publication. The
Fable review (2026-07-12) supplied the original decomposition; later
paper-specific rulings supersede its count where stated below. The
provisional Baer + completion merge was superseded by the focused Baer/Q25
ruling on 2026-07-14, dihedral bundles the D₂ₘ family, continuation is
N1-only, and coding proceeded after its internal audit. **Clebsch: Rigidity
from Sparse Shadows is a five-paper numbered series:** rigidity Paper I,
factorization Paper II, `passages` Paper III, q13 passant-code Paper IV, and a
culminating recognition and marked-round-trip Paper V. The MDS--CSS
transversal-groups and Golden interferometer papers are unnumbered companions.
Papers I--III have GitHub/DOI v1 and v2 releases; later changes are forward
versions. The former
37-page mega-paper is not being published and is retained at
`archive/papers/clebsch-hexagon-code`. See
`notes/handoffs/2026-07-13-clebsch-paper.md` for the current order and
`papers-planning.md` for the older decomposition rulings.

Likely expert readers, referee-fit cautions, paper-specific questions, and high-excitement upgrade
targets are maintained in [`expert-profiles/`](expert-profiles/README.md).
The shared rigidity/transport research agenda for `arcs`, `clebsch`, `repaircodes`, and `baer` is
recorded in [`2026-07-15-cross-paper-incidence-pattern-agenda.md`](../notes/2026-07-15-cross-paper-incidence-pattern-agenda.md).

An additional unnumbered methods-paper idea, `lean-proof-engineering-at-scale`, is tracked below.
It is not part of the seven-paper mathematical ship order and has no manuscript directory yet.

**Numbering.** The `#` on each directory row is that paper's **ship-order number, 1–7**, and is the
one numbering scheme in use — `papers-planning.md` → *Papers — decomposition and ship order* is the
authoritative list (it carries the gate distances and the dependency rulings); this registry carries
the same numbers and does not restate them. Directory rows appear in ascending `#` across both tracks
below. `—` marks a staging view that is not itself a paper. The public mirror and the two OEIS
entries are **not** papers and are deliberately outside this numbering; see the planning doc's
*Non-paper deliverables*. These numbers are registry positions, not working names; future candidates
use a descriptive alias and working title until admitted here.

## Games track — impartial cap / Nofil / Node-Kayles

**1 · `nofil-finite-geometry-outcomes`** — Outcome classes of cap/Nofil games on finite
geometries (pairing/mirror)
- *Status:* partial draft; projective proven but unwritten.
- **Owns the game reading** of the shared q=11/q=9 material (`thm-relative-game-localization`,
  `comp-q9-terminal`, `comp-q11-icosahedral`); see *Arcs vs Nofil* in the planning doc.

**2 · `dihedral-schreier-node-kayles`** — *Node Kayles on Conic Schreier Graphs: Dihedral and
Polyhedral Templates*
- *Status:* draft near-complete, committed.

*Split by technique:* Schreier-residual nimbers vs the pairing/mirror ⇒ P method.

## Geometry / coding track — Package 2 (arc extension & reconstruction)

**`integral_secant_arcs`** — *Integral Secant Distributions and Line-Code
Obstructions for Complete \((k,n)\)-Arcs*
- *Contents:* manuscript, exact-arithmetic evidence bundle, partial Lean
  companion, imported-source registry, and referee guide.

**3 · `arcs_complete_outside_conic`** — *Secant defects with prescribed holes: arcs, caps, and
matching designs*
- *Status:* self-contained manuscript + PDF + independent checkers + strict-trust Lean
  formalization; the 21-page paper has completed adversarial, style-guide, and repeated cold-prose
  review. The standard frame and optional-branch hierarchy are explicit. Its remaining
  paper-specific scholarly-artifact gate is a stable, citable archive identifier for the source
  supplement; the repo-wide adequacy-appendix and AI/provenance-disclosure policies also remain to
  be applied before release.
- **Owns the q=11 deep-holes=conic identification** (`comp-q11-mds-deep-holes`), which
  is shared setup for `clebsch`, and the arc/extension reading of the material shared with `nofil`.
  “Owns” is a publication-allocation statement: Dye and Blokhuis--Seress--Wilbrink supply the
  classical inclusion `C subset U`; `arcs` publishes the exact equality, coding translation, and
  certificate as an apparently unrecorded synthesis.

**4 · `clebsch-rigidity`** — *Reconstructing the Clebsch code and its golden orientation from its
deep-hole syndrome locus*, with the companion *Computational strengthenings of Clebsch syndrome
rigidity* in the same root
- *Status:* warning-free manuscript + PDF, split into a human core and the
  computational companion, each with its own build target, bibliography, claim
  ledger, and replay routes. Review cleared; C182 owns archive/release, whose
  blocker is an immutable public artifact locator.
- *Scope:* conceptual and low-degree rigidity, quantitative gaps, decoder and
  automorphism structure, invariant support bipartition, Brianchon
  reconstruction, `q=11` uniqueness, the universal conic-filling window, and the
  `4≤k≤8` classification.
- **Ships after `arcs` by publication-allocation ruling, not mathematical
  dependency.** It reproves the shared deep-holes=conic input while citing
  `arcs` for public provenance.

**Clebsch second paper · `clebsch-factorization`** — *Quadratic trade rigidity and cubic orientation
in conic matching quotients*
- *Status:* C577 active. The `3,6,10` ranks and cubic survival now have
  conceptual proofs, and C665 adds the completeness theorem naming `B₃/F₇` and
  `H₃/F₁₁` as the only occurring orbits.
- *Scope:* conic matching quotient, ranks `3,6,10`, balanced sheets,
  cubic-first orientation, six-profile reconstruction, modular depth, and
  arithmetic splitting/gluing.

**Clebsch third paper · `clebsch-passages`** — *Golden descent and operator realizations of the
Clebsch cubic*
- *Status:* the rational square class `5J₀` supplies the golden orientation,
  the conference operator carries it through the classical Clebsch--Segre
  shadows, and the degree-six Petersen/Gaunt construction returns the same
  invariant harmonically. The seven trust rows are proved, certified, or
  literature-backed, and the structural Lean companion records exact
  partial-mechanism coverage without serving as a manuscript premise. Local
  release gates are closed; submission still requires an immutable finitegeom
  release containing the supplemental golden-return sources.

**Clebsch fourth paper · `q13-passant-code`** — *Reconstructing $\PG(2,13)$, its conic, and polarity
from the minimum words of a binary conic code* (earlier titled *A binary [78,36,12] code from the passant lines of a conic over
F13*)
- *Status:* a manuscript-only pre-release was deposited 2026-08-03 as DOI
  `10.5281/zenodo.21783971`, with the Lean companion excluded and due as a forward version. C761 has
  installed the standalone manuscript, verification, and release-planning
  infrastructure. The proof-producing formal closure, the exhaustive Lean standards checklist,
  isolated replay, and the full public artifact remain active work.
- *Scope:* exact dimension and minimum distance, 364 minimum words in four projective orbits — one
  octahedral family and three chord-indexed punctured-conic families — spanning by every orbit
  through a canonical `F₈` operator field, reconstruction of the passant incidence matrix, the code,
  the elliptic association scheme and then all of `PG(2,13)` with its conic and polarity from
  weighted pair concurrences alone, and exact coordinate-permutation automorphism group
  `PGL(2,13)`.
- *Boundary:* Paper IV does not own the through-eight or all-`k` conic-filling classification.
  It cites Paper I for motivation and becomes the canonical home of the full q13 code proof.

**Clebsch fifth paper · `chordal-conference-reconstruction`** — *Chordal and Conference Cubics: Reconstruction and a Residual C2-Torsor*
- *Status:* complete 11-page manuscript with a paper-owned exact checker;
  claim-specific literature closure and isolated cold-referee review remain
  open before release.
- *Scope:* identifies the signed Paper-II residue as a chordal Hankel cubic,
  recovers the original six axes from stabilizer pairs on its singular
  quartic, places it beside the conference cubic in the invariant pencil,
  and proves the exact oriented marked return through the normalized outer
  difference \(q-1\).
- *Boundary:* the conference and chordal lines are distinct; the inverse
  requires a selected chordal line, and Paper IV remains an independent
  reconstruction branch.

**Active unnumbered candidate — cubic-stabilization-irrationality** —
*Sharpness of Irrationality after One Stabilization for Cubic Threefolds*
- *Status:* ten-page release candidate with an exact-arithmetic tangent-slice
  certificate, current claim/import ledgers, a clean standalone export, and
  cleared hostile geometry, quotient/computation, and public-surface review.
- *Scope:* proves that two explicit smooth cubic threefolds have level of
  stable rationality exactly two over both \(\mathbf Q\) and \(\mathbf C\);
  proves \(S\times\mathbf A^2\) rational for quartic del Pezzo surfaces with a
  rational point and stably permutation geometric Picard lattice; and gives a
  reusable constructive criterion for rational torus quotients from descended
  tangent sections.
- *Boundary:* the upper bound concerns the two displayed cubic series, not
  every smooth cubic threefold; the independent one-stabilization theorem
  supplies the lower bound for the cubic threefold members.

**5 · `complete-repair-ports`** — *Complete Bounded Repair Ports: Transfer, Reliability, and
Geometric Structure*
- *Status:* six-part private manuscript assembled and rebuilt, with synchronized proof and novelty
  ledgers. Structural-section assembly is complete and C220 is **omitted by decision**. External
  specialist citation-chain review, immutable checker/archive identity, shared-Lean public closure,
  adequacy/provenance integration, and public-export gates remain before submission.
- *Headline:* complete bounded repair ports unify support, coefficient, and probability layers;
  exact weighted-functional transfer and prescribed realization connect the local object to
  asymptotically good families; reliability/EXIT and pointed-Tutte structure culminate in a cubic
  versus quartic-nucleus/harmonic comparison.
- *Clebsch application:* the full pointed coefficient port of the
  `[6,3,4]_11` Clebsch code reconstructs the inner code and occurs with
  density `1/6` in an asymptotically good fixed-`F_11` family; its
  support-only clutter is explicitly identified as generic MDS data.
- *Trust and scope:* the finite transfer/cubic core is kernel-checked; prescribed asymptotics,
  reliability/EXIT, pointed-Tutte specialization, and all-field harmonic proofs are manuscript
  arguments backed where finite by committed deterministic certificates. The concrete TVZ family
  uses exactly the quarantined Stichtenoth theorem. Coefficients certify a direct
  one-symbol-per-helper scalar protocol, not minimum bandwidth or access under subpacketization. Primary venue fit is Designs,
  Codes and Cryptography / Finite Fields and Their Applications, not IEEE-TIT in the present form.

**6 · `equivariant-robust-completion`** — *Frobenius-equivariant pair extension and robust repair
of eight-arcs*
- *Lane:* `paper-frob-eq`.
- *Status:* focused LaTeX submission source + bibliography + cleanly compiled PDF; exact quadratic
  criterion, semantic global count, collision inverse, robust exchange, and uniform Q25 theorem
  Lean-built. In the two-fixed-point Q25 profile, `32` is the exact semantic minimum and five
  residual-group orbits are the complete equality set up to normalization.
- *Clebsch application:* scalar extension to `F_121` gives exactly `4180`
  Frobenius-paired two-column MDS extensions of the Clebsch hexagon and
  `4179` alternate repairs after deletion of a selected pair; this
  manuscript corollary applies to every `F_11`-rational six-arc.
- *Staging/library views, not themselves papers:* `archive/papers/baer-equivariant-extension` is a
  retired source view merged into this paper;
  `completion-core-rigidity` is reusable generic infrastructure outside the submission.

**7 · `continuation-graph-rigidity`** — *Semilinear rigidity of four-point-frame continuation
graphs*
- *Status:* N1-only LaTeX working manuscript with complete written proof; the planned Lean library
  is not yet built. Full-complex reconstruction remains a softened scope remark.

**Active unnumbered candidate · `high_weight_grs_cosets`** — *High-weight cosets of generalized and
extended Reed--Solomon codes*
- *Status:* 42-page archival manuscript and 31-page IEEE TIT version with a public verification
  bundle; the current revision is under final artifact packaging.
- *Owns:* the arbitrary-redundancy classification of all weight-at-least-(r-1) cosets for
  point-deleted projective-line supports, its deep-hole and MDS/NMDS extension consequences, and
  the sharp redundancy-five through redundancy-seven refinements.
- *Boundary:* R8--R10 computations remain companion records and are not claims of the submission;
  the general Reed--Solomon deep-hole conjecture is not claimed.

**Active unnumbered candidate · `ame_lu`** — *Robust Local-Unitary Rigidity of Stabilizer AME States*
- *Lane:* `ame-lu`.
- *Status:* 35-page candidate, deposited as DOI `10.5281/zenodo.21681856`, with a standalone mirror;
  no submission has occurred.
- *Owns:* the arbitrary-length LU-to-LC theorem for equal-phase MDS--CSS states, its generalization
  to every stabilizer AME state (CSS, equal phase, classical linearity, and MDS are all unnecessary
  for rigidity), the factorwise transversal no-go, the Pauli phase-correction lemma, the
  minimum-support atlas, and the cleaning-based quantitative rounding chain with its uniform scale
  and the unresolved affine stabilizer-character correction.
- *Trust:* the marginal-to-rigidity chain is in the formal aggregate; the quantitative rounding and
  two-uniform estimates are manuscript proofs, and the Choi/encoder construction remains one.

**Active unnumbered candidate · `mds_css_transversal_groups`** — *Diagonal Isoduality and
Transversal Clifford Groups of MDS--CSS Codes*
- *Lane:* `ame-lu`.  Split from the AME rigidity paper above, which it cites and does not reprove.
- *Status:* 23-page candidate, deposited as DOI `10.5281/zenodo.21766797`, with a standalone mirror;
  no submission has occurred.
- *Owns:* the diagonal code-to-dual multiplier line and its nullity test, the exact fixed-party
  projective transversal group `F_q^2 : SL_2(q)` versus `F_q^2 : T` that the nullity selects, the
  six-arc self-association and conic boundary, the degree-eight pencil quotient and its
  local-Clifford/local-unitary classification over odd prime fields, the Frobenius-sector divisors,
  the Clebsch syndrome application, and the fixed-copy scalar blindness boundary.
- *Trust:* its own semantic Lean gate `RelativeConicArcs.Gates.MDSCSSTransversalGeometry` and axiom
  audit, with a registered terminal set and a public claim manifest; the exact carrier,
  classification, separator, logical-phase, and transport terminals are hypothesis-explicit
  interfaces over manuscript proofs and replayable certificates.

*Common parentage:* all descend from "Package 2" in `../notes/2026-07-10-codex-publishable-spinout-audit.md`
and share the `lean/FiniteGeom/` base. The Clebsch program is the exception:
Paper I descends from the `arcs` q=11 witness
(`comp-q11-mds-deep-holes`) rather than from Package 2, and the four numbered
Clebsch candidates share that witness's `lean/RelativeConicArcs/` library
rather than owning one.
Primary venue fit is Designs, Codes and Cryptography / Finite Fields and Their Applications, with
JCTA's shorter-paper format or J. Geometry as secondary fits; explicitly **not** IEEE-TIT. Lane map
— the single live doc to read first (status, verification map, remaining work):
`../notes/handoffs/2026-07-13-clebsch-paper.md`. Lane alias `clebsch`
(CLAUDE.md routing), same word as this directory's alias.

**Active unnumbered candidate · `conference-cut-spectra`** — *Balanced Cuts of Conference
Matrices: Squared-Spectrum Rigidity and Hermitian Holonomy*
- *Lane:* `golden`.
- *Status:* deposited as DOI `10.5281/zenodo.21766747`, with a standalone mirror and an
  immutable-source release policy; no submission has occurred.
- *Owns:* the classification of symmetric conference matrices whose normalized balanced
  cross-block Gram spectrum is cut-independent; the order-six continuous-control optimum; the
  Hermitian triangle-holonomy parametrization of the degree-three Pareto frontier; quantitative
  rigidity relative to the real switching class; the general orientation refinement for port
  transfers; and the six-mode conference-interferometer application.
- *Lean:* the `conference_cut_spectra` export area is configured but is not adopted on the
  finitegeom repository, so this paper's Lean development currently sits outside the shared library.

**Source programme, not a numbered paper · `golden-operator`** — *The golden conference operator and
its shadow sisters*
- *Lane:* `golden`.
- *Status:* gated in the repository registry, on the ground that the source programme is not adopted
  as a standalone publication.
- *Role:* the source-development programme for a future forward version of Paper III
  (`clebsch-passages`), centered on the common operator theorem rather than the full inventory.
  Released Paper-III versions remain immutable, and publication integration runs through the
  `passages` identity rather than a separate release.


## Engineering / methods track — unnumbered spin-off

**— · `lean-proof-engineering-at-scale`** — Lean proof engineering for large generated-certificate
repositories: an evidence-based essay and practical how-to

- *Status:* idea registered; outline, literature positioning, and manuscript staging directory open.
- *Owns:* the reusable engineering lessons from the project rather than any mathematical theorem:
  stable checker/schema boundaries, bounded certificate shards, content-trace staleness, import
  blast-radius control, restart sentinels, disk-backed artifact recovery, `LEAN_NUM_THREADS` fan-out
  control, OOM-sacrificial `choom` guards, and cross-lane build-tree isolation.
- *Evidence base:* the measured C143/C151 build failures and successful redesigns, including direct
  versus shared-incidence certificates; the C162 restart/cache/blast-radius tooling should turn the
  case study into reproducible guidance.
- *Claim posture:* practitioner methods/case-study paper first. Any novelty claim about build systems,
  proof-certificate architecture, or multi-agent formalization requires a dedicated literature audit
  and comparison against existing Lean/Lake, CI/cache, and large-formalization practice.
- *Lane:* `build-sys`; live entry doc:
  `../notes/handoffs/2026-07-14-lean-build-system.md`.

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

- **Complete 18-page LaTeX manuscript (+ PDF + independent checkers + strict-trust Lean package):**
  `arcs_complete_outside_conic` — adversarial, style-guide, and repeated cold-prose reviews are
  complete, with a final recommendation to publish after minor revision. The frame coordinates and
  optional-branch hierarchy identified in that review have landed. The remaining paper-specific
  scholarly-artifact gate is a stable, citable archive identifier for the source supplement; the
  shared release policy still requires the verbatim Lean adequacy appendix and explicit
  AI/provenance disclosure.
- **Six-part private LaTeX manuscript (+ PDF + deterministic replays + proof/novelty ledgers +
  strict-trust Lean core):** `complete-repair-ports` — identity and structural assembly are
  complete; C220 is omitted. Specialist citation-chain review, immutable checker/archive identity,
  shared-Lean public closure, adequacy/provenance integration, and the deferred aggregate rebuild
  remain submission preflight gates.
- **Focused LaTeX manuscript (+ PDF; verification surface in progress):**
  `clebsch-rigidity` — the active 19-page Paper I. It contains the explicit
  code, complete fifteen-class census, conceptual rigidity proof, decoder
  reconstruction, support bipartition, field uniqueness, and small-arc
  classification. Its printed nineteen-row trust map is authoritative;
  C320 must still freeze the exact gate/checker/replay surface.
- **Compilable Clebsch spines:** `clebsch-factorization` for gated Paper II
  and `clebsch-passages` for the still-conditional Paper III.
- **Markdown manuscript exists:** `dihedral-schreier-node-kayles` (the committed submission).
- **LaTeX manuscript exists (partial):** `nofil-finite-geometry-outcomes`
  (`paper-sumfree-capgame/main.tex` — sum-free ℤₙ + affine cap written; projective unwritten).
- **Focused LaTeX manuscript + PDF + Lean lane:** `equivariant-robust-completion`, with the exact
  coordinate quadratic extension theorem, robust repair, exact Q25 minimum/classification, and
  completed internal referee closeout. Continuation rigidity has an N1-only LaTeX working
  manuscript but no Lean library yet.
- **Active manuscript scaffold:** `high_weight_grs_cosets` — C538 owns the integrated draft, C545 the rapid
  proof-complete DOI-bearing preprint, and C539--C544 the Lean closure.
- **Sequence packages (ready/draft):** the two `oeis-submissions/` entries.

## Shared blocker

Several deliverables want a **public code/preprint URL** that does not exist yet (the repo has no
public remote): the A344227 `%H` link and n=18 comment, the sequences' program links, and any
arXiv posting of the manuscripts. One shared, incrementally tagged public Lean repository plus
paper-specific fresh-history repositories supplies that prerequisite. It does not clear each
paper's remaining adequacy/provenance, scholarly review, immutable-release, or build gates.

## Lean state at a glance

- **Formalized, `sorry`-clean:** the pairing/mirror geometry outcomes (`lean/ProjectiveCap/`,
  `lean/CapGame/`); the dihedral reduction + V₄→K₄ core (`lean/DihedralSchreier/`); the
  Baer pair-extension proof spine (`lean/FiniteGeom/BaerCompletion/`) and its projective-plane,
  coordinate-conjugation, and quadratic-Frobenius consumers (`lean/RelativeConicArcs/`); the
  completion δ_x = τ base identity (`lean/FiniteGeom/Completion.lean`); the coding/LRC seed,
  exact-transfer, asymptotic, projective-completion, and operational-coefficient theorem chain
  (`lean/RepairCodes/`); and the complete arcs-outside-a-conic theorem/certificate package
  (`lean/RelativeConicArcs/`).
- **Partially formalized with an explicit classical boundary —
  `clebsch-rigidity`:**
  `Q11Coding.lean` and `Q11A5PointOrbits.lean` certify the syndrome conic and concrete point-orbit
  data; `Q11DecodingSynthesis.lean` certifies the decoding/Brianchon/support-bipartition synthesis;
  `ReflectionArrangements.lean` certifies the finite `A₃/H₃` coordinate bridges, intersection
  spectra, characteristic boundary, and pointwise transport to the Clebsch secant index;
  `SixArcDefectBridge.lean` proves the projective chord-defect identity; and
  `Q11BrianchonClassification.lean`/`Q11DyeConsequences.lean` prove the ten-point bound and the
  equality classification at order eleven, both stated by Dye, and derive the conic-containment
  rigidity implication from them. `ClebschChordDefect.lean` and
  `Q9Sylvester.lean` support field uniqueness, while `SmallKChordMoments.lean` and
  `SmallKGeometricBridge.lean` certify the universal small-arc moment consequences. All eleven are
  available kernel-checked roots for Paper I. C320 must admit and name only
  those actually used by the nineteen-row Paper I surface. The two gap
  censuses, low-degree finite linear algebra,
  Clebsch-family use of Dye, and finite `k=7` exclusions are intentionally outside Lean and mapped
  to exact replays or citations in the paper's verification tables. Lane map:
  `notes/handoffs/2026-07-13-clebsch-paper.md`. The broader replacement-spine
  Lean campaign belongs to Paper II/III inventories unless their separate
  manifests adopt it.
- **Planned, not built:** `ContinuationRigidity`. The exact quadratic Baer pair-extension data and
  semantic arc extension are Lean-proved; see `lean/FiniteGeom/BaerCompletion/TRUST.md`.
- **Axiom-clean bar:** `KleinFourBridge.explicit_pairProducts` now uses kernel `decide`; the former
  `native_decide` exception is closed. The coding/LRC chain is likewise `native_decide`-free; see
  `lean/RepairCodes/TRUST.md` and its dated adversarial review.
- **Release gates are paper-specific:** every claim presented as Lean-formalized must meet the full
  `lean/TRUST.md` standard — `sorry`-free, axiom-audited, and free of `native_decide` — but a paper
  may instead declare a mixed boundary of conceptual proof, classical citation, exact replay, and
  kernel-checked consequence. The arcs library is complete; focused Clebsch
  Paper I has a frozen nineteen-row manuscript map but its C320 release
  surface is still open. Paper II and Paper III require separate maps if
  built. The remaining planned libraries and dihedral paper-level theorems
  are release-blocking only where their own lane requires them.
  The queens and S₄/A₅ nimber enumerations follow the `getK` pattern: a Lean-proved recurrence plus
  a differential-tested reproducible solver, not `native_decide`. The ρ_𝒞 values instead enter
  through kernel-checked coordinate witnesses; at q=16 the lower bound uses locally checked
  transition and leaf-obstruction certificates forming an exhaustive covering list. Independent
  programs provide provenance, not trusted answers. See `papers-planning.md` → *Authorship,
  provenance & reception*.

## Results → papers → proofs

Key computational results and proven lemmas/theorems, mapped to their paper and proof location.

**Paper aliases:** `nofil` = `nofil-finite-geometry-outcomes`; `dihedral` =
`dihedral-schreier-node-kayles`; `arcs` = `arcs_complete_outside_conic`; `paper-frob-eq` =
`equivariant-robust-completion`; `completion` is library-only; `continuation` =
`continuation-graph-rigidity`; `queens-n18` = `non-formal-bloggy/queens-n18`; `oeis:*` =
`oeis-submissions/*`; `complete-ports` = `complete-repair-ports`; `clebsch` =
active program rooted at `clebsch-rigidity`.

**Proof-location key:** `lean <file>:<line> <ident>` = formalized, `sorry`-clean (paths under
`lean/`); `paper §N` = proven in that manuscript; `note <file>` = proven in a research note
(plan-stage, Lean deferred); `solver <path>` = computed by a cross-checked solver; `checker <path>`
= re-verified by a standalone script in the paper directory (independent of
Lean and of the manuscript's own computation). Clebsch rows distinguish
this grade from kernel-checked formalization; until C320 freezes Paper I,
their checker names identify candidate evidence in the preserved fallback
surface rather than a completed Paper I release bundle.

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
| thm-relative-game-localization | Exact cap-game localization | every continuation stays in `A∪H`; off-hole moves equal the uncovered locus; any injective hole parametrization preserves the full normal-play value | nofil | lean `RelativeConicArcs/ProjectiveBridge.lean` `move_mem_holes_of_completeOutside`, `legalExtensions_sdiff_holes_eq_uncovered`, `win_parametrizedHoles_iff`, `isP_parametrizedHoles_iff` — the game predicates live in the `arcs` library for historical reasons (that is where the witness was formalized), which is a file-location fact, not a claim by the `arcs` paper |
| thm-secant-moments  | Maximum index and secant moments         | `r_A(x)≤⌊k/2⌋`; `Σr=C(k,2)(q−1)`; `ΣC(r,2)=3C(k,4)` | arcs                | paper §2; lean `RelativeConicArcs/Moments.lean:202` `pointIndex_le_half_card`, `:290` `first_secant_moment`, `:510` `second_secant_moment` |
| thm-defect-identity | Prescribed-hole defect identity          | exact secant-index defect remainder identity       | arcs                | paper §3; lean `RelativeConicArcs/Defect.lean:214` `scaledDefect_eq_remainders` |
| thm-defect-corollaries | Defect equality, coverage, and stability | exact equality pattern, uncovered-locus bound, and quantitative bounded-defect control | arcs | paper §3; lean `RelativeConicArcs/Defect.lean:309` `scaledDefect_eq_zero_iff`, `:379` `uncovered_bound`, `:465` `stability_bound` |
| thm-affine-complete-defect | Complete affine arcs as line holes | deleting a line `L∞` identifies affine completeness with completeness outside `L∞`; every secant contributes one ideal incidence, giving the exact corrected capacity bound and equality pattern | arcs | paper Corollary `cor:affine`; Giulietti--Montanucci 2006 and Korchmáros--Szőnyi 2008 for the established line-hole/hyperfocused context; lean `RelativeConicArcs/Affine.lean` `completeAffine_iff_completeOutside`, `holeIncidence_pointsOnLine`, `completeAffine_bound`, `completeAffine_bound_eq_iff` |
| thm-conic-normalization | Nonsingular-conic normalization      | standard conic is `XZ=Y²`, has `q+1` points, and `rho` is invariant under projective normalization | arcs | lean `RelativeConicArcs/Conic.lean:286` `standardConic_card`, `:307` `mem_standardConic_iff_onConic`, `:422` `NonsingularConic.rho_points_eq` |
| thm-rho-finite      | Corrected prescribed-hole lower bound    | arbitrary `h`-point holes obey the exact corrected capacity bound with required-locus size `q²+q+1−k−h`; `L₁(q)≤L₂(q)≤ρ_𝒞(q)` for conic holes | arcs | paper §3–4; lean `RelativeConicArcs/Conic.lean` `card_requiredLocus_general`, `completeOutside_bound_general`, `L2_le_rho`, `L1_le_L2` |
| thm-rho-lower       | ρ_𝒞(q) asymptotic lower bound            | explicit `ρ_𝒞(q)≥√(2q)+3/2−8/√(2q)`, Big-O shortfall, and realized-field liminf wrapper | arcs | paper §4; lean `RelativeConicArcs/Asymptotic.lean:275` `rhoC_explicit_additive_lower_bound`, `:301` `additiveShortfall_isBigO`, `:410` `realized_three_halves_le_liminf` |
| lem-transitive-avoidance | Finite transitive-action avoidance | `|A||B|<|X|` gives a translate of `A` disjoint from `B` | arcs | lean `RelativeConicArcs/Averaging.lean:73` `exists_disjoint_smul` |
| thm-rho-transfer    | Prescribed-hole averaging transfer       | an ordinary complete `b`-arc moves off arbitrary `H` when `b|H|<q²+q+1`; hence ρ_𝒞(q) ≤ t₂(2,q) when t₂(2,q) ≤ q; Kim–Vu remains explicit | arcs | paper §5; lean `RelativeConicArcs/Averaging.lean` `exists_completeOutside_of_completeArc`, `rhoC_le_t2`, `rhoC_le_of_kimVuBound` |
| lem-nucleus         | Even-char hyperoval and nucleus constraints | standard conic+nucleus is a hyperoval; tangents, nucleus-in/out incidence and parity laws; every relative-complete arc has `I_𝒞(A)≥1` | arcs | paper §6; lean `RelativeConicArcs/Nucleus.lean` `standardHyperoval_arc`, `standardConic_tangent_iff_mem_nucleus`, `nucleus_mem_arc_constraints`, `nucleus_not_mem_arc_constraints`, `complete_holeIncidence_pos` |
| thm-relative-cert   | Generic relative/ordinary arc certificate soundness | canonical coordinate checks imply relative completeness; stronger ordinary coverage implies completeness with no holes; raw determinant arcs equal projective caps | arcs | lean `RelativeConicArcs/Certificate.lean` `rawArc_iff_projectiveCap`, `check_sound`, `check_sound_empty`, `rhoC_le_length_of_check` |
| lem-rho16-projective-reduction | Eight-cap frame reduction | every eight-cap is carried by a retained linear projectivity to an indexed cap containing the standard four-frame; each `StepBook.coverage` theorem represents every legal move by a certified transition, and `StepBooksValid` covers the parent list exactly, so the four checked covering-list layers are closed and exhaustive; pairwise class deduplication is neither assumed nor certified | arcs | lean `RelativeConicArcs/Q16StepKernel.lean` `StepBook.coverage`, `StepBooksValid`; `Q16Reduction.lean` `exists_mapEquiv_of_caps_card_four`, `classifiedAt_level8_of_frame` |
| lem-uncovered-evaluation-obstruction | Linear-system obstruction from uncovered points | for any linear system of homogeneous forms, injective evaluation on the uncovered locus or a selected evaluation functional in its span excludes a zero locus containing the uncovered set and avoiding the selected set | arcs, algebraic geometry | paper Lemma `lem:evaluation-obstruction`; lean `RelativeConicArcs/EvaluationObstruction.lean` `eq_zero_of_evaluationMap_injective`, `evaluation_eq_zero_of_eq_sum`; quadratic instances in `Q16Reduction.lean` |
| thm-evaluation-dichotomy | Sharp finite-field evaluation avoidance | for any feature map (hence every Veronese degree), a form vanishing on `U` and avoiding `A`, `|A|≤q`, exists exactly when `span ν(U)` is proper and contains no `ν(a)`; quantitative rank-sensitive lower bound, equality model, and sharp `q+1` plane cover | arcs, algebraic geometry | paper Appendix B, Proposition `prop:evaluation-dichotomy`; lean `RelativeConicArcs/EvaluationDichotomy.lean` `card_outside_hyperplanes_factored_lower_bound`, `evaluation_avoidance_iff`, `feature_evaluation_avoidance_iff`, `card_outside_planeCoverHyperplanes` |
| thm-arc-mds-syndrome | Plane arc / codimension-three MDS syndrome dictionary | transparent parity-check kernel has dimension `n-3` and minimum distance four; projective syndrome distance is 1/2/3 on selected/secant/uncovered directions; actual affine leaders are in bijection with their supports through weight three; index is the exact weight-two leader count; every distance-three affine syndrome has exactly `choose(n,3)` leaders | arcs | paper Proposition `prop:syndrome-dictionary`; lean `RelativeConicArcs/CodingBridge.lean` `CodimThreeMDSColumns.code_finrank`, `minimumDistance_ge_four`, `card_syndromeLeadersOfWeight_eq_supports`, `card_syndromeLeadersOfWeight_three`; `SyndromeGeometry.lean` distance/support theorems |
| thm-relative-syndrome-confinement | Relative completeness as syndrome confinement | `CompleteOutside A H` iff the projective distance-three syndrome directions are confined to `H`; a fresh direction is a one-column MDS extension iff it has distance three | arcs | paper Proposition `prop:syndrome-dictionary`; lean `RelativeConicArcs/SyndromeGeometry.lean` `completeOutside_iff_distanceThreeDirections_subset`, `oneColumnExtension_iff_distance_three` |
| thm-uncovered-parent-reconstruction | Large-field parent fingerprint from the complete extension locus | if `k`-arcs `A,B` in `PG(2,q)` satisfy `q+1>choose(k,2)` and have the same literal uncovered locus, then their secant arrangements agree and `A=B` as unlabelled point sets; the secants are canonically the lines containing more than `choose(k,2)` points of the covered set, and `Stab_PGammaL(U(A))=Stab_PGammaL(A)`; for six-arcs this applies at `q>=16`; the strict threshold is sharp at the `q=5` frame/conic fibre | arcs; generalized from the six-arc input of the Reed--Solomon reconstruction programme | paper Proposition `prop:arc-reconstruction`, Corollary `cor:arc-reconstruction-algorithm`, and Remark `rem:arc-reconstruction-sharp`; proof-only, no finite census |
| thm-extension-conflict-hypergraph | Exact simultaneous arc/MDS extension semantics | general simultaneous extensions are independent sets of the pair/triple conflict hypergraph; when the allowed locus is an arc, this reduces to pair-graph independence and maximality inside that locus; maximality upgrades to ordinary completeness when the locus is the full one-point extension set | arcs library; the paper states the q=11 pair-graph specialization (nofil cites the artifact as its move-legality substrate) | paper Proposition `prop:q11-extensions`; lean `RelativeConicArcs/SyndromeGeometry.lean` `arc_union_iff_extension_hypergraph`, `arc_union_iff_pairExtensionIndependent_of_arc_locus`, `maximalExtensionIn_iff_maximalPairExtensionIndependent`, `completeOutside_empty_of_maximalExtensionIn_full` |
| thm-defect-leader-collision | Coding form of prescribed-hole defect | secant first/second moments and the exact defect are weight-two leader-count and leader-collision identities, yielding the same length obstruction for projective codimension-three MDS systems with prescribed distance-three locus | arcs | paper §`sec:coding`; lean `RelativeConicArcs/SyndromeGeometry.lean` `first_weightTwoLeader_moment`, `second_weightTwoLeader_collision_moment`, `scaledDefect_eq_weightTwoLeader_remainders` |
| thm-uncovered-quadratic-obstruction | GF(16) quadratic-avoidance theorem | for every eight-arc, no nonzero quadratic zero set—singular or nonsingular—contains its ordinary-uncovered locus while avoiding the arc; full-rank and forced-hit alternatives cover all 2633 listed representatives | arcs | paper Theorem `thm:q16-quadratic`, including the short arbitrary-quadratic projective transport; Lean `RelativeConicArcs/Q16QuadraticAvoidance.lean` `QuadraticAvoidance`, `RejectsLevel.quadraticAvoidance`, `level8_quadraticAvoidance` checks every listed leaf, while `Q16Result.lean` `no_completeOutside_GF16_card_eight` kernel-checks the global relative-conic consequence |
| comp-rho16-classes | PG(2,16) eight-arc quadratic-obstruction refinement | a kernel-checked exhaustive covering list of length 2633 matches the known ordinary projective class count (Al-Seraji--Al-Ogali 2018); its leaves split into 2630 full-rank and 3 forced-hit uncovered-quadratic rejections | arcs | generator/report `arcs_complete_outside_conic/search_rhoc16.cpp`, `search_rhoc16_output.txt`; kernel data `RelativeConicArcs/Q16CertificateData*`, `Q16LeafData*`; novelty audit `notes/2026-07-13-rhoc16-novelty-check.md` |
| thm-rho16-exact | Exact relative-conic value over GF(16) | no eight-point arc is complete outside any nonsingular conic; the checked nine-point witness gives `ρ_𝒞(16)=9` | arcs | paper §7; lean `RelativeConicArcs/Q16Result.lean` `no_completeOutside_GF16_card_eight`, `rhoC_GF16`; registry alias `RelativeConicArcs/Results.lean` `Examples.rhoC_GF16` |
| thm-rho5-exact | Exact relative-conic value over GF(5) | the projective four-frame has a nonsingular conic as its full ordinary-uncovered locus, and the corrected lower threshold is `L₂(5)=4`, giving `ρ_𝒞(5)=4` for every nonsingular conic model | arcs | paper Proposition `prop:small-values`; C187 companion conic-filling theorem for the broader small-`k` classification; Lean `RelativeConicArcs/ExampleChecks/Q5.lean` `q5_frame_check`, `L2_five`, `rhoC_ZMod5`, `rho_points_ZMod5`; registry import `RelativeConicArcs/Results.lean` |
| comp-rho-small      | ρ_𝒞 small values and arithmetic thresholds | `L₂(5)=4`, `L₂(8)=L₂(9)=L₂(11)=6`, `L₂(16)=8`; ρ_𝒞(5)=4, ρ_𝒞(8)=ρ_𝒞(9)=ρ_𝒞(11)=6; ρ_𝒞(16)=9 | arcs | paper §7 + q=5 frame checker + independent verifier + q=16 kernel-checked exhaustive covering certificate; lean `RelativeConicArcs/Results.lean`, `RelativeConicArcs/ExampleChecks/Q5.lean`, `RelativeConicArcs/Q16Result.lean` `rhoC_GF16` |
| comp-q11-exterior  | q=11 exterior-secant design              | all 15 witness secants avoid the conic; required-point index distribution `(N₁,N₂,N₃)=(90,15,10)`. Complete exteriority is classical (Dye 1991; BSW 1992); the refined index distribution is derived and verified here | arcs | paper §8 + verifier `I_C=0` + paper moment equations; Dye p. 281 before Thm 6, BSW pp. 143, 146 |
| obs-exterior-relative | Exteriority versus prescribed-hole completeness | complete exteriority gives `C(F_q) ⊆ U(A)`, while relative completeness is `U(A) ⊆ C(F_q)`; BSW's q=7 exterior four-arc has the strict count `20>8` from `|U(A)|=(q-2)(q-3)` | arcs | paper §1 and §8; BSW 1992 pp. 143, 146; elementary four-arc secant count |
| comp-q11-mds-deep-holes | q=11 non-GRS MDS/deep-hole spectrum | projectively non-GRS `[6,3,4]₁₁` code of covering radius three; actual distance-three nonzero affine syndrome rays are exactly the standard conic; actual affine syndrome distribution `(1,60,1150,120)` and actual minimum-weight word split `(900,150,100)` | arcs | paper Proposition `prop:q11-code`; lean `RelativeConicArcs/Q11SemanticRayData.lean` `affineRayVec_bijective`; `Q11SemanticSynthesis.lean` `affine_distanceThree_iff_mem_standardConic`, `mem_affineSyndromesOfDistance_iff`; `Q11SemanticDistribution.lean` `affine_coset_distance_distribution`; `Q11SemanticLeaders.lean` `syndromeLeaderSupports_two_eq_raw`, `distance_two_leader_distribution`; `Q11Coding.lean` MDS/radius/deep-hole theorems and formal no-conic premise `no_nonzero_quadratic_vanishing`; projectively non-GRS conclusion uses the cited classical NRC/GRS dictionary |
| comp-q11-extension-complex | q=11 exact simultaneous-extension complex | independence polynomial `1+12t+36t²+20t³`; no maximal 0/1-extension, exactly six maximal 2-extensions and twenty maximal 3-extensions, no 4-extension; all 26 maximal sets are certified ordinary complete arcs, giving six complete eight-arcs and twenty complete nine-arcs over the fixed seed | arcs | paper Proposition `prop:q11-extensions`; lean `RelativeConicArcs/Q11Coding.lean` `extension_independence_spectrum`, `maximal_extension_spectrum`, `maximal_independent_extension_complete` |
| comp-q11-chord-decomposition | q=11 coloured icosahedral chord decomposition | each witness gives a five-edge matching missing an antipodal pair; six disjoint colour classes partition all 30 conflict edges; the six missing antipodal edges are distinct and augment the classes to a one-factorization | arcs | paper Proposition `prop:q11-extensions`; Lean `RelativeConicArcs/Q11Coding.lean` `witness_chords_nearPerfect`, `witness_chords_miss_antipodes`, `witness_chords_partition`, `completed_witness_matchings_oneFactorization`. This is not cited by the current Clebsch manuscript |
| comp-q9-terminal   | q=9 terminal six-point P-position        | the witness is an ordinary complete arc; its legal-extension set is empty, hence the actual projective position is P | nofil | Lean `RelativeConicArcs/Q9Terminal.lean` `complete`, `legalExtensions_eq_empty`, `isP`. The input fact is classical (Storme–Van Maldeghem 1995, Prop. 13), so `nofil` cites SVM, not `arcs`. The Clebsch lane retains an independent checker-only deep-hole reading (`comp-q9-exclusion`), but the current Clebsch manuscript does not use it |
| comp-q11-icosahedral | q=11 icosahedral seeded P-position     | all 12 conic points live; every seeded continuation is exactly an independent set of the icosahedral graph; the actual projective seed is P by antipodal mirror and exact localization | nofil (the icosahedral identification itself is `arcs`') | Lean `RelativeConicArcs/Q11Residual.lean` `continuation_rawArc_iff` and `RelativeConicArcs/Q11ResidualGame.lean` `isP`, `seed_isP`. The underlying graph identification `adj_iff_icosahedron` is `arcs`' (paper Proposition `prop:q11-extensions`); it is not part of the current Clebsch manuscript. `nofil` owns only the P-position reading |
| thm-clebsch-deep-holes | Deep holes of the Clebsch hexagon code are exactly a conic | projectively non-GRS `[6,3,4]₁₁` code of covering radius three; the fifteen secants cover all of `PG(2,11)` except the twelve points of the `A₅`-invariant conic `XZ=Y²`, so the complete deep-hole set *is* `𝒞(𝔽₁₁)`; affine count `120=12×10`, each deep-hole coset has `C(6,3)=20` leaders. Dye/BSW give the classical inclusion `𝒞⊂U`; equality is an apparently unrecorded synthesis with Dye's ten concurrences and the chord-defect count. **Owned for publication by `arcs`**, which holds the shared Lean certificate and ships first; `clebsch` gives a self-contained conceptual reproof as setup and claims no priority for the identification | arcs (clebsch restates) | `arcs` paper Proposition 8.2(i) + Lean `RelativeConicArcs/Q11Coding.lean`; restated at `clebsch` paper §3 Prop 3.2 + Cor 3.3 via the `A₅` orbit ledger, Dye/BSW, and the DMP dictionary |
| comp-clebsch-a5-point-orbits | Full `A₅` point-orbit profile in `PG(2,11)` | the Clebsch stabilizer has orbit lengths `[6,10,12,15,30,30,30]`; the first four are the arc, Brianchon points, associated conic, and self-polar-triangle vertices. The subgroup/fixed-line ledger derives uniqueness of the twelve-orbit and conceptually forces the deep-hole conic | clebsch | paper §3 Prop `prop:a5-point-orbits`; Dye 1991 identifies the classical orbits; concrete sixty-element action and all seven blocks in `Q11A5PointOrbits.lean` |
| thm-clebsch-rigidity | Conceptual rigidity theorem | for a six-arc `A⊂PG(2,11)`: `U(A)` lies on some conic ⟺ `U(A)` is all `𝔽₁₁`-points of a nonsingular conic ⟺ `A` is `PGL(3,11)`-equivalent to the Clebsch hexagon ⟺ `Stab(A)⊇A₅`. `A₅` is recovered from a coding-theoretic hypothesis, not assumed. The separate gap theorem states that `#U(A)≤15` characterizes this class and its exact value is `12` | clebsch | Paper I §4; the rigidity implication is conceptual via the six-arc line bound, chord defect, and Dye's equality classification. The 1548-representative census belongs only to the numerical gap. Lean inputs: `SixArcDefectBridge.lean`, `Q11DyeAxioms.lean`, and `Q11DyeConsequences.lean`, with Dye's bound and equality case as the two declared axioms |
| thm-clebsch-gap     | Gap theorem (rigid, not merely stable)   | every non-Clebsch six-arc has `#U≥16` with `U` on no conic; each of the 252 single-point perturbations of the hexagon has symmetric difference `#(U Δ 𝒞) ≥ 18` (exact spectrum `{18,19,20,22,24}`), so at most seven of the twelve conic points survive; distance-to-phenomenon jumps `0 → ≥18` with nothing between | clebsch | paper §4 Thm 4.7; `check_global_conic_gap.py` and `check_perturbation_gap.py` cover the global and 252-neighbour claims. These finite gap censuses are replayed, not Lean-formalized |
| comp-clebsch-low-degree-loci | Low-degree rigidity and quartic sharpness | a nonzero form of degree at most three contains `U(A)` exactly for the Clebsch class; there the minimum degree is two, the quadratic kernel is the conic equation, and the cubic kernel is that equation times the linear forms. One non-Clebsch class has an 18-point uncovered locus equal to the rational zero set of a quartic, showing degree four is sharp; no smoothness, irreducibility, or genus claim is made | clebsch | Paper I §4 Prop. 4.4 and the following sharpness remark; `check_low_degree_loci.py`. The fallback-only Singular wrapper and archived quintic/sextic computations are not Paper I dependencies |
| comp-clebsch-u-spectrum | Six-arc extension-count spectrum in `PG(2,11)` | `#U(A) ∈ {12,16,18,19,20,21,22}` with frame-normalized multiplicities `{6,30,150,300,630,360,72}` (Σ=1548); `#U=12` is attained by exactly one `PGL(3,11)` orbit (multiplicity `6=360/60`, consistent with `#Aut=60`) | clebsch | **priority granted outright to Hirschfeld–Sadeh 1984 / Sadeh thesis — recomputed here, claimed by us for neither the numbers nor the classification**; ours is only the deep-hole/covering *reading* of `U`. paper §4; verified by two independent code paths |
| thm-clebsch-chirality | Invariant support bipartition of deep-hole leaders | the twenty support triples split into two complementary `A₅`-orbits of ten. Only the unordered bipartition is intrinsic: the outside `S₅` normalizer coset exchanges its parts, while code automorphisms preserve them. Each deep-hole coset has ten leaders in each class, globally `1200+1200`; complementary support pairs are canonically the ten Brianchon points | clebsch | paper §5 Props 5.1 and 5.3; `check_chirality.py`, `check_code_automorphisms.py`, and `check_decoding.py`; kernel-checked finite synthesis in `Q11DecodingSynthesis.lean` |
| thm-clebsch-decoding | Complete distance oracle and ambiguity geometry | for syndrome `s`, distance is 0 at zero, 1 on an arc-column ray, 3 exactly when `s≠0` and `s₀s₂-s₁²=0`, and 2 otherwise; nearest-word multiplicities are `1^960 2^150 3^100 20^120`. The ten Brianchon points and five triangles are classical (Edge/Dye); the new layer reconstructs them from decoder ambiguity and identifies their supports with the complementary matchings; every deep hole has all twenty triple supports | clebsch | paper §3 Prop 3.5 and §5 Cor 5.2; `check_decoding.py`; kernel-checked synthesis in `Q11DecodingSynthesis.lean` |
| thm-clebsch-why11   | Classification-free uniqueness of `q=11` for six-arcs | the chord-defect identity and universal matching bound `c≤15` reduce a conic-filling six-arc to `q∈{4,5,9,11}`; hyperoval completeness excludes q=4, every six-cap is maximal at q=5, and the exact-distance-two Sylvester graph has clique number five at q=9, leaving q=11 | clebsch | paper §6 Thm 6.2; `check_small_q_uniqueness.py` and an independent q=9 construction; kernel-checked support in `ClebschChordDefect.lean` and `Q9Sylvester.lean` |
| thm-clebsch-family-uncovered | All-field uncovered formula for Clebsch hexagons | every finite-field Clebsch hexagon has `#U=q²−14q+45`; for `q≡3 (mod 4)`, Dye's associated conic lies in `U` with exact off-conic excess `(q−4)(q−11)`, so exact conic filling is isolated at q=11 | clebsch | paper §6 Prop 6.3; hand proof from the chord-defect identity and Dye's ten Brianchon points/non-secant criterion. The `q=19` instance is independently replayed by `check_q19_nonexample.py`; the family specialization itself is not claimed as Lean-formalized |
| thm-clebsch-reflection-arrangements | Paired `A₃/H₃` organization of the two conic-filling exceptions | the q=5 frame joins are the reduced `A₃` mirrors; an exact projectivity identifies the q=11 Clebsch secants with the reduced `H₃` mirrors; their intersection spectra give complement counts `(q−2)(q−3)` and `(q−5)(q−9)` and transport pointwise to the Clebsch secant-index strata | clebsch-factorization | assigned to Paper II by C575; preserved fallback §7 contains the earlier integrated statement. Evidence: `check_reflection_arrangements.py` and `RelativeConicArcs/ReflectionArrangements.lean` |
| thm-rank3-reflection-complement-code | Uniform rank-three Coxeter complement-code phase | for `T=A3,B3,H3` with Coxeter number `h`, the mirror-complement code has parameters `[(q-h/2)(q-h+1),3,(q-h/2-1)(q-h+1)]`; at `q=h+1` it is the full-conic extended GRS code; the exact maximum nonmirror intersection is `q-h+1` | clebsch-factorization | Paper II input; note `2026-07-20-c399-coxeter-number-conic-phase.md`, exact Python/JSON/checksum replay, and green dedicated/umbrella Lean gates. Edge/Dye own the individual small-field configurations and marker counts; see `2026-07-20-c399-literature-audit.md` |
| thm-conic-filling-kle7 | Conic-filling extension loci for `4≤k≤7` | if a `k`-arc has uncovered locus equal to all rational points of a nonsingular conic, then `(k,q)` is exactly `(4,5)` or `(6,11)`; the former is the projective frame and the latter the Clebsch hexagon. Exact chord moments rule out k=5 and reduce k=7 to q=11,13; exhaustive normalized searches find no seven-arc hit in either field | clebsch | paper §6 Thm 6.6; `check_small_k_conic_filling.py`; universal projective moments in `SmallKChordMoments.lean` and `SmallKGeometricBridge.lean`; finite seven-arc exclusions remain checker-certified. The elementary `(4,5)` instance is priority-neutral; downstream consumers are C188 (`relconic`) and C189 (`cap`/Nofil) |
| comp-q9-exclusion   | `q=9` icosahedral six-arc is complete    | `#U=0` at `q=9`: the analogous `A₅`-invariant six-arc has covering radius two, so its deep-hole locus is empty and the phenomenon is vacuous | clebsch side computation | `check_q9_exclusion.py` independently re-verifies SVM 1995 Prop. 13 over the Lean-certified GF(9) tables. This checker-only side result is not a claim or dependency of the current manuscript, whose `q=9` exclusion instead uses the Sylvester graph |
| comp-q19-nonexample | `q=19` icosahedral six-arc has exactly 140 deep holes | the recipe still yields a genuine six-arc disjoint from the conic — at `q=19`, `5∣q+1` so order-five elements are non-split and fix *no* rational conic point, but their `𝔽₃₆₁`-conjugate fixed pairs span Galois-stable rational chords, hence rational poles. The Clebsch-family formula gives `#U=140=20+120` and Dye's edge criterion gives the conic inclusion; the checker independently reconstructs the arc, count, and full quadratic rank | clebsch | paper §6 Remark 6.4 following Prop 6.3; Dye 1991 pp. 281–282; `check_q19_nonexample.py` is independent verification |
| comp-clebsch-dual   | The dual code is again a Clebsch hexagon code | dual arc `B={(1,5,5),(1,4,9),(1,9,3),(1,0,0),(0,1,0),(0,0,1)}`: a genuine six-arc meeting `𝒞` in two points, with `#U(B)=12` lying on a second nonsingular conic; rigidity makes `B` projectively equivalent to `A`, though not coordinate-for-coordinate | clebsch side computation | `check_dual_code.py`; deliberately omitted from the current manuscript |
| comp-clebsch-mathieu | The two icosahedral hexads are transverse to `S(5,6,12)` | the six fixed-point chords partition the conic's twelve points into complementary hexads, neither among the 132 Mathieu hexads; both have intersection histogram `{1:6,2:30,3:60,4:30,5:6}` with the Steiner blocks | clebsch side computation | `check_mathieu_hexads.py`; deliberately omitted from the current manuscript |
| comp-clebsch-ten-arc-foil | Ten-arc foil: same `A₅`, empty deep holes | the unique size-ten orbit in the Clebsch stabilizer's point action is a ten-arc with empty uncovered locus, showing that conic filling is not forced by icosahedral symmetry alone | clebsch side computation | `check_ten_arc_foil.py`; deliberately omitted from the current manuscript |
| thm-baer-criterion  | Orbit-valued extension criterion         | plausibly unrecorded assembled quadratic-Frobenius criterion; exact coordinate theorem constructs an arc extension; heterogeneous support count specializes to uniform `E(N−M)` | paper-frob-eq | lean `FiniteGeom/BaerCompletion/PairExtension.lean` `PairExtensionData.sum_card_sub_le_legalCount`; `RelativeConicArcs/QuadraticForbidden.lean` `exists_quadratic_pair_extension`; novelty audit `notes/2026-07-13-baer-completion-adversarial-novelty-review.md` |
| comp-baer-clebsch-pairs | Clebsch quadratic pair-extension count | viewing the `F_11`-rational Clebsch hexagon in `PG(2,121)` gives exactly `76·55=4180` legal nonfixed Frobenius-pair extensions and `4179` alternate repairs after deletion of a selected pair; equivalently, `4180` paired extensions to `[8,5,4]_121` MDS codes | paper-frob-eq | manuscript Corollary `cor:clebsch-pair-extension`, derived from the semantic carrier count at `(s,f,e)=(11,6,0)`; manuscript-level arithmetic, not a separate Lean terminal; the count holds for every rational six-arc |
| lem-baer-linewise-correction | Exact carrier correction          | subtraction-free `legal(ℓ)+M=N+B_ℓ+Σ_q(μ_ℓ(q)−1)` separates invisible orbit mass from collision redundancy, linewise and in aggregate | paper-frob-eq | lean `FiniteGeom/BaerCompletion/CollisionProfile.lean`, `RelativeConicArcs/QuadraticCollision.lean`, `RelativeConicArcs/QuadraticInvisible.lean`; paper Theorem B.1; fixed-center interpretation kernel-checked |
| thm-baer-all-orders | Uniform pair extension from base order five | for every prime power `s≥5`, every Frobenius-invariant eight-arc in `PG(2,s²)` admits a fresh conjugate-pair extension | paper-frob-eq | paper Corollary `cor:all-orders`; combines the kernel-checked order-five theorem with the generic `s≥7` criterion and the absence of an intervening prime-power order |
| thm-baer-saturation | Quadratic orbit-saturation bound         | denominator-free `2s(s−1) ≤ (k−1)²`; classical Lunelli–Sce/line-covering square-root scale under the weaker no-pair-extension hypothesis | paper-frob-eq | lean `FiniteGeom/BaerCompletion/OrbitSaturation.lean` `orbitSaturation_quadratic_bound_of_split` |
| thm-completion-tau  | δ(C) = τ                                 | standard conflict/correction-set hitting-set duality, formalized semantically for every finite hereditary system | completion (library-only) | lean `FiniteGeom/BaerCompletion/Obstruction.lean` `insertionDistance_eq_transversalNumber` |
| lem-completion-clutter | Minimal-obstruction reduction        | classical clutter reduction: removing nonminimal dependent traces preserves every transversal and `τ` | completion (library-only) | lean `FiniteGeom/BaerCompletion/Clutter.lean` `transversalNumber_minimalEdges` |
| thm-completion-weighted | Weighted completion identity        | standard weighted-hitting-set specialization, kernel-checked for arbitrary nonnegative deletion costs | completion (library-only) | lean `FiniteGeom/BaerCompletion/Weighted.lean` `weightedInsertionDistance_eq_weightedTransversalCostWithin` |
| thm-completion-multi | Multi-insertion identity               | standard prescribed-set correction/hitting-set schema, exposed as a checked API | completion (library-only) | lean `FiniteGeom/BaerCompletion/MultiInsertion.lean` `multiInsertionDistance_eq_transversalNumber` |
| thm-completion-weighted-multi | Weighted multi-insertion      | prescribed-set representation with standard nonnegative vertex weights | completion (library-only) | lean `FiniteGeom/BaerCompletion/Weighted.lean` `weightedMultiInsertionDistance_eq_weightedTransversalCostWithin` |
| thm-secant-resilience | Arc insertion distance               | classical secant-deletion/point-index fact, formalized in every finite abstract projective plane | completion (library-only) | lean `RelativeConicArcs/CompletionDistance.lean` `arcInsertionDistance_eq_pointIndex` |
| thm-baer-involution | Fixed/conjugate secant decomposition    | elementary involution-orbit decomposition, abstractly formalized for reuse | paper-frob-eq | lean `FiniteGeom/BaerCompletion/BaerPlane.lean`; `RelativeConicArcs/BaerIncidence.lean` |
| thm-baer-frobenius | Coordinate quadratic Frobenius           | classical semilinear/Hilbert-90 infrastructure and exact `(s²−s)/2` linewise candidate count, formalized for the criterion | paper-frob-eq | lean `RelativeConicArcs/QuadraticFrobenius.lean`; `RelativeConicArcs/QuadraticPairExtension.lean` |
| lem-baer-input-reduction | Quadratic count-input reduction   | proof infrastructure: exact count fields reduce to a 2-fiber map, complement, and injective charge | paper-frob-eq | lean `FiniteGeom/BaerCompletion/OrbitCounting.lean` |
| thm-baer-line-counts | Exact fixed-line occupation          | paper-specific bookkeeping assembly from classical incidence counts, with nontruncating subtraction | paper-frob-eq | lean `RelativeConicArcs/QuadraticLineCounting.lean` `card_occupiedFixedLines`, `card_emptyFixedLines`, `choose_fixedArcPoints_le_star` |
| thm-baer-forbidden | Exact forbidden-candidate charging       | core mechanism of the assembled criterion: injective support-to-orbit charge, semantic coverage equivalence, and legal arc union | paper-frob-eq | lean `RelativeConicArcs/QuadraticForbidden.lean` `card_nonfixedSecantOrbits`, `card_forbiddenCandidates_le_baer`, `arc_union_candidate_of_not_mem_forbidden` |
| lem-baer-arithmetic | Quadratic Baer arithmetic                | elementary paper-support arithmetic: `M=fe+e(e−1)`, eight-arc `M≤12`, candidate surplus, and occupied-line identity | paper-frob-eq | lean `RelativeConicArcs/BaerArithmetic.lean` |
| thm-completion-robust | Robust obstruction persistence        | standard transversal monotonicity: below-`τ` deletion cannot unblock and persistence of old obstructions preserves the lower bound | completion (library-only) | lean `FiniteGeom/BaerCompletion/RobustHole.lean` `not_insertion_indep_of_obstructions_persist` |
| thm-completion-core | Sharp completion-core radius            | standard defining-set/facet-separation lemma, conditional on an alternative-facet witness | completion (library-only) | lean `FiniteGeom/BaerCompletion/Core.lean` `completionCore_sdiff_eq`, `completionCore_delete_difference_eq_intersection` |
| lem-nu-tau          | ν ≤ τ                                    | matching ≤ transversal (hypergraph base)           | completion (base)   | lean `FiniteGeom/Hypergraph.lean:53` `matching_card_le_transversal_card` |
| thm-frame-rigidity  | Frame-graph semilinear rigidity (N1)     | Aut = ambient semilinear group, q ≥ 13             | continuation        | note (Thm 7.4) [plan] |
| thm-complex-recon   | Continuation-complex reconstruction (N2) | recovers plane + secants + arc                     | continuation        | note (Thm 8.4) [plan; SOFTEN] |
| lem-transfer        | Complete repair-hypergraph transfer      | exact blockwise preservation when `r+1<2d(I⊥)` and the outer functional-dual gate holds; every exact locality `s≤r` is preserved | coding | lean `RepairCodes/SeedLift.lean` `repairHypergraph_concatenatedCode_eq_embed`, `hasExactLocalityAt_concatenatedCode_iff_of_le` |
| comp-clebsch-complete-port | Positive-density Clebsch coefficient port | the Clebsch `[6,3,4]_11` code has full pointed confinement cost `z_x=8`; its radius-five coefficient port reconstructs the inner code and occurs with density `1/6` in an asymptotically good fixed-`F_11` family; the minimal support clutter is the generic complete three-uniform hypergraph on five helpers with `(ν,τ)=(1,3)` | coding | complete-ports Corollary `cor:clebsch-port` and proof-ledger row T9c; manuscript-derived from dual MDS parameters and the prescribed-port theorem, not a separate Lean terminal |
| thm-transfer-boundary | Uniform boundary of both transfer gates | nondegenerate `GF(3)` examples give literal complete-hypergraph failure at `r+1=2d(I⊥)` and at outer functional-dual distance `r+1`; no fixed-code necessity claim | coding | paper Proposition `prop:transfer-boundary`; lean `RepairCodes/TransferBoundary.lean` `innerDualDistanceGate_boundary_counterexample`, `outerFunctionalDualDistanceGate_boundary_counterexample` |
| thm-gf9-seed10      | GF9 seed `[10,4,6]₉`                     | exact minimum distance 6 and dual distance 4; formal-library result, not used in the manuscript | coding (library-only) | lean `RepairCodes/Q9Seed.lean` `q9InnerCode_minDist`, `q9InnerCode_dualDist` |
| thm-axis-uniform-code | Uniform axis–twisted-cubic code       | `[2q+1,4,q−1]₍q₎` in finite characteristic three  | coding    | lean `FiniteGeom/AxisTwistedCubic.lean` `axisTwistedCubic_code_parameters` |
| thm-axis-cubic-row | Exact cubic-coordinate repair row | every cubic coordinate has `(ν,τ)=((q−1)/2,q−2)` over every finite characteristic-three field | coding | paper §4; lean `RepairCodes/AxisTwistedCubicInvariants.lean` `cubicRepair_matchingNumber`, `cubicRepair_transversalNumber`; rainbow core `FiniteGeom/ExplicitRainbowMatching.lean` |
| thm-axis-q9-table   | Exact q9 all-symbol repair table         | `[19,4,8]₉`; rows `(ν,τ)=(4,7),(6,12),(7,13)`; repair counts `28`, `36+8`, `36+12` | coding | lean `RepairCodes/Q9Uniform.lean` `axisTwistedCubic_q9_row_invariants`, `cubicRepair_edge_count_q9`, `axisRepair_component_edge_counts_q9` |
| thm-axis-q9-circuits | Exact q9 small-circuit inventory       | 120 axis three-circuit supports and 84 completed cubic four-circuit supports | coding | lean `RepairCodes/Q9CircuitInventory.lean` `q9_smallCircuit_support_counts` |
| thm-axis-uniform-repair | Uniform all-symbol separation       | exact axis formulas, exact cubic row, and `τ>ν` at every coordinate for `q≥9` | coding | lean `RepairCodes/AxisTwistedCubicInvariants.lean` `minimalAxisRepair_nucleus_invariants`, `minimalAxisRepair_finite_invariants`, `cubicRepair_matchingNumber`, `axisTwistedCubic_allSymbol_tau_gt_nu` |
| thm-repair-coefficients | Coefficient-labelled scalar repairs | every repair witness yields an exact scalar recovery equation; three completed-seed repair shapes have explicit nonzero coefficients, while a monomial rescaling theorem rules out invariant coefficient-cost claims | coding | lean `RepairCodes/OperationalCoefficients.lean` `repair_edge_has_scalar_recovery_equation`, `projectiveAxisPair_arbitrary_helperCoefficient`, and the three coefficient-relation theorems |
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
