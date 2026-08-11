# C907 — Quantum-monodromy stabilization test

**Date:** 2026-08-10

**Lane:** `clebsch`

## Verdict

Cai's fractional formal-monodromy block survives stabilization by every
projective space: the small quantum connection of

\[
X\times\mathbf P^m
\]

has `m+1` copies of the cubic rank-two block, each with fractional exponents
congruent to `+/-1/6` modulo integers.  This is an exact classical computation
and a general product/projective-bundle formula, not a bounded numerical
observation.

This already gives a one-step stable-irrationality theorem:

\[
\boxed{\text{For every smooth cubic threefold }X,
       \ X\times\mathbf P^1\text{ is irrational}.}
\]

Indeed, every center in a weak factorization of a rational fourfold has
dimension at most two.  KKPYY's nef-canonical normal form and the
classification of surfaces force every point, curve, or surface quantum block
to have fractional exponents only `0` or `1/2` modulo integers, never
`+/-1/6`.

This does **not** yet settle full stable rationality.  From stabilization
dimension `m=2` onward, the ungraded multiplicity of the cubic atom admits universal
two-sided blow-up-center cancellation patterns using centers which themselves
carry the cubic atom.  Thus a proof that remembers only the fractional
exponents modulo integers and their multiplicity cannot close stable
irrationality.

The exact surviving refinement is Tate/integer graded: its endpoint polynomial
has nonzero extreme terms that no lower-dimensional self-carrier center has.
It now also has a basis-independent integral-lattice avatar: the Beilinson
Euler form gives the endpoint one unipotent Serre block of length `m+1`, while
every projective self-carrier contribution has length `m-1`.  This uniform gap
of two is exact.  Iritani's leading blow-up Fourier matrix supplies a further
positive result: at a chosen large-radius blow-up boundary, its `q`-adic
elementary divisors are consecutive and recover exactly the unordered Tate
width.  Cyclic root monodromy preserves this multiset.  What remains missing is
not the local filtration but its presentation-independent, functorial
compatibility across composed weak factorizations and with analytic Stokes
data.  The first composition audit is positive: the associated-graded Tate
polynomial is coherent under both transverse and nested two-step blow-up
exchanges.  It also exposes the next obstruction sharply: mutations preserve
Euler and Serre data while changing the exceptional flag.  Irregular-Hodge
theory supplies a canonical-up-to-shift filtration, strict projective
pushforward, and Thom--Sebastiani convolution in its own category.  The full
ambient cubic quantum module is now proved to lie in that category through its
hypergeometric mirror.  It is globally irreducible, however, so Cai's local
rank-two Levelt--Turrittin block cannot be a global irregular-Hodge subobject.
The local object itself is nevertheless exact: for every admissible phase, the
unique sectorial lift has ordered formal ranks `1,2,1`, with Cai's
zero-exponential rank-two atom in the middle and fixed by root monodromy; phase
`pi/2` is the certified representative.  The missing theorem is therefore not
existence of the cubic Stokes grading.  It is identification of
Iritani's residual blow-up sectors with the centers' own Stokes/irregular-Hodge
structures, followed by strict composition through weak factorization.  That
residual-center mutation-system comparison, rather than a new polynomial
identity, is now the highest-EV theorem gate.

The subsequent `T1/T2/T3` scoping pass sharpens this verdict.  Iritani's
formula (5.28) gives a positive formal pilot: at `Q=theta=0`, its comparison is
strict after taking the `t`-adic associated graded and then the
exceptional-first dominance graded.  The point- and curve-center cases in a
fivefold pass exactly.  But the Gamma lattice lives in analytic flat sections,
and its exponential summands are obtained only after choosing a sector and an
admissible phase; formal Levelt--Turrittin uniqueness does not make that
analytic projection canonical.  The proposed Krull--Schmidt ledger also needs
one repair: a plain free `C[[t]]`-module forgets block length.  Keeping the
unipotent Serre operator makes a single Jordan block indecomposable, with local
endomorphism order `C[[t]][N]/(N^ell)`.  Finally, arbitrary threefold blow-up
centers are not exhausted by Fanos, conic bundles, and del Pezzo fibrations:
smooth quintic and sextic threefolds in a hyperplane of `P^5` already give
Calabi--Yau and general-type codimension-two centers.  Thus a Fano database
sweep is useful reconnaissance but cannot prove `X x P^2` irrational.  The
full program survives only with a formal **and** analytic/integral `T1`, the
enriched `T2`, and `T3` for arbitrary smooth projective carriers.

A second proposed refinement, the `p`-primary length of a global spectral
cycle, does not survive audit in the published formalism.  The blow-up and
projective-bundle theorems identify analytic germs with disjoint unions of
local copies; they do not retain a chosen global Novikov loop.  Iterated
projective bundles also give dimension-admissible local-copy and wreath
counterpatterns.  Prime-power cycle length is therefore demoted from a live
cofinal obstruction to a conditional diagonal-loop observation.

Nothing in this report is promoted to the frozen Paper V manuscript.

## 1. Exact reconstruction of Cai's block

Use Cai's convention

\[
z^2\partial_z S=(K+zG)S
\]

for the cubic threefold, with `q=u^2`, over
`Q(sqrt(3))(u)`.  Starting from Cai's displayed matrices rather than from his
claimed answer, the Sage generator:

1. puts `K` into its two scalar blocks and one rank-two zero-eigenvalue Jordan
   block;
2. solves the first off-block Sylvester equation exactly;
3. computes the rank-two pieces

   \[
   M_1=\begin{pmatrix}-19/18&0\\0&19/18\end{pmatrix},
   \qquad
   (R_2)_{21}=-16/81
   \]

   in the generator's normalization, where the Jordan link is `1`; and
4. derives the indicial polynomial

   \[
   (\rho+19/18)(\rho-1/18)+16/81
   =\rho^2+\rho+5/36.
   \]

Its roots are `-1/6` and `-5/6`, hence the residues modulo integers are
`+/-1/6`.  The different off-diagonal normalization in Cai's displayed block
has Jordan link `2` and return link `-8/81`; their product, and therefore the
indicial polynomial, is the same.

An independent SymPy replay uses an explicit basis change and first gauge
matrix and recomputes every identity from `K` and `G`.

## 2. Stabilization by projective spaces

For `P^m`, write `n=m+1`.  At nonzero quantum parameter, multiplication by
`c_1(P^m)` is `n` times the cyclic shift.  In its Fourier eigenbasis the
diagonal of the grading operator is

\[
\frac1n\sum_{k=0}^{m}(m/2-k)=0.
\]

Consequently all `n` rank-one formal solutions of the projective-space factor
have integer-power exponent zero.  The quantum Kunneth connection is the
tensor connection, so tensoring those solutions with the cubic rank-two
solutions gives exactly `m+1` rank-two blocks with unchanged residues
`+/-1/6`.

Cai's flatness argument upgrades the cubic block from the small to the big
quantum connection.  The projective-bundle theorem below then supplies the
corresponding big-connection stabilization statement.

Equivalently, this is the trivial-bundle case of the projective-bundle
decomposition theorem for maximal A-model F-bundles in
Katzarkov--Kontsevich--Pantev--Yu, Theorem 4.11.  The certificate checks the
cyclic power identity, exact Fourier diagonalization, vanishing grading
diagonal, and resulting copy count for every `0 <= m <= 24`.  The displayed
trace identity proves the same statement for all `m`.

## 3. Surface-carrier exclusion and `X x P^1`

The following lemma is the load-bearing alternate attack.

