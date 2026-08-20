# A modular direct quantum-`D`-module proof of cubic one-stabilization irrationality

**Packet part:** Modules 0--3.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

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
