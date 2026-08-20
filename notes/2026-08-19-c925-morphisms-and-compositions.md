# Module 19. Morphisms, compositions, and higher-stabilization consequences

**Packet part:** Module 19.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

The categorical architecture gives several theorems that are independent of
the cubic residue calculation.  Two are positive composition theorems and one
is a sharp no-go theorem.

## 19.1 A bicategory of block theories

Let \(\mathsf{BlkTh}\) have the following structure.

- A 0-cell is an indexed birational block theory from Module 7.6, together
  with the list of geometric adapters it supports.
- A 1-cell \(F:\mathfrak T\to\mathfrak U\) consists of functors on coefficient
  and probe contexts, a pseudonatural strong symmetric-monoidal functor on
  marked blocks, and invertible 2-cells intertwining every enabled comparison
  span and atomizer.  When products are retained, `strong monoidal` is
  upgraded to **strong rig**: \(F\) respects both direct sum \(\oplus\), tensor
  product \(\otimes\), and distributivity.
- A 2-cell is a modification compatible with the comparison 2-cells.

Composition is pointwise composition of the context functors, block
functors, and comparison 2-cells.  Pseudofunctor coherence and Mac Lane
coherence give associativity and units up to their unique canonical 2-cells.
Thus lawful block theories, not just their final monoid values, can be
specialized and composed.

## Theorem 19.1 — specialization and marker fusion

Let \(F:\mathfrak T\to\mathfrak U\) be a 1-cell and let
\(W:\mathfrak U\to\underline A\) be a lawful marker.  Then \(W\circ F\) is a
lawful marker on \(\mathfrak T\), and
\[
I_{W\circ F}(Y)=W\bigl(F(\mathscr B_{\mathfrak T}(Y))\bigr).
\tag{19.1}
\]
If \(W\) kills the image under \(F\) of every center of dimension at most
\(d\), then \(W\circ F\) factors through \(L_d\).  These assertions remain
true under any finite composite of 1-cells.

### Proof

Pseudonaturality gives the regular-gauge, base-change, and comparison laws for
the composite.  Strong monoidality gives the fold law.  The identity (19.1)
is functor composition, and the center statement is the universal property
(7.21).  Associativity for longer composites is bicategorical coherence. ∎

The main kinds of 1-cell are different and should not be conflated.

1. A **forgetful morphism** drops a marking or decoration.
2. A **quotient morphism** atomizes by a generated congruence; the KKPYY atom
   map is of this kind.
3. A **base specialization** pulls an indexed theory to a probe.  Guéré
   evaluation is only a lax/span-valued version until spectra are separated;
   on the separated probe category it becomes strong monoidal.
4. An **enrichment lift** equips an underlying block with extra operation or
   descent data.  Its forgetful map is a 1-cell in the opposite direction,
   but existence of the lift is additional mathematics.

## 19.2 The additive stabilization no-go theorem

## Theorem 19.2 — constituent-additive theories stop at one stabilization

Let \(X\) be a smooth projective variety of dimension \(s\), let \(m\ge2\),
and let \(I\) be a marker invariant satisfying
\[
I(X\times\mathbf P^m)=(m+1)I(X).
\tag{19.2}
\]
Suppose a weak-factorization proof in dimension \(s+m\) requires
\[
I(Z)=0\qquad(\dim Z\le s+m-2).
\tag{19.3}
\]
Then
\[
I(X\times\mathbf P^m)=0.
\tag{19.4}
\]

### Proof

Since \(m\ge2\), the variety \(X\) itself lies in the center range:
\(s\le s+m-2\).  Equation (19.3) gives \(I(X)=0\), and (19.2) gives
(19.4). ∎

For a cubic threefold this says that every unmarked additive constituent
marker is structurally powerless from \(m=2\) onward **in the
center-vanishing weak-factorization scheme**.  The obstruction is not a poor
choice of rank, residue, monodromy eigenvalue, or atom equivalence.  It is the
factorization
\[
\text{structured configuration}
\longrightarrow\operatorname{Sym}(\text{individual blocks})
\longrightarrow A.
\tag{19.5}
\]
By the universal property of \(\operatorname{Sym}\), every strong
symmetric-monoidal marker after this forgetful arrow is determined block by
block.  Two configurations with the same underlying multiset but different
provenance, cyclic action, extension class, or distinguished row are
indistinguishable.  Hence an \(m=2\) solution within this positive compiler
must retain a relation or operation **before** applying the free-multiset
compiler, or else abandon the center-vanishing strategy for a genuinely
global cancellation law.

## 19.3 Composition by an ideal quotient

The ordinary demand that all local comparison matrices literally agree is
often stronger than a marker needs.

## Theorem 19.3 — ideal-quotient telescope

