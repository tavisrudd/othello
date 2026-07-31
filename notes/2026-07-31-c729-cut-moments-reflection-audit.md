# C729 cut moments and Naimark-reflection audit

**Date:** 2026-07-31  
**Lane:** `golden`  
**Status:** higher-moment and focused literature gates passed; no next-order
enumeration attempted

## Result

The conference-cut distribution has an exact Cauchy--Binet hierarchy, but
conference orthogonality fixes only its unrefined minor energy.  The arithmetic
content begins when the energy is resolved by row--column overlap patterns.
For the two Golden stages this refinement is exceptionally small:

\[
\begin{array}{c|c|c}
\text{stage}&\text{internal squared-minor profile}&\text{ordered halves}\\ \hline
6&(1,6,9,4)&20\\
10&(1,20,134,356,385,144)&180\\
10&(1,20,150,500,625,0)&72.
\end{array}
\]

The two order-ten profiles are exactly the 90 singular and 36 extremal
projective cuts, counted with both orientations.  Thus the determinant split is
already visible in the full internal minor-energy vector, not only in its final
alternating cancellation.

The reflection construction itself is universal and classical at the frame
level.  What is special here is the integral cut selection producing its two
successive coordinate forms.  The first is the order-ten conference matrix;
the second is the two-weight Sylvester operator.  Exact pair moments prove that
both antipodal cut configurations are spherical 3-designs and not spherical
4-designs.  The second stage therefore preserves tightness and design strength
but loses equiangularity.  There is no functorial conference tower yet.

## Cauchy--Binet cut-moment theorem

Let \(C=C^{\mathsf T}\) be a conference matrix of order \(2m\), put
\(q=2m-1\), and for an \(m\)-set \(A\) write

\[
C=\begin{pmatrix}P_A&Q_A\\Q_A^{\mathsf T}&P_{A^c}\end{pmatrix},
\qquad \Delta_A=\det Q_A.
\]

The \(A\)-principal block of \(C^2=qI\) gives

\[
P_A^2+Q_AQ_A^{\mathsf T}=qI_m.
\]

For \(0\le j\le m\), define the internal \(j\)-minor energy

\[
E_j(A)=
\sum_{\substack{I,J\subseteq A\\|I|=|J|=j}}
\det C[I,J]^2.
\]

Principal-minor expansion followed by Cauchy--Binet gives the local identity

\[
\boxed{
\Delta_A^2=\det(qI-P_A^2)
=\sum_{j=0}^m(-1)^jq^{m-j}E_j(A).}
\]

In particular \(E_0=1\), \(E_1=m(m-1)\), and
\(E_m=\det(P_A)^2\).  The formula gives every even cut moment:

\[
\sum_{|A|=m}\Delta_A^{2s}
=\sum_{|A|=m}
\left(\sum_{j=0}^m(-1)^jq^{m-j}E_j(A)\right)^s.
\]

To state exactly where universal information stops, set

\[
M_{j,r}(C)=
\sum_{\substack{|I|=|J|=j\\|I\cap J|=r}}
\det C[I,J]^2.
\]

Ordinary Cauchy--Binet fixes only

\[
\sum_rM_{j,r}(C)=\binom{2m}{j}q^j.
\]

Double counting the halves containing \(I\cup J\) refines the second cut
moment to

\[
\boxed{
\sum_{|A|=m}\Delta_A^2
=\sum_{j=0}^m(-1)^jq^{m-j}
  \sum_r\binom{2m-2j+r}{m-2j+r}M_{j,r}(C).}
\]

For the \(2s\)-th moment, the same argument replaces \(M_{j,r}\) by the
intersection tensor of \(s\) pairs \((I_a,J_a)\), weighted by the number of
halves containing their union.  Hence the next-order computation should record
overlap-resolved minor energies, not merely a determinant histogram.  Paley
arithmetic, switching class, and automorphism orbits can change these refined
tensors even when the unrefined Cauchy--Binet totals agree.

For the order-ten shadow the projective determinant moments are, for every
\(s\ge1\),

\[
\sum_{\{A,A^c\}}|\Delta_A|^{2s}=36\,48^{2s};
\]

