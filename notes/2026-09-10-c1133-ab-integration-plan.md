# C1133 — A/B integration plan and architectural alternatives

**Lane:** `cubic-threefolds`. **Date:** 2026-09-10.
**Status:** plan and fresh editorial referee feedback complete. The referee
recommends P with revisions; this version incorporates responses, not a
second independent acceptance of the revised text. Planning only; no manuscript
reorganization, new theorem promotion, Lean operation or export is authorized
by this document. The user requested a plan and referee feedback on alternatives.

## 1. Objective and fixed mathematical boundaries

Keep the first headline unchanged:

> For every smooth complex cubic threefold X, X×P¹ is irrational.

Integrate A and B without making either depend on unpublished or assumed
transport properties. A says rationality is unchanged by one stabilization
for every smooth complex Picard-rank-one Fano threefold (seventeen families).
B says that for X,Y in the nine detected families, birationality of X×P¹
and Y×P¹ implies H³(X,Q)≅H³(Y,Q) as rational Hodge structures.
Identify those families in the introduction itself: index two, degrees
1,2,3; and index one, genera 2,3,4,5,6,8. The B statement must not depend
on an unexplained phrase “detected families” or a table twenty pages later.
Do not silently enlarge B to all seventeen families, integral cohomology,
polarized identification or cancellation for every cubic.

C is very-general-source cubic/quartic cancellation with arbitrary smooth
same-family target. D is bounded-extension-degree finiteness of geometric
cubic partner classes over a fixed finitely generated characteristic-zero
field; it counts neither twists nor effective bounds. Their narrower
hypotheses never qualify A, B or the cubic headline.

The primary audience is birational geometers. Adjacent readers are algebraic
geometers familiar with cohomology and Hodge theory but not quantum
connections; quantum-cohomology specialists must also be able to locate and
audit the actual source-map, completion and lattice arguments.

## 2. Proposed hierarchy: one paper, two complete reading routes

**First headline:** cubic theorem, prominently stated and proved directly.
**Numerical theorem A:** the all-family extension and endpoint of Part I.
**Structural theorem B:** the principal result of Part II.
**C/D:** applications of B, not additional coequal headline mechanisms.

The introductory presentation order is cubic → A → B. Logical dependence
is different: A includes the cubic assertion as a special case, but the
reader sees a direct cubic proof before the family extension. Neither A
nor the cubic proof uses B. A and B use a common operation/vanishing method;
the Hodge branch requires additional fixed-base/full-fiber work.

    numerical transport + low-dimensional vanishing
          + cubic calculation + specialized P¹ lemma → cubic theorem
          + nine-family/parity inputs                → A

    equivariant full-fiber transport on fixed bulk base
          + safe whole-primary selection + endpoint H³ recovery → B

    B + rational generic Torelli → C
    B + arithmetic intermediate Jacobian + bounded-degree isogeny theorem
      + finite kernels + polarization finiteness + cubic Torelli → D

This is a conceptual dependency sketch, not a statement that the full-even
and Hodge-fixed generic decompositions are identical for arbitrary varieties.
The fixed-base injection must be proved directly in the Hodge branch.

## 3. Concrete table of contents and reader outputs

Page ranges below are drafting budgets, not measured lengths or permission
to omit a necessary proof. Choose a target only after assembling the prose.

| Section | Job and required reader output | Initial budget |
|---|---|---|
| 1. Results and proof mechanism | Cubic headline on page 1; exact A/B scope; why surface centers matter; one reading map; closest prior-work comparison once | 3–4 pages |
| Part I / 2. A numerical obstruction | Define original lattice, eligible rank-two block, canonical residue; prove local transport; explain auxiliary generic parameters | 4–5 |
| 3. Blowups and low-dimensional centers | Match actual comparison, give faithfulness mechanism, prove vanishing including ruled/elliptic case, deduce fourfold invariance | 3–4 |
| 4. The cubic and one stabilization | Compute cubic residue, establish full-bulk P¹ continuation, finish the contradiction; reader can stop here | 2–3 |
| 5. Picard-rank-one Fano threefolds | Introduce parity/rank-three selector only now; nine-row table; all-member geometric inputs; prove A; complete numerical endpoint | 3–4 |
| Part II / 6. Hodge conservation | State B and new obligations; fixed bulk base/full fiber distinction; equivariance, selection, cancellation; complete proof of B | 4–6 |
| 7. Torelli and arithmetic consequences | State C/D with exact independent scope and give their short deductions; remove from body if they expand disproportionately | 2–3 |
| Technical appendices | Full coefficient realizations; detailed local gauges and all-bulk continuation; finite provenance and exceptional model bridges | provisionally 8–12 |

These budgets total **21–29 body pages and 8–12 technical appendix pages**,
before references or retained legacy extensions. They are not a promise of
a short paper. Record body, appendices, references and optional legacy
material separately in the first assembled PDF; the total governs the
packaging decision. Do not hide growth by moving substantive contributions
to appendices or excluding their pages from the comparison.

