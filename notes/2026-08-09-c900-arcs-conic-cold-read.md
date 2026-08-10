# C900 sealed conic-geometry cold read

**Date:** 2026-08-09  
**Persona:** Maria Montanucci / Massimo Giulietti, with emphasis on conics, secant foci, and relative completeness  
**Verdict:** **MINOR**

## Review boundary and sources

This is a first-round cold review of the human proofs and exposition in the conic specialization, the equality classifications, and the even-characteristic nucleus section of `papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex`.  I read the abstract and introduction only to determine the claimed scope.  I did not inspect the computational or formal-verification sections, proof audits, trust manifests, prior reviews, handoff review notes, or another reviewer's report, and I did not run Lean or a classifier.

Conventions were checked against:

- Giulietti--Montanucci, *On Hyperfocused Arcs in* \(PG(2,q)\), arXiv:math/0601488, cached SHA-256 `feb9f148d51c22df3f9ba35867137a0870ca220b1b233c03b0319de720c263f9`: a hyperfocused \(k\)-arc has its secants blocked by \(k-1\) points on one external line; a generalized hyperfocused arc merely has a minimum secant-blocking set, not necessarily linear.  Their Proposition 3.1 makes translation arcs hyperfocused, while Proposition 3.4 separately treats completeness in \(PG(2,q)\setminus\ell_\infty\) and extension to a larger translation arc.
- Ball--Lavrauw, *Arcs in finite projective spaces*, arXiv:1908.10772, cached SHA-256 `00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4`: a tangent to a planar arc is a line meeting the arc once and must not be confused with a tangent to an algebraic curve; projective equivalence means equivalence under PGL.
- Blokhuis--Seress--Wilbrink, *Characterization of complete exterior sets of conics*, authoritative scans pp. 143--144 under `/tmp/persistent/tavis/lit-search/bsw-1992/`: for odd \(q\), their complete exterior set consists of \((q+1)/2\) exterior points whose pairwise joins are passants.  Thus \(\mathcal C(\mathbb F_q)\subseteq U(A)\), the reverse of the manuscript's \(U(A)\subseteq\mathcal C(\mathbb F_q)\).

## Strongest theorem and causal spine

The strongest conceptual theorem is the prescribed-hole defect identity: the first two secant-index moments factor into a sum of nonnegative pointwise remainders for every finite projective plane and every prescribed hole set.  Its strongest conic consequence in the reviewed material is the characteristic-two zero-defect classification (within the stated body ranges): for odd \(k\ge7\), equality is exactly an oval of size \(q+1\) whose nucleus lies on the prescribed disjoint conic; for even \(k\ge6\), equality forces \(k=q+2\), hence the hyperoval scale.

The proof works for the following reason.

1. Secants through an exterior point use disjoint endpoint pairs, hence \(r(x)\le m=\lfloor k/2\rfloor\).  The first index moment counts secant--point incidences, and the second counts pairs of disjoint secants by four-subsets of the arc.
2. Splitting both moments over the prescribed conic and its complement yields the exact defect identity.  Zero defect forces indices \(1\) or \(m\) at covered required points and \(0\) or \(m\) on the conic.
3. Maximum-index concurrence points decompose the Kneser graph into maximum matching cliques.  Counting them, and then counting how many lie on the conic, gives three candidate plane orders for each parity of \(k\).
4. For powers of two, elementary factorization eliminates two odd-\(k\) orders, leaving \(q=k-1\); the standard oval index distribution then identifies the nucleus-on-conic condition.
5. For even \(k\), the middle candidate is arithmetically impossible.  In the last candidate, parity of conic intersections first forces the conic nucleus to be outside the arc and to have maximum secant index.  A conic-tangent arc secant then supplies two chord involutions preserving the maximum-index subset of the conic.  Their fixed-point parity and product relation contradict permutation signs.  Only \(q=k-2\) remains.

## Coordinate-free account of the involution step

