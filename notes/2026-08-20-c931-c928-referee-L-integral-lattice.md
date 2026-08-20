# C931 referee L — integral symplectic Lefschetz lattice

## 1. Verdict

**B — minor revision.**  The integral lattice calculation is correct: the
occupancy decomposition is an integral monomial-basis decomposition, the
complete-graph blocks have Smith form \(1^{n-1},2\) even for \(n=3\), their
all-edge vectors give the whole saturation defect, and for \(g=5\) the result
is \(1^{110},2^{10}\).  The required revision is bibliographic rather than
mathematical.  The Smith multiplicities are already an immediate consequence
of Faulkner Valiente--Miller Eismeier's compatible integral splittings and
associated-graded contraction formula, although their paper does not state
the manuscript's off-central map as a named theorem.  The manuscript should
say this explicitly and reserve its narrower algebraic contribution for the
complete-graph proof and the natural divided-power representatives.

Review surface: the frozen eight-page PDF
`papers/blown-up-theta-lattice/blown_up_theta_lattice.pdf`, SHA-256
`3822f928217df38e4ed3f4feb687d9036637dbc751bda3f792906df1196e36e5`, and
arXiv:2507.00844v1, SHA-256
`3a3ef5208198526fdfcdeaabc00abbae77650b2015bce5806cce92e3d8a0ac91`.
No finite certificate was available or used.

## 2. Claim map

**Theorem 3.1 (PDF pp. 4--5, equations (7)--(10)).**  All stated claims are
verified: injectivity for \(g\geq4\), the exact saturation formula, the natural
isomorphism \(\Lambda/2\Lambda\simeq\operatorname{Sat}(\operatorname{im}
L_3)/\operatorname{im}L_3\), and exactly \(2g\) nonunit Smith factors, all
equal to two.

**Theorem 1.1, assigned lattice portion (PDF p. 2, equation (2) and the
sentence following equation (3)).**  The formula for the Gysin-image lattice
and the factors \(1^{110},2^{10}\) follow correctly from Theorem 3.1; the
geometric identification of that lattice with the Gysin image is outside this
packet.

**Theorem 1.2 and Corollary 1.3 (PDF p. 2).**  Their use of a rank-ten defect
is numerically consistent with Theorem 3.1, but the duality and intersection-
cohomology mechanisms are outside this packet and are not independently
endorsed here.

## 3. Major findings

1. **The occupancy decomposition is integral, exhaustive, and proves
   injectivity (verification; severity: none; remedy: none).**  Location: Theorem 3.1 proof, PDF
   pp. 4--5, especially equation (9).  Put \(x_i=e_i\wedge f_i\).  Every
   exterior-basis monomial has a unique singleton set \(A\), a choice
   \(u_A\in\{e_i,f_i\}_{i\in A}\), and a full-pair set \(T\), and is
   \(u_Ax_T\).  Thus fixing \((A,u_A)\) partitions the monomial basis itself,
   not merely its rational span.  In degree three the only possibilities are
   \((|A|,|T|)=(3,0)\) and \((1,1)\); in degree five they are \((5,0)\),
   \((3,1)\), and \((1,2)\).  Wedge by \(\theta=\sum x_i\) preserves
   \((A,u_A)\) and sends
   \[
      u_Ax_T\longmapsto
      \sum_{j\notin A\cup T}u_Ax_{T\cup\{j\}}.
   \]
   Consequently a size-three singleton block maps one generator to the sum
   of \(g-3\) target basis vectors and is primitive for \(g\geq4\); a
   size-one singleton block is \(U_{g-1}\).  Size-five singleton blocks are a
   direct complement in degree five and do not meet the image.  This accounts
   for every source monomial and every target monomial relevant to the image.
   Since the first blocks are nonzero and \(U_{g-1}\) is injective for
   \(g-1\geq3\), \(L_3\) is injective for all \(g\geq4\).

