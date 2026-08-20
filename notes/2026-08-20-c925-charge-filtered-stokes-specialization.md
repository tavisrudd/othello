# Module 37. Charge-filtered Stokes specialization

**Packet part:** Module 37.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** abstract charge-filtration theorem proved; its QDM blowup
realization is open

## 37.1 Positive charge as an augmentation ideal

Let \(K\) be a field and let

\[
\mathcal A=\prod_{d\ge0}\mathcal A_d
\tag{37.1}
\]

be a unital \(K\)-algebra complete and separated for the degree filtration

\[
F^p\mathcal A=\prod_{d\ge p}\mathcal A_d,
\qquad
F^p\mathcal A\,F^q\mathcal A\subseteq F^{p+q}\mathcal A,
\tag{37.1a}
\]

with continuous multiplication and
\(\mathcal A_d\mathcal A_e\subseteq\mathcal A_{d+e}\).  Write

\[
\epsilon:\mathcal A\longrightarrow\mathcal A_0,
\qquad
I_+=\ker\epsilon=\prod_{d>0}\mathcal A_d.
\tag{37.2}
\]

The same discussion works for any complete separated multiplicative
filtration \(F^pF^q\subseteq F^{p+q}\), with \(I_+=F^1\).  Generic
topological completeness without this pro-nilpotent filtration is
insufficient.

### Proposition 37.1 -- positive Stokes factors form a normal congruence

The set \(1+I_+\) is a group.  It is preserved by conjugation by every unit
normalizing \(I_+\), and

\[
\epsilon\left(
g_0(1+x_1)g_1\cdots(1+x_r)g_r
\right)
=
\epsilon(g_0)\epsilon(g_1)\cdots\epsilon(g_r)
\tag{37.3}
\]

for \(x_i\in I_+\) and arbitrary normalizing units \(g_i\).

#### Proof

The kernel of an algebra homomorphism is a two-sided ideal.  Completeness
makes

\[
(1+x)^{-1}=1-x+x^2-x^3+\cdots
\tag{37.4}
\]

converge for \(x\in I_+\).  Hence \(1+I_+\) is closed under products and
inverses.  Normalization gives
\(g(1+x)g^{-1}=1+gxg^{-1}\in1+I_+\).  Applying the algebra homomorphism
\(\epsilon\) proves (37.3).  \(\square\)

No sign or positivity condition on the coefficients is present.  The result
uses positivity of **charge degree**, not positivity of a Stokes matrix.

### Corollary 37.1A -- pointed quantum-torus specialization

Let \(\Gamma^+\) be a cancellative pointed submonoid of a lattice and let
\(\widehat K_q[\Gamma^+]\) be a locally finite complete quantum torus with

\[
\widehat e_\gamma\widehat e_\mu
=q^{\langle\gamma,\mu\rangle/2}\widehat e_{\gamma+\mu}.
\tag{37.4a}
\]

Then

\[
\epsilon(\widehat e_0)=1,
\qquad
\epsilon(\widehat e_\gamma)=0\quad(\gamma\ne0)
\tag{37.4b}
\]

extends to an algebra augmentation, and all series with constant term one
belong to \(1+I_+\).

#### Proof

Pointedness says \(\gamma+\mu=0\) for
\(\gamma,\mu\in\Gamma^+\) only when both vanish.  Thus (37.4b) respects
(37.4a).  Local finiteness and the chosen completion type the infinite
sums; Proposition 37.1 applies.  \(\square\)

This is the exact quantum-torus law imported from the BPS/DT setting.  It
does not identify the QDM blowup factors with its generators.

## 37.2 The retained row and quotient line

Let \(M\) be a complete left \(\mathcal A\)-module and put, algebraically,

\[
M_0=M/I_+M.
\tag{37.5}
\]

Every \(1+x\in1+I_+\) acts as the identity on \(M_0\).  Let
\(\rho_0:M_0\to K\) be a row.  If \(\rho_0\ne0\), require every degree-zero
normalizing factor \(g\) to satisfy
\(\rho_0g=c_g\rho_0\) for some \(c_g\in K^\times\).  If \(\rho_0=0\), retain
the zero-row marker separately, as in Module 34.

