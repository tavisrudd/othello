# C1090 — Clebsch II cubic-phase quantum codes: priority search and resource classification

**Lane:** clebsch (research-only spinoff track; no Paper II manuscript edit until the novelty
verdict is recorded here)

**Date:** 2026-09-07

**Status:** active

## Input

Astra's memo *Clebsch → quantum* (2026-09-04) and its verified bundle, banked at
`notes/2026-09-06-clebsch-quantum-replay/astra-bundle/`; the independent replay of every exact
claim is `notes/2026-09-06-clebsch-quantum-replay/REPORT.md`; the review and the no-overlap
check against `papers/conference-cut-spectra` are in
`notes/2026-09-06-astra-review-ame-lu-clebsch-quantum.md`.

Verified content: from the exceptional matching configurations of *Quadratic Trade Rigidity
and Cubic Orientation in Conic Matching Quotients* (Paper II) at `p = 7, 11`, the CSS codes
`[[14,6,2]]_7` and `[[22,10,2]]_11` (X-stabilizer `<1>`, Z-stabilizer `L^⊥ = DL`) admit the
signed transversal cubic phase `⊗ M^{ε_i}` with logical cubic `F(u) = Σ ε_i (x_i·u)^3`, whose
`PSL_2(p)`-invariant normal forms are `4sI + 3J` (binary quartic invariants) and
`4sI_2 + 2I_3` (binary octavic invariants); `F` is not Clifford-equivalent to any product with a
single-qudit cubic-phase factor; Waring rank `k+1 ≤ r ≤ 2p−1`; exact error enumerators for the
native-resource factory.

## Goal

Decide whether this is (a) a section or appendix of Paper II, (b) a standalone unnumbered
companion note, or (c) an outlook paragraph, by settling novelty and by establishing what the
two invariant-defined gates are as resources.

## Work items and gates

1. **Priority search** (gate for any manuscript text).  Weighted/generalized triorthogonal
   qudit codes (Campbell–Anwar–Browne 2012; Haah, towers of generalized divisible codes;
   Krishna–Tillich 2019; Saha–Prakash 2025; Heyfron–Campbell compiler), small qudit codes with
   transversal cubic gates at length `2p`, codes or magic resources defined by invariants of
   binary forms, and coupled multi-qudit cubic-phase resources.  Record every consulted source
   per `notes/literature-audit-conventions.md`.  Output: a dated literature note and a verdict
   line (pre-empted / partially known / unclaimed) for each of: the general signed-moment CSS
   mechanism, the two specific codes, the invariant normal forms, the Pauli-spectrum
   non-equivalence certificate, and the factory.
2. **Resource classification** (mathematics/computation only).  Exact Pauli-spectrum
   histogram of `|F_7>` (Hessian-rank distribution over all `v ∈ F_7^6`) and a sampled one
   for `|F_11>`; comparison against product cubic-phase and disjoint-`xyz` resources; any
   improvement of the Waring-rank bracket; the measurement-assisted conversion question.
   Output: a dated report with certificates under a committed replay directory.
3. **Decision.**  Record (a)/(b)/(c) with reasons in this card; if (a) or (b), allocate the
   writing task separately.

## Boundaries

- No edits to `papers/clebsch-factorization/` or any Lean source in this task.
- No commercial or hardware-advantage claim; the memo's own trust boundary stands.
- The conference-cut-spectra paper is cited only as the programme's earlier quantum
  application.

## Log

- 2026-09-07: card opened; bundle banked; priority search and resource classification
  dispatched.
