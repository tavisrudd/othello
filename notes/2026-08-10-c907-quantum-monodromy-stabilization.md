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
The present formal category explicitly permits integer-power gauge changes and
therefore forgets precisely this grading.  The next theorem needed is a
birationally functorial filtered or integral-exponent enhancement of the
quantum atom, or a proof that such an enhancement cannot exist.

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
The polynomial separation therefore identifies the missing structure rather
than proving stable irrationality.  A Γ-integral or Stokes enhancement would
have to recover an absolute filtration through this cyclic monodromy.  KKPYY
explicitly identify integral enhanced atoms and their blow-up compatibility as
future work rather than an available theorem.

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

- Sage generator: 20,082 bytes;
- independent replay: 8,657 bytes;
- JSON certificate: 188,133 bytes.

Trusted boundary: Sage exact matrix arithmetic, Jordan form, cyclotomic-field
arithmetic, and SymPy symbolic simplification; the mathematical identification
of the source matrices and the quantum Kunneth/projective-bundle formula is
human-audited.  The bounded checks do not assert existence or nonexistence of
any weak factorization.

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
- **Open:** whether the integer/Tate grading has a canonical filtered quantum
  refinement respected by the blow-up and projective-bundle isomorphisms.
  Evidence gap: current formal gauges allow integer powers of `z`, the atom
  formalism quotients them out, projective Novikov monodromy cyclically
  permutes every candidate label, and Γ-integral blow-up compatibility is not
  yet available in the cited theory.
- **Open:** whether geometric constraints on centers forbid the formal
  self-carrier balances in a minimal weak factorization.  Evidence gap: no
  common resolution or non-realizability theorem is known.
- **Open:** whether the surface argument can be promoted to a recursive
  minimum-carrier theorem in higher dimensions.  Section 7 isolates an exact
  Serre-dimension gap `2/3`, but exploiting it requires both a gluing-sensitive
  enhancement that prevents the `m+1` projective summands from being
  distributed among centers and a restricted fractional-Calabi--Yau carrier
  inequality.  General Serre-dimension monotonicity is false.
- **Settled negatively at the present formal level:** `p`-primary
  spectral-cycle length is not part of the local analytic-germ invariant used
  by the cited blow-up and projective-bundle theorems.  Prime-power
  self-carrier exclusion remains an exact diagonal-loop calculation, but
  dimension-admissible iterated projective-bundle towers and their possible
  wreath monodromy defeat any descent based only on local copies and
  dimension.  A substantially stronger global enhancement would be needed.
