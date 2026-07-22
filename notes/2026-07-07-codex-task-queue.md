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
- **C287 `[build-sys]` [QUEUED]** — extract the reviewed union of all paper-facing Lean closures into one fresh-history shared repository at `~/src/papers/lean`, validate public gates, and prove guarded artifact restore semantics → `notes/2026-07-17-c287-shared-lean-extraction-plan.md`.
### `cap`

- **C13 `[cap]` [OPEN]** — q=9 intrusion structure / Lean target → `notes/2026-07-07-codex-q9-intrusion-probe.md`.
- **C30 `[cap]` [OPEN ENGINEERING TAIL; USER GATE]** — reduce or explicitly launch the q17/q19 generated-certificate assembly.
- **C74 `[cap]` [ACTIVE]** — prove maximum-pencil balanced-packet P existence / `Ncenters <= q-8`; characteristic-5/7 exceptions remain.
- **C77 `[cap]` [OPEN GAME-SEMANTIC TAIL]** — algebraic forced-reply closure for the C74 packet → `notes/2026-07-11-c77-game-semantic-reply-graphs.md`.
- **C80 `[cap]` [ACTIVE; exact Y_NK0 guard P-pure but sparse]** — prove bulk descent into the graph-exact Node--Kayles-zero packet (q17: 3,048 members / 2,822 transitions) or add a companion guarded packet covering the missing branches; only then release the count to C82 → `notes/2026-07-12-c80-bulk-exhaustion-probe.md`.
- **C81 `[cap]` [OPEN; independent]** — characteristic-5/7 subfield descent gate → `notes/2026-07-12-c81-subfield-descent-gate.md`.
- **C82 `[cap]` [GATED on C80]** — orbital counting for the exact packet C80 produces → `notes/2026-07-12-c82-orbital-counting.md`.
- **C189 `[cap]` [QUEUED]** — q=5 octahedral-frame game bridge → `notes/2026-07-15-c189-q5-octahedral-frame.md`.
- **C198 `[cap]` [QUEUED]** — bounded q=7 BSW exterior-four-arc residual scout → `notes/2026-07-15-c198-q7-exterior-residual-scout.md`.
- **C199 `[cap]` [QUEUED]** — extract direct strategies from the Schreier catalogue → `notes/2026-07-15-expert-questions-upgrade-portfolio.md`.
- **C200 `[cap]` [QUEUED]** — recognize Schreier graph families structurally → `notes/2026-07-15-expert-questions-upgrade-portfolio.md`.

### `clebsch`

