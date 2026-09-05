# Queue row specifications, preserved 2026-09-05

The live queue (`2026-07-07-codex-task-queue.md`) is an allocation and open-work index: an ID, a
lane peg, status fields, a short summary, and a pointer. Many rows had grown into full task
specifications instead, several of them carrying material that appears nowhere else — findings the
row records against its own linked report, explicit counterexample witnesses, ordered deliverable
lists, and prior-art instructions.

This file holds the verbatim pre-trim text of every row that exceeded 600 characters, grouped by
lane, so the queue rows could be cut back to routing entries without losing a word of it. Nothing
here is a status update: each row's own linked report remains the authority, and a row's live status
is whatever the queue says today.


## `ame-lu`

### C979

- **C979 `[ame-lu]` [RUNNING; USER-HELD OPEN UNTIL EXPLICIT CLOSE]** — revise *Diagonal Isoduality and Transversal Clifford Groups of MDS--CSS Codes* for a stabilizer-code reader who is not already fluent in MDS codes, arcs, Gale duality, or finite-group extensions: make the diagonal-multiplier nullity-zero/nullity-one dichotomy the unmistakable core, rebuild the introduction and Section 3 around the operational question and proof architecture, re-layer the six-point applications and refinements, simplify the verification and appendix presentation without weakening scope or trust boundaries, and correct the paper README so it makes no Clebsch-series or Clebsch-portfolio affiliation claim. Preserve the exact mathematics, distinguish imported rigidity from paper-local proofs, validate the rendered hierarchy, and do not close or archive this task until the user explicitly says to close it → `notes/2026-08-27-c979-mds-css-exposition-revision.md`.

### C986

- **C986 `[ame-lu]` [QUEUED; CSS BOREL CLASSIFICATION AND REALIZABILITY]** — develop C982's torus/Borel/full-`SL_2` projection theorem into a possible standalone classification package: classify global coordinatewise Clifford stabilizers of pure CSS states, determine realizable square-zero conductor bimodules and construct nontrivial Borel families, give a recognition algorithm, pursue the full prime-power semilinear sectors and positive-rate logical quotient, and complete a graph-state/endomorphism-algebra novelty audit. Stop at a corollary or outlook result if no substantive realizability or semilinear layer emerges; do not touch C979 → `notes/2026-08-27-c986-css-borel-classification.md`.

### C795

- **C795 `[ame-lu]` [QUEUED; MANUSCRIPT CORRECTNESS, AHEAD OF THE COLD READ]** — the adopted subsection's region statement is scoped wrongly. C786 proved the certified radius grows like the uniformity order, so for an absolutely maximally entangled state on 2m parties it grows linearly in the party count, while the manuscript's region proposition and its impossibility sentence generalize a 2-uniform-class fact to the class the decomposition corollary is actually stated for. The Reed--Muller family behind the shrinkage holds uniformity at three for every length, which is why it never tested the governing quantity. Restate the region result with uniformity order as the parameter, keep the 2-uniform statement as the special case it is, adopt C786's explicit closed-form threshold in place of the compactness existence claim, and record that at uniformity three the truth is bracketed between total generator norm one and 1.466. Red-team the reparameterization before adopting it — this reverses a conclusion the lane already adopted once. **Three additions the report undersells.** First, promote its quantized-overlap lemma's consequence to a named corollary: the symmetry group is not merely discrete but *uniformly separated in defect*, by a constant depending only on the characteristic and on nothing else — not the party count, not the state. That is a cleaner and stronger sentence than the threshold formula, and it is the certification statement that actually survives at scale. Second, state the stability estimate at general uniformity order rather than only at order two, since the order-k remainder is the same proof and the maximally entangled case is then the k equal to m specialization. Third, generalize the two-state intertwiner bound to arbitrary party count, which the report says the proof already supports and which subsumes part of C787. **Also adopt C796's budget-free stability estimate** (`notes/2026-08-02-c796-phase-blindness-transfer.md` section 7): it reaches the same conclusion with no global generator-budget hypothesis and a per-site spread condition relaxed to pi, paying only in the constant, and it is complementary to the moment route rather than competing with it. Together they make the region discussion a choice of hypothesis set rather than a single contested claim, which is a better section than either alone. Note also that C786's named blocking example for its open problem is false — C796 proves that configuration is always detected, without phase information — so any manuscript sentence describing the obstruction as phase-blindness must be rewritten or dropped. **One trust gap to close first:** the new threshold's Step A depends on the manuscript's quantitative-axes proof, which the report notes is independently verified nowhere in the corpus. Verify it before the threshold is adopted, or state the dependency explicitly → `notes/2026-08-01-c795-region-scope-and-explicit-threshold-adoption.md`.

### C790

