# Module 20. Sparse-shadow reconstruction, effects, and optics

**Packet part:** Module 20.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

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
