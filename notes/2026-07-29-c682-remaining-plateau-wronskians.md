# C682 four additional plateau Wronskians

Date: 2026-07-29

## Outcome

Four additional periodic plateau-entry rays are boundary-controllable for
every integer \(q\ge1\):
\[
\begin{array}{c|c|c|c|c}
\text{family}&\rho&\dim(T/H)&
\deg\Omega&\text{positive Smith valuations}\\ \hline
n=73+60q&2&3&83&(3,4,6)\\
n=74+60q&3&4&124&(3,3,4,4)\\
n=74+60q&3'&4&122&(3,3,4,6)\\
n=78+60q&3'&4&122&(3,3,4,6).
\end{array}
\]
For each ray, fixed endpoint returns surject onto the complete local
boundary quotient on the stable ray and on every exact shorter chain.

Together with the four preceding rays, this gives one all-\(q\) boundary
certificate for every plateau-entry type modulo \(20\).  It does **not**
identify the three modulo-\(60\) phases of a given modulo-\(20\) type.

## All-\(q\) certificates

The construction is the same signed block connection determinant as in the
preceding Wronskian theorem.  Incoming third-transvectant columns span the
local hyperplane; selected third--third--ninth endpoint returns fill its
quotient.  Exact determinant interpolation gives formal/actual degrees
\[
(96,83),\quad(138,124),\quad(138,122),\quad(138,122).
\]
The Smith-at-infinity profiles account exactly for every degree drop.

After extracting only below-ray integral factors, the residual polynomials
become coefficientwise one-signed at
\[
q\ge20,\quad q\ge10,\quad q\ge21,\quad q\ge22,
\]
respectively.  Exact evaluation closes the intervening stable integers.
For \(q=1,\ldots,9\), the checker reconstructs the actual shorter boundary
quotients and obtains a nonzero determinant in every case.

## Phase audit

The Kostant numerators give the plateau entrances modulo \(60\):
\[
\begin{array}{c|l}
\rho&n\bmod60\\ \hline
1&4,24,44\\
2&3,13,23,33,43,53\\
3&12,14,32,34,52,54\\
3'&10,14,18,30,34,38,50,54,58.
\end{array}
\]
The old and new ray certificates cover
\[
1:\{4\},\quad
2:\{3,13\},\quad
3:\{12,14\},\quad
3':\{10,14,18\}.
\]
The exact remaining phase set is therefore
\[
\begin{aligned}
1&:\{24,44\},\\
2&:\{23,33,43,53\},\\
3&:\{32,34,52,54\},\\
3'&:\{30,34,38,50,54,58\},
\end{aligned}
\]
sixteen rays in total.

Multiplication by the degree-\(20\) invariant preserves the Hilbert-series
type but does not intertwine the third transvectant.  Direct exact operator
comparison also rules out the naive affine substitution
\(q\mapsto q+1/3\).  Thus these sixteen phases are a genuine boundary gate,
not a formal corollary of the eight certified rays.  The global
\((F,h)\)-Weyl operator bundle constructed in the companion report is the
correct common input for them.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-29-c682-remaining-plateau-wronskians.py --check
python3 ../notes/2026-07-29-c682-remaining-plateau-wronskians-replay.py
```

The primary checker regenerates the exact ray-specific order-\(3,3,9\)
operators and determinant polynomials, verifies the Smith profiles,
coefficientwise sign certificates, finite stable prefixes, and all exact
short chains.  The replay independently reconstructs every operator at
\(q=13\) over two large primes, checks nonzero boundary determinants and
Smith profiles, and rederives the complete modulo-\(60\) phase audit from
the Kostant generator degrees.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-remaining-plateau-wronskians.py` | 10254 | `7c23005bf2d422b772ebc961284bf3f6b4c33c2453e73c758349441137f5265c` |
| `2026-07-29-c682-remaining-plateau-wronskians-operators.json` | 297255 | `36dc47251d31c8479bc4aca163c5230563541567e9461dd6a280220071befa0a` |
| `2026-07-29-c682-remaining-plateau-wronskians-boundary.json` | 261969 | `ee588b59d96a674e75f25e29f9d96eaf7a35cf23cd9d50f3ebdeece3d9fa987f` |
| `2026-07-29-c682-remaining-plateau-wronskians.json` | 8831 | `c398b8b4a0d02cb451a2d6ae5deada18c0b3620ba343ec814056ae099d1dfb0c` |
| `2026-07-29-c682-remaining-plateau-wronskians-replay.py` | 3219 | `96d729ede97c37703628b23ba1a36b5c8e2eed3392d418ee716eb30a671148a0` |

## `ej` + `tt` closeout

The cheap positive upgrade is the \(3_{14}\) ray: its residual determinant
is already coefficientwise one-signed at the stable boundary \(q=10\), so
no finite stable prefix is needed.

The negative `ej` result is equally useful.  Hilbert periodicity modulo
\(20\) does not imply operator periodicity, and recording the exact sixteen
phase residues prevents an invalid propagation claim.

The `tt` correction is to replace phase-by-phase operator interpolation by
the global \((F,h)\)-Weyl operator.  Future work should evaluate only the
small quotient Schur complements on the sixteen lattices, not reconstruct
large transvectant matrices independently on every ray.

## Mystery ledger

- **Settled:** the four displayed rays are boundary-surjective for all
  integers \(q\ge1\).
- **Settled:** all eight plateau types modulo \(20\) now have an all-\(q\)
  representative.
- **Settled by `ej`:** degree-\(20\) Hilbert translation is not
  transvectant linearity.
- **Open, exact owner:** sixteen modulo-\(60\) phase rays listed above;
  evaluate their compressed boundary Schur complements with the global Weyl
  operator.
- **Open:** propagate the resulting anchors through the twenty-one strict
  peak families.
- **Open:** prove the off-peak full-corner step and the separate all-weight
  one-sided maximal-rank theorem.

No all-weight full-corner claim is made.
