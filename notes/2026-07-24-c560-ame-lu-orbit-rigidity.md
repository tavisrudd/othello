# C560 — four-party Weyl-tensor rigidity proves LU equals LC

**Lane:** `ame-lu`

**Date:** 2026-07-24

**Status:** complete; positive uniform theorem, stronger than the queued orbit
claim

## Result

Let `\(q\)` be a prime power and let `\(C,D\leq\mathbb F_q^6\)` be linear
`[6,3,4]` MDS codes.  Form the equal-phase CSS stabilizer states

\[
 |\Psi_C\rangle=q^{-3/2}\sum_{c\in C}|c\rangle,
 \qquad
 |\Psi_D\rangle=q^{-3/2}\sum_{d\in D}|d\rangle .
\]

If

\[
 (U_1\otimes\cdots\otimes U_6)\,\pi|\Psi_C\rangle
   =e^{i\theta}|\Psi_D\rangle
\]

for a party permutation `\(\pi\)` and arbitrary single-qudit unitaries
`\(U_i\)`, then every `\(U_i\)` is a single-qudit Clifford unitary relative
to the `\(\mathbb F_q\)` Weyl system.  Thus the displayed equivalence is a
party-permuting local-Clifford equivalence.

Consequently, for the admitted odd non-GRS pencil of C396,

\[
 \Psi_t\sim_{\rm LU}\Psi_u
 \quad\Longleftrightarrow\quad
 \Psi_t\sim_{\rm LC}\Psi_u
 \quad\Longleftrightarrow\quad
 z(t)=z(u).
\]

There are no new exceptional characteristics beyond C396's stated admitted
domain.  The first theorem is stronger than equality of orbit partitions:
**every** local-unitary intertwiner between these equal-phase MDS/CSS states
is local Clifford.

## 1. The four-party shortened stabilizer

The CSS stabilizer of `\(|\Psi_C\rangle\)` is

\[
 \mathcal S_C
   =\{X(c)Z(h):c\in C,\ h\in C^\perp\},
\]

with the standard additive-character phase convention.  Fix any four-party
set `\(S\subset\{1,\ldots,6\}\)`.

Shortening an `[6,3,4]` MDS code on the two coordinates outside `\(S\)`
leaves a one-dimensional code supported exactly on `\(S\)`.  The same is
true for the dual `[6,3,4]` MDS code.  Choose nonzero shortened words
`\(c^S\in C\)` and `\(h^S\in C^\perp\)`.  Every coordinate of each word on
`\(S\)` is nonzero, because its weight is four.

The subgroup of `\(\mathcal S_C\)` supported inside `\(S\)` is therefore

\[
 \mathcal S_C(S)
   =\{X(a c^S)Z(b h^S):a,b\in\mathbb F_q\}.
\]

It has order `\(q^2\)`.  Every nonidentity member has support exactly `\(S\)`.
At each `\(i\in S\)`, the local-label projection is

\[
 (a,b)\longmapsto(a c_i^S,b h_i^S),
\]

an invertible linear map of `\(\mathbb F_q^2\)`.  Hence the local factors of
the `\(q^2-1\)` nonidentity members run through every nonidentity Weyl
operator exactly once.

The reduced state on `\(S\)` is

\[
 \rho^C_S
   =q^{-4}\sum_{s\in\mathcal S_C(S)}s_S.
                                                        \tag{1}
\]

The same statements hold for `\(D\)`.

## 2. Diagonal correlation tensors recover their axes

The needed tensor lemma is elementary.

**Diagonal-tensor rigidity lemma.**  Let `\(r\geq3\)`, let
`\(E_1,\ldots,E_r\)` be complex inner-product spaces of the same dimension
`\(N\)`, and choose orthonormal bases
`\(\{e_{ij}:1\leq j\leq N\}\)` of `\(E_i\)`.  If

\[
 T=\sum_{j=1}^N\lambda_j\,
     e_{1j}\otimes\cdots\otimes e_{rj},
 \qquad \lambda_j\ne0,
                                                        \tag{2}
\]

