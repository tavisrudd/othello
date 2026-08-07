# C816 — Paper III four-shadow characterization integration

**Lane:** `clebsch`  
**Status:** fifth task for `go clebsch paper III`; begin after C800's shared
formal reconciliation; C815 statement/formal freeze complete first; paper
promotion authorized by this task only

## Objective

Integrate C809's characterization theorem into the forward version of Paper III so that the operator section advances from several coincident realizations to a necessity-and-rigidity theorem, without overstating the unresolved global weighted locus or treating four dependent shadows as independent evidence.

## Entry gates

1. Read `papers/style-guide.md` before touching the manuscript.
2. Freeze the exact C809 statement against the C815 Lean declarations and the current C800 operator manifest.
3. Complete a publication-grade literature audit under `notes/literature-audit-conventions.md` before writing any novelty or priority sentence. Extend the quick C809 check through the relevant conference, Seidel/two-graph, Pfaffian commutator, compound-minor, tight-frame, and determinantal-representation literature; record every source's read depth and all uncovered services.
4. If prior work pre-empts the recognition theorem, run the required bounded adjacent-crown extraction and reposition before editing headline claims.

## Manuscript work

1. Insert one causal theorem near the existing commutator-Pfaffian result:
   nonzero proportionality forces $A^2=\lambda I$; on scalar sign operators it characterizes the unique order-six golden conference class, while the sign records the two outer orientations.
2. Give the translation-invariance proof in the main text. Keep the pentagon classification short and structural; place the exact census and tangent calculation in the verification/evidence surface rather than the proof spine.
3. Explain explicitly that the compound diagonal and Pfaffian are universally identical and that the cross-golden determinant follows after the splitting. Present the result as one recognition comparison, not four independent coincidences.
4. Include the order-six degree explanation $n/2=3$ and, if it improves rather than crowds the exposition, the five-balance-plus-one-orientation recognition packet.
5. State the boundary next to the theorem: global on the scalar sign locus, locally rigid in the weighted ambient space, with remote weighted real/complex components unclassified.
6. Reassess the abstract, introduction hierarchy, operator-section roadmap, conclusion, and any existing source--operator--cubic diagram. Change the abstract only if the characterization becomes a genuine headline after the literature audit.
7. Update the claim map, trust table, adequacy/provenance text, bibliography, artifact guide, and verification manifests to point to C815 and C809 with exact proof ownership.

## Theorem D promotion

Added 2026-08-06. C809's Theorem D — the local ambient rigidity statement, that
the Jacobian of the twenty equality equations has rank fourteen at either
oriented golden representative with kernel the scaling line — is no longer
backed by an external rational certificate. It has a structural proof in
`notes/2026-08-05-c815-rank-14-weighted-jacobian.md`, and the only external
ingredient left is the ordinary constant-rank theorem. The manuscript may
therefore cite it as proved rather than certified, provided it carries the
constant-rank step and the reduced table or a reference for them.

The five items below are proposals for this task to accept or decline, in
descending order of value. Items 1 and 4 are positioning changes and are
subject to entry gate 3.

1. **Replace the numerical comparison sentence.** Theorem D currently closes
   with "the cubic equality cuts the four non-scaling tight-frame deformation
   directions," which reads as an observation that two dimensions agree.
   Replace it with the module statement: the conference tangent space at the
   representative is the trivial-plus-four isotypic subspace of the edge
   module, the cubic Jacobian is injective on the four-dimensional irreducible,
   and the ranks fourteen and eleven are therefore one structural fact rather
   than two coincident computations. This is the highest-value change here,
   because it converts the theorem's weakest-sounding remark into a claim.
2. **State the eigenspace description of the splitting.** The displayed line
   $A_0XA_0=\mu(X)A_0-5X$, obtained by multiplying the conference tangency
   condition by the representative and using $A_0^2=5I$, makes the
   trivial-plus-four splitting an eigenspace decomposition of conjugation by
   the representative rather than the output of a character table. Two
   sentences, and it removes this theorem's only appeal to a character
   computation.
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
   of the conference tangent space, proved in the same report — but Theorem D
   is a statement over the reals and the modular material would be a
   digression. The one exception worth a footnote is that five divides the
   reduced table's four-by-four minor for every choice of rows and every orbit
   basis, since a reader who computes the table will notice the $-5$ and
   wonder.

