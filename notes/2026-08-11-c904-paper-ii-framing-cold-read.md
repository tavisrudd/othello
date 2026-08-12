# C904 Paper II framing cold read

**Date:** 2026-08-11
**Artifact read:** `papers/clebsch-factorization/clebsch_factorization.pdf` (45 pages)
**Verdict:** **MINOR**

## Protocol

I read the complete rendered PDF before inspecting manuscript source. Before that
read I did not inspect old reports, notes, handoffs, Git history, manuscript source,
or prior review discussion. After fixing the PDF-first assessment, I consulted the
paper style guide, the manuscript source only to locate exact edits, and current
primary bibliographic pages only to test apparently time-sensitive references.

## Cold-reader reconstruction

A cold reader can state the paper's result accurately from the abstract and
introduction:

- **Inverse problem.** Restricting a product of matched secants to the conic erases
  the pairing; the problem is whether low-degree algebra in the conic-ideal quotient
  recovers that pairing.
- **All-odd-prime-power classification.** Among full
  \(\operatorname{PGL}_2(q)\)-orbits of perfect matchings, for every odd prime
  power \(q\), the one-dimensional, two-valued strength-two trade condition leaves
  exactly \(B_3/\mathbf F_7\) and \(H_3/\mathbf F_{11}\).
- **Exceptional outputs.** The three quotient ranks are \(3,6,10\), with the
  \(A_3/\mathbf F_5\) row serving as the nonsplitting comparison; for the two
  survivors, quadrics recover the unordered sheets and the first nonzero signed
  moment is a cubic that orients them. Their homogenizations are self-associated
  and arithmetically Gorenstein, with that cubic as the inverse system.
- **Sharpness.** For either surviving stabilizer, the ambient fixed locus is a
  rational affine line. Its matching point is the unique geometrically split point,
  while \(q-2\) nonmatching orbits retain the same trade condition; the omitted
  rational parameter is the coalescence point.
- **Source and novelty boundaries.** The exceptional one-factorizations are
  declared classical, as is the general self-dual-code/Schur-square implication to
  Gorensteinness. The paper claims the all-field trade classification, fixed-line
  boundary, sheet reconstruction, and cubic orientation. The companion-paper
  connection is expressly nonlogical.

That is unusually good coverage for a technically dense abstract/introduction.
There is no material overclaim in the headline as rendered: “sharp” is supported by
an explicit off-carrier family, and “all odd prime powers” is supported by an
all-field exclusion rather than a finite census.

## Gate assessment

| Gate | Result | PDF evidence |
|---|---|---|
| Inverse problem visible immediately | PASS | p. 1: “Restriction to a conic forgets how its marked points were paired into secants.” |
| Quantifier and classification recoverable | PASS | p. 2: “The classification ranges over every odd prime power”; Theorem 1.1(i) names exactly \(B_3/\mathbf F_7\) and \(H_3/\mathbf F_{11}\). |
| Exceptional outputs recoverable | PASS | pp. 1–3: the abstract, the three-row rank table, and Theorem 1.1(ii)–(v). |
| Sharp carrier boundary recoverable | PASS | pp. 1–4: fixed line, \(q-2\) nonmatching trade orbits, unique Chow point, and coalescence qualification. |
| Source/priority boundaries recoverable | PASS | pp. 1–2: classical one-factorizations and general Schur-square/Gorenstein mechanism are separated from the configuration-specific claims. |
| Standalone theorem foregrounded | PASS with minor hierarchy residue | Theorem 1.1 begins on p. 2 and the p. 3–4 reading map makes its dependencies navigable, but series material and literature positioning precede it. |
| Later proof structure supports the pitch | PASS | Proposition 2.1 → Lemma 3.5/Theorem 3.6 → Theorem 3.9 → Propositions 4.1–4.2 → Theorems 4.3 and 4.6; Appendix A is honestly marked load-bearing. |

## Concerns and exact fixes

Every concern below is minor; none calls for changing the theorem or proof.

### 1. Opening hierarchy retains avoidable series residue

- **PDF p. 1:** title banner “**Clebsch: Rigidity from Sparse Shadows — II**”.
- **PDF p. 1:** epigraph “**From deep holes, a cubic takes shape; its companion
  finds its bearings, / the carrier stands fixed while their shadows move; from
  minimum words, the plane returns, / and the scattered shadows gather home.**”
- **PDF p. 2:** “**Connections with the other papers follow from this
  reconstruction and are not used here; Paper V identifies the resulting chordal
  shadow with a conference companion only after the additional marking stated
  there [15].**”

The subtitle is standalone and the theorem appears on p. 2, so this is not a
structural failure. But the opaque epigraph and the Paper V sentence make the reader
parse series continuity before reaching Theorem 1.1. The explicit statement that
Paper V is not used makes that pre-theorem sentence particularly easy to move to
related work or delete. If the series banner must remain, the mathematical subtitle
already does all necessary orienting work.

**Source locations:** `clebsch_factorization.tex:38–49`, `:104–111`.

### 2. The theorem is preceded by a long priority defense

