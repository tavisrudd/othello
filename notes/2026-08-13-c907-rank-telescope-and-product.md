# C907 — rank telescope and projective-product endpoint

Date: 2026-08-13

Status: exact endpoint product and exact one-blow-up equivalence inside one
receiver.  The global rank telescope remains conditional: the
formal-constant banking audit found no functorial full-Novikov morphism from
the `z=0` primitive-sixth packet to the Gamma rank line.  Adjacent receivers
can differ by Stokes shears, so their scalar constants do not yet compose.

## 1. The framed packet

For a smooth projective variety `Y`, let `P_6(Y)` be the generalized
primitive-sixth formal-monodromy packet of its quantum connection on the
chosen fixed phase.  On its Gamma realization define

\[
 \mathfrak r_Y(v)=(-1)^{\dim Y}[s(\mathcal O_y),v),
 \tag{1}
\]

where `y` is a general point and `[ , )` is the two-flat-section pairing.
For a Gamma class `s(E)`, Iritani's integral-structure identity gives

\[
 \mathfrak r_Y(s(E))=(-1)^{\dim Y}\chi(\mathcal O_y,E)
 =\operatorname{rk}(E)
 \tag{2}
\]

up to the fixed global sign convention.  Thus `r_Y` is intrinsic and
additive; it does not depend on an exceptional-collection basis.

The cubic Barnes calculation already on disk proves

\[
 \mathfrak r_X|_{P_6(X)}\ne0
 \tag{3}
\]

on each of the two conjugate primitive branches of every smooth cubic
threefold.

## 2. One blow-up, in both directions

Let `p:Ytilde=Bl_Z(Y)->Y` be a nontrivial smooth blow-up.  The sectorial
receiver gives a direct-sum decomposition

\[
 P_6(\widetilde Y)=P_6(Y)_{\rm amb}
 \oplus\bigoplus_j P_6(Z)_j
 \tag{4}
\]

compatible with the full formal ambient Novikov connection.  Its unit-column
and constancy statements give

\[
 \mathfrak r_{\widetilde Y}|_{P_6(Y)_{\rm amb}}=\mathfrak r_Y,
 \qquad
 \mathfrak r_{\widetilde Y}|_{P_6(Z)_j}=0.
 \tag{5}
\]

The second equality is also transparent categorically: every exceptional
Orlov image is supported on the exceptional divisor and has ordinary rank
zero.  It is unaffected by tensoring that image with `O(kE)` or by mutating
the center blocks from one side of the ambient block to the other.

Equations (4)--(5) prove the equivalence

\[
 \mathfrak r_{\widetilde Y}|_{P_6(\widetilde Y)}\ne0
 \quad\Longleftrightarrow\quad
 \mathfrak r_Y|_{P_6(Y)}\ne0.
 \tag{6}
\]

Indeed, the forward implication projects a vector with nonzero rank onto the
ambient summand; all center projections have rank zero.  The reverse
implication uses the ambient inclusion.  This is why a blow-down needs no
inverse analytic comparison: it is the forward implication of the same
blow-up identity.

## 3. Weak-factorization telescope

Suppose two smooth projective varieties of the same dimension are birational.
Weak factorization in characteristic zero supplies a finite zigzag whose
arrows are smooth blow-ups or their inverses.  Divisorial centers may be
deleted because their blow-ups are identities, so every retained center has
codimension at least two.

If the restrictions in (6) are identified functorially across incident
receivers, apply (6) at every arrow.  The truth value

\[
 \mathfrak r_Y|_{P_6(Y)}\ne0
 \tag{7}
\]

is then unchanged through the whole zigzag.  No cancellation or
Krull--Schmidt argument is needed: the scalar functional itself annihilates
every exceptional summand before any sum is taken.  Composition would then be automatic
because (7), rather than a chosen block basis or point section, is the
transported datum.

Independent fixed-`q` analytic receivers cannot be composed by specializing
old formal variables to nonzero numbers.  The numerical Novikov divisor
derivations do have simultaneous constant field `C`, so pairings already
defined in one horizontal category are complex constants.  But this does not
construct the restriction of the large-radius Gamma point covector to the
`z=0` formal packet over the full Novikov base.  Two incident receivers can
realize that packet through different Stokes embeddings.  The exact remaining
gate is a functorial morphism `P_6 -> 1`, a proof that the relevant Stokes
transitions preserve it, or one coherent two-arrow receiver.  See
`2026-08-13-c907-formal-constant-banking.md`.

