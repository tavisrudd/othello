# A modular direct quantum-`D`-module proof of cubic one-stabilization irrationality

## Parameterized proof packet

**Date:** 2026-08-19

**Task:** C925

**Status:** draft under audit

**Scope:** mathematics only; no manuscript or Lean edits

---

## Executive theorem

Let \(X\subset \mathbf P^4\) be a smooth cubic threefold. Then
\[
X\times\mathbf P^1
\]
is irrational.

The proof uses ordinary genus-zero quantum \(D\)-modules, Beauville's small
quantum-cohomology calculation, the Iritani--Koto projective-bundle
decomposition, Iritani's blowup decomposition, and weak factorization.

The packet is modular in the following precise sense.  The geometric transport
machinery is written once for an arbitrary **marker package**.  A marker package
chooses:

1. what information to observe on a generic even QDM spectral block;
2. which observed blocks to retain; and
3. what value each retained block contributes to a commutative monoid.

The cubic proof instantiates this interface with the smallest sufficient
observation:
\[
\boxed{
\text{even rank }2,\qquad
N\ne0,\qquad
\delta^\sharp\ne0.
}
\]
It does not retain the odd rank, the exact value \(\delta^\sharp=4/9\), or the
full formal type.

## Reader and configuration paths

| Goal | Modules |
| --- | --- |
| Understand or implement the marker interface | 0, 2, 7, 14 |
| Audit coefficient and transport safety | 1, 3--6, 8 |
| Reuse the fourfold birational obstruction | 7--9 and Theorem 16.1 |
| Check only the cubic instance | 4, 10--13 |
| See the whole proof in one diagram | Diagram 13.1 |

---

# Module 0. Interface summary

The software analogy is:

```haskell
class CommutativeMonoid (Value m) => QDMMarker m where
  data Observation m
  observe  :: GenericEvenBlock -> Observation m
  select   :: Observation m -> Bool
  emit     :: Observation m -> Value m

  -- laws, not executable fields
  regularGaugeLaw :: RegularGauge b b' -> mark b == mark b'
  baseChangeLaw   :: FieldExtension k l -> mark (b `baseChange` l) == mark b
```

Here

```haskell
mark b = if select (observe b) then emit (observe b) else mempty
```

and the invariant of a variety is the fold

```haskell
qdmInvariant y = foldMap mark (genericEvenSpectralBlocks y).
```

The rest of the packet proves that the Iritani comparison theorems act as
lawful adapters for this interface and that weak factorization consumes only
the resulting monoid-valued ledger.

---

# Module 1. Generic even quantum-`D`-module blocks

Let \(Y\) be a smooth projective complex variety of dimension \(D\).  Restrict
the big quantum base to even cohomology:
\[
t\in H^{\mathrm{even}}(Y).
\]
Quantum multiplication by an even class preserves cohomological parity, so the
quantum connection restricts to the even module
\[
\operatorname{QDM}^{\mathrm{ev}}(Y)
=H^{\mathrm{even}}(Y)[z][[Q,t]].
\]

In a homogeneous basis, the connection is
\[
\nabla_{\partial_{t^a}}
=\partial_{t^a}+z^{-1}C_a,
\qquad
C_a=\phi_a\star_t,
\tag{1.1}
\]
and
\[
\nabla_{z\partial_z}
=z\partial_z-z^{-1}U+\mu,
\qquad
U=E_Y\star_t.
\tag{1.2}
\]
The Poincaré pairing on even cohomology is symmetric, nondegenerate, and
horizontal.

Pass to the fraction field of the numerical reduced even bulk base, then to an
algebraic closure.  The characteristic polynomial of \(U\) splits.  Its
pairwise coprime primary factors give generalized-eigenvalue summands.

## Definition 1.1 — generic even spectral block

A **generic even QDM spectral block** is one generalized-eigenvalue summand of
the full even quantum connection after algebraic generic scalar extension.

An object \(B\) in the block groupoid consists of:

- a finite-dimensional vector space over an algebraically closed generic
  coefficient field;
- the restriction of the full flat connection;
- its regular \(z\)-lattice;
- the restricted horizontal pairing; and
- its single Euler eigenvalue \(\lambda_B\).

Within a fixed generic field, morphisms are parity-even connection
isomorphisms that are regular and invertible at \(z=0\).  Extension of the
generic coefficient field acts by base-change functors; it is not declared to
be an invertible morphism.

We write this groupoid informally as \(\mathsf{QBlock}^{\mathrm{ev}}\).

## Lemma 1.2 — formal block splitting

Suppose
\[
U=\bigoplus_i(\lambda_iI+N_i),
\qquad \lambda_i-\lambda_j\ne0\quad(i\ne j),
\]
with every \(N_i\) nilpotent.  Then there is a unique normalized formal gauge
\[
G(z)=I+G_1z+G_2z^2+\cdots
\]
whose coefficients are block-off-diagonal and which block-diagonalizes the
\(z\)-connection.

### Proof

At order \(z^{n-1}\), an off-diagonal block \(X=(G_n)_{ij}\) solves
\[
(\lambda_i-\lambda_j)X+N_iX-XN_j=B_{n,ij}.
\]
The operator \(X\mapsto N_iX-XN_j\) is nilpotent.  Thus the displayed
Sylvester operator is an invertible scalar plus a nilpotent operator and is
invertible by a finite geometric series.  Induction gives the unique gauge.
No fractional power of \(z\) occurs. ∎

## Lemma 1.3 — flatness splits every base direction

After applying Lemma 1.2, every base-direction connection matrix is block
diagonal for the same decomposition.

### Proof

Use fixed frames of the Henselian generalized-eigenvalue submodules.  If an
off-diagonal base block has first nonzero Laurent term \(Xz^m\), the lowest
coefficient of the flatness equation is
\[
U_iX-XU_j=0.
\]
The same Sylvester operator is invertible, so \(X=0\), a contradiction. ∎

## Lemma 1.4 — separated blocks have nondegenerate pairings

Distinct spectral blocks are orthogonal for the horizontal Poincaré pairing,
and the pairing restricted to each block is nondegenerate.

### Proof

In the block-diagonal frame, write
\[
P(z)=P_0+zP_1+\cdots.
\]
On an off-diagonal \((i,j)\)-block, the lowest pairing-horizontality equation
is a Sylvester equation of the form
\[
U_i^T(P_0)_{ij}-(P_0)_{ij}U_j=0.
\]
Its scalar eigenvalue difference is nonzero, so \((P_0)_{ij}=0\).  At every
higher order the same invertible Sylvester operator acts on \((P_m)_{ij}\),
with a right-hand side involving only earlier off-diagonal coefficients.
Induction gives \(P_{ij}(z)=0\).  The full pairing is nondegenerate, so every
diagonal restriction is nondegenerate. ∎

Thus a generic Euler block is a block of the entire even QDM, not merely of one
endomorphism.

---

# Module 2. Marker packages

Let \((A,+,0)\) be a commutative monoid.

## Definition 2.1 — lawful marker package

A **lawful QDM marker package** \(\mathcal M\) consists of:

1. a set \(O_{\mathcal M}\) of observations;
2. an observation map
   \[
   \operatorname{obs}_{\mathcal M}:
   \operatorname{Obj}(\mathsf{QBlock}^{\mathrm{ev}})
   \longrightarrow O_{\mathcal M};
   \]
3. a selector
   \[
   \operatorname{keep}_{\mathcal M}:O_{\mathcal M}\to\{0,1\};
   \]
4. an emitter
   \[
   \operatorname{emit}_{\mathcal M}:O_{\mathcal M}\to A;
   \]

subject to two laws.

### Regular-isomorphism law

