# Final cold prose read

## Publication recommendation

**Recommend publication after minor revision.** The manuscript has a clear new core result, a convincing geometric narrative, and an unusually well-articulated computer-assisted component. I found no exposition-level defect that calls the mathematical conclusions into question. Before publication, the finite certificate should be tied to a stable, citable supplement in the paper itself, and the hierarchy between the main geometric proof and the two coding-theoretic branches should be made still more visible. The latter is primarily an organizational issue, not a request for additional mathematics.

## Overall assessment

The paper is strongest when it stays close to its central sequence:

1. split the classical secant-index equations across required points and allowed holes;
2. retain the exact nonnegative remainder rather than discarding it;
3. specialize to a conic and extract finite and asymptotic lower bounds;
4. convert relative conic-completeness into a quadratic condition on the ordinary-uncovered locus; and
5. exclude eight-arcs over \(\mathbb F_{16}\) by an exhaustive, certificate-checked classification.

That route is mathematically natural and, by the end of the introduction, easy to retain. The defect identity is presented at the right level of generality, its proof is short enough that the reader immediately sees the mechanism, and the equality and stability statements feel like genuine structural dividends rather than decorative add-ons. The conic specialization then arrives without unnecessary setup. The manuscript is appropriately written for specialists in finite geometry and coding theory: it recalls the necessary terminology, distinguishes the problem from nearby notions, and does not belabor standard projective-plane facts.

The main expository tension is abundance rather than obscurity. The transfer theorem, nucleus analysis, coding dictionary, small examples, Clebsch configuration, coset spectrum, and extension complex are all individually worthwhile, but together they compete with the title's two advertised pillars. The introduction does explicitly identify the coding section and final \(q=11\) subsection as secondary and skippable, which substantially resolves this problem. Nevertheless, the physical placement of the coding section before the upper transfer, nucleus discussion, and \(q=16\) classification means that a linear reader leaves the main geometric route just after the principal lower bound and only returns several pages later.

## Paragraph-by-paragraph flow and hierarchy

### Abstract and introduction

The abstract is dense but effective for the intended audience. It states the relative-completeness problem, names the new invariant, gives the exact inequality and asymptotic consequence, supplies the averaging upper transfer, and culminates in the exact small values. The last sentence correctly signals that \(q=16\) rests on a checked finite classification. This is a lot of information, but nearly every item earns its place.

The opening definitions and comparisons with saturating sets, almost-complete conic subsets, line-covering arcs, and complete exterior sets are especially helpful. The three-line display comparing complete exteriority and relative completeness is an excellent piece of exposition: it makes a potentially confusing distinction immediate and prepares the later \(q=11\) equality.

The contribution list and section roadmap are clear. The sentence explicitly declaring the coding applications secondary is important and should be retained. The final paragraph separating classical inputs from new contributions is also valuable, though it partly repeats the preceding contribution list; this is harmless, but the two paragraphs could be compressed if space is at a premium.

### Classical equations and defect identity

These sections are exceptionally clean. Definitions are introduced only as needed, the maximum-index lemma makes the combinatorial constraint explicit, and the two moment equations are proved at exactly the right level. The comment about general finite linear spaces is concise and usefully marks the scope.

The defect section has good internal pacing: notation, split equations, theorem, coverage corollary, complete-outside specialization, and stability. The boxed identity exposes the source of nonnegativity term by term, and the equality criterion is immediately interpretable. The prose following the stability bound successfully translates the inequality back into geometry. This is the strongest expository part of the paper.

### Conic specialization and asymptotic lower bound

The conic-loss term is introduced transparently, and the distinction between universal secant overlap and incidence spent on the exempt conic is memorable. The definitions of \(L_1\) and \(L_2\), parity formulas, and sample table provide an effective bridge between the general inequality and finite cases.

The asymptotic theorem is appropriately explicit. Its proof is computational in appearance because of the polynomial expansion, but the proof strategy is signposted well: first put \(k\) on the \(\sqrt{2q}\) scale, then isolate the only difficult range, then use the leading coefficient with uniform bounds on the rest. The subsequent scale remark is excellent; it prevents readers from overestimating what a sharper conic-incidence estimate could accomplish.

### Coding interpretation

The dictionary is mathematically crisp and likely useful to the coding-theory readership. In particular, the warning that distance-three syndrome directions are deep-hole directions only after covering radius three is established is precise and prevents a common overstatement. The projective-to-affine factor of \(q-1\) is also explained rather than left implicit.

As a matter of paper hierarchy, however, this is the clearest optional branch and its present location interrupts the geometric route. The introduction tells readers that it may be skipped, but the section itself could begin with a one-sentence reminder that no later geometric result depends on it. Better still, it could be placed after the \(q=16\) theorem, immediately before the \(q=11\) coding application. Either change would make the main route visually as clear as it is logically.

### Transfer and nucleus sections

The projective-averaging argument is short, elegant, and well placed as an upper-bound counterpart to the lower bounds. The prose correctly emphasizes both its generality and its likely non-sharpness.

The even-characteristic nucleus discussion is clear and useful, but it is another branch rather than a step in the proof of \(\rho_{\mathcal C}(16)=9\). The closing numerical explanation at \((q,k)=(16,8)\) is therefore important: it tells the reader exactly why the nucleus analysis cannot finish the finite case and motivates the change of method. The proposition titles “The nucleus belongs to the arc” and “The nucleus lies outside the arc” read momentarily like conclusions rather than case headings; “Case \(\nu\in A\)” and “Case \(\nu\notin A\)” would be slightly clearer.

### Evaluation obstruction and the \(q=16\) proof

