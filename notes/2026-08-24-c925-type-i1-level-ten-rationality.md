# C925: the explicit type-I1 cubic is rational after ten stabilizations

> **Superseded on 2026-08-24:** the simultaneous three-scalar quotient in
> `2026-08-24-c925-type-i1-level-eight-rationality.md` improves ten to eight.

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-24

## Result

Let \(K\) be a field of characteristic zero and let \(S/K\) be a smooth
quartic del Pezzo surface with a \(K\)-point whose geometric Picard action is
of Tschinkel--Zhang type \(I_1\).  Then

\[
S\times\mathbf A^{10}\quad\text{is }K\text{-rational}.
\]

Consequently, for the smooth cubic threefold over \(\mathbf Q\) in
Tschinkel--Zhang Proposition 5.1 (the case \(r=0\)),

\[
\boxed{X\times\mathbf P^{10}\quad\text{is }\mathbf Q\text{-rational}.}
\]

This improves the direct bound \(11\) by one.  It is an actual rationality
theorem, not a method-optimality statement.  Combined with C924's
\(X\times\mathbf P^1\) irrationality theorem, the presently certified range
for this explicit cubic is

\[
2\le s(X)\le8,
\qquad
s(X)=\min\{m:X\times\mathbf P^m\text{ is rational}\}.
\]

The argument does not decide \(m=2\).

## Proof

Write \(M=\operatorname{Pic}(\bar S)\), and let \(T\) be the rank-six
Néron--Severi torus with character lattice \(M\).  Tschinkel--Zhang Theorem
3.4 and its proof give a \(K\)-rational universal torsor
\(\mathcal T\to S\).  Its Cox embedding is an open subvariety of the affine
cone \(U\), and their tangent-projection argument proves not only that
\(\mathcal T\) is rational but that the cone projectivization
\(\mathbf P(U)\) is \(K\)-rational.

Let

\[
d:M\longrightarrow\mathbf Z,
\qquad d(D)=(-K_S)\cdot D.
\]

This is primitive because every exceptional curve has degree one.  Its dual
cocharacter \(\lambda:\mathbf G_m\to T\) acts with weight one on all sixteen
Cox generators, hence is exactly the scalar action on the cone.  Put
\(T_0=T/\lambda(\mathbf G_m)\).  Therefore

\[
\mathcal T/\mathbf G_m\ \sim_K\ \mathbf P(U)
\quad\text{is rational}.
\]

The generic splitting of the universal torsor, used in Tschinkel--Zhang
Proposition 2.3, descends after this quotient and gives

\[
\mathbf P(U)\sim_K S\times T_0. \tag{1}
\]

Now restrict the permutation identity in their Lemma 4.2 to the type-\(I_1\)
group \(H\cong C_2\times S_3\):

\[
M\oplus P\cong P',
\qquad \operatorname{rank}P=5,
\quad \operatorname{rank}P'=11.
\]

