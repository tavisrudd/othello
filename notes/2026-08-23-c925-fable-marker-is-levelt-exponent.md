# The cubic marker is a Levelt exponent class, and Iritani's comparison preserves it

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

## 1. Claim

The exact cubic marker \(\delta^\sharp=4/9\) of a rank-two nilpotent block is
equivalent to the statement that the block's Levelt exponents at \(z=0\) are
\(\{1/6,\,5/6\}\bmod\mathbf Z\); the unmarked values \(\delta^\sharp\in\{0,4\}\)
are the class \(\{1/2,1/2\}\).  Exponent classes of a regular-singular block are
invariant under any isomorphism of \(z\)-connections over any coefficient field
of characteristic zero, and Iritani's decomposition \(\Psi\) is such an
isomorphism.  Hence the marker of a correction block is the marker of a block
of the centre's own quantum D-module, computed in the centre's own lattice.
No transport of lattice, grading, first gauge, or selected basis is required.

## 2. Evidence

**The marker from the audit script.**  In
`notes/cubic-threefolds-tasks/c924-finite-cubic-check.py`, the constant
change of basis \(c\) puts \(c_1\star=2(H\star)\) into Jordan form
\(J=\operatorname{diag}(6r,-6r,N)\), \(N=\bigl(\begin{smallmatrix}0&2\\0&0\end{smallmatrix}\bigr)\),
and conjugates the grading to \(D=c^{-1}\mu c\).  The first Sylvester step
\(D+[J,A_1]=\) block-diagonal gives the raw residue of the \(u=0\) block as
\(\operatorname{diag}(-19/18,\ 19/18)\) — **traceless**.  The "modified
residue" is this block plus \(N\), plus the second-order lower-left term
\(-8/81\), minus \(E_{22}\):
\[
\begin{pmatrix}-19/18&2\\-8/81&1/18\end{pmatrix},\qquad
\text{eigenvalues }-1/6,\ -5/6 .
\]
The subtraction of \(E_{22}\) is the elementary modification that converts the
nilpotent-leading-term block into an honest regular-singular block; its
eigenvalues are the Levelt exponents, well defined modulo \(\mathbf Z\), and
\(\delta^\sharp=(1/6-5/6)^2=4/9\) is their squared difference in the
trace-\(-1\) normalization.  The two strict orientations of the unmarked
case, \((-1/2,-1/2)\) and \((1/2,-3/2)\), are two integer representatives of
the single class \(\{1/2,1/2\}\); that is why the qualitative predicate
\(\delta^\sharp\ne0\) failed (it saw \(4\)) and the exact one did not.

**\(\Psi\) commutes with the \(z\)-direction.**  Iritani, arXiv:2307.13555v3,
Theorem 5.18: \(\Psi\) is an isomorphism of
\(\mathbf C[z]((q^{-1/s}))[[Q,\tilde\tau]]\)-modules
\(\mathrm{QDM}(\tilde X)^{la}\to\tau^*\mathrm{QDM}(X)^{la}\oplus\bigoplus_j\varsigma_j^*\mathrm{QDM}(Z)^{la}\)
with (1) "\(\Psi\) commutes with the quantum connection", where the quantum
connection is the full set \(\nabla_{\tau^i},\nabla_{z\partial_z},\nabla_{\xi Q\partial_Q}\)
with \(\nabla_{z\partial_z}=z\partial_z-z^{-1}(E\star_\tau)+\mu\) (his (2.3)/§2.3,
text line 736 of the cached extraction); and (3) the centre component is
homogeneous of degree \(-r\), which shifts both exponents of a block by the
same constant and does not change the class of their difference.  A
\(\mathbf C[z]\)-linear isomorphism commuting with \(z\partial_z\) extends to
\(K((z))\) for \(K\) the fraction field of the coefficient ring, and the
Levelt–Turrittin decomposition and the exponents of its regular part are
invariants of that extended isomorphism.

