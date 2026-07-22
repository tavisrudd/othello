# C468 — Klein cubic zeta at good primes: does the golden `C4` meet the Gauss field in a live spectrum?

**Context:** parallel and non-blocking; promoted from the resolved Klein-cubic zeta discovery lead
(`notes/2026-07-21-klein-cubic-zeta-probe.md`). The probe proved the Klein cubic
`x0^2 x1 + x1^2 x2 + x2^2 x3 + x3^2 x4 + x4^2 x0` is singular mod 11 (unique wild corank-1
`A_10`-type point at the `zeta_5`-CM point; `Z(X/F_11) = Z(P^3)`), so the weight-3 question is
vacuous at 11 and moves to good primes. At `p = 1 mod 5` with `p` not dividing `33`, X mod p is
expected smooth and quintic characters exist over `F_p`, so quintic Jacobi sums (absolute value
`sqrt(p)`, in `Z[zeta_5]`) can genuinely populate `H^3`. The probe's curve-sum trace reduction
(`O(q^2)` naive, `O(q polylog)` via per-point root-finding) transfers verbatim with `11 -> p`.

## Inputs

- `notes/2026-07-21-klein-cubic-zeta-probe.md` — the resolved bad-prime picture, the reduction
  chain (Section 3.1), the Delsarte stratification machinery (Section 3.3), and its verified
  stratum controls
- `notes/2026-07-21-klein-cubic-zeta-probe-scripts/` — committed generators, including the Rust
  `klein_zeta` counter (rebuild in a scratch directory, not the repo `rust/` workspace)
- C453 bundle — only for the fused/visible class labels of the chosen primes

## Task

1. **Smoothness gate:** for each chosen prime, certify X mod p is smooth by the probe's singular
   scan (torus reduction plus the coordinate-vanishing chain argument). Primes: `p = 31` and
   `p = 41` (both fused classes mod 40), plus `p = 61` (visible class `21 mod 40`) as the
   fused-vs-visible control. If 61 is computationally out of reach at the required depth, state
   so explicitly and deliver the two fused primes.
2. **Exact `H^3` characteristic polynomial** at each prime: compute `#X(F_{p^k})` for `k = 1..5`
   (traces `k = 1..5` plus the weight-3 functional equation determine the degree-10 polynomial;
   justify the trace count actually needed). Use the curve-sum reduction; optimize `k = 5` with
   per-point root-finding rather than the naive `O(q^2)` sum where necessary. Verify `k = 1, 2`
   by an independent method at each prime, and verify the final polynomial against every computed
   count, the functional equation, and the Weil bounds.
3. **Cross-check route:** reproduce at least one prime's polynomial (or a nontrivial part of it)
   through the Delsarte/Gauss-sum stratification with quintic characters, re-verifying each
   stratum formula against direct torus counts at that prime before use (compute, never recall).
4. **Field verdict (the headline):** factor each polynomial over `Q`; determine the splitting
   field; state exactly whether it contains `zeta_5`, `sqrt(-p)` or `sqrt(p*)`, both, or neither;
   test whether the eigenvalue multiset is closed under multiplication by fifth roots of unity;
   and identify the eigenvalues against quintic Jacobi sums in `Z[zeta_5]` where possible. Answer:
   do the golden `C4` (Galois of `Q(zeta_5)`) and a Gauss quadratic field genuinely meet inside
   one zeta function at a good prime?
5. **Fused-vs-visible comparison:** state whether any structural feature of the spectra (field,
   factorization shape, Jacobi-sum pattern) differs between the fused primes (31, 41) and the
   visible prime (61), or whether the zeta is blind to the C453 fusion bit. Either answer is a
   deliverable; no mechanism claim beyond the computed comparison.

Deliver an atomic bundle: dated report, exact generators/checkers (extending the committed probe
scripts), canonical JSON with all counts, polynomials, factorizations, and verdicts, checksum
manifest, and an independent replay.

## Boundaries

- No novelty or priority claim: the good-prime zeta of the Klein cubic is plausibly classical
  (Delsarte/Shioda territory). This card computes and interprets for the program's internal
  questions only; any future paper-facing use triggers the literature-audit conventions first.
- The conductor/Swan analysis at the bad prime 11, and any Neron-model statement, are out of
  scope (named possible successor, pre-allocation gated).
- No H4 or continuation claims; the fused/visible comparison consumes C453's labels, it does not
  extend the fusion law.
- Blocker rules per the controller: unexpected singular primes, failed stratum controls, or
  polynomial/count contradictions stop the task with a report, not an improvised repair.