this contains no information beyond the already proved binary distribution.
The internal-energy profiles above are the first useful refinement.

## `ej3`: every extremal half borders back to order six

The two order-ten energy profiles have a stronger spectral meaning.  Since
\(E_j(A)=e_j(P_A^2)\), their characteristic polynomials factor as

\[
\begin{aligned}
\chi_{P_A^2}(t)
&=(t-9)(t-1)^2(t^2-9t+16)
&&\text{for the 90 singular projective cuts},\\
\chi_{P_A^2}(t)
&=t(t-5)^4
&&\text{for the 36 extremal projective cuts}.
\end{aligned}
\]

For an extremal cut, let \(u\) be a unit kernel vector of \(P_A\).  The
second factorization gives

\[
P_A^2=5(I-uu^{\mathsf T}).
\]

Every diagonal entry of \(P_A^2\) is four.  Hence \(u_i^2=1/5\) for all
five coordinates, so \(v=\sqrt5u\) is a sign vector and

\[
P_Av=0,
\qquad
P_A^2=5I-vv^{\mathsf T}.
\]

It follows that the bordered matrix

\[
\widehat P_A=
\begin{pmatrix}
P_A&v\\v^{\mathsf T}&0
\end{pmatrix}
\]

is a symmetric order-six conference matrix:

\[
\widehat P_A^2=5I_6.
\]

The kernel line fixes \(v\) up to sign; the two borders differ by switching
the added vertex.  Thus the completion is canonical at the switching-class
level.

Conversely, if a five-vertex principal half \(P_A\) admits such a sign
border, then

\[
Q_AQ_A^{\mathsf T}=9I-P_A^2=4I+vv^{\mathsf T},
\]

whose eigenvalues are \(9,4,4,4,4\).  Therefore
\(|\det Q_A|=48\).  For the Golden order-ten shadow this proves the intrinsic
equivalence

\[
\boxed{
\text{extremal balanced cut}
\iff
\text{its principal half borders to an order-six conference matrix}.}
\]

Thus every one of the 36 Sylvester vertices carries a local order-six
conference completion.  This is stronger than saying that the two stages
share a Naimark-reflection mechanism: the second stage contains 36 marked
local retractions back to the first conference order.  The theorem does not
by itself identify which marking quotient, if any, recovers the six original
Golden sisters.

## Exact higher moments of the two cut frames

Let \(Y_1\) be the antipodal double of the ten normalized balanced
\(3+3\) cut lines in the five-dimensional augmentation module.  Let \(Y_2\)
be the antipodal double of the 36 normalized extremal \(5+5\) cut lines in
the nine-dimensional augmentation module.  For a fixed member \(y\), their
pair moments are

\[
\frac1{|Y_1|}\sum_{z\in Y_1}\langle y,z\rangle^{2s}
=\frac{1+9\cdot3^{-2s}}{10},
\]

and

\[
\frac1{|Y_2|}\sum_{z\in Y_2}\langle y,z\rangle^{2s}
=\frac{1+5(3/5)^{2s}+30(1/5)^{2s}}{36}.
\]

All odd moments vanish by antipodality.  At degree two the values are
\(1/5\) and \(1/9\), as tightness requires.  At degree four they are
\(1/9\) and \(53/1125\), whereas the spherical values are respectively
\(3/35\) and \(1/33\).  Thus each antipodal configuration has spherical
design strength exactly three.  The full certificate records moments through
degree eight.

## Reflection theorem and hierarchy audit

Let \(x_1,\ldots,x_N\in\mathbb R^d\) have common squared norm \(r\), let
\(X\) have these vectors as columns, and suppose

\[
XX^{\mathsf T}=\frac{Nr}{d}I_d.
\]

With \(G=X^{\mathsf T}X\),

\[
P=\frac d{Nr}G,
\qquad
\mathcal R=2P-I_N
\]

are respectively a constant-diagonal projection and its Naimark reflection.
In particular

\[
\mathcal R^2=I_N,
\qquad
\mathcal R_{ii}=\frac{2d}{N}-1.
\]