**Isomonodromy.**  The quantum connection is flat in \((\tau,Q,z)\), so the
formal type at \(z=0\) — exponential factors, Jordan types, Levelt exponents —
is constant along any parameter path on which the eigenvalue configuration of
\(E\star\) keeps its combinatorial type (Jimbo–Miwa–Ueno; Sabbah,
*Isomonodromic deformations and Frobenius manifolds*, Ch. VI).  The correction
summand is \(\varsigma_0^*\mathrm{QDM}(Z)\): the centre's big quantum
connection at the formal parameter
\(\varsigma_0=-q+\pi i\rho_Z+O(q^{-1})\) with Novikov substitution
\(Q_Z^d\mapsto Q^{\iota_*d}q^{-\rho_Z\cdot d}\).  The \(-q\) term is a unit
shift (scalar on eigenvalues), the \(\pi i\rho_Z\) term a sign rescaling of
Novikov variables by the divisor equation; only the \(O(q^{-1})\) bulk terms
deform the block structure, and they do so along a formal curve through the
centre's divisor-shifted small point.

## 3. What this changes

1. **The calibration gate dissolves.**  Every open "source" obligation in the
   card — native-order charts, affine-Bruhat bound, marked Rees port,
   primitive valuation, cocharacter-quotient descent — was needed to recover
   a *lattice-dependent* normalized residue discriminant from generic Laurent
   data.  The loop-stabilizer consumer needs only the exact predicate
   "marked", which is the exponent class, which is lattice-independent and
   \(\Psi\)-invariant.  The parabolic shear, the \(A_d/A_s\) pair, the
   \(1/6\)-leakage chart and the \(x^3=qh^{3k}\) family are countermodels to
   abstract provider hypotheses; none is the quantum connection of a threefold,
   and under this reformulation the provider is the centre's own connection.
2. **The \(m=2\) obligation becomes a statement about threefolds.**  Let \(Z\)
   be a connected smooth projective threefold appearing as a codimension-two
   centre.  Over the coefficient field of the correction summand, the
   transported source loop is an integral cocharacter of \(Z\)'s own Novikov
   torus (ledger §8, §12.1).  Required: the big quantum connection of \(Z\)
   along the formal bulk curve \(\varsigma_0\) has no three-cycle, under that
   cocharacter, of rank-two nilpotent blocks with exponent class
   \(\{1/6,5/6\}\).  By isomonodromy this is decided at the small point of
   \(Z\) on the locus where the block persists, and at a confluence by the
   Stokes data of the merging pair (§4).
3. **Consumer interface.**  `ExactCubicPoint` should be retyped as (rank two,
   \(N\ne0\), exponent class \(\{1/6,5/6\}\)).  Its invariance under
   connection isomorphism is a one-line Levelt statement and replaces the
   whole `RankSixRecurrenceCertificate.Calibration` structure as the boundary
   with geometry.  Not yet done in Lean (needs the guarded window).

## 4. The residual subtlety, and where the Serre-functor dictionary enters

Isomonodromy is silent at confluences.  A marked block over the coefficient
field may, at the centre's small point, be a sub-block of a larger nilpotent
block, or two rank-one sheets of the small point may merge along
\(\varsigma_0\) into a rank-two nilpotent block.  In the second case the
exponent class of the merged block is determined by the Stokes multipliers of
the merging pair.  If the Stokes matrix is the Euler form of an exceptional
pair (Gamma conjecture II, conjectural), \(\chi=\bigl(\begin{smallmatrix}1&a\\0&1\end{smallmatrix}\bigr)\)
gives \(S=\chi^{-1}\chi^{T}\) of trace \(2-a^2\), so the merged class is
\(e=0\) (\(a=0\)), \(e=1/6\) (\(a=\pm1\)), \(e=1/2\) (\(a=\pm2\)), and nothing
else.  For a non-exceptional rank-two piece the class is
\(\operatorname{tr}S\in\{2,1,0,-1,-2\}\leftrightarrow e\in\{0,1/6,1/4,1/3,1/2\}\);
Bernardara–Macrì–Mehrotra–Stellari's numerical Euler form on
\(\mathcal Ku(Y_3)\), \(\chi=\bigl(\begin{smallmatrix}-1&-1\\0&-1\end{smallmatrix}\bigr)\),
gives \(S=\bigl(\begin{smallmatrix}0&1\\-1&-1\end{smallmatrix}\bigr)\), trace
\(1\), eigenvalues \(e^{\pm\pi i/3}\): exactly the cubic's class.  So the
classification experiment proposed earlier (compute \(e\) for
\(V_{12},V_{14},V_{16},V_{18},V_2,V_{10}\)) is the same question as the
confluence rule, now with a precise prediction for each row.