**Surface lemma.** Every formal quantum-connection block of a smooth complex
projective surface has fractional power exponent congruent to `0` or `1/2`
modulo integers.

For a minimal surface with nef canonical class, KKPYY Claim 6.15 introduces
the parity projector `T` and the grading operator `Gr`.  In complex dimension
two,

\[
g=Gr+\tfrac12T
\]

has integral eigenvalues in every cohomological degree.  Gauging the connection
plus `T/(2u)` by `u^g` gives a regular-singular connection with nilpotent
residue.  Undoing the half-parity shift leaves fractional powers `0` on even
cohomology and `1/2` on odd cohomology.

If the minimal surface has Kodaira dimension `-infinity`, it is `P^2` or a
ruled surface over a curve.  The projective-space calculation gives exponent
zero for `P^2`; the projective-bundle theorem reduces ruled surfaces to their
base curves; and Cai's curve calculation gives only `0` or `1/2`.  Passing to a
nonminimal surface adds point blocks through blow-ups and does not change this
list.  This proves the lemma for all smooth projective surfaces.

Now suppose `X x P^1` were rational.  Weak factorization would connect it to
`P^4` through blow-ups and blow-downs with smooth centers of dimension at most
two.  Cai's integer-power property for the blow-up connection preserves
fractional exponents modulo integers.  Starting from `P^4`, whose blocks have
exponent zero, points, curves, and the surface lemma can introduce only `0` or
`1/2`.  But Section 2 gives two copies of the cubic rank-two block with
residues `+/-1/6`.  This is a contradiction.

The argument is algebraic: it uses ordinary weak factorization of a hypothetical
birational map, so it proves irrationality rather than only failure of a
particular symplectic factorization.

## 4. Why ungraded atom multiplicity cannot settle full stability

Let `alpha` denote the cubic rank-two atom and set the endpoint dimension to

\[
D=3+m.
\]

The projective bundle `X x P^m` contains `m+1` copies of `alpha`.  Consider a
self-carrier center

\[
Z_t=X\times\mathbf P^{t-1},\qquad 1\le t\le m-1.
\]

It has dimension `t+2`, carries `t` copies of `alpha`, and has codimension
`m+1-t` in a `D`-fold.  The blow-up formula therefore contributes

\[
w_t=t(m-t)
\]

copies of `alpha`.  Exact arithmetic gives

\[
\gcd_{1\le t\le m-1}t(m-t)=
\begin{cases}
1,&m\text{ even},\\
2,&m\text{ odd}.
\end{cases}
\]

This always divides `m+1`.  More strongly, the following explicit two-sided
balances use only `t=1,2`:

- `m=2`: `3 w_1 = m+1`;
- even `m>=4`: `3 w_1 = (m+1)+w_2`;
- odd `m>=3`, with `f=(m+1)/2`:
  `2f w_1 = (m+1)+f w_2`.

Hence the atom-count ledger of a hypothetical common resolution has no
congruence or positivity contradiction from `m>=2`.  The certificate checks
the full weight lists, gcd formula, and explicit relations for `1 <= m <= 24`;
the formulas prove them for every `m`.

This is a ceiling for the **coarse additive invariant**, not a constructed
weak factorization.  The calculation neither embeds all listed centers in one
factorization nor proves that a stable-rationality factorization exists.  It
shows that any successful quantum proof must use geometric realizability,
filtration, or data finer than ungraded atom multiplicity.

## 5. The exact refinement that survives arithmetically

If Tate/integer shifts are retained, the stabilized endpoint contributes

\[
P_m(L)=1+L+\cdots+L^m.
\]

The same center `Z_t` contributes

\[
B_{m,t}(L)=
(1+\cdots+L^{t-1})(L+\cdots+L^{m-t}).
\]

Every `B_{m,t}` has zero constant coefficient and zero `L^m` coefficient.
No signed integer combination of these self-carrier center polynomials can
equal `P_m`.  The certificate verifies the full coefficient arrays through
`m=24`, while the two extreme coefficients prove the statement generally.

### 5.1 Integral Euler/Serre-width avatar

The same separation can be expressed without choosing individual Tate labels.
For the Beilinson basis

\[
(\mathcal O,\mathcal O(1),\ldots,\mathcal O(d))
\]

of `K_num(P^d)`, the Euler matrix is

\[
(E_d)_{ij}=
\begin{cases}
\binom{d+j-i}{d},&j\ge i,\\
0,&j<i.
\end{cases}
\]

It is integral and unimodular.  Its Serre matrix

\[
C_d=E_d^{-1}E_d^{\mathsf T}
\]

has characteristic polynomial

\[
(\lambda-(-1)^d)^{d+1},
\]

and `(-1)^d C_d` is a single unipotent Jordan block of length `d+1`.
Equivalently, its logarithm has nilpotence index `d+1`.  The Sage certificate
and independent SymPy replay verify the exact Euler, characteristic-polynomial,
and nilpotence identities for `0<=d<=24`; the general statement is the standard
Beilinson/Serre calculation.

Tensor products add logarithmic width.  If unipotent factors have logarithms
`L_a,L_b`, then

\[
\log(U_a\otimes U_b)=L_a\otimes I+I\otimes L_b,
\]

whose nilpotence index is `a+b+1`: the top term is
`binom(a+b,a)L_a^a tensor L_b^b`, which is nonzero in characteristic zero.
Therefore the endpoint `X x P^m` carries a cubic block tensored with one Serre
block of length `m+1`, whereas the self-carrier `Z_t=X x P^(t-1)` and its
`m-t` exceptional copies contribute the projective tensor

\[
\mathbf P^{t-1}\times\mathbf P^{m-t-1},
\]

of logarithmic width `m-2` and block length `m-1`.  The gap is uniformly two,
including `m=2`.

This also gives the exact arbitrary-center theorem that would suffice.  In
ambient dimension `D=m+3`, suppose an `s`-dimensional carrier of the cubic atom
has intrinsic Tate width at most `s-3`.  A codimension-`D-s` blow-up adds the
exceptional width `D-s-2`, so every center contribution has width at most

\[
(s-3)+(D-s-2)=D-5=m-2,
\]

again two below the endpoint width `m`.  Direct sums cannot create a longer
Jordan block.

In particular, this defeats all previously found iterated-projective-bundle
counterpatterns **inside the candidate filtered theory**.  A tower with fibre
dimensions `d_1,...,d_k` has logarithmic width `sum d_i`; after it appears as a
blow-up center, the same dimension calculation caps its exceptional width by
`m-2`.  The prime-power wreath towers can reproduce copy count and global
cycle length, but not the endpoint Serre width.

The `tt` closeout exposes one further necessary clause.  Serre block length is
a basis-independent diagnostic of the desired Tate filtration, but it is not
itself additive under a semiorthogonal decomposition: off-diagonal extensions
can join shorter Jordan blocks.  The sufficient theorem must therefore produce
a **strict cubic-isotypic Stokes/Rees filtration** whose associated graded
satisfies

\[
[\operatorname{Bl}_Z Y]_\alpha
=[Y]_\alpha+(T+\cdots+T^{r-1})[Z]_\alpha.
\]

Then the extreme associated-graded terms, equivalently the certified width
gap, prove full stable irrationality.  A theorem preserving only the Euler
pairing or the Serre operator does not suffice.

The qualification is essential.  The ordinary derived blow-up decomposition
is semiorthogonal rather than Serre-block diagonal; off-diagonal extensions can
join Jordan blocks.  KKPYY's local analytic-germ atom forgets the absolute
Tate filtration, and its Section 6.4 explicitly defers Γ-integral compatibility
to forthcoming work.  Hence the block gap is an exact candidate invariant, not
an established birational invariant.

