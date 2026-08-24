# C925: corrected invariant rank-three frontier

**Lane:** cubic-threefolds · **Task:** C925 · **Date:** 2026-08-24

## Correction

The earlier version used the three sign eigenvectors

\[
(0,0,0,1,1),\quad(0,0,1,0,1),\quad(0,0,1,1,0)
\]

as a cocharacter-lattice basis. Their maximal-minor gcd is \(2\), so that
basis is not saturated. The integral half-sum

\[
(0,0,1,1,1)
=\frac{(0,0,0,1,1)+(0,0,1,0,1)+(0,0,1,1,0)}2
\]

belongs to the actual image-subtorus lattice. The previous claims that the
best stable tetrahedron had index two and that the tangent slice was a
geometric double cover are withdrawn. They measured a projective
\(\boldsymbol\mu_2\)-kernel introduced by nonsaturated coordinates.

In the saturated lattice the stable four-block window has affine lattice
index one. The exact tangent matrix has rank three and all four maximal
minors nonzero, so the higher-rank OADP theorem gives a one-point rational
slice. The residual torus has rank two and is rational. Therefore

\[
\boxed{S\times\mathbf A^2\text{ is rational in the type-}I_1\text{ setting},}
\]

and \(X\times\mathbf P^2\) is rational for the Tschinkel--Zhang
type-\(I_1\) cubic family.

The authoritative theorem, proof, exact-threshold implication, symbolic
smooth-moduli cover, and two independent certificates are in
notes/2026-08-24-c925-type-i1-level-two-rationality.md.

## Corrected certificate

- notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.py,
  SHA-256
  3a685d8bb66d908ee4df0b1d68220b3278740d784ba7385c4956ef8e6abd016e;
- notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.json,
  SHA-256
  67ac08dfe16bdfd972235fbfd101b5afdc4bc7db9cd094186b67dab8e3b82841.

Replay from /home/tavis/src/othello:

    uv run --with sympy==1.14.0 python3 \
      notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.json

## Mystery ledger

| status | feature | evidence or remaining gate |
|---|---|---|
| settled | Apparent index-two slice | Nonsaturated-basis artifact. |
| settled | Actual three-sign slice | Stable unimodular tetrahedron and one-point tangent slice. |
| settled | Smooth-moduli coverage | Three determinant witnesses fail together only at the singular point \((1,1)\). |
| settled | Residual torus | Rank two, hence rational. |
| settled | Type-\(I_1\) rationality level | \(m=2\) is rational. |
| open | Manuscript-level priority | Full novelty and forward-citation audit. |
