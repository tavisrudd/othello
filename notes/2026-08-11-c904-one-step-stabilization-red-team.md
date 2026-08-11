# C904 one-step stabilization bridge: formal-exponent and cancellation audit

Date: 2026-08-11

Status: independent theorem-level audit of
`notes/2026-08-10-c904-c907-enhanced-atom-bridge-blueprint.md`; no C907,
manuscript, or Lean edit

## Verdict: MINOR

The proposed proof that a smooth cubic threefold \(X\) has irrational
\(X\times\mathbf P^1\) is structurally sound.  Multiplicity two causes no
cancellation problem.  KKPYY define the chemical formula in the free
abelian group on atom equivalence classes, and their projective-bundle
formula gives two positive copies of the cubic atom.  In a telescoped weak
factorization, the only other terms are atoms of centers of dimension at
most two; the sixth-root signature rules every one of them out.

Two small changes make the argument theorem-grade.

1. Replace the boolean \(\varepsilon_6\) in the additive ledger by the
   integer multiplicity \(\nu_6\) of primitive sixth-root formal-monodromy
   eigenvalues.  A boolean is not additive, while \(\nu_6\) is.
2. Define the invariant directly from formal-monodromy eigenvalues, rather
   than asserting that all exponents of every geometric atom lie in
   \(\mathbf Q/\mathbf Z\).  Quasi-unipotence is unnecessary and is not
   supplied for arbitrary atoms.

The smallest theorem-local proof gap is the constancy of formal monodromy
along a connected component of the reduced unramified spectral cover.  It
is a standard consequence of formal flatness, but the blueprint's phrase
“flatness makes the family isomonodromic” is one assertion short of a proof.
The residue-conjugacy calculation in Section 2 below closes it.

Subject to printing that lemma, the bridge is **GO** after minor correction.

## 1. Correct additive invariant

For a geometric atomic F-bundle \(\mathcal A\), let

\[
 \operatorname {FM}(\mathcal A)
\]

be the multiset of eigenvalues of formal monodromy on its
Levelt--Turrittin regular-singular factors, after separating the exponential
parts.  Define

\[
 \nu_6(\mathcal A)=
 \operatorname {mult}_{e^{\pi i/3}}\operatorname {FM}(\mathcal A)
 +\operatorname {mult}_{e^{-\pi i/3}}\operatorname {FM}(\mathcal A).
 \tag{1}
\]

This definition works in \(\mathbf C^\times\) and does not require a chosen
logarithm or rational exponents.  It has the needed properties:

- an isomorphism of meromorphic connection germs conjugates formal
  monodromy;
- an integral \(u\)-power gauge shifts residue eigenvalues by integers and
  leaves (1) unchanged;
- a base change or mirror map which is independent of \(u\) preserves the
  loop and hence formal monodromy;
- external direct sum takes disjoint union of spectra, so \(\nu_6\) is
  additive.

Cai Proposition 6 gives the two residue classes \(\pm1/6\) in the rank-two
zero-eigenvalue block of the big cubic quantum connection.  KKPYY Example
6.21 places that block in the unsplit zero atom \(\alpha_X\).  Hence

\[
 \nu_6(\alpha_X)>0
\]

(indeed the displayed rank-two calculation gives two eigenvalues counted
with multiplicity).

The low-dimensional argument in the blueprint gives

\[
 \nu_6(\beta)=0
 \tag{2}
\]

for every atom \(\beta\) representable by a point, curve, or smooth
projective surface.  For a minimal surface with nef canonical class, KKPYY
Claim 6.15 gauges the parity-corrected connection by an integral grading to
a regular-singular connection with nilpotent residue.  Undoing the
half-parity correction permits only formal-monodromy eigenvalues \(1\) and
\(-1\).  Ruled minimal surfaces reduce to curves by Theorem 4.11, and point
blowups add only point atoms by Theorem 4.5.  This exhausts smooth projective
surfaces over \(\mathbf C\).

## 2. Formal-monodromy constancy on one atom

The source definition identifies geometric atomic F-bundle germs at points
of one connected component of the reduced unramified spectral cover.  To
make (1) an invariant of this equivalence, use the following local lemma.

