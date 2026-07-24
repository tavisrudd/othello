# C538 — beyond-four PRS manuscript integration

**Lane:** `reed-solomon` · **Status:** queued next; user-directed merger; supersedes C500

## Objective

Create the first integrated manuscript for *Beyond redundancy four: deep holes, polar flags, and
modular obstructions for projective Reed--Solomon codes* in `papers/beyond4_prs/`.

The manuscript must make redundancy five the complete headline theorem and use redundancies
six through nine, coherent polar induction, ordered-Hessian geometry, and Lucas arithmetic to
explain the structural phase transition beyond the previously classified range.

## Work

1. Freeze an exact theorem-adoption table for C491, C498, C509, C512, C513, C516/C517, C525,
   C529, and C530.  Label each clause as complete classification, high-field classification,
   containment, obstruction, arithmetic component theorem, or computation.
2. Draft a self-contained LaTeX manuscript, bibliography, abstract, introduction, notation, and
   theorem roadmap.  Position the paper against Zhang--Wan--Kaipa and the claim-specific audits
   already attached to each theorem package.
3. Organize the proof spine as:
   redundancy-five exceptional covers; coherent-polar transition; fixed-level applications;
   characteristic-two ordered Hessian; Lucas-carrier arithmetic; exact open boundary.
4. Integrate the committed certificate/replay evidence through a paper-facing verification map.
5. Create a claim/proof/novelty ledger and identify every statement requiring a Lean terminal from
   C539--C544.
6. Build the PDF and run a first cold structural review.  Do not wait for C531/C532.

## Acceptance gate

- A compilable manuscript source and PDF exist in `papers/beyond4_prs/`.
- The abstract and main theorem never imply complete classification at levels where only a
  high-field or containment theorem is proved.
- Every computational table names its committed generator, independent replay, certificate, and
  checksum.
- The theorem map exposes all cited/external hypotheses and the current Lean boundary.
- C500's standalone redundancy-five plan is absent from the live queue.

## Owned paths

- `papers/beyond4_prs/`
- the paper-specific C538 report and verification/claim ledgers
- the `reed-solomon` handoff and lifecycle rows

