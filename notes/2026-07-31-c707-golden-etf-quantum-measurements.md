# C707 — golden ETF quantum measurements

**Lane:** clebsch

**Date:** 2026-07-31

## Verdict

The two golden eigenspaces give a genuine pair of Naimark-complementary
six-outcome real-qutrit equiangular measurements.  Each measurement is
minimally informationally complete for real density matrices, with exact
linear reconstruction
\[
 \rho=\frac52\sum_i p_i\Pi_i-\frac12I_3,
\]
but neither is informationally complete for complex qutrits and neither is
a qutrit SIC.

The operator tower has a precise operational meaning.  In the common
six-path Naimark dilation, the C704 cross-golden block is a postselected
qutrit transfer operator
\[
 K_T(x)=Q_{T,-}^{\mathsf T}\operatorname{diag}(x)Q_{T,+}.
\]
On three antisymmetrized copies,
\[
 \det(K_T^{\mathsf T}K_T)=\frac{Z_T(x)^2}{500}.
\]
Thus \(Z_T\) is an oriented transition-volume amplitude, \(A=dZ\) is its
control response, and the C704/C705 polar vector \(W\) is exactly a centered
contrast of six three-copy success probabilities.  Inverse polarity
recovers the projective signed amplitude vector from these contrasts away
from \(e_5=0\).

There is also a sharp structural physical bound:
\[
 |Z_T(x)|\le8,\qquad p_T^{(3)}(x)\le\frac{16}{125}
 \quad(\|x\|_\infty\le1),
\]
with equality exactly at the twenty balanced \(3+3\) phase vertices.
These controls maximize all six outer protocols simultaneously.  Their six
oriented amplitude signs are the twenty signed representatives of the ten
Segre nodes, paired by complementary controls; after squaring, every
optimal probability vector is constant.  Thus \(W=0\) and \(e_5(Z)=0\) at
every optimum: maximum success is exactly where probability contrast and
inverse polarity lose the orientation data.
On this same twenty-point layer, the signed amplitude map is the exceptional
outer transform: it preserves complementary triples and exchanges the two
Johnson relations \(|S\cap R|=1\) and \(|S\cap R|=2\).  Its input and output
sign matrices are orthogonal simplex frames, and together with their
pointwise products they realize the full \(1+5+5+9\) harmonic decomposition
of functions on the twenty triples.
The transform is cubic in both directions and correlation-immune through
order two: one amplitude sign is independent of every chosen pair of path
signs, while the first nonzero mixed moments are cubic and equal
\(\pm2/5\).

At the optimum this is also literal free-fermion physics.  The balanced
mask is a lossless six-mode phase unitary, and \(16/125\) is a three-fermion
Slater-determinant scattering probability.  The commutator
\([D_x,C_T]\) is simultaneously a signed \(K_{3,3}\) six-Majorana
Hamiltonian with positive energies \(\{2,4,4\}\) and Pfaffian
\(4Z_T=\pm32\); its class-D ground-state-parity signs are precisely the six
outer amplitude signs.
At every optimum,
\[
 \operatorname{spec}(K_T^{\mathsf T}K_T)=\{4/5,4/5,1/5\}.
\]
The three-filter realization is query-optimal among coherent circuits with
\(x\)-independent gates and ancillas.

## Literature finding first

This was a bounded positioning sweep, not a novelty audit, and makes no
priority or absence claim.  Zero sources were read at full text; six primary
sources were read partially at the sections stated below, and one recent
primary source was available only at abstract/metadata depth.

1. Marcus Appleby, Ingemar Bengtsson, Steven Flammia, and Dardo Goyeneche,
   *Tight Frames, Hadamard Matrices and Zauner's Conjecture*.
   **Read depth:** partial, arXiv v2, Sections 2--3 and the Naimark-complement
   discussion.  These sections state the tight-frame/rank-one-POVM
   normalization, give the six icosahedral axes as the basic real
   \((6,3)\) ETF, and state the Gram-matrix Naimark-complement formula.
   Cache key arXiv:1903.06721, SHA-256
   ef806c2b1f5e60f87ce98f31115001332cb82f1c615c69a599916188f0c8de0d.
   Source: https://arxiv.org/abs/1903.06721.