Let \(\mathcal C\) be a preadditive category and \(\mathcal I\) a two-sided
ideal of morphisms.  Let
\[
Q:\mathcal C\longrightarrow\mathcal C/\mathcal I
\tag{19.6}
\]
be the quotient functor, and suppose a marker \(W\) factors through \(Q\).
If every elementary comparison in a zigzag becomes an isomorphism under
\(Q\), then the two endpoint marker values agree.  If, after fixed endpoint
identifications, every forward comparison has the form
\[
T_i=1+e_i,
\qquad e_i\in\mathcal I,
\tag{19.7}
\]
then every composite also has the form \(1+e\) with \(e\in\mathcal I\).

### Proof

The first claim follows by composing the isomorphisms \(Q(T_i)\), reversing
them for backward arrows, and applying the factorized marker.  For the second,
\[
(1+e_2)(1+e_1)=1+(e_1+e_2+e_2e_1),
\]
and the parenthesized term lies in \(\mathcal I\).  Induction proves the
claim. ∎

This theorem imports the standard quotient-by-an-ideal mechanism into the
weak-factorization problem.  It does **not** make the naked class
\(\{e:r e=0\}\) into a two-sided ideal.  In the full matrix category, take
\[
r=(1,0),\qquad e=E_{21},\qquad a=E_{12}.
\]
Then \(re=0\), but \(r(ae)=rE_{11}\ne0\).  In fact the two-sided ideal
generated by \(E_{21}\) in \(M_2(K)\) is the whole matrix algebra, since it
contains both \(E_{11}=E_{12}E_{21}\) and
\(E_{22}=E_{21}E_{12}\).  Forcing two-sided closure can therefore trivialize
the proposed quotient.

The lawful repair packages the row as an output arrow before taking a
kernel.

## Theorem 19.3A — augmented-row output and canonical kernel ideal

Let \(\mathsf{AugOp}_K\) have objects
\[
A=(V_A,T_A,L_A,r_A:V_A\to L_A)
\tag{19.7a}
\]
and morphisms \((f,\ell):A\to B\) satisfying
\[
fT_A=T_Bf,
\qquad
r_Bf=\ell r_A.
\tag{19.7b}
\]
Then \(\mathsf{AugOp}_K\) is preadditive.  The output functor
\[
\mathsf{Out}:\mathsf{AugOp}_K\to\mathsf{Vect}_K,
\qquad
(V,T,L,r)\mapsto L,\quad(f,\ell)\mapsto\ell
\tag{19.7c}
\]
is additive, so
\[
\mathcal J=\ker(\mathsf{Out})
\tag{19.7d}
\]
on Hom spaces is a canonical two-sided ideal.

If \((f,\ell)\) is an isomorphism and \(p\in K[t]\), then
\[
r_Ap(T_A)\ne0
\quad\Longleftrightarrow\quad
r_Bp(T_B)\ne0.
\tag{19.7e}
\]
The same equivalence holds when the class of \((f,\ell)\) is an isomorphism
in \(\mathsf{AugOp}_K/\mathcal J\), and also when \(f\) is surjective and
\(\ell\) is invertible.

### Proof

The two equations in (19.7b) are closed under addition and composition, so
the category is preadditive and \(\mathsf{Out}\) is additive.  The kernel of
an additive functor is a two-sided ideal.  Polynomial naturality gives
\[
r_Bp(T_B)f=r_Bfp(T_A)=\ell r_Ap(T_A).
\]
For an isomorphism, both \(f\) and \(\ell\) are invertible, proving
(19.7e).  If only the quotient class is invertible, choose a quotient inverse
\((g,m)\).  Applying \(\mathsf{Out}\) to the two inverse equations gives
\(m\ell=1\) and \(\ell m=1\).  Equation (19.7e) in the forward direction
shows that a nonzero source row forces a nonzero target row; applying the
same argument to \((g,m)\) gives the converse.

For the final case, the polynomial identity shows that vanishing of the
target row implies vanishing of the source row.  If the source row vanishes,
the target row vanishes after precomposition with the surjection \(f\), hence
vanishes. ∎

For a one-dimensional output \(L=K\), \(\ell\) is the allowed scalar change
of row normalization.  Thus the primitive-row Boolean needs preservation of
the row **line**, not equality of one normalized row vector.  The case
\(r=0\) is also typed correctly.  If exact normalization is desired, restrict
to the groupoid with \(\ell=1\); it is closed under composition and inverse,
so no ideal quotient is needed for one ordered path.

The rank-framed Stokes/Gamma application of Theorem 19.3 is legitimate only
after a geometric provider lands in \(\mathsf{AugOp}_K\), or after a separate
additive retained-shadow functor \(R\) has been constructed and one sets
\(\mathcal I=\ker R\).  The ideal then comes for free.  The unresolved
analytic gate is the construction of the row-line-compatible provider and
its overlap 2-cells, not an abstract ideal axiom.