The transition from geometry to linear algebra is excellent. The paper first states the elementary evaluation obstruction without computational baggage, explains its Veronese meaning, and only then specializes it to the classification. This is exactly the right proof/computation balance.

The augmentation contract is sufficiently explicit to show why local checked transitions imply global exhaustiveness. The proof does not rely on canonical labeling or deduplication, and the text repeatedly distinguishes the trusted covering argument from the external class count. This is a major strength. The leaf obstruction is also mathematically transparent: most leaves furnish six independent quadratic conditions, while the exceptional leaves furnish a span relation forcing a selected point onto every containing quadratic. Projective transport is stated explicitly rather than being treated as obvious bookkeeping.

At the level of mathematical specification, the computer-assisted proof is self-contained: the manuscript specifies the universe of 273 normalized projective points, the augmentation invariant, the exact local certificate obligation, the list sizes, the two accepted leaf-obstruction forms, and the transport step. Appendix A states the trust boundary and identifies independent regeneration and formal checking. A specialist can understand exactly what finite proposition was checked and why it implies the theorem without reading source code.

Reproducibility still depends on an external “source supplement” and its `TRUST.md`. For a final journal version, that supplement must be deposited at a stable archival location and cited/versioned in the manuscript, with the checked certificate and checker included. If the submission system already binds the supplement immutably to the article, this is administratively satisfied; the prose should nevertheless point to the archived object rather than only naming a file. Defining the “standard four-frame” by coordinates would also remove one small avoidable convention from the formal contract.

### The \(q=11\) application, questions, and appendices

The \(q=11\) subsection is rich and readable. Its first sentence clearly marks independence from the \(q=16\) proof, and the “Optional extension structure” heading makes the deepest side branch visible. The code/coset proposition follows naturally from the earlier dictionary, and the icosahedral extension complex is attractive mathematics. For a finite-geometry/coding-theory journal it is venue-appropriate, but it also makes the paper feel like two papers sharing one particularly interesting example. If length or thematic concentration becomes an editorial concern, this is the first material I would move to an appendix or a companion note; it should not be cut merely for stylistic tidiness.

The further-questions section is focused and emerges naturally from the preceding limitations. Its closing paragraph gives the paper an effective conceptual ending by separating universal overlap from genuinely conic-specific geometry.

The appendices are sensibly divided into trust boundaries, the general evaluation dichotomy, and coordinates. The table in the verification appendix is especially effective. The discussion of the three exceptional leaves is optional detail but useful: it gives geometry to what would otherwise be opaque rank defects. The coordinate appendix supplies compact, exact witnesses and field encodings without burdening the body.

## Prioritized revisions

### Must-fix before publication

1. **Make the computer supplement permanently identifiable from the article.** Cite a stable archived version containing the certificate, checker, regeneration programs, manifest, hashes, and formal statements. A filename such as `TRUST.md` is not by itself a durable scholarly reference. This is the only substantive publication prerequisite I see in the exposition.

2. **State explicitly what the “standard four-frame” is.** Give its four normalized coordinates (and, if relevant to the checker contract, the ordering). This is small, but it belongs in a proof whose principal virtue is a fully explicit finite specification.

### Medium priority

1. **Strengthen the visible main-route hierarchy.** Either move the coding-interpretation section to immediately before the \(q=11\) coding application, or add a prominent opening sentence within that section saying that it may be skipped and is not used in the geometric proof of the main exact result.

2. **Add a one-paragraph proof architecture immediately before the \(q=16\) classification.** It could say, in one place: lower bound \(8\); a hypothetical relative-complete eight-arc makes its ordinary-uncovered locus lie on an avoiding nonsingular quadratic; the certificate excludes even an avoiding nonzero quadratic; the nine-point witness supplies the upper bound. All of this is already present, but collecting it would let readers re-enter the main route after the intervening branches.

3. **Consider relocating the optional \(q=11\) extension complex if the venue values a tightly single-theme article.** The material is good and clearly labeled; this is a question of emphasis and length, not correctness.

### Polish

1. Rename the two nucleus proposition headings as explicit cases, so that they cannot be mistaken for assertions derived from the hypotheses.

2. In the \(q=16\) proof, change “the lists contain \(4,61,454,2633\) representatives at sizes five through eight” to an explicit mapping such as \(|\mathcal L_5|=4,|\mathcal L_6|=61,|\mathcal L_7|=454,|\mathcal L_8|=2633\). This removes a momentary parsing burden.

3. Consider trimming one of the two consecutive contribution summaries at the end of the introduction if page economy matters.

## Direct answers to the requested checks

- **Is the main geometric route obvious?** Yes, after the introduction, and especially once the evaluation-obstruction subsection begins. Its visual continuity is weakened by the placement of the coding section and, to a lesser degree, the nucleus branch, but the logic is not obscure.

- **Are optional branches visibly optional?** Mostly yes. The introduction explicitly marks the coding section and final \(q=11\) subsection as secondary, the \(q=11\) subsection declares its independence from the \(q=16\) proof, and the extension material is labeled optional. The coding section itself would benefit from repeating that status at its opening or being moved later.

- **Is the \(q=16\) computer-assisted proof self-contained at the level of mathematical specification?** Yes. The finite universe, coverage contract, exhaustiveness induction, leaf rejection alternatives, and projective transport are all specified, and the trust boundary is unusually clear. Final publication still requires a stable archived supplement and would benefit from explicit coordinates for the initial frame.

In short, the manuscript already reads like a serious specialist-journal paper. Its central identity and the conversion of uncovered loci into a checked quadratic obstruction are both memorable. The remaining work is to make the scholarly artifact behind the finite proof permanent and to ensure that the paper's generous secondary material never visually outranks the geometric spine.