### Theorem 37.2 -- charge-filtered rank-row transport

Any ordered product of degree-zero ambient factors and positive-charge
exceptional factors induces on \(M_0\) the product of the ambient factors
alone.  In particular, under the displayed row hypotheses it preserves the
zero/nonzero marker and, on the nonzero component, the quotient line

\[
Q(M_0,\rho_0)=M_0/\ker\rho_0.
\tag{37.6}
\]

The same conclusion holds for a zigzag: a reversed exceptional factor uses
its inverse, which still belongs to \(1+I_+\).

#### Proof

Reduce the product modulo \(I_+\) and apply Proposition 37.1.  The
exceptional factors all become the identity.  The remaining assertion is
Proposition 34.1 applied in the degree-zero quotient.  \(\square\)

This is the exact sense in which charge filtration can bypass a local
zero-leakage theorem.  Individual ambient--exceptional Stokes coefficients
may be nonzero.  They need only have strictly positive charge.

## 37.3 Wall crossing is compatible but not load-bearing

Suppose two sectorial factorizations represent the same Stokes automorphism.
Then Theorem 37.2 plainly gives the same degree-zero transport.  More
strongly, even before proving equality of the two ordered products, every
product made solely from factors in \(1+I_+\) reduces to the identity.
Thus the final Boolean/rank consumer does not consume the detailed
wall-crossing identity.

The mathematical-physics precedents explain why this interface is natural:

- Kontsevich--Soibelman attach completed Hall/quantum-torus elements to
  strict sectors and prove the clockwise factorization law
  \(A_V=A_{V_1}A_{V_2}\): Proposition 11 gives the Hall-algebra statement,
  while Theorem 7 gives the motivic statement under their integral-identity
  hypothesis (arXiv:0811.2435).
- Bridgeland packages active-ray automorphisms into a BPS
  Riemann--Hilbert problem; the explicit Gamma-product solution is proved for
  finite uncoupled integral BPS structures, not for arbitrary coupled
  systems, and assumes the base point is one on every active class (Theorem
  5.3 of arXiv:1611.03697).
- Iwaki--Nakanishi prove cluster mutation laws for Voros symbols and
  identities of Stokes automorphisms for exact-WKB Schrödinger equations
  (arXiv:1401.7094).
- Boalch organizes an irregular type into singular directions and Stokes
  groups and constructs the corresponding product space of Stokes data
  (Definition 7.5 of arXiv:1111.6228).
- Sabbah includes Stokes-filtered local systems in good integrable twistor
  structures and obtains a Tannakian category (Definition 1.8 and
  Proposition 1.10 of arXiv:1511.00176); this supplies categorical precedent,
  not strict blowup transport.

These are precedents for ordered completed products and charge/path
bookkeeping.  None constructs the charge realization required below for an
Iritani blowup comparison.

### Corollary 37.2A -- a strict sector supplies a positive weight

Let \(Z:\Gamma\to\mathbf C\) be additive, and suppose the central charges of
all exceptional factors lie in a sector whose closed angular width is
strictly less than \(\pi\), with \(Z(\gamma)\ne0\) on that support.  There is
a real linear functional \(h:\mathbf C\to\mathbf R\) positive on every
nonzero point of that sector.  Hence

\[
d(\gamma)=h(Z(\gamma))
\tag{37.6a}
\]

is additive and strictly positive on exceptional support.  This supplies the
weight on every finite product.  To obtain Proposition 37.1 for an infinite
ordered product, assume additionally that the ordered family tends to the
identity in a complete separated multiplicative sector filtration: for every
\(p\), only finitely many factors fail to lie in \(1+F^p\).  Equivalently,
every bounded-height coefficient receives only finitely many contributions.
Ambient factors must have degree zero.  A positive lower height bound alone
does not make an infinite product converge.

#### Proof

Rotate the sector so that its closure lies strictly inside the right
half-plane and take \(h\) to be the real part.  Additivity follows from that
of \(Z\).  \(\square\)