- **C790 `[ame-lu]` [QUEUED; would restructure the diagonal programme's core]** — prove or refute that the Smith normal form of a binary code's lift lattice is exactly its Schur filtration: the number of invariant factors divisible by `2^l`, plus the lattice's free rank, equals the codimension of the l-th Schur power, for every l. Verified in every entry for ten codes at lengths 7 to 32 and levels 1 to 4, including the rank-deficient repetition/GHZ case once the free rank is counted (`notes/2026-08-01-external-source-numerics-lattice.json`). If true, the diagonal note's classification theorem and its Schur-cube rigidity criterion are the same theorem: the l=3 case reads "no invariant factor divisible by 8 exactly when the third Schur power is full", which is the classification's Clifford criterion against the rigidity theorem's hypothesis. The cascade lemma supplies one inclusion; the lift identity is the natural source of the other. Before leaning on the evidence, recompute the Schur codimensions at one small length by brute-force enumeration of l-fold products: the certificate uses an iterated bilinear span, which is valid because Schur multiplication is bilinear but is the one step where a subtle error would hide. Binary only — characteristic two carries the factors of two that drive the correspondence. **Bounded prior-art check first, before investing in a proof:** this is our own new claim in a well-populated area, and it must not be assumed novel. Search Construction-A code lattices and their elementary divisors, the divisible-codes literature (Ward), Schur/component-wise products of codes and their dimension filtrations, and the code-lattice invariants used in the triply-even classification line. Record it per `notes/literature-audit-conventions.md`; if the correspondence is known, the value shifts entirely to the restructuring argument for the diagonal note and the proof effort should stop → `notes/2026-08-01-c790-smith-schur-filtration.md`.

### C779

- **C779 `[ame-lu]` [QUEUED; independent of C778 and higher EV]** — attempt a structural proof replacing the finite sweep: in the generator-column formulation, dual distance at least five makes the column multiset a Sidon set and triple-evenness makes every nontrivial Walsh coefficient congruent to the length modulo sixteen; test whether the power-sum moment identities for the Walsh spectrum force a contradiction at all lengths. Two fallbacks if the moment route stalls: a Terwilliger-type semidefinite refinement using the quadratic pair conditions, and exhaustive small-dimension search under Walsh-modulo-sixteen filtering for the five lengths 70--74. Target both open ranges, 70--74 and 81--124; the second is unreachable by linear programming, which loses its killing power by length 88 → `notes/2026-08-01-c779-triply-even-walsh-moment-mechanism.md`.

### C807

- **C807 `[ame-lu]` [RUNNING; BLOCKING GATE FOR THE C804 REFRAMING]** — claim-specific novelty audit for the recognition-group criterion proved in `notes/2026-08-02-c804-recognition-group-criterion.md`: the partial-Weyl marginal criterion at index-set sizes strictly between two and the squared local dimension, the recognition subgroup and its generation criterion, the arbitrary-local-dimension form of Van den Nest, Dehaene and De Moor's minimal-support lemma, the claim that their Theorem 1 is the local-dimension-two case, and the CSS corollary. Two halves: the stabilizer and local-unitary-versus-local-Clifford literature, and the tensor-decomposition-uniqueness literature, the latter to fix the correct attribution for the axis lemma, which is expected to be a known Kruskal-type result. Follows `notes/literature-audit-conventions.md`; no manuscript wording may assert generality until it closes → `notes/2026-08-02-c807-recognition-group-novelty-audit.md`.

### C782

- **C782 `[ame-lu]` [QUEUED; needs the C780 audit first if it is to be published]** — write the general p-power qudit sector airtight over the proved augmentation lemma, which bounds how many finite differences are needed before everything is divisible by the right power of p; the source scheme is stated but explicitly not written, and the p=3 case (whose T-analogue is a quadratic phase of order nine, in neither proved sector) and the prime-to-p part of the order are both open. Do not inherit the binary lattice laws recorded in `notes/2026-08-01-external-source-numerics.md` by analogy: the factors of two in the lift identity drive that correspondence, and the odd-characteristic analogue needs p-adic valuations and a different carry structure → `notes/2026-08-01-c782-qudit-general-p-power-sector.md`.

### C783

- **C783 `[ame-lu]` [IN PROGRESS; ORIGINAL ENUMERATOR ROUTE PRE-EMPTED]** — the certified plateau covers only the transversal-T sector where the weight vector is all ones. Nezami--Haah already give the all-odd level-three lift test, and Baldelli--Mostad--Lin--Rosnes--Battaglioni (2026) already give the triorthogonal/MacWilliams dual-distance ILP. The surviving problem is the exact mixed-residue equal-phase CSS boundary; establish C790's level-three Smith--Schur reduction or retain all eight residue classes and determine whether the plateau survives → `notes/2026-08-01-c783-weighted-diagonal-boundary.md`.

## `build-sys`

### C326

- **C326 `[build-sys]` [IN PROGRESS; exporter landed and self-validated, project extraction awaits a quiet Lean worktree]** — implement a declared-intent/Lean-facts trust spine with a global orphan inventory, exact per-terminal axiom checks, generated trust-document regions, strict data provenance, and canonical theorem/module/data dependency-graph JSON with filtered Mermaid/DOT renderers; all checks are read-only and adversarially tested → plan `notes/2026-07-18-c326-trust-spine-and-dependency-graph-plan.md`, Phase A report `notes/2026-07-18-c326-trust-spine-phase-a.md`, exporter report `notes/2026-07-18-c326-lean-fact-exporter.md`.

### C328

- **C328 `[build-sys]` [GATED; after C326 stabilizes node IDs and the evidence-extension schema]** — operationalize the trust graph's evidence overlay for novelty assessment: freeze bounded status vocabulary and immutable/superseding assessment records, validate literature-search scope/evidence/freshness metadata, add query and renderer badges, and populate a RelativeConicArcs pilot; portfolio judgments remain with their owning lanes; the read-depth vocabulary and coverage outcomes it validates are owned by `notes/literature-audit-conventions.md` and change together with it → `notes/2026-07-18-c326-trust-spine-and-dependency-graph-plan.md` § Evidence-extension boundary.

## `cap`

### C553

- **C553 `[cap]` [IN PROGRESS; 2026-07-26 target-only boundary approved; C287 dependency; A1/B1 APPROVED]** — construct the first-tag target transformation without editing or deleting private-monorepo Lean source: rewrite the 17 first-tag modules for referee-facing public prose, omit `ProjectiveCap.Almost.OddEscape` and `ProjectiveCap.StableFacts` from the target, migrate every target consumer to the canonical `GridGame`/`ExtensionCount` APIs without compatibility aliases, and complete the semantic declaration/docstring gate → `notes/2026-07-24-c287-source-owner-rewrite-packet.md`, `notes/2026-07-26-c287-paper-intake-refresh.md`.

### C80

- **C80 `[cap]` [ACTIVE; HIGHEST-EV SPINE; next step = prove global consumed-label Hall surplus and strict support descent, or extract the first support-deficit set]** — `Ω` is the exact absorption coordinate, `B_cc` is the structural overload-zero boundary, and defect cardinality `d=|Def|` gives the sound q23 survivor `F_d`. The local causal-label crown is closed-negative at q11: for `A={(1,3),(5,2),(9,6),(10,1)}`, opponent `(4,4)`, and causal reply `(7,10)`, both played moves lie in `Def(A)`, `Def(A+o)=∅`, but `Def(A+o+h)={(0,5),(6,5)}`. Both fibres are uncompensated because the causal move itself was a shared old `B_small` certificate reply; selecting it consumes both copies, and the remaining reply of one fibre is killed on a secant. Primary bitmask and independent determinant replay agree. Thus field-uniform certificate-exchange nonpacking and the one-label causal update are false, although the conditional injectivity theorem remains valid. This witness still has global cardinality surplus (seven old labels, two new defects), so the live crown is a projectively natural Hall rematching from genuinely new defects to all consumed ancestral labels with strict support descent, followed by opponent-complete entry. C82 stays gated. Do not patch the false per-causal bound, return to more q23 orbit enumeration, or use an explicit growing matching table. Reports → `notes/2026-07-29-c80-causal-one-to-many.md`, `notes/2026-07-25-c80-status-ledger.md`.

### C520

- **C520 `[cap]` [GATED on C80; C496 successor; feeds C82]** — generalize the C496 q=11 coupling to all odd q: exhibit the incidence-live locus as a bounded-degree algebraic family in `u`; test whether the live-pair resolvent-quadratic discriminant's square class predicts the depletion sequence `{11,17}` (tt #1), and whether a Weil bound on the value character sum `Σ_live (1−χ(u))/2` gives uniform odd-q abundance for C82 (tt #3). The first moment `Σ_live χ` is `C2`-symmetry-forced (not a diagnostic; tt #4) — use a `C2`-invariant higher moment. Also state the coupling as the sign-isotypic Hecke bimodule (tt #2). The resolvent-depletion half (tt #1) is testable now on frozen q=13/17/19 A5-anchor data, ahead of the C80 gate → `notes/2026-07-23-c496-bihecke-two-sort-coupling.md`.

### C508

- **C508 `[cap]` [QUEUED; DEPRIORITIZED — low upside after the C495/C497 negatives; diagnostic, not descent]** — consume C497's exact reply-type balance and test the bounded projective-plane correlation/polarity candidates on the full 17,954-state marked `Y_0` census: require an explicit involutive pairing that swaps 0/2-fixed reply types and preserves `Y_NK0`, then a minimal full-state anchor whose stabilizer class detects the swap. Even a positive is symmetry/case-reduction only unless it improves C80's sparse guard or a descent measure — revisit only then → `notes/2026-07-22-c508-q17-external-c2-local-detector.md`.

## `clebsch`

### C1013

- **C1013 `[clebsch]` [QUEUED; MATH/LITERATURE/USES; CLASSICAL MECHANISM LEVEL; NO MANUSCRIPT OR ERGODIS SOURCE EDITS]** — deepen the Wronskian-norm level of the Gram--discriminant hierarchy: identify the residual invariants \(\Phi_{d,r}\) through explicit plethysm/transvectant decompositions, determine modular radicals and the exact characteristic range, classify degeneracy and square/Pfaffian phenomena for general \((d,r)\), and extract concrete uses in invariant theory, quadratic spaces, evaluation codes, and configuration moduli; use the existing Ergodis control interface where its typed search can test bases, recurrences, exceptional strata, or counterexamples, while recording interface improvements and keeping every classicality/priority statement under the literature-audit conventions → `notes/clebsch-tasks/c1013-gram-discriminant-invariant-hierarchy.md`.

### C1014

- **C1014 `[clebsch]` [QUEUED AFTER/ALONGSIDE C1013; CONSEQUENCES/USES LEVEL; NO MANUSCRIPT OR ERGODIS SOURCE EDITS]** — shake the downstream tree opened by \(G_{d,r}=\Delta\Phi_{d,r}\): study the finite-field double covers and Frobenius biases, real/local signature and Hasse refinements, automorphism groups of the induced colorings, exceptional harmonic/equianharmonic collapses, exact marking fibres and query complexity, and applications to Papers IV--V or a standalone sparse-shadow arithmetic/reconstruction theorem; run Ergodis-controlled searches for family-level laws and hostile small-characteristic/small-field exceptions, audit all surviving novelty claims, and deliver a ranked theorem/use portfolio with proof gates and publication routing → `notes/clebsch-tasks/c1014-gram-shadow-consequences-uses.md`.

### C816

- **C816 `[clebsch]` [PAPER III ROUTE 5; RESCOPED 2026-08-19; AUDIT GATES THE POSITIONING]** — C809's characterization is already promoted into Paper III and the table (5.1) correction is landed, so what remains is the priority audit the recognition theorem never received and its `OPER` ledger row, the unlanded Theorem D rigidity statement with its module and eigenspace upgrades, the shorter balanced-exchange-rigidity proof that drops the switching normalization and `R(3,3)=6`, the abstract-headline decision, and the hard-coded `\tag` cleanup; then Milnor--Serre, red-team, PDF/release gates, and a fresh context-free cold-read regrade before the final C824 merge → `notes/clebsch-tasks/c816-paper-iii-four-shadow-integration.md`.

### C880

- **C880 `[clebsch]` [QUEUED; MATH AND COMPUTATION ONLY; NO MANUSCRIPT EDITS]** — determine the query complexity of aligned-design reconstruction: decide whether seven points is the sharp hypothesis by enumerating the six-point two-graphs, compute the exact minimum number of alignment tests at seven and eight points against the exhibited $3n^2-23n+45$, and either improve the constant or prove it optimal in a named class, including the regular-two-graph and promised-anchor special cases; audit the principal-minor, hidden-graph-learning, quartet, separating-system and two-graph literatures for pre-emption; cost the decoder against a named state-of-the-art baseline in any setting whose primitive observation is a four-set alignment test; and hand C816 drafted manuscript wording for whatever survives → `notes/clebsch-tasks/c880-aligned-query-complexity.md`.

### C968

- **C968 `[clebsch]` [PAPERS I+II+IV+V COMPLETE; ONE EXPORT GATE]** — build a sparse-shadow reconstruction and canonicalization engine as a new top-level `sparse-shadow/` Cargo project: define typed adapters for the five Clebsch reconstruction profiles, compute exact canonical forms, automorphism/stabilizer data, recovered carriers and residual fibres/torsors, and emit independently replayable equivalence and reconstruction certificates; Papers I, II, IV, and V native/reference canonicalization, full automorphism, reconstruction, certificate, zero-allocation hot-loop, golden/backend gates are green; Paper III remains at its exact paper-owned export gate, with no unblocked C968 implementation frontier until it freezes; make no manuscript, universal graph-isomorphism, or complexity claim beyond proved and measured gates → `notes/clebsch-tasks/c968-sparse-shadow-reconstruction-canonicalization.md`.

### C892

- **C892 `[clebsch]` [REOPENED; FULL REMEDIATION REQUIRED BEFORE CLOSE]** — remediate every finding in the full Paper II Lean and trust-boundary review: formalize every manuscript assertion at exact statement strength, replace partial bundle modes by declaration-level coverage, close the full local source and build fingerprint, pin exact unique terminals and axioms, remove the cap-game regression, repair prose and digests, export one complete formal companion, synchronize the standalone paper, and pass fresh guarded, rejecting, isolated and referee gates → `notes/clebsch-tasks/c892-paper-ii-lean-trust-boundary-review.md`.

### C756

- **C756 `[clebsch]` [ACTIVE OPEN MATH; STRUCTURAL DUAL-3-NET / MASKED-REDEI GATES — saturated-exterior package transferred to C894]** — retain the saturated-internal and full nonsaturated branches.  The complete \(k=12,13,14\) layers are impossible over every finite field.  The saturated power tower untwists to the ordinary Cartier--Toeplitz matrix \(\mathbb M_R\); row count forces kernels only at \(q=25,27,81\), and all three of those fields are now closed by an exhaustive oriented-coherence census covering every odd prime power \(q\le127\) plus \(q=169\), so all remaining kernels lie on a determinantal rank-drop locus whose properness remains to prove.  The census graph is a Cayley graph on \(\mathrm{AGL}(1,q)\) of proved degree \((q^2-1)/4\) whose clique ratio bound exceeds the required size by a factor tending to \(4/3\).  In characteristics three and five the first non-shadow gate is a mixed conic--ghost quadratic/cubic map; for \(p\ge7\) it descends to a pure quadratic map on \(\ker\mathbb M_R\).  Nonsaturated excess has filtered modules and dual barycentric edge-weight spaces.  Its trace splits into a zero norm on \(K_P\) and a sign resultant on \(K_{\rm odd}\), and lifts to a divisor trace of \(z^2\) on the direction-conic pencil of the branched quadric \(\mathscr X_\eta\).  Do not start a \(k=15\) census: next prove the matrix/quadratic rank gates and the quadric divisor-trace law.  Do not edit a manuscript under C756 → `notes/clebsch-tasks/c756-all-k-conic-filling.md`.

### C894

- **C894 `[clebsch]` [ACTIVE; PRE-DRAFT MATRIX FROZEN; HUMAN SAFEGUARDS PENDING]** — the claim--proof--citation matrix is frozen around Paley restriction-is-an-isomorphism and the extremal exterior-arc classification, with the exact mixed-Jacobi collision theorem a qualified named engine, Aoki/Koblitz/Hoshi occupying the broad arithmetic crown, and the rooted \(0\to A_4\to D_6\to\mathcal O_5\to0\) completion a classical secondary endpoint.  Haemers--Parsaei Majd 2022 now closes generic Seidel-to-conference bordering attribution, narrowing the ready-to-send institutional-index packet to the exact local extension, mixed collision, tournament-square refinement, and golden lattice sequence; the external specialist packet checks Segre scale pinning, Stickelberger normalization, and the Weil hypotheses.  Record both returns before choosing title/venue or creating a manuscript.  Keep all-\(k\), saturated-internal, finite-sweep, negative-method, and broader conference material out of the main spine, and do not imply a fifth numbered Clebsch paper → `notes/clebsch-tasks/c894-saturated-exterior-paley-companion.md`.

### C834

- **C834 `[clebsch]` [ACTIVE; REQUIRED FULL-LEAN CLOSURE BEFORE C761 RELEASE]** — replace Paper IV's partial formal mirror by a theorem-complete public Lean aggregate covering distance, all 364 minimum words and four intrinsic families, spanning, exact pair-only reconstruction, automorphisms, the Sylow/involution recovery of the full marked plane, and the \(\mathbf F_8^{12}\) operator module; eliminate native-evaluation axioms, trusted Python premises, and unformalized human transports from the release theorem while retaining exact replays only as independent checks → `notes/clebsch-tasks/c834-paper-iv-full-lean-release-closure.md`.

### C857

- **C857 `[clebsch]` [QUEUED AFTER C834; COMPLETE PAPER IV LEAN STANDARDS CLOSURE BEFORE C761]** — close every gap in the Paper IV Lean audit against `lean/AGENTS.md`, `papers/style-guide.md`, and the reproducibility conventions: reconcile the full manuscript theorem, eliminate forbidden trust from the public closure, freeze a rejecting axiom transcript/allowlist/theorem map/release verifier, repair all module and declaration docs, pinpoint every classical input, and validate every generated artifact plus a clean public checkout against the complete checklist → `notes/clebsch-tasks/c857-paper-iv-lean-standards-closure.md`.

### C682

- **C682 `[clebsch]` [IN PROGRESS — McKAY CORNER CLASSIFICATION COMPLETE]** — explore the rational \(5J_0\) incidence torsor, golden fibre, Clebsch/Petersen modules, and harmonic realization for Gold/Platinum structure. The two-sided Klein defect vanishes for every \(n>52\), every one-sided McKay block has maximal rank in every weight, and all sixty-three monotone entrance phases are transverse. The signed block-Wronskian endpoint package identifies the full graded path corner with the local-return algebra in every degree except the exact degree-\(22\) failure; the nearest lower and upper positive Gram returns form a generator-minimal pair. The virtual levels \(0,\pm1/3,\pm2/3\) are the order-three \(h=0\) indicial roots in the \(E_8\) degree-\(60\) \(h^3/F^5\) level, and source-chain residues explain every multiplicity. Completion or selection of a parked branch is the user's decision → `notes/clebsch-tasks/c682-hitchin-structural-exploration.md`.

### C705

- **C705 `[clebsch]` [COMPLETE — C704 WP1]** — the six cross-golden adjugates intrinsically assemble the Segre--Igusa polar after the third-compound/Jacobian assembly; the \(E_6\) lift, Coble elder-parent, characteristic-zero conormal Hessian normalization, and common affine-\(E_8\) mixed potential are positive; the genuine Lie-\(E_8\) Vinberg/Pfaffian Coble parent is identified with the frozen \(\operatorname{PGL}_9\)-orbit, and all \(720\) ordered level-\(2\) sheets are computed, while the full residual \(S_5\)-torsor correctly obstructs a canonical ordering → `notes/clebsch-tasks/c705-adjugate-segre-igusa-polar.md`.

## `cubic-threefolds`

### C930

- **C930 `[cubic-threefolds]` [ACTIVE; 50-PAGE EPILOGUE REFOUNDING IMPLEMENTED, HOSTILE REFEREE PASS]** — C930 is strictly `m=1` and owns only `papers/cubic-stabilization-m1/`.  The complete 60-page baseline was read and frozen; the implemented 50-page manuscript retains the cycle core and refounds the quantum pair through one occurrence-indexed categorical QDM ledger construction, specialized through distinct atomic and framed block types.  The theorem spine passes resumed, fresh blind, and hostile manuscript review.  The claim-level QDM audit version-pins Beauville, Iritani, and Iritani--Koto, and the migrated verification map records the common theorem and its exact source boundary.  Spacing lint, source-only formal correspondence, manuscript build, and warning rejection pass.  The Gamma-row manuscript is out of scope and untouched; author review of the linked epilogue PDF is next → `notes/cubic-threefolds-tasks/c930-categorical-direct-qdm-paper-preparation.md`.

### C978

- **C978 `[cubic-threefolds]` [ACTIVE; FULL COLD READ ACCEPT, EXPORT VERIFIED]** — repair the exposition of `papers/cubic-stabilization-m1/`: improve the theorem-first narrative, local transitions, notation onboarding, and proof-roadmap clarity while preserving the accepted mathematical claims, hypotheses, proof dependencies, citations, and formal-provenance interfaces; the QDM, “even,” and “generic” are introduced before use, the reader-facing manuscript uses standard mathematical language, and a full cold-read protocol accepts the manuscript and all fourteen PDF pages; final optional copy edits are synchronized at `cf56c9b44`, standalone `c52be41`; C978 remains active by author instruction → `notes/cubic-threefolds-tasks/c978-cubic-m1-exposition-repairs.md`.

### C963

- **C963 `[cubic-threefolds]` [QUEUED AFTER C958; PROOF-PRODUCING STABLE-RATIONALITY WORKBENCH]** — turn C958's accepted ground-field maps into a reusable exact workbench that emits compact straight-line programs, localized forward/inverse certificates, exceptional-locus data, and measured degree/height/formula-size profiles; expose the one-extra-variable cancellation geometry and rational-point/function-field operations without claiming uniform complexity, finite-field applicability, or a general rationality decision procedure beyond proved gates → `notes/cubic-threefolds-tasks/c963-stable-rationality-workbench.md`.

### C966

- **C966 `[cubic-threefolds]` [LATER TRIAGE AFTER C965; REMAINING ALGORITHMIC IMPLICATIONS]** — deduplicate and rank the remaining cubic-threefold applications: broader constructive stable-rationality solving, exact stabilization-level certificate standards, modular recognition of special fibres, integral lattice algorithms for cycle questions, and reusable proof-certificate protocols; run only bounded feasibility probes, identify theorem and source gates, and recommend promotion or closure without opening implementations or manuscript claims → `notes/cubic-threefolds-tasks/c966-algorithmic-implications-triage.md`.

### C914

- **C914 `[cubic-threefolds]` [ACTIVE; BOTH COMPARISONS DECIDED; MANUSCRIPT RESTATEMENT OPEN]** — the pencil contains the Fermat cubic threefold; all but finitely many members are outside the Yang--Yu--Zhu coprime-degree locus, since every member of that normal form has an Eckardt point and the generic pencil member has none; and Voisin's criterion is unreachable by any elliptic-product route, because the exotic two-primary gluing kernel leaves `1 + 4` as the only odd-degree product shape.  What remains is to restate the pencil's contribution in the epilogue introduction and its novelty ledger; C921 owns the residual Voisin gate → `notes/cubic-threefolds-tasks/c914-a5-pencil-vs-coprime-degree-locus.md`.

### C910

- **C910 `[cubic-threefolds]` [ACTIVE; STANDALONE PAPER-BUNDLED LEAN COMPANION]** — formalize the cubic-stabilization epilogue in the Mathlib-only package `papers/cubic-stabilization-m1/lean/`, under the C879 paper-facing namespace `TavisRuddFiniteGeom.Papers.CubicStabilizationM1`, with reviewer entry point `PaperInterface` and machine audit `Verification/AxiomAudit`; require the full referee-facing source-prose standard, explicit literature-input boundary, exact terminal and manuscript-claim map, deterministic release identity, stale-artifact rejection, and exporter verification; do not duplicate sources under the shared `lean/TavisRuddFiniteGeom/` tree or a second Lean repository → `notes/cubic-threefolds-tasks/c910-cubic-stabilization-lean-companion.md`.

### C907

- **C907 `[cubic-threefolds]` [ACTIVE; SILVER `X x P^1` CLOSED; GOLD `m=2` OPEN; PLATINUM ALL-`m` OPEN]** — Gold is reduced to a minimal nilpotent `K[N]` packet on the whole generalized `zeta_6` sector: endpoint `J_3`, strict blowup biproducts, and no center `J_3` imply irrationality.  A `J_3` requires `nu_6>=6`; the two-block strictness obstruction is one explicit `Ext^1_(K[N])` class.  The first genuine ungraded extension pilot is `Bl_(X x p)(X x P^2)=X x F_1`; `Bl_X P^5` is only one-dimensional normalization.  For `N_L=1-(tensor f^*O_(P^2)(1))`, projection formula gives strict relative Orlov blocks and the endpoint `J_3`.  More sharply, on a graph resolution of `P^5 dashrightarrow P^2`, `N_L^2` cuts every exceptional-divisor generator to support of dimension at most two.  Thus one exact localizing, Orlov-additive, `K_0`-linear/derived-Gysin `Phi_6` packet functor vanishing on all low-dimensional supports would kill every base-ideal extension and prove `m=2` by relative factorization.  A formal-space projector is too weak, and linear projection shows raw `K_0` can already create `J_3`.  Higher codimension needs a non-split exceptional string, so this Gold mechanism does not naively extend to Platinum.  The separate toric leaf has rank four but still needs oriented tame residual-pair excision for the directed `P^3` matrix.  No Paper V or Lean promotion → `notes/cubic-threefolds-tasks/c907-quantum-monodromy-stabilization.md`.

## `golden`

### C845

- **C845 `[golden]` [ACTIVE; PAPER FF + PDF/DOI README AT 42794F25; STOPPED AT MISSING GUARDED FINITEGEOM EXPORTER CONTRACT]** — prepare the authoritative paper package and narrow Golden Lean trust roots for guarded, exporter-only materialization into `~/src/math-papers/golden-quantum-statistics` and canonical `~/src/lean/finitegeom`; by explicit user instruction the exporter-produced sixteen-page paper tree, relative PDF link, and Zenodo DOI badge were locally fast-forwarded onto the existing standalone history at `42794f25`, with no push, tag, remote mutation, or formal-companion declaration; canonical Lean materialization still awaits the exact source-to-base exporter contract frozen in the C845 report, and the suffixed finitegeom clone remains read-only superseded evidence → `notes/golden-tasks/c845-golden-full-forward-export-preparation.md`.

## `crowns`

### C394

- **C394 `[crowns]` [QUEUED; portable curve Schreier and finite-phase resource theorem]** — generalize C389 from `P1` to faithful finite automorphism groups of smooth projective curves, proving exact-degree free Cayley layers with multiplicities `|H|^-1 sum_(e|d) mu(d/e)#X(F_(q^e))` above the bounded fixed-point degree; then prove the consumer-independent finite normal-fan phase, support-function, convergence, and mixed-volume theorem for every Minkowski-additive convex resource functor, with a hard curve/higher-dimension boundary and optional bounded stabilizer-layer appendix → `notes/2026-07-20-c394-portable-exact-degree-curve-base-change.md`.

## `gem-mining`

### C1000

- **C1000 `[gem-mining]` [QUEUED; INDEPENDENT OPEN-PROBLEM WIN]** — pick, by a one-day feasibility spike, one of: (a) the exact equiangular-line maximum `M(18) in {57,58,59}` via the complete Seidel-spectrum census already queued as C737 (absorb C737 if chosen), or (b) completion of the length-333 Legendre-pair census (absorb C741's 108 exact lift representatives), which either yields a structured second construction of order 668 or proves no multiplier-invariant Legendre pair of length 333 exists; the spike must state the candidate's compute bound and the certificate it would emit before committing. Whichever is chosen, follow the novelty-extraction and literature-audit conventions before any write-up; the other candidate returns to the queue unchanged.

### C741

- **C741 `[gem-mining]` [IN PROGRESS; 108 EXACT LIFT REPRESENTATIVES REMAIN]** — decide residual fixed common-multiplier LP(333) IDs 4 and 5; both separate 9- and 37-compressions are exactly feasible, the complete 9-compression lift frontier is 648 normalized pairs and 108 affine/decimation/swap representatives, and the compression recovers the unique minus among fixed positions `{0,111,222}` modulo 6, splitting the frontier into 36 same-point and 72 different-point cases; finish with selector-aware proof-carrying exact lifts or a mixed-character obstruction, without overclaiming unrestricted Hadamard order 668 → `notes/2026-07-31-c741-hadamard-668-ids4-5.md`.

## `quantum-codes`

### C967

- **C967 `[quantum-codes]` [QUEUED; STANDALONE COMPILER/RESEARCH GATE]** — build an exact jet-quotient quantum-code compiler for the odd-prime-power family `[[q+1,2,(q-5,4)]]_q`, emitting check matrices, logical jet quotients, Pauli pairings, and independently replayable distance certificates; certify the `q=11` and `q=13` specializations, and separately test whether the Schur-algebra structure yields a transversal non-Clifford logical phase, without assigning the construction to the Clebsch or AME manuscripts or claiming novelty before a dedicated audit → `notes/quantum-codes-tasks/c967-jet-quotient-quantum-code-compiler.md`.

## `reed-solomon`

### C881

- **C881 `[reed-solomon]` [COMPLETE 2026-08-07 PENDING ARCHIVE; SUCCESSORS C882 AND C883]** — Krishna Kaipa persona review of the beyond-redundancy-four PRS paper.  The cubic-pencil literature gap, the per-stratum pre-emption verdict, and the \(W_f\cap\mathcal O_3=\varnothing\) formulation are done and committed in Version 2.  Remaining: identify \(Y_f\) with the Kaipa--Pradhan elliptic curve, decide whether their exact incidence count can replace rather than accompany the redundancy-five proof, recast the sporadic inventory by \(j\)-invariant and Frobenius trace, promote the split-witness count, and give the Hankel--Plücker map and the maximal Lucas carrier invariant formulations → `notes/reed-solomon-tasks/c881-kaipa-persona-review-followup.md`.

### C915

- **C915 `[reed-solomon]` [ACTIVE; ALL SIX EDITS APPLIED AND CHECKLIST GREEN 2026-08-16; INDEPENDENT DEPENDENCY, HOSTILE-R10, AND PRIMARY-SOURCE AUDITS OPEN]** — apply the external referee correction package for the beyond-redundancy-four PRS Version 2 draft, in its mandated order: expand Theorem D.10's all-field complement argument (E2), supply the self-contained characteristic-two transverse proof for Proposition D.12's R10 branch (E1), correct the characteristic-five R9 modular lift from line to point (E3), repoint every Blokhuis--Pellikaan--Szőnyi locator to the published numbering (E4), resolve the Proposition 6.1 coordinate-sign ambiguity (E5), cite Aubry--Perret rather than bare Hasse--Weil in Lemma B.4 (E6), then run the specification's build/logic/source checklists and its five closing audits, honouring the primary-source guardrails on claims that must not be "corrected". Input spec: `notes/reed-solomon-tasks/c915-v2-referee-correction-input.md` → `notes/reed-solomon-tasks/c915-v2-referee-corrections.md`

### C969

- **C969 `[reed-solomon]` [ACTIVE; TRUTH/ACTION SCHEMAS, EXACT LOCATOR CORE, SEMILINEAR FALLBACK, AND FROZEN R5--R7 ADAPTERS GREEN; FAST TERMINAL SOLVER AND UNIFORM ADAPTERS OPEN; ABSORBS C607/C608]** — build an exact structural PRS deep-hole classifier and decoder for redundancies `5` through `10`: from a projective syndrome, compute exact distance and a nearest word, decide deepness on the proved coding domain, identify its Hankel/pencil/net/polar/Lucas family and full semilinear orbit, return a canonical representative with transporter, and emit a replayable obstruction to every closer codeword; retain C607's general fixed-parameter split-locator decision/recovery theorem and C608's explicit R5--R7 decoder/operation-count gates, distinguish split-free syndrome classification from covering-radius promotion, return an explicit unsupported/unresolved verdict outside frozen theorem domains, and benchmark against brute-force syndrome search without changing either PRS manuscript → `notes/reed-solomon-tasks/c969-structural-prs-deep-hole-classifier.md`.

### C970

- **C970 `[reed-solomon]` [ACTIVE; TOOLKIT/PAPER/EXPORT/EXTRACTION GATES GREEN; GF16/R11 EXHAUSTIVE RELEASE GATE AWAITS APPROVAL]** — package the classifier as Projective Reed--Solomon Toolkit in the authoritative `papers/high_weight_grs_cosets/software/projective-reed-solomon/` subtree; make the crate independently buildable with local registries, locks, licensing, citation, and documentation; upgrade the manuscript's algorithm/theorem boundary; integrate software checks and hashes into the supplement, release manifest, and deterministic exporter; and require a clean history-preserving standalone extraction dry run without broadening the proved classification domain → `notes/reed-solomon-tasks/c970-high-weight-grs-cosets-software-packaging.md`.

## `relconic`

### C1015

- **C1015 `[relconic]` [IN PROGRESS; UNIVERSAL K10 PENCIL THEOREM AND THREE-HESSE-LINE HUMAN PROOF LANDED; NINE-POINT GAIN BALANCE OPEN; NO MANUSCRIPT OR ERGODIS SOURCE EDITS]** — star interpolation plus parity-pencil closure classifies all 396 one-factorizations: 395 close directly, while three affine lines kill the unique `AG(2,3)` exception whenever `2!=0` and characteristic two closes combinatorially; for the regular class this forces all 28 Ree lines and Nagy's exact `F_8` boundary, uniqueness, and subplane containment; the closest-seed citation audit is clean and the next mathematical gate is whether nine-point matching concurrence forces balanced edge gain → `notes/2026-08-30-c1015-match9-global-obstruction.md`.

### C949

- **C949 `[relconic]` [ACTIVE; USER-REOPENED SHARPNESS]** — Prove the sharp asymptotics for the minimum size of complete `(2q/3+1)`-arcs. Landed: the `q^2/3+5q/3-o(q)` lower bound, endpoint exclusion, nine signatures, quadratic Mason separation, bounded Redei state `(E,U)`, and a marked selector within two monomers of a matching. The inverse duplex is excluded for ternary `q>=27`; ordinary projections have degree-five residuals with only `O(q)` saturation defect. Global division gives an orbit-safe quadratic quotient gate; the six-boundary valuation now forces every nonmissing label into the double/quadruple root support. Open: the matching near-base construction and all-signature classification. Highest EV is lifting that local marked-root divisibility across slopes with split norm/Witt data, alongside testing the q27 post-terminal filter. Start at `notes/2026-08-24-c949-sharp-higher-arc-asymptotics.md`; its archive and focused snapshots are linked there.

### C900

- **C900 `[relconic]` [ACTIVE; ROUND 1 HUMAN-PROOF/EXPOSITION GREEN; REVIEW/FIX/SEALED-RE-REVIEW LOOP REMAINS OPEN; DOSSIER QUARANTINED]** — run independent persona cold reads of the Arcs paper's human proofs and exposition from isolated packets; freeze and synthesize the reports; implement accepted manuscript fixes; and repeat context-clean reviews, while keeping the reviewer dossier out of ordinary `relconic`, manuscript, and Lean routing. Round 1 froze four independent `MINOR` reports with no false theorem or central gap, repaired every accepted scope/convention/citation/exposition finding, and closed with sealed geometry and citation `GO` gates → `notes/2026-08-09-c900-arcs-paper-reviewer-dossier.md`.
