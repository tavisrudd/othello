# C682 monotone entrance propagation

Date: 2026-07-29

## Outcome

The global \((F,h)\)-Weyl construction now covers all five monotone
binary-icosahedral modules
\[
2',\quad 4,\quad 4_s,\quad 5,\quad 6.
\]
Their third- and ninth-transvectants are exact falling-factorial
differential operators in the invariant exponents.  The primitive
generator degrees are
\[
\begin{array}{c|l}
2'&7,13,17,23\\
4&6,8,12,14,16,18,22,24\\
4_s&3,9,11,13,17,19,21,27\\
5&4,8,10,12,14,16,18,20,22,26\\
6&5,7,9,11,13,15,15,17,19,21,23,25.
\end{array}
\]
The order-three operator term counts are \(54,176,176,258,350\);
the order-nine counts are \(722,2546,2546,3812,5284\).

Of the sixty-three remaining modulo-\(60\) plateau entrances, fifty-one
have complete fixed-width boundary quotients.  Their quotient dimensions
and exact determinant degrees are
\[
\begin{array}{c|c|c|c}
\rho&\text{certified phases}&\dim Q&\deg D\\ \hline
2'&6&3&67\\
4&9&5&126\\
4_s&9&5&126\\
5&12&6&156\\
6&15&7&185.
\end{array}
\]
After exact removal of negative integral roots, every residual polynomial
is coefficientwise one-signed after shifting to \(q=10\) or \(q=11\).
The finite prefixes \(1\le q<10\), and the one exceptional transition
value when the threshold is \(11\), are nonzero by direct exact
determinants.  Thus all fifty-one entrance quotients are surjective for
every integer \(q\ge1\).  Combined with the all-weight maximal-rank
theorem, their full graded path corners propagate.

The remaining frontier is exactly twelve phases, four types modulo \(20\):
\[
\begin{array}{c|l}
4&6,26,46\\
4_s&3,23,43\\
5&4,24,44\\
6&5,25,45.
\end{array}
\]
For these types the first-return columns span codimension one in the
complete raw local quotient.  They are not counterexamples: direct full
corner determinants are nonzero in tested degrees.  The missing local
direction is removed only after intersecting with the global incoming
image, so a signed block Schur-complement or transfer proof is still
required.  No all-\(q\) claim is made for these twelve phases.

## Exact construction

The covariant seeds are intrinsic:

- \(2'\): \(X^7-7X^2Y^5\);
- \(4\): \(X^4Y^2\);
- \(4_s\): \(X^3\);
- \(5\): \(X^4\);
- \(6\): \(X^5\).

Transvecting these seeds with the Klein dodecic, its Hessian, and its
Jacobian gives the displayed primitive free generators.  The global
operator fitter uses the formal differential-order bounds \(3\) and \(9\)
and verifies every formula beyond its interpolation grid.

At a certified entrance, the last seven semigroup levels form a stable
tail.  Incoming columns supported there, together with a fixed endpoint
return tuple
\[
(\,\cdot\,,F)_9\circ(\,\cdot\,,F)_3\circ(\,\cdot\,,F)_3,
\]
give a square denominator-cleared determinant.  Its formal degree bound is
\[
3(\dim T-\dim Q)+15\dim Q.
\]
Exact Newton interpolation gives the smaller observed degrees in the
table.  The certificate stores every coefficient, endpoint key, negative
integral root, positivity shift, and low-\(q\) sign.

## Independent replay

The replay does not import the rational transvectant engine.  It rebuilds
the five seeds and all primitive generators with a separate dense modular
engine.  At both
\(\mathbf F_{1000000007}\) and \(\mathbf F_{1000000009}\), it:

1. checks every global order-three and order-nine generator transition at
   exponent pairs outside the fit grids;
2. reevaluates all fifty-one boundary determinants at \(q=13,17\).

The replay is green.

## Reproducibility

From `rust/`, the lightweight independent check is

```text
python3 ../notes/2026-07-29-c682-monotone-entrance-propagation-replay.py
```

Full atomic regeneration is

```text
python3 ../notes/2026-07-29-c682-monotone-entrance-propagation.py --write-operators
python3 ../notes/2026-07-29-c682-monotone-entrance-propagation.py --write-boundary
python3 ../notes/2026-07-29-c682-monotone-entrance-propagation.py --write
```

The exact boundary regeneration is intentionally expensive.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-monotone-entrance-propagation.py` | 17197 | `cb1adf0f7fa7f34921e1065d50823bf112d922ce7c909e4627be9dfce47080f7` |
| `2026-07-29-c682-monotone-weyl-operators.json` | 3695023 | `070a85a9a9b98db69b0baf00ebcfc4d6a865715b8ab983ff3cd45342910b7e83` |
| `2026-07-29-c682-monotone-entrance-boundary.json` | 6489982 | `4e301a39ff3e780675fbd38fa84359075e3fe3e1872fedd73cd443b9ccd679d4` |
| `2026-07-29-c682-monotone-entrance-propagation.json` | 73345 | `7f57002be448f35374a58c319cf5df706051a6ee59b0112bda2f8836037f7526` |
| `2026-07-29-c682-monotone-entrance-propagation-replay.py` | 8308 | `7c404c062f4edd395e75f9841d5c641ac083dde643b480ead99bf3a34dd952f8` |

## `ej` + `tt` closeout

The cheap gain is larger than a module-by-module estimate suggested.
The stable local quotient works in every module; failure is concentrated
in only one congruence type modulo \(20\) for each of \(4,4_s,5,6\).
Thus fifty-one phases close without constructing a new global transfer.

The correction is that “complete local quotient” and “global
codimension-one quotient” are not interchangeable.  In the four
exceptional types, raw endpoint returns miss one local direction, while
the global incoming image contributes additional tail combinations through
interior cancellation.  Treating raw supported columns as the full Schur
complement would either underclaim the global mixing or falsely certify
local surjectivity.

## Mystery ledger

- **Settled:** intrinsic free generators for all five monotone modules.
- **Settled:** exact global third- and ninth-transvectant Weyl operators.
- **Settled:** fifty-one of sixty-three entrance phases for every
  \(q\ge1\).
- **Settled by `ej`:** the stable quotient dimensions are
  \(3,5,5,6,7\), and the exact determinant degrees are
  \(67,126,126,156,185\).
- **Settled by `tt`:** the exceptional set is not all of \(4\) and \(6\);
  it is exactly four modulo-\(20\) types across \(4,4_s,5,6\).
- **Open:** construct the signed global block Schur complement for
  \(4_6,4_{s,3},5_4,6_5\) modulo \(20\).
- **Open:** prove its endpoint contraction nonzero for all integer
  \(q\ge1\), closing the final twelve phases.

Vibe: the monotone frontier has collapsed from sixty-three phase
quotients to four genuinely global transfer types.

Copyable continuation:

```text
go C682 clebsch derive the signed block Schur complements for the four exceptional monotone entrance types 4_6, 4s_3, 5_4, and 6_5 modulo 20
```