Thus a strict sector supplies the pointed **weight**, not the completed
receiver.  The geometric question is: do all exceptional actions used by the
fixed-phase comparison have nonzero central charge in one strict sector,
with the required local finiteness, completion, degree-zero ambient action,
and path compatibility?

### Corollary 37.2B -- Levi/unipotent-radical form

Let \(G\subset\mathcal A^\times\) normalize \(I_+\), let \(\rho_0\ne0\), and
put

\[
G_{\rho}
=\{g\in G:\rho_0\epsilon(g)=c_g\rho_0
\text{ for some }c_g\in K^\times\},
\qquad
U_+=G\cap(1+I_+).
\tag{37.6b}
\]

Then \(U_+\triangleleft G_\rho\), and augmentation gives an exact sequence

\[
1\longrightarrow U_+
\longrightarrow G_\rho
\xrightarrow{\ \epsilon\ }
\epsilon(G_\rho)
\longrightarrow1.
\tag{37.6c}
\]

Consequently, if the ambient/formal factors land in a degree-zero Levi
subgroup whose action preserves the row line, while every exceptional
Stokes group lands in \(U_+\), the row consumer factors through the Levi
quotient.  Here \(\operatorname{Aut}_{F,\rho}(M)\) denotes the
filtration-preserving automorphisms whose induced degree-zero action
preserves the row line:

\[
\begin{CD}
G_\rho @>{\epsilon}>> \epsilon(G_\rho)\\
@V{\text{Stokes path action}}VV
@VV{\text{degree-zero row line}}V\\
\operatorname{Aut}_{F,\rho}(M) @>>>
\operatorname{Aut}Q(M_0,\rho_0).
\end{CD}
\tag{37.6d}
\]

#### Proof

Every element of \(U_+\) acts trivially after augmentation, hence belongs to
\(G_\rho\).  Normality and exactness are Proposition 37.1 restricted to
\(G_\rho\); Theorem 37.2 gives the bottom factorization.  The zero-row
component is handled separately by its unique zero quotient.  \(\square\)

This is the closest abstract match to the wild-character-variety picture:
formal centralizer data play the Levi role and sectorial Stokes root groups
are candidate radical factors.  Ordinary unipotence is not sufficient; the
root factors must still land in the same positive congruence.

## 37.4 Occurrence-indexed charge maps

A bare label such as "exceptional" is not enough.  For every actual blowup
occurrence \(\sigma\), require:

1. a cancellative occurrence charge submonoid \(\Gamma_\sigma^+\) of an
   abelian charge group and a completed algebra \(\mathcal A_\sigma\);
2. a cancellative path charge submonoid \(\Gamma_{\rm path}^+\) of an
   abelian group, with
   \(\Gamma_{\rm path}^+\cap(-\Gamma_{\rm path}^+)=\{0\}\);
3. an additive map

   \[
   \phi_\sigma:\Gamma_\sigma^+\longrightarrow\Gamma_{\rm path}^+
   \tag{37.7}
   \]

   which is zero-reflecting on the support of every exceptional Stokes
   factor; and
4. a continuous augmented algebra map lifting \(\phi_\sigma\), compatible
   with the adjacent reindexing of Module 34.

Item 4 is independent provider data: an additive map of charge monoids need
not induce a map of product completions unless its fibres and the admitted
support satisfy the required local-finiteness/continuity law.

The zero-reflecting condition is

\[
\gamma\in\operatorname{Supp}_{\rm exc}(\sigma),
\quad
\phi_\sigma(\gamma)=0
\quad\Longrightarrow\quad
\gamma=0,
\tag{37.8}
\]

together with the independent certificate that no exceptional factor is
supported at \(\gamma=0\).

Common scalar translation of all irregular values preserves their
differences.  Independent unit translations of separate summands do not
automatically preserve (37.7)--(37.8).  They are lawful only after supplying
the corresponding charge-map/reindexing certificate.  Ramified or deck
paths likewise have to be closed on a common cover or equipped with a
deck-compatible endpoint map.

