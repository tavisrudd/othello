# C515 — modular TRS additive/Hasse recursion

**Date:** 2026-07-23  
**Lane:** `reed-solomon`  
**Verdict:** exact Hasse normal form; zero-lifting recursion obstructed

## Result

Retain C514's notation:
\[
 M=\Gamma^sE/\langle z\rangle,\qquad z=e_{s-1}+e_s,\qquad p\mid s,
\]
and
\[
 F_y(r,U)=\langle A_{-r}y,\;XQ_U(X)\rangle,\qquad
 |U|=s-1,\quad \sum U=1.                                      \tag{1}
\]
The translation representation has canonical divided-power operators
\[
 \partial^{[d]}e_j={j+d\choose j}e_{j+d},\qquad
 A_b=\sum_{d=0}^s b^d\partial^{[d]}.                            \tag{2}
\]
They descend to \(M\), commute with translations, and give the complete Hasse normal form
\[
 F_y(r,U)=\sum_{d=0}^s(-r)^d
 \langle\partial^{[d]}y,\;XQ_U\rangle,                          \tag{3}
\]
\[
 D_r^{[d]}F_y(r,U)
 =(-1)^dF_{\partial^{[d]}y}(r,U).                              \tag{4}
\]
Thus the intrinsic first Hasse level of a nonfixed syndrome is
\[
 \tau(y)=\min\{d>0:\partial^{[d]}y\ne0\text{ in }M\};           \tag{5}
\]
the entire Hasse support is translation-orbit invariant.  On a basis vector,
\(\partial^{[d]}e_j\ne0\) exactly when \(j\preceq_p j+d\), so (5) is the
Lucas filtration in operator form.  Finite differences are equally exact:
\[
 \Delta_bF_y(r,U)
 =F_{(A_{-b}-1)y}(r,U),                                       \tag{6}
\]
and iterated differences apply the corresponding product of augmentation operators.

This is a genuine additive reduction of **translation degree**, but it is not a recursion for
deep-hole avoidance.  Unlike C512's lifting identity, neither (4) nor (6) preserves the zero set:
\[
 \Delta_bF_y(r,U)=0
\quad\Longleftrightarrow\quad
 F_y(r+b,U)=F_y(r,U),                                         \tag{7}
\]
not \(F_y(r,U)=0\).  Both values in (7) may be nonzero.  At the terminal fixed flag every
positive difference vanishes identically, while the standard syndrome has \(F_y=1\) on every
support.  Hence no induction based only on the first nonzero Hasse layer can lift a lower zero
to an original support hyperplane.

The obstruction remains arithmetic at additive degree one.  If a terminal fibre has
\[
 F_y(r,U)=L_U(r)+c_U
\]
with \(L_U\) a linearized polynomial, then a root exists exactly when
\[
 -c_U\in\operatorname{im}L_U.                                 \tag{8}
\]
Under the trace pairing this is the explicit criterion
\[
 \operatorname{Tr}_{q/p}(v c_U)=0
 \quad\text{for every }v\in\ker L_U^\ast.                      \tag{9}
\]
For \(L_U(r)=a(r^p-r)\), (9) is the Artin--Schreier condition
\(\operatorname{Tr}_{q/p}(c_U/a)=0\).  These image classes vary with \(U\); Hasse order alone
does not determine them.

There is nevertheless one exact global translation invariant that the local differences hide:
\[
 \mathcal N_y(U)=\prod_{r\in\mathbb F_q}F_y(r,U)
 =\operatorname{Res}_R(R^q-R,F_y(R,U)).                         \tag{10}
\]
It satisfies
\[
 \mathcal N_{A_by}(U)=\mathcal N_y(U)
\]
and vanishes exactly when the translation orbit over \(U\) contains a support hyperplane through
\(y\).  Hence \(y\) is deep exactly when \(\mathcal N_y(U)\ne0\) for every distinct trace-one
\(U\).  This is an exact elimination of \(r\), but not a recursion: the resultant has degree
\(q\) in the determinant values and its component structure is not supplied by the Hasse
filtration.