### Proposition 19.3B -- the residual row stabilizer is affine-linear

Let \(V\) be finite-dimensional over \(K\), let \(0\ne r:V\to K\), choose
\(s\in V\) with \(r(s)=1\), and put \(H=\ker r\).  Every invertible
\(T\) preserving the row line has unique coordinates

\[
T(s)=c s+u,\qquad T|_H=A,qquad
(c,u,A)\in K^\times\times H\times\operatorname{GL}(H).
\tag{19.7f}
\]

Composition and inverse are

\[
(c,u,A)(d,v,B)=(cd,\,d u+A v,\,AB),
\qquad
(c,u,A)^{-1}=(c^{-1},-c^{-1}A^{-1}u,A^{-1}).
\tag{19.7g}
\]

Thus the row-line stabilizer is the corresponding affine parabolic; the
exact-row stabilizer is the subgroup \(c=1\), isomorphic to
\(H\rtimes\operatorname{GL}(H)\).  The proof is obtained by applying \(r\)
to \(T(s)\) and \(T(H)\), followed by direct composition.

These coordinates depend on the choice of \(s\), although the parabolic and
its row-line character are canonical.  The augmented output functor records
the scalar \(c\); the final nonzero Boolean ignores its value once
\(c\in K^\times\) has been certified.  The translation \(u\) and kernel
automorphism \(A\) are lawful hidden state.  A provider therefore need not
calculate them, but row preservation cannot reconstruct them.  This is the
group-level version of the non-implications in (21.24).

## 19.4 The monadic nilpotent-operation specialization

Let \(K\) have characteristic zero.  Write \(\mathsf{Nil}_K\) for the category
of finite-dimensional vector spaces equipped with a nilpotent endomorphism
\(D\), with \(D\)-linear maps.  It is the finite-nilpotent part of the
Eilenberg--Moore category for the monad
\[
T(V)=K[t]\otimes_KV,
\tag{19.8}
\]
and equivalently the category of finite-dimensional unipotent
representations of \(\mathbf G_a\).  It is a symmetric rig category with
\[
(V,D_V)\otimes(W,D_W)
=\bigl(V\otimes W,D_V\otimes1+1\otimes D_W\bigr).
\tag{19.9}
\]

If \(\tau\) is a unipotent line-bundle or parameter-loop action, put
\[
D=\log\tau.
\tag{19.10}
\]
The sum is finite.  The operators \(D\) and \(1-\tau\) have the same Jordan
partition, while
\[
\log(\tau_V\otimes\tau_W)
=D_V\otimes1+1\otimes D_W.
\tag{19.11}
\]
Thus the logarithm converts the multiplicative line-bundle action into the
primitive Hopf-algebra tensor law.

Let \(J_a=K[t]/(t^a)\).  The characteristic-zero Clebsch--Gordan rule is
\[
\boxed{
J_a\otimes J_b
\cong
\bigoplus_{i=1}^{\min(a,b)}J_{a+b-2i+1}.}
\tag{19.12}
\]
One proof identifies \(J_a\) with the regular nilpotent action on
\(\operatorname{Sym}^{a-1}K^2\) and applies the \(\mathfrak{sl}_2\)
Clebsch--Gordan decomposition.  Forgetting \(D\) sends \(J_a\) to \(a\)
unrelated one-dimensional constituents, exactly recovering the ordinary
projective-bundle ledger.

This gives a nontrivial coherence theorem.  Projection from a point makes
\(\operatorname{Bl}_p\mathbf P^m\) a \(\mathbf P^1\)-bundle over
\(\mathbf P^{m-1}\).  If the lifted projective objects are \(J_{r+1}\), the
projective presentation gives
\[
J_m\otimes J_2=J_{m+1}\oplus J_{m-1}.
\tag{19.13}
\]
Therefore the blowup presentation must lift its total exceptional string to
\(J_{m-1}\), not to \(J_1^{\oplus(m-1)}\).  These agree for \(m=2\), but not
for \(m\ge3\).  The mismatch is not a contradiction in geometry; it proves
that a higher-stabilization lift must retain non-split gluing among the
exceptional copies.

## 19.5 Conditional \(m=2\) and higher obstruction theorems

## Theorem 19.4 — operation-framed \(J_3\) criterion

Suppose the primitive-sixth QDM sector lifts functorially to
\(\mathsf{Nil}_K\) and satisfies:

1. the packet of \(X\times\mathbf P^2\) contains a \(J_3\), while that of
   \(\mathbf P^5\) contains none;
2. every fivefold blowup comparison is a strict biproduct in
   \(\mathsf{Nil}_K\); and
3. no packet of a smooth projective variety of dimension at most three
   contains \(J_3\).

Then \(X\times\mathbf P^2\) is irrational.