- **PDF p. 2:** “**Accordingly, the general self-associated/Schur-square/Gorenstein
  mechanism is background here, not a priority claim. Our theorem starts from
  different input.**”

This is accurate and the source boundary is valuable, but the full
Rodríguez-Pajares–Ruano–Salizzoni paragraph appears before the theorem, after the
series paragraph. The theorem would be more strongly foregrounded if this paragraph
followed Theorem 1.1 (or were compressed before it to one sentence). The current
ordering makes the paper defend priority before the reader has seen the precise
claim.

**Source location:** `clebsch_factorization.tex:126–139` (paragraph immediately
before the rank table and theorem).

### 3. Optional appendices are a real secondary-paper branch

- **PDF p. 26:** “**Appendices B, C, E, and F record H3 refinements that use a
  chosen A4-structure; Appendix D compares the arithmetic marker data of all three
  configurations.**”
- **PDF p. 4:** “**Appendices B–F may be skipped on a first pass.**”

The navigation is candid, and placing these appendices after the conclusion protects
the main proof. Even so, pp. 32–42 develop decorated parents, depth profiles,
projective-cover bridges, marker algebras, a profile-plane cubic, and a relative-cubic
Tate plane—roughly eleven pages that are not outputs of Theorem 1.1. This is the only
substantial scope drift. For a lean standalone submission, B–F are natural supplement
or separate-note material. If retained, the existing skip instruction is sufficient
to prevent a MAJOR verdict.

**Source location:** `clebsch_factorization.tex:2092–2110`, followed by Appendices
B–F.

### 4. One displayed citation is visibly malformed

- **PDF p. 29:** “**St ⊗ Y1 ≃ T(2q)[10, Lemmas 1.3 − −1.4].**”

The citation is glued to the formula and the range renders as two minus signs rather
than an en dash. Move the citation outside the display (or put it in textual math-safe
content) so it reads “... \(T(2q)\) [10, Lemmas 1.3–1.4].”

**Source location:** `clebsch_factorization.tex:2358–2365`.

### 5. The verification source has no stable public locator

- **PDF p. 43:** “**The fingerprint identifies the source closure; it is not an
  immutable public locator.**”
- **PDF p. 42:** “**From the root of the archival source, the aggregate entry point
  is `python3 verification/verify_release.py`.**”

The logical trust boundary is excellent: text proof, classical inputs, Lean gates,
certificates, and cross-checks are separated claim by claim. But a cold reader of the
PDF is not told where to obtain “the archival source.” Before circulation or
submission, add a stable repository/archive URL or DOI and identify the fingerprinted
release there. The current digest is an identity check only after the source has been
found.

**Source location:** `clebsch_factorization.tex:3412–3442`.

### 6. One journal reference is bibliographically incomplete

- **PDF p. 45:** “**T. Braun and G. Nebe, Orthogonal representations of SL2(q) in
  defining characteristic, Beiträge zur Algebra und Geometrie (2025).**”

