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

The cubic proof instantiates this interface with the following compact
sufficient observation (no minimality order on all possible observations is
claimed):
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
| Understand or implement the marker interface | 0, 2, 7, 14, 17 |
| Audit coefficient and transport safety | 1, 3--6, 8 |
| Reuse the fourfold birational obstruction | 7--9 and Theorem 18.1 |
| Check only the cubic instance | 4, 10--13 |
| See the whole proof in one diagram | Diagram 13.1 |
| Compare Guéré/BFGMP and KKPYY | 7.6 and 17 |
| Study morphisms, compositions, and \(m\ge2\) | 14.7 and 19 |
| Reconstruct retained data from sparse shadows | 20 |
| Implement Reader/indexed-State/Writer/optic effects | 20.3--20.5 |
| Follow the concrete route to \(m=2\) | 21 |

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
  coordinateLaw   :: InvertibleBulkChange phi
                  -> mark (pullback phi b) ~= reindex phi (mark b)
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

The direct-QDM instance has only one generic probe.  To encompass evaluated
or analytic atom theories as well, the outer interface is slightly more
general:

```haskell
class IndexedBirationalBlockTheory t where
  data Context t
  data Probe t
  data LocalBlock t
  data Mark t
  data Atom t

  probes        :: Geometry -> Filter (Probe t)
  splitAt       :: Probe t -> Geometry -> FreeSym (LocalBlock t)
  retainMark    :: LocalBlock t -> Groupoid (Mark t)
  atomize       :: LocalBlock t -> Atom t
  compareSum    :: Comparison -> Span (FreeSym (LocalBlock t))
  separate      :: FiniteFamily (LocalBlock t) -> Eventually (Probe t)

  -- laws, not executable fields
  baseChange    :: PseudofunctorLaw t
  comparisonBC  :: BeckChevalleyLaw t
  sumCoherence  :: SymmetricMonoidalLaw t
  atomNaturality :: ComparisonCongruenceLaw t
```

Here `Filter` specifies what counts as a sufficiently general probe,
`FreeSym` is the finite-multiset construction, and `Span` allows comparison
theorems that canonically identify blocks only after passing to a common
domain.  The direct-QDM proof uses the singleton filter, honest comparison
isomorphisms, and the identity atomizer.  Module 17 gives the nontrivial
Guéré and KKPYY instances.  The extra parameters are dormant in Modules
1--16, so they do not enlarge the hypotheses of the cubic proof.

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

subject to three laws.

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

### Formal-coordinate pseudonaturality law