### Proof

Finite nilpotent \(K[t]\)-modules are Krull--Schmidt.  Hence the multiplicity
of \(J_3\) is additive under strict biproducts.  Every nontrivial center in a
fivefold has dimension at most three, so hypothesis 3 makes that multiplicity
unchanged across every weak-factorization arrow.  Hypothesis 1 distinguishes
the two endpoints. ∎

The analogous statement with \(J_{m+1}\) applies to
\(X\times\mathbf P^m\), provided the operation-framed comparison is coherent
with the exceptional-string law (19.13) and no center of dimension at most
\(m+1\) carries \(J_{m+1}\).

This is a real gain in organization, but not a new unconditional
irrationality theorem.  For \(m=2\), product naturality supplies the endpoint
\(J_3\); the unresolved inputs are strict transport of the operation through
arbitrary comparisons and the arbitrary-threefold carrier bound.  The
rank-framed augmented-row route of Theorem 19.3A bypasses the carrier bound
and is currently the stronger route: if its one global row-line-compatible
provider exists, the same argument is uniform in \(m\).

## 19.6 Further useful specializations

| provider | block category and morphisms | laws imported | value and limitation |
| --- | --- | --- | --- |
| Chow or André motives | pure motives with Tate twists and correspondences | Manin blowup and projective-bundle decompositions | exact benchmark; unmarked additive form is ruled out for \(m\ge2\) by Theorem 19.2 |
| noncommutative motives | additive motives of `Perf`, induced by Fourier--Mukai kernels | Orlov semiorthogonal blowup/projective-bundle formulas | exact additive specialization; full dg/SOD gluing, not its additive motive, is needed to retain exceptional extensions |
| irregular Riemann--Hilbert | Stokes-filtered local systems with strict filtered morphisms | sectorial descent, duality, tensor product | natural home for correlated exponential factors and the Gamma row; arbitrary-blowup strictness is the provider gate |
| \(\operatorname{Rep}(\boldsymbol\mu_6\times\mathbf G_a)\) | primitive-sixth eigensector with commuting formal monodromy and logarithmic base action | character projectors plus (19.12) | minimal operation-framed candidate for \(m=2\) |
| Mackey/Burnside descent | finite Galois/deck sets, spans, restriction and induction | double-coset and table-of-marks laws | retains cyclic branch provenance, but semisimple deck data alone cannot produce or detect the required \(J_3\) extension |
| quiver/Hall enhancement | blocks plus extension arrows; morphisms are diagram maps | Krull--Schmidt, extension composition, Hall multiplication where defined | can retain gluing discarded by split \(K_0\); no general QDM blowup provider has yet been constructed |
| gauged common-source theory | endpoint modules related by quotient maps from one gauged source | kernel descent, Beck--Chevalley, quotient-by-ideal | closest fit to the current all-\(m\) rank-row route; the zero-mode/common-receiver compatibility remains analytic |

The most informative chain of forgetful morphisms is
\[
\mathsf{StokesGamma}^{\mathrm{pointed}}_{\zeta_6}
\longrightarrow
\operatorname{Rep}(\boldsymbol\mu_6\times\mathbf G_a)^{\mathrm{pointed}}
\longrightarrow
\operatorname{Rep}(\boldsymbol\mu_6\times\mathbf G_a)
\longrightarrow
\operatorname{Rep}(\boldsymbol\mu_6)
\longrightarrow
\mathsf{Vect}_K.
\tag{19.14}
\]
The arrows forget, successively, Stokes/Gamma data, the distinguished rank
row, the unipotent operation, and the cyclotomic character.  Any marker that
factors past the arrow forgetting \(\mathbf G_a\) also forgets the distinction
between \(J_3\) and \(J_1^{\oplus3}\), and therefore falls back under the
no-go theorem.

For \(m=2\) and higher, the categorical framework therefore contributes
three concrete things:

1. an unconditional proof that no further unmarked constituent marker can
   work;
2. the exact operation-framed target category and its compulsory
   projective/blowup coherence identities; and
3. an augmented-row composition theorem showing that row-line-compatible
   isomorphisms suffice, with any global error ideal derived as the kernel of
   an honest output functor--literal equality of row normalizations is
   unnecessary.

The missing step is geometric/analytic, not categorical: construct one of
the two enriched provider functors and prove its comparison 2-cells.  Once
that exists, the obstruction and its composition are formal consequences of
Theorems 19.3A or 19.4.

The finite law replay checks Theorem 19.2 for \(2\le m\le6\), verifies
(19.12) for \(1\le a,b\le5\) and (19.13) through \(m=6\) by exact rational
Jordan-kernel calculations, disproves two-sidedness of the naked row kernel,
and checks both ordered row-stabilizer composition and the canonical
augmented-row output-kernel repair.

---