Let \(Q,R\) be the quasi-trivial tori with character lattices \(P,P'\), so
\(T\times Q\cong R\).  In the displayed permutation basis
\(b_1,\ldots,b_{11}\), exact multiplication of the Lemma 4.2 basis matrix by
the primitive degree row \((3,1,1,1,1,1,0,\ldots,0)\) gives

\[
(d(b_1),\ldots,d(b_{11}))
=(2,2,2,2,2,2,-3,-3,-3,-3,4). \tag{2}
\]

The \(H\)-orbits on this basis have sizes \(6,4,1\).  Thus for finite etale
\(K\)-algebras \(E_6,E_4\) of those degrees,

\[
R\cong
\operatorname{Res}_{E_6/K}\mathbf G_m
\times\operatorname{Res}_{E_4/K}\mathbf G_m
\times\mathbf G_m,
\]

and \(\lambda\) acts on the three factors with weights \(2,-3,4\).  Because
the auxiliary component of the degree row is zero, quotienting the torus
identity gives

\[
T_0\times Q\cong R/\lambda(\mathbf G_m). \tag{3}
\]

The right side is rational.  Indeed choose \(K\)-linear coordinates
\(x_1,\ldots,x_6\) and \(y_1,\ldots,y_4\) on the two Weil-restriction
vector spaces and a coordinate \(z\) on the last factor.  On the dense torus,
\(\lambda\) gives these blocks weights \(2,-3,4\).  The monomial change

\[
t=x_1^2y_1,
\qquad s=x_1^3y_1^2
\]

is unimodular since
\(\det\bigl(\begin{smallmatrix}2&1\\3&2\end{smallmatrix}\bigr)=1\), and
\(t,s\) have weights \(1,0\).  A transcendence basis for the invariant field
is

\[
s,\quad x_i/x_1\ (2\le i\le6),\quad
y_j/y_1\ (2\le j\le4),\quad z/t^4.
\]

Hence \(R/\lambda(\mathbf G_m)\), and by (3) \(T_0\times Q\), is a rational
rank-ten torus.  Combining this with (1) and the rationality of the
quasi-trivial \(Q\) yields

\[
S\times\mathbf A^{10}
\sim_K S\times(T_0\times Q)
\sim_K \mathbf P(U)\times Q,
\]

which is rational.

For Tschinkel--Zhang's \(r=0\) cubic, projection from the displayed plane has
base \(\mathbf P^1\), function field \(K=\mathbf Q(a)\), and generic fibre
birational to this type-\(I_1\) surface \(S/K\).  The preceding pure
transcendence identity over \(K\) is therefore a pure transcendence identity
over \(\mathbf Q\) after adjoining \(a\).  Thus \(X\times\mathbf A^{10}\),
equivalently \(X\times\mathbf P^{10}\), is \(\mathbf Q\)-rational.

## Exact certificate

Artifacts:

- `notes/cubic-threefolds-tasks/c925-i1-projectivized-torsor-level10-check.py`,
  5,602 bytes, SHA-256
  `71a64eaea86137b36c8ce42ffa4a6c3d85fe4ecea5affc319db5d728c7e6b794`;
- `notes/cubic-threefolds-tasks/c925-i1-projectivized-torsor-level10-check.json`,
  948 bytes, SHA-256
  `35cb27d6cb0304f963714f32d57a444265fd61c706ca02b4f8c2c624c6554dc3`.

Replay from the repository root with SymPy 1.14.0:

```text
uv run --with sympy==1.14.0 python3 \
  notes/cubic-threefolds-tasks/c925-i1-projectivized-torsor-level10-check.py \
  --check-certificate \
  notes/cubic-threefolds-tasks/c925-i1-projectivized-torsor-level10-check.json
```

The certificate checks the unimodularity of the Lemma 4.2 basis, the exact
degree weights (2), primitivity, the order-twelve type-\(I_1\) subgroup and
its \(6+4+1\) orbits and order profile, and the unimodular weight-\((1,0)\)
monomial change.  It does not certify the cited rationality of the universal
torsor or its
projectivization; those are geometric inputs from Tschinkel--Zhang Theorem
3.4 and its proof.

## Source and read depth

- Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo
  surfaces and stable rationality*, arXiv:2608.20029v1.
  **Read depth: partial** — Proposition 2.3, Theorem 3.4 and its proof,
  Lemma 4.2, the levels paragraph, and Proposition 5.1.  Shared-cache key
  `arXiv:2608.20029`, PDF SHA-256
  `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.

## Mystery ledger

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | The scalar quotient of the universal torsor is rational. | The scalar action is the primitive anticanonical cocharacter; Tschinkel--Zhang's proof proves \(\mathbf P(U)\) rational. |
| settled | The type-\(I_1\) permutation torus quotient is rational of dimension ten. | Exact \(6+4+1\) orbit weights and the explicit unimodular monomial invariant basis. |
| settled | The Proposition 5.1 cubic satisfies \(X\times\mathbf P^{10}\) rational. | Function-field passage from its type-\(I_1\) generic fibre. |
| open | Is the bound ten minimal, or can the rationality construction be compressed further? | No lower bound above one is known for this explicit cubic. |
| open | Is \(X\times\mathbf P^2\) irrational for every smooth cubic threefold? | The C925 threefold-centre marked-cycle gate remains open. |

## EJ+TT closeout

The eleven-dimensional direct stable-permutation resolution is still
method-optimal as a lattice identity.  The new argument does not contradict
that result: it first quotients the universal torsor and the quasi-trivial
torus by the same scalar \(\mathbf G_m\), then proves the resulting nonlinear
torus quotient rational.  This is exactly the extra geometric operation that
the direct lattice optimization did not allow.

**Resume line:** `go C925 cubic-threefolds` — try to iterate the scalar-quotient
idea on the \(6+4+1\) torus quotient, or return to the every-smooth \(m=2\)
threefold-centre marked-cycle gate.