For block length over `Q` or `C`, integrality is stronger than logically
necessary: a complex-analytic Stokes-filtered theorem with the strictness and
associated-graded identity above would already suffice.  The Γ-integral
structure is the canonical known mechanism expected to identify that Stokes
filtration with the Euler lattice and its Tate grading.

Iritani's original theorem confirms that this is the exact seam rather than a
missing easy corollary.  Theorem 1.1 constructs the formal blow-up quantum
`D`-module direct sum and intertwines both the quantum connection and the
symmetric Poincaré pairing.  But Remark 1.5 says that the Stokes structure at
`z=0` does **not** admit the corresponding orthogonal decomposition in the
known toric case; instead it has a semiorthogonal decomposition matching
Orlov's through the Γ-integral structure.  The general analytic statement is
presented there as expected, not proved.  Thus the formal direct sum preserves
exactly the data that split the copies and discards exactly the Stokes extension
data in which the length-`m+1` Serre block would live.

### 5.1 The formal `q`-adic lattice does recover local Tate spacing

There is nevertheless more integral information in Iritani's initial matrix
than in the Laurent-field direct sum alone.  Let `r` be the codimension of the
blow-up center and set `t=q^{-1/s}`, where `s=r-1` for even `r` and
`s=2(r-1)` for odd `r`, as in Iritani (5.11).  Equations
(5.19) and (5.27) give, up to nonzero constants and higher `t`-order terms, the
`l`-th exceptional column as

\[
 q_{Z,j}q^{(l+1)/(r-1)}
 \bigl(\zeta^{-j(l+1)}\bigr)_{j=0}^{r-2},
 \qquad 0\leq l\leq r-2,
\]

where

\[
 q_{Z,j}=u_jq^{-r/(2(r-1))},\qquad u_j\in\mathbf C^\times.
\]

The character matrix
`(zeta^(-j(l+1)))` is an invertible discrete Fourier matrix.  Therefore the
exceptional block has `t`-adic elementary-divisor valuations

\[
 v_l=\frac{s(r-2l-2)}{2(r-1)}.
\]

These are integers by the parity-dependent definition of `s`, and consecutive
values differ by `s/(r-1)`.  After translation and rescaling, their levels are
exactly

\[
 0,1,\ldots,r-2.
\]

Thus the formal boundary lattice recovers the **unordered Tate spacing** of the
`r-1` exceptional copies.  A loop in `q` permutes the Fourier sectors and
multiplies rows and columns by roots of unity; both operations are units over
the valuation ring, so the elementary-divisor multiset and its width survive.
The certificate verifies the Fourier invertibility and valuation formula
independently for `2 <= r <= 25`; the displayed calculation proves the general
formula.

This removes cyclic root monodromy as the local obstruction.  It does not yet
produce a stable-birational invariant.  The parameter `q`, the valuation ring,
and the lattice are attached to a selected blow-up direction and large-radius
boundary.  Theorem 5.18 gives an isomorphism only after Laurent base change;
it does not identify one intrinsic Rees lattice of a variety across different
blow-up presentations or prove strict compatibility under composition in weak
factorization.  Nor does it supply the analytic Stokes extensions whose
semiorthogonal gluing is singled out in Remark 1.5.  That
presentation-independence plus strict composition law is now the precise gate.

This is not yet a stable birational invariant.  Cai's obstruction deliberately
uses exponents modulo integers because the formal isomorphisms in the blow-up
theorem may contain integer powers of `z`.  Katzarkov--Kontsevich--Pantev--Yu's
Hodge atoms likewise fold the Hodge grading so that Tate twists are invisible.
There is also an exact local obstruction to simply restoring labels: a loop of
the projective-space Novikov parameter sends

\[
q^{1/(m+1)}\zeta^j\longmapsto
q^{1/(m+1)}\zeta^{j+1},
\]

and hence cyclically permutes all `m+1` eigenbranches.  No branch is globally
distinguished when `m>0`; the certificate checks these cycles through `m=24`.
The polynomial separation therefore cannot be interpreted as a canonical
labelling of branches.  Section 5.1 shows, however, that monodromy still
preserves the unordered local valuation width.  A Γ-integral or Stokes
enhancement would have to make that width intrinsic and strictly composable
across blow-up presentations, not choose one branch globally.  KKPYY
explicitly identify integral enhanced atoms and their blow-up compatibility as
future work rather than an available theorem.

### 5.2 Two-step composition is coherent on the associated graded

Write

\[
P_r(T)=T+\cdots+T^{r-1}
\]

for the exceptional Tate polynomial of a codimension-`r` blow-up.  The two
standard order-exchange tests both pass identically.

For transverse smooth centers `A,B` of codimensions `r,s`, with intersection
`C`, blowing up `A` and then the strict transform of `B` gives `C`-coefficient
`P_sP_r`; reversing the order gives `P_rP_s`.

For a smooth flag `A subset Z subset X`, put

\[
\operatorname{codim}_X Z=r,
\qquad
\operatorname{codim}_Z A=c.
\]

Blowing up `A` and then `Bl_A Z` is the standard nested-order exchange of
blowing up `Z` and then the center `P(N_{Z/X}|_A)`.  On the first side the
total `A`-coefficient is

\[
P_{r+c}+P_rP_c.
\]

On the second side, the new center is a `P^(r-1)`-bundle over `A` of
codimension `c+1`, so the coefficient is

\[
P_{c+1}(1+P_r).
\]

Direct expansion gives the general identity

\[
\boxed{P_{r+c}+P_rP_c=P_{c+1}(1+P_r).}
\]

The certificate checks `300` nested and `276` transverse instances with total
codimension at most `26`; the displayed polynomial identities prove all
codimensions.  Thus blow-up order causes no defect at the associated-graded
level.  Any failure of presentation independence lies in the extension or
wall-crossing data.

This test uses the classical normalization that identifies Section 5.1's
consecutive local valuation levels with the shifts `1,...,r-1`.  It does not
compare the different multivariable Novikov lattices of a composed
factorization.  Constructing that comparison is part of the filtered quantum
lift, not a consequence of the polynomial identity.

Bittner's blow-up presentation of `K_0(Var_k)` explains why the graded
consistency is structural at the motivic level: smooth proper generators
modulo the blow-up relation already give the whole Grothendieck group.  Thus,
if an intrinsic filtered quantum assignment satisfying the blow-up relation
existed, factorization independence of its associated graded would be formal.
Bittner does not construct that assignment or compare its Novikov lattices.

### 5.3 Mutation isolates the flag ambiguity

The smallest example already shows why Euler and Serre data do not repair that
extension problem.  In the basis `(O,O(1))` of `K_0(P^1)`, the Euler matrix is

\[
E=\begin{pmatrix}1&2\\0&1\end{pmatrix}.
\]

Mutation to `(O(-1),O)` has basis matrix

\[
B=\begin{pmatrix}2&1\\-1&0\end{pmatrix},
\qquad B^tEB=E.
\]

Nevertheless the first flag line changes from the span of `(1,0)` to the span
of `(2,-1)`.  The normalized Serre nilpotent is

\[
N=-E^{-1}E^t-I
=\begin{pmatrix}2&2\\-2&-2\end{pmatrix},
\]

whose canonical weight line is the span of `(1,-1)`, different from both
exceptional first lines.  So the canonical monodromy-weight filtration retains
the block width but does not recover the Tate/exceptional flag.  This is the
exact chamber ambiguity that a strict enhancement must overcome.

