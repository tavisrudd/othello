# C904: primary-literature audit for the degree-\(15\) \(D_{3,3}\) packet

Date: 2026-08-11  
Scope: read-only claim audit; no manuscript or Lean change  
Verdict: **apparently unpreempted; special-fibre count GO, generic theorem MINOR pending two printed comparison lemmas**

## Strongest candidate theorem

Let \(Y\) be a general smooth cubic threefold and let \(E\) be a general
globally generated point of Voisin's \(M_9(Y)\). The normalization of the
fibre of

\[
                 D_{3,3}\dashrightarrow M_9
\]

is a \(\mathbf P^1\)-bundle over a finite etale
\(K=\mathbf C(M_9)\)-scheme \(R_{3,3}(E)\) of length \(15\).
Geometrically it is the disjoint union of fifteen projective lines.
It is tempting to identify their quotient with Voisin's intermediate
rational quotient \(Z\), but that stronger comparison requires an additional
linearity calculation and is not used below.

The odd degree supplies a degree-\(15\) zero-cycle on the actual generic
\(D_{3,3}\)-fibre. The statement should say *geometrically rank-two
quadrics*: over a residue field the two hyperplanes can be Galois conjugate,
but the unordered pair and the section pencil still descend.

## Exact primary-source boundary

### Voisin

In Section 2 of *Abel--Jacobi map, integral Hodge classes and decomposition
of the diagonal*, Voisin proves:

1. a general elliptic sextic gives a stable rank-two bundle \(E\) with
   \(c_1(E)=2H\), \(\deg c_2(E)=6\), \(h^0(E)=4\), and section space
   \(\mathbf P^3\);
2. \(M_{6,1}\dashrightarrow M_9\) is dominant with general fibre
   \(\mathbf P^3\);
3. \(D_{3,3}\dashrightarrow M_9\) is dominant and its general fibre has
   dimension exactly one (Lemma 2.4);
4. \(D_{3,3}\to S^2\Theta\) has general fibre birational to \(S^2E_3\);
5. in the proof of Lemma 2.9 she passes to a birational fibration
   \(Z\dashrightarrow S^2\Theta\) with fibre
   \(\operatorname {Pic}^2(E_3)\), using
   \(S^2E_3\to\operatorname {Pic}^2(E_3)\).

She does **not** state that the \(D_{3,3}\)-fibre is a union of lines,
construct \(Z\dashrightarrow M_9\), compute its degree, or mention \(15\).

### Harris--Roth--Starr

The HRS papers supply the needed Hilbert-scheme tools:

- \(H_{3,0}(Y)\) is smooth irreducible of dimension \(6\); each twisted
  cubic spans a unique hyperplane, and the Abel--Jacobi map is birationally
  a \(\mathbf P^2\)-bundle over a theta translate.
- For \(1\le d\le5\), the relevant smooth-curve spaces have dimension
  \(2d\). General rational quartics and quintics are nondegenerate in
  \(\mathbf P^4\); Lemma 7.1 gives
  \(\dim H_{4,0}^{\rm deg}\le7\).

Neither paper introduces or counts the wedge-quadric packet.

### Fine \(M_9\) and universal sections

Xu, Theorem 2.2, quotes the Huybrechts--Lehn universal-family criterion:
the stable-sheaf moduli class is fine when the Euler-pairing weights have
gcd \(1\). For the normalized charge-three bundle \(F=E(-1)\),

\[
 \operatorname {ch}(F)=2-3[\ell],\qquad
 \operatorname {td}(Y)=1+H+2[\ell]+[\mathrm {pt}],\qquad
 \chi(F)=-1.
\]

Thus the criterion applies already with the test sheaf \(\mathcal O_Y\).
On the open where \(h^0(E)=4\), cohomology and base change gives an honest
rank-four bundle of sections, an honest relative \(G(2,4)\), and an honest
tautological rank-two bundle. Hence
\(\mathbf P(\mathcal U|_R)\to R\) has a residue-field point in every fibre,
and

\[
 \operatorname {ind}\mathbf P(\mathcal U|_R)
       =\operatorname {ind}(R).
\]

There is no hidden two-primary Severi--Brauer obstruction in this
charge-three step.

### Exact index consequence—and its limit

If the generic comparison is proved, then

\[
 \operatorname {ind}(D_{3,3,E}^{\rm norm})
   =\operatorname {ind}(R_{3,3}(E))\mid 15.
\]