This proves a genuine common mechanism but not an iteration rule.  Naimark
complementation keeps \(N\) fixed and exchanges dimensions \(d\) and
\(N-d\); it does not select a new integral frame.  The Golden chain uses two
different additional selections:

1. all ten balanced cuts of a six-set, producing \((d,N)=(5,10)\) and
   diagonal zero;
2. the 36 maximum cross-determinant cuts of the order-ten conference matrix,
   producing \((d,N)=(9,36)\) and diagonal \(-1/2\).

After primitive integral scaling these reflections are

\[
S_{10}^2=9I,
\quad |(S_{10})_{ij}|=1,
\]

and

\[
H_{36}^2=100I,
\quad (H_{36})_{ii}=-5,
\quad |(H_{36})_{ij}|\in\{1,3\}.
\]

The first is a conference matrix because redundancy is two.  The second is
the primitive-idempotent reflection of the Sylvester \(-3\)-eigenspace.  Its
quadratic law follows formally from idempotency; its special content is the
integral two-weight realization by extremal conference cuts and its full
\(\operatorname{Aut}(S_6)\)-equivariance.

This also settles the roux question.  Roux lines are equiangular tight frames.
The 36 lines are biangular, with angle multiplicities \(5\) and \(30\), so the
weighted operator is not a roux signature matrix in the standard sense.  It
does lie in the Bose--Mesner algebra of the Sylvester distance scheme.

## Focused literature audit

One of the nine individually discussed sources below was read at full text.
The remaining sources carry explicit partial or metadata-only depth markers.
The audit supports terminology and boundary claims, not an unrestricted
priority claim.

### Verdict

- **Standard/pre-empted:** a unit-norm tight-frame Gram matrix is a scaled
  constant-diagonal projection; Naimark complementation is complementary
  projection; equiangular redundancy-two frames are conference matrices.
- **Standard/pre-empted:** constant-diagonal orthogonal matrices with one
  off-diagonal magnitude were studied directly by Seberry--Lam.  The phrase
  “Naimark-reflection hierarchy” must therefore name this paper's selected
  integral cut chain, not the general reflection normalization.
- **Adjacent prior iteration:** Et-Taoui iterates a Hadamard block construction
  to infinite families of complex ETFs whose redundancies tend to two.  This
  rules out any claim that the Golden construction is the first iterative
  conference/ETF mechanism.
- **Standard:** biangular tight frames and their forced angle
  equidistribution, primitive-idempotent spherical embeddings, and moment
  criteria for spherical designs all have established frameworks.
- **Not a roux instance:** Iverson--Mixon's roux lines are equiangular; the
  Golden 36-line frame is biangular.
- **Bounded negative:** no source in this audit gave the specific chain from
  the ten balanced-cut ETF through the 36 extremal order-ten conference cuts
  to the integral Sylvester weights \(1,3\), nor the two internal minor-energy
  profiles.  Manuscript language should remain “in this construction” or “we
  obtain,” not “first” or “new,” until the coverage gaps below are closed.

### Sources and read depth

- B. Et-Taoui, *Complex conference matrices, complex Hadamard matrices and
  complex equiangular tight frames*, arXiv:1409.5720v1. **Read depth: full
  text**, cached as `arXiv:1409.5720`, SHA-256
  `eb45c19abf8fb8ea10c4263c9659e1af9b80050899c38085cf8ed846e582ca66`.
- M. Appleby, I. Bengtsson, S. Flammia, D. Goyeneche, *Tight Frames,
  Hadamard Matrices and Zauner's Conjecture*, arXiv:1903.06721. **Read depth:
  partial**, cached as `arXiv:1903.06721`, SHA-256
  `ef806c2b1f5e60f87ce98f31115001332cb82f1c615c69a599916188f0c8de0d`;
  read Section 2's Gram/projector and Naimark-complement discussion.
- J. Giol, L. V. Kovalev, D. Larson, N. Nguyen, J. E. Tener, *Projections and
  idempotents with fixed diagonal and the homotopy problem for unit tight
  frames*, arXiv:0906.0139v2. **Read depth: partial**, cached as
  `arXiv:0906.0139`, SHA-256
  `b04fc623b7b3290509c17fe603c95e1008c47f7e1c379aab5ce899030cbad6ac`;
  read the abstract and Section 1.