2. Boumediene Et-Taoui, *Complex conference matrices, complex Hadamard
   matrices and equiangular tight frames*.  **Read depth:** partial,
   current cached arXiv PDF, introduction and Section 1.  These passages
   supply the standard conference/Seidel-matrix-to-\((2k,k)\)-ETF
   construction and the Gram-projector normalization.
   Cache key arXiv:1409.5720, SHA-256
   eb45c19abf8fb8ea10c4263c9659e1af9b80050899c38085cf8ed846e582ca66.
   Source: https://arxiv.org/abs/1409.5720.

3. Joseph M. Renes, Robin Blume-Kohout, A. J. Scott, and Carlton M. Caves,
   *Symmetric Informationally Complete Quantum Measurements*.
   **Read depth:** partial, current cached arXiv PDF, introduction and
   Section 2.  It fixes the complex SIC convention: \(d^2\) rank-one
   outcomes, squared overlap \(1/(d+1)\), and tight-frame/POVM equivalence.
   This is the source for keeping the six-outcome real measurement distinct
   from a complex qutrit SIC.
   Cache key arXiv:quant-ph/0310075, SHA-256
   336013ee0807018733d921f08811208092752d3d2a7ff517142ee495b0b9ca85.
   Source: https://arxiv.org/abs/quant-ph/0310075.

4. Zhihua Guo, Yan Liu, Tsung-Lin Lee, and Shunlong Luo,
   *Construction and classification of all equioverlapping measurements in
   qubit and qutrit systems*.  **Read depth:** abstract/metadata only from
   the official APS page; the full text required authorization and was not
   covered.  The abstract confirms that equiangular/equioverlapping qutrit
   measurements are an active classified setting, but licenses no claim
   about the paper's internal classification or the golden determinant
   protocol.  DOI 10.1103/PhysRevA.111.012430.
   Source: https://journals.aps.org/pra/abstract/10.1103/PhysRevA.111.012430.

5. Yuval Filmus and Elchanan Mossel, *Harmonicity and invariance on slices
   of the Boolean cube*.  **Read depth:** partial, arXiv version, Sections
   3.1--3.2 and 9.1.  The canonical harmonic representation, its orthogonal
   homogeneous pieces, and
   \(\dim H_d=\binom nd-\binom n{d-1}\) supply the classical
   \(1+5+9+5\) decomposition of functions on the \((6,3)\) slice.  C707's
   new input is not that decomposition, but the identification of its two
   five-spaces with path signs and cubic outer-amplitude signs.  Cache key
   arXiv:1507.02713, SHA-256
   05e249d4ef881fb30d21d88eca85e61c2fd2b9207cbd7c320cc8af2ffd3c6586.
   Source: https://arxiv.org/abs/1507.02713.

6. Barbara M. Terhal and David P. DiVincenzo, *Classical simulation of
   noninteracting-fermion quantum circuits*.  **Read depth:** partial,
   arXiv version, the number-preserving transition-amplitude derivation in
   Section II.  Equation (18) derives a many-fermion transition amplitude as
   the determinant of the selected one-particle block; this is the standard
   physical mechanism used by the C707 Slater protocol.  Cache key
   arXiv:quant-ph/0108010, SHA-256
   71a6c85976f3697a24eb6c32219e6322915f4e2684cd772b25f4f67c3edb271a.
   Source: https://arxiv.org/abs/quant-ph/0108010.

7. A. Grabsch, Y. Cheipesh, and C. W. J. Beenakker, *Pfaffian formula for
   fermion parity fluctuations in a superconductor and application to
   Majorana fusion detection*.  **Read depth:** partial, arXiv version,
   Section 2.2.  It states Kitaev's formula equating the ground-state parity
   of a closed quadratic Majorana system with the Hamiltonian Pfaffian sign.
   This supplies the standard class-D interpretation; C707 supplies the
   golden signed-\(K_{3,3}\) family and its exact spectrum.  Cache key
   arXiv:1903.11498, SHA-256
   5a437fbe55049c7c65c8b528dbc9a75bd92da64320da0d543f35300029631a13.
   Source: https://arxiv.org/abs/1903.11498.

The exact orientation queries were:

