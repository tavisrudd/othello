# C900 Szőnyi cold read: *Arcs complete outside a conic*

Date: 2026-08-09  
Reviewer stance: sealed first-round human-proof and exposition review, in the requested Tamás Szőnyi persona.  
Verdict: **MINOR**.

## Scope and source boundary

I read the manuscript abstract, introduction, classical secant equations, prescribed-hole defect section, matching-design equality mechanism, conic specialization, equality classifications, characteristic-two/nucleus section, and conclusion. I did not inspect its computational or formal-verification sections or any certificate/classifier artifact.

The primary comparison source was Korchmáros--Nagy--Szőnyi, *Algebraic approach to the completeness problem for \((k,n)\)-arcs in planes over finite fields*, arXiv:2302.10162, cached PDF SHA-256 `32cfd5b1cb4f28c171418f61d467fc0accee8adc269ae9cf36a517158917b6b7`. I read its Introduction, definitions of \((k,n)\)-arc and completeness, algebraic completeness strategy, and Theorem 7.5 with its proof context. I also read Giulietti--Montanucci, *On Hyperfocused Arcs in* \(PG(2,q)\), arXiv:math/0601488, especially Definitions and Notation and Proposition 3.4. Ball's 1997 opening conventions were not needed to resolve the manuscript's ordinary completeness convention. I did not read any prior review, proof audit, trust manifest, dossier, or another agent's report.

## Strongest theorem and causal spine

The paper's strongest conceptual result is Theorem `thm:defect`, not any one finite value of \(\rho_{\mathcal C}(q)\). For a \(k\)-arc \(A\) in an arbitrary finite projective plane and an arbitrary disjoint prescribed hole set \(\mathcal H\), it combines the first and second secant-index moments into
\[
 m\Delta_{\mathcal H}(A)
 =\sum_{x\in\mathcal X_{\mathcal H}(A)}(r(x)-1)(m-r(x))
  +\sum_{y\in\mathcal H}r(y)(m-r(y)),
 \qquad m=\lfloor k/2\rfloor.
\]
The remainder is pointwise nonnegative and has exact equality support.

The causal spine is clean:

1. Distinct secants through an external point use disjoint endpoint pairs, so \(r(x)\le m\).
2. Count secant--external-point incidences for the first moment and pairs of disjoint secants for the second moment.
3. Split both moments over required points and holes, take the indicated linear combination, and factor each local contribution.
4. At zero defect, every concurrence clique has maximum size. The unique intersection of two projective lines decomposes the Kneser edges into these cliques, producing a simple \(\operatorname{MATCH}(k,m,1)\) design and its dual rank-three realization in the Desarguesian case.
5. Specializing \(|\mathcal H|=q+1\), then \(\mathcal H=\mathcal C\), gives the scalar lower bound and the zero-defect order equations.
6. In even characteristic, conic tangency through the nucleus plus an involution/sign argument eliminates the exceptional even-\(k\) order \(q=\binom{k-1}{2}+1\), leaving the hyperoval scale.

The human proofs of steps 1--5 are short, sufficient, and correctly expose the mechanism. The finite exact values and computer-assisted ten-point realization elimination lie outside this cold read's proof verdict.

## Novelty boundary against Korchmáros--Nagy--Szőnyi

KNS Theorem 7.5 is stronger than a vague claim that uncovered loci had never previously been localized. For the rational BKS curve over odd \(q\), viewed in \(PG(2,q^r)\) with \(r\ge5\), it proves that its specially constructed \((k,q+1)\)-arc is complete when \(r\) is even, while for odd \(r\) its points not covered by \((q+1)\)-secants are exactly \(PG(2,q)\setminus\Omega\); adjoining those points gives a complete \((k,q+1)\)-arc. The proof depends on the BKS curve, its algebraic extension and monodromy, ramification/genus estimates, and the subfield parity condition \(q+1\mid q^r-1\).

That theorem does **not** give the manuscript's pointwise defect factorization for every ordinary \(2\)-arc, every prescribed disjoint hole set, and every finite projective plane. It also does not give the matching-design equality/stability consequences. Conversely, the manuscript's elementary identity does not subsume KNS's construction or its exact subplane localization theorem for higher-multiplicity arcs.