Before coordinates, the geometry is this.  Projection from a point \(R\notin\mathcal C\) pairs the two intersections of every line through \(R\) with the conic; a tangent contact is paired with itself.  This defines an involution \(\sigma_R\) of \(\mathcal C(\mathbb F_q)\).  In characteristic two all conic tangents pass through the nucleus \(\nu\).  Hence \(\sigma_\nu\) is the identity, while \(R\ne\nu\) lies on exactly one conic tangent and \(\sigma_R\) has exactly its contact point as fixed point.

If \(R\in A\) and \(Y\) has maximum index \(m=k/2\), the secants through \(Y\) pair all points of \(A\).  Pairing \(R\) with \(R'\) shows that the second conic point of \(RR'\), with tangency interpreted as a repeated point, is \(\sigma_R(Y)\) and again has positive, hence maximum, index.  Thus the maximum-index set \(S\) is invariant.

Now suppose the arc secant \(PQ\) is tangent to \(\mathcal C\) at \(T\).  Both \(\sigma_P\) and \(\sigma_Q\) fix \(T\), and their product is the third nonidentity involution in the four-group of projections whose centers lie on that tangent.  The coordinates \(XZ=Y^2\), \(T=(1,0,0)\), \(c(u)=(u^2,u,1)\) merely verify this intrinsic picture: a center \((a,1,0)\) acts by \(u\mapsto u+a\).  The nucleus is \(a=0\), and distinct nonnuclear centers give distinct nonzero translations.

Because \(PQ\) itself passes through \(T\), zero defect implies \(T\in S\).  Each of the three involutions therefore has exactly one fixed point on \(S\).  In the candidate branch, \(|S|=k-1=2m-1\) and \(m\) is even, so each restriction has \(m-1\) transpositions and sign \(-1\).  But the product of the first two restrictions has sign \(+1\), contradicting that the third also has sign \(-1\).  The coordinate calculation and the sign contradiction are correct once these exceptional-point conventions are made explicit.

## Nucleus and parametrization audit

- **Nucleus in the arc:** correct.  The \(k-1\) lines from the nucleus to the other arc points are exactly the conic-tangent arc secants; any additional such secant would contain three arc points.  The lower bound and parity of \(I_{\mathcal C}(A)\) follow.
- **Nucleus outside the arc:** correct.  Relative completeness, not hyperfocusedness, gives \(r(\nu)\ge1\).  All and only conic tangents pass through \(\nu\), so their number is \(r(\nu)\), giving the stated parity.
- **Parametrization:** correct and complete after adding the convention that the omitted conic point is \(T\).  The chord through \(c(u),c(v)\) meets \(Z=0\) at \((u+v,1,0)\), so the induced involution is \(u\mapsto u+a\).  PGL suffices both to put the conic in standard form and, using its stabilizer, to move \(T\) to \((1,0,0)\).
- **Maximum-index invariance and parity:** correct.  Tangency causes no exception if its contact is declared fixed.  The proof's parity calculation uses \(m\) even and gives \((|S|-1)/2=m-1\) odd.

## Earliest unsupported implication

The earliest unsupported claim is already in the abstract: “classify zero defect in characteristic two: odd \(k\) gives an oval ... while even \(k\) forces \(k=q+2\).”  The body proves these assertions only for odd \(k\ge7\) and even \(k\ge6\).  No reviewed lemma disposes of the omitted small sizes before the abstract makes the unrestricted claim.  The same unqualified summary recurs in the introduction.  This is a scope gap, not a defect in the displayed large-\(k\) proofs.

Within the even-branch proof itself, the first omitted bridge occurs at “Restricted to \(S\), each nonidentity involution has one fixed point.”  One must first say that the tangency point \(T\) belongs to \(S\): it lies on the arc secant \(PQ\), hence has positive conic index, and zero defect makes that index \(m\).  The conclusion is valid, but this sentence is load-bearing for the sign count.

## Terminology and prior-art boundary

The manuscript gets the most important containment boundary right: BSW complete exteriority has \(\mathcal C(\mathbb F_q)\subseteq U(A)\), whereas \(\mathcal C\)-completeness has \(U(A)\subseteq\mathcal C(\mathbb F_q)\).  It would be slightly safer to state there that BSW's term is for odd \(q\), exterior points, and a fixed cardinality \((q+1)/2\).

