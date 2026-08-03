# C855 — Paper I batched manuscript pass: decision log

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream)
**Scope:** `papers/clebsch-rigidity/` in the authoritative monorepo only. No edits under
`lean/`; no edits to `~/src/math-papers/clebsch-rigidity`; no commits.

**Authorization:** the "Decisions (2026-08-03, author-delegated)" section of
`notes/clebsch-tasks/c855-paper-i-lean-referee-artifact-remediation.md`.

**Governing constraints applied throughout.**

* Claim strength is capped by `notes/2026-08-03-c855-strengthening-literature-audit.md`.
  Claims 1--3 of that audit are pre-empted in substance by Dye 1991; only the
  spectrum's exclusion of the counts five, seven, eight, and nine keeps a
  "to our knowledge" hedge, and that hedge survives verbatim in the manuscript.
* No new statement is labelled formalized unless it names an actual terminal of
  `RelativeConicArcs/Gates/ClebschRigidityTrust.lean`.
* Exposition follows `papers/style-guide.md`.

## Item A(a) — all-odd-order concurrence spectrum

* **Source note:** `notes/2026-08-03-c855-structural-exclusions.md:20-205` (theorem at
  127-155; edge bound 34-61; outer-automorphism dictionary 69-89; Lemmas A and B 91-125).
* **Integrated at:** `clebsch_rigidity.tex`, end of Section 3, as
  `\begin{proposition}[Concurrence spectrum]` `\label{prop:concurrence-spectrum}`
  with its proof and a following `Remark (What is classical here)`.
* **Claim strength.** Stated for a six-arc in `PG(2,q)`, `q` odd, exactly as the note
  proves it. The Fano/quadrangle edge bound `c(A) <= 10` and the one-factorization
  structure at equality are attributed inside the proof to Dye 1991 §2.2 and the proof
  of Theorem 1, pages 274--275, not presented as new. The novelty sentence in the
  remark is confined to the exclusion of five, seven, eight, and nine, and keeps the
  "to our knowledge" hedge the audit licenses (audit lines 308--346: complete read of
  Dye plus eight topical web searches, no citation-graph screen).
* **Proof mode:** human structural proof. Not formalized; no Lean declaration named.
* **Deliberately omitted.** The note's realized-type census (which partitions actually
  occur at each `q`) is descriptive and unexplained (`3+3` non-occurrence at `q = 11, 17`
  is open); nothing about realization entered the manuscript.

## Item A(b) — golden normal form and uniform rigidity package

* **Source note:** `notes/2026-08-03-c855-dye-orbit-uniqueness.md:30-168` (normalization,
  normal form, existence, one orbit, stabilizer) and `:264-369` (polarity, quadratic-form
  values).
* **Integrated at:** `clebsch_rigidity.tex`, Section 2, replacing the former Dye citation
  block, as `\begin{proposition}[Golden normal form and uniform rigidity]`
  `\label{prop:golden-normal-form}` with its proof and a following
  `Remark (Attribution)`.
* **Claim strength.** Explicitly framed as a reproof. The attribution remark cites Dye
  Theorem 1 (existence and transitivity), Theorem 2(iii) (unique polarity), Theorem 3
  (stabilizer `A_5`), and records that two triangles in general position having a unique
  common self-polar conic is classical. The only difference asserted is presentational:
  the triple-perspective normalization forcing `(x-1)(x^2-x-1)=0`, and identity-level
  verification over `Z[phi]`. This matches the audit's verdicts on Claims 2 and 3
  ("presentational novelty at most, not a new theorem"; "state without novelty claim").
* **Hypotheses preserved:** field of odd characteristic; existence iff 5 is a square.
  Characteristic five is not excluded. The `q = 11` identification of the associated
  conic with `U(A)` is now explicitly tagged as order-specific, with the `q = 19`
  contrast (140 uncovered points against a conic of 20) stated.
* The characteristic-five and characteristic-three conic-avoidance conditions are stated
  here because this is the only place the associated polarity is defined; the companion
  carries the specialized `q = 9` and `q = 5` caveats (item B3).