The DOI is correct, but the published citation should include volume, issue, and
pages: **66(3), 717–725 (2025)**. This was checked after the PDF-first read against
the [RWTH publication record](https://www.mathematik.rwth-aachen.de/cms/mathematik/forschung/publikationen/bibliographie/~ckus/einzelansicht/?file=994478).

**Source location:** `clebsch_factorization.tex:3655–3662`.

## Repetition, staleness, and overclaim audit

- **No stale external reference found.** In particular, arXiv:2512.16766 is still
  v1 on the [current arXiv record](https://arxiv.org/abs/2512.16766), and
  arXiv:math/0703685 remains a single-version preprint on its
  [current arXiv record](https://arxiv.org/abs/math/0703685). Reference [16] is
  incomplete, not stale.
- **No harmful claim repetition.** Abstract, introduction, theorem, reading map,
  and conclusion repeat the spine at different rhetorical levels. The closest thing
  to defensive repetition is the priority paragraph before Theorem 1.1, addressed
  above.
- **No scope overclaim.** “All-field” consistently means all odd prime powers and
  full matching orbits, not arbitrary ambient conic-fiber points. The fixed-line
  theorem explicitly demonstrates why the matching-carrier hypothesis is necessary.
- **No hidden computational substitution for the main proof.** Theorem 3.6's
  exclusion is textual and Appendix A is load-bearing; finite reconstructions are
  labeled cross-checks or optional-appendix inputs. Appendix G's trust table matches
  what the proofs actually use.

## Proof-spine cold read

The later structure delivers what the opening promises:

1. Proposition 2.1 gives the common conic restriction and affine quotient, with the
   four-endpoint switch supplying the local mechanism.
2. Lemmas 3.1–3.5 convert a two-valued trade into two
   \(\operatorname{PSL}_2(q)\)-sheets and use targeted outer-parity detectors plus
   Faber's tame subgroup list to force sheet size \(q\).
3. Theorem 3.6 then uses orbit–stabilizer and Dickson/exceptional subgroup orders to
   leave \(q=5,7,11\), excludes the fused \(q=5\) row, and obtains exactly the two
   claimed matching orbits. Its converse is explicitly deferred to Propositions
   4.1–4.2; the reading map prevents that forward reference from looking circular.
4. Lemma 3.7 and Theorem 3.9 give the common radial witness and quotient ranks
   \(3,6,10\), including the exact five-dimensional middle-layer loss in \(H_3\).
5. Propositions 4.1–4.2 prove that the square algebra has the sheet-sign line as its
   unique trade, giving intrinsic unordered-sheet recovery.
6. Theorem 4.3 proves the advertised fixed-line/unique-Chow-point boundary and the
   exact \(q-2\) off-carrier ambiguity.
7. Lemma 4.5 and Theorem 4.6 force a nonzero cubic as the first signed moment and
   derive self-association and Gorenstein duality without assuming them.

The causal chain is therefore real, not just an opening-page slogan. The difficult
all-field step is expanded rather than hidden, and the optional refinements begin only
after the main conclusion.

## Bottom line

**MINOR.** The paper is already cold-readable as a standalone classification and
reconstruction theorem. Preserve the theorem and proof architecture. The highest-EV
framing edit is to remove or relocate the p. 1 epigraph, the pre-theorem Paper V
sentence, and the long priority paragraph; the remaining issues are appendix scope,
one malformed citation, one incomplete bibliography entry, and the release locator.

## Semi-blind A/B addendum

**B artifact:** rebuilt 45-page PDF after the scoped
`clebsch_factorization.tex` revision.
**Scoped A/B verdict:** **PASS.** The revision resolves the opening-hierarchy,
priority-placement, malformed-citation, and Braun–Nebe metadata concerns without
weakening attribution, hypotheses, or proof support. The paper-wide verdict remains
MINOR only for the untouched optional-appendix scope and verification-archive locator.

### Hierarchy and page flow

- **B p. 1:** the epigraph is gone. The abstract begins directly below the title
  block, and the opening problem/result paragraph remains on p. 1. This removes the
  opaque series poetry without changing the abstract.
- **B p. 2:** “**The classification and reconstruction are standalone; no
  companion construction is used here.**” replaces the Paper V pointer. Theorem 1.1
  now fits completely on p. 2, including clauses (i)–(vi), instead of continuing onto
  p. 3. This is the decisive A/B improvement.
- **B p. 3:** the full Rodríguez-Pajares–Ruano–Salizzoni attribution now precedes
  the reading map rather than the theorem: “**That general mechanism is not a
  priority claim here. The new input and outputs are the all-field trade
  classification, sheet reconstruction, sharp matching boundary, and orbit-specific
  cubic orientation in the theorem above.**” It is neither orphaned nor visually
  detached from the theorem.
- The series numeral in the banner, “**Clebsch: Rigidity from Sparse Shadows — II**”
  (B p. 1), remains. This is harmless residual branding now that no series map,
  companion promise, or companion bibliography entry interrupts the standalone
  opening.

### Hostile-referee invariants

- **All-field quantifier preserved:** B p. 2 still says “**among all odd prime
  powers \(q\)**” and still restricts the claim to full perfect-matching orbits under
  \(\operatorname{PGL}_2(q)\). No drift to arbitrary ambient configurations occurred.
- **Matching-carrier sharpness preserved:** B pp. 1–2 retain the unique split point,
  the \(q-2\) nonmatching trade orbits, and clause (vi)'s fixed affine line. B pp. 3–4
  retain the coalescence qualification and the Chow-locus repair.
- **External versus new Gorenstein claims improved:** B p. 2 gives the short warning
  before the theorem—“**The general implication from self-dual codes and their Schur
  squares to Gorenstein coordinate rings is background here**”—while B p. 3 supplies
  the exact source and theorem/corollary numbers. Theorem 1.1(v) remains a proved
  configuration-specific identification, not a priority claim for the general
  implication.
- **Proof-mode descriptions remain honest:** no proof statement was changed. The
  textual all-field detector argument and load-bearing Appendix A remain separate
  from symbolic rank proofs, exact cross-checks, computer-assisted optional
  propositions, Lean gates, and certificate replays. The p. 3 reading map still
  identifies Appendix A as required only at the detector node and Appendix G as
  supplying no logical premise.

### Repairs and regression check

- **B p. 29:** the display now ends cleanly with “**\(\operatorname{St}\otimes
  Y_1\simeq T(2q)\).**” The next sentence renders “**[10, Lemmas 1.3–1.4]**” with a
  correct en dash and spacing. Attribution was preserved and made easier to read.
- **B p. 45:** Braun–Nebe now renders as “**Beiträge zur Algebra und Geometrie
  66(3) (2025), 717–725**,” followed by the same DOI. The natural DOI line wrap is
  legible. Removing the now-unused Paper V entry leaves 15 consecutively numbered
  references and no visible unresolved citation.
- The PDF remains 45 pages. The opening gains space, Theorem 1.1 no longer breaks
  across pages, the p. 3 attribution/reading-map transition is balanced, and no later
  theorem or appendix changed page in a way that creates a framing regression.

**A/B conclusion:** accept the scoped revision as-is. No follow-up manuscript change
is required for these four fixes.
