# C616 — equivariant \(H_3\) rank proof

**Lane:** `clebsch`

**Date:** 2026-07-25

## Result

The coordinate row reduction is no longer load-bearing for the
\(H_3/\mathbb F_{11}\) containment, top harmonic summand, or rank ten.
The proof now uses the affine connecting cocycle of the common conic
restriction, the three Fischer summands as twisted
\(\operatorname{PGL}_2(11)\)-modules, cyclic-Sylow cohomology, and
\(A_5\)-fixed spaces. Only one scalar computation remains:
\[
 \Delta_Q^2\Phi_{M_{H_3}}(M_-)=10
   =\Delta_Q^2(Q^2)\ne0.
\]

Consequently
\[
 W_{H_3}=\mathcal H_4\oplus\mathbb F_{11}Q^2
\]
and
\[
 \Delta_Q\Phi_{M_{H_3}}(M)\in\mathbb F_{11}Q
 \quad(M\in\Omega_{H_3})
\]
follow without a 22-row rank calculation.

## Equivariant mechanism

Let \(G=\operatorname{PGL}_2(11)\),
\(G^+=\operatorname{PSL}_2(11)\), and let
\(\chi=\det^5\) be the square-class character. The common restriction of
the matching products is the Dickson form
\(s^{11}t-st^{11}\), whose contragredient weight is \(\det^{-1}\).
After linearizing that section invariantly, the quotient quartics carry
the module
\[
 \widetilde R_4=R_4\otimes\det^{-1}
  =M_8\oplus M_4\oplus M_0,
\]
with
\[
\begin{aligned}
M_8&=\operatorname{Sym}^8(V^\vee)\otimes\det^{-1},\\
M_4&=\operatorname{Sym}^4(V^\vee)\otimes\det^{-3},\\
M_0&=\det^{-5}=\chi.
\end{aligned}
\]
The underlying subspaces are
\(\mathcal H_4,Q\mathcal H_2,\mathbb F_{11}Q^2\).

For
\[
M_r=\operatorname{Sym}^r(V^\vee)\otimes
     \det^{r/2}\otimes\chi,\qquad r=8,4,0,
\]
restrict first cohomology to the upper-unipotent Sylow subgroup
\(U=C_{11}\). Since \(r<10\), its norm is
\((u-1)^{10}=0\), and \((u-1)M_r\) has codimension one. Thus
\(H^1(U,M_r)\) is one-dimensional. A generator of the diagonal
normalizer acts on it by the character exponent
\[
4-r/2\pmod {10},
\]
giving exponents \(0,2,4\) for \(r=8,4,0\).
Restriction \(H^1(G,M_r)\to H^1(U,M_r)\) is injective because
\([G:U]=120\) is invertible in \(\mathbb F_{11}\), and its image is
normalizer fixed. Therefore
\[
H^1(G,M_4)=H^1(G,M_0)=0,\qquad
\dim H^1(G,M_8)\le1.
\]

The base matching has stabilizer \(H=A_5<G^+\). On the three summands,
the \(A_5\)-characters are
\[
(9,1,0,-1,-1),\quad(5,1,-1,0,0),\quad(1,1,1,1,1),
\]
and averaging over class sizes \((1,15,20,12,12)\) gives fixed-space
dimensions \(0,0,1\).

The affine quotient map defines the cocycle
\[
c(g)=\Phi_{M_{H_3}}(gM_{H_3}),\qquad
c(gh)=g c(h)+c(g),
\]
which vanishes on \(H\). Its middle component is a coboundary, and the
translating vector would have to lie in \(M_4^H=0\); hence the middle
component vanishes. This proves the radial-trace containment.

The radial cocycle is also a coboundary and is zero on \(G^+\), where
\(\chi\) is trivial. Any nonbase matching in the eleven-element
\(G^+\)-sheet therefore gives a nonzero vector purely in \(M_8\).
The quotient is nonzero by unique factorization of its secant-line
products. Since the degree-eight restricted
\(\operatorname{SL}_2(\mathbb F_{11})\)-module is irreducible, its orbit
spans \(M_8\).

Finally, with \(\infty\) indexed by \(11\),
\[
M_-=\{\{0,1\},\{2,\infty\},\{3,8\},\{4,6\},
       \{5,9\},\{7,10\}\}
\]
lies in the other sheet and has
\(\Delta_Q^2\Phi(M_-)=10\). Since
\(\Delta_Q^2(Q^2)=10\), this is radial coefficient one. The span already
contains \(M_8\), so subtracting the top component supplies \(Q^2\).

## Exact evidence

The primary checker reconstructs the \(H_3\) orbit and quotient forms
from the frozen C406 input. It checks:

- the cyclic norm and coboundary ranks for degrees \(8,4,0\);
- the normalizer exponents \(0,2,4\);
- the three \(A_5\)-fixed-space dimensions \(0,0,1\);
- a nonzero same-sheet quotient with zero second Laplacian; and
- the displayed outer-sheet quotient with second Laplacian \(10\).

The independent replay uses the separate C406 replay implementation,
reconstructs the Möbius groups, secant products, conic division, and
Laplacians, and agrees on every recorded value.

From `/home/tavis/src/othello`:

```text
python3 notes/2026-07-25-c616-h3-equivariant-rank.py --check
python3 notes/2026-07-25-c616-h3-equivariant-rank-replay.py
sha256sum -c notes/2026-07-25-c616-h3-equivariant-rank.sha256
```

The trusted finite boundary is exact arithmetic over
\(\mathbb F_{11}\), the frozen C406 matching orbit, and the displayed
module conventions. The cohomological implication is proved in the
manuscript rather than inferred from the certificate. The task does not
replace the \(A_3/B_3\) row reductions, prove a theorem over all good
characteristics, or formalize finite-group cohomology in Lean.

## Closeout

The extra-juice pass used C417's affine-cocycle language componentwise:
the global origin obstruction can be nonzero while its middle Fischer
projection vanishes. The Tao-style pass separated containment from
nonvanishing and reduced the latter from a full rank computation to:

1. unique factorization plus irreducibility for the nine-dimensional
   top summand; and
2. one exact second-Laplacian scalar for the radial line.

## Mystery ledger

- **Settled:** the missing \(Q\mathcal H_2\) layer is excluded by
  \(H^1(G,M_4)=0\) together with \(M_4^{A_5}=0\).
- **Settled:** top nonvanishing is forced by a nonzero same-sheet
  difference and irreducibility; it is not a rank-table coincidence.
- **Settled:** the radial line requires only one outer-sheet scalar, not
  a 22-row calculation.
- **Open:** remove that final scalar by interpreting the radial
  coboundary geometrically or through a closed invariant formula for the
  \(A_5\)-fixed sextic lift.
- **Open:** extend the Sylow-normalizer calculation integrally and locate
  every characteristic where a normalizer exponent, Fischer ladder
  scalar, or orbit structure degenerates.
- **Open, lower value:** replace the remaining \(A_3/B_3\) row
  reductions by the parallel cohomological argument. Their target spaces
  are already full, so this improves uniformity rather than the theorem.