- "Joubert cubic" "equiangular tight frame";
- "Clebsch cubic" POVM quantum measurement;
- conference matrix qutrit equiangular measurement determinant.

They located the standard conference/ETF and qutrit-measurement literature,
but no result was used as evidence about prior occurrence of the
Joubert-determinant or Segre--Igusa probability-contrast identification.
MathSciNet, zbMATH forward screening, and citation-graph closure were not
performed.  Accordingly the present report attributes the classical frame
facts and proves the operator-specific statements without saying they are
first.

## Structural proof spine

Let \(Q_\pm\) be isometries onto the two golden eigenspaces and set
\(u_i^\pm=\sqrt2Q_\pm^{\mathsf T}e_i\).  Then
\[
 \operatorname{Gram}(u^\pm)=2P_\pm=I\pm C/\sqrt5,
 \qquad \sum_i u_i^\pm(u_i^\pm)^{\mathsf T}=2I_3.
\]
This proves the ETF and POVM normalizations immediately.  Squaring the Gram
entries gives the projector Gram matrix with diagonal \(1\) and off-diagonal
\(1/5\).  Its spectrum \(2, (4/5)^5\) proves real informational
completeness and the displayed reconstruction formula.

The common Naimark dilation gives
\[
 K_T(x)=\frac12\sum_i x_i\,u_{T,i}^-(u_{T,i}^+)^{\mathsf T}.
\]
For \(\|x\|_\infty\le1\) it is a contraction, hence a valid postselected
branch.  It is the C704 block \(P_{T,-}D_xP_{T,+}\) in orthonormal qutrit
coordinates, so the C704 determinant theorem gives
\[
 Z_T=\pm10\sqrt5\det K_T.
\]
The one-dimensional identity
\(\bigwedge^3K_T=\det(K_T)\) turns the square into a literal three-copy
success probability.

For the sharp bound, put \(c_{ijk}=C_{ij}C_{jk}C_{ki}\).  The equations
\(C^2=5I\) and \(C^3=5C\) imply that every signed constant, linear, and
quadratic moment of \(c\) vanishes.  At a sign vertex
\(x_i=1-2\,1_{i\in S}\), only the cubic term survives:
\[
 Z_T(x)=-8\sum_{\{i,j,k\}\subset S}c_{ijk}.
\]
It is zero for \(|S|<3\), is \(\pm8\) for \(|S|=3\), and complementation
handles the remaining cases.  Multilinearity moves the maximum on the
cube to a vertex and shows that equality occurs only at those twenty
balanced vertices.

For a balanced support the formula holds for every outer cubic, so
\(Z_T=\pm8\) simultaneously for all six \(T\).  The normalized sign vector
\((Z_T/8)_T\) has three plus and three minus entries.  Complementing the
control negates it, and the twenty signed vectors therefore form the
oriented double cover of the ten projective Segre nodes.  All six squares
are then \(64\), whence \(W=0\); the same balanced sign pattern gives
\(e_5(Z)=0\).  The amplitudes retain the node and orientation, but their
success probabilities erase both.

This node map contains the exceptional outer automorphism itself.  If
\(F(S)\) is the negative support of \((Z_T(x_S)/8)_T\), then
\[
 F(S^c)=F(S)^c,\qquad
 |S\cap R|=1,2\Longrightarrow |F(S)\cap F(R)|=2,1.
\]
Indeed the path-sign and amplitude-sign matrices \(X,H\) satisfy
\[
 XX^{\mathsf T}=HH^{\mathsf T}=24I-4J,\qquad XH^{\mathsf T}=0.
\]
The tight-frame identity forces the relevant output inner products to be
\(2,-2\), so the intersection exchange follows without a pair census.
The two row spaces are the two five-dimensional constituents of the
middle-layer Johnson module; their pointwise products fill the remaining
nine-space.  Thus the physical optimum carries the complete
\(1+5+5+9\) harmonic splitting.

The vanishing mixed moments continue through bidegrees \((1,0),(1,1)\),
and \((1,2)\): for uniform balanced \(x\),
\[
 \mathbb E\left[(Z_T/8)\prod_{i\in I}x_i\right]=0
 \quad(|I|\le2),
 \qquad
 \mathbb E[(Z_T/8)x_ix_jx_k]=\pm2/5.
\]
Hence each amplitude sign is independent of any selected pair of phase
bits, and cubic coherence is the first carrier of information.  If the
negative support of an output sign vector is \(U\), assigning inverse cubic
coefficient \(-x_i(F^{-1}U)\) gives
\(\widetilde Z_i(Z(x)/8)/8=x_i\) on the balanced slice.  The transform and
its inverse are therefore both cubic.