- **C182 `[clebsch]` [QUEUED]** — immutable artifact/DOI archive → `notes/2026-07-15-c182-clebsch-artifact-archive.md`.
- **C320 `[clebsch]` [QUEUED; RELEASE-BLOCKING CAPSTONE AFTER ALL PAPER-ADOPTED FORMALIZATION SLICES]** — create the independently reviewed Clebsch claim-by-claim trust ledger, adequacy extraction, pinned gates/commit, and one verify-all entry point; no completion/archive before the local checklist, issue fixes, post-fix review, and final `GO` → `notes/2026-07-20-c320-clebsch-trust-ledger.md`.
- **C321 `[clebsch]` [QUEUED; after C320 inventory]** — replace load-bearing Singular evidence with independently specified exact certificates/checkers and canonical replay bundles; no completion/archive before the local checklist, issue fixes, post-fix review, and final `GO` → `notes/2026-07-20-c321-clebsch-singular-certificates.md`.
- **C427 `[clebsch]` [QUEUED; after C425 and C426]** — Lean committed C373 intrinsic six-block and unordered `10+10` chirality theorem, with sound automorphism/no-outer-lift evidence and the import-only replacement-spine gate → `notes/2026-07-20-c427-clebsch-scheme-chirality-lean.md`.
- **C428 `[clebsch]` [QUEUED; after C222, C421, and C427]** — Lean C403 weighted 2-adjoint depth/enumerator/distance theorem with separate B3 leaf and its own import-only gate; hand trust-map results to C320 → `notes/2026-07-20-c428-clebsch-weighted-adjoint-lean.md`.

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
- **C417 `[crowns]` [QUEUED; EV58, affine cocycle and line-bundle formulation]** — audit affine group cohomology, hypersurface-ideal covariants, projective evaluation bundles, and design-trade polarization, then formalize quotient base change so it explains both failed quotient-depth and successful product-depth covariance and exports a reusable theorem; elementary repackaging stops → `notes/2026-07-20-c411-c417-c406-successors.md`.
- **C418 `[crowns]` [QUEUED; seven/eight-point realizable balanced-trade gate]** — over `F_7`, first apply C430's restriction/radical rigidity pretest to each named support, then build only the surviving Pasch, four-endpoint, common-core, and incidence-2-switch defect generators; seek an exact realizable vector in the kernel of the original-characteristic/universal-adjoint map but outside the pointed repair/puncture/syndrome map, moving from seven to eight points only through the stated structural gate and stopping before any raw census or field increase → `notes/2026-07-20-c418-c419-c410-successors.md`.
- **C419 `[crowns]` [QUEUED; fixed-incidence moduli and exact kernel-realizability gate]** — normalize a seven-point rank-three incidence type, derive the locally closed realization stratum preserving every original and adjoint incidence in the universal map, track C430's restriction ranks and radical level pattern across it, and use exact determinant ideals plus elimination/SAT/ILP filtering only on the resulting defect locus to test whether a pointed secant or puncture condition cuts that stratum; reconstruct every candidate projectively and stop on forced constancy or an unbounded field/moduli census → `notes/2026-07-20-c418-c419-c410-successors.md`.
- **C429 `[crowns]` [QUEUED; EV92, after C427]** — prove the intrinsic split/inert/ramified outer-symmetry phase theorem over `Z[tau]`, starting from C430's canonical outer-odd radical/socle line and testing its integral Smith/Fitting and Frobenius behavior as the common datum for the two `A5` representations, arc chiralities, monomial-equivalence obstruction, and scheme fibres; require q=5 internalization and a Frobenius-semilinear inert statement without reopening Benson-pre-empted quadratic descent → `notes/2026-07-20-clebsch-lean-formalization-plan-fable-review.md`.
- **C431 `[crowns]` [QUEUED; EV79, after C428]** — falsifier-first rank-four test, then prove or refute that a finite-field weighted `(r-1)`-adjoint depth spectrum punctured at mirrors determines the rank-`r` arrangement-complement code enumerator; preserve the distinction from C403's higher-degree failure and stop at the first exact counterexample → `notes/2026-07-20-clebsch-lean-formalization-plan-fable-review.md`.
- **C432 `[crowns]` [QUEUED; EV72, structural C400 fusion gate]** — replace Bell-number fusion enumeration by a centralizer/representation-algebra criterion that exactly reproduces the q=5/9/11 coherent-fusion lattices; require a portable classification theorem and stop on a field-by-field orbit-table reformulation → `notes/2026-07-20-clebsch-lean-formalization-plan-fable-review.md`.
- **C433 `[crowns]` [QUEUED; EV66, modular depth-map identification]** — consume C412's `P(1)`/`1|9|1` placement and C430's exact identification of the outer-odd affine radical with the `[1,1,1]` depth socle, then canonically place the odd Fourier block and C411 profile map in an exact sequence through that socle; stop if the remainder is only decomposition data or another rank-drop computation with no canonical map theorem → `notes/2026-07-20-clebsch-lean-formalization-plan-fable-review.md`.
- **C434 `[crowns]` [QUEUED; EV61, double-coset information-lattice functor]** — formulate and test a portable `K\G/H` recovery theorem whose coset strata realize the exact `22 -> 6 -> 2 -> 1` information lattice across C379/C403/C406/C411 and whose local algebra contains C430's `radical -> sheets -> equal-sum product algebra -> sign line` chain; require decorated inversion or another reconstruction consequence and stop on abstract subgroup bookkeeping → `notes/2026-07-20-clebsch-lean-formalization-plan-fable-review.md`.
- **C436 `[crowns]` [QUEUED; EV43, bounded Mathieu-adjacency check]** — compute the subgroup of `Sym(12)` generated by the two C379 sheet stabilizers, equivalently by `PSL_2(11)` and the recorded `J` edge action, and decide exactly whether it remains `PGL_2(11)` or reaches `M_12`; stop at the group-order/action certificate with no Mathieu-tourism successor → `notes/2026-07-20-clebsch-lean-formalization-plan-fable-review.md`.
- **C439 `[crowns]` [QUEUED; C430 radical--Hadamard application sweep]** — apply the restriction/radical/product-algebra pretest to C418/C419, place C433's odd Fourier/profile map relative to the now-identified projective-cover socle, test C429's integral/Frobenius radical line, and require a reconstruction consequence from C434's functorial `K\G/H` version; export only exact theorem/obstruction hand-backs and stop before field-by-field census → `notes/2026-07-20-c439-radical-hadamard-application-sweep.md`.
- **C401 `[crowns]` [QUEUED; EV66, cubic-contained uncovered-locus classification]** — classify six-arcs whose nonempty uncovered locus lies on a degree-at-most-three curve, deriving a rigorous field bound before any residual census and separating every reducible/nonreduced cubic type; consume C398's conic subcase and stop on a large exception taxonomy or pre-emption → `notes/2026-07-20-c398-c402-portable-clebsch-theorem-priority.md`.
- **C402 `[crowns]` [QUEUED; EV60, all-good-reduction H3 AME separation gate]** — test whether every good non-GRS `H3/A5` reduction gives an `AME(6,q)` state LU-inequivalent to every GRS class via one uniform invariant, using C395's characteristic-31 non-GRS `A5` and characteristic-17 GRS `S4` towers only for same-field controls; stop at the first collision, continuous-unitary requirement, or unbounded GRS-moduli census → `notes/2026-07-20-c398-c402-portable-clebsch-theorem-priority.md`.
- **C396 `[crowns]` [QUEUED; holonomy completeness and LU-moment failure gate]** — first certify the q=13 collision showing C374's triple-marginal moment does not classify the pencil, then determine whether the holonomy signature exactly classifies its projective/monomial classes over odd prime powers; require symbolic parameter equivalence plus direct-Lagrangian replay and stop on the first certified collision or known-invariant factorization → `notes/2026-07-20-c395-c396-c384-portable-upgrades.md`.
- **C397 `[crowns]` [QUEUED; AME perfect-tensor Clifford and operator-pushing physics gate]** — compute the exact party-permuting local-Clifford stabilizers, induced logical Clifford groups of all six encoder views, and single-leg Pauli operator-pushing orbits for the q=11 Clebsch/GRS tensors; continue to C395's arithmetic symmetry-jump fields only if one operational invariant survives, and stop if all data factor through the known projective stabilizer and AME parameters → `notes/2026-07-20-c397-ame-perfect-tensor-physics-gates.md`.
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
- **C309 `[dihedral]` [QUEUED; after C308, C264 phase 4/6]** — artifact/reproducibility gate: stabilize tables, references, appendices, regeneration commands, PDF build, evidence manifests, and scoped existing formal checks → `notes/2026-07-17-c264-dihedral-latex-adversarial-review.md`.
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
- **C270 `[nofil]` [QUEUED]** — public mirror / first extraction ("do this first", `papers/papers-planning.md`): tagged public `FiniteGeom` base repo pinned by commit + the Lean-complete mirror outcomes, unblocking this paper's public-artifact citation (per the *Arcs vs Nofil* ruling), OEIS `%H` links, and arXiv posting → `notes/2026-07-17-c270-finitegeom-public-extraction.md`.

### `reed-solomon`

- **C476 `[reed-solomon]` [QUEUED]** — exhaust all semilinear classes of six-point GRS supports and deepest-syndrome orbits for `q in {5,7,8,9,11}`, compare them with the C475 four-cycle atlas in a fixed lexicographic order, and stop after completing the first colliding support fibre; if none collides, certify exact separation on the whole stated domain → `notes/2026-07-22-c476-standard-grs-atlas-pilot.md`.
- **C477 `[reed-solomon]` [GATED on a C476 collision]** — freeze C476's first colliding standard-GRS support, determine its complete atlas fibre and stabilizer action, and prove an intrinsic minimal discriminator or a sharp obstruction; close immediately at an unmet collision gate → `notes/2026-07-22-c477-first-atlas-collision-fibre.md`.
- **C478 `[reed-solomon]` [GATED on C475; independent of C476 collision]** — evaluate the proved atlas on the four frozen C398 non-GRS classes and the fixed `A3/B3/H3` conic-phase controls at `q=5,7,11`, separating ordinary orbit recovery from Gram/Sylow modular-carrier gates without opening a new field census → `notes/2026-07-22-c478-exceptional-family-controls.md`.

### `relconic`


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
