# C816 — Paper III recognition theorem: literature gate and Theorem D promotion

**Lane:** `clebsch`
**Status:** rewritten 2026-08-19. The integration this card was created for is
already in the manuscript; what remains is the audit gate that was never
discharged for it, plus three unlanded upgrades. Paper promotion authorized by
this task.

## Why this card was rewritten

C809's characterization was promoted into Paper III ahead of the serialized
route, in commit `41d989eba` "Add Paper III recognition upgrades". Verified in
the working tree on 2026-08-19:

- `thm:triangle-pfaffian-recognition` stands at
  `papers/clebsch-passages/sections/05-golden-operator.tex:311`, with the
  translation-invariance proof in the main text, the degree argument forcing
  \(n/2=3\), the pentagon classification on the sign locus, the sign identified
  with the orientation character, and the boundary sentence recording that the
  remaining weighted solutions of \(A^2=\lambda I\) are unclassified.
- The paragraph "What the four descriptions do and do not assert" at line 170
  states that the compound diagonal and the commutator Pfaffian are universally
  identical and that only the triangle comparison is matrix-specific, which is
  the old card's manuscript item 3.
- Row \(r=2\) of table (5.1) now reads `+-+-+---++--+++-+-+-`, the corrected
  string. The required manuscript correction is landed. Public versions 1 and 2
  still carry the defective row `+-+-+---++--++-+-+-+`; that is expected, since
  the correction was always scoped to a forward version.

Old manuscript items 1 through 5 and the table correction are therefore closed.
They are not repeated below. What follows is the surviving scope.

## Objective

Discharge the priority audit that the promoted recognition theorem has never
received, land the Theorem D rigidity statement and the two upgrades that make
it structural rather than computational, and take the remaining exposition
decisions the promotion left open.

## Entry gates

1. Read `papers/style-guide.md` before touching the manuscript.
2. Work item 1 gates every novelty or priority sentence about the recognition
   theorem, and gates work item 4 entirely. **Gate open since 2026-08-20:** the
   audit is discharged and row `OPER-5` exists, so novelty-sensitive prose may be
   written provided it preserves that row's boundary.

## Work item 1 — the recognition theorem's literature audit — DISCHARGED 2026-08-20

**Outcome:** nothing pre-empts the recognition theorem, so no adjacent-crown
extraction is triggered and work item 4 is ungated. Row `OPER-5` is in
`papers/clebsch-passages/literature-boundaries.md`; the search record, read
depths, screened citing sets, and access gaps are in
`notes/2026-08-20-c816-recognition-theorem-literature-audit.md`. The audit
licenses "we prove" and "we have not located", never "first" or "new", and every
negative keeps "to our knowledge".

Three findings bear on the manuscript and are recommendations for this task's
owner, not applied by the audit pass:

1. The ingredients now have named classical owners the manuscript does not cite.
   Beauville settles in general which forms are Pfaffians of skew matrices of
   linear forms and Tanturri gives the constructive cubic-surface case, so a
   \(6\times6\) linear Pfaffian representation is a known object; the triangle
   cubic's coefficients are order-three cycle products, half the principal
   \(3\times3\) minors of a hollow symmetric matrix, in Huang and Oeding's
   cycle-sum coordinates. Adding the identity \(\det A[S,S]=2a_{ij}a_{jk}a_{ki}\)
   is what tells a referee the two cubics are minors of the same matrix.
2. The conclusion \(A^2=\lambda I\) has a standard name: a scaled hollow
   symmetric involution, equivalently a constant-diagonal rank-three projection,
   equivalently an equal-norm tight frame of six vectors in \(\mathbf R^3\); the
   equal-modulus case is the classical conference, regular-two-graph, and
   equiangular-tight-frame correspondence. **This confirms Theorem D's counts
   from an independent direction and is a free upgrade to work item 2 sub-item
   1.** The frame description gives the conference tangent space dimension
   \(1+(9-5)=5\) — one scaling direction plus \(\dim\mathrm{Gr}(3,6)=9\) minus
   the five independent constant-diagonal equations — which is exactly the
   five-dimensional kernel the sixteen-variable conference count reports, and
   its non-scaling part is exactly the "four" that sub-item 1 wants to stop
   presenting as a numerical coincidence. Sub-item 1's module statement then
   says *which* four-dimensional space that is; the dimension itself no longer
   needs a computation.
