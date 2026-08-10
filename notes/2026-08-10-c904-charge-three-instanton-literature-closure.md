# C904 charge-three instanton / generic-fibre literature closure

Date: 2026-08-10
Status: quarantined Paper V research; no manuscript or Lean edits
Scope: charge-three rank-two instantons on a cubic threefold, Voisin's
degree-six model, elementary modifications along a line, and the birational
type or index of the generic four-dimensional fibre over the intermediate
Jacobian

## Executive verdict

This bounded audit used **zero papers read in full and six primary papers read
claim-specifically at partial depth**.  The load-bearing statements below come
from the complete relevant theorem and proof sections, not from abstracts.
The negative is additionally checked against the largest of three independent
forward-citation sets for each of the two seed papers.

There is one exact pre-emption.  The elementary modification

\[
  0\longrightarrow G\longrightarrow E\longrightarrow \mathcal O_L
  \longrightarrow0
\]

from a charge-\(k\) instanton and a general line is Faenzi's induction step.
For an index-two Fano threefold he proves that \(G\) is a stable instantonic
sheaf of charge \(k+1\), is unobstructed, and deforms to locally free
instantons.  The modification locus has dimension \(4k\), while the component
of charge-\(k+1\) instantons has dimension \(4k+1\).  At \(k=2\), it is
therefore an eight-dimensional boundary divisor in a nine-dimensional
charge-three component.  Comaschi--Jardim later recast and extend this
elementary-transformation mechanism; they explicitly credit Faenzi for the
index-two construction.

What is **not** pre-empted is the Abel--Jacobi arithmetic of that divisor.
No located source computes its map to the intermediate Jacobian, its
intersection degrees in a proper model of Voisin's generic fourfold, or the
index of that generic fourfold.  No located source proves that the generic
fourfold is rational, stably rational, or has a zero-cycle of odd degree.

The strongest clean unpre-empted target is therefore:

> Let \(K=\mathbf C(J(Y))\), and let \(V/K\) be a smooth proper model of the
> generic fibre of the Abel--Jacobi/MRC map from the relevant charge-three
> instanton component.  Prove that \(V\) has odd index (stronger: index one;
> stronger still: \(V\) is stably \(K\)-rational; strongest: \(V\) is
> \(K\)-rational), by identifying the Faenzi
> elementary-modification boundary over \(J(Y)\) and computing an odd
> zero-dimensional intersection on it.

The raw Hecke construction is not enough.  It gives a relative divisor: even
if it dominates \(J(Y)\), its generic fibre has dimension three inside a
fourfold.  Three additional relative cuts and their degrees must be computed.
That parity computation, not the existence of the modification, is the new
gate.

## 1. Exact Voisin boundary

Voisin's Theorem 2.1 proves that, for a general cubic threefold \(Y\), the
Abel--Jacobi map from the 12-dimensional family \(M_{6,1}\) of nondegenerate
elliptic sextics to \(J(Y)\) is surjective with rationally connected general
fibre.  A general sextic gives a stable rank-two bundle \(A\) with

\[
  c_1(A)=2h,\qquad \deg c_2(A)=6,\qquad h^0(A)=4.
\]

Writing \(M_9\) for the resulting nine-dimensional moduli space, she constructs
a dominant rational map \(M_{6,1}\dashrightarrow M_9\) with general fibre
\(\mathbf P^3\).  Twisting by \(\mathcal O_Y(-1)\) gives
\(c_1=0,c_2=3l\), and the Serre sequence gives the instanton vanishing
\(H^1(A(-2))=0\).  Thus this is a charge-three instanton component.

It follows from Voisin's theorem (this is the present audit's inference) that
the induced rational map from the relevant component of \(M_9\) to \(J(Y)\)
has geometrically rationally connected generic fibre of dimension four.
Voisin does not describe its birational type, construct a projective-bundle
model, or calculate its index.

