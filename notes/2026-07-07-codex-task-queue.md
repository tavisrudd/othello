# Codex task queue — live registry

> **LIVE MAP ONLY. DO NOT APPEND RESULTS, SESSION LOGS, REVIEW TRANSCRIPTS, OR
> SUPERSEDED PLANS HERE.** A task row is one line. Put full task bodies and completed work in
> `2026-07-07-codex-task-queue-archive.md` and findings in
> the linked dated report.

**Allocate every ID with the script, never by reading this file.** Run
`python3 notes/scripts/allocate_codex_task_ids.py reserve --count N --lane <alias> --purpose '<bounded purpose>'`
from the repository root, commit the updated `codex-task-id-allocations.json` ledger before using the
returned IDs, and lane-peg each row at allocation. Never derive an ID from repository text, treat
`peek` as an allocation, or reuse or renumber an ID; `notes/scripts/next_codex_task_id.py` is for
auditing only. This file records no maximum allocated ID — the ledger is the sole authority.

**This queue is an allocation and open-work index, not a completion ledger.** It carries no
`[REPORTED]` rows and no other completed-task rows, and a live row is never transitioned to
`[REPORTED]` even temporarily. On completion, append the row to the companion archive first, then
delete it from here; an unarchived row is a blocker to deletion, not a reason to leave history in
this file.

The user selects a lane; this queue never selects one globally, and the selected lane's handoff owns
ordering and detail.

## Open tasks by lane

### `alt-orbit-repair`

- **C152 `[alt-orbit-repair]` [QUEUED]** — quadratic-Frobenius replacement graph and component census → `notes/2026-07-14-c152-orbit-replacement-graph.md`.
- **C318 `[alt-orbit-repair]` [QUEUED]** — add the Q25 residual layer to the arcs trust manifest: theorem-map rows for the orbit/classification theorems, the residual `*Data/` trees with their scale and consuming checker, and the trusted-surface statement distinguishing generic-predicate leaves from bespoke per-row leaves → `notes/2026-07-18-c151-certificate-portfolio-fable-review.md`.
- **C319 `[alt-orbit-repair]` [QUEUED; C151 cost now measured at 1:57:09 serial]** — decide whether to replace the literal canonical-class links with a verified canonicalizer, or to demote the exact Q25 classification to a Lean-checked reduction plus reproducible computation → `notes/2026-07-18-c151-certificate-portfolio-fable-review.md`.

### `build-sys`

- **C162 `[build-sys]` [ACTIVE]** — quiet resource/profile/tmpfs orchestration, import blast radius, and restart-guard failure tests landed; next real lightweight gate, restart cycle on disposable state, stable-checker boundaries, and artifact isolation → `notes/2026-07-14-c162-lean-build-system.md`.
- **C326 `[build-sys]` [IN PROGRESS; exporter landed and self-validated, project extraction awaits a quiet Lean worktree]** — implement a declared-intent/Lean-facts trust spine with a global orphan inventory, exact per-terminal axiom checks, generated trust-document regions, strict data provenance, and canonical theorem/module/data dependency-graph JSON with filtered Mermaid/DOT renderers; all checks are read-only and adversarially tested → plan `notes/2026-07-18-c326-trust-spine-and-dependency-graph-plan.md`, Phase A report `notes/2026-07-18-c326-trust-spine-phase-a.md`, exporter report `notes/2026-07-18-c326-lean-fact-exporter.md`.
- **C328 `[build-sys]` [GATED; after C326 stabilizes node IDs and the evidence-extension schema]** — operationalize the trust graph's evidence overlay for novelty assessment: freeze bounded status vocabulary and immutable/superseding assessment records, validate literature-search scope/evidence/freshness metadata, add query and renderer badges, and populate a RelativeConicArcs pilot; portfolio judgments remain with their owning lanes; the read-depth vocabulary and coverage outcomes it validates are owned by `notes/literature-audit-conventions.md` and change together with it → `notes/2026-07-18-c326-trust-spine-and-dependency-graph-plan.md` § Evidence-extension boundary.
- **C324 `[build-sys]` [QUEUED; before C287 extraction]** — one clean regeneration pass per paper on the pinned toolchain, confirming each frozen artifact still reproduces byte-identically; recorded hashes prove identity, not that the generator still reproduces the artifact. Record the outcome per manifest → `notes/2026-07-18-c151-certificate-portfolio-fable-review.md`.
- **C287 `[build-sys]` [IN PROGRESS; A1/B1 approved, blocked on C553 source rewrite and four facts]** — export a reviewer-scale human union into `~/src/lean/finitegeom` under the 100-file/25k-line first-tag gate, keep heavyweight Q16, Q25, and ProjectiveCap Q11/Q13 generated closures in separate opt-in one-way-dependent certificate packages, validate public gates, and prove guarded artifact restore semantics → `notes/2026-07-17-c287-shared-lean-extraction-plan.md`.
### `cap`

