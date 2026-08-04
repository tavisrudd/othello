# C862 — cold adversarial review of the applied front-matter and Paper III edits

**Date:** 2026-08-04
**Lane:** clebsch
**Status:** read-only review of commits `3984efa9` and `1bc774d5`; this file is the
only write; no manuscript, verification, Lean, or mirror file was changed.

Checks performed independently of the two C862 notes: symbolic verification of the
Pfaffian/complementary-minor/Hodge identity for arbitrary symmetric matrices under
the paper's exact star convention; exhaustive verification of the Seidel
principal-minor identities (`1x1`, `2x2`, `3x3 = 2abc`, `4x4 = 3 - 2w` with value
set `{-3, 5}`); exhaustive verification over all 32768 graphs that six vertices are
insufficient for aligned-family reconstruction (192 of the 1024 labeled six-vertex
two-graphs are not determined up to complement — the "six are not" clause is true);
a constructed counterexample to the new lemma's fibre clause (below); section-hash
spot check against `verification/statement_identity.json` (all match); and
confirmation that Paper I reconstructs the Clebsch code over `F_11`
(`clebsch_rigidity.tex:149-156`), so the two-elevens clause is factually right.

## Verdict

One genuine mathematical error and one proof-level gap, both confined to the newly
promoted square-class lemma in `sections/02-orientation-cover.tex`; everything the
paper actually proves about its own situation is untouched, because the Hitchin
application (same file, lines 246-257) carries exactly the hypothesis the general
lemma dropped. Every other new assertion checked out, most of them by independent
computation. The edits serve the three aims well and do not read as defensive. The
lemma must be corrected before any mirror sync or release refresh.

## Mathematical errors and overstatements, most severe first

### 1. The fibre clause of the new square-class lemma is false as stated

`papers/clebsch-passages/sections/02-orientation-cover.tex:188-190`:

> Moreover, if \(x\in X(k)\) lies off the branch divisor and the normalization of
> \(X\) in \(M\) has residue algebra \(k(\sqrt d)\) at \(x\), then \(c=d\).

Counterexample: \(X=\mathbf P^1_{\Q}\), \(\mathcal L=\mathcal O(1)\),
\(J=2(x^2+y^2)\in H^0(\mathcal O(2))\) (irreducible zero divisor, the closed point
with residue field \(\Q(i)\)), \(M=\Q(t)(\sqrt{2(t^2+1)})\). Every hypothesis
holds, and \(c=1\) (take \(s=y\)). At the rational point \(t=0\), off the branch
divisor, the residue algebra is \(\Q(\sqrt2)\), so \(d=2\neq1=c\).

What specialization actually evaluates is \(c\cdot[J(x)]\), where \([J(x)]\) is the
canonical square class of the value \(J(x)\) in the one-dimensional fibre
\(\mathcal L_x^{\otimes2}\) (well defined because a basis change of
\(\mathcal L_x\) rescales it by a square). So \(d=c\cdot[J(x)]\), and \(c=d\)
only when \(J(x)\) is a square in the fibre. The paper's own application is
careful about precisely this point: lines 250-252 note that \(j_e(xyz)\) differs
from \(J_0(xyz)=(16/25)^2\) by a rational square before concluding the residue
algebra is \(\Q(\sqrt c)\). The general lemma dropped that step.

Proposed corrected wording for the moreover clause:

> Moreover, if \(x\in X(k)\) lies off the branch divisor, then the residue algebra
> of the normalization of \(X\) in \(M\) at \(x\) is \(k(\sqrt{c\,[J(x)]})\), where
> \([J(x)]\in k^\times/k^{\times2}\) is the square class of the value
> \(J(x)\in\mathcal L_x^{\otimes2}\); in particular, when \(J(x)\) is a square in
> that fibre, the residue algebra \(k(\sqrt d)\) gives \(c=d\).

