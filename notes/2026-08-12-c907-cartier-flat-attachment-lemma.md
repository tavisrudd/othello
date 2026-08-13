# C907 Cartier-over-pair-of-pants attachment lemma

**Lane:** `clebsch`

**Status:** proved structural reduction for the full-initial gate.  It turns
scheme-theoretic flat attachment into a fibrewise nonvanishing check for one
normalized Cartier section.  It does not construct the regular refinement or
verify that check on its strata.

## Fibrewise Cartier lemma

Let `S` be noetherian, let `A` be a finitely presented flat `S`-algebra, and
let `G` be an `A`-regular element.  Suppose that, for every geometric point
`s -> S`, the restriction

\[
 G_s\in A_s=A\otimes_{\mathcal O_S}k(s)
\tag{1}
\]

is a non-zero-divisor.  Then `A/(G)` is flat over `S`, and its fibre at `s`
is scheme-theoretically

\[
 A_s/(G_s).
\tag{2}
\]

**Proof.**  The exact sequence

\[
0\longrightarrow A\mathbin{\mathop{\longrightarrow}^{G}}A
 \longrightarrow A/(G)\longrightarrow0
\tag{3}
\]

remains left-exact after tensoring with every geometric residue field by the
hypothesis on `G_s`.  Since `A` is flat, the resulting Tor sequence gives

\[
\operatorname{Tor}_1^{\mathcal O_S}(A/(G),k(s))=0
\tag{4}
\]

at every point.  The local criterion for flatness, applied to the finitely
presented `A`-quotient, gives flatness over `S`.  Right exactness of tensor
product gives (2).  \(\square\)

The same statement holds for an invertible sheaf section on an `S`-flat
scheme after trivializing the line bundle.  Multiplying a local generator by
a unit changes neither hypothesis nor conclusion.

## Application to the marked graph

Each initial degeneration of one marked pair of pants

\[
B+U-1=0
\tag{5}
\]

is one of

\[
B+U-1,qquad B+U,qquad B-1,qquad U-1.
\tag{6}
\]

Every member of (6) is a smooth prime linear hypersurface.  The product of
the two `B/U` and `C/V` degenerations is therefore geometrically integral on
every tripod cone and face.  In the application below we assume that the
chosen regular toroidal refinement carries the corresponding flat log-smooth
pair-of-pants family.  Constructing that refinement and checking this
standard toroidal model are still part of the finite gate.

Pull back the global graph section `Pbar` and divide by precisely the
exceptional multiplicity supported over the complement of the original
dense domain.  Call the resulting strict-transform generator `G_sigma` on a
regular chart.  Because the ambient pair-of-pants fibre is integral,

\[
 G_{\sigma,\tau}\ne0
 \quad\Longrightarrow\quad
 G_{\sigma,\tau}\text{ is a non-zero-divisor}
\tag{7}
\]

for every geometric residue stratum and face `tau`.  The lemma then proves
all of the following at once:

1. the graph quotient is flat over the regular toric base;
2. its scheme-theoretic boundary fibre is obtained by restricting the same
   normalized Cartier section;
3. the full initial complete intersection has the expected codimension; and
4. face attachment is literal restriction, with overlap generators agreeing
   up to the units already supplied by the global Cartier closure.

Thus a separate Groebner-basis or saturation computation for each of the
81,367 support cells is unnecessary.  The finite attachment certificate can
instead record

\[
(\sigma,\tau; e_{\sigma},\ G_{\sigma,\tau},
  G_{\sigma,\tau}\ne0,
  \text{smoothness normal form}),
\tag{8}
\]

where `e_sigma` is the genuine exceptional multiplicity.  The pair-of-pants
relations themselves need not be re-certified cell by cell.

## What remains nonformal

The implication (7) does not say that the restriction is nonzero.  A support
mask can become zero after imposing one of the linear equations (6), and an
incorrect exceptional division can make an entire boundary component appear
or disappear.  Consequently the remaining replay must still:

- serialize a regular integral refinement;
- compute the exact exceptional multiplicity of the pulled-back global
  section on every chart;
- reduce `G_sigma` modulo the applicable equations (6), retaining residue
  coefficients;
- prove the reduced section is not identically zero on every geometric
  residue stratum and face; and
- attach its smoothness to the unit-circuit or reciprocal-linear lemma.

Smoothness is stronger than (7) and remains a separate Jacobian statement.
Likewise, flat graph attachment says nothing about submersivity of the value
map on a coarser control stratum; the stratumwise Fitting replay is unchanged.

## EJ/TT and mystery ledger

- **EJ:** the global Cartier section and the prime tripod initials replace an
  81,367-record full-ideal ledger by a much smaller exceptional-order and
  nonvanishing ledger.
- **TT:** the invariant datum is not a support mask but a section of a line
  bundle on the initial pair-of-pants fibre.  Once phrased that way, flatness
  and face compatibility are formal; only vanishing and smoothness carry
  geometric content.
- **Settled:** scheme-theoretic flat attachment and expected codimension from
  fibrewise regularity of the normalized section.
- **Open:** construction of the regular refinement and the finite verification
  of exceptional orders, nonvanishing, and smoothness normal forms.
