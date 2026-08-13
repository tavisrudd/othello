# C907 — smooth simple-wall coverage obstruction

Date: 2026-08-13

Status: exact negative coverage result.  The smooth-projective simple-VGIT
rank theorem does not by itself globalize to an arbitrary birational map of
smooth projective fivefolds.  Birational cobordism produces projective locally
toric wall quotients, generally with cyclic quotient singularities.  Making
those quotients smooth requires subdivisions that are geometric blowups and
blowdowns, so the old peak-coherence problem returns.

## 1. What birational cobordism actually supplies

Wlodarczyk's Proposition 2(B') constructs a smooth projective cobordism for
two smooth projective birational varieties.  Its elementary pieces induce
simple toroidal flips, blowups, or blowdowns with weighted-projective fibres
(Proposition 1, Lemmas 4 and 9).  Smoothness of the master does **not** imply
smoothness of its chamber quotients.

The local model is already decisive.  For a smooth affine master with
positive weights `a_i` and negative weights `-b_j`, chamber charts have the
form

\[
 \{x_i=1\}/\mu_{a_i}.
\]

Wlodarczyk's Example 2 explicitly records the resulting cyclic
singularities.  Theorems 1 and 2 consequently factor smooth projective
endpoints through complete varieties with cyclic singularities, not through
smooth-projective simple-VGIT chambers.

AKMW sharpen the projectivity statement but not smoothness.  Theorem 2.6.2
produces projective locally toric intermediate spaces when the endpoints are
projective.  Lemma 2.6.1 identifies the local toric wall models.  Thus the
exact output needed here is

\[
 \text{smooth projective master}
 \quad\Longrightarrow\quad
 \text{projective locally toric chamber quotients},
\]

not smooth projective quotients.

## 2. Why subdivision does not close the gap

AKMW Sections 0.8--0.9 and Theorem 2.7.1 torify and desingularize the
cobordism by blowing up torific ideals, resolving, and regularly subdividing
the associated complexes.  In toric geometry a regular subdivision inserts
rays, hence exceptional divisors.  It is therefore a chain of toroidal
blowups and blowdowns, not a cost-free replacement of the original wall by a
smooth simple wall.

The final weak-factorization theorem does give smooth projective
intermediates and smooth centers, but its arrows are precisely those inserted
blowups/down.  Applying the one-arrow receiver to them recreates the
incompatible peak frames isolated in
`2026-08-13-c907-peak-confluence-obstruction.md`.

Root constructions or smooth toric DM stacks merely expose the finite
stabilizers.  They do not regularize the singular coarse cone.  Coarse
smoothness again requires a subdivision and therefore a blowup.

## 3. Fivefold regression

The phenomenon occurs in the Gold dimension.  The affine weights

\[
 (1,1,2,-1,-1,-1)
\]

give a five-dimensional chamber quotient with a local `A^5/mu_2` chart and
weighted exceptional fibre `P(1,1,2)`.  A projective compactification gives
a projective fivefold wall example.  Hence dimension five supplies no
automatic smoothness theorem that could rescue Gold.

## 4. Consequence for C907

The theorem in `2026-08-13-c907-simple-vgit-rank-theorem.md` is a genuine
positive peak class and a publishable stepping stone, but it does not close
Gold by formal appeal to birational cobordism.  The remaining alternatives
are now exact:

1. extend the ambient point-coordinate and oriented-rank theorem to smooth
   DM/toroidal simple walls and prove compatibility with coarse endpoints;
2. prove the peak lemma for the subdivisions inserted by torification;
3. construct a common master-space realization that survives the singular
   coarse wall without resolving it first.

The first route is the smallest apparent extension.  It needs orbifold
quantum D-modules, orbifold Gamma/Euler pairing, and a point-coordinate
argument in the completed Fourier source; none is supplied by the two
birational-cobordism papers.  The nearest existing theorem is Iritani's
formal pairing-preserving decomposition for discrepant toric GIT walls of
smooth semiprojective toric DM stacks.  Its Gamma/Stokes lift is proved only
for compact weak-Fano toric weighted blowups along toric substacks.  Thus a
toric-DM weighted-wall point-row theorem is the smallest source-supported
extension; arbitrary finite-stabilizer or toroidal VGIT remains beyond the
available package.

The source boundary is strict.  Crepant toric-DM wall-crossing theorems give
Gamma/Fourier--Mukai compatibility but no discrepant ambient-plus-center
decomposition.  General GIT wall-crossing formulas for smooth proper DM
quotients give potentials, not a pairing-preserving QDM direct sum or Stokes
packet control.  No 2024--2026 primary source located in the audit combines
all four ingredients needed here.

## 5. AA / EJ / TT

- **AA:** the tempting opposite statement—every smooth-projective
  birational map admits only smooth-projective simple walls—is false already
  in the weighted local model above.
- **EJ:** the obstruction is one integer weight greater than one.  It creates
  a finite quotient in the chamber; regularizing that quotient necessarily
  inserts a ray and therefore a blowup.
- **TT:** three type boundaries are load-bearing.  Smoothness belongs to the
  master, while Gu--Yu--Yu require smoothness of the chamber quotients.
  Exactness holds for the ambient point coordinate, not for the full point
  column.  Gu--Yu--Yu's pairing is the formal Poincare-QDM pairing, while the
  Gamma/Stokes rank statement additionally uses the fixed-sector receiver
  and Shen--Shoemaker's oriented Euler orthogonality.  Crossing any one of
  these boundaries silently recreates a false Gold proof.

## Sources

- J. Wlodarczyk, *Birational cobordisms and factorization of birational
  maps*, arXiv:math/9904074v1, especially Proposition 2(B'), Example 2,
  Lemmas 9 and 11, and Theorems 1--3; cached SHA-256
  `ac86c460c3a039284565630ef63a77028af53a71697d4d0deb356574d2b3aa9c`.
- D. Abramovich, K. Karu, K. Matsuki, J. Wlodarczyk, *Torification and
  factorization of birational maps*, arXiv:math/9904135, especially
  Sections 0.8--0.9, Lemma 2.6.1, Theorems 2.6.2 and 2.7.1, and the weak
  factorization theorem; cached SHA-256
  `55bbc2c58f29d4b9dbe965035f80f3844f6968eaf98076ac625132ac3b3977a5`.
- H. Iritani, *Global mirrors and discrepant transformations for toric
  Deligne--Mumford stacks*, arXiv:1906.00801, Theorem 5.16 and Theorems
  7.25, 7.31, 7.33.  The first is the formal toric-DM decomposition; the
  latter are the narrower weak-Fano weighted-blowup Gamma/Stokes results.