Thus the mysterious generic \(D_{3,3}\)-curve has odd index.  Voisin's
generic \(\operatorname {Sym}^2(E_3)\) fibre has index dividing \(3\), so it
also does not alter the two-primary part. Consequently the packet transfers the
two-primary index question for the generic Abel--Jacobi fourfold to the
unordered-theta fibre.

It does **not** by itself prove an odd zero-cycle on that fourfold: the
index-one versus index-two question for the unordered-theta fibre remains
open. The new theorem removes the intervening \(D_{3,3}\)-curve
cancellation ambiguity; it does not close the whole relative-cycle gate.

## Audit of the exact computation

The new artifacts construct six quadratic Pluecker coordinates satisfying

\[
 q_{01}q_{23}-q_{02}q_{13}+q_{03}q_{12}=zF
\]

with \(F\) a smooth cubic. On \(Y=(F=0)\) they define a globally generated
rank-two bundle. The Sage computation checks:

- no base point on \(Y\);
- a smooth, prime, nondegenerate section curve with Hilbert polynomial
  \(6t\);
- \(H_C(1)=5\), \(H_C(2)=12\), hence \(h^0(I_C(2))=3\) and \(h^0(E)=4\);
- the saturated rank-at-most-two packet on
  \(G(2,4)\subset\mathbf P^5\) has length \(15\), is radical, and has no
  rank-one point.

The Macaulay2 replay checks the same hard-coded symmetric matrix and reports
degree \(15\), radicality, primeness over \(\mathbf Q\), and absence of
rank-one points.

Artifacts as read:

- 2026-08-11-c904-factorable-quadric-packet.sage,
  SHA-256 836d56922ed6aa1ade6ec7db2249f81e0b569d50a3bf6ac76570b354f7358961;
- its output,
  SHA-256 d7e5f0df050e0bef6ef5aa2b109ee471c57a84cb48543189e0ac0abc83dbc64d;
- 2026-08-11-c904-factorable-quadric-packet-replay.m2,
  SHA-256 105a6b7b684329f9614d81cff6096ffd2c15ff0d59cb2288f6e9424edb413b52;
- its output,
  SHA-256 ffbaea344a8f1b3a29b487109f5d76b659a89a92b24c55996b2821a6a3d35361.

At audit time these files were untracked and the older reduction note still
said that the packet had not been counted. Before paper use, commit an atomic
evidence bundle with exact commands, Sage/Macaulay2 versions, hashes, byte
counts, and an updated report. The replay is independent at the
computer-algebra-engine level, but imports the first computation's matrix
rather than independently deriving it.

## Gate 1: the computed normal form must dominate framed \(M_9\)

The intended proof is short and should be printed.

1. For a general framed bundle the wedge quadrics satisfy
   \(\operatorname {Pf}(q)=F\ell\), since their Pluecker relation vanishes
   on \(Y=(F=0)\).
2. On \(H=(\ell=0)\), the restricted quadrics define a four-generated
   rank-two bundle \(B\) on \(\mathbf P^3\) with
   \(\det B=\mathcal O(2)\).
3. Three quadrics from a general section form a \((2,2,2)\) complete
   intersection: the elliptic sextic plus a degree-two residual on \(H\).
   Liaison gives residual arithmetic genus \(-1\), so it is a pair of skew
   lines, not a plane conic. Thus \(c_1(B)=c_2(B)=2\).
4. The locally free case of Ballico--Huh--Malaspina, Proposition 4.5,
   identifies \(B\) with a null-correlation bundle \(N(1)\).
5. After changing coordinates and the section basis, every general framed
   system is therefore a lift
   \(q_{ij}=q^H_{ij}+z\ell_{ij}\), precisely the family sampled by the
   script.

Once this lemma is in place, properness of the relative Grassmannian packet,
generic flatness, and geometric reducedness of the displayed
characteristic-zero fibre give a finite etale degree-\(15\) packet on a
nonempty open. The upgraded script already closes the earlier
stability/\(h^0\) concern.

## Gate 2: all fifteen points must belong to \(D_{3,3}\)

The determinantal ideal counts every geometrically rank-at-most-two wedge
quadric, not automatically only the \((3,3)\) stratum.

A regular section curve satisfies

\[
        \omega_C=(\omega_Y\otimes\det E)|_C\cong\mathcal O_C.
\]

For a generic nodal union of two smooth components, this forces both
components to be rational and to meet in two points. In an unbalanced split
\((1,5)\) or \((2,4)\), the degree-\(5\) or degree-\(4\) component must be
hyperplane-degenerate. HRS makes that a proper codimension-at-least-one
condition. A two-marked incidence count then has dimension at most \(9\);
the fixed-quadric section pencil gives fibre dimension at least one over
\(M_9\), so its image has dimension at most \(8\) and cannot meet the
general point of the nine-dimensional \(M_9\). More-component and singular
strata are smaller.