One normalization trap matters.  Voisin's divisor \(D_{5,1}\) of reducible
sextics \(C_5\cup L\) is **not** the Faenzi elementary-modification divisor in
\(M_9\).  Voisin says explicitly that \(L\) is a base component of the relevant
linear system and that the vector-bundle construction fails on \(D_{5,1}\).
Her linked divisor \(D'_{5,1}\) instead parametrizes smooth sextics admitting a
trisecant line; its associated locally free bundles are special because their
restriction to that line is
\(\mathcal O_L(3)\oplus\mathcal O_L(-1)\), hence they are not globally
generated.  This is a different divisor from Faenzi's non-locally-free kernels.

## 2. Exact Faenzi pre-emption

Faenzi's Theorem 3.1 gives, for every index-two Fano threefold and every
\(k\ge2\), a generically smooth component of \(k\)-instantons of dimension
\(4k-3\).  In Steps 2--3 of the proof he chooses a general line with
\(E|_L\simeq\mathcal O_L^2\), a quotient \(E\twoheadrightarrow\mathcal O_L\),
and its kernel \(G\).  He proves

\[
 c_1(G)=0,\quad c_2(G)=k+1,\quad c_3(G)=0,
 \quad H^i(G(-1))=0,
 \quad \operatorname {Ext}^2(G,G)=0,
\]

and then proves that a general deformation of \(G\) is locally free.  The
families fitting into this exact sequence have dimension

\[
  (4k-3)+2+1=4k,
\]

whereas the ambient charge-\(k+1\) component has dimension \(4k+1\).

Consequences for the proposed Paper V route:

1. claiming a new charge-two/charge-three line Hecke construction is untenable;
2. claiming a new nine-dimensional charge-three component is untenable;
3. the possible novelty begins only after compatibility with the
   Abel--Jacobi map and an exact degree/index computation;
4. because Faenzi constructs a boundary of torsion-free sheaves, the index
   theorem must be formulated on a chosen proper component/compactification,
   not merely on Voisin's open moduli of bundles.

The audit does not identify Faenzi's component with Voisin's component as a
printed theorem.  They have the same expected dimension and Voisin's general
bundle is a charge-three instanton, but a manuscript-bound identification
requires a geometric intersection or uniqueness proof.

## 3. Later work checked

Comaschi--Jardim prove generally that rank-two non-locally-free instanton
sheaves arise as elementary transformations of instanton bundles along
rank-zero instantons under their hypotheses, and their Theorem 29 repeats the
line induction mechanism.  They do not compute the cubic-threefold
charge-three Abel--Jacobi fibre or its index.

Kuznetsov develops instantons on all index-two Fano threefolds but treats the
degree-three case only as a future direction; his detailed moduli descriptions
are for degrees five and four.  Liu--Zhang treat the minimal charge-two class on
the cubic threefold and its \(V_{14}\) partner.  Ma--Yang study a different
rank-four Chern character and an eight-dimensional moduli space.  None of
these computes Voisin's generic fourfold.

## 4. Source depths

- **Claim-specific partial:** Claire Voisin, *Abel--Jacobi map, integral Hodge
  classes and decomposition of the diagonal*, arXiv:1005.5621, especially
  Theorem 2.1 and its proof through the construction of \(M_9\), Lemmas
  2.4--2.6, and Remark 2.8.  Preprint version read from cache key
  `arXiv:1005.5621`, SHA-256
  `ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547`.
  The published JAG version was not separately read.

- **Claim-specific partial:** Daniele Faenzi, *Even and odd instanton bundles
  on Fano threefolds of Picard number one*, arXiv:1109.3858v2, introduction
  and complete Section 3.1, especially Theorem 3.1 and Steps 2--3.  Cache key
  `arXiv:1109.3858`, SHA-256
  `0024a632f2ca141eb4f3c09c43c65a3464646fd72fd951417abb2a3a9db90e8f`.
  The published version was not separately read.

- **Claim-specific partial:** Gaia Comaschi and Marcos Jardim, *Instanton
  sheaves on Fano threefolds*, arXiv:2208.03210v1, introduction, elementary
  transformations in Section 4, and Theorem 29 with proof.  Cache key
  `arXiv:2208.03210`, SHA-256
  `fa0922a010c635f547c8e00c224182d405d039881fd3a503fdcf6f0a2e57eb15`.

- **Claim-specific partial:** Alexander Kuznetsov, *Instanton bundles on Fano
  threefolds*, arXiv:1203.3975v1, introduction, Section 3, and Section 6.1.
  Cache key `arXiv:1203.3975`, SHA-256
  `8085ae335da122394e3b0c935ec21dabae8cd20ee2393b72fea739724ba7c478`.

- **Claim-specific partial:** Zhiyu Liu and Shizhuo Zhang, *A note on
  Bridgeland moduli spaces and moduli spaces of sheaves on \(X_{14}\) and
  \(Y_3\)*, arXiv:2106.01961v2, introduction and all occurrences of the cubic
  instanton/sheaf classes.  Cache key `arXiv:2106.01961`, SHA-256
  `0cb659ad18cbe73d7807e2a673301169f91b6b3df9180be8faf6b6a7cce00f31`.

- **Claim-specific partial:** Shihao Ma and Song Yang, *A Moduli Space of
  Stable Sheaves on a Cubic Threefold*, arXiv:2406.10104v2, introduction and
  all occurrences of the relevant Chern characters and Abel--Jacobi geometry.
  Cache key `arXiv:2406.10104`, SHA-256
  `a4c9070cb7f2e7037728c6b54b2d7c6b2b0230dff4249d69a34b80eb8177aee8`.

## 5. Search boundary and forward closure

### Exact arXiv API searches

The following queries were run against `export.arxiv.org` over title, abstract,
author and comment metadata on 2026-08-10:

```text
all:"charge 3" AND all:"cubic threefold"                       -> 0
all:"cubic threefold" AND all:instantons AND all:moduli        -> 3
all:"cubic threefold" AND all:"rank 2" AND all:Chern           -> 4
all:"degree 6" AND all:"cubic threefold" AND all:"Abel-Jacobi" -> 0
all:"elliptic sextic" AND all:cubic                            -> 0
```

The three instanton/moduli hits were screened by title and abstract; they were
Lahoz--Macri--Stellari on ACM/minimal instantons, Liu--Zhang, and a Clifford
algebra/Prym paper.  The four rank/Chern hits were the two classical
charge-two Abel--Jacobi papers plus two false positives.  Empty result sets
were valid Atom responses with `<opensearch:totalResults>0</...>`, not request
errors.

### Forward citations

The seeds were pinned by DOI and independently resolved in all three graphs:

| Seed | OpenAlex | Crossref | Semantic Scholar |
|---|---:|---:|---:|
| Voisin, DOI `10.1090/S1056-3911-2012-00597-9` | 47 | 28 | 54 |
| Faenzi, DOI `10.1007/s00229-013-0646-6` | 57 | 36 | 59 |

For each seed, the largest set was Semantic Scholar.  All 54 and 59 records,
respectively, were screened over `title`, `abstract`, `year`, and external
identifiers.  The mechanical discriminator for the Voisin set was

```text
cubic threefold|Abel.Jacobi|instant|elliptic sext|degree 6|vector bundle|M_?9
```

and for the Faenzi set was

```text
cubic threefold|Abel.Jacobi|charge 3|charge three|c2.?=.?3|c_2.?=.?3|
elliptic sext|degree 6|M_?9
```

Promoted matches were then manually read at abstract/metadata depth.  The
Voisin matches concern universal cycles, charge-two matrix factorizations, or
other cubic-threefold geometry; the Faenzi matches concern other Fano
threefolds.  None advertises a charge-three cubic Abel--Jacobi fibre,
rationality, or index computation.  HTTP 200 responses and returned array
lengths distinguished complete responses from errors.

### Coverage gaps

MathSciNet and Google Scholar were not covered.  No absence claim here is
global: the correct wording remains "no source was located in this bounded
audit."  The published versions of the six papers above were not all read
separately from the cached preprints.

## 6. The theorem ladder that survives

From weakest/sufficient to strongest:

1. construct an odd-degree zero-cycle on a smooth proper model of the generic
   fourfold over \(\mathbf C(J(Y))\);
2. prove its index is one;
3. give a rational section after an explicitly controlled odd-degree base
   change;
4. prove stable rationality or rationality of the generic fourfold;
5. identify the Faenzi boundary over \(J(Y)\) and compute its complete
   intersection form, making (1) canonical and equivariant in families.

For the relative-cycle application, (1) is the mathematically sufficient and
apparently un-pre-empted claim.  The likely Annals-level version is (5) plus
an exact index theorem, especially if it explains why the adjacent
charge-two gerbe is two-primary while the charge-three generic fibre acquires
an odd carrier.
