# C904 Paper IV framing cold read

Date: 2026-08-11
Artifact read first and in full: `papers/q13-passant-code/passant_code_q13.pdf` (15 pages)
Source inspected only after the PDF pass: `papers/q13-passant-code/passant_code_q13.tex`
Verdict: **MINOR**

## Bottom line

The front matter succeeds. A cold reader can state all four requested items from the abstract and introduction:

1. **Fixed-\(q\) inverse problem.** From only the weighted coordinate-pair concurrences inside the minimum supports of
   \(K=\ker_{\mathbf F_2}M\), where \(M\) is the passant-by-internal incidence matrix of a conic in
   \(\mathrm{PG}(2,13)\), reconstruct the geometry lost when the row presentation is discarded. PDF p. 1 says:
   “The retained input is only the weighted pair data inside the minimum supports of a binary code; neither its
   parity-check matrix nor an ambient projective plane is supplied.”
2. **Exact threshold.** Weighted arity two suffices; unary support counts are constant. PDF p. 1 says:
   “Pair parity recovers \(K\), while unary minimum-support statistics are constant; reconstruction therefore has
   exact arity two.”
3. **Full output.** The weighted 2-section recovers the 78 incidence rows, the code, the six-class elliptic scheme,
   \(\mathrm{PGL}(2,13)\), and then all 183 points and lines of the marked plane, its conic, and polarity, up to
   isomorphism but with no chosen frame or field labels. Theorem 1.1 on PDF p. 2 states this cleanly.
4. **Proof/trust boundary.** The abstract gives the two main reductions (PSD clique obstruction for weight eight;
   line moments plus bounded stabilizer exhaustion for weight ten), and PDF p. 3 says: “The reductions are structural
   except at small exact endpoints.” Thus a cold reader can distinguish the human reductions from the finite leaves.
   The precise execution categories—trusted Python, Lean native evaluation, kernel-checked transport, and human
   transport—are correctly deferred to the explicit trust table on pp. 13–14.

The fixed-field disclaimer strengthens the pitch. The sharpest version is the abstract's closing sentence on PDF p. 1:
“The theorem is intentionally specific to \(q=13\): it gives complete ambient reconstruction, not a uniform distance
formula.” This converts an apparent generality limitation into a precise and unusually strong fixed-instance theorem.
The issue is repetition, not substance.

## Required minor fixes

### 1. Make the “exact arity” lower bound mathematically explicit

PDF p. 9 concludes:

> “Every coordinate occurs in \(364\cdot12/78=56\) minimum supports, making unary data constant. Pair data suffices
> and unary data does not; reconstruction arity is exactly two.”

Constancy makes the intended obstruction evident, but it does not by itself define or prove “does not” for an inverse
problem whose output is only required up to isomorphism. State that reconstruction is intrinsic/equivariant, then give
the one-line automorphism obstruction: unary data have automorphism group \(S_{78}\), whereas the reconstructed marked
presentation has automorphism group \(\mathrm{PGL}(2,13)\). Hence no intrinsic reconstruction of the nontrivial marked
relations can factor through unary data. This closes the headline minimality claim locally. The fix belongs near
`passant_code_q13.tex:667`–`672`, with a forward reference if the \(\mathrm{PGL}(2,13)\) computation is retained later.

### 2. Update the stale Tranchida citation

PDF p. 15 still gives:

> “[8] P. Tranchida, *Triples of involutions in PGL(2,q) and their incidence geometries*, arXiv:2411.10299, 2024.”

The paper was published in *Innovations in Incidence Geometry: Algebraic, Topological and Combinatorial* **22**
(2025), no. 1–2, 25–46, DOI `10.2140/iig.2025.22.25`. Update `passant_code_q13.tex:1121` onward; the arXiv identifier
may remain as a secondary locator. Publisher record:
<https://msp.org/iig/2025/22-1/iig-v22-n1-p02-s.pdf>.

### 3. Remove or use the uncited companion reference

PDF p. 14 lists:

> “[1] T. Rudd, *Chordal and Conference Cubics: Reconstruction and a Residual \(C_2\)-Torsor*, Paper V, companion
> manuscript, 2026.”

`RuddCompanion2026` occurs only in its `\bibitem` (`passant_code_q13.tex:1076`); it is never cited. Delete it unless a
specific comparison is added. In its current form it is bibliography detritus and needlessly pushes against the
otherwise convincing “standalone fixed-field inverse problem” claim.

### 4. Give the formal package a stable locator and reconcile “certificate” terminology

PDF p. 13 says both:

> “The accompanying verification/ directory contains separate canonical certificates ...”

and

> “the formal package is distributed separately and carries its own README.”

