# C816 gate 2 follow-up — verification of the landed edits (commit `89b046502`)

**Task:** C816 (`clebsch` lane). Read-only verification of commit `89b046502`
against `notes/2026-08-20-c816-suggested-edits-referee.md`.
**Date:** 2026-08-20.
**Constraint honoured:** nothing under `papers/` was touched; only this file was
written.

## Verdict

The commit is faithful and complete: all eight tightened blocks landed verbatim
at the right sites, with no truncation, no duplication of replaced text, and no
collateral change to neighbouring prose; the three-site "nonzero" repair landed;
the three bibliography entries match house format (including the arXiv version
suffixes the surrounding entries carry) and their cite keys resolve; nothing
stale survives anywhere in the paper; and the verification scaffolding was
updated consistently. One residual defect, low severity, reported only: the
conclusion's new qualifier "whenever no off-diagonal entry vanishes" is
necessary but not sufficient — the sentence still omits hollowness, and both
cubics are diagonal-blind, so a diagonal perturbation of the pentagon
representative satisfies every stated hypothesis while failing the scalar-square
conclusion. The extra page is carried by content.

## 1. Diff fidelity — confirmed

`git show --stat` shows exactly the expected files: the abstract, introduction,
operator section, conclusion, references, the tracked PDF, and two verification
files. Per-file diffs check block by block against my report:

- **Edit A** (tangent-space proof, two paragraphs) — verbatim, correctly seated
  between the retained lower-bound paragraph and the retained injectivity
  sentences; the old "Equality holds, and the splitting is visible" block is
  fully gone.
- **Edit B** (implicit function theorem) — verbatim; the retained final proof
  sentence on odd signed permutations follows directly.
