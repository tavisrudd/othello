# C817 toric--octahedral homogeneous geometry

**Lane:** `clebsch`
**Scope:** C817 subitem 3 only; mathematics freeze, with Paper IV read-only

## Verdict

The homogeneous-geometry proposal is positive.  Let
\(G=\PGL(2,13)\) act on the conic \(\mathcal C\) and its \(78\) internal
points.  The four \(G\)-orbits of minimum supports are exactly

1. one octahedral homogeneous space \(G/O\), where \(O\cong S_4\); and
2. three toric homogeneous spaces \(G/N_e\), one for each member of a
   canonical three-set over every chord \(e\), where
   \(N_e\cong D_{24}\) is the split-torus normalizer fixing the unordered
   endpoints of \(e\).

Every stabilizer has order \(24\), so every family has size
\(2184/24=91=\binom{14}{2}\), and every support has size \(12\).

The hidden \(\mathbf F_8\)-module is also identified.  As a
12-dimensional \(\mathbf F_8G\)-module it is, up to Frobenius twist, the
mod-\(2\) reduction of the degree-\(12\) cuspidal representation indexed by
an order-seven character of the nonsplit torus.  Its restriction to the odd
part \(C_7\) of that torus is
\[
 2\,\operatorname{Reg}_{C_7}-\theta-\theta^{-1}.
\]
This is a nonsplit-torus-series identification.  It does not assert modular
Harish--Chandra cuspidality.

## The conic--involution dictionary

Write a conic point as \((t^2:t:1)\), with the usual point at infinity.  An
internal point \(P=(x:y:z)\) determines the fixed-point-free projective
involution
\[
 j_P(t)=\frac{yt-x}{zt-y},
 \qquad
 J_P=\begin{pmatrix}y&-x\\ z&-y\end{pmatrix},
 \qquad J_P^2=(y^2-xz)I.
\]
The seven secants through \(P\) are precisely the seven pairs
\(\{t,j_P(t)\}\).  Thus internal points are equivalently the nonsplit
involutions, and their secants are perfect matchings of
\(\mathcal C(\mathbf F_{13})\).  This makes both homogeneous constructions
coordinate-free after one standard normalization.

## The three toric families

Fix a chord endpoint pair \(e\) and carry it to \(\{0,\infty\}\).  Its
setwise stabilizer is
\[
 N_e=\langle t\mapsto at,\ t\mapsto t^{-1}\rangle,
 \qquad |N_e|=2(13-1)=24.
\]
For an internal point with \(xz\ne0\), the quantity
\[
 r_e(P)=\frac{y^2}{xz}
\]
is unchanged by \(N_e\).  It is independent of the normalizing transporter,
because any two transporters differ by \(N_e\).  The three minimum supports
over \(e\) are
\[
 S_r(e)=
 \left\{(x:1:r^{-1}x^{-1}):x\in\mathbf F_{13}^{\times}\right\},
 \qquad r\in\{2,5,11\}.
\]
Equivalently, \(\{2,5,11\}\) is the intrinsic set
\[
 R=\{r:\chi(r)=-1,\ \chi(r-1)=1\},
\]
where \(\chi\) is the quadratic character.

Each \(S_r(e)\) is the open split-torus orbit on the pencil conic
\[
 \mathcal C_r:\quad y^2=r xz;
\]
more precisely,
\[
 S_r(e)=\mathcal C_r(\mathbf F_{13})\setminus e.
\]
Hence its size is \(14-2=12\).  Its unique conic closure recovers
\(\mathcal C_r\), and the two omitted intersection points with
\(\mathcal C\) recover \(e\).  Consequently its stabilizer inside \(G\) is
exactly \(N_e\), and its global orbit has size \(91\).

### Structural parity proof

