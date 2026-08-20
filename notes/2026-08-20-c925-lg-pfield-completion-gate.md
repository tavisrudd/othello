# Module 52. The LG bypass needs a nontrivial critical target

**Packet part:** Module 52.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** Landau--Ginzburg wall crossing is a real way to make the extra
semistable boundary invisible, but it is not free in this problem.
Ballard--Favero--Katzarkov compare factorization categories across a crepant
GIT wall, and matrix factorizations only see a neighbourhood of the critical
locus.  However, any gauge-invariant nondegenerate quadratic fibre which can
be removed by equivariant Knörrer periodicity has total character zero.  It
cannot supply the nonzero correction \(c=(1,-1)\).  Pairing the canonical
coordinate with the existing discrepancy coordinate removes a genuine raw
direction.  Thus a successful \(p\)-field/GLSM route needs a new,
geometrically meaningful critical target and then a QDM/Gamma realization
of that target; it is not a formal repair of the ordinary completion.

## 52.1 What LG wall crossing actually supplies

Let a reductive group \(G\) act on a smooth quasi-projective variety \(A\),
and let \(w\) be a \(G\)-invariant potential.  For an elementary GIT wall
crossing, Ballard--Favero--Katzarkov define

\[
                         \mu=-t(K_+)+t(K_-).                   \tag{52.1}
\]

Their Theorem 3.5.2 says, under its affine-cover and zero wall-weight
hypotheses on \(w\), that

\[
 \mu=0
 \quad\Longrightarrow\quad
 D\!\operatorname{Fact}([A_-/G],w)
    \simeq D\!\operatorname{Fact}([A_+/G],w).                 \tag{52.2}
\]

For the canonical completions of Module 48, total character zero is exactly
the numerical crepancy input which makes the two window widths equal.
Therefore (52.2) is available whenever the remaining BFK wall hypotheses and
an appropriate invariant potential are supplied.  It does not require the
ordinary semistable loci to equal the intended total-space opens.

There is a second standard localization principle.  If
\(U\subset X\) is a \(G\)-invariant open neighbourhood of
\(\operatorname{Crit}(w)\), restriction induces an equivalence of coherent
matrix-factorization categories, under the usual smoothness and
localization hypotheses:

\[
                         \operatorname{MF}(X,w)
                    \simeq \operatorname{MF}(U,w).            \tag{52.3}
\]

Locally, this is because a partial derivative of \(w\) which is a unit makes
every matrix factorization contractible.  Thus Module 51's mixed
boundary--open points cease to matter if

\[
       \operatorname{Crit}(w)\cap
       (X_{\mathrm{completed}}\setminus U_{\mathrm{intended}})
                               =\varnothing.                   \tag{52.4}
\]

Equations (52.2)--(52.4) give a genuine categorical bypass of ordinary
open-kernel descent.

## 52.2 The harmless quadratic fibre cannot cancel discrepancy

The cheapest hope would be to add fibre coordinates which both cancel the
canonical character and disappear by equivariant Knörrer periodicity.

### Proposition 52.1 -- invariant quadratic balance

Let \(T\) be a split torus over a field of characteristic different from
two, and let \(A\) be a finite-dimensional \(T\)-representation.  If \(A\)
carries a \(T\)-invariant nondegenerate
quadratic form, then the sum of its weights is zero:

\[
                              \kappa(A)=0.                     \tag{52.5}
\]

#### Proof

The polar form gives a \(T\)-equivariant isomorphism
\(A\cong A^\vee\).  Hence the weight multiset of \(A\) is invariant under
\(\alpha\mapsto-\alpha\), with zero weights self-paired.  Summing the
multiset gives (52.5).  Equivalently,
\(\det A\cong(\det A)^{-1}\), so \(2\kappa(A)=0\); the character lattice of a
split torus is torsion-free.  \(\square\)

### Corollary 52.1A -- no pure Knörrer correction

Let the raw pilot representation have
\(\kappa(W)=(-1,1)\).  There is no added representation \(A\) such that

1. \(\kappa(A)=-\kappa(W)=(1,-1)\); and
2. an invariant fibrewise nondegenerate quadratic potential on \(A\) removes
   all of \(A\) by equivariant Knörrer periodicity while leaving the raw
   geometry \(W\) unchanged.

