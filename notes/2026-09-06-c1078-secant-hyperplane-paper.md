# C1078: third paper, secant–hyperplane defects of complete caps

**Lane**: `relconic`
**Date**: 2026-09-06
**Status**: skeleton draft complete and building through its gate; export-ready pending the
user's math-papers and GitHub steps.

## Deliverable

`papers/secant_hyperplane_defects/` — *Secant–hyperplane defects of complete caps*
(repository alias `secant-hyperplane-defects`, registered in `papers/repositories.toml` and
`lean/trust/papers.toml`; index entry in `papers/papers-index.md`). Fourteen pages, warning-free,
byte-reproducible under the pinned source date. Files: driver, nine section files plus
bibliography, `verification/` (exact scan script, JSON certificate, SHA-256), README, LICENSE,
`.zenodo.json`, flake, Makefile, and the two export-excluded records
`claim-proof-novelty-ledger.md` and `literature-audit.md`.

## What the paper proves

1. Hyperplane loss identity: for every hyperplane, `Σ_{x∈Π∖A}(r(x)−1) = Q(s_Π)` with
   `Q(s) = N − θ_{d−1} + qC(s,2) − (k−2)s`; completeness gives `0 ≤ Q ≤ Λ_0`, hence the admissible
   set `S` of section sizes, with a shape lemma (two runs of at most `2 + √(2Λ_0/q)` elements).
2. Secant–hyperplane moments through a secant, identified as the Pless power moments of the cap
   code shortened at two coordinates.
3. Global and local integer feasibility (character equations over `S`; secant system with
   congruence), the bracket bound `T_ℓ ≥ ⌈τ_0⌉` with a two-character stability estimate, the
   one-sided variant using only `Q ≥ 0`.
4. Exclusions at the counting bound: 31 in PG(4,7), 37 in PG(4,8), 97 in PG(4,16), 293 in PG(6,8),
   387 in PG(6,9). New relative to the memo and C1076: the four two-size cases are already
   excluded by the **global** character equations (divisibility of `kθ_{d−1} − s_1θ_d` by
   `s_2 − s_1`), without any secant; PG(6,8) needs the secant bracket plus coverage budget. All
   five are also excluded by the **one-sided** route (`Q ≥ 0` only, then bracket, then budget),
   with margins of two orders of magnitude (e.g. 418.5 versus 20 in PG(4,7)).
5. Prescribed-hole version of the identity (`−|H∩Π| ≤ Q ≤ Λ_0 + h`).
6. Limits: one-step ceiling (PG(4,7), `k = 32` has `Q > 0` everywhere, `S = {0..12}`); complete
   caps with `c_4 = 0` have `Λ_0 = 0` and are the two perfect-code caps by Pavese's equality case;
   the degree-only countermodel as a formal proposition (edge-disjoint `K_4` packing, greedy bound
   `k(k−1)/72`).

## Corrections applied from the citation verification

`notes/2026-09-06-c1078-citation-verification.md` (Opus sub-agent, 2 full-text sources plus the
Pavese preprint):

- Free pair (Farr–Lisoněk): every plane through the pair contains **at most one** further cap
  point. The memo's "no further cap point" was wrong; the equivalence with `T_ℓ = 0` is exact.
  Term originates in Farr–Lisoněk, J. Geom. 85 (2006).
- Pavese Proposition 3.1 classifies only the equality cases of his 4-general counting bound; the
  memo's "classification of complete caps with no four coplanar points" is not what he proves.
  The paper uses it at its true strength via `c_4 = 0 ⇒ Λ_0 = 0 ⇒ equality`.
- arXiv:1706.01941 is Davydov–Faina–Marcugini–Pambianco (no Bartoli). Segre 1959 is pp. 1–96.
  arXiv:1406.5060 was published as Bartoli–Faina–Marcugini–Pambianco, J. Geom. 108 (2017).
- The 2025 Hirschfeld–Thas survey does not contain the character equations; the paper proves them
  in two lines and cites no source for them.
- Davydov et al. 2009 (paywalled) is no longer cited; the quasi-perfect dictionary is cited to
  arXiv:1706.01941 §1 (verbatim sentence recorded).

## Verification

- `make check` in the paper directory: lint, evidence replay, manuscript build, warnings gate.
- Certificate `verification/secant-hyperplane-checks.json`, SHA-256
  `981c6985b1214ae06bd1c591fdccceac1e6b7039369c28cda1b9a68339e3b5c6`; scan domain identical to
  C1076 (d=3 q≤128, d=4 q≤64, d=5 q≤16, d=6 q≤9, window 12). Adds test G (global character
  infeasibility for `|S| ≤ 3`) and the one-sided route to the C1076 tests. Same five gains for
  `d ≥ 4`; in `d = 3` test G fires at PG(3,7), `k = 12`, matching the arcs paper's bound 13.
- Hand checks in this session: all five `Λ_0`, `S`, global divisibility integers, the PG(4,7)
  one-sided bracket `τ_0 = 58/7`, the PG(6,9) admissible set and secant divisibility, the
  countermodel packing bound.

## Not done / open for the user

- Math-papers materialization and GitHub creation (`export-paper-repos.py plan/audit/materialize`
  after commit); Zenodo concept DOI, then README badge and DOI line.
- Independent replay of the scan beyond this session's own run.
- Cold read of the manuscript prose.

## Mystery ledger

- Dimension five yields nothing in the scanned range while four and six each yield twice
  (carried from C1076; now stated as the closing empirical question of the paper). Gate: extend
  the `d = 5` scan (a Rust port would be cheap).
- The global character route excludes exactly the two-size cases; whether the global and secant
  divisibility conditions are ever independent at the counting bound is untested.
