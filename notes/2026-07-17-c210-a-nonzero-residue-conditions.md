# C210: a!=0 D_AS residue conditions — G1 trivial, three h0-linear G2a conditions

**Lane**: `relconic` (task report; C210 remains active)

Date: 2026-07-17. This is step-2(b) part 1, derived on top of the step-2(a)
preflight
([`2026-07-17-c210-a-nonzero-preflight-resultants.md`](2026-07-17-c210-a-nonzero-preflight-resultants.md)),
which certified that the poles of

    phi = R1/sigma^2 = Q^2*B0 / (delta^2*N^2*G1^2*G2a^2),   N=a^2+a+1,

are exactly order two at the simple roots of `G1*G2a` (off the merged-pole locus
`K1*K2=0`) and that the infinity place is Artin--Schreier trivial.  The task is
to turn `D_AS = {phi in the AS image of K}` into explicit branch equations, by
the same char-2 `W`-residue method that closed the a=0 stratum (trusted; see
[`2026-07-17-c210-a-zero-artin-schreier-divisor.md`](2026-07-17-c210-a-zero-artin-schreier-divisor.md)).

## Statement

Write `phi = f/D^2` with `f = B0*Q^2` and `D = delta*N*G1*G2a`.  At a simple root
`rho` of `D` the order-two pole reduces (char 2) to a simple pole whose
Frobenius-reduced residue vanishes iff `W(rho)=0`, where, using `(Q^2)'=0` and
that `delta,N` are `u`-constant,

    W = f'^2 + f*(D')^2 = (B0')^2*Q^4 + B0*Q^2*(D')^2,   D = delta*N*G1*G2a.

`D_AS` is the locus where `W` vanishes at every root of `G1` and of `G2a`.  Exact
computation over `GF(2)(e,delta,a,b,p,w,h0,h1)` gives:

1. **`G1`-residues vanish identically.**  `W == 0 mod G1` on the whole `a!=0`
   stratum.  The a=0 accident (`W==0 mod G1` there) **recurs**: the `G1` place
   contributes no branch condition.  This resolves the "expect new `G1`
   conditions on `a!=0`" concern downward — there are none.
2. **Three `G2a`-residue conditions.**  `W mod G2a` has `u`-degree two, so `D_AS`
   is cut by exactly the three `u`-coefficients `C0,C1,C2` (of `u^0,u^1,u^2`) —
   the same count as the a=0 `P0,P1,P2`, not the feared five.
3. **`h1`-free, `h0`-linear, quadratic in `e`.**  Every `C_i` has `deg_{h1}=0`,
   `deg_{h0}=1`, `deg_e=2`.  This is the a=0 structural pattern, so the system is
   again solvable for `h0` on each branch by the cross-determinant method.
4. **Common content `(delta*N)^6`.**  `gcd(C0,C1,C2) = delta^6*N^6`
   (`a^12+a^10+a^6+a^2+1 = N^6`); the stripped conditions `c_i = C_i/(delta*N)^6`
   remain `h0`-linear and `h1`-free.

**Conclusion.**  The a!=0 residue system has the same shape as the closed a=0
divisor — `G1` automatically trivial, three `h1`-free/`h0`-linear `G2a`
conditions — so the a=0 cross-determinant branch decomposition transfers.  The
Fable-flagged risks for this sub-step (new `G1` conditions, up to five
equations, loss of `h0`-linearity) all resolve favorably.

## Artifact and replay

- Checker: `papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_residue_conditions.py`
  (canonical JSON output `analyze_c210_a_nonzero_residue_conditions_output.txt`).
- Replay: `cd papers/arcs_complete_outside_conic && python3
  analyze_c210_a_nonzero_residue_conditions.py | diff -
  analyze_c210_a_nonzero_residue_conditions_output.txt`.
- The checker rebuilds `B0` from the committed universal resultant via
  `trace_one_pullback` (no re-transcription), builds `W` symbolically, and runs
  one Singular block (numbered exit gates 1--19) asserting `W==0 mod G1`, the
  `u`-degree of `W mod G2a`, the three coefficients' `h1`-freeness and
  `h0`-linearity and `e`-degree, their exact sizes, and the content
  `gcd = delta^6*N^6`.  The block order is `(lp on u, dp on the rest)` so that
  `leadterm(G1)=u^2` and `leadterm(G2a)=u^3` for the reductions.

## Exact checked counts and conventions

- All identities exact over `GF(2)[e,delta,a,b,p,w,h0,h1][u]`; no specialization.
- `u`-degrees: `Q=2, G1=2, G2a=3`; `W mod G1 = 0`; `W mod G2a` degree 2.
- Raw condition sizes (terms): `C0=1389, C1=643, C2=677`; after stripping the
  `(delta*N)^6` content, `c0=453, c1=221, c2=185`.
- Trusted boundary: Singular `reduce`/`std`/`coeffs`/`gcd`/`diff` over
  `GF(2)(params)`, plus the classical char-2 Artin--Schreier double-pole
  reduction (same as the a=0 report).

## What this does not prove (next parts of step 2)

- the explicit branches of `D_AS` with their forced `h0` (the a=0 analogue of
  `{e=0,h0=0}`, `{e=delta,...}`, `{delta=p,...}`) via cross-determinant
  elimination — the height parameters `e,h0` are load-bearing here;
- whether any branch is collision-free (arc-legal) rather than collision-forcing,
  which on `a!=0` needs the **second-layer** `tau`-quadratic trace test
  `Tr(A/(bQ)^2)=0` (the `D_AS` components are `tau^2+bQ*tau+A`, not the a=0
  `t`-linear lines);
- the reconstruction-split locus `H=J=0` on `a!=0`;
- the `b=0,a!=0` degenerate stratum (`psi=tau^2` inseparable);
- the classical Artin--Schreier reduction and Lang--Weil theory (trusted).

## SHA-256 / byte counts

    analyze_c210_a_nonzero_residue_conditions.py         8514  461ae7dede79419567202b8a1e2e509ecf1c4cb4f63de0d091bcb5e1b62d1327
    analyze_c210_a_nonzero_residue_conditions_output.txt  1770  d291e11dec4ade16ffc302befbc609a5f63fd7b583f22fb9a15a8222d5311760