- **Edit C** (theorem statement's last clause) — verbatim; the old "opposite
  oriented representative" clause is gone.
- **Edit D** (abstract) — verbatim; "characterizes" and the old hypothesis
  order are gone; "of even order" correctly absent.
- **Edit E** (priority boundary) — verbatim, in the intended slot after the
  boundary paragraph at the old lines 348–351 and before
  `\paragraph{Rigidity of the equality.}`.
- **Edit F** (magnitude versus sign) — verbatim; the old "It is not the
  output" sentence is gone.
- **Edit G** (inclusion-rank induction) — verbatim; the old half-sentence
  descent is gone.
- **Edit H** — both one-line repairs landed ("nontrivial" in the introduction;
  "of order six" at the four-descriptions paragraph).

No hunk touches anything outside the eight target spans plus the three
"nonzero" sites.

## 2. The three-site "nonzero" fix — landed; conclusion still one word short

Abstract and introduction now both carry "nonzero proportionality" with the
full matrix class stated. The conclusion reads "nonzero proportionality of the
commutator Pfaffian to the triangle cubic forces order six and a scalar square
whenever no off-diagonal entry vanishes".

The coordinator's reasoning for adding an entries hypothesis there is correct:
the old sentence carried no hypothesis at all, and the order-four zero matrix
kills it (both cubics vanish identically, so proportionality holds with any
nonzero constant, at the wrong order). The added qualifier is real progress and
reads well in place. But it is not yet sufficient, and this is the one defect
of the commit. Both cubics ignore the diagonal entirely — the commutator
\([D_x,A]\) and the triangle products use only off-diagonal entries — so for
\(A=C+\operatorname{diag}(1,0,\dots,0)\) with \(C\) the pentagon
representative, \(\Phi_A=\Phi_C=4\mathcal T_C=4\mathcal T_A\): nonzero
proportionality holds, no off-diagonal entry vanishes, and \(A^2\neq\lambda I\).
"Forces order six" survives (the degree argument is diagonal-blind too);
"and a scalar square" does not. The abstract and introduction state the class
in full and are exact; the conclusion is now the paper's only loose statement
of the theorem — the same species of looseness this whole pass existed to
remove, at the same summary register where the red team flagged it in the
abstract. Minimal repair, for the owner to apply: "whenever the matrix is
hollow with no vanishing off-diagonal entry", or mirror the introduction with
"for hollow symmetric matrices with no vanishing off-diagonal entry".
(Symmetry is arguably supplied by the carrier context; hollowness is the
load-bearing omission, because the counterexample above satisfies everything
else the sentence says.) Reported only; not fixed.

## 3. Edit A in context — continuous, no collision, no duplication

Read end to end in the committed file: the retained paragraph proves
\(\dim T\ge5\); "Equality holds, by the same mechanism..." proves
\(\dim L=5\) and \(T=L\); "The splitting is an eigenspace decomposition..."
derives the involution and names \(T=\mathbf1\oplus\mathbf4\); the retained
sentences then use the Jacobian's injectivity on \(\ker\mu\) and "the
four-dimensional constituent", which is now defined before use. The argument
is continuous, each object (\(L\), \(\mu\), \(P_\pm\), \(p_i\), \(q_i\),
\(\ker\mu\)) is defined at first use, and no sentence duplicates another; the
retained opener "Its dimension is forced rather than computed" is now true of
both bounds. Notation: the passage's \(P_\pm=(I\pm C/\sqrt5)/2\) is the
\(q=5\) specialization of the exchange-spectra subsection's
\(P_\pm=(I\pm C/\sqrt q)/2\) and of the theorem's \(P_{T,\pm}\) at the marked
representative — the same objects under the same sign convention, each defined
locally, so there is nothing misleading; the group element \(h\) and the
functions \(h_S\) of the surrounding proof do not enter the passage.

## 4. Edit E in context, bibliography, and the licence re-check — all pass

The paragraph sits after the theorem's boundary paragraph and before the
rigidity material, so the section's order is statement, open boundary,
priority boundary, rigidity — correct hierarchy. The three `\bibitem` entries
match the house format of the surrounding items exactly (author, `\emph`
title, journal `\textbf{vol}` (year), pages, `\href` doi, arXiv id with
version suffix — the file's other entries carry `v1`/`v2`/`v3` suffixes too).
The bibliography is citation/thematically ordered, not alphabetical, and the
three entries sit adjacent to the other principal-minor references; placement
is consistent with the file's scheme. The volume, year and page data I flagged
as unverified are now confirmed against journal records per the coordinator,
and the landed Beauville DOI (10.1307/mmj/1030132707) is a genuine addition
over the red-team draft, which had no DOI for that entry. Cite keys resolve:
three `\cite` uses in the operator section, keys defined once in the
references file, build warning-free per the gate run.

`OPER-5` licence re-check on the landed text: "What we prove" and "We have not
located" present; "first" and "new" absent; the single negative carries "to
our knowledge"; no novelty claimed for Pfaffian representations ("known
object"), cycle-sum coordinates ("are Huang and Oeding's"), or the
conference/two-graph/tight-frame correspondence ("classical"); attribution
scoping matches the row (Beauville general, Tanturri constructive
cubic-surface, Huang–Oeding cycle-sums, Greaves–Suda principal versus
complementary minors); the searched-domain list matches the row, with one
harmless narrowing — "maximal-determinant design" for the row's
"maximal-determinant/D-optimal-design", which understates the search actually
performed and therefore weakens, not strengthens, the negative. Compliant.

## 5. Nothing broken elsewhere — confirmed

- No occurrence of "constant-rank", "constant rank", or "opposite oriented"
  survives anywhere in `sections/`, the main file, or
  `literature-boundaries.md`.
- The verification section (`08-verification.tex`) nowhere describes the
  rigidity proof's route in terms the edits invalidated (no mention of rank
  theorems, the tangent dimension, or the old clause); its hash is unchanged
  in the commit, correctly.
- `verification/trust_manifest.json` already says "nondegenerate real
  triangle-Pfaffian proportionality forces order six and a scalar square" and
  states the recognition converse "for a real symmetric even-order
  zero-diagonal matrix" — both consistent with the landed text; no row
  contradicts the new prose, and no claim identifier changed.
- `verification/statement_identity.json` was refreshed correctly: the
  `thm:golden-equality-rigidity` entry's stored TeX is byte-identical to the
  landed statement, source lines and section hashes updated for exactly the
  changed files, statement count unchanged at eleven.
- `verification/check_manuscript_build.py` pins `EXPECTED_PAGES = 39`,
  matching the gate run.

## The extra page

Carried by content. The net prose growth is about fifty lines: Edit A replaced
an assertion with a proof, Edit E is a licensed boundary obligation, and Edit G
completed an induction that was previously half a sentence — none of which the
paper can drop. Re-reading each landed block for slack: the only compressible
candidates are Edit E's tight-frame chain sentence and its parenthetical minor
identity, together worth perhaps four lines, nowhere near a page, and both are
doing licensed disclaimer work the `OPER-5` row instructs the paper to carry.
No block is longer than it needs to be.