* **Proof mode:** human structural proof. Not formalized. The two Dye axioms
  `dye1991_brianchon_bound` and `dye1991_equality_classification` remain in the Lean
  gate and are unchanged by this pass.

## Item A(c) — pentagon converse and sharpened twelve-pentagon count

* **Source note:** `notes/2026-08-03-c855-orbit-classification-proofs.md:249-353`
  (Theorem 2.2 at 265-269, converse at 285-292, payoff at 307-323).
* **Integrated at:** `clebsch_rigidity.tex`, `thm:orientation-two-graph`'s final sentence
  (replacing "there is a unique balanced switching class up to relabeling") and the
  "Triangle holonomy" stage of its proof (replacing the two-sentence pentagon paragraph).
* **What changed.** The forward direction is unchanged. Added: the gauge representative
  is unique in its switching class; the converse that every pentagon returns
  `B^2 = 5I`, with the `+1,-1,-1` three-term count in both the adjacent and
  non-adjacent cases; the bijection between gauge classes and the `5!/(5*2)=12`
  pentagons; transitivity of `S_6` with point stabilizer of order sixty; negation acting
  without fixed points, so six unordered pairs with stabilizer of order 120; and one
  sentence connecting the order-sixty/order-120 pair to the `A_5 ⊂ S_5` distinction of
  `cor:orientation-cubic-geometry`.
* **Claim strength.** No novelty language. The audit has no claim entry here; this is a
  gap-fill in the manuscript's own argument (the converse was the direction the later
  argument used but did not prove), so no priority sentence is warranted either way.
* **Proof mode:** human structural proof. `PaperIOrientationPentagon.signedOrbitalMatrix_sq`
  remains the Lean terminal for `B^2 = 5I` on the displayed matrix; the converse as such
  is not formalized and is not claimed to be.

## Item A(d) — order-eleven tagging of Edge's external/internal reading

* **Source note:** `notes/2026-08-03-c855-dye-orbit-uniqueness.md:341-359`.
* **Integrated at:** `clebsch_rigidity.tex`, Section 2, the paragraph following the
  external/internal/passant definitions.
* **What changed.** "Edge's six vertices are external ... ten internal Brianchon points"
  is now tagged "At `q = 11`", followed by the order-independent part (the six vertices
  share one type and the ten Brianchon points share one type at every odd order) and the
  inversion at `q = 19` (vertices internal, Brianchon points external). The
  complete-exterior-set sentence is now explicitly conditioned on the `q = 11` tagging.
* **Deliberately omitted.** The note's further data points (both internal at 29 and 59,
  both external at 31 and 61) are computational observations from
  `notes/2026-08-03-c855-dye-polarity.py` with no committed paper-side replay; only the
  `q = 19` inversion, which is the one that contradicts an untagged reading, is stated.
  The note marks *which* type occurs as unexplained with no owning successor; the
  manuscript makes no attempt to explain it.
* **Proof mode:** the uniform part is exact `Z[phi]` arithmetic (human structural proof,
  now carried by `prop:golden-normal-form`); the `q = 19` assignment is a computational
  observation and is stated as a fact about that order only.

## Item B1 — q = 23 eight-point passant-arc sharpness witness

* **Source note:** `notes/2026-08-03-c855-structural-exclusions.md:251-336`.
* **Integrated at:** `clebsch_rigidity_computational_companion.tex`, after the proof of
  `thm:small-k-conic-filling`, as
  `\begin{remark}[The terminal bound six is not uniform in q]`
  `\label{rem:q23-passant-arc}`.
* **Claim-strength decision.** Only the explicit eight-point witness is asserted, plus
  the structural consequence that no bound with the order entering as a parameter can
  return six at `q = 19` and permit eight at `q = 23`. The witness is self-certifying:
  twenty-eight discriminant evaluations and fifty-six collinearity determinants.
  **Not asserted in the manuscript:** the exhaustive count of 6,072 eight-point arcs and
  the statement that eight is the exact maximum at `q = 23`. Those rest on
  `notes/2026-08-03-c855-passant-arc-search.py`, which is not part of the paper's
  release surface (no `checker_outputs.json` entry, no claim-map row), and the sharpness
  point does not need them.
