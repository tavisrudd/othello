# C756 — all-\(k\) conic-filling classification

**Lane:** `clebsch`

**Status:** active open mathematics.  The saturated-external branch is closed
and transferred to C894.  C756 retains the saturated-internal branch and the
full nonsaturated branch.  The latter is not reduced to one conic point type
in general, but the entire \(k=12\) layer is now impossible over every finite
field.  At \(q=47\), all 22 external-deletion stars fail \(E_9=0\); at
\(q=49\), all 22 fail the divided equation \(E_7=0\); both genuine
all-passant rows have no geometric star.  At \(q=53\), the 230
external-deletion and 44 all-passant stars have zero complete centers.  The
direction bound excludes \(q>53\), while even fields and \(q\le43\) were
already settled.  At \(k=13\), exact twelve-line geometry also closes
\(q=59\), while at \(q=61\) exactly 96 normalized mixed leaves survive
geometry and every one fails the first forced equation \(E_6=0\); the
all-passant row has no leaf.  Thus the complete \(k=13\) layer is impossible
over every finite field.  At \(k=14\), none of the 96 exact \(q=61\) mixed
leaves admits a thirteenth line, so that field also closes.  At \(q=67\) the
mixed branch has no thirteen-line star, while all 92 all-passant stars fail
already at \(E_{12}\).  At \(q=71\), the all-passant branch has no star and
all 39 mixed stars fail their first forced equation \(E_8=0\).  At \(q=73\),
neither branch has a geometric star.  Thus the complete \(k=14\) layer is
also impossible over every finite field, and no \(k=15\) census is planned.
In the saturated-internal branch, coherence canonically produces a dual
3-net of order \((q+3)/2\); the collinear-component conic theorem and subgroup
arithmetic now exclude every prime \(q>5\).  Extension fields remain at a
precise characteristic-threshold version of that theorem.
The character-weighted
all-center residual sum is the difference of the \(\pm1\) root
multiplicities of an exact
degree-\(\delta S(A)\) norm polynomial; its trace coefficient gives the sum
modulo the characteristic.  At defect two the scalar resultant detects the
zero-weight case but necessarily loses the sign \(W=\pm2\).

> **LIVE CARD.**  Keep only current conclusions, gates, stop rules, ownership,
> and authoritative pointers here.  Put evidence, failed routes, correction
> trails, and detail in dated C756 reports.

## Goal

Remove the \(k\le8\) boundary and prove, or find a counterexample to, the
complete statement:

> For every \(k\) and every prime power \(q\), the only \(k\)-arcs in
> \(\mathrm{PG}(2,q)\) whose uncovered locus is the full point set of a
> nonsingular conic are the projective four-frame over \(\mathbb F_5\) and
> the Clebsch hexagon over \(\mathbb F_{11}\).

Quotable form if proved: *deep-hole loci are conics exactly twice, ever.*

## Scope correction

No current theorem excludes external or mixed-type primal arcs in the
nonsaturated branch.  The point-type audit now shows exactly where that
matters:

- polarity gives a mixed secant/passant arrangement, but every pairwise node
  is internal because it is the pole of a chord passant;
- at \(q=53,k=12\), moment collapse, covariance rank two, the critical
  equations, and the open separator Hessian hold for either deleted-point
  type and arbitrary types among the remaining points;
- the all-internal hypothesis first enters the old offset/node-character
  descent, where every polar line was parameterized as a passant;
- \(q=47\) has a bounded degree-eight star carrier, while at \(q=49\) the
  divided elementary form \(E_7\) retains the information lost by ordinary
  characteristic-seven moments;
- \(k=12\) is the first candidate size in these fields, not their only
  nonsaturated size.

Authorities:
`notes/2026-08-09-c756-all-k-status-assumption-audit.md` and
`notes/2026-08-09-c756-nonsaturated-point-type-ledger.md`.

## Ownership and routing

- C756 is a research task; do not edit `papers/` under this ID.
- C756 owns this card, dated C756 reports, and task-specific evidence.
- C894 owns the saturated-exterior/local-Paley publication package.
- Paper IV supplies reusable definitions and the weight-eight method but does
  not own or block this theorem.
- Optional stuck-state/referee context:
  `notes/clebsch-tasks/c756-proof-expert-dossier.md`.  Do not preload it for
  routine continuation.

## Proved common core

- The conic-filling condition is equivalent to hereditary chord externality
  plus full off-conic covering.
- Even \(q\) is impossible because the nucleus is never covered.
- In odd characteristic, chord externality is the fixed quadratic-character
  condition on pairwise binary-quadratic resultants.
- The covering LP has degree cap \(\lfloor k/2\rfloor\).
- A spare external line gives either
  \(\binom{k-1}{2}\ge q\), or saturation with
  \(k=(q+1)/2\) and all points external, or
  \(k=(q+3)/2\) and all points internal.
- In the nonsaturated case the direction quotient improves the bound to
  \(\binom{k-1}{2}\ge q+2\); defects zero and one are impossible.
- The classification is exact for every \(k\) and odd prime power \(q\le43\):
  only the \(q=5\) four-frame and \(q=11\) hexagon occur.
- No conic-filling \(12\)-arc exists over any finite field.
- No conic-filling \(13\)-arc exists over any finite field.
- No conic-filling \(14\)-arc exists over any finite field.
- A saturated-internal coherent support is a dual 3-net of order
  \((q+3)/2\); over prime fields this leaves only the \(q=5\) four-frame.
- Over every odd prime power, the two affine net components have the
  complementary-factor form
  \((x,\pm S(x))\) on the nonroots of \(S\), where
  \(RS=X^q-X\), \(\deg R=(q+3)/2\), and \(\deg S=(q-3)/2\).

## Current branch map

### Saturated-external — closed, publication work in C894

