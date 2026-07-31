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
Every optimal transfer has squared singular spectrum
\(\{4/5,4/5,1/5\}\).  The three-filter exterior-cube protocol is
query-optimal among coherent circuits with \(x\)-independent gates and
ancillas.  The operational structure belongs to the coherently signed
Naimark instruments; the POVM effects alone forget the signs needed to
define the cross transfer.

Full report:
notes/2026-07-31-c707-golden-etf-quantum-measurements.md.
Certificate-independent proof:
notes/2026-07-31-c707-golden-etf-quantum-measurements-human-proofs.md.
