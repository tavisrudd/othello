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

## Literature finding first

This was a bounded positioning sweep, not a novelty audit, and makes no
priority or absence claim.  Zero sources were read at full text; three
primary sources were read partially at the sections stated below, and one
recent primary source was available only at abstract/metadata depth.

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
  probability \(16/125\).

The first list is classical and cited.  The second list is proved from the
C704/C705 operator tower and is not implied by ordinary ETF theory.

## Operational boundary

- The two objects are real-qutrit measurements, not complex qutrit SICs.
- The six \(T\)'s are six outer-conjugate protocols, not six outcomes of
  one additional POVM.
- \(x\) is a coherent path-control vector, not a quantum state.
- \(Z_T\) is orientation-dependent and is not itself a Born probability.
  Its square is operational only after the specified coherent
  three-copy protocol.
- \(W\) is a signed probability contrast, not a positive effect.
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
\(44+20\) cube-vertex distribution for every protocol.  The independent
replay constructs the two projectors directly over
\(\mathbf Q(\sqrt5)\) and checks
\(\det(K^{\mathsf T}K)=Z^2/500\) for all \(729\) filters in
\(\{-1,0,1\}^6\).

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
- **Open — the operational geometry of \(e_5=0\):** the algebra proves
  precisely where inverse recovery fails, but does not classify which
  experimentally distinct transfer families share the same probability
  contrasts there.  This is optional successor work and has no allocated
  C-ID.
- **Open — resource minimality:** three copies give a canonical determinant
  protocol, but no lower bound here excludes a different ancilla-assisted
  estimator using fewer copies.  Such a lower bound is outside C707 and
  would require a separately promoted quantum-information task.
- **Coverage gap:** the 2025 complete qutrit equioverlapping-measurement
  classification was not accessible at full text.  Therefore no novelty
  sentence about the underlying six-outcome POVM, or about the
  operator-specific transfer construction, is licensed.
