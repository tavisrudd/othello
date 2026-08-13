# C907 — formal-constant banking across a blow-up zigzag

Date: 2026-08-13

Status: exact constant-field lemma, but **not** a composition theorem.  A
hostile audit found that the proposed banking step presupposes the missing
object: a functorial full-Novikov horizontal morphism from the formal
primitive-sixth packet to the constant object.  Adjacent arrow receivers can
realize the formal packet through different Stokes embeddings.  Scalar
constancy does not identify those embeddings, so Gold remains open.

## 1. The constant-field lemma

Let `Lambda_Y` be the completed **numerical** Novikov ring of a smooth
projective variety `Y`, and let `K_Y` be an algebraic closure of its fraction
field after adjoining the finite fractional Novikov powers used by a formal
QDM comparison.  For every divisor class `D`, put

\[
 \delta_D(Q^\beta)=\langle D,\beta\rangle Q^\beta .
 \tag{1}
\]

For the small-QDM argument set the formal bulk variables to zero.  More
generally use the Euler bulk derivations `tau_i partial_tau_i`, which preserve
the ordinary Artin truncations.  Then

\[
 K_Y^{\{\delta_D,\tau_i\partial_{\tau_i}\}}=\mathbf C.
 \tag{2}
\]

Indeed, the numerical Novikov monomials form a submonoid of the numerical
curve lattice.  The pairing between `N^1(Y)` and `N_1(Y)` is nondegenerate,
so the only monomial character killed by every `delta_D` is the degree-zero
character.  Equivalently, the formal torus with character lattice generated
by the numerical curve classes has no nonconstant rational invariant under
its full translation action.  Completion does not add an invariant: at every
Novikov/Artin cutoff the weight decomposition is finite, and passage to the
separated inverse limit is coefficientwise.  The Euler bulk derivatives remove the
remaining formal parameters.

Finite ramification does not change the conclusion.  On `Q^(beta/s)`, (1)
has the rational weight `<D,beta>/s`, still separated by some divisor unless
`beta=0`.  Finally, the constants of an algebraic differential-field
extension are algebraic over the old constants; since `C` is algebraically
closed, the algebraic closure in the coefficient direction adds no constant.

The same proof works at the pro-Artin level used by the sectorial receiver.
If `A_N` is a quotient of the completed numerical Novikov/bulk ring, its
simultaneous horizontal scalars are the image of `C`; compatibility through
the inverse system gives (2) again.  This is why the use of numerical rather
than raw homology Novikov variables is load-bearing: numerically invisible
curve tags would otherwise survive every divisor derivation.

## 2. The conditional horizontal value

Let `P_6(Y)` be the generalized primitive-sixth framed formal-monodromy
packet of the small even quantum connection over `K_Y`.  Integrability makes
formal monodromy commute with the Novikov connection, so the whole generalized
packet is stable under every `delta_D`; no individual atom or exponential
line is selected.

At this point there are two different completions.  `P_6(Y)` belongs to the
formal `z=0` category, while the Gamma point section is normalized at
`z=infinity`.  The constant-field lemma does not itself put them in one
horizontal fiber category.  The paragraphs below are therefore conditional
on a compatible sectorial/Picard--Vessiot realization containing both.

First work on the **whole** quantum differential module.  In the
Artin-sectorial fiber functor of
`2026-08-13-c907-formal-novikov-sectorial-receiver.md`, the normalized Gamma
point section and every canonical block section are jointly flat in `z`, the
Novikov variables, and the bulk variables.  Pairing compatibility therefore
gives

\[
 \delta_D[s(\mathcal O_y),v)=0,
 \qquad
 \tau_i\partial_{\tau_i}[s(\mathcal O_y),v)=0,
 \qquad
 \partial_z[s(\mathcal O_y),v)=0.
 \tag{3}
\]

The normalized point section exists formally without a Fano convergence assumption:
at every Artin cutoff it is the unique `1+O(1/z)` solution of a finite
meromorphic `z`-system, and integrability makes it flat in the surviving
Novikov directions.  Compatible uniqueness gives the inverse limit.  Thus
the large-`z` horizontal covector is constructed before any primitive atom is
split.  This still does not canonically restrict it to the `z=0` formal
packet.