If \(B\cong B'\) by a connection isomorphism regular and invertible at
\(z=0\), then
\[
\operatorname{obs}_{\mathcal M}(B)
=\operatorname{obs}_{\mathcal M}(B').
\tag{2.1}
\]

### Generic-base-change law

If \(L/K\) is a field extension and \(B_L\) is obtained from \(B\) by scalar
extension, then
\[
\operatorname{obs}_{\mathcal M}(B_L)
=\operatorname{obs}_{\mathcal M}(B).
\tag{2.2}
\]
Here equality means the canonical identification prescribed by the package;
for example, a conjugacy class is extended to \(L\), while a rank or a Boolean
property is literally unchanged.

Define the value of a block by
\[
w_{\mathcal M}(B)=
\begin{cases}
\operatorname{emit}_{\mathcal M}(\operatorname{obs}_{\mathcal M}(B)),
&\operatorname{keep}_{\mathcal M}(\operatorname{obs}_{\mathcal M}(B))=1,\\
0,&\text{otherwise}.
\end{cases}
\tag{2.3}
\]

## Definition 2.2 — variety invariant

For a smooth projective \(Y\), define
\[
I_{\mathcal M}(Y)
=\sum_{B\in\operatorname{Blocks}^{\mathrm{ev}}(Y)}w_{\mathcal M}(B)
\in A.
\tag{2.4}
\]
The sum is finite because the even cohomology has finite rank.

## Examples 2.3 — selectable retention levels

The interface supports, without changing any later transport proof:

1. **Existence only:** \(A=(\{0,1\},\lor,0)\), emitting `true` for every
   retained block.
2. **Count:** \(A=(\mathbf N,+,0)\), emitting \(1\).
3. **Multiset:** \(A=\mathbf N^{(O)}\), emitting the basis vector of the
   observation.  This retains every observed signature with multiplicity.
4. **Exact numerical profile:** observations may contain rank, Jordan
   partition, residue trace, determinant, discriminant, or formal monodromy.
5. **Product observer:** if \(\mathcal M_1,\mathcal M_2\) are lawful, observe
   both and take values in \(A_1\times A_2\).
6. **Coarse Boolean marker:** observe rich data but retain only whether a
   specified predicate holds.

## Definition 2.4 — morphism of marker packages

Let \(\mathcal M\) take values in \(A\) and \(\mathcal N\) in \(B\).  A
**forgetful morphism** \(F:\mathcal M\to\mathcal N\) is a monoid homomorphism
\[
F_*:A\to B
\]
such that for every block
\[
F_*(w_{\mathcal M}(B))=w_{\mathcal N}(B).
\tag{2.5}
\]

## Proposition 2.5 — naturality under forgetting

For every smooth projective \(Y\),
\[
F_*(I_{\mathcal M}(Y))=I_{\mathcal N}(Y).
\tag{2.6}
\]

### Proof

Apply \(F_*\) termwise to the finite sum (2.4). ∎

Therefore one may prove a rich ledger once and later forget exact residue
values or multiplicities without revisiting the geometry.  Optional parity
enrichment, including odd ranks, is described in Module 14.

---

# Module 3. Coefficient spines and generic data

The comparison theorems use Laurent neighborhoods in the fibre or exceptional
variable.  The intrinsic ample-adic completion and the opposite Laurent
completion need not map to one another.  The correct interface is a common
coefficient spine.

## Definition 3.1 — common coefficient spine

A **coefficient spine** is a diagram of injective maps of \(z\)-independent
integral domains
\[
R_{\mathrm{full}}\longleftarrow R_0\longrightarrow R_\infty.
\tag{3.1}
\]
Write
\[
K_0=\operatorname{Frac}(R_0),\quad
K_{\mathrm{full}}=\operatorname{Frac}(R_{\mathrm{full}}),\quad
K_\infty=\operatorname{Frac}(R_\infty).
\]
Both outer fields are field extensions of \(K_0\).  No map between the outer
rings or fields is required.  The QDM lattices live over \(R_i[z]\) or
\(R_i[[z]]\); taking \(\operatorname{Frac}(R_i)\) never inverts \(z\).

## Lemma 3.2 — common-generic-field principle

Let a finite connection matrix and pairing be defined over the corresponding
\(R_0[z]\)-lattice.  Every
algebraic generic-block observation satisfying Definition 2.1 has the same
value after passage through either arm of (3.1).

### Proof

Rank, characteristic factors, Jordan partitions, nilpotence, regular formal
gauges, and conjugacy invariants are unchanged by field extension.  Compare
both arms after extending an algebraic closure of \(K_0\) into algebraic
closures of the two outer fields.  The marker's base-change law gives the
claim. ∎

## Projective-bundle spine

Iritani--Koto define the projective-bundle QDM over \(R_0[z]\), where
\[
R_0=\mathbf C[q][[Q,\widehat t]],
\tag{3.2}
\]
and its localized form over \(R_\infty[z]\), where
\[
R_\infty
=\mathbf C((q^{-1/r'}))[[Q,\widehat t]].
\tag{3.3}
\]
The map \(R_0\hookrightarrow R_\infty\) is injective.  Completing \(R_0\) in
the separated ample filtration of the intrinsic effective cone gives the
other injective arm \(R_0\hookrightarrow R_{\mathrm{full}}\).

This is the only comparison needed.  We never assert a map
\[
\mathbf C[[q]]\longrightarrow\mathbf C((q^{-1/r'})).
\]

## Blowup spine

On the blowup side, Iritani's equation (5.38) is an actual embedding from the
intrinsic blowup coefficient algebra into the formal Laurent algebra:
\[
\widetilde Q^{\widetilde d}
\longmapsto
Q^{\varphi_*\widetilde d}
\mathfrak q^{-[D]\cdot\widetilde d}.
\tag{3.4}
\]
Together with the injective completion of the same intrinsic algebra, this is
the blowup coefficient spine.  The center side is different: its raw map may
fail to be injective and is handled by the numerical/divisor adapter in Module
6.

## Numerical Novikov reduction

Before using divisor characters, pass from effective homology classes to
effective numerical classes.  Filter by ample degree.  Effective homology
classes below a fixed cutoff form a finite set because they occur in finitely
many finite-type Chow varieties and the homology class is locally constant in
an algebraic family.  Hence grouping coefficients by numerical class defines
a continuous ring map and commutes with completed convolution.

All curve operations in the two QDM comparison theorems—pushforward, Chern
pairing, and exceptional or projective-bundle exponents—depend only on the
numerical class.  Applying the numerical quotient to a comparison map and its
stated inverse preserves their inverse identities.  Thus both comparison
theorems descend to the numerical QDM.

The numerical completed monoid algebra is a domain: its effective monoid lies
in the torsion-free lattice \(N_1(Y)\), and the lowest ample-degree part of a
nonzero product is the product of two nonzero elements of an ordinary monoid
algebra.

---

# Module 4. A reusable rank-two observation

This module supplies one possible observation for a marker package.  Other
packages may ignore it entirely.

Let \(B\) be a generic even spectral block of rank two.  Center its Euler
eigenvalue and write its horizontal \(z\)-equation as
\[
z\partial_z y=A(z)y,
\qquad
A(z)=z^{-1}N+A_0+zA_1+\cdots.
\tag{4.1}
\]
Concretely, centering subtracts \(z^{-1}\lambda I\) from the horizontal
matrix and adds \(z^{-1}(\partial\lambda)I\) to a base-direction matrix.  It is
the connection-level form of the scalar factor \(e^{-\lambda/z}\), but no
exponential is adjoined.  The scalar factors at \(-z\) and \(z\) cancel in the
horizontal pairing, so centering preserves it.

Assume \(N\ne0\).  Since \(N\) is a nilpotent \(2\times2\) matrix,
\[
N^2=0,
\qquad
L:=\operatorname{im}N=\ker N
\tag{4.2}
\]
is an intrinsic line.

## Lemma 4.1 — the regular coefficient preserves the intrinsic line

\[
A_0L\subset L.
\tag{4.3}
\]

### Proof

Write the horizontal pairing as
\[
P(z)=P_0+zP_1+\cdots.
\]
Pairing horizontality for the convention (4.1) reads
\[
z\partial_zP+A(-z)^TP+PA(z)=0.
\tag{4.4}
\]
The \(z^{-1}\)-coefficient gives
\[
N^TP_0=P_0N.
\tag{4.5}
\]
Thus \(N\) is self-adjoint for the nondegenerate symmetric form \(P_0\).
The line \(L\) is isotropic, and in dimension two \(L^\perp=L\).

The constant coefficient of (4.4) is
\[
A_0^TP_0+P_0A_0-N^TP_1+P_1N=0.
\tag{4.6}
\]
For \(0\ne x\in L=\ker N\), sandwiching (4.6) between \(x\) and \(x\)
gives \((A_0x,x)_{P_0}=0\).  Hence \(A_0x\in L^\perp=L\). ∎

## Definition 4.2 — canonical shear and modified residue

Define the elementary modification
\[
B^\sharp=\{s\in B:s\bmod z\in L\}.
\tag{4.7}
\]
Choose an adapted frame with
\[
N=\nu E_{12},\qquad \nu\ne0,
\]
and use the new lattice basis \((e_1,ze_2)\), represented by
\[
S=\operatorname{diag}(1,z).
\]
The transformed horizontal matrix is
\[
A^\sharp=S^{-1}AS-S^{-1}z\partial_zS.
\tag{4.8}
\]
The irregular term becomes the regular term \(\nu E_{12}\).  The only
possible pole from \(A_0\) would be its \(E_{21}\)-entry, which vanishes by
Lemma 4.1.  Every higher term remains regular.  Thus
\[
A^\sharp=R+zR_1+z^2R_2+\cdots.
\tag{4.9}
\]
Define
\[
\delta^\sharp(B)=(\operatorname{tr}R)^2-4\det R.
\tag{4.10}
\]

## Lemma 4.3 — regular-gauge invariance

The rank, the condition \(N\ne0\), and \(\delta^\sharp\) satisfy the two marker
laws in Definition 2.1.

### Proof

Let \(T(z)=T_0+T_1z+\cdots\) be a regular invertible connection gauge.  Then
\[
N'=T_0^{-1}NT_0,
\qquad
L'=T_0^{-1}L.
\]
So \(T\) identifies the intrinsic modified lattices.  Its induced map there is
regular and invertible at \(z=0\), and the two modified residues are conjugate.
Rank, nonvanishing of \(N\), and the discriminant are therefore invariant.
The same statements plainly survive field extension. ∎

## Lemma 4.4 — flatness makes the modified spectrum constant

Along every formal even bulk direction, the modified residue evolves by a Lax
equation.  In particular, \(\delta^\sharp\) is constant.

### Proof

For a centered base direction \(\partial\), write
\[
\partial y=B_\partial(z)y,
\qquad
B_\partial=z^{-1}C_\partial+C_{\partial,0}+O(z).
\]
To justify the trace condition used below, start before centering with leading
Euler term \(\lambda I+N\).  The \(z^{-1}\)-coefficient of uncentered flatness
has trace
\[
2\,\partial\lambda+\operatorname{tr}C_\partial^{\mathrm{old}}=0.
\]
The scalar centering adds \((\partial\lambda)I\) to the base leading
coefficient, so
\[
C_\partial=C_\partial^{\mathrm{old}}+(\partial\lambda)I,
\qquad \operatorname{tr}C_\partial=0.
\]
The \(z^{-2}\)-coefficient of flatness gives
\[
[N,C_\partial]=0.
\]
Centering makes \(C_\partial\) traceless.  The commutant of a nonzero
rank-one nilpotent in dimension two is \(KI\oplus KN\), hence
\[
C_\partial=q_\partial N.
\tag{4.11}
\]

After the shear, the only possible base pole is
\[
B_\partial^\sharp=z^{-1}K_\partial+G_\partial+O(z),
\qquad K_\partial=kE_{21}.
\]
The \(z^{-1}\)-coefficient of modified flatness says
\[
K_\partial+[R,K_\partial]=0.
\]
Because \(R_{12}=\nu\ne0\), the diagonal entries force \(k=0\).  The modified
base connection is regular.  The constant term of flatness is therefore
\[
\partial R=[G_\partial,R].
\tag{4.12}
\]
Trace and determinant are constant under this Lax equation. ∎

## Example 4.5 — the qualitative rank-two observer

Take
\[
O_{\mathrm{rt}}
=\{(r,n,s):r\in\mathbf N,\ n,s\in\{0,1\}\},
\]
where
\[
r=\operatorname{rank}B,
\quad
n=[N\ne0],
\quad
s=[\delta^\sharp\ne0].
\]
For blocks not satisfying \(r=2,n=1\), set \(s=0\) by convention.  Lemma 4.3
makes this a lawful observation.  A caller can retain the entire triple, count
only \((2,1,1)\), or map it to a Boolean.

---

# Module 5. Direct sums and comparison adapters

## Lemma 5.1 — independent units separate summand spectra

Suppose QDM summands \(B_i\) have independent unit bulk coordinates \(u_i\).
Then their Euler spectra are pairwise disjoint at the generic point.

### Proof

The string equation makes the quantum product independent of \(u_i\), while
the Euler multiplication on the \(i\)-th summand is translated by \(u_iI\).
If \(p_i(T)\) and \(p_j(T)\) are the characteristic polynomials before unit
translation, the resultant of
\[
p_i(T-u_i),\qquad p_j(T-u_j)
\]
is a polynomial in \(u_i-u_j\) whose leading term, up to sign, is
\[
(u_i-u_j)^{(\deg p_i)(\deg p_j)}.
\]
It is not identically zero. ∎

## Proposition 5.2 — direct-sum adapter

Let a regular parity-preserving QDM isomorphism identify the generic even QDM
of \(Y\), after lawful coefficient extension and an invertible bulk-coordinate
change, with
\[
\bigoplus_{i=1}^m \mathscr Q_i.
\]
If the summands have independent unit coordinates, then for every lawful marker
package
\[
I_{\mathcal M}(Y)=\sum_{i=1}^m I_{\mathcal M}(\mathscr Q_i).
\tag{5.1}
\]

### Proof

Lemma 5.1 prevents blocks from different summands from merging.  Regularity,
parity, and the marker laws identify each even block with exactly one summand
block and preserve its weight.  Sum the weights. ∎

## Parity adapter

Both comparison papers work with supercommutative QDMs.  After odd bulk
coordinates are set to zero, all scalar coefficients—including roots of even
Novikov variables—have even parity.  The comparison constructions are
parity-even: their leading terms use only even hyperplane powers, even Gysin
degree shifts, and even Laurent scalars, and the formal coordinate maps are
maps of supermanifolds.  Therefore their comparison isomorphisms restrict to
the even QDMs used in this packet.

The Jacobian of a parity-even formal coordinate map is block diagonal by
parity at the odd-zero slice.  Invertibility of the full Jacobian therefore
implies invertibility of its even-even block.  The target even coordinates,
including all target unit coordinates, remain independent after the
restriction.

This is the only parity fact needed.  No odd block rank is retained.

## Regularity adapter

Iritani's blowup comparison is an isomorphism over a ring of the form
\[
\mathbf C[z]((\mathfrak q^{-1/s}))[[Q,t]],
\]
and Iritani--Koto's projective-bundle comparison is over
\[
\mathbf C[z]((q^{-1/r'}))[[Q,t]].
\]
Their maps and inverses require no negative powers of \(z\).  Iritani--Koto
Remark 5.3 explicitly places the homogeneous coefficient ring in a formal
power-series ring in \(z\).  Hence both comparisons are regular and invertible
at \(z=0\), as required by the marker interface.

---

# Module 6. Faithful center pullback

Iritani's raw center Novikov map can identify distinct curve classes.  The
following adapter repairs it without recursively composing asymptotic
completions.

Let \(i:Z\hookrightarrow Y\) be a smooth projective center.  After numerical
Novikov reduction, the raw map has the form
\[
Q_Z^d\longmapsto
c_d:=Q^{i_*d}\mathfrak q^{-\rho_Z\cdot d/(r-1)}.
\tag{6.1}
\]
Choose divisor classes \(D_1,\ldots,D_\rho\) separating \(N_1(Z)\) and put
\[
\ell_d(s)=\sum_i(D_i\cdot d)s_i.
\]

## Lemma 6.1 — finite-to-one character twisting is faithful

The reduced map
\[
Q_Z^d e^{\ell_d(s)}
\longmapsto
c_d e^{\ell_d(s)}
\tag{6.2}
\]
is injective on the numerical reduced completed coefficient algebra.

### Proof

First, every fibre of \(d\mapsto c_d\) is finite.  Equality \(c_d=c_{d'}\)
implies \(i_*d=i_*d'\).  For an ample divisor \(H\) on \(Y\), all elements of
one fibre have the same \(i^*H\)-degree.  The slice
\[
\{x\in\overline{NE}(Z):(i^*H)\cdot x\le M\}
\]
is compact and contains finitely many numerical lattice points.

Now group a series in the kernel by its target monomial \(c\).  Distinct
Laurent-Novikov monomials are linearly independent, and the finite-fibre
statement makes every such coefficient a finite sum
\[
\sum_{d:c_d=c}a_de^{\ell_d(s)}=0,
\tag{6.3}
\]
where the \(a_d\) are independent of the divisor variables.  Choose
\(v\in\mathbf C^\rho\) such that the finitely many numbers
\(\ell_d(v)\) are distinct.  Restrict to \(s=uv\) and differentiate at
\(u=0\) through one less than the fibre size.  The resulting Vandermonde
matrix has nonzero complex determinant, hence is invertible over the remaining
coefficient ring.  Every \(a_d\) vanishes. ∎

Iritani Remark 2.3 says that the intrinsic QDM uses divisor and Novikov
variables only in the combinations \(Q^de^{\ell_d(s)}\).  Remark 5.6 applies
the same reduction to each center QDM.  Theorem 5.18(7) makes the bulk systems
of all summands independent, so every center copy retains its own divisor and
unit coordinates.  Lemma 6.1 therefore identifies each center summand with a
faithful scalar extension and formal reparametrization of the intrinsic
generic numerical reduced QDM of \(Z\).

---

# Module 7. The categorical compiler

Fix a sufficiently large algebraically closed universal field \(\Omega\) and
base-change every finite generic block under discussion to \(\Omega\).  This
is only a size and bookkeeping convention; Definition 2.1 makes every marker
insensitive to the choice.

Let
\[
\Pi=\pi_0\bigl(\mathsf{QBlock}^{\mathrm{ev}}\bigr)
\]
be the set of regular-isomorphism and generic-base-change classes of even
blocks.  Let
\[
\mathbf N^{(\Pi)}
\]
be the free commutative monoid on \(\Pi\); its elements are finite multisets of
block classes.

## Definition 7.1 — universal block spectrum

Define
\[
\mathcal B^{\mathrm{ev}}(Y)
=\sum_{B\in\operatorname{Blocks}^{\mathrm{ev}}(Y)}[B]
\in\mathbf N^{(\Pi)}.
\tag{7.1}
\]

Every lawful marker package determines a unique monoid homomorphism
\[
W_{\mathcal M}:\mathbf N^{(\Pi)}\longrightarrow A,
\qquad
[B]\longmapsto w_{\mathcal M}(B).
\tag{7.2}
\]
Then
\[
I_{\mathcal M}=W_{\mathcal M}\circ\mathcal B^{\mathrm{ev}}.
\tag{7.3}
\]

This is the categorical content of the software interface: geometry compiles
to a universal multiset of block objects, and the caller chooses only the final
fold.

## Diagram 7.2 — marker-independent compiler pipeline

\[
\boxed{
\begin{array}{ccccc}
\mathsf{Geo}_{\mathrm{QDM}}
&\xrightarrow{\quad\mathcal B^{\mathrm{ev}}\quad}&
\mathbf N^{(\pi_0\mathsf{QBlock}^{\mathrm{ev}})}
&\xrightarrow{\quad W_{\mathcal M}\quad}& A
\\[4pt]
Y&\longmapsto&\displaystyle\sum_{B\subset\operatorname{QDM}^{\mathrm{ev}}(Y)}[B]
&\longmapsto&I_{\mathcal M}(Y).
\end{array}}
\tag{7.4}
\]

The left arrow contains all QDM geometry and is independent of the marker.
Changing which information is retained means replacing only
\(W_{\mathcal M}\).

## 7.3 Categorical lift before decategorification

Let
\[
\operatorname{Sym}(\mathsf{QBlock}^{\mathrm{ev}})
\]
be the free symmetric-monoidal category on the block groupoid.  Its objects are
finite formal direct sums of blocks; its morphisms are generated by block
isomorphisms and permutations.  Direct sum is the tensor product and the empty
sum is the tensor unit.  Its set of connected components is
\[
\pi_0\operatorname{Sym}(\mathsf{QBlock}^{\mathrm{ev}})
\cong\mathbf N^{(\Pi)}.
\tag{7.5}
\]

Regard a commutative monoid \(A\) as a discrete symmetric-monoidal category
\(\underline A\): its objects are elements of \(A\), its only morphisms are
identities, and its tensor product is addition.  A lawful marker determines a
symmetric-monoidal functor
\[
\mathscr W_{\mathcal M}:
\operatorname{Sym}(\mathsf{QBlock}^{\mathrm{ev}})
\longrightarrow\underline A,
\tag{7.6}
\]
and \(W_{\mathcal M}\) is its map on \(\pi_0\).

The comparison theorems provide isomorphisms in the source category:
\[
\mathscr B(\mathbf P_Y(V))
\cong\mathscr B(Y)^{\otimes r},
\tag{7.7}
\]
\[
\mathscr B(\operatorname{Bl}_Z Y)
\cong
\mathscr B(Y)\otimes
\mathscr B(Z)^{\otimes(r-1)}.
\tag{7.8}
\]
The monoid ledgers (8.2) and (8.6) are their decategorifications.

For a dimension cutoff \(d\), form the symmetric-monoidal quotient
\[
\operatorname{Sym}(\mathsf{QBlock}^{\mathrm{ev}})_{>d}
\tag{7.9}
\]
that freely identifies every object \(\mathscr B(Z)\), \(\dim Z\le d\), with
the tensor unit.  A center-vanishing marker functor factors through this
quotient.  Its \(\pi_0\) is exactly the congruence quotient
\(\mathcal L_{>d}\) of Definition 9.3.

Thus the category-theoretic proof has three layers:
\[
\boxed{
\mathsf{Geometry}
\xrightarrow{\ \mathscr B\ }
\operatorname{Sym}(\mathsf{QBlock}^{\mathrm{ev}})_{>2}
\xrightarrow{\ \mathscr W_{\mathcal M}\ }
\underline A,}
\tag{7.10}
\]
and the numerical contradiction is obtained only after applying \(\pi_0\).

## Marker coarsening as postcomposition

If \(F:\mathcal M\to\mathcal N\) is a forgetful morphism, the triangle
\[
\begin{array}{ccc}
\mathbf N^{(\Pi)}&\xrightarrow{W_{\mathcal M}}&A\\
&\searrow_{W_{\mathcal N}}&\downarrow F_*\\
&&B
\end{array}
\tag{7.11}
\]
commutes.  Thus exact signatures, multisets, counts, and existence markers are
different consumers of the same universal block spectrum.

## Geometric presentation

For purposes of this proof, \(\mathsf{Geo}_{\mathrm{QDM}}\) can be regarded as
the symmetric-monoidal category presented by:

- smooth projective varieties as generators;
- direct sum as the monoidal operation on QDM outputs;
- regular QDM comparison isomorphisms;
- projective-bundle adapters
  \[
  \mathbf P_Y(V)\rightsquigarrow Y^{\oplus r};
  \]
- blowup adapters
  \[
  \operatorname{Bl}_Z Y\rightsquigarrow
  Y\oplus Z^{\oplus(r-1)};
  \]
- the coefficient-spine, parity, and independent-coordinate laws from Modules
  3, 5, and 6.

The arrows \(\rightsquigarrow\) are comparison correspondences, not ordinary
morphisms of varieties.  Their images under \(\mathcal B^{\mathrm{ev}}\) are
honest equalities in the free commutative monoid.

---

# Module 8. Universal QDM ledgers

## Theorem 8.1 — projective-bundle ledger

Let \(V\to Y\) have rank \(r\), after an allowed line-bundle twist making
\(V^\vee\) globally generated.  For every lawful marker package,
\[
\boxed{
I_{\mathcal M}(\mathbf P_Y(V))=rI_{\mathcal M}(Y).
}
\tag{8.1}
\]
At the universal level,
\[
\mathcal B^{\mathrm{ev}}(\mathbf P_Y(V))
=r\mathcal B^{\mathrm{ev}}(Y).
\tag{8.2}
\]

### Proof

Iritani--Koto Theorem 5.1 gives, over the Laurent arm of the common coefficient
spine,
\[
\operatorname{QDM}(\mathbf P_Y(V))_{\mathrm{loc}}
\cong
\bigoplus_{j=0}^{r-1}\varsigma_j^*
\operatorname{QDM}(Y)_{\mathrm{ext,loc}}.
\tag{8.3}
\]
Their base Novikov map
\[
Q_Y^d\longmapsto q^{-c_1(V)\cdot d/r}Q^d
\tag{8.4}
\]
is an embedding.  Module 3 compares the projective-bundle side with its
intrinsic generic QDM through \(R_0\), not by mapping opposite completions.
Theorem 5.1(5) gives an invertible combined bulk Jacobian, so all target unit
coordinates are independent.  Modules 5 and 3 now identify the block multiset
with \(r\) copies of the intrinsic block multiset of \(Y\).  Apply
\(W_{\mathcal M}\). ∎

## Theorem 8.2 — blowup ledger

Let \(Z\subset Y\) be smooth of codimension \(r\ge2\).  For every lawful marker
package,
\[
\boxed{
I_{\mathcal M}(\operatorname{Bl}_Z Y)
=I_{\mathcal M}(Y)+(r-1)I_{\mathcal M}(Z).
}
\tag{8.5}
\]
Universally,
\[
\mathcal B^{\mathrm{ev}}(\operatorname{Bl}_Z Y)
=\mathcal B^{\mathrm{ev}}(Y)
 +(r-1)\mathcal B^{\mathrm{ev}}(Z).
\tag{8.6}
\]

### Proof

Iritani Theorem 5.18 supplies
\[
\operatorname{QDM}(\operatorname{Bl}_Z Y)^{\mathrm{La}}
\cong
\tau^*\operatorname{QDM}(Y)^{\mathrm{La}}
\oplus
\bigoplus_{j=0}^{r-2}\varsigma_j^*
\operatorname{QDM}(Z)^{\mathrm{La}}.
\tag{8.7}
\]
The blowup-side coefficient map (5.38) is an embedding.  Module 6 repairs the
possibly noninjective raw center map on the intrinsic numerical reduced QDM.
Theorem 5.18(7) gives independent bulk coordinates, hence independent unit
coordinates.  Module 5 makes all summand spectra generically disjoint and
transports every block through a regular parity-preserving gauge.  This proves
(8.6), and (8.5) follows by applying the chosen fold. ∎

## Corollary 8.3 — no completion recursion

Equations (8.1) and (8.5) are identities of intrinsic generic numerical
reduced-QDM invariants.  If a center is later analyzed by another comparison
theorem, that theorem is applied afresh to the center's intrinsic coefficient
spine.  No Laurent completion is pushed through another Laurent completion.

---

# Module 9. Weak-factorization conservation law

## Definition 9.1 — vanishing range

A marker package has **center-vanishing range \(\le d\)** if
\[
I_{\mathcal M}(Z)=0
\]
for every smooth projective \(Z\) with \(\dim Z\le d\).

## Theorem 9.2 — birational conservation

Let \(n\ge2\).  If \(\mathcal M\) has center-vanishing range \(\le n-2\), then
\(I_{\mathcal M}\) is a birational invariant of smooth projective
\(n\)-folds.

### Proof

Weak Factorization expresses a birational map as a chain of blowups and
blowdowns with smooth centers.  Blowup along a Cartier divisor is an
isomorphism, so every nontrivial center in an \(n\)-fold has dimension at most
\(n-2\).  For each arrow, Theorem 8.2 and center vanishing give
\[
I_{\mathcal M}(\operatorname{Bl}_Z Y)=I_{\mathcal M}(Y).
\]
The same equality works in the reverse orientation.  Compose along the
factorization.  A disconnected smooth center may be blown up componentwise;
the same argument applies. ∎

## Definition 9.3 — the center quotient

Let \(\mathcal L=\mathbf N^{(\Pi)}\) be the universal block ledger.  Define
\(\mathcal L_{>d}\) to be the quotient of \(\mathcal L\) by the smallest
commutative-monoid congruence containing
\[
x+\mathcal B^{\mathrm{ev}}(Z)\sim x
\qquad
(\dim Z\le d)
\tag{9.1}
\]
for every \(x\in\mathcal L\).  Thus all block spectra carried by possible
centers of dimension at most \(d\) are killed universally.

If \(\mathcal M\) has center-vanishing range \(\le d\), then
\(W_{\mathcal M}\) factors uniquely through \(\mathcal L_{>d}\).  The blowup
ledger shows that the composite
\[
\mathsf{SPVar}_n
\xrightarrow{\mathcal B^{\mathrm{ev}}}
\mathcal L
\longrightarrow
\mathcal L_{>n-2}
\tag{9.2}
\]
is constant on weak-factorization arrows.

## Diagram 9.4 — descent through birational localization

For a marker with center-vanishing range \(\le2\), the fourfold invariant
descends through the localization that inverts weak-factorization arrows:

\[
\boxed{
\begin{array}{ccccccc}
\mathsf{SPVar}_4
&\xrightarrow{\quad\mathcal B^{\mathrm{ev}}\quad}&
\mathcal L
&\longrightarrow&\mathcal L_{>2}
&\xrightarrow{\quad\overline W_{\mathcal M}\quad}&A
\\[5pt]
\Big\downarrow\scriptstyle{\text{birational localization}}
&&\Big\downarrow\scriptstyle{\text{center quotient}}
&&\Big\Vert
&&\Big\Vert
\\[5pt]
\mathsf{Bir}_4
&\xrightarrow{\quad\overline{\mathcal B}\quad}&
\mathcal L_{>2}
&=&\mathcal L_{>2}
&\xrightarrow{\quad\overline W_{\mathcal M}\quad}&A.
\end{array}}
\tag{9.3}
\]

The mathematical work is exactly the assertion that every relation introduced
by the left vertical arrow is sent to an equality on the right.

---

# Module 10. The minimal cubic marker

Take \(A=\mathbf N\).  Use the observer from Example 4.5, retain exactly the
triple
\[
(r,n,s)=(2,1,1),
\]
and emit \(1\).  Denote this lawful package by \(\mathcal C\).  Explicitly,
\[
w_{\mathcal C}(B)=
\begin{cases}
1,&\operatorname{rank}B=2,\quad N_B\ne0,\quad
\delta^\sharp(B)\ne0,\\
0,&\text{otherwise}.
\end{cases}
\tag{10.1}
\]
No odd rank and no exact nonzero value of \(\delta^\sharp\) is retained.

We next compute \(I_{\mathcal C}(X)\) for a smooth cubic threefold.

## 10.1 Beauville's small quantum algebra

Let \(P\) be the hyperplane class and let \(q\) be the Novikov monomial of a
line.  Beauville's formulas give
\[
P\star P=P^2+6q,
\tag{10.2}
\]
\[
P\star P^2=P^3+15qP,
\tag{10.3}
\]
\[
P\star P^3=6qP^2+36q^2.
\tag{10.4}
\]
Indeed his complete-intersection constants are
\[
\mu=27,\qquad \ell_0=6,\qquad \ell_1=15,
\]
and restoring \(q\) by degree gives these identities.

In the classical basis \((1,P,P^2,P^3)\), multiplication by \(P\) is
\[
M_P=
\begin{pmatrix}
0&6q&0&36q^2\\
1&0&15q&0\\
0&1&0&6q\\
0&0&1&0
\end{pmatrix}.
\tag{10.5}
\]
Since \(c_1(X)=2P\), the small Euler operator is \(K=2M_P\), with
\[
\chi_K(T)=m_K(T)=T^2(T^2-108q).
\tag{10.6}
\]
Thus, after adjoining \(r=(3q)^{1/2}\), its even spectrum has the pattern
\[
1\mid1\mid2,
\]
with simple eigenvalues \(6r,-6r\) and one nonzero \(2\times2\) nilpotent
Jordan block at eigenvalue zero.

## 10.2 Formal persistence of the rank-two block

Work over \(B=K[[t_1,\ldots,t_4]]\) at the small point.  Hensel lifting of the
three pairwise coprime closed-point factors gives projectors of ranks
\(1,1,2\).  On the rank-two factor, set
\[
U_0=PUP,
\qquad
\lambda=\tfrac12\operatorname{tr}U_0,
\qquad
N=U_0-\lambda I.
\tag{10.7}
\]
At the closed point, one off-diagonal entry of \(N\) is \(2\), hence remains a
unit in \(B\).

Flatness of (1.1)--(1.2) gives
\[
[U,C_a]=0,
\qquad
\partial_aU=C_a+[C_a,\mu].
\tag{10.8}
\]
The operators \(C_a\) commute with the Henselian projector.  If \(D_a\) is the
projected trivial derivative and \(C_{a,0}=PC_aP\), then the unit entry of
\(N\) implies
\[
\operatorname{Cent}(U_0)=BI\oplus BN.
\]
Write
\[
C_{a,0}=p_aI+q_aN.
\]
Compressing (10.8), taking traces, and removing the scalar part yields
\[
D_aN=q_aN+q_a[N,\mu_0].
\tag{10.9}
\]
For \(d=\det N\), the identities
\[
\operatorname{adj}(N)=-N,
\qquad N^2=-dI
\]
and cyclicity of trace give
\[
\begin{aligned}
\partial_a d
&=\operatorname{tr}(\operatorname{adj}(N)D_aN)\\
&=-q_a\operatorname{tr}(N^2)
  -q_a\operatorname{tr}(N[N,\mu_0])\\
&=2q_ad,
\end{aligned}
\]
because the commutator trace vanishes.  Thus
\[
\partial_a d=2q_ad.
\tag{10.10}
\]

## Lemma 10.1 — formal differential-ideal uniqueness

Let \(f\in K[[t_1,\ldots,t_m]]\), with \(\operatorname{char}K=0\).  If
\[
f(0)=0,
\qquad
\partial_if\in(f)\quad\text{for every }i,
\]
then \(f=0\).

### Proof

If \(f\ne0\), let \(f_d\) be its lowest nonzero homogeneous part, where
\(d\ge1\).  Choose \(t_i\) occurring in \(f_d\).  Then
\(\partial_if\) has a nonzero term of degree \(d-1\), while every element of
\((f)\) has order at least \(d\), a contradiction. ∎

Apply Lemma 10.1 to (10.10).  Then \(\det N=0\) identically.  The unit entry
keeps \(N\ne0\).  Hence the generic rank-two factor remains a single nonzero
nilpotent Jordan block with one eigenvalue.

## 10.3 Minimal residue calculation

The grading term in the horizontal system is
\[
G=-\mu
=\tfrac12\operatorname{diag}(3,1,-1,-3).
\]
With \(r^2=3q\), use the constant basis
\[
C=
\begin{pmatrix}
6r^3&-6r^3&0&-7r^2\\
7r^2&7r^2&-2r^2&0\\
3r&-3r&0&1\\
1&1&1&0
\end{pmatrix},
\qquad
\det C=-486r^5.
\tag{10.11}
\]
Direct multiplication gives
\[
C^{-1}KC
=\operatorname{diag}(6r,-6r,J_0),
\qquad
J_0=
\begin{pmatrix}0&2\\0&0\end{pmatrix}.
\tag{10.12}
\]

For \(D=C^{-1}GC\), only the following blocks are needed:
\[
D_{00}=
\begin{pmatrix}-19/18&0\\0&19/18\end{pmatrix},
\tag{10.13}
\]
\[
D_{0s}=
\begin{pmatrix}
-14/9&-14/9\\
-4r/3&4r/3
\end{pmatrix}.
\tag{10.14}
\]
The opposite coupling block is
\[
D_{s0}=
\begin{pmatrix}
-2/9&-7/(27r)\\
-2/9&7/(27r)
\end{pmatrix}.
\tag{10.15}
\]
The simple-to-zero part of the first normalized gauge is
\[
(A_1)_{s0}=
\begin{pmatrix}
1/(27r)&1/(18r^2)\\
-1/(27r)&1/(18r^2)
\end{pmatrix}.
\tag{10.16}
\]
It is checked directly from
\[
J_s(A_1)_{s0}-(A_1)_{s0}J_0=-D_{s0}.
\]

For a normalized block-off-diagonal gauge, the diagonal second-order
coefficient is
\[
\bigl([D,A_1]-A_1[J,A_1]-A_1\bigr)_{\mathrm{diag}}
=\bigl(D_{\mathrm{off}}A_1\bigr)_{\mathrm{diag}},
\]
where \([J,A_1]=-D_{\mathrm{off}}\) was used.  Thus on the zero block
\[
(E_0)_{21}
=-\frac{4r}{3}\frac1{27r}
 +\frac{4r}{3}\left(-\frac1{27r}\right)
=-\frac8{81}.
\tag{10.17}
\]
No other second-order entry is needed.

Under the shear \(S=\operatorname{diag}(1,z)\), the four constant
contributions are \(2E_{12}\) from \(z^{-1}J_0\), \(D_{00}\),
\(-\frac8{81}E_{21}\) from \(zE_0\), and
\(-\operatorname{diag}(0,1)\) from the derivative of \(S\).  Therefore the
modified residue is
\[
R_X=
\begin{pmatrix}
-19/18&2\\
-8/81&1/18
\end{pmatrix}.
\tag{10.18}
\]
Its discriminant is
\[
(\operatorname{tr}R_X)^2-4\det R_X
=1-4\cdot\frac5{36}
=\frac49\ne0.
\tag{10.19}
\]
The package \(\mathcal C\) forgets the value \(4/9\) after checking that it is
nonzero.

The two simple blocks contribute zero and the repeated block contributes one.
Hence
\[
\boxed{I_{\mathcal C}(X)=1.}
\tag{10.20}
\]
By Theorem 8.1 applied to \(\mathcal O_X^{\oplus2}\),
\[
\boxed{I_{\mathcal C}(X\times\mathbf P^1)=2.}
\tag{10.21}
\]

---

# Module 11. Low-dimensional vanishing for the cubic marker

We prove
\[
I_{\mathcal C}(Z)=0
\qquad(\dim Z\le2).
\tag{11.1}
\]

## 11.1 Points

A point has one even block of rank one, so its value is zero.

## 11.2 Curves

For \(\mathbf P^1\), small quantum multiplication satisfies
\[
p\star p=Qe^{t_p}.
\]
The centered Euler operator \(2p\star\) has two distinct generic eigenvalues.
Both blocks have rank one.

Now let \(C\) have genus \(g\ge1\).  There is no nonconstant genus-zero stable
map to \(C\).  For degree zero and more than three primary insertions, the
positive-dimensional \(\overline M_{0,n}\)-factor receives no class and the
invariant vanishes.  Thus the even big quantum product is classical.

With \(p\in H^2(C)\), \(\int_Cp=1\), put \(a=2-2g\).  After removing the unit
coordinate, the even Euler nilpotent and grading terms on \((1,p)\) are
\[
N=aE_{21},
\qquad
-\mu=\operatorname{diag}(1/2,-1/2).
\tag{11.2}
\]
If \(g=1\), then \(N=0\).  If \(g>1\), shear with
\(S=\operatorname{diag}(z,1)\).  The modified residue is
\[
R_C=aE_{21}-\tfrac12I,
\tag{11.3}
\]
whose discriminant is zero.  Hence every curve has \(I_{\mathcal C}=0\).

## 11.3 Surfaces with nef canonical class

Let \(S\) be a smooth projective surface with \(K_S\) nef.  Remove the scalar
unit coordinate from Euler multiplication and call the result \(N_S\).
The non-scalar Euler terms have ordinary degree at least two.  For a quantum
product contribution with input degree \(b\), Euler-term degree \(a\), curve
class \(d\), and nonunit even bulk insertion degrees \(e_\nu\), the dimension
axiom gives output degree
\[
\deg\xi
=a+b-2c_1(S)\cdot d+\sum_\nu(e_\nu-2).
\tag{11.4}
\]
Here \(a\ge2\), \(e_\nu\ge2\), and
\(c_1(S)\cdot d=-K_S\cdot d\le0\).  Therefore
\[
\deg\xi\ge b+2.
\]
Thus \(N_S\) strictly raises ordinary degree and \(N_S^3=0\).  There is one
even spectral block, the whole even cohomology, of rank
\[
b_0+b_2+b_4\ge3.
\]
It is not retained by \(\mathcal C\).

## 11.4 Remaining surfaces

A minimal smooth projective surface with non-nef canonical class is either
\(\mathbf P^2\) or geometrically ruled.

For \(\mathbf P^2\), the small relation \(H^{\star3}=Q\) makes multiplication
by \(E=3H\) have three distinct eigenvalues over the generic field.  Its
generic Euler discriminant is therefore nonzero, so all generic blocks have
rank one.

A geometrically ruled surface is \(\mathbf P_C(V)\) for a rank-two bundle on a
curve.  After a line-bundle twist, Iritani--Koto applies.  Theorem 8.1 and the
curve calculation give
\[
I_{\mathcal C}(\mathbf P_C(V))=2I_{\mathcal C}(C)=0.
\]

Every nonminimal smooth projective surface is obtained from a minimal one by
point blowups.  Theorem 8.2 and the point calculation show that these do not
change \(I_{\mathcal C}\).  This proves (11.1).

---

# Module 12. The endpoint \(\mathbf P^4\)

On the small quantum locus,
\[
QH^\bullet(\mathbf P^4)
=\Lambda[H]/(H^5-Q).
\]
At nonzero \(Q\), multiplication by \(E=5H\) has five distinct eigenvalues
over an algebraic closure.  Therefore its Euler discriminant is nonzero at one
point of the even big base and is not the zero formal function.  At the generic
point all Euler blocks have rank one.  Hence
\[
\boxed{I_{\mathcal C}(\mathbf P^4)=0.}
\tag{12.1}
\]

---

# Module 13. Final proof and its category diagram

Let
\[
W=X\times\mathbf P^1.
\]
Equation (10.21) gives \(I_{\mathcal C}(W)=2\).  Module 11 gives center
vanishing through dimension two, so Theorem 9.2 makes \(I_{\mathcal C}\) a
birational invariant of smooth projective fourfolds.

If \(W\) were rational, it would be birational to \(\mathbf P^4\).  Therefore
\[
2=I_{\mathcal C}(W)
=I_{\mathcal C}(\mathbf P^4)=0,
\]
a contradiction.

Thus
\[
\boxed{X\times\mathbf P^1\text{ is irrational}.}
\]

The entire proof is summarized by the commutative diagram that rationality
would force:

\[
\boxed{
\begin{array}{ccccccc}
X\times\mathbf P^1
&\xrightarrow{\mathrm{Iritani\text{-}Koto}}&
\mathcal B^{\mathrm{ev}}(X)+\mathcal B^{\mathrm{ev}}(X)
&\longrightarrow&[2\mathcal B^{\mathrm{ev}}(X)]\in\mathcal L_{>2}
&\xrightarrow{W_{\mathcal C}}&2
\\[6pt]
\Big\downarrow\scriptstyle{\text{weak factorization, if rational}}
&&
&&\Big\downarrow\scriptstyle{=\text{ in }\mathcal L_{>2}}
&&\Big\downarrow\scriptstyle{=}
\\[6pt]
\mathbf P^4
&\xrightarrow{\text{small }QH}&
\displaystyle\sum_{j=1}^{5}[\text{rank-one block}_j]
&\longrightarrow&
\left[\displaystyle\sum_{j=1}^{5}\text{rank-one}_j\right]
&\xrightarrow{W_{\mathcal C}}&0.
\end{array}}
\tag{13.1}
\]

Weak factorization would create the middle equality because every correction
term is the block spectrum of a surface, curve, or point and hence vanishes in
\(\mathcal L_{>2}\).  Applying the marker functor would then make the right
vertical equality hold, which is impossible.

---

# Module 14. Configuration menu and optional enrichments

The proof above used a counting consumer because it makes the contradiction
read \(2=0\).  The interface permits strictly less or substantially more
retention.

| Configuration | Observation | Selector | Value monoid | Information retained |
| --- | --- | --- | --- | --- |
| `CubicExists` | \((r,[N\ne0],[\delta^\sharp\ne0])\) | equals \((2,1,1)\) | Boolean `or` | existence only |
| `CubicCount` | same | same | \((\mathbf N,+)\) | multiplicity |
| `ResidueProfile` | rank, Jordan type, \(\chi_R\) | caller supplied | free multiset | exact selected residue profiles |
| `ParityProfile` | even/odd ranks plus residue profile | caller supplied | free multiset | parity-enriched signatures |
| `Universal` | full block class | keep all | \(\mathbf N^{(\Pi)}\) | complete generic even-block multiset |

## 14.1 Boolean existence: the smallest sufficient consumer

Let
\[
\mathbf N\longrightarrow(\{0,1\},\lor),
\qquad
n\longmapsto[n>0].
\tag{14.1}
\]
This is a commutative-monoid homomorphism.  Postcomposing \(\mathcal C\) gives
a Boolean package \(\mathcal C_{\exists}\).  Then
\[
I_{\mathcal C_{\exists}}(X\times\mathbf P^1)=\mathrm{true},
\qquad
I_{\mathcal C_{\exists}}(\mathbf P^4)=\mathrm{false}.
\]
Thus existence alone proves irrationality.  The multiplicity two is optional.

## 14.2 Exact signature multiset

One may instead observe
\[
(\operatorname{rank},\operatorname{Jordan}(N),\chi_R(T))
\]
and take the free commutative monoid on such observations.  This retains the
entire distribution of rank-two modified-residue characteristic polynomials.
The cubic observer is obtained by the forgetful predicate
\[
\operatorname{rank}=2,\qquad N\ne0,\qquad
\operatorname{disc}\chi_R\ne0.
\]

## 14.3 Parity-enriched blocks

If odd ranks are wanted for another application, replace the even block
groupoid by the parity-graded block groupoid
\(\mathsf{QBlock}^{\mathrm{gr}}\).  This enrichment is available because the
even quantum algebra acts unitally on total cohomology.

### Lemma 14.1 — spectrum transfer

Multiplication by an even element has the same set of eigenvalues on the even
quantum algebra and on total cohomology.

### Proof

After a splitting-field extension, decompose the even Artinian algebra by its
generalized-eigenvalue idempotents:
\[
A=\bigoplus_\lambda A_\lambda,
\qquad 1=\sum_\lambda e_\lambda.
\]
Then
\[
H^\bullet(Y)=\bigoplus_\lambda e_\lambda H^\bullet(Y).
\]
Every summand is nonzero because \(e_\lambda=e_\lambda\cdot1\).  On
\(A_\lambda\), \(U-\lambda\) is nilpotent, so it acts nilpotently on every
finite \(A_\lambda\)-module.  There are no additional total-cohomology
eigenvalues. ∎

There is a forgetful functor
\[
\mathsf{QBlock}^{\mathrm{gr}}
\longrightarrow
\mathsf{QBlock}^{\mathrm{ev}}.
\tag{14.2}
\]
A parity-enriched observer may retain
\((r_{\bar0},r_{\bar1})\); the earlier \((2,10)\) cubic signature is one such
configuration.  The proof in Modules 10--13 factors through the forgetful
functor and deliberately discards \(r_{\bar1}\).

## 14.4 Formal-monodromy observer

One may emit the conjugacy class, characteristic polynomial, or eigenvalue
ratio of formal monodromy after the canonical shear.  This is lawful under
meromorphic connection isomorphism and is independent of the choice of
regular lattice.  It is not used here because proving its constancy invokes an
isomonodromy statement, whereas Lemma 4.4 gives discriminant constancy
directly from coefficients of flatness.

## 14.5 Full block observer

At the maximal setting, take \(O=\Pi\), keep every block, and emit its basis
vector in \(\mathbf N^{(\Pi)}\).  Then the marker invariant is exactly the
universal spectrum \(\mathcal B^{\mathrm{ev}}\).  Every other even-block
configuration in this packet is a postcomposition of this maximal observer.

The dependency direction is therefore
\[
\boxed{
\text{full block multiset}
\longrightarrow
\text{exact signature multiset}
\longrightarrow
\text{qualitative count}
\longrightarrow
\text{Boolean existence}.}
\tag{14.3}
\]

---

# Module 15. Hostile audit

## H1. Does the marker interface assume additivity?

No.  Additivity occurs in the free block monoid before a marker is chosen.
Every marker consumer is required only to be a commutative-monoid
homomorphism.  Noncancellative consumers such as Boolean `or` are allowed.

## H2. Can spectra from different comparison summands collide?

Not generically.  The combined bulk Jacobians in the two source theorems are
invertible.  Their even-even blocks remain invertible on the even slice, so
the summands have independent unit coordinates.  Lemma 5.1 separates their
Euler spectra by a nonzero resultant.

## H3. Is an opposite Laurent completion treated as a localization?

No.  Module 3 uses the common spine
\[
R_{\mathrm{full}}\leftarrow R_0\rightarrow R_\infty
\]
and compares algebraic generic data over field extensions of
\(\operatorname{Frac}(R_0)\).  No map between the outer completions is used.

## H4. Can the raw center specialization kill a block?

Not after numerical reduction and divisor tagging.  Lemma 6.1 proves the
reduced coefficient map injective.  The proof uses both finite fibres and
independent divisor characters; neither alone is sufficient.

## H5. Are successive Iritani comparisons composed?

No.  Every ledger equation is intrinsic.  A later center calculation starts
again from that center's numerical reduced QDM and its own coefficient spine.

## H6. Can a regular comparison change the modified residue?

It conjugates it.  The intrinsic line \(L=\operatorname{im}N\) and the
modified lattice are transported by the constant term of the regular gauge.
Negative powers of \(z\), which could shift exponents, are excluded by the
source coefficient rings.

## H7. Does the cubic repeated eigenvalue split on the big base?

No.  Equation (10.10) places every partial derivative of \(\det N\) in its own
principal ideal.  Lemma 10.1 forces \(\det N=0\), while a unit matrix entry
forces \(N\ne0\).

## H8. Is algebra semisimplicity confused with simple Euler spectrum?

No.  For \(\mathbf P^2\) and \(\mathbf P^4\), the proof checks directly that
multiplication by the Euler element has distinct eigenvalues at a small point.
This makes the Euler discriminant, not merely the algebra discriminant,
generically nonzero.

## H9. Does low-dimensional vanishing use the discarded odd rank?

No.  Curves are separated by \(N=0\) or \(\delta^\sharp=0\); nef-canonical
surfaces have even rank at least three; the remaining surfaces reduce to
rank-one blocks or curves.  The number \(b_3(X)=10\) never enters.

## H10. Is the categorical diagram claiming a false equality of raw spectra?

No.  Raw block spectra may differ by center summands.  Equality occurs only in
the center quotient \(\mathcal L_{>2}\), after which any center-vanishing
marker functor may be applied.

---

# Module 16. Source boundary

The proof uses the following external inputs.

1. Beauville, *Quantum cohomology of complete intersections*,
   arXiv:alg-geom/9501008, main theorem and formulas (2.1)--(2.3), for the
   cubic small quantum ring.
2. Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3, Remark 2.3,
   Remark 5.6, equations (5.15) and (5.38)--(5.43), and Theorem 5.18.
3. Iritani--Koto, *Quantum cohomology of projective bundles*,
   arXiv:2307.03696v4, equation (5.2), Theorem 5.1, and Remark 5.3.
4. Abramovich--Karu--Matsuki--Włodarczyk, arXiv:math/9904135, Theorem 0.1.1,
   including the projective conclusion.
5. The standard classification of minimal smooth projective surfaces with
   non-nef canonical class.

The proof does not use Cai, KKPY/HYZZ reconstruction, Hodge atoms,
David--Hertling, or a recursive comparison of asymptotic completions.

The exact identities in §10.3 were replayed in rational symbolic arithmetic by
`notes/cubic-threefolds-tasks/c924-finite-cubic-check.py`; its checked output is
`notes/cubic-threefolds-tasks/c924-finite-cubic-check.json`.  The displayed
matrix calculation remains the mathematical proof.

---

# Final modular statement

The proof is an instance of the following schema.

## Theorem 16.1 — parameterized fourfold obstruction

Let \(\mathcal M\) be any lawful QDM marker package with values in a
commutative monoid \(A\).  Suppose:

1. \(I_{\mathcal M}(Z)=0\) for every smooth projective \(Z\) of dimension at
   most two;
2. the projective-bundle and blowup comparison adapters satisfy the
   coefficient, parity, regularity, and independent-unit contracts of Modules
   3--6; and
3. two smooth projective fourfolds \(Y_0,Y_1\) have
   \(I_{\mathcal M}(Y_0)\ne I_{\mathcal M}(Y_1)\).

Then \(Y_0\) and \(Y_1\) are not birational.

For the cubic marker, take
\[
Y_0=X\times\mathbf P^1,
\qquad
Y_1=\mathbf P^4.
\]
The values are \(2\) and \(0\) for the counting consumer, or `true` and
`false` for the Boolean consumer.  Either configuration proves the theorem.

---

# Exploration frontier

This packet deliberately remains open under C925.  The next design questions
are:

1. **Proof-carrying record or type class?**  The mathematical object is more
   faithfully a record containing `observe`, `select`, `emit`, and proofs of
   the two laws.  A Haskell implementation could expose a type class for
   ergonomic instance selection while storing the laws in a refinement layer.
2. **Free monoidal category or only its decategorification?**  The
   \(\operatorname{Sym}(\mathsf{QBlock})\) formulation records actual block
   isomorphisms; \(\mathbf N^{(\Pi)}\) is smaller and sufficient for the
   present theorem.  Future extension data may require staying categorified.
3. **Monoid quotient or group completion?**  The center congruence uses no
   subtraction and works for Boolean consumers.  Passing prematurely to a
   Grothendieck group would add cancellation that the proof neither needs nor
   geometrically justifies.
4. **Which enrichments are lawful under the available comparison maps?**
   Even rank, nilpotent Jordan type, and modified residue are proved lawful.
   Stokes data, integral structures, Gamma classes, and extension classes
   would require stronger adapters.
5. **Can the cubic calculation become conceptual?**  The current packet has
   compressed the finite computation to one cross-term, but the appearance of
   the nonzero sheared-residue discriminant is still computed rather than
   explained structurally.
6. **Can the geometric source category be made canonical?**  Here it is a
   category presented by comparison correspondences.  A more intrinsic
   version might use a bicategory of coefficient spines and regular QDM
   correspondences, with the Iritani maps as invertible 1-cells.

None of these questions blocks the proof in Modules 0--16.  They control how
far the modular interface can be reused beyond this one-stabilization
application.
