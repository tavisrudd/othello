# C927 — determinantal proof that the conference cubic has exactly six nodes

**Lane:** `clebsch` (Paper V, `papers/chordal-conference-reconstruction/`)
**Date:** 2026-08-20
**Status:** proof complete; no manuscript edit made (user instruction).
**Supersedes as authority:** the Gröbner delegation of
[C926](2026-08-20-c926-conference-node-completeness.md). That certificate remains
valid and now serves as an independent machine cross-check of a proved statement
rather than as the reason to believe it.

## Statement

Throughout, \(k\) is a field with \(\operatorname{char}k\notin\{2,3,5\}\)
containing a square root of \(5\), and \(\bar k\) is its algebraic closure. Let
\(\Omega\) be a six-element set, \(k^\Omega\) the permutation module with its
standard symmetric form \(\langle\ ,\ \rangle\) and basis \((e_i)\), and let
\(A_0=\{x:\sum_i x_i=0\}\). Let \(B\) be a symmetric conference matrix of order
six: \(B_{ii}=0\), \(B_{ij}=\pm1\) for \(i\neq j\), and \(B^2=5I\). Let

\[ c_B(x)=\sum_{i<j<l} B_{ij}B_{jl}B_{li}\,x_ix_jx_l \]

be its triangle cubic, restricted to \(A_0\), and let \(G\cong A_5\) act on
\(\Omega\) preserving the two-graph of \(B\). Write \(p_a=[\mathbf 1-6e_a]\).

> **Theorem.** The singular locus of \(\{c_B=0\}\subset\PP(A_0)\) over \(\bar k\)
> is exactly the six points \(p_a\), and each is an ordinary node.

The proof is uniform in the characteristic and uses no Gröbner basis, no Bézout
count, and no computer. Two facts are imported from the manuscript, both proved
there structurally: the invariant cubic pencil \(\Pi=\Sym^3(A_0^*)^G\) is
two-dimensional, and a chordal generator \(h\in\Pi\) has singular locus the
rational normal quartic \(R\) (Lemma *Hankel singular locus*). Ordinariness of
the six nodes is the manuscript's existing Hessian computation
(Proposition *Nodes persist in characteristic eleven*); everything else below is
new.

## 1. The eigenspace splitting

Since \(B^2=5I\) and \(\sqrt5\in k\), \(k^\Omega=W_+\oplus W_-\) with
\(W_\pm=\ker(B\mp\sqrt5 I)\). As \(B\) is symmetric the two summands are
orthogonal, and \(\operatorname{tr}B=0\) forces
\(\dim W_+=\dim W_-=3\). Consequently \(W_-=W_+^{\perp}\) and the form restricts
nondegenerately to each summand.

Write \(\ell_i\in W_+^*\) and \(m_i\in W_-^*\) for the \(i\)-th coordinate
functional restricted to \(W_+\) and to \(W_-\).

## 2. Both eigenspaces are maximum-distance-separable

> **Lemma 1.** Every nonzero \(w\in W_\pm\) has at least four nonzero
> coordinates. Equivalently, any three of the \(\ell_i\) are linearly
> independent, and likewise for the \(m_i\).

*Proof.* Suppose \(0\neq w\in W_+\) has support \(S\) with \(|S|\le3\). For
\(i\in S\), the eigenvector equation reads
\(\sum_{j\in S}B_{ij}w_j=\sqrt5\,w_i\), so \(\sqrt5\) is an eigenvalue of the
principal submatrix \(B[S,S]\). That submatrix is symmetric, hollow, with all
off-diagonal entries \(\pm1\), of size at most three; its characteristic
polynomial is \(\lambda\), \(\lambda^2-1\), or
\(\lambda^3-3\lambda\mp2=(\lambda\pm1)^2(\lambda\mp2)\), so its eigenvalues lie
in \(\{0,\pm1,\pm2\}\). Then \(5\in\{0,1,4\}\), i.e. \(\operatorname{char}k\)
divides \(5\), \(4\), or \(1\) — excluded. The same argument applies to \(W_-\)
with \(-\sqrt5\). A three-dimensional subspace of \(k^6\) whose nonzero vectors
all have weight at least four is exactly a \([6,3,4]\) maximum-distance-separable
code, and for such a code every three coordinate functionals are independent. ∎

Hollowness of \(B\) is what makes this work; it is the same hypothesis that
later makes the six nodes isolated.

## 3. The matrix of linear forms

Define, for \(x\in k^\Omega\), the bilinear form on \(W_+\times W_-\)