The natural polar-compatible locus is also exact.  It is the image of the ruled incidence
\[
\mathcal P_z=
 \{([\lambda],f):\iota_\lambda f=z\}
\longrightarrow {\bf P}(M),\qquad
 ([\lambda],f)\longmapsto
[\,\iota_\mu f\bmod z\,],                                    \tag{11}
\]
where \(\mu\) complements \(\lambda\).  Each fibre over \([\lambda]\in{\bf P}^1\) is an affine
line, so the image has dimension at most two.  It is a proper special locus for \(s\ge4\).
It contains the standard fixed direction, but every additional pure Lucas-maximal direction
\(\bar e_j\), \(j\le s-3\), lies outside it.  Consequently polar geometry cannot absorb the
larger modular fixed flag.

The completion-collision boundary remains
\[
U=\{0\}\sqcup V,\qquad \sum V=1,\qquad XQ_U=X^2Q_V,            \tag{12}
\]
and all formulas (3)--(9) restrict to it without deleting it.  This supplies exact boundary data
but does not repair the missing zero-lifting implication.

C515 therefore closes by obstruction: the additive/Hasse machinery canonically filters syndrome
orbits and gives exact trace tests at additive endpoints, but it cannot by itself recurse the
support-avoidance predicate.  A future theorem would need a global zero-existence argument for a
geometrically integral component of the trace-one incidence variety (or an exact quotient incidence
with its rational lifting condition), followed by a rational-point bound—not another local
difference operator.  No field census or standard-only classification is claimed.

## 1. Hasse operators and orbit invariance

In the degree-\(s\) divided-power module, translation is
\[
 A_be_j=\sum_{i=j}^s{i\choose j}b^{i-j}e_i.
\]
Putting \(d=i-j\) gives (2).  The composition law is
\[
 \partial^{[a]}\partial^{[b]}
 ={a+b\choose a}\partial^{[a+b]},
\]
so these are precisely the Hasse operators for the additive action.  Because \(z\) is fixed,
\(\partial^{[d]}z=0\) for every \(d>0\); hence each operator descends to \(M\).

Substituting (2) into (1) proves (3).  Hasse differentiation and the composition law give (4).
Moreover
\[
 \partial^{[d]}A_b=A_b\partial^{[d]},
\]
so the vanishing pattern of the vectors \(\partial^{[d]}y\), and in particular \(\tau(y)\),
is constant on every translation orbit.  Formula (6) follows directly from
\(A_{-(r+b)}=A_{-r}A_{-b}\).

The Lucas fixed flag is the common kernel of all positive Hasse operators:
\[
 M^{(\mathbb F_q,+)}
 =\bigcap_{d>0}\ker\partial^{[d]}.
\]
Thus (3) specializes to an \(r\)-independent elementary-symmetric test exactly at the terminal
flag.

## 2. Why differences do not lift zeros

C512 works because contraction supplies an incidence equivalence:
\[
 g\in W_{\iota_\lambda f}\quad\Longleftrightarrow\quad\lambda g\in W_f.
\]
The additive identity (6) has a different logical shape.  A zero after one step is an equality
of two original determinant values.  It gives no vanishing of either value, and iteration only
produces alternating sums over translation cubes.

This failure is already visible at the terminal object.  For the standard class
\(y=\bar e_s\),
\[
 F_y(r,U)=1
\]
for every \(r,U\), while
\[
 F_{(A_{-b}-1)y}(r,U)=0
\]
for every \(b,r,U\).  Hence even the strongest possible lower vanishing—identical zero—does not
lift to an original zero.  This is a structural counterexample to a C512-shaped implication,
not a shortage of point-counting estimates.

Higher finite differences do retain useful information: their terminal additive-degree-one pieces
are linearized polynomials.  Their augmentation depth is distinct from the first Hasse index in
(5), as the Tao audit below makes explicit.  What they do not retain is the absolute level
\(c_U\), exactly the datum needed in (8).

## 3. Exact additive and Artin--Schreier endpoint

