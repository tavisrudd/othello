# C707 — Golden eigenspaces as quantum measurements

**Lane:** `clebsch`

**Status:** complete

## Objective

Develop the two rank-three projectors
\(P_\pm=(I\pm C/\sqrt5)/2\) as Naimark-complementary six-vector real-qutrit
equiangular tight frames and test whether the C704/C705 operator tower has
an intrinsic measurement-theoretic meaning.

## Gates

1. Fix normalized frames, Gram matrices, POVM weights, and symmetry groups.
2. Interpret the cross-golden blocks and \(Z_T=\det B_T\) as transition
   volumes or frame invariants.
3. Test whether \(A=dZ\), \(W\), and the inverse polarity describe
   singular, dual, or informational-completeness loci.
4. Separate standard ETF facts from genuinely operator-specific content.

## Boundary

These six-outcome measurements are not qutrit SICs; no operational claim is
licensed without a precise state/measurement protocol.

## Resolution

The two golden eigenspaces give Naimark-complementary \((6,3)\) real ETFs
and minimally informationally complete real-qutrit POVMs, with reconstruction
\[
 \rho=\frac52\sum_i p_i\Pi_i-\frac12I.
\]
They are not informationally complete for complex qutrits.

The common six-path dilation supplies the precise protocol:
\[
 K_T(x)=Q_{T,-}^{\mathsf T}\operatorname{diag}(x)Q_{T,+},
 \qquad
 p_T^{(3)}(x)=\det(K_T^{\mathsf T}K_T)=\frac{Z_T(x)^2}{500}.
\]
Thus \(Z\) is an oriented three-copy transition amplitude, \(A=dZ\) is
its control response, and \(W\) is the centered contrast of the six
three-copy success probabilities.  Inverse polarity recovers the
projective signed amplitude vector off \(e_5=0\).

Signed-moment cancellation from \(C^2=5I\) gives the sharp physical bound
\[
 |Z_T(x)|\le8,\qquad p_T^{(3)}(x)\le16/125
 \quad(\|x\|_\infty\le1),
\]
with equality exactly at the twenty balanced \(3+3\) phase vertices.
Every balanced control maximizes all six outer protocols simultaneously;
their amplitude sign vectors are the oriented lifts of the ten Segre nodes.
All six optimal probabilities coincide, so \(W=e_5(Z)=0\): the optimum is
exactly the probability-polar blind locus, while coherent amplitude signs
retain the node orientation.
On the twenty-point optimal layer the cubic amplitude map also realizes the
exceptional outer transform: it preserves complements, exchanges triple
intersection sizes one and two, and identifies the path and protocol sign
spaces with the two orthogonal five-dimensional Johnson constituents.  Their
pointwise products complete the \(1+5+5+9\) harmonic decomposition.
The transform and its inverse are cubic on the balanced layer.  Each output
amplitude sign is statistically independent of any chosen pair of input
phase signs, with the first nonzero mixed moments equal to \(\pm2/5\).
Physically, the optimum is a lossless three-fermion Slater-determinant
interferometer.  The same control gives a signed \(K_{3,3}\) six-Majorana
Hamiltonian with positive energies \(\{2,4,4\}\), Pfaffian \(\pm32\), and
ground-parity sign \(\operatorname{sign}Z_T\).
Every optimal transfer has squared singular spectrum
\(\{4/5,4/5,1/5\}\).  The three-filter exterior-cube protocol is
query-optimal among coherent circuits with \(x\)-independent gates and
ancillas.  The operational structure belongs to the coherently signed
Naimark instruments; the POVM effects alone forget the signs needed to
define the cross transfer.

The physics novelty audit identifies a further exact bridge.  The Segre
identities for the six amplitudes are precisely the local \(U(1)\) anomaly
equations for six Weyl charges.  Every nonbalanced real phase mask has
\(Z=0\), while the balanced masks give the vectorlike Segre nodes.  The
contractive filter \((-3,-2,-1,0,1,3)/3\) instead gives the standard
primitive chiral charge vector \((11,-10,-8,5,4,-2)\) projectively.  Prior
work contains the ambient Segre/outer geometry, anomaly interpretation,
determinant rule, and Pfaffian-parity rule separately; the bounded sweep did
not locate their exact real-golden operator synthesis.

Full report:
notes/2026-07-31-c707-golden-etf-quantum-measurements.md.
Certificate-independent proof:
notes/2026-07-31-c707-golden-etf-quantum-measurements-human-proofs.md.
Physics novelty and directions audit:
notes/2026-07-31-c707-physics-novelty-and-directions-audit.md.