* **Independent verification of the witness performed for this pass** (scratch script,
  `q = 23`, `Q = Y^2 - XZ`): all eight points off the conic; 28 of 28 joins passant by
  the non-square discriminant test; 0 of 56 triples collinear; tangent counts
  `[0,0,2,0,2,0,0,0]`, so six internal and two external. Matches the note exactly.
* **No claim-ledger row added.** Remarks carry no row in this companion by existing
  convention (`rem:degree-threshold` likewise has none), so the five-mode table is
  unchanged by this item.

## Item B2 — the named `q = 2k - 3` pencil-saturation lemma

* **Source note:** `notes/2026-08-03-c855-classical-transfer-proofs.md:57-63` (statement
  and proof), with the `q = 9` instance at `:377-394` and the non-uniformity reading at
  `notes/2026-08-03-c855-structural-exclusions.md:218-227, 331-334`.
* **Integrated at:** `clebsch_rigidity_computational_companion.tex`, immediately before
  `thm:q13-tangent-code`, as `\begin{lemma}[Pencil saturation at q=2k-3]`
  `\label{lem:pencil-saturation}`. Consumed twice: in the weight-eight step of the
  passant-code proof and in the `k = 8`, `q = 13` structural reduction of
  `thm:small-k-conic-filling`; referenced once more in `rem:q23-passant-arc`.
* **Claim strength.** Pure incidence counting: internal points lie on exactly `(q+1)/2`
  passants and on no tangent, and `k - 1 = (q+1)/2` is exactly `q = 2k - 3`. No novelty
  language. The `q >= 2k - 3` window bound of the geometric paper is a separate
  statement and was not touched.
* **Proof mode:** human structural proof.
* Both former ad hoc phrasings ("the passant pencil at every vertex is saturated",
  "its seven chords would exhaust its complete passant pencil") now cite the lemma.

## Item B3 — characteristic-three and characteristic-five conic-avoidance caveats

* **Source note:** `notes/2026-08-03-c855-dye-orbit-uniqueness.md:327-359`, plus the
  characteristic-five boundary discussion at `:236-246`.
* **Integrated at:** `clebsch_rigidity_computational_companion.tex`, after the proof of
  `thm:why11`, as `\begin{remark}[Why characteristics three and five need separate care]`
  `\label{rem:char-three-five}`.
* **Content.** Vertex values have norm `-5` and Brianchon values norm `-9`, so the
  vertices miss the associated conic unless the characteristic is five and the Brianchon
  points miss it unless the characteristic is three. Both exceptions are shown
  non-vacuous: in characteristic three the configuration exists over `F_9` with all ten
  Brianchon points on its associated conic, which is why the `q = 9` exclusion is closed
  by the Sylvester clique bound and not by conic avoidance; in characteristic five the
  vertices lie on the associated conic and the two golden roots merge, which is why the
  `q = 5` entry of `thm:small-k-conic-filling` is a four-frame.
* Cross-referenced to the geometric paper by `\cite{RuddRigidity2026}` without a
  pinpoint number, since companion and paper numbering are independent.
* **Deliberately omitted.** The note's open question about whether the projective
  stabilizer grows from `A_5` to `S_5` in characteristic five, and the unexplained
  norm `-9`, are not mentioned.

## Item B4 — demotion of the 160,930-conic distance audit

* **Card decision:** demote from a claim row to reported computation, keeping only a
  descriptive sharpness figure.