Rows are ordered by expected value toward the odd-q all-P crown; the cap handoff's Near-Term Queue is
the ordering authority and carries the rationale. C80 is the spine (everything gates on it); its
current highest-EV step is a variable-depth P-preserving descent into `Y_NK`; the former bounded-depth
target is closed-negative by `notes/2026-07-24-c80-capok-depth-obstruction.md`.

- **C553 `[cap]` [QUEUED; C287 source-owner dependency; A1/B1 APPROVED]** — rewrite the 17 first-tag modules for referee-facing public prose, delete `ProjectiveCap.Almost.OddEscape` and `ProjectiveCap.StableFacts`, migrate every consumer to the canonical `GridGame`/`ExtensionCount` APIs without compatibility aliases, and complete the semantic declaration/docstring gate → `notes/2026-07-24-c287-source-owner-rewrite-packet.md`.

- **C80 `[cap]` [ACTIVE; HIGHEST-EV SPINE; next step = prove or falsify a q-uniform positive retention-strength bound from opponent-marked secant algebra]** — prove bulk descent into a proven-P packet, then release the count to C82. `Y_NK` is the overload-zero static Node-Kayles guard, `Ω` is the exact monotone absorption coordinate, and `K_Ω` is the maximal strict-overload survivor family. Fixed-depth absorption is impossible beyond the twelve-cap ceiling (`q≥67`), and `Rmax` plus both overload-vector extremes are now closed-negative as uniform routes. The first scale-aware family is the nested boundary-or-retention kernel `F_α⊆K_Ω`: always admit `Y_NK`, otherwise retain at least an `α` fraction of the maximum available positive target overload. Exact Bellman replay gives minimum retention strength `1` at q11/q13 and `20/51` at q17, so `F_{1/4}` contains every tested kernel escape root; the q19 root passes 25%, 40%, 50%, and 75% but fails 90%. Unmarked overload data remain kernel-membership-mixed (48/57 scalar signatures, 120/690 full load profiles), so the live theorem must use the original conic/frame and opponent--reply secant data. The finite corpus still has at most one consecutive positive-target exchange and does not enter the forced `sqrt(q)`-depth regime; no q-independent positive lower bound is proved. Do not run another bounded-depth selector, stabilizer, gadget, terminal-guard, or unmarked-potential probe. C82 remains gated. Reports → `notes/2026-07-24-c80-scale-survivor-falsifiers.md`, `notes/2026-07-24-c80-marked-head-and-bulk-audit.md`, `notes/2026-07-24-c80-strict-overload-kernel.md`.
- **C82 `[cap]` [GATED on C80]** — orbital counting for the exact packet C80 produces; C520 offers a Weil-bound route → `notes/2026-07-12-c82-orbital-counting.md`.
- **C520 `[cap]` [GATED on C80; C496 successor; feeds C82]** — generalize the C496 q=11 coupling to all odd q: exhibit the incidence-live locus as a bounded-degree algebraic family in `u`; test whether the live-pair resolvent-quadratic discriminant's square class predicts the depletion sequence `{11,17}` (tt #1), and whether a Weil bound on the value character sum `Σ_live (1−χ(u))/2` gives uniform odd-q abundance for C82 (tt #3). The first moment `Σ_live χ` is `C2`-symmetry-forced (not a diagnostic; tt #4) — use a `C2`-invariant higher moment. Also state the coupling as the sign-isotypic Hecke bimodule (tt #2). The resolvent-depletion half (tt #1) is testable now on frozen q=13/17/19 A5-anchor data, ahead of the C80 gate → `notes/2026-07-23-c496-bihecke-two-sort-coupling.md`.
- **C74 `[cap]` [ACTIVE]** — prove maximum-pencil balanced-packet P existence / `Ncenters <= q-8`; characteristic-5/7 exceptions remain.
- **C77 `[cap]` [OPEN GAME-SEMANTIC TAIL]** — algebraic forced-reply closure for the C74 packet → `notes/2026-07-11-c77-game-semantic-reply-graphs.md`.
- **C81 `[cap]` [OPEN; independent]** — characteristic-5/7 subfield descent gate → `notes/2026-07-12-c81-subfield-descent-gate.md`.
- **C13 `[cap]` [OPEN]** — q=9 intrusion structure / Lean target → `notes/2026-07-07-codex-q9-intrusion-probe.md`.
- **C508 `[cap]` [QUEUED; DEPRIORITIZED — low upside after the C495/C497 negatives; diagnostic, not descent]** — consume C497's exact reply-type balance and test the bounded projective-plane correlation/polarity candidates on the full 17,954-state marked `Y_0` census: require an explicit involutive pairing that swaps 0/2-fixed reply types and preserves `Y_NK0`, then a minimal full-state anchor whose stabilizer class detects the swap. Even a positive is symmetry/case-reduction only unless it improves C80's sparse guard or a descent measure — revisit only then → `notes/2026-07-22-c508-q17-external-c2-local-detector.md`.
- **C189 `[cap]` [QUEUED]** — q=5 octahedral-frame game bridge → `notes/2026-07-15-c189-q5-octahedral-frame.md`.
- **C198 `[cap]` [QUEUED]** — bounded q=7 BSW exterior-four-arc residual scout → `notes/2026-07-15-c198-q7-exterior-residual-scout.md`.
- **C199 `[cap]` [QUEUED]** — extract direct strategies from the Schreier catalogue → `notes/2026-07-15-expert-questions-upgrade-portfolio.md`.
- **C200 `[cap]` [QUEUED]** — recognize Schreier graph families structurally → `notes/2026-07-15-expert-questions-upgrade-portfolio.md`.
- **C30 `[cap]` [OPEN ENGINEERING TAIL; USER GATE]** — reduce or explicitly launch the q17/q19 generated-certificate assembly (advances trust, not the kernel; ~10h+ user-gated).

