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

4. **One factorization divisor** (on `a*delta*N*b != 0`). As a quadratic in
   `psi`, `F` factors over `K` via slope `bQ` iff the Artin--Schreier class
   `R1/sigma^2` is trivial in `K/{g^2+g}`. The two other factorization modes both
   collapse into this one divisor: (i) a linear factor `tau+phi` forces the
   same-slope partner `tau+phi+bQ`, so `beta = phi^2+bQ*phi` lies in `K` and the
   split is the `bQ` one; (ii) the alternate slope `s'` (root of
   `X^2+bQ*X+sigma`) is excluded from `K` because `sigma/(bQ)^2` has polynomial
   part of degree `deg(sigma)-deg(bQ)^2 = 5-4 = 1` (odd), while every `g^2+g` has
   a constant or even-degree polynomial part -- so `s' in K` would need
   `a*delta*N*b = 0`. Hence the a!=0 factorization locus is the single
   Artin--Schreier divisor

       D_AS = { R1/sigma^2 in the Artin--Schreier image of K },
       sigma = a*delta*N*G1*G2a,   R1 = a^2*Q^2*B0.

**Conclusion.** Off `D_AS` the cover is absolutely irreducible, so Lang--Weil
forces collisions **once the a!=0 reconstruction-split locus `H=J=0` is shown
empty** (a step-2 deliverable; proven only on a=0 so far). This mirrors the
closed a=0 conic -- there in `t`, here in `psi = tau^2+bQ*tau`. The height
parameters `e, h0, h1` enter only through `R1 = a^2*Q^2*B0`, i.e. only in the
numerator of the AS class; `B2` and `B1` are the pure geometric skeleton.
The `b=0, a!=0` locus is a **separate degenerate stratum** (`psi=tau^2`
inseparable, `Q1=0`) that the a=b=0 gate does not own; it is deferred to step 2.

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
  is where `e,h0,h1` become load-bearing). Preflight before the residue
  derivation: `Res(G2a,G2a')` (a-deformed simple-root locus), `Res(Q,G2a)`
  (shared-`Q`-root pole cancellation), and the infinity-place balance;
  `Res(G1,G2a)=Res(G1,G2)=p^2*K1*K2` is inherited from a=0 for free since
  `G2a=G2` at the roots of `G1`;
- whether any `D_AS` branch is collision-free (arc-legal) rather than
  collision-forcing. Unlike a=0 (whose components were `t`-linear), the `D_AS`
  components are `tau`-quadratics `tau^2+bQ*tau+A(u)`, so this needs a
  **second-layer** trace analysis `Tr(A/(bQ)^2)=0`: a branch is collision-free
  only if its `tau`-quadratic stays rootless over the whole odd tower -- the one
  place a genuine construction could still hide;
- the reconstruction-split locus `H=J=0` on `a!=0` (the a=0 pullback
  `H -> delta*G1` is stratum-specific; `H=D*B+A*E` must be recomputed on `a!=0`);
- the `b=0, a!=0` degenerate stratum (`psi=tau^2` inseparable, `Q1=0`), unowned
  by the a=b=0 gate;
- the classical Artin--Schreier reduction and Lang--Weil theory (trusted).

## SHA-256 / byte counts

    analyze_c210_a_nonzero_artin_schreier_form.py         15123  74654129056588e8e400fd17ee041e6c82be9d53607013b1ef9061f3b33d6248
    analyze_c210_a_nonzero_artin_schreier_form_output.txt  2590  ef431d5e49faed11e46d84072a57912c6375ace480e4d71b4fe61ad118a32f2b
