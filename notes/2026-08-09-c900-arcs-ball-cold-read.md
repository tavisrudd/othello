# C900 Arcs paper: Simeon Ball cold read

**Date:** 2026-08-09  
**Review boundary:** sealed first-round review of the human mathematics and exposition only. I read the manuscript from the abstract through the conic specialization and then the conclusion. I did not inspect formal-verification sections, proof audits, dossiers, prior reviews, or other reviewers' reports.

## Sources used

1. S. Ball, *On small complete arcs in a finite plane*, authoritative six-page PDF from the author's UPC page (SHA-256 `b59d6ec7b7bb5e50a807cdd580ae84f6eacd2ec3b22e8329c549962a82eb26d7`). I used the opening secant distribution, the elementary lower bound, and the dual blocking-set construction.
2. S. Ball and M. Lavrauw, *Arcs in finite projective spaces*, arXiv:1908.10772v2 (cached PDF SHA-256 `00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4`). I used the definitions of completeness and projective equivalence, the combinatorial tangent convention, and the generator-matrix/MDS-code convention.
3. G. Korchmáros, G. P. Nagy, and T. Szőnyi, *Algebraic approach to the completeness problem for \((k,n)\)-arcs in planes over finite fields*, arXiv:2302.10162v1 (cached PDF SHA-256 `32cfd5b1cb4f28c171418f61d467fc0accee8adc269ae9cf36a517158917b6b7`). I read the Introduction, definitions, and Theorem 7.5 only.

## Executive assessment

The strongest conceptual theorem is not the displayed asymptotic lower bound or the four finite values. It is the prescribed-hole defect identity together with its zero-defect consequence: for any arc in any finite projective plane, the two classical secant moments admit a pointwise nonnegative remainder, and vanishing forces the secant-concurrency decomposition of \(KG(k,2)\) to be a simple \(\operatorname{MATCH}(k,\lfloor k/2\rfloor,1)\) design. The deletion statement is a useful quantitative refinement of the same mechanism. In the conic case, retaining rather than discarding the hole-incidence term then gives a genuinely geometric equality analysis, especially the characteristic-two oval/nucleus and hyperoval conclusions.

I found no false assertion in the human proofs reviewed. The first literal defect is an omitted size hypothesis near the start of the Introduction, not a failure of the main argument. My verdict is **MINOR**: the mathematics on the main route is sound and suitable for a combinatorics journal, but the novelty claim and conventions should be made more exact, and one substantial audit section should be moved out of the article.

## Causal spine

1. For a \(k\)-arc, a point outside the arc lies on at most \(m=\lfloor k/2\rfloor\) secants, because those secants use disjoint endpoint pairs.
2. The two classical counts are
   \[
   \sum r=N(q-1),\qquad \sum \binom r2=3\binom k4.
   \]
   Splitting them over a prescribed hole set \(\mathcal H\) and its complement records the incidence spent on the holes.
3. The selected linear combination factors pointwise as
   \[
   (r-1)(m-r)\quad\hbox{off the holes},\qquad r(m-r)\quad\hbox{on the holes}.
   \]
   Since \(0\le r\le m\), every term is nonnegative. This gives the coverage bound, the exact equality indices, and the defect-weighted stability estimates.
4. Two secants with disjoint endpoint pairs determine one Kneser edge and meet at one external point. Thus concurrency partitions the edges of \(KG(k,2)\) into cliques. At zero defect all nontrivial cliques have the maximum order \(m\), producing the matching design and, after duality, its rank-three projective realization.
5. For \(|\mathcal H|=q+1\), completeness and deletion of the nonnegative hole-incidence term give the scalar lower bound. Substitution at \(k=\sqrt{2q}+a\) yields \(a\ge 3/2-8/\sqrt{2q}\).
6. When \(\mathcal H\) is a conic, keeping the conic-incidence term at zero defect counts the maximum-index conic points and restricts \(q\) to three orders for each parity of \(k\). In characteristic two, elementary prime-power exclusions settle the odd branch; the even exceptional branch is eliminated by the signs of three conic-chord involutions, leaving the hyperoval scale.

The exact values at \(q=13,16,17,19\) form a separate finite-classification branch. They are not needed for the causal spine above and, under this review boundary, I make no judgment on the exhaustive certificates.

## Exact novelty relative to the three sources

Ball's paper already treats bisecants of a complete arc as a dual blocking set, states the secant-index distribution, and obtains the classical \(\sqrt{2q}\) lower scale from the number of bisecants. It also records the first three global index equations in a small-order application. Hence neither the leading scale nor the raw secant moments are new here.

The new item relative to Ball is the prescribed-hole split and the particular extremal linear combination whose slack factors at each point. The factorization itself is elementary algebra once the two moments and \(r\le m\) are written down. The substantive new consequences are the exact equality pattern, its canonical matching-design interpretation, the deletion stability statement, and the conic equality restrictions.

