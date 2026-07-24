# C595 stable-component Fano elimination

**Lane:** `reed-solomon`

**Status:** queued for a fresh session

## Objective

Turn the stable-component assertion \(\mathrm{SC}(j)\) into an integral
Fano-scheme/elimination problem for universal first-polar lines.  Determine
whether contained cyclic-type residues can be excluded without classifying
every carrier point, and make any generic-fiber result effective in
characteristic by a cleared-denominator unit certificate.

This is companion research.  It must not delay or mutate C545's frozen
R5--R7 submission theorem.

## Required entry context

- `papers/beyond4_prs/sections/05-polar-induction.tex`, especially
  `def:contained`, `def:stable-component`, and
  `thm:uniform-transverse`;
- `notes/2026-07-24-c545-r7-two-step-review-repair.md`, especially the
  final Mystery ledger;
- the proved R6/R7 contained-component ideals as regression targets;
- C513/C516/C532 only to identify which fixed levels are already closed
  before selecting the first unresolved application.

## Construction

For a fixed redundancy \(j\):

1. define the recursively pointed bad scheme and universal polar line
   \(\Phi_f(\lambda)\) over an explicit integral coefficient ring, including
   the infinity chart;
2. substitute \(\Phi_f(\lambda)\) into generators of the bad ideal and set
   every coefficient in \(\lambda\) to zero;
3. saturate by the persistent, modular, rank-boundary, fixed-factor, and
   collision ideals, documenting the order and geometric meaning of every
   saturation;
4. regress the residual ideal against the printed R6 and R7 answers;
5. after the regression is exact, apply the construction to the first
   unresolved stable-component level;
6. if the residual generic fiber is empty, produce a replayable
   Nullstellensatz/unit-ideal certificate.  Clear denominators to obtain a
   nonzero integer \(N_j\), so only primes dividing \(N_j\) remain for
   separate analysis.

## Deliverables

- a dated mathematical report defining the universal ideal and proving its
  equivalence to \(\mathrm{SC}(j)\);
- exact, versioned generator/checker code and a compact certificate following
  `notes/research-reproducibility-conventions.md`;
- R6/R7 regression results, including infinity and small-characteristic
  controls;
- either an effective generic-fiber theorem with the integer \(N_j\), or a
  precise obstruction identifying the surviving component or failed
  saturation;
- a recommendation on whether the method merits a companion paper theorem.

## Stop rules

- Do not replace the universal ideal by an ambient finite-field census.
- Do not claim spreading from characteristic zero until the integral model,
  saturation equivalence, and vertical-component certificate are explicit.
- Do not classify a full cyclic carrier unless the Fano-line elimination
  demonstrably requires it.
- Stop after the first unresolved level or the first structural obstruction;
  arbitrary-\(j\) continuation needs a separately allocated task.
- Do not edit the C545 submission manuscript unless the new result passes an
  independent proof review and the user explicitly reopens that frozen scope.

