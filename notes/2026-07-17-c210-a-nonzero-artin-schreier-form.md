# C210: the a!=0 (t-degree-four) cover is a single Artin--Schreier form

**Lane**: `relconic` (task report; C210 remains active)

Date: 2026-07-17. Opens the `a!=0` factorization frontier left by
[`2026-07-17-c210-a-zero-artin-schreier-divisor.md`](2026-07-17-c210-a-zero-artin-schreier-divisor.md)
(which closed `a=0,b!=0`). This report reduces the whole `a!=0` stratum to one
Artin--Schreier divisor; it does **not** yet compute that divisor's branches.

## Statement

On the generic `a!=0` stratum the trace-one cover is a plane curve of
`t`-degree four with perfect-square leading coefficient and no cubic term:

    R = a^2*Q^2 * t^4 + B2 * t^2 + B1 * t + B0,   Q = u^2 + u*delta + delta^2.

Depressing by `t = tau/(a*Q)` (multiply by `a^2*Q^2`) gives the monic quartic
`F(tau) = tau^4 + B2*tau^2 + a*Q*B1*tau + a^2*Q^2*B0`, and `F(a*Q*t) = a^2*Q^2*R`
with `a*Q != 0`, so `R` and `F` are reducible together over
`K = GF(2)-bar(params)(u)`.

1. **Skeleton factorization.** With `theta = w^2+w+1`, `N = a^2+a+1`,
   `G1 = u^2+u*p+p^2*theta` (the *same* `G1` as the a=0 conic),
   `G2 = u^3+u^2*delta+u*p^2*theta+delta*p^2*theta+delta^2*p`, and its
   a-deformation `G2a = G2 + delta*a*G1` (irreducible over `GF(2)(params)`):

       B1 = delta * N * b * G1 * G2a,      B2 = b^2*Q^2 + sigma,
       sigma := a*delta*N*G1*G2a.

   Equivalently `E = b^2*Q^2 + B2 + a*delta*N*G1*G2a == 0` identically.

2. **The resolvent always splits off `bQ`.** The characteristic-two
   (2,2)-resolvent `X^3 + B2*X + a*Q*B1` factors, exactly and for all
   parameters,

       X^3 + B2*X + a*Q*B1 = (X + b*Q) * (X^2 + b*Q*X + sigma).

   So the rational root `X = b*Q` is present on the whole stratum. (`N = 0`
   needs `a` in `GF(4)`, which has no points over `GF(8^m)` with odd `m`; the
   forcing `phi = b*Q` is arithmetically valid there.)

3. **Artin--Schreier form.** Feeding the shared slope `b*Q` back collapses the
   quartic to a quadratic in `psi = tau^2 + b*Q*tau`:

       F(tau) = psi^2 + sigma*psi + R1,   sigma = a*delta*N*G1*G2a,
       R1 = a^2*Q^2*B0.

   (Verified by direct `tau`-expansion, not only by coefficient matching.)

4. **One factorization divisor.** As a quadratic in `psi`, `F` factors over `K`
   iff the Artin--Schreier class `R1/sigma^2` is trivial in `K/{g^2+g}`. Every
   finer split reduces to this one divisor: a linear factor `tau+phi` forces the
   same-slope partner `tau+phi+bQ`, so `beta = phi^2+bQ*phi` lies in `K` and the
   (2,2) split is already over `K`. Hence the a!=0 factorization locus is the
   single Artin--Schreier divisor

       D_AS = { R1/sigma^2 in the Artin--Schreier image of K },
       sigma = a*delta*N*G1*G2a,   R1 = a^2*Q^2*B0.

**Conclusion.** Off `D_AS` the cover is absolutely irreducible and Lang--Weil
forces reconstructible collisions, exactly as on the closed a=0 conic -- there
in `t`, here in `psi = tau^2+bQ*tau`. The height parameters `e, h0, h1` enter
only through `R1 = a^2*Q^2*B0`, i.e. only in the numerator of the AS class; `B2`
and `B1` are the pure geometric skeleton.

## Artifact and replay

- Checker: `papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_artin_schreier_form.py`
  (canonical JSON output `analyze_c210_a_nonzero_artin_schreier_form_output.txt`).
- Replay: `cd papers/arcs_complete_outside_conic && python3
  analyze_c210_a_nonzero_artin_schreier_form.py | diff -
  analyze_c210_a_nonzero_artin_schreier_form_output.txt`.
- The checker rebuilds the cover from the committed universal resultant
  (`analyze_c210_seed_cross_repair_curve`, no re-transcription), verifies the
  skeleton factorization and `E == 0` in exact GF(2) set arithmetic, expands
  `F` and `psi^2+sigma*psi+R1` in a `tau`-ring and asserts equality, and runs one
  light Singular `factorize` for `G2a` irreducibility (no Groebner/elimination).

## Exact checked counts and conventions

- All polynomial identities are exact over `GF(2)[e,delta,a,b,p,w,h0,h1][u]`
  (or with `tau` adjoined for the form identity); no specialization or sampling.
- `G2a` irreducibility: single `factorize` over `GF(2)(u,delta,a,p,w)`, unit +
  one factor of multiplicity one.
- Trusted boundary: Python exact GF(2) set arithmetic, plus Singular `factorize`
  for the one irreducibility claim.

## What this does not prove (next: step 2)

- the explicit branch equations of `D_AS` from the AS-residues of `R1/sigma^2`
  at the roots of `G1` and `G2a` (mirrors the a=0 `W`-residue derivation; this
  is where `e,h0,h1` become load-bearing);
- whether any `D_AS` branch is collision-free (arc-legal) rather than
  collision-forcing;
- the reconstruction-split locus `H=J=0` on `a!=0`;
- the classical Artin--Schreier reduction and Lang--Weil theory (trusted).

## SHA-256 / byte counts

    analyze_c210_a_nonzero_artin_schreier_form.py         12137  0eb9ad53de37e63bf1d15739e90451d30b4d0b5ac976bb66c7deed62e21017cd
    analyze_c210_a_nonzero_artin_schreier_form_output.txt  2019  7f7d9bb9f7ab070f3cc056d70b7e3f92d5f25199942dac74b5ec8ee2de2a05b3
