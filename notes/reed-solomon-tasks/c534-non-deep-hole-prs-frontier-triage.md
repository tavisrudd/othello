# C534 — non-deep-hole PRS frontier triage

**Lane:** `reed-solomon` · **Status:** complete; C535--C537 queued without displacing C531

Terminal report: `notes/2026-07-23-c534-non-deep-hole-prs-frontier-triage.md`.
Conversation/portfolio companion:
`notes/2026-07-23-c534-frontier-publication-portfolio-companion.md`.

## 1. Objective and terminal deliverable

Determine which structures uncovered by the PRS deep-hole programme support genuinely valuable
research beyond deep-hole classification.  For each candidate below:

1. run a claim-specific literature and forward-citation audit;
2. identify the strongest theorem-shaped question, structural relationship, or reconstruction
   principle that is both interesting and plausibly new;
3. run the cheapest decisive kill or characterize tests;
4. assess mathematical notability, audience breadth, theorem readiness, and publishability; and
5. re-rank the surviving directions by expected value.

The terminal report is
`notes/2026-07-23-c534-non-deep-hole-prs-frontier-triage.md`.  It must end with a re-ranked
portfolio and allocate/queue bounded follow-up C tasks only for directions that survive their
novelty and cheap-test gates.  A pre-empted or structurally weak direction is a successful negative
result, not a reason to widen the search.

This is a research-triage task, not manuscript work.  C500 remains release-gated.

## 2. Common audit, scoring, and kill protocol

Follow `notes/literature-audit-conventions.md` in full.  Every named source carries an explicit
read depth; every screened set records its size, provenance, fields, and discriminator; every
forward-citation negative uses independently resolved OpenAlex, Crossref, and Semantic Scholar
counts.  Read `/tmp/persistent/tavis/lit-search/README.md` before fetching and use the shared
cache.  Record inaccessible sources as coverage gaps, never as negatives.

For each direction produce a compact card with:

- **Published frontier:** exact strongest located theorem and what it does not cover.
- **Candidate crown:** one clean theorem statement or structural classification, stripped of
  deep-hole terminology where possible.
- **Why it matters:** target mathematical audience and which existing objects it connects.
- **Cheap kill:** the smallest counterexample, dimension count, classical theorem comparison,
  generic-stabilizer calculation, or frozen-certificate probe that could make the direction
  uninteresting.
- **Characterize test:** if the broad crown fails, the cheapest test that identifies the exact
  surviving special locus or replacement invariant.
- **Evidence boundary:** which clauses are already proved in C481--C530, which need new proof, and
  which depend on computation.
- **Verdict:** `KILL`, `PRE-EMPTED`, `STRUCTURE-ONLY`, `THEOREM-READY`, or `HIGH-UPSIDE OPEN`.
- **Scores, each 0--5:** novelty confidence, mathematical notability, audience breadth, theorem
  readiness, tractability, and publication coherence.

Initial EV order below is a prior, not an instruction to preserve the ranking.  Use the weighted
score
\[
  5N+5M+3A+4R+4T+4P
\]
only as a forcing device for explicit comparisons; the report must also state qualitative
dependencies and reasons a lower raw score may dominate.

Do not promote:

- a standard invariant under PRS terminology;
- a generic Chebotarev or Galois-splitting theorem already supplied by the literature;
- a finite census without a theorem-shaped structural boundary;
- a coding corollary whose underlying projective statement is classical; or
- a proposed paper requiring several unrelated unresolved crowns.

Any new paper-facing computation follows
`notes/research-reproducibility-conventions.md` and is committed atomically with its generator,
compact certificate, independent replay, hashes, and exact negative domain.

## 3. EV rank 1 — finite-field Gale reconstruction and MDS parent recovery

### Candidate contribution

Extract C481--C490 as an inverse-geometry theorem: coherent projection atlases of a six-point
configuration recover its labelled `M_0,6` point; four abstract views recover a Gale pair; the
branch divisor is the conic locus; Kummer/Artin--Schreier descent controls rational sheets; complete
ambient-child incidence selects a sheet; and complete children reconstruct unlabelled parents
outside exact small-field exceptions.

The valuable question is not “which syndromes are deep?” but:

> When does the deletion/projection deck of a finite projective configuration or MDS parity-check
> geometry determine its parent up to projective-semilinear equivalence?

### How to start

1. Load only C481--C485 and C490, then state the strongest theorem without syndrome language.
2. Audit four adjacent literatures separately: Gale association and reconstruction from
   projections; deletion-deck reconstruction for point configurations or matroids; reconstruction
   and equivalence of punctured/shortened linear codes; and MDS extension geometries.
3. Search exact theorem shapes, not just vocabulary: recovery up to Gale duality, branch conic,
   bounded reconstruction number, and complete-child rigidity over finite fields.
4. Build a dependency-minimal statement showing which clauses need only projective geometry and
   which use finite-field incidence counts.

### Cheap kill or characterize tests

- Check whether a classical reconstruction theorem already recovers a generic six-point
  configuration from the same four projections; if so, isolate whether finite-field descent,
  exact branch, or child-relative reconstruction remains new.
- Run the dimension count for `n` points in `P^(r-1)` from `k` projected children.  Kill any broad
  generalization whose data is generically underdetermined.
- Test the frozen C478/C490 examples after forgetting every coding decoration.  If the claimed
  discriminator vanishes with the decorations, characterize the exact geometric functor that
  survives.
- Determine whether the result is genuinely a deletion-deck theorem or merely inversion of an
  explicitly labelled coordinate chart.

### Promotion gate

Promote if the audit leaves a clean finite-field Gale/deletion reconstruction theorem with a
recognizable inverse-problem audience and at most one principal generalization gap.  Prefer one
geometry paper plus a coding corollary over a coding-only presentation.

## 4. EV rank 2 — coherent polar flags and structured splitting loci

### Candidate contribution

Recast C512 as a theorem about coherent contraction flags in modular binary-form representations:
contained flags are persistent catalecticant tangent/sigma components or explicit Lucas-nucleus
components; transverse flags admit effective finite-field splitting bounds with exact collision
budgets.

The frontier question is:

> Classify coherent polar/contraction flags contained in secant, discriminant, and factorization
> loci of binary forms in positive characteristic, and give effective rational splitting outside
> the contained locus.

### How to start

1. Start from C512's scheme-level contraction functor and theorem hypotheses, not its PRS
   applications.
2. Reuse the C512 audit, then extend it to Fano schemes of linear spaces on catalecticant/secant
   varieties, modular binary-form invariant theory, and structured polynomial-family splitting.
3. Treat Wang's 2026 Galois-splitting framework as prior infrastructure.  Novelty must lie in
   coherent Hankel overlap, contained-locus classification, forbidden-factor retention, or the
   effective structured deletion bound.
4. Extract the smallest nontrivial theorem covering C498/C509/C513/C516 uniformly.

### Cheap kill or characterize tests

- Compare C512's “contained” classification with known Fano schemes of secant varieties.  If it is
  a coordinate translation of a standard result, kill the abstract crown and retain only the
  modular nucleus clause.
- Check whether the transverse bound follows formally from an existing normal-variety
  Chebotarev theorem once genus/deletion inputs are supplied.  Credit only the new geometric input.
- Compute the first degree where a coherent flag has positive-dimensional moduli not controlled by
  persistent/Lucas loci.  This is the sharp boundary of any uniform theorem.
- Test whether the pointed forbidden-factor condition is essential by removing it in the C498 and
  q=19 controls.

### Promotion gate

Promote only if one theorem cleanly separates contained modular flags from transverse splitting
families and recovers at least three fixed-level results as corollaries.

## 5. EV rank 3 — characteristic-two Hessian--Arf replacement geometry

### Candidate contribution

Extract C519/C525 as modular invariant theory: the divided binary-cubic discriminant becomes the
doubled quadric `(AD+BC)^2`; the divided Hessian and its Arf/Artin--Schreier class retain residual
splitting; root-compatible pullbacks are ordered `(2,2)` curves; and the complete contained
pullback is the persistent/Lucas carrier union.

The frontier question is:

> What functorial replacement retains separability and splitting information when classical
> discriminants or Hessians become Frobenius powers, and how does it behave on constrained
> root-compatible families?

### How to start

1. Separate the classical binary-cubic/quadratic invariant facts from the new constrained-pullback
   theorem.