### 5.4 Irregular Hodge theory is the precise conditional repair

Sabbah's category of irregular mixed Hodge modules supplies three ingredients
of exactly the desired shape:

- every morphism is bi-strict for the irregular Hodge and weight filtrations,
  and projective pushforward is strict (Theorem 0.3);
- an irreducible rigid, locally formally unitary holonomic `D`-module on `P^1`
  has a canonical irregular Hodge filtration up to an overall shift (Theorem
  0.7), which is enough for a width obstruction;
- the irregular Hodge filtration obeys a Thom--Sebastiani convolution formula
  (Theorem 3.39), the filtered analogue needed for products.

Sabbah--Yu additionally identify the filtration with the Harder--Narasimhan
filtration of Kontsevich bundles for exponential Gauss--Manin systems and prove
strict projective pushforward there.  Qin--Zhang's 2026 theorem identifies
irregular Hodge numbers with limiting Hodge numbers and proves deformation
invariance for non-degenerate regular functions.  These results make the route
structurally credible, but they do **not** prove the needed quantum statement.

The source audit below shows that the full cubic connection already has this
origin, but also that the local atom cannot globalize as a subobject.  Thus
Sabbah's strictness theorem cannot be applied to Iritani's formal direct sum in
the naive way.

### 5.5 The cubic is irregular-Hodge, but its atom cannot globalize

The cubic threefold is the complete intersection of `O(3)` in the toric
variety `P^4`, with

\[
-K_{\mathbf P^4}-\mathcal O(3)=\mathcal O(2).
\]

Therefore Reichelt--Sevenheck Theorem 6.6 applies: the reduced ambient quantum
`D`-module, after the mirror map, underlies a variation of pure polarized
noncommutative Hodge structures.  Its regularized quantum period is

\[
\sum_{d\ge0}\frac{(3d)!}{(d!)^5}t^d.
\]

After `x=27t`, its scalar operator is

\[
D^4-x(D+1/3)(D+2/3).
\]

This is the hypergeometric module

\[
H(0,0,0,0;1/3,2/3)
\]

up to the integral parameter shifts licensed by Castaño
Domínguez--Reichelt--Sevenheck Proposition 5.2.  Every cross-difference between
an alpha and a beta parameter is nonintegral, and the two parameter sets occupy
complementary arcs of the unit circle.  Proposition 5.2 therefore makes the
module irreducible, while Theorem 5.7 gives its unique irregular mixed-Hodge
upgrade and extension.  The certificate verifies the period recurrence and all
parameter conditions through degree `24`; the displayed recurrence proves it
for every degree.

This is simultaneously a positive result and an exact no-go.  Cai's ranks
`1,1,2` are the **local formal** exponential blocks at the irregular point.  A
proper global rank-two subobject would contradict irreducibility of the rank-four
hypergeometric module.  The earlier target “make Cai's block a global IrrMHM
object” is therefore impossible.  The surviving object must be the rank-two
graded piece of a local Stokes filtration on the full irreducible quantum
module.  The next subsection after the compactification comparison certifies
that this sectorial graded piece exists and is canonically singled out by its
zero exponential factor.

### 5.6 Compactification independence is an exact near-miss

Wang's 2026 Theorems 1.1 and 4.11 prove precisely the kind of filtered weak-
factorization consistency one would want on the mirror side.  For a **fixed**
Landau--Ginzburg pair `(U,w)`, the irregular Hodge filtration is independent of
its normal-crossing rational compactification.  Pullback across every
boundary-admissible blow-up gives levelwise filtered quasi-isomorphisms,
including the integer-slice quotients and their spectral sequences from `E_1`.

This does not yet apply to Iritani's theorem.  An A-model blow-up changes the
target and adds `r-1` center modules; it is not merely a new compactification of
one fixed `(U,w)`.  Iritani constructs his map by Fourier analysis of the
equivariant quantum module of a master space.  No theorem in the audited sources
makes that master-space quantum module a monodromic mixed Hodge module for an
arbitrary center, identifies the Fourier projections with Wang's pullbacks, or
turns the formal direct sum into a Stokes filtration.  Saito's Fourier--Laplace
theorem would preserve and compute the relevant Hodge filtration **if** that
monodromic mixed-Hodge input existed; it does not construct the input.  Iritani's
2025 survey still states the Γ-integral/semiorthogonal Stokes comparison as
anticipated rather than proved.

### 5.7 The cubic sectorial atom exists; residual-center transport is open

Write `u>0`, `q=u^2`, and

\[
A=6\sqrt3\,u.
\]

Cai's formal exponential factors, in Jordan-block order, are `+A`, `-A`, and
`0`, with ranks `1,1,2`.  For an admissible phase `phi`, their Stokes heights
are `-A sin(phi)`, `A sin(phi)`, and `0`.  Hence the zero-exponential block is
the middle block for **every** admissible phase.  At the representative phase
`phi=pi/2`, the increasing-height order is

\[
(+A,\ 0,\ -A), \qquad (1,\ 2,\ 1).
\]

Hukuhara--Turrittin therefore gives a unique analytic lift on every sufficiently
small sector of opening greater than `pi`.  The square-root monodromy
`u -> -u` exchanges the two outer rank-one factors and fixes the middle
zero-exponential rank-two factor.  Thus the local Stokes-graded cubic atom is
not conjectural; the certificate and independent replay verify its exact phase
ordering.

Iritani's 2020 Theorem 1.3 supplies the closest blow-up model.  For weak-Fano
toric weighted blow-ups along toric centers, the formal decomposition has a
sectorial analytic lift and its Gamma-integral lattice gives the Orlov-type
semiorthogonal decomposition of topological `K`-groups.  But Remark 1.4(3)
states the exact surviving defect: each residual sector has the same **formal**
structure as the center quantum module, while equality of their Stokes
structures is unknown.  In the general framework, Conjecture 8.3 and
Proposition 8.5 identify the necessary datum as the center summand of the full
mutation system—equivalently its Stokes-filtered local system with pairing and
Gamma-integral `K`-embedding.  Given that datum, the Riemann--Hilbert problem
recovers the retained quantum module.

Hinault--Yu--Zhang--Zhang prove uniqueness of the projective-bundle and blow-up
decomposition maps in the formal/non-archimedean `F`-bundle category.  This
removes ambiguity from Iritani's **formal** map, but does not provide the
missing mutation system: their introduction explicitly leaves the nc-Hodge
upgrade of general Gromov--Witten theory conjectural because of convergence,
Gamma, and opposedness problems.

The old demand that the master-space Fourier projections themselves become
global IrrMHM morphisms was therefore stronger than necessary.  The corrected
sufficient theorem is:

1. realize the full quantum modules of every weak-factorization variety and
   center as analytic exponential-type irregular-Hodge/Stokes objects;
2. identify each residual mutation-system summand of Iritani's sectorial
   decomposition with the Stokes-filtered quantum module of the corresponding
   center, compatibly with the Gamma-integral `K`-embedding;
3. prove strict compatibility of its irregular Hodge filtration with that
   Stokes filtration, identify the graded shifts with Section 5.1's elementary
   divisors, and compose it through the exchanges of Section 5.2.

No theorem in the audited literature supplies this package.  The cubic
endpoint and its local sectorial atom are closed; residual-center Stokes
identification and functorial composition remain.

### 5.8 `T1/T2/T3` scoping: one pilot passes, two shortcuts fail

