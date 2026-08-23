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

## 6b. Picard-rank-one test of the Serre-functor dictionary

`c925-fable-rank-one-exponents.py` builds the quantum D-module of a
Picard-rank-one Fano threefold from its quantum period: many terms of the
unregularized period from the closed formulas in Coates–Corti–Galkin–Kasprzyk
(arXiv:1303.3288v3, §§11–14, Theorem F.1 instances; each checked against the
printed regularized series), the order-four operator in \(\theta=s\,d/ds\)
guessed from forty terms (one-dimensional nullspace with at most twenty-five
unknowns), the companion matrix of \(\Theta=zq\partial_q\) on the cyclic basis
\(v_k=\Theta^k1\), and the flat-section system
\(z^2y'=(rC(q,z)-z\operatorname{diag}(k-3/2))\,y\) from
\(\nabla_{z\partial_z}v_k=(k-3/2)v_k-(r/z)v_{k+1}\).  The cubic threefold,
run through the same companion construction from its known product, again
gives \(\{1/6,5/6\}\); that validates the basis change.

| \(X\) | \(h^{1,2}\) | Kuznetsov component | predicted class | computed block | class | \(\delta^\sharp\) |
|---|---|---|---|---|---|---|
| cubic \(V_3\) | 5 | \(\mathcal Ku\), \(S^3=[5]\) | \(\{1/6,5/6\}\) | \(J_2\) at \(u=0\) | \(\{1/6,5/6\}\) | \(4/9\) |
| \(V_{14}\) | 5 | \(\simeq\mathcal Ku(V_3)\) (Kuznetsov) | \(\{1/6,5/6\}\) | \(J_2\) at \(u=-4\) | \(\{1/6,5/6\}\) | \(4/9\) |
| \(V_{12}\) | 7 | \(D^b(C_7)\) | \(\{1/2,1/2\}\) | \(J_2\) at \(u=-5\) | \(\{1/2,1/2\}\) | \(0\) |
| \(V_{10}\) | 10 | Enriques-type, \(S=\tau[2]\) | \(\{0,0\}\) (numerically unipotent) | \(J_2\) at \(u=-6\) | \(\{0,0\}\) | \(1\) |
| \(V_2\) | 52 | rank three | — | rank-three generalized eigenspace | out of scope | — |

Every prediction is met.  \(V_{14}\) is the decisive row: a different Fano
threefold (index one, genus eight) whose only relation to the cubic is the
equivalence of Kuznetsov components, and its block carries the cubic's class
exactly.  \(V_{10}\) shows a third class, \(e=0\), again the one its
component's numerical Serre functor predicts.  The exponent class is therefore
a categorical invariant on all tested rows: the marker reads the numerical
Serre functor of the non-exceptional component.

Replay: `uv run --with sympy python3 c925-fable-rank-one-exponents.py`
(about four minutes).  SHA-256: script
`84f6bfb356f77a2b5cc9e48dcc3650183408083635013fb96af16eb608dae2b9`, output
`636619c2884a0c0971686a5099b0286214bff161329d8fea5f75a21d4cdf07b4`.  \(V_{16}\)
and \(V_{18}\) (components \(D^b(C_3)\), \(D^b(C_2)\); predicted
\(\{1/2,1/2\}\)) need the general Theorem F.1 formula for \(\mathrm{Gr}(3,6)\)
and \(\mathrm{Gr}(5,7)\), which the cached extraction garbles; their period
sequences in the Fanosearch database would do.

## 6c. Persistence of the marked block along Iritani's bulk curves (H-C)

Iritani's shifts are genuine bulk deformations: at \(\tilde\tau=0\),
\(\tau(0)|_{Q=0}\in q^{-1}H^*(X)[q^{-1}]\) and
\(\varsigma_j(0)|_{Q=0}\in-(r-1)\lambda_j+h_{Z,j}+q^{-1/(r-1)}H^*(Z)[q^{-1/(r-1)}]\)
(arXiv:2307.13555v3, (5.30) and the display before it).  So the blocks of a
summand over its coefficient field are the blocks of the big quantum
connection of \(X\) (or \(Z\)) along a formal curve through the small point,
and the marker is a field-generic object only if the \(J_2\) survives that
deformation.

*Hertling–Manin–Teleman*, arXiv:0803.2769 (cached 2026-08-23, sha256
`f54acf28…`), strengthening Bayer–Manin 1.8.1: if the **even** quantum
cohomology of \(V\) is generically semisimple then \(V\) has no odd
cohomology.  The cubic threefold has \(b_3=10\), so its even big quantum
cohomology is nowhere semisimple.  Its rank is four and the two sheets
\(\pm\sqrt{108q}\) are simple at the small point, hence simple on an open set;
the remaining rank-two factor is therefore non-reduced at every point: the
\(J_2\) persists along every bulk curve, and by isomonodromy its class is
\(\{1/6,5/6\}\) everywhere.  **H-C holds for the cubic factor.**

For \(B\times\mathbf P^2\) at the first edge: the three marked blocks are
permuted by the \(Q_{\mathbf P^2}\)-monodromy, which commutes with the
\(q^{-1}\)-shift, so they split or persist together; all three splitting would
make the summand semisimple at a point of the Frobenius manifold of
\(B\times\mathbf P^2\), which has odd cohomology — excluded by HMT.  At later
vertices the same conjugacy gives all-or-nothing for the source triple, but
HMT alone does not exclude the non-semisimple part migrating to an earlier
correction block; that residual is now stated precisely as H-C.

*Abstract confluence rule.*  For a rank-two family
\(z^2Y'=(U(\varepsilon)+zA_1+\dots)Y\) with \(U(0)\) nilpotent and
\(U(\varepsilon)\) of distinct eigenvalues, the local monodromy of the
two-dimensional system is constant in \(\varepsilon\): for
\(\varepsilon\ne0\) it is \(S_-S_+=\bigl(\begin{smallmatrix}1+ss'&s\\s'&1\end{smallmatrix}\bigr)\)
(trivial formal monodromy, Stokes multipliers \(s,s'\)); at \(\varepsilon=0\)
it is conjugate to \(e^{2\pi iR}\) with exponents \(\pm e\).  Hence
\(2+ss'=2\cos2\pi e\), and with integral Stokes data
\(ss'\in\{0,-1,-2,-3,-4\}\leftrightarrow e\in\{0,1/6,1/4,1/3,1/2\}\).  For an
exceptional pair \(s=-s'=\pm a\) this is the Euler-form list of §4.  This is
the mechanism behind the table of §6b; applying it to an actual quantum
connection needs the rank-two piece to be a sub-local-system on the punctured
\(z\)-disc, which is exactly the non-semisimple Gamma-II content.

## 6d. H-C sharpened: the whole gate is now "no splitting along Iritani's curves"

The edge relation at \(\tilde\tau=0\) reads: the small-quantum block ledger of
\(\tilde X\) over its generic field equals the ledger of \(X\)'s big quantum
connection along the bulk curve \(\tau(0)=q^{-1}[Z]+O(q^{-2})\), joined with
\(Z\)'s along \(\varsigma_0\) (whose divergent part is scalar+divisor only,
property (6)).  The bulk curve cannot be removed: it is how the blow-up's
small quantum cohomology sees the base's.  By semicontinuity of Jordan type,
the only discrepancy between \(X\)'s ledger at its bulk origin and along the
curve is **splitting** of a \(J_2\) into two simple sheets.  If a marked block
split at some edge, the marker would silently leave the telescope and the
endpoint comparison with \(\mathbf P^5\) would say nothing.  Hence the entire
reformulated \(m=2\) gate is:

> **H-C (final form).**  Along Iritani's bulk curves, marked
> (\(\{1/6,5/6\}\)) blocks do not split, and a threefold centre's correction
> summand contributes no marked three-cycle.

Progress on the first half:

* **Persistence criterion (proved).**  At any vertex where the origin
  ledger's non-semisimple part is exactly the source triple, the triple
  persists: it splits all-or-nothing (the transported loop permutes the three
  blocks and commutes with the \(q^{-1}\)-shift), and all-split would make a
  bulk point of that variety semisimple, contradicting Hertling–Manin–Teleman
  since every vertex variety has \(b_3\ge b_3(B)=10\).  This covers the source
  vertex and every vertex before the first curve or threefold centre.
* **After a curve centre** the origin ledger also contains unmarked
  \(\{1/2,1/2\}\) blocks, and HMT alone no longer forces the triple (rather
  than the curve blocks) to carry the non-semisimplicity.  Two ways to close:
  1. *Stokes obstruction:* a splitting pair limiting on a \(J_2\) of class
     \(e\) must carry mutual Stokes data with \(ss'=2\cos2\pi e-2\ne0\) for
     \(e\ne0\) (§6c); making this precise for a sub-family of the quantum
     connection is the same non-semisimple Gamma-II content as the dictionary.
  2. *Direct computation:* the splitting is first-order visible.  Writing the
     deformed Euler operator along \(\tau=\varepsilon\phi\),
     \(E\star_\tau\approx c_1\star+\varepsilon(\partial_\phi(c_1\star_\tau)-
     (\deg\text{-}2)\,\phi\star)\), the block splits at first order iff the
     lower-left entry \(c\) of that derivative in the \(J_2\) basis is
     nonzero.  For \(X=B\) and \(\phi=[\mathrm{pt}]\) (the first-order
     direction of \(\tau(0)\) for a point blow-up) this needs four-point
     invariants \(\langle H^a,H^b,\mathrm{pt},\phi_k\rangle_d\) of the cubic,
     which Kontsevich–Manin reconstruction determines from the known small
     product because the even cohomology is generated by \(H\).  HMT already
     guarantees the answer for the cubic (rank four leaves nowhere else for
     the non-semisimplicity, so \(c=0\) there); the first genuinely open case
     is a vertex variety after a curve blow-up, where the same first-order
     test applies to the explicit blow-up product.

The second half of H-C is the threefold-centre statement of §3.2, unchanged.

**The first-order test is implemented and validated on the cubic**
(`notes/cubic-threefolds-tasks/c925-fable-first-order-splitting.py`,
output `c925-fable-first-order-splitting-output.txt`; SHA-256
`50006608…`, `68eb9f60…`).  WDVV from the small product determines the three
irreducible four-point invariants of the cubic threefold uniquely and
overdeterminedly:
\[
  \langle H^2,H^2,H^2,H^2\rangle_2=2187,\quad
  \langle H^2,H^2,H^3,H^3\rangle_3=7452,\quad
  \langle H^3,H^3,H^3,H^3\rangle_4=15552 .
\]
The first-order Euler deformation on the marked \(J_2\) block is scalar
\(-2I\) along \(t_2\) and strictly upper triangular
\(\bigl(\begin{smallmatrix}0&35/9\\0&0\end{smallmatrix}\bigr)\) along
\(t_3\): both splitting entries vanish, as Hertling–Manin–Teleman forces.
Notably the \([\mathrm{pt}]\)-type direction moves only the nilpotent scale —
the first Rees jet — never the eigenvalues; this is the quantitative face of
"the marker deforms through its jet, not its spectrum".  The same script
pattern applies verbatim at a post-curve-centre vertex once that vertex's
four-point data are assembled (Iritani plus the product formula); first-order
vanishing there is the open half of H-C, and higher-order or HMT-type
arguments must supplement it.

## Mystery ledger (EJ+TT closeout, 2026-08-23)

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | The marker is the Levelt exponent class, invariant under \(\Psi\). | §1–2; audit-script rederivation; Iritani 5.18(1). |
| settled | The class is categorical on all tested rank-one threefolds, matching the three known component types: Jacobian \(\{1/2,1/2\}\), Enriques \(\{0,0\}\), cubic \(\{1/6,5/6\}\). | §6b table; the V14 row is an independent variety sharing only the component. |
| settled | The cubic's \(J_2\) persists along every bulk curve. | Hertling–Manin–Teleman + rank four (§6c). |
| settled | e cannot be read from the regularized period operator's indicial exponents at \(t=\infty\): V14, V12, V10 all have integer exponents \(\{1,2,3\}\) there. | Scratch check on the guessed order-three operators; e is a monodromy invariant, not an indicial one. |
| open | H-C after the first curve-centre edge: marked blocks do not split along Iritani's bulk curves. | First-order four-point splitting test and the \(ss'=2\cos2\pi e-2\) Stokes obstruction identified (§6d); neither yet executed. |
| open | The confluence rule for actual quantum connections (non-semisimple Gamma-II, numerical part). | §6c derives it in the abstract model only. |
| open | The threefold classification: no connected \(b_2\ge2\) threefold carries three loop-conjugate \(\{1/6,5/6\}\) blocks. | §3.2; the categorical form is a finite question about cubic-type components of Mori fibre spaces. |
| queued | Extend the tool to \(J_3\) blocks (V2's rank-three eigenspace) and to V16/V18 once more period terms are available. | Tool limitation; CCGK text has nine terms only. |

No manufactured mysteries: the two open rows above are the whole gate.

## 7. Next

1. Replace the card's `Next` item 1 by the threefold statement of §3.2; mark
   the native-order and Rees-port items as superseded.
2. Compute \(e\) at the small point for the Mori–Mukai threefolds with
   \(b_2\ge2\) that can carry a three-cycle of rank-two blocks (P²-bundles over
   curves, conic bundles over P² with symmetric discriminant, P²×P¹ blow-ups):
   the prediction is \(e=1/2\) or \(0\) throughout.
3. Retype `ExactCubicPoint` in Lean.
