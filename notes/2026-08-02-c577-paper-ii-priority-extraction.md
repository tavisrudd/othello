# C577 — Paper II priority extraction

**Lane:** `clebsch`

**Date:** 2026-08-02

## Verdict

Rodr\'iguez-Pajares--Ruano--Salizzoni (2025) pre-empt Paper II's general
self-associated/Schur-square/Gorenstein mechanism.  Their theorem computes
the Schur-square dimension of a self-dual code from its indecomposable blocks
and identifies arithmetic Gorensteinness with indecomposability.

Paper II turns this priority blocker into a reverse rigidity theorem.  Among full
\(\operatorname{PGL}_2(q)\)-orbits of perfect matchings over all odd prime
powers, the two-valued one-dimensional quadratic-trade condition alone forces
\(B_3/\F_7\) or \(H_3/\F_{11}\).  The proof does not assume
self-association, a Gorenstein coordinate ring, or the general self-dual-code
criterion.  For the two surviving orbits, quadratic products recover the two
sheets and the first nonzero signed tensor moment is the sheet-sign cubic.

This is the same priority-judo pattern as C794: prior work owns the forward
mechanism, while the task promotes an exact reverse reconstruction theorem.
Here the forward mechanism passes from self-duality and Schur-square defect to
Gorensteinness.  Paper II instead starts from the intrinsic two-valued residue,
recovers the hidden bipartition, classifies the ambient matching orbit, and
only then derives self-association and Gorenstein duality.

The manuscript now leads with this trade-only classification, credits the
general criterion at first use, and treats Gorensteinness as a downstream
consequence.

## Source audit

This report names one mathematical source, read at full text.

- Gonzalo Rodr\'iguez-Pajares, Diego Ruano, and Flavio Salizzoni,
  *A combinatorial description of when a self-associated set of points fails
  to be arithmetically Gorenstein*, arXiv:2512.16766v1 (18 December 2025).
  **Read depth: full text** — cached v1 preprint, all Sections 1--4 and the
  references.  Cache key `arXiv:2512.16766`, SHA-256
  `9dc89d58c45537bdd3d7844903da5de7d4d55aef9550dd6ddba36064c03882ca`.
  Theorem 3.11 proves
  \(\dim C^{(2)}=2k-\operatorname{nb}(C)\); Corollaries 3.12--3.13 identify
  Gorenstein defect with block defect and arithmetic Gorensteinness with
  indecomposability.  The paper contains no matching-orbit action,
  two-valued-trade classification, \(B_3/H_3\) classification, or signed
  cubic/inverse-system orientation theorem.

The source's two explicit adjacent directions are asymptotic existence of
indecomposable self-dual codes (Section 4) and the proportional-column/fat-point
boundary (Remark 4.3).  Neither is needed for Paper II's exact matching-orbit
theorem.

The seed was pinned as DOI `10.48550/arXiv.2512.16766` and OpenAlex work
`W4417531175`.  On 2026-08-02 OpenAlex returned `cited_by_count = 0`.
Semantic Scholar returned HTTP 429 for the pinned arXiv identifier, and
Crossref returned HTTP 404 for the DOI.  These are coverage failures, not
empty citing sets.  No forward-citation negative and no broader priority
negative is claimed from citation graphs.  MathSciNet, zbMATH Open, and
Google Scholar were not used in this bounded extraction.

## Bounded adjacent-crown extraction

Four candidates were considered:

1. classify full projective matching orbits from the two-valued
   one-dimensional quadratic-trade condition;
2. identify the recovered sheet sign with the first nonzero signed tensor
   moment and prove that it is cubic;
3. specialize the general block-defect theorem to the two configurations;
4. extend the matching construction to repeated endpoints or fat points.

The top two pass the cheap source-separation test.  Candidate 1 has different
input and output from the 2025 theorem and is already the uniform
balanced-orbit classification theorem in Paper II.  It is promoted as the
reverse-recognition crown, not merely retained as an unaffected special case.
Candidate 2 is absent
from the source's vocabulary and results and is already Paper II's balanced
sheets and cubic-first orientation theorem.  Candidate 3 is pre-empted and
remains only a cited consequence.  Candidate 4 is outside the present matching
model and would expand scope without strengthening the exact classification.

C749 already owns the adversarial human freeze of the present
matching-orbit classification, and C750 owns its same-spine formal coverage.
C797 owns the one-level-higher question from the cross-paper scout: remove the
perfect-matching carrier itself and reconstruct it from the trade.

## Mystery ledger

| feature | status | exact gap or gate |
|---|---|---|
| general self-associated/Schur-square/Gorenstein mechanism | settled as prior work | cite arXiv:2512.16766v1, Theorem 3.11 and Corollaries 3.12--3.13 |
| exact \(B_3/H_3\) classification from the two-valued trade | promoted as the reverse-recognition crown | C749 must freeze the classification proof without a Gorenstein premise |
| sheet-sign cubic | survives source comparison | C749 checks the human causal separation; C750 owns formal coverage |
| carrier-free trade reconstruction | settled negatively under C797 | at \(q=7\), seven \(S_4\)-fixed affine placements share the trade and only one is a matching orbit; complete reducibility of one lift is the nearest exact repair |
| broader forward-priority closure | open and deliberately unclaimed | Semantic Scholar and Crossref did not yield valid citing sets; no citation-graph negative is issued |
| fat-point/repeated-endpoint extension | rejected for this task | outside Paper II's present orbit model |

Vibe check: the priority loss removes a general mechanism, but it leaves the
paper's sharper finite-group theorem intact and improves the paper by forcing
its true contribution to the front.
