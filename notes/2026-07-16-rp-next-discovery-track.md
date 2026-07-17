# Repair ports next discovery track

**Lane:** `rp-next`

Append-only catchment for incidental observations and musings encountered during C226--C228, under
[`discovery-track-conventions.md`](discovery-track-conventions.md). Entries are leads, not lane
obligations, task allocations, proof claims, or substitutes for the explicit depth gates in the
handoff.

The discriminator is: **was I looking for this as part of C226, C227, or C228?** If yes, it belongs
in that task's report. If no, record it here with provenance, the observation or musing, why it may
matter, evidence level, and status. Promotion still requires a new C-ID and normal lane routing.

### 2026-07-16 — LRC BEC capacity already uses local rank/Tutte polynomials

**Provenance:** C226's focused prior-art check, Arya Mazumdar,
[*Capacity of Locally Recoverable Codes*](https://arxiv.org/abs/1808.10262), especially the general
multiple-local-erasure discussion and BEC bounds.
**Was I looking for this?:** no — C226 was checking exact complete-port EXIT and stopping-set
precedents, not the polynomial identification allocated to C227.
**Observed / musing:** Mazumdar explicitly packages the BEC contribution of a local code through
its rank (Tutte) polynomial. This is not yet the pointed rank-jump polynomial of C227, but it moves
the prior-art boundary closer than the generic Tutte analogy in the brainstorm suggested.
**Why it may matter / strongest question:** does the complete-port polynomial become a pointed or
split refinement of the same local rank polynomial, and does that import a genuine composition or
duality theorem rather than only a name?
**Evidence:** SOURCE-CHECKED against the primary arXiv paper.
**Status:** graduated -> C227
