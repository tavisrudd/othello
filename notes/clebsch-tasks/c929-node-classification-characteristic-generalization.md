# C929 — relax the Paper I node classification from characteristic zero

**Lane:** `clebsch`
**Paper stream:** Paper I (`papers/clebsch-rigidity/`), Lean development only
**State:** complete 2026-08-20, landed in `0a6f3695d`. Report:
`../2026-08-20-c929-node-classification-characteristic-generalization.md`.

Outcome: `[CharZero K]` is gone from the classification chain, replaced by
`(h30 : (30 : K) ≠ 0)`, and the theorem is instantiated at `ZMod 11` with golden
root eight, sorry-free and with no compiled-evaluation axiom. The characteristic
input was not where it looked: Mathlib's `ring` normalizer rationalizes a numeral
inverse only when it finds a `CharZero` instance, so the elimination certificates
had to lose their denominators rather than their instance, which meant changing
the generator `lean/scripts/generate_golden_cubic_elimination.py` — a scope
expansion over the dispatch allowlist, taken because the elimination module is
generated and must not be hand-edited.

Manuscript updated 2026-08-20 by explicit user instruction: the two sentences
describing the kernel-checked coverage now say "any field containing such a root
whose characteristic is not 2, 3, or 5" instead of "characteristic zero", the
chartwise Groebner certificate is identified as the human certificate over the
rationals, and the verification section names the characteristic-eleven
specialization. Deterministic rebuild green at twenty-nine pages with no
warnings. A Fable referee pass on that diff was requested and deferred for
budget; it remains owed.

Two follow-ups, both deliberately not done. `supportCubic_framePoints_ordinaryNodes`
still requires characteristic zero because its Hessian determinants are computed
in `RelativeConicArcs/GoldenCubicNodeHessians.lean`, outside the allowlist; the
numbers involved are nonzero under the same hypothesis, so that module is the
obvious successor and would make the ordinary-node statement uniform. And
`Gates/GoldenCubicNodes.lean` still opens by describing itself as auditing "the
exact characteristic-zero formalization", which now misdescribes what it audits.

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