Let
\[
 L(X)=\sum_{i=0}^{m-1}a_iX^{p^i}
\]
act on \(\mathbb F_q\).  Relative to
\(\langle x,v\rangle=\operatorname{Tr}_{q/p}(xv)\), its adjoint is
\[
 L^\ast(V)=
 \sum_{i=0}^{m-1}a_i^{p^{m-i}}V^{p^{m-i}},
 \]
with exponents read modulo \(m\).  Nondegeneracy of the trace pairing gives
\[
 \operatorname{im}L=(\ker L^\ast)^\perp,
\]
which proves (8)--(9).  Frobenius carries this criterion to its coefficientwise conjugate, so the
test is semilinearly intrinsic.

For \(L(X)=a(X^p-X)\), the image is \(a\ker\operatorname{Tr}_{q/p}\), giving the stated
Artin--Schreier trace bit.  More general linearized endpoints carry the full finite
\(\mathbb F_p\)-subspace obstruction \(\ker L^\ast\), not necessarily one bit.  Therefore a
single Kummer/Artin--Schreier label cannot be attached to the whole C514 quotient before \(U\)
and \(L_U\) are known.

## 4. The polar-compatible ruled locus

C514's consecutive-row criterion says that the line
\(\langle z,\tilde y\rangle\subset{\bf P}(\Gamma^sE)\) is polar exactly when it is the image of
the contraction map of some \(f\in\Gamma^{s+1}E\).  If it is polar and contains \(z\), some
\([\lambda]\in{\bf P}(E^\vee)\) satisfies
\(\iota_\lambda f=z\) after scaling.

For fixed \(\lambda\), the contraction
\[
 \iota_\lambda:\Gamma^{s+1}E\longrightarrow\Gamma^sE
\]
is surjective with one-dimensional kernel.  Thus
\(\iota_\lambda f=z\) is an affine line of solutions.  Choosing a complementary \(\mu\), the
second contraction modulo \(z\) gives (11).  Replacing \(\mu\) changes the representative only
by a multiple of \(z\), so the resulting point of \({\bf P}(M)\) is intrinsic.  Conversely every
polar line through \(z\) arises this way.  This proves the ruled classification and its
dimension bound.

In the frame where \(\lambda\) is the first coordinate, the two consecutive rows are
\[
 z=(0,\ldots,0,1,1),\qquad
 (0,\ldots,0,1,1,a).
\]
Modulo \(z\), the second is
\[
 \bar e_{s-2}+(1-a)\bar e_{s-1}.
\]
The standard line is obtained among these frames.  On the other hand, inserting
\(y=e_j\), \(j\le s-3\), into C514's matrix \(K(y)\) forces the off-diagonal basis
coefficients to vanish at rows \(j-1,j\), and the remaining coefficients to vanish at the last
two rows; no invertible \(2\times2\) transporter remains.  Since \(s-2\) is not Lucas-maximal
when \(p\mid s\), every nonstandard pure Lucas-maximal basis direction has \(j\le s-3\) and is
nonpolar.

For \(s=3\), the ruled image may fill the syndrome plane; C514's matrix criterion remains the
exact pointwise test.  For every \(s\ge4\), \(\dim{\bf P}(M)=s-1>2\), so the polar-compatible
locus is proper.

## 5. Fixed endpoints and the collision boundary

If \(y=\bar e_j\) is fixed, (3) is independent of \(r\).  From
\[
 XQ_U(X)=\sum_{a=0}^{s-1}(-1)^ae_a(U)X^{s-a}
\]
one obtains
\[
 F_{\bar e_s}=1,\qquad F_{\bar e_{s-1}}=-1,\qquad
 F_{\bar e_j}=(-1)^{s-j}e_{s-j}(U)\quad(1\le j\le s-2).         \tag{13}
\]
Thus every extra Lucas-fixed endpoint is an explicit elementary-symmetric nonvanishing problem
on distinct trace-one configurations.  Translation differences cannot simplify (13), because
they already vanish.