\[ M(x)(w,v)=\langle D_xw,\,v\rangle=\sum_i x_iw_iv_i,
   \qquad\text{that is}\qquad M(x)=\sum_{i\in\Omega} x_i\,\ell_i\otimes m_i, \]

where \(D_x=\operatorname{diag}(x)\). This is a three-by-three matrix of linear
forms in \(x\).

> **Lemma 2.** \(\sum_i\ell_i\otimes m_i=0\), so \(M\) descends to
> \(k^\Omega/\langle\mathbf 1\rangle\cong A_0\). Moreover
> \(M(\mathbf 1-6e_a)=-6\,\ell_a\otimes m_a\), which has rank one, and
> \(\ker M(x)=\{w\in W_+ : D_xw\in W_+\}\).

*Proof.* \(M(\mathbf 1)(w,v)=\langle w,v\rangle=0\) because \(W_+\perp W_-\);
this single relation is the orthogonality of the eigenspaces. Evaluating at
\(\mathbf 1-6e_a\) and subtracting gives the second claim, and \(\ell_a\neq0\),
\(m_a\neq0\) by Lemma 1. For the third, \(w\in\ker M(x)\) means \(D_xw\perp W_-\),
i.e. \(D_xw\in W_-^{\perp}=W_+\). ∎

So the six frame points are literally the six rank-one coordinate tensors of
\(M\), and \(\det M\) is singular at each of them: at a rank-one point of a
three-by-three matrix the adjugate vanishes, hence so do all partials of the
determinant.

## 4. The determinant is the conference cubic

> **Lemma 3.** \(\det M\) is a nonzero \(G\)-invariant cubic on \(A_0\), and
> \(\det M=\kappa\,c_B\) for some \(\kappa\in k^\times\).

*Proof.* *Nonzero.* Take \(x\) supported on a three-element set \(S\) with
nonzero entries. By Lemma 1 both \((\ell_i)_{i\in S}\) and \((m_i)_{i\in S}\) are
bases, so \(M(x)=\sum_{i\in S}x_i\,\ell_i\otimes m_i\) is diagonal with nonzero
entries in those bases and \(\det M(x)\neq0\).

*Invariant.* For \(g\in G\) with permutation matrix \(P_g\), invariance of the
two-graph gives a diagonal sign matrix \(S_g\) with \(P_g^{-1}BP_g=S_gBS_g\).
Then \(T_g=P_gS_g\) commutes with \(B\), hence preserves \(W_\pm\), and satisfies
\(T_gD_xT_g^{-1}=D_{P_gx}\) and \(T_g^{\mathsf T}=T_g^{-1}\) since \(T_g\) is a
signed permutation. Therefore \(M(P_gx)(w,v)=M(x)(T_g^{-1}w,T_g^{-1}v)\) and
\(\det M(P_gx)=\lambda_g\det M(x)\) with
\(\lambda_g=\det(T_g)^{-1}\in\{\pm1\}\), unchanged by the sign ambiguity in
\(S_g\) because \(W_\pm\) are odd-dimensional. So \(\lambda:G\to k^\times\) is a
homomorphism, and \(A_5\) is perfect, so \(\lambda\equiv1\).

*Identification.* Hence \(\det M\in\Pi\), which is two-dimensional. The members
of \(\Pi\) singular at \(p_0\) form a linear subspace \(L\). If \(L=\Pi\) then the
chordal generator \(h\) is singular at \(p_0\), so \(p_0\in\operatorname{Sing}h=R\);
but \(R\cong\PP^1\) carries the icosahedral \(G\)-action, whose orbits have sizes
\(12,20,30,60\), while the \(G\)-orbit of \(p_0\) has size six — the stabilizer
of \(p_0\) is a dihedral group of order ten, and no such subgroup of
\(\mathrm{PGL}_2\) fixes a point of \(\PP^1\). So \(\dim L\le1\). Both \(c_B\)
and \(\det M\) are nonzero elements of \(L\), so they are proportional. ∎

## 5. Singular locus equals the rank-one locus

> **Lemma 4.** \(\operatorname{Sing}\{c_B=0\}=\{x:\operatorname{rank}M(x)\le1\}\)
> over \(\bar k\).

*Proof.* If \(\operatorname{rank}M(x)\le1\) the adjugate vanishes and every
partial of \(\det M\) vanishes, so \(x\) is a singular point of
\(\{\det M=0\}=\{c_B=0\}\). Conversely, \(\operatorname{rank}M(x)=3\) gives
\(\det M(x)\neq0\), so \(x\) is not even on the hypersurface. Let
\(\operatorname{rank}M(x)=2\). Then \(\operatorname{adj}M(x)=u\otimes v\) has rank
one with \(0\neq u\in W_+\) and \(0\neq v\in W_-\), and since
\(\partial M/\partial x_k=\ell_k\otimes m_k\),