then the coordinate axes in every `\(E_i\)` are intrinsic to `\(T\)`.
Consequently, any product of invertible linear maps carrying one tensor of
the form (2) to another acts monomially in the displayed bases.

To prove the lemma, contract the first factor against
`\(x=\sum_jx_je_{1j}^*\)`.  The result is

\[
 T_x=\sum_j\lambda_jx_j\,
        e_{2j}\otimes\cdots\otimes e_{rj}.
\]

Flattening its second factor against the remaining `\(r-2\)` factors gives
a matrix of rank exactly the number of nonzero `\(x_j\)`.  Thus `\(T_x\)`
has tensor rank one exactly when `\(x\)` lies on a coordinate axis.  A
product equivalence preserves this rank-one contraction locus, so it
permutes the axes in the first factor.  Repeating the argument in every
factor proves the lemma.

## 3. A reduced state forces local Clifford action

Subtract the identity term from (1) and regard the result as a tensor in the
Hilbert--Schmidt operator spaces of the four parties.  Weyl operators form an
orthogonal basis, and the local-label projection above is bijective.
After reindexing the nonzero label `\(v=(a,b)\)` and retaining the harmless
stabilizer phases, the nonidentity correlation tensor has the form

\[
 T^C_S
   =\sum_{v\in\mathbb F_q^2\setminus\{0\}}
       \lambda_v\,
       W_{1,L_1v}\otimes W_{2,L_2v}
       \otimes W_{3,L_3v}\otimes W_{4,L_4v},
                                                        \tag{3}
\]

where every `\(L_i\)` is invertible and every `\(\lambda_v\)` is nonzero.
This is precisely (2) with `\(r=4\)` and `\(N=q^2-1\)`.

Suppose a product unitary carries `\(\rho^C_S\)` to `\(\rho^D_S\)`.
Conjugation fixes the identity, so its four local adjoint actions carry
`\(T^C_S\)` to `\(T^D_S\)`.  By diagonal-tensor rigidity, each adjoint action
permutes the one-dimensional axes spanned by the nonidentity Weyl operators.
Thus