On the collision divisor, \(U=\{0\}\sqcup V\) and (12) holds.  The remaining set \(V\) is
distinct, nonzero, and has sum one.  Equations (3), (9), and (13) restrict by substituting
\(X^2Q_V\).  This is a lower-dimensional boundary recursion for the **configuration space**, but
not for the syndrome degree or the zero predicate.

## 6. Tao audit — use the orbit norm, not a local difference

The product in (10) is the multiplicative transfer for the additive translation group.  Indeed,
\[
 F_{A_by}(r,U)=F_y(r-b,U),
\]
so translation merely permutes its \(q\) factors.  Frobenius sends
\(\mathcal N_y(U)\) to its coefficientwise conjugate, and projective rescaling of \(y\) multiplies
it by a nonzero \(q\)-th power.  Therefore its zero locus is a projective-semilinear invariant.
It also retains the collision divisor by direct substitution of \(X^2Q_V\).

At a linearized endpoint \(F_y(r,U)=L_U(r)+c_U\), put
\[
 I_U=\operatorname{im}L_U,\qquad
 \kappa_U=|\ker L_U|,\qquad
 \Psi_{L_U}(Z)=\prod_{a\in I_U}(Z-a).
\]
The image polynomial \(\Psi_{L_U}\) is linearized, and grouping the norm factors by fibres of
\(L_U\) gives, up to the fixed nonzero resultant sign,
\[
 \mathcal N_y(U)=
 \Psi_{L_U}(-c_U)^{\kappa_U}.                                  \tag{14}
\]
Thus the adjoint-kernel trace criterion (9) is exactly the vanishing criterion of the orbit norm,
not an auxiliary obstruction.  For \(L_U=a(X^p-X)\), the image polynomial is a nonzero scalar
multiple of
\[
 \operatorname{Tr}_{q/p}(Z/a),
\]
so (14) recovers the Artin--Schreier trace test with multiplicity \(p\).

The norm is the right exact elimination of the translation coordinate at the level of
\(\mathbb F_q\)-point incidence, but it exposes rather than solves the remaining geometry.  Indeed
\[
 \mathcal N_y(U)=\prod_{r\in\mathbb F_q}F_y(r,U)
\]
is already a product of \(\mathbb F_q\)-defined factors, so its whole hypersurface is reducible
whenever more than one distinct factor remains.  The valid gates are a component classification of
this product or geometric integrality of a suitable component of the incidence variety
\(\mathcal Z_y\) below, not absolute irreducibility of the norm.  Local Hasse data controls its
degeneration strata, not its global components.

The audit also separates two filtrations that should not be conflated.  The index \(\tau(y)\) in
(5) is the first nonzero **Hasse index**, governed by Lucas digits.  Iterated finite differences
instead measure augmentation/additive degree; for a scalar monomial \(r^n\) this is governed by
the base-\(p\) digit sum of \(n\).  They agree only in special cases.

## 7. Extra-juice closeout and mystery ledger

The closeout exposes two cheap consequences.

First, the modular fixed flag and polar locus meet asymmetrically: the standard fixed direction is
polar, while every pure additional Lucas-maximal direction is nonpolar.  Thus any future claim
that all deep syndromes are polar-compatible would simultaneously prove that every additional
Lucas endpoint in (13) has a split trace-one zero.

Second, the correct global successor object is now explicit:
\[
 \mathcal Z_y=
 \{(r,U):\sum U=1,\ \operatorname{disc}(Q_U)\ne0,\
 F_y(r,U)=0\}.
\]
The collision locus \(0\in U\) remains inside its domain.  Geometric integrality of a suitable
component of \(\mathcal Z_y\), or a component classification together with an exact quotient and
rational lifting criterion, stratified by the Hasse support of \(y\), would turn the local normal
form into a high-field existence theorem.  No such geometric statement follows for free from the
difference identities.

The Tao audit eliminates the translation coordinate exactly by the orbit norm (10).  Accordingly,
the same successor geometry has a set-theoretic eliminated image given by the factor/component
problem for \(\mathcal N_y(U)=0\); it is not replaced by one irreducible norm hypersurface.
Equation (14) gives its complete factor on every linearized endpoint.