\[ \frac{\partial\det M}{\partial x_k}
   =\operatorname{tr}\big(\operatorname{adj}M(x)\cdot\ell_k\otimes m_k\big)
   =\ell_k(u)\,m_k(v). \]

By Lemma 1, \(\ell_k(u)\neq0\) for at least four indices \(k\) and
\(m_k(v)\neq0\) for at least four indices \(k\); two subsets of size four in a
six-element set meet, so some partial is nonzero and \(x\) is a smooth point. ∎

## 6. The rank-one locus is exactly the six frame points

> **Theorem.** Over \(\bar k\),
> \(\{x\in\PP(A_0):\operatorname{rank}M(x)\le1\}=\{p_0,\dots,p_5\}\).

*Proof.* Work over \(\bar k\); Lemmas 1–4 hold there verbatim, since scalar
extension preserves all hypotheses. Let \(U=\ker M(x)=\{w\in W_+:D_xw\in W_+\}\)
and suppose \(\dim U\ge2\), with \(x\notin\langle\mathbf 1\rangle\).

*Case A: some nonzero \(w\in U\) is an eigenvector of \(D_x\), say
\(D_xw=\lambda w\).* Then \(x_i=\lambda\) for every \(i\) in the support of
\(w\), which has at least four elements by Lemma 1. So \(x-\lambda\mathbf 1\) is
supported on a set \(T\) with \(|T|\le2\), and
\(M(x)=M(x-\lambda\mathbf 1)=\sum_{i\in T}(x_i-\lambda)\ell_i\otimes m_i\) has
rank exactly \(|T|\) by Lemma 1. Rank at most one forces \(|T|=1\), i.e.
\(x\in\langle\mathbf 1,e_a\rangle\), which is the point \(p_a\) of \(\PP(A_0)\).
(\(|T|=0\) would put \(x\) in \(\langle\mathbf 1\rangle\).)

*Case B: no such eigenvector exists.* If \(\dim U=3\) then \(D_xW_+\subseteq W_+\)
and \(D_x\) acts on \(W_+\), which has an eigenvector over \(\bar k\) — Case A.
So \(\dim U=2\). The map \(U\to W_+/U\), \(w\mapsto D_xw \bmod U\), has nonzero
kernel; pick \(0\neq w_0\) in it and set \(w_1=D_xw_0\in U\),
\(w_2=D_xw_1\in W_+\). If \(w_0,w_1,w_2\) are dependent then either
\(w_1\in\langle w_0\rangle\), making \(w_0\) an eigenvector in \(U\), or
\(\langle w_0,w_1\rangle=U\) is \(D_x\)-stable and \(D_x|_U\) has an eigenvector
in \(U\); both are Case A. So \(w_0,w_1,w_2\) form a basis of \(W_+\), and since
\((w_j)_i=x_i^{\,j}(w_0)_i\),

\[ W_+=\{\,(v_i\,q(x_i))_{i\in\Omega}\ :\ \deg q\le2\,\},\qquad v=w_0, \]

a generalized Reed–Solomon presentation. No \(v_i\) vanishes: a coordinate on
which every codeword vanishes would make \(W_+\) a three-dimensional code of
length five and minimum distance four, contradicting the Singleton bound. The
\(x_i\) are pairwise distinct: if \(x_i=x_j\) with \(i\neq j\), choose \(q\) of
degree two vanishing at \(x_i\) and at some \(x_l\neq x_i\) (such an \(l\) exists
because \(x\notin\langle\mathbf 1\rangle\)); the resulting codeword vanishes at
\(i\), \(j\), and \(l\), contradicting Lemma 1.

In the basis of \(W_+^*\) dual to \((w_0,w_1,w_2)\) we then have
\(\ell_i=v_i\,(1,x_i,x_i^2)\), so the six points \([\ell_i]\in\PP(W_+^*)\) lie on
the smooth conic \(\{Y_0Y_2=Y_1^2\}\). By Lemma 1 no three of the six points are
collinear, so any conic through them is smooth, and two distinct smooth conics
meet in at most four points; the conic through the six is therefore unique, hence
\(G\)-stable, since \(G\) permutes the six points. The induced map
\(G\to\mathrm{PGL}(C)\cong\mathrm{PGL}_2\) is injective: \(G\) is simple, and a
trivial action on \(C\) would fix six points spanning \(\PP(W_+^*)\). So the
icosahedral group would have an orbit of size six on \(\PP^1\), whose point
stabilizer has order ten. Point stabilizers of \(\mathrm{PGL}_2(\bar k)\) acting
on \(\PP^1\) in characteristic prime to the group order are cyclic, and the
subgroups of order ten in \(A_5\) are dihedral. Contradiction, so Case B is
empty. ∎

