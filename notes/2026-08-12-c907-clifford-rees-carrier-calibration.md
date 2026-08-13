# C907: cubic-line Clifford calibration for the Rees carrier gate

**Lane:** `clebsch`
**Scope:** research-only carrier calibration for `m=2`; no analytic
Stokes/Gamma identification is claimed.

## Verdict

The two-sheeted discriminant of the conic bundle obtained by blowing up a
line in a cubic threefold does carry an exact square-zero *special-fibre*
filtration.  It is a useful model for a one-step cubic carrier, but it does
**not** imply `ell_(1/6) <= 1` from Clifford geometry alone.  The full ramified
quaternion order has arbitrarily long central-thickening radical chains, and
the actual cubic Clifford category contains a canonical nonzero derived
extension.  Thus the proposed automatic carrier theorem is false at the
level of the order/category; the missing input is precisely a strict,
value-localized Stokes/Rees realization which kills the central normal
parameter and identifies the Rees arrow with the reduced radical.

This separates the two invariants cleanly:

* `nu_6` is a formal-monodromy multiplicity of the quantum connection.  The
  discriminant double cover neither defines it nor bounds it.
* `ell_(1/6)` is the length of a strict Stokes/Gamma Rees packet.  The
  Clifford special fibre supplies a candidate square-zero model for one
  arrow, conditional on an unproved analytic identification.

## The exact local Clifford statement

Let `R` be a strictly henselian DVR of characteristic different from two,
with uniformizer `t`.  Suppose a conic bundle has a simple degeneration over
`t=0`.  Etale locally its rank-three quadratic form is

\[
q=\langle 1,-1,t\rangle .
\]

Its even Clifford order is

\[
A=\operatorname{Cl}_0(q)\simeq
\begin{pmatrix}R&R\\tR&R\end{pmatrix}. \tag{1}
\]

Indeed, for Clifford generators `e_i` with squares `1,-1,t`, respectively,
send

\[
 e_1e_2\longmapsto\begin{pmatrix}1&0\\0&-1\end{pmatrix},\qquad
 e_1e_3\longmapsto\begin{pmatrix}0&1\\-t&0\end{pmatrix}.
\]

Together with the identity and their product, these span exactly the order
in (1), since two is a unit.  This is also the elementary local form behind
the rank-four even-Clifford order of Chan--Ingalls.

Put `A_0=A/tA`.  There is a canonical quotient after the two idempotents are
split etale-locally,

\[
 A_0\twoheadrightarrow k\oplus k,
 \qquad
 N=\ker(A_0\to k\oplus k)
   =k\,e_{12}\oplus k\,(t e_{21}),
 \qquad N^2=0. \tag{2}
\]

Globally on a smooth discriminant curve `C`, the two diagonal factors glue
to the etale degree-two component cover `p:\widetilde C\to C`; hence (2)
descends to a square-zero extension

\[
 0\longrightarrow N\longrightarrow
 \mathcal B_0|_C\longrightarrow p_*\mathcal O_{\widetilde C}
 \longrightarrow0,
 \qquad N^2=0. \tag{3}
\]

Consequently every `\mathcal B_0|_C`-module has the two-step radical
filtration `0\subset NM\subset M`.  This statement is about the reduced
discriminant fibre, not about the nearby order.

For a cubic threefold, blowing up a suitably general line gives precisely an
ordinary conic bundle over `\mathbf P^2`, with a smooth plane-quintic
discriminant and its etale degree-two component cover.  This is therefore an
honest calibration of a one-arrow packet, rather than an invented local
analogy.

## Why the square-zero statement does not prove the carrier bound

Let `J` be the Jacobson radical of the local order (1):

\[
 J=\begin{pmatrix}tR&R\\tR&tR\end{pmatrix}.
\]

Direct multiplication gives

\[
 J^2=tA,\qquad
 J^{2r}=t^rA,\qquad J^{2r+1}=t^rJ. \tag{4}
\]

Thus `N^2=0` only after quotienting by the normal parameter `t`; before that
quotient the order has nonzero radical paths of every finite length.  The
two sheets do not split this normal direction; when the component cover is
connected, they do not even supply global diagonal idempotents.

There is independent categorical counterevidence to replacing the entire
Clifford category by (3).  For the cubic line, Bernardara--Macri--Mehrotra--
Stellari identify the cubic residual category with the admissible orthogonal
to `\mathcal B_1` in `D^b(\mathbf P^2,\mathcal B_0)`.  Their Example 2.11
constructs the nonzero triangle

\[
 \mathcal B_0[1]\longrightarrow I_{\ell}\Xi
 \longrightarrow\mathcal B_1
 \xrightarrow{\eta}\mathcal B_0[2], \tag{5}
\]