By (2), every such pairing is a complex number.  The rank-normalized
functional is

\[
 \mathfrak r_Y(v)=(-1)^{\dim Y}[s(\mathcal O_y),v),
 \tag{4}
\]

so `r_Y(s(E))=rank(E)` on Gamma classes.

This does **not** say that the coordinates of `r_Y` in an arbitrary algebraic
frame are constant.  They generally are not.  It says that its values on
jointly horizontal sections belong to the differential constant field.  The
datum to transport is therefore the intrinsic Boolean

\[
 \mathfrak r_Y|_{P_6(Y)}\ne0,
 \tag{5}
\]

or, equivalently, the restriction of the horizontal covector to the whole
generalized packet.  No row of a large-radius-to-cusp connection matrix is
banked.

## 3. What one arrow computes

For a smooth blow-up `p:Ytilde -> Y`, Iritani's comparison is an isomorphism
of the full `z` and Novikov connections over

\[
 \mathbf C[z]((q^{-1/s}))[[Q,\widetilde\tau]],
 \tag{6}
\]

and it preserves the pairing.  Its ambient and center summands are stable
under every ambient Novikov derivation.  The fixed-nonzero-`q` Artin receiver
does only the following job:

1. put the intrinsic Gamma point section and the formal block decomposition
   into one sectorial fiber functor;
2. at the extremal specialization `Q=0`, use Shen--Shoemaker's oriented
   Gamma/Orlov asymptotics and the exact point unit column;
3. read the horizontal pairing constants there.

Choose Gamma/Orlov flat sections spanning every whole ambient and center
block.  The resulting constants are

\[
 \mathfrak r_{\widetilde Y}|_{P_6(Y)_{amb}}=\mathfrak r_Y,
 \qquad
 \mathfrak r_{\widetilde Y}|_{P_6(Z)_j}=0.
 \tag{7}
\]

The second equality is ordinary rank zero of an exceptional-divisor-supported
Orlov image; it is unchanged by an `O(kE)` twist.  The first equality is the
unit ambient point column.  More invariantly, subtract the two sides of (7)
on the **entire** indicated block.  The difference is a horizontal covector.
In any horizontal basis its coordinates lie in the constant field (2).  The
sectorial fiber functor is faithful and computes all those coordinates as
zero on the spanning Gamma/Orlov sections; hence the horizontal covector
itself is zero.  This is faithfulness of a solution fiber functor, not
algebraicity of the covector in the cohomology frame.  Only inside that
receiver, and after this whole-block identity is established, do we restrict
it to the formal-monodromy primary packet.  Consequently the confluence of
atoms inside the ambient block never enters the one-arrow statement.

To include the exceptional variable itself, let `q` vary on a small simply
connected subset of `C*`.  At every Artin level the connection is polynomial
in `q` by the genus-zero dimension axiom.  Parameterized summation gives
jointly `nabla_q`-flat lifts without moving the closed-fiber Stokes rays;
pairing flatness makes the values in (7) locally constant in `q`.  Thus a
single admissible fixed-`q` computation determines the same formal constants
over (6).  This is a statement about the scalar pairing in the horizontal
category, not a claim that the sectorial point solution has Laurent-polynomial
coordinates in `q`.

## 4. Why the proposed composition fails

At the next factorization arrow, every earlier exceptional variable does
belong to the new base variety's formal numerical Novikov ring, and it cannot
be evaluated at the old nonzero analytic value.  More importantly, the next
receiver supplies a new sectorial embedding of the intermediate variety's
formal packet.  A Stokes transition between the two receivers can mix that
packet with other exponential blocks.  Constancy of the pairings in either
receiver does not prove that the two restrictions of the point covector agree.

Thus (7) is exact inside one receiver, but its output has not been identified
with the input of the next receiver.  The proposed equivalence

\[
 \mathfrak r_{\widetilde Y}|_{P_6(\widetilde Y)}\ne0
 \quad\Longleftrightarrow\quad
 \mathfrak r_Y|_{P_6(Y)}\ne0
 \tag{8}
\]

