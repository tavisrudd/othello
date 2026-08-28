# C988 — paper integration of the strengthened all-characteristic containment

**Lane:** `reed-solomon` · **Status:** complete 2026-08-28; report
`c988-2026-08-28-paper-integration-report.md`

## Objective

Integrate the closed C973 results into `papers/high_weight_grs_cosets`
without reopening research.  The single load-bearing change is to Theorem 1.1:
its containment clause already reads `f ∉ P_r ∪ M^max_{r,p} ⇒ d_S(f) ≤ r-2`,
and its classification clause assumes `p > r-1` only to make `M^max_{r,p}`
empty.  Statement (15') of
`c973-2026-08-26-simultaneous-marker-theorem.md` proves `M^max` contributes
nothing for every odd `p` and for `p=2, r>=8`, so the hypothesis becomes
"`p` odd, or `p=2` and `r>=8`", with binary `r in {6,7}` the only modular
exceptions (already the paper's R6/R7 refinements).

## Gates, in order

1. **Persistent-locus check (blocking).**  Verify that the deep-set
   classification inside `P_r` (tangent and conjugate-secant, orbit law
   `T/T^(r-1)`, counts `q(q+1)^2/2` and the `s>0` shell counts) uses no
   `p > r-1` hypothesis.  Known small-`p` phenomena to check against: R6
   tangent fibres split into two `PGL_2` orbits at `p=5`; the tangent cocycle
   splits as `1+(q-1)` in characteristics two and three.  If only orbit
   *counts* change, add a count clause; the deep set itself must be unchanged.
2. **Theorem 1.1 and its proof.**  Replace the `p>r-1` clause; cite (15')
   through the paper's simultaneous-marker escape theorem and the repaired
   persistent-branch induction (`c973-2026-08-28-level-uniform-polar-lemma.md`,
   C536 §2 (5)--(7), quoted over the algebraic closure only).
3. **Deletion/retention.**  Follow `c973-2026-08-26-paper-successor-map.md`
   §4: the carrier--nucleus identification, digit stripping, and GF(64)
   trace balance become a remark plus companion evidence; keep the R6/R7
   binary modular material.
4. **Evidence registry.**  Register the GF(27) certificate
   (`c973-gf27-switch-probe`, §8 of the probe report) and the rebuilt
   GF(16)/GF(32) bundles (degree-ten Borel action, equivariance assertion) as
   below-threshold R11 evidence in the supplement only; the paper claims
   R8--R10 as companion records and nothing at R11.
5. **Frontmatter and maps.**  Abstract and introduction currently say "large
   characteristic"; update them, the reading map, claim map, formalization
   ledger, annotation rows, and verification boundary per
   `notes/formal-annotation-conventions.md`.
6. **Sources.**  Verify Seroussi--Roth and Dür against primary sources as
   invoked (the C973 reviewers checked the arithmetic, not the sources).
   Fold an implementation-independent replay into the `q=49` bundle.
7. **Reviews and builds.**  Both manuscript builds, the supplement verifier,
   the standalone replay, and one cold external-reader pass on the changed
   theorem and abstract.

## Inputs

- `notes/reed-solomon-tasks/c973-2026-08-26-paper-successor-map.md`
- `notes/reed-solomon-tasks/c973-2026-08-26-simultaneous-marker-theorem.md`
  (statement (15'), pointed (17'))
- `notes/reed-solomon-tasks/c973-2026-08-28-review-{geometry,selection,coding}.md`
- `notes/reed-solomon-tasks/c973-2026-08-28-review-closeout.md`
- `papers/style-guide.md` (read completely before editing prose)

## Owned paths

- `papers/high_weight_grs_cosets/` and its supplement/evidence registry
- `notes/reed-solomon-tasks/c988-*`
- the live queue and handoff for C988 state transitions

Standalone export and math-papers synchronization require
`notes/export-and-mirror-conventions.md` first and are a separate step;
publication, pushing, and DOI minting remain out of scope.