> **Formal-isomonodromy lemma.**  Let \((H,\nabla)\) be a flat F-bundle on
> \(S\times\operatorname {Spf}K[[u]]\), and let \(S'\to S\) be a connected
> unramified spectral component.  After a finite formal ramification in
> \(u\) and separation of the exponential factors, the conjugacy class of
> formal monodromy of each resulting block is locally constant on \(S'\).
> Consequently its eigenvalue multiset is constant on \(S'\), up to
> permutation under descent.

Indeed, after the formal decomposition and an admissible gauge, a block has
the form

\[
 \nabla=d-d\Phi(s,u)+R(s)\frac{du}{u}
       +\sum_i\Gamma_i(s,u)\,ds_i,
 \tag{3}
\]

with \(\Gamma_i\) formal-regular after the exponential term has been
removed.  The coefficient of \(du/u\wedge ds_i\) in \(\nabla^2=0\) gives

\[
 \partial_{s_i}R=[\Gamma_i(s,0),R].
 \tag{4}
\]

Thus the characteristic polynomial of \(R\), and hence that of
\(\exp(2\pi iR)\), is locally constant.  Integral lattice gauges change the
eigenvalues of \(R\) by integers, while descent can only permute blocks.
This proves the lemma and makes \(\nu_6\) well-defined on the equivalence in
KKPYY Definition 5.21.

The unramified hypothesis is used to keep the formal block separated while
moving in \(S'\).  The lemma does not claim constancy across the discriminant
where spectral components meet.

## 3. Multiplicity two and exact no-cancellation

KKPYY Definition 5.16 forms the set of atom equivalence classes.  Immediately
after Proposition 5.17 they use

\[
 \mathbf Z^{\oplus\operatorname {Atoms}_G}
\]

as the **free abelian group** on those classes, and chemical formulas have
nonnegative integer coefficients.  Proposition 5.22(3), using Theorem 4.11,
states

\[
 \operatorname {CFF}_G(\mathbf P(V))
 =\operatorname {rank}(V)\operatorname {CFF}_G(X).
\]

For \(Y=X\times\mathbf P^1\), this gives

\[
 [\alpha_X]\text{ occurs with coefficient }2
 \quad\text{in }\operatorname {CFF}_G(Y).
 \tag{5}
\]

There is no operation in the atom group which turns two equal positive
copies into zero.  More explicitly, suppose a birational map
\(Y\dashrightarrow\mathbf P^4\) is weakly factorized.  Telescoping the
blowup identities gives an equality in the free abelian group

\[
 \operatorname {CFF}_G(Y)+\sum_i(r_i-1)\operatorname {CFF}_G(Z_i)
 =\operatorname {CFF}_G(\mathbf P^4)
  +\sum_j(s_j-1)\operatorname {CFF}_G(W_j),
 \tag{6}
\]

where every center \(Z_i,W_j\) has dimension at most two.  Apply the unique
additive extension of \(\nu_6\) to the free group.  By (2), all center terms
vanish.  The projective-bundle formula over a point gives
\(\nu_6(\mathbf P^4)=0\), while (5) gives

\[
 \nu_6(Y)=2\nu_6(X)\ge2\nu_6(\alpha_X)>0.
\]

This contradicts (6).  The same argument can be phrased coefficientwise in
the basis element \([\alpha_X]\); the additive \(\nu_6\) formulation makes
the absence of cancellation visible without requiring injectivity of the
map from abstract atoms to geometric atomic F-bundles.

Multiplicity two is therefore helpful but not load-bearing: one copy of an
atom excluded in dimensions at most two would already invoke KKPYY
Proposition 5.17.

## 4. Source verification and residual cautions

The following clauses were checked in the cached primary texts.

- Cai, arXiv:2608.01577v1, Proposition 6: the big cubic quantum connection
  has \(z^\rho\) solutions with \(\rho\equiv\pm1/6\pmod{\mathbf Z}\), in its
  rank-two Jordan block.
- KKPYY, arXiv:2508.05105v2, Theorem 4.11: the maximal F-bundle of a rank-
  \(r\) projective bundle is canonically isomorphic on connected nonempty
  analytic domains to that of \(r\) disjoint copies of the base.
- KKPYY Definition 5.10: atom multiplicity is the degree of the connected
  unramified spectral-cover component.
- KKPYY Proposition 5.17: an atom not representable in dimension
  \(d-2\) obstructs rationality of a \(d\)-fold.
- KKPYY Proposition 5.22(3): the geometric atomic F-bundle formula is exactly
  \(\operatorname {CFF}_G(\mathbf P(V))=r\operatorname {CFF}_G(X)\).
- KKPYY Claim 6.15 and Example 6.21: the nef-surface parity gauge has
  nilpotent residue, and the cubic zero atom is unsplit near the hyperplane
  point.

Primary files:

- `arXiv:2608.01577`, PDF SHA-256
  `06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e`;
- `arXiv:2508.05105`, PDF SHA-256
  `2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64`.

Two cautions remain for exposition, not correctness.

1. Cai's algebraic/formal rank-two calculation should be explicitly
   identified with the corresponding formal block of the maximal F-bundle;
   the common big quantum connection makes this a scalar-extension step,
   not a new theorem.
2. State that every atom equivalence used by KKPYY preserves the loop
   coordinate \(u\).  A ramified reparametrization \(u\mapsto u^m\) would
   change sixth-root eigenvalues, but it is not among Definitions
   5.21--5.22 or the blowup/projective-bundle F-bundle isomorphisms.

## Mystery ledger

- **Settled:** multiplicity two is two positive coefficients in a free atom
  group; it cannot self-cancel.
- **Settled:** the additive sixth-root count kills every possible
  weak-factorization center in dimension at most two.
- **Settled:** formal monodromy is constant along a connected unramified
  spectral component by the residue-conjugacy equation (4).
- **Settled:** no global quasi-unipotence statement is needed; work directly
  with formal-monodromy eigenvalues.
- **Residual exposition check:** print the scalar-extension identification
  between Cai's formal block and KKPYY's maximal F-bundle block.

Vibe check: the bridge is strong and very close to theorem-ready.  The only
real repair is to use an additive eigenvalue count and print the formal
isomonodromy lemma; multiplicity two and atom cancellation are not genuine
obstructions.