3. The boundary sentence after the theorem names the wrong set. The solutions of
   \(A^2=\lambda I\) at order six form a family of dimension at least four; what
   is unclassified is the set of weighted solutions of the *proportionality*,
   which Theorem D pins to the scaling line at either golden representative.

The closeout pass added a fourth item, with its own evidence bundle in
`notes/2026-08-20-c816-extremal-minor-census.{md,py,json}`. Over all 32768
hollow symmetric sign matrices of order six, being a conference matrix, having
every complementary \(3\times3\) minor nonzero, and satisfying the cubic
proportionality hold on exactly the same 384 matrices — the pentagon's
switching-and-relabelling orbit — with proportionality constants exactly
\(\pm4\). Two consequences for this task. The factor \(4\) in the proof is
forced, not calculated: a \(3\times3\) sign matrix has absolute determinant
\(0\) or \(4\) and nothing else, so replacing "its complementary-minor
calculation gives the factor \(4\)" with that reason costs one sentence and
removes the theorem's last unexplained number. And the equal-modulus half may
admit a bare nondegeneracy hypothesis in place of the cubic identity — but that
is census evidence at order six, not a proof, and must not enter the manuscript
as a theorem without one. The route to try is the parity reduction in the bundle
report: a \(3\times3\) sign matrix is nonsingular exactly when the product of
the three pairwise inner products of its rows is \(-1\).

The audit's sharpest limitation, carried forward: MathSciNet is unauthenticated
and Google Scholar blocks automated access, so no article-body index was
searched and the negative rests on title, abstract, and metadata indexes plus
term searches of cached full texts.

The original scope statement follows, retained for provenance.

**This is the exposed item.** The theorem is in print-track prose with no
priority boundary of its own. `papers/clebsch-passages/literature-boundaries.md`
carries rows for the four-descriptions identification (`OPER-1`), the exchange
spectrum (`OPER-3`), and the reconstruction theorem (`OPER-4`), but no row for
the converse, and the operator section carries no "to our knowledge" sentence
near the theorem. The paper is not overclaiming today, because it claims nothing
there; the risk is a referee asking who else has characterized the order-six
conference class by Pfaffian--triangle proportionality and finding the question
unasked.

Run a publication-grade audit under `notes/literature-audit-conventions.md`
through the Pfaffian-commutator, compound-minor, determinantal-representation,
conference-matrix, and tight-frame literature. Record every source's read depth
and every uncovered service. Then add an `OPER` row for the recognition theorem
stating what is classical, what is paper-owned, and the exact wording the
negative supports. If prior work pre-empts the theorem, run the bounded
adjacent-crown extraction under `notes/novelty-extraction-conventions.md` before
editing any headline claim.

Two audits already cover adjacent ground and should be read first rather than
repeated: `notes/2026-08-05-c876-two-graph-literature-audit.md` for the
two-graph side, and `notes/2026-08-07-c880-literature-audit.md` for the
principal-minor and determinantal side.

## Work item 2 — Theorem D promotion — LANDED 2026-08-20

Theorem D is in the manuscript as `thm:golden-equality-rigidity`, stated as
proved rather than certified, with the constant-rank step, the derivation of the
reduced table, and the table itself carried in the text. Sub-items 1, 2 and 3
were taken; sub-item 4 was superseded by the stronger
`prop:nonsingular-complementary-minors`, which also explains the factor \(4\)
where the recognition proof produces it; sub-item 5's characteristic-five
material was declined as that report recommended. The frame dimension count went
in with it. The table is certified against the manuscript's own representative
and sign convention by
`notes/2026-08-20-c816-theorem-d-table.{md,py,json}`; the paper-local scaffold
and manuscript-build gates pass at thirty-seven pages, warning-free.

The original scope statement follows, retained for provenance.

### Original scope

Theorem D is C809's local ambient rigidity statement: the Jacobian of the twenty
equality equations has rank fourteen at either oriented golden representative,
with kernel the scaling line. It is **not in the manuscript** — no rank
fourteen, no Jacobian, no tangent-space language appears in any section. It is
no longer backed by an external rational certificate; it has a structural proof
in `notes/2026-08-05-c815-rank-14-weighted-jacobian.md`, and the only external
ingredient left is the ordinary constant-rank theorem. The manuscript may
therefore cite it as proved rather than certified, provided it carries the
constant-rank step and the reduced table or a reference for them.