Do not repeat an introduction at every level. Section 1 explains the idea;
the reading map identifies safe first-pass omissions; section openings state
only the new task. Section 6 opens with what must be added to Part I, not a
second development of quantum cohomology. If these budgets fail, evaluate
the alternative architectures in §6 rather than compressing crucial proofs.

## 4. Main-text/appendix boundary

### Material that must remain visible in the body

- Exact theorem scope and each added hypothesis at its first use.
- The geometric problem created by surface centers in a fourfold factorization.
- The definition of the selected block and why its original/canonical
  lattice matters. A punctured-disc isomorphism would not suffice.
- The actual reduced-domain comparison lemma and a concise proof of its
  central idea: independent divisor characters separate raw Novikov
  collisions, by a finite Vandermonde argument. The original z-map and its
  inverse preserve the lattice. Refer to the appendix for completion details.
- Whole-primary selection before odd extraction. No replacement of full
  even ranks by dimensions of invariant vectors.
- The ordering proving surface vanishing without assuming the fourfold
  invariant under construction, including the elliptic exception.
- The P¹ lemma's full-even-bulk scope and its use of cyclic persistence;
  small tensor identification alone does not prove the generic assertion.
- In B, the fixed base retains the full cohomology fiber; direct fixed-base
  faithfulness, equivariance and rational cancellation have exact statements
  and their essential proofs in the body. In particular, show whole-primary
  selection, equality of twice the endpoint H³ classes, cancellation,
  pure-weight recovery and descent to Q there. Appendices may carry longer
  coefficient constructions; they do not substitute for B's reasoning.

Section 5 must prove the additional parity selector's operation law and
surface vanishing after introducing it. This is a separate finite-dimensional
argument; the preceding even-fiber rank-two construction does not establish
it automatically. Part I therefore moves from the even connection to the
full supermodule over the even bulk base at exactly this point, without
introducing a Hodge-group action. State that change explicitly. For the
dangerous even-rank-three surface factor, explain why b₂=1 forces the odd
fiber to vanish. The ruled-product case and blowup operation must cover
this selector as well as the earlier rank-two count.

### Details that can move to appendices

Graded-completion constructions, longer coefficient identifications and
source equation matching; off-diagonal gauge calculations beyond the
displayed cubic residue; technical proof of cyclic persistence; detailed
all-member matrix provenance/deformation bridges. The main table retains
each bridge's scope and exact source pointer so completeness is not hidden.
Appendices belong to the paper and must contain finished proofs, not links
to working audit notes in lieu of proofs.

The exact computation/evidence bundle stays available through the
verification references. Search logs, referee exchanges, hash tables and
task history do not enter the mathematical narrative. Formal coverage stays
accurate even when its strength is below the unconditional written theorem.

## 5. Reader-facing design decisions

**Abstract:** first sentence cubic theorem, second A, then one sentence
giving the surface-vanishing mechanism and one stating B. Mention C/D only
if space remains without turning the abstract into a theorem inventory.
No general projective-bundle theorem or optional pencil claim is advertised.

**Introduction:** one exact B statement must appear early enough that it
cannot look like an appendix bonus. Explain rational Hodge conservation in
one sentence; do not introduce universal Hodge groups before the reader
needs their role. Explain once that generic refers to quantum parameters,
not a restriction to a general member of the geometric family.

**Notation:** use established current semantic labels; retain the exponent
count for the cubic. Introduce the stronger residue count at its first
resonant application, and the rank-three odd selector in §5. In §6 name the
Hodge-valued refinement distinctly; do not reuse a numerical symbol for it.
Define specialized vocabulary with one operational gloss at first use.

**Model example:** the cubic illustrates the rank-two nonresonant mechanism.
Explicitly state that A additionally uses resonant rank two and a rank-three
parity selector. Do not pretend the cubic illustrates every later case.

**Reading map:** statements and overview give a complete account of what is
proved and why it matters; §§2–5 give the numerical proof; §6 adds Hodge
conservation; appendix pointers allow verification of every technical step.
“May skip on a first reading” never means the omitted step is dispensable
to correctness. No result depends on a reader's accepting an assumption box.

## 6. Serious alternatives for the referee

| Architecture | Benefit | Cost / failure risk | When to choose |
|---|---|---|---|
| P: cubic-first, A completes Part I, B completes Part II; C/D brief | Preserves headline and gives two complete routes; retains structural contribution in one paper | Long appendices or duplicated transport could make the split cosmetic | Default proposal if §6 stays focused and shared material is proved once |
| Q: one structural A/B theorem package first, cubic as its first corollary | Strongest apparent methodological unity; economical for specialists | Delays the accessible cubic argument and front-loads fixed-base machinery | If a compact common construction genuinely shortens the proof without conflating the two bases |
| R: numerical paper through A; separate B–D paper | Clean audience separation and short first paper | Splits the conceptual contribution; repeats common setup; companion must stand independently | If B's additional construction dominates the numerical paper or requires extensive independent development |
| S: cubic/A main text; B's statement in introduction, full proof in appendix | Short main narrative while retaining all results in one object | Hides a principal contribution; may make B look insufficiently integrated or inspected | Only if B's additional argument is mostly technical and genuinely short conceptually |

