# C692 — cross-sheet incidence versus the Gorenstein pairing

**Lane:** `clebsch`

**Date:** 2026-07-30

## Verdict

The C689 cross-sheet incidence matrix does not supply Paper II's
Gorenstein perfect pairing.  It stops one canonical dimension short.

It does have a precise role.  If
\[
 P_\pm=\mathbb F_q^{\Omega_\pm},\qquad
 P_{\pm,0}=\ker\left(\sum:P_\pm\longrightarrow\mathbb F_q\right),
 \qquad S_\pm=\mathbb F_q\mathbf1,
\]
then \(S_\pm\subset P_{\pm,0}\) because the characteristic is \(q\).
Writing \(A\) for the cross-incidence matrix, exact reconstruction gives
\[
 \bar\rho_-=2A^{\mathsf T}\bar\rho_+
 :L/(S_+\oplus S_-)\longrightarrow P_{-,0}/S_-             \tag{1}
\]
after identifying the source with the common top module
\(P_{+,0}/S_+\).  Thus \(A\) identifies the two copies of the
\((q-2)\)-dimensional top module.  Since
\[
 AA^{\mathsf T}=\frac14(I+J),
\]
the map \(2A^{\mathsf T}\) is an isometry after passage to
\(P_0/S\).

The Artinian Gorenstein pairing has different degrees and different
dimensions.  It is
\[
 \mathcal A_1\times\mathcal A_2\longrightarrow\mathcal A_3,
 \qquad
 \mathcal A_1=L/\langle\mathbf1\rangle,\quad
 \mathcal A_2=L^{\circ2}/L,\quad
 \mathcal A_3=\mathbb F_q^{2q}/L^{\circ2},                 \tag{2}
\]
with dimensions
\[
 (1,q-1,q-1,1).
\]
Its scalar form is the signed coordinate pairing
\[
 B((u_+,u_-),(v_+,v_-))
   =u_+\mathbin{\cdot}v_+-u_-\mathbin{\cdot}v_- .           \tag{3}
\]
The extra degree-one line in (2) is the radial sheet-constant class.
Its degree-two partner is the common-sheet-sum direction in
\(L^{\circ2}/L\).  Neither survives in \(P_0/S\).

Consequently the cross pairing has rank \(q-2\), whereas the Gorenstein
pairing has rank \(q-1\):
\[
\begin{array}{c|cc|c}
T&q&\operatorname{rank}(P_0/S\text{ cross pairing})
&\operatorname{rank}(\mathcal A_1\times\mathcal A_2)\\ \hline
B_3&7&5&6\\
H_3&11&9&10.
\end{array}
\]
This is the exact mismatch requested by C692.

## The missing radial pair

The one-dimensional defect is visible without coordinates.  Let
\(e_-=(0,\mathbf1)\in L\); its class modulo
\(\mathbf1=(\mathbf1,\mathbf1)\) is the radial line in
\(\mathcal A_1\).  Put
\[
 K=\{(u_+,u_-):\textstyle\sum u_+=\sum u_-\}.
\]
Paper II's quadratic theorem says \(L^{\circ2}=K\).  A vector
\((\delta_+,\delta_-)\), with one coordinate delta on each sheet, lies
in \(K\) but not in \(L\), and
\[
 B(e_-,(\delta_+,\delta_-))=-1.                              \tag{4}
\]
This is the missing perfect pair.  By contrast, the cross form on
\(P_0\) kills the constant line:
\[
 \mathbf1^{\mathsf T}A\mathbf1=q\frac{q+1}{2}=0.
\]
Bordering \(A\) to the Paley--Hadamard matrix does not turn (4) into a
graded multiplication map; the added border is not the common-sum
class in \(L^{\circ2}/L\).

## Direct Gorenstein proof left by the comparison

Although \(A\) does not prove Gorenstein perfectness, the comparison
exposes a shorter proof using the quadratic theorem already in Paper II.
On
\[
 V=P_+\oplus P_-
\]
the form \(B\) in (3) is nondegenerate.  Since
\[
 L^{\circ2}=K=\langle\mathbf1\rangle^{\perp_B},
\]
every product of two elements of \(L\) has zero signed sum.  Hence \(L\)
is \(B\)-isotropic.  Its dimension is \(q=\frac12\dim V\), so
\[
 L=L^{\perp_B}.
\]
The form \(B\) therefore descends to
\[
 L/\langle\mathbf1\rangle
 \ \times\
 \langle\mathbf1\rangle^{\perp_B}/L
 \longrightarrow\mathbb F_q,                               \tag{5}
\]
and (5) is perfect: its left radical is
\(K^\perp/\langle\mathbf1\rangle=0\), while its right radical is
\(L^\perp/L=0\).

Under the evaluation-algebra identifications, (5) is exactly the
degree-\(1\)-by-degree-\(2\) multiplication pairing in (2).  Together
with \(L^{\circ3}=V\), it proves directly that the Artinian reduction is
Gorenstein with Hilbert function \((1,q-1,q-1,1)\).  Regularity of the
homogenizing coordinate then gives the arithmetically Gorenstein
projective coordinate ring.