- J. I. Haas, J. Cahill, J. Tremain, P. G. Casazza, *Constructions of
  biangular tight frames and their relationships with equiangular tight
  frames*, arXiv:1703.01786. **Read depth: partial**, cached as
  `arXiv:1703.01786`, SHA-256
  `fce8d21d26ca978237bcb111ec5296eb73dd7f07dc5bbbba761e6608b0fbaebf`;
  read Sections 1--2.
- S. Suda, *On spherical designs obtained from Q-polynomial association
  schemes*, arXiv:0910.4628v1. **Read depth: partial**, cached as
  `arXiv:0910.4628`, SHA-256
  `ce63862aa96cb1fd741b8b4ae34cc1425809b7ec5e10b768ca53b53bf9692117`;
  read Sections 1--2 through Lemma 2.1.
- J. W. Iverson, D. G. Mixon, *Doubly transitive lines I: Higman pairs and
  roux*, arXiv:1806.09037. **Read depth: partial**, cached as
  `arXiv:1806.09037`, SHA-256
  `a2b98c480fafc98617b5789eba3291ff427805e611bb5c1364eb14b7b029867a`;
  read Definition 1.4 and Corollary 1.5 with their surrounding discussion.
- R. P. Brent, J.-A. H. Osborn, *On minors of maximal determinant matrices*,
  arXiv:1208.3819v3. **Read depth: partial**, cached as `arXiv:1208.3819`,
  SHA-256
  `751057c5ff1399601482135568c471ee9c5bbd7f87c067363088d2505a3811a9`;
  read the abstract, introduction, opening of Section 2, Proposition 3, and
  Remark 5.  Its minors are unrestricted submatrices, not complementary
  conference cuts; Remark 5 is nevertheless relevant evidence that higher
  minor distributions can depend on equivalence class.
- M. R. Alfuraidan, J. I. Hall, *Imprimitive distance-transitive graphs with
  primitive core of diameter at least 3*. **Read depth: partial**, cached as
  DOI `10.1307/mmj/1242071683`, SHA-256
  `303e6f86d31e86a3f4a7c170e77141e1598c1819e3ac84f699d2e5783c450e90`;
  read Section 5.8.2, which records the Sylvester outer-involution model,
  commuting adjacency, and intersection array.
- J. Seberry, C. W. H. Lam, *On orthogonal matrices with constant diagonal*,
  DOI `10.1016/0024-3795(82)90031-3`. **Read depth: abstract/metadata only**,
  from the publisher record and zbMATH Open.  The attempted open PDF fetch
  failed TLS certificate validation and was not cached.

### Search record and coverage

The bounded web screen used the first result page returned for nineteen exact
queries over title/abstract/metadata fields.  The load-bearing queries were:

```text
conference matrix complementary minors determinant cuts maximal minors
Naimark complement constant diagonal reflection tight frame Gram projection
biangular tight frames roux weighted adjacency quadratic relation
conference matrix principal minors Cauchy Binet
equiangular tight frame signature matrix quadratic equation conference matrix
finite unit norm tight frame Gram projection constant diagonal Naimark complement
roux lines equiangular tight frames association schemes
Sylvester graph tight frame eigenspace
association scheme primitive idempotent spherical embedding design moments
distance regular graph primitive idempotent spherical embedding tight frame higher moments
biangular tight frame 36 lines dimension 9 Sylvester graph
constant diagonal Naimark reflection tight frame
2P-I tight frame reflection Gram matrix
constant diagonal projection unit norm tight frame
weighted conference matrix tight frame quadratic
zbMATH constant diagonal projection tight frame conference
zbMATH conference matrix minors maximal determinant
zbMATH biangular tight frame association scheme
zbMATH Naimark complement conference matrix
```

