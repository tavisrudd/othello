# C919 follow-up — synthesis of the five abstract-review memos

**Lane:** `clebsch` · **Date:** 2026-08-19 · **Status:** review complete, nothing applied to any manuscript

Reviews the external proposal in `../2026-08-19-c919-abstract-tightening-proposal.md` against the
five committed manuscripts. Per-paper memos sit beside this file. No manuscript, build, or release
action has been taken; every abstract is still the committed one.

## 1. The proposal is not a tightening pass

| paper | current | proposed | reviewer's counter-draft |
|---------------------------|--------:|---------:|-------------------------:|
| I — rigidity              |     257 |      228 |                      220 |
| II — factorization        |     256 |      253 |                      235 |
| III — passages            |     251 |      257 |                      248 |
| IV — q13 passant code     |     184 |      194 |                      182 |
| V — chordal/conference    |     342 |      248 |                      264 |

(Word counts are each memo's own, math groups counted as one token; they differ by a word or two
from a raw `wc -w` on the abstract environment.)

Only Paper V is a real compression. Papers III and IV get *longer* under the proposal, and Paper II's
replacement is the current abstract with four small deltas. All five reviewers, working
independently and without seeing each other's memos, reached the same structural verdict: every
mathematical claim in the proposal is supported by the corresponding body, no proposed claim
overreaches its theorem, no undefined macro is introduced — and the swap should still be declined in
favour of targeted upgrades, because the proposal buys precision, not brevity.

## 2. What the proposal genuinely improves

- **Paper I.** Reordering so recognition, orientation lift, and uniform consequence occupy one
  paragraph each; removal of the thrice-stated reconstruction idea.
- **Paper II.** "Signed tensor moments vanish through degree two" (supported, and the missing
  antecedent for "first nonzero"); deletion of the alternating-cycle/Dickson proof-machinery
  sentence.
- **Paper III.** Exactly three wording refinements: "under the marked Petersen pair-sum comparison"
  in place of "on the Petersen four-space"; "four-blocks" in place of "blocks", matching the
  theorem's principal four-subsets; "every symmetric conference signing" for the theorem's universal
  quantifier.
- **Paper IV.** Promoting the conceptual theorem — the weighted two-section of the minimum-support
  hypergraph is a complete invariant of the marked presentation — into the abstract, where the
  keywords already advertise the term and the abstract never used it.
- **Paper V.** Cutting the redundant second sentence, the `\varphi^2-\varphi=(n-2)I/4` display, and
  the nonsplit-extension interior detail.

## 3. Regressions the proposal would introduce, caught by review

1. **Paper II — dropped attribution specificity.** The proposal rewrites "General self-dual-code
   criteria already explain the Gorenstein consequence *of the Schur square*" without the "already"
   and without naming the Schur square. That sentence is the paper's disclaimer of a general
   mechanism it does not claim; the proposal's own cross-paper check demands the disclaimer it then
   weakens. Restore the current wording.
2. **Paper IV — dropped "up to isomorphism".** The complete-invariant claim is stated in the paper's
   conclusion as holding for the marked presentation *up to isomorphism*. The proposal's headline
   sentence omits the qualifier while its own red-team note requires it. Restore.
3. **Paper V — dropped mod-8 dichotomy.** The induced algebra on the binary quotient is
   \(\F_4\) for \(n\equiv6\pmod 8\) and \(\F_2\times\F_2\) for \(n\equiv2\pmod 8\); that dichotomy is
   the entire general-\(n\) content of the residue half of two headline theorems. The proposal's
   compressed paragraph does not literally assert \(\F_4\) everywhere, but it states the general
   theorem and then produces an \(\F_4\) structure with no signal that the algebra depends on
   \(n \bmod 8\). Keep the dichotomy as one clause (about twenty words); the reviewer's middle path
   is cheaper than the proposal's own fallback of restoring the whole old paragraph.
4. **Paper V — dropped "which fixes \(c\)".** Three words, and the one-glance reason the
   line-forgetting torsor differs from the conference-orientation torsor. Restore.