Ball--Lavrauw supplies conventions and the standard arc/MDS correspondence, not a predecessor of the prescribed-hole result. The manuscript's use of a parity-check matrix is the dual version of their generator-matrix convention and is correct once \(k\ge3\) and rank three are stated. Its definition of ordinary completeness agrees with theirs, while \(\mathcal C\)-completeness is explicitly a different relative notion.

Korchmáros--Nagy--Szőnyi Theorem 7.5 localizes uncovered points only for their specially constructed rational BKS \((k,q+1)\)-arc in \(\operatorname{PG}(2,q^r)\), with the parity and extension hypotheses in that theorem. It is not a theorem about arbitrary ordinary \(2\)-arcs or arbitrary prescribed hole sets. The manuscript describes this boundary accurately and does not claim priority for localization itself.

## Does the pointwise factorization contain more than the summed moments?

Not in the information-theoretic sense. The displayed identity is algebraically equivalent to the two summed classical moments after the hole/complement split; it introduces no independent incidence equation. It is nevertheless more useful than the usual scalar inequality: termwise nonnegativity identifies all equality cases point by point, and the same weights bound the exceptional concurrency graph and a deletion set. The right claim is therefore that the factorization **extracts local equality and stability consequences from the classical moments**, not that it contains extra incidence data beyond them. Most of the manuscript already speaks this way, but the distinction should be stated once without ambiguity.

## Classical-scale framing

The framing is substantially correct. The \(\sqrt{2q}\) scale is classical, and the paper cites Ball and Hirschfeld near the discussion of the point-index equations. The actual asymptotic contribution is an additive \(3/2-o(1)\) improvement for arcs complete outside \(q+1\) prescribed points, plus the equality/stability structure. I would say this explicitly immediately before the main conic theorem and cite Ball's elementary bound at theorem level. The abstract's naked display can otherwise be read as advertising the leading scale as the advance.

The remark on the conic term has the right scale: at \(k\asymp\sqrt q\), \(I_{\mathcal C}(A)/m=O(\sqrt q)\), whereas the universal overlap correction is \(\Theta(q^{3/2})\). Thus improving only the former cannot change the displayed additive constant.

## Ranked findings

1. **GAP.** The first unjustified statement occurs immediately after Definition 1: the code paragraph and the introductory form of the defect theorem are stated for an unqualified arc \(A\), although a \([k,k-3,4]_q\) code and division by \(m=\lfloor k/2\rfloor\) require at least \(k\ge3\). The main body later imposes \(q\ge3\), \(k\ge3\), so the proof is unaffected. Add that hypothesis before the code paragraph and repeat it in the introductory theorem statement.

2. **SIGNIFICANCE.** The defect identity is a sharp repackaging of two classical moment equations, not a third source of incidence information. Its JCTA-level content lies in the matching-design rigidity, deletion stability, and conic/characteristic-two consequences. The introduction should make those consequences carry the novelty claim and describe the factorization itself more modestly.

3. **CONVENTION.** In the characteristic-two proof, phrases such as "tangent \(A\)-secants" use *tangent* for tangency to \(\mathcal C\). In the arc literature a tangent to \(A\) means a line meeting \(A\) once, whereas these lines meet \(A\) twice. Define "\(\mathcal C\)-tangent secant of \(A\)" and use that phrase throughout the argument.

4. **MISSING CITATION.** The proof of the explicit additive theorem calls the first-moment estimate elementary, but the paper should attach the closest classical reference there, preferably Ball's Theorem 3.1 (and the corresponding Hirschfeld result), and say in the theorem's lead-in that \(\sqrt{2q}\) is the classical baseline. The general citation paragraph in the Introduction is accurate but too remote from the asymptotic claim.

5. **EXPOSITION.** The 26-page length is acceptable for JCTA only if the central human argument remains visibly dominant. At present the conclusion arrives before a long sequence of secondary classifications, transfer results, inverse reconstruction, formal contracts, and witnesses. This makes the article feel like a core paper plus an audit dossier. Keep a short trust map in the article and move the section **Computational and formal verification** to an electronic supplement; this is the one section I would move first.

## JCTA significance and length

The universal identity alone would be too slight for JCTA: its proof is one linear combination of familiar counts. The zero-defect matching design, rank-three realization, quantitative deletion consequence, and characteristic-two conic classification together raise the work to plausible JCTA significance. The exact small orders add useful concrete results but should not be asked to carry the conceptual case, especially where their lower exclusions are exhaustive computations.

Twenty-six pages is not excessive numerically. The problem is hierarchy rather than raw length. A shorter main article ending with the geometric equality theorem and a compact account of the finite values would read as a coherent contribution; detailed formal/computational contracts and witness tables belong in a supplement. The conclusion itself is concise and correctly identifies the next structural problem.

## Verdict

**MINOR.** No false mathematical claim was found on the reviewed human-proof route. Repair the missing \(k\ge3\) hypothesis, disambiguate conic tangency from arc tangency, sharpen the classical-baseline citation and novelty sentence, and move the detailed verification section out of the main narrative.