does not yet telescope through a finite weak factorization zigzag.

The exact missing theorem is one of the following equivalent-strength
repairs:

1. a functorial horizontal morphism
   `r_Y:P_6(Y)->1` in a specified full-Novikov differential/Tannakian category,
   with conservative comparison to every incident arrow receiver;
2. a proof that every relevant Stokes transition preserves `P_6(Y)` and
   intertwines the Gamma rank covector;
3. one coherent sectorial fiber functor common to both incident arrows.

Once such a morphism exists, Section 1 proves that all its horizontal scalar
values lie in `C`, and the intended telescope becomes valid without any
Laurent-coordinate descent.

### Minimal Stokes countermodel

The logical gap is already visible in rank two.  Let the formal primary line
be `P=Ce_1`, let a second exponential factor be `Ce_2`, and let the two
sectorial fiber functors differ by the Stokes shear

\[
 S(e_1)=e_1+a e_2,
 \qquad S(e_2)=e_2,
 \qquad a\ne0.
 \tag{9}
\]

For the constant covector `ell(e_1)=0`, `ell(e_2)=1`, the restriction is zero
in the first sector and nonzero in the second:

\[
 \ell(e_1)=0,
 \qquad \ell(S(e_1))=a.
 \tag{10}
\]

All displayed values are horizontal complex constants.  Hence neither the
constant-field lemma nor constancy in parameters prevents the Boolean from
changing.  What excludes (9) geometrically must be an actual Stokes-filtration
or rank-morphism theorem.

## 5. Failure modes excluded

1. **Nonzero formal evaluation.**  No old Novikov variable is assigned a
   nonzero complex value in a later arrow.
2. **Coordinate algebraization.**  The sectorial point solution and the
   rank-covector row are not asserted to be Laurent polynomials.
3. **Confluence.**  At `Q=0` only the center-versus-whole-ambient splitting is
   used.  The primitive-sixth atom inside the ambient block is never followed
   to the confluence point.
4. **Phase transport.**  This is **not excluded**.  A Stokes change can mix
   the formal primary packet with other exponential blocks, so it need not be
   a basis change within `P_6`.
5. **Ramification.**  Fractional Novikov weights remain visible to divisor
   derivations, so the differential constants do not grow.
6. **Bulk truncations.**  The statement uses Euler bulk derivations, which
   preserve the Artin filtration; the Gold application may simply set bulk
   variables to zero.

## 6. AA / EJ / TT

- **AA1:** prove rank-invariance for the actual Stokes mutation word between
  two incident receivers; exceptional Orlov shears have rank zero, but it
  remains to show that no uncontrolled ambient shear occurs.
- **AA2:** build a two-arrow or whole-zigzag receiver on an iterated
  Laurent/Hahn base.  This must control infinite old-exceptional tails; the
  one-variable dimension bound does not automatically do so.
- **AA3:** construct the microlocal morphism `P_6 -> 1` directly in the
  Stokes-filtered/enhanced Riemann--Hilbert category.  This is the cleanest
  categorical I/O shape and would be uniform in `m`.
- **EJ:** Section 1 remains a useful exact lemma.  Once any one of AA1--AA3
  supplies the morphism, no further scalar parameter comparison is needed.
- **TT:** constants do not remember their domain.  The missing datum is the
  natural transformation that says which moving formal-primary subspace the
  constant covector is restricted to.

### Regression against AA2

The one-arrow dimension bound is not iterable by inspection.  Blow up
`P^2` at a point and then blow up a point on the first exceptional curve.  In
the resulting surface the strict transform `C=E_1-E_2` is a `(-2)`-curve and

\[
 -K\mathbin\cdot C=0.
 \tag{11}
\]

Every multiple `dC` is an effective stable-map class with the same
anticanonical degree.  Hence the genus-zero dimension axiom does not bound the
old exceptional degree after the second arrow.  Taking the product with
`P^3` gives the same obstruction in dimension five, realized by two
codimension-two blow-ups with centers `point x P^3`.  Therefore a common
multi-analytic receiver cannot be justified by repeating the single-arrow
polynomiality argument; it needs actual convergence/resummation or a different
coefficient category.