There are two direct fermionic readings.  In passive number-preserving
fermionic linear optics, the amplitude between the Slater determinants
occupying \(V_{T,+}\) and \(V_{T,-}\) is \(\det K_T\).  Balanced \(D_x\) is
unitary, so the optimal experiment requires only fixed mode mixers,
programmable \(0/\pi\) path phases, and occupation detection.  Independently,
\(A_T=[D_x,C_T]\) is supported on the crossing edges of the \(3+3\) cut,
so it is a signed \(K_{3,3}\) Majorana Hamiltonian.  Since its off-diagonal
golden block is \(2\sqrt5K_T\), its positive energies are \(\{2,4,4\}\),
and \(\operatorname{Pf}A_T=4Z_T=\pm32\).  Thus the oriented output is a
class-D fermion-parity syndrome, not merely an algebraic sign convention.

At a balanced sign filter, cyclic trace expansion gives
\[
 \operatorname{tr}(K_T^{\mathsf T}K_T)=\frac95,\quad
 \operatorname{tr}((K_T^{\mathsf T}K_T)^2)=\frac{33}{25},\quad
 \det(K_T^{\mathsf T}K_T)=\frac{16}{125}.
\]
Newton's identity factors the characteristic polynomial as
\((\lambda-1/5)(\lambda-4/5)^2\).  Finally, an \(r\)-query coherent
circuit has acceptance probability of degree at most \(2r\) in \(x\).
Since \(Z_T^2\) has degree six, exact realization on the physical cube
requires \(r\ge3\); the antisymmetric protocol is therefore query-optimal.

The complete certificate-independent argument, including inverse polarity
and all boundary distinctions, is in
notes/2026-07-31-c707-golden-etf-quantum-measurements-human-proofs.md.

## Standard facts versus the golden return

The standard layer is:

- conference matrix \(\Rightarrow\) \((6,3)\) ETF;
- \(G_-=2I-G_+\) \(\Rightarrow\) Naimark complement;
- tight frame \(\Rightarrow\) rank-one POVM; and
- the six icosahedral axes \(\Rightarrow\) the same real ETF.

The golden-operator layer is:

- the marked cross transfer has determinant \(Z_T/(10\sqrt5)\);
- the six outer transfer amplitudes obey the Segre relation;
- their three-copy success contrasts are the Igusa polar coordinates;
- those contrasts projectively recover the signed amplitudes off \(e_5=0\);
- the transfer ranks \(3,2,1\) reproduce the cubic, its smooth wall, and
  its six nodes; and
- the sharp physical optimum is the \(3+3\) phase orbit, with success
  probability \(16/125\) and squared singular spectrum
  \(\{4/5,4/5,1/5\}\);
- the twenty optimal controls are the oriented lifts of the ten Segre
  nodes, while all six probability contrasts vanish there; and
- on the optimal layer the cubic amplitude signs realize the exceptional
  outer transform, exchanging the two nontrivial Johnson relations and the
  two five-dimensional harmonic constituents; and
- this transform is a two-sided cubic, order-two correlation-immune phase
  code, whose first mixed information is third-order; and
- the optimum is both a lossless three-fermion interferometer and a signed
  \(K_{3,3}\) Majorana family with energy spectrum \(\{2,4,4\}\); and
- the exterior-cube implementation uses the minimum possible three
  controlled-filter queries.

The first list is classical and cited.  The second list is proved from the
C704/C705 operator tower and is not implied by ordinary ETF theory.

## Operational boundary

- The two objects are real-qutrit measurements, not complex qutrit SICs.
- The cross-transfer protocol requires coherently signed Naimark
  instruments.  The POVM effects alone forget the frame-vector signs and
  do not determine \(K_T\).
- The six \(T\)'s are six outer-conjugate protocols, not six outcomes of
  one additional POVM.