The fixed-sector qualification is load-bearing.  A full Stokes circle
normally sees opposite exponential/root directions, so its support need not
lie in one pointed cone.  The provider must show either that the chosen
fixed-phase comparison consumes only a strict sector, or that all
complementary-sector factors already preserve the degree-zero row.  The
existence of sectorwise Stokes filtrations does not by itself make this
choice coherent along the weak-factorization path.

## 37.5 Two sharp countermodels

### Nonpointed charges can create degree zero

In \(K[z,z^{-1}]\), declaring both \(z\) and \(z^{-1}\) "positive" gives

\[
(1+z)(1+z^{-1})=2+z+z^{-1}.
\tag{37.9}
\]

Two nonzero charges have created a new charge-zero coefficient.  Therefore a
strict pointed cone, rather than mere nonzero action, is load-bearing.

### A zero-charge exceptional shear changes the row

Let \(\rho=(1,0)\) and

\[
T=1+E_{12}.
\tag{37.10}
\]

Then \(T\) is invertible but
\(\rho T=(1,1)\) is not proportional to \(\rho\).  Thus one exceptional
zero-charge factor can destroy the Module 34 quotient-line law.  Wall
crossing cannot repair this abstract defect; it must be excluded or shown to
lie in the degree-zero row stabilizer.

These countermodels also show why the Kontsevich--Soibelman support property
is not itself the desired provider.  That property bounds active charges and
excludes zero central charge on their support.  The application here
additionally needs one common pointed sector and absence of an exceptional
zero-charge action after every QDM coordinate reindexing.

## 37.6 Conditional all-stabilization theorem

### Theorem 37.3 -- charge-filtered weak-factorization telescope

Assume that, for every hypothetical birational map
\(X\times\mathbf P^m\dashrightarrow\mathbf P^{m+3}\), one chosen weak
factorization admits a coherent occurrence-indexed realization satisfying:

1. every vertex carries a Module-34 augmented packet
   \((M_i,\rho_i)\), and all actual edge maps and adjacent reindexings land
   in one complete charge-filtered receiver;
2. after the declared edge orientation and occurrence reindexing, every
   actual comparison isomorphism \(J_i\) factors into ambient normalizing
   units and exceptional Stokes factors, with every exceptional factor in
   \(1+I_+\);
3. reduction modulo \(I_+\) deletes precisely those exceptional factors,
   leaving an actual degree-zero isomorphism \(\overline A_i\) satisfying

   \[
   \rho_i\overline A_i
   =c_i(\rho_{i-1}\oplus0),
   \qquad c_i\in K^\times,
   \tag{37.10a}
   \]

   with the analogous inverse equation for a reversed edge;
4. every adjacent-vertex reindexing is induced by the actual comparison and
   is row-compatible in the sense of (34.6a); and
5. typed endpoint certificates identify \((M_0,\rho_0)\) with the audited
   nonzero cubic/product row and \((M_n,\rho_n)\) with the zero projective
   endpoint row in the same phase.

Then \(X\times\mathbf P^m\) is irrational.  If these hypotheses hold on any
unbounded set of \(m\), they imply irrationality for every \(m\ge0\).

#### Proof

Proposition 37.1 deletes the positive factors after augmentation, so
(37.10a) is the row law for the actual edge map.  Theorem 37.2 supplies the
local quotient-line isomorphism.  The typed edge and reindexing maps then
telescope by Theorem 34.2, contradicting the endpoint certificates.  The
unbounded-to-all statement is Theorem 24.1.  \(\square\)

The theorem is uniform in \(m\) and does not require the local \(m=2\)
threefold-center boundary to vanish.  It replaces that theorem by a different
geometric provider: strict positive charge for every exceptional factor.

## 37.7 Exact pilot and next computation

The already-computed negative-degree pilot admits an exact first charge
test.

### Proposition 37.3A -- the hostile coefficient is not charge zero

Regard

\[
\frac{1-e^{-R}}{R}
=\frac1R[0]-\frac1R[-1]
\tag{37.11}
\]

as an element of the finite-support group algebra
\(K(R)[\mathbf Z]\), where the bracket records exponential support.  On the
submonoid \(\mathbf N(-1)\), define \(d(-n)=n\).  Then the hostile term

