# C682 mod-\(11\) transvectant--matching bridge

**Date:** 2026-07-28

## Result

Let
\[
G=\operatorname{PGL}_2(\mathbf F_{11}),\qquad
G^+=\operatorname{PSL}_2(\mathbf F_{11}),
\]
and let \(\Omega\) be Paper II's 22-point \(H_3\) matching orbit.  Its two
11-point factorization sheets are the two \(G^+\)-orbits.

Reduce modulo \(11\) the content-divided integral matrix of
\[
T_{\Phi_{12}}\colon \operatorname{Sym}^6\longrightarrow
\operatorname{Sym}^{12},\qquad
p\longmapsto (p,\Phi_{12})_3.
\]
It has rank four.  Under projective conjugation by \(G\), its projective
stabilizer has order \(60\) and lies in \(G^+\).  After conjugating that
stabilizer to C651's frozen \(A_5\) stabilizer, the orbit of the marked
transvectant has 22 elements and there is a \(G\)-equivariant bijection
\[
\Omega\;\xrightarrow{\;\sim\;}\;
G\cdot[T_{\Phi_{12}}].
\]
This bijection carries the two matching sheets to the two \(G^+\)-orbits of
transvectants.  Every element of \(G\setminus G^+\) exchanges both pairs of
sheets.

At the marked base point, the transvectant image is four-dimensional.  Its
Hom space from the standard Clebsch four-space
\(\sum_{i=1}^5y_i=0\) is one-dimensional under the common \(A_5\).
Transporting C651's signed matching cubic through this unique module line
gives the nonzero \(A_5\)-invariant cubic line on the transvectant image.
In C651's frozen coordinates it is still
\[
c_{\mathrm{match}}=4\sigma_3.
\]
The exact check over all 1,320 elements of \(G\) also proves
\[
g\cdot c_{\mathrm{match}}
=\chi_{\det}(g)c_{\mathrm{match}},
\]
where \(\chi_{\det}\) is the quadratic determinant character.  Thus the
outer sheet action on the primitive-transvectant orbit is the same
orientation torsor detected by Paper II's cubic.

## Necessary correction to the naive comparison

The fixed content-divided matrix is not a single
\(\operatorname{PGL}_2(\mathbf F_{11})\)-intertwiner with determinant twist.
Its projective stabilizer is one \(A_5\), and the full group moves it through
a 22-point orbit.  This is expected at the bad prime: division by the
content \(2640\), which contains \(11\), retains a nonzero rank-four
operator but does not commute with reducing the ordinary transvectant
identity.

The correct cross-characteristic object is therefore the marked orbit of
primitive transvectants, not one globally equivariant linear map.  This
distinction is load-bearing: it proves a sheet-torsor comparison without
claiming a nonexistent ambient \(\operatorname{PGL}_2(11)\)-map.

## Paper disposition

Paper II should not import the transvectant construction or the
Mukai--Umemura geometry.  Its conclusion may use one restrained
cliffhanger:

> The obstruction concerns an equivariant affine origin, not the
> orientation cubic itself: after fixing the icosahedral marking, that
> cubic admits a cross-characteristic lift.  The companion paper develops
> this lift.

Paper III owns the reveal: the lift is the rank-four third-transvectant
orbit, its two \(G^+\)-sheets are Paper II's factorization sheets, and its
characteristic-zero parent is the Mukai--Umemura kernel construction.
Nothing here requires Paper II to restore \(H_3\) as its main case.

C665's updated Platinum report does not change this disposition.  Its
uniform characteristic-three trade step is now settled while the
extension-field C1 step remains open.  Those results strengthen Paper II's
internal classification route; they neither supply nor conflict with the
cross-characteristic lift.

## Reproduction and trust boundary

Run from `/home/tavis/src/othello`:

```text
python3 notes/2026-07-28-c682-mod11-transvectant-matching-bridge.py --check
python3 notes/2026-07-28-c682-mod11-transvectant-matching-bridge-replay.py
python3 notes/2026-07-26-c651-hitchin-tensor-bridge-replay.py
```

The primary route independently reconstructs the binary-form actions, the
primitive transvectant, the matching quotient, and all 1,320 group actions.
The replay uses the separate Paper II matching implementation and rebuilds
the transvectant and projective actions from their formulas.  C651's
independent replay separately checks the matching tensor and the scalar
\(4\).

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-28-c682-mod11-transvectant-matching-bridge.py` | 23709 | `b33c881c01b1821d60785afb1869562da17e2caf3581bfa3ae3bb3363a506208` |
| `notes/2026-07-28-c682-mod11-transvectant-matching-bridge-replay.py` | 11324 | `714f0d201ed227006ae0c165ffb6f5d1a627f088bd10158bf2181c7609190c82` |
| `notes/2026-07-28-c682-mod11-transvectant-matching-bridge.json` | 5464 | `f82a700fa0886168688cd9021bb13b76581838acc8dd5fcdd28e60e975fd004d` |

The certificate proves the finite-field orbit, module, cubic-line, and
sheet-character statements.  It does not identify a global integral
incidence model at \(11\), reduce the rational Gaunt scalar, or remove the
need to choose the initial \(A_5\) marking.

## Mystery ledger

- **Settled:** the primitive mod-\(11\) transvectant and Paper II matchings
  carry the same marked 22-point \(G\)-set and the same two-sheet
  \(G/G^+\)-torsor.
- **Settled:** their marked four-spaces have a unique \(A_5\)-module
  comparison, and C651's cubic becomes the nonzero invariant cubic line on
  the transvectant image.
- **Settled negatively:** a fixed primitive matrix is not a global
  determinant-twisted \(G\)-intertwiner; the 22-point orbit is essential.
- **Open, owned by Paper III/C682:** compare the characteristic-zero
  Euclidean and binary normalizations if an exact scalar, rather than the
  invariant cubic line and orientation torsor, is desired.
