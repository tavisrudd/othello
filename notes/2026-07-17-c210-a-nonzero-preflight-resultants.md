# C210: a!=0 step-2(a) preflight — the D_AS residue setup is clean

**Lane**: `relconic` (task report; C210 remains active)

Date: 2026-07-17. This is the step-2(a) preflight for the `a!=0` Artin--Schreier
divisor left by
[`2026-07-17-c210-a-nonzero-artin-schreier-form.md`](2026-07-17-c210-a-nonzero-artin-schreier-form.md),
which reduced the whole `a!=0` (t-degree-four) stratum to the single divisor

    D_AS = { R1/sigma^2 in the Artin--Schreier image of K=GF(2)-bar(params)(u) },
    R1/sigma^2 = Q^2*B0 / (delta^2*N^2*G1^2*G2a^2),   N=a^2+a+1 (u-constant, b cancels),

with `Q=u^2+u*delta+delta^2`, `G1=u^2+u*p+p^2*theta` (`theta=w^2+w+1`),
`G2=u^3+u^2*delta+u*p^2*theta+delta*p^2*theta+delta^2*p`, and the a-deformation
`G2a=G2+delta*a*G1`.  Before deriving the branch equations from AS-residues, the
residue formula needs the pole geometry of `R1/sigma^2` (order-two simple poles,
no infinity contribution).  On `a=0` those facts came cheaply; the deformation
`G2->G2a` makes three of them a-dependent.  This report computes all of them
exactly and finds the setup **clean** — no genuinely new degeneracy locus.

## Statement

All resultants are in `u` over `GF(2)(delta,a,p,w)`.

1. **`G2a` is separable off `delta*p=0`.**

       Res_u(G2a, G2a') = delta^4 * p^2 * N^2,      N = a^2+a+1,

   the clean a-deformation of the a=0 value `Res_u(G2,G2') = delta^4*p^2`
   (`N=1` at `a=0`).  The only new `a`-factor is `N^2`, and `N=0` needs `a` in
   `GF(4)`, which has no points over `GF(8^m)`, odd `m`.  So `G2a` has simple
   roots on the whole arithmetic stratum off `delta*p=0` — the deformation adds
   no new degeneracy, contrary to the a=0-had-it-easy worry.

2. **`Q` shares no root with `G2a` off the merged-pole locus.**

       Res_u(Q, G2a) = delta^2 * N * K1 * K2,
       K1 = p^2*w^2 + delta*p*w + p^2*w + delta^2 + p^2,
       K2 = K1 + delta*p,

   with `K1,K2` the two `GF(4)`-conjugate merged-pole quadratics of item 3.  So a
   common `Q`/`G2a` root (which would cancel an order-two pole of `R1/sigma^2`)
   occurs only on `K1*K2=0` (or `delta=0`); off it the poles at the roots of
   `G2a` are genuine order two.

3. **The merged-pole locus is inherited from a=0 for free.**  Because
   `G2a=G2+delta*a*G1` agrees with `G2` at the roots of `G1` (`G2a==G2 mod G1`),

       Res_u(G1, G2a) = Res_u(G1, G2) = p^2 * K1 * K2      (identically),

   the same `p^2*K1*K2` as the a=0 conic.  `Res_u(G1, G1') = p^2` is unchanged
   (`G1` carries no `a`).  On `K1*K2=0` a root of `G1` meets a root of `G2a`;
   exactly as on a=0, that only *shrinks* `D_AS` (two order-two poles merge), it
   adds no branch.

4. **The infinity place is Artin--Schreier trivial.**  `deg_u(Q^2*B0) = 10 =
   deg_u(G1^2*G2a^2)`, so `R1/sigma^2` is regular at `u=infinity` with value

       lead_u(B0) / (delta^2*N^2) = e*(e+delta)/delta^2 = (e/delta)^2 + (e/delta),

   using `lead_u(B0) = e*(e+delta)*N^2`.  That constant is `℘(e/delta)`, already
   in the AS image, so infinity contributes **nothing** to `D_AS`.  This sharpens
   the a=0 "at most a constant polynomial part" fact to exact triviality: the
   divisor is fixed entirely by the finite residues at the roots of `G1` and
   `G2a`.

**Conclusion.**  On the generic stratum `delta*p*N*K1*K2 != 0` the poles of
`R1/sigma^2` are exactly order two at the simple roots of `G1*G2a` and there is
nothing at infinity.  This is precisely the input the step-2(b) AS-residue
derivation consumes, and it is structurally identical to the a=0 pole geometry
(`Res(G1,G1')=p^2`, `Res(G2,G2')=delta^4*p^2`, merged pole `p^2*K1*K2`) up to the
arithmetically-empty `N` factors.  The a-deformation therefore does not obstruct
the residue method; step-2(b) can proceed with the a=0 residue template.

## Artifact and replay

- Checker: `papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_preflight_resultants.py`
  (canonical JSON output `analyze_c210_a_nonzero_preflight_resultants_output.txt`).
- Replay: `cd papers/arcs_complete_outside_conic && python3
  analyze_c210_a_nonzero_preflight_resultants.py | diff -
  analyze_c210_a_nonzero_preflight_resultants_output.txt`.
- The checker rebuilds `Q,G1,G2,G2a,B0` from the committed universal resultant
  via the step-1 `build`/`trace_one_pullback` (no re-transcription), verifies the
  infinity-place degree balance and `lead_u(B0)=e*(e+delta)*N^2` in exact GF(2)
  set arithmetic, cross-multiplies the infinity value to certify it equals
  `(e/delta)^2+(e/delta)`, and runs one Singular block asserting the five
  resultant identities plus `G2a==G2 mod G1` and `K2=K1+delta*p` (numbered
  exits 1--10).

## Exact checked counts and conventions

- All resultants are exact in `u` over `GF(2)[delta,a,p,w]`; no specialization.
- `u`-degrees (Python, exact): `Q=2, G1=2, G2=3, G2a=3, B0=6`; numerator
  `Q^2*B0` and denominator `G1^2*G2a^2` both `u`-degree 10.
- Trusted boundary: Python exact GF(2) set arithmetic for the degree/leading
  identities, plus Singular `resultant`/`reduce`/`std` over `GF(2)(delta,a,p,w)`
  for the five resultant identities.

## What this does not prove (next: step-2(b) and later)

- the branch equations of `D_AS` themselves — the AS-residue conditions at the
  roots of `G1` and `G2a`, where `e,h0,h1` become load-bearing (the a=0
  `W==0 mod G1` accident is not assumed to recur; the G1-residues may be
  nontrivial here);
- whether any `D_AS` branch is collision-free (arc-legal) via the second-layer
  `tau`-quadratic trace test `Tr(A/(bQ)^2)=0`, rather than collision-forcing;
- the reconstruction-split locus `H=J=0` on `a!=0` (the a=0 `H->delta*G1`
  pullback is stratum-specific);
- the `b=0,a!=0` degenerate stratum (`psi=tau^2` inseparable), unowned by the
  a=b=0 gate;
- the classical Artin--Schreier reduction and Lang--Weil theory (trusted).

## SHA-256 / byte counts

    analyze_c210_a_nonzero_preflight_resultants.py         10998  7edd9fb021eb1d753bad7c1efe6403d10afe704f7ccb3ec266d3e41579a02176
    analyze_c210_a_nonzero_preflight_resultants_output.txt  2082  6b0ba16d81c6d53058181315414b27ada1b6d0a6d6581ee9a830f23902511f83