The proposed canonical invariant was the image of the Gamma lattice in the
exponent-`+/-1/6` constituent, together with its Serre operator and `q`-adic
bigrading.  This is not yet presentation-free.  Iritani defines the
Gamma-integral structure as a lattice in the space of multivalued analytic
flat sections.  The formal exponential decomposition has regular-singular
pieces unique up to isomorphism, but its lift to flat sections uses an
admissible direction and a sector.  The resulting semiorthogonal decomposition
changes by Stokes mutations as the phase changes.  Therefore there is no
intrinsic operation in the cited theory that simply takes the image of the
Gamma lattice in one formal exponential factor.  Passing to `C[[q]]` removes
convergence from a formal calculation; it does not identify that formal
lattice with the analytic Gamma/Stokes lattice.

There is, however, a genuine positive `T1` pilot.  At `Q=theta=0`, Iritani's
equation (5.28) writes the comparison matrix as

\[
A+B,\qquad
A=\begin{pmatrix}I&0\\ \iota^*&F\end{pmatrix},
\qquad \operatorname{ord}_t(B)>0,
\]

where `F` is the invertible exceptional Fourier matrix.  Taking the `t`-adic
associated graded kills `B`.  If the exceptional module is the first step of
a two-step dominance filtration, the lower-left restriction block also dies
on the associated graded.  What remains is exactly

\[
(F\otimes I_Z)\oplus I_X.
\]

The certificate checks this for every codimension `2 <= r <= 25`.  In the
fivefold cases relevant to the proposed `m=2` pilot, a point center has `r=5`
and raw `t`-valuations

\[
3,1,-1,-3,
\]

while a curve center has `r=4` and valuations

\[
1,0,-1.
\]

Thus the basepoint formal comparison is dominance-triangular and strict on its
double associated graded.  This does not yet cover nonzero Novikov/big-quantum
variables, composition, or the Gamma/Stokes lift.

The proposed `T2` statement is false for plain modules.  Over
`R=C[[t]]`, the module `R^ell` splits into `ell` rank-one modules, so its
Krull--Schmidt multiset does not remember that one intended a length-`ell`
Jordan block.  The correct object retains the unipotent Serre operator

\[
U_\ell=I+N_\ell.
\]

Its commutant is

\[
R[N_\ell]/(N_\ell^\ell),
\]

a local ring with unique maximal ideal `(t,N_ell)`.  Hence the enriched single
block is indecomposable.  The certificate reconstructs the centralizer exactly
through length `25`; the independent replay recomputes the full commutant in a
representative bounded range.  A global telescoping ledger would follow only
after `T1` supplies honest strict direct sums in a finite enriched category.
It is not a consequence of Krull--Schmidt for plain `C[[t]]`-modules.

The proposed `T3` silver reduction fails before any database sweep.  A smooth
degree-`d` hypersurface

\[
V_d\subset\mathbf P^4\subset\mathbf P^5
\]

is a smooth codimension-two threefold blow-up center and has

\[
K_{V_d}=\mathcal O_{V_d}(d-5).
\]

Thus `V_5` is Calabi--Yau and `V_d` is of general type for `d>=6`.  Weak
factorization does not restrict all centers to rationally connected Mori
fibre spaces, and no audited minimal-factorization theorem removes these
examples.  The Coates--Corti--Galkin--Kasprzyk Fano database may reveal or
exclude Fano carriers, but it does not classify the possible threefold
centers and cannot by itself yield the claimed theorem for `X x P^2`.

The repaired gold architecture is consequently:

1. prove the formal strict comparison suggested by (5.28) in general, and
   separately lift it to the sectorial Gamma/Stokes category;
2. apply Krull--Schmidt to the enriched filtered objects, not their underlying
   free modules;
3. prove the `+/-1/6` carrier-length bound for **every** smooth projective
   carrier, beginning with Calabi--Yau and general-type threefolds.

The third item remains the deep theorem.  Its sharp conjectural form, length at
most `n-2` on an `n`-fold, is still consistent with every certificate in this
report and is tight on `X x P^(n-3)`.

## 6. Spectral-cycle alternate attack: negative audit

Along the particular diagonal Novikov loop used in the certificate, the cycle
type survives a relabelling of its branches.  In the self-carrier model of
Section 4, the center
`X x P^(t-1)` has a `t`-cycle and the exceptional cluster has an `(m-t)`-cycle.
Along a diagonal one-parameter loop, every orbit length divides

\[
\operatorname{lcm}(t,m-t).
\]

If `m+1=p^k` is a prime power, neither `t` nor `m-t` is divisible by `p^k`,
so their least common multiple cannot contain the endpoint `p^k`-cycle.  The
certificate verifies the exact reproducing `t` lists for `2<=m<=24` and the
prime-power exclusion; the valuation argument proves it for every prime power.

This would be cofinal if the cycle were functorial.  If `X x P^m` is rational for one `m`, then
`X x P^M` is rational for every larger `M`, because products of projective
spaces are rational of the corresponding dimension.  Thus an obstruction for
all

\[
M=p^k-1
\]

would prove full stable irrationality.

The source-level audit shows that the premise fails in the present theory.
KKPYY Theorems 4.5 and 4.11 identify the F-bundle of a blow-up or projective
bundle, on suitable **analytic germs**, with the F-bundle of a disjoint union
of copies of the source and center.  Their atomic composition retains the
degree of a connected spectral-cover component as a multiplicity.  It does
not retain a distinguished large Novikov loop or the permutation induced by
that loop.  Shrinking to the germs on which the decomposition is stated can
split or trivialize exactly the monodromy used above.

There is also an exact dimension-compatible counterpattern to any attempted
repair using only local-copy counts and unrestricted continuation.  Put

\[
n=p^k,
\qquad
Z_k\longrightarrow Z_{k-1}\longrightarrow\cdots\longrightarrow Z_0=X,
\]

where each arrow is a rank-`p` projective bundle.  Then

\[
\dim Z_k=3+k(p-1),
\qquad
\operatorname{CF}(Z_k)=p^k\operatorname{CF}(X)=n\operatorname{CF}(X).
\]

For the endpoint `X x P^(n-1)`, whose dimension is `n+2`, a weak-factorization
center may have dimension at most `n`.  The tower is therefore
dimension-admissible whenever

\[
3+k(p-1)\le p^k.
\]

This holds for every odd `p` with `k>=2` and for `p=2`, `k>=3`; the lone
nontrivial exception is `n=4`.  If global continuation is restored without
additional structure, the compatible iterated wreath group contains the
`p^k`-cycle given by the `p`-adic odometer.  The certificate checks these
dimensions and odometer cycles over its bounded range.

This tower is **not** asserted to occur as a center in an actual weak
factorization.  Its role is sharper and purely negative: local atom data plus
dimension cannot prove the desired descent, while unrestricted wreath mixing
can synthesize the supposedly forbidden cycle.  A viable enhancement would
have to retain global monodromy, prove compatibility for common-resolution
maps, and impose geometric restrictions excluding these projective-bundle
towers.  None of those statements is in the cited theory.  The prime-power
route is therefore no longer a live standalone route.

## 7. Fractional-Calabi--Yau carrier attack

There is a cleaner categorical reformulation of the recursive-carrier gate.
For the Kuznetsov component of a smooth cubic threefold, the standard Serre
relation is

\[
S^3=[5],
\]

so its lower and upper Serre dimensions are both `5/3`.  Serre dimension is
additive under tensor products, while
`D^b(P^m)` has Serre dimension `m`.  Consequently