* **Changed:**
  * `clebsch_rigidity_computational_companion.tex`, proof of `thm:gap`: the sentence
    asserting "no non-Clebsch uncovered locus lies on a nearer conic" is replaced. The
    four-point gap between twelve and sixteen is named as the sharpness figure that
    `thm:rigidity` leaves; the enumeration over all 160,930 nonsingular conics is
    described as recording the largest intersection per class and stated to be reported
    computation rather than a premise.
  * The claim-map row `$q=11$ conic-distance gap / trusted execution / All 160930
    nonsingular conics` is deleted from `tab:claim-modes`.
  * The paragraph introducing the table now states that the audit carries no row.
  * `verification/computational_companion_trust.json`: claim `q11-conic-distance-gap`
    removed (thirteen claims to twelve; all five modes still used).
  * `verification/verify_computational_companion.py`: `q11-conic-distance-gap` removed
    from `CLAIM_IDS`.
  * `verification/README.md`: "thirteen-row atomic claim map" to "atomic claim map"
    (per the documentation convention against embedded counts).
  * `verification/build_trust_manifest.py`, row 20 summary: the trusted exhaustive
    execution sentence is rewritten as reported computation. The
    `check_global_conic_gap.py` replay entry itself is retained; it is a replay, not a
    claim.
* `python3 verification/verify_computational_companion.py` reports
  `companion_claims=12 modes=5 checks=10 artifacts=4 finite_boundary_claims=7 status=ok`.

## Item D — Madison--Wu framing and the descent refinement

* **Source note:** `notes/2026-08-03-c855-q13-scheme-gap-closure.md`, Theorem A at
  `:330-333`, Corollary A at `:352-353`, §6 scope correction at `:710-720`, proof-mode
  statement at `:21-23`, referee record at `:11-19`.
* **Integrated at:** `clebsch_rigidity_computational_companion.tex`, the paragraph
  opening Section `sec:q13-tangent-code`.
* **Credit sentence.** Madison and Wu determine the kernel for every odd `q`: over an
  algebraic closure of `F_2` they give both the dimension `(q-1)^2/4`, which is 36 at
  `q = 13`, and the exact decomposition into pairwise nonisomorphic simple
  `PSL(2,q)`-modules, cited to Theorem 6.1 and Corollary 6.3. This corrects the previous
  text, which credited them only with the nullity.
* **Refinement stated as descent.** Over `F_2` itself and for the full `PGL(2,13)`
  action, `K = ker M` is irreducible with endomorphism field `F_8`; equivalently `K`
  carries a canonical twelve-dimensional `F_8`-structure whose base change to the
  closure returns Madison and Wu's three summands as Galois conjugates. Consequence:
  every nonzero codeword generates `K`, which is why each minimum-word orbit spans.
* **Proof mode recorded accurately:** "a human structural proof, adversarially refereed;
  it is not part of the formal gate." No Lean declaration is named and nothing is
  labelled Lean-checked. The task ID is deliberately not written into the manuscript
  (public artifacts carry no task IDs).
* The claim-ledger row `$q=13$ orbit spans and automorphism group` keeps its
  `human structural proof` mode; its boundary column now reads "Irreducibility of
  `ker M` over `F_2` with endomorphism field `F_8`, the mod-two elliptic algebra, and
  resolving anchors".
* **Not done:** the note observes that `\cite{MadisonWu2012}` could now be dropped from
  `thm:q13-tangent-code`. The citation is kept — dropping it would remove a correct
  credit for the result the companion still reports, and no card decision authorizes it.

## Item C — the two singular-locus passages

* **Lean source:** `notes/2026-08-03-c855-six-node-lean-log.md`, and the declarations
  themselves in `lean/RelativeConicArcs/PaperIOrientationNodes.lean`.
* **Exact strengths, read off the Lean statements rather than the task brief.**
  * `derivative_crossGoldenDeterminantLine_eval`: `{R} [CommRing R] (t : R) (ht : t^2 = t+1)` —
    any commutative ring containing a golden root.
  * `singularPoints_crossGoldenDeterminant_eq_axisClasses`:
    `{K} [Field K] [CharZero K] (t : K) (ht : t^2 = t+1)` — a **field of characteristic
    zero** containing a golden root. The brief's "any commutative ring with a golden
    root" applies only to the derivative identity; the manuscript states each at its own
    hypothesis. Neither uses smoothness or transversality.