### `clebsch`

- **C576 `[clebsch]` [QUEUED; EV 2 — PAPER I MANUSCRIPT AFTER C575 GO]** — build and referee-test a roughly 19--21 page rigidity/decoder Paper I from the older coherent base, backporting only the approved auditability improvements and at most a compact `H_3` explanation → `notes/2026-07-24-clebsch-paper-split-trial.md`.
- **C320 `[clebsch]` [QUEUED; EV 3 — PAPER I RELEASE CAPSTONE AFTER C576]** — remap the existing claim-by-claim trust ledger, adequacy extraction, pinned gates, and verify-all entry point to Paper I first; preserve the broad fallback ledger separately, interpose C321 only if the Paper I inventory triggers it, and require issue fixes, post-fix review, and final `GO` → `notes/2026-07-20-c320-clebsch-trust-ledger.md`.
- **C321 `[clebsch]` [CONDITIONAL PAPER I SUBTASK; ONLY IF C320 TRIGGERS IT]** — replace any load-bearing Singular evidence retained by Paper I with independently specified exact certificates/checkers and canonical replay bundles; otherwise close it as not triggered → `notes/2026-07-20-c321-clebsch-singular-certificates.md`.
- **C182 `[clebsch]` [QUEUED; EV 4 — PAPER I ARCHIVE/RELEASE AFTER C320 FINAL GO]** — archive the focused Paper I source, PDF, exact verification surface, tracked `flake.nix`/`flake.lock` pins for `finitegeom`, certificate packages, toolchain, and system dependencies under a stable DOI/release → `notes/2026-07-15-c182-clebsch-artifact-archive.md`.
- **C577 `[clebsch]` [QUEUED; EV 5 — PAPER II ONLY AFTER PAPER I IS SUBMISSION-READY]** — build and referee-test a standalone factorization-memory Paper II around the conic quotient, ranks, balanced sheets, cubic orientation, profiles, modular depth, and arithmetic gluing, while inventorying rather than importing possible Paper III material → `notes/2026-07-24-clebsch-paper-split-trial.md`.
- **C579 `[clebsch]` [QUEUED; EV 6 — EXPLORATORY PAPER III AFTER PAPER II]** — test whether the passage-survival, four-sheet holonomy, carrier-torsor, theta/Fourier/quantum, Mathieu, and characteristic-zero results form one standalone theorem complex, then either build the `clebsch-passages` candidate or return the material to an inventory → `notes/2026-07-24-clebsch-paper-split-trial.md`.
- **C552 `[clebsch]` [FALLBACK-ONLY; NO ACTIVE WORK UNLESS THE BROAD MANUSCRIPT IS REVIVED]** — preserve the implemented linear-sheaf/cycle-holonomy repair, `96/192` relative-frame proof, exceptional-prime explanation, and corrected degree-six action wording for the unchanged broad fallback; do not place it on the Paper I release path → `notes/2026-07-23-c552-c550-manuscript-integration.md`.