## 5. Hypotheses to carry explicitly

* H-A: the marked blocks consumed by `LoopStabilizerPath` are blocks over the
  coefficient field of the summand (they are: C924 primitive factors).
* H-B: Levelt exponents of the regular part are invariant under
  \(K((z))\)-isomorphism commuting with \(z\partial_z\) — classical, to be
  stated in the packet as the new consumer lemma.
* H-C: along \(\varsigma_0\) the eigenvalue configuration is constant on an
  open formal locus; at confluences the exponent class is read from Stokes
  data.  This is the one place a genuinely new input (the Stokes/Euler
  dictionary or a direct computation on \(Z\)) is still needed.

## 6. Exponent-class tool and first data

`notes/cubic-threefolds-tasks/c925-fable-levelt-exponent-tool.py` takes
\(U=c_1\star\) and the grading matrix in any basis, performs the Jordan
reduction, the zero-diagonal-block first gauge, the second-order diagonal
block, checks that the first-order \((2,1)\) entry of each \(J_2\) block
vanishes, applies the elementary modification \(\operatorname{diag}(1,z)\),
and returns the residue exponents and \(\delta^\sharp\).  It reproduces the
audit script on the cubic.  Results
(`c925-fable-levelt-exponent-tool-output.txt`):

| variety | blocks | exponents | class | \(\delta^\sharp\) |
|---|---|---|---|---|
| cubic threefold | \(J_2\) at \(u=0\) | \(-1/6,-5/6\) | \(\{1/6,5/6\}\) | \(4/9\) |
| \(\mathbf P^2\times C_g\), \(g=2,3\) | three \(J_2\), a 3-cycle | \(-1/2\) double | \(\{1/2,1/2\}\) | \(0\) |
| \(\mathbf P(E)\to C_g\), \((g,\deg E)=(2,1),(3,5)\) | three \(J_2\), a 3-cycle | \(-1/2\) double | \(\{1/2,1/2\}\) | \(0\) |
| curve summand \(C_g\) (blow-up centre), \(g=0,2\) | one \(J_2\) | \(-1/2\) double | \(\{1/2,1/2\}\) | \(0\) |

The \(\mathbf P(E)\) rows use the projective-bundle quantum relation
\(\xi^3+c_1(E)\xi^2=q\) (fibre-line class; no other rational curves for
\(g\ge1\)), and \(c_1=3\xi+\pi^*(c_1(C)+c_1(E))\); the substitution
\(\xi'=\xi+c_1(E)/3\) makes them identical to the product case, as the output
confirms.  Every three-cycle of rank-two blocks on a threefold computed so far
has the unmarked class, and every curve-type block has it too.

Replay: `uv run --with sympy python3 c925-fable-levelt-exponent-tool.py`.
SHA-256: script
`3f2b836ac3ccec79da92bd69f506f3abc3fbfb2941b0a5f3a8abc2c7c6b6c20a`, output
`ab32eaf611c1435fb32aae2fb8b5858ef7c039bd58d391999570e095e86e4fd6`.  No
independent second implementation; the cubic row is the cross-check against
`c924-finite-cubic-check.py`.

## 7. Next

1. Replace the card's `Next` item 1 by the threefold statement of §3.2; mark
   the native-order and Rees-port items as superseded.
2. Compute \(e\) at the small point for the Mori–Mukai threefolds with
   \(b_2\ge2\) that can carry a three-cycle of rank-two blocks (P²-bundles over
   curves, conic bundles over P² with symmetric discriminant, P²×P¹ blow-ups):
   the prediction is \(e=1/2\) or \(0\) throughout.
3. Retype `ExactCubicPoint` in Lean.