### Audit of phase globalization by rotating `q`

A proposed repair fixes one global `z`-phase `theta_0` and rotates each
arrow's new exceptional value `q_0` so that its certified aperture contains
`theta_0`.  This does align the **angular** fiber functors: the source bounds
are conditions on `arg(z/q)`, and level-one uniqueness identifies two sums of
the same formal system on the same aperture.

It does not align the **parameter** fiber functors.  A sectorial fiber functor
is specified by the `z` direction together with a quantum-parameter basepoint
and continuation path.  At arrow one, the intermediate variety is realized
with its new exceptional variable `q_1=q_1^0 in C*`.  At arrow two, that same
`q_1` is an old ambient formal variable.  Multisummation uniqueness does not
compare systems over these two noncomparable coefficient settings.  To make
the basepoints agree one would have to evaluate the old formal `q_1` at
`q_1^0`, the illegal map the proposal was meant to avoid.  The `(-2)`-curve
regression above shows that the required old-exceptional tails need not even
truncate.

Therefore `q`-rotation solves the finite global-phase bookkeeping but not the
composition gate.  It becomes useful only after a common parameter receiver
or a parameter-functorial `P_6 -> 1` morphism is constructed.

### Valley banking and radial peak legs

A sharper proposal separates a weak-factorization zigzag into valleys and
peaks.  At a valley, both incident arrows use the variety as their ambient
base with all of its Novikov variables formal.  Per Artin quotient the
nilpotent exponential corrections terminate, and the same normalized
regular-singular ambient fiber functor is used on both sides.  The one-arrow
whole-block covector identity therefore appears sufficient at valleys; no
primitive packet is specialized at the all-formal origin.

At a peak, the two blow-up structures have exceptional parameters `q` and
`q'`.  The proposal connects the receivers by a radial `q`-leg with `q'`
formal, followed by a radial `q'`-leg with `q` formal.  This is a genuine
improvement over a two-analytic-variable receiver.  On each punctured leg the
new exceptional exponential has fixed argument, nilpotent Artin corrections
do not rotate its rays, and the other exceptional direction remains in the
formal filtration.  In particular the `(-2)`-curve regression above does not
by itself kill this construction.

The proposed peak lemma—commutation of parameterized summation with Taylor
truncation **at the level of scalar pairings**—is nevertheless insufficient.
At the common formal corner the scalar rank covector can extend uniquely
while the incoming `q`-primary subspace and outgoing `q'`-primary subspace
confluence.  A nontrivial confluence/Stokes matrix can relate them.  The rank
two shear (9) is compatible with constant scalar values on both punctured
legs; concentrating the shear at the turning corner changes the restriction
Boolean without changing the extended covector.

Thus valley banking localizes the global gate to the peaks, but the correct
peak statement must include the subspace:

\[
 \mathfrak r|_{P_6^{(q)}}\ne0
 \quad\Longleftrightarrow\quad
 \mathfrak r|_{P_6^{(q')}}\ne0,
 \tag{12}
\]

or, more structurally, a confluence nearby-cycle map intertwining the two
radial formal-primary packets and the rank covector.  Scalar
summation--truncation faithfulness is one input to (12), not a proof of it.
One further coefficient check is required as well: the two blow-up monomial
charts must meet at a common completed numerical-Novikov corner; this cannot
be inferred solely from the existence of the two contractions.

## Sources

- H. Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3,
  Theorem 5.18 and Sections 5.5--5.8.
- H. Iritani, *Gamma classes and quantum cohomology*, arXiv:2307.15938v1,
  Section 1.2.
- Y. Shen and M. Shoemaker, *Quantum spectrum and Gamma structure for
  standard flips*, arXiv:2502.08762v2, Theorem 1.4 and Remark 1.6.
- T. Dreyfus, *A density theorem in parameterized differential Galois
  theory*, arXiv:1203.2904v4, Proposition 1.3 and Sections 1.3--1.4.