The manuscript states this boundary accurately at lines 229--240: line 231 pins KNS Theorem 7.5, lines 232--235 state the parity/subplane conclusion, and lines 236--240 distinguish the particular curve-derived \((k,q+1)\)-arc from the arbitrary-hole ordinary-arc identity. The phrase "prescribed subplane" at line 236 is slightly loose—the subplane in KNS is the defining subfield subplane, not an arbitrary prescribed subplane—but it over-credits rather than suppresses the prior result. A maximally exact replacement is "localization on the defining subfield subplane is prior art."

## Earliest unsupported implication

The earliest unsupported implication is in the abstract, lines 51--53: "classify zero defect in characteristic two" is stated without a size hypothesis, but the cited human results prove the odd branch only for odd \(k\ge7\) (lines 845--850) and the even branch only for even \(k\ge6\) (lines 872--876). The same unqualified summary recurs in the introduction. The proof may well extend or the remaining small cases may be elementary, but that extension is not supplied in the reviewed text.

Smallest repair: change the abstract and introductory summary to "for odd \(k\ge7\) ... while for even \(k\ge6\) ...", or add a short lemma disposing of \(k=3,4,5\) and then keep the blanket formulation.

## Detailed audit of the even-characteristic equality argument

I find the argument at lines 878--938 correct. Here is the complete dependency check.

- **Arithmetic/parity.** In the exceptional branch \(q=B+1=(m-1)(2m-1)+1\), evenness of \(q>1\) forces \(m\) even. Since \(s=k-1=2m-1\), one has \(I_{\mathcal C}=ms=\binom{k}{2}\), hence \(I_{\mathcal C}\) is even and \(|S|=2m-1\equiv3\pmod4\).
- **Nucleus in the arc.** If \(\nu\in A\), the \(k-1\) joins from \(\nu\) to the other arc points are exactly the tangent secants. Any additional tangent secant would also contain \(\nu\), contradicting the arc condition. Nontangents contribute zero or two conic intersections, so \(I_{\mathcal C}\equiv k-1\pmod2\), contradicting even \(I_{\mathcal C}\).
- **Nucleus outside the arc.** If \(\nu\notin A\), tangent secants are exactly the secants through \(\nu\), whence \(I_{\mathcal C}\equiv r(\nu)\pmod2\). Relative completeness makes \(r(\nu)>0\), and zero defect gives \(r(\nu)\in\{1,m\}\). Since \(I_{\mathcal C}\) and \(m\) are even, \(r(\nu)=m\). Thus there is a tangent arc secant \(PQ\), tangent at some \(T\), and zero defect also puts \(T\) in the maximum-index set \(S\).
- **Maximum-index-set invariance.** For \(Y\in S\), the \(m\) secants through \(Y\) pair all \(2m\) points of \(A\). For every \(R\in A\), let \(R'\) be its partner. The second conic intersection of \(RR'\) is \(\sigma_R(Y)\) (equal to \(Y\) in the tangent case). It has positive conic index; zero defect forces that index to be \(m\). Hence \(\sigma_R(S)\subseteq S\), and finiteness/bijectivity gives invariance.
- **Coordinate involutions.** On \(XZ=Y^2\), after moving \(T\) to \((1,0,0)\), the affine parametrization \(c(u)=(u^2,u,1)\) gives the tangent \(Z=0\), and the chord through \(c(u),c(v)\) meets it at \((u+v,1,0)\). Thus a centre \((a,1,0)\) acts by \(u\mapsto u+a\). The nucleus is \(a=0\). Since \(P,Q\ne\nu\) and \(P\ne Q\), the parameters \(a_P,a_Q,a_P+a_Q\) are three distinct nonzero elements.
- **Fixed points and signs.** The corresponding three translations commute, preserve \(S\), and have the unique projective fixed point \(T\), which lies in \(S\). Each restriction to \(S\) therefore consists of one fixed point and \((|S|-1)/2\) transpositions. As \(|S|\equiv3\pmod4\), that number is odd, so all three restrictions have sign \(-1\). But the third is the product of the first two and must have sign \(+1\), a contradiction.

