# C929 — relax the Paper I node classification from characteristic zero

**Lane:** `clebsch`
**Paper stream:** Paper I (`papers/clebsch-rigidity/`), Lean development only
**State:** dispatched to a sub-agent 2026-08-20; report due at
`../2026-08-20-c929-node-classification-characteristic-generalization.md`.

## Scope

Replace `[CharZero K]` with the true hypothesis — 2, 3, and 5 invertible, which
for a field is the single condition \((30:K)\neq0\) — across the node
classification chain, then instantiate at `ZMod 11` with the golden root
\(t=8\). Manuscript edits are excluded by explicit user instruction, so Paper I's
sentence will understate its own Lean until the author decides otherwise.

Allowed paths: `lean/RelativeConicArcs/GoldenCubicNodeElimination.lean`,
`GoldenCubicNodes.lean`, `SupportOrientationNodes.lean`,
`GoldenCubicNodesBase.lean`, this card, and the dated report. Gate and trust
files are out of scope; a build failure that forces one is a stop-and-report
condition.

## Why it should go through

The engine is a chart case analysis splitting on the roots \(1\), \(-5\), and
\(-1/5\) of the displayed factorizations; those are pairwise distinct exactly
when 2, 3, and 5 are invertible. [C927](c927-determinantal-node-count.md) proves
independently that the geometric statement holds throughout that range, so any
obstruction encountered is proof engineering rather than a false statement.
Modulo eleven the roots are \(1,6,2\), matching the coordinates of the six
singular points the Paper V certificates record.

## Interaction with the queued Lean module remap

Checked before dispatch. C879 (`build-sys`, plan
`../2026-08-06-c879-finitegeom-paper-extraction-plan.md`) will retire the
`RelativeConicArcs` module and declaration namespace in favour of
`TavisRuddFiniteGeom.Papers.*`, in bounded reverse-closure-checked moves. It is
queued behind the active C864 and is a design gate before any source move, so
nothing is in flight and in-place edits are safe: a later rename carries them
along. Two constraints follow and are in the dispatch prompt — create no new Lean
module, since new modules must be registered in C879's extraction manifests, and
rename nothing.

## Payoff

Paper V's Proposition on nodes in characteristic eleven currently proves
persistence by hand because Paper I's kernel-checked classification is
characteristic-zero only; commit `f34fefd15` weakened its sentence for exactly
that reason. With this generalization the citation can be restored, and the C926
Gröbner certificate becomes redundant even as a cross-check.