where `\eta` corresponds to the identity of `\mathcal B_1`; it is the unique
nontrivial extension of that form.  The same paper records homological
dimension two for `D^b(\mathbf P^2,\mathcal B_0)`.  Equation (5) is not a
counterexample to a *properly defined* one-step Rees packet, but it proves
that the two-sheeted Clifford datum by itself has not removed higher derived
or normal-direction extension data.

## Conditional theorem worth targeting

**Conditional Clifford--Rees lemma.**  Let a smooth threefold center admit
an ordinary conic-bundle presentation with even Clifford order
`\mathcal B_0` and smooth discriminant cover `p`.  Assume that its
value-localized cubic Stokes/Gamma Rees packet is the exact image of a
`\mathcal B_0|_C`-module, and that its shifted Rees arrow is the exact image
of multiplication by the radical `N` in (3).  Then

\[
 \ell_{1/6}\leq1.
\]

The proof is one line: the square of the Rees arrow is the image of
`N^2=0`.  This is the strongest correct theorem supplied by the Clifford
calibration.  Its hypotheses deliberately contain all missing work:

1. a value-localized, strict Stokes/Gamma realization rather than a numerical
   `K_0` identification;
2. support on the *reduced* discriminant, thereby excluding the `t`-adic
   paths in (4);
3. compatibility of the Rees shift with the radical action; and
4. a geometric reason every arbitrary smooth threefold carrier has such a
   presentation, or a separate MMP reduction to a class for which it does.

At present none of (1)--(4) is available in the C907 architecture.  In
particular, the lemma calibrates the cubic line but cannot serve as the
universal threefold-carrier theorem.

## Consequences for C907

1. The cubic-line conic bundle gives a concrete target for the positive-order
   analytic gate: construct a functor from the value-localized four-thimble
   Rees packet to the radical filtration (3), and prove that the normal
   `t`-direction is absent after localization.
2. A proof using only the discriminant involution, a two-sheeted spectral
   cover, or the fact that a singular conic has two components cannot establish
   `ell_(1/6)<=1`: (4) is a local countermodel before any global geometry is
   invoked.
3. The canonical class (5) is a useful normalization test.  A proposed
   Rees/Clifford bridge should say whether it maps to the allowed single
   cubic arrow, to a sector outside the localized packet, or to zero.  Leaving
   this unspecified risks confusing an ordinary derived `Ext^2` class with
   the sought sectorial Rees extension.

## Source audit

All sources below were read from the shared primary-source cache; this report
uses no computer calculation.

* A. Beauville, *Variétés de Prym et jacobiennes intermédiaires*, 1977,
  Section 1.2 and Example 1.4.1 establish the cubic-line conic bundle; Section
  1.5, Proposition 1.5 gives the etale double component cover for an ordinary
  conic bundle.  Cache key `10.24033/asens.1329`, SHA-256
  `4cf7ebf67a7d0d58c643efdb2d090b3b5fb61b8b7a4dd8e8a743079e9600e1c0`.
* D. Chan and C. Ingalls, *Conic bundles and Clifford algebras*, 2011,
  Section 3: the even Clifford construction, its rank-four conic-bundle
  filtration, and its Azumaya locus.  Cache key `arXiv:1101.1705`, SHA-256
  `25d4ba34eff384c87a9c3331d275d00fcad764e10966f63e2822ff59a964dd4e`.
* M. Bernardara, E. Macri, S. Mehrotra, P. Stellari, *A categorical invariant
  for cubic threefolds*, Section 2, especially (2.1), Proposition 2.9,
  Remark 2.10, and Example 2.11.  Cache key `arXiv:0903.4414`, SHA-256
  `22fcb02de553d5e90d3fc0e1775ed256bbf7253c0af9175b89159a6a9ed1cff9`.

## Mystery ledger (`ej` + `tt` closeout)

* **Settled:** the attractive square-zero mechanism is real, canonical after
  passing to the reduced discriminant, and has a precise two-sheeted meaning.
* **Settled:** it is not a dimension-three automatic nilpotence theorem; the
  normal parameter supplies the exact obstruction `J^2=tA`.
* **Open:** whether the cubic value-localized Stokes packet discards that
  normal parameter.  Evidence required: a strict analytic comparison sending
  the Rees arrow to `N`, with its Gamma lattice and directed thimbles tracked.
* **Open:** whether a useful subclass of arbitrary non-nef threefold centers
  admits an ordinary conic-bundle reduction compatible with that comparison.
  This is an MMP/classification gate, not a local Clifford calculation.