An exterior arc of \((q+1)/2\) external conic points exists only for
\(q\in\{3,7,11\}\), in one conic-stabilizer orbit per field; covering selects
the \(q=11\) hexagon.  The all-field proof and cold read are authoritative.
Do not reopen this branch in C756.

Authorities:
`notes/2026-08-08-c756-saturated-exterior-consolidated-proof.md` and
`notes/2026-08-08-c756-consolidated-proof-cold-referee-read.md`.

### Saturated-internal — prime fields closed; extension conic gate open

Put \(q=2m-1\).  Polarity turns a hypothetical example into \(m+1\) passants
in dual-arc position whose pairwise intersections form an internal star
\(\mathcal B(Y)\).  Covering is exactly

\[
 \mathcal B(Y)\text{ meets every secant and every passant}. \tag{A}
\]

Tangents automatically avoid the star.  The live geometric gate is:

> prove that every such coherent star over a proper extension field with
> \(q>5\) misses a non-tangent line.

Coherence now has a standard incidence model.  For an oriented support
\(Z\subset\mathbb F_{q^2}\), the three sets consisting of \(Z\), \(Z^q\),
and the character-opposite directions together with the trace-zero direction
form a dual 3-net of order \((q+3)/2\).  If \(q\) is prime, Theorem 5.1 of
Blokhuis--Korchmaros--Mazzocca forces the two affine components onto a conic;
splitting and the two-line subgroup classification leave only \(q=5\).
For proper prime powers the net order exceeds the characteristic.  The live
gate is the same conic conclusion using the extra Frobenius exchange and
quadratic-character direction component.