A requested post-closeout extra-juice pass finds a necessary refinement before that geometry is
attempted.  Let
\[
 H_y=\{b\in\mathbb F_q:[A_by]=[y]\}.
\]
Every \(A_b\) is unipotent, so a projective eigenvalue is necessarily one; hence \(H_y\) is the
actual vector stabilizer, an additive \(\mathbb F_p\)-subspace.  If \(b\in H_y\), then
\[
 F_y(r-b,U)=F_{A_by}(r,U)=F_y(r,U).
\]
Thus \(F_y\) is constant on cosets of \(H_y\), and the orbit norm has the forced factorization
\[
 \mathcal N_y(U)=
 \left(
   \prod_{r\in\mathbb F_q/H_y}F_y(r,U)
 \right)^{|H_y|}
 =\bigl(\mathcal N_y^{\mathrm{red}}(U)\bigr)^{|H_y|}.            \tag{15}
\]
The product over cosets is independent of representative.  Equivalently, as a polynomial in
\(r\), \(F_y\) factors through the linearized quotient coordinate
\[
 P_{H_y}(r)=\prod_{h\in H_y}(r-h).
\]

Because \(|H_y|\) is a power of \(p\), the full resultant is forced to be inseparable on every
nontrivial stabilizer stratum.  The reduced coset norm
\(\mathcal N_y^{\mathrm{red}}\) removes exactly this forced repetition, but it is still a product
of the distinct \(\mathbb F_q/H_y\)-coset factors and is therefore not an irreducibility candidate
unless only one coset remains.  Its correct role is to record the reduced component union.  On the
full fixed flag,
\(H_y=\mathbb F_q\), so
\[
 \mathcal N_y(U)=F_y(U)^q,\qquad
 \mathcal N_y^{\mathrm{red}}(U)=F_y(U).
\]
The elementary-symmetric equations (13) are therefore exactly the reduced fixed-flag components,
while their multiplicity \(q\) records the translation stabilizer.

- **Settled — is there a canonical Hasse normal form?** Yes, equations (2)--(6), with
  translation-invariant first level \(\tau(y)\).
- **Settled — do additive endpoints have an exact arithmetic test?** Yes, the adjoint-kernel
  trace criterion (9), specializing to Artin--Schreier trace zero.
- **Settled — can the translation coordinate be eliminated without losing zero incidence?** Yes.
  The orbit norm/resultant (10) vanishes exactly when some translated determinant vanishes.
- **Settled — is the full orbit norm the correct reduced geometric equation?** Only on the
  trivial-stabilizer stratum.  Equation (15) removes the forced \(p\)-power multiplicity on every
  other stratum.
- **Settled — does finite-difference vanishing lift a support zero?** No.  Equation (7) and the
  standard fixed syndrome give a sharp counterexample.
- **Settled — are Hasse index and augmentation depth the same filtration?** No.  Hasse index is
  Lucas-position data; finite-difference depth is controlled by additive degree/base-\(p\)
  digit weight.
- **Settled — what is the polar-compatible locus?** The ruled image (11), of dimension at most
  two; it misses every pure nonstandard Lucas-maximal direction.
- **Settled — what remains on the fixed flag?** The elementary-symmetric tests (13).
- **Open — which reduced coset factors or quotient-incidence components are geometrically
  integral off a classified persistent locus?** Evidence gap: no component or monodromy theorem
  has been proved, and a rational point of a quotient must retain the exact lift to the original
  \(r\)-incidence.  The unreduced norm is automatically a \(p\)-power when \(H_y\ne0\), while the
  reduced norm remains a product over distinct cosets.
- **Open — do all extra Lucas-fixed directions admit a trace-one configuration zero in (13)?**
  Evidence gap: no uniform distinct-root construction is known.
- **Open — can the collision boundary seed an inclusive logarithmic polar theory?** Equation
  (12) supplies the boundary object, but no zero-lifting equivalence is known.

Vibe check: the additive symmetry yields a complete filtration and exact trace obstructions, but
not the missing incidence equivalence; the next viable route is global geometry of
\(\mathcal Z_y\), not another local recursion or a census.