**Referee's additional option P′:** retain P with C in the body and D in a
short application appendix. If arithmetic alone causes an overrun, this is
the first adjustment to test before separating B. D keeps a precise
discoverable statement in the consequences section and a complete proof in
that appendix; its independent arithmetic inputs remain explicit.

The referee should recommend an architecture, identify conditions that would
reverse that recommendation, and propose a better alternative if appropriate.
No venue prediction or prior favorable mathematical review should decide
this question. This review evaluates exposition and proof placement, not
certification of the underlying new geometric results.

## 7. Implementation sequence and acceptance gates

1. Freeze the current manuscript as the comparison baseline; preserve stable
   semantic theorem labels. Inventory statements, imports, evidence links and
   applications before moving them. Read the annotation/mirror/Lean guides
   when their respective operations are actually triggered.
2. Draft the new introduction, theorem hierarchy and section openings first.
   A statement-only cold reader must recover exact scopes, the relation of
   the cubic theorem to A, independence of A from B, and B→C/D.
   Before moving existing manuscript files, assemble a complete prototype
   of B's essential body proof in a working note. This makes the P/R decision
   concrete early, rather than discovering the need to split after a large
   reorganization. The prototype is a drafting test, not an extra theorem.
3. Consolidate the numerical proof and P¹ replacement. Remove only core IK
   dependencies actually replaced; any retained general bundle theorem
   keeps its own dependency. Prove the geometric instantiation of every
   internal transport lemma.
4. Integrate §5 and its finite/geometric appendix, preserving all-member
   coverage. The eight rational controls use geometric rationality, not
   inference from vanishing quantum signatures.
5. Integrate B, explicitly adding the full-fiber fixed-base arguments.
   Confirm the prototype's measured duplication and new material before
   locking P versus R.
   A draft requiring more than roughly 6–8 genuinely additional body pages,
   or substantial repeated setup, triggers review of R. This is a discussion
   threshold, not a page cap or automatic instruction to split.
6. Place C/D only after B; relocate optional additive, spectral, motive and
   pencil branches by explicit scope/ownership disposition, not silent
   deletion. Keep conditional companions out of the headline dependency path.
7. Update statement/coverage/source/evidence records with the changed proofs;
   perform required builds and annotated-artifact checks using authorized
   entry points. Do not convert written-proof acceptance to full Lean coverage.
8. Obtain cold reads of the assembled PDF from a primary-audience specialist
   and an adjacent-field reader. Record correctness confidence and
   accessibility separately; inspect the rendered hierarchy and appendix
   pointers. Only then decide submission packaging and any synchronization.

**Planning completion:** referee report obtained, material objections
addressed in the revised plan, implementation map available, no manuscript mutation.
**Integration completion:** assembled paper passes the tests above. The
plan's approval is not the assembled paper's final referee acceptance.

## 8. EJ + TT / Mystery ledger

The complete cold report is `2026-09-10-c1133-ab-plan-referee.md`, commit
`3ec4ac1b2`, reviewing the frozen draft `dcaf82257`. It favors P, with R as
the fallback, Q requiring positive evidence of a shorter master proof, and
S the least attractive default. It adds P′ above. No external sources or
prior referee reports were read by this editorial referee; no theorem
certification or venue verdict was attempted.

| Referee objection | Response in this plan / migration map |
|---|---|
| Rank-three selector introduced after blanket vanishing | §4 now requires its own operation and surface proof at §5, and states the change to full supermodule explicitly |
| B's body proof could disappear into appendices | §4 specifies the complete conceptual chain that stays in the body, through weight recovery and rational descent |
| B→C/D conceals imported premises | §2 diagram now lists rational Torelli and the independent arithmetic inputs |
| Total length and retained results undercounted | §3 reports 29–41 planned pages before references/legacy; migration map assigns every current section and named application |
| Nine-family membership unexplained | §1 gives the exact family list for use before B |
| Arithmetic might force unnecessary split | P′ moves D's proof before considering removal of B |
| Need evidence before locking architecture | Step 2 adds a complete B body prototype before manuscript file moves |

The EJ + TT pass exposed two cheap further improvements. Use one faithful-map
lemma with explicit hypotheses and check them separately on each base;
reuse proof logic without conflating numerical and Hodge-fixed decompositions.
Measure three reader-facing quantities: pages to the completed cubic proof,
pages added exclusively for B, and total pages including references and
appendices. Count substantive repetitions separately. These measurements
test the architecture's purpose better than a single total-page target.

The implementation inventory is `2026-09-10-c1133-ab-migration-map.md`.
It preserves the general threefold/motivic claims with their actual IK
dependencies in optional material, distinguishes the CH₀ bundle formula,
and separates the rank-three lattice limitation from A's parity argument.
This resolves the statement-disposition gap at the planning level; final
packaging can change only with an explicit updated disposition.

**Mystery ledger:** no mathematical mystery is created by the exposition
choice. The remaining editorial uncertainty is measured B length and
duplication; the early prototype and assembled-PDF gate own it. The plan
referee has not reread this revised plan or a newly assembled manuscript.