This one-page incidence lemma should be explicit. A finite-field type audit
is a useful diagnostic, but is not a substitute for the
characteristic-zero argument.

## Comparison with Voisin's \(Z\)

For \(C_s=A_s\cup B_s\) on \(H_1\cup H_2\), put

\[
 D_s=A_s\cap B_s\subset E_3=Y\cap H_1\cap H_2.
\]

The divisor \(D_s\) has degree \(2\).  Along a fixed wedge pencil
\(\mathbf P(U)\), the components move in fixed pencils inside their
two-dimensional twisted-cubic linear systems.  To identify
\(\mathbf P(U)\) with an Abel fibre of
\(S^2E_3\to\operatorname {Pic}^2(E_3)\), one must still prove that the
resulting map to the degree-two linear system is induced by a nonzero linear
map of two-dimensional section spaces.  Nonconstancy alone does not control
its degree.  This stronger comparison is therefore pending and is not needed
for the index theorem: Voisin's map from the full \(D_{3,3}\) incidence to
\(S^2\Theta\), whose generic fibre is birational to \(S^2E_3\), already
supplies the odd index-dividing-three relay.

## Priority and venue verdict

Scoped exact-phrase and full-text searches for \(D_{3,3}\), \(M_9\),
\(\operatorname {Pic}^2(E_3)\), reducible/rank-two wedge quadrics, and
degree/fifteen variants found Voisin itself or unrelated classical
configurations. HRS, the null-correlation classification, and Xu supply
tools, not the theorem. No primary source found preempts the packet or
degree \(15\).

This is a bounded negative result. MathSciNet was not directly searched;
forward-citation coverage was limited to web-visible citation lists and
exact/full-text searches.

The degree-\(15\) theorem is a beautiful, exact strengthening of Voisin and
an exact odd-index theorem for her intervening curve. By itself it has **strong specialist
journal / Inventiones-component** ceiling, not standalone Annals scale.
As the missing arithmetic hinge in a broader bidirectional reconstruction
or relative-cycle theorem, it can support an Annals-level crown.

## Read-depth ledger

- Claire Voisin, arXiv:1005.5621v2: complete \(M_9\), \(D_{3,3}\),
  Lemma 2.4, and Lemma 2.9 passages; PDF SHA-256
  ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547.
- Harris--Roth--Starr, arXiv:math/0202080: Sections 3--4 and Corollary 4.3;
  PDF SHA-256
  fae17135016e77425060e8c0860c9938facda3144ac1cd091a853d34c337d3ec.
- Harris--Roth--Starr, arXiv:math/0202067: deformation setup and
  twisted-cubic, degenerate-quartic, and rational-quintic passages; PDF
  SHA-256
  d3e38aca85883bb638ae143c56aa966e24c9c6204c8f2f1e9816903b5bfb182a.
- Ballico--Huh--Malaspina, arXiv:1301.1822: Proposition 4.5 and its proof;
  PDF SHA-256
  dc71f70f50ea5ef92d759bdab1651a3598e24d76a8e3b73da9ed0386c460e922.
- Ze Xu, DOI 10.1016/j.crma.2012.12.002: complete five-page note,
  especially Theorem 2.2; PDF SHA-256
  a3da147d0004942fd72faa1827f02fa2684108295530808aa9ab5f949ca851e1.

## Closeout ledger

- **Closed:** Voisin does not publish degree \(15\).
- **Closed:** the proposed degree is compatible with, but stronger than,
  Voisin's \(Z\).
- **Closed:** charge-three \(M_9\) is fine on the needed open, so the
  projective-line/index step descends.
- **Closed after the generic comparison:** the intervening
  \(D_{3,3}\)-curve has odd index and does not change two-primary index.
- **Still open:** the unordered-theta fibre, hence the original generic
  Abel--Jacobi fourfold, can still have index \(2\).
- **Computationally closed for one fibre:** reduced length \(15\), no
  rank-one point.
- **Pending:** relative null-correlation normal form/dominance.
- **Pending:** exclusion of generic unbalanced and multicomponent strata.
- **Pending but non-load-bearing:** explicit identification of each packet
  line with the Abel ruling, and hence any degree claim for Voisin's further
  quotient \(Z\dashrightarrow M_9\).
- **Novelty:** likely new within the stated search boundary.
