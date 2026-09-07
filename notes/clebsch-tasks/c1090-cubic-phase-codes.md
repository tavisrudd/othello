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

## Results (2026-09-07)

**Priority search** (`../2026-09-07-c1090-literature-cubic-phase-codes.md`):

| claim | verdict | strongest prior art |
|---|---|---|
| weighted transversal degree-`r` phase iff `w ⊥ L^{∘(r−1)}` | partially known | Haah, PRA 97, 042327 (2018): weighted generalized divisible codes, qubits, qudits flagged open; qudit triorthogonality unweighted in Krishna–Tillich and Prakash–Saha |
| the codes `[[14,6,2]]_7`, `[[22,10,2]]_11`, family `[[2p,p−1,2]]_p` | unclaimed | Zoo taxonomy, parameter search, arXiv API all negative; Li–Yeh `[[6,2,2]]_3` transversal AND is a different object |
| phase polynomial = invariant of a binary form | unclaimed | Nebe–Rains–Sloane (invariants *of* Clifford groups, opposite direction); Jain–Prakash Clifford-eigenstate magic states (single qudit) |
| coupled cubic resource with Pauli-spectrum non-equivalence | partially known in method, not in instance | qudit CCZ, Pauli-support equivalence, stabilizer Rényi additivity, Gauss sums |
| qudit synthillation with exact enumerator formulas | partially known | Campbell–Howard PRA 95, 022316 (2017) is qubit-only; no qudit generalization found |

Not yet done: forward-citation closure (OpenAlex, Crossref, Semantic Scholar) per
`notes/literature-audit-conventions.md`; required before any manuscript "to our knowledge".

**Resource classification** (`../2026-09-07-c1090-resource-classification/REPORT.md`, scripts
and Rust census alongside):

- Pauli spectrum: `|<F|X(v)Z(w)|F>| = p^{−rank H_F(v)/2}` for `w ∈ Im H_F(v)`, else `0`;
  Parseval verified exactly.  `p = 7` exhaustive rank counts over `F_7^6`:
  `N_0 = 1, N_3 = 48, N_4 = 2940, N_5 = 26502, N_6 = 88158`, no rank 1 or 2.  `p = 11`
  exhaustive over all `2 593 742 460` projective points (Rust, 82 s on 24 cores): ranks 5–10
  with `12 / 1452 / 8052 / 2144296 / 238748521 / 2352840127` lines.
- Clifford-invariant separation: the largest nonscalar Pauli expectation is `7^{−3/2}` for
  `|F_7>`, against `7^{−1/2}` for six independent cubic-phase qudits and `7^{−1}` for two
  disjoint CCZ-type phases; `|F_7>` has no Pauli at either of those moduli.
- Minimum-rank locus: `r_min = (p−1)/2`, attained on exactly `p+1` projective points, which
  are the rational normal curve of `(p−3)`-th powers at `s = 0`; for `p = 7` this is the
  Veronese image of the base conic, one `PGL_2(7)`-orbit of size 8.  `F_7` is invariant under
  the `Sym²`-lifted `PGL_2(7)` action with scalar exactly 1 on the checked lifts (Paper II's
  sheet-exchange sign is absorbed because `−1` is a cube), and the Hessian rank is constant on
  all 129 orbits of `PG(5,7)`.
- Waring bracket: the rank census gives `r(F_7) ≥ 9` (any shortest decomposition would force
  56 distinct minimum-rank points, but there are 8) and `r(F_11) ≥ 15`; upper bounds stay at
  `13` and `21`.  The `4sI + 3J` route costs at least 16 cubes (measured negative).

**Recommendation for the decision gate** (author's call): (b) a standalone unnumbered
companion note, working title *Quadratic trades as certificates for coupled cubic-phase
quantum resources*, containing the trade-to-code dictionary, the two invariant-defined
resources with their rational-normal-curve Pauli-spectrum extremum, the rigidity and
non-equivalence certificates, the Waring bracket, and the factory with exact enumerators.
Not (a): Paper II is a geometry paper under the series Lean standard, and a quantum section
would bind every assertion to that standard.  Not (c): the unclaimed instance and the
invariant-theoretic phase are more than an outlook sentence.  Gate before any draft:
forward-citation closure on Haah 2018, Campbell–Howard 2017, Krishna–Tillich 2019, and
Prakash–Saha 2025.

## Log

- 2026-09-07: card opened; bundle banked; priority search and resource classification
  dispatched and completed (above); decision (a)/(b)/(c) awaiting the author.
