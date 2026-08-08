# C888: AME pair second external-review validation and remediation

**Lane:** `ame-lu`

**Status:** active.

## Objective

Independently vet the supplied second referee-style review against both current
manuscripts, their rendered PDFs, the owning Lean comments/trust maps, git
history, and the cited primary literature.  Repair every finding that survives
without adopting the review's novelty or correctness conclusions by authority.

## Required checks

1. Locate and read Ian Tan's five-qubit/six-qubit AME symmetry paper; decide
   whether it belongs in the AME paper beside his general AME--QMDS work.
2. Audit the companion's quantum-transversal related work against the primary
   papers by Tansuwannont--Takada--Fujii, Dasu--Burton, Sayginel and
   collaborators, and the claimed August 2026 Victor Albert preprint.  State
   their scopes accurately and avoid a firstness or absence claim.
3. Reconstruct the coherent Weil-lift paragraph with the manuscript's exact
   Weyl and CSS stabilizer conventions.  Decide whether the tensor phase
   `chi(c dot h / 2)` is trivial on `C direct-sum C-perp` and whether that proves
   preservation of the stabilizer character/state ray rather than labels only.
4. Check every `Corollary 1.1`/`Theorem 1.1` reference semantically and repair
   all stale numbering, including public maps and generated statement facts.
5. Cross-check every change against the owning Lean module comments and exact
   declarations.  Quantitative or phase arguments not formalized in Lean must
   remain explicitly manuscript-only.
6. Rebuild and visually inspect both papers as affected, regenerate release
   identities, audit/export both existing standalone histories through the
   guarded exporter, and leave push/deposit/submission as author decisions.

## Acceptance

Record a finding disposition and primary-source ledger with exact read depth;
pass warning-free paper and release gates; run an adversarial phase-convention
and novelty-boundary closeout; keep edits within both paper roots, their owning
trust metadata if genuinely required, and this report/lane lifecycle surface.