2. **The complete-graph Smith calculation, including \(n=3\), is correct
   (verification; severity: none; remedy: none).**  Location: PDF p. 4, equation (10), continuing
   on p. 5.  For
   \[
      U_n(a_1,\ldots,a_n)=(a_i+a_j)_{1\leq i<j\leq n},
   \]
   the rows \(\{1,j\}\), \(2\leq j\leq n\), and columns \(2,\ldots,n\)
   give an identity \((n-1)\)-minor.  Modulo two, the sum of all \(n\)
   columns is zero, so every \(n\)-minor is even.  The rows
   \(\{1,2\},\{1,3\},\{2,3\}\) together with \(\{1,k\}\),
   \(4\leq k\leq n\), give an \(n\)-minor whose determinant is the determinant
   of
   \[
      \begin{pmatrix}1&1&0\\1&0&1\\0&1&1\end{pmatrix},
   \]
   namely \(-2\), times an identity determinant.  For \(n=3\) the second row
   set is simply empty, so this displayed \(3\times3\) matrix is the whole
   minor; the unit \(2\)-minor remains available.  Triangle equations also
   give injectivity over \(\mathbf Z\).  Hence the determinantal divisors are
   \(1,\ldots,1,2\) and
   \(\operatorname{SNF}(U_n)=\operatorname{diag}(1^{n-1},2)\).

3. **The all-edge vector gives the complete defect, and the global count and
   natural generator are exact (verification; severity: none; remedy: none).**  Location: PDF
   p. 5, first four paragraphs after equation (10), and Theorem 3.1 equations
   (7)--(8) on p. 4.  In one incidence block let
   \(w=\sum_{i<j}E_{ij}\).  Then
   \(2w=U_n(1,\ldots,1)\), while \(w\notin\operatorname{im}U_n\): equations
   \(a_i+a_j=1\) on a triangle force \(a_i=1/2\).  Finding 2 shows that the
   torsion of the cokernel has order exactly two, so \([w]\) generates the
   entire saturation quotient, not just a visible subgroup.  There are
   exactly \(2g\) size-one singleton choices (one of \(e_k,f_k\) for each
   \(k\)), and different choices lie in disjoint monomial blocks.  Moreover
   \[
      \theta^{[2]}=\sum_{i<j}x_ix_j,
   \]
   so \(\theta^{[2]}\wedge e_k\) and
   \(\theta^{[2]}\wedge f_k\) are precisely the corresponding all-edge
   vectors.  The map
   \[
      \tau:\Lambda/2\Lambda\longrightarrow
      \operatorname{Sat}(\operatorname{im}L_3)/\operatorname{im}L_3,
      \qquad z\longmapsto[\theta^{[2]}\wedge z]
   \]
   is well defined because
   \(2\theta^{[2]}\wedge z=L_3(\theta\wedge z)\), and the block calculation
   makes its \(2g\) basis images independent and exhaustive.  Its definition
   from the polarization proves symplectic naturality.  For \(g=5\), the
   size-three singleton blocks contribute
   \(2^3\binom53=80\) unit factors; the ten \(U_4\) blocks contribute thirty
   further unit factors and ten factors of two.  This reproduces
   \(1^{110},2^{10}\) structurally.

4. **The novelty boundary needs a local but mandatory correction
   (verification of mathematics; severity: minor revision).**  Locations: the literature discussion on PDF
   p. 3 and the paragraph after Theorem 3.1 on p. 5.  In
   Faulkner Valiente--Miller Eismeier, arXiv:2507.00844v1, Theorem 2.9 (source
   PDF p. 9) identifies the integral filtration quotients, Corollary 2.10
   (p. 10) computes wedge and contraction on those quotients, and Proposition
   2.14 (p. 11) supplies integral splittings compatible with contraction.
   Apply Proposition 2.14 to
   \(\iota_\theta:\bigwedge^5\Lambda\to\bigwedge^3\Lambda\), whose monomial
   matrix is the transpose of the matrix of \(L_3\), up to harmless basis
   signs.  Corollary 2.10 gives multiplication by one on the
   \(P^3\)-piece and by two on the \(P^1\)-piece.  Their ranks at \(g=5\) are
   \(\binom{10}{3}-\binom{10}{1}=110\) and \(10\), respectively.  Thus the
   Smith multiplicities in this manuscript are an immediate specialization
   of those two named results.  Their Theorem 3.1 (source PDF p. 12) concerns
   the different, central maps
   \(\omega_k:\bigwedge^{g-k}\to\bigwedge^{g+k}\), so it is not itself the
   correct pinpoint citation for this off-central map.  The source does not
   state the complete-graph occupancy blocks or the natural representatives
   \([\theta^{[2]}\wedge z]\) for this quotient as a named result.  The
   smallest adequate remedy is to cite Proposition 2.14 and Corollary 2.10 at
   the claims on pp. 3 and 5 and say explicitly: the Smith multiplicities
   follow from their filtration, while the present proof gives a direct
   complete-graph realization and identifies the natural divided-power
   representatives used by the geometry.  No theorem or proof mechanism must
   change.