The only worthwhile prose repair here is to insert after line 905: "Since \(T\) has positive conic index, zero defect gives \(T\in S\)." This makes the later fixed-point count literally self-contained; it is not a mathematical gap.

## Ranked findings and smallest repairs

### 1. GAP — opening classification is broader than the proved range

Lines 51--53 and the corresponding introductory summary omit the hypotheses \(k\ge7\) in the odd branch and \(k\ge6\) in the even branch. This is the earliest unsupported implication in the manuscript.

**Smallest repair:** add those two lower bounds to both summaries. If a hypothesis-free headline is desired, add an elementary low-\(k\) lemma first.

### 2. CONVENTION — "every arc" and the coding translation need size hypotheses

The introductory Theorem `thm:main` says "for every arc" at line 136 even though its definition divides by \(m=\lfloor k/2\rfloor\); the body later imposes \(k\ge3\), but the headline theorem should carry its own domain. Likewise lines 113--117 call the projective representative matrix a \([k,k-3,4]_q\) MDS parity-check matrix without stating \(k\ge4\); for \(k=3\) this invokes the nonstandard/variable convention that the zero code has distance \(4\), and for smaller arcs the displayed parameters do not apply.

**Smallest repair:** write "For every \(k\)-arc \(A\) with \(k\ge3\)" in `thm:main`, and begin the coding sentence "For \(k\ge4\), ..." (or explicitly state the zero-code convention).

### 3. CONVENTION — hyperfocusedness is not relative completeness

Lines 213--216 place "affine completeness" and "hyperfocused constructions" too close without giving the defining distinction. Giulietti--Montanucci define a hyperfocused arc by a **minimum linear blocking set for all its secants**. Their Proposition 3.4 separately states that a translation arc is either complete in \(PG(2,q)\setminus\ell_\infty\) or extends to a translation arc of twice the size. Hyperfocusedness itself does not imply completeness outside the focus line, nor conversely.

**Smallest repair:** replace the phrase with: "For a line hole this is affine completeness. Hyperfocusedness is a different secant-blocking condition; for translation arcs, Giulietti--Montanucci, Proposition 3.4, separately relates it to affine extendability." Pin the citation to Definition 2 and Proposition 3.4.

### 4. MISSING CITATION — the novelty-bearing classical-moment attribution is not pinned

Lines 222--227 correctly locate the proposed novelty in the factored prescribed-hole remainder rather than in the moment counts, but the supporting references for the classical equations are only a chapter-level citation, an unpinned Ball paper, and a recent bound. Since this sentence carries the novelty boundary, a reader should be able to verify exactly which source contains which first/second index equation and under what convention.

**Smallest repair:** cite an exact theorem/equation/page for both moments. Keep Ball only if its exact displayed convention has been verified; otherwise use the precise Hirschfeld location that contains the two formulas.

## Acceptance and significance

The exact defect identity is correct and useful: it is a genuinely local strengthening of the classical scalar secant count, and the matching-design consequence is not rhetorical decoration but the exact equality object. The conic lower bound and the parity-separated equality spectra follow correctly from it. The KNS comparison is unusually responsible and already blocks an overbroad first-localization claim. No major proof repair is needed in the reviewed human argument.

The verdict is **MINOR** because the only mathematical support issue is a removable range mismatch in the opening summary; the central theorem and the delicate even-characteristic proof survive intact.

## Mystery ledger (ej + tt closeout)

- **Low-\(k\) zero defect:** unresolved in the prose as written. The abstract claims the full characteristic-two classification, while the displayed results start at \(k=6\) or \(7\). The exact evidence gap is a lemma for \(k=3,4,5\), or a decision to qualify the headline. This is settled for acceptance by the one-line qualification repair, but not mathematically classified by the reviewed text.
- **Global priority of the exact factorization:** not settled by this bounded comparison. KNS does not pre-empt it, but a claim against all literature would require a separate literature audit with exact moment-inequality predecessors. The current manuscript wisely makes the narrower, mechanism-level claim.
- **Even-characteristic sign obstruction:** no genuine mystery remains. Every parity, tangency, invariance, fixed-point, and sign step closes as above.