A passant line \(L:AX+BY+CZ=0\) has \(A,C\ne0\), since otherwise its
discriminant \(B^2-4AC\) is square or zero.  Its intersections with
\(S_r(e)\) are the nonzero roots of
\[
 A x^2+B x+C/r=0.
\]
An odd intersection could occur only at a double root.  But a double root
would give \(B^2=4AC/r\), and hence
\[
 B^2-4AC=B^2(1-r).
\]
For \(r\in R\), both \(-1\) and \(r-1\) are squares in
\(\mathbf F_{13}\), so \(1-r\) is square.  This contradicts that \(L\) is
passant.  Every passant therefore meets \(S_r(e)\) in zero or two points.
The support lies among the internal points because \((r-1)/r\) is
nonsquare.  This proves the codeword property without syndrome enumeration.

The standard-normal-form check finds all seven \(N_e\)-suborbits:

| \(r_e\) | size | \(\chi(r_e)\) | zero passant syndrome |
|---:|---:|---:|:---:|
| \(0\) | \(6\) | \(0\) | no |
| \(2\) | \(12\) | \(-1\) | yes |
| \(3\) | \(12\) | \(1\) | no |
| \(5\) | \(12\) | \(-1\) | yes |
| \(9\) | \(12\) | \(1\) | no |
| \(11\) | \(12\) | \(-1\) | yes |
| \(12\) | \(12\) | \(1\) | no |

Thus the three toric codeword families are exactly the three nonsquare
pencil levels.

## The octahedral family

Let \(O\cong S_4\) lie in the octahedral class occurring here, intrinsically
distinguished by its conic-point orbits
\[
 \mathcal C(\mathbf F_{13})=A_6\sqcup B_8.
\]
For an internal point \(P\), inspect the perfect matching defined by \(j_P\).
Define
\[
 X_O=\{P:\text{the matching of }P\text{ has exactly two }
              A_6\text{--}B_8\text{ cross-pairs}\}.
\]
Equivalently, its seven pairs consist of two pairs internal to \(A_6\),
three internal to \(B_8\), and two cross-pairs.  Then
\[
 |X_O|=12,\qquad \operatorname{Stab}_G(X_O)=O,
\]
and \(X_O\) is a minimum support.

The finite leaf is only the standard octahedral normal form:
\[
 A_6=\{0,1,2,6,9,\infty\},\qquad
 B_8=\{3,4,5,7,8,10,11,12\}.
\]
The generators
\[
 \begin{pmatrix}1&0\\3&8\end{pmatrix},\qquad
 \begin{pmatrix}1&4\\3&0\end{pmatrix}
\]
have orders \(4\) and \(3\), their product has order \(2\), and their exact
closure has order \(24\).  The six internal-point suborbits have sizes
\[
 6,12,12,12,12,24
\]
and matching profiles
\[
 (3,4),(2,3),(1,2),(1,2),(0,1),(1,2).
\]
The profile \((2,3)\) is unique and its point stabilizer has order \(2\), so
orbit--stabilizer gives size \(12\).  A direct incidence check gives zero
passant syndrome.  Conjugacy proves the construction for every member of
this \(6+8\) octahedral class.  No assertion about other possible rational
conjugacy classes of abstract \(S_4\) subgroups is needed.

## Gram and Frobenius dictionary

With \(A_9=\alpha\), \(A_{10}=\alpha^2\), and
\(A_{12}=\alpha^4\) on the hidden module:

| family | stabilizer | support construction | orbit Gram |
|---|---|---|---|
| octahedral | \(S_4\) | two cross-pairs in \(A_6\sqcup B_8\) | \(A_9=\alpha\) |
| toric \(r=5\) | \(D_{24}\) | \(\mathcal C_5\setminus e\) | \(A_9=\alpha\) |
| toric \(r=2\) | \(D_{24}\) | \(\mathcal C_2\setminus e\) | \(A_{10}=\alpha^2\) |
| toric \(r=11\) | \(D_{24}\) | \(\mathcal C_{11}\setminus e\) | \(A_{12}=\alpha^4\) |

Thus the squaring cycle is the geometric cycle
\[
 r=5\longmapsto2\longmapsto11\longmapsto5
\]
after the named choice \(A_9=\alpha\).  A coordinate-free explanation for
why the octahedral frame repeats the \(r=5\) Gram remains open.

## Nonsplit-torus representation identification