This maximal-isotropic argument is suitable for C694's v2 editorial
integration.  It shortens the existing passage through the external
self-association criterion and Hilbert symmetry, but it is a consequence
of \(L^{\circ2}=K\), not of the C689 design inverse.

## Paley and differential boundary

The Paley/Hadamard carrier contributes no essential step to (5).  Its
use is the isometry (1), which identifies the two top sheet restrictions
and gives a conceptual replacement for the equality of their top
second-moment forms.

The defining-characteristic square-zero operator also remains inside the
sheet augmentation module.  It does not produce the common-sheet-sum
class in degree two, nor a multiplication map
\(\mathcal A_1\to\mathcal A_2^\vee\).  Matching its filtration with the
cubic would still require the exact filtration map and quadratic-twist
sign forbidden by the task boundary.  No such identification is claimed.

C689 should therefore enter Paper II v2 only through its shared
alternating-cycle radial nonvanishing mechanism.  The top-sheet isometry
(1) records where the attempted bridge stops; C694 need not add it to the
manuscript.

## Reproducibility

From the repository root:

```text
python3 notes/2026-07-30-c692-cross-sheet-gorenstein.py --check
python3 notes/2026-07-30-c692-cross-sheet-gorenstein-independent.py
sha256sum -c notes/2026-07-30-c692-cross-sheet-gorenstein.sha256
```

The primary replay reconstructs the two matching orbits, their sheets,
the cross-incidence matrices, and the affine quotient points from the
paper's exact matching module.  It verifies the inverse formula, (1), the
rank-\((q-2)\) cross pairing, maximal isotropy, all four Artinian
dimensions, and all four Gorenstein pairing ranks.

The independent replay uses the separately implemented matching and
conic-quotient reconstruction from Paper II's independent Gorenstein
checker.  It obtains the same graph scalar, cross-pairing ranks, Artinian
dimensions, and one-dimensional deficits.

| file | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-30-c692-cross-sheet-gorenstein.py` | 9267 | `8ccd7178d7049567a42cc9a91ceeeefc52e81b4af9b37f03a6aed7bb82c69421` |
| `notes/2026-07-30-c692-cross-sheet-gorenstein-independent.py` | 4018 | `65c693d995a96eb7da82d1b2adb5c55790ab139ce205c1590061c6a26a9a098b` |
| `notes/2026-07-30-c692-cross-sheet-gorenstein.json` | 3401 | `2d45ea4ec79f6bf19fa325fd5750383b8c87871f9299e011416cd8f14cce857e` |

The replay is finite evidence for the two classified \(B_3/H_3\)
configurations.  The quotient proof of (5) is ordinary linear algebra
from Paper II's symbolic identity \(L^{\circ2}=K\).  No literature
absence or priority claim is made.

## Extra juice and Tao closeout

The useful positive residue is (1): the cross design is exactly the
apolar isometry between the two simple top modules that Paper II
previously obtained abstractly.  The identity
\(AA^{\mathsf T}=\frac14(I+J)\) forces its scalar to be \(\pm2\), because
the \(J\)-term vanishes on augmentation; the frozen matching
normalization selects \(+2\).  This locates the attempted bridge but is
not needed in v2.

The decisive Tao question is whether a degree-preserving pairing of two
sheet modules can become a degree-reversing Frobenius pairing merely
because both ambient modules have dimension \(q\).  It cannot: the actual
evaluation image is \(P_0\), its constant line is radical, and quotienting
leaves dimension \(q-2\).  The Gorenstein algebra keeps a radial class in
degree one and pairs it with a non-augmentation class in degree two.
The apparent dimension match disappears after writing the exact
quotients.

## Mystery ledger

| feature | status | exact remaining gate |
|---|---|---|
| role of \(A^{-1}=4A^{\mathsf T}(I-J)\) | settled: perfect transport of the two full sheet modules and an isometry on \(P_0/S\) | none |
| relation to quotient evaluations | settled for both types by \(\bar\rho_-=2A^{\mathsf T}\bar\rho_+\) | a human equivariant derivation is optional if C694 uses this secondary explanation |
| missing Gorenstein dimension | settled: the radial degree-one line pairs with the common-sheet-sum degree-two line | none |
| Gorenstein perfectness | settled directly by maximal isotropy and quotient duality | none |
| Paley/Hadamard essentiality | settled negative for the Gorenstein proof | retain only as top-sheet structure |
| middle-layer differential versus cubic | no identification claimed; it lacks the required graded filtration/product map | outside C692; do not promote without that exact map and twist |

No genuine mystery remains inside C692's bounded comparison.

## Disposition

C692 is complete with a negative verdict on the proposed cross-incidence
replacement and a positive maximal-isotropic simplification for C694.
Paper II v1 is unchanged.

Vibe check: the apparent perfect-pairing bridge was one dimension too
small, but locating that dimension exposed a cleaner Gorenstein proof
already latent in Paper II's quadratic theorem.