2. Audit characteristic-two resolvents, Arf invariants of quadratic forms, divided Hessians,
   inseparable discriminants, and modular invariant theory of binary cubics.
3. Search for the exact `(2,2)` ordered-root model and its two ruling classification.
4. Formulate a universal base-scheme statement before specializing to Hankel kernels.

### Cheap kill or characterize tests

- Kill any claim that the Arf invariant itself is new; test novelty only for the canonical
  divided-Hessian construction and constrained carrier equality.
- Check whether the doubled-quadric and ruling statements are immediate standard invariant theory.
  If so, isolate the exact root-compatible pullback classification as the crown.
- Test one higher binary-form degree to see whether the replacement is genuinely functorial or an
  isolated cubic coincidence.
- Identify whether the `(2,2)` model yields a reusable genus/deletion theorem outside PRS.

### Promotion gate

Promote if the constrained-pullback theorem is not pre-empted and can be stated as a short modular
geometry paper with PRS as one application.

## 6. EV rank 4 — Lucas nuclei and affine root-space monodromy

### Candidate contribution

Generalize C529/C530's power-of-two carrier family, constant-field cycles, and the enlargement
`AGL_1(F8) < AGL_3(F2)` to a theory of affine `F_p^r` root spaces embedded in ordinary modular
binary-form representations.

Core questions:

- Which Lucas-nucleus or Hankel carriers contain affine `F_p^r` root-space families?
- Which affine monodromy groups and constant fields occur?
- Can the carrier and Frobenius cycle type be read directly from base-\(p\) digits?
- What is the exact count and orbit structure of split root-space members?

### How to start

1. Load C529/C530 and extract the representation-theoretic input separately from generic
   linearized-polynomial facts.
2. Audit NRC nuclei, Lucas-theorem submodules, Dickson/Moore invariants, Galois groups of generic
   linearized polynomials, affine subspace polynomials, and the new geometric literature on
   linearized Reed--Solomon codes.
3. Treat generic `AGL_r(F_p)` monodromy as likely classical.  Search for novelty in its forced
   occurrence inside consecutive-row Lucas carriers and in the coefficientwise-Frobenius law.
4. Probe the next two prime/power levels symbolically before proposing a general theorem.

### Cheap kill or characterize tests

- Verify whether the apparent infinite family is more than a restatement of the standard subspace
  polynomial parameter space.
- Compute the carrier intersection with `p`-linearized exponents at the next two Lucas levels.
  Kill a digit-law conjecture at its first failure.
- Compare stabilizers and orbit dimensions: if the additive family is lower-dimensional and
  noncanonical away from the endpoint orbit, characterize exactly the intrinsic special strata.
- Test whether the exact C530 witness count has a direct Gaussian-binomial generalization and
  whether that count adds information beyond standard subspace-polynomial enumeration.

### Promotion gate

Promote only if the modular representation selects the root-space cover canonically or forces a
new Frobenius/constant-field law.  Do not publish generic linearized-polynomial theory under new
names.

## 7. EV rank 5 — simultaneous MDS-extension complexes

### Candidate contribution

Replace the one-column extension set by the simplicial complex of subsets that can be adjoined
simultaneously while preserving the MDS property.  Ask whether this extension complex determines
the parent, controls reconstruction number, or interfaces with higher-order MDS and list decoding.

### How to start

1. Load C295 and the C485/C490 collision-hypergraph boundary only after the literature search
   identifies a precise common object.
2. Audit higher-order MDS codes, simultaneous extensions of arcs, matroid extension spaces,
   extension complexes, and list-decoding intersection conditions.
3. Define the functor invariantly for parity-check configurations and record its behavior under
   puncturing, shortening, duality, and semilinear equivalence.

### Cheap kill or characterize tests

- On the frozen C398/C478 controls, compute whether two nonisomorphic parents can have identical
  simultaneous-extension complexes.  One collision kills naïve reconstruction.
- Check whether the complex is determined by the one-column legal set plus pairwise conflicts.  If
  so, characterize the first genuinely higher face.
- Test whether the C295 simultaneous-extension data can actually be recovered from coherent
  projection atlases.  Without this bridge, do not promote the direction from this lane.
- Compare its minimal nonfaces with known higher-order-MDS determinants; kill a relabelling-only
  result.

