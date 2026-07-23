# C505 / F12 — Lean torsor-Rosetta closing theorem

**Lane:** `clebsch`

**Status:** queued task brief

This file is both the cold-read task specification and the durable result report. Complete it in
place with exact theorem names, artifacts, validation, axiom evidence, trust boundaries, judgment
calls, review dispositions, and the proposed C320 ledger delta.

## Required outcome and trust route

Define a reusable free-`C2` torsor interface and formalize the adopted closing theorem assembled
from C417, C448, C473, C474, C480, C486, and C487:

- C474's q=11 fixed-child quotient is torsor-isomorphic to `T_11`;
- the Čech/base-point obstruction, one-bit selector, and free torsor are three readouts of the
  determinant-square sign character with kernel `PSL_2(q)`;
- split working primes give a free two-point torsor at B3/H3, while the A3 prime is an inert,
  connected quadratic point with no bit;
- the q=11 swap agrees with the design polarity, signed Fourier-sector swap, and the forced-outer
  Hadamard/Mathieu hinge at the exact boundary delivered by C504;
- `Spec Q(sqrt5)` supplies the characteristic-zero row, whose two reductions at 11 map to the two
  finite sheets.

The theorem is an assembly of certified dictionaries, not a claim that all carriers are naturally
identical before the named maps are supplied.

## Owned surface and dependencies

- Own only `lean/RelativeConicArcs/ClebschTorsorRosettaData.lean`,
  `lean/RelativeConicArcs/ClebschTorsorRosetta.lean`,
  `lean/RelativeConicArcs/Gates/ClebschTorsorRosetta.lean`, and this report.
- Import the committed F8, C503/F10, and C504/F11 gates. Consume the C417/C448/C473/C474/C480/
  C486/C487 bundles read-only.
- Exit through `RelativeConicArcs.Gates.ClebschTorsorRosetta`.

## Required theorem and exclusion boundary

Prove the explicit finite actions, maps, equivariance squares, sign-character kernel, splitting
checks, and reduction dictionary. The characteristic-zero row must state precisely what is proved
over `Q(sqrt5)` and what is only identified after reduction at 11. Exclude an absolute-`H^1`
classification, universal all-prime trichotomy, integral cubic carrier, uniform period-to-cubic
rule, signed genuine-Weil restriction, or claim that `PGL_2(11)` embeds in `M12`.

## Validation and closing review

Before proof work read `lean/AGENTS.md` and the routed named-expert dossier. Each imported finite
bundle needs a sound checker theorem or a precisely declared external-certificate row. Audit all
gate terminals for axioms and use guarded/unattended exact-target builds only.

Completion requires artifact/report/checklist/C320 delta, user-launched independent review,
resolution or narrowing of every finding, user-launched post-fix review after changes, and recorded
final `GO`. The implementer may not select or simulate the reviewer.

## Result, judgment calls, validation, review, and C320 delta

To be completed during execution.