\[
\operatorname{Sdim}\bigl(\operatorname{Ku}(X)\otimes D^b(\mathbf P^m)\bigr)
=m+\frac53.
\]

Every center in a weak factorization of the `(m+3)`-fold
`X x P^m` has dimension at most `m+1`.  A carrier inequality of the form

\[
\mathcal A\subset D^b(Z)\text{ admissible and fractional CY}
\quad\Longrightarrow\quad
\operatorname{Sdim}(\mathcal A)\le\dim Z
\]

would therefore create the uniform numerical gap

\[
\left(m+\frac53\right)-(m+1)=\frac23.
\]

It is not yet a valid reduction.  The standard exceptional collection on
`P^m` gives

\[
\operatorname{Ku}(X)\otimes D^b(\mathbf P^m)
=\langle\operatorname{Ku}(X),\ldots,\operatorname{Ku}(X)\rangle
\]

with `m+1` semiorthogonal copies.  The ordinary additive blow-up/atomic ledger
can distribute those copies among different centers; it does not force the
whole tensor category of Serre dimension `m+5/3` into a single center.
Therefore the displayed carrier inequality would prove stable irrationality
only after a **gluing-sensitive enhanced atom theorem** shows that the relevant
Serre dynamics across the projective branches is retained and must be carried
as one object.

There is a second independent gap.  Elagin--Lunts prove additivity,
but Serre dimension is not monotone for general admissible subcategories: they
exhibit an admissible subcategory of the derived category of the Hirzebruch
surface `F_3` whose upper Serre dimension is `3`, exceeding the ambient
dimension `2`.  Their counterexample does not have coincident lower and upper
Serre dimensions and therefore does not refute the restricted
fractional-Calabi--Yau carrier inequality above.  No proof of that restricted
inequality was located in the bounded current literature audit.

The sharp categorical route therefore needs **both** the gluing-sensitive atom
theorem and the restricted fractional-CY carrier inequality.  It is
conceptually stronger than the quantum multiplicity bookkeeping and is not
something a finite classical computation can establish.  The certificate
records the exact `2/3` numerical gap for `0<=m<=24`; additivity proves the
displayed formula for all `m`, but not either missing theorem.

KKPYY Section 6.4 also sketches Serre-enhanced atoms, but explicitly defers the
non-archimedean duality and integral compatibility details to forthcoming
work.  Its F-bundle convention writes a dual graded relation, so the
categorical `S^3=[5]` relation used here should not be silently identified with
that convention.

## 8. Alternate-attack checkpoint

The earlier `ej` pass upgraded the bounded search twice: it replaced the
observed gcd pattern by the all-`m` formulas in Section 3, and extracted the
Tate-graded polynomial separation in Section 4 at no additional geometric
assumption.  That separation is the strongest positive residue of the failed
multiplicity-only route.

The earlier `tt` pass challenged the three delicate seams: the product grading, the
allowed center dimensions, and the passage from a signed relation to a
two-sided positive common-resolution ledger.  It confirmed the zero
projective-space exponent directly, checked that `t=1,2` occur only in the
ranges where the formulas use them, and rewrote every relation positively.
It also rejected an apparent `m=1` conclusion: excluding self-carrier centers
does not by itself exclude an unrelated surface carrying the same atom.  The
present `aa` pass closes exactly that gap by the surface lemma, while leaving
the `m>=2` self-carrier ceiling intact.  The subsequent source-level `aa`
audit rejects the proposed prime-power upgrade at its functoriality seam: the
cited decomposition theorems are local on analytic germs, and iterated
rank-`p` projective bundles supply the exact dimension/wreath counterpattern
recorded in Section 6.

The final `ej`+`tt` pass extracts the basis-independent Serre-width form of the
Tate gap and verifies that it defeats every iterated-projective-bundle tower,
not only the one-step self-carriers.  It also rejects the overstrong claim that
Serre-block preservation alone would suffice: semiorthogonal extensions can
join blocks.  The surviving exact gate is strict filtered additivity of the
cubic-isotypic Stokes/Rees object.

The present source-level `q` pass computes the integral content of Iritani's
initial Fourier matrix.  It confirms that consecutive Tate width is already
visible as a monodromy-invariant multiset of local `q`-adic elementary
divisors, but rejects the inference that this relative boundary lattice is an
intrinsic invariant of the variety.  The gate is narrowed to
presentation-independent strict composition and analytic Stokes gluing.

The present composition pass proves that the associated-graded Tate ledger is
coherent under the transverse and nested two-step blow-up exchanges, so no
polynomial anomaly blocks functoriality.  The `P^1` mutation audit then shows
that Euler, Serre, and monodromy-weight data still do not select the exceptional
flag.  The literature `aa` pass identifies irregular mixed Hodge modules as the
closest existing strict filtered category, but locates the unproved bridge at
the quantum blow-up isomorphism itself.

The closing `ej`+`tt` audit places the polynomial identities in Bittner's
global blow-up presentation, then rejects the tempting overclaim that this
already supplies a motivic measure: neither the intrinsic filtered quantum
assignment nor the comparison of its multivariable `q`-lattices exists.  It
also keeps separate Cai's local Levelt--Turrittin block from a global object of
irregular mixed-Hodge origin.  Those two seams are the exact surviving gate.

The present hypergeometric `ej` pass closes one of those seams and corrects the
other.  The full cubic ambient quantum module already has a canonical
irregular-Hodge upgrade, but global irreducibility proves that the local
rank-two atom cannot itself be the upgraded object.  The `tt` challenge then
finds Wang's compactification-independence theorem: it supplies strict filtered
blow-up comparison for compactifications of one fixed Landau--Ginzburg model,
not for Iritani's additive quantum blow-up map.  The exact frontier is therefore
a semiorthogonal Stokes filtration compatible with irregular Hodge theory, not
a direct-sum IrrMHM morphism.

The present master-space `ej`+`tt` pass closes the local sectorial-existence
question as well.  The zero-exponential rank-two atom is the middle term of the
unique `1,2,1` sectorial lift for every admissible phase, not only for the
certified representative `pi/2`; root monodromy merely exchanges the outer
lines.  Iritani's toric theorem then shows that sectorial blow-up decompositions
themselves are not the missing technology.  His explicit residual-center
caveat and Riemann--Hilbert formulation move the exact gate one level deeper:
identify the residual mutation system with the center's mutation system and
make that identification strict for irregular Hodge filtrations.  The full
identification is sufficient but stronger than logically necessary: a
composable strict identification of only the cubic-isotypic zero-exponential
graded piece and its relative Rees lattice would already carry the obstruction.
Formal `F`-bundle uniqueness and fixed-Landau--Ginzburg compactification
independence do not determine even this restricted analytic Stokes datum.

The current `T1/T2/T3` `ej`+`tt` closeout extracts the cheap generalization and
tests the hidden hypotheses.  The point/curve strictness calculation does not
use their dimensions: equation (5.28) gives the same double-graded result in
every codimension, so the certificate now checks `2 <= r <= 25`.  Retaining
`U=I+N` is the minimum extra structure that makes the endpoint length visible;
discarding it makes the claimed Krull--Schmidt argument false.  The `tt`
challenge asks what forces a threefold center to be a Mori fibre space.  Weak
factorization supplies no such hypothesis, and the hyperplane hypersurface
examples refute the proposed exhaustion immediately.  The Fano sweep is
therefore not queued as a proof task.  The unexplained quantity is now cleaner:
the maximal `+/-1/6`-isotypic enriched Jordan length on arbitrary Calabi--Yau
and general-type threefolds.  This remains owned by active C907 rather than a
new discovery-track item until the arbitrary-center bound acquires a viable
mechanism or a counterexample.