The later trust language is admirably exact—PDF p. 14 explicitly says hash checks “do not turn either execution into a
kernel-checked certificate”—but the earlier phrase “canonical certificates” can blur that distinction for the finite
leaves classified as trusted executions. Use “evidence artifacts” or “replay records” unless each item is actually
checked as a witness by a separate small verifier. Also replace “distributed separately” with a stable public
repository/archive URL, release/tag or commit, and the package version that matches this PDF. Source location:
`passant_code_q13.tex:933`–`951`.

### 5. Fix two visible PDF defects

- PDF p. 4 prints “a positive- semidefinite form,” with a conspicuous interword gap after the hyphen. Join the split
  source token at `passant_code_q13.tex:269`–`270` as `positive-semidefinite`.
- The theorem-terminal list is orphaned across pp. 13–14: PDF p. 13 ends with only
  “incidenceRankAndCodeDimension,” while p. 14 begins with the remaining seven unintroduced names. Keep the
  namespace sentence and terminal list together, or force the whole block to p. 14. Source:
  `passant_code_q13.tex:1011`–`1023`.

## Repetition and overclaim audit

These are trims, not structural repairs.

- PDF p. 2 first says “At \(q=13\), unary data are constant while weighted pair data recover everything, so the exact
  arity is two,” then, just before the theorem, repeats: “The theorem is field-specific but maximal in reconstruction
  output.” The theorem immediately enumerates the output. Keep the first fixed-field setup; replace “recover
  everything” by the concrete endpoint (“recover the marked conic plane and polarity”), and delete or compress the
  second paragraph. “Maximal” has no stated ordering and is the only genuinely promotional overreach.
- The diagram on PDF p. 3 already says “Weight eight gives a seven-clique ...” and “The line moment reduces weight ten
  to two shapes”; the prose immediately below repeats both sentences. Let the diagram carry the proof route and make
  the paragraph below carry only what the diagram does not: which leaves are finite/trusted and which transports are
  human.
- The fixed-field point appears in the abstract (p. 1), twice before Theorem 1.1 (p. 2), and again in the conclusion
  (p. 14): “The theorem is deliberately fixed-field.” Retain the abstract boundary and one introduction statement;
  the conclusion can end on the information-threshold result without repeating the programmatic disclaimer.
- PDF p. 14 closes with “recovers every level of structure that the linear presentation had forgotten.” The paper has
  already stated the exact recovered objects. Repeating that list or stopping after “complete ambient conic plane” is
  more precise than “every level.”

The series epigraph on PDF p. 1—“From deep holes, a cubic takes shape ... and the scattered shadows gather home”—is
attractive but opaque to a standalone reader and points outside this paper before the abstract begins. It is optional,
not a defect; if standalone presentation is the priority, it is the first decorative element to cut.

## Theorem-support and trust audit

Apart from the unary-impossibility step above, I found no front-facing theorem-support gap. The theorem's main outputs
are all taken up later:

- distance and the four minimum-word orbits in Sections 2–3;
- pair-to-scheme, pair-to-row, and pair-parity-to-code reconstruction in Section 3;
- the \(\mathbf F_8\) operator field, orbit spanning, and automorphism group in Section 4;
- the 183-point marked plane and polarity in Section 5;
- explicit proof modes, finite domains, transports, and execution trust in Section 6.

The phrase “complete ambient reconstruction” is supported because the paper recovers points, lines, incidence,
distinguished conic, polarity, and the original internal-coordinate embedding, while explicitly disclaiming a canonical
frame, field labeling, or conic equation. The fixed-\(q\) scope is therefore honest and pitch-positive.

## Acceptance judgment

**MINOR.** The abstract/introduction pass the cold-reader test, the fixed-field framing helps, and the proof/trust
boundary is unusually transparent. Acceptance should be gated on the local arity-minimality sentence, reference
updates, artifact locator/terminology, and the two rendered copy/layout defects. None requires restructuring the
mathematics or weakening the central theorem.

## A/B follow-up

Follow-up date: 2026-08-11
Scope: only the scoped diff of `papers/q13-passant-code/passant_code_q13.tex` and rebuilt 15-page PDF B
Verdict: **MINOR**

### A findings resolved in B

- **Exact arity: PASS.** PDF B p. 9 now says: “Indeed, intrinsic reconstruction is equivariant: the constant unary
  datum has automorphism group \(S_{78}\), whereas Section 4 proves that the recovered marked presentation has
  automorphism group \(\mathrm{PGL}(2,13)\). No intrinsic reconstruction of those nontrivial marked relations can
  therefore factor through unary data.” Because the output is the marked presentation on the same 78-point set, its
  coordinate-equivariance makes the \(S_{78}\)-versus-\(\mathrm{PGL}(2,13)\) obstruction valid. This closes the
  lower-bound half of “exact arity two.”