The discriminator was: retain work defining the frame/projection/reflection
normalization, conference/ETF equivalence, BTF or roux boundary, Sylvester
primitive-idempotent embedding, or determinant-minor distribution; reject
unrelated uses of “conference,” generic determinantal ideals, numerical matrix
algorithms, and application papers merely invoking Cauchy--Binet.  All returned
hits were screened; the search service did not expose total database hit counts.
Promoted sources are listed above.

zbMATH Open was covered through the four exact searches above.  MathSciNet was
not covered because institutional authentication was unavailable.  Google
Scholar was not covered because automated access is blocked.  No citation-graph
exhaustion or forward-citation closure was attempted, so the three-graph rule is
not triggered and no priority conclusion is licensed.

## Reproducibility

From `/home/tavis/src/othello`:

```sh
python3 notes/2026-07-31-c729-cut-moments.py --check
python3 notes/2026-07-31-c729-cut-moments-replay.py
```

The generator uses exact integer Bareiss determinants.  It reconstructs the
order-ten conference matrix from all balanced six-set cuts, exhausts the 10 and
126 projective balanced cuts at orders six and ten, verifies the local and
overlap-resolved Cauchy--Binet identities, constructs both tight frames and
their primitive integral reflections, and records moments through degree eight.
The replay starts instead from the displayed Paley order-ten matrix, uses a
Leibniz determinant, and independently checks the 126-cut distribution, the
36-line angle counts, tight-frame operator, and moment sequence.  It does not
classify higher conference orders or prove stability.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-31-c729-cut-moments.py` | 12524 | `4ffc912742cc752bbb99ce93301d26e3466be066b8a38a21c2edb9f8d2ff3d92` |
| `notes/2026-07-31-c729-cut-moments-replay.py` | 3538 | `d6c24973b8f60aad6fce29181c73e3abbff811df560377ed120ca01114f345cb` |
| `notes/2026-07-31-c729-cut-moments.json` | 3142 | `fd6b21929b26129736eaf3ac3f45a22f7d08b877c110a78ccb04d25dc3b6fca5` |

## Next gate

Use the overlap tensors to choose one next feasible symmetric conference
switching class and compute orbit-resolved profiles.  The theorem-level datum is
whether two inequivalent classes with the same unrefined Cauchy--Binet totals
have different overlap profiles.  Stability should wait until that comparison
shows which profile coordinates are discriminating.

## `ej` + `tt` closeout and mystery ledger

- **Settled by `tt`:** the moment theorem now separates universal
  Cauchy--Binet energy from overlap-resolved arithmetic; a determinant table is
  no longer allowed to stand in for the latter.
- **Settled by `ej`:** the two order-ten determinant values lift to exactly two
  complete internal minor-energy profiles.
- **Settled by `ej`:** both antipodal cut frames have exact spherical design
  strength three and fail at degree four; tightness survives without a gain in
  higher design strength.
- **Settled by `ej3`:** every extremal order-ten principal half has spectrum
  \(P_A^2\sim\{0,5,5,5,5\}\), a sign kernel vector, and a border to a
  symmetric order-six conference matrix canonical up to switching the added
  vertex.  Conversely such a border forces the D-optimal cross determinant
  \(48\).
- **Settled by the literature audit:** the general constant-diagonal reflection
  and conference/ETF normalization are classical, and Et-Taoui already has a
  different infinite conference/ETF iteration.
- **Settled by the literature audit:** the two-weight 36-line system is not a
  roux instance under the standard definition.
- **Open:** whether the Golden extremal-cut selection extends to another order
  with an integral few-weight frame.  Evidence gap: no next-order orbit profile
  has yet been computed; owner: the next C729 computational gate.
- **Open:** whether the overlap-resolved tensors distinguish conference
  switching classes.  Evidence gap: the current certificate covers the unique
  order-ten class only; owner: the next C729 computational gate.
- **Open:** unrestricted novelty of the exact integral Sylvester cut chain.
  Evidence gap: MathSciNet, Google Scholar, and citation-graph closure are not
  covered; no priority language is licensed.
- **Open:** determine the marking quotient from the 36 bordered local
  order-six completions to the six Golden sisters.  The present theorem gives
  the completions and their common switching class, but not a canonical
  six-fibre map.