Combining: \(\operatorname{Sing}\{c_B=0\}=\{p_a\}\), six distinct points, each an
ordinary node by the manuscript's Hessian computation. This proves the Theorem.

## What this changes

1. **The count is now proved, not certified, and in every characteristic**
   outside \(\{2,3,5\}\) with \(\sqrt5\) present — including characteristic zero,
   so the node corollary of \cite{RuddRigidity2026} acquires a second and
   self-contained proof that does not pass through the rational Hessian
   evaluation.
2. **The C926 Gröbner certificate becomes a cross-check.** It replays a proved
   statement in the one characteristic the paper works in. Keeping it costs
   nothing and is worth keeping; it should no longer be described as the reason
   the count is exact.
3. **The paper's central contrast becomes one sentence.** Both members of the
   invariant pencil are determinantal. The conference cubic is
   \(\det M\) for the matrix above, whose rank-one locus is the six coordinate
   tensors. The chordal cubic is the three-by-three Hankel determinant, a
   *symmetric* matrix of linear forms, and the rank-one locus of a symmetric
   three-by-three is the Veronese surface of degree four in \(\PP^5\); the
   Hankel matrices form a hyperplane there, so the chordal singular locus is a
   hyperplane section of the Veronese — a quartic curve of arithmetic genus zero,
   which is the rational normal quartic the manuscript computes by hand and whose
   Hilbert polynomial \(4d+1\) the C926 control leg returned. Non-isomorphism is
   then immediate: six points against a quartic curve.
4. **The six nodes acquire a meaning.** They are the six axes: the node \(p_a\)
   is the rank-one tensor \(\ell_a\otimes m_a\), whose kernel is the hyperplane
   \(\{w\in W_+:w_a=0\}\). The two three-dimensional eigenspaces of \(B\) are the
   two icosahedral representations, and the six coordinate functionals on them
   are the six axes of the icosahedron, which is to say the six Sylow
   \(5\)-subgroups the paper starts from.

## Verification

`papers/chordal-conference-reconstruction/verification/evidence/determinantal_presentation.py`
replays the construction over \(\F_{11}\): the eigenspace splitting, the
maximum-distance-separable property by exhaustive minors and weights, the
relation \(\sum_i\ell_i\otimes m_i=0\), the identity \(\det M=\kappa\,c_B\) with
its \(\kappa\), the six rank-one tensors at the frame points, and the rank-one
locus of \(M\) over \(\PP^4(\F_{11})\). It is a cross-check of a proved theorem,
not its evidence.

For the canonical reduced-row-echelon eigenspace bases the program fixes, the
constant is \(\kappa=1\): \(\det M\) is the triangle cubic on the nose, not
merely a multiple of it. That is a normalization accident of the basis choice,
not part of the theorem.

| path | bytes | SHA-256 |
|---|---|---|
| `papers/chordal-conference-reconstruction/verification/evidence/determinantal_presentation.py`   | 11405 | `f78ea061a5f35def10d709c9cd20caee2e93a85c670b010dad32250b4e173416` |
| `papers/chordal-conference-reconstruction/verification/evidence/determinantal_presentation.json` | 4919  | `c5051153590acc5dd8bfcb1287c0f8b53f651268dc9ea76e19a780d165c279ab` |

Replay, from the paper root:

```sh
make evidence   # third terminal prints CHECK OK (DETERMINANTAL_PRESENTATION_CONFIRMED)
```

## Open, and deliberately not done

- **No manuscript edit.** Where this lands — a new proposition replacing the
  citation-plus-Hessian argument, or an appendix — is a decision for the author,
  and it interacts with the C926 remark that was also left unapplied.
- **Ordinariness is still the manuscript's Hessian computation.** The
  determinantal picture gives it too: near a rank-one point the determinant is
  \(\varepsilon^2\) times the two-by-two cofactor of the perturbation, a quadratic
  form of rank four provided the perturbation map onto that cofactor block is an
  isomorphism. I did not verify that transversality in general, so the Hessian
  argument stays the cited one.
- **Generality beyond order six is untested.** The proof used \(|\Omega|=6\) in
  exactly two places: the dimension count \(3+3\) and the meeting of two weight-four
  supports in a six-set. Conference matrices of order \(q+1\) for larger \(q\)
  would need a different argument in Lemma 4 and lose the \(\PP^1\)-orbit step.
