# C907 (V_{10}) period/operator reconnaissance

**Lane:** `clebsch`

**Status:** superseded for the full-QDM question by
`2026-08-12-c907-v10-full-qdm-certificate.md`. This remains a finite
independent check of the CCGK period formula. Its former negative full-QDM
verdict was correct for the period formula alone, but is overtaken by the
Przyjalkowski counting-matrix theorem and Golyshev’s right determinant.

## Input actually available

CCGK's displayed Section-12 quantum-period formula for the degree-ten,
genus-six prime Fano is

\[
G(t)=e^{-6t}\sum_{\ell,m\ge0}(-1)^{\ell+m}t^{\ell+m}
 \frac{((\ell+m)!)^2(2\ell+2m)!}{(\ell!)^5(m!)^5}
 \bigl(1-5(m-\ell)H_m\bigr).
\]

Its regularization starts
\[
1+78t^2+1320t^3+37746t^4+1051920t^5+\cdots,
\]
matching the printed CCGK prefix.  No V10 recurrence, creative-telescoping
certificate, full-QDM connection matrix, or cyclic-vector theorem was found
in the existing C907 notes.  The old statement that a “provisional
calculation” gives zero has no tracked script or source locator.

## Candidate scalar operator

Exact finite checking of the displayed sum through degree 48 gives

\[
\begin{aligned}
L_{10}={}&\theta^4
-10t\,\theta(\theta+1)(2\theta+1)\\
&-16t^2(37\theta^2+74\theta+39)
-2040t^3(2\theta+3)-8784t^4.
\end{aligned}
\]

Equivalently, if \(G=\sum g_nt^n\), the checked recurrence is

\[
\begin{aligned}
n^4g_n&-10(n-1)n(2n-1)g_{n-1}
-16(37n^2-74n+39)g_{n-2}\\
&-2040(2n-3)g_{n-3}-8784g_{n-4}=0.
\end{aligned}
\]

This is evidence only.  Checking a finite prefix, even exactly, is not a
creative-telescoping proof and cannot promote the operator to a QDM claim.

## Conditional formal calculation

If (L_{10}) were the correctly normalized full scalar small-even QDM, its
infinity exponential polynomial would be

\[
\lambda^4-20\lambda^3-592\lambda^2-4080\lambda-8784
=(\lambda+6)^2(\lambda^2-32\lambda-244).
\]

The two simple branches have exponentials
\(16\pm10\sqrt5\) and power exponent \(-3/2\).  After shifting by the
double exponential \(-6), the first nonzero double-block equation is

\[
-4(2\alpha+1)(2\alpha+3)=0,
\]
so its two formal power exponents are \(-1/2,-3/2\).  Their difference is
one: resonance permits a nontrivial extension/logarithm, and none is ruled
out here.  All displayed residues become integral after the usual threefold
framing shift, so this *conditional scalar calculation* contains no
primitive-sixth residue.

## Exact missing theorem inputs

To certify \(\nu_6(V_{10})=0\), supply all three:

1. An all-degree creative-telescoping/WZ identity for the CCGK double sum,
   or a primary source proving precisely (L_{10}G=0) in this normalization.
2. A direct full-QDM scalarization theorem: the cyclic vector must generate
   the rank-four ordinary small-even quantum connection of (V_{10}), not a
   period submodule or its regularized/Fourier transform.
3. An explicit comparison of the period variable, regularization gauge, and
   scalar formal residues with C907's framed numerical small-QDM convention.

The V5 route had item 2 from a source explicitly listing the full QDE.  CCGK
Section 12 supplies a quantum period, not that bridge.  In particular, the
rank coincidence four-by-four is not enough: regularization and a scalar
annihilator of the unit period can lose or alter the formal data relevant to
\(\nu_6\).

## Replay

```sh
python3 notes/2026-08-12-c907-v10-period-reconnaissance.py \
  --bound 48 \
  --output notes/2026-08-12-c907-v10-period-reconnaissance.json

nix shell nixpkgs#sage --command sage \
  notes/2026-08-12-c907-v10-formal-replay.sage
```

The generated JSON records the exact finite audit and the conditional formal
calculation; it deliberately labels the absent all-degree and full-QDM steps.

The checked artifacts are:

- `2026-08-12-c907-v10-period-reconnaissance.py` —
  `5cd11f538ab9489bc065ed05c60453d82262248ca31c57ecc2f3603cf78892ee`;
- `2026-08-12-c907-v10-period-reconnaissance.json` —
  `deb631ecb8af9dad62e849134520943bb901b594708cab764966ab579e639e64`;
- `2026-08-12-c907-v10-formal-replay.sage` —
  `51d406004723c2125690416551862046adc6ae5367f28f014e789901ff916e68`.