The extension seam is now algebraic.  If \(H_2\) is the degree-\(<\deg R\)
remainder of \(S^2\) modulo \(R\), conic containment is exactly
\(\deg H_2\le2\), equivalently the vanishing of the coefficient band
\[
 [X^j]S^3=0\qquad((q+3)/2\le j\le q-1).
\]
Writing the proper Laurent part of \(S^3/(X^q-X)\) as
\(\sum c_rX^{-r}\), the third odd divided coefficient forces
\(r(r+1)c_r=0\) through the whole required range.  Only
\(r\equiv0,-1\pmod p\) can survive.  If \(F=H_2/R\), this is the truncated
rank-two Cartier tail
\(F=A(Z^{-p})+ZB(Z^{-p})+O(Z^{-(n-2)})\).  Every higher odd coefficient
acts on the same tail through the exact nonlinear coupling
\[
 \frac{H_{2j}}R=\operatorname{pr}_{<0}(R^{j-1}F^j).
\]
The ghost module is affine-stable, so coordinate translation is not an
additional equation.  After reciprocation, the same condition is a
two-component Frobenius--Pade congruence against the unit reciprocal factor
\(R^\vee\), while the higher equations impose the nonlinear compatibility
with \(H_2\equiv S^2\pmod R\).  Its numerator space has dimension
\(q/p+2\); quotienting by the three-dimensional conic numerators leaves an
exact \(q/p-1\)-dimensional saturated ghost module.  More generally, the
rungs \(j=p^a\) form a
Frobenius-semilinear digit tower: for \(p\ge5\) every level
\(0\le a\le e-1\) is available, and for \(p=3\) every non-top level is.
Lucas selects the corresponding base-\(p\) digit of the Laurent index.  If
the descended digit maps have zero common kernel on the ghost quotient, the
extension conic lemma follows; otherwise only their common kernel must meet
the first non-shadow odd equation.  The latter clause is essential:
dimension alone forces tower kernels of dimension at least one for \(q=25\)
and at least five for each of \(q=27,81\).
In canonical ghost-tail coordinates the entire semilinear tower untwists to
one ordinary stacked Cartier--Toeplitz matrix \(\mathbb M_R\), with
\(\mathcal K_R=\ker\mathbb M_R\).  Its entries are denominator-free
polynomials in the coefficients of \(R\), so positive-kernel loci are exact
determinantal strata on the completely split factor locus.  Lucas gives the
row count at every digit.  The only live parameters where row count alone
forces a nonzero kernel are now \(q=25,27,81\) (the additional \(q=9\) row
is already closed); at \(q=81\), the kernel must meet the native \(j=2\)
checks and the reflected shadow-successor rungs \(j=5,14\).  Outside these
three fields, any tower kernel is a special rank-drop stratum rather than a
dimension necessity.
In general the first non-shadow rung does not descend to the ghost quotient:
its mixed
binomial terms retain the three-dimensional conic part of \(H_2\).  Using
the canonical ghost-tail section, its exact carrier is a degree-two map for
\(p\ne5\), or a degree-three map for \(p=5\), on
\(\mathcal C_R\oplus\ker\mathbb M_R\).  The strong rigidity target is that
its zero locus is exactly \(\mathcal C_R\oplus\{0\}\).
Its normal derivative along the conic locus is another explicit
denominator-free matrix \(\mathbb N_R(C)\); the first subgate is the
determinantal transversality condition
\(\ker\mathbb M_R\cap\ker\mathbb N_R(C)=0\), followed by exclusion of
disjoint zeros of the full quadratic/cubic map.  This tangent test is useful
in characteristics three and five, hence at all three forced seams.  For
\(p\ge7\), residue support makes \(\mathbb N_R(C)\) identically zero: every
rank-drop ghost has second-order contact with the conic locus, so the
quadratic normal cone must be used directly.  Moreover the same cancellation
removes all conic dependence from the full \(j=2\) equation, leaving a pure
homogeneous quadratic map on \(\ker\mathbb M_R\).  Hence only
characteristics three and five require the genuinely mixed bundle.
Writing the full rational tail in its \(p\) Cartier components turns that
large-characteristic quadratic into an exact block convolution.  Its
two-slot core is the recurrence
\(R_kA^2+2R_{k-1}AB+R_{k-2}B^2\), while an explicit correction
\(\Delta_k\) contains the late residue components generated by rational-tail
recurrence.  The next lemma is to use the power tower to kill \(\Delta_k\)
through the forced window; the remaining Cartier slices would then have the
osculating form \((\alpha+\beta k)(-\lambda)^k\), which must be ruled out by
complete splitting of \(R\).
Equivalently, if \(x_i\) are the roots of \(R\) and
\(w_i=1/R'(x_i)\), the entire hierarchy is the division-free syndrome law
\[
 \sum_i w_i^{2j+1}x_i^m=0
 \quad\text{whenever}\quad
 0\le m\le n-2j-2,
 \ \binom{m+2j}{2j}\not\equiv0\pmod p.
\]
The conic conclusion is exactly that the squared weight vector
\((w_i^2)\) is the evaluation of a quadratic polynomial on the \(x_i\).
Frobenius reflects a power rung \(j=p^a\) into the non-power rung
\(j^\vee=(p^{e-a}+1)/2\), rotating monomial exponents modulo \(q-1\).  In
the forced tower-kernel seams this adds the explicit high exponent sets
\(\{0,5,10\}\) at \(q=25\) and \(\{0,9,18\}\) at \(q=27\).
Every rung with \(2j+1=p^b\) is a tautological Frobenius shadow of the
ordinary barycentric identities and must be skipped.  Hence \(j=2\) gives no
new information in characteristic five: the correct first kernel test is
\(j=3\) at \(q=25\),
where its native exponent set \(\{0,1,2,3,5,6\}\) is enlarged by the
reflected exponent \(10\).  At \(q=27\), \(j=2\) remains informative, with
native set \(\{0,1,3,4,9\}\).
More generally, every reflected rung is the immediate successor
\(j_b^+=(p^b+1)/2\) of a tautological shadow
\(j_b^-=(p^b-1)/2\), and
\(H_{2j_b^+}\equiv H_2H_{2j_b^-}\pmod R\).  The extension problem can thus
be routed through rigidity of these shadow--successor ratios.
For general \(j\), Kummer's theorem gives the exact visible prefix: if
\(s=v_p(j)\) and \(d\equiv2j/p^s\pmod p\), the first carry occurs at
\(p^s(p-d)\).  Barycentric Reed--Solomon duality turns that prefix into an
explicit degree bound on the interpolant \(H_{2j}\).  The identities
\(H_{2(j+1)}\equiv H_2H_{2j}\pmod R\) therefore form a single
digit-controlled multiplication orbit.  The extension theorem is now a
carry-flag rigidity statement for that orbit.
The top rung \(j=q/p\) is completely visible for \(p\ge5\).  Its no-wrap
degree bound proves the uniform gap
\[
 \deg H_2\le2
 \quad\text{or}\quad
 \deg H_2\ge(p+1)/2.
\]
Thus any surviving extension ghost has characteristic-scale degree.
More generally, every rung gives the exact no-wrap implication
\(j\deg H_2<n\Rightarrow j\deg H_2\le\nu_j\), where \(\nu_j\) is the
carry-prefix degree bound.  The union of the resulting forbidden degree
intervals is a universal digit-arithmetic sieve; only its complement needs
wrapped multiplication or sparse/reflected checks.  In characteristic three,
the rung \(j=q/9\) additionally excludes \(\deg H_2=4\) for every
\(q=3^e\), \(e\ge3\), while degree three remains open.
After wrap, the full interpolant orbit is cyclic of length dividing
\((q-1)/2\), with \(P_{(q-1)/2}=1\), inversion
\(P_jP_{(q-1)/2-j}\equiv1\pmod R\), and Frobenius acting on index cycles of
length at most \(e\).  This supplies the finite orbit structure on which the
determinantal kernel and carry flags must be combined.
Multiplying back the root
divisor of \(S\) packages the entire hierarchy as a full-field norm
identity: the two completely split degree-\(q\) products
\(\prod_{x\in\mathbb F_q}(U+Vx\pm WS(x))\) differ by
\(\gamma WQ_D(V,W)C_S(U,V)\), whose \(U\)-degree is only \((q-3)/2\).

Exact necessary structure already available:

\[
 \sum_{j\ge1}(j-1)(j-2)a_j
 =\frac{m(m-2)(m-3)(m-5)}4, \tag{B}
\]

which excludes \(q=7\), plus the certified diagonal allocation excluding the
rigid \(q=9\) profile.  Covering also forces

\[
 T_4(Y)\ge
 \frac{m(m-2)(m-1)(m+1)}{8(2m-1)}>0. \tag{C}
\]

For the outside-by-support signed matching block,

\[
 R\mathbf1=0,
 \qquad R^{\mathsf T}R=(m-2)((m+1)I-J), \tag{D}
\]

and each row is a signed chord-matching vector.  These are necessary global
interfaces, not contradictions.  Local diagonal signs, Smith torsion, and the
abstract frame alone do not close the branch.

### Nonsaturated — mixed-type ledger complete, classification open

For a deleted arc point \(P\), a spare external line gives

\[
 D_P(T)=(T^q-T)E_P(T),\qquad
 \deg E_P=\delta:=\binom{k-1}{2}-q. \tag{E}
\]

The clean uniform target remains a masked Rédei theorem forcing a missing
direction for every \(\delta\ge2\).  No such carrier is proved.

The point-type gate is now exact.  If \(e\) of the \(k\) arc points are
external, then the number of ordered deleted-point/spare-passant pairs, each
carrying a degree-\(\delta\) quotient (E), is

\[
 k\left(\frac{q+1}{2}-(k-1)\right)-e. \tag{F}
\]

At \(k=12\), an external versus internal deleted point supplies respectively
\(12/13\), \(13/14\), and \(15/16\) spare-line quotients for
\(q=47,49,53\).  In the dual arrangement all 55 nodes are internal, even
when the eleven lines are a secant/passant mixture.  Simultaneous projection
forces

\[
\begin{array}{c|c|c}
q&P\text{ external}&P\text{ internal}\\ \hline
47&e_9,\ldots,e_{11}=0&e_9,\ldots,e_{12}=0\\
49&e_7,\ldots,e_{12}=0&e_7,\ldots,e_{13}=0\\
53&e_3,\ldots,e_{14}=0&e_3,\ldots,e_{15}=0.
\end{array}                                                \tag{G}
\]

The degree-nine separators and degree-ten generators lie in every window.
At \(q=47\), ordinary polarization produces an explicit bounded
quadratic-through-octic carrier: the 42 coefficients of the binary forms
\(E_2,\ldots,E_8\) determine all moment tensors through degree eleven and
one multilinear partition function packages the star product, generators,
and separators as its value, gradient, and Hessian.  At \(q=49\),
characteristic seven destroys the mixed moments from degree seven onward;
use Hasse/divided-power coefficients instead.  At \(q=53\), the common range
through degree fourteen gives the rank-two critical core for both point
types.

The aggregate collision identity

\[
 \delta\left(k\left(\frac{q+1}{2}-(k-1)\right)-e\right)
 =\sum_{X\notin A\cup C}(d_X-1)s_A(X)                   \tag{H}
\]

retains all deleted points and spare lines.  Its character-weighted refinement
is exact locally: on a spare line it is the quadratic-character sum over the
degree-\(\delta\) residual divisor \(E_{P,\ell}\).  At defect two it lies in
\(\{-2,0,2\}\).  If \(B_{P,\ell}\) is the residual Artin algebra and
\(u=(Q_\ell\bmod E_{P,\ell})^{(q-1)/2}\), then the local weight is
\(\operatorname{Tr}(u)\), its scalar resultant sign is \(N(u)\), and the
product of the characteristic norm polynomials over all deleted points and
centers is

\[
 (Z-1)^{(\delta S(A)+T_A)/2}(Z+1)^{(\delta S(A)-T_A)/2}. \tag{H'}
\]

Thus \(T_A\) is the difference of the \(\pm1\) root multiplicities of one
exact all-center resultant; its negative next-to-leading coefficient is
\(T_A\) modulo the characteristic.  At defect two,
\(W_{P,\ell}^2=2(1+\chi(\operatorname{Res}(E_{P,\ell},Q_\ell)))\).
The scalar norm alone cannot distinguish all-external from all-internal
residual pairs; the remaining covariance work must retain the trace of the
linear remainder of \(Q_\ell^{(q-1)/2}\) modulo \(E_{P,\ell}\).  Authority:
`notes/2026-08-09-c756-all-center-resultant-norm.md`.

The masked direction and intercept data also have a uniform finite-module
carrier.  Let \(A_{\rm node}\) be the split function algebra of the
\(q+\delta\) chord nodes and let
\(B_{\rm dir}=\operatorname{Map}(\mathbb F_q,\mathbb F_q)\) pull back along
the slope map.  The excess module
\[
 M=A_{\rm node}/B_{\rm dir}
\]
has dimension exactly \(\delta\).  Slope multiplication descends to \(M\)
and has characteristic polynomial \(E_P\); the classes
\([U],[U^2],\ldots\) form a canonical intercept flag spanning every repeated
fibre.  Fibrewise trace gives a canonical covariance form on \(M\), whose
intercept-power Gram determinant at multiplicity \(\mu\) is
\(\mu^{\mu-2}\prod_{a<b}(u_a-u_b)^2\).  The node-character condition is the
constant square class of \(Q(T,U)\in A_{\rm node}^\times\).  This quotient
lives only on the Frobenius-fixed finite base and does not assume a global
Moore Cartier divisor.  Weighting covariance by \(Q\) reduces the global
conic contribution to
\(\epsilon^{\delta+r}\prod_{\mu_t\ge2}
\chi(\sigma_t)^{\mu_t-2}\), where
\(r=|\{t:\mu_t\ge2\}|\) and
\(\sigma_t=\sum_{\pi^{-1}(t)}Q(t,u)\); only multiplicity at least three
remains unknown.  Equivalently this product is the character of
\(\operatorname{Res}(J_P,\Sigma)\), where
\(J_P=E_P/\operatorname{rad}E_P\) has degree \(\delta-r\) and
\(\Sigma(t)=\sigma_t\).  Each \(\sigma_t\) depends only on the first two
coefficients of the repeated-root factor of \(F(U,t)\), and equivalently is
a square-normalized matching sum of
\(Q(v_i)Q(v_j)-B(v_i,v_j)^2\) over chord endpoints.  The
earlier Euler-character norm does not determine this value-level trace:
replacing the weights by their constant signs reduces weighted covariance
tautologically to ordinary covariance.
The cross-direction trace is nevertheless explicit without fibrewise gcds:
if \(\Lambda_t(T)=1-(T-t)^{q-1}\), then
\[
 \Sigma(T)=\sum_{i<j}Q(t_{ij},u_{ij})\Lambda_{t_{ij}}(T).
\]
Substituting the conic Lagrange identity writes this entirely as a
square-normalized sum over endpoint Gram entries.  Reducing modulo \(J_P\)
produces a polynomial \(\Sigma_J\) of degree less than \(\delta-r\), and the
remaining conic character is exactly
\(\chi(\operatorname{Res}(J_P,\Sigma_J))\).
Intrinsically, \(J_P\) is the slope characteristic polynomial on the
second-excess module
\[
 M^{[1]}=A_{\rm node}/(B_{\rm dir}+UB_{\rm dir}),
 \qquad \dim M^{[1]}=\delta-r.
\]
Multiplication by the trace function \(\sigma\) on this module has
determinant \(\operatorname{Res}(J_P,\Sigma_J)\).  Quotienting by
\(B+UB+\cdots+U^dB\) similarly gives a canonical carrier for every higher
direction-multiplicity layer.
The projection collision energy has the exact uniform interpretation
\[
 \rho=\sum_t\binom{\mu_t}{2}
      =\sum_{d\ge0}\dim M^{[d]}
      =\sum_{d\ge1}d\,|\{t:\mu_t\ge d+1\}|.
\]
Hence the all-center collision identity is a trace identity for the full
Hilbert function of these reduced support layers; in particular
\(\delta\le\rho\le\binom{\delta+1}{2}\).  This generalizes the old
defect-two energies \(2,3\), while also showing precisely why that identity
still lacks the actual conic-value trace needed by the resultant.  It does
bound the open carrier sharply:
\(\deg J_P=\dim M^{[1]}\le\rho-\delta\).  Hence aggregate collision energy
above the all-double minimum bounds the total unresolved resultant dimension
across centers.
Since the resultant needs only trace values, not jets, its scalar input may
be reduced further modulo \(K_P=\operatorname{rad}J_P\).  The resulting
\(\Sigma_3\) has degree less than
\(|\{t:\mu_t\ge3\}|\), while
\(\operatorname{Res}(J_P,\Sigma_3)=
\operatorname{Res}(J_P,\Sigma_J)\).
This resultant vanishes exactly when some triple-or-higher fibre has
\(\sigma_t=0\).  If it is nonzero, its quadratic character is the product of
\(\chi(\sigma_t)\) only over odd multiplicities \(\mu_t\ge3\); even
multiplicities contribute squares.
The trace carrier itself is the split algebra
\(C_3=\mathbb F_q[T]/(K_P)\), and \(\Sigma_3\) has a direct degree-less-than-
\(\deg K_P\) Lagrange formula over triple directions, so no degree-\(q\)
interpolation is needed.  Factoring \(J_P=K_{\rm odd}L^2\) separates the
zero detector on \(K_P\) from the nonzero sign resultant on the smaller
odd-multiplicity support \(K_{\rm odd}\).
Dualizing the intercept filtration identifies \((M^{[d]})^\vee\) with edge
weights whose first \(d+1\) intercept moments vanish on every direction
matching; fibrewise these are the barycentric vectors
\(P(u_i)/G_t'(u_i)\).  Thus both saturated and nonsaturated carriers are
Reed--Solomon annihilator modules, coupled respectively by one split factor
and by the endpoint graph coloring.
Finally, writing the constant conic class as
\(Q(t,u_i)=\eta s_i^2\) makes weighted covariance congruent to the
orthogonal projector
\((\sum s_i^2)I-ss^{\mathsf T}\).  Hence zero trace is exactly isotropy of
the square-root edge vector on a direction matching; a structural proof
should retain any endpoint-coherent deck-sign law before squaring.
These signs live on a concrete surface: the twist
\(\mathscr X_\eta:z^2=\eta^{-1}Q_{\rm du}(T,U,W)\) is a smooth quadric
branched over the dual conic, every node has two rational deck-conjugate
lifts, and every arrangement line pulls back to a plane conic.  Thus each
endpoint edge is the deck pair of intersections of two lifted conics.  The
remaining trace theorem can be sought from divisor/incidence relations on
\(\mathscr X_\eta\), rather than from arbitrary square-root vectors.  On the
hyperplane conic above a direction \(t\), the arrangement divisor restricts
as twice the lifted repeated-node divisor plus the unmatched divisor, and
\(\sigma_t\) is \(\eta/2\) times the trace of \(z^2\) on that repeated
divisor.  Thus the final resultant is a norm of divisor traces in one pencil
of conics.  More sharply, summing the conic value over all endpoint-line
intersections produces a fixed polynomial \(L(T)\) of degree at most two.
If \(\Upsilon_3\) interpolates the trace on the unmatched residual divisor
over the triple-direction support, then
\[
 \Sigma_3\equiv(L-\Upsilon_3)/2\pmod {K_P}.
\]
Hence both the zero detector and the odd-multiplicity sign resultant reduce
to the complementary-divisor resultant of \(L-\Upsilon_3\).  The live
nonsaturated gate is now to control this unmatched-divisor trace from the
incidence of the lifted endpoint conics on the quadric pencil.  Algebraically,
if \(F_t=G_t^2H_t\), coefficient comparison shows that this trace uses only
the first two coefficients of \(H_t\), and writes them explicitly in terms
of the first two coefficients of \(F_t\) and \(G_t\).  This identifies the
divisor-trace and repeated-root subresultant routes without computing a full
fibre gcd.  Equivalently,
\(\nu_t=-\operatorname{Res}_{U=\infty}(Q_{\rm du}\,d\log H_t)\), while
\(\sigma_t\) uses \(G_t\); the factorization \(F_t=G_t^2H_t\) makes the
complementary trace law a logarithmic-residue identity on the direction
pencil.  The unmatched pullback must be taken scheme-theoretically: unlike
the repeated nodes, its points need not split over \(\mathbb F_q\).  The
quadratic fibre algebra nevertheless has trace \(2Q/\eta\).  Multiplicativity
also gives the complementary norm law
\[
 \operatorname{Res}(F_t,Q)=\operatorname{Res}(G_t,Q)^2
                            \operatorname{Res}(H_t,Q),
\]
so the unmatched norm square class is the value of the fixed endpoint
polynomial \(\Pi(T)=\prod_iQ(T,y_i-Tx_i)\).  Its quadratic factors are
typed: for the line vector \(v_i=(x_i,1,-y_i)\),
\(\operatorname{disc}_TQ(T,y_i-Tx_i)=-4Q_{\rm pr}(v_i)\).
Hence the complementary norm retains the original internal/external mixture
rather than discarding it.  When \(\Pi\) is squarefree, the product
discriminant formula further gives
\([\operatorname{disc}\Pi]=\prod_i[-Q_{\rm pr}(v_i)]\), since all pairwise
factor resultants occur squared.
Finally, the scalar value polynomial
\(\mathfrak F(V,T)=\prod_i(V-Q(T,y_i-Tx_i))\) factors on every covered
direction as \(\mathfrak G_t(V)^2\mathfrak H_t(V)\); the first coefficients
of \(\mathfrak G_t\) and \(\mathfrak H_t\) are \(-\sigma_t\) and
\(-\nu_t\).  Each value difference splits as
\[
 q_i-q_j=((y_i-y_j)-T(x_i-x_j))
 \bigl((b-c(x_i+x_j))T+c(y_i+y_j)+e\bigr).
\]
Hence
\(\operatorname{disc}_V\mathfrak F\doteq
(T^q-T)^2E_P^2\Theta_Q^2\): value collisions decompose into the ordinary
chord cover and a conic-centered mirror cover.  Separating these two forced
square divisors is now an explicit alternative route to \(\Upsilon_3\).
The mirror square is intrinsic:
\[
 \operatorname{Res}_U(F,F^\iota)\doteq\Delta_Q\Theta_Q^2,
 \qquad
 \Theta_Q^2\doteq
 \operatorname{disc}_V(\mathfrak F)/\operatorname{disc}_U(F).
\]
Away from \(\Theta_Q=0\), the matched-value factor is exactly
\(\gcd_V(\mathfrak F,\partial_V\mathfrak F)\).  Thus the triple-direction
support splits into a transverse part, where \(\Sigma_3\) is extracted by
ordinary value-polynomial subresultants, and the explicit mirror-overlap
support \(\gcd(K_P,\Theta_Q)\), where accidental value collisions can occur.
Geometrically the mirror is the quadric involution
\[
 \jmath(T,U,W,z)=
 \left(T,-U-\frac{bT+eW}{c},W,z\right),
\]
which preserves \(Q_{\rm du}\), fixes every direction conic, and commutes
with the deck involution.  The reflected arrangement \(F^\iota\) is exactly
\(\jmath(F)\).  Thus ordinary nodes and mirror collisions are respectively
the off-diagonal intersections \(D_i\cap D_j\) and
\(D_i\cap\jmath(D_j)\) inside one Klein-four incidence geometry.  On line
vectors, \(v_i\mapsto v_i^\iota=(b/c-x_i,1,e/c+y_i)\) preserves
\(Q_{\rm pr}\), so the mirror intersections have the same Lagrange--Gram
formula with \(B(v_i,v_j)\) replaced by \(B(v_i,v_j^\iota)\), without
changing the endpoint type vector.  Decomposing the primal quadratic space
into the \(1+2\) eigenspaces of this reflection shows more:
the ordinary and mirror Lagrange-numerator matrices differ by
\(4(G_+\circ G_-)\), a matrix of rank at most two.  The remaining comparison
must retain the squared affine normalization weights.

### \(q=53\): type-uniform critical core

For either deleted-point type, degree-nine node separators exclude covariance
ranks zero and one; nonsingular covariance gives

\[
 \operatorname{rank}M=2,
 \qquad \nabla\mathcal Z(c)=0,
 \qquad \partial_i\partial_j\mathcal Z(c)\ne0\ (i\ne j). \tag{I}
\]

External deletion is impossible before the covariance split.  Its unique
\(UV=2\) conic normal form has exactly 230 normalized eleven-line stars with
all 55 nodes internal and no triple concurrency.  Those leaves are the full
covariance-free geometric list, not merely the aligned split list, and none
has even one complete center among the fifteen required internal directions;
their best projections span at most 45 of 53 fibres.  This closes the seven
anisotropic rows, all disjoint-root split rows, the one-shared-root case, and
the aligned split case simultaneously.  Authority:
`notes/2026-08-09-c756-external-deletion-all-covariance-closure.md`.

### \(q=47,k=12\): complete negative classification

The residue-class sign must be changed from the \(q=53\) geometry:
\(\chi(-1)=-1\), so internal split-model nodes satisfy
\(\chi(UV-5)=-1\).  With that corrected predicate, external deletion has
exactly 22 normalized mixed secant/passant stars.  Every leaf has
\(E_9\ne0\), against the twelve-center interpolation window
\(E_9=E_{10}=E_{11}=0\); independently, no leaf has one complete center.
If there is no external point, all polar lines are passants, and the genuine
norm-normalized all-passant row has no eleven-line geometric star.  Therefore
\[
 \boxed{\text{no conic-filling }12\text{-arc exists over }\mathbf F_{47}.}
\]
This does not cover \(k>12\).  Authority:
notes/2026-08-09-c756-q47-k12-complete-closure.md.

### \(q=49,k=12\): complete negative classification

Native \(\mathbf F_{49}\) geometry gives exactly 22 normalized
external-deletion mixed-type stars, all with five secants and six passants.
Every leaf violates the first forced divided elementary identity
\(E_7=0\), and independently none has one complete center.  If all arc
points are internal, the anisotropic all-passant model has 600 states but no
eleven-line geometric star.  Hence
\[
 \boxed{\text{no conic-filling }12\text{-arc exists over }\mathbf F_{49}.}
\]
Together with the \(q\le43\), \(q=47\), and \(q=53\) results and the bound
\(55\ge q+2\), this closes \(k=12\) over every finite field.  Authority:
notes/2026-08-09-c756-q49-and-global-k12-closure.md.

### \(q=53,k=12\): complete negative classification

If no point is external, all twelve polar lines are passants.  The two
covariance-free conic offset classes have respectively zero and 44 normalized
eleven-line stars.  Every one of the 44 has zero complete centers among the
sixteen required directions; each center projection spans between 36 and 43
of the required 53 fibres.  Thus the all-internal branch also fails before
covariance, and
\[
 \boxed{\text{no conic-filling }12\text{-arc exists over }\mathbf F_{53}.}
\]
This does not cover \(k>12\), whose defect and interpolation window differ.
Authority: `notes/2026-08-09-c756-q53-k12-complete-closure.md` and its
exact script/certificate bundle.

There is also a shorter aggregate certificate for the 44 leaves.  If
\(\rho(c)\) is projection collision energy, pair-direction double counting
gives
\[
 \sum_{c\ {\rm internal}}\rho(c)
 =\#\{\{X,Y\}:XY\cap r_0\text{ is internal}\}.
\]
For every leaf, the eleven used centers contribute 657 and the sixteen
missing centers contribute 290.  A complete defect-two center has
\(\rho\in\{2,3\}\), so simultaneous completeness would give at most 48,
contradicting 290.  The common diagonal character sum \(-86\) and four-line
histogram \((48,138,118,26)\) are exact across all four normalized dihedral
orbits but presently have no symbolic all-\(q\) derivation.  Authority:
notes/2026-08-09-c756-star-collision-character-identity.md.

### \(q=59,61,k=13\): complete negative classification

At \(q=59\), the 30 normalized mixed seed rows and 15 present all-passant
seed rows have no twelve-line geometric star after respectively 187,764,531
and 3,042,991 search nodes.  At \(q=61\), the all-passant row again has no
star; the mixed row has exactly 96 normalized stars, all of type three
secants plus nine passants, and every one fails \(E_6=0\).  None of those 96
has even one complete center.  Hence no conic-filling \(13\)-arc exists over
any finite field.  Authority:
notes/2026-08-09-c756-global-k13-closure.md.

### \(q=61,67,k=14\): complete negative classification

At q=61 none of the 96 exact twelve-line mixed stars admits a compatible
thirteenth line, and the all-passant row has no twelve-line star.  At q=67,
the complete mixed search visits 946,250,059 recursion states and has no
thirteen-line geometric star.  The all-passant search has exactly 92 stars;
all 92 first fail \(E_{12}=0\), and none has a complete unused center.  These
are the first two closed fields in the four-field k=14 direction-bound
frontier.  Authorities:
notes/2026-08-09-c756-k14-ledger-q61-closure.md and
notes/2026-08-09-c756-q67-k14-closure.md.

### \(q=71,73,k=14\): complete negative classification

At q=71, the complete anisotropic all-passant search has no thirteen-line
star.  The mixed search visits 2,570,632,814 recursion nodes and returns 39
geometric stars; all 39 first fail the forced equation \(E_8=0\), and none
has a complete center.  At q=73, the all-passant search has no star in
38,310,405 states, while the independently implemented mixed search has no
star in 4,198,162,536 states.  Together with q=61,67, this closes \(k=14\)
over every finite field.  Authorities:
`notes/2026-08-10-c756-q71-k14-all-passant-closure.md`,
`notes/2026-08-10-c756-q71-k14-mixed-closure.md`,
`notes/2026-08-10-c756-q73-k14-all-passant-closure.md`, and
`notes/2026-08-10-c756-q73-and-global-k14-closure.md`.

## Ordered next actions

1. Do not open a \(k=15\) census.  Treat q=67,71,73 only as theorem-design
   data for the all-\(q\) branches.
2. For saturated-internal configurations, prove the special-direction conic
   lemma over proper extension fields by analyzing the nonlinear Cartier
   system \(\operatorname{pr}_{<0}(R^{j-1}F^j)\).  Classify the common
   kernel of the semilinear digit tower \(j=p^a\), then analyze the mixed
   conic--ghost non-shadow map: \(j=2\) unless \(p=5\), where one must use
   \(j=3\).  In root coordinates its normal rows are weighted
   Reed--Solomon evaluation rows; for \(p\ge7\) its quadratic part is the
   diagonal Gram pencil
   \(\mathsf E_R^{\mathsf T}\operatorname{diag}(w_iP(x_i))\mathsf E_R\)
   restricted to \(\ker\mathbb M_R\).  The Lucas-visible rows always contain
   the Frobenius-strided sequence \(0,P_0,2P_0,\ldots\), with \(P_0\) the
   least \(p\)-power above \(2j_0\); its Vandermonde minor forces every
   surviving nonshadow word to have support at least
   \(2+\lfloor(n-2j_0-2)/P_0\rfloor\).
   Independently, the common divisor \(\gcd(R,G)\) divides every flagged
   remainder \(P_j\), so the top power rung forces every nonzero Cartier
   kernel word to have support at least \(n-2q/p\) for \(p\ge5\), and at
   least \(q/9+1\) in characteristic three.
   Prove that the resulting carry-controlled multiplication flag forces
   \(\deg H_2\le2\); or
   classify the equivalent completely split lacunary norm
   pair; do not retry translations of the affine coordinate.
3. For the nonsaturated branch, prove the masked Redei missing-direction
   theorem for arbitrary defect through the \(\delta\)-dimensional excess
   node module.  Evaluate its degree-\(\delta-r\) endpoint-pair resultant
   \(\operatorname{Res}(J_P,\Sigma_3)\) by controlling the unmatched-divisor
   trace \(\Upsilon_3\) in
   \(\Sigma_3=(L-\Upsilon_3)/2\) using the lifted endpoint conics on
   \(\mathscr X_\eta\), then
   compare it with the constant conic square class.

## Stop rules

Do not:

- assume a nonsaturated arc is all-internal or its polar arrangement
  all-passant, or conversely discard the type-uniform star identities merely
  because the arrangement is mixed;
- call \(q=53\) the first open field, or infer general \(\delta\) from defect
  two without a propagation theorem;
- reopen the closed \(q=53,k=12\) layer without identifying a normalization
  or projection-completeness flaw in its exact bundle;
- reopen the closed \(q=47,k=12\) layer with the unchanged \(q=53\)
  node-character sign;
- replace the divided \(q=49\) identity \(E_7=0\) by the Frobenius-tautological
  power sum \(P_7=0\);
- infer any \(k=13\) coefficient window from \(k=12\); the exact table starts
  only at \(E_8\) for \(q=59\) and \(E_6\) for \(q=61\);
- rerun the closed aligned state graph, generic 11-variable elimination, or
  an unchanged quartic character bound;
- retry normalized one-variable selectors, their first two slices,
  unweighted subresultants, local diagonal-sign classification, Smith torsion,
  raw cardinality/parity/defect averaging, or abstract matching-frame
  contractions without a new global identity;
- classify arbitrary near transversals without retaining star realization;
- claim that counting in general cannot close the theorem merely because
  untyped low moments stalled;
- cross the degree-16 mask boundary blindly.  A targeted degree-16
  cross-center identity is allowed if its lost-information role is explicit;
- edit a manuscript under C756.

## Evidence boundaries

- The \(q\le43\) exhaustive classification has internal cross-checks; a wholly
  independent uncovered-set replay extends only through \(q\le19\).
- The saturated-external human proof has a successful cold read; C894 owns its
  remaining external-specialist safeguard.
- The \(q=53\) all-passant aligned certificate has independent formula-level
  invariant checks, not a second independent exhaustive search implementation.
- Exact all-type searches cover \(k=12\) at \(q=47,49,53\), with independent
  formula-level checks but not second independent exhaustive enumerators.
  Higher sizes remain separate.

## Current assessment

- Saturated-external: closed.
- Saturated-internal: sharply constrained but open at global coherence.
- Nonsaturated, arbitrary type: the first-size point/type/window ledger is
  exact, and its character total has the all-center trace/norm law (H');
  \(k=12\) is closed globally, but higher sizes are open.  The direction and
  intercept excess is compressed canonically into a \(\delta\)-dimensional
  module whose slope characteristic polynomial is \(E_P\).
- \(q=47,k=12\): closed exactly for every point type.
- \(q=49,k=12\): closed exactly for every point type.
- \(q=53,k=12\): closed exactly for every point type and covariance class.
- \(k=13\): closed exactly over every finite field; at \(q=61\), all 96
  geometric mixed leaves fail \(E_6=0\), and the other remaining rows have no
  twelve-line star.
- \(k=14\): q=61 closes by exact nonextension; q=67 has no mixed star and
  all 92 all-passant stars fail \(E_{12}\); at q=71 all 39 mixed stars fail
  \(E_8\), and q=73 has no geometric star of either type.  The layer is
  closed over every finite field.
- Saturated-internal: coherent supports are dual 3-nets; all prime fields
  \(q>5\) are excluded structurally.  Proper extension fields remain at the
  special-direction conic lemma, now reduced to the affine-stable
  \(r\equiv0,-1\pmod p\) Laurent ghosts and their higher-power coupling.
- Near-term full all-\(k\) proof odds remain below the former 20--25% estimate:
  the higher-size and saturated-internal gates remain; a counterexample
  remains live.

## Durable pointers

- Current audit:
  `notes/2026-08-09-c756-all-k-status-assumption-audit.md`.
- Character-weighted all-center trace/norm identity:
  `notes/2026-08-09-c756-all-center-resultant-norm.md`.
- q=47 quadratic-through-octic partition carrier:
  `notes/2026-08-09-c756-q47-octic-carrier.md`.
- Complete q=47,k=12 closure:
  `notes/2026-08-09-c756-q47-k12-complete-closure.md`.
- Complete q=49,k=12 and global k=12 closure:
  `notes/2026-08-09-c756-q49-and-global-k12-closure.md`.
- k=13 ledger and q=47,49,53 geometric closure:
  `notes/2026-08-09-c756-k13-ledger-low-field-closure.md`.
- Global k=13 closure at q=59,61:
  `notes/2026-08-09-c756-global-k13-closure.md`.
- k=14 ledger and q=61 extension closure:
  `notes/2026-08-09-c756-k14-ledger-q61-closure.md`.
- q=71 mixed closure:
  `notes/2026-08-10-c756-q71-k14-mixed-closure.md`.
- q=73 and global k=14 closure:
  `notes/2026-08-10-c756-q73-and-global-k14-closure.md`.
- Coherent dual-3-net reduction and prime-field theorem:
  `notes/2026-08-10-c756-coherent-dual-three-net.md`.
- Extension-field complementary-factor and Frobenius-ghost reduction:
  `notes/2026-08-10-c756-dual-net-frobenius-ghost-reduction.md`.
- Nonsaturated excess-node module:
  `notes/2026-08-10-c756-nonsaturated-excess-node-module.md`.
- External-deletion all-covariance closure:
  `notes/2026-08-09-c756-external-deletion-all-covariance-closure.md`.
- Complete \(q=53,k=12\) closure:
  `notes/2026-08-09-c756-q53-k12-complete-closure.md`.
- Mixed-type equation ledger:
  `notes/2026-08-09-c756-nonsaturated-point-type-ledger.md`.
- External-deletion aligned split closure:
  `notes/2026-08-09-c756-aligned-split-mixed-closure.md`.
- Universal and bounded foundation:
  `notes/2026-08-01-c756-all-k-conic-filling.md`.
- Saturated-internal foundation:
  `notes/2026-08-01-c756-saturated-internal-branch.md`.
- Nonsaturated direction quotient:
  `notes/2026-08-01-c756-nonsaturated-direction-reduction.md`.
- All-internal premise of the defect-two star model:
  `notes/2026-08-09-c756-defect-two-star-near-transversal.md`.
- Latest conditional chain:
  `notes/2026-08-09-c756-tt-star-moment-collapse.md`,
  `notes/2026-08-09-c756-ej-antipodal-fibres.md`,
  `notes/2026-08-09-c756-ej2-torus-contraction.md`,
  `notes/2026-08-09-c756-ej3-elliptic-overlap-squeeze.md`, and
  `notes/2026-08-09-c756-aligned-critical-closure.md`.

Historical method details remain in dated C756 reports, not this card.