The closing gloss (lines 195-198, "one unramified rational point whose fibre is a
quadratic field reconstructs every rational quadratic twist") should gain the same
qualifier, e.g. "one unramified rational point where \(J\) takes a square value".
The sentence "Only the second sentence is specific to the situation at hand" should
also be rewritten — as written it is unclear which sentence it means, and the
moreover clause is no less general than the rest.

### 2. The lemma's proof needs the divisor class group, not the Picard group

`sections/02-orientation-cover.tex:179-180` (hypothesis
"\(\operatorname{Pic}(X)\) free of two-torsion") versus lines 193-194 ("the
resulting divisor class is two-torsion, hence trivial"). The divisor \(F\) with
\(\operatorname{div}(e/j)=2F\) is a priori only a Weil divisor on the normal
variety \(X\), so the two-torsion class lives in the divisor class group
\(\operatorname{Cl}(X)\), which can strictly contain \(\operatorname{Pic}(X)\)
when \(X\) is normal but not locally factorial. Fix: state the hypothesis as "the
divisor class group of \(X\) has no two-torsion" (or assume \(X\) smooth or
locally factorial). The application to \(\mathbf P(H)\) is unaffected —
\(\operatorname{Cl}=\operatorname{Pic}=\mathbf Z\) there, and the pre-existing
concrete argument at lines 200-226 already says
\(\operatorname{Pic}(\mathbf P(H))=\mathbf Z\) correctly.

Two hypothesis nits in the same statement: "proper" is redundant given normality
plus \(H^0(X,\mathcal O_X)=k\) (a rational function with zero divisor on a normal
variety is a global regular function by the codimension-one Hartogs argument); and
characteristic zero is only used as characteristic not two. Neither is an error;
the task asked for unused hypotheses, and "proper" is the one.

### 3. "Accordingly" in the new abstract opening slightly overstates the implication

`clebsch_passages.tex:48-50`: "…whose residue-field pinching has square class
\([5]\); accordingly the cover's function field is
\(\Q(\mathbf P(H))(\sqrt{5J_0})\)." Section 2 itself disclaims exactly this
inference: "This local model explains the descent geometry but does not replace
the comparison with Hitchin's incidence scheme below"
(`02-orientation-cover.tex:105-106`). The function-field statement additionally
needs Hitchin's branch-sextic identification and the local comparison at
\([xyz]\). The compression is defensible at abstract register, but "accordingly"
asserts the pinching as the proof. Proposed: replace "; accordingly the cover's
function field is" with "; with Hitchin's branch sextic this makes the cover's
function field" — or simply "; the cover's function field is". Everything else in
the sentence is accurate: the meeting point, the nonsplitness, the two branches,
and the discriminant square class \([5]\) of \(\Q(\sqrt5)/\Q\) are all proved at
`02-orientation-cover.tex:59-106`.

### 4. Category slip in the principal-minor paragraph

`sections/05-golden-operator.tex:352-354`: "The odd principal minors trivialize
the problem: the \(1\times1\) minors vanish, the \(2\times2\) minors are all
\(-1\), and a \(3\times3\) principal minor is twice the triangle sign…" The
\(2\times2\) minors are even-order; listing them under "odd principal minors" is
wrong as a sentence even though every numerical claim in it is verified correct.
Proposed: "The principal minors of order at most three trivialize the problem:
…". The later phrase "this negation-invariant even-order data" is then also
cleaner, since the (constant) \(2\times2\) minors are even-order too and the text
means specifically the fourth order.

## New assertions verified correct (no action needed)

- **Pfaffian equals middle-exterior diagonal for every symmetric matrix.**
  Verified symbolically for random symmetric matrices (including nonzero
  diagonal): the coefficient of \(x_S\) in \(\operatorname{Pf}[D_x,A]\) is
  \(\operatorname{sgn}(S^c,S)\det A[S^c,S]\), which is exactly
  \((*\!\bigwedge^3A)_{SS}\) under the paper's stated star convention
  (`05-golden-operator.tex:406-424`). The reading of the existing proof is right:
  the matching expansion and Hodge identification at lines 561-564 are general,
  and only the final sentence ("Two dihedral representatives and complementation
  give \((K_T)_{SS}=4(C_T)_{ij}(C_T)_{jk}(C_T)_{ki}\)") uses the conference
  structure. So "one identity written twice" is accurate.
- **Cross-block versus within-\(S\) disjointness.** \(\det A[S^c,S]\) uses only
  entries joining \(S\) to \(S^c\); the triangle product uses only entries inside
  \(S\); for a symmetric zero-diagonal matrix these entry sets are disjoint and
  algebraically independent, so "unrelated for a general symmetric zero-diagonal
  matrix" is defensible, and C809's recognition result backs "the one
  identification that could fail".
- **Seidel principal-minor arithmetic.** All verified exhaustively:
  \(1\times1=0\), \(2\times2=-1\), \(3\times3=2abc\), and
  \(\det C[Q]=3-2w(Q)\in\{-3,5\}\) over all 64 sign patterns; fourth-order
  principal minors are negation-invariant and carry exactly the one aligned bit.
- **Sharpness clause.** "Seven vertices are enough and six are not": the
  six-vertex failure is true (verified by exhaustive search; 192 of 1024 labeled
  six-vertex two-graphs share an aligned family with a non-complement partner).
  Note the manuscript itself still exhibits no six-vertex counterexample near the
  theorem — this claim predates the edits, but a referee may ask where sharpness
  is proved.
- **Query-count reconciliation.** "…suffice, and the decoder in the proof uses
  exactly this many" matches the proof (`05-golden-operator.tex:330-339`, "Query
  all four-sets meeting \(Q\) in at least two points … No further query is
  used"), and the count \(1+4(n-4)+6\binom{n-4}{2}=3n^2-23n+45\) is right. The
  exact-count claim is correctly scoped to after the anchor is found; the twenty
  anchor tests are stated separately. This settles the old
  sufficiency-versus-exact-count ambiguity in the right direction.
- **Two-elevens clause.** Paper I reconstructs the Clebsch code over \(\F_{11}\)
  (`clebsch_rigidity.tex:149-156, 247`), and \(46189=11\cdot13\cdot17\cdot19\) is
  the Wigner denominator; the disambiguation is accurate.
- **Abstract's exchange-spectrum sentence.** "The balanced exchange spectrum is
  the squared singular spectrum of its cut block" matches
  Theorem `thm:balanced-exchange-rigidity` (up to the \(1/q\) normalization,
  acceptable at abstract register), and "cut-independence singles out order six"
  matches the \(d\le3\) classification with the trivial order elided.
- **Relative-marking discipline.** Intact everywhere. The abstract keeps "These
  sign comparisons are relative to the marked datum…"; every promoted sentence
  that touches a sign ("Fixing the marked bridge datum attaches the chosen
  sign…", "Its oriented cubic…") carries or presupposes the marking; the new
  inventory and principal-minor paragraphs assert only switching-invariant or
  intrinsically combinatorial content. No regression of the C733 repair.

## Consistency findings

- `verification/statement_identity.json` and
  `verification/check_manuscript_build.py` were updated coherently: section
  hashes match the current files (spot-checked by sha256), the three shifted
  `source_line` values are exact, the updated `thm:aligned-faithfulness` text
  matches the manuscript, and the page count bump to 28 accompanies the added
  material.
- The old "four equivalent descriptions" phrasing is gone from every `.tex` file;
  abstract, introduction (`01-introduction.tex:195-197`), operator section, and
  conclusion now agree on the by-type billing. `ARTIFACT.md` and
  `literature-boundaries.md` contain nothing contradicting the new framing.
- **Stale: the three README series lines.** `clebsch-passages/README.md:5`,
  `clebsch-factorization/README.md:5`, and `clebsch-rigidity/README.md:5` still
  carry the retired subtitle "*The Clebsch cubic: recovering, orienting, and
  realizing — N*" that commit `3984efa9` removed from the title pages.
  `clebsch-passages/README.md:12` also still opens "The paper determines the
  rational twist…", the framing the abstract just moved away from, and its
  summary omits the new keywords' principal-minor language. Not wrong, but the
  public entry points now trail the manuscript.
- Paper IV (`q13-passant-code`) gained the epigraph and the unified banner but
  still has no Mathematics Subject Classification line — it remains the only one
  of the four without MSC codes, an inconsistency both notes flagged and the
  commit did not close. Its body line 795 still says "the Clebsch cubic program",
  harmless as prose but the last trace of the retired label.
- The five-clause epigraph's final clause ("and gathers its shadows home") is
  bolded in no released paper — it belongs to the unreleased Paper V. The notes
  chose this deliberately; recording here that all four released papers now
  advertise a fifth movement that does not yet exist.

## Did the edits serve the three aims?

**Emphasize the general theorems: yes.** The retitle to "Exchange spectra of
symmetric conference matrices", the "order six is its answer, not its hypothesis"
lead-in, the principal-minor restatement, the Seidel/two-graph keywords, and the
05B20/05C22 MSC codes together move the paper's most exportable theorem into
searchable language at essentially zero cost. The principal-minor paragraph is not
padding: it adds the genuinely sharper point that the reconstruction consults only
the negation-invariant fourth-order data and never the odd minors that would
trivialize the problem, which is the correct pre-emption of a "minors determine
symmetric matrices — known" referee.

**Blunt the one-exceptional-object reading: partly, as far as prose can.** The
abstract now opens on a mechanism (a discriminant forced by residue-field
pinching) rather than a computed constant, and the general theorems each get a
quantified sentence. The remaining exposure is content placement, exactly as the
independent Fable note argued; no prose edit was going to move that, and none
pretended to.

**Not burying the beauty: preserved, and arguably improved.** The inventory
paragraph reads as confident bookkeeping, not apology — "not four coincidences of
equal standing" and "the one identification among the four that could fail" give
the exceptional object a sharper pedestal than "four equivalent descriptions"
did, because the miracle is now located precisely instead of diffused over four
items. The conclusion's added sentence does the same. The five-clause epigraph
keeps the affection. No sentence in the new material reads as defensive; the
closest to a cost is that the abstract's middle paragraph is now long and asks
the reader to resolve "the middle two" and "the last" against a four-item list —
naming them ("the exterior-diagonal and Pfaffian descriptions agree for every
symmetric matrix, and the cross-golden determinant reformulates the golden
splitting") would remove the only friction in an otherwise strong rewrite.

## What I would still change

1. Fix the square-class lemma's fibre clause and its Pic-versus-Cl hypothesis
   (findings 1 and 2) — the only mandatory items, and both are two-line edits
   confined to the new paragraph.
2. Soften "accordingly" in the abstract (finding 3).
3. "Principal minors of order at most three" for "odd principal minors"
   (finding 4).
4. Regenerate the three README series lines and the Paper III README summary from
   the current sources; add the missing MSC line to Paper IV.
5. Optional: name "the middle two" descriptions explicitly in the abstract.