## 9. Reproduction

Working directory: repository root `/home/tavis/src/othello`.

Generate the canonical certificate with SageMath 10.7:

```sh
nix shell nixpkgs#sage --command sage \
  notes/2026-08-10-c907-quantum-monodromy-stabilization.sage \
  --bound 24 \
  --output notes/2026-08-10-c907-quantum-monodromy-stabilization.json
```

Check it without modifying the worktree:

```sh
nix shell nixpkgs#sage --command sage \
  notes/2026-08-10-c907-quantum-monodromy-stabilization.sage \
  --bound 24 \
  --check notes/2026-08-10-c907-quantum-monodromy-stabilization.json
```

Independent replay with SymPy 1.14.0:

```sh
nix shell nixpkgs#uv --command uv run --with sympy==1.14.0 python \
  notes/2026-08-10-c907-quantum-monodromy-stabilization-independent.py \
  notes/2026-08-10-c907-quantum-monodromy-stabilization.json
```

The certificate is canonical JSON with no timestamps or host paths.  The
tracked `SHA256SUMS` file records:

- Sage generator: 51,030 bytes;
- independent replay: 21,303 bytes;
- JSON certificate: 353,156 bytes.

Trusted boundary: Sage exact matrix arithmetic, Jordan form, cyclotomic-field
arithmetic, and SymPy symbolic simplification; the mathematical identification
of the source matrices, the cubic period with its hypergeometric quantum
module, the hypotheses of the cited irregular-Hodge theorems, Iritani's
asymptotic formulae, the identification of the exponential factors with
Stokes heights, the quantum Kunneth/projective-bundle formula, and the geometric
identification of the two standard blow-up order exchanges is human-audited.
The bounded checks do not assert existence or nonexistence of any weak
factorization or the missing residual-center mutation-system and global
irregular-Hodge/Rees/Stokes compatibility.

## 10. Sources

- Jiaji Cai, *The cubic threefold is symplectically irrational*,
  arXiv:2608.01577v1, especially Proposition 6 and Sections 2--3.  Cached PDF
  SHA-256:
  `06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e`.
- Ludmil Katzarkov, Maxim Kontsevich, Tony Pantev, and Tony Yue Yu,
  *Birational Invariants from Hodge Structures and Quantum Multiplication*,
  arXiv:2508.05105v2, especially Theorems 4.5 and 4.11, Sections 4.2--4.3,
  and Section 5.4.  The analytic-germ and disjoint-union scope used in the
  negative spectral-cycle audit is explicit in those two decomposition
  theorems.  Cached
  PDF SHA-256:
  `2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64`.
- Hiroshi Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555,
  especially (5.11), (5.19), (5.27), (5.28), Theorem 5.18, and Remark 1.5.  The
  formulae give the exact local `q`-adic elementary divisors; the theorem
  preserves the connection and Poincaré pairing in the formal direct sum; the
  remark locates the missing Γ-integral/Stokes semiorthogonal compatibility.
  Shared-cache PDF SHA-256:
  `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`.
- Hiroshi Iritani, *Gamma classes and quantum cohomology*, arXiv:2307.15938,
  especially Sections 1.3, 2.4, and 3.3 and Conjecture 2.13.  The Gamma lattice
  is defined in analytic flat sections; the exponential decomposition lifts
  sectorially and yields a phase-dependent mutation system.  Birational
  functoriality and the blow-up Riemann--Hilbert reconstruction are
  conjectural at this level.  Shared-cache PDF SHA-256:
  `462f2e0d6eff6315d9fcc2e0db78f95f14558d532d118e31b74f2270c2e0ab8a`.
- Hiroshi Iritani, *Fourier analysis of equivariant quantum cohomology*,
  arXiv:2501.18849, especially Remark 57, which still presents the
  Γ-integral/Stokes comparison with semiorthogonal decompositions as an
  anticipated relationship.  Shared-cache PDF SHA-256:
  `7a949edc17fe87f2af306dc663a95056e4636e8c312df09303c6f6f702afdc39`.
- Hiroshi Iritani, *Global Mirrors and Discrepant Transformations for Toric
  Deligne--Mumford Stacks*, arXiv:1906.00801, especially Theorem 1.3 on the
  toric sectorial lift, Remark 1.4(3) on the unknown residual-center Stokes
  comparison, and Conjecture 8.3 with Proposition 8.5 on the mutation-system
  Riemann--Hilbert gate.  Shared-cache PDF SHA-256:
  `dc25e5cbd849ee5daa7643d69ae2e77936d5cd343ceb66ce8bbd8e03fbf874c7`.
- Thorgal Hinault, Tony Yue Yu, Chi Zhang, and Shaowu Zhang, *Decomposition and
  framing of F-bundles and applications to quantum cohomology*,
  arXiv:2411.02266, especially Theorems 1.1, 1.2, 5.22, and 5.24.  These prove
  formal/non-archimedean decomposition and uniqueness, not the analytic Stokes
  or nc-Hodge comparison.  Shared-cache PDF SHA-256:
  `a11a093f790890804c7d4f7559b30ed2a6da87811de46f2aa0d29026e343e6bd`.
- Franziska Bittner, *The universal Euler characteristic for varieties of
  characteristic zero*, arXiv:math/0111062, especially Theorem 3.1's
  presentation of `K_0(Var_k)` by smooth complete varieties and blow-up
  relations.  This establishes abstract motivic coherence, not a filtered
  quantum realization.  Shared-cache PDF SHA-256:
  `484d2c3586977503dc6f1b43fca158af059cd0f9c5322731d0ebae6d643e160c`.
- Claude Sabbah, *Irregular Hodge theory*, arXiv:1511.00176v5, especially
  Theorems 0.3, 0.7, and 3.39 on strictness, canonical filtrations for rigid
  locally formally unitary connections, and Thom--Sebastiani.  Shared-cache
  PDF SHA-256:
  `8221dd998d7b6459c525255c92755b2a60229088eb851a182be961528540b3ba`.
- Claude Sabbah and Jeng-Daw Yu, *On the irregular Hodge filtration of
  exponentially twisted mixed Hodge modules*, arXiv:1406.1339, especially the
  strict projective-pushforward and Kontsevich-bundle comparison.  Shared-cache
  PDF SHA-256:
  `d034597e2f31a3cf400130b2a9124733438062014a603c82c0a54ea7a2cec22d`.
- Yichen Qin and Dingxin Zhang, *Classical and irregular Hodge numbers*,
  arXiv:2603.06040, especially Theorems 1.1.1 and 1.3.1.  These identify the
  numerical irregular filtration with limiting Hodge data and prove
  deformation invariance for non-degenerate functions; they do not establish
  filtered quantum blow-up compatibility.  Shared-cache PDF SHA-256:
  `95b699eb50c830dea8b5b6241bcc4450e1be8c72b50f20350741101b9efed6f5`.
- Thomas Reichelt and Christian Sevenheck, *Hypergeometric Hodge modules*,
  arXiv:1503.01004, especially Theorem 6.6 on the reduced quantum `D`-module
  of a nef complete intersection in a toric variety.  It applies to
  `(P^4,O(3))`.  Shared-cache PDF SHA-256:
  `1bb0f17b52203927e8bd536c706f2f871b7bee59fd35196d987d2ef6284541e8`.