The five sub-items below are proposals to accept or decline, in descending order
of value. Sub-items 1 and 4 are positioning changes and are subject to work
item 1.

1. **Replace the numerical comparison sentence.** Theorem D's draft closes with
   "the cubic equality cuts the four non-scaling tight-frame deformation
   directions," which reads as an observation that two dimensions agree.
   Replace it with the module statement: the conference tangent space at the
   representative is the trivial-plus-four isotypic subspace of the edge module,
   the cubic Jacobian is injective on the four-dimensional irreducible, and the
   ranks fourteen and eleven are therefore one structural fact rather than two
   coincident computations. Highest-value change here, because it converts the
   theorem's weakest-sounding remark into a claim.
2. **State the eigenspace description of the splitting.** The displayed line
   \(A_0XA_0=\mu(X)A_0-5X\), obtained by multiplying the conference tangency
   condition by the representative and using \(A_0^2=5I\), makes the
   trivial-plus-four splitting an eigenspace decomposition of conjugation by the
   representative rather than the output of a character table. Two sentences,
   and it removes this theorem's only appeal to a character computation.
3. **Carry the reduced eight-by-five table with its derivation.** The table is
   the one place a reader must still do arithmetic on faith. Give the
   multilinear difference rule, one worked row, and the statement that the
   remaining rows follow identically. Keeping it as an unexplained display is
   what makes Theorem D read as certified when it no longer is.
4. **Add the complementation antisymmetry as a remark.** For every symmetric
   zero-diagonal matrix the complementary third-compound coefficients are
   negatives, so on the locus the complementary triangle coefficients are too.
   That recovers the ten-plus-ten two-graph split the series elsewhere assumes,
   in three lines, and connects Theorem D to the orientation-torsor material
   instead of leaving it isolated.
5. **Keep the characteristic-five theorem out of the manuscript.** It is a real
   theorem — the modular kernel is exactly the vanishing-multiplier hyperplane
   of the conference tangent space, proved in the same report — but Theorem D is
   a statement over the reals and the modular material would be a digression.
   The one exception worth a footnote is that five divides the reduced table's
   four-by-four minor for every choice of rows and every orbit basis, since a
   reader who computes the table will notice the \(-5\) and wonder.

**Do not carry forward a retracted reading.** An earlier version of the C815
report observed that the Jacobian's rank modulo five equals the conference
tangent rank, both eleven, and presented that as suggestive. It is not: the
conference count is sixteen variables against a five-dimensional kernel and the
modular count is fifteen against four, so two offsets cancel. The containment of
the modular kernel in the conference tangent space is the real fact and is
stronger than the coincidence it was mistaken for. Neither the coincidence nor
any sentence resting on it may enter the manuscript.

## Work item 3 — the shorter balanced exchange rigidity proof — APPLIED 2026-08-20

The replacement text is in the manuscript. The switching normalization and
`R(3,3)=6` are gone from this proof; the inclusion-matrix rank formula is now
attribution rather than a dependency, with the one-element swap descent proved
in the text; and the whole-matrix fourth-trace pin `(2d-3)w = -3` both excludes
the large orders and identifies order six as the one carrying weight `-1` on
every four-set. It costs one page rather than saving space, which the
simplification note predicted the other way round. The trust manifest's
`OPER-3` row already described this proof, so the manuscript and its evidence
map now agree. Detail in
`notes/2026-08-20-c816-exchange-rigidity-and-abstract-decision.md`.

### Original scope

Still unlanded, verified 2026-08-19: the proof at
`sections/05-golden-operator.tex:455-470` continues to switch \(C\) so that all
edges at one vertex are positive and to finish through \(R(3,3)=6\).

The replacement loses both. Once the four-set weight is known to be constant,
applying the closed-walk count to the whole matrix rather than to a half
determines that constant: reading the diagonal of \(C^2=qI\) gives \(q=2d-1\),
and comparing \(2d(2d-1)^2\) with
\(2d(2d-1)+12\binom{2d}3+8w\binom{2d}4\) leaves \((2d-3)w=-3\). So \(w=3\)
forces \(2d=2\) and \(w=-1\) forces \(2d=6\), and the same equation says every
four-set of the order-six conference matrix carries weight \(-1\) — it
identifies the exceptional order instead of only excluding the others.