Let \(W=K\) as a 12-dimensional \(\mathbf F_8G\)-module, and let
\(T\cong C_{14}\) be the nonsplit torus fixing an internal point.  For a
chosen generator \(g\) of its odd part \(C_7\), exact diagonalization over
\(\mathbf F_8\) gives the multiplicities of
\(1,\alpha,\ldots,\alpha^6\):
\[
 (2,2,1,2,2,1,2).
\]
The missing inverse pair is \(\{\alpha^2,\alpha^{-2}\}\); changing the
generator or Frobenius-twisting \(W\) permutes the three inverse pairs.
Hence
\[
 W|_{C_7}=2\operatorname{Reg}_{C_7}-\theta-\theta^{-1}.
\]

The other \(2\)-regular types complete the Brauer-character check:

| type | exact eigenvalue data on \(W\) | Brauer value |
|---|---|---:|
| identity | dimension \(12\) | \(12\) |
| split order \(3\) | multiplicities \(4,4,4\) | \(0\) |
| nonsplit order \(7\) | regular twice, less \(\theta^{\pm1}\) | \(-(\theta+\theta^{-1})\) |
| unipotent order \(13\) | each nontrivial 13th root once | \(-1\) |

For order \(13\), the exact check factors \(\Phi_{13}\) over
\(\mathbf F_8\) into three quartics and finds a four-dimensional kernel for
each factor.  These are all \(2\)-regular class types in \(G\).  The values
are exactly the restriction to \(2\)-regular classes of the ordinary
degree-\(12\) cuspidal character attached to \(\theta\).  Since subitem 1
already proves that \(W\) is absolutely irreducible, Brauer--Nesbitt
identifies \(W\) with that reduction, up to Frobenius twist.

The three inverse pairs
\[
 \{\theta^{\pm1}\},\quad
 \{\theta^{\pm2}\},\quad
 \{\theta^{\pm4}\}
\]
form one Frobenius orbit because \(2\) has order \(3\) modulo \(7\); their
residue field is exactly \(\mathbf F_8\).  This explains the observed Schur
field and three Frobenius Gram scalars.

## Background-source check

No novelty or priority claim is made here.  Source depth is zero full-text
papers, two partial published primary papers, and one complete secondary
academic character-table webpage.

- Deligne--Lusztig, *Representations of reductive groups over finite fields*,
  published 1976 version, DOI `10.2307/1971021`: **partial**, cached IAS PDF
  and extracted text, SHA-256
  `8037b883d391a17534f2b5c7a55b9593ad6a3f5c15045ec8751bd1ffced83bdf`.
  The introduction, Theorem 4.2, and Theorem 8.3 were read and used for the
  anisotropic-torus construction, character formula, and cuspidality of the
  characteristic-zero lift.

- Deriziotis--Gotsis, *The Cuspidal Modules of the Finite General Linear
  Groups*, published 1998 version, DOI `10.1112/S1461157000000152`:
  **partial**, cached PDF and extracted text, SHA-256
  `eb5dca0665c41cdf9ee58d5ac5d419c12ff993a3214b6feb93d47189d02c8757`.
  The introduction and opening setup on pp. 75--76 were read and used for the
  Coxeter-torus parametrization, regular-character condition, and degree
  formula.
- J. D. Adams, *Character Table of \(PGL(2,q)\)*: **secondary, full
  webpage** (the complete table page),
  `https://math.umd.edu/~jda/characters/pgl2/`.  The degree-\(q-1\) row was
  used only as a non-load-bearing cross-check of the split, nonsplit, and
  unipotent specialization of the primary Deligne--Lusztig formula.

The exact modular irreducibility and eigenvalue multiplicities are local
computations, not imported from either source.  Before manuscript novelty
positioning, the task-wide original-source and forward-citation audit remains
required.

## Exact evidence and trust boundary

Replay from `rust/`:

```sh
python3 ../notes/2026-08-02-c817-toric-octahedral-geometry.py \
  --check ../notes/2026-08-02-c817-toric-octahedral-geometry.json
```