- Alberto Castaño Domínguez, Thomas Reichelt, and Christian Sevenheck,
  *Examples of hypergeometric twistor D-modules*, arXiv:1803.04886,
  especially Proposition 5.2 and Theorem 5.7 on irreducibility, parameter
  shifts, and the IrrMHM upgrade.  Shared-cache PDF SHA-256:
  `134b742e3d698d1ecd6d9b6eca4dafd6f59fe264ae8e21aa0e46fb6f7fa991f5`.
- Takahiro Saito, *The Hodge filtration of a monodromic mixed Hodge module and
  the irregular Hodge filtration*, arXiv:2204.13381, especially Theorems
  1.1, 1.4, and 1.5.  These control Fourier--Laplace transforms once a
  monodromic mixed-Hodge input is given; they do not construct the arbitrary
  master-space quantum input.  Shared-cache PDF SHA-256:
  `59e2c7e55867f6abc0e3ce54f2ac9cfdf2b02225d43e4a492a54ad04070ad65e`.
- Haoxu Wang, *Compactification Independence of the Irregular Hodge Filtration
  on Deligne--Mumford Stacks*, arXiv:2608.06234, especially Theorems 1.1 and
  4.11.  These give filtered comparison under boundary blow-ups of a fixed
  Landau--Ginzburg model, not Iritani's additive A-model blow-up formula.
  Shared-cache PDF SHA-256:
  `6a3343410d2f4e9867d19fde778dd541867b579187393f4922d3202a84bd34fa`.
- Vladimiro Benedetti, Aideen Fay, Jérémy Guéré, Laurent Manivel, and
  Nicolas Perrin, *An atomic criterion for irrationality without quantum
  computations*, arXiv:2607.26718v1, especially Section 2 on atoms of
  surfaces.  This is corroborating context; the exponent restriction above is
  derived directly from KKPYY Claim 6.15 and surface classification.  Cached
  PDF SHA-256:
  `bb1ee656bd55008a5403e057d0856e65c81b100f2fa07d1c90e184766dd0f407`.
- Soheyla Feyzbakhsh and Laura Pertusi, *Serre-invariant stability conditions
  and Ulrich bundles on cubic threefolds*, arXiv:2109.13549, especially the
  cubic-threefold relation `S^3=[5]` for `Ku(X)`.
- Alexey Elagin and Valery Lunts, *Three notions of dimension for triangulated
  categories*, arXiv:1901.09461, especially additivity of Serre dimension and
  the Hirzebruch-surface counterexample to general monotonicity.

## Mystery ledger

- **Settled:** the fractional block is not destroyed by stabilization;
  projective space replicates it `m+1` times with unchanged residues.
- **Settled:** raw multiplicity, parity, and positivity cannot be the stable
  obstruction from `m>=2`; the explicit self-carrier balances explain why.
- **Settled:** no surface carries the cubic fractional block; consequently
  `X x P^1` is irrational for every smooth cubic threefold.
- **Settled locally, open globally:** Iritani's initial exceptional Fourier
  matrix has consecutive `q`-adic elementary divisors, so the chosen blow-up
  boundary already recovers the unordered Tate width and cyclic root monodromy
  preserves it.  What is open is whether these relative lattices descend to a
  presentation-independent filtered quantum object respected by composed
  blow-up and projective-bundle isomorphisms.
- **New positive `T1` pilot:** Iritani (5.28) is strict at `Q=theta=0` after
  the `t`-adic and exceptional-first dominance associated gradeds.  The
  fivefold point and curve cases pass exactly, and the certificate extends the
  same block argument through codimension 25.  Mystery: whether this persists
  over the full parameter space and lifts to the analytic Gamma/Stokes lattice.
- **New `T2` correction:** plain `C[[t]]`-modules do not remember block length.
  The enriched pair `(R^ell,I+N_ell)` is indecomposable because its endomorphism
  order `R[N]/(N^ell)` is local.  Mystery: whether the full filtered
  Gamma/Stokes category produced by `T1` has the finite, strict direct-sum
  structure needed for a global Krull--Schmidt telescope.
- **Settled for the first composition relations:** the associated-graded Tate
  polynomial is identical under transverse and nested two-step blow-up order
  exchanges, and Bittner's presentation makes the abstract motivic blow-up
  ledger factorization-independent.  The missing object is an intrinsic
  filtered quantum realization of that ledger.  The `P^1` mutation calculation
  simultaneously proves that Euler and Serre data do not select the exceptional
  flag; its canonical monodromy-weight line is a third line.
- **Settled globally and sectorially:** the full reduced ambient cubic
  quantum module is the irreducible hypergeometric module
  `H(0,0,0,0;1/3,2/3)` and underlies an irregular mixed Hodge module.  Cai's
  local formal ranks are `1,1,2`; irreducibility therefore rules out the
  rank-two block as a proper global subobject.  For every admissible phase its
  unique sectorial realization has ordered ranks `1,2,1`; the zero-exponential
  rank-two middle block is fixed by root monodromy.
- **Open, with two exact near-misses:** Iritani proves the sectorial
  Gamma-integral/Orlov decomposition for weak-Fano toric blow-ups, but
  explicitly leaves equality between each residual Stokes structure and the
  center quantum module open.  Hinault--Yu--Zhang--Zhang make the formal map
  unique but do not add this analytic datum.  Wang proves filtered
  compactification independence for one fixed Landau--Ginzburg pair, not an
  A-model target blow-up adding centers.  The exact missing object is the
  residual-center mutation-system identification, strict for the irregular
  Hodge filtration and composable through weak factorization.
- **Open target:** preserve the cubic-isotypic
  unipotent Serre block.  Its endpoint length is `m+1`, while every
  self-carrier length is `m-1`; the conditional arbitrary-center width formula
  has the same gap two.  Evidence gap: current formal gauges allow integer
  powers of `z`, the atom formalism quotients them out, and Γ-integral/Stokes
  blow-up compatibility and factorization-independent Rees lattices are not
  yet available in the cited theory.  The theorem
  must be strict on the filtration and additive on its associated graded;
  preservation of the Euler pairing or Serre operator alone is insufficient.
- **Open:** whether geometric constraints on centers forbid the formal
  self-carrier balances in a minimal weak factorization.  Evidence gap: no
  common resolution or non-realizability theorem is known.
- **Open:** whether the surface argument can be promoted to a recursive
  minimum-carrier theorem in higher dimensions.  Section 7 isolates an exact
  Serre-dimension gap `2/3`, but exploiting it requires both a gluing-sensitive
  enhancement that prevents the `m+1` projective summands from being
  distributed among centers and a restricted fractional-Calabi--Yau carrier
  inequality.  General Serre-dimension monotonicity is false.
- **Settled negatively for the proposed silver shortcut:** arbitrary
  threefold centers are not exhausted by Fano, conic-bundle, and del Pezzo
  cases.  Quintic and sextic threefolds inside `P^4` inside `P^5` give
  Calabi--Yau and general-type smooth centers.  A Fano database sweep remains
  useful reconnaissance but cannot prove `X x P^2` irrational.  Mystery: the
  `+/-1/6` carrier length for Calabi--Yau and general-type threefolds.
- **Settled negatively at the present formal level:** `p`-primary
  spectral-cycle length is not part of the local analytic-germ invariant used
  by the cited blow-up and projective-bundle theorems.  Prime-power
  self-carrier exclusion remains an exact diagonal-loop calculation, but
  dimension-admissible iterated projective-bundle towers and their possible
  wreath monodromy defeat any descent based only on local copies and
  dimension.  A substantially stronger global enhancement would be needed.