* **Passage 1** (proof of `thm:orientation-two-graph`, "The node frame"): the paragraph
  invoking Hassett--Tschinkel Proposition 10 is replaced by the direct argument —
  `det(Phi_x) = -C(x)`, differentiation along a centered coordinate line, simultaneous
  vanishing of the five gradient quadrics exactly on the six centered axis vectors,
  frame property from the kernel of the cross-golden compression being the all-ones
  line. Hassett--Tschinkel is retained in a following paragraph as context, with "the
  argument above does not use it" stated in the same breath. The former sentence "They
  are therefore the complete singular locus" is gone; the Hessian/node-type paragraph is
  otherwise unchanged.
* **Passage 2** (Section `sec:verification`): the opening sentence now reads "one
  external model identification and no external singular-locus theorem"; the
  Hassett--Tschinkel transfer sentence is rewritten to mark that statement as context
  and not load-bearing; the two Lean declarations are named with their exact hypothesis
  classes. A third sentence later in the same section ("the smooth Clebsch dual surface
  put the cubic under the cited determinantal theorem") is rewritten to "the resulting
  gradient classification give singular-locus completeness without a smoothness input".
* The Cheltsov--Tschinkel--Zhang paragraph in Section
  `sec:orientation-two-graph` is unchanged; it was already marked as not transferring
  singular-locus completeness.

## Item E — verification surface

* **`verification/build_trust_manifest.py`, `TERMINALS["orientation_spine"]`:**
  `PaperIOrientationTraceDual.hassettTschinkel_six_nodes_of_traceDual` removed;
  `PaperIOrientationNodes.derivative_crossGoldenDeterminantLine_eval` and
  `PaperIOrientationNodes.singularPoints_crossGoldenDeterminant_eq_axisClasses` added,
  in the gate's own order. Row summaries for rows 20, 24, 26, and 29 updated to match
  the manuscript changes.
* **`verification/extract_statement_identity.py`, `ROW_LABELS`:** the three new
  theorem-like environments are attached to existing rows rather than creating new ones,
  so the published claim map stays at nineteen rows —
  `prop:concurrence-spectrum` joins row 24 (chord defect and window),
  `prop:golden-normal-form` joins row 26 (Clebsch-family/Dye), and
  `lem:pencil-saturation` joins row 29 (`q = 13` code and small-arc boundary).
* **`verification/check_manuscript_build.py`, `EXPECTED_PAGES`:** 22 to 25 for the main
  paper and 12 to 13 for the companion.
* **Regenerated:** `verification/statement_identity.json` and
  `verification/trust_manifest.json` (19 rows), both against the authoritative Lean root
  `othello/lean`, which is the script default.
* **Both PDFs rebuilt.** `check_manuscript_build.py` reports
  `manuscript_pages=clebsch_rigidity:25,clebsch_rigidity_computational_companion:13
  warnings=0 pdfs=produced`. Pages inspected visually: main-paper 4--5 (golden normal
  form and attribution), 7 (concurrence spectrum and its classical remark), 19 (pentagon
  converse and the twelve-class count), 21 (singular-locus rewrite), 22 (verification
  section); companion 10 (the `q = 23` remark, the terminal proof, and the trust
  section). No overfull boxes, no undefined references, no float displacement.
* **`verify-release-output.json` was NOT refreshed.** The README admits `--update-output`
  only after sources and PDFs are final *and* the clean-source release gate passes;
  neither precondition holds (see the two blockers below).

### Release-verifier outcome: two recorded blockers, neither forced

1. **Dirty paper root.** `nix develop --command python3 verification/verify_release.py
   --lean-root /home/tavis/src/lean/finitegeom-clebsch-q11-certificates` exits 1 with
   `release verification failed: release verification requires a clean paper root; found
   12 changed paths`. This is by construction: the task forbids committing, and the
   release gate is defined only on a committed tree. It clears as soon as this pass is
   committed.

2. **The pinned q11 export predates the six-node Lean change.** This one does not clear
   by committing. `~/src/lean/finitegeom-clebsch-q11-certificates` is at the pinned
   commit `09d8e174880e7370966da788da3c5d303df8af4f`, whose gate still has 51 terminals
   including the deleted `hassettTschinkel_six_nodes_of_traceDual`, while the authority
   `othello/lean` has 52 including the two new node theorems. Exact failures observed:
   * Regenerating against the export:
     `CLEBSCH_LEAN_ROOT=<export> python3 verification/build_trust_manifest.py` fails with
     `manifest construction failed: axiom audit terminal mismatch:
     missing=['...derivative_crossGoldenDeterminantLine_eval',
     '...singularPoints_crossGoldenDeterminant_eq_axisClasses'],
     extra=['...hassettTschinkel_six_nodes_of_traceDual']`.
   * Validating the regenerated manifest against the export:
     `verify_trust_manifest.py ... --lean-root <export>` fails with
     `manifest.claims[0].components[1].lean.gate hash mismatch`.
   * Validating against the authority: `verify_trust_manifest.py ... --lean-root
     othello/lean` fails with `manuscript displays a stale digest for
     RelativeConicArcs/Gates/ClebschRigidityTrust.lean`. The manuscript displays
     `c5d532db...` (the export's gate); the authority's gate is `4bc2adb5...`.

   **Deliberate residual.** The manuscript's pin block — certificate-package commit
   `09d8e174...` and gate digest `c5d532db...` — is left untouched. Updating only the
   digest would name a gate unreachable from the displayed package commit; the two must
   move together when the q11 package is re-exported from the authority, which is a
   guarded Lean/export operation and out of scope here. Until that re-export, the
   manuscript cites two declarations (`derivative_crossGoldenDeterminantLine_eval`,
   `singularPoints_crossGoldenDeterminant_eq_axisClasses`) that are present in the
   authority but not in the pinned public package. That is the single referee-visible
   inconsistency this pass leaves, and it is the successor's first task, ahead of the
   `verify-release-output.json` refresh and the `~/src/math-papers` forward
   synchronization.

## Referee revision round (2026-08-03, second pass)

Work order: `notes/2026-08-03-c855-cold-read-referee.md` (verdict MINOR REVISIONS;
4 MAJOR, 7 MINOR, 3 trivial, one free strengthening). Everything was applied except
MAJOR 4 (item 15, the Section 9 pin block), which stays untouched: the q11 package
re-export and re-pin is a separate Lean-side task.

| Finding | Fix | Location |
|---|---|---|
| 1 MAJOR — companion cites `[9, Theorem 3.2]` for the conic-filling window | Pinpoint corrected to `[9, Theorem 4.4]`, verified against `clebsch_rigidity.aux` after the final build | companion `thm`/`cor:conic-filling-window` header |
| 1 MAJOR — sweep of remaining cross-artifact numbers | `[9, Theorem 3.1]` (chord defect) and `[9, Theorem 1.1]` (rigidity) re-verified as correct; two new pinpoints `[9, Proposition 3.2]` verified; the `rem:char-three-five` citation stays unnumbered | companion lines 81, 109, 93, 205 region |
| 2 MAJOR — q13 descent advertised as a new contribution with no in-artifact proof | Madison--Wu credit kept; descent kept but stated as a refinement recorded in the project's research notes, proof not reproduced, formalization pending, explicitly outside the artifact's claim surface, with a sentence saying the spanning conclusion is proved independently from the mod-two intersection algebra. "What is added here" and "adversarially refereed" deleted | companion Section `sec:q13-tangent-code` opening |
| 2 MAJOR — Table 2 row boundary asserted the unproved irreducibility | Row kept (the spanning/automorphism claim is proved here); boundary column now reads "The mod-two elliptic intersection algebra and the four resolving anchors" | companion `tab:claim-modes` |
| 3 MAJOR — Remark 5.2 impossibility framing | Rewritten as a descriptive observation: the bound six is order-specific; the counting, character-sum, and clique estimates tried here do not distinguish `q=19` from `q=23`; `lem:pencil-saturation` is the order-specific coincidence closing `q=13`. No quantification over proof techniques remains | companion `rem:q23-passant-arc` |
| 4 MINOR — superseded `c(A) <= 15` in the window theorem | Display now carries only `|U(A)|` and `c(A)=(q-6)(q-9)`, with the spectrum `c(A) in {0,1,2,3,4,6,10}` cited to Proposition 3.2 for odd `q`; new `rem:spectrum-field-restriction` records that the spectrum alone leaves `q=5,9,11` and that the window removes `q=5`, so only `q=9` needs the companion's Sylvester bound. Propagated to companion Theorem 1.2 and to the first line of the `thm:why11` proof | main `cor:conic-filling-window`, new remark; companion Theorem 1.2, `thm:why11` |
| 5 MINOR — classical transitivity ingredient uncredited | Proof now names the determinant identity as the classical double-implies-triple perspective theorem for a commutative field; Remark 3.3 repeats the credit once and scopes the novelty to the reading as a transitivity relation | main proof of `prop:concurrence-spectrum`, `Remark (What is classical here)` |
| 6 MINOR — `K_{3,3}` normalization unjustified | New paragraph: the union of three pairwise disjoint perfect matchings is `K_{3,3}` or the prism; the prism's complement is a six-cycle, so a prism triple extends to a one-factorization and is a star triple; hence a triangle triple spans `K_{3,3}` and its bipartition gives the two triangles in perspective | main proof of `prop:concurrence-spectrum` |
| 7 MINOR — proof material attached to Theorem 1.1 | Bezout argument moved into new `cor:conic-stabilizer-orbit` (Corollary 4.2) after the rigidity proof; the introduction now states the orbit fact and points at the corollary | main Section 1 and Section 4 |
| 8 MINOR — Section 4 opens with a forward reference to Proposition 6.1 | Rephrased to name the content ("the conic identification for the displayed arc, proved in Section 6"), plus an explicit no-circularity sentence listing each side's inputs | main Section 4 opening |
| 9 MINOR — compressed nucleus argument | Intermediate clause inserted: every line through the nucleus meets `U(A)` in exactly one point, a chord meets it in none, so no chord passes through `N`; and no vertex can be `N` since each vertex lies on its `k-1` chords | main proof of `cor:conic-filling-window` |
| 10 MINOR — Definition 2.1's two definitions | Dye's ten-Brianchon-point condition is now the definition; the icosahedral construction follows as a `q=11` construction, and the agreement over `F_11` is stated via Edge's count plus the single-orbit statement of Proposition 2.2 | main `def:hexagon` |
| 11 TRIVIAL — three names for one companion table row | All three replaced by the script names actually responsible: `check_rigidity_degenerate_conic.py` for the conic-inscribed subcensus, `check_global_conic_gap.py` and `check_low_degree_loci.py` in the Table 1 caption, `check_low_degree_loci.py` in Remark 2.3. (The Table 1 caption uses `\texttt` since `\path` breaks in a moving argument.) | companion Section 2, `tab:fifteen-classes` caption, `rem:degree-threshold` |
| 12 TRIVIAL — bibliography order | Hassett--Tschinkel moved before Hirschfeld | main `thebibliography` |
| 13 TRIVIAL — abstract wording | "has `q` odd, with `2k-3 <= q <= (k(k-1)+3)/3`"; the arc no longer "lies in" a field window | main abstract |
| 14 — free strengthening | Companion census corroboration of the concurrence spectrum added in both papers, stated as corroboration at `q=11` and not a second proof: main Remark 3.3 and companion Section 2 after the `|U(A)|=22-c(A)` identity | main `Remark (What is classical here)`, companion Section 2 |
| 15 MAJOR — stale Section 9 pin block | **Deferred, untouched.** Owned by the q11 package re-export/re-pin task. `verify_trust_manifest.py` still exits 1 with the single message "manuscript displays a stale digest for RelativeConicArcs/Gates/ClebschRigidityTrust.lean", exactly as before this round | main Section 9 |

### Verification surface after this round

* `verification/extract_statement_identity.py`: `cor:conic-stabilizer-orbit` attached to
  existing row 17 (with `thm:rigidity`), so the published claim map stays at nineteen rows.
  The new `rem:spectrum-field-restriction` is a remark and is not an extracted environment.
* `verification/check_manuscript_build.py`: main-paper `EXPECTED_PAGES` 25 to 26 (the
  companion stays at 13).
* `verification/build_trust_manifest.py`: row 17's conceptual description now also records
  the fixed-conic single-orbit statement.
* Regenerated against the authoritative Lean root `othello/lean`:
  `verification/statement_identity.json` and `verification/trust_manifest.json`.
* `check_manuscript_build.py` reports
  `manuscript_pages=clebsch_rigidity:26,clebsch_rigidity_computational_companion:13
  warnings=0 pdfs=produced`; both root PDFs rebuilt with no warnings and no undefined
  references.
* `verify_computational_companion.py`: `companion_claims=12 modes=5 checks=10 artifacts=4
  finite_boundary_claims=7 status=ok`.
* `verify_trust_manifest.py --lean-root othello/lean`: still the single stale-digest
  failure of item 15. No new failure mode.
* `verify-release-output.json` was **not** touched and `--update-output` was **not** run,
  per the same two blockers recorded above.
* Pages inspected visually: main 2 (introduction and the relocated orbit statement),
  4 (Definition 2.1), 7 (the `K_{3,3}` paragraph, the perspective credit, Remark 3.3),
  9 (Corollary 4.2, the window theorem, the nucleus clause), 10 (the new spectrum remark);
  companion 2 (Theorem 1.2 and the Table 1 caption), 3 (census corroboration), 5 (the
  descent paragraph), 10 (Remark 5.2), 11 (Table 2). No overfull boxes and no float
  displacement.

### Numbering note

The main paper's numbering moved: the conic-filling window is now Theorem 4.4 (was 4.3,
and 4.2 one revision earlier), because Corollary 4.2 was inserted before it. The
companion's pinpoint was set from the freshly built `.aux`, but this pointer has now
drifted in three consecutive revisions. Before release, either regenerate the companion's
restated-input numbers from the manuscript label set or drop the numbers and cite the
window by name.

## Changed paths, referee revision round (all uncommitted)

```
papers/clebsch-rigidity/clebsch_rigidity.tex
papers/clebsch-rigidity/clebsch_rigidity.pdf
papers/clebsch-rigidity/clebsch_rigidity_computational_companion.tex
papers/clebsch-rigidity/clebsch_rigidity_computational_companion.pdf
papers/clebsch-rigidity/verification/build_trust_manifest.py
papers/clebsch-rigidity/verification/check_manuscript_build.py
papers/clebsch-rigidity/verification/extract_statement_identity.py
papers/clebsch-rigidity/verification/statement_identity.json
papers/clebsch-rigidity/verification/trust_manifest.json
notes/2026-08-03-c855-manuscript-pass-log.md   (this file)
```

Nothing under `lean/`, nothing under `~/src/math-papers/`, no git state change, and
`verification/verify-release-output.json` untouched.

## Changed paths, first batched pass (committed as `2799bcbf`)

```
papers/clebsch-rigidity/clebsch_rigidity.tex
papers/clebsch-rigidity/clebsch_rigidity.pdf
papers/clebsch-rigidity/clebsch_rigidity_computational_companion.tex
papers/clebsch-rigidity/clebsch_rigidity_computational_companion.pdf
papers/clebsch-rigidity/verification/build_trust_manifest.py
papers/clebsch-rigidity/verification/extract_statement_identity.py
papers/clebsch-rigidity/verification/check_manuscript_build.py
papers/clebsch-rigidity/verification/verify_computational_companion.py
papers/clebsch-rigidity/verification/computational_companion_trust.json
papers/clebsch-rigidity/verification/statement_identity.json
papers/clebsch-rigidity/verification/trust_manifest.json
papers/clebsch-rigidity/verification/README.md
notes/2026-08-03-c855-manuscript-pass-log.md   (new, this file)
```

Nothing under `lean/`, nothing under `~/src/math-papers/`, and no git state change.