- \(x\) is a coherent path-control vector, not a quantum state.
- \(Z_T\) is orientation-dependent and is not itself a Born probability.
  Its square is operational only after the specified coherent
  three-copy protocol.
- \(W\) is a signed probability contrast, not a positive effect.
- At balanced controls the Slater protocol is lossless passive fermionic
  linear optics.  Ordinary photons implement permanents, not this determinant,
  unless an antisymmetric internal-state encoding is added.
- The signed \(K_{3,3}\) Majorana network is an exact finite Hamiltonian
  proposal, not a claim of an existing golden-network experiment.
- Rank drops of \(A\) and \(K_T\) concern the controlled transfer family;
  the underlying fixed POVMs remain real-informationally-complete.

## Exact evidence and replay

The canonical bundle consists of:

- notes/2026-07-31-c707-golden-etf-quantum-measurements.py;
- notes/2026-07-31-c707-golden-etf-quantum-measurements.json;
- notes/2026-07-31-c707-golden-etf-quantum-measurements-replay.py;
- the human proof companion; and
- notes/2026-07-31-c707-golden-etf-quantum-measurements.sha256.

From the repository root:

    python3 notes/2026-07-31-c707-golden-etf-quantum-measurements.py --check
    python3 notes/2026-07-31-c707-golden-etf-quantum-measurements-replay.py

The generator checks the two ETF normalizations, the projector-Gram
spectrum and tomography formula, the \(60+60\) symmetry split, all six
outer response-kernel identities at two integral witnesses, and the sharp
\(44+20\) cube-vertex distribution for every protocol.  It also checks that
each balanced control maximizes all six protocols, that the twenty signed
amplitude patterns pair into ten projective Segre nodes, and that \(W=e_5=0\)
on this locus.  It further checks the \(0\mapsto0,1\mapsto2,2\mapsto1\)
intersection transport, the orthogonal simplex identities, and the complete
\(1+5+5+9\) middle-layer decomposition.  It also checks the two-sided cubic
inverse, vanishing mixed moments through order two, the first cubic moments
\(\pm2/5\), and the signed-\(K_{3,3}\) Majorana invariants
\(\operatorname{tr}(-A^2)=72\), \(\operatorname{tr}((-A^2)^2)=1056\), and
\(\operatorname{Pf}A=\pm32\).  The independent
replay constructs the two projectors directly over
\(\mathbf Q(\sqrt5)\) and checks
\(\det(K^{\mathsf T}K)=Z^2/500\) for all \(729\) filters in
\(\{-1,0,1\}^6\), together with the three elementary symmetric functions
of the optimal squared singular values.

The computation does not prove the determinant theorem or the cube bound;
the human exterior-algebra and signed-moment arguments do.  The computation
checks normalization, convention transfer, and exact finite witnesses.

## EJ + Tao closeout

The first extra-juice pass exposed the three-copy antisymmetric protocol,
turning transition volume into an actual success probability.  The Tao
check then asked for the physical domain, coordinate independence, the
sharp success bound, and the distinction between tomography rank and
transfer rank.  This produced the structural \(3+3\) phase theorem and
removed the loose contraction estimate \(p\le1\).

A second Tao pass asked which data the POVM effects forget, whether three
copies are necessary, and what the optimal transfer actually does in its
three singular directions.  It isolated the coherently signed instrument
as the true operational object, proved three-query optimality by the
polynomial method, and fixed the optimum spectrum
\(\{4/5,4/5,1/5\}\).

The final extra-juice pass compared the six outer protocols at the sharp
optimum.  It found the cleanest geometric boundary in the package: the
twenty maximizing controls are exactly the oriented lifts of the ten Segre
nodes, yet their six success probabilities are all equal.  The probability
polar is therefore maximally blind precisely where each individual
protocol is maximally successful.  Coherent relative phase retains the
lost signed-node data; success statistics alone do not.

The second extra-juice pass compared pairs of optimal controls.  The cubic
map exchanges intersection one with intersection two and preserves
complements, giving a direct operational realization of the exceptional
outer automorphism on the middle layer.  The orthogonal input/output simplex
frames explain why: they are the two five-dimensional Johnson constituents,
and their pointwise correlations supply the remaining nine-dimensional
channel.

