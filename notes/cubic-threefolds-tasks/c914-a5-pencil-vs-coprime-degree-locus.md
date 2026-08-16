# C914 — The `A_5`-pencil against the known universally `CH_0`-trivial loci

**Lane:** `cubic-threefolds`

**Status:** active; first question answered, successor question open

**Objective:** locate the nonstandard `A_5`-invariant cubic pencil relative to
the loci of smooth cubic threefolds already known to be universally
`CH_0`-trivial, and feed the verdict into the epilogue's introduction.

## Answered

The pencil contains the Fermat cubic threefold. `W_5` is the induced
representation `Ind_{A_4}^{A_5}(omega)` of a nontrivial cubic character, which
is monomial with cube-root entries, so the Fermat form is invariant. Report
and replay: `../2026-08-14-c914-a5-pencil-vs-known-loci.md`; script
`../2026-08-14-c914-a5-pencil-fermat-membership.py`.

Consequences already landed in the manuscript: the pencil is not the first
positive-dimensional family, and the Fermat member's universal
`CH_0`-triviality has three earlier proofs (Voisin 2017 Theorem 4.5,
Colliot-Thélène 2017, Yang--Yu--Zhu 2025 Remark 3.6).

The Eckardt-point separator hypothesis is refuted; see the report.

## Open

- [ ] Decide whether the generic member of the pencil lies in the
  Yang--Yu--Zhu locus (arXiv:2508.03623, Theorem 3.3), by comparing the two
  explicit normal forms rather than by a discrete invariant.
- [ ] Decide whether the pencil lies inside one of Voisin's
  codimension-at-most-three components, that is, whether `J(X_b)` is
  isogenous by an odd-degree isogeny to a curve Jacobian uniformly in `b`.
- [ ] If either answer is negative, restate the pencil's contribution in the
  epilogue at its proved strength and record the verdict in the paper's
  novelty ledger.