\[
 U_i W_v U_i^\dagger
   \in\mathbb C^\times W_{v'}
 \qquad(v\ne0).
\]

It fixes the identity as well, so `\(U_i\)` normalizes the single-qudit Weyl
group projectively.  This is exactly the single-qudit Clifford condition.

Now start with a six-party LU equivalence.  Partial trace gives the required
product-unitary equivalence of reduced states for every four-set `\(S\)`.
For a given party `\(i\)`, choose one such `\(S\)` containing it; the
preceding paragraph forces `\(U_i\)` to be Clifford.  Hence all six factors
are Clifford.  A party permutation is absorbed by relabelling the target
before applying the argument.

In fact two four-party marginals whose supports cover all six parties are
enough.  For example, the marginals on `\(\{1,2,3,4\}\)` and
`\(\{1,2,5,6\}\)` already force all six local factors to be Clifford.

## 4. Consequences for the pencil

C396 proves on the admitted odd non-GRS pencil that the following are
equivalent:

1. projective equivalence of the six-arcs, allowing party permutation;
2. monomial equivalence of their `[6,3,4]` kernels;
3. equality of `\(z\)`; and
4. local-Clifford equivalence of the equal-phase CSS states.

C560 adds arbitrary LU equivalence to this list.  The reverse implication is
automatic because every Clifford unitary is unitary; the forward implication
is the rigidity theorem above.

The result also sharpens the paper architecture:

- C374 and C402's LU separations are instances of a complete equivalence
  theorem, not isolated invariant witnesses;
- C397's q=13 four-copy scalar remains a short explicit certificate for a
  difficult pair, but is no longer needed for completeness;
- C548/C550's divisor explains where that certificate changes, not where LU
  classification changes; and
- C559 correctly proves that scalar fixed-copy contractions cannot recover
  the generic coordinate, while the operator-valued four-party marginals do
  recover the local Weyl axes.

## 5. Scope and literature boundary

The proof is self-contained linear algebra once the standard stabilizer
partial-trace formula is fixed.  No computation is load-bearing.

Van den Nest--Dehaene--De Moor, *Local unitary versus local Clifford
equivalence of stabilizer states*, arXiv:quant-ph/0411115, gives a qubit
minimal-support criterion.  **Read depth: `partial`**, cached preprint
`arXiv:quant-ph/0411115`, SHA-256
`c0f8e192552369d5af9304ebf08995f59b6917e243a570f37ff1b29f3b4cb735`;
Sections II--IV, Theorem 1, Lemma 2, and the proof architecture were read.
Its key local lemma is stated for qubits.  C560 does not cite it as a proof of
the prime-power qudit statement; diagonal-tensor rigidity supplies the
required special qudit argument directly.

Burchardt--Raissi, *Stochastic Local Operations with Classical Communication
of Absolutely Maximally Entangled States*, arXiv:2003.13639.
**Read depth: `partial`**, cached preprint `arXiv:2003.13639`, SHA-256
`7b38bd6a5bd8fb8299863e5ca3c7f64dfadd51a12f1b865edbbcbc3d4847a9e3`;
Sections III--IV, Propositions 2, 5--7, Remark 1, the adjacent dimension
table, and the relevant Appendix-C reductions were read.  Their general
saturated `AME(6,d)` analysis reaches a Butson/MOLH boundary at local
dimension 11 and does not itself give the theorem above.  C560 uses the
additional CSS stabilizer and MDS-shortening structure.

No novelty or priority claim is made here.  C562 owns the claim-specific
literature and forward-citation audit.

The theorem does not cover arbitrary minimal-support AME tensors, nonlinear
orthogonal arrays, or non-MDS stabilizer states.  Its portable hypothesis is
the existence, through every party, of a reduced stabilizer subgroup whose
nonidentity correlation tensor projects bijectively onto a full local Weyl
basis.

## `ej` and Tao closeout

The first upgrade is the intertwiner theorem: the argument proves that every
LU map is LC, not merely that LU and LC give the same partition of the pencil.

The second is a portable criterion.  A prime-power stabilizer state is
LU-rigid whenever each party lies in a support `\(S\)` of size at least three
such that the stabilizer subgroup supported in `\(S\)` has order `\(q^2\)`
and projects bijectively onto the local Weyl labels at every party of `\(S\)`.
The diagonal correlation tensor then forces the local Clifford condition.
C560 needs only the `[6,3,4]` MDS specialization, but C562 should audit this
criterion separately before it is advertised as new.

The third is minimal marginal input: two four-party reduced operators
covering the six parties certify the whole LU-to-LC conclusion.  Scalar
moments of those operators discard the axes and explain C559's obstruction;
the operators themselves retain exactly the missing basis information.

## Mystery ledger

| Feature | Disposition |
|---|---|
| Whether restricted LU and LC orbit partitions coincide | **Settled positively:** every LU intertwiner is LC. |
| Whether exceptional values `z=2,4/9` are LU-classification exceptions | **Settled negatively:** they are exceptions only for C397's scalar detector. |
| Why fixed-copy scalars fail while four-party marginals succeed | **Settled:** scalars retain ranks; the diagonal operator tensor retains its intrinsic Weyl axes. |
| Whether all fifteen four-party marginals are required | **Settled negatively:** any two qualifying four-sets covering all parties suffice. |
| Whether the portable prime-power stabilizer criterion is already in the literature | **Open evidence gate; C562 owns it:** no priority wording is licensed here. |

No mathematical C560 mystery remains.

## Vibe check

Excellent.  The hard continuous-unitary problem collapses to an elementary
rank-one-axis characterization of a four-way diagonal correlation tensor.
The proof is uniform, removes all pencil exceptions, and strengthens the
paper's title from invariant separation to genuine local-unitary rigidity.