### Promotion gate

Promote only after either a reconstruction theorem, a strict hierarchy example, or a proved bridge
to higher-order MDS/list decoding.  This is high-upside but presently less theorem-ready.

## 8. EV rank 6 — algorithms for code equivalence and parent reconstruction

### Candidate contribution

Turn the determinant/Gale invariants into certified algorithms for recognizing common MDS parents,
detecting Gale ambiguity, and deciding projective-semilinear equivalence from a bounded set of
punctured children.

### How to start

1. Extract executable invariants and reconstruction maps from C475, C481, C485, and C490.
2. Audit code-equivalence algorithms, canonical forms for projective systems and matroids, support
   splitting, puncturing-based distinguishers, and graph-isomorphism reductions.
3. State the input model and complexity honestly: labelled versus unlabelled children, fixed versus
   growing redundancy, and explicit versus oracle access to the deletion deck.

### Cheap kill or characterize tests

- Compare against canonical labelling of the incidence graph and direct `PGL` transporter search.
  Kill the algorithmic crown if the atlas has no asymptotic or certification advantage.
- Benchmark only frozen small examples first; no large field census.
- Determine whether four views are information-theoretically necessary or merely sufficient.
- Test robustness to missing children and Frobenius-unlabelled data.

### Promotion gate

Promote if the method yields a provable complexity improvement, a canonical certificate unavailable
from generic equivalence software, or a meaningful reconstruction guarantee under partial data.

## 9. Cross-direction relationship tests

Before final ranking, test these possible unifications:

1. **Gale reconstruction ↔ extension complexes:** does the complete-child incidence cut recover
   higher faces of the simultaneous-extension complex?
2. **Polar flags ↔ Hessian--Arf:** is C525 the characteristic-two local model for the modular
   contained branch of C512?
3. **Lucas nuclei ↔ polar flags:** can every affine root-space carrier be characterized as a
   modular contained flag, rather than a separately named exception?
4. **Reconstruction ↔ algorithms:** does the theorem yield a canonical semilinear fingerprint, or
   only an existential inverse?
5. **Root-space monodromy ↔ linearized RS geometry:** is there a functorial bridge, or merely a
   shared use of linearized polynomials?

Promote a relationship only when it reduces hypotheses, explains an exception, or transfers a
theorem.  Analogy alone does not raise EV.

## 10. Execution order and final queue gate

1. **Audit pass:** build six source maps and pin the strongest predecessor for each direction.
2. **Theorem extraction:** write one dependency-minimal candidate crown per direction.
3. **Cheap tests:** run all kill tests that need no new large computation; commit any
   paper-facing certificate bundles atomically.
4. **Relationship pass:** test the five bridges in §9 and merge directions only if a theorem
   genuinely unifies them.
5. **Re-rank:** score all survivors, give confidence intervals, and state the highest-EV next
   falsifiable gate.
6. **Queue:** allocate IDs only through
   `python3 notes/scripts/allocate_codex_task_ids.py reserve`; add bounded task cards and queue rows
   in re-ranked EV order.  Do not allocate a manuscript task, and do not displace the selected
   C531/C532 execution chain without explicit user approval.

## 11. Acceptance gates

- All six directions have convention-compliant literature records and explicit coverage gaps.
- Every survivor has a theorem-shaped crown, a named audience, a dependency boundary, and at least
  one passed cheap characterize test.
- Every killed direction states the exact predecessor, counterexample, dimension obstruction, or
  missing bridge that killed it.
- Notability and publishability are assessed separately: a deep theorem with a fragmented story
  and a clean publishable theorem with moderate depth receive different scores.
- The final EV ranking is justified from evidence rather than inherited from this card.
- Follow-up tasks are allocated and queued only for survivors, in the new order, with explicit
  entry and stop gates.
- C500 remains unopened and no manuscript prose is produced.

## 12. Owned paths

- `notes/2026-07-23-c534-non-deep-hole-prs-frontier-triage*`
- `notes/reed-solomon-tasks/c534-non-deep-hole-prs-frontier-triage.md`
- C534-created follow-up task cards and allocation rows after the final survivor gate
- the `reed-solomon` live handoff, archive, discovery track, and task lifecycle rows