The deterministic script constructs all \(2184\) projective transformations,
all \(78\) internal points and \(78\) passant lines, and all four minimum-word
orbits.  It checks the complete subgroup suborbit partitions, all
\(\binom{78}{2}\) Gram entries for every family, every standard support
syndrome, and all odd-order module diagnostics.  There is no sampling or
early stop.

The script uses full projective-matrix enumeration, while the subitem-1
evidence independently generates \(G\) by word closure.  The existing
Paper-IV checker independently reconstructs the \(364\) minimum supports and
their stabilizer profiles.  The toric codeword property additionally has the
displayed discriminant proof.  The octahedral uniqueness retains one
irreducibly finite 78-point standard-normal-form leaf; no independent
symbolic classification of its six suborbits is claimed.

Evidence files:

- `notes/2026-08-02-c817-toric-octahedral-geometry.py` — 27427 bytes,
  SHA-256
  `3699f0c6ade546fa2a31faa384836d8b79556fb786b103f5a6221ed00dd1e8dd`;
- `notes/2026-08-02-c817-toric-octahedral-geometry.json` — 8364 bytes,
  SHA-256
  `260311112a66f43c8e396ba1e05b4ad9222b5e54dec97de5e75d5dc0497fc7bc`;
- `notes/2026-08-02-c817-toric-octahedral-geometry.sha256` — 224 bytes.

The JSON is canonical, sorted, deterministic, and checked byte-for-byte by
`--check`.  The adjacent manifest records the same hashes.

## Required closeout passes

### `ej`

The free upgrade is that each toric support is a punctured member of the
conic pencil through the chord endpoints.  This makes the support size and
stabilizer geometric and turns parity into a short discriminant argument.
The same argument incidentally extends to odd \(q\equiv1\pmod4\);
anti-dilution keeps that all-\(q\) observation out of this theorem, and it is
recorded only in the Clebsch discovery track.

### `tt`

The key invariant is the matching, not stored coordinates.  An internal point
is a nonsplit involution, a chord is a split torus, and the relevant
octahedral subgroup canonically cuts the conic points as \(6+8\).  The caution
is exact: the statement identifies a complex cuspidal lift by its restricted
Brauer character; it does not promote \(W\) to a modular
Harish--Chandra-cuspidal module or choose a preferred Frobenius twist.

### `ej2`

The second-order gain is the complete geometry--module dictionary.  The three
nonsquare pencil levels acquire the three Frobenius Gram scalars, and the
same order-seven torus parameter explains both the scalar field
\(\mathbf F_8\) and the three Galois twists.  This closes the conjectural
subitem-1 nonsplit-torus gate.

`aa` was not triggered because the split-normal-form falsifier, octahedral
matching profile, and Brauer comparison all passed.

## Mystery ledger

- **Settled:** the three \(D_{24}\) stabilizers are exactly split-torus
  normalizers, and their supports are the three nonsquare punctured pencil
  conics \(S_2,S_5,S_{11}\).
- **Settled:** the exceptional support is intrinsically the two-cross-pair
  orbit of the octahedral \(6+8\) partition; its stabilizer and size are
  \(S_4\) and \(12\).
- **Settled by `ej`:** support size, exact stabilizer, and code parity have
  structural conic/discriminant proofs.
- **Settled by `tt`:** the constructions are intrinsic to the conic action,
  with coordinate and modular-cuspidality ambiguities delimited.
- **Settled by `ej2`:** the hidden module is the Frobenius packet of
  nonsplit-torus cuspidal reductions, and the three toric families carry the
  three exact Gram conjugates.
- **Open conceptual gap:** the octahedral frame and \(r=5\) toric frame both
  have Gram \(A_9\).  Schur-field scalarity and exact pair counts prove
  equality, but no canonical correspondence between the nonconjugate
  homogeneous spaces \(G/S_4\) and \(G/D_{24}\) explains it.
- **Open novelty gate:** no publication novelty is asserted.  Any integration
  still requires the task-wide original-source and forward-citation audit.
- **Next owning gate:** C817 subitem 4, intrinsic recovery of the conic action
  from the \(14\) Sylow-\(13\) subgroups of the reconstructed group.

No Paper-IV manuscript or release file was changed.
