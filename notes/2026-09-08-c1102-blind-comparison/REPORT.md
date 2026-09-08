# C1102 — blind before/after comparison (style guide step 7)

**Lane:** clebsch. **Date:** 2026-09-08. **Task:** C1102.

## Setup

Two frozen PDFs of `papers/clebsch-cubic-phase/companion.pdf`, labels hidden
from the readers (`labels.json`):

| label | source | pages | SHA-256 |
|-------|--------|-------|---------|
| A     | HEAD (`40619973a`, revised draft of `b77f6c843` plus export prep) | 12 | `7e522ebb…f474985f` |
| B     | first draft `fb93f5c02` | 11 | `c503a724…345d519a` |

Full hashes: `frozen/SHA256SUMS`. Text extractions `frozen/version-{A,B}.txt`
were supplied alongside the PDFs. Both readers were `gpt-6-astra` via
`codex exec`, fresh context, restricted to this directory, with the prompts
`prompt-specialist.md` and `prompt-adjacent.md`. Neither saw a prior review.
Logs: `codex-*.log`. Reports: `report-specialist.md`, `report-adjacent.md`.

## Result

| reader                          | blind choice | score A | score B | scale                 |
|---------------------------------|--------------|---------|---------|-----------------------|
| primary-audience specialist     | A (after)    | 8       | 7       | specialist confidence |
| adjacent-field reader           | A (after)    | 7       | 5       | accessibility         |

Both blind choices select the revised draft. Scores are recorded separately
per the style guide; the specialist stresses that the scores do not certify
the computations, and that PDF rendering was unavailable in the sandbox so the
judgement is on the text extraction.

## Specialist findings (version A)

No demonstrably false main analytic theorem in either version. Three items
requested before acceptance, none scope-changing:

1. Reviewable finite evidence: a stable, precise supplement locator for the
   conic matrices, census inputs/outputs, shadow embedding, conference matrix,
   and verification procedures. Appendix A promises matrices it delegates to the
   evidence index; fix the pointer.
2. Two short clarifications: the `N_0 = 1 ⇒ full-span` step in Lemma 3.1; keep
   the exact phase-representative convention of Proposition 4.1 (the B-version
   text lacked it and is flagged as a real gap A repaired).
3. One literature sentence connecting Bravyi–Haah triorthogonality with the
   signed prime-qudit condition, then naming what is new (the coupled logical
   phase, its spectrum, the bounded factory comparison).

Also flagged: §3.1 should say the cost counts raw states only.

## Adjacent-reader findings (version A)

Can state both principal results in their own words. Residual friction:
operational meaning of stabilizer resources, injection, and block infidelity
still needs inference; the conference matrix and embedding are described but
not displayed.

## Disposition

Step 7 of the style-guide revision protocol is complete with a positive
result. The three specialist items are cheap manuscript edits and are the
recommended pre-publication revision; the author publication decision remains
open.