The full argument, the exact replacement text, and the notes on what the edit
does to the Jolliffe citation and to the verification rows are in
`notes/2026-08-06-c815-exchange-rigidity-simplification.md`. The whole chain is
formalized and gated, so this is a proposal about exposition, not about what is
proved:
`RelativeConicArcs.BalancedExchangeRigidity.not_forall_sum_closedFourWalkWeight_eq`
states the conclusion for the fourth trace of the principal block, and the
spectral translation to the exchange moment is the one step still outside Lean.
The inclusion-matrix rank citation likewise becomes attribution rather than a
dependency, since the swap descent is proved in
`RelativeConicArcs.SubsetInclusionSums`.

Note that the other two uses of \(R(3,3)=6\) in the section, at lines 551 and
635, belong to the reconstruction argument's aligned anchor and stay.

## Work item 4 — abstract and theorem hierarchy — DECIDED 2026-08-20

**Necessity is stated in the abstract; the theorem hierarchy is not
restructured.** The abstract's four-descriptions sentence is now followed by the
characterization, the local rigidity, and the sign-locus nondegeneracy form; the
introduction gained a paragraph naming the three statements after the operator
stage; and the conclusion says the agreement of the four descriptions identifies
the carrier. The source--shadow--return spine, the figure, the reading map, the
section order, and the claim identifiers are unchanged, because the recognition
theorem characterizes the carrier rather than standing on the main route and
would compete with it as a headline. No novelty adjective was introduced; row
`OPER-5` licenses "we prove" and "we have not located" only. Reasoning and the
exact changes in
`notes/2026-08-20-c816-exchange-rigidity-and-abstract-decision.md`.

Registering the two new statements was a four-file operation the scaffold gate
does not enforce: `EXPECTED_LABELS` in
`verification/extract_statement_identity.py`, the `OPER-1` row in
`verification/trust_manifest.json`, a regenerated
`verification/statement_identity.json`, and the removal of repository `notes/`
paths and a numbered workflow identifier from release-visible text. The
intermediate commit left the statement-identity gate red until these landed.

### Original scope

Gated on work item 1. The abstract still presents the source cubic as having
"four exact descriptions" — coincident realizations — and says nothing about
necessity. Decide whether the recognition theorem becomes a genuine headline. If
it does, revise the abstract, the introduction hierarchy, the operator-section
roadmap, the conclusion, and any source--operator--cubic diagram together, and
update the claim map, trust table, provenance text, bibliography, artifact
guide, and verification manifests to point at C815 and C809 with exact proof
ownership. If it does not, say so on the card and change nothing.

## Work item 5 — retire the hard-coded equation numbers — DONE 2026-08-20

The three `\tag` uses this item names in `sections/05-golden-operator.tex` were
already gone when the pass reached them. One survivor elsewhere in the paper,
`\tag{2.1}` in `sections/02-orientation-cover.tex` with a prose reference reading
"Equation~(2.1)", is now `\label{eq:branch-cycle}` and an `\eqref`. No `\tag`
remains in the paper.

### Original scope

`sections/05-golden-operator.tex` hard-codes `\tag{5.1}`, `\tag{5.2}` and
`\tag{5.3}` at lines 77, 33 and 584. The style guide forbids this because
reordering then silently breaks cross-references. Replace each with a semantic
`\label` and `\eqref`, and check every prose reference to those numbers. Cheap,
and best done in the same pass as any other edit to this section.

**Lean items are not owned here.** The C815 report proposes four Lean targets
supporting these edits — the complementation antisymmetry over an arbitrary
commutative ring, the gauge-coordinate triangle derivative and tangency
characterization, the engine identity, and the cofactor-array classification —
and recommends against formalizing the modular representation-theoretic finish,
which would require building Brauer-character support first. Those are outside
both C815's declared scope and this task's. They are candidates for C800 or for
a separately reserved identifier; the decision is deferred and no identifier has
been reserved.

## Review and release gates

