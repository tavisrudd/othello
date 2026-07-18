# C210: exact original-cover splits on the three known a!=0 branches

**Lane**: `relconic` (task report; C210 remains active)

Date: 2026-07-17. This closes Packet 1 of the C210 umbrella handoff on the
generic `b!=0` scope. It upgrades the three certified residue-system branches
to exact factorization branches of the original trace-one collision cover.
It does not yet decide whether either quadratic component has rational points.

## Statement

Use

    theta = w^2+w+1,                  N = a^2+a+1,
    Q = u^2+u*delta+delta^2,          G1 = u^2+u*p+p^2*theta,
    G2a = u^3+u^2*delta+u*p^2*theta+delta*p^2*theta
          +delta^2*p+delta*a*G1,
    psi = tau^2+b*Q*tau,              sigma = a*delta*N*G1*G2a,
    F = psi^2+sigma*psi+R1,           R1 = a^2*Q^2*B0.

On each known branch there is a polynomial `A=a*Q^2*L` over `GF(2)`:

| branch | coordinate conditions | `L=A/(a*Q^2)` |
|---|---|---|
| 1 | `e=0`, `h0=0` | `h1` |
| 2 | `e=delta`, `h0=p^2*theta+e^2+e*b+e*a*p` | `a*p^2*theta+delta*a*p+delta^2+delta*b+delta*p+h1` |
| 3 | `delta=p`, `w in {0,1}`, `h0=e^2*a^2+e*a^2*p+e*a*p+e^2+e*b+e*p` | `h1+e*b+e*N*(u+p+(a+1)*e)` |

The committed checker proves by direct exact identity in every branch
coordinate ring

    A^2 + sigma*A + R1 = 0,
    F = (psi+A)*(psi+A+sigma).

It also rebuilds the original trace-one cover `R(u,t)` from the committed
universal resultant and verifies directly, with `T=a*t^2+b*t+L`,

    R = T * (Q^2*T + delta*N*G1*G2a).

Thus all three known residue-system branches are genuine original-cover
factorization branches. This conclusion is stated on the Packet-1 `b!=0`
scope; the polynomial identity happens to specialize at `b=0`, but it does not
close that inseparable stratum, where the earlier factorization classification
and second-layer classes are not valid.

## Denominators, constants, and merged poles

No rational denominator occurs: every `A` and `L` displayed above is a
polynomial in the stated branch coordinate ring. The factors are defined over
`GF(2)` itself, with no unnamed constant-field extension.

Branch 3 lies on `K1*K2=0`. Its identities are checked independently after
the direct substitutions `w=0` and `w=1`; the certificate never divides by
`K1`, `K2`, a pole resultant, or a generic residue equivalence.

The branch intersections are compatible as unordered component pairs:

- at branch 3 with `e=0`, `A3=A1`;
- at branch 3 with `e=delta=p`, `A3=A2+sigma`, so the two component labels
  swap.

## Artifact and replay

- Checker:
  `papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_exact_splits.py`.
- Canonical output:
  `papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_exact_splits_output.txt`.
- Replay from `papers/arcs_complete_outside_conic/`:

  ```bash
  python3 analyze_c210_a_nonzero_exact_splits.py | diff - analyze_c210_a_nonzero_exact_splits_output.txt
  sha256sum -c analyze_c210_SHA256SUMS
  ```

The checker rebuilds `B0` and the full original cover from
`trace_one_pullback()`; no cover coefficient is re-transcribed. Candidate
factors were discovered with Singular factorization, but the load-bearing
certificate uses only direct polynomial identities.

## Exact checks and trusted boundary

- Nineteen numbered exit gates: eight `A`/depressed-factor identities, four
  direct original-cover identities, four intersection checks, and three
  polynomial/tau-independence checks.
- All identities are exact over the relevant quotient of
  `GF(2)[tau,t,u,e,delta,a,b,p,w,h0,h1]`; there is no sampling.
- Trusted boundary: the committed universal-resultant generator and Singular
  exact polynomial arithmetic over `GF(2)` (`subst`, expansion, equality).
- Independent invariant check: the direct identity against the original
  `R(u,t)` is checked separately from the depressed `F(tau)` identity; it
  catches an incorrect depression, scale cancellation, or component formula.
- Canonical sorted JSON contains no timestamp or host path.

## What this does not prove

- A rational `tau`-root on either component: both second-layer classes
  `A/(bQ)^2` and `(A+sigma)/(bQ)^2` remain to be classified.
- Reconstruction, distinctness, projective genuineness, or any genuine
  collision.
- Arithmetic completeness of the three-branch list.
- The separate `b=0,a!=0` inseparable stratum.
- Arc legality, affine coverage, or `C`-completeness.

## Next gate

Close `b=0,a!=0` before beginning the two-component second-layer
Artin--Schreier classification.

## SHA-256 / byte counts

    analyze_c210_a_nonzero_exact_splits.py          7977  45159c3c20732989da9798fdf4caee58a402e2b9403b1f4fdb166c8cf8b6fea3
    analyze_c210_a_nonzero_exact_splits_output.txt  1461  7616801d5b3979d925280f5f2aa2bd4520ff7fee1336eee8d0a6dcb2caa0d02f