The third extra-juice pass asked whether that transform is reversible and
whether its ``quantum'' interpretation survives contact with standard
many-body physics.  Both answers are positive.  The inverse is again cubic
on the balanced slice; every individual output parity is blind to any pair
of input phases, with information first appearing in cubic moments.  At the
same time the protocol becomes ordinary lossless Slater-determinant
scattering, while the C709 commutator becomes a universal-spectrum signed
\(K_{3,3}\) Majorana network.  The two readings share the same determinant
and retain complementary operational data: occupation probability sees
\(Z^2\), ground-state parity sees \(\operatorname{sign}Z\).

The Milnor/Serre proof review reduced the package to four reusable
mechanisms: projector Gram matrices, one Naimark dilation, top exterior
power, and vanishing signed moments from \(C^2=5I\).  No classification
table or finite enumeration is load-bearing.

## Mystery ledger

- **Settled — why the factor \(500\):** it is
  \((10\sqrt5)^2\), the square of the oriented cross-golden determinant
  normalization.
- **Settled — whether the POVMs are informationally complete:** yes,
  minimally and isotropically for real qutrit states; no for complex
  qutrit states.
- **Settled — what \(W\) measures:** it is \(500\) times the centered
  three-copy success probability, or \(3000\) times that contrast in the
  C705 integral normalization.
- **Settled — why signs can return from squares:** inverse polarity uses
  the Segre constraint and recovers \(z\) projectively by
  \(y=-4e_5(z)z\).
- **Settled — the surprisingly small physical optimum:** the exact maximum
  success probability is \(16/125\), attained on the twenty balanced
  \(3+3\) phase controls; lower signed moments vanish because
  \(C^2=5I\).
- **Settled — the shape of the optimum:** every maximizing transfer has
  squared singular spectrum \(\{4/5,4/5,1/5\}\), forced by two cyclic
  traces and the determinant.
- **Settled — the operational geometry of \(e_5=0\) at the optimum:** the
  twenty maximizing controls form the oriented double cover of the ten
  Segre nodes.  All six probabilities equal \(16/125\), so \(W=0\) and
  inverse polarity is necessarily blind there; only coherent relative
  amplitude retains the node and orientation signs.
- **Settled — why there are two natural six-coordinate descriptions of the
  optimum:** the path signs and outer-protocol amplitude signs span the two
  orthogonal five-dimensional constituents of the twenty-triple permutation
  module.  The cubic map is the exceptional outer transform, detected by its
  exchange of intersection sizes one and two.
- **Settled — where the hidden input information first appears:** every one
  or two path phases are statistically independent of one chosen output
  amplitude sign; the first nonzero mixed moments are cubic, equal to
  \(\pm2/5\).  The inverse map is itself cubic on the balanced slice.
- **Settled — whether the optimum has literal many-body physics:** yes.  It
  is a lossless three-fermion Slater transition with probability \(16/125\),
  and simultaneously a signed \(K_{3,3}\) class-D Majorana Hamiltonian with
  energies \(\{2,4,4\}\) and parity Pfaffian \(\pm32\).
- **Settled — resource minimality in the coherent-filter model:** an
  \(r\)-query acceptance probability has degree at most \(2r\), so the
  degree-six probability \(Z_T^2/500\) requires \(r\ge3\); the parallel
  exterior-cube protocol is optimal even with \(x\)-independent ancillas.
- **Open — the rest of the exceptional divisor:** the maximum-success
  stratum is now classified, but experimentally distinct transfer families
  sharing probability contrasts on the full locus \(e_5=0\) remain
  unclassified.  This optional question has no allocated C-ID.
- **Not audited — hardware realization:** this pass proves an implementable
  finite free-fermion model but did not run the experimental-literature audit
  needed to say whether the exact golden mixer or signed \(K_{3,3}\) network
  has been built.  That is not a missing mathematical gate for C707.
- **Boundary — resources outside the oracle model:** hardware that exposes
  nonlinear functions of \(x\) as primitive controls is a different
  resource theory; C707 makes no minimality claim there.
- **Coverage gap:** the 2025 complete qutrit equioverlapping-measurement
  classification was not accessible at full text.  Therefore no novelty
  sentence about the underlying six-outcome POVM, or about the
  operator-specific transfer construction, is licensed.