This also resolves the orientation issue.  Shen--Shoemaker's integer `k`
chooses an Orlov order needed to label sectorial blocks.  But every center
block has rank zero in every order, so the telescope is independent of `k`.

## 4. Product endpoint

For `n=m+1`, the projective-space quantum connection has `n` rank-one formal
solutions whose fractional formal exponents are zero.  Quantum Kunneth gives
the tensor connection, so

\[
 P_6(X\times\mathbf P^m)
 \cong P_6(X)\otimes H^*(\mathbf P^m)
 \tag{8}
\]

as the framed primitive-sixth packet.  In particular it contains `m+1`
copies of the cubic packet with unchanged fractional exponents.

Iritani's extended Gamma integral structure is natural for Cartesian
products.  For the even external products used here the flat pairing and rank
multiply:

\[
 [s(E_1\boxtimes F_1),s(E_2\boxtimes F_2))
 =\chi(E_1,E_2)\chi(F_1,F_2),
 \qquad
 \operatorname{rk}(E\boxtimes F)=\operatorname{rk}(E)\operatorname{rk}(F).
 \tag{9}
\]

Take the Gamma section of `O_(P^m)`, whose rank is one.  It need not be a
single Fourier eigenline: the aggregate projective-space solution has only
integral fractional exponents, so tensoring its entire formal decomposition
with the cubic primitive-sixth packet remains inside the aggregate
primitive-sixth product packet.  Product naturality and (3) therefore yield

\[
 \mathfrak r_{X\times\mathbf P^m}|_{P_6(X\times\mathbf P^m)}\ne0
 \qquad(m\ge0).
 \tag{10}
\]

By contrast, every formal block of projective space has integral exponent, so

\[
 P_6(\mathbf P^{m+3})=0.
 \tag{11}
\]

Equations (7), (10), and (11) contradict any birational map
`X times P^m dashrightarrow P^{m+3}`.

For Gold one takes `m=2`.  The same assembly is uniform in `m`.

## 5. Hostile checks

1. **Center with its own cubic packet.**  It causes no problem.  Equation (5)
   uses support/rank, not absence of a primitive-sixth eigenvalue.
2. **Blow-down.**  No preferred inverse gauge is chosen.  Projection to the
   ambient direct summand and vanishing on the center summands prove the
   forward half of (6).
3. **Mutation or nonzero `k`.**  Exceptional objects remain supported on the
   exceptional divisor after every `O(kE)` twist; their rank remains zero.
4. **Confluence at `Q=0`.**  Equation (8)'s cubic atom is never followed
   through a blow-up specialization.  The per-arrow comparison is made on the
   unsplit ambient block, and the intrinsic product decomposition is applied
   only at the endpoint.
5. **Ordinary formal monodromy alone.**  It is not the invariant: center
   packets can create the same eigenvalue.  The extra datum in (7) is the
   nonzero Gamma rank functional.
6. **Product phase.**  Choose one nonsingular phase for the cubic and
   projective-space tensor connection.  Extended Gamma product naturality
   gives `s(O_x) tensor s(O_p)=s(O_(x,p))`.  After (10), only the resulting
   same fixed-phase formal packet and rank covector enter the telescope.
7. **Successive exceptional variables.**  The one-arrow Artin receivers do
   not compose by nonzero specialization.  Only their scalar horizontal
   pairing values are banked; the next arrow reconstructs its own receiver
   over the full formal base.

## AA / EJ / TT

- **AA:** telescope the Boolean statement `rank functional nonzero`, not a
  marked basis vector, a center row, or a Jordan block.
- **EJ:** the same rank-zero observation removes the apparent
  high-codimension `O(kE)` obstruction.  The first `k != 0` case is still a
  useful normalization regression, but it is not load-bearing for (6).
- **TT:** the factorization transports an intrinsic functional on a formal
  monodromy packet.  Any proof phrased as transport of a chosen atom through
  `Q=0` has changed the datum and reintroduced the confluence gap.

## Sources

- H. Iritani, *Gamma classes and quantum cohomology*, arXiv:2307.15938v1,
  Section 1.2 and Remark 1.2 (extended product naturality).
- H. Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3,
  Theorem 5.18.
- Y. Shen, M. Shoemaker, *Quantum spectrum and Gamma structure for standard
  flips*, arXiv:2502.08762v2, Theorem 1.4 and Remark 1.6.
- The projective-product formal calculation and the projective-space endpoint
  are recorded in `2026-08-10-c907-quantum-monodromy-stabilization.md`,
  Sections 2--3.