### `complete-ports`

- **C325 `[complete-ports]` [QUEUED]** — one consolidated executable verifier reproducing every finite table from a versioned manifest, plus a per-theorem proof ledger naming its evidence mode (Lean / exact replay / conventional proof / external classical theorem / a stated combination); the risk here is the number of verification modes, not generated volume → `notes/2026-07-18-c151-certificate-portfolio-fable-review.md`.

### `continuation`

- **C271 `[continuation]` [QUEUED]** — N2-gate literature closure: obtain full texts of Drake–Sané and Metsch (LNM 1490) and run the MathSciNet/zbMATH forward-citation check, then record the outcome in the audit note (implements the audit's recorded residual diligence for the N2 SOFTEN verdict; does not re-decide N1 SURVIVES) → `notes/2026-07-11-continuation-rigidity-audit-scope.md`.
- **C273 `[continuation]` [QUEUED]** — build the `ContinuationRigidity` Lean library per the Phase 3 plan (implement, do not re-decide it); collaborator route is the recorded fallback if formalization stalls per the #7 gate → `notes/2026-07-17-c273-continuation-lean-library.md`.

### `crowns`

- **C206 `[crowns]` [PAUSED; explicit resume required]** — conceptual nearest-conic gap/stability, now absorbed from `clebsch-next`; it remains mathematically distinct but is not a submission dependency → `notes/2026-07-15-c206-clebsch-gap-stability.md`.
- **C207 `[crowns]` [GATED; lifecycle reconciliation only]** — reconcile the legacy intrinsic-chirality row against C373/C376; do not rerun the research → `notes/2026-07-20-clebsch-next-crowns-merge.md`.
- **C208 `[crowns]` [GATED; lifecycle reconciliation only]** — reconcile the legacy all-field orbit row against C400, retaining only a strictly stronger representation-theoretic remainder if one is stated → `notes/2026-07-20-clebsch-next-crowns-merge.md`.
- **C212 `[crowns]` [GATED; lifecycle reconciliation only]** — reconcile the legacy decoder-tomography row against C399/C403/C407/C373; no duplicate research execution → `notes/2026-07-20-clebsch-next-crowns-merge.md`.
- **C213 `[crowns]` [GATED; lifecycle reconciliation only]** — reconcile the legacy Clebsch-cubic incidence row against C376; no repeat incidence dictionary → `notes/2026-07-20-clebsch-next-crowns-merge.md`.
- **C386 `[crowns]` [QUEUED; canonical `O_10^-(2)` matching-code gate]** — map each of C379's 22 perfect matchings on twelve child points to its canonical maximal singular four-space in the ten-dimensional deleted permutation module; certify intersection code, full stabilizer, and intrinsic recovery, then stop unless the orthogonal configuration yields more than the known biplane/matching incidence → `notes/2026-07-19-c386-c387-c382-adjacent-mappings.md`.
- **C387 `[crowns]` [QUEUED; Clebsch--Bring/Bertini theta bridge]** — use Bring's curve, the invariant-quadric section of the Clebsch cubic, as the smooth `S5` theta control; test whether C381's norm-four lift with seven root decompositions has an intrinsic theta/tritangent avatar, and attempt a stable Bertini limit only after that exact compatibility passes → `notes/2026-07-19-c386-c387-c382-adjacent-mappings.md`.
- **C390 `[crowns]` [QUEUED; induced Bring bridge and free `E8`/Lagrangian upgrades]** — formalize C381's norm-four cap/pointed-Steiner normal form and the general recoverable matching--Lagrangian/intersection-cycle theorem; then test the mod-11 golden reduction of Bring's rulings and an `O_8^+(2)` triality explanation of the published theta-orbit triples, with full Dye/matching-code prior-art closure and hard stops on abstract-coset or classical-count restatements → `notes/2026-07-19-c390-clebsch-bring-e8-lagrangian-upgrades.md`.
- **C393 `[crowns]` [QUEUED; post-Clebsch Cayley--Kayles normalizer gate]** — classify and recognize normalizer-paired connected four-involution Cayley graphs in `PGL_2(q)`; extract the simultaneous Node--/Arc--Kayles zero certificate and decide whether matrix-group recognition yields a substantive tractable subclass beyond the standard graph-involution theorem, with a focused primary/forward audit and a mandatory stop on mere repackaging; do not evaluate the quadratic scar or resume C294 → `notes/2026-07-19-c393-cayley-kayles-normalizer-gate.md`.
- **C394 `[crowns]` [QUEUED; portable curve Schreier and finite-phase resource theorem]** — generalize C389 from `P1` to faithful finite automorphism groups of smooth projective curves, proving exact-degree free Cayley layers with multiplicities `|H|^-1 sum_(e|d) mu(d/e)#X(F_(q^e))` above the bounded fixed-point degree; then prove the consumer-independent finite normal-fan phase, support-function, convergence, and mixed-volume theorem for every Minkowski-additive convex resource functor, with a hard curve/higher-dimension boundary and optional bounded stabilizer-layer appendix → `notes/2026-07-20-c394-portable-exact-degree-curve-base-change.md`.
- **C366 `[crowns]` [QUEUED; priority 1/5, near-free flagship upgrade]** — compose C336, C337, and C364 into an end-to-end theorem from an unmarked layered code through intrinsic recovery to every-syndrome decoding, stopping if any unrecorded marking or oracle remains → `notes/2026-07-19-c366-c370-cross-finding-upgrades.md`.
- **C367 `[crowns]` [QUEUED; priority 2/5, bounded exact compatibility test]** — test whether C353's certified same-type/same-axis pair also shares any of C351's uncoloured residual graph, repair multigraph, or unmarked-code interfaces; a shared interface with unequal two-failure capacity is the target gem, while the exact negative closes the task → `notes/2026-07-19-c366-c370-cross-finding-upgrades.md`.
- **C352 `[crowns]` [GATED; EV18, symbolic k=3 multi-orbit gate]** — generalize C333 from two to `k>=3` mirror orbits only after a symbolic `k=3` positive-density legality/nonadjacency family and full-group proof; a pairing restatement or isolated census stops, and primary/forward-citation novelty closure must cover involution generating sets, higher-rank hypertopes/maniplexes, symmetric arcs/MDS families, repair alternatives, and Node--Kayles pairing families → `notes/2026-07-19-c352-multiorbit-mirror-families.md`.
- **C355 `[crowns]` [READY; EV10, integral oval scheduling]** — characterize the integer demand semigroup, IDP/holes, and sharp rounding of the coloured projection matchings; audit batch/PIR and matching-polytope normality first, then exhaust `T<=4` on C353's certified q=7 separating pair and continue only with a uniform mechanism or repeatable minimized obstruction → `notes/2026-07-18-c334-implied-crowns-portfolio.md`.
- **C359 `[crowns]` [GATED; EV17, twisted-cubic secant-design falsifier]** — seek a higher-dimensional resolvable-recovery MDS family only after RNC/Waring-rank/service literature closure and a `k=4`, `q=5,7,11` gate finds four independent targets with positive-density resolvable recoveries of size `<4` and a systematic-baseline gain; isolated targets or a bare census stop → `notes/2026-07-18-c334-implied-crowns-portfolio.md`.
- **C342 `[crowns]` [GATED; EV15, bounded spread-switch falsifier]** — seek a spread-breaking switch that turns C329 field reduction into a genuinely non-Desarguesian pseudo-arc/additive MDS family; ordinary Desarguesian field reduction is prior art and failure of the frozen switch gate closes the task → `notes/2026-07-18-c336-c348-arc-code-crowns-portfolio.md`.
- **C343 `[crowns]` [GATED; EV16, only if clebsch-next C213 passes]** — consume an exact C213 Clebsch-cubic incidence map, if one exists, and require a new code/deep-hole/decoder or `E6` reconstruction theorem; a cardinality or classical-configuration match closes negatively → `notes/2026-07-18-c336-c348-arc-code-crowns-portfolio.md`.
- **C344 `[crowns]` [GATED; EV17/HIGH-RISK literature plus small-field test]** — test C294/C333 four-involution configurations for a genuinely new rank-four non-polytopal hypertope or maniplex, proceeding beyond `q=7,11,23` only after exact intersection-property success and closure against rank-four `PSL₂/PGL₂` literature → `notes/2026-07-18-c336-c348-arc-code-crowns-portfolio.md`.
- **C296 `[crowns]` [GATED on substantive C294/C295 theorems]** — reconstruction-to-value synthesis: prove on a natural infinite class, or first on a sharply bounded Clebsch/frame pilot, that the continuation object reconstructs its algebraic geometry and that the reconstructed data determine the exact P/N or Grundy value → `notes/2026-07-17-c296-reconstruction-to-value-crown.md`.
- **C294 `[crowns]` [PAUSED BY USER 2026-07-18; preserve router, evidence, and frozen E3]** — full conic-continuation crown remains open but no B3 experiment, larger cap, or value search is authorized until the user explicitly resumes C294 → `notes/2026-07-17-c294-full-conic-continuation-crown.md`.
### `cubic`

- **C116 `[cubic]` [STARTED/DEFERRED]** — exact TO/RC/IC transversal spectra; resume with HiGHS → `notes/handoffs/2026-07-13-twisted-cubic-transversal-spectrum.md`.
- **C158 `[cubic]` [QUEUED]** — k=4 healthy search → lane handoff.
- **C204 `[cubic]` [QUEUED]** — N1 graph recognition/coherent-configuration gate → `notes/2026-07-15-expert-questions-upgrade-portfolio.md`.

### `dihedral`

- **C264 `[dihedral]` [READY UMBRELLA; execute C306–C311 in order]** — rebuild the paper on Fable's adopted universal-reduction/three-applications spine, then clear correctness integration, scholarly/trust apparatus, artifact reproducibility, adversarial review, and two cold-prose passes; close only after the full phase chain passes → `notes/2026-07-17-c264-dihedral-latex-adversarial-review.md`.
- **C307 `[dihedral]` [READY; C264 phase 2/6]** — correctness-first integration: land C281's value-affecting `t`-case split and integrate C284/C289/C290/C278/C283 plus the C281/C288 validation appendices and Dawson period-34 corollary → `notes/2026-07-17-c264-dihedral-latex-adversarial-review.md`.
- **C308 `[dihedral]` [QUEUED; after C307, C264 phase 3/6]** — scholarly apparatus and trust boundary: apply C261 R1–R5; finish citations, novelty calibration, provenance, evidence/replay map, Lean adequacy statement, and exact title/abstract exclusions → `notes/2026-07-17-c264-dihedral-latex-adversarial-review.md`.
- **C309 `[dihedral]` [QUEUED; after C308, C264 phase 4/6]** — artifact/reproducibility gate: stabilize tables, references, appendices, regeneration commands, PDF build, evidence manifests, scoped existing formal checks, and tracked `flake.nix`/`flake.lock` pins for `finitegeom` plus every required external certificate package → `notes/2026-07-17-c264-dihedral-latex-adversarial-review.md`.
- **C310 `[dihedral]` [QUEUED; after C309, C264 phase 5/6]** — adversarial mathematical referee pass with a dated issue ledger and repairs for every blocking correctness, scope, dependency, or reproducibility finding → `notes/2026-07-17-c264-dihedral-latex-adversarial-review.md`.
- **C311 `[dihedral]` [QUEUED; after C310, C264 phase 6/6]** — two separated cold-prose reads, final title/abstract and journal-neutral preflight, final source/PDF agreement, and C264 closure → `notes/2026-07-17-c264-dihedral-latex-adversarial-review.md`.
- **C322 `[dihedral]` [QUEUED; feeds C308 trust apparatus]** — audit at source level what the three nimber solvers actually share (move generator/rules encoding, algorithm, state canonicalization); agreement is evidence only if they share none of the three. Add mutation tests on the q11 template, and write a genuinely independent solver if the audit finds a shared move generator → `notes/2026-07-18-c151-certificate-portfolio-fable-review.md`.
- **C291 `[dihedral]` [QUEUED; POST-C264]** — structural strategies and compact certificates for the nonregular polyhedral templates: recognize residual graph families where possible and replace the nonzero `1/2` table entries by human strategies or small independently checkable Node-Kayles certificates → `notes/2026-07-17-c291-polyhedral-template-strategies.md`.
- **C292 `[dihedral]` [QUEUED; POST-RELEASE]** — wild polyhedral characteristic spike: classify or sharply delimit `S₄/A₅` behavior in characteristics dividing the group order (`p=3,5`), including unipotent stabilizers, changed orbit types, and exactly which tame formulas fail → `notes/2026-07-17-c292-wild-polyhedral-spike.md`.
- **C293 `[dihedral]` [QUEUED; POST-RELEASE, after C291]** — formalize the polyhedral finite boundary: add a small Lean-checkable orbit-template/table certificate layer for the `S₄/A₅` rows and audit the resulting paper-facing theorem boundary without importing the full escape residual → `notes/2026-07-17-c293-polyhedral-template-formalization.md`.

### `gem-mining`

- **C156 `[gem-mining]` [QUEUED; folds into C155]** — citable source for the relevant classical claim.
- **C157 `[gem-mining]` [QUEUED; only if C155 proceeds]** — verify or replace the remaining claim.
- **C159 `[gem-mining]` [QUEUED]** — U-atlas first cell.
- **C160 `[gem-mining]` [QUEUED]** — settle q=5 frame-sibling priority.
- **C169 `[gem-mining]` [QUEUED; C155 gate]** — remaining submission literature gate.
- **C175 `[gem-mining]` [QUEUED FOLLOW-ON]** — separate higher-field follow-on.
- **C177 `[gem-mining]` [QUEUED FOLLOW-ON]** — generalized-hexagon connection.
- **C193 `[gem-mining]` [OPEN ILL GATE]** — obtain/read the remaining BSW source.

### `nofil`

- **C265 `[nofil]` [QUEUED]** — write the projective mirror-outcomes section into `notes/paper-sumfree-capgame/main.tex` per ruling D1 (FOLD): integrate the Lean-proved mirror⇒P projective theorems (PG(n,2), elliptic Q⁻, even-q planes, hyperbolic quadrics), retire the manuscript's "projective case open" framing, and clear the DRAFT flags and placeholder title/author block → `notes/2026-07-17-c265-nofil-projective-section.md`.
- **C266 `[nofil]` [QUEUED]** — implement the recorded sharpness-negative release gate (do not re-decide it): Scharlau/Witt-transfer lemma to make the elliptic Q⁻ method-negative airtight, plus boundary negatives and capacity-2 sharpness to the recorded internal gate (parabolic + Hermitian negatives already rigorous) → `notes/2026-07-17-c266-nofil-sharpness-witt-transfer.md`.
- **C267 `[nofil]` [QUEUED]** — close the novelty audit's open diligence item: obtain and verify the Clark–Mancini–Van Hook full text, then harden or retain the qualified "to our knowledge / first" language per the audit's instruction → `notes/2026-07-17-c267-nofil-novelty-clark-mancini-vanhook.md`.
- **C268 `[nofil]` [QUEUED]** — create the `lean/TRUST.md`-standard trust ledger for `lean/ProjectiveCap/` + `lean/CapGame/` (axiom audit, no-`sorry`/no-`native_decide` statement, adequacy notes) → `notes/2026-07-17-c268-nofil-projectivecap-trust-ledger.md`.
- **C269 `[nofil]` [QUEUED]** — full-manuscript pass to the arcs/clebsch release bar: complete LaTeX+PDF, adversarial review, repeated cold-prose review → `notes/2026-07-17-c269-nofil-latex-adversarial-review.md`.
- **C270 `[nofil]` [QUEUED]** — public mirror / first extraction ("do this first", `papers/papers-planning.md`): coordinate the tagged public `github.com/tavisrudd/finitegeom` identity and Lean-complete mirror outcomes, require the fresh paper export's tracked `flake.nix`/`flake.lock` pins for `finitegeom` and every required external certificate package, and unblock the public-artifact citation, OEIS `%H` links, and arXiv posting → `notes/2026-07-17-c270-finitegeom-public-extraction.md`.

### `reed-solomon`

- **C533 `[reed-solomon]` [QUEUED; independent after C525]** — sharpen C525's characteristic-two ordered-Hessian base-selection threshold and `3n-4` deletion budget using exact pulled-back covariants, smaller deterministic hitting slices, and divisor-overlap accounting; retain the same carrier theorem and prove any improvement uniformly rather than by fixed-level enumeration → `notes/reed-solomon-tasks/c533-c525-threshold-deletion-sharpening.md`.
- **C537 `[reed-solomon]` [QUEUED; after C536; C534 closeout rank 3]** — compare Flatland's pairwise fundamental-matrix reconstruction and explicit multi-view consistency gap with C481--C485's labelled `M_0,6` diagonal compatibility, residual dimensions, and four-view Gale pair; prove exact equivalence or strict refinement, or kill the bridge by incompatible inverse inputs, without opening a manuscript or displacing C538/C545 → `notes/reed-solomon-tasks/c537-flatland-gale-multiview-comparison.md`.
- **C545 `[reed-solomon]` [QUEUED; NEXT AFTER PROOF-EXPANSION GATES; DOI RELEASE BLOCKED FOR CURRENT ANNOUNCEMENT DRAFT]** — publish a proof-complete Version 1 of the same beyond-four PRS paper through a recognized DOI-bearing preprint route only after the second-draft plan closes the full manuscript-proof, public classification-record, statement-adequacy, provenance, immutable-manifest, clean-replay, literature, cold-review, and fresh-export tracked `flake.nix`/`flake.lock` pin gates; then perform the exact claim/proof/certificate audit, target-journal policy check, immutable release, and explicit version relationship so the priority record does not become a competing publication.  The current research-announcement draft must not be released as proof-complete → `papers/beyond4_prs/second-draft-fix-plan.md`, `notes/reed-solomon-tasks/c545-beyond-four-prs-rapid-preprint-doi.md`.

### `relconic`

- **C556 `[relconic]` [GATED; after C554--C555 expose a carrier or rank invariant]** — test whether the resulting invariant yields an infinite characteristic-two low-degree-carrier obstruction extending the structural mechanism behind \(q=16\), using finite computations only as certificate-backed reconnaissance → `notes/2026-07-24-c556-even-family-carrier-obstruction.md`.

### `ame-lu`

- **C581 `[ame-lu]` [QUEUED; after C580; optional manuscript upgrade gate]** — test whether C560's rank-one contraction locus canonically reconstructs the local Heisenberg/symplectic phase space and admits a quantitative approximate-rigidity theorem; separate the exact basis-free reconstruction from any robust claim and audit each before adoption → `notes/2026-07-24-c581-phase-space-robust-rigidity.md`.
- **C563 `[ame-lu]` [QUEUED; PARALLEL AFTER C561]** — import every adopted paper-facing computation as a paper-local reproducibility bundle with exact generator, compact certificate, independent replay, manifest entry, and SHA-256 hashes → `notes/2026-07-24-c563-ame-lu-evidence-package.md`.
- **C564 `[ame-lu]` [GATED; after C561--C563]** — write the first complete manuscript draft, synchronize theorem labels and boundaries with the ledgers, build a warning-free PDF, and record all remaining proof and exposition gaps → `notes/2026-07-24-c564-ame-lu-first-draft.md`.
- **C565 `[ame-lu]` [GATED; after C561 theorem freeze]** — build the shared Lean interface for six-arcs, `[6,3,4]` MDS kernels, equal-phase CSS states, AME conditions, party actions, and the exact manuscript convention dictionary → `notes/2026-07-24-c565-ame-lu-lean-foundation.md`.
- **C566 `[ame-lu]` [GATED; after C565]** — formalize the admitted non-GRS pencil, the scalar \(z\), and the algebraic/projective implications needed by the manuscript's local-Clifford classification, exposing every geometric classification input as a named hypothesis when not formalized → `notes/2026-07-24-c566-ame-lu-lean-lc-classification.md`.
- **C567 `[ame-lu]` [GATED; after C565]** — formalize the stabilizer marginal trace/rank formula, the concurrency-count reduction, and the exact arithmetic implication used in the uniform H3-versus-GRS arbitrary-LU separator → `notes/2026-07-24-c567-ame-lu-lean-marginal-moment.md`.
- **C568 `[ame-lu]` [GATED; after C565]** — formalize the manuscript-facing algebra for the split-torus versus `SL_2(q)` logical-Clifford phase and the exact four-copy contraction separator, with finite group and contraction evaluations kept as explicit certificate inputs where necessary → `notes/2026-07-24-c568-ame-lu-lean-logical-phase.md`.
- **C569 `[ame-lu]` [GATED; after C565 and C563 evidence schema]** — formalize the reduced transport operator's cycle-cover factorization, the divisor \((z-2)(9z-4)\), and the characteristic-seven merger identity, separating checked algebra from orbit-geometry inputs → `notes/2026-07-24-c569-ame-lu-lean-transport-divisor.md`.
- **C570 `[ame-lu]` [GATED; after C566--C569]** — close the aggregate Lean import, standard-axiom audit, declaration-level manuscript reconciliation, and referee-facing statement-adequacy ledger for the complete adopted formal package → `notes/2026-07-24-c570-ame-lu-lean-aggregate-audit.md`.
- **C571 `[ame-lu]` [GATED; after C564 and C570]** — run the adversarial proof/evidence audit and second-draft revision, close every claim/proof/novelty and trust-map row, inspect the rendered PDF, and obtain an independent mathematical cold read → `notes/2026-07-24-c571-ame-lu-adversarial-second-draft.md`.
- **C572 `[ame-lu]` [GATED; after C571]** — produce the release candidate: clean-checkout build and full replay, immutable source/evidence manifest, reviewed paper-only public export plan, target-policy check, and final author/account gates → `notes/2026-07-24-c572-ame-lu-release-candidate.md`.

### `rp-next`

- No open tasks.

### Dormant / handoff-owned lanes

- **C16 `[kayles]` [DORMANT]** — sum-free induction; resume only on explicit lane selection.
- `baer` has no queue-level open row here; its handoff owns the current C99.6 review/disposition.
- `queens` is archived and has no live task.

## Settled work

All completed rows, original rankings, amendments, and detailed task bodies are preserved in
`2026-07-07-codex-task-queue-archive.md`. Do not copy them
back into this live registry.