**Do not carry forward a retracted reading.** An earlier version of the C815
report observed that the Jacobian's rank modulo five equals the conference
tangent rank, both eleven, and presented that as suggestive. It is not: the
conference count is sixteen variables against a five-dimensional kernel and the
modular count is fifteen against four, so two offsets cancel. The containment
of the modular kernel in the conference tangent space is the real fact and is
stronger than the coincidence it was mistaken for. Neither the coincidence nor
any sentence resting on it may enter the manuscript.

## Balanced exchange rigidity: a shorter proof

Added 2026-08-06. The closing paragraph of the balanced exchange rigidity proof
can lose both its switching normalization and its appeal to `R(3,3) = 6`. Once
the four-set weight is known to be constant, applying the closed-walk count to
the whole matrix rather than to a half determines that constant: reading the
diagonal of \(C^2=qI\) gives \(q=2d-1\), and comparing \(2d(2d-1)^2\) with
\(2d(2d-1)+12\binom{2d}3+8w\binom{2d}4\) leaves \((2d-3)w=-3\). So \(w=3\)
forces \(2d=2\) and \(w=-1\) forces \(2d=6\), and the same equation says that
every four-set of the order-six conference matrix carries weight \(-1\) — it
identifies the exceptional order instead of only excluding the others.

The full argument, the exact replacement text for
`sections/05-golden-operator.tex`, and the notes on what the edit does to the
Jolliffe citation and to the verification rows are in
`notes/2026-08-06-c815-exchange-rigidity-simplification.md`. The whole chain is
formalized and gated, so this is a proposal about exposition, not about what is
proved: `RelativeConicArcs.BalancedExchangeRigidity.not_forall_sum_closedFourWalkWeight_eq`
states the conclusion for the fourth trace of the principal block, and the
spectral translation to the exchange moment is the one step still outside Lean.
The inclusion-matrix rank citation likewise becomes attribution rather than a
dependency, since the swap descent is proved in
`RelativeConicArcs.SubsetInclusionSums`.

**Lean items are not owned here.** The C815 report also proposes four Lean
targets supporting these edits — the complementation antisymmetry over an
arbitrary commutative ring, the gauge-coordinate triangle derivative and
tangency characterization, the engine identity, and the cofactor-array
classification — and recommends against formalizing the modular
representation-theoretic finish, which would require building Brauer-character
support first. Those are outside both C815's declared scope and this task's.
They are candidates for C800 or for a separately reserved identifier; the
decision is deferred and no identifier has been reserved.

## Review and release gates

1. Run theorem-level red-team review focused on hypotheses, proportionality versus equality, the nonzero-shadow clause, orientation covariance, and the global weighted boundary.
2. Run a Milnor--Serre exposition pass on the affected abstract, introduction, theorem proof, transitions, and conclusion.
3. Build and visually inspect the PDF; replay the paper-local evidence gate, formal gate, axiom audit, source/hash checks, and complete aggregate.
4. Obtain a fresh context-free independent cold read of the revised PDF. Repair and regrade until the theorem is judged an upgrade rather than an appendage.
5. Synchronize any configured downstream standalone release only by the lane's forward workflow and only after the authoritative root is green. Do not alter immutable released versions.

## Acceptance

The paper's central claim is stronger and simpler: the Clebsch cubic comparison recognizes the golden sign operator rather than merely furnishing several realizations. The abstract and theorem hierarchy make that necessity visible; the proof is short and causal; literature positioning is fully auditable; the weighted and orientation boundaries are unmistakable; C815 covers the structural kernel; all release gates pass; and a fresh independent reader confirms a material level-up.

## Inputs

- C809 theorem/report: `notes/2026-08-02-c809-four-shadow-characterization.md`.
- C815 formalization: `notes/clebsch-tasks/c815-four-shadow-lean-formalization.md`.
- Existing operator integration/formal ownership: C763 and C800.
- Theorem D structural proof, the characteristic-five theorem, the corrected
  mystery ledger, and the manuscript and Lean proposals above:
  `notes/2026-08-05-c815-rank-14-weighted-jacobian.md`.
- Discovery context for the characteristic-five result, and the recorded
  negative on any connection to the exceptional root-system code ladder:
  `notes/2026-08-06-c815-characteristic-five-degeneracy.md`.
- Shorter balanced exchange rigidity proof with its exact manuscript
  replacement text:
  `notes/2026-08-06-c815-exchange-rigidity-simplification.md`.