\[
-\frac1R[-1]
\tag{37.12}
\]

has degree one and belongs to \(I_+\), while augmentation retains only
\(R^{-1}[0]\).

#### Proof

The two support exponents in (37.11) are \(0\) and \(-1\).  The stated degree
map sends them to \(0\) and \(1\), respectively.  \(\square\)

Thus the known \(-1/R\) coefficient is hostile to an exposed-face
**cancellation** proof but harmless to the charge-zero **augmentation**
consumer, provided its exponent label survives the analytic realization.
This is a genuine separation between the two routes.  It does not prove that
(37.11) is itself a Stokes factor, nor that every other occurrence lies in
the same cone.

The cheapest remaining computation is not a full Stokes-matrix calculation.
For the toric blowup calibration and then
\(\operatorname{Bl}_X\mathbf P^5\), compute only:

1. the master-space Fourier/action label of each point-to-exceptional arrow;
2. its image under every coordinate and deck reindexing used by the
   comparison;
3. whether the exponent label in Proposition 37.3A is retained by the
   actual point-to-exceptional Stokes factor; and
4. whether all admitted occurrence charges remain in one strict cone.

An opposite exponential charge or a lawful reindexing which maps \(-1\) to
zero would still collapse the route.

Module 38 executes this bounded regression.  The two actual split pilots
have zero exceptional point coefficient; the negative-degree exponent
survives the displayed formal reparametrizations but has no proved
relative-cap Stokes lift.  It also proves that the full stationary charge
set of every codimension-\(r\ge3\) center is nonpointed.  Thus the naive
uniform all-branch charge provider is unavailable, while the unique
codimension-two charge remains a possible \(m=2\) specialization.

## 37.8 Executable calibration

The shared finite replay checks:

- closure of positive-degree series under products and inverses;
- invariance of augmentation under factor order and signed coefficients;
- preservation of positive charge by zero-reflecting path maps;
- the oriented degree-one label of the negative exponential pilot;
- the nonpointed Laurent countermodel (37.9); and
- the zero-charge row-shear countermodel (37.10).

These tests verify only the algebra above.  They do not construct a charge
lattice, a BPS structure, a Stokes factorization, or a QDM comparison.

## 37.9 EJ/TT and mystery ledger

**EJ.** The Boolean/rank consumer does not actually need the KS
wall-crossing identity once every factor is known to have positive charge.
The augmentation ideal forgets the ordering and all coefficients for free.

**TT.** The problem should be attacked first as a zero-charge collision
test, not as a positivity theorem for Stokes matrices.  Coefficient signs are
irrelevant; pointedness and zero-reflection are the exact laws.

| question | status | exact evidence or gate |
|---|---|---|
| Do positive-charge Stokes factors preserve the retained row quotient? | **yes** | Propositions 37.1 and Theorem 37.2 |
| Is detailed wall-crossing consumed by the final marker? | **no after a common positive filtration exists** | Section 37.3 |
| Can opposite nonzero charges manufacture charge zero? | **yes** | countermodel (37.9) |
| Can the full Stokes circle be declared positive at once? | **not in general** | opposite root/action directions violate pointedness; a strict fixed sector or row-stabilizing complement is required |
| Can one exceptional zero-charge arrow change the row? | **yes** | countermodel (37.10) |
| Does existing BPS/WKB/wild-Stokes theory supply the Iritani charge realization? | **not known** | no cited source identifies the blowup comparison with the required occurrence-indexed pointed charge receiver |
| Does the hostile \(-1/R\) coefficient itself have charge zero? | **no in the finite exponential-support model** | Proposition 37.3A |
| What did the bounded charge regression find? | **split pilots zero; negative formal label survives; higher-codimension full packet nonpointed** | Module 38 |
| What remains for the full provider? | **open** | convergence/completion, degree-zero ambient row law, typed adjacent reindexing, and endpoint calibration in one receiver |

## Boundary

The charge-filtration theorem is unconditional algebra.  Its QDM use is
conditional on a new occurrence-indexed analytic realization and endpoint
calibration.  No unconditional \(m=2\) or all-\(m\) theorem follows.
