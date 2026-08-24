# Uniform level-two rationality for the Tschinkel--Zhang types

**Lane:** cubic-threefolds · **Task:** C925 · **Date:** 2026-08-24

## Theorem

Let \(K\) be an infinite field of characteristic zero and let \(S/K\) be a
stably rational smooth quartic del Pezzo surface with a \(K\)-point. Then

\[
\boxed{S\times\mathbf A^2\text{ is }K\text{-rational}.} \tag{1}
\]

Consequently every cubic hypersurface in both Tschinkel--Zhang
Propositions 5.1 and 5.2 satisfies

\[
\boxed{X\times\mathbf P^2\text{ is }\mathbf Q\text{-rational}.} \tag{2}
\]

For their two cubic threefolds, the C925 \(m=1\) theorem gives the exact
threshold

\[
\boxed{s(X)=2.} \tag{3}
\]

The two explicit equations are

\[
\begin{aligned}
X_1={}&\{(x_4-2x_3)x_1^2+3(x_4+2x_3)x_2^2
+3x_3^2x_4-x_4^3+x_5^3=0\},\\
X_3={}&\{x_4(x_1^2+2x_1x_2)+x_3(x_1^2+x_1x_2+x_2^2)
+x_3^3-x_3^2x_4+x_4^3+2x_5^3=0\},
\end{aligned}
\tag{3a}
\]

inside \(\mathbf P^4\).

Thus each

\[
Y=X\times\mathbf P^1
\]

is a smooth projective nonrational variety with
\(Y\times\mathbf A^1\) rational.
Thus the construction gives explicit four-dimensional smooth projective
counterexamples to birational \(\mathbf A^1\)-cancellation over \(\mathbf Q\)
and, after base change, over \(\mathbf C\).

## Full-\(I_3\) quotient

Work in the rank-five cocharacter lattice of the projective
Neron--Severi torus \(T_0\). The full type-\(I_3\) group preserves the
saturated rank-three lattice

\[
N_3=\mathbf Ze_3\oplus\mathbf Ze_4\oplus\mathbf Ze_5. \tag{4}
\]

The two generators act on this basis by

\[
\begin{pmatrix}
-1&0&0\\-1&0&1\\-1&1&0
\end{pmatrix},
\qquad
\begin{pmatrix}
1&0&-1\\0&1&-1\\0&0&-1
\end{pmatrix}. \tag{5}
\]

Pairing with the 16 Cox coordinates gives the Galois-stable unimodular
window

| weight | Cox block |
|---|---|
| \((0,1,1)\) | \(L_{13},L_{23},L_{35}\) |
| \((1,0,1)\) | \(L_{14},L_{24},L_{45}\) |
| \((1,1,0)\) | \(E_1,E_2,E_5\) |
| \((1,1,1)\) | \(L_{12},L_{15},L_{25}\) |

The three weight differences have determinant \(1\). Every other block lies
in

\[
B=\mathbf P\langle E_3,E_4,L_{34},Q\rangle. \tag{6}
\]

This is exactly the boundary space and four-block partition in the symbolic
tangent certificate. Its three tangent equations have rank three and every
kernel coordinate nonzero; three symbolic witnesses cover the full smooth
quartic-del-Pezzo moduli. The higher-rank unimodular-window OADP theorem
therefore proves

\[
Z/T_3\text{ rational}. \tag{7}
\]

Completing (4) by \(e_1,e_2\) has determinant \(1\). The residual torus
\(T_0/T_3\) has rank two, hence is rational by Voskresenskii. The
Tschinkel--Zhang generic splitting gives

\[
Z/T_3\sim_K S\times(T_0/T_3), \tag{8}
\]

proving (1) for type \(I_3\).

## The other three types

Tschinkel--Zhang Lemma 4.2 records that, up to conjugacy in \(W(D_5)\), the
groups of types \(I_0,I_1,I_2\) are subgroups of the type-\(I_3\) group.
Restricting the \(I_3\)-stable saturated subtorus, its boundary space, and
its descended slice to any subgroup preserves every hypothesis. Thus (1)
holds for all four types. Their Corollary 4.3 stable-rationality implication
for the four minimal types is therefore strengthened to the uniform
quantitative bound two.

If \(S\) is not \(K\)-minimal, contract a nonempty \(K\)-stable collection of
disjoint exceptional curves. Iterating produces a del Pezzo surface of degree
at least five over \(K\); it has a \(K\)-point, the image of any point of
\(S(K)\). The classical high-degree del Pezzo theorem makes that surface
\(K\)-rational, hence \(S\) is already \(K\)-rational. If \(S\) is minimal
and stably rational, Tschinkel--Zhang Proposition 4.1 and Corollary 4.3 place
its Picard action in exactly the four types above. This proves (1) for every
stably rational smooth quartic del Pezzo surface in the stated setting.

The generic-fibre function-field argument in Section 5 then proves (2) for
both cubic families.

## Evidence and replay

Full-\(I_3\) lattice and weight certificate:

- notes/cubic-threefolds-tasks/c925-i3-level4-cubic-slice-check.py,
  SHA-256
  eccf2a5e20f4f8c24b29f24c170dbf6726ebe20078b0af27a26733960321180f;
- notes/cubic-threefolds-tasks/c925-i3-level4-cubic-slice-check.json,
  SHA-256
  c8ceaf4187ba09b3828d264f58b35ccf5131d34acc3f274449ed9447bd091fd6.

Replay:

    uv run --with sympy==1.14.0 python3 \
      notes/cubic-threefolds-tasks/c925-i3-level4-cubic-slice-check.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-i3-level4-cubic-slice-check.json

The tangent slice, smooth-moduli cover, and an independent stdlib replay are
recorded in
notes/2026-08-24-c925-type-i1-level-two-rationality.md. They apply here
because the full-\(I_3\) window has exactly the same four Cox blocks and
boundary space, merely with a different saturated weight basis.

## Scope

This theorem strengthens the full Tschinkel--Zhang stable-rationality
classification to a uniform level-two bound. Global novelty remains subject
to the literature audit recorded in the priority-judo synthesis.

## Mystery ledger

| status | feature | evidence or remaining gate |
|---|---|---|
| settled | Full \(I_3\) rank-three subtorus | Saturated basis (4), integral actions (5). |
| settled | Full \(I_3\) window | Galois-stable and unimodular. |
| settled | Types \(I_0,I_1,I_2\) | Restriction from the containing \(I_3\) group. |
| settled | Both cubic thresholds | \(s(X)=2\). |
| settled | Nonminimal surfaces | Contraction to a rational del Pezzo surface of degree at least five. |
| open | Explicit rational parametrizations | Constructive formulas not extracted. |