## 4. Minor findings

1. The bibliography entry `[FVME25]` on PDF p. 8 should include
   `arXiv:2507.00844` (and the version/date, or final publication data if then
   available), rather than only the title and year.
2. On PDF p. 4, the determinant-two minor argument is valid for \(n=3\), but
   adding “with the \(\{1,k\}\) list empty when \(n=3\)” would remove the only
   plausible edge-case hesitation.

## 5. Literature boundary

The only assigned comparison source consulted was Faulkner Valiente--Miller
Eismeier, *A Lefschetz decomposition over Z, and applications*,
arXiv:2507.00844v1 (1 July 2025).  Its Theorem 2.9, Corollary 2.10, and
Proposition 2.14 provide the general integral filtration, exact
associated-graded coefficients, and compatible nonequivariant splittings.
Together they already imply the Smith factors of the present off-central map
after transposing wedge to contraction.  Its Theorem 3.1 gives a more explicit
cokernel result only for central Hard-Lefschetz maps and is not a literal
specialization to \(\bigwedge^3\to\bigwedge^5\) at \(g=5\).

That source does not supply, as a stated result, the unsigned-complete-graph
block decomposition, the all-edge description of each saturation generator,
the natural isomorphism
\(z\mapsto[\theta^{[2]}\wedge z]\) for this exact quotient, or any of the
cubic-threefold Gysin interpretation.  Those are the precise remaining
contributions on this packet's surface.  Conversely, the manuscript should
not present the numerical Smith multiplicities themselves as newly obtained
relative to that source.

## 6. Confidence

1. **Finding 1: high.**  It follows by a complete partition of the exterior
   monomial bases in degrees three and five and checks every possible
   \((|A|,|T|)\).
2. **Finding 2: high.**  The displayed unit and determinant-two minors,
   parity rank drop modulo two, and triangle injectivity determine every Smith
   invariant for all \(n\geq3\), with \(n=3\) written out explicitly.
3. **Finding 3: high.**  The all-edge calculation, independent-block count,
   and divided-power identity prove the exact quotient and the \(g=5\)
   multiplicities without a finite computation.
4. **Finding 4: high.**  It is supported directly by arXiv:2507.00844v1,
   source PDF pp. 9--12 (Theorem 2.9, Corollary 2.10, Proposition 2.14, and
   Theorem 3.1) and by the transpose relation between wedge and contraction.

No genuine mathematical mystery remains on the assigned lattice surface.  The
only open item is the explicit citation repair in Finding 4.

## 7. Publication recommendation

**Default venue — Proceedings of the AMS:** recommend publication after minor
revision.  The result is correct, concise, and reproducible from a structural
argument; the attribution correction is local and should be required before
acceptance.

**Stretch venue — Algebraic Geometry:** do not recommend acceptance on the
strength of this packet alone in the present form.  The numerical Smith result
is already immediate from the cited general framework, so the stretch case
must rest on the paper's geometric synthesis and the explicit natural glue,
not on novelty of the multiplicities.  If the other proof surfaces survive
and the novelty statement is corrected as above, this packet raises no
mathematical obstacle, but it does not by itself supply the broader novelty
expected for the stretch venue.