1. Theorem-level red-team review focused on hypotheses, proportionality versus
   equality, the nonzero-shadow clause, orientation covariance, and the global
   weighted boundary. **RUN 2026-08-20; report and evidence bundle in
   `notes/2026-08-20-c816-theorem-red-team.{md,py,json,sha256}`.** No claim was
   withdrawn: the section's mathematics was recomputed independently from the
   manuscript's own representative and conventions and came through intact,
   including the reduced Jacobian table entry for entry, the order-ten cut split
   36/90, the 384-matrix order-six census, and exhaustive aligned-family
   faithfulness at six, seven, and eight points. Eight findings, none requiring
   new mathematics; four of them should land before the cold read of gate 4:

   1. The tangent space `T` to `{A^2 = lambda I}` is proved five-dimensional only
      from below; "Equality holds" has no upper bound anywhere, and the module
      decomposition does not supply one. The upper bound is one sentence: `mu` is
      linear on the linearized space, its kernel lies in the `-1`-eigenspace of
      conjugation by `C/sqrt5`, and that eigenspace is four-dimensional
      (verified). Without it, "the four-dimensional constituent" is unsupported,
      so this is the load-bearing repair for work item 2 sub-item 1.
   2. The local rigidity conclusion cites the constant-rank theorem, whose
      hypothesis is never established; the implicit-function theorem applied to
      fourteen of the twenty functions is what the proof actually needs, and is
      weaker. The card's own sentence about the remaining external ingredient
      should follow.
   3. "The opposite oriented representative" in Theorem D reads as `-C` by this
      paper's usage, and under that reading the sentence is false, since the whole
      scaling line lies in `X_{+1}`. It means the odd signed-permutation image.
   4. The abstract states the recognition theorem more loosely than the theorem
      does — it drops nonzero proportionality and even order, and "characterizes"
      reads as an equivalence beside a genuine equivalence. The introduction and
      conclusion already say "forces order six and a scalar square".
   5. Work item 1's positioning follow-through is still owed: `OPER-5` exists, but
      no priority sentence sits near the recognition theorem, and none of the
      classical owners the audit named (Beauville, Tanturri, Huang--Oeding) is
      cited or connected by the principal-minor identity the audit recommended.
   6. The factor-four paragraph overstates what nondegeneracy replaces: it fixes
      the magnitude, while the converse's uniform sign across the twenty triples
      still comes from the two orbit computations.
   7. The inclusion-rank descent asserts the endpoint of a four-step induction in
      half a sentence; the descent alone leaves a threefold difference, and the
      return leg is what gives pointwise vanishing.
   8. Two wording items: the introduction drops "nontrivial" from the exchange
      characterization, and the universal Pfaffian identity is quantified over
      "every symmetric matrix" when it needs order six.
2. Run a Milnor--Serre exposition pass on every affected passage.
3. Build and visually inspect the PDF; replay the paper-local evidence gate,
   formal gate, axiom audit, source/hash checks, and complete aggregate.
4. Obtain a fresh context-free independent cold read of the revised PDF. Repair
   and regrade until the additions are judged an upgrade rather than an
   appendage.
5. Synchronize any configured downstream standalone release only by the lane's
   forward workflow and only after the authoritative root is green. Do not alter
   immutable released versions.

## Acceptance

The recognition theorem carries an auditable priority boundary with its own
ledger row. Theorem D is stated in the manuscript as proved rather than
certified, with the module statement replacing the numerical coincidence and the
eigenspace description replacing the character-table appeal. The exchange
rigidity proof is the shorter one or the shorter one is explicitly declined. The
abstract decision is taken and recorded either way. All release gates pass.

## Inputs

- C809 theorem/report: `notes/2026-08-02-c809-four-shadow-characterization.md`.
- C815 formalization: `notes/clebsch-tasks/c815-four-shadow-lean-formalization.md`.
- Theorem D structural proof, the characteristic-five theorem, the corrected
  mystery ledger, and the manuscript and Lean proposals:
  `notes/2026-08-05-c815-rank-14-weighted-jacobian.md`.
- Discovery context for the characteristic-five result, and the recorded
  negative on any connection to the exceptional root-system code ladder:
  `notes/2026-08-06-c815-characteristic-five-degeneracy.md`.
- Shorter balanced exchange rigidity proof with its exact manuscript replacement
  text: `notes/2026-08-06-c815-exchange-rigidity-simplification.md`.
- Table (5.1) correction provenance, now landed:
  `notes/2026-08-07-c815-oper1-oper2-algebraic-closure.md`.
- Existing operator integration/formal ownership: C763 and C800.