- **Tranchida metadata: PASS.** PDF B p. 15 gives *Innovations in Incidence Geometry* **22** (2025), no. 1–2,
  25–46, DOI `10.2140/iig.2025.22.25`, with arXiv:2411.10299 retained. This matches the publisher record.
- **Uncited Paper V entry: PASS.** It is gone; B has seven references, all used in the text.
- **Evidence terminology: PASS as wording.** PDF B p. 13 now says “evidence artifacts and replay records,” avoiding
  the earlier blanket “canonical certificates.” The later warning remains exact: PDF B p. 14 says hash checks “do not
  turn either execution into a kernel-checked certificate.”
- **Positive-semidefinite: PASS.** PDF B p. 4 cleanly prints “a positive-semidefinite form.”
- **Terminal-list integrity: PASS locally.** The full `PassantCodeQ13.Gates.Main` list and both shared low-weight
  terminals now stay together on PDF B p. 13.
- **Fixed-field repetition: PASS.** B keeps the strong abstract boundary—“intentionally specific to \(q=13\)” on
  p. 1—and one standalone fixed-field setup on p. 2. It removes the redundant pre-theorem “field-specific but
  maximal” paragraph and the repeated fixed-field conclusion. The series epigraph is also gone. The result now reads
  as a self-contained fixed-instance theorem rather than a defense of being one.

### Remaining trust-boundary defects

1. **The automorphism claim is missing from the proof-mode table.** Theorem 1.1 and the abstract both claim that the
   recovered scheme has automorphism group \(\mathrm{PGL}(2,13)\); this claim also supplies the new exact-arity
   obstruction. PDF B p. 13 says “The minimum-word exhaustion and four-anchor rigidity retain their original exact
   replays,” and lists `ellipticSchemeAutomorphismsAreProjective`, but Table 1 on p. 14 has no “scheme automorphisms”
   row. A hostile reader cannot tell whether uniqueness of the fourth anchor and injectivity of all 78 signatures are
   trusted Python, Lean native evaluation, kernel-checked relative to named finite axioms, or human-checked exact
   data. Add a row classifying the anchor argument, its 78-point finite leaf, the Lean terminal, and the human
   equivariance step.
2. **Two finite leaves still lack an execution category.** Table 1, PDF B p. 14, calls the weight-ten mode “exact
   stabilizer leaves” and the octahedral mode a “bounded exact leaf.” “Exact” describes arithmetic, not trust. If these
   are Python executions, say “trusted Python stabilizer leaves” and “trusted Python bounded leaf”; if they are Lean
   native evaluations or independently certificate-checked, say that instead. This matters because the paragraph
   below carefully distinguishes all three categories.
3. **The formal package still has no stable locator.** PDF B p. 13 retains: “the formal package is distributed
   separately and carries its own README.” The terminology fix does not make the named Lean terminals retrievable.
   Give a repository/archive URL and exact release, tag, or commit matching B.

### Layout regression

The `\Needspace` repair keeps the terminal names together but lets the trust table float past its introduction. PDF B
p. 13 says “Table 1 records the remaining division of proof,” then shows both namespace lists; Table 1 first appears at
the top of p. 14. This is better than splitting a terminal list across pages, but the proof-mode table should precede
the implementation namespaces it explains. Place a float barrier before the namespace paragraph, make the table
nonfloating, or move the namespace material after the rendered table.

### Hostile-referee claim audit

No abstract or Theorem 1.1 claim needs mathematical weakening. The parameters, minimum-word census and orbit
classification, pair reconstruction, orbit spanning, hidden \(\mathbf F_8\), and ambient plane all have corresponding
proof text and a stated mix of human argument, finite data, replay, or Lean checks. The three explicit human
transports on PDF B p. 14—globalizing the fixed-point exhaustion, carrying support automorphisms to the polar scheme,
and identifying abstract group incidence with trace polarity—are stated without being laundered into machine proof.
The remaining problem is trust-map completeness and category naming, not a theorem-support failure.

**A/B judgment: MINOR.** B is materially better and closes every mathematical/citation/copy issue from A. Gate a
PASS on classifying the automorphism and two unnamed finite leaves, supplying the formal-package locator, and keeping
Table 1 ahead of the terminal namespaces. No regression affects the theorem itself.

**Targeted closure (latest 16-page PDF): PASS.** Table 1 now includes the automorphism group and explicitly separates finite certificates, Lean gates/theorems/native evaluation, trusted Python/replay, and human transports; it renders before both complete namespace lists on PDF p. 14 with no split or float-order regression.