The line-hole sentence needs sharper separation.  Replacing the conic by an external line gives relative completeness in the affine complement.  Hyperfocused means instead that all secants focus into exactly \(k-1\) points of that line; generalized hyperfocused means a minimum secant-blocking set, possibly nonlinear.  Giulietti--Montanucci treat affine relative completeness as an additional property of translation arcs, not as the definition or consequence of hyperfocusedness.

Likewise, “tangent” should follow Ball--Lavrauw's convention.  A tangent to the arc meets the arc once; the lines at issue here meet \(A\) twice and are tangent to \(\mathcal C\).  “Conic-tangent \(A\)-secant” is unambiguous.

## Ranked findings

1. **GAP — Abstract and introduction overstate the characteristic-two equality classification.**  The prose suppresses the body hypotheses odd \(k\ge7\) and even \(k\ge6\), and no reviewed argument closes the small cases.  **Smallest repair:** insert those ranges in both summaries, or add and cite a short lemma settling all omitted \(k\).
2. **CONVENTION — “Tangent \(A\)-secant” conflicts with standard arc terminology.**  A tangent to \(A\) meets \(A\) once, while these lines are secants of \(A\) tangent to the conic.  **Smallest repair:** define once and consistently write “conic-tangent \(A\)-secant.”
3. **GAP — The sign contradiction omits the sentence proving \(T\in S\).**  Without it, “each restriction has one fixed point” has not been established.  **Smallest repair:** after introducing the tangent secant \(PQ\), state that \(r(T)>0\), hence zero defect gives \(r(T)=m\) and \(T\in S\).
4. **CONVENTION — The line-hole/hyperfocused sentence blurs two independent properties.**  Hyperfocusedness is minimum linear secant blocking; completeness outside the line is a separate coverage condition.  **Smallest repair:** replace the sentence by two clauses explicitly separating affine relative completeness from the hyperfocused translation-arc examples, preferably citing Giulietti--Montanucci Propositions 3.1 and 3.4 at the respective clauses.
5. **EXPOSITION — The chord involution's exceptional points are left implicit.**  The invariance argument precedes the coordinate model but does not state that a tangent contact is fixed, that the nucleus induces the identity, or that every other center has one fixed point.  **Smallest repair:** add the coordinate-free paragraph above before the parametrization; then retain the coordinates only to prove the translation product law.

No reviewed statement is false after restoring the displayed size hypotheses.  The body argument for the odd and even large-size branches is sound, and the BSW containment comparison is correctly oriented.

## Smallest complete repair set

1. Qualify both opening equality summaries by \(k\ge7\) odd and \(k\ge6\) even, unless the paper adds a small-\(k\) lemma.
2. Insert a three-sentence coordinate-free description of \(\sigma_R\), including tangency, the nucleus, and the unique fixed point.
3. Add the explicit inference \(T\in S\) before the permutation-sign count.
4. Replace “tangent \(A\)-secant” by “conic-tangent \(A\)-secant.”
5. Separate affine relative completeness from hyperfocusedness in the related-work paragraph; optionally add the odd-order/cardinality qualifiers to the BSW sentence.

## Closeout and mystery ledger

The explicit extra-juice/Tao pass found no alternate geometric obstruction needed for the large-\(k\) proof: once the conic pencil involutions are stated intrinsically, the coordinate translation law and sign contradiction are the shortest route.  It also settled the apparent exceptional-point issue: tangency is a fixed point, the nucleus is the identity, and distinct nonnuclear centers on one tangent give the required four-group.

One genuine scope mystery remains: whether the authors intend the unrestricted opening claim to include the omitted small values.  The reviewed text contains no such lemma, so the evidence gap is exact and local.  Qualifying the summaries closes it without changing any theorem; retaining the unrestricted claim requires a separate small-case proof.  No other unexplained conic-geometric feature remains.