5. **Paper V — undefined term in a displayed identity.** The proposal keeps
   \(16|A(\Delta)|=\sum m(xy)^2\) but drops the definitions of the triple sign, the pair defect, and
   \(A(\Delta)\), leaving the display unverifiable from the abstract alone.

One omission is older than the proposal and worth fixing in either version: **Paper II's current
abstract never says the trade recovers the two complementary sheets only *up to interchange***,
which is the theorem's exact qualifier and the reason the cubic is needed for orientation.

## 4. TeX hazards

- `\PGL` and `\PP` are **not defined** in Paper I's or Paper III's preamble (Paper III defines
  `\PSL` only). The proposal's global style note tells the editor to preserve those macros; importing
  either into those two papers fails to compile.
- The proposal writes `\(…\)` and `\[…\]` throughout; Paper I's manuscript is uniformly `$…$`.
- The proposal puts display math in the abstracts of Papers I and III. Both expressions already sit
  inline in the committed abstracts, and displays cost page-1 vertical space against a title,
  keywords, and MSC block that currently fits. No display belongs in any of these abstracts.

## 5. Separate manuscript issues found while reviewing (reported, not fixed)

- **Paper I:** the universal chord-defect *Theorem* carries `\label{lem:chord-defect}` and the
  conic-filling window *Theorem* carries `\label{cor:conic-filling-window}` — leftovers from
  promotions. Harmless to compilation; misleading if either label is ever renamed.
- **Paper IV:** the abstract's "making *it* twelve-dimensional over that field" has an ambiguous
  antecedent (the relation algebra's image is one-dimensional over \(\F_8\)); the "therefore" in
  "pair parity recovers \(K\) … reconstruction therefore has exact arity two" draws the arity
  conclusion from the wrong premise (it needs full pair-data sufficiency, stated a sentence
  earlier); the keywords advertise "weighted hypergraph 2-section", a term the abstract never uses;
  and the abstract's opening question is repeated verbatim as the introduction's first sentence.
- **Paper V:** line 138 uses a word on the author's forbidden list ("honest metric groupoids") and
  needs rewording. The non-projective-isomorphism-over-the-closure claim, which both the abstract and
  the hook depend on, has no numbered statement in the body — it is carried by the six-isolated-nodes
  versus singular-along-a-curve contrast plus a "geometrically distinct" line in the conclusion; a
  one-line remark would close the gap. The conclusion's "without identifying the two invariant cubic
  lines themselves" undercounts: the pencil carries three distinguished lines, one conference and two
  chordal.

## 6. Where this leaves the tight-and-short goal

The reviewers' counter-drafts average about 230 words. That is better than the committed set
(258 average) and much better than the proposal (236 average, with the two longest papers growing),
but it is still long against a typical journal abstract of 150 to 200 words. Every counter-draft was
written under the instruction to keep every load-bearing theorem and every scope qualification, so
none of them could go further: the remaining length is third-tier theorem advertising, and cutting
that is an author decision about what each paper leads with, not a reviewer decision about accuracy.

If a genuinely short set is wanted, the cuts available are, per paper:

- **Paper I** — the decoder-recovery list (Brianchon points, self-polar triangles, support
  bipartition) or the uniform \(k\)-arc window. The window is the paper's only field-uniform theorem
  and both the proposal and the reviewer argue for keeping it, so the list is the cheaper cut.
- **Paper II** — the Gorenstein/Macaulay sentence and the Faber-exhaustiveness sentence, which
  together are method and context rather than the classification itself.
- **Paper III** — the Stein-algebra and residue-fibre clause, or the two independent structural
  consequences reduced to one clause naming them without their sharpness constants.
- **Paper IV** — already the shortest and the only one that needs no compression.
- **Paper V** — the \(n=6\) torsor identification, keeping the lattice theorem and its dichotomy.

Each of these drops an advertised result from page 1; none of them changes a theorem.