#### Proof

Condition 2 invokes Proposition 52.1 and forces \(\kappa(A)=0\), contrary to
condition 1.  \(\square\)

This is independent of the number of added coordinates and strengthens the
ordinary support-cone obstruction in a different direction: even after
allowing a superpotential, a completely metabolic added fibre cannot carry
the required discrepancy.

## 52.3 Semi-invariant potentials do not fix both walls

One could let \(w\) be a section of a \(G\)-line bundle of character
\(\eta\), rather than an invariant function.  BFK's wall hypothesis requires
the line bundle to have zero weight on the fixed locus of the crossing
one-parameter subgroup:

\[
                             \langle\eta,\lambda\rangle=0.     \tag{52.6}
\]

### Proposition 52.2 -- two-wall character forcing

Let \(T\) be the connected split rank-two pilot torus.  If the two
coordinate-wall cocharacters \(\lambda_1,\lambda_2\) span its cocharacter
space and the same semi-invariant potential of character
\(\eta\in X^*(T)\) is to satisfy the BFK zero-weight hypothesis at both
walls, then

\[
                                  \eta=0.                      \tag{52.7}
\]

#### Proof

Equation (52.6) for \(i=1,2\) says that \(\eta\) annihilates a spanning set of
the cocharacter space.  Hence \(\eta=0\) in the character space, and
integrality gives the same conclusion in the lattice.  \(\square\)

Thus a nontrivial gauge character cannot be hidden in one common potential
through both consecutive coordinate walls.

## 52.4 The tempting linear potential deletes a raw direction

Every five-signature raw pilot contains the discrepancy weight

\[
                            \kappa=(-1,1),                     \tag{52.8}
\]

while the added canonical coordinate \(p\) has weight
\(c=-\kappa=(1,-1)\).  If \(x_\kappa\) is a raw coordinate of weight
\(\kappa\), then

\[
                              w=p\,x_\kappa                    \tag{52.9}
\]

is gauge invariant and nondegenerate in the pair \((p,x_\kappa)\).  It is
also critical-free wherever \(p\ne0\), so it kills every extra semistable
boundary point of the one-coordinate completion in Module 49 and every
mixed witness in Module 51.  This statement is not about Module 50's
arbitrary multi-coordinate completions, which need not contain such a
\(p\)-coordinate.

Its critical locus has \(p=x_\kappa=0\).  If an invariant neighbourhood of
that locus in the GIT quotient is independently identified with the total
space of the hyperbolic pair
\(\mathcal L_c\oplus\mathcal L_\kappa\) over the quotient built from the
remaining raw coordinates, relative equivariant Knörrer periodicity removes
**both** \(p\) and \(x_\kappa\).  The resulting category is then attached to
the raw representation with a genuine discrepancy coordinate deleted, not
to the original raw quotient or its QDM.  Ordinary GIT semistability can
depend on both coordinates, so this product-neighbourhood identification is
an additional occurrence hypothesis; without it, even the deleted-coordinate
endpoint is not typed.  Equation (52.9) therefore demonstrates the mechanism
while failing the required endpoint type in either reading.

More generally, a \(p\)-field potential \(p f\) recovers the zero locus
\(\{f=0\}\), not the full base.  Chang--Li's stable-map and stable-quasimap
\(p\)-field theorems make this precise at the virtual-cycle level: the
cosection degeneracy locus is the hypersurface theory, and the localized
class agrees with the hypersurface virtual class up to the stated sign.  This
is powerful evidence for the LG mechanism, but it necessarily changes the
geometric target unless the desired object was already that zero locus.

## 52.5 Relation to the QDM/Gamma consumer

The source packages divide into three levels:

1. BFK Theorem 3.5.2 gives a derived factorization-category equivalence for a
   crepant LG wall;
2. Chang--Li gives cosection-localized virtual-cycle identities for
   hypersurface \(p\)-field theories; and
3. Iritani--Mann--Mignon and Shoemaker give quantum-Serre/narrow QDM and
   Gamma-integral structures for an actual vector-bundle total space or
   complete intersection.

No cited theorem identifies the BFK equivalence for the completed mixed
pilot with the fixed primitive-sixth QDM/Gamma row of the actual birational
overlap.  In particular, none constructs:

\[
\begin{CD}
 K_0\operatorname{MF}(X_-,w) @>{\mathrm{BFK}}>>
 K_0\operatorname{MF}(X_+,w)\\
 @V{\text{actual fixed-phase realization}}VV
 @VV{\text{actual fixed-phase realization}}V\\
 Q_{\zeta_6}(V_-,\rho_-) @>{\sim}>>
 Q_{\zeta_6}(V_+,\rho_+).
\end{CD}                                                       \tag{52.10}
\]

Moreover, Corollary 52.1A shows that a potential which is merely a harmless
quadratic stabilization cannot provide the missing vertical arrows while
retaining the original endpoints.  A successful LG route must specify a
nontrivial critical target whose QDM is independently identified with the
cubic packet.

## 52.6 Source audit

- Ballard--Favero--Katzarkov, *Variation of geometric invariant theory
  quotients and derived categories*, arXiv:1203.6643, Theorem 3.5.2, proves
  (52.2) for an elementary wall crossing of a smooth quasi-projective
  \(G\)-variety, with \(G\) reductive, the stated affine-cover hypothesis,
  and zero \(\lambda\)-weight for the potential line bundle.  Cached PDF SHA:
  b6bfbfd977ee6cdf91ba5b463b9ad296766fdac55dedc80558edb50b1a1860b3.
- Chang--Li, *Gromov--Witten invariants of stable maps with fields*,
  arXiv:1101.0914, Theorem 1.1, identifies the \(p\)-field invariant with the
  quintic invariant up to sign; its Section 3 constructs the cosection and
  degeneracy locus.  Cached PDF SHA:
  77faf1245fe5d422cb7f1b32d15626cdced8bab502903e2e8947e8ed1dd705b3.
- Chang--Li, *Invariants of stable quasimaps with fields*,
  arXiv:1804.05310, Theorem 1.1, gives the corresponding equality of
  cosection-localized and hypersurface quasimap virtual classes.  Cached PDF
  SHA:
  e89144b05371c7b08eefd1fbe36af99c98572a73d42691947a0b8c1b0c2acef6.
- Iritani--Mann--Mignon and Shoemaker remain scoped exactly as in Modules
  42, 44--46.  They do not supply the mixed-pilot BFK-to-QDM square (52.10).

The categorical localization principle (52.3) is used only under the named
smoothness/localization hypotheses.  No claim is made that a virtual-cycle
identity automatically yields a quantum connection or Gamma-integral
structure.

## 52.7 EJ/TT and mystery ledger

**EJ.** The simplest potential \(p x_\kappa\) perfectly removes the bad
boundary, showing that the LG idea is geometrically real.  Its failure is
equally precise: it deletes the raw discrepancy coordinate along with the
completion coordinate.

**TT.** Ask what critical theory remains after localization.  “The boundary
is invisible” is not enough; the surviving category/QDM must still have the
original endpoint type.  Weight balance proves that a harmless quadratic
stabilization cannot do both jobs.

| question | status | exact evidence or gate |
|---|---|---|
| Can an LG potential bypass mixed ordinary semistability? | **yes categorically** | BFK plus critical-locus localization |
| Can a pure nondegenerate added quadratic also cancel \(c\ne0\)? | **no** | Corollary 52.1A |
| Does \(p x_\kappa\) kill the bad boundary? | **yes** | direct critical-point calculation |
| Does it retain the original raw geometry? | **no** | it eliminates \(x_\kappa\) by Knörrer periodicity |
| Do current \(p\)-field sources produce the needed fixed-phase QDM/Gamma row? | **no** | they give hypersurface virtual cycles, not (52.10) |
| What would make LG viable? | **a nontrivial critical target with an independently proved QDM/Gamma identification** | open provider |

## Boundary

Module 52 does not rule out a genuinely new GLSM/\(p\)-field proof.  It rules
out the cheap version in which a purely added metabolic quadratic fibre both
cancels the canonical discrepancy and disappears without changing the raw
endpoint.  Existing LG and cosection theorems show how to recover a
hypersurface or complete intersection, not the full original overlap QDM.
The normal-jet fixed-phase row adapter therefore remains the shortest
currently typed route.