If \(\phi:S'\xrightarrow{\sim}S\) is an invertible formal bulk-coordinate
change and \(B'\cong\phi^*B\) by a regular connection isomorphism, then

\[
\operatorname{obs}_{\mathcal M}(B')
\cong \phi^*\operatorname{obs}_{\mathcal M}(B),
\tag{2.2a}
\]

and the selector and emitter agree under this canonical reindexing.  For a
scalar rank, Jordan partition, or Boolean this is literal equality.  For an
observation such as an Euler-eigenvalue function, it is pullback of the
function, not equality at unrelated coordinate names.  Identity and composite
coordinate changes must satisfy the usual pseudonaturality coherence.

This third law is load-bearing in every adapter that uses the formal maps
\(\tau\) or \(\varsigma_j\).  Without it, an observer of an uncentered
eigenvalue function would satisfy (2.1)--(2.2) but would change under an
independent unit translation, so the universal claims in Modules 5 and 8
would be false.  The concrete cubic marker is coordinate-insensitive, but the
parameterized interface records the stronger law explicitly.

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
be the set of even-block classes in the localization of the indexed
Grothendieck construction of Module 7.5 by regular isomorphisms, generic
base changes, and invertible formal-coordinate pullbacks.  Thus a
coordinate-dependent observation remains an indexed section and is compared
by pullback; it is never identified by evaluating two unrelated coordinate
names.  Let
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

Every lawful marker package, including the coordinate-pseudonaturality law
of Definition 2.1, determines a unique monoid homomorphism
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

## 7.4 The finite-multiset 2-monad

The construction \(\operatorname{Sym}\) is the free symmetric-monoidal
2-monad on groupoids.  Its unit and multiplication are
\[
\eta_{\mathcal G}:\mathcal G\longrightarrow\operatorname{Sym}(\mathcal G),
\qquad B\longmapsto[B],
\tag{7.12}
\]
and
\[
\mu_{\mathcal G}:
\operatorname{Sym}(\operatorname{Sym}(\mathcal G))
\longrightarrow\operatorname{Sym}(\mathcal G),
\tag{7.13}
\]
where \(\mu\) flattens a finite multiset of finite multisets.  Up to the
canonical symmetric-monoidal coherence isomorphisms, they satisfy
\[
\mu\circ\operatorname{Sym}(\eta)=1
=\mu\circ\eta_{\operatorname{Sym}},
\qquad
\mu\circ\operatorname{Sym}(\mu)
=\mu\circ\mu_{\operatorname{Sym}}.
\tag{7.14}
\]

These are the exact analogues of `singleton`, `flatten`, and associativity in
the software interface.  A marker functor is the unique symmetric-monoidal
extension of its value on one block.  Consequently its fold obeys
\[
\operatorname{fold}_w(0)=0,
\quad
\operatorname{fold}_w(x\oplus y)
=\operatorname{fold}_w(x)+\operatorname{fold}_w(y),
\tag{7.15}
\]
and, for every monoid map \(f:A\to A'\), the fusion law
\[
f\circ\operatorname{fold}_w
=\operatorname{fold}_{f\circ w}.
\tag{7.16}
\]
Equation (7.16) is Proposition 2.5 in universal form.  Mac Lane coherence
means that no ledger can depend on the bracketing or ordering chosen for a
finite direct sum.

## 7.5 Indexed blocks and Beck--Chevalley

Let \(\mathsf{Coeff}\) be the category whose arrows are the lawful generic
field extensions and formal coordinate changes used by the comparison
theorems.  Scalar extension defines a covariant pseudofunctor
\[
\mathscr Q:\mathsf{Coeff}\longrightarrow\mathsf{Gpd},
\qquad K\longmapsto\mathsf{QBlock}^{\mathrm{ev}}_K.
\tag{7.17}
\]
Its identity and composition constraints say
\[
B_K\cong B,
\qquad
(B_L)_M\cong B_M
\quad(K\to L\to M).
\tag{7.18}
\]
The Grothendieck construction \(\int\mathscr Q\to\mathsf{Coeff}\) is an
opfibration: a block and every one of its scalar extensions are one indexed
object, not unrelated copies.

Every comparison adapter is required to be pseudonatural in this index.  Thus
for each coefficient or coordinate square used in a spine, the two routes
\[
\text{base change then compare},
\qquad
\text{compare then base change}
\]
are canonically isomorphic.  This is the Beck--Chevalley law required of a
fully indexed comparison theory.  It
implies that a composite of comparison spans can be formed by a fibre product
over a common coefficient context and that changing the chosen common
algebraic closure cannot change the resulting block ledger.  Modules 3, 5,
and 6 verify the comparison-specific scalar-extension and coordinate-pullback
identities used in the cubic \(m=1\) ledger.  They do **not** by themselves
construct a global atlas of comparison 2-cells for arbitrary spans; any later
use of that stronger bicategorical structure lists it as provider data.

## 7.6 Probe-indexed block theories

An **indexed birational block theory** consists of the following data.

1. A category of coefficient contexts and an indexed groupoid of decorated
   carriers as in (7.17).
2. For every variety \(Y\), a set \(P(Y)\) of probes with a filter
   \(\mathfrak F_Y\).  A statement is *eventual* if it holds on a member of
   \(\mathfrak F_Y\).
3. For every \(p\in P(Y)\), a finite split object
   \[
   \operatorname{Split}_p(Y)
   \in\operatorname{Sym}(\mathsf{Block}_p).
   \tag{7.19}
   \]
4. Comparison spans that commute with reindexing, preserve finite sums, obey
   Beck--Chevalley, and preserve and reflect eventual marker classes.  A
   filter-cofinal span is sufficient; a direct eventual-equivalence theorem
   is also allowed.
5. A **separation contract**: for each finite collection of comparison
   summands, there is an eventual set of probes on which the relevant spectra
   are disjoint, or else the summands remain explicitly labelled and are not
   merged.
6. Optionally, a marking fibration
   \(\mathsf{MarkedBlock}_p\to\mathsf{Block}_p\), whose fibre records the
   labels, vectors, or subobjects the caller elects to retain.
7. An atomizer from marked or unmarked local blocks to a quotient set or
   groupoid, natural for all comparison spans.

The present direct-QDM theory is the special case in which \(P(Y)\) is a
singleton generic point, the filter is trivial, the separation contract is
Lemma 5.1, and the atomizer identifies only regular isomorphisms and generic
base changes.  Evaluation theories use a nontrivial probe filter.  Analytic
atom theories use connected components of an unramified spectral cover and a
larger atomizing congruence.  These specializations are audited in Module 17.

The separation contract is essential.  At a special probe, two different
summand eigenvalues may coincide and their generalized eigenspaces merge.
Additivity of blockwise observations is therefore asserted only after
separation or in a labelled-summand category.  This is precisely the point at
which Guéré's evaluation method is more general than the singleton-generic
interface.

## 7.7 Symmetric-monoidal center localization

Let \(L_d\) freely adjoin an isomorphism
\[
\mathscr B(Z)\cong\mathbbm 1
\qquad(\dim Z\le d)
\tag{7.20}
\]
and close under tensor product.  This localization has the universal
property
\[
\operatorname{Fun}^{\otimes}
\bigl(L_d\operatorname{Sym}(\mathsf{QBlock}^{\mathrm{ev}}),\mathcal A\bigr)
\simeq
\left\{
F:\operatorname{Sym}(\mathsf{QBlock}^{\mathrm{ev}})\to\mathcal A:
F\mathscr B(Z)\cong\mathbbm1
\right\}.
\tag{7.21}
\]
On the right, the functor is equipped with coherent choices of the displayed
trivializations.  For a discrete target \(\underline A\), such a
trivialization exists uniquely exactly when the marker value is zero.
It follows formally that
\[
L_dL_d\simeq L_d,
\qquad
L_eL_d\simeq L_e\quad(d\le e).
\tag{7.22}
\]
On connected components, (7.20) is exactly the monoid congruence (9.1).
Thus center annihilation, factorization of center-vanishing markers,
idempotence, and compatibility of nested dimension cutoffs are consequences
of one universal construction.

## 7.8 The optional Bittner backend

Let \(G(\mathcal L)\) be the Grothendieck group of the universal block monoid.
For a blowup of a smooth projective \(Y\) along a smooth codimension-\(r\)
center \(Z\), let
\(E=\mathbf P_Z(N_{Z/Y})\) be its exceptional divisor.  The two ledgers give
\[
\mathcal B(\operatorname{Bl}_ZY)
=\mathcal B(Y)+(r-1)\mathcal B(Z),
\qquad
\mathcal B(E)=r\mathcal B(Z).
\tag{7.23}
\]
Therefore in \(G(\mathcal L)\),
\[
\mathcal B(\operatorname{Bl}_ZY)-\mathcal B(E)
=\mathcal B(Y)-\mathcal B(Z).
\tag{7.24}
\]
Bittner's presentation now gives a unique additive homomorphism
\[
K_0(\mathsf{Var}_{\mathbf C})
\longrightarrow G(\mathcal L)
\tag{7.25}
\]
whose value on a smooth projective variety is its block ledger.
The empty variety maps to the empty block sum, so the remaining Bittner
relation is satisfied as well.

This is an optional backend, not the foundation of the proof.  It loses every
noncancellative consumer: for example, the group completion of the Boolean
`or` monoid is trivial.  Nor is (7.25) asserted to be a ring homomorphism; that
would require a product/Künneth law for the relevant generic big QDMs, which
has not been proved here.

## Marker coarsening as postcomposition

If \(F:\mathcal M\to\mathcal N\) is a forgetful morphism, the triangle
\[
\begin{array}{ccc}
\mathbf N^{(\Pi)}&\xrightarrow{W_{\mathcal M}}&A\\
&\searrow_{W_{\mathcal N}}&\downarrow F_*\\
&&B
\end{array}
\tag{7.26}
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

## 14.1 Boolean existence: a compact sufficient consumer

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

## 14.6 Coarsening by finite Kan extension

Let \(f:O_{\mathrm{rich}}\to O_{\mathrm{coarse}}\) forget part of an
observation.  On free commutative monoids it induces
\[
f_!: \mathbf N^{(O_{\mathrm{rich}})}
\longrightarrow \mathbf N^{(O_{\mathrm{coarse}})},
\qquad
(f_!m)(c)=\sum_{f(o)=c}m(o).
\tag{14.4}
\]
This is the finite-support left Kan extension along the map of discrete
observation categories.  It gives aggregation automatically: all rich
signatures with the same coarse signature have their multiplicities added.
For Boolean-valued predicates the same left-Kan formula uses `or` and means
"there exists a rich signature over \(c\)"; the right-Kan formula uses `and`
and means "every rich signature over \(c\)".  Infinite fibres require the
corresponding target colimits or limits, so this packet uses only finite
support or explicitly supplies that completeness.

Postcomposition from Definition 2.4 and Kan aggregation solve different
problems.  Postcomposition changes the answer attached to each block.  The
map \(f_!\) changes the indexing set on which a whole signature multiset is
reported.  Their standard mate/fusion square commutes, so one may aggregate
before or after applying a compatible monoid-valued marker.

## 14.7 Retention through endomorphism categories

For a nilpotent leading term, a block may be regarded first as an object
\((V,N)\) of the category of finite-length \(K[t]\)-modules, with \(t\)
acting as \(N\).  There is a strict retention ladder
\[
\text{isomorphism groupoid}
\longrightarrow K_0^{\mathrm{split}}
\longrightarrow K_0^{\mathrm{exact}}
\longrightarrow \mathbf Z.
\tag{14.5}
\]
Over an algebraically closed field, Krull--Schmidt makes the split group free
on the Jordan blocks \(J_n\), so it retains the Jordan partition.  The exact
group of nilpotent finite-length \(K[t]\)-modules remembers only total length,
because every composition factor is \(K[t]/(t)\).  Thus passing from split to
exact \(K_0\) destroys precisely the extension data that distinguish Jordan
blocks.

Likewise, an invertible formal-monodromy operator is an object of
\(\operatorname{Rep}_K(\mathbf Z)\), equivalently a finite-dimensional
\(K[t,t^{-1}]\)-module.  Direct sum sends it to multiplication of
characteristic polynomials.  One may therefore retain the full representation
groupoid, its split class, or only the characteristic polynomial.  This
categorical ladder explains why a higher-stabilization theory should not pass
to an exact Grothendieck group before deciding whether extension classes are
part of the marking.

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

## H2A. Does separation make every coordinate-dependent observer lawful?

No.  Independent unit translations separate spectra, but they also change an
uncentered Euler-eigenvalue function.  Definition 2.1 therefore includes the
formal-coordinate pseudonaturality law, and the universal ledger localizes
the indexed Grothendieck construction by coordinate pullback.  The cubic
marker is centered and coordinate-insensitive; the general interface may not
silently compare values at unrelated coordinate names.

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

## H11. Does group completion silently discard Boolean obstructions?

No.  Center localization is performed in the effective symmetric-monoidal
category or its commutative monoid.  The Bittner/Grothendieck-group backend is
optional and explicitly unavailable for Boolean `or`, whose group completion
is trivial.

## H12. Is Guéré's evaluation map being treated as a field extension?

No.  It is a probe in an indexed theory.  Its cofinite quantifier and possible
spectral collisions are retained.  The direct-sum law is invoked only after
the unit-shift separation used in Guéré's own proof.

## H13. Does the KKPYY specialization invent a category of atoms?

No.  Local spectral blocks form the categorified input.  The published atom
equivalence is then represented by its presented thin groupoid solely so that
the free symmetric-monoidal compiler may act on it.  No natural atom
morphisms are asserted.

## H14. Does the generalized compiler prove the imported frameworks?

No.  It subsumes their transport, atomization, marking, and retention laws.
Non-Archimedean convergence, motivic actions, monodromy irreducibility, and
the Iritani comparison theorems remain provider obligations.

## H15. Can a coarsening destroy extension data accidentally?

Yes, unless its target is chosen deliberately.  Module 14.7 records the exact
loss: split \(K_0\) retains Jordan-block multiplicities, while exact \(K_0\)
retains only total length.  The interface therefore makes the retention
quotient an explicit parameter rather than a default.

## H16. Does categorical packaging alone prove \(m=2\)?

No.  It proves the constituent-additive no-go, the ideal-quotient composition
theorem, and the \(\mathbf G_a\) coherence laws.  The enriched QDM comparison
functor landing in the augmented-row category is still a geometric/analytic
input.  Once that functor exists, its row-output kernel ideal is formal by
Theorem 19.3A.

## H17. Can finite deck monodromy replace the nilpotent operation?

No.  A finite cyclic action is semisimple in characteristic zero.  It can
retain branch provenance through a Burnside or Mackey marker, but cannot
distinguish the extension \(J_3\) from three split constituents.  The needed
operation lives in the commuting \(\mathbf G_a\) factor.

## H18. Is wall-local annihilation enough for a long factorization?

Not when the identities live in separately chosen receivers.  Actual
row-line-compatible isomorphisms in one augmented category compose and invert
without a quotient.  Alternatively, Theorem 19.3 applies after all receivers
and overlap 2-cells map through one retained-shadow functor, whose kernel is
then two-sided.  Constructing that global provider, not constructing the
ideal algebra, is the composition gate.

## H19. May higher-codimension exceptional copies remain split?

Not in an operation-framed rig lift.  Equation (19.13) forces their total
Jordan type to be \(J_{m-1}\).  Treating them as
\(J_1^{\oplus(m-1)}\) is compatible only after forgetting the operation, or
in the accidental case \(m=2\).

## H20. Does a lens invert a forgetful map?

No.  An ordinary lens can update a focus while the original source, including
its residual context, is still present.  It does not reconstruct the source
from the focus alone.  Reconstruction requires either a retained residual, a
contractible forgetful fibre, or a second jointly conservative shadow.

## H21. Does recording the name of a forgetting path preserve its payload?

No.  A path label supplies provenance and selects possible Beck--Chevalley
transport, but two rich objects can traverse the same path to the same shadow.
The path becomes reconstructive only when it carries an optic residual or a
cartesian lift to a common source on which the desired marker is constant.

## H22. Is every sparse reconstruction shadow closed under composition?

No.  The complete nilpotent kernel profile is closed under direct sums and,
in characteristic zero, determines the tensor decomposition.  The single bit
\(D^m\ne0\) detects the desired endpoint string but is not by itself a lawful
provider for arbitrary tensors or wall comparisons.  Consumer sufficiency
must not be confused with provider closure.

## H23. Is a function on path labels enough to transport retained data?

No.  A path translator must preserve identities and composition, at least up
to coherent 2-cells, and the shadow map must be natural with respect to it.
Without that naturality square, mapping a route and mapping the payload are
unrelated operations.

## H24. Is the naked row annihilator a two-sided ideal?

No.  The \(2\times2\) matrix counterexample before Theorem 19.3A disproves
this, and its two-sided closure can contain the identity.  A lawful quotient
uses the kernel of the augmented-row output functor or another named additive
retained-shadow functor.  For an ordered path of actual row-compatible
isomorphisms, no quotient is needed.

## H25. Is the point row transported covariantly?

No.  On column carriers it is a covector.  The typed comparison law is
\[
r_{\mathrm{target}}\circ f=\ell\circ r_{\mathrm{source}},
\]
with \(fT= T'f\).  Exact normalization is unnecessary for the nonvanishing
Boolean when \(\ell\) is invertible.

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

The optional backend in Module 7.8 additionally uses F. Bittner,
*The universal Euler characteristic for varieties of characteristic zero*,
Compositio Math. 140 (2004), for the smooth-projective blowup presentation of
\(K_0(\mathsf{Var}_{\mathbf C})\).  It is not an input to the cubic proof.

The proof does not use Cai, KKPYY/HYZZ reconstruction, Hodge atoms,
David--Hertling, or a recursive comparison of asymptotic completions.
Module 17 cites Guéré, Benedetti--Fay--Guéré--Manivel--Perrin, and
KKPYY only to test the general interface against their frameworks; none is an
additional input to Modules 10--13.

The exact identities in §10.3 were replayed in rational symbolic arithmetic by
`notes/cubic-threefolds-tasks/c924-finite-cubic-check.py`; its checked output is
`notes/cubic-threefolds-tasks/c924-finite-cubic-check.json`.  The displayed
matrix calculation remains the mathematical proof.

---

# Module 17. External-framework specialization audit

This module asks for literal law-preserving instances of Module 7.6.  It does
not count a shared slogan or a similar blowup formula as subsumption.

## 17.1 Guéré's evaluated coarse-block instance

Fix the morphism and coefficient ring used to define Guéré's evaluations.
The instance data are as follows.

- A probe is a nonvanishing \(K\)-evaluation map
  \[
  \mathrm{ev}:\widehat R^*_{Z,K}\longrightarrow S_K^*.
  \tag{17.1}
  \]
  The filter is the cofinite filter: a statement is eventual when it fails for
  only finitely many evaluation maps.
- The local blocks are the generalized eigenspaces
  \[
  E^Y_{\mathrm{ev},\alpha}
  =\ker(\mathrm{ev}(\kappa_\tau)-\alpha)^m,
  \qquad m\gg0.
  \tag{17.2}
  \]
- The decoration remembers Guéré's tuple
  \[
  o_Y(\mathrm{ev},\alpha)
  =(\rho,\nu,\nu',\gamma),
  \tag{17.3}
  \]
  measuring the Hodge-class part, Hochschild-degree-two and degree-one
  parts, and the rank of \(\mathrm{ev}(\kappa_\tau)-\alpha\) on the block.
- Scaling an evaluation and translating it in the unit direction reindex the
  spectrum by a bijection and preserve (17.3).  They are therefore lawful
  probe morphisms, not changes to the retained value.

Define Boolean violation markers
\[
\begin{aligned}
\operatorname{bad}_{\clubsuit}(\rho,\nu,\nu',\gamma)
&=[\nu\ne0\ \text{and}\ \rho\le2],\\
\operatorname{bad}_{\heartsuit}(\rho,\nu,\nu',\gamma)
&=[\nu\ne0,\ \nu'=0,\ \gamma\le1].
\end{aligned}
\tag{17.4}
\]
For each probe, fold these values with Boolean `or` over all eigenblocks.
The resulting function on probes is considered in the quotient Boolean
algebra
\[
\{0,1\}^{P(Y)}/\mathrm{Fin},
\tag{17.5}
\]
where two functions agree if they differ on only finitely many probes.  Then
Guéré's Properties \(\clubsuit\) and \(\heartsuit\) are exactly the
statements that the corresponding violation class in (17.5) is zero.

Iritani's evaluated blowup isomorphism, in Guéré's Corollary 37, gives the
comparison span and adds the four measurements at a fixed eigenvalue.  A
unit translation of a center evaluation can make its finite spectrum disjoint
from any prescribed finite collection.  Guéré's Proposition 38 uses exactly
this separation operation, and Corollary 41 composes it along weak
factorization.  Thus the \(\clubsuit/\heartsuit\) formalism is a genuine
instance of the probe-indexed interface.

Equivalently, let \(V_\diamond(Y)\) be `true` when the support of the
violation function is infinite, i.e. when its class in (17.5) is nonzero.
Guéré's Proposition 38 is exactly the Boolean blowup law
\[
V_\diamond(\operatorname{Bl}_Z Y)
=V_\diamond(Y)\lor V_\diamond(Z),
\qquad \diamond\in\{\clubsuit,\heartsuit\}.
\tag{17.6}
\]
Multiplicity \(r-1\) is invisible to the idempotent `or` consumer.

It is **not** an instance of Definition 2.1 without the extension in Module
7.6: evaluation is a specialization rather than a generic field extension,
specialized spectra can collide, and the invariant contains a cofinite
quantifier over probes.

## 17.2 The Benedetti--Fay--Guéré--Manivel--Perrin marked instance

The BFGMP criterion uses the same evaluated blocks, but adds a transported
mark.  For a Hodge-general Fano fourfold in their hypotheses, monodromy
irreducibility and equivariance put the whole vanishing cohomology into one
generalized eigenspace.  Define a marked local block to be
\[
(E_{\mathrm{ev},\alpha},
  H^4_{\mathrm{van}}\hookrightarrow E_{\mathrm{ev},\alpha}),
\tag{17.7}
\]
and retain its Hochschild-degree pieces and the codimension of its Hodge
classes.  Their pairwise-disjoint maximal-spectrum choice supplies the
separation contract along a chosen weak factorization.  Surface inequalities
then rule out every possible carrier of the marked block.

This is a specialization of the **pointed** or **marked** version of Module
7.6, in which the fibre over a local block is a groupoid of retained labels or
subobjects and comparison spans must transport the label.  It demonstrates
why `select` cannot always be merely a predicate on an unmarked isomorphism
class: the distinguished monodromy subrepresentation is part of the proof
state.

The framework recovers the architecture of BFGMP Theorem 4.1, conditional on
its geometric inputs (Hodge generality, monodromy irreducibility, and the
surface bounds).  It does not turn those inputs into formal consequences of
the QDM ledger.

## 17.3 The KKPYY atom and chemical-formula instance

For a \((G,\epsilon_G)\)-symmetric Weil cohomology theory, take as carrier the
non-Archimedean maximal \(G\)-equivariant A-model \(F\)-bundle on the
\(G\)-fixed base.  Over the locus where the reduced spectral cover is
unramified, a local block is a connected component of that cover together
with its generalized-eigenvalue \(F\)-bundle and \(G\)-representation.
The split object records such a component with multiplicity equal to the
degree of that component over the base; this is the multiplicity in the
chemical formula.

The atomizer is the quotient generated by:

1. automorphisms and disjoint-union identifications;
2. the local correspondence induced by the canonical blowup decomposition;
3. the local correspondence induced by the projective-bundle decomposition.

This is precisely KKPYY Definition 5.16.  Since KKPYY explicitly note that
atoms have no natural morphisms and do not themselves form a category, the
categorical implementation uses the **thin groupoid presented by this
equivalence relation**.  It does not invent morphisms between the underlying
atoms.

Applying \(\operatorname{Sym}\) and \(\pi_0\) gives
\[
\operatorname{CF}_G(Y)
\in\mathbf N^{(\operatorname{Atoms}^K_G)},
\tag{17.8}
\]
the KKPYY chemical formula.  Their spectral, blowup, and projective-bundle
Theorems 4.1, 4.5, and 4.11 discharge the split/comparison laws.  Their
dimension filtration
\[
\operatorname{Atoms}_{G,\dim\le0}^K
\subset\operatorname{Atoms}_{G,\dim\le1}^K
\subset\cdots
\tag{17.9}
\]
is the atom-level form of center localization, and Proposition 5.17 is the
corresponding non-rationality theorem.

Thus the positive chemical-formula and dimension-filtration portion of
KKPYY is an exact specialization of the generalized compiler.  The internal
construction of maximal analytic \(F\)-bundles, motivic \(G\)-actions,
pairings, integral structures, and enhanced Serre operators remains inside
the carrier provider.  The compiler organizes and forgets such data; it does
not derive it.

## 17.4 Subsumption theorem

Let a probe-indexed block theory satisfy:

1. pseudofunctorial base change and Beck--Chevalley;
2. coherent finite splitting under \(\operatorname{Sym}\);
3. a filter-exact comparison span for every geometric adapter enabled by the
   instance, meaning that it preserves and reflects eventual marker classes;
4. spectral separation or persistent summand labels; and
5. a comparison-natural atomizer and marker.

Then its variety assignment, atomized spectrum, marker folds, and
center-localized birational obstructions are obtained functorially from the
single pipeline
\[
\boxed{
\mathsf{Geometry}
\longrightarrow
\int_{p\in P(-)}\operatorname{Sym}(\mathsf{MarkedBlock}_p)
\longrightarrow
\operatorname{Sym}(\mathsf{Atom})
\xrightarrow{L_d}
\operatorname{Sym}(\mathsf{Atom})_{>d}
\longrightarrow\underline A.}
\tag{17.10}
\]

### Proof

Pseudofunctoriality and Beck--Chevalley make the first two arrows independent
of coefficient refinements and of how comparison spans are composed.
The 2-monad laws make all finite decompositions coherent.  Separation makes
the atomizer blockwise; naturality lets it descend through comparisons.
The universal property (7.21) gives the last factorization for every marker
that kills centers through dimension \(d\).  Fold fusion proves compatibility
with every subsequent coarsening. ∎

The principal instances are:

| instance | probes | local block | atomizer | final consumer | exact scope |
| --- | --- | --- | --- | --- | --- |
| direct QDM in this packet | one algebraic generic point | regular even QDM spectral block | regular isomorphism and generic base change | arbitrary lawful monoid marker | all of Modules 1--16 |
| Guéré \(\clubsuit/\heartsuit\) | nonvanishing evaluations, cofinite filter | evaluated generalized eigenspace with \((\rho,\nu,\nu',\gamma)\) | evaluation equivalence and separated comparison | eventual Boolean violation | Definitions 20, 25, 27; Proposition 38; Corollary 41 |
| BFGMP coarse criterion | separated maximal evaluations along a factorization | evaluated eigenspace marked by vanishing cohomology | transport of the mark | surface-carrier inequality | Theorem 4.1, given its Hodge/monodromy inputs |
| KKPYY | connected non-Archimedean analytic domains | component of the unramified reduced spectral cover with \(G\)-decoration | generated elementary atom equivalence | positive chemical formula or dimension cutoff | Theorems 4.1, 4.5, 4.11; Definition 5.16; Proposition 5.17 |

The verdict is therefore:
\[
\boxed{
\text{one generalized compiler has direct QDM, Guéré/BFGMP, and KKPYY
as sibling specializations of its transport-and-retention layer}.}
\tag{17.11}
\]
It would be inaccurate to say that the current unindexed marker package alone
subsumes the other two, or that the compiler reproduces their analytic,
motivic, or monodromy theorems.

## 17.5 Law-test matrix

| law | direct QDM witness | Guéré/BFGMP witness | KKPYY witness |
| --- | --- | --- | --- |
| identity/composite base change | Definition 2.1 and Module 3 | equivalence and extension of evaluation maps | analytic base change of maximal \(F\)-bundles |
| Beck--Chevalley for comparison | common spines, Modules 3 and 6 | Iritani comparison plus variable changes in Corollary 37 | canonical comparison on common analytic domains |
| finite-sum coherence | Lemma 5.1 and Proposition 5.2 | direct sums after unit-shift separation | disjoint unions of spectral-cover components |
| separation | independent generic unit coordinates | chosen unit translations; maximal pairwise-disjoint spectra | restriction to the unramified cover and connected domains |
| atomizer naturality | regular gauge/base change | preservation of \((\rho,\nu,\nu',\gamma)\) | elementary equivalences defining \(\operatorname{Atoms}^K_G\) |
| center localization | Theorem 9.2 | center satisfies the relevant eventual property | dimension filtration and Proposition 5.17 |
| coarsening/fusion | Proposition 2.5 | change of violation predicate | forgetful maps from enhanced to coarse atoms |

## 17.6 Primary-source check

The comparison above was checked against the following cached primary-source
texts, not against secondary descriptions.

1. J. Guéré, *On the irrationality of cubic fourfolds*,
   arXiv:2603.04518v1: Definitions 20, 25, 27; Corollary 37; Proposition 38;
   Corollary 41; Theorem 56.  Cached PDF SHA-256:
   `eb84753911c97a6b618975be5da4dc3b5bdec2b66edf11063d09d75e475abfdc`.
2. V. Benedetti, A. Fay, J. Guéré, L. Manivel, N. Perrin,
   *An atomic criterion for irrationality without quantum computations*,
   arXiv:2607.26718v1: Definition 2.1, Theorem 4.1, Remarks 4.2 and 4.5.
   Cached PDF SHA-256:
   `bb1ee656bd55008a5403e057d0856e65c81b100f2fa07d1c90e184766dd0f407`.
3. L. Katzarkov, M. Kontsevich, T. Pantev, T. Y. Yu,
   *Birational invariants from Hodge structures and quantum multiplication*,
   arXiv:2508.05105v2: Theorems 4.1, 4.5, 4.11; Definition 5.16;
   Proposition 5.17; Example 6.21.  Cached PDF SHA-256:
   `2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64`.

The finite algebraic shadow of the laws in Modules 7, 17, and 19--21 is replayed by
`notes/cubic-threefolds-tasks/c925-categorical-law-check.py`; its checked
output is `notes/cubic-threefolds-tasks/c925-categorical-law-check.json`.
The typed effect/optic toy is
`notes/cubic-threefolds-tasks/c925-sparse-shadow-path-toy.hs`, with checked
output in the adjacent `-output.txt` file.  These replays test finite
coherence, collision, sparse reconstruction, and type-level path laws.  They
are not evidence for the analytic comparison theorems, which remain primary
inputs.

Exact replay:

```bash
nix shell nixpkgs#python3 --command \
  python3 notes/cubic-threefolds-tasks/c925-categorical-law-check.py \
  | diff -u notes/cubic-threefolds-tasks/c925-categorical-law-check.json -

nix shell nixpkgs#ghc --command \
  runghc notes/cubic-threefolds-tasks/c925-sparse-shadow-path-toy.hs \
  | diff -u \
      notes/cubic-threefolds-tasks/c925-sparse-shadow-path-toy-output.txt -
```

The SHA-256 hashes are
`cd4129e493e5b98393ed7e59e2fb56de149675fbc762c3d1279c888c5977ffcd`
for the script and
`a13e408408432ff5c36323998157d475ae9f9d9484158591c97eab201186631d`
for its checked output; and
`4d77f6d103b20bacd3ecdc7a30a2dc78039018c69c7c119ff301cd5612af8adb`
and
`9406cab21b4e8536ec42403e84accb39e67556f017df2d69c52821413d706360`
for the Haskell toy and its checked output respectively.

---


# Module 18. Final modular statement

The proof is an instance of the following schema.

## Theorem 18.1 — parameterized fourfold obstruction

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

# Module 19. Morphisms, compositions, and higher-stabilization consequences

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

# Module 20. Sparse-shadow reconstruction, effects, and optics

The other papers in the reconstruction programme suggest a distinction that
the retention ladder in Module 14.7 did not yet make.  Information can be
absent from the displayed shadow without being mathematically destroyed.
Sometimes the shadow determines the rich object on a rigid locus; sometimes
only the marker descends; sometimes the fibre is a finite torsor; and
sometimes the information is genuinely lost.  These four cases must not be
called by the same name.

## 20.1 Marker descent through a forgetful shadow

Let
\[
U:\mathcal C\longrightarrow\mathcal S
\tag{20.1}
\]
be a functor from rich objects to shadows, and let
\(M:\operatorname{Ob}(\mathcal C)/\!\cong\;\to A\) be an isomorphism-invariant
marker with values in a set \(A\).  Write \(\operatorname{im}_0(U)\) for the
image of \(U\) on isomorphism classes.

## Theorem 20.1 -- sparse-shadow descent criterion

There is a unique function
\[
\overline M:\operatorname{im}_0(U)\longrightarrow A,
\qquad
M=\overline M\circ U,
\tag{20.2}
\]
if and only if
\[
Ux\cong Uy\quad\Longrightarrow\quad M(x)=M(y).
\tag{20.3}
\]

### Proof

Necessity follows by applying \(\overline M\) to an isomorphism of shadows.
Conversely, define \(\overline M([Ux])=M(x)\).  Condition (20.3) makes this
independent of the chosen lift, and uniqueness holds because every class in
\(\operatorname{im}_0(U)\) has such a lift. ∎

Thus **the object need not be reconstructible for its marker to be
reconstructible**.  In the groupoid-valued refinement, one replaces (20.3)
by an isomorphism
\[
p_1^*M\;\xRightarrow{\ \theta\ }\;p_2^*M
\quad\text{on}\quad
\mathcal C\times_{\mathcal S}\mathcal C
\tag{20.4}
\]
satisfying the usual identity and cocycle laws on the triple fibre product.
When \(U\) is an effective descent morphism for the target, this datum
descends \(M\) to \(\mathcal S\).  Equation (20.4), rather than a choice of
inverse to \(U\), is the categorical form of "the shadow forgot it, but the
invariant did not."

For a family of shadows \(U_i:\mathcal C\to\mathcal S_i\), replace \(U\) by
the joint functor
\[
U_{\mathrm{joint}}=(U_i)_i:
\mathcal C\longrightarrow\prod_i\mathcal S_i.
\tag{20.5}
\]
Two individually lossy projections can be jointly conservative, or merely
jointly sufficient for one marker.  This is the exact role of companion
cubics, signed higher moments, marked contractions, and operator-valued
atlases in the other papers.

## 20.2 Four different forgetful fibres

The fibre of \(U\) over a shadow separates four situations.

1. **Contractible fibre.**  On a rigid stratum there is, up to unique
   isomorphism, one lift.  A reconstruction functor \(R\) with
   \(RU\simeq\mathrm{id}\) and \(UR\simeq\mathrm{id}\) makes \(U\) an
   equivalence on that stratum.  The shadow has forgotten only a
   presentation.
2. **Marker-contractible fibre.**  Several inequivalent lifts remain, but
   the desired marker is constant on the fibre.  Theorem 20.1 reconstructs
   the marker without reconstructing the object.
3. **Torsorial fibre.**  The lifts form a principal homogeneous space for a
   group such as \(C_2\).  The shadow reconstructs the ambiguity but supplies
   no canonical choice.  A marking, companion shadow, or section trivializes
   the torsor.
4. **Marker-varying fibre.**  Two lifts have the same shadow and different
   marker.  The marker is genuinely destroyed.  Recording only the name of
   the forgetful functor cannot repair this case.

The restriction to a rigid carrier is part of the theorem, not decoration.
Paper II's nonmatching fixed-line examples are an exact warning: a quadratic
trade that reconstructs on the matching carrier does not reconstruct in the
ambient fibre.

## 20.3 Reconstruction patterns already present in the programme

The following table is a structural synthesis of the complete local portfolio
summary `papers/summary/README.md`, SHA-256
`4184dc9e270a97e585d07a56d3f4d7a01f5fac480ef29e7c297f3b8f7c069a5e`.
It does not import the papers' individual reconstruction theorems as inputs
to the cubic proof.

| source | sparse shadow | what is reconstructed | residual or gate |
| --- | --- | --- | --- |
| Clebsch I | deep-hole syndrome locus and nearest-word ambiguity | code, conic, polarity, golden operator | recognition is on the Clebsch rigidity locus; ambiguity data, not the point set alone, carries orientation |
| Clebsch II | two-valued quadratic trade | unordered sheets | only on the perfect-matching carrier; complete splitting excludes the nonmatching fixed-line counterexamples; a signed cubic orients |
| Clebsch III | incidence-cover sheet plus operator shadows | a conference source and its equivalent operator realizations | the sheet alone supplies none of the bridge marking |
| Clebsch IV | weighted pair concurrences of minimum words | incidence matrix, code, association scheme, marked plane, conic, polarity | pair data are sufficient; triple concurrence is genuinely unnecessary |
| Clebsch V | singular shadow of either invariant cubic | common six-axis carrier | the oriented round trip needs a chordal companion; the remaining ambiguity is a \(C_2\)-torsor |
| PRS recursive carriers | polar contraction with the removed root retained | a lower split witness lifts coherently | the pointed lower packages are the stated existence gate |
| stabilizer AME | one \((m+1)\)-party support atlas | complete local Weyl frame | recovered up to local symplectic frame change |
| MDS--CSS | operator-valued Weyl atlas | equivalence data invisible to bounded scalar contractions | scalar contractions alone are constant on generic fibres and fail (20.3) |
| golden exchange | singular values, then determinant sign, then calibrated amplitudes | successively the unframed carrier, orientation, and framed device | each added shadow shrinks the forgetful fibre |
| cubic epilogue | QDM atom plus intrinsic line and modified residue | the obstruction not determined by the bare Hodge representation | the ordinary representation is realizable by a surface, while its atomic residue profile is not |

Three recurring mechanisms emerge:

\[
\boxed{
\text{rigid carrier restriction}
\quad+\quad
\text{jointly conservative shadows}
\quad+\quad
\text{a small residual marking}.}
\tag{20.6}
\]

This is a more precise design rule than "retain everything."  One should
seek a compact collection for which the target marker satisfies the
kernel-pair criterion (20.3) or its groupoid descent refinement (20.4).

## 20.4 Reader, indexed State, and Writer

The proof compiler has three different kinds of information, so an undivided
ordinary `State` monad is the wrong software analogy.

```haskell
data Env keep = Env
  { coefficientSpine :: FaithfulCommonSpine
  , probePolicy       :: Filter (Probe keep)
  , centerCutoff      :: Dimension
  , retainedOutput    :: AdditiveRetainedShadowFunctor keep
  , coherenceAtlas    :: BeckChevalleyAtlas
  }

data Ledger keep stage = Ledger
  { currentContext :: ContextAt stage
  , currentBlocks  :: FreeSym (Shadow keep stage)
  , currentMark    :: Maybe (MarkedRow keep stage)
  }

newtype ProofM keep source target a = ProofM
  { runProofM :: Env keep
              -> Ledger keep source
              -> Either Failure
                   (a, Ledger keep target, Certificate source target)
  }
```

`Env` is Reader data: it is fixed for the entire factorization.  In
particular, if Theorem 19.3 is used, its global error ideal is derived as
`ker retainedOutput`; it is not an unexplained field and cannot mutate from
wall to wall.  If the path already consists of isomorphisms in
the augmented-row category, Theorem 19.3A composes it without a quotient.

`Ledger keep source` is indexed State.  A wall, base change, or specialization
can change the type of the state, so the correct bind has the form

```haskell
return :: a -> ProofM keep s s a
(>>=)  :: ProofM keep s t a
       -> (a -> ProofM keep t u b)
       -> ProofM keep s u b
```

rather than the bind of ordinary `State s`.  The left-unit, right-unit, and
associativity laws are exactly identity and associativity of comparison
paths.  Certificates are 1-cells; the comparison coherence maps are 2-cells
identifying different parenthesizations and allowed path refinements.

Only path-independent summaries belong in a commutative Writer:

```haskell
data Evidence keep = Evidence
  { observedProfiles :: FiniteSet (Profile keep)
  , usedInputs        :: FiniteSet SourceId
  , dischargedGates  :: FiniteSet GateId
  }
```

Its union law makes accumulation associative, commutative, and idempotent.
The raw ordered comparison path must not be flattened into this Writer; it
lives in `Certificate source target`, where order and 2-cell coherence remain
visible.

Finally, retention is a capability, not a nullable record field:

```haskell
class Retention keep where
  type Shadow keep stage
  observe :: RichBlock stage -> Shadow keep stage
  descent :: KernelPairLaw keep

class Retention keep => HasNilpotentProfile keep where
  kernelProfile :: Shadow keep stage -> [Nat]

class Retention keep => HasPointRow keep where
  rowShadow :: Shadow keep stage -> CyclicRowProfile
```

Parametricity then prevents a consumer configured for a coarse shadow from
silently inspecting a forgotten Gamma row or nilpotent operator.

## 20.5 Lenses, residuals, and parallel projections

A lawful lens
\[
\operatorname{get}:A\to S,
\qquad
\operatorname{put}:A\times S\to A
\tag{20.7}
\]
satisfies `GetPut`, `PutGet`, and `PutPut`.  These laws permit focused updates
while \(A\) is still available.  They do **not** give a map \(S\to A\).

The reconstructive version is a residual optic.  In a symmetric monoidal
category, a representative has a residual \(R\) and maps of the shape
\[
A\longrightarrow R\otimes S,
\qquad
R\otimes S'\longrightarrow A'.
\tag{20.8}
\]
When the first map is an isomorphism, the pair consisting of the visible
shadow and the retained residual reconstructs the source.  A zipper is the
corresponding data-structural example.  In the Clebsch series, a bridge
marking, a companion cubic, or an orientation torsor is precisely such a
residual.

For QDM comparisons the product form (20.8) is often too restrictive.  The
correct general optic is a common-source span
\[
\begin{array}{ccc}
& \mathcal E & \\
{}^{p}\swarrow && \searrow^{q}\\
\mathcal S && \mathcal T,
\end{array}
\tag{20.9}
\]
where \(\mathcal E\) is a common coefficient spine, gauged master object, or
marked comparison category.  To read a parallel shadow in \(\mathcal T\), one
must retain either a lift \(e\in\mathcal E\) over the observed
\(s=p(e)\), or enough residual data to choose such a lift.  Then the other
shadow is \(q(e)\).  If no lift is retained, \(q(e)\) is nevertheless
well-defined from \(s\) exactly when it is constant on the fibres of \(p\),
which is Theorem 20.1 again.

Tracking the route is therefore useful, but only in the following typed form:
\[
(\text{current shadow},\ \text{cartesian lift or residual},\
  \text{path 1-cell},\ \text{coherence 2-cells}).
\tag{20.10}
\]
The Grothendieck construction of the indexed block pseudofunctor in Module
7.5 is a natural home for (20.10).  A Beck--Chevalley square lets a retained
lift be pulled along one specialization and read through a parallel one.
Different routes give the same marker only after the specified 2-cell is
checked.

The path itself can change type.  A morphism from one comparison theory to
another therefore includes an indexed path translator:

```haskell
class PathFunctor f where
  type FStage f source

  mapPath :: Path source target
          -> Path' (FStage f source) (FStage f target)

  mapId      :: mapPath (identity @source) ~= identity
  mapCompose :: mapPath (q . p) ~= mapPath q . mapPath p
  mapTwoCell :: TwoCell p q -> TwoCell (mapPath p) (mapPath q)
```

In ordinary categories the two displayed comparisons are equalities.  For
QDM comparison bicategories they are coherent invertible 2-cells, so
`mapPath` is a pseudofunctor.  If comparison errors vanish only after one
additive retained-shadow functor, its kernel ideal permits the quotient of
Theorem 19.3.  A naked row annihilator does not.

A path functor alone still transports only provenance.  It must be paired
with a shadow transformation

```haskell
mapShadow :: Shadow keep source
          -> Shadow keep' (FStage f source)

naturality :: mapShadow (transport p x)
           ~= transport (mapPath p) (mapShadow x)
```

or, diagrammatically,
\[
\begin{array}{ccc}
\operatorname{Shadow}(s)
  &\xrightarrow{\operatorname{transport}(p)}&
  \operatorname{Shadow}(t)\\
{\scriptstyle\Phi_s}\,\big\downarrow&&
  \big\downarrow\,{\scriptstyle\Phi_t}\\
\operatorname{Shadow}'(Fs)
  &\xrightarrow{\operatorname{transport}(Fp)}&
  \operatorname{Shadow}'(Ft).
\end{array}
\tag{20.10a}
\]
This is the pseudonaturality component already required of a 1-cell in
\(\mathsf{BlkTh}\).  When paths come in two kinds--vertical specializations
and horizontal comparison spans--the faithful structure is a double functor
or equipment morphism, with Beck--Chevalley squares mapped to squares.  This
is the precise version of mapping one type of path to another while reading a
retained focus through a parallel projection.

In the effect interface, `PathFunctor` and its naturality certificate belong
in `Env`; `Certificate source target` records which mapped path was actually
used.  This keeps the translator global and lawful while allowing the indexed
State to move through different source and target types.

## Proposition 20.1A -- pullback along a path functor

Let \(B:\mathcal P\to\mathsf{Gpd}\) and
\(B':\mathcal P'\to\mathsf{Gpd}\) be indexed block theories, let
\(F:\mathcal P\to\mathcal P'\) be a pseudofunctor on path types, and let
\[
\Phi:B\Longrightarrow B'F
\tag{20.10b}
\]
be a pseudonatural shadow map.  If \(m'\) is invariant under every
\(\mathcal P'\)-transport, then
\[
m_s(x):=m'_{Fs}(\Phi_sx)
\tag{20.10c}
\]
is invariant under every \(\mathcal P\)-transport.  These pullbacks compose
associatively, up to the inherited coherence 2-cells.

### Proof

For \(p:s\to t\), pseudonaturality identifies
\(\Phi_t(B(p)x)\) with \(B'(F(p))\Phi_s(x)\).  The latter has the same
\(m'\)-value as \(\Phi_s(x)\) by path invariance, which proves the first
claim.  For two path functors, substitution in (20.10c) gives the composite
shadow map; pseudofunctor associativity supplies the unique required 2-cell.
∎

This proposition is the reusable payoff of a path-mapping function: a lawful
marker in the target path theory becomes a lawful marker in the source theory
without re-proving every path comparison.  It does not rescue a target marker
that already varies on the target's forgetful fibres.

This exactly diagnoses the all-stabilizations Gamma route.  The common-open
or gauged source is \(\mathcal E\), the endpoint theories are parallel
projections, and the point row is the retained focus.  The missing marked
threshold theorem is not the assertion that a path exists; it is the
assertion that the relevant square carries a cartesian lift of the entire
row-generated cyclic module, including the zero-mode nearby-cycle case.

## 20.6 The nilpotent operator has a much smaller complete shadow

The full matrix of \(D=\log\tau\) is unnecessary if only its conjugacy class
or its longest strings matter.  For a nilpotent endomorphism of an
\(n\)-dimensional vector space define
\[
k_j(D)=\dim\ker D^j,
\qquad 0\le j\le n,
\qquad k_0=0.
\tag{20.11}
\]

## Theorem 20.2 -- kernel-profile reconstruction

The integer vector
\[
\operatorname{KP}(D)=(k_1(D),\ldots,k_n(D))
\tag{20.12}
\]
determines the nilpotent Jordan partition.  More precisely,
\[
\#\{\text{blocks of size at least }j\}=k_j-k_{j-1},
\tag{20.13}
\]
and hence
\[
\operatorname{mult}(J_j)
=2k_j-k_{j-1}-k_{j+1},
\tag{20.14}
\]
where \(k_{n+1}=k_n\).  The profile is additive under direct sums.

### Proof

A block \(J_r\) contributes \(\min(j,r)\) to \(k_j\).  Its contribution to
\(k_j-k_{j-1}\) is therefore one exactly when \(r\ge j\), proving (20.13).
Taking the difference between the counts for \(j\) and \(j+1\) gives
(20.14).  Kernel dimensions add under direct sums. ∎

If \(D^r=0\), this compresses further:
\[
\operatorname{mult}(J_r)=\operatorname{rank}D^{r-1}.
\tag{20.15}
\]
Indeed, among blocks of size at most \(r\), only \(J_r\) contributes to the
rank of \(D^{r-1}\), and it contributes one.

For \(m=2\), under the exponent bound \(D^3=0\), the single sparse Boolean
\[
\operatorname{rank}D^2>0
\tag{20.16}
\]
detects a \(J_3\) string.  It distinguishes
\(J_3\) from \(J_2\oplus J_1\) and \(J_1^{\oplus3}\), although all three have
the same three-dimensional shadow after forgetting \(D\).  Thus the matrix
entries of \(D\) may be forgotten while the exact information needed later is
retained by three small integers, or by one rank under a certified exponent
bound.

The whole profile, unlike the one-bit consumer, is closed under the
characteristic-zero tensor rule: it reconstructs the Jordan partition, and
the Clebsch--Gordan formula (19.12) then computes the tensor profile.  It is
therefore a genuine candidate for `Shadow keep`; (20.16) alone is generally
only a final consumer.

## 20.7 Cyclic rows are reconstructible from Krylov shadows

The Gamma paper already singles out the **row-generated cyclic module**.  A
cyclic module has a stronger sparse reconstruction theorem.

## Theorem 20.3 -- pointed cyclic reconstruction

Let \((M,D,v)\) be a pointed cyclic \(K[t]\)-module of dimension \(n\), with
\(t\) acting by \(D\).  The monic annihilator \(p(t)\) of \(v\) has degree
\(n\), and
\[
(M,D,v)\cong(K[t]/(p),\ t,\ 1)
\tag{20.17}
\]
as a pointed module.  In particular, if \(D\) is nilpotent, cyclicity and the
single number \(n\) force \(p=t^n\) and hence force \(J_n\).  The dual
statement holds for a row that cyclically generates \(M^\vee\).

### Proof

The map \(K[t]\to M\), \(f\mapsto f(D)v\), is surjective by cyclicity.  Its
kernel is a principal ideal \((p)\).  The quotient has dimension
\(\deg p\), so \(\deg p=n\), giving (20.17).  If \(D\) is nilpotent then
\(p\) divides a power of \(t\); being monic of degree \(n\), it is \(t^n\).
∎

There is also a purely scalar version.  Given a vector \(v\), a row
\(\lambda\), and
\[
h_i=\lambda D^i v,
\tag{20.18}
\]
form the \(n\times n\) Hankel matrix \(H=(h_{i+j})_{0\le i,j<n}\).  If
\(H\) is invertible, then the \(2n\) moments
\(h_0,\ldots,h_{2n-1}\) determine the monic relation
\[
p(t)=t^n+c_{n-1}t^{n-1}+\cdots+c_0
\tag{20.19}
\]
by the linear system
\[
H(c_0,\ldots,c_{n-1})^{\mathsf T}
=-(h_n,\ldots,h_{2n-1})^{\mathsf T}.
\tag{20.20}
\]
Nondegeneracy makes the Krylov realization both cyclic and cocyclic, so this
relation reconstructs the pointed realization up to unique similarity.

This suggests a strictly smaller analytic provider target than a full
Stokes-filtered object:

```haskell
data CyclicRowShadow = CyclicRowShadow
  { dimension       :: Nat
  , annihilator     :: MonicPolynomial
  , primaryDeckType :: CyclotomicCharacter
  , rankNormalization :: NonzeroScalar
  }
```

or, when a common point column supplies a nondegenerate pairing, the finite
moment list in (20.18).  Proving that these data cross every threshold may be
easier than constructing an isomorphism of all ambient objects.  It is not
automatic: the incomplete-Gamma and Fourier-boundary countermodels show that
formal monodromy, integrality, or support without the cyclic-row reconstruction
law are insufficient.

## Theorem 20.3A -- dual cyclic rows descend through stable quotients

Let \(R\) be a commutative ring, let \(T\in\operatorname{End}_R(M)\), and let
\(r:M\to L\) be a row.  Suppose \(V\subset M\) is \(T\)-stable and
\(r(V)=0\).  Write \(q:M\to\overline M=M/V\).  Then \(T\) and \(r\) descend
uniquely to \(\overline T\) and \(\overline r\), and pullback along \(q\)
identifies the dual cyclic modules
\[
q^*:C_{\overline T}(\overline r)
\xrightarrow{\ \sim\ }C_T(r).
\tag{20.20a}
\]
In particular, for every \(p\in R[t]\),
\[
\overline r\,p(\overline T)\ne0
\quad\Longleftrightarrow\quad
r\,p(T)\ne0.
\tag{20.20b}
\]
If a deck group stabilizes \(V\), the same result holds after adjoining the
full deck orbits of the rows.

### Proof

The quotient universal property gives
\(\overline r q=r\), and \(T\)-stability gives
\(qT=\overline Tq\).  Hence
\[
(\overline r\,\overline T^k)q=rT^k
\]
for every \(k\).  Pullback on Hom modules is injective because \(q\) is
surjective, and the displayed identities identify the two generated
submodules.  Polynomial linearity proves (20.20b).  Deck stability gives the
same argument orbitwise. ∎

Categorically, this is the elementary law that the contravariant
representable functor \(\operatorname{Hom}(-,L)\) sends the cokernel
\(M\to M/V\) to the kernel of restriction
\(\operatorname{Hom}(M,L)\to\operatorname{Hom}(V,L)\).  The \(T\)-stability
of \(V\) makes that kernel a \(K[t]\)-submodule.  Thus the needed information
was not reconstructed after being forgotten: it already lay in the exact
dual shadow of the quotient.

This is a variance-sensitive zero-mode lemma.  No complementary summand and
no conversion of the row into a column via a pairing is needed.  At the
finite-module level, a \(T\)-stable vanishing-cycle submodule contained in the
kernel of the point row removes no part of the **dual** cyclic row module.
For Rees--Stokes objects, existence of one marked meromorphic family,
strictness of the quotient, finite local freeness, and compatibility of the
two boundary maps remain analytic provider obligations; Theorem 20.3A does
not assert them.

### Corollary 20.3B -- the exact hypothesis for strict decoration

Let the data of Theorem 20.3A live in a \(K\)-linear exact category
\(\mathcal E\) equipped with whatever Rees, connection, deck, or Stokes
decoration is to be retained.  Fix an exact category \(\mathcal E^\vee\) of
decorated rows and a contravariant functor
\(D_L:\mathcal E^{\mathrm{op}}\to\mathcal E^\vee\) whose underlying module
functor is \(\operatorname{Hom}(-,L)\).  Assume that

1. \(0\to V\to M\xrightarrow q\overline M\to0\) is an admissible strict
   exact sequence in that decorated category;
2. \(T\), \(r\), and the deck action are morphisms of the retained
   decoration; and
3. \(D_L\) sends this particular sequence to the strict exact sequence in
   \(\mathcal E^\vee\)

   \[
   0\longrightarrow D_L(\overline M)
   \xrightarrow{q^*}D_L(M)\longrightarrow D_L(V).
   \tag{20.20c}
   \]
4. the row-generated cyclic objects are defined by strict saturation in
   \(\mathcal E^\vee\), these strict saturations exist, and strict
   isomorphisms preserve them.

Then (20.20a) is an isomorphism of decorated cyclic-row objects, not merely
of underlying modules.

Indeed, the proof of Theorem 20.3A takes place inside the strict kernel in
(20.20c), every displayed generator is decoration-compatible, and condition
4 promotes the resulting equality of generated underlying modules to the
required strict cyclic-row subobjects.  This corollary is deliberately
conditional on strict dual exactness and strict saturation.  Finite local
freeness of the underlying quotient does not by itself prove compatibility
with a Stokes filtration or identify the two endpoint boundary maps.  Thus
(20.20c), together with condition 4, is the exact categorical interface an
analytic zero-mode provider must implement; it is not supplied by the
algebraic quotient lemma.

### Corollary 20.3C -- rigid exact categories discharge dual exactness

In Corollary 20.3B, condition 3 is automatic if the retained decorated
category is rigid exact monoidal, dualization is exact, and tensoring by
\(L\) is exact, so that \(D_L=(-)^\vee\otimes L\) is an exact
contravariant functor.  Indeed, such an exact dual sends every admissible
cokernel diagram to an admissible kernel diagram.  This applies to the
finite-dimensional filtered/Stokes setting only after exactness of the
decorated dual and tensor functors has been verified and the proposed
sequence is already known to be strict; it is also the
local algebra behind dualizing a short exact sequence of finite locally free
Rees modules with locally free quotient.

The order of quantifiers matters.  Rigidity does **not** construct the
zero-mode subobject, prove that the quotient remains finite locally free, or
show that a proposed boundary map is strict.  It says only that after those
facts have placed the sequence inside the exact category, the dual-row
descent requires no further analytic theorem.

## 20.8 Consequences for \(m=2\) and higher

The sparse-shadow viewpoint changes the provider question but does not erase
it.

1. The bare functor
   \(\operatorname{Rep}(\boldsymbol\mu_6\times\mathbf G_a)
   \to\operatorname{Rep}(\boldsymbol\mu_6)\) genuinely loses the
   \(J_3\) marker: its fibre contains \(J_3\),
   \(J_2\oplus J_1\), and \(J_1^{\oplus3}\).  Theorem 20.1 fails there.
2. The kernel-profile functor keeps no basis and no matrix entries, yet is
   complete for nilpotent conjugacy and is additive under strict biproducts.
   This is the most compressed operation-level replacement justified here for
   retaining the full \(\mathbf G_a\)-module.
3. On a certified cyclic primary row, dimension plus cyclicity reconstructs
   the whole nilpotent string.  For \(X\times\mathbf P^2\), the desired
   endpoint check can therefore be compressed to a nonzero top Krylov iterate
   or to \(\operatorname{rank}D^2>0\).
4. A common-source optic can transport that sparse row shadow through a
   parallel specialization only when the marked Beck--Chevalley square is
   proved.  Path provenance selects the square; it does not prove the square.
   At a quotient zero mode, however, Theorem 20.3A reduces the internal
   survival check to \(V_t(\mathcal M)\subset\ker r\), together with
   \(T\)- and deck stability; a pairing-based complementary-summand argument
   is unnecessary for the dual consumer.
5. If every low-dimensional center has vanishing top Krylov rank, Theorem
   19.4 may be restated using this sparse rank rather than a full Jordan-block
   object.  The arbitrary-center vanishing and threshold transport remain the
   two substantive gates.

The highest-value next test is therefore not "retain more."  It is:
\[
\boxed{
\text{construct one common realization of the point-row cyclic module, then
test whether its projected row satisfies marked threshold descent}.}
\tag{20.21}
\]
Inside such a common realization, an annihilator or finite Krylov moments may
be enough to certify the desired primary or nilpotent shadow.  Separately
matching those data on two tails is not enough.  If two lifts through the same
proposed shadow have different primary rows, annihilators, or top Krylov
ranks, Theorem 20.1 supplies an exact counterexample and tells us which
residual datum must be restored.

The finite replay now tests kernel-profile reconstruction over every integer
partition through total size eight, exact nilpotent Krylov reconstruction
through size six, the Reader/indexed-State/Writer composition laws, and the
fact that an optic residual--not a path label alone--recovers a parallel
projection.

---

# Module 21. The concrete specialization from here to \(m=2\)

Module 20 shows how information may descend through a sparse shadow.  The
existing all-stabilizations draft identifies the particular shadow needed for
the fivefold case.  It is not the unpointed Jordan partition by itself.  It is
the **pointed formal-monodromy cyclic shadow**.

## 21.1 The specialization chain

At a finite Artin level and fixed ordinary degree, let an ambient marked QDM
object carry:

- half-Tate-normalized formal monodromy \(T\);
- finite ramified deck group \(G\);
- the horizontal Gamma point/rank row \(r\); and
- the Rees connection and Stokes filtration needed to construct strict
  comparison maps.

First take the strict row-generated cyclic saturation
\[
\operatorname{Cyc}(H,T,G,r)
=\operatorname{Sat}^{\mathrm{str}}_H
  \left\langle g(rT^k):g\in G,\ 0\le k<\operatorname{rk}H\right\rangle.
\tag{21.1}
\]
Then use polynomial B\'ezout functional calculus to project to the
primitive-sixth primary factor.  The useful chain is
\[
\mathsf{StokesGamma}^{\mathrm{pointed}}
\xrightarrow{\ \operatorname{Cyc}\ }
\mathsf{CycRees}^{\mathrm{pointed}}_{T,G}
\xrightarrow{\ e_{\zeta_6}(T)\ }
\mathsf{CycPrim}^{\mathrm{pointed}}_{\zeta_6}
\xrightarrow{\ \operatorname{AugRow}\ }
\mathsf{AugPrim}_{\zeta_6},
\qquad
\operatorname{Core}(\mathsf{AugPrim}_{\zeta_6})
\xrightarrow{\ [r\ne0]\ }
\mathbf B_{\mathrm{disc}}.
\tag{21.2}
\]
Here an object of \(\mathsf{AugPrim}_{\zeta_6}\) is the
operator-row arrow
\[
(V,T,L,r:V\to L)
\]
of Theorem 19.3A after primitive-sixth projection.  A comparison is a pair
\((f,\ell)\) with \(fT=T'f\) and \(r'f=\ell r\).  The final Boolean is
\[
b_{\zeta_6}(Y)
=\begin{cases}
1,&r_Ye_{\zeta_6}(T_Y)\ne0,\\
0,&r_Ye_{\zeta_6}(T_Y)=0.
\end{cases}
\tag{21.3}
\]

The Boolean is an isomorphism-class marker on the core, not a functor on the
full preadditive category: a zero morphism can exist between objects with
different Booleans.  Every path comparison used below is an isomorphism in
this core, or in the core of the lawful quotient category.

The first two categories in (21.2) are provider categories.  They retain
analytic structure needed to construct a lawful comparison.  The final two
are consumer categories.  Once comparison has been proved, they forget the
complementary QDM, bases, matrix entries, exact Barnes coefficients, and all
primary factors except \(\zeta_6\).  If a quotient presentation is useful,
one may further divide \(\mathsf{AugPrim}_{\zeta_6}\) by the legitimate
two-sided ideal \(\ker\mathsf{Out}\).  The naked class
\(\{e:r e=0\}\) in an unrestricted matrix category is not used.

## 21.2 What must actually be retained

One compact proved consumer payload is:

1. the primitive-sixth label, with its half-Tate normalization;
2. the row-generated Krylov subspace
   \[
   C_T(r)=\operatorname{span}\{r,rT,rT^2,\ldots\};
   \tag{21.4}
   \]
3. the action of \(T\) on that subspace, only far enough to form
   \(e_{\zeta_6}(T)\);
4. the distinguished Euler-rank row line \(Kr\), with any convenient nonzero
   normalization; and
5. a certificate that every mapped path intertwines \(T\) and satisfies
   \(r_{\mathrm{target}}f=\ell r_{\mathrm{source}}\) for an invertible output
   scalar \(\ell\).

The provider temporarily retains more:

6. strict Rees--Stokes saturation and deck action;
7. one common equivariant input and derivative frame;
8. compatible Artin reductions; and
9. at a zero mode, the reduced nearby-cycle object and proof that its
   variation-generated submodule is \(T\)- and deck-stable, is annihilated by
   the point row, and admits compatible strict boundary maps.

This distinction matters.  The Boolean (21.3) is enough to state the
obstruction but not enough to manufacture or compose threshold maps.  The
two-tail counterexample in the all-stabilizations draft shows that matching
recurrences or tailwise holonomicity do not produce one common continuation.

The nilpotent kernel profile of Module 20 is an optional parallel consumer:
it can detect a coherent \(J_3\) refinement when such an operation has been
constructed.  It is **not required** for the point-row Boolean (21.3), whose
operator is formal monodromy \(T\) and whose purpose is spectral support, not
Jordan length.

## 21.3 The required parallel projection

At a nonzero sign or stability threshold the optic has one middle object:
\[
\begin{array}{ccccc}
&& (\mathcal K_j,\mathfrak r_j,T_j) &&\\
&\swarrow\scriptstyle{\operatorname{res}^-}&&
  \searrow\scriptstyle{\operatorname{res}^+}&\\
(K_j^-,r_j^-,T_j^-)&&&& (K_j^+,r_j^+,T_j^+).
\end{array}
\tag{21.5}
\]
The residual in the sense of Module 20.5 is the common marked object
\((\mathcal K_j,\mathfrak r_j,T_j)\) together with the oriented path between
its boundary restrictions.  Parallel transport gives
\[
\Phi_j:K_j^-\xrightarrow{\sim}K_j^+,
\qquad
\Phi_jT_j^-=T_j^+\Phi_j,
\qquad
c_j\in K^\times,
\qquad
r_j^+\circ\Phi_j=c_jr_j^-.
\tag{21.6}
\]
Polynomial naturality then gives
\[
r_j^+e_{\zeta_6}(T_j^+)\Phi_j
=c_jr_j^-e_{\zeta_6}(T_j^-),
\tag{21.7}
\]
so the Boolean crosses the threshold.

At a zero-mode rank change, the middle object in (21.5) must be replaced by
the **row-generated reduced nearby-cycle module**.  Theorem 20.3A shows that
the internal quotient step needs no chosen complement: if the
variation-generated submodule \(V_t(\mathcal M_j)\) is \(T\)- and deck-stable
and the common point row annihilates it, the entire dual cyclic row descends
unchanged to the quotient.  This removes the additional pairing-based demand
to prove that a column realization has zero intersection with \(V_t\).

It does not construct the common meromorphic family or its boundary maps.
The two adjacent tails must still enter that one receiver through strict
row-line-compatible specializations which reflect the projected-row
nonvanishing.  Isomorphisms of the dual cyclic row modules are sufficient; a
carrier epimorphism with invertible output-line map is another sufficient
finite-module condition.  A span of ambient modules of unequal rank, or two
separately chosen cyclic models with the same annihilator, does not suffice.

Consequently, a one-object Gamma/window theorem which identifies
\(V_t(\mathcal M_j)\) with a strict module generated by wall-supported
classes would have a shorter implication for this consumer than for a
column-framed invariant.  Euler orthogonality of the common-open skyscraper
would give \(r(V_t)=0\), and Theorem 20.3A would then descend the dual cyclic
row without an additional spanning hypothesis.  This is a conditional
reduction of the zero-mode gate, not a proof that the Gamma/window object or
its strict boundary maps exist.

The residual is expected to come from the point of the common birational
open.  Algebraically, its skyscraper class defines the Euler rank row, and
exceptional Orlov summands supported away from that point are orthogonal to
it.  Identifying this algebraic row with the intrinsic large-radius
Gamma/Stokes row through an arbitrary wall is **not** formal; it is precisely
part of the provider theorem.  Once that theorem holds, the common-source
lift retains provenance that the unmarked formal spectrum appears to forget.

## 21.4 The path functor for the fivefold proof

The desired map of path types is
\[
\mathsf{CobPath}_5
\xrightarrow{\ F_{\mathrm{cyc}}\ }
\mathsf{Path}
  \left(\mathsf{AugPrim}_{\zeta_6}\right).
\tag{21.8}
\]
A Włodarczyk/VGIT threshold path is sent to the comparison (21.6), or to
its reduced-nearby-cycle analogue.  The accompanying shadow transformation
sends the orbit-cylinder point class to the row-generated cyclic module.
Its pseudonaturality square is exactly (21.7).

The preferred construction lands directly in row-line-compatible
isomorphisms of \(\mathsf{AugPrim}_{\zeta_6}\); Theorem 19.3A then composes
them.  If the provider first supplies an additive retained-shadow functor and
the transitions become invertible only after killing its kernel, Theorem
19.3 supplies an optional quotient.  A raw row-null class in unrestricted
linear maps supplies neither construction.  Proposition 20.1A then pulls the
target Boolean back to a path-invariant marker on fivefold cobordisms.

In software form the essential method is:

```haskell
data PointedPrimary = PointedPrimary
  { character  :: PrimitiveCharacter
  , monodromy  :: Endomorphism
  , pointRow   :: Row
  , cyclicCert :: CyclicSaturationCertificate
  }

mapPath :: CobordismPath y0 y1
        -> CyclicPath (PrimaryShadow y0) (PrimaryShadow y1)

mapShadow :: MarkedQDM y -> PointedPrimary y

naturality :: mapShadow (transportQDM p q)
           ~= transportCyclic (mapPath p) (mapShadow q)
```

The augmented-row retained-output functor, primitive character, coefficient
spine, common input frame, and path translator live in Reader.  Any global
kernel ideal is derived from that functor.  The current pointed cyclic module
lives in indexed State.  The finite ordered comparison stays in the
certificate; only discharged support and rank-nullity facts enter the
commutative Writer.

## 21.5 Endpoint contrast for \(m=2\)

The endpoint computation is already unconditional.  Quantum K\"unneth gives
three copies of each cubic primitive-sixth line on
\(X\times\mathbf P^2\), and multiplicativity of the Gamma framing makes the
point row nonzero on that primary packet.  Thus
\[
b_{\zeta_6}(X\times\mathbf P^2)=1.
\tag{21.9}
\]
Every formal factor of \(\mathbf P^5\) has normalized exponent zero, so
\[
b_{\zeta_6}(\mathbf P^5)=0.
\tag{21.10}
\]
If (21.8) exists for the unknown birational map supplied by a hypothetical
rationality of \(X\times\mathbf P^2\), Proposition 20.1A makes (21.9) and
(21.10) equal, a contradiction.

## 21.6 Why this beats the unmarked and \(J_3\)-only routes

The decisive regression is
\[
\operatorname{Bl}_X\mathbf P^5.
\tag{21.11}
\]
The unmarked rational side can acquire the same primitive-sixth packet from
the cubic threefold center.  Hence multiplicity and every other positive
constituent-additive marker fail exactly as Theorem 19.2 predicts.

The point row is designed to distinguish **where the packet lands**.
Exceptional classes have algebraic ambient rank zero, equivalently they pair
trivially with the skyscraper of a point in the common open.  Under the
missing Gamma/Stokes row-line provider, they may survive as unmarked blocks
while mapping to zero under (21.3).  This is the key proposed example of
information which appears forgotten in a local spectrum but is retained by a
higher common source and recovered through a parallel pointed projection.

The two current \(m=2\) routes therefore have different gates:

| route | retained specialization | advantage | unresolved gate |
| --- | --- | --- | --- |
| pointed Gamma/rank | augmented row arrow \((C_T(r),T,L,r)_{\zeta_6}\) | row-line rescaling is harmless; exceptional cubic-center packets are predicted to be invisible; uniform in \(m\) | construct the one-object row-line-compatible threshold and zero-mode parallel projections for arbitrary admissible masters |
| operation/Jordan | primitive-sixth \(K[N]\)-module or kernel profile | no Gamma row in final cancellation; \(J_3\) is a sharp \(m=2\) object | construct strict \(N\)-transport and prove no threefold center supplies the forbidden \(J_3\) carrier |

The pointed Gamma/rank route is presently higher value because its marking
was designed for the concrete fivefold self-carrier (21.11).  The Jordan
route remains useful as an independent specialization and as a diagnostic of
which extension information the unmarked spectrum destroys.

## 21.7 A smaller but still legitimate threshold target

The full ambient QDM need not cross a threshold.  It is enough to construct
one common marked cyclic object whose boundary restrictions satisfy (21.6).
Within that object, it is enough for the \(\zeta_6\)-projected row itself to
survive.  A sufficient local normal form--not an equivalent characterization
of every row-preserving automorphism--is
\[
1+v\otimes\lambda,
\qquad r(v)=0,
\tag{21.12}
\]
in one common receiver, with the displayed shear invertible and
\(T\)-compatible.  Then the row fixes that factor directly.  More generally,
the exact condition is the augmented-row square (21.6), and finite
composition follows from Theorem 19.3A.

When a common column gives the nondegenerate realization of Theorem 20.3,
finite Krylov moments can serve as a certificate **inside this common
object**.  Equality of separately computed moment lists on the two tails is
not enough.  The current compact credible target for \(m=2\) is therefore:

\[
\boxed{
\begin{gathered}
\text{one common row-generated Rees object at each threshold,}\\
\text{one global row-line-compatible retained-output functor,}\\
\text{and one path functor satisfying (21.7).}
\end{gathered}}
\tag{21.13}
\]

This formulation does not prove the missing analytic theorem.  It removes
irrelevant ambient structure from its statement and identifies exactly which
parallel projection must retain the information needed for \(m=2\).

The finite replay includes the endpoint shadow of this specialization: six
unmarked primitive-sixth lines on \(X\times\mathbf P^2\) collapse to the
single nonzero pointed Boolean, \(\mathbf P^5\) gives zero, and adding an
arbitrary primitive-sixth block killed by the point row changes the unmarked
count without changing the pointed marker.

## 21.8 Internal source audit

The specialization in this module is extracted from, and was checked against,
the following complete local source files.  It is a reorganization of their
proved endpoint and conditional transport interface, not a promotion of the
missing threshold theorem.

| source | role | SHA-256 |
| --- | --- | --- |
| `papers/cubic-stabilization-irrationality/sections/01-introduction.tex` | fivefold self-carrier obstruction and point-row Boolean | `6bc03390ed53c42a19db8e50428c455df1cb087ae06ba496416c9709b7285b50` |
| `papers/cubic-stabilization-irrationality/sections/08-global-transport.tex` | finite dual cyclic Rees module, marked threshold and zero-mode hypotheses, cyclic-row support, conditional birational invariance | `92a45fdc9f2e9046795570ba129562c1c27d1bcbcaf963aa49376505381e1ae8` |
| `papers/cubic-stabilization-irrationality/sections/09-cubic-endpoint.tex` | primitive-sixth Barnes row and projective-stabilization endpoint contrast | `3421b4bc17f13af73696c1366869ddc0aeefa7d5595beac89126530b8542626b` |
| `notes/cubic-threefolds-tasks/c907-solver-dossier.md` | rank-row strategy, failure models, and current analytic gate | `0e4fcedb4513c4c4ecf61d2ea68e5102133d4191fe3a952d4f63cf1468702958` |
| `notes/cubic-threefolds-tasks/c907-quantum-monodromy-stabilization.md` | \(m=2\) route comparison and minimal \(K[N]\) alternative | `a9b65f9155bc0501846a87c2ffac47f52607e6596a800444308c89c9c0b115b2` |
| `notes/2026-08-13-c907-coniveau-principal-symbol-repair.md` | exceptional-cusp point symbol, exact rank reduction, cubic/split-CI pilots, and fixed-phase gap | `f478acc6d85ac83f0ede0f5b8ab328c70c619488360c3070a20d98584af3a1fe` |
| `notes/2026-08-13-c907-formal-point-covector-frame-gap.md` | two-completion obstruction and one-row large-radius-to-cusp reduction | `736360a5a231157ff953d24ab4218800c5e882450960fbf761a466e515275d97` |

## 21.9 Iritani 2026: useful specialization, not the missing row theorem

Hiroshi Iritani's 2026 note *Notes on the decomposition theorem for blowups*
(arXiv:2604.10028v2) adds two unconditional structures to the formal blowup
decomposition:

1. the coordinate changes and decomposition maps are defined over the stated
   cyclotomic extensions and the center branches are related by cyclotomic
   monodromy; and
2. they are equivariant for the universal Hodge group, hence preserve the
   complexified Hodge-class subspaces and, by the same construction, the
   algebraic-class subspaces.

This gives a lawful Hodge--cyclotomic specialization of the modular compiler.
It does not give Gamma-integral, \(K\)-theoretic, Orlov, Euler-rank-row, or
common-open point compatibility.  Every Tate direction is Hodge-fixed, so
Hodge equivariance cannot distinguish the ambient point direction from
exceptional Tate directions.  The finite replay includes an exact
pairing-preserving, operator-intertwining Tate shear that moves the point row.

The explicit initial asymptotics do prove one useful local statement.  For
\(\varphi:\widetilde Y\to Y\) the blowup along a proper center \(i:Z\to Y\),
\[
\Psi_Y(\varphi^*[p_Y])=[p_Y]+O(\mathfrak q^{-1}),
\qquad
\operatorname{in}\!\left(q_{Z,j}^{-1}
\Psi_{Z,j}(\varphi^*[p_Y])\right)=i^*[p_Y]=0.
\tag{21.14}
\]
Thus the cohomological point column is pure in the exceptional-cusp
principal symbol.  This is not the intrinsic large-radius Gamma point row:
the two frames live at \(\mathfrak q=\infty\) and \(\mathfrak q=0\),
respectively, and the formal theorem supplies no continuous identification of
their solution completions.  The missing datum is the center coefficient of
that frame-change matrix, branch by branch.

Consequently the 2026 theorem strengthens the available unmarked
Hodge--cyclotomic specialization and confirms the local cusp shadow, but it
does not evade Theorem 19.2 or close the augmented-row provider gate for
\(m=2\).

## 21.10 Direct blowup path: no master or zero mode required

There are two distinct ways to supply the conditional path functor in
Module 21.4.  The gauged-master route passes through thresholds and therefore
needs the zero-mode analysis above.  Weak factorization itself suggests a
smaller direct route.

## Theorem 21.1 -- direct augmented-row blowup criterion

Fix a primary polynomial \(e_{\zeta_6}\) on a common normalized coefficient
spine.  Suppose that for every smooth blowup
\(\varphi:\widetilde Y=\operatorname{Bl}_Z Y\to Y\) occurring in a weak
factorization, the analytic continuation of Iritani's blowup decomposition
induces an isomorphism in \(\mathsf{AugPrim}_{\zeta_6}\)
\[
\left(V_{\widetilde Y},T_{\widetilde Y},K,r_{\widetilde Y}\right)
\xrightarrow{\ \sim\ }
\left(
V_Y\oplus\bigoplus_{j=0}^{c-2}V_{Z,j},
T_Y\oplus\bigoplus_jT_{Z,j},
K,
c_\varphi(r_Y,0,\ldots,0)
\right)
\tag{21.15}
\]
for some \(c_\varphi\in K^\times\).  Then
\[
b_{\zeta_6}(\widetilde Y)=b_{\zeta_6}(Y).
\tag{21.16}
\]
Consequently \(b_{\zeta_6}\) is invariant along the entire weak
factorization.  In particular, the endpoint contrast (21.9)--(21.10) implies
that \(X\times\mathbf P^2\) is irrational.

### Proof

Theorem 19.3A and polynomial naturality identify nonvanishing of the
projected row on the two sides of (21.15).  The exceptional coordinates have
zero row, so the right-hand Boolean is exactly \(b_{\zeta_6}(Y)\).  Invert the
same augmented-row isomorphism for a backward weak-factorization arrow and
compose along the finite path.  The endpoint contradiction is immediate. ∎

Theorem 21.1 is conditional.  Its statement names fewer intermediate
structures than the gauged-master package:

- it needs no arbitrary-master gauged admissibility;
- it needs no threshold atlas, reduced nearby cycles, or zero-mode theorem;
- it needs no global ideal or quotient; and
- it permits a nonzero scalar rescaling \(c_\varphi\).

This is a comparison of interface fields, not a proved logical ordering of
hypotheses.  Constructing the end-to-end analytic continuation in (21.15)
may require the same Stokes or zero-mode analysis hidden inside a different
provider.

Its sole analytic input is still substantial: identify the intrinsic
large-radius Gamma row with the exceptional-cusp formal decomposition and
prove that every exceptional primitive-sixth branch has ambient row zero.
Equation (21.14) proves only cusp-frame point purity.  The cubic-center and
split-nef codimension-two Kummer calculations verify the first nonvacuous
pilots; arbitrary nonsplit normal bundles and arbitrary smooth centers remain
open.  Thus Theorem 21.1 sharpens the direct \(m=2\) landing without claiming
the missing one-row blowup theorem.

## 21.11 K-theoretic forcing of the missing blowup row

The row part of (21.15) is formal once the analytic blowup comparison is
known to lift the Orlov \(K\)-theory decomposition.  This separates the
remaining analytic content from the elementary rank calculation.

### Theorem 21.2 -- an Orlov-compatible Gamma lift forces point-row purity

Let \(\varphi:\widetilde Y=\operatorname{Bl}_Z Y\to Y\) be the blowup of a
smooth center of codimension \(c\ge2\).  Write

\[
\Theta_K:K_0(Y)\oplus\bigoplus_{j=0}^{c-2}K_0(Z)
\xrightarrow{\ \sim\ }K_0(\widetilde Y)
\tag{21.17}
\]

for the \(K_0\)-isomorphism induced by Orlov's blowup decomposition: the
first component is \(L\varphi^*\), and every other component is a pushforward
from the exceptional divisor.  Suppose:

1. Gamma integral-structure maps \(\Psi_Y,\Psi_Z,\Psi_{\widetilde Y}\) span
   the corresponding solution spaces after scalar extension;
2. the point rows satisfy
   \(r_W\Psi_W(a)=u_W\operatorname{rk}_W(a)\), with \(u_W\ne0\); and
3. an analytic blowup isomorphism
   \(A:V_{\widetilde Y}\to V_Y\oplus\bigoplus_jV_{Z,j}\) makes the square

   \[
   A\Psi_{\widetilde Y}\Theta_K
   =D\bigl(\Psi_Y\oplus\textstyle\bigoplus_j\Psi_Z\bigr)
   \tag{21.18}
   \]

   commute, where \(D\) is block diagonal and acts on the ambient block by
   a nonzero scalar.

Then, after harmless normalization of the row lines,

\[
r_{\widetilde Y}
=c_A(r_Y,0,\ldots,0)A
\qquad(c_A\in K^\times).
\tag{21.19}
\]

### Proof

For \(a\in K_0(Y)\), derived pullback preserves generic rank:

\[
\operatorname{rk}_{\widetilde Y}(L\varphi^*a)
=\operatorname{rk}_Y(a).
\]

Every exceptional Orlov component is represented by a complex supported on
the exceptional divisor, so it has generic rank zero on \(\widetilde Y\).
Consequently

\[
\operatorname{rk}_{\widetilde Y}\Theta_K
=(\operatorname{rk}_Y,0,\ldots,0).
\tag{21.20}
\]

Apply the rows to (21.18) and use hypotheses 2 and (21.20).  The two
functionals agree up to the nonzero ambient normalization.  Hypothesis 1
extends this equality from the Gamma lattice to the whole solution space,
which is (21.19). ∎

This theorem is not the missing provider.  Iritani's formal QDM
decomposition gives the underlying \(A\) at the exceptional cusp, while
Orlov gives (21.17), but the audited sources do not prove the
Gamma/integral-structure square (21.18) after analytic continuation from the
large-radius frame.  Theorem 21.2 gives one clean sufficient naturality
package for Theorem 21.1: an Orlov-compatible Gamma lift, rather than a
separate calculation of every exceptional row or a global marked-threshold
theorem.  It is not the smallest possible provider.  The C907 shadow audit
isolates the strictly weaker one-row Stokes/window statement
\(r(T-1)=0\); a full commuting Gamma--Orlov square implies that statement but
is not known, and should not be presented as necessary.

The proof only used an additive character \(\epsilon\) satisfying

\[
\epsilon_{\widetilde Y}\Theta_K
=(a\epsilon_Y,0,\ldots,0),\qquad a\ne0.
\tag{21.21}
\]

Hence the same forcing lemma applies to any support-null character: generic
rank, restriction to the common open followed by rank, the top-dimensional
generic-stalk character, or a localizing additive invariant followed by a
functional that kills the boundary-supported subcategory.  In software
language, (21.21) is the getter law; (21.18) is the path-map naturality law.
The higher \(K\)-theory/SOD path retains the value that the bare QDM
projection forgot, and the Gamma square reads it back without choosing a
complement.

The resulting categorical spine is the commutative diagram

\[
\begin{CD}
K_0(Y)\oplus K_0(Z)^{\oplus(c-1)} @>{\Theta_K}>> K_0(\widetilde Y)\\
@V{\Psi_Y\oplus\Psi_Z^{\oplus(c-1)}}VV
 @VV{\Psi_{\widetilde Y}}V\\
V_Y\oplus V_Z^{\oplus(c-1)} @<{A}<< V_{\widetilde Y}\\
@V{(\operatorname{rk},0)}VV @VV{r_{\widetilde Y}}V\\
K @= K,
\end{CD}
\tag{21.22}
\]

where the harmless block normalization \(D\) from (21.18) is suppressed.
The upper square is the unproved provider; the lower triangle is Theorem
21.2.  Thus the diagram displays rather than hides the exact missing edge.

## 21.12 Provider morphisms and non-implications

The competing routes fit into the implication diagram

\[
\begin{CD}
\mathsf{GammaOrlovSquare}
 @>>> \mathsf{DirectAugBlowup}\\
 @. @VVV\\
\mathsf{TwoWallRankQuotient}
 @>>> \mathsf{RowStabilizerPath}
 @>>> \mathsf{BooleanInvariant}.
\end{CD}
\tag{21.23}
\]

The top arrow is Theorem 21.2, the right vertical arrow is Theorem 21.1,
and the bottom-left arrow is the common-open/rank-zero-target Stokes lemma.
The bottom route needs only the aggregate transition at each incompatible
pair of incident receivers; it need not lift every arrow to an integral
Gamma square.

None of the displayed arrows may be reversed formally.  For example, with
\(r=(1,0)\), every matrix

\[
T_{a,b}=\begin{pmatrix}1&0\\a&b\end{pmatrix},\qquad b\ne0,
\]

preserves \(r\), while the action on \(\ker r\) is invisible to the row and
cannot reconstruct a Gamma--Orlov lift.  Conversely, an aggregate path can
preserve \(r\) by cancellation even when its individual factors do not:

\[
U=\begin{pmatrix}1&1\\0&1\end{pmatrix},\qquad
U^{-1}=\begin{pmatrix}1&-1\\0&1\end{pmatrix},\qquad
rU\ne r,\quad rUU^{-1}=r.
\tag{21.24}
\]

Thus a theorem only at the final Boolean level cannot be silently promoted
to edgewise marked compatibility.  Diagram (21.23) is also the modular
choice point: the caller may provide rich integral lifts, direct augmented
arrows, or only the smallest common-open row quotient, and the downstream
Boolean consumer is unchanged.

## 21.13 Multi-sector reconstruction from sparse Stokes shadows

There is one precise way in which parallel projections can recover a block
that no single sector sees conservatively.

### Theorem 21.3 -- jointly separating half-space shadows recover the zero block

Let \(\Phi\) be a finite subset of a real vector space containing \(0\), and
let

\[
W=\bigoplus_{\phi\in\Phi}W_\phi.
\]

For a real linear functional \(\lambda\), put

\[
F_\lambda^{\le0}W
=\bigoplus_{\lambda(\phi)\le0}W_\phi.
\tag{21.25}
\]

If a finite family \(\Lambda\) satisfies

\[
\forall\phi\ne0\quad\exists\lambda\in\Lambda
\quad\lambda(\phi)>0,
\tag{21.26}
\]

then

\[
\bigcap_{\lambda\in\Lambda}F_\lambda^{\le0}W=W_0.
\tag{21.27}
\]

Indeed, the \(W_0\)-summand belongs to every half-space shadow.  Condition
(21.26) excludes every other summand from at least one of them. ∎

This is a finite-limit reconstruction theorem: the inclusions
\(F_\lambda^{\le0}W\hookrightarrow W\) form a jointly monic family whose
pullback is exactly \(W_0\).  A single shadow is normally insufficient,
because it retains every strictly decaying exponential on that ray.

For a Stokes-filtered local system, apply the theorem on the **dual** formal
solution space, where the Gamma point row is a section.  The normalized
ambient exponent is \(0\), and the exceptional blowup exponents are the
nonzero elements of \(\Phi\).  If one can

1. map a finite set of sectorial paths to one common dual fiber coherently;
2. supply a simultaneous splitting, or an equivalent Beck--Chevalley
   comparison, identifying the transported Stokes subspaces with the formal
   half-space subspaces (21.25);
3. prove that the continued Gamma point section lies in
   \(F_\lambda^{\le0}\) for every chosen direction; and
4. choose directions satisfying (21.26),

then (21.27) forces point-row purity without computing any Stokes
multiplier.  The path maps in item 1 are the requested functor between path
types; the transported section is indexed State, and the intersection is
the lens getter from the family of Reader-supplied sectorial orders.

Coherent path transport alone does not supply item 2.  For instance, with
\(W=Ke_0\oplus Ke_1\), the formal shadows
\(Ke_0\subset W\) have intersection \(Ke_0\), but a Stokes shear can replace
the first inclusion by \(K(e_0+e_1)\subset W\).  Their transported
intersection is then \(K(e_0+e_1)\), which retains a nonzero exceptional
component.  The shear is exactly the optic residual that the bare path map
forgot.

Only the finite reconstruction theorem is unconditional.  For an arbitrary
smooth blowup, items 2--3 are genuine analytic assertions.  The split-nef
Kummer calculation proves it in its pilot cases because the normalized
point solution is polynomial.  For a split negative normal degree, the raw
slice \((e^R-1)/R\) leaves a nonzero \(e^{-R}/R\) branch after normalization,
so one cannot assert the required multi-sector moderation.  In the nonsplit
case the relative-cap point-purity lemma would supply items 2--3, but that
lemma is currently open.  Thus Theorem 21.3 is a new alternative interface
for the same missing analytic content, not an \(m=2\) proof.

## 21.14 A holonomic/Fourier specialization of the same reconstruction law

The multi-sector criterion has a useful exact analytic avatar.

### Theorem 21.4 -- global polynomial growth forces punctual exponential support

Let \(E\) be a finite-dimensional complex vector space and let

\[
f(z)=\sum_{\phi\in\Phi}p_\phi(z)e^{\phi z},
\tag{21.28}
\]

where \(\Phi\subset\mathbf C\) is finite and every \(p_\phi\) is an
\(E\)-valued polynomial.  Suppose that on every ray
\(z=re^{i\theta}\), the function \(f\) has polynomial growth as
\(r\to+\infty\).  Then \(p_\phi=0\) for every \(\phi\ne0\); equivalently,
\(f\) is a polynomial.

### Proof

Assume some nonzero exponential remains.  The finite polytope
\(\operatorname{conv}(\{0\}\cup\{\phi:p_\phi\ne0\})\) has a nonzero exposed
vertex \(\phi_0\).  Choose \(\theta\) so that
\(\operatorname{Re}(e^{i\theta}\phi)\) has a unique positive maximum at
\(\phi_0\).  After applying a linear functional on \(E\) which does not kill
the leading coefficient of \(p_{\phi_0}\), the \(\phi_0\)-term dominates
all other terms by an exponential factor on that ray.  It cannot have
polynomial growth, a contradiction. ∎

### Corollary 21.4A -- rational coefficients and finitely many test rays

The same conclusion holds when the nonzero \(p_\phi\) are \(E\)-valued
rational functions: choose the exposing ray away from their finitely many
poles.  After a scalar functional has selected a nonzero coordinate, a
rational coefficient has a nonzero Laurent leading term at infinity, hence
only polynomial growth or decay; it cannot cancel exponential domination.
This includes coefficients such as \(1/R\) in the negative-degree pilot.

Moreover, for a fixed finite candidate set \(\Phi\), polynomial growth need
only be tested on finitely many rays.  For every nonempty subset
\(S\subseteq\Phi\setminus\{0\}\), choose one direction which has a unique
positive maximum at a nonzero exposed vertex of
\(\operatorname{conv}(\{0\}\cup S)\).  The resulting finite family contains
an exposing ray for the actual nonzero support, whatever subset it is.

This is a finite analytic certificate only after one global function with
candidate support contained in \(\Phi\) has been constructed.  Unrelated
sectorial germs do not meet the premise, and the corollary supplies neither
their gluing nor their growth estimates.

Under Fourier--Laplace transform, (21.28) is the solution generated by a
finite-length holonomic object supported on \(\Phi\); Theorem 21.4 says that
global polynomial growth forces that support to be punctual at the ambient
exponent \(0\).  Thus another lawful specialization of the modular packet is

\[
\mathsf{ExpHol}
\xrightarrow{\ \operatorname{FL}^{-1}\ }
\mathsf{Hol}_{\mathrm{fin}}(\mathbf A^1)
\xrightarrow{\ \Gamma_{\{0\}}\ }
\mathsf{Vect},
\tag{21.29}
\]

where the middle functor takes the punctual subobject supported at zero.
Finite support itself is only lax under addition or convolution because top
coefficients can cancel.  Its convex-hull/Newton polytope is monoidal under
convolution over a domain, while the associated-graded face retained in
Theorem 21.5 records the coefficients needed to detect cancellation.

For the blowup problem this is again a conditional interface.  One would
need the normalized Gamma point channel, coefficientwise in the retained
Novikov variables, to have the finite exponential-polynomial form (21.28)
and polynomial growth on a separating set of rays.  The split-nef Kummer
pilot has exactly this form.  The negative-degree tail \(e^{-R}/R\) violates
the growth premise, and no audited source proves the required punctual
Fourier support for arbitrary relative caps.  The theorem therefore gives a
sharp falsifier and a possible holonomic specialization, not the missing
provider.

### Theorem 21.5 -- exposed exponential faces form a filtered-monoidal shadow

Let \(k\) be an integral domain, let \(\Gamma\) be a torsion-free abelian
group, and consider its finite-support group algebra \(k[\Gamma]\).  For an
additive weight (group homomorphism) \(w:\Gamma\to\mathbf R\) and nonzero
\(f=\sum_\gamma a_\gamma[\gamma]\), define

\[
\nu_w(f)=\max_{a_\gamma\ne0}w(\gamma),\qquad
\operatorname{in}_w(f)
=\sum_{w(\gamma)=\nu_w(f)}a_\gamma[\gamma].
\tag{21.30}
\]

Put \(\nu_w(0)=-\infty\), with the usual extended-addition convention, and
\(\operatorname{in}_w(0)=0\).  For nonzero \(f,g\),

Then

\[
\nu_w(fg)=\nu_w(f)+\nu_w(g),\qquad
\operatorname{in}_w(fg)
=\operatorname{in}_w(f)\operatorname{in}_w(g).
\tag{21.31}
\]

For sums,

\[
\nu_w(f+g)\le\max\{\nu_w(f),\nu_w(g)\},
\tag{21.32}
\]

If \(\nu_w(f)=\nu_w(g)\), the inequality is strict exactly when
\(\operatorname{in}_w(f)+\operatorname{in}_w(g)=0\).  If their top weights
are unequal, the inequality is an equality.  These are the standard
associated-graded laws for the weight filtration.  Indeed, the supports of
\(f\) and \(g\) generate a finitely generated torsion-free subgroup of
\(\Gamma\), hence a free abelian group; its group algebra over \(k\) is a
domain, so the product of two nonzero initial forms is nonzero.  Additivity of
\(w\) then gives (21.31).

Thus the exposed-face assignment is a multiplicative filtered shadow on
group-algebra elements.  It becomes a filtered-monoidal specialization only
after a category and its action on morphisms have separately been specified;
no such categorical upgrade is used here.  Reader supplies \(w\), indexed
State stores the current support face, and Writer records the exact
initial-form identities discharged under addition.  Applied to a relative
degeneration, no lower-weight gluing channel can cancel a forbidden exposed
exponential.  One must group precisely the channels on the same top face and
prove their initial forms sum to zero.

The domain hypothesis is load-bearing.  A cohomology-valued degeneration
may have zero divisors, so (21.31) should be applied only after the scalar
point-row pairing, or after passage to a coefficient domain on which the
relevant initial forms remain nonzero.

For the normalized negative-degree pilot

\[
\frac{1-e^{-R}}{R},
\]

the forbidden \(-1\) exponential has nonzero exposed coefficient
\(-1/R\) in the ray where it grows.  Consequently any relative-cap proof
must exhibit another top-face channel with the opposite coefficient; a
formal support or lower-order argument cannot suffice.  This turns the open
relative-cap lemma into a finite associated-graded cancellation target at
each retained Novikov coefficient, while making no claim that the
cancellation holds.

## 21.15 The comma-bridge theorem for parallel retained paths

The higher-support path and the QDM path can be combined without pretending
that either determines the other.

Let \(\mathcal A\) be a category of retained objects (for example numerical
\(K\)-theory with a support recollement), let \(\mathcal Q\) be a category of
operator objects, and let

\[
R:\mathcal A\to\mathsf{Vect}_K,
\qquad
S:\mathcal Q\to\mathsf{Vect}_K
\]

be realization functors.  A **bridge object** is

\[
(a,q,\gamma_a:R(a)\twoheadrightarrow S(q),
  \epsilon_a:R(a)\to L_a)
\tag{21.33}
\]

with \(\ker\gamma_a\subseteq\ker\epsilon_a\).  Thus \(\epsilon_a\) descends
uniquely to a row \(r_a:S(q)\to L_a\).  A bridge morphism
\((u,f,\ell):(a,q,\gamma_a,\epsilon_a)\to
(b,q',\gamma_b,\epsilon_b)\) satisfies

\[
S(f)\gamma_a=\gamma_bR(u),
\qquad
\epsilon_bR(u)=\ell\epsilon_a.
\tag{21.34}
\]

### Theorem 21.6 -- bridge naturality forces the augmented row law

Every bridge morphism satisfies

\[
r_bS(f)=\ell r_a.
\tag{21.35}
\]

If \(f\) also intertwines the retained operators, it is therefore a morphism
of \(\mathsf{AugOp}_K\).  Bridge morphisms compose, and the induced
augmented-row construction is functorial.

### Proof

Precompose the desired identity with the epimorphism \(\gamma_a\):

\[
r_bS(f)\gamma_a
=r_b\gamma_bR(u)
=\epsilon_bR(u)
=\ell\epsilon_a
=\ell r_a\gamma_a.
\]

Epimorphy gives (21.35), and composition is the ordinary comma-category
calculation. ∎

This is the exact categorical version of reading forgotten information from
a higher parallel projection.  Useful choices of \(\mathcal A\) include:

| retained path \(\mathcal A\) | output \(\epsilon\) | data still required in \(\gamma\) |
|---|---|---|
| Orlov numerical \(K_0\) | generic rank | Gamma/integral compatibility with the QDM comparison |
| recollement \(\operatorname{Perf}_D(Y)\to\operatorname{Perf}(Y)\to\operatorname{Perf}(U)\) | common-open rank | a QDM realization of the localization square |
| finite-support holonomic/Fourier object | punctual zero-exponent component | identification of the normalized Gamma channel with the Fourier realization |
| strict nearby/vanishing-cycle object | dual row on the quotient | strict boundary maps and row-nullity of vanishing cycles |

Reader carries \((R,S,\epsilon)\) and the bridge laws; indexed State carries
the current pair \((a,q)\); the optic residual is \(\gamma\); Writer records
support-null and strictness certificates.  Forgetting \(\gamma\) leaves two
parallel paths but destroys (21.35), exactly as the Stokes graph countermodel
shows.

The theorem does not build a bridge.  For \(m=2\), a pseudonatural family of
the first or second row of the table along arbitrary weak factorization would
prove the required augmented-row path theorem.  Constructing that family is
the same one-row Gamma/common-open provider already isolated above, now
expressed without any ideal or zero-mode ambiguity.

## 21.16 What scales to \(m>2\)

The comma-bridge theorem separates a dimension-free implication from the
dimension-sensitive provider search.

### Corollary 21.7 -- a rank bridge for all blowups proves all stabilizations

Assume that for every smooth blowup in every relevant dimension there is a
pseudonatural bridge of Theorem 21.6 whose high retained path is Orlov
numerical \(K_0\), whose output is generic rank, and whose QDM side
intertwines the normalized formal monodromy.  Then the pointed
primitive-sixth row Boolean is a birational invariant in every dimension.
Combined with
the audited endpoint calculation, this proves the irrationality of
\(X\times\mathbf P^m\) for every \(m\ge1\).

The proof is dimension-free: every exceptional Orlov functor has image
supported on a proper exceptional divisor and hence generic rank zero,
regardless of the center dimension or codimension.  Theorem 21.6 supplies
the augmented-row blowup arrows, and weak factorization composes them.

This corollary is a conditional implication, not a theorem that the bridge
exists.  Its premise is stronger than the one-row provider targeted for
\(m=2\).  The latter benefits from the fivefold center bound: only rank-two
normal bundles of threefold centers are genuine primitive carriers.  For
\(m>2\), centers of dimension at least four can carry additional
primitive-sixth data, and higher-codimension blowups have longer exceptional
strings.  The relative-cap/exposed-face approach then becomes multivariate,
with \(\Gamma\cong\mathbf Z^{c-1}\); Theorem 21.5 still applies to each
weight, but it supplies no uniform cancellation theorem.

The independent \(\mathbf G_a\)/Jordan route scales differently.  The
projective factor asks for \(J_{m+1}\), and tensor-product coherence is
controlled by the Clebsch--Gordan law already tested in Module 19.4.  What
does not scale for free is the geometric carrier exclusion: higher
dimensional centers can themselves carry the required long nilpotent string.
Thus category theory organizes the higher-\(m\) obstruction and its
compositions, but neither the rank bridge nor the carrier theorem is
currently available.

## 21.17 Sparse reconstruction as a torsor-lift problem

The reconstruction results in the other papers have a common exact core:
either the chosen shadows are proved complete, or a residual marking is kept
which selects one lift through a nontrivial forgetful fibre.  The following
graph theorem isolates the path-tracking part without asserting that a
particular geometric fibre has this form.

Let \(Q\) be a connected graph, let \(\Pi(Q)\) be its path groupoid, and let
\(G\) be a group.  A **torsor local system** on \(Q\) consists of a nonempty
right \(G\)-torsor \(X_v\) at each vertex and a \(G\)-equivariant bijection

\[
\tau_e:X_v\longrightarrow X_w
\tag{21.36}
\]

for every oriented edge \(e:v\to w\), with
\(\tau_{e^{-1}}=\tau_e^{-1}\).  A compatible lift is a choice
\(x_v\in X_v\) satisfying \(\tau_e(x_v)=x_w\) for every edge.

### Theorem 21.8 -- torsor reconstruction is exactly trivial holonomy

Fix a base vertex \(b\) and \(x_b\in X_b\).  There is a compatible lift
extending \(x_b\) if and only if every based-loop transport fixes \(x_b\):

\[
\tau_\ell(x_b)=x_b
\qquad(\ell\in\operatorname{Aut}_{\Pi(Q)}(b)).
\tag{21.37}
\]

Because the action on a torsor is free and every transport is
\(G\)-equivariant, this is equivalent to trivial holonomy on all of \(X_b\).
When it exists, the extension of the fixed base point is unique.  In
particular:

1. if \(Q\) is a tree, every base lift extends uniquely and the set of all
   compatible lifts is itself a right \(G\)-torsor;
2. on an interval with both endpoint lifts prescribed, a compatible lift
   exists exactly when transport along the interval sends the first endpoint
   lift to the second;
3. a graph map, or more generally a functor of path groupoids
   \(F:\Pi(P)\to\Pi(Q)\), pulls the local system and its holonomy back.  It
   does not in general trivialize that holonomy.

### Proof

Choose paths \(p_v:b\to v\) and define
\(x_v=\tau_{p_v}(x_b)\).  This is independent of the chosen path precisely
when every loop \(p_vp_v'^{-1}\) fixes \(x_b\), which is (21.37); edge
compatibility and uniqueness then follow.  A tree has a unique reduced path
from \(b\) to each vertex.  The interval statement is the same construction
with its terminal value prescribed.  Pullback replaces every transport
\(\tau_p\) by \(\tau_{F(p)}\), so it replaces each loop holonomy by its
image under \(F\).  ∎

After choosing one point in every fibre, the edge transports are encoded by
a nonabelian graph \(1\)-cocycle with values in \(G\); changing those choices
is vertexwise gauge.  Theorem 21.8 says exactly that a compatible lift exists
when this cocycle has neutral gauge class.  For a path theory with imposed
2-cells, the products around the corresponding boundary loops must also be
the identity.  This is the elementary cohomological form of the
Beck--Chevalley requirement.

This explains what the sparse-shadow precedents do and do not import.  A
marked bridge kills a residual \(C_2\)-torsor; a retained removed-root marker
chooses a polar-contraction lift; and a proved complete weighted shadow has
singleton fibres.  An affine frame residual that remains uncontrolled is the
opposite case.  These are structural precedents, not a theorem that the QDM
forgetful fibre is any particular torsor.

For the present packet, Proposition 19.3B identifies the candidate residual
group only **after** a common row-line carrier has been constructed.  A single
weak-factorization chain is a tree, so an arbitrarily chosen lift can always
be propagated along it.  That fact is useless for birational invariance unless
the propagated endpoint equals the canonical Gamma point row; by item 2 this
is exactly a boundary condition, not a formal consequence of having tracked
the path.  Parallel projections and overlap squares add loops, whose trivial
holonomy is exactly the missing marked Beck--Chevalley/provider theorem.

In effect notation, Reader contains the torsor local system and any path
functor, indexed State contains the chosen lift, and Writer contains the
holonomy and endpoint certificates.  A lens into a higher parallel
projection is lawful only when a bridge such as (21.33) makes that residual
cartesian.  Mapping paths without mapping this residual merely pulls the
obstruction back; it cannot recover information that was never marked.

## 21.18 A simple retained character forces the row line

There is one useful way for the higher projection to make the endpoint
condition automatic.  Let \(A\) be a unital \(K\)-algebra and let
\(\chi:A\to K\) be a character.  Write \(K_\chi\) for the resulting
one-dimensional left \(A\)-module.

### Theorem 21.9 -- simple-character row forcing

Let \(V_-\) and \(V_+\) be left \(A\)-modules and suppose

\[
\operatorname{Hom}_A(V_\pm,K_\chi)=K r_\pm
\tag{21.38}
\]

with \(r_\pm\ne0\).  Every \(A\)-linear isomorphism
\(\Phi:V_-\to V_+\) satisfies

\[
r_+\Phi=c_\Phi r_-
\qquad\text{for a unique }c_\Phi\in K^\times.
\tag{21.39}
\]

These scalars multiply under composition.  If the modules also carry
operators \(T_\pm\) and \(\Phi T_-=T_+\Phi\), then \(\Phi\) is an augmented
operator-row isomorphism.

### Proof

The composite \(r_+\Phi\) is a nonzero element of
\(\operatorname{Hom}_A(V_-,K_\chi)\), so (21.38) gives the unique nonzero
scalar in (21.39).  Substitution proves the composition law, and the final
claim is exactly the morphism law of \(\mathsf{AugOp}_K\).  ∎

### Corollary 21.9A -- semilinear character forcing

Let \(\alpha:A_-\xrightarrow\sim A_+\) be an algebra isomorphism, let
\(\chi_+\alpha=\chi_-\), and suppose
\(\Phi(av)=\alpha(a)\Phi(v)\).  If
\(\operatorname{Hom}_{A_\pm}(V_\pm,K_{\chi_\pm})=Kr_\pm\), then the same
conclusion \(r_+\Phi=c_\Phi r_-\) holds.  The scalars compose together with
the algebra maps.  This is the correctly typed form when a QDM comparison
includes a coordinate pullback; the proof is the same precomposition
argument after restriction of scalars along \(\alpha\).

Over a base ring, replace the two one-dimensional Hom spaces by invertible
rank-one modules.  Precomposition gives a canonical isomorphism of those line
modules, while a scalar \(c_\Phi\) appears only after choosing frames.  The
resulting line-bundle holonomy is precisely the residual tracked by Theorem
21.8; the line theorem does not trivialize it.

For a single retained endomorphism \(Q\), take \(A=K[t]\) and let \(t\) act
on \(K_\chi\) by \(\lambda\).  The hypothesis then says that the left
\(\lambda\)-eigenspace is the single row line.  Thus any intertwiner of
\(Q\) preserves that line.  More geometric candidates are an action
descending to a multiplicity-one generic-point quotient, or the coordinate
algebra of finite Fourier support with the character at exponent zero.  The
generic-point construction is canonically a quotient; it does not provide an
idempotent splitting on the QDM side.

This theorem pinpoints why the audited Hodge specialization is insufficient:
the trivial Hodge character occurs on every Tate direction, so (21.38) fails.
Formal monodromy already has three copies of each primitive-sixth character
on \(X\times\mathbf P^2\), before any exceptional packet is added.  A raw
cohomological grading separates the top cohomology line, but the Gamma point
row is a calibrated flat section rather than a bare \(\mu\)-eigenrow.  A
generic-point quotient separates rank on \(K\)-theory, but the fixed-phase
analytic blowup comparison has not been shown to descend to that quotient in
the Gamma frame.  Theorem 21.9 therefore gives another small provider
interface, not that missing linearity theorem.

## 21.19 Laurent grading alone has repeated characters

The grading candidate in Theorem 21.9 has an exact failure mode.  Let
\(e\ge1\), let \(V_i\) carry a diagonalizable endomorphism \(\mu_i\), and put

\[
M_i=K[z^{1/e},z^{-1/e}]\otimes_KV_i,
\qquad
\mathcal G_i=z\partial_z+\mu_i.
\tag{21.40}
\]

### Proposition 21.10 -- Laurent shifts collide grading characters

If \(a\) is an eigenvalue of \(\mu_i\), \(b\) is an eigenvalue of
\(\mu_j\), and \(a-b\in\tfrac1e\mathbf Z\), then the
\(\mathcal G\)-eigenvalue \(a\) occurs in both \(M_i\) and \(M_j\).
Consequently, on \(M_i\oplus M_j\), the corresponding left-character space
has dimension at least two and cannot satisfy (21.38).

### Proof

If \(\mu_i v=a v\) and \(\mu_j w=bw\), then

\[
\mathcal G_i(1\otimes v)=a(1\otimes v),
\qquad
\mathcal G_j(z^{a-b}\otimes w)=a(z^{a-b}\otimes w).
\tag{21.41}
\]

The two eigenvectors lie in distinct direct summands.  Their dual coordinate
rows give two independent left eigenrows.  ∎

Thus an intertwiner of the grading connection does not by itself preserve a
distinguished point row once the coefficient spine permits the Laurent or
ramified shifts used to align blowup branches.  The neutral toric calibration
in the source is consistent with this no-go: although its continuation gauge
intertwines the quantum and grading connections, point-row preservation is
deduced from the stronger Fourier--Mukai statement carrying
\(\mathcal O_p\) to \(\mathcal O_{p'}\).

A grading route can still work after retaining a bounded lattice or an
associated-graded extremal piece for which the shift in (21.41) is forbidden.
But preservation of that lattice/filtration is then the provider theorem;
forgetting it and retaining only \(\mathcal G\) reintroduces the collision.
Generic-point localization does not suffer this particular grading collision
because its quotient kills boundary-supported objects independently of
Laurent degree.  It supplies no canonical QDM idempotent; a bridge to that
quotient is still required.

## 21.20 Wall mutations fix a common-open point object

The support specialization has a standard categorical mechanism.  Let
\(\mathcal C\) be a triangulated category and let
\(i:\mathcal B\hookrightarrow\mathcal C\) be an admissible subcategory.  Its
left and right mutations are defined by the triangles

\[
ii^!x\longrightarrow x\longrightarrow L_{\mathcal B}x,
\qquad
R_{\mathcal B}x\longrightarrow x\longrightarrow ii^*x.
\tag{21.42}
\]

### Proposition 21.11 -- the orthogonal point is mutation-fixed

If

\[
p\in{}^\perp\mathcal B\cap\mathcal B^\perp,
\tag{21.43}
\]

then \(L_{\mathcal B}p\cong p\) and
\(R_{\mathcal B}p\cong p\).  Hence every composable word of left and right
mutations through wall-supported admissible subcategories fixes \(p\).

### Proof

The condition \(p\in\mathcal B^\perp\) gives \(i^!p=0\), so the first
triangle in (21.42) identifies \(L_{\mathcal B}p\) with \(p\).  The condition
\(p\in{}^\perp\mathcal B\) gives \(i^*p=0\), and the second triangle does the
same for \(R_{\mathcal B}p\).  Compose these isomorphisms.  ∎

For a point \(p\) in the common open complement of a wall, its skyscraper
object is orthogonal in both directions to perfect complexes supported on the
wall.  Suppose a pairing-preserving analytic continuation \(\Phi\) is known,
on the single Gamma-framed section \(s(\mathcal O_p)\), to realize such a
mutation word and hence

\[
\Phi s_-(\mathcal O_p)=s_+(\mathcal O_p).
\tag{21.44}
\]

Then its point rows satisfy

\[
r_{+,p}(\Phi v)
=\langle\Phi v,s_+(\mathcal O_p)\rangle
=\langle v,s_-(\mathcal O_p)\rangle
=r_{-,p}(v).
\tag{21.45}
\]

This recovers the neutral toric calibration and explains the window proposal
in the source.  It also compresses Theorem 21.2: compatibility is required on
one common-open point object, not on the entire Orlov decomposition.  It does
not prove (21.44).  Outside the calibrated toric cases, identifying the
fixed-phase continuation with a wall-mutation word on that Gamma section is
exactly the conjectural one-object/window provider.  Orthogonality alone
cannot identify an analytic continuation with a categorical mutation.

## 21.21 Generic rank is the universal support-null character

The high retained path itself has a canonical quotient, even though the QDM
bridge to it is missing.  Let \(Y\) be an integral regular noetherian scheme
with function field \(K(Y)\).  Let \(N_Y\subset K_0(Y)\) be the subgroup
generated by the images of \(K_0^Z(Y)\) as \(Z\) ranges over proper closed
subsets.

### Theorem 21.12 -- generic-point localization

Restriction to the generic point induces an isomorphism

\[
K_0(Y)/N_Y\xrightarrow{\ \sim\ }K_0(K(Y))\cong\mathbf Z,
\tag{21.46}
\]

and the map is generic rank.  Consequently, for every abelian group (or
\(\mathbf Z\)-module) \(A\), every group homomorphism
\(\epsilon:K_0(Y)\to A\) which kills every proper-supported perfect complex
has the unique form

\[
\epsilon(n)=a\,\operatorname{rk}(n)
\tag{21.47}
\]

for one element \(a\in A\), where multiplication by rank means the integer
action on \(A\).

### Proof

Localization shows that every class supported on a proper closed subset lies
in the kernel of generic restriction.  Conversely, represent a generic-rank
zero class by a difference of perfect complexes.  Over the field \(K(Y)\)
the corresponding \(K_0\)-classes agree, so after adding trivial summands
their generic fibres are isomorphic.  This isomorphism spreads out over some
dense open \(U\subset Y\).  The class therefore restricts to zero in
\(K_0(U)\), and the localization sequence for \(Y\setminus U\) places it in
\(N_Y\).  Finally \(K_0(K(Y))\cong\mathbf Z\) by dimension, proving (21.46),
and the universal property of the quotient proves (21.47).  ∎

### Corollary 21.12A -- a coniveau checklist for the rank row

Assume in addition that \(Y\) is smooth projective, and let
\(\epsilon:K_0(Y)\to K\) be additive.  If

\[
\epsilon([\mathcal O_Y])=1
\quad\text{and}\quad
\epsilon([\mathcal O_Z])=0
\tag{21.47a}
\]

for every proper integral closed subscheme \(Z\subsetneq Y\), then
\(\epsilon=\operatorname{rk}\).  Indeed, regularity identifies \(K_0(Y)\)
with coherent \(G_0(Y)\), and the support filtration plus devissage expresses
every proper-supported class as a sum of structure-sheaf classes of integral
closed subschemes.  Theorem 21.12 then applies.

Thus, **after** a Gamma/\(K_0\) realization has made a transported analytic
row into an additive \(K_0\)-functional, one normalization and
support-nullity on coniveau generators identify that functional with rank.
The corollary constructs neither the realization nor its naturality.  This is
weaker than constructing a full Gamma--Orlov square, but support-nullity of
the fixed-phase row is still an analytic assertion.  In the fivefold problem
one may restrict further to the exceptional primary generators which survive
the dimension bound only after a common primitive projector and its
intertwining have been supplied; the relative-cap computation is a proposed
way to test those generators.

For a birational map of smooth integral varieties, the function fields and
hence the quotients (21.46) are canonically identified.  In an Orlov blowup
decomposition every exceptional component is proper-supported and maps to
zero.  Thus the upper support path needed by the comma bridge is canonical
and one-dimensional; no choice of complement or support idempotent is
needed.

This theorem discharges the **high-path uniqueness** part of the proposed
rank bridge.  It does not construct a natural epimorphism from the Gamma/QDM
solution module to (21.46), nor prove that analytic continuation respects its
kernel.  Those are precisely \(\gamma\) and its naturality law in Theorem
21.6.  In particular, universal rank on \(K_0\) cannot be pulled through an
unproved Gamma realization merely because both sides have the same
dimension.

## 21.22 After realizing fixed rank quotients, the sole residual is leakage

Once the two full analytic row quotients have been supplied, their residual
comparison obstruction is a single covector.  Let

\[
0\longrightarrow N_\pm\longrightarrow V_\pm
\xrightarrow{r_\pm}K\longrightarrow0
\tag{21.48}
\]

be exact and let \(\Phi:V_-\xrightarrow\sim V_+\).  Define its **leakage** by

\[
\delta_\Phi=r_+\Phi|_{N_-}\in N_-^*.
\tag{21.49}
\]

### Proposition 21.13 -- zero leakage is exactly quotient naturality

The following are equivalent:

1. \(\delta_\Phi=0\);
2. \(\Phi(N_-)=N_+\) and \(\Phi\) induces an isomorphism on the
   one-dimensional quotients;
3. \(r_+\Phi=c_\Phi r_-\) for a unique \(c_\Phi\in K^\times\).

Zero-leakage maps are closed under composition and inverse.  After choosing
splittings \(V_\pm=Ks_\pm\oplus N_\pm\), a general comparison has blocks

\[
\Phi=
\begin{pmatrix}c&\beta\\u&A\end{pmatrix},
\qquad
\delta_\Phi=\beta,
\tag{21.50}
\]

and composition gives

\[
\begin{pmatrix}d&\gamma\\v&B\end{pmatrix}
\begin{pmatrix}c&\beta\\u&A\end{pmatrix}
=
\begin{pmatrix}dc+\gamma u&d\beta+\gamma A\\
vc+Bu&v\beta+BA\end{pmatrix}.
\tag{21.51}
\]

### Proof

Condition 1 says \(\Phi(N_-)\subseteq N_+\).  Since both kernels have
codimension one and \(\Phi\) is invertible, equality follows and the induced
quotient map is a nonzero scalar, proving 2 and 3.  Condition 3 immediately
implies 1.  Composition, inverse, and (21.51) are direct.  ∎

For the **full Gamma--rank bridge**, take
\(N=\ker(\operatorname{rk})\) on the high path and transport it objectwise to
the solution space.  Its missing arbitrary-blowup theorem is exactly
\(\delta_\Phi=0\), not an unidentified full-matrix condition.  This full row
statement is stronger than the minimal \(m=2\) primary Boolean.  After
applying the primitive-sixth projector, only the corresponding primary
leakage must vanish; when the projected row itself is zero, the zero-row case
of \(\mathsf{AugPrim}\), rather than the codimension-one quotient (21.48), is
the correct interface.

Proposition 21.11 kills full leakage when \(\Phi\) is realized by wall
mutations fixing the common-open point.  Theorem 21.9 kills it when a simple
retained character exists.  If a scalar relative-cap channel has first been
identified with this analytic leakage, Theorem 21.5 computes its exposed
associated-graded pieces; the coefficient \(-1/R\) is then a candidate
nonzero forbidden piece, and a proof must cancel it on its own face.  Theorem
21.5 is only a group-algebra initial-form law and does not make that analytic
identification.

Equivalently, the desired comparison is the assertion that the left arrow
exists and the following diagram commutes:

\[
\begin{CD}
N_- @>>> V_- @>{r_-}>> K\\
@V{\Phi|_{N_-}}VV @V{\Phi}VV @VV{c_\Phi}V\\
N_+ @>>> V_+ @>{r_+}>> K.
\end{CD}
\tag{21.52}
\]

The top and bottom rows are the full generic-rank quotients.  The middle arrow is
the analytic blowup comparison.  The left arrow and commutativity are not
additional provider fields: both exist exactly when the leakage covector
vanishes.

This identification is an exact synthesis, not a vanishing theorem.  The
audited sources prove zero leakage for ordinary flops and the stated toric
calibrations, but not for arbitrary codimension-two centers in fivefolds.

---

# Module 22. The conditional framed \(m=1\) proof as a specialization

The conditional framed-monodromy proof summarized in Section 6 of the
epilogue fits the compiler, but not by declaring its small-point invariant to
be an ordinary generic-bulk marker.  The designated small section and the
original \(z\)-disc are part of its type, and the two unresolved moves must
remain proof fields.

## 22.1 The framed-small block theory

Let \(\mathsf{FrSmQDM}^{\mathrm{ev}}\) be the symmetric-monoidal theory whose
objects are small even quantum differential modules together with:

1. their numerical Novikov coefficient spine;
2. the designated small bulk point; and
3. the original loop coordinate \(z\), before any Levelt--Turrittin
   ramification.

Its unconditional comparison arrows are generated by:

- coefficient-field extensions fixing \(\mathbf C\) and \(z\);
- connection gauges over \(K(\!(z)\!)\), hence using only integral powers of
  the original loop;
- exact scalar \(H^0\)-twists, which are single-valued on the \(z\)-disc; and
- fixed divisor shifts whose Novikov characters descend to the coefficient
  ring.

The last two generators are the string/divisor adapters of the epilogue.
An arbitrary formal bulk reparametrization is **not** an arrow in this theory
when it moves the designated small point.  In particular, the residual
reconstruction tail is not hidden inside the coordinate-pseudonaturality law
of Definition 2.1.

For an object \(D\), let

\[
\operatorname{cyc}(D):\boldsymbol\mu_\infty\longrightarrow\mathbf N
\tag{22.1}
\]

record the algebraic multiplicity of each root of unity in the framed formal
monodromy operator defined by one turn of the original \(z\)-disc.  The
universal-exponential construction discards nonrational exponent classes and
makes (22.1) independent of the auxiliary coefficient complement and common
ramification.  It is additive under direct sums and invariant under every
unconditional arrow just listed.

Let \(\zeta_6=e^{\pi i/3}\).  The framed-sixth consumer is the monoid map

\[
\operatorname{ev}_6:\mathbf N^{(\boldsymbol\mu_\infty)}\longrightarrow
\mathbf N,
\qquad
\operatorname{ev}_6(c)=c(\zeta_6)+c(\zeta_6^{-1}).
\tag{22.2}
\]

Thus

\[
\nu_6(Y;\chi)=
\operatorname{ev}_6\bigl(\operatorname{cyc}
  (\operatorname{QDM}^{\mathrm{ev}}_{\mathrm{sm}}(Y;\chi))\bigr).
\tag{22.3}
\]

Equivalently, take framed formal orbit factors as blocks, observe their
torsion eigenvalue and algebraic multiplicity, keep only
\(\zeta_6^{\pm1}\), and emit the multiplicity into \((\mathbf N,+,0)\).
This is exactly the observer/selector/emitter interface of Module 2 on the
framed-small block theory.

## 22.2 The two conditional arrows are provider fields

Let \(\mathsf{Tail}_{\mathrm{cmp}}\) be the type of residual
\(O(u)+s_j\) ambient and center reconstruction tails which actually occur in
the Iritani and Iritani--Koto comparisons, after the exact \(H^0\) and fixed
\(H^2\) terms have been removed.  Let
\(\mathsf{ResidualSurfSpec}\) be the type of comparison-generated strictly
Novikov-admissible specializations of surface centers which are neither
minimal nor geometrically ruled.

The conditional environment is the proof-carrying record

```haskell
data FramedM1Env = FramedM1Env
  { reconstructionTail
      :: forall e. GeneratedTail e
      -> Equal (nu6 (smallEndpoint e)) (nu6 (reconstructionEndpoint e))
  , residualTagging
      :: forall s. ResidualSurfaceSpecialization s
      -> Equal (nu6 (specializedSurface s)) (nu6 (taggedSurface s))
  }
```

The first field is exactly Hypothesis 5.7R, with its restricted quantifier;
it asserts no arbitrary-bulk invariance.  The second is the part of
Hypothesis 5.7T actually consumed after the direct center-vanishing theorems.
The tagged map is injective, so its module is an unconditional scalar
extension of the intrinsic module; composing that fact with the displayed
field gives intrinsic-to-specialized equality.  No arbitrary specialization
invariance is asserted.

These are **marker-level certified edges**.  Neither field claims an
isomorphism of the entire ambient QDM, and neither is derivable from path
provenance.  Reader carries `FramedM1Env`; indexed State carries the current
coefficient specialization and designated bulk point; Writer records the
exact string/divisor normalization, strict-admissibility, and center-null
certificates used along the path.

## 22.3 Specialized centers must remain indexed

For a smooth center \(C\subset Y\), let \(\Sigma_4(C)\) be the class of
numerical Novikov maps \(\chi_j\) generated when \(C\) occurs in a blowup
arrow of a smooth fourfold.  Each arrow contributes only finitely many such
maps.  They are strictly Novikov-admissible; the
specialization for \(F_1\) is also graded-monomial.

Define the indexed center-null interface

\[
\mathsf{CenterNull}^{\mathrm{sp}}_{\le2}(\nu_6):
\quad
\nu_6(C;\chi)=0
\quad
\text{for every }\dim C\le2\text{ and }\chi\in\Sigma_4(C).
\tag{22.4}
\]

The \(\chi\)-index is load-bearing.  A noninjective center map can merge
Novikov classes, so intrinsic vanishing \(\nu_6(C)=0\) does not formally
imply (22.4).  Divisor tagging is the adapter which repairs precisely that
implication where it is still needed.

### Proposition 22.1 -- Section 5 constructs the specialized center-null instance

Assume `reconstructionTail`, and assume `residualTagging` only on
\(\mathsf{ResidualSurfSpec}\).  Then (22.4) holds.

### Proof

The direct specialized results give zero for points, positive-genus curves,
\(\mathbf P^1\), \(\mathbf P^2\), every nef-canonical surface, and every
Hirzebruch surface; the \(F_1\) argument uses the graded-monomial property
already satisfied by comparison-generated maps.  Ruled surfaces over
positive-genus curves use `reconstructionTail` and the projective-bundle
calculation.  These cases cover every minimal surface and every geometrically
ruled surface.

A remaining surface is an iterated point blowup of a minimal surface.
`reconstructionTail` gives the intrinsic blowup formula and point terms are
zero, so its intrinsic \(\nu_6\) vanishes.  Only here is
`residualTagging` used to carry intrinsic zero through the external
specialization \(\chi\).  This proves every indexed case of (22.4).  ∎

## 22.4 Operation algebra and weak factorization

Iritani's decomposition, integral-\(z\) framing, the exact shift adapters,
and `reconstructionTail` give

\[
\nu_6(\operatorname{Bl}_C Y)
=\nu_6(Y)+\sum_{j=0}^{c-2}\nu_6(C;\chi_j).
\tag{22.5}
\]

This is the blowup method of the framed specialization.  The conditional
projective-bundle formula can also be installed from the same field, but the
\(m=1\) contradiction does not consume it: the external product formula

\[
\nu_6(Y\times\mathbf P^m)=(m+1)\nu_6(Y)
\tag{22.6}
\]

is unconditional by the tensor-product QDM and the simple Euler blocks of
\(\mathbf P^m\).  In particular,
\(\nu_6(Y\times\mathbf P^1)=2\nu_6(Y)\).

### Theorem 22.2 -- indexed center-nullity compiles birational invariance

If (22.5) and (22.4) hold, \(\nu_6\) is a birational invariant of smooth
projective varieties of dimension at most four.

### Proof

Every nontrivial center in a weak factorization of a fourfold has dimension
at most two.  For each blowup arrow, every specialized term in (22.5)
vanishes by (22.4), so the two endpoint values agree.  The same equality
handles a blowdown and composes along the factorization.  Lower dimensions
are identical.  ∎

The universal ledger for this instance must retain the specialization label:

\[
\begin{CD}
\mathsf{SPVar}_4^{\mathsf{FramedM1Env}}
@>{\mathcal B_{\mathrm{fr}}}>>
\mathcal L_{\mathrm{fr}}
@>>>
\mathcal L_{\mathrm{fr}}/
 \langle(C,\chi):\dim C\le2,\ \chi\in\Sigma_4(C)\rangle
@>{\overline{\operatorname{ev}}_6}>>\mathbf N\\
@VVV @VVV @| @|\\
\mathsf{Bir}_4 @>>> \mathcal L_{\mathrm{fr},>2}^{\mathrm{sp}}
@= \mathcal L_{\mathrm{fr},>2}^{\mathrm{sp}}
@>{\overline{\operatorname{ev}}_6}>>\mathbf N.
\end{CD}
\tag{22.7}
\]

The superscript on the source records proof-carrying comparison arrows; it
does not turn the hypotheses into properties of all smooth varieties.

## 22.5 The conditional \(m=1\) specialization

### Corollary 22.3 -- the Section 6 proof is a compiler instance

Assume Hypothesis 5.7R and Hypothesis 5.7T only for surface centers which are
neither minimal nor geometrically ruled.  For every smooth cubic threefold
\(X\), the framed specialization proves that
\(X\times\mathbf P^1\) is irrational.

### Proof

The endpoint calculations and (22.6) are unconditional:

\[
\nu_6(X)=2,
\qquad
\nu_6(X\times\mathbf P^1)=4,
\qquad
\nu_6(\mathbf P^4)=0.
\tag{22.8}
\]

The two provider fields give Proposition 22.1 and (22.5), so Theorem 22.2
makes \(\nu_6\) birationally invariant in dimension four.  Rationality of
\(X\times\mathbf P^1\) would therefore force \(4=0\), a contradiction.  ∎

This is an exact retyping of the conditional proof, not a new removal of its
hypotheses.  It is also not stronger:

- 5.7R is quantified only over the comparison-generated residual tails;
- 5.7T is consumed only on the residual class of surface centers;
- center vanishing is required after each actual \(\chi_j\), not merely
  intrinsically; and
- the unconditional product adapter is used instead of the conditional
  projective-bundle operation.

## 22.6 Relation to the unconditional atomic specialization

The framed and atomic \(m=1\) proofs are sibling compiler instances.  They
are not related by a global forgetful morphism.  The atomic marker retains a
centered rank-two nilpotent packet and the shift-invariant discriminant
\(\delta^\sharp\); the framed marker retains absolute exponent classes and
original-loop descent.  On the isolated cubic rank-two packet, a richer
exponent-framed object maps to both:

\[
\begin{CD}
&\mathsf{RankTwoExponentFrame}&\\
@V{\text{difference squared}}VV
&&@VV{\text{original-disc exponential}}V\\
\mathsf{Atomic}_{\delta^\sharp}
&&\mathsf{Framed}_{\nu_6}.
\end{CD}
\tag{22.9}
\]

The left projection forgets a common scalar exponent shift; the right does
not.  This is why the atomic instance can be unconditional while the framed
instance still needs reconstruction-tail control.  The shared compiler is
the direct-sum/blowup/center-null/weak-factorization algebra, not an assertion
that one marker determines the other on every QDM.

---

# Module 23. Universal sufficient shadows and the non-\(m=2\) dividend

The categorical compiler has consequences which do not depend on the open
higher-stabilization provider.  Section 7.7 constructed the categorified
center localization and Theorem 20.1 gave the object-level descent test.  We
now promote their universal decategorified forms and the joint-shadow
product corollary.  These statements classify what the compiler can retain; they do
not manufacture a geometric QDM comparison arrow.

## 23.1 Center-null markers are represented by one universal quotient

Let \(\mathcal L\) be the commutative monoid of isomorphism classes in a
lawful comparison ledger, after imposing the direct-sum and operation
relations which its provider has actually proved.  Let \(E_d\subset\mathcal
L\) be the set of **indexed** center generators

\[
e(C,\chi),\qquad \dim C\le d,
\tag{23.1}
\]

where \(\chi\) ranges over the specializations generated by the comparison
arrows.  Retaining \(\chi\) prevents intrinsic center vanishing from being
silently substituted for specialized center vanishing.

Let \(F(E_d)\) be the free commutative monoid on \(E_d\).  There are two
maps

\[
s,0:F(E_d)\rightrightarrows\mathcal L,
\qquad s([e])=e,\quad 0([e])=0.
\tag{23.2}
\]

Define the universal center-null ledger by the coequalizer

\[
q_d:\mathcal L\longrightarrow
\mathcal L_d:=\operatorname{coeq}(s,0).
\tag{23.3}
\]

Equivalently, \(\mathcal L_d\) is the quotient by the least monoid
congruence containing \(x+e\sim x\) for every \(x\in\mathcal L\) and
\(e\in E_d\).  This is the connected-component form of the symmetric-monoidal
localization (7.20), not a claim that the center generators form a ring
ideal.

### Theorem 23.1 -- representability and completeness of center-null markers

For every commutative monoid \(A\), precomposition with \(q_d\) gives a
natural bijection

\[
\operatorname{Hom}_{\mathsf{CMon}}(\mathcal L_d,A)
\xrightarrow{\ \sim\ }
\left\{
W\in\operatorname{Hom}_{\mathsf{CMon}}(\mathcal L,A):
W(e)=0\text{ for every }e\in E_d
\right\}.
\tag{23.4}
\]

Moreover, for \(x,y\in\mathcal L\),

\[
q_d(x)=q_d(y)
\quad\Longleftrightarrow\quad
W(x)=W(y)
\text{ for every center-null }W:\mathcal L\to A
\text{ and every }A.
\tag{23.5}
\]

If \(d\le e\), there is a unique quotient map
\(q_{d,e}:\mathcal L_d\to\mathcal L_e\) with
\(q_e=q_{d,e}q_d\), and

\[
(\mathcal L_d)_e\cong\mathcal L_e,
\qquad
(\mathcal L_d)_d\cong\mathcal L_d.
\tag{23.6}
\]

Here \((\mathcal L_d)_e\) means quotienting \(\mathcal L_d\) by the images
\(q_d(E_e)\); it does not reuse the original generators without mapping them
to the intermediate quotient.

Finally, let \(n\ge2\), and suppose every actual step in a chosen weak
factorization in dimension \(n\), including every specialized center label
\(\chi_j\) which it produces, has its specialized blowup relation in this
fixed ledger.  Then the class of a smooth projective \(n\)-fold in
\(\mathcal L_{n-2}\) is birationally invariant along such factorizations, and every
commutative-monoid-valued birational marker produced by the center-null
compiler is obtained uniquely by applying a homomorphism out of
\(\mathcal L_{n-2}\).

### Proof

The coequalizer universal property says that a map out of \(\mathcal L\)
factors uniquely through \(q_d\) exactly when it equalizes \(s\) and the
zero map.  On the generators this is precisely \(W(e)=0\), proving (23.4).

The forward implication of (23.5) follows from (23.4).  For the converse,
take \(A=\mathcal L_d\) and \(W=q_d\), which is itself center-null.  The
inclusions \(E_d\subseteq E_e\) and the same universal property give
\(q_{d,e}\), idempotence, and the nested-localization law (23.6).

For a nontrivial blowup arrow in dimension \(n\), the center has dimension at
most \(n-2\).  Its specialized center terms vanish in
\(\mathcal L_{n-2}\), so the two endpoints of the arrow have the same class.
A blowup of a smooth Cartier divisor is an isomorphism and may be deleted.
The same equality handles the inverse arrow and hence every admitted
weak-factorization zigzag.  The classification of its marker-valued
consumers is (23.4). ∎

### Corollary 23.1A -- one universal obstruction class

Let \(G(\mathcal L_{n-2})\) be the group completion.  For smooth projective
\(n\)-folds \(Y_0,Y_1\), put

\[
\Delta_{n-2}(Y_0,Y_1)
=q_{n-2}\mathscr B(Y_0)-q_{n-2}\mathscr B(Y_1)
\tag{23.7}
\]

in \(G(\mathcal L_{n-2})\).  Every abelian-group-valued center-null marker
factors uniquely through this group, and all such markers identify the two
endpoints if and only if \(\Delta_{n-2}(Y_0,Y_1)=0\).  The converse uses the
identity consumer of \(G(\mathcal L_{n-2})\).

At the finer monoid level, if
\(q_{n-2}\mathscr B(Y_0)=q_{n-2}\mathscr B(Y_1)\), no lawful center-null
monoid marker can distinguish them; if the classes differ, the universal
quotient marker itself does.  Group completion can collapse a
noncancellative monoid distinction, so the group and monoid assertions are
kept separate.  Individual numerical markers are coordinates on these
universal obstructions, not unrelated constructions.

## 23.2 Every marker family has a canonical minimal sufficient shadow

Let \(I\) be a small index set and let

\[
M_i:\mathcal L\longrightarrow A_i\qquad(i\in I)
\tag{23.8}
\]

be lawful commutative-monoid markers.  Write

\[
M_I=(M_i)_{i\in I}:\mathcal L\longrightarrow\prod_{i\in I}A_i
\tag{23.9}
\]

and define the kernel congruence

\[
x\equiv_I y
\quad\Longleftrightarrow\quad
M_i(x)=M_i(y)\text{ for every }i\in I.
\tag{23.10}
\]

It is a monoid congruence because every \(M_i\) is additive.  Put

\[
q_I:\mathcal L\longrightarrow
\mathcal S_I:=\mathcal L/{\equiv_I}.
\tag{23.11}
\]

An **image-complete sufficient shadow** for \((M_i)\) is a surjective monoid
map \(U:\mathcal L\to S\) through which every \(M_i\) factors.  Restricting
to the image loses no observed object and prevents irrelevant extra elements
of \(S\) from spoiling uniqueness.  A morphism from
\(U:\mathcal L\twoheadrightarrow S\) to
\(V:\mathcal L\twoheadrightarrow T\) is a monoid map \(h:S\to T\) with
\(V=hU\).

### Theorem 23.2 -- canonical minimal sufficient shadow

There is a canonical monoid isomorphism

\[
\mathcal S_I\xrightarrow{\ \sim\ }\operatorname{im}(M_I),
\qquad [x]\longmapsto M_I(x).
\tag{23.12}
\]

For every image-complete sufficient shadow
\(U:\mathcal L\twoheadrightarrow S\), there is a unique monoid map

\[
h_U:S\longrightarrow\mathcal S_I
\qquad\text{such that}\qquad
q_I=h_UU.
\tag{23.13}
\]

Consequently \(\mathcal S_I\) is terminal among image-complete
operation-stable shadows sufficient for the chosen marker family: it retains
no distinction which all the \(M_i\) forget.  For one marker,
\(\mathcal S_{\{M\}}\cong\operatorname{im}M\).

Here “operation-stable” refers to addition and to every relation already
encoded in \(\mathcal L\).  If one retains further unary, tensor, or path
operations outside that ledger, the construction must be performed in their
category of algebras and \(\equiv_I\) must be a congruence for those
operations as well.

### Proof

The map in (23.12) is well-defined and injective by (23.10), surjective by
the definition of the image, and monoidal by (23.9).  If
\(M_i=\overline M_iU\), define

\[
h_U(Ux)=[x].
\tag{23.14}
\]

If \(Ux=Uy\), then \(M_i(x)=\overline M_i(Ux)=\overline M_i(Uy)=M_i(y)\)
for every \(i\), so (23.14) is well-defined.  It is monoidal because \(U\)
and \(q_I\) are, and it is unique because \(U\) is surjective. ∎

### Corollary 23.2A -- minimality commutes with center localization

If every \(M_i\) kills \(E_d\), then \(q_I\) factors uniquely through
\(q_d\).  Hence the minimal shared shadow is already a quotient of the
universal center-null ledger:

\[
\mathcal L\xrightarrow{q_d}\mathcal L_d
\longrightarrow\mathcal S_I
\lhookrightarrow\prod_i A_i.
\tag{23.15}
\]

This gives a precise information order on the audited Guéré, BFGMP, KKPYY,
atomic, and framed instances whenever their provider contracts place them on
the same comparison ledger.  It does not assert a comparison morphism when
those contracts differ.

### Corollary 23.2B -- sufficient shadows form an information lattice

Up to isomorphism over \(\mathcal L\), image-complete monoid shadows
sufficient for \((M_i)\) correspond to monoid congruences

\[
R\subseteq\ker_{\mathrm{cong}}M_I.
\tag{23.15a}
\]

They therefore form the interval below \(\ker_{\mathrm{cong}}M_I\) in the
congruence lattice.  Adding another marker family \((N_j)\) replaces the
terminal kernel by

\[
\ker_{\mathrm{cong}}M_I\cap
\ker_{\mathrm{cong}}N_J,
\tag{23.15b}
\]

so the new minimal shadow is the observed image of
\(\mathcal L\to\mathcal S_I\times\mathcal S_J\).  Thus marker fusion is the
canonical common refinement, not necessarily the full product of the two
individual images.

### Proof

Indeed, a surjective shadow \(U\) is sufficient exactly when
\(\ker_{\mathrm{cong}}U\subseteq\ker_{\mathrm{cong}}M_I\), and kernel
congruences of product maps are intersections. ∎

## 23.3 Parallel sparse shadows can be jointly sufficient

Let \(U_j:\mathcal L\to S_j\), \(j\in J\), be a small family of monoidal
shadows and let

\[
U_J=(U_j)_{j\in J}:\mathcal L\longrightarrow\prod_{j\in J}S_j,
\qquad
S_J^{\mathrm{obs}}=\operatorname{im}(U_J).
\tag{23.16}
\]

No \(U_j\) is assumed faithful, and the joint map need not reconstruct an
object of \(\mathcal L\).

### Theorem 23.3 -- joint-shadow product descent

For a lawful marker \(M:\mathcal L\to A\), the following are equivalent:

1. there is a unique monoid map
   \(\overline M:S_J^{\mathrm{obs}}\to A\) with
   \(M=\overline M U_J\);
2. for every \(x,y\in\mathcal L\),
   \[
   U_j(x)=U_j(y)\text{ for every }j
   \quad\Longrightarrow\quad M(x)=M(y);
   \tag{23.17}
   \]
3. the intersection of kernel congruences satisfies
   \[
   \bigcap_{j\in J}\ker_{\mathrm{cong}}U_j
   \subseteq\ker_{\mathrm{cong}}M.
   \tag{23.18}
   \]

The theorem may hold even when \(M\) descends through no individual
\(U_j\), and even when \(U_J\) forgets part of the rich object.

### Proof

Conditions 2 and 3 are the same statement.  Condition 1 implies 2 by
applying \(\overline M\).  Conversely, define

\[
\overline M(U_Jx)=M(x).
\tag{23.19}
\]

Condition 2 makes this independent of the lift.  Surjectivity onto the image
makes it unique, and additivity of \(U_J\) and \(M\) makes it a monoid map.
∎

### Exact countermodel to individual descent

Take \(\mathcal L=(\mathbf Z/2)^3\), with coordinates \((x,y,z)\), and set

\[
U_1(x,y,z)=x,\qquad U_2(x,y,z)=y,\qquad M(x,y,z)=x+y.
\tag{23.20}
\]

The marker descends through neither \(U_1\) nor \(U_2\), but it descends
through \((U_1,U_2)\).  The joint shadow still forgets \(z\), so marker
reconstruction is strictly weaker than object reconstruction.

For groupoid-valued rich objects, (23.17) is replaced by a coherent
isomorphism on the Čech groupoid of the joint shadow, satisfying the identity
and cocycle laws on the triple fibre product.  This datum produces an actual
descended object only when the target satisfies effective descent for the
joint shadow.  This is the simultaneous product-shadow version of (20.4),
not an automatic stack theorem.

### Corollary 23.3A -- canonical fusion of parallel markers

The minimal sufficient shadow for \((M_i)_{i\in I}\) is the observed image
of their product marker.  If every \(M_i\) is center-null, so is the fusion;
if any component separates two endpoints, the fusion separates them.  A
lawful coarsening of the fusion commutes with the entire ledger, but may of
course erase the endpoint distinction.

## 23.4 Other non-\(m=2\) consequences already available

The three promoted theorems sit alongside six further consequences of the
same framing:

1. **Hypothesis slicing.**  A proof needs laws only on the comparison
   subcategory it traverses.  Module 22 uses this to restrict 5.7R to generated
   tails and 5.7T to residual specialized surfaces.
2. **Holonomy classification.**  Theorem 21.8 says that a forgotten torsor
   lift exists globally exactly when path holonomy is trivial.  Path state
   transports a lift; it does not canonically choose one.
3. **Generic-rank uniqueness.**  Theorem 21.12 identifies rank as the
   universal additive character killing proper support.  Every such
   invariant factors through rank, so none is independent of rank.
4. **Leakage classification.**  Proposition 21.13 reduces failure of a
   one-dimensional retained quotient to one covector and proves the
   zero-leakage maps form a subgroupoid.
5. **Leading-defect separation.**  Theorem 21.5 prevents lower-weight terms
   from cancelling a nonzero exposed initial leakage.  This can test
   reconstruction and tagging corrections without identifying the full
   comparison matrix.
6. **Boundary-mutation invariance.**  Common-open localization makes
   wall-supported mutations invisible to every support-null consumer.  A QDM
   application still needs the corresponding Gamma/common-open bridge.

The logical boundary is uniform: category theory classifies consumers,
factorizations, composition, and exact obstructions.  It does not supply a
missing analytic or geometric provider.

---

# Exploration frontier

This packet deliberately remains open under C925.  The next design questions
are:

1. **Proof-carrying record or type class?**  The mathematical object is more
   faithfully a record containing `observe`, `select`, `emit`, and proofs of
   the three laws.  A Haskell implementation could expose a type class for
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
7. **What is the canonical category of evaluation probes?**  Guéré's
   evaluation maps depend on a morphism \(Y\to Z\), and BFGMP Remark 4.2
   warns that maximality relative to an embedding is weaker than maximality
   relative to the identity.  A full implementation should index probes on
   arrows, probably by a double category or equipment, rather than only by
   varieties.
8. **Should KKPYY elementary equivalences retain path data?**  The thin
   groupoid is exactly sufficient for their atom set and chemical formula.
   A theory of specific birational maps would need the non-thin groupoid or
   bicategory of actual comparison spans, together with its 2-cells.
9. **When is the Bittner backend multiplicative?**  Equation (7.25) is only
   additive.  A ring-valued motivic measure requires a generic-big-QDM
   Künneth theorem compatible with the chosen atomizer and coefficient
   spines.
10. **Can a correlated marking beat the \(m=1\) constituent threshold?**
    Theorem 19.2 proves that such a marking is mandatory.  The two precise
    candidates are the \(\mathbf G_a\)-operation producing \(J_{m+1}\) and
    the pointed Gamma rank row; their provider theorems remain open.
11. **Can the provider land in one augmented-row category?**  Theorem 19.3A
    then makes the row-output kernel automatically two-sided, or avoids a
    quotient entirely.  Wall-local annihilation in separately chosen
    receivers is insufficient until the overlap 2-cells are row-line
    compatible.
12. **Can the projective and blowup lifts be made one rig pseudofunctor?**
    Equation (19.13) is the first compulsory regression.  For \(m\ge3\), it
    forces the exceptional copies into a non-split \(J_{m-1}\) string.
13. **Does the point-row marker descend through a finite Krylov shadow?**
    Theorem 20.3 reduces this to cyclicity, a nondegenerate common point
    column, and preservation of one finite recurrence at every threshold.
14. **Which comparison paths admit lawful optics?**  A useful path must retain
    a cartesian lift or residual and satisfy the relevant Beck--Chevalley
    2-cell.  Provenance without that residual is not reconstructive.
15. **Can the arbitrary-center gate be stated in kernel-profile language?**
    For \(m=2\), vanishing of the top rank \(\operatorname{rank}D^2\) is much
    smaller than classification of every center's full Stokes object, but it
    still needs a geometric proof.
16. **Can the fivefold path functor be built directly in the augmented
    primitive-row category?**  This would avoid choosing ambient threshold
    isomorphisms that the final Boolean never consumes, while retaining the
    one-object and zero-mode conditions that the countermodels show are
    essential.
17. **Can the rank-zero-target Stokes lemma be promoted to an optic law?**
    Equation (21.12) is one sufficient rank-one local normal form.  The exact
    condition is the augmented-row square (21.6).  The remaining issue is to
    place every wall and overlap map in one common row-line-compatible
    receiver.
18. **Can the large-radius/cusp frame coefficient be controlled directly?**
    Iritani's formal point column is pure at the exceptional Laurent cusp,
    but this does not identify the intrinsic large-radius Gamma point row.
    The first nonvacuous scalar is the point/exceptional coefficient for the
    blowup of projective five-space along the cubic; split
    complete-intersection pilots vanish, while nonsplit rank-two normal
    degeneration remains open.
19. **Is the one-object window statement easier than a Gamma--Orlov
    square?**  Proposition 21.11 needs analytic compatibility only on the
    common-open skyscraper.  The toric and ordinary-flop calibrations say yes
    in their scope; arbitrary codimension-two blowups remain the test.
20. **Does the transported row kill the surviving coniveau generators?**
    Corollary 21.12A reduces the full rank bridge to support-nullity plus one
    normalization.  For \(m=2\), only its primitive-sixth leakage on
    exceptional threefold-center generators is needed.
21. **What cancels the first forbidden relative-cap face?**  The
    \((-1,0)\) pilot contributes \(-1/R\).  A positive proof must identify a
    same-face channel contributing \(+1/R\); lower faces, grading, and path
    provenance cannot affect this coefficient.

None of these questions blocks the proof in Modules 0--16 or the
transport-level specialization audit in Module 17.  Modules 18--21 isolate
the general consequences without claiming the missing enriched provider.
The open questions control whether the interface can be promoted from a
lawful compiler to a canonical equivalence with the complete external
theories, and how far it can be reused beyond this one-stabilization
application.
