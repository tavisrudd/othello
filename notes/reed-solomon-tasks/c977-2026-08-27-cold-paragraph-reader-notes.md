# Cold paragraph-by-paragraph exposition journal

Reader protocol: one fixed packet per turn; one paragraph at a time; record the
first-pass reaction before opening the next paragraph.  The reader has not seen
the manuscript, prior reviews, or revision history.
### packet-01 / paragraph-0001.tex

- Job: Abstract-style statement of the paper's hypotheses, complete high-weight-coset classification, covering-radius split, geometric representatives, and downstream counting/extension results.
- First-pass accessibility: Minor friction. A coding theorist can identify the headline result, but the geometric classification arrives before the geometry has been oriented.
- Friction: “maximum-weight directions,” “normal rational curve,” tangent/conjugate-secant points, and “rational secants incident with \(A\)” are used without saying what ambient projective space the cosets inhabit or why these point types represent cosets. “Both shells” also requires the reader to infer weights \(r\) and \(r-1\), and the final phrase stacks two further deliverables densely.
- Smallest high-value repair: Add one orienting clause before the geometric list, e.g. that coset directions are viewed as points in the syndrome projective space containing the normal rational curve; replace “both shells” by “the weight-\(r\) and weight-\(r-1\) shells.”
- Finding: MINOR.
### packet-01 / paragraph-0002.tex

- Job: Sketch the proof mechanism and advertise its auxiliary consequences and computational/formal support.
- First-pass accessibility: Major friction. Even a coding-theory expert cannot reconstruct the proof narrative without already knowing the manuscript's private vocabulary.
- Friction: “contracts ... markers,” “catalecticant rank-two locus,” “Lucas carrier,” “degree-six selector,” “terminal cubic pencil,” “split cubic,” and “carrier containment” appear in rapid succession without definitions or a statement of what mathematical objects they act on. The causal chain from avoiding markers and \(A\) to low coset weight is hidden. “Exact R5--R7 results” and “trust boundaries” are labels with no self-contained meaning here.
- Smallest high-value repair: Replace the first three sentences with a two-level proof sketch: first state in ordinary geometric/coding terms what object must be constructed and why it forces weight \(\le r-2\); then name only the one or two indispensable mechanisms, deferring the internal labels (Lucas carrier, selector, R5--R7) to the body. Spell out what R5--R7 and the public artifacts certify.
- Finding: MAJOR.
### packet-01 / paragraph-0003.tex

- Job: Supply index/search keywords spanning the coding-theoretic, matrix, and finite-geometric interfaces.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-01 / paragraph-0004.tex

- Job: Mark the start of the introduction.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-01 / paragraph-0005.tex

- Job: Define coset weight, state the central classification problem in coding language, and name its two immediate applications.
- First-pass accessibility: Yes; the paragraph gives a clean entry point before invoking geometry.
- Friction: None for a coding-theory reader; “deep holes” and “Singleton defect” are standard enough at this level and their role is explicit.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-01 / paragraph-0006.tex

- Job: Fix the evaluation-set/code notation and translate coset weight into the projective geometry of a normal rational curve via a parity-check matrix.
- First-pass accessibility: Yes. The explicit parametrization and the definition of \(d_S(f)\) make the coding/geometry bridge concrete.
- Friction: None. The syndrome–coset correspondence and invariance under column scaling are standard and are stated at the needed level.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-01 / paragraph-0007.tex — Theorem “High-weight cosets” (`thm:main`)

- Source metadata: `coverage{absent}`; uses `thm:simultaneous-marker-escape`, `prop:recursive-component-selection`; proves `main-fixed-level-classification-package`.
- Job: State the main carrier-containment theorem: outside two exceptional projective loci, every syndrome has coset weight at most \(r-2\), with the general and binary field-size thresholds made explicit.
- First-pass accessibility: Minor friction. The implication and thresholds are readable, but the central exceptional geometry is not yet intelligible to a coding theorist crossing into invariant theory.
- Friction: \(\mathcal P_r\) is described only as a “rank-at-most-two catalecticant locus”; neither the relevant catalecticant matrix nor its geometric meaning is given. The basis vectors \(e_j\) and the reason the binomial-vanishing subspace \(\mathcal M^{\max}_{r,p}\) is exceptional are also unstated. Thus the reader can parse the theorem formally but cannot yet picture what it classifies or how large the exceptional set is.
- Smallest high-value repair: Add one sentence immediately after the two loci are introduced giving the catalecticant matrix/standard-coordinate convention and a plain-language gloss: these are precisely the two candidate carriers of high-weight syndromes, with the second arising only from modular binomial degeneracy.
- Finding: MINOR.
### packet-01 / paragraph-0008.tex — continuation of Theorem “High-weight cosets” (`thm:main`)

- Job: Under the nonmodular characteristic hypothesis, turn the containment theorem into the exact covering-radius and geometric high-weight classification, then give projective and affine coset counts.
- First-pass accessibility: Minor friction. The coding conclusions and count conversion are clear, but the finite-geometric point types are still assumed rather than introduced.
- Friction: “tangent direction/point,” “conjugate-secant direction/point,” and especially “interior points of rational secants incident with \(A\)” require the reader to infer conventions: whether endpoints are excluded, what conjugate field the secant uses, and whether “incident with \(A\)” means the line contains an omitted curve point. “Direction” and “point” are interchanged without explicitly saying both mean projective syndrome classes.
- Smallest high-value repair: Insert a compact parenthetical definition of the three point types and state once that “directions” are projective syndrome points; this would make the central classification self-contained without interrupting it.
- Finding: MINOR.
### packet-01 / paragraph-0009.tex

- Job: Interpret the theorem's three characteristic regimes, identify the remaining small-characteristic gap, and highlight the qualitative effect of puncturing the evaluation set.
- First-pass accessibility: Mostly yes, with minor friction at the description of the unresolved case.
- Friction: “the only unresolved arbitrary-redundancy arithmetic is confined to the explicit Lucas carrier” does not say what is unresolved there—presumably the exact weights/classification of syndrome points lying in \(\mathcal M^{\max}_{r,p}\). “Lucas carrier” is a new nickname rather than a standard term, though its referent is now displayed.
- Smallest high-value repair: Replace that clause by the concrete statement “in small characteristic, only the weights of syndrome points lying in \(\mathcal M^{\max}_{r,p}\) remain to be classified for arbitrary \(r\).”
- Finding: MINOR.
### packet-01 / paragraph-0010.tex

- Job: Declare the proof's trust boundary: isolate the sole computer-algebra input, distinguish the paper's mathematical arguments, and identify the two imported coding-theory implications.
- First-pass accessibility: Minor friction. The division of labor is welcome, but the claims behind the project-specific nouns are not stated.
- Friction: “reduced terminal-carrier decomposition,” “registered Gröbner-elimination certificate,” and “covering-radius and MDS-extension gates” are internal/process language. A reader cannot tell what the certificate certifies or which precise implications are taken from Seroussi–Roth and Dür.
- Smallest high-value repair: Add a plain-language appositive stating what the certified decomposition establishes, and replace “gates” with the exact imported implications (for example, “we use Seroussi–Roth to infer … and Dür to infer …”).
- Finding: MINOR.
### packet-01 / paragraph-0011.tex — “Coding interpretation”

- Job: Translate the geometric coset classification into one-column MDS/NMDS extensions and preview the family-aggregate enumerator result.
- First-pass accessibility: Minor friction; the key equation makes the extension correspondence transparent.
- Friction: “the two highest possible weight shells” is ambiguous when \(s=0\), where the preceding theorem says the covering radius is \(r-1\) and hence the weight-\(r\) shell is empty. The intended scope seems to be the weight-\(r\) and weight-\(r-1\) shells across the family. “Family-wise” and “family-aggregate” are careful but leave the reader to infer that individual extensions need not share one enumerator.
- Smallest high-value repair: Say explicitly “all cosets of weight \(r\) or \(r-1\) (the former shell is empty for \(s=0\))” and add “aggregated over, rather than fixed within, each geometric family.”
- Finding: MINOR.
### packet-01 / paragraph-0012.tex

- Job: Relate the evaluation-set formulation to the standard extended/projective and ordinary GRS models, state the claimed novelty, and restate the classification in that familiar frame.
- First-pass accessibility: Minor friction. The standard-code reduction and novelty claim are clear, but the final geometric name changes.
- Friction: “deleted-point-incident split-secant directions” appears to rename the earlier “interior points of rational secants incident with \(A\).” Without an explicit equivalence, a reader may wonder whether a split secant is a narrower class or whether endpoints are included. The compound modifier is also hard to parse on first pass.
- Smallest high-value repair: Use the same term as in the theorem, or define once that a split secant is a line through two \(\mathbb F_q\)-rational curve points and that the classified syndrome directions are its non-curve interior points when one endpoint lies in \(A\).
- Finding: MINOR.
## packet-01 note

- Current mental model: The paper turns high coset weight into a secant-rank problem for syndrome points relative to a normal rational curve with a finite deleted set. A uniform theorem forces every weight-\(\ge r-1\) point into a catalecticant rank-two locus or an explicit small-characteristic Lucas subspace. When \(p>r-1\), the latter disappears and the remaining points split geometrically into omitted curve points (weight \(r\)) and tangent/conjugate-secant/deleted-endpoint rational-secant points (weight \(r-1\)); this also classifies low-defect one-column extensions and supports aggregate enumerator counts.
- Questions carried forward: What precisely are the catalecticant coordinates and the “Lucas carrier,” and why do they exhaust the candidates? What are “markers,” “selectors,” “terminal carriers,” and the cubic-pencil construction in ordinary geometric terms? Are conjugate and split secants defined uniformly, including endpoint conventions? Which exact Seroussi–Roth and Dür implications are imported, and what is certified computationally versus proved mathematically? In small characteristic, is only the internal classification of \(\mathcal M^{\max}_{r,p}\) open?
- Top accessibility issue so far: The proof synopsis and trust-boundary discussion rely on a dense layer of manuscript-specific carrier/marker/selector/gate vocabulary before giving the underlying construction and its coding-theoretic consequence. The main theorem itself is much easier to parse once the syndrome-projective-space bridge is supplied.
### packet-02 / paragraph-0013.tex

- Job: Delimit the novelty against classical dictionaries, known redundancy-four/full-support classifications, deleted-point studies, and recent deep-hole constructions.
- First-pass accessibility: Minor friction. The literature map is useful, but the final novelty sentence becomes abstract just where precision matters most.
- Friction: “that conjunction” forces the reader to reconstruct the exact conjunction from the previous sentences, and “uniform exclusion off the explicit carrier” is internal shorthand. It is unclear whether the claimed novelty is the arbitrary-redundancy classification itself, the deletion parameter, the uniform field threshold, or all three together.
- Smallest high-value repair: Restate the novelty directly: “Our new contribution is the complete classification of both top shells for finitely point-deleted projective supports at arbitrary redundancy, obtained by uniformly ruling out every syndrome outside \(\mathcal P_r\cup\mathcal M^{\max}_{r,p}\).” Adjust if the intended conjunction differs.
- Finding: MINOR.
### packet-02 / paragraph-0014.tex

- Job: Give the central proof idea—reduce arbitrary redundancy directly to a redundancy-five cubic problem—and quantify the abundance of resulting witnesses.
- First-pass accessibility: Major friction. The paragraph is structurally a proof overview, but nearly every noun needed to understand the mechanism is manuscript-specific and undefined.
- Friction: It is not stated what the \(r-5\) “roots” are roots of, what R5 denotes, what a “terminal R5 cubic pencil” parametrizes, how row spaces become “trapped,” or what “marker equation,” “split cubic,” and “split locator” mean. The displayed asymptotic therefore has no immediately visible object-level or coding-theoretic interpretation, and the link from a split cubic/locator to a weight-\(\le r-2\) witness is hidden.
- Smallest high-value repair: Precede the mechanism with two ordinary-language sentences defining the witness being sought and the reduction: specify the polynomial/divisor whose \(r-5\) roots are chosen, say that R5 means redundancy five, and state exactly why a split member of the residual cubic pencil supplies an \((r-2)\)-column representation of the syndrome. Then retain the technical labels.
- Finding: MAJOR.
### packet-02 / paragraph-0015.tex

- Job: Explain how the exact redundancy-five through seven results support or sharpen the uniform theorem, give their placement in the paper, and exclude older R8–R10 computations from the submission's proof/claim scope.
- First-pass accessibility: Minor friction. The division of roles is understandable, but some scope language is procedural rather than mathematical.
- Friction: “terminal cubic engine,” “radius and certificate boundaries,” and “companion records” are not self-explanatory. In particular, the reader does not know whether the R5–R7 refinements improve thresholds, settle exceptional carriers, compute radii, or all of these, nor where the explicitly disclaimed R8–R10 records live.
- Smallest high-value repair: Replace the boundary shorthand with one clause listing what each exact result adds (classification range, radius conclusion, and any computer-certified step), and either cite the companion records or omit the R8–R10 sentence from the mathematical introduction.
- Finding: MINOR.
### packet-02 / paragraph-0016.tex — Section “Results at a glance” (`sec:results-map`)

- Job: Open a compact results-roadmap section.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-02 / paragraph-0017.tex

- Job: State the main theorem's scope and emphasize invariance under the deleted points' placement and column multipliers.
- First-pass accessibility: Minor friction because the first sentence drops a crucial qualification established immediately after the theorem.
- Friction: The unconditional phrase “classifies every coset” sounds inconsistent with the earlier statement that, in small characteristic, behavior inside \(\mathcal M^{\max}_{r,p}\) remains unresolved at arbitrary redundancy. The independence assertion is otherwise crisp.
- Smallest high-value repair: Write “When \(\operatorname{char}\mathbb F_q>r-1\), Theorem … classifies …; in every characteristic it confines all such cosets to the two explicit carriers.”
- Finding: MINOR.
### packet-02 / paragraph-0018.tex — Table “The high-weight cosets…” (`tab:headline-shells`)

- Job: Present the complete-classification regime in a single comparison table, separating full and deleted support and giving radii, geometric shell types, and projective counts.
- First-pass accessibility: Minor friction. The hypotheses, projective-versus-literal count convention, and case split are exceptionally easy to scan; only the finite-geometric type names remain undefined.
- Friction: A coding theorist without the finite-geometry convention may not know that a conjugate secant is an \(\mathbb F_q\)-rational line determined by a conjugate pair over \(\mathbb F_{q^2}\), or that “interiors” excludes the two curve endpoints. The column heading “Support” actually records the deletion regime \(s=0\) versus \(s>0\).
- Smallest high-value repair: Add a one-sentence note defining tangent/conjugate/split-secant interior points, and rename the first column “Deletion regime.”
- Finding: MINOR.
### packet-02 / paragraph-0019.tex

- Job: Convert the shell classification into an explicit distance/Singleton-defect classification of one-column extensions and point to the aggregate NMDS enumerator theorem.
- First-pass accessibility: Yes. The three-row table makes the dictionary immediate.
- Friction: None; the notation \(\ker[H_S\mid f]\) and MDS/NMDS terminology are standard for the intended coding-theory readership.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-02 / paragraph-0020.tex

- Job: Summarize the all-characteristic containment result, give a combinatorial way to read the Lucas subspace from Pascal's triangle, and separate fixed-redundancy refinements from the uniform proof.
- First-pass accessibility: Minor friction. The implication is clear and the Pascal-row description is helpful, but the status of points inside the exceptional subspace remains vague.
- Friction: “The carrier” is ambiguous between the union and the Lucas component, while “decide its arithmetic” does not specify whether R5–R7 determine exact coset weights, radii, shell membership, or point counts. R5–R7 is still unexplained shorthand for redundancies five through seven.
- Smallest high-value repair: Say “The Lucas subspace \(\mathcal M^{\max}_{r,p}\) is read off from …,” expand R5–R7 once, and replace “decide its arithmetic” with the exact result those classifications supply.
- Finding: MINOR.
### packet-02 / paragraph-0021.tex — Subsection “Why the classification closes”

- Job: Open an explanatory subsection promising the reason the candidate list is exhaustive.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-02 / paragraph-0022.tex

- Job: Organize the exhaustiveness proof into three conceptual steps: translate representations to split forms, characterize failure under contraction, and simultaneously choose contraction data before applying the exact redundancy-five count.
- First-pass accessibility: Major friction. The three-step signposting is excellent, but a reader outside this exact interface cannot tell what any step does to the original syndrome problem.
- Friction: “Hankel dictionary,” “split squarefree binary form,” “contraction,” “terminal R5 system,” “trapped,” “degree-six selector,” and “R5 pencil” are undefined. In particular, the direction of the first equivalence is obscure (does a split degree-\(r-2\) binary form encode the selected parity-check columns?), and there is no stated invariant showing that repeated contraction preserves the relevant obstruction.
- Smallest high-value repair: Add a compact schematic with object types and implications: syndrome \(f\) → associated binary form/Hankel row space; choosing a linear factor → lowering redundancy by one; \(r-5\) choices → a redundancy-five cubic pencil; a split squarefree member avoiding \(A\) → an \((r-2)\)-column representation. Then the carrier/selector terminology has an intelligible backbone.
- Finding: MAJOR.
### packet-02 / paragraph-0023.tex — Figure “The proof route” (`fig:headline-proof-route`)

- Job: Visualize the proof as exceptional-locus exclusion → contraction/R5 construction of a split locator → Hankel interpretation for the syndrome.
- First-pass accessibility: Minor friction. The caption conveys the intended high-level logic, but the diagram itself omits definitions and its arrow directions do not form one obvious implication chain.
- Friction: \(W_f\) is introduced without saying what space it is, “locator” remains undefined, and the top downward arrow plus bottom upward arrow makes “syndrome \(f\)” look like an input to rather than a consequence interpreted through the locator statement. Most importantly, the desired endpoint \(d_S(f)\le r-2\) is absent, so the reader must remember why the middle statement proves the theorem.
- Smallest high-value repair: Redraw as a one-direction chain: \(f\notin\mathcal P_r\cup\mathcal M^{\max}_{r,p}\Rightarrow W_f\text{ contains a split squarefree degree-}(r-2)\text{ locator}\Rightarrow d_S(f)\le r-2\), with the first arrow labeled contraction/R5 and the second Hankel dictionary; define \(W_f\) in the surrounding sentence.
- Finding: MINOR.
### packet-02 / paragraph-0024.tex

- Job: Give first-pass readers a selective route through the main proof and direct specialized fixed-level/computational material to the appendices.
- First-pass accessibility: Yes. It clearly distinguishes the conceptual path from optional technical records.
- Friction: None requiring repair here; the technical section names appropriately match the earlier roadmap and promise their later development.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
## packet-02 note

- Current mental model: The introduction now separates three layers more clearly. The complete large-characteristic result classifies the weight-\(r\) and weight-\(r-1\) projective syndrome shells and hence MDS/NMDS one-column extensions; the all-characteristic result confines every high-weight syndrome to a rank-two catalecticant locus plus a Lucas subspace read from adjacent zeros in Pascal row \(r-2\); exact redundancies five through seven handle some sharper/small-field cases. The uniform proof is intended to translate an \((r-2)\)-column representation into a split squarefree locator, contract directly to a redundancy-five cubic pencil, and use one simultaneous choice plus an exact point count to construct such a locator outside the exceptional carrier.
- Questions carried forward: What is \(W_f\), and precisely how does a split squarefree locator encode a column-span representation? What algebraic operation is contraction, which invariant/obstruction does it preserve, and why do \(r-5\) chosen roots terminate in a cubic pencil? What is the degree-six selector and how does it make all choices simultaneously? Exactly what shell data do the redundancy-five through seven results settle inside the Lucas carrier, and what remains open? Where are tangent, conjugate-secant, and split-secant conventions formally defined?
- Top accessibility issue so far: The paper has an effective coding-theory results map, especially the shell and extension tables, but its central proof map still substitutes internal nouns—locator, contraction, carrier, selector, terminal R5 pencil—for a typed chain of mathematical objects and implications. The one-direction schematic proposed at paragraph-0023 would materially bridge the coding, invariant-theoretic, and finite-geometric interfaces.
### packet-03 / paragraph-0025.tex — Section “The syndrome–Hankel dictionary” (`sec:dictionary`)

- Job: Open the section that will connect syndrome representations to Hankel/binary-form data.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-03 / paragraph-0026.tex

- Job: Establish characteristic-safe coordinates: syndromes live in a divided-power space, root forms in the dual symmetric power, with a coefficient-extraction pairing; then define the Hankel matrix \(H_f\) and its kernel \(W_f\).
- First-pass accessibility: Minor friction. The explicit pairing and matrix make the construction checkable, but the divided-power notation is assumed at the moment this new interface begins.
- Friction: \(\Gamma^{r-1}E\) and \(x^{[k]}\) are not explicitly identified as the divided-power functor/basis notation, and \(\nu(t)\) is written as a coordinate vector without saying that it is the normal-rational-curve point in \(\mathbb P(\Gamma^{r-1}E)\). A reader can infer both, but only after parsing the display.
- Smallest high-value repair: Add “where \(\Gamma^nE\) denotes the degree-\(n\) divided-power space and \(x^{[n-i]}y^{[i]}\) its standard basis”; identify \(\nu:\mathbb P^1\to\mathbb P(\Gamma^{r-1}E)\) explicitly.
- Finding: MINOR.
### packet-03 / paragraph-0027.tex — Table “Notation used from the Hankel dictionary onward” (`tab:notation`)

- Job: Consolidate the notation for the coding, divided-power, Hankel, and later counting interfaces.
- First-pass accessibility: Major friction because the displayed redundancy relation appears to change the setup without announcing a restriction.
- Friction: Earlier, a redundancy-\(r\) code is supported on \(|S|=q+1-s\) points, so a coding reader expects \(r=|S|-k=q+1-s-k\); the table instead states \(r=q+1-k\) while introducing an undefined \(\mathrm{PRS}(k)\). If this row applies only to the full-support projective RS code or uses \(k\) in a different convention, that scope is hidden. The last two rows (\(g,\delta,\kappa,d\)) also arrive well before their construction, and “unavailable marker scheme” is not an explanatory definition.
- Smallest high-value repair: State the exact scope/convention for \(\mathrm{PRS}(k)\) and reconcile \(r\) with deletion (or use a separate symbol for the full-support parameter). Move the genus/marker rows to the section where those quantities enter, or add a “used in” column and define the marker scheme plainly.
- Finding: MAJOR.
### packet-03 / paragraph-0028.tex

- Job: Give a classical recurrence-theoretic interpretation of \(W_f\) and of the squarefree-split-locator obstruction.
- First-pass accessibility: Yes. This is the first intuitive explanation of why the Hankel kernel is a “witness system.”
- Friction: None; “split-free” is defined naturally by the preceding sentence.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-03 / paragraph-0029.tex — Lemma “Hankel criterion” (`lem:hankel`)

- Source metadata: `coverage{conditional_deduction}`; Lean item `PRSFoundation.HankelKernelDictionary.not_splitFree_of_kernel_member`.
- Job: State the exact dictionary: an \((r-2)\)-point normal-rational-curve span representation of \(f\) is equivalent to the product of the corresponding distinct linear factors lying in \(W_f\); also record multiplicity/osculating and equivariance variants.
- First-pass accessibility: Minor friction. The main equivalence is concise and now gives the missing coding consequence of a split locator, but the two extensions are compressed into specialist shorthand.
- Friction: The notation \(\nu(\lambda_i)\) extends the earlier affine parameter notation without explicitly identifying \(\mathbb P(E^\vee)\cong\mathbb P^1\). “The same statement with repeated factors and Hasse derivatives” does not say which derivatives enter or how multiplicity corresponds to an osculating order, and \(\mathrm{P}\Gamma\mathrm L_2(q)\) is not expanded or its action specified.
- Smallest high-value repair: Add the identification of a root point \(\lambda\) with its curve point \(\nu(\lambda)\), and gloss the last sentence as equivariance under projective semilinear changes of the root coordinate; defer the precise repeated-factor formula to a separately stated variant if it is used later.
- Finding: MINOR.
### packet-03 / paragraph-0030.tex — Proof of the Hankel criterion

- Job: Justify the dictionary via geometric-sequence solutions and ordinary/confluent Vandermonde independence, including infinity, repeated roots, all characteristics, and coordinate equivariance.
- First-pass accessibility: Yes. Each sentence addresses one potential edge case and the proof matches the recurrence interpretation immediately preceding it.
- Friction: None requiring repair for the intended expert audience.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-03 / paragraph-0031.tex — Corollary “Split-free criterion” (`cor:splitfree`)

- Source metadata: `coverage{conditional_deduction}`; Lean items `PRSFoundation.HankelKernelDictionary.not_splitFree_of_kernel_member`, `PRSFoundation.CoveringRadiusInput.deep_iff_splitFree`.
- Job: Specialize the Hankel criterion to full-support deep holes: assuming covering radius \(r-1\), deep syndrome directions are exactly those whose Hankel kernel has no squarefree completely split degree-\(r-2\) form.
- First-pass accessibility: Minor friction. The equivalence is the desired conceptual payoff, but the code notation and scope remain implicit.
- Friction: \(\rho\) is not explicitly introduced as covering radius, and \(\mathrm{PRS}(q+1-r)\) has only appeared in the potentially ambiguous notation-table row. The reader must infer that this is the full projective-support case \(s=0\), not the deleted-support code \(C_S(v)\).
- Smallest high-value repair: Write “For the full-support projective Reed–Solomon code \(\mathrm{PRS}(q+1-r)\), assume its covering radius \(\rho\) is \(r-1\)” on first use.
- Finding: MINOR.
### packet-03 / paragraph-0032.tex

- Job: Fix the manuscript's characteristic-free terminology for the two Hankel-kernel cases independently of any known covering radius.
- First-pass accessibility: Yes.
- Friction: None; “split-free” and “shallow” are defined directly and symmetrically enough in context.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-03 / paragraph-0033.tex

- Job: Identify and bound the first contraction-stable obstruction: a common factor of all forms in \(W_f\) has degree at most two, and its three quadratic factorization types correspond to tangent, conjugate-secant, or rational-secant geometry.
- First-pass accessibility: Minor friction. The dimension bound is clear, but the geometric/depth classification is asserted faster than the preceding dictionary alone explains.
- Friction: The reader has not yet been told what contraction is, so “persists under contraction” is only a promise. More importantly, the passage from a common rational square or irreducible quadratic in \(W_f\) to a tangent or conjugate-secant syndrome direction is not spelled out, and calling those families “deep” silently invokes the full-support covering-radius regime. Why two distinct rational factors make the point shallow (presumably by adjoining further distinct rational factors to obtain a full split locator) is also omitted.
- Smallest high-value repair: Add one sentence applying the repeated-factor Hankel criterion to identify the square/irreducible cases, and one sentence stating the available-points hypothesis under which a split quadratic can be extended to a degree-\(r-2\) squarefree split member; specify that “deep” here refers to the full-support radius-\(r-1\) case.
- Finding: MINOR.
### packet-03 / paragraph-0034.tex — Subsection “Coding consequences and recognition”

- Job: Open the subsection translating the Hankel dictionary into coding results and practical recognition tests.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-03 / paragraph-0035.tex

- Job: State the exact coding payoff of a supported split locator, separate that construction from the covering-radius input needed to call its absence deep, and preview the deleted-support shell/extension consequences.
- First-pass accessibility: Yes. This paragraph supplies the object-level implication that the earlier proof roadmaps needed.
- Friction: None warranting repair; “covering-radius gate” is immediately explained as an independent condition rather than left as process shorthand.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-03 / paragraph-0036.tex

- Job: Advertise an algorithmic recognition route from a syndrome to its persistent geometric family, modular exceptional locus, or finite-field orbit representative.
- First-pass accessibility: Minor friction. Forming \(H_f\), computing \(W_f\), and taking a common gcd are actionable, but the modular branch is not yet a procedure.
- Friction: “the relevant contraction kernel” and “the modular locus” are not defined or cross-referenced, so a reader cannot tell which map/kernel to compute or how its output identifies \(\mathcal M^{\max}_{r,p}\). “Tests the listed geometric families” also overstates what has been listed operationally: the tangent/conjugate common-factor test is clear, while the remaining branches rely on future machinery or a supplement.
- Smallest high-value repair: Name the contraction map/kernel explicitly (or forward-reference its definition), identify the modular locus with \(\mathcal M^{\max}_{r,p}\), and present the recognition route as numbered branches with stated inputs and outputs.
- Finding: MINOR.
## packet-03 note

- Current mental model: A syndrome \(f\) is represented in the divided-power space \(\Gamma^{r-1}E\), while degree-\(r-2\) root/locator forms live in \(\operatorname{Sym}^{r-2}E^\vee\). The two-row Hankel matrix \(H_f\) defines an apolar kernel \(W_f\); a squarefree form in \(W_f\) split into supported rational linear factors is equivalent to expressing \(f\) in the span of the corresponding normal-rational-curve columns, hence gives coset weight at most \(r-2\). “Split-free” names the absence of such a form without assuming a radius; it becomes a deep-hole criterion only for the full-support code once radius \(r-1\) is supplied independently. A common factor of \(W_f\) has degree at most two, with square and irreducible-quadratic types intended to recover tangent and conjugate-secant families. The later contraction machinery is meant to detect the remaining modular obstruction.
- Questions carried forward: How is redundancy \(r\) related to dimension \(k\) after deleting \(s\) evaluation points, and is \(\mathrm{PRS}(k)\) used only for full support? What is the precise contraction map on \(f\), \(H_f\), or \(W_f\), and which kernel recognizes the Lucas locus? How exactly does a common quadratic factor force the corresponding tangent/conjugate-secant syndrome geometry, and under what available-root hypothesis does a split quadratic guarantee shallowness? What data make the advertised recognition procedure complete in finite exceptional fields?
- Top accessibility issue so far: The divided-power/Hankel interface is now substantially clearer—the recurrence interpretation, criterion, and coding consequence work well—but the notation table introduces a potentially conflicting full-support dimension/redundancy convention inside a deleted-support narrative. Explicitly separating full-support \(\mathrm{PRS}\) notation from general \(C_S(v)\) notation is the highest-value repair in this packet.
### packet-04 / paragraph-0037.tex

- Job: Contrast the proposed fixed-redundancy recognition method—row reduction plus family tests and polar induction—with brute-force enumeration of projective forms in \(W_f\).
- First-pass accessibility: Minor friction. The computational motivation is clear, but the replacement method is named rather than described.
- Friction: “the listed family-membership tests” has no immediate referent, and “coherent polar induction” is new disciplinary/manuscript terminology. A reader cannot tell what is polarized, what is inductive, or why coherence avoids searching \(\mathbb P(W_f)\).
- Smallest high-value repair: Point to the exact test list and add one clause defining polar induction's input/output, e.g. that it recursively tests compatible restrictions/derivatives of the binary-form system to recognize the orbit family without enumerating all kernel members.
- Finding: MINOR.
### packet-04 / paragraph-0038.tex — Section “The recursive carrier theorem” (`sec:recursive-carriers`)

- Job: Open the section developing the contraction-stable exceptional locus.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-04 / paragraph-0039.tex

- Job: Announce the recursive strategy: contract to a terminal exceptional locus, analyze the linear subspaces lying in it fiberwise, and consolidate all characteristic-dependent exceptions into one linear carrier.
- First-pass accessibility: Minor friction. The broad reduction strategy is visible, but none of its object-level terms is yet anchored.
- Friction: “composite contraction,” “terminal bad locus,” “reduction in each geometric fiber,” and “modular descendants” do not identify the spaces, maps, or parameter fibers involved. “After reduction” is especially ambiguous between algebraic reduction, row reduction, and reduction modulo the characteristic.
- Smallest high-value repair: Add a setup sentence naming the source/target of one contraction, the terminal redundancy, and the parameter over which the fibers vary; replace “after reduction” with the precise operation intended.
- Finding: MINOR.
### packet-04 / paragraph-0040.tex — Equation defining the maximal Lucas carrier (`eq:maximal-lucas-carrier`)

- Job: Define the characteristic-dependent linear carrier \(\mathcal M^{\max}_{r,p}\), including boundary binomial conventions and the empty case, and introduce the other exceptional scheme \(\mathcal P_r\).
- First-pass accessibility: Major friction. The Lucas carrier is explicit, but the equally central catalecticant scheme is only named.
- Friction: “rank-at-most-two consecutive catalecticant scheme” does not specify the catalecticant matrix, its dimensions, or its equations. Because the only displayed Hankel/catalecticant so far is the two-row \(H_f\), whose rank is automatically at most two, a cold reader cannot infer which larger consecutive catalecticant is intended. Nor is the geometric relation of \(\mathcal P_r\) to secant/tangent points stated here.
- Smallest high-value repair: Display the relevant catalecticant matrix (or give an exact prior definition reference) and say that \(\mathcal P_r\) is its \(3\times3\)-minor locus / the second secant variety of the normal rational curve, if that is the intended identification.
- Finding: MAJOR.
### packet-04 / paragraph-0041.tex — Definition “Reduced terminal bad scheme” (`def:terminal-bad-scheme`)

- Source metadata: `coverage{absent}`; computer-assisted statement checked by “Certificate SC.”
- Job: Give explicit integral equations for the terminal exceptional scheme in Plücker coordinates of a cubic pencil and state the elimination/collision cleanup used to obtain them.
- First-pass accessibility: Major friction. The equations are reproducible as data, but a reader cannot tell what geometric property their zero locus encodes.
- Friction: The cubic pencil itself and its six Plücker coordinates are not constructed, so the origin of \(\Phi_z(t,s)\) and the roles of \(t,s\) are opaque. “off-diagonal ordered-pair equation,” “diagonal factor,” “symmetric residual factorization,” and “anti-invariant collision component” are unexplained elimination language. It is not stated as an iff what \(z\in V(K)\) means for the pencil, and “Certificate SC” is neither expanded nor located.
- Smallest high-value repair: Before the formula, define a pencil \(\langle F,G\rangle\subset\operatorname{Sym}^3E^\vee\), its Plücker coordinates, and the bad geometric condition. After the formula, state explicitly “\(z\in V(K)\) iff … after excluding …”; add an exact pointer to Certificate SC and one sentence on what the certificate verifies.
- Finding: MAJOR.
### packet-04 / paragraph-0042.tex — continuation of Definition “Reduced terminal bad scheme” (`def:terminal-bad-scheme`)

- Job: Pull the Plücker-coordinate ideal back to redundancy-five syndrome coordinates, separate the catalecticant-determinant component from the residual component, reduce in characteristic \(p\), and define their union as the fixed terminal bad scheme.
- First-pass accessibility: Major friction. The algebraic operations are explicit, but the ambient objects and their geometric/coding meanings remain unstated.
- Friction: The coordinates \(c_0,\ldots,c_4\) are introduced without saying they represent a terminal syndrome \(f\in\mathbb P(\Gamma^4E)\), and the map \(z(c)\) is not identified as the Plücker map of \(W_f\). The reader must guess that \(D=0\) is the rank-two catalecticant component, why the residual ideal is saturated by \(D\), and what property makes points of \(V(I_{\mathrm{res},p})\) “bad.” The final census disclaimer clarifies provenance but not semantics.
- Smallest high-value repair: State the ambient map \(c\mapsto W_c\mapsto z(c)\), identify \(V(D)\) geometrically, and give the badness equivalence for the residual locus before presenting the saturation/radical formula.
- Finding: MAJOR.
### packet-04 / paragraph-0043.tex

- Job: Explain the logical role of the next results and give first-pass readers an explicit route around the elimination details while assuring them those details establish exhaustiveness without extra hypotheses.
- First-pass accessibility: Yes. The navigation advice is concrete and the dependency claim is clear.
- Friction: None requiring repair in this roadmap paragraph.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-04 / paragraph-0044.tex — Proposition “Computer-assisted terminal decomposition” (`prop:reduced-terminal-carrier`)

- Source metadata: `coverage{absent}`; evidence `certificate-stable-components`; displayed labels `eq:terminal-residual-param`, `eq:terminal-char3-prime`.
- Job: State the certified irreducible decomposition of the terminal bad scheme and describe the residual prime explicitly in generic characteristic and in characteristics two and three, including the divided-power/plain-coefficient conversion.
- First-pass accessibility: Minor friction. The parametrizations make the characteristic-wise result concrete, but the final structural conclusion is not interpreted.
- Friction: “the bottom \(c_i\)” has no visible referent in this paragraph. The switch from divided-power coordinates \(c_i\) to ordinary quartic coefficients \(z_i\) is useful but sentence-dense. Most importantly, “There is no flat reduced integral model having exactly these residual fibers” arrives without saying why this matters—whether it prevents one universal carrier equation, explains the separate modular components, or affects specialization of the certificate.
- Smallest high-value repair: Replace “bottom” by “syndrome coordinates,” split the coordinate-conversion explanation into a short remark, and append one consequence clause explaining why non-flatness forces the characteristic-two/three residual carriers to be treated separately.
- Finding: MINOR.
### packet-04 / paragraph-0045.tex — continuation of Proposition “Computer-assisted terminal decomposition” (`prop:reduced-terminal-carrier`)

- Job: Give the geometric meaning of the terminal bad scheme's complement and connect that condition to the later exact redundancy-five count and branch lemma.
- First-pass accessibility: Minor friction. An algebraic geometer can parse the monodromy criterion, but the pencil-to-cover construction and its coding role are not stated.
- Friction: “base-point-free separable terminal pencil,” “its cubic map,” and “geometric \(S_3\) monodromy” are not tied to an explicit map (presumably the ratio of two cubics \(\mathbb P^1\to\mathbb P^1\)). It is also unclear why full \(S_3\) monodromy is exactly the good case needed by the point count.
- Smallest high-value repair: Identify the cubic cover attached to a pencil and add one clause: outside the bad scheme its full \(S_3\) monodromy permits the Chebotarev/genus-one count of completely split fibers used to construct the locator.
- Finding: MINOR.
### packet-04 / paragraph-0046.tex — proof of terminal decomposition (part 1)

- Job: Derive the elimination setup geometrically from the Hankel-to-Plücker map and classify possible factorization components under the swap involution, excluding the anti-invariant collision case.
- First-pass accessibility: Minor friction. The explicit Grassmannian map and three involution cases provide a real argument, but the saturation bookkeeping is still expressed in private shorthand.
- Friction: “diagonal and collision factors already charged as deletion divisors” does not define the divisors, where they were charged, or why saturation removes exactly irrelevant configurations. “factorization locus of \(\Phi_z\)” still lacks the stated factorization pattern that constitutes badness. “the residual component below” is a fragile positional reference.
- Smallest high-value repair: Name the excluded divisors and the geometric degeneracies they represent, state the required factorization type of \(\Phi_z\), and replace “below” with the residual prime's label/description.
- Finding: MINOR.
### packet-04 / paragraph-0047.tex — proof of terminal decomposition (part 2)

- Job: Supply a compact ideal-containment/saturation check that independently exposes the residual component and explains the exceptional characteristic-three treatment.
- First-pass accessibility: Minor friction. The three ideal relations communicate the algebraic point, but the reader cannot verify what \(V\) is at the moment it is invoked.
- Friction: “the seven-generator residual ideal printed below” is an unresolved forward positional reference, and “exact reduction” does not say whether this means Gröbner reduction with respect to a specified basis/order or another certificate. The relation of \(V\) to the generic Veronese parametrization could be stated explicitly.
- Smallest high-value repair: Give \(V\) a displayed label or immediate definition and say “Gröbner reduction against [basis/order/certificate] proves …”; identify \(V\) as the ideal of the generic residual Veronese component.
- Finding: MINOR.
### packet-04 / paragraph-0048.tex — proof of terminal decomposition (part 3)

- Job: Print generators for the generic residual prime, state the direct characteristic-two/three specializations, and dispose of an additional ruled possibility via a Hessian rank calculation.
- First-pass accessibility: Minor friction. The ideal generators are usable, but the final geometric sentence is too compressed to understand.
- Friction: “ordered-Hessian calculation,” “its complementary ruling,” and “to rank one” do not identify the Hessian map, the ruled variety/component, or the target rank-one locus. The pronoun “its” could refer to the characteristic-three prime, the residual surface, or the elimination construction, and the consequence for the component decomposition is unstated.
- Smallest high-value repair: Expand the last sentence to name the source ruling and target rank-one/catalecticant locus and explain that this ruling contributes no new noncollision component; add a reference to the displayed Hessian calculation if it occurs elsewhere.
- Finding: MINOR.
## packet-04 note

- Current mental model: The recursive proof contracts the Hankel/apolar problem to redundancy five, where a syndrome quartic \(c\in\mathbb P(\Gamma^4E)\) determines a two-dimensional cubic kernel \(W_c\), hence a point of \(\operatorname{Gr}(2,\Gamma^3E)\) via explicit Plücker minors \(z(c)\). A symmetric ordered-pair polynomial \(\Phi_z(t,s)\) detects exceptional factorization/monodromy behavior of the cubic pencil. After removing diagonal/collision degeneracies, its pulled-back bad locus is the union of the catalecticant cubic \(D=0\) and one residual prime: generically a Veronese surface of quartic squares, with distinct plane/cone fibers in characteristics two/three. Outside this reduced terminal bad scheme, a base-point-free separable pencil has full geometric \(S_3\) monodromy and is eligible for the later exact split-fiber count. The general Lucas carrier is an explicit coordinate subspace selected by adjacent binomial zeros; later results are meant to identify which terminal components persist back up the contraction tower.
- Questions carried forward: What exact catalecticant matrix defines \(\mathcal P_r\) for general \(r\)? What bad pencil property is equivalent to the factorization of \(\Phi_z\), and exactly which diagonal/collision divisors are removed? How is the cubic cover attached to \(W_c\), and why does full \(S_3\) monodromy yield the desired split locator count? Which generic and characteristic-two/three residual components lift under contraction, and how do all modular descendants merge into \(\mathcal M^{\max}_{r,p}\)? What is the ordered-Hessian map and the complementary ruling it eliminates?
- Top accessibility issue so far: The packet gives admirably explicit equations and a useful skip route, but the definition of the terminal bad scheme presents elimination outputs before stating the geometric iff they encode. One sentence defining the cubic pencil/cover and saying “a terminal point is bad exactly when …” would make the Plücker polynomial, saturation, component decomposition, and later monodromy statement cohere for readers crossing from coding theory.
### packet-05 / paragraph-0049.tex

- Job: Explain the exact computer-assisted exhaustiveness check and locate the reproducible Python/Singular certificate inputs.
- First-pass accessibility: Yes. The incidence–saturation–elimination–prime/fiber workflow and the trust boundary are stated concretely.
- Friction: None warranting repair here; the relative supplement path and hash-pinning statement make “Certificate SC” materially less opaque than before.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-05 / paragraph-0050.tex — proof of terminal decomposition (conclusion)

- Job: Verify primeness, noncontainment, irredundancy/reducedness, absence of embedded primes, component degrees, nonexistence of a flat integral model, and certificate coverage.
- First-pass accessibility: Minor friction. The algebraic-geometric checklist is complete, but two sentences require unnecessary backtracking and “respectively” bookkeeping.
- Friction: The three witness points are matched only by “respectively” to the generic, characteristic-two, and characteristic-three residual components; their ambient characteristics are not stated inline. “The final assertion” refers back several paragraphs to nonexistence of a flat reduced integral model, so its Hilbert-polynomial argument is hard to place. “intersection with \((D)\)” could also be read as a set-theoretic intersection rather than the ideal intersection defining the union.
- Smallest high-value repair: Name each witness together with its component/characteristic, replace “final assertion” by the assertion itself, and write “the intersection of the residual ideal with \((D)\) defines an irredundant reduced union.”
- Finding: MINOR.
### packet-05 / paragraph-0051.tex — proof of terminal decomposition (monodromy conclusion)

- Job: Identify the residual factorization locus with cyclic cubic monodromy and conclude that every pencil outside the terminal bad scheme has full geometric \(S_3\) monodromy.
- First-pass accessibility: Yes. This supplies the clean geometric iff that makes the earlier ordered-pair elimination meaningful.
- Friction: None requiring repair for a mathematically mature reader; the transitive-subgroup dichotomy \(C_3\) versus \(S_3\) and the off-diagonal reducibility criterion are stated in the needed form.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-05 / paragraph-0052.tex — Definition “Coherent polar flag”

- Job: Define the recursive contraction data from redundancy \(r\) to five and the reverse lifting operation, including distinctness, nonvanishing, and persistence of previously chosen markers as exclusions.
- First-pass accessibility: Major friction. This is the first formal definition of the central recursive object, but its operation and compatibility condition are still undefined.
- Friction: Neither the contraction \(\iota_{\lambda_j}f_j\) nor the type of a “geometric marker” \(\lambda_j\) is stated; a reader needs to know whether \(\lambda_j\in\mathbb P(E^\vee)\) and whether \(\iota_\lambda\) is divided-power interior multiplication/evaluation. “Every earlier marker remains a forbidden root for the lower witness system” is not translated into a formula involving \(W_{f_{j-1}}\), so the ordering and quantifiers are ambiguous. The reverse map is delegated to an equation not yet intelligible in this reading sequence.
- Smallest high-value repair: Immediately define \(\iota_\lambda:\Gamma^{j-1}E\to\Gamma^{j-2}E\), specify marker space/rationality, and write the coherence condition symbolically (which \(\lambda_i\), which \(W_{f_k}\), and what “forbidden” means). Give the lift's source/target even if its formula is cross-referenced.
- Finding: MAJOR.
### packet-05 / paragraph-0053.tex — Proposition “Maximal Lucas union” (`prop:maximal-lucas-union`)

- Source metadata: `coverage{absent}`; imports `wang-wu-hu`.
- Job: Assert that all characteristic-dependent nuclei arising anywhere in a coherent contraction/lift tower consolidate exactly into the one explicit Lucas linear scheme, with a degree-one intersection bound for external polar lines.
- First-pass accessibility: Major friction. The set-theoretic conclusion is readable, but the geometric objects quantified over are not defined.
- Friction: “normal-rational-curve nucleus,” “later lift,” and “polar line” have no definitions or ambient spaces. It is therefore unclear whether the reduced union ranges over all possible flags/markers and levels, how a lower-dimensional nucleus is embedded back into \(\mathbb P(\Gamma^{r-1}E)\), and why the final line-intersection statement matters for recursive component selection.
- Smallest high-value repair: Define a level-\(j\) nucleus and its lift to level \(r\), state the union's quantifiers explicitly (“over every level and every coherent flag”), define the polar line, and add one clause explaining that the degree-one bound prevents an uncontained contraction family from being trapped in the Lucas carrier.
- Finding: MAJOR.
### packet-05 / paragraph-0054.tex — proof of “Maximal Lucas union”

- Job: Prove carrier consolidation combinatorially by tracking zero-binomial coordinate supports through a lift operator and Pascal's identity, then deduce the polar-line degree bound from linearity.
- First-pass accessibility: Minor friction. The support recursion is explicit and persuasive, but the initial nucleus criterion and lift quantifiers are underexplained.
- Friction: “order-\(a\) nucleus” is still undefined, and saying its conditions “include the row \(d\)” presupposes a binomial-matrix description not shown. The relation among \(a,d\), contraction level, and syndrome degree is absent. “one coherent lift” seems weaker than the proposition's “every later lift” unless all lifts have this same support rule. “earlier descendant in the last one” reverses the family-tree language and is hard to visualize.
- Smallest high-value repair: State the coordinate equations defining the order-\(a\) nucleus and clarify that every allowed lift induces the displayed support operator (or explain why one canonical lift suffices). Replace the descendant sentence by an explicit nested-support statement indexed by levels.
- Finding: MINOR.
### packet-05 / paragraph-0055.tex

- Job: Delimit the exact imported Wang–Wu–Hu result about when a Lucas block exists as projective sublines, and separate that endpoint arithmetic from the manuscript's carrier nesting and Hankel-incidence work.
- First-pass accessibility: Major friction. The imported criterion cannot be connected to the present notation without consulting the cited paper.
- Friction: “Lucas block” and “endpoint arithmetic” are undefined, and \(k=p^a+1\) reuses \(k\), already declared to mean code dimension, apparently in a different literature-specific role. “We use this criterion at that exact boundary” does not identify which boundary case in \(r,p,e\) or which step of the proposition depends on it. The distinction between a block, its projective sublines, the adjacent-zero carrier, and a nucleus is not explained.
- Smallest high-value repair: Restate the cited proposition in the manuscript's own variables, define the relevant block/subline inside \(\mathcal M^{\max}_{r,p}\), and name the exact lemma/case where the divisibility criterion is used; avoid reusing \(k\) unless it is truly code dimension.
- Finding: MAJOR.
### packet-05 / paragraph-0056.tex — Definition “Reduced recursively contained carrier”

- Job: Define the global exceptional carrier as the reduced union of upper-level components generically trapped in the terminal bad scheme plus all lifted intermediate nuclei, while excluding gcd and collision strata handled elsewhere.
- First-pass accessibility: Major friction. The definition depends on several families and exclusions whose ambient schemes and quantifiers have never been made explicit.
- Friction: “irreducible upper components” does not say components of which scheme; “generic coherent contraction row space” does not specify the contraction parameter space or whether containment must hold for one, every, or a dense set of coherent flags. A row space is said to lie in a component of a syndrome scheme, which obscures the intervening Grassmannian/Hankel map. “fixed-gcd strata,” “lower packages,” and “deletion divisors” are internal labels rather than defined exclusions, so the reader cannot determine the actual set being defined.
- Smallest high-value repair: Give a set-theoretic/incidence-correspondence formula with named source, flag parameter space, contraction map, and quantifier; then list the two excluded closed strata with exact definitions or cross-references and state where each is treated.
- Finding: MAJOR.
### packet-05 / paragraph-0057.tex — Theorem “Recursive carrier” (`prop:recursive-component-selection`)

- Source metadata: `coverage{fragment}`; displayed equality `eq:recursive-carrier`.
- Job: State the main recursive classification: after the stipulated exclusions, the only components trapped all the way down the contraction tower are the catalecticant locus and maximal Lucas carrier.
- First-pass accessibility: Minor friction. The headline equality is memorable and easy to parse, but the scope exclusions are again described by package language.
- Friction: “Fixed linear gcds retain their quadratic-graph package” does not tell the reader what locus survives, what “retain” means under contraction, or where that package is classified. “marker collisions remain deletion divisors” similarly states an accounting disposition rather than a mathematical condition. Since both are excluded from the carrier equality, their separate treatment matters to understanding exhaustiveness.
- Smallest high-value repair: Replace each package label with a one-line mathematical description and exact cross-reference: identify the fixed-gcd component and explain why it is handled by the tangent/secant classification; identify the collision divisor and explain how avoiding deleted/previous marker points removes it.
- Finding: MINOR.
### packet-05 / paragraph-0058.tex — proof of “Recursive carrier” (geometric component selection)

- Job: Express composite contraction by \(m\) marker factors as multiplication of their coefficient row by a catalecticant matrix, then use geometric density/irreducibility to reduce generic terminal containment to containment in one terminal component.
- First-pass accessibility: Minor friction. This is the first concrete formula for composite contraction and the component-selection argument is understandable, but its indexing is not tied back to the flag definition.
- Friction: “Retain \(m\) markers” does not say whether \(m=r-5\), why their product has coefficient row \(h\), or explicitly identify \(h\operatorname{Cat}_{m,4}(f)\) with the coordinate vector of \(f_5\). “Deleting the projective kernel” would be easier to parse if the rational map from marker-product forms to bottom syndromes were named. “kernel checked” is formalization-process jargon unless the ledger declaration is identified.
- Smallest high-value repair: Set \(m=r-5\), write the marker product and its coefficient vector, state \(f_5=h\operatorname{Cat}_{m,4}(f)\), and name the induced projective linear map before invoking density and irreducibility.
- Finding: MINOR.
### packet-05 / paragraph-0059.tex — proof of “Recursive carrier” (four-row component calculation)

- Job: Classify which projective linear subspaces can lie in each terminal component and compute how each can lift: the catalecticant component persists as \(\mathcal P_r\), generic/characteristic-three residual pieces collapse to rank one, and the characteristic-two plane produces precisely the nested Lucas lifts.
- First-pass accessibility: Major friction. The four-row table is a strong summary, but the single long calculation paragraph crosses four characteristics/components and several determinantal ideals without enough local signposting.
- Friction: “possible linear part” is not defined as a linear subspace contained in the terminal component, and \(c_i=xd_i+yd_{i+1}\) is not introduced as the parametrization of a polar line/one-step lift. “consecutive Fano identity,” “coefficient ideal,” “persistent \(3\times3\)-minor ideal,” “binary-plane descendant,” and the successive binary line/central point chain are unexplained. Pronouns such as “their” and “it” become ambiguous across component changes. The significance of rank-one lifts—presumably containment in \(\mathcal P_r\)—is only partly stated.
- Smallest high-value repair: Keep the table but define its columns and the line substitution immediately below it; then split the calculation into four labeled component cases, each with the same three sentences: substitute, identify the coefficient/minimal-prime ideal, conclude the upper carrier. Display the characteristic-two nested coordinate supports explicitly.
- Finding: MAJOR.
### packet-05 / paragraph-0060.tex — proof of “Recursive carrier” (certificate and induction conclusion)

- Job: State which certificate module verifies the component-lift substitutions and close the exhaustiveness proof by induction on contraction depth.
- First-pass accessibility: Yes. The verification boundary and logical conclusion are concise after the preceding component table.
- Friction: None warranting repair here.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
## packet-05 note

- Current mental model: The terminal scheme calculation is now semantically grounded: for a base-point-free separable cubic pencil, reducibility of its off-diagonal ordered-pair curve detects cyclic \(C_3\) monodromy, so the complement of the saturated factorization locus has full \(S_3\) monodromy. For general redundancy, choosing \(m=r-5\) marker factors amounts to contracting the syndrome through the catalecticant map \(h\operatorname{Cat}_{m,4}(f)\); geometric density lets the closure of attainable terminal syndromes be treated as a projective row space. An irreducible such row space trapped in the terminal bad union must lie in one terminal component. The four-row component calculation says the catalecticant component lifts to \(\mathcal P_r\), generic and characteristic-three residual linear pieces lift only to rank one (hence already into \(\mathcal P_r\)), and the characteristic-two plane yields nested coordinate descendants contained in the Lucas carrier. Independently, Pascal-zero support propagation merges all intermediate normal-rational-curve nuclei and their lifts into \(\mathcal M^{\max}_{r,p}\). Thus the recursively trapped carrier is exactly \(\mathcal P_r\cup\mathcal M^{\max}_{r,p}\).
- Questions carried forward: What is the precise divided-power contraction \(\iota_\lambda\), and what formula expresses coherence/marker avoidance at every lower \(W_{f_j}\)? What exactly is an order-\(a\) NRC nucleus, and how does the cited projective-subline criterion translate into the manuscript's \(r,p,e\) variables? What incidence correspondence formally defines “recursively contained,” including its quantifier over flags? How are fixed-gcd strata and marker-collision divisors handled in the later construction rather than merely excluded? In the component table, what is the polar-line substitution and how do its characteristic-two support descendants appear explicitly?
- Top accessibility issue so far: The terminal monodromy/certificate story is now reasonably clear, but the recursive layer still defines its core objects through internal labels. A typed definition of contraction and a symbolic coherence condition—followed by a precise incidence-based definition of recursive containment—would unlock the theorem for readers outside the authors' polar-induction framework. The four-row table is the right summary, but its proof should be split into four parallel cases.
### packet-06 / paragraph-0061.tex — Theorem “Arbitrary-redundancy carrier theorem” (`thm:recursive-carrier`)

- Source metadata: `coverage{absent}`; uses `thm:simultaneous-marker-escape`; evidence `certificate-stable-components`; proves `recursive-carrier-classification`; threshold label `eq:uniform-threshold`.
- Job: State the uniform full-support theorem: above an explicit field threshold, every split-free syndrome lies in the two carriers; in nonmodular characteristic this yields the exact tangent/conjugate-secant deep-hole classification and count, with a sharper binary containment threshold and an orbit description.
- First-pass accessibility: Major friction. The carrier/classification/count statements are readable, but the orbit sentence introduces an entirely new invariant-theory layer with no definitions.
- Friction: \(T/T^{r-1}\), inversion, “coefficient Frobenius,” and the tangent cocycle \(z\mapsto z+(r-1)u\) appear without defining \(T,z,u\), the acting equivalence relation, or what object the “orbit law” classifies. The deep-hole conclusion also silently relies on the covering-radius hypothesis needed to turn split-free into deep, rather than naming that input here. The relation between this theorem's \(Q_r^*\) and the earlier deleted-support \(Q_{r,s}^*\) is not flagged.
- Smallest high-value repair: Move the orbit law to a separate, fully defined corollary/remark (or define the torus/parameters and orbit set here), and add one clause naming the covering-radius result used for the deep-hole equivalence. State that this is the \(s=0\) specialization of the later/deleted-support threshold.
- Finding: MAJOR.
### packet-06 / paragraph-0062.tex — proof of arbitrary-redundancy carrier theorem (containment)

- Job: Derive carrier containment by combining recursive-carrier exhaustiveness with simultaneous construction of a split squarefree kernel member outside the carrier, and identify the threshold source.
- First-pass accessibility: Minor friction. The logical dependency is clear, but the quantitative input is named rather than interpreted.
- Friction: “Its strict genus-one inequality” does not say what is being counted or which two quantities the threshold makes positive. “no intermediate lower package is assumed” is internal proof-management language; the useful mathematical point is presumably that the argument does not induct on already-classified redundancies.
- Smallest high-value repair: Say that the genus-one point estimate guarantees at least one split cubic fiber after exclusions and that solving its positivity condition yields \(Q_r^*\); replace the final clause by “the proof does not assume classifications at redundancies \(6,\ldots,r-1\).”
- Finding: MINOR.
### packet-06 / paragraph-0063.tex — proof of arbitrary-redundancy carrier theorem (classification)

- Job: Eliminate the Lucas carrier in large characteristic, classify the rank-two catalecticant points by splitting type, invoke the known covering-radius range, and conclude the count/orbit statement.
- First-pass accessibility: Minor friction. The Pascal-row and rank-two classification argument is compact and intelligible; the enumerative/orbit conclusion is not actually exposed.
- Friction: “persistent calculation already used at R6 and R7” neither expands the redundancy shorthand nor gives a lemma/reference or the calculation. A reader cannot learn why the tangent and conjugate-secant projective counts sum to \(q(q+1)^2/2\), much less recover the undefined orbit law. The sentence also makes the arbitrary-\(r\) result sound dependent on fixed-level work despite the previous paragraph's nondependence claim, unless “used at” means merely reused notation.
- Smallest high-value repair: Cite or include a short standalone rank-two orbit/count lemma valid for all \(r\), with its parameters defined; clarify that the R6/R7 sections instantiate rather than supply this lemma.
- Finding: MINOR.
### packet-06 / paragraph-0064.tex

- Job: Delimit the theorem's scheme-theoretic and arithmetic scope: it concerns reduced fibers, does not control nilpotents in an integral model, and in small characteristic localizes rather than resolves all extra split-free points.
- First-pass accessibility: Yes. This is a precise and valuable qualification, and the final sentence cleanly states what is proved off the carrier.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-06 / paragraph-0065.tex — Proposition “Upper-level radius gate” (`prop:upper-radius`)

- Source metadata: `coverage{fragment}`; imports `duer`, `seroussi-roth`.
- Job: Record the exact full-support covering-radius inputs needed at the three upper fixed redundancies and the general large-characteristic radius conclusion.
- First-pass accessibility: Yes. The numerical ranges and role as an imported gate are explicit; with the earlier \(r=q+1-k\) convention, the three lines correspond transparently to redundancies eight, nine, and ten.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-06 / paragraph-0066.tex — proof of upper-level radius gate

- Job: Verify the hypotheses of Seroussi–Roth's nonextendability theorem and pass to the covering radius through Dür/Kaipa, explicitly isolating the imported step used to turn split-free syndromes into deep holes.
- First-pass accessibility: Yes. The inequality, exception check, and two-stage literature implication are all stated clearly.
- Friction: None requiring repair; “R8–R10” is readily understood here from the immediately preceding three displayed cases.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-06 / paragraph-0067.tex — Section “Simultaneous contraction and escape” (`sec:simultaneous-contraction`)

- Job: Open the section proving construction of a supported split locator outside the recursive carrier.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-06 / paragraph-0068.tex

- Job: State the key methodological simplification: outside the trapped carrier, choose all contraction markers simultaneously rather than inductively searching for good fibers, and perform only one terminal redundancy-five count.
- First-pass accessibility: Yes. The contrast with intermediate-fiber induction is concise and now grounded by the previous catalecticant row-space discussion.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-06 / paragraph-0069.tex — Definition of composite contraction (`eq:composite-contraction`)

- Job: Finally define contraction invariantly as the operation adjoint to multiplication by a root form under the divided-power/symmetric-power pairing.
- First-pass accessibility: Minor friction. The defining equation is elegant, but the source/target degrees and a notation collision are left implicit.
- Friction: The reader must infer that \(0\le m\le r-1\), \(\iota_Rf\in\Gamma^{r-1-m}E\), and the test form is \(h\in\operatorname{Sym}^{r-1-m}(E^\vee)\). The ground field is called \(k\), although \(k\) was explicitly assigned to code dimension in the notation table; switching meanings at this central definition is avoidable friction.
- Smallest high-value repair: State the full typed map \(\iota_R:\Gamma^{r-1}E\to\Gamma^{r-1-m}E\) and the degree of \(h\), and use \(K\) (or retain \(\mathbb F_q\)) for the ground field.
- Finding: MINOR.
### packet-06 / paragraph-0070.tex — Proposition “Composite contraction” (`thm:composite-contraction`)

- Source metadata: `coverage{absent}`.
- Job: State the exact compatibility between contraction and Hankel witness systems, its functorial/equivariant behavior, and the criterion for lifting a split squarefree lower locator by multiplying back the marker product.
- First-pass accessibility: Yes. This is the clean algebraic backbone missing from the earlier coherent-flag discussion.
- Friction: None requiring repair; the degree of \(h\) makes the contraction target inferable even if it would be helpful in the preceding definition.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-06 / paragraph-0071.tex — proof of composite contraction proposition

- Job: Prove witness-system compatibility directly from the pairing and dispose of functoriality/equivariance and squarefreeness by standard arguments.
- First-pass accessibility: Yes. The proof is short, typed by the preceding proposition, and exposes why exactly two Hankel equations occur (one for each \(\lambda\in E^\vee\) direction).
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-06 / paragraph-0072.tex

- Job: Transition from the algebraic contraction identity to the finite-field selection result that will construct the marker product \(R\).
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
## packet-06 note

- Current mental model: The full-support arbitrary-redundancy theorem combines the recursively trapped carrier \(\mathcal P_r\cup\mathcal M^{\max}_{r,p}\) with a simultaneous-marker escape theorem: outside that carrier, one directly constructs a squarefree split member of \(W_f\), hence the syndrome is shallow. In characteristic \(p>r-1\), Pascal row \(r-2\) has no internal zeros, so the Lucas carrier disappears; the rank-two catalecticant locus then divides into shallow curve/rational-secant points and split-free tangent/conjugate-secant points. An explicit imported nonextendability-to-radius implication makes split-free equivalent to deep in the required full-support ranges. The contraction operation is now cleanly defined by adjunction, \(\langle\iota_Rf,h\rangle=\langle f,Rh\rangle\), and satisfies \(h\in W_{\iota_Rf}\iff Rh\in W_f\). Thus a lower split locator coprime to the simultaneously chosen marker product \(R\) lifts to the desired degree-\(r-2\) locator.
- Questions carried forward: What finite-field lemma selects the distinct rational roots of \(R\), and what polynomial/degree-six condition ensures the resulting terminal row space is good? How does the genus-one split-fiber count produce the exact threshold \(6r-16+\lfloor2\sqrt{6r-18}\rfloor\), and how do deletions change it to \(Q_{r,s}^*\)? What precisely is the torus \(T\), the quotient \(T/T^{r-1}\), and the tangent cocycle in the theorem's orbit law? Where is the rank-two tangent/conjugate-secant count proved uniformly in \(r\)?
- Top accessibility issue so far: The contraction mechanism is finally presented in a crisp invariant form, and this packet is much easier to follow than the prior recursive-component calculations. The main remaining accessibility failure is the unexplained orbit law embedded in the headline theorem; it should be separated and fully defined so it does not interrupt an otherwise clear carrier/deep-hole statement.
### packet-07 / paragraph-0073.tex — Lemma “Vandermonde grid” (`lem:vandermonde-grid`)

- Source metadata: `coverage{absent}`.
- Job: Provide the elementary finite-field selection lemma needed to choose distinct marker roots outside a prescribed deleted set while avoiding the zero locus of a bounded individual-degree polynomial.
- First-pass accessibility: Yes. Hypotheses, conclusion, and the roles of \(d,m,s\) are explicit.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-07 / paragraph-0074.tex — proof of Vandermonde grid lemma

- Job: Enforce distinctness and avoidance by multiplying by Vandermonde and forbidden-point factors, then use injectivity of evaluation for individual degrees below \(q\).
- First-pass accessibility: Yes. The construction and degree count make the lemma immediate.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-07 / paragraph-0075.tex

- Job: Specialize composite contraction to the \(m=r-5\) marker product and identify its redundancy-five syndrome coordinates with the catalecticant row-map formula.
- First-pass accessibility: Yes. This explicitly connects the invariant contraction definition to the earlier matrix calculation.
- Friction: None requiring repair in context.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-07 / paragraph-0076.tex — Lemma “Terminal selector” (`lem:terminal-selector`)

- Source metadata: `coverage{absent}`.
- Job: Produce a low-degree equation separating the attainable terminal row space from the reduced bad carrier; pulling it back along the marker contraction gives a nonzero bounded-individual-degree polynomial to which the Vandermonde grid lemma can be applied.
- First-pass accessibility: Minor friction. The strategy is now concrete, but one phrase and the degree variables admit two readings.
- Friction: “nonzero on \(L_f\)” could mean nowhere vanishing, whereas the needed conclusion is presumably that \(F_f|_{L_f}\) is not identically zero. “degree … in each marker” does not specify affine marker coordinates or explain why substituting the product \(\lambda_1\cdots\lambda_m\) preserves the same individual degree bound.
- Smallest high-value repair: Write “whose restriction to \(L_f\) is not the zero polynomial,” choose affine coordinates \(t_i\) for the markers, and add that the contracted syndrome is linear in the coefficients of each \(\lambda_i\), hence \(\deg_{t_i}S_f\le\deg F_f\).
- Finding: MINOR.
### packet-07 / paragraph-0077.tex — proof of terminal selector (separating equation)

- Job: Construct the selector explicitly as the product of one nonvanishing equation from each terminal component and derive the degree bounds from the certified component equations.
- First-pass accessibility: Yes. Irreducibility/domain arguments explain why the product remains nonzero on \(L_f\), while vanishing on the union is immediate.
- Friction: None requiring repair; in context \(D|_{L_f}\ne0\) and \(G|_{L_f}\ne0\) are naturally read as nonzero restrictions.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-07 / paragraph-0078.tex — proof of terminal selector (pullback)

- Job: Prove that the selector remains a nonzero polynomial in ordered marker coordinates and retains the individual degree bound.
- First-pass accessibility: Yes. Geometric surjectivity of factorization plus surjectivity onto the row space addresses nonzeroness, and multilinearity of the root-product coefficients addresses degree.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-07 / paragraph-0079.tex — Theorem “Simultaneous-marker escape” (`thm:simultaneous-marker-escape`)

- Source metadata: `coverage{absent}`.
- Job: State the uniform construction theorem: outside the two carriers and above the explicit general/binary thresholds, \(W_f\) contains a degree-\(r-2\) squarefree form split entirely over allowed evaluation points.
- First-pass accessibility: Yes. The hypotheses, avoided set, conclusion, and binary improvement are all explicit.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-07 / paragraph-0080.tex — proof of simultaneous-marker escape (marker selection)

- Job: Move infinity into the retained support, apply the selector and Vandermonde grid lemmas to choose all distinct allowed markers at once, and compare the resulting mild selector bound with the theorem's stronger threshold.
- First-pass accessibility: Yes. The coordinate choice, avoidance condition, terminal-goodness conclusion, and numerical degree calculation are easy to follow.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-07 / paragraph-0081.tex — proof of simultaneous-marker escape (terminal count and threshold)

- Job: Use full \(S_3\) monodromy and the exact genus-one/branch estimate to count split terminal cubics, subtract those meeting markers or deleted points, solve the positivity inequality exactly, and lift a surviving cubic by multiplying with \(R\).
- First-pass accessibility: Yes. This paragraph finally exposes the complete quantitative chain behind \(Q^*_{r,s}\), including the binary improvement.
- Friction: None requiring repair at this level; the future terminal-count proposition is cited, its usable bound is printed, and every subsequent inequality is motivated.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-07 / paragraph-0082.tex

- Job: Signal a quantitative strengthening from existence to abundance of supported split locators.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-07 / paragraph-0083.tex — Corollary “Split-witness abundance” (`cor:split-witness-abundance`)

- Source metadata: `coverage{absent}`.
- Job: Quantify the construction uniformly for fixed \(r,s\), emphasizing that the displayed expression is a lower bound rather than an asserted asymptotic expansion.
- First-pass accessibility: Minor friction. The scale and error term are clear, but the counted normalization is not.
- Friction: “members of \(W_f\)” could mean literal nonzero forms, projective form directions, monic affine representatives, or root subsets. These differ by a factor of \(q-1\), and the leading constant \(1/(r-2)!\) suggests unordered root sets/projective locators. The variable tending to infinity in \(O_{r,s}(q^{r-9/2})\) is inferable but unstated.
- Smallest high-value repair: Specify “projective split-locator directions (equivalently, monic locator forms/root subsets)” or the intended normalization, and say “as \(q\to\infty\) through prime powers satisfying the theorem's hypotheses.”
- Finding: MINOR.
### packet-07 / paragraph-0084.tex — proof of split-witness abundance

- Job: Count good ordered marker tuples via the selector degree, multiply by the uniform terminal-cubic lower bound, and divide by the maximum number of marker/cubic decompositions of one locator to obtain the leading term and error.
- First-pass accessibility: Yes. The falling factorial, zero-locus error, terminal count, and \((m+3)!/6\) decomposition multiplicity form a coherent counting argument.
- Friction: None requiring repair for the intended expert audience; the preceding corollary should still specify the locator normalization being counted.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
## packet-07 note

- Current mental model: The simultaneous escape argument is now fully visible. For \(m=r-5\), the marker product \(R=\prod\lambda_i\) sends \(f\) to a terminal redundancy-five syndrome \(\iota_Rf\) in the row space of \(\operatorname{Cat}_{m,4}(f)\). Outside the recursive carrier, that row space is not trapped in the two-component terminal bad scheme. Multiplying one low-degree equation from each component gives a selector \(F_f\) of degree at most six (four in characteristic two), whose pullback is a nonzero polynomial of the same individual degree in every marker. The Vandermonde grid lemma then chooses all \(m\) distinct rational markers simultaneously outside \(A\) with a terminal pencil of full \(S_3\) monodromy. A genus-one/branch estimate supplies more split terminal cubics than can be spoiled by the \(m+s\) forbidden roots; solving the strict point-count inequality yields exactly \(Q^*_{r,s}\). Multiplication by \(R\) lifts the surviving cubic to a supported split squarefree degree-\(r-2\) form in \(W_f\). The same count gives on the order of \(q^{r-4}/(r-2)!\) locator directions.
- Questions carried forward: How is the terminal split-cubic count proved, what genus-one curve is counted, and why is the branch budget \(B_p=12\) generically but \(6\) in characteristic two? Does the abundance corollary count projective locator directions, monic forms, or literal nonzero elements of \(W_f\)? Can the selector's degree-six separation be stated canonically or does it depend on choosing one residual generator for each \(f\)? How will fixed-gcd and collision strata re-enter the final high-weight classification?
- Top accessibility issue so far: This is the clearest proof packet yet: the selector, finite-field grid, terminal count, avoidance subtraction, threshold algebra, and lift form a readable end-to-end chain. The main repair is small but important—state that “nonzero on \(L_f\)” means nonzero restriction and specify the normalization in the abundance count.
### packet-08 / paragraph-0085.tex

- Job: Extract a deterministic fixed-redundancy search procedure from the existential selector proof and explicitly limit its complexity claim.
- First-pass accessibility: Yes. The test counts, coefficient-access assumption, exponential dependence on \(r\), and non-decoding disclaimer are all clear.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-08 / paragraph-0086.tex — Section “High-weight cosets and code extensions” (`sec:high-weight-cosets`)

- Job: Open the section translating the escape/carrier results into the paper's main coding-theoretic classification and extension consequences.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-08 / paragraph-0087.tex

- Job: State the section's plan and compress all prior machinery to the single supported-locator implication needed for the coding proof.
- First-pass accessibility: Yes. This is excellent dependency management for readers who skipped the geometric/elimination details.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-08 / paragraph-0088.tex — Subsection “Coset weights”

- Job: Open the direct coset-weight classification.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-08 / paragraph-0089.tex — Coset-weight formula (`eq:grs-coset-weight`)

- Job: Remove arbitrary column multipliers from the geometry, express coset weight as the smallest supported normal-rational-curve span, and invoke the Hankel criterion to interpret a supported split locator as an \((r-2)\)-term witness.
- First-pass accessibility: Yes. This is a clean, self-contained bridge back to standard coding language.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-08 / paragraph-0090.tex — Proof of main theorem (escape and Lucas elimination)

- Job: Deduce the universal low-weight bound outside the carriers and remove the modular carrier under \(p>r-1\).
- First-pass accessibility: Yes. Both implications are direct from the previously isolated result and Pascal-row definition.
- Friction: None requiring repair; “pointed” is naturally read as the deleted-set version of the simultaneous-marker theorem.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-08 / paragraph-0091.tex — Proof of main theorem (full-support strata)

- Job: Decompose the rational rank-two catalecticant locus into four geometric strata, assign their coset weights in full support, and isolate tangents/conjugate secants as the maximum-weight directions.
- First-pass accessibility: Yes. The low-weight strata are immediate from their spans, while the nontrivial weight-\(r-1\) input and covering-radius gate are cited explicitly.
- Friction: None requiring repair in this paragraph.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-08 / paragraph-0092.tex — Proof of main theorem (deleted-support top shell)

- Job: Show each omitted curve point has coset weight \(r\), verify the numerical range for Seroussi–Roth uniqueness, and conclude that no other weight-\(r\) directions exist.
- First-pass accessibility: Yes. The arc/MDS span argument, threshold implication, and imported uniqueness step are all explicit.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-08 / paragraph-0093.tex — Proof of main theorem (deleted-support second shell and exhaustiveness)

- Job: Show tangent/conjugate-secant weights persist after deletion, prove incident rational-secant interiors rise to weight \(r-1\) by an arc-dependence contradiction, retain the obvious low-weight strata, and invoke escape off \(\mathcal P_r\) for exhaustiveness.
- First-pass accessibility: Yes. The monotonicity, exclusion of the weight-\(r\) shell, short-dependence contradiction, and final partition fit together cleanly.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-08 / paragraph-0094.tex — Proof of main theorem (counts)

- Job: Count the weight-\(r-1\) geometric directions by adding the persistent tangent/conjugate contribution to incident rational secant interiors, then convert projective directions to literal nonzero cosets.
- First-pass accessibility: Yes. The incident-line subtraction, \(q-1\) interior points per secant, and \(q-1\) syndrome representatives per direction are transparent.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-08 / paragraph-0095.tex

- Job: Specialize the general deleted-support count to the ordinary affine GRS support and distinguish the classical unique top direction from the newly complete next shell.
- First-pass accessibility: Yes. The convention \(A=\{\infty\}\) makes the specialization immediate.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-08 / paragraph-0096.tex — Subsection “MDS and NMDS appended columns”

- Job: Open the subsection translating the two high-weight shells into one-column extension classes.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
## packet-08 note

- Current mental model: The geometric machinery now collapses cleanly into the coding theorem. Arbitrary nonzero GRS column multipliers disappear under projective span, so coset weight is the minimum number of retained normal-rational-curve points spanning the syndrome. Escape supplies an \((r-2)\)-point representation everywhere outside the two carriers; in characteristic \(p>r-1\), the Lucas carrier is empty. The rank-two catalecticant locus has four rational strata. With full support, curve and rational-secant points have weights one/two, while off-curve tangent and conjugate-secant points have the maximum weight \(r-1\). With deletions, each omitted curve point has weight \(r\) and Seroussi–Roth uniqueness says these exhaust the top shell; tangent/conjugate points remain at \(r-1\), and interiors of rational secants with a deleted endpoint rise to \(r-1\) by the arc property. Simple incidence counts then give both projective shell sizes and literal coset counts. The ordinary affine-support case has one top direction and an explicitly counted complete next shell.
- Questions carried forward: How exactly are the MDS and NMDS extension equivalences and family-aggregate enumerators formulated? Does the extension classification distinguish equivalence classes of appended columns from literal syndrome directions/scalars? How are minimum supports counted within tangent, conjugate-secant, and incident-split-secant NMDS families, and why are only aggregate rather than individual weight enumerators claimed?
- Top accessibility issue so far: No new issue in this packet. It is the most accessible section so far: it restates the only needed geometric input, proves each shell weight with short coding/arc arguments, and makes the projective-versus-literal count conversion explicit. Any residual friction comes only from geometric terms defined or motivated earlier, not from this proof's presentation.
### packet-09 / paragraph-0097.tex

- Job: Define the one-column code extension associated with a nonzero syndrome direction/column.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-09 / paragraph-0098.tex — Corollary “One-column extensions” (`cor:one-column-extensions`)

- Source metadata: `coverage{absent}`; distance identity `eq:extension-distance`.
- Job: State the exact distance shift under column extension and translate the two high-weight syndrome shells into the complete MDS/NMDS/defect-at-least-two classification, including the empty full-support MDS case.
- First-pass accessibility: Yes. The classification directly mirrors the preceding shell theorem.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-09 / paragraph-0099.tex — proof of one-column extension corollary (distance identity)

- Job: Prove the distance shift by comparing minimum dependent column sets before and after appending \(f\).
- First-pass accessibility: Yes. The two cases for a smallest dependence are exhaustive and directly match the coset-span definition.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-09 / paragraph-0100.tex — proof of one-column extension corollary (NMDS equivalence)

- Job: Show that the weight-\(r-1\) syndrome condition is equivalent to both primal and dual Singleton defect one, then invoke the shell classification to identify all NMDS families.
- First-pass accessibility: Yes. The hyperplane functional constructs the required dual word, the old GRS distance supplies optimality, and the converse follows immediately from the distance identity.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-09 / paragraph-0101.tex — Subsection “Family-aggregate NMDS enumerators”

- Job: Open the enumerative subsection for the classified NMDS extension families.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-09 / paragraph-0102.tex — Minimum-word coefficient (`eq:nmds-minimum-coefficient`)

- Job: Define the number \(\mu_S(f)\) of minimum old-column supports spanning an NMDS syndrome and convert it to the number of minimum-weight extension words by scalar multiplicity.
- First-pass accessibility: Yes. The support count and factor \(q-1\) are explicit.
- Friction: None requiring repair; although \(m\) previously denoted \(r-5\) marker roots, the local reset \(m=r-1\) is prominent and unambiguous.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-09 / paragraph-0103.tex

- Job: Name the three NMDS geometric families and fix the projective-representative convention for subsequent sums.
- First-pass accessibility: Yes. The normalization directly answers the likely scalar-count ambiguity.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-09 / paragraph-0104.tex — Theorem “Family-aggregate minimum supports” (`thm:family-aggregate-nmds`)

- Source metadata: `coverage{absent}`; identities `eq:aggregate-tangent`, `eq:aggregate-conjugate`, `eq:aggregate-split`.
- Job: Give exact sums of minimum-support multiplicities over each of the three NMDS geometric families and state precisely the aggregate/average—not individual—isospectral consequence.
- First-pass accessibility: Yes. All parameters and summation conventions have just been defined, and the nonuniformity disclaimer is admirably explicit.
- Friction: None requiring repair at the statement level.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-09 / paragraph-0105.tex — proof of family-aggregate minimum-support identities (incidence count)

- Job: Prove all three aggregate formulas by fixing an \(m\)-subset hyperplane \(H_T\), counting its intersections with each geometric family, and summing over \(T\).
- First-pass accessibility: Yes. The tangent, conjugate-secant, two-omitted-endpoint, and one-omitted-endpoint cases are parallel and the coefficients in the theorem become immediately meaningful.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-09 / paragraph-0106.tex — proof of family-aggregate theorem (minimum-word coefficients)

- Job: Convert the three aggregate support counts into aggregate numbers of minimum-weight codewords by the scalar factor \(q-1\).
- First-pass accessibility: Yes. The notation \(\mathcal A_j^{\mathcal F}\) and all three substitutions are explicit.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-09 / paragraph-0107.tex — proof of family-aggregate theorem (complete enumerators)

- Job: Invoke the standard NMDS recurrence to show that every higher weight coefficient depends affinely only on the minimum coefficient, so the aggregate minimum-support identities determine complete aggregate and average enumerators.
- First-pass accessibility: Yes. Length \(L\), dimension \(K\), coefficient range, recurrence, and summation step are all explicit.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-09 / paragraph-0108.tex — Section “Redundancy five: exceptional cubic covers” (`sec:r5`)

- Job: Open the fixed redundancy-five section that supplies the terminal cubic analysis used by the uniform theorem.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
## packet-09 note

- Current mental model: Appending a syndrome column \(f\) to the parity-check matrix raises minimum distance by exactly one because any new minimum dependence containing \(f\) is precisely a minimum old-column span representation of \(f\). Consequently the weight-\(r\) shell gives all MDS extensions and the weight-\(r-1\) shell gives exactly the NMDS extensions; a short hyperplane-functional argument verifies the dual defect-one condition. For an NMDS direction, \(\mu_S(f)\) counts \((r-1)\)-subsets of retained curve points whose hyperplane contains \(f\), and each support yields \(q-1\) minimum words. Double-counting intersections of these subset hyperplanes with the tangent, conjugate-secant, and deleted-point-incident split-secant families gives exact family sums of \(\mu_S(f)\). The standard NMDS recurrence makes every other weight coefficient affine in the minimum coefficient, so these sums determine full family-aggregate and family-average enumerators without asserting equality among individual family members.
- Questions carried forward: What exceptional cubic covers arise at redundancy five, and how do their branch/genus calculations yield the exact split-member lower bound used in the uniform theorem? Which fixed-level cases are unconditional arithmetic classifications versus computer-certified orbit tables? Do any special redundancy-five orbit families illuminate variation of individual NMDS enumerators within a geometric family?
- Top accessibility issue so far: No substantive issue in this packet. The extension dictionary, NMDS dual check, projective normalization, incidence double counts, and aggregate-versus-individual distinction are all unusually explicit. The packet is a strong model for how the manuscript can present cross-interface consequences without relying on internal package terminology.
### packet-10 / paragraph-0109.tex

- Job: Specialize the Hankel witness system to redundancy five and warn against treating divided-power syndrome coordinates as ordinary quartic coefficients in small characteristic.
- First-pass accessibility: Yes. The explicit matrix, coordinate distinction, and precise characteristics where naive factorization fails are clear.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-10 / paragraph-0110.tex — “The criterion in finite-geometric form” (`eq:r5-orbit-criterion`)

- Job: Translate the redundancy-five split-free condition into the finite geometry of lines in \(\mathrm{PG}(3,q)\) avoiding the orbit of completely split cubic forms, position the resulting line-orbit question in prior literature, and isolate this paper's syndrome-to-pencil contribution.
- First-pass accessibility: Minor friction. The orbit criterion and novelty boundary are excellent, but the primal/dual projective identifications are compressed.
- Friction: A cubic form is a point of \(\mathbb P(\operatorname{Sym}^3E^\vee)\), while “equivalently a plane meeting the twisted cubic” uses coefficient–hyperplane duality in another \(\mathrm{PG}(3,q)\); that duality is not stated, so a reader may wonder how a point becomes a plane. Likewise \(W_f\) is first a vector pencil and then a projective line without explicitly projectivizing.
- Smallest high-value repair: Insert “after projectivizing” for \(W_f\) and “under the standard coefficient/hyperplane duality” before the plane interpretation; distinguish primal and dual \(\mathrm{PG}(3,q)\) if both are used later.
- Finding: MINOR.
### packet-10 / paragraph-0111.tex — Theorem “Complete redundancy-five classification” (`thm:r5`)

- Source metadata: `coverage{conditional_deduction}`; Lean items `PRSRedundancyFiveCertified.redundancyFiveSynthesisWithCertificate`, `PRSRedundancyFive.FamilyData`, `PRSRedundancyFiveCertificate`; evidence `certificate-r5`; proves `redundancy-five-classification`.
- Job: State the exact radius-four deep-hole classification for every \(q\ge7\), including persistent rank-two families, congruence-dependent osculating families, wild characteristic-three families, finite sporadic exceptions, orbit sizes, and total counts.
- First-pass accessibility: Major friction. The exhaustive case split and arithmetic are explicit, but the new families that distinguish this theorem from the uniform large-characteristic result are only named.
- Friction: “rational/conjugate osculating-pair family,” “\(\mathrm{PGL}_2(q)\)-fixed nucleus point,” and “wild Artin–Schreier orbit” have no constructions or representative syndromes/pencils. A cold coding theorist cannot tell why the mod-three congruence swaps \(\mathrm O^+\) and \(\mathrm O^-\), what geometric pair is osculating, or how the characteristic-three orbit differs from the nucleus. The sporadic classification depends on a later table, so even the statement is not self-contained as read.
- Smallest high-value repair: Precede the theorem with a compact family dictionary giving one normal-form syndrome or pencil and a one-line geometric description for \(\mathrm O^\pm\), the nucleus, and \(\mathrm W\); say why their rationality is controlled by \(q\bmod3\). Include or immediately follow with the sporadic table.
- Finding: MAJOR.
### packet-10 / paragraph-0112.tex

- Job: Highlight the exceptional scale of the \(q=8\) case by separating nonsporadic and sporadic deep-hole direction counts.
- First-pass accessibility: Yes. The two contributions sum transparently to the total.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-10 / paragraph-0113.tex — Proposition “Radius gate” (`prop:r5-radius`)

- Source metadata: `coverage{fragment}`; Lean item `PRSFoundation.CoveringRadiusInput.deep_iff_splitFree`; imports `duer`, `seroussi-roth`.
- Job: Isolate the exact covering-radius input that converts the redundancy-five split-free pencil classification into a deep-hole classification for all \(q\ge7\).
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-10 / paragraph-0114.tex — proof of redundancy-five radius gate

- Job: Derive radius four from normal-rational-curve completeness using Seroussi–Roth nonextendability and Dür/Kaipa equivalence, check the numerical/exception hypotheses, and separate the all-field proof from finite certificate checks.
- First-pass accessibility: Yes. The imported implication chain and trust boundary are explicit.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-10 / paragraph-0115.tex — Subsection “Gcd strata”

- Job: Open the classification of redundancy-five pencils according to their common cubic factors.
- First-pass accessibility: Yes; the precise gcd object can naturally be defined in the following paragraph.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-10 / paragraph-0116.tex — Proposition “Quadratic gcd” (`prop:r5-gcd2`)

- Source metadata: `coverage{fragment}`; Lean item `PRSRedundancyFive.FamilyData.family_arithmetic`.
- Job: Completely classify pencils with a common quadratic factor by the factorization type of that quadratic, identify the tangent/conjugate-secant deep families and shallow rational case, prove the converse, and give family sizes.
- First-pass accessibility: Yes. The factorization trichotomy makes the geometric families concrete.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-10 / paragraph-0117.tex — proof of quadratic-gcd proposition

- Job: Prove the factorization trichotomy's shallow/deep behavior, identify the associated syndrome spans through the Hankel criterion, and source the family counts.
- First-pass accessibility: Yes. Each quadratic type is handled by one transparent root argument, and the geometric identification/count inputs are cited.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-10 / paragraph-0118.tex — Proposition “Linear gcd” (`prop:r5-gcd1`)

- Source metadata: `coverage{absent}`.
- Job: Eliminate all pencils with exactly one common linear factor from the deep-hole list, analytically for \(q\ge8\) and by the finite R5 certificate at \(q=7\).
- First-pass accessibility: Yes. The scope and exceptional verification boundary are explicit.
- Friction: None at the statement level.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-10 / paragraph-0119.tex — proof of linear-gcd proposition

- Job: Reduce to a base-point-free quadratic pencil, use its deck-involution graph to find a rational split quadratic avoiding collisions and the fixed gcd root, and dispose of the characteristic-two inseparable case through the Hankel equations.
- First-pass accessibility: Minor friction. The graph-point count gives an appealing proof, but the “unsafe” subsets and a final hypothesis are not fully motivated.
- Friction: The paragraph deletes fixed graph points, graph points over branch fibers, and points involving \(\lambda_0\), but it only explains the last category; a reader cannot tell which failure (repeated root, singular fiber, or another collision) each of the first two categories prevents, and fixed points of the deck involution seem closely related to branch fibers. “contrary to the rank-two pencil hypothesis” refers to a hypothesis not stated in the proposition; it should be explained why \(\deg\gcd(W_f)=1\) places the argument in the rank-two Hankel/pencil case.
- Smallest high-value repair: Label each deleted subset by the precise bad condition it excludes and state the rank-two/pencil reduction at the start, before writing \(W_f=\lambda_0V\).
- Finding: MINOR.
### packet-10 / paragraph-0120.tex — Subsection “The trivial-gcd cubic cover”

- Job: Open the remaining base-point-free cubic-pencil case after the quadratic- and linear-gcd strata have been classified.
- First-pass accessibility: Yes. “trivial gcd” now clearly means no common factor in \(W_f\).
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
## packet-10 note

- Current mental model: At redundancy five, \(W_f\) is a projective line/pencil of binary cubics. A squarefree completely split cubic lies in the \(\mathrm{PGL}_2(q)\)-orbit of \(XY(X-Y)\), so split-free syndromes correspond exactly to those Hankel-image lines avoiding this orbit. The all-field radius-four gate is independent and converts this orbit-avoidance classification to deep holes. Pencils with quadratic gcd are completely transparent: a split quadratic gives a shallow member, while an irreducible quadratic and a square give the persistent conjugate-secant and tangent families. Pencils with linear gcd are shallow for \(q\ge8\) by finding a safe rational point on the deck-involution graph of the residual degree-two map; \(q=7\) is certified. The remaining trivial-gcd pencils define cubic covers and support additional congruence-dependent osculating families, characteristic-three nucleus/Artin–Schreier families, and finitely many sporadic orbits. The complete theorem gives exact orbit sizes and totals but has not yet defined these new families.
- Questions carried forward: What normal forms or geometric constructions define \(\mathrm O^+\), \(\mathrm O^-\), the fixed nucleus, and the wild Artin–Schreier orbit? Why is their rationality/existence controlled by \(q\bmod3\)? How does a trivial-gcd pencil produce a cubic map, and which monodromy/branch configurations are split-free? What are the sporadic orbit representatives and how are their completeness and field list certified? In the linear-gcd proof, which distinct bad conditions account for the fixed-point and branch-fiber deletions?
- Top accessibility issue so far: The finite-geometric orbit criterion and gcd stratification are readable, but the headline complete classification introduces its genuinely new families before giving even one representative or picture. A short family dictionary immediately before the theorem would turn an opaque list of labels into a meaningful classification and make the subsequent trivial-gcd analysis easier to anticipate.
### packet-11 / paragraph-0121.tex

- Job: Attach an incidence curve \(X_f\) to a base-point-free cubic pencil, recording which pencil member \([u:v]\) vanishes at which root \(t\).
- First-pass accessibility: Yes. The equation directly exposes the cubic-cover construction anticipated in the preceding section.
- Friction: None requiring repair; the homogeneity in the projective root coordinate is standard in context.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-11 / paragraph-0122.tex — Proposition “Cubic incidence and off-diagonal fiber square” (`prop:r5-incidence`)

- Source metadata: `coverage{absent}`.
- Job: Identify the incidence curve as a rational cubic cover of the pencil parameter line and define its off-diagonal fiber-product curve \(Y_f\), whose components encode geometric monodromy on ordered distinct root pairs.
- First-pass accessibility: Minor friction. The cover and monodromy interpretation are clear, but the residual equation is named more tersely than necessary.
- Friction: “the diagonal bracket” is not written; a reader crossing from coding theory may not know it means the bihomogeneous equation \([t_1,t_2]\) of the diagonal. Nor is it explicitly said that the numerator cuts out pairs of roots lying in the same pencil fiber, so the reason division produces the off-diagonal fiber square must be inferred.
- Smallest high-value repair: Display the diagonal bracket in homogeneous coordinates and add “the numerator is the equation of \(X_f\times_{\mathbb P^1}X_f\); removing the diagonal leaves \(Y_f\).”
- Finding: MINOR.
### packet-11 / paragraph-0123.tex — proof of cubic-incidence proposition

- Job: Prove integrality/birationality from the trivial-gcd condition, compute both genera and residual bidegree, and invoke the standard fiber-square/monodromy correspondence.
- First-pass accessibility: Yes. Each conclusion in the proposition receives a short, ordered justification.
- Friction: None requiring repair for the intended expert audience.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-11 / paragraph-0124.tex — Lemma “Cyclic stratum” (`lem:cyclic`)

- Source metadata: `coverage{absent}`.
- Job: Classify geometrically cyclic cubic pencils: tame rational/conjugate ramification gives the two congruence-controlled osculating families, while characteristic three gives the fixed nucleus and one nonsquare Artin–Schreier orbit, with explicit normal forms.
- First-pass accessibility: Minor friction. This supplies most of the missing family dictionary, but the tame geometric construction remains compressed.
- Friction: “the corresponding osculating-plane intersection” does not say that the two ramification points determine two osculating planes to the quartic normal rational curve whose intersection is the syndrome direction, nor does it explicitly identify the rational case with \(\mathrm O^+\) and the conjugate case with \(\mathrm O^-\). The switch from a pencil normal form to a syndrome coordinate \(n\) also relies on the syndrome-to-pencil map without reminder.
- Smallest high-value repair: Name \(\mathrm O^+\) and \(\mathrm O^-\) in item (i), spell out the two planes and their intersection point, and prefix items (ii)–(iii) with the corresponding syndrome/pencil identification.
- Finding: MINOR.
### packet-11 / paragraph-0125.tex — proof of cyclic-stratum lemma (tame setup)

- Job: Use Riemann–Hurwitz to obtain the two total ramification points, translate them through the confluent Hankel criterion to intersecting osculating planes, and normalize the cyclic pencil/deck action.
- First-pass accessibility: Yes. The tame cyclic normal form and its geometric origin are concise and standard.
- Friction: None requiring repair; \(\zeta\) is naturally understood as a primitive cube root of unity in the geometric base field.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-11 / paragraph-0126.tex — proof of cyclic-stratum lemma (tame descent and orbit sizes)

- Job: Determine split-free/deep congruence conditions by Frobenius descent of the cyclic deck action and compute the rational and conjugate osculating-family orbit sizes from split/nonsplit dihedral stabilizers.
- First-pass accessibility: Minor friction. The Frobenius congruences and orbit–stabilizer arithmetic are clear, but the bridge from deck descent to a split cubic is omitted.
- Friction: “Thus its complement is deep” is grammatically ambiguous and hides the key reasoning: presumably when the order-three deck map is \(\mathbb F_q\)-rational, a generic rational root has a three-point rational orbit giving a split pencil member, whereas without descent no such rational split fiber exists. That iff should be stated. “setwise stabilizer of the ordered normal form” is also confusing because a dihedral stabilizer normally includes interchange of the two ramification points.
- Smallest high-value repair: Insert the rational-orbit/split-fiber equivalence before drawing the deep congruence, replace “its complement” by the explicit congruence case, and clarify whether the ramification pair is ordered or unordered in the stabilizer count.
- Finding: MINOR.
### packet-11 / paragraph-0127.tex — proof of cyclic-stratum lemma (fixed wild point)

- Job: Identify the characteristic-three common osculating-plane nucleus, prove its projective invariance, compute its cubic pencil, and conclude split-freeness/depth.
- First-pass accessibility: Yes. The Hasse-derivative calculation and pencil normal form make the fixed point concrete.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-11 / paragraph-0128.tex — proof of cyclic-stratum lemma (remaining wild orbit)

- Job: Normalize every remaining characteristic-three separable cyclic pencil to an Artin–Schreier form, characterize split fibers through the kernel of an additive polynomial, and compute the unique nonsquare-parameter deep orbit and its size.
- First-pass accessibility: Minor friction. The additive-polynomial criterion is clean, but the normal-form parameters and stabilizer notation collide.
- Friction: The first pencil uses coefficients \(\alpha,\beta\) with \(\kappa^2=-\beta\), then switches to \(a\) without explicitly stating the substitution, and finally reuses \(\beta\) as the translation parameter in \(t\mapsto\pm t+\beta\). This makes it hard to tell whether the stabilizer translations depend on the pencil coefficient. “comparing coefficients under a nontrivial translation” also suppresses the one calculation that forces \(\alpha=0\).
- Smallest high-value repair: State the normalization map from \((\alpha,\beta)\) to \(a\), rename the stabilizer translation parameter (say \(b\)), and show one line of the translation-invariance coefficient comparison.
- Finding: MINOR.
### packet-11 / paragraph-0129.tex

- Job: Transition from qualitative split-free classification to the exact split-fiber count used both for uniform thresholds and exceptional cases.
- First-pass accessibility: Yes. It clearly signals why the next identity matters.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-11 / paragraph-0130.tex — Proposition “Exact split-witness count” (`prop:r5-count`)

- Source metadata: `coverage{fragment}`; Lean item `PRSRedundancyFive.ExactSplitWitnessCount.countRelation`; identity `eq:r5-count`.
- Job: Express the rational point count of the residual fiber-square curve exactly in terms of squarefree split fibers and the two rational ramification degeneracy types, yielding a numerical split-free criterion in every characteristic.
- First-pass accessibility: Yes. The three counted quantities and the iff consequence are explicitly defined.
- Friction: None at the statement level; the coefficients \(6,3,1\) naturally invite and presumably receive the local fiber explanation in the proof.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-11 / paragraph-0131.tex — proof of exact split-witness count

- Job: Compute \(\#Y_f(\mathbb F_q)\) fiber by fiber and explain the coefficients \(6,3,1\) for split squarefree, double-plus-simple, and triple-root pencil members, while showing all nonsplit types contribute zero.
- First-pass accessibility: Yes. This is a model local counting proof: every fiber type is named and its contribution is derived explicitly.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-11 / paragraph-0132.tex

- Job: Connect the residual fiber-square construction to the genus-one double-cover curve used in prior incidence-based treatments.
- First-pass accessibility: Minor friction. The first projection is visibly degree two from the proof, but the claimed literature identification is too allusive.
- Friction: “the genus-one curve of the incidence literature” neither names/cites the curve nor says whether the identification is an isomorphism, normalization, or birational equivalence, especially when \(Y_f\) is singular or reducible. The relevant double-cover map and branch divisor are not restated.
- Smallest high-value repair: Cite the precise incidence construction and state the relationship accurately (e.g. the normalization of \(Y_f\) under the first projection is the cited double cover, with the stated branch divisor).
- Finding: MINOR.
## packet-11 note

- Current mental model: A trivial-gcd cubic pencil determines a rational incidence curve \(X_f\) and a degree-three map \(\phi_f:\mathbb P^1\to\mathbb P^1\). Removing the diagonal from its fiber square yields a bidegree-\((2,2)\), arithmetic-genus-one curve \(Y_f\); its geometric components are monodromy orbits on ordered distinct sheets. Cyclic monodromy explains the nonpersistent redundancy-five families. In tame characteristic, the two total ramification points determine an intersection of osculating planes; Frobenius descent of the deck transformation gives the complementary mod-three conditions for rational versus conjugate ramification pairs and their orbit sizes. In characteristic three, all osculating planes share a fixed nucleus with pencil \(\langle T^3,U^3\rangle\), while the remaining cyclic covers normalize to \(\langle U^3,T^3+aTU^2\rangle\); nonsquare \(-a\) gives one wild deep orbit. For any separable trivial-gcd pencil, the exact identity \(\#Y_f(\mathbb F_q)=6N_f+3d_2+d_3\) counts split squarefree members and ramified degeneracies fiber by fiber.
- Questions carried forward: How are noncyclic \(S_3\) pencils bounded/classified using the genus-one point count, and how are branch budgets \(d_2,d_3\) controlled uniformly? Which singular or reducible \(Y_f\) cases produce the finite sporadic orbits? What exact incidence-literature curve is identified with the fiber-square double cover, and is the relation an isomorphism or normalization? Can the tame deck-descent argument explicitly state why rational descent is equivalent to the existence of a split cubic fiber?
- Top accessibility issue so far: The packet gives a strong geometric explanation and an exceptionally clear exact point-count proof. The main remaining issue is family naming/identification: the osculating-plane families should be explicitly labeled \(\mathrm O^\pm\) at first construction, and the deck-descent-to-split-fiber implication should be stated rather than left implicit.
### packet-12 / paragraph-0133.tex — Proposition “The fiber square is the incidence curve” (`prop:r5-fibre-is-elliptic`)

- Source metadata: `coverage{absent}`.
- Job: Identify the first projection of \(Y_f\) with the discriminant double cover in odd characteristic, explain the characteristic-two exception, and match the normalized fiber square with the Kaipa–Pradhan elliptic curve under the additional nondegeneracy hypotheses.
- First-pass accessibility: Yes. The map, branch polynomial, characteristic restrictions, normalization statement, and point-count consequence are explicit.
- Friction: None requiring repair in this paragraph.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-12 / paragraph-0134.tex — proof of fiber-square/incidence-curve proposition

- Job: Prove the discriminant-cover description, identify the function-field square class with the literature's model to exclude a twist, and carefully distinguish smooth-stratum point-count equality from merely birational singular cases.
- First-pass accessibility: Yes. This directly resolves the normalization/isomorphism ambiguity and gives a precise reason the exact count is formulated on \(Y_f\) itself.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-12 / paragraph-0135.tex — Lemma “Branch budget” (`lem:r5-branch`)

- Source metadata: `coverage{fragment}`; Lean items `PRSRedundancyFive.ExactSplitWitnessCount.branchBudget`, `ExactSplitWitnessCount.fibreSquarePoints_le_twelve`, `nonSplitWeight_le_twelve`, `nonSplitWeight_le_six_of_characteristicTwoBranchBudget`, `fibreSquarePoints_le_six_of_characteristicTwoBranchBudget`.
- Job: Bound the total rational ramification contribution of a separable cubic cover and deduce the sharp twelve-point ceiling for a split-free residual fiber square.
- First-pass accessibility: Yes. Combined with the preceding exact identity, the optimization and equality case are immediate.
- Friction: None at the statement level.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-12 / paragraph-0136.tex — proof of branch-budget lemma

- Job: Allocate the degree-four different among double-root and triple-root fibers, account for tame/wild costs by characteristic, derive both the general and binary feasible regions, and optimize the split-free point contribution.
- First-pass accessibility: Yes. The “spends” language makes the ramification budget intuitive without sacrificing the exact different exponents.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-12 / paragraph-0137.tex — Corollary “Split members of an \(S_3\) pencil” (`cor:r5-equidistribution`)

- Source metadata: `coverage{fragment}`; Lean item `PRSRedundancyFive.ExactSplitWitnessCount.splitMembers_bounds`.
- Job: Convert the genus-one Hasse interval and branch budget into explicit lower and upper bounds for the number of squarefree split members of a full-monodromy cubic pencil, including the sharper binary constant.
- First-pass accessibility: Yes. The role of the constants \(12\) and \(6\) is now fully motivated by the preceding lemma.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-12 / paragraph-0138.tex — proof of split-member bounds

- Job: Combine the exact count, ramification correction, and Aubry–Perret point bound for a geometrically integral arithmetic-genus-one curve.
- First-pass accessibility: Yes. Each term in the inequality is traced to a named prior result, and the \(S_3\)-to-integrality implication is stated.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-12 / paragraph-0139.tex — Corollary “Binary \(S_3\) shallowness above \(q=8\)” (`cor:r5-binary-shallow`)

- Source metadata: `coverage{fragment}`; Lean items `PRSRedundancyFive.splitMembers_pos_of_characteristicTwoBranchBudget`, `fieldOrder_le_twelve_of_characteristicTwoSplitFree`; imports `aubry-perret`.
- Job: Specialize the split-member lower bound to rule out binary full-monodromy deep holes beyond the last small field \(q=8\).
- First-pass accessibility: Yes. Since binary field sizes are powers of two, “above \(q=8\)” and \(q\ge16\) are equivalent.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-12 / paragraph-0140.tex — proof of binary \(S_3\) shallowness

- Job: Contradict the binary split-free six-point ceiling with the genus-one lower bound starting at \(q=16\).
- First-pass accessibility: Yes. The numerical contradiction is immediate.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-12 / paragraph-0141.tex

- Job: Interpret the \((q+1)/6\) main term through the identity Frobenius class in \(S_3\), connect the explicit bound to Chebotarev/Weil equidistribution, explain why split-free exceptions are confined to small fields, and delimit the density claim.
- First-pass accessibility: Yes. The paragraph carefully distinguishes density/main term from an exact fiber count and states which factorization class is actually controlled.
- Friction: None requiring repair despite the technical content.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-12 / paragraph-0142.tex — Lemma “\(S_3\) stratum” (`lem:s3`)

- Source metadata: `coverage{fragment}`; Lean item `PRSRedundancyFive.fieldOrder_le_nineteen_of_splitFree`; imports `aubry-perret`.
- Job: Turn the quantitative lower bound into the clean cutoff that all full-monodromy pencils over \(q\ge20\) are shallow, with a geometrically integral odd-characteristic variant.
- First-pass accessibility: Yes. The threshold and alternative hypothesis are explicit.
- Friction: None at the statement level.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-12 / paragraph-0143.tex — proof of \(S_3\)-stratum cutoff

- Job: Derive geometric integrality from two-transitivity, apply the arithmetic-genus-one Aubry–Perret lower bound, and contradict the split-free twelve-point ceiling above \(q=19\).
- First-pass accessibility: Yes. The group action, curve bound, and exact threshold algebra are all displayed.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-12 / paragraph-0144.tex — Corollary “Forced fiber-square invariants” (`cor:r5-forced`)

- Source metadata: `coverage{fragment}`; Lean item `PRSRedundancyFive.ExactSplitWitnessCount.fibreSquareInvariants_of_splitFree`.
- Job: State the rigid point and ramification data forced on any geometrically integral split-free fiber square in the last odd small-field range.
- First-pass accessibility: Yes. The hypotheses and three forced invariants are explicit.
- Friction: None at the statement level; the mechanism forcing equality is naturally deferred to the proof.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
## packet-12 note

- Current mental model: In odd characteristic, the residual quadratic over a rational root \(x\) gives a Kummer double cover \(Y_f:w^2=\operatorname{disc}(h_x)/4\). On the smooth nondegenerate stratum this is exactly, not merely a twist of, the Kaipa–Pradhan elliptic curve because the two discriminants have the same square class in \(\mathbb F_q(x)^\times\); away from that stratum the manuscript correctly retains \(Y_f\)'s own point count. Riemann–Hurwitz gives a different budget four for the cubic map. Rational double-root fibers cost at least one unit and rational cubes at least two, yielding \(d_2+2d_3\le4\), with the sharper binary region \(d_2+d_3\le2\). For split-free pencils this bounds \(\#Y_f\) by twelve, or six in characteristic two. Full \(S_3\) monodromy makes \(Y_f\) geometrically integral of arithmetic genus one, so Aubry–Perret gives \(q+1\pm2\sqrt q\). Combined with the exact identity, this produces the \(1/6\) Chebotarev-scale split-member bounds, eliminates binary \(S_3\) exceptions beyond \(q=8\), and eliminates all \(S_3\) split-free pencils for \(q\ge20\).
- Questions carried forward: How does the proof force \(\#Y_f=12,d_2=4,d_3=0\) specifically for odd \(17\le q\le19\), beyond the coarse Aubry–Perret interval? How are the remaining \(q\le19\) geometrically integral pencils enumerated into the sporadic table, and how are reducible/cyclic cases separated? What certificate data verify orbit representatives, split-freeness, and completeness across the finite field list?
- Top accessibility issue so far: No substantive accessibility issue in this packet. The manuscript carefully distinguishes exact fiber-square counts from normalized elliptic-curve counts, explains the ramification correction, and turns the geometric input into thresholds step by step. This is another strong model section.
### packet-13 / paragraph-0145.tex — proof of forced fiber-square invariants

- Job: Combine the discrete ramification-value set with the Aubry–Perret lower bound to force the unique remaining value \(12\), then invoke the equality case of the branch budget.
- First-pass accessibility: Yes. This answers exactly how the coarse interval becomes rigid at \(q=17,19\).
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-13 / paragraph-0146.tex

- Job: Compare the manuscript's characteristic-free fiber count with the tame twisted-cubic incidence formula, reconcile notation and a denominator discrepancy in Kaipa–Pradhan, delimit exactly where the elliptic/discriminant comparison applies, and state the finite exhaustive verification range.
- First-pass accessibility: Major friction. The paragraph contains four logically distinct tasks and introduces literature-specific invariants without a dictionary.
- Friction: \(\eta_L\), \(\nu_L\), and \(S\cap\mathcal O_3\) are not defined; \(S\) also conflicts with the manuscript's evaluation support. “the binary quartic of the line,” “five incidence counts,” and “lines meeting the curve” require the reader to reconstruct the cited taxonomy. The assertion that a denominator printed in a cited theorem differs from its proof is important but buried inside a long sentence, and the paragraph repeatedly switches among \(N_f\), literature incidence counts, characteristic restrictions, and supplement verification. The difference between proving a corrected formula internally and relying on an erratum-like reading is not immediately clear.
- Smallest high-value repair: Split into four short paragraphs or a comparison table: (1) define the tame notation map \((N_f,d_2,\#Y_f)\leftrightarrow(|S_L\cap\mathcal O_3|,\eta_L,\#E_L)\); (2) isolate the denominator discrepancy and derive \(6\) in two displayed steps; (3) state exactly how Proposition `r5-count` extends beyond tame characteristic; (4) state the exhaustive certificate range. Rename the literature's \(S\) locally to avoid collision.
- Finding: MAJOR.
### packet-13 / paragraph-0147.tex — Proposition “Exhaustion and finite bridge” (`prop:r5-bridge`)

- Source metadata: `coverage{fragment}`; Lean items `PRSRedundancyFive.requiredBridgeFieldOrders`, `PRSRedundancyFiveCertified.requiredBridgeFieldOrders_subset_certifiedBridgeFieldOrders`, `certifiedBridgeFieldOrders_exceed_required_only_at_sixteen`, `PRSRedundancyFiveCertificate.certified_comparison_band_has_no_sporadic`, `certified_orbit_summaries_agree_with_sporadic_records`, `CertificateValidation`.
- Job: Close the analytic-to-computational gap by identifying the exact seven small fields requiring Certificate R5, explain the logically redundant \(q=16\) regression check, and state the exact sporadic-field list.
- First-pass accessibility: Yes. The finite residue and trust boundary are unusually explicit.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-13 / paragraph-0148.tex — proof of exhaustion/finite-bridge proposition

- Job: Give the complete decision tree by gcd degree, separability, and geometric monodromy, then assign exactly the unresolved finite data to Certificate R5.
- First-pass accessibility: Yes. The cases are mutually exclusive, exhaustive, and tied to named prior results.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-13 / paragraph-0149.tex — Remark “Relation to the twisted-cubic line literature” (`rem:r5-line-literature`), part 1

- Job: Reconcile the two standard finite-geometric conventions that turn a cubic pencil into a line—plane-pencil axis versus coefficient-point line—and identify the symplectic polarity exchanging them.
- First-pass accessibility: Yes. The primal/dual ambiguity flagged earlier is now resolved concretely, with the relevant sources attached to each convention.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-13 / paragraph-0150.tex — Remark on line conventions, part 2

- Job: Demonstrate the polarity translation on quadratic-gcd pencils and the all-cube pencil, and fix which source convention governs subsequent class names while emphasizing invariant split-member content.
- First-pass accessibility: Yes. The displayed osculating-plane intersection makes the convention swap tangible.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-13 / paragraph-0151.tex — Remark on line conventions, part 3

- Job: Map every manuscript pencil stratum to the Blokhuis–Pellikaan–Szőnyi line classes, compare the two genus-one threshold arguments, explain the improvements from Aubry–Perret and the exact count, and cite an independent permutation-rational-function confirmation.
- First-pass accessibility: Major friction. The content is valuable, but a single paragraph carries a dozen class labels, seven manuscript correspondences, a proof comparison, two improvements, and a second literature bridge.
- Friction: The mappings \(O_1,\ldots,O_8\), \(O_1',O_3',O_7(3),O_{8.1}(3)^\pm,O_{8.2}(3)\) are impossible to retain on first pass, especially after the warning about dual conventions. “their degree-one case” and “which classes lie in a plane meeting the twisted cubic…” depend on source taxonomy not defined here. The core conceptual comparison—same genus-one route, but singular-curve bounds plus an exact ramification identity lower \(23\) to \(20\)—is buried near the end.
- Smallest high-value repair: Replace the class-name prose by a table with columns “our stratum,” “pencil/gcd/monodromy description,” “BPS class in plane convention,” and “deep condition”; follow it with a separate three-sentence proof comparison highlighting \(23\to20\) and the \(q=17,19\) rigidity. Put the permutation-function confirmation in its own final sentence/remark.
- Finding: MAJOR.
### packet-13 / paragraph-0152.tex — Remark on exact line-class counts

- Job: Survey exact incidence-count results for non-generic and generic line classes, identify the generic elliptic-curve formula with the manuscript's fiber-square identity, emphasize that the two threshold proofs are the same argument in different coordinates, and point to characteristic-two/three treatments.
- First-pass accessibility: Minor friction. The conceptual equivalence is explained well, but the paragraph mixes a broad bibliography with a detailed derivation and scope qualifications.
- Friction: “the ten non-generic line classes” is not tied to the preceding class list/table, and the reader must track changes among plane counts, point/plane orbit distributions, \(|W_f\cap\mathcal O_3|\), and elliptic point counts. The sentence beginning “This is not a second route…” is useful but comes after a repeated threshold derivation; the main message could be foregrounded. The positional reference “discussed after Corollary …” is harder to use than an equation/remark label.
- Smallest high-value repair: Split into (1) a short bibliography/table for exact non-generic class counts and characteristic scope, and (2) a generic-class paragraph beginning “The Kaipa–Pradhan and fiber-square arguments are the same genus-one argument,” followed by the common formula and threshold.
- Finding: MINOR.
### packet-13 / paragraph-0153.tex — Remark on syndrome-level contribution

- Job: State the section's true novelty boundary: construct and characterize the nonsurjective syndrome-to-pencil map, provide syndrome representatives/orbit data rather than line incidences alone, and supply the independent radius gate turning split-free pencils into deep-hole syndromes.
- First-pass accessibility: Minor friction. The distinction is important and mostly clear, but two notation/convention details interrupt it.
- Friction: “codimension-four generalized Reed–Solomon code” sits beside a redundancy-five discussion without explaining whether the literature counts affine codimension, projective redundancy, or polynomial codimension differently. The number \(2q-3+\mu\) introduces \(\mu\) without definition, and the exact orbit-count expression is not necessary to understand the extraction burden. The characteristic-two unrealized-line example is valuable but “inseparable unisecants” could be tied explicitly to the line class named earlier.
- Smallest high-value repair: Add a parenthetical reconciling the codimension/redundancy conventions, define \(\mu\) or replace the formula by “all generic line orbits,” and identify the unrealized unisecant class by its prior label.
- Finding: MINOR.
### packet-13 / paragraph-0154.tex

- Job: Summarize the reusable redundancy-five proof template and distinguish the higher-redundancy escape problem from the recursively trapped-carrier problem.
- First-pass accessibility: Minor friction. The five-step terminal workflow is clear, but the branch names revert to internal shorthand.
- Friction: “transverse branch,” “contained branch,” and “which polar lines remain trapped” are not defined here. A reader must infer that transverse means syndrome row spaces not contained in the terminal bad locus and contained means those lying in \(\mathcal P_r\cup\mathcal M^{\max}_{r,p}\). “remove its singular, branch, diagonal, and marker incidences” lists exclusions without saying whether they are points/divisors or why each spoils the split witness.
- Smallest high-value repair: Add parenthetical definitions of the two branches in carrier language and gloss the four exclusions as the finite bad-point budget on the splitting curve.
- Finding: MINOR.
### packet-13 / paragraph-0155.tex — Table “Complete sporadic orbit inventory at redundancy five” (`tab:r5sporadic`)

- Job: Give the complete finite list of sporadic deep-hole orbit representatives, orbit sizes, stabilizer orders, and Frobenius fusion for the seven exceptional fields.
- First-pass accessibility: Major friction for the nonprime fields: the representative coordinates are not mathematically interpretable without the finite-field encoding.
- Friction: Entries such as \(2,4,6\in\mathbb F_8\) and \(4\in\mathbb F_9\) depend on a chosen irreducible polynomial and primitive-element/integer encoding, none of which is stated in the caption or table. Thus the promised “canonical representatives” cannot be reconstructed or checked from the table. The “stabilizer” column contains numbers and should say “stabilizer order”; it does not identify the acting group (presumably \(\mathrm{PGL}_2(q)\)). The Frobenius arrows are understandable as fusion cycles but the chosen Frobenius generator is not specified.
- Smallest high-value repair: Add a caption note or adjacent field-model table specifying \(\mathbb F_8\), \(\mathbb F_9\), element encoding, and Frobenius map; rename the column “\(|\operatorname{Stab}_{\mathrm{PGL}_2(q)}|\).” If the supplement owns the encoding, give an exact pointer and still state the defining polynomials here.
- Finding: MAJOR.
### packet-13 / paragraph-0156.tex

- Job: Explain that repeated-size sporadic orbits are distinguished by complete pencil-member histograms recorded in the certificate rather than by orbit size alone.
- First-pass accessibility: Minor friction. The distinguishing invariant is named, but “visibly” and its location are unclear.
- Friction: No histogram appears in the preceding table, so it is not clear in what sense repeated orbit sizes are “visibly distinguished.” “without requiring a working-directory file” is implementation/process language and does not tell a reader where the durable record lives or how to inspect it.
- Smallest high-value repair: Give an exact supplement path/table reference for the histograms (or include a compact histogram identifier column in the inventory) and replace the working-directory phrase by a statement that the data are included in the published supplement.
- Finding: MINOR.
## packet-13 note

- Current mental model: The branch budget restricts split-free fiber-square counts to a sparse finite set, so the Aubry–Perret lower bound forces the rigid \((\#Y_f,d_2,d_3)=(12,4,0)\) configuration at \(q=17,19\). Analytic gcd/separability/monodromy cases exhaust all redundancy-five pencils for \(q\ge20\), and the sharper binary argument covers \(q\ge16\); exactly seven smaller fields remain certificate-dependent, with \(q=16\) retained only as regression. The manuscript carefully distinguishes two dual finite-geometric line conventions and identifies them via symplectic polarity. Its actual contribution relative to the line-class literature is not a new pencil-level partition, but the nonsurjective Hankel map from divided-power syndromes to pencils, canonical syndrome representatives and orbit/fusion data, the all-characteristic exact fiber count, and the independent radius promotion to deep holes. A complete sporadic table lists 17 orbits across the seven fields, though extension-field coordinate encodings are not yet specified.
- Questions carried forward: What finite-field models and element encodings underlie the \(q=8,9\) representatives? Where are the complete pencil-member histograms stored, and can they be read without unpublished working files? How does Certificate R5 prove orbit completeness, stabilizers, Frobenius fusion, and agreement with the analytic families? Will the manuscript summarize the dense BPS/Kaipa/Davydov class correspondences in a table rather than prose?
- Top accessibility issue so far: The literature reconciliation is mathematically valuable but overpacked, and the sporadic inventory is not self-contained over extension fields. The highest-value repairs are (1) a correspondence table for manuscript versus literature line classes and proof thresholds, and (2) explicit finite-field defining polynomials/element encodings plus a precise histogram location for the sporadic representatives.
### packet-14 / paragraph-0157.tex — Table “Independent R5 completeness totals” (`tab:r5-sanity`)

- Job: Cross-check the finite R5 classification by comparing direct enumeration with orbit–stabilizer totals and independently decomposing each total into analytic/nonsporadic and certified sporadic contributions.
- First-pass accessibility: Minor friction. The arithmetic checks are transparent, but the counted object and normalization are left in the surrounding context.
- Friction: The caption should say explicitly that each total counts projective split-free/deep-hole syndrome directions, not literal syndrome vectors, pencils, or codewords. “direct \(=\) orbit sum” is a check rather than a numerical category, while the adjacent columns form a different decomposition; a two-level heading would make this structure immediate.
- Smallest high-value repair: Add “projective deep-hole syndrome directions” to the caption and group the columns under “independent equality” and “nonsporadic + sporadic decomposition.”
- Finding: MINOR.
### packet-14 / paragraph-0158.tex — Remark “No one-column MDS extension at this radius” (`rem:q8-no-extension`), part 1

- Job: Prevent a likely misinterpretation of the large \(q=8\) deep-hole count by reiterating that full-support radius four yields NMDS, not MDS, appended-column extensions.
- First-pass accessibility: Yes. The distinction is direct and consistent with the earlier extension dictionary.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-14 / paragraph-0159.tex — Remark on deep holes versus MDS extensions, part 2

- Job: Explain the one-column difference between deep-hole and arc-extension span conditions and restate the impossibility of an MDS extension through Dür's completeness/radius equivalence, uniformly across the classified full-support redundancies.
- First-pass accessibility: Yes. The \(r-2\) versus \(r-1\) column thresholds make the distinction memorable and remove any ambiguity.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-14 / paragraph-0160.tex — end of Remark `rem:q8-no-extension`

- Job: Close the preceding remark.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-14 / paragraph-0161.tex — Section “Sharp fixed-level and modular refinements” (`sec:fixed-level-roadmap`)

- Job: Open the section containing exact redundancy-six/seven and small-characteristic refinements beyond the uniform theorem.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-14 / paragraph-0162.tex

- Job: Position the fixed-level results relative to the uniform carrier/escape theorem, state what sharper arithmetic they add, preview their proof inputs, and emphasize logical independence from the uniform argument.
- First-pass accessibility: Minor friction. The role and dependency direction are clear, but the method sentence uses internal package vocabulary.
- Friction: “stagewise polar packages” is not a standard mathematical object, and “marker and ramification divisors” does not say on which parameter spaces they live or what is excluded. “explicit adjacent-zero Hankel kernels” is more concrete but the relation to the Lucas carrier could be stated.
- Smallest high-value repair: Replace the package phrase by the actual method—successive one-marker contractions with compatible lower-level classifications—and identify the divisors as bad marker/branch loci and the adjacent-zero kernels as the fixed-level Lucas-carrier pieces.
- Finding: MINOR.
### packet-14 / paragraph-0163.tex

- Job: Point readers to the exact redundancy-six/seven theorems and reiterate the proof order: classify split-free directions geometrically, then promote them to deep holes using an independent radius theorem.
- First-pass accessibility: Minor friction because the cited radius proposition does not visibly list these two fixed levels.
- Friction: Proposition `prop:upper-radius` previously displayed radius statements for redundancies eight through ten and only a general large-characteristic clause, whereas this paragraph advertises separate redundancy-six/seven gates including exceptional/small-field ranges. A reader cannot tell whether the general clause covers every case below or whether a different R6/R7 radius result is intended.
- Smallest high-value repair: Cite the exact redundancy-six and redundancy-seven radius propositions/clauses alongside each theorem, or state explicitly which hypothesis of `prop:upper-radius` covers them.
- Finding: MINOR.
### packet-14 / paragraph-0164.tex — Theorem “Redundancy-six deep holes and redundancy-seven split-free syndromes” (`thm:spine`)

- Source metadata: `coverage{conditional_deduction}`; Lean items `PRSRedundancySixSeven.redundancySixAllFieldSynthesis`, `redundancySevenAllFieldSynthesis`, `PRSPolarInduction.fifthPower_sigmaInversionOrbitCount`.
- Job: Give an all-field summary of the exact R6 deep-hole classification and R7 split-free/deep-hole status, including persistent families, binary nuclei, small-field exceptions, and unresolved radius separations.
- First-pass accessibility: Major friction. The statement compresses several logically different classifications and radius regimes into forward references and status shorthand.
- Friction: Part (a) does not print or summarize the “five finite-field exception rows,” so the purported exact classification depends on a later theorem. Part (b) alternates among split-free classification, deep-hole classification for \(q\ge11\), a radius-seven \(q=8\) extraction, and “radii at \(q=7,9\) remain separate” without saying whether those radii are unknown, known elsewhere, or simply outside the theorem. At redundancy seven, the expected split-free/deep promotion normally uses radius six, so the significance of radius seven and why only the nine-direction diagonal tangent orbit plus nucleus are deepest needs explanation. “central nucleus point” versus “characteristic-two nucleus orbit” is also not defined.
- Smallest high-value repair: Replace the prose enumeration with a status table by redundancy and field range, with columns for known radius, object classified (split-free or deep), surviving families, and certificate/theorem source. Print the five R6 exception rows or give their field/orbit summaries directly, and explain the \(q=8\) radius-seven extraction in one sentence.
- Finding: MAJOR.
### packet-14 / paragraph-0165.tex

- Job: Preview the stagewise R6/R7 proof mechanism, list all trapped-line obstructions, state how an untrapped line yields a terminal split witness, point to the exhaustive appendix/certificates, and delimit higher-level companion work.
- First-pass accessibility: Major friction. The paragraph is intended as orientation but is written almost entirely in package/divisor shorthand.
- Friction: “first two pointed packages,” “persistent rank-two carrier,” “exact-linear-gcd boundary,” “modular nucleus,” “self-collision divisor,” “polar line,” and “proper bad scheme” are not assembled into a defined parameter-space picture. “The remaining line” has no antecedent: it could mean a contraction line not in any obstruction, a line in the Hankel kernel, or a pencil line. The reader cannot see how these four cases are exhaustive or how the terminal cubic cover attaches to the line.
- Smallest high-value repair: Replace the first three sentences by a four-row obstruction table naming the line/parameter space, the defining condition, its geometric family, and how it is handled; then state explicitly that any contraction line outside their union meets the terminal bad locus in boundedly many marker values, leaving a good terminal pencil.
- Finding: MAJOR.
### packet-14 / paragraph-0166.tex — Section “Scope and open problems” (`sec:boundary`)

- Job: Open the section delimiting proved scope and remaining questions.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-14 / paragraph-0167.tex — Scope summary list

- Job: Separate the geometrically complete recursive-carrier result from unresolved small-characteristic arithmetic and inventory completion status at redundancies five through ten and arbitrary redundancy.
- First-pass accessibility: Major friction. The numbered structure helps, but several boundary phrases are not self-contained enough for a scope/open-problems section.
- Friction: “need not share the degree-nine answer” is unexplained—degree nine could mean redundancy, form degree, extension degree, or a specific computed pattern. “only the \(q=7,9\) radius gates remain separate” does not say whether those radii are unknown/open or merely proved elsewhere. “the stated high-field ranges” forces a search instead of printing the R8–R10 thresholds. “degree-one modular union,” “later Lucas carriers,” and “evaluated levels” are internal descriptions, so the precise open arithmetic problem is not formulated as a mathematical question.
- Smallest high-value repair: Use a compact completion-status table with explicit \(r,q,p\) ranges, known radius, split-free/deep status, and open item. Replace “degree-nine answer” by the exact R9 phenomenon and formulate the arbitrary-\(r\) open problem as deciding which \(f\in\mathcal M^{\max}_{r,p}(\mathbb F_q)\) have a squarefree split degree-\(r-2\) form in \(W_f\).
- Finding: MAJOR.
### packet-14 / paragraph-0168.tex

- Job: Explicitly disclaim a solution of the general Reed–Solomon deep-hole conjecture and restate the exact unconditional containment versus large-characteristic classification boundary.
- First-pass accessibility: Minor friction. The logical scope is clear, but the conjecture and range are referenced generically.
- Friction: “the general Reed–Solomon deep-hole conjecture” can refer to several related formulations depending on standard/projective support and rate, and it is neither stated nor cited. “the displayed field range” is also less usable than the exact theorem/threshold reference in a boundary statement.
- Smallest high-value repair: Name or state the precise conjecture being disclaimed and cite it; replace “displayed field range” with \(q\ge Q^*_{r,s}\) (binary variant as applicable) or an exact theorem reference.
- Finding: MINOR.
## packet-14 note

- Current mental model: The redundancy-five certificate has two independent completeness checks: direct syndrome enumeration agrees with orbit–stabilizer sums, and the same totals split into analytic/nonsporadic plus sporadic contributions; \(q=16\) is a deliberately redundant no-sporadic regression field. Deep holes and one-column MDS extensions differ by one span threshold, so full-support radius \(r-1\) simultaneously identifies deep directions and forbids MDS extension points. The next layer claims exact R6 deep-hole and R7 split-free classifications, with persistent rank-two families, finite exceptions, and binary nuclei; R7 promotes to deep holes for \(q\ge11\), while \(q=8\) has radius seven and ten extracted deepest directions. The general recursive carrier is geometrically complete, but deciding squarefree-split incidence for rational points on later small-characteristic Lucas carriers remains the main arithmetic frontier.
- Questions carried forward: What are the five R6 finite-field exception rows and the precise R6/R7 family normal forms? Are the R7 radii at \(q=7,9\) unknown, or merely delegated to separate results? What explicit high-field ranges and exception hypotheses apply at R8–R10? What does “degree-nine answer” mean, and how exactly does it motivate the open Lucas-carrier arithmetic problem? How do the appendix's stagewise polar calculations and certificates establish the R6/R7 contained-component cases?
- Top accessibility issue so far: The scope material should be the easiest place to learn exactly what is proved and what remains open, but it currently relies on forward references and internal phrases. A single completion-status table with explicit field ranges, radii, classified objects, surviving families, and open cases would repair both the R6/R7 theorem summary and the final boundary section.
### packet-15 / paragraph-0169.tex

- Job: Highlight the opposite movement of observed last-sporadic fields and analytic no-sporadic field gates across R5–R7, motivating an open question about sporadic behavior at high redundancy.
- First-pass accessibility: Minor friction. The numerical contrast is striking, but “field-order gate” is not defined.
- Friction: A reader cannot tell whether \(23,29,37\) are the first prime powers above an analytic threshold, the first fields covered by a radius theorem, or empirically first fields with no exceptions. “persistent and modular loci” should be tied explicitly to \(\mathcal P_r\) and \(\mathcal M^{\max}_{r,p}\).
- Smallest high-value repair: Say “the first prime-power field orders at which the analytic no-sporadic proof applies are …” (if intended), and formulate the question as whether exceptions outside \(\mathcal P_r\cup\mathcal M^{\max}_{r,p}\) persist for arbitrarily large \(r\).
- Finding: MINOR.
### packet-15 / paragraph-0170.tex — Section “Acknowledgment”

- Job: Open the acknowledgment section.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-15 / paragraph-0171.tex

- Job: Disclose the scope of AI assistance, the author's supervision/checking, and responsibility for the final work.
- First-pass accessibility: Yes. The disclosure is specific and unambiguous.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-15 / paragraph-0172.tex — Section “Stagewise interfaces for the fixed-level refinements” (`sec:polar`)

- Job: Open the technical section/appendix formalizing the one-level polar interfaces used in R6/R7 refinements.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-15 / paragraph-0173.tex

- Job: Reiterate that stagewise polar results are logically separate from the simultaneous uniform proof, explain why fixed-level appendices retain them, and promise self-contained interface proofs.
- First-pass accessibility: Yes. The dependency and purpose are explicit.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-15 / paragraph-0174.tex — One-step lift interface (`eq:lift`)

- Job: State the one-marker specialization of composite contraction and the exact coprimality condition for lifting a lower squarefree witness.
- First-pass accessibility: Yes. This finally supplies the equation referenced in the earlier coherent-polar-flag definition.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-15 / paragraph-0175.tex — Theorem “Polar-flag construction” (`thm:polar-construction`)

- Source metadata: `coverage{conditional_deduction}`; Lean items `PRSPolarInduction.iteratedProjectiveSequenceContraction_map`, `sequenceContraction_agrees_with_finite`, `PointedKernelLift.lift_splitSquarefreeKernelMember`.
- Job: State functoriality/equivariance of iterated contraction and the iterated witness-lift/squarefreeness criterion.
- First-pass accessibility: Major friction because the squarefreeness statement lacks an explicit marker-distinctness hypothesis.
- Friction: If two \(\lambda_i\) are proportional, the product \(\lambda_1\cdots\lambda_jg\) has a repeated factor regardless of \(g\); “avoids every distinct marker” does not clearly say that the marker directions are pairwise distinct. The theorem also does not state that the \(\lambda_i\) are nonzero/projective root directions. A reader cannot tell whether distinctness is assumed from the earlier coherent-flag definition, proved as part of “avoids,” or omitted.
- Smallest high-value repair: Begin “For pairwise distinct marker directions \([\lambda_1],\ldots,[\lambda_j]\in\mathbb P(E^\vee)\) …” and conclude “the lift is squarefree iff \(g\) is squarefree and none of the \(\lambda_i\) divides \(g\).” If repetition is allowed, state the general coprimality/multiplicity criterion instead.
- Finding: MAJOR.
### packet-15 / paragraph-0176.tex — proof of polar-flag construction

- Job: Derive functoriality from the perfect pairing, iterate the one-step lift identity, and reduce squarefreeness to coprimality of two squarefree factor products.
- First-pass accessibility: Minor friction. The proof itself is clear, but “the distinct markers” confirms an assumption that was not stated in the theorem.
- Friction: The definite phrase presupposes pairwise distinctness rather than deriving it. Readers should not need to import that condition from the earlier coherent-flag definition into a standalone theorem.
- Smallest high-value repair: Move the pairwise-distinct marker hypothesis into the theorem statement; the proof then needs no further change.
- Finding: MINOR.
### packet-15 / paragraph-0177.tex — Definition “One-step lower package” (`def:lower-package`)

- Job: Abstract the data needed for one stage of fixed-level escape: a lower bad locus and strata, a splitting curve with point bound, bad-incidence deletions, forbidden markers, and a map from surviving rational points to lower witnesses.
- First-pass accessibility: Major friction. The ingredients are recognizable, but their ambient spaces, dependence on parameters, and connecting maps are not typed.
- Friction: “lower bad locus” is not placed in a syndrome/projective/marker space; “on each stratum” could mean one curve per stratum or a family of curves over the stratum; the deletion scheme presumably lies on each splitting curve, while the “finite parameter scheme” presumably lies in the marker line, but neither ambient is stated. “proper geometrically integral splitting curve” may vary in genus, and “every unavailable marker” is undefined. Most importantly, the map taking a surviving curve point to a split squarefree lower witness is asserted but not included as package data.
- Smallest high-value repair: Present the package as a typed bullet list or diagram: base stratum \(B\), curve family \(\pi:C\to B\), deletion subscheme \(D\subset C\), forbidden-marker subscheme \(M\subset\mathbb P^1\), witness map \(C\setminus D\to\mathbb P(W_{\iota_\lambda f})\), and uniform genus/degree/point bounds. Define “unavailable” by the exact marker conditions.
- Finding: MAJOR.
### packet-15 / paragraph-0178.tex — Definition “Contained-component assertion” (`def:contained`)

- Job: Abstract the exhaustive upper-level claim that three ways a one-step contraction can fail globally—degenerate contraction, a polar image trapped in the lower bad scheme, or universal marker collision—force the upper syndrome into a known closed exceptional list.
- First-pass accessibility: Major friction. The three failure modes are named, but the contraction/polar map and collision divisor have not been defined as objects.
- Friction: “contraction is noninjective” is ambiguous between the linear map \(E^\vee\to\Gamma^{r-2}E\), the projective marker map, and contraction on witness spaces. “polar line” should be the image of a map \([\lambda]\mapsto[\iota_\lambda f]\), but this map is not displayed and can fail to be defined where contractions vanish. The collision divisor's equation and ambient marker line are unstated. “closed upper list \(\mathcal C\)” sounds like a list rather than a closed union/scheme.
- Smallest high-value repair: Define the polar rational map \(c_f:\mathbb P(E^\vee)\dashrightarrow\mathbb P(\Gamma^{r-2}E)\), its image line and base locus, define the collision divisor on its domain, and state the assertion as a set/scheme containment in a closed union \(\mathcal C\).
- Finding: MAJOR.
### packet-15 / paragraph-0179.tex — Lemma “Collision criterion” (`lem:marker-collision`)

- Source metadata: `coverage{absent}`.
- Job: Characterize marker values at which every lifted witness acquires a repeated marker factor, both in lower-witness gcd language and as the collision divisor of the upper linear series.
- First-pass accessibility: Minor friction. The fixed-factor equivalence is concrete, but the divisor terminology is not defined.
- Friction: “every lift through \(\lambda\)” should explicitly quantify \(g\in W_{\iota_\lambda f}\) and refer to \(\lambda g\). “collision divisor of the linear series \(W_f\)” is offered as an equivalent standard-geometric label without giving its equation or construction, despite that divisor being central to the contained-component assertion.
- Smallest high-value repair: Write the quantified condition \(\lambda\mid g\) for every lower witness \(g\), and define the collision divisor as the vanishing locus of the appropriate evaluation/Wronskian (or give its exact prior reference).
- Finding: MINOR.
### packet-15 / paragraph-0180.tex — proof of collision criterion

- Job: Use the one-step lift identity to equate repeated marker factors with a fixed lower gcd, then interpret the same condition as ramification/zero differential of the morphism defined by the base-point-free linear series \(W_f\).
- First-pass accessibility: Yes. The displayed intersection identity and differential interpretation connect the algebraic and geometric collision notions cleanly.
- Friction: None requiring repair in the proof itself.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
## packet-15 note

- Current mental model: The observed last sporadic fields decrease from R5 to R7 even as the analytic no-sporadic gates increase, motivating a genuine asymptotic question about exceptions outside the persistent catalecticant and modular Lucas loci. The technical appendix then formalizes stagewise contraction. One-step and iterated divided-power contractions lift lower witnesses by multiplying marker factors, with squarefreeness governed by marker distinctness and coprimality. A “one-step lower package” is intended to bundle the lower bad locus, complementary strata, splitting-curve families, bad-incidence deletions, and forbidden-marker data needed for a rational-point escape. A “contained-component assertion” is intended to say that degenerate polar maps, polar lines wholly trapped in the lower bad scheme, or identically colliding marker lines force the upper syndrome into a known exceptional union. For a base-point-free \(W_f\), a marker collision is equivalently a fixed factor in every lower witness and a zero of the differential of the morphism defined by \(W_f\).
- Questions carried forward: What are the exact source/target and base-locus conventions for the polar map \([\lambda]\mapsto[\iota_\lambda f]\)? How are the lower-package curve family, deletion divisor, forbidden-marker scheme, and witness map typed over a stratum? What equation/degree defines the collision divisor, and how is the universal-collision case classified? Where is pairwise marker distinctness imposed in the polar-flag theorem? How do these abstract interfaces instantiate at R6 and R7?
- Top accessibility issue so far: The invariant one-step lift identity is clear, but the two core interface definitions are too untyped to serve readers outside the authors' framework. A single diagram of the marker line, polar map, lower stratum, splitting-curve family, deletion divisor, and witness lift would substantially improve the entire fixed-level appendix; the pairwise-distinct marker hypothesis also needs to be explicit in the theorem statement.
### packet-16 / paragraph-0181.tex — Lemma “Uniform collision bound” (`lem:uniform-collision`)

- Source metadata: `coverage{absent}`.
- Job: Uniformly bound the ramification/collision divisor of the lower witness linear series, isolate the only inseparable level/characteristic pairs, and place their lifts inside already declared exceptional carriers.
- First-pass accessibility: Minor friction. An algebraic geometer can parse the \(g^r_d\) statement, but the manuscript-specific indexing and exceptional destinations are not spelled out.
- Friction: The notation \(g^{j-4}_{j-2}\) is introduced without saying that it is the projectivized lower witness system of degree \(j-2\) and dimension \(j-4\). “collision divisor” relies on the prior differential interpretation but its degree convention is not recalled. “declared persistent or modular carrier” does not identify whether \((5,3)\) goes to the tangent/catalecticant carrier and \((6,2)\) to the Lucas carrier, or vice versa.
- Smallest high-value repair: Add a parenthetical identifying the linear series with \(\mathbb P(W_f)\), state that the collision divisor is the zero divisor of its differential, and name the carrier containing each exceptional inseparable lift.
- Finding: MINOR.
### packet-16 / paragraph-0182.tex — proof of uniform collision bound

- Job: Classify inseparability by Frobenius factorization and a degree/dimension inequality, and bound the separable collision scheme by a binary Wronskian degree.
- First-pass accessibility: Yes. The argument is short, quantitative, and cites the fixed-level propositions handling the two exceptional pairs.
- Friction: None requiring repair for the intended expert audience.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-16 / paragraph-0183.tex — Lemma “Linear modular pullback” (`lem:linear-modular-pullback`)

- Source metadata: `coverage{fragment}`; Lean item `PRSPolarInduction.mem_modularContractionKernel_iff`.
- Job: Bound the marker values whose lower contraction lands in a linear modular nucleus, unless the entire polar image is contained there.
- First-pass accessibility: Yes. It is the elementary projective-line/linear-subspace trichotomy needed for a degree-one deletion budget.
- Friction: None requiring repair in context.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-16 / paragraph-0184.tex — proof of linear modular pullback lemma

- Job: Reduce the pullback trichotomy and degree bound to linearity of polar-map coordinates in the marker.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-16 / paragraph-0185.tex — Lemma “Old-marker fixed-factor divisor” (`lem:old-marker-fixed-factor`)

- Source metadata: `coverage{absent}`.
- Job: Bound the next-marker values that make a previously retained marker become a fixed factor of every lower witness, thereby controlling loss of squarefreeness under iterated lifting.
- First-pass accessibility: Yes. The quantifiers and degree-three bound are explicit.
- Friction: None at the statement level.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-16 / paragraph-0186.tex — proof of old-marker fixed-factor lemma

- Job: Express the fixed-factor condition by cubic maximal minors and prove properness by showing universal vanishing would force the old marker to divide every member of \(W_f\).
- First-pass accessibility: Yes. The determinantal degree and contradiction with trivial gcd are both transparent.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-16 / paragraph-0187.tex — Lemma “Exact-linear-gcd transport” (`lem:exact-linear-gcd-transport`)

- Source metadata: `coverage{fragment}`; Lean items `PRSUniformCoveringRadius.exactLinearFlagParameterBudget_lt_uniformParameterBudget`, `UniformIteratedPackageInput.packages_fit_uniform_threshold`.
- Job: Show that an exact common linear factor persists unchanged through coherent contractions away from that factor, unless the syndrome enters the rank-two carrier.
- First-pass accessibility: Yes. The hypothesis, excluded marker, and persistence conclusion are concise.
- Friction: None at the statement level.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-16 / paragraph-0188.tex — proof of exact-linear-gcd transport

- Job: Use the lift inclusion and coprimality to preserve the linear factor, rule out gcd growth outside the rank-two carrier, and iterate while maintaining squarefreeness.
- First-pass accessibility: Yes. The proof matches the statement step for step.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-16 / paragraph-0189.tex — Lemma “Identically colliding stages” (`lem:identically-colliding`)

- Source metadata: `coverage{absent}`.
- Job: Classify the universal-collision failure mode as precisely the two inseparable fixed-level components and assert that no new upper exception arises after coherent lifting.
- First-pass accessibility: Minor friction. The classification is concise, but the destinations are again referred to generically.
- Friction: “characteristic-three R5” and “characteristic-two R6 components” should be identified by their normal forms/names, and “the declared carrier” should name \(\mathcal P_r\) or \(\mathcal M^{\max}_{r,p}\) for each. Without that, the lemma does not tell the reader how universal collision is absorbed into the final carrier equality.
- Smallest high-value repair: Name both inseparable components and state their exact lifted containment, e.g. “the R5 all-cube nucleus lifts into …; the R6 binary component lifts into ….”
- Finding: MINOR.
### packet-16 / paragraph-0190.tex — proof of identically-colliding-stages lemma

- Job: Chain the collision/differential criterion to the inseparability classification, identify the two fixed-level components by earlier propositions, and cite the lifting results that absorb them into upper carriers.
- First-pass accessibility: Minor friction. The logical chain is clear, but one exceptional component is described by a new compound label rather than its established normal form.
- Friction: “wild rank/fixed-factor boundary” has not been used as a stable family name and does not immediately evoke the R5 all-cube nucleus pencil \(\langle T^3,U^3\rangle\). The proof would be easier to audit if each cross-reference were accompanied by the concrete component and target carrier it supplies.
- Smallest high-value repair: Replace the compound label with the explicit R5 normal form and add parenthetical target carriers after the R5 and R6 references.
- Finding: MINOR.
### packet-16 / paragraph-0191.tex — Theorem “Finite-depth polar escape” (`thm:induction`)

- Source metadata: `coverage{fragment}`; Lean items `PRSPolarInduction.iteratedProjectiveSequenceContraction_map`, `sequenceContraction_agrees_with_finite`, `CoherentPolarInput.splitFree_implies_persistent_or_modular`.
- Job: Package the stagewise escape argument: choose a rational marker outside each proper unavailable-marker scheme, reach a terminal splitting curve, use its point lower bound to survive the deletion budget, and lift the resulting terminal witness.
- First-pass accessibility: Major friction. The quantitative core is simple, but the hypotheses do not explicitly state the stagewise selection logic and reuse a globally fixed symbol.
- Friction: \(s\) has meant \(|A|\) throughout the paper and is now reset to the number of contraction stages. “\(s\) coherent contraction stages have unavailable-marker schemes” sounds as though the stages/markers already exist, whereas the degree condition is presumably used to construct them inductively. It is not stated that a degree-\(<q+1\) scheme on \(\mathbb P^1\) misses an \(\mathbb F_q\)-point, nor how the next scheme depends on prior choices. The theorem also omits an explicit conclusion about distinctness/coprimality of markers needed for the lifted product to remain squarefree.
- Smallest high-value repair: Rename the depth \(\ell\); state the induction (“at stage \(i\), after earlier choices, a zero-dimensional forbidden scheme \(D_i\subset\mathbb P^1\) of degree \(d_i<q+1\) leaves a rational marker distinct from all earlier ones”); then invoke the pairwise-distinct lift theorem explicitly after the terminal inequality.
- Finding: MAJOR.
### packet-16 / paragraph-0192.tex — proof of finite-depth polar escape

- Job: Carry out successive rational marker selection, use the terminal point-count inequality to avoid deletions, and iteratively lift the coprime terminal witness to \(W_f\).
- First-pass accessibility: Yes. The proof supplies the selection and distinctness logic that was compressed in the theorem statement.
- Friction: None in the proof itself; its explicit “distinct marker factors” condition should be reflected in the theorem hypotheses.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
## packet-16 note

- Current mental model: The fixed-level stagewise interface now has concrete degree budgets. For the lower witness linear series \(g^{j-4}_{j-2}\), the collision/ramification divisor has degree at most \(2j-6\) unless the map is inseparable; Frobenius factorization leaves only R5 in characteristic three and R6 in characteristic two, whose lifts are absorbed into known carriers. A linear modular nucleus pulls back along the marker line in degree at most one unless the whole polar line is contained. A previously chosen marker becomes a fixed lower factor for at most three next-marker values when the upper gcd is trivial. An exact linear gcd transports unchanged along coherent contractions outside the rank-two carrier. Whole-line collision is exactly the two inseparable cases. The finite-depth escape theorem then chooses rational markers successively outside degree-\(<q+1\) forbidden schemes, uses a genus/point lower bound \(q+\kappa-2g\sqrt q\) to beat a terminal deletion degree \(\delta\), and lifts a supported squarefree witness through distinct markers.
- Questions carried forward: Which explicit carrier contains each inseparable R5/R6 component after arbitrary coherent lifting? How do the degrees \(2j-6\), one, and three combine into the actual R6/R7 marker budgets? What are the concrete curve genus \(g\), correction \(\kappa\), and deletion degree \(\delta\) at each fixed level? Are earlier markers explicitly included in every unavailable-marker scheme, ensuring pairwise distinctness? How do the contained-component assertions invoke these lemmas to produce the closed exception lists?
- Top accessibility issue so far: Most individual degree lemmas are clear and useful, but the abstract finite-depth theorem should state the stagewise selection data rather than relying on its proof to reveal them. Renaming the contraction depth away from the globally fixed deletion-size symbol \(s\), and explicitly including prior markers in each forbidden scheme, would make the interface much safer to reuse.
### packet-17 / paragraph-0193.tex — Proposition “Contained rank-two polar lines” (`prop:contained-rank-two`)

- Source metadata: `coverage{absent}`.
- Job: Characterize exactly when an injective upper syndrome has its entire one-step contraction line trapped in the lower catalecticant carrier, and otherwise bound the exceptional marker parameters by degree three.
- First-pass accessibility: Yes. The contained-versus-proper-intersection dichotomy and upper/lower carrier relation are explicit.
- Friction: None requiring repair in this technical context, assuming the polar map and catalecticant loci are fixed as earlier.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-17 / paragraph-0194.tex — proof of contained rank-two polar-lines proposition

- Job: Prove the containment equivalence by restricting the upper second catalecticant to marker-divisible subspaces and use cubic maximal minors for the noncontained degree bound.
- First-pass accessibility: Major friction. The proof finally relies on the exact catalecticant map, but introduces it only by symbol.
- Friction: \(C_f^{(2)}\) is not defined, so the reader cannot determine its source, target, why rank three is the only case outside the upper rank-two locus, or why \(\dim K=n-4\). The restriction identity \(C_{\iota_\lambda f}^{(2)}=A|_{H_\lambda}\) is the key functorial bridge but its types are invisible. This also leaves the manuscript's long-standing definition of \(\mathcal P_r\) unresolved.
- Smallest high-value repair: Before the proof, define the second catalecticant explicitly, for example \(C_f^{(2)}:\operatorname{Sym}^{n-2}E^\vee\to\Gamma^2E\), \(R\mapsto\iota_Rf\) (adjust to the intended convention), and state that \(\mathcal P\) is its rank-\(\le2\) degeneracy locus. Then give the source/target of the restriction identity and the dimension count.
- Finding: MAJOR.
### packet-17 / paragraph-0195.tex — Section “Redundancies six and seven: complete and gated results” (`sec:r67`)

- Job: Open the detailed R6/R7 classification and radius-gate section.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-17 / paragraph-0196.tex

- Job: State the appendix's input, identify exhaustive polar-line case classification as the main task, and explain that structural cases plus bounded certificates prove the exact R6/R7 theorems.
- First-pass accessibility: Major friction. The paragraph repeats the internal package terminology instead of instantiating the abstract interface for R6/R7.
- Friction: “marked polar-escape theorem,” “first two pointed lower packages,” “fixed gcd,” “modular nucleus,” “self-collision,” and “transverse cases” are not tied to a specific upper syndrome, marker line, lower R5/R6 bad locus, or defining equations. The reader cannot tell which four cases are disjoint/exhaustive or which require certificates.
- Smallest high-value repair: Add an R6/R7 instantiation table with columns: upper redundancy, lower level, polar-line condition, resulting family/carrier, analytic treatment, and finite certificate range. Replace “packages” with the concrete one-step contraction problems.
- Finding: MAJOR.
### packet-17 / paragraph-0197.tex — Subsection “Redundancy six”

- Job: Open the detailed redundancy-six analysis.
- First-pass accessibility: Yes.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-17 / paragraph-0198.tex

- Job: Specialize the Hankel witness system to redundancy six and restate split-freeness as absence of a squarefree completely split quartic in the resulting net.
- First-pass accessibility: Yes. The coordinates, matrix, projective dimension, and criterion are concrete.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-17 / paragraph-0199.tex — Proposition “Persistent net and orbit law” (`prop:r6-persistent`)

- Source metadata: `coverage{fragment}`; Lean items `PRSRedundancySixSeven.PersistentModularFamilyData.classified_card_doubled`, `PRSPolarInduction.fifthPower_sigmaInversionOrbitCount`.
- Job: Identify the quadratic-gcd R6 nets, give the total persistent split-free count, and state the tangent/conjugate-fiber orbit actions controlling finer orbit decomposition.
- First-pass accessibility: Major friction. The gcd structure and total count are clear, but the orbit law is untyped and unmotivated.
- Friction: “tangent fiber,” “unipotent coordinate” \(x\), parameter \(u\), “irreducible quadratic fiber,” norm-one torus \(T\), quotient \(T/T^5\), inversion, and coefficient Frobenius are not defined. It is unclear which group acts on which set of syndromes/nets, what the quotient parametrizes, or how the fifth-power law refines the already counted tangent/conjugate families.
- Smallest high-value repair: Separate the orbit statement into a fully defined proposition/remark: specify the stabilizer group of a chosen quadratic \(Q\), give normal-form coordinates for the fiber of syndromes with gcd \(Q\), define \(T\), and state the orbit equivalence relation. Keep the structural gcd/count proposition independent.
- Finding: MAJOR.
### packet-17 / paragraph-0200.tex — proof of persistent-net/orbit-law proposition

- Job: Count tangent and irreducible-quadratic fibers, then give normal forms and stabilizer actions that realize the additive and norm-one-torus orbit laws, including the characteristic-five degeneration.
- First-pass accessibility: Minor friction. This paragraph supplies the definitions missing from the proposition, and the total count is easy to verify, but several transitions are compressed.
- Friction: The opening annihilator \(Q\operatorname{Sym}^3E^\vee\) is not related explicitly to the earlier condition \(W_f=Q\operatorname{Sym}^2E^\vee\). “one endpoint has dependent Hankel rows” does not identify the excluded syndrome or why exactly one. “acts by fifth powers” should say that the stabilizer's image consists of multiplication by elements of \(T^5\), so its orbits are \(T/T^5\). The final “characteristic-five tangent splitting” is announced without stating the resulting number/shape of tangent orbits.
- Smallest high-value repair: Add the annihilator-to-kernel equivalence, name the excluded endpoint, and explicitly state the orbit relation and what changes when \(5=0\).
- Finding: MINOR.
### packet-17 / paragraph-0201.tex — Lemma “Exact linear gcd is shallow” (`lem:r6-gcd1`)

- Source metadata: `coverage{absent}`.
- Job: Eliminate the entire exact-linear-gcd R6 stratum from the split-free list for all fields in scope.
- First-pass accessibility: Yes. The hypothesis and constructive shallowness conclusion are explicit.
- Friction: None at the statement level.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-17 / paragraph-0202.tex — proof of exact-linear-gcd shallowness (polynomial argument, part 1)

- Job: Reduce the problem to finding a distinct finite-root cubic in a hyperplane \(V\), assume none exists, and use a bounded-degree finite-field polynomial identity to force the coefficients \(c_1,c_2,c_3\) of the annihilating functional to vanish.
- First-pass accessibility: Yes. The affine normalization, symmetric-coordinate polynomial \(P\), unique bad \(z\), degree bound, and domain argument form a coherent contradiction setup.
- Friction: None requiring repair for the intended expert audience; the remaining constant-functional case is naturally left to the continuation.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-17 / paragraph-0203.tex — proof of exact-linear-gcd shallowness (conclusion)

- Job: Interpret the forced constant functional as saying every cubic in \(V\) shares the old factor, contradict exact gcd degree, and construct the desired squarefree quartic.
- First-pass accessibility: Yes. The contradiction and final multiplication are immediate.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-17 / paragraph-0204.tex — Proposition “First-polar line and secant degree” (`prop:r6-secant`)

- Source metadata: `coverage{fragment}`; Lean item `PRSPolarInduction.sequenceContraction_agrees_with_finite`.
- Job: Give explicit affine coordinates for the R6 first-polar contraction line, state the one-step witness identity in those coordinates, and bound its intersection with the lower rank-two/secant carrier.
- First-pass accessibility: Minor friction. The formula is concrete, but it reuses the manuscript's central redundancy symbol and names the lower locus differently.
- Friction: \(r\) has denoted redundancy throughout the paper and is now used as an affine marker coordinate inside a redundancy-six proposition. “lower secant cubic” should be identified with the R5 rank-at-most-two catalecticant hypersurface \(V(D)\), otherwise the relation to Proposition `contained-rank-two` is hidden.
- Smallest high-value repair: Rename the marker coordinate \(t\) or \(\alpha\), and write “the lower secant/catalecticant cubic \(\mathcal P_5=V(D)\).”
- Finding: MINOR.
## packet-17 note

- Current mental model: The contained rank-two case is governed by the second catalecticant: restricting the upper map \(C_f^{(2)}\) to marker-divisible subspaces gives lower catalecticants. An injective upper polar line lies wholly in the lower rank-two locus exactly when the upper syndrome is rank at most two; otherwise cubic minors bound the bad marker scheme by degree three. At R6, \(W_f\) is a net of quartics. Quadratic-gcd nets are exactly \(Q\operatorname{Sym}^2E^\vee\), producing the persistent tangent/conjugate locus of size \(q(q+1)^2/2\) and finer stabilizer orbit laws; exact-linear-gcd nets are always shallow for \(q\ge7\) by a direct finite-field polynomial argument. The first-polar line has the explicit contraction coordinates \(b(t)=(a_1-ta_0,\ldots,a_5-ta_4)\), and a trivial-gcd polar line meets the lower R5 secant/catalecticant cubic in degree at most three.
- Questions carried forward: What is the formal definition and matrix of \(C_f^{(2)}\), and how does it globally define \(\mathcal P_r\)? What are the complete R6 modular and sporadic components after the persistent and exact-linear-gcd strata? How does the fifth-power torus/additive orbit law change specifically in characteristic five? Which four polar-line cases exhaust R6, and where do their marker/deletion budgets enter the final threshold/certificate bridge?
- Top accessibility issue so far: The appendix is finally concrete at R6, but it still has not displayed the second catalecticant map on which the central carrier and contained-line proof depend. Defining that map once, with source/target and degeneracy locus, is the highest-value repair. The persistent orbit law should also be separated from the structural count and introduced with its stabilizer/fiber coordinates.
### packet-18 / paragraph-0205.tex — proof of first-polar-line/secant-degree proposition

- Job: Compute the lower catalecticant along the explicit polar line, derive its cubic secant determinant by Cauchy–Binet, and identify identically vanishing determinant with the upper quadratic-gcd/rank-two carrier.
- First-pass accessibility: Yes. The matrices make the degree-three bound and contained-case equivalence concrete.
- Friction: None in this proof beyond the marker-coordinate symbol collision already noted in the proposition.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-18 / paragraph-0206.tex — Proposition “Complete lower trivial-gcd carrier” (`prop:r6-lower-carrier`)

- Source metadata: `coverage{absent}`.
- Job: Classify all trivial-gcd R5 lower pencils by monodromy/characteristic, giving explicit syndrome loci for every case where the geometrically integral \(S_3\) fiber-square argument is unavailable.
- First-pass accessibility: Minor friction. The four alternatives are explicit, but two geometric symbols and the repeated “package” terminology are not unpacked.
- Friction: “the \(S_3\) package” should mean the full-monodromy genus-one point-count argument, but that is not stated. \(C_4\) is not identified here as the quartic normal rational curve, and the role of \(\operatorname{Join}(e_2,C_4)\) as the closure of wild pencils plus nucleus is only partially glossed. The diagonal rescaling in (ii) is correct-looking but a reader would benefit from being reminded that it converts ordinary quartic-square coefficients to divided-power syndrome coordinates.
- Smallest high-value repair: Replace “package” by “geometrically integral \(S_3\) fiber-square case,” define \(C_4\), and add the divided-power rescaling gloss after (ii).
- Finding: MINOR.
### packet-18 / paragraph-0207.tex — proof of complete lower trivial-gcd carrier (tame cases)

- Job: Derive the \(S_3\) case from two-transitive monodromy and compute the tame cyclic syndrome locus as the divided-power image of squared binary quadratics.
- First-pass accessibility: Yes. The monodromy dichotomy and coordinate-rescaling origin are clearly stated.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-18 / paragraph-0208.tex — proof of complete lower trivial-gcd carrier (small-characteristic cases)

- Job: Compute the characteristic-two orbit closure as a plane, identify the characteristic-three wild cyclic closure as the join of the fixed nucleus and quartic curve, place the inseparable all-cube pencil at its vertex, and conclude exhaustiveness.
- First-pass accessibility: Yes. The explicit binary action formula and ternary orbit-closure geometry make both modular loci concrete.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-18 / paragraph-0209.tex — Proposition “Cyclic and collision degrees” (`prop:r6-degrees`)

- Source metadata: `coverage{absent}`.
- Job: Supply the fixed R6 geometric degrees needed for stagewise escape: the tame cyclic carrier degree/no-line property, a proper ramification divisor bound, and the total terminal deletion budget after marking a root.
- First-pass accessibility: Major friction. The numerical bounds are stated, but the schemes/conditions they measure are not defined in the proposition.
- Friction: “pointed ramification condition” does not specify the map, equation, or parameter space; “does not vanish identically” presumably means it is a proper divisor on the marker line. “an \(S_3\) lower pencil with the marked root deleted” conflates a pencil with a splitting/fiber-square curve, and “total deletion degree at most nineteen” does not list the branch, diagonal, collision, old-marker, or other contributions summed to \(19\). The connection between (i)'s no-polar-line result and the contained-component classification is unstated.
- Smallest high-value repair: State all three items on named spaces and add a deletion-budget table whose rows sum to \(19\). Say explicitly that (i) prevents a trivial-gcd upper polar line from being wholly trapped in the tame cyclic carrier.
- Finding: MAJOR.
### packet-18 / paragraph-0210.tex — proof of cyclic/collision-degree proposition (items i–ii)

- Job: Establish the tame cyclic surface's degree/no-line property and prove the degree-six collision bound in every characteristic by excluding the only binary inseparable net via the Hankel equations.
- First-pass accessibility: Yes. The exceptional characteristic-three routing and the binary contradiction are explicit.
- Friction: None requiring repair.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-18 / paragraph-0211.tex — proof of cyclic/collision-degree proposition (item iii)

- Job: Assemble the terminal R5 curve deletion budget \(13+6=19\), record the genus/correction parameters, derive the rational-point escape inequality, and identify the first prime-power field gate \(29\).
- First-pass accessibility: Minor friction. The marker contribution and final arithmetic are clear, but the base deletion degree thirteen is asserted rather than decomposed.
- Friction: The reader has seen a branch budget of at most twelve, but “off-diagonal curve has deletion degree thirteen, including its possible rational singular point” does not explicitly say whether this is \(12\) branch/ramification points plus one singular point or includes diagonal/collision terms differently. Since \(19\) drives the R6 gate, its provenance should be auditable in place.
- Smallest high-value repair: Display the budget as a short sum with labels, e.g. “ramification/collision \(\le12\) + singular normalization correction \(\le1\) + marked-root ordered pairs \(\le6\) = 19.”
- Finding: MINOR.
### packet-18 / paragraph-0212.tex — Proposition “Modular contained components” (`prop:r6-modular`)

- Source metadata: `coverage{fragment}`; Lean item `PRSPolarInduction.mem_modularContractionKernel_iff`.
- Job: Determine whether R6 trivial-gcd polar lines can be wholly trapped in the characteristic-three wild cone or characteristic-two cyclic plane, ruling out the former and identifying the unique binary upper component in the latter.
- First-pass accessibility: Yes. Both lower carriers and the sole contained upper component are displayed explicitly.
- Friction: None at the statement level.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-18 / paragraph-0213.tex — proof of modular contained-components proposition (characteristic three)

- Job: Reduce containment in a wild-cone ruling by equivariance to one coordinate frame and show the overlapping Hankel rows force the upper syndrome onto the normal rational curve, contradicting trivial gcd.
- First-pass accessibility: Yes. The ruling geometry and coordinate conclusion are concise.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-18 / paragraph-0214.tex — proof of modular contained-components proposition (characteristic two)

- Job: Compute the binary cyclic plane and solve the two overlapping row-containment conditions exactly, yielding the unique upper line \(\mathcal N_3\).
- First-pass accessibility: Yes. The coordinate equations prove existence and uniqueness transparently.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-18 / paragraph-0215.tex — Proposition “Binary nucleus arithmetic” (`prop:r6-nucleus`)

- Source metadata: `coverage{absent}`.
- Job: Classify the rational points of the unique binary contained component as one semilinear orbit and give the exact extension-degree parity criterion for split-freeness.
- First-pass accessibility: Yes. The orbit size and arithmetic iff are explicit.
- Friction: None requiring repair at the statement level; the acting projective-semilinear group is inferable from the manuscript's standing symmetry.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-18 / paragraph-0216.tex — proof of binary nucleus arithmetic

- Job: Analyze the representative witness net by an additive root-difference polynomial, derive the even-extension-degree criterion for a four-root member, and compute the semilinear orbit size from the Borel stabilizer.
- First-pass accessibility: Yes. The root criterion, divisibility condition, parity translation, and orbit–stabilizer count are all explicit.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
## packet-18 note

- Current mental model: The R6 first-polar line is explicitly controlled by a cubic lower secant determinant; identically vanishing determinant is exactly the upper quadratic-gcd/rank-two carrier. For a trivial-gcd upper net, every lower R5 pencil is either full \(S_3\) with geometrically integral fiber square or lies in one explicit cyclic/inseparable carrier: a degree-four rescaled Veronese surface in tame characteristic, a binary plane, or a ternary wild cone \(\operatorname{Join}(e_2,C_4)\). The tame surface contains no polar line, and a trivial-gcd polar line cannot lie in the ternary cone. In characteristic two, exactly the upper line \(\mathcal N_3=\mathbb P\langle e_2,e_3\rangle\) has its polar line contained in the cyclic plane. Its \(q+1\) rational points form one semilinear orbit and are split-free precisely over \(\mathbb F_{2^m}\) with odd \(m\). Outside contained cases, the R6 stage uses a collision bound six and a terminal genus-one deletion budget \(19\), leading to the first analytic prime-power gate \(q=29\).
- Questions carried forward: How are the remaining fields \(7\le q<29\) closed and which five R6 sporadic rows occur? How does the R6 radius gate promote split-free directions to deep holes over every \(q\ge7\)? Can the deletion budget \(19\) be itemized explicitly from branch, singular, marker, diagonal, and collision contributions? What is the exact group action/normal form behind the characteristic-five persistent orbit splitting?
- Top accessibility issue so far: The modular contained-component geometry is concrete and easy to follow. The main weak point is the proposition that states degree/deletion budgets without naming their parameter spaces or itemizing the sum to \(19\); a small budget table would make the later field gate auditable and connect the abstract lower-package interface to this R6 instance.
### packet-19 / paragraph-0217.tex — Proposition “Exhaustive R6 contained-component classification” (`prop:r6-contained`)

- Source metadata: `coverage{absent}`.
- Job: Assemble all earlier R6 component lemmas into a genuinely exhaustive contained-case list and conclude that only the persistent rank-two locus and binary nucleus line can be nonshallow contained components.
- First-pass accessibility: Minor friction. The five-case list is excellent and resolves the prior abstraction, but one excluded stratum is still described by package shorthand.
- Friction: “the separate quadratic-graph package” is not a defined object and Proposition `prop:r5-gcd1` is more concretely the base-point-free quadratic-pencil/deck-involution argument showing exact linear gcd is shallow. Calling it a “lower stratum” also leaves unclear whether the exclusion concerns a proper intersection of the polar line with that locus rather than whole-line containment.
- Smallest high-value repair: Replace the package sentence with “If a lower pencil has exact linear gcd, Proposition … constructs a split cubic directly; this is a proper-intersection/shallow case, not a contained upper component.”
- Finding: MINOR.
### packet-19 / paragraph-0218.tex — proof of exhaustive R6 contained-component classification

- Job: Audit the five exhaustive clauses against the earlier rank-two, tame cyclic, collision, modular, and complete lower-carrier propositions.
- First-pass accessibility: Yes. It explicitly explains why the component list is exhaustive rather than empirical.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-19 / paragraph-0219.tex — Proposition “R6 one-step exhaustion” (`prop:r6-one-step`)

- Source metadata: `coverage{conditional_deduction}`; Lean item `PRSRedundancySixSeven.redundancySixHighFieldSynthesis`.
- Job: State the high-field R6 split-free classification obtained from one-step polar escape: only the persistent quadratic-gcd locus and the odd-degree binary nucleus orbit survive.
- First-pass accessibility: Yes. The field gate and modular parity condition are explicit.
- Friction: None at the statement level.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-19 / paragraph-0220.tex — proof of R6 one-step exhaustion (gcd/contained reduction)

- Job: Dispatch the contained branch and positive-gcd strata, reducing the high-field proof to trivial-gcd nets outside the known contained components.
- First-pass accessibility: Yes. The gcd trichotomy and status of each case are succinct.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-19 / paragraph-0221.tex — proof of R6 one-step exhaustion (transverse marker budget)

- Job: Bound all bad first-marker parameters by pulling back the lower secant, cyclic/wild/modular, and collision loci, obtaining the explicit unavailable-marker degree \(3+4+6=13\).
- First-pass accessibility: Yes. Each summand is tied to a prior proposition and the contained binary exception is separated before summing.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-19 / paragraph-0222.tex — proof of R6 one-step exhaustion (bottom-pencil escape)

- Job: Handle the two remaining lower-pencil types with marked-root avoidance, show marker–fixed-gcd coincidence is already charged to collision, assemble the \(S_3\) curve budget \((g,\delta,\kappa)=(1,19,1)\), verify the threshold \(29\), and invoke the abstract one-step escape theorem.
- First-pass accessibility: Minor friction. The two cases and numerical logic are soundly exposed, but the paragraph is long and introduces two notations without setup.
- Friction: \(Z_f\) is used for the excluded marker scheme without definition, and \(\mathcal H_1(1,19)\) appears only at the threshold calculation without defining the general \(\mathcal H_g\) function. The affine marker is again called \(r\), colliding with redundancy. The exact-linear-gcd and \(S_3\) cases would be easier to audit as separate paragraphs, especially because the “eight original + two pointed” graph budget and the “thirteen + six” fiber-square budget are different mechanisms.
- Smallest high-value repair: Split into two labeled cases; rename the marker \(t\); define \(Z_f\) and \(\mathcal H_g(\kappa,\delta)\) before use or omit the latter notation and simply solve the displayed inequality.
- Finding: MINOR.
### packet-19 / paragraph-0223.tex — proof of R6 one-step exhaustion (modular residue)

- Job: Clarify that \(29\) is one field-order gate rather than separate characteristic estimates, identify the first binary/ternary prime powers covered, and apply the exact parity arithmetic on the contained binary nucleus.
- First-pass accessibility: Yes. The threshold interpretation and modular conclusion are explicit.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-19 / paragraph-0224.tex

- Job: Close the independent R6 radius gate analytically for \(q\ge8\), computationally for \(q=7\), and retain \(q=8\) as an independent certificate check.
- First-pass accessibility: Yes. The endpoint inequality and proof/certificate domains are exact.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-19 / paragraph-0225.tex — Theorem “Redundancy six” (`thm:r6`)

- Source metadata: `coverage{conditional_deduction}`; Lean items `PRSRedundancySixSeven.redundancySixAllFieldSynthesis`, `PRSRedundancySixSevenCertificate.redundancySix_count_exhaustion`, `PRSUniformCoveringRadius.SeroussiRothDuerRadiusInput.seroussiRothDimensionRange_six_eight`, `radiusRange_six_eight_of_externalSeroussiRothDuer`; uses `thm:r5`; evidence `certificate-r6`; proves `redundancy-six-classification`.
- Job: State the complete all-field R6 deep-hole classification, exceptional-orbit counts and totals, binary nucleus parity rule/no-double-counting convention, and persistent orbit refinement.
- First-pass accessibility: Major friction. The field-by-field totals are clear, but the exact exceptional classification and orbit law are not self-contained.
- Friction: Saying there are \(18,11,4,2,1\) exceptional orbits does not identify them; the statement depends on a later “exceptional table” without a reference/representative list. “The complete persistent orbit law is \(T/T^5\) modulo inversion and Frobenius” still omits the torus/fiber definitions from the theorem, and “a tangent fixed/nonzero split exactly in characteristic five” is not grammatical enough to determine the actual orbit decomposition. “deep syndromes” should explicitly mean projective syndrome directions, matching the totals.
- Smallest high-value repair: Place the exceptional representative table immediately after the theorem and reference it here; move the orbit law to a defined corollary or give a compact fiber/stabilizer dictionary; rewrite the characteristic-five clause as an explicit count/partition of tangent-fiber orbits. State “projective deep-hole syndrome directions.”
- Finding: MAJOR.
### packet-19 / paragraph-0226.tex — proof of redundancy-six theorem

- Job: Join analytic exhaustion above \(q=29\), exhaustive certificate coverage of every smaller prime power in scope, and the independent radius gate to prove the all-field classification.
- First-pass accessibility: Yes. The finite bridge list is complete and the five exceptional versus six no-exception certificate fields are explicit.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-19 / paragraph-0227.tex

- Job: Explain why the persistent, finite sporadic, and infinite binary-nucleus contributions do not overlap.
- First-pass accessibility: Yes. The gcd and field-range distinctions are simple and decisive.
- Friction: None.
- Smallest high-value repair: CLEAR.
- Finding: CLEAR.
### packet-19 / paragraph-0228.tex — Setup for the R6 exceptional tables

- Job: Define two invariants used to distinguish certified exceptional R6 nets—an aggregate lower-pencil irreducible-member pair count and, in odd characteristic, a quintic factorization type—then state semilinear orbit totals and preview the representative table.
- First-pass accessibility: Minor friction. The invariants are mostly explicit, but field indexing and one name are ambiguous.
- Friction: The semilinear counts \(18,5,2,2,1\) are not explicitly matched to \(q=7,8,9,11,13\), and their difference from the preceding projective orbit counts \(18,11,4,2,1\) must be inferred as Frobenius fusion. The marker parameter is again \(r\), conflicting with redundancy. Calling \(E_f\) a “shared-root pair count” is not immediately explained by \(\binom{I_f(t)}2\), which counts pairs of irreducible cubic members in the same quotient pencil rather than visibly shared roots.
- Smallest high-value repair: Give a two-row table of projective versus semilinear orbit counts by field, rename the marker \(t\), and add one clause explaining the geometric interpretation of \(E_f\) or rename it “same-marker irreducible-member pair count.”
- Finding: MINOR.
## packet-19 note

- Current mental model: The R6 contained-component analysis is now explicitly exhaustive: noninjective contraction is shallow rank one; lower secant containment is exactly the upper rank-two carrier; tame cyclic and ternary wild carriers contain no trivial-gcd polar line; the binary cyclic plane contains exactly the nucleus line \(\mathcal N_3\); and universal collision adds nothing else. Outside those cases, the unavailable first-marker scheme has degree \(3+4+6=13\). A surviving lower pencil has either exact linear gcd, handled by a pointed deck-graph argument, or \(S_3\) monodromy, handled by a genus-one curve with total deletion degree \(19\); the inequality \(q+1-2\sqrt q>19\) begins at prime-power order \(29\). Certificate R6 exhausts every smaller prime power \(7\le q<29\). The independent radius gate gives radius five for all \(q\ge7\). Thus R6 deep directions are the persistent tangent/conjugate locus, finite exceptional trivial-gcd orbits at \(q=7,8,9,11,13\), and one \(q+1\)-point binary nucleus orbit for odd extension degree \(m\ge5\), with the \(q=8\) nucleus already included in the finite table.
- Questions carried forward: What are the canonical representatives and finite-field encodings in the five R6 exceptional tables? How do the invariants \(E_f\) and \(\tau_5(f)\) distinguish PGL orbits and explain Frobenius fusion? What exactly is the characteristic-five tangent orbit split in the persistent law? How will the R7 stage build on these R6 lower packages, and what new modular central nucleus appears?
- Top accessibility issue so far: The proof of R6 exhaustion is now quite readable and its \(13\)/\(19\)/\(29\) budgets are mostly auditable. The headline theorem remains less accessible than its proof because the exceptional orbits and persistent orbit law are deferred/undefined; putting the representative table adjacent to the theorem and separating the orbit refinement would fix that.

### packet-20 / paragraph-0229.tex
- **Job:** Insert the exceptional-radius-six table that the preceding discussion promised.
- **First-pass accessibility:** No: this paragraph is only an `\\input` directive, so the table, its caption, and its notation are not visible to this cold reader.
- **Friction:** Missing content/context. I cannot tell whether the promised orbit representatives, field encodings, stabilizers, or count conventions are explained, nor can I assess the table's legibility or significance.
- **Smallest high-value repair:** Ensure the reader-facing/extracted text expands this input (or place a one-sentence prose summary immediately around it that states what the table certifies and how to read its columns).
- **Finding:** MAJOR.

### packet-20 / paragraph-0230.tex
- **Job:** Mark the transition from the completed redundancy-six analysis to redundancy seven.
- **First-pass accessibility:** Yes.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-20 / paragraph-0231.tex
- **Job:** Set up the redundancy-seven Hankel kernel, its marker contraction, and the exact criterion for lifting a squarefree quintic from the contracted system.
- **First-pass accessibility:** Yes; the formulas make the dimensional shift and the role of the nonvanishing condition explicit.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-20 / paragraph-0232.tex
- **Job:** Bound the exceptional marker parameters for which the contracted quintic net has a quadratic fixed factor, separating a generic degree-three intersection from a contained-line case.
- **First-pass accessibility:** Mostly, but the geometric translation is compressed.
- **Friction:** Disciplinary-language jump and slightly hidden significance: “first-polar line” is not identified here with the just-defined family (r\mapsto b(r)), and the paragraph does not say explicitly that a quadratic gcd is what makes a marker unusable in the recursive argument.
- **Smallest high-value repair:** Write “the first-polar line (\{[b(r)]\})” and add a short clause calling these the bad-marker parameters.
- **Finding:** MINOR.

### packet-20 / paragraph-0233.tex (Proposition `prop:r7-pointed`, “Complete two-marker lower package”)
- **Job:** Supply the pointed redundancy-five input needed after two recursive marker choices: a trivial-gcd quartic net has a split squarefree member avoiding one specified root, uniformly for (q\ge 37), apart from the named characteristic-two nucleus stratum.
- **First-pass accessibility:** Yes; despite the package-style title, the mathematical statement and exception are direct.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-20 / paragraph-0234.tex (proof of `prop:r7-pointed`, “Choosing the second marker”)
- **Job:** Show that all forbidden second markers lie in a parameter scheme of degree at most (16), including the new condition that the contracted pencil not acquire the prescribed root (x) as a fixed factor; then choose a rational marker outside it.
- **First-pass accessibility:** Mostly. The new determinantal argument is intelligible, but the opening exclusion count is dense on a first pass.
- **Friction:** Sentence overload and disciplinary-language stacking: one long sentence moves through the lower secant cubic, cyclic/wild surface, collision divisor, and several degree bounds before explaining the combined count. A reader must reconstruct which failure each named locus represents.
- **Smallest high-value repair:** Display the exclusions as a compact condition / degree bound / cited result list before summing (1+3+4+6+2).
- **Finding:** MINOR.

### packet-20 / paragraph-0235.tex (proof of `prop:r7-pointed`, “The linear-gcd branch”)
- **Job:** Handle the branch where the lower cubic pencil has an exact linear gcd, showing that the old graph construction still has a squarefree member after also avoiding the two chosen markers.
- **First-pass accessibility:** Mostly, but only if the reader retains the internal mechanics of the earlier graph proof.
- **Friction:** Hidden logical relation: “eight original deletions” and “two graph points each” import proof-level bookkeeping without reminding the reader what the graph parameterizes or why a forbidden root costs at most two points.
- **Smallest high-value repair:** Add one sentence recalling that the graph parametrizes candidate cubics by (\PP^1) and that imposing vanishing at either marker cuts at most two parameter points.
- **Finding:** MINOR.

### packet-20 / paragraph-0236.tex (proof of `prop:r7-pointed`, “The (S_3) branch”)
- **Job:** Apply the genus-one point bound to the remaining monodromy branch, subtract all bad points (including those meeting the two markers), derive the threshold (q=37), and complete the lift.
- **First-pass accessibility:** Yes. The deletion total (13+6+6=25), the Hasse--Weil inequality, and the final lifting conclusion form a visible chain.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-20 / paragraph-0237.tex (Proposition `prop:r7-gcd1`, “Exact-gcd-one avoidance”)
- **Job:** Treat lower nets with an exact linear common factor by reducing the desired avoidance to finding a split cubic in the residual three-dimensional system (U).
- **First-pass accessibility:** Mostly.
- **Friction:** Unclear referent and significance: “the parameter belongs to the collision divisor” does not say explicitly that the parameter is the current marker (r), or that this case has therefore already been removed from consideration.
- **Smallest high-value repair:** Replace that sentence by “If the common root (x) equals the current marker (r), then (r) lies on the collision divisor and was already excluded.”
- **Finding:** MINOR.

### packet-20 / paragraph-0238.tex (proof of `prop:r7-gcd1`)
- **Job:** Count ordered pairs of two prospective roots and show that, for (q\ge16), some pair determines a third root that is distinct from both and avoids the two forbidden points.
- **First-pass accessibility:** Mostly; the bidegree count is concrete and the numerical comparison is easy to follow.
- **Friction:** The proof stops immediately after the inequality, leaving the final inference implicit: a pair outside the four bad divisors gives three distinct rational roots (u,v,w), with none equal to (x) or (r), and its cubic lies in (U).
- **Smallest high-value repair:** Add precisely that concluding sentence after the inequality.
- **Finding:** MINOR.

### packet-20 / paragraph-0239.tex (Proposition `prop:r7-collision`, “Collision divisor”)
- **Job:** State the degree bound for marker collisions in the moving quintic linear system, which is used in the redundancy-seven bad-marker count.
- **First-pass accessibility:** Only with the earlier algebraic-geometric terminology in active memory.
- **Friction:** Disciplinary-language jump: the bare notation “moving (g^3_5)” and “collision divisor” do not tell a coding-theory reader what is varying, on which parameter line the divisor lives, or which repeated-root event it records.
- **Smallest high-value repair:** Add a parenthetical gloss: a (g^3_5) is the projective three-dimensional linear system of degree-five forms after removing its fixed factor, and the divisor records markers at which the lifted form repeats the marker root.
- **Finding:** MINOR.

### packet-20 / paragraph-0240.tex (proof of `prop:r7-collision`)
- **Job:** Derive the degree-eight collision bound by specializing the previously proved uniform collision lemma to redundancy seven.
- **First-pass accessibility:** Yes; this is an intentionally short specialization, and the arithmetic (2\cdot7-6=8) is explicit.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### Packet 20 note
- **Current mental model:** The manuscript has moved to redundancy seven. One marker contracts the quintic web to a quintic net; a second marker reduces to the already classified quartic-net/cubic-pencil problem. The proof builds a complete bad-marker budget (degree (16)), handles exact-linear-gcd systems by a direct bidegree count, and handles the (S_3) branch by a genus-one point estimate, producing the uniform threshold (q\ge37). Collision parameters are controlled uniformly by a degree-eight divisor.
- **Questions carried forward:** How will the contained first-polar-line cases be classified at redundancy seven? Will the promised exceptional small fields be enumerated, and will their finite-field encodings and orbit/count conventions be made explicit? How does the exact-gcd-one proposition feed into the full redundancy-seven carrier alongside the pointed lower package?
- **Top accessibility issue so far:** The proof's logic is soundly signposted at the branch level, but its bad-locus bookkeeping is expressed in dense internal geometry vocabulary; a compact dictionary/table linking each named locus to the concrete marker failure it encodes would make the recursion much easier to audit. Separately, the exceptional-table input in paragraph 0229 was not expanded in the review packet, so its accessibility could not be assessed.

### packet-21 / paragraph-0241.tex
- **Job:** Resolve the characteristic-two nucleus-line lift at redundancy seven: identify its unique coherent lift, state when its quintic web is split-free, and exhibit a split member in even extension degree.
- **First-pass accessibility:** Mostly, but the even/odd dichotomy is not fully unpacked.
- **Friction:** Hidden logical relation and internal terminology: (m) is not locally tied to (q=2^m), “the separate radius-six gate” is opaque, and the paragraph leaves the reader to infer that (\mathbb F_4\subseteq\mathbb F_{2^m}) exactly for even (m), so the displayed polynomial then gives a split squarefree quintic and destroys split-freeness.
- **Smallest high-value repair:** State (q=2^m), replace “gate” by the precise radius-six hypothesis, and add the one-sentence inference from the five (\mathbb F_4)-roots.
- **Finding:** MINOR.

### packet-21 / paragraph-0242.tex (Proposition `prop:r7-central`, “Central binary lift”)
- **Job:** Package the preceding characteristic-two observation as an exact classification: the nucleus line has the single projective lift ([e_3]), split-free precisely for odd extension degree.
- **First-pass accessibility:** Yes, given the immediately preceding explanation.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-21 / paragraph-0243.tex (proof of `prop:r7-central`)
- **Job:** Prove uniqueness of the central lift by coefficient elimination, then prove the parity criterion by contraction for odd (m) and by an explicit five-root polynomial for even (m).
- **First-pass accessibility:** Yes; both directions are short and concrete, and the role of the point at infinity is stated.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-21 / paragraph-0244.tex (Corollary `cor:r7-contained`, “Exhaustive R7 contained-component classification”)
- **Job:** Close the contained-first-polar-line case at redundancy seven by classifying every possible source of containment and concluding that only the persistent families and the characteristic-two central point survive nonshallowly.
- **First-pass accessibility:** No. This is a key exhaustiveness statement, but almost every step is expressed in the manuscript's internal stratum vocabulary.
- **Friction:** Disciplinary-language jump and hidden logical relations: (\mathrm{CC}(6,1)), noninjective contraction, lower persistent locus, upper catalecticant, shallow rank-one boundary, and persistent tangent/conjugate-secant families are chained without a local dictionary or citations. In particular, it is not explained why a nonzero collision divisor rules out every remaining contained component.
- **Smallest high-value repair:** Precede the conclusion with a short case list (failure mode, earlier result used, resulting family) and explicitly say that containment in the collision locus would force its pullback polynomial to vanish identically, which nonzeroness excludes.
- **Finding:** MAJOR.

### packet-21 / paragraph-0245.tex (proof of `cor:r7-contained`)
- **Job:** Justify exhaustiveness by matching the three quadratic-recurrence types, the binary nucleus lift, and the collision alternative to the cases in the earlier contained-line definition.
- **First-pass accessibility:** Yes. Unlike the compressed corollary statement, this proof supplies the governing proposition, names the three recurrence types, and maps each to a geometric family.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-21 / paragraph-0246.tex (Theorem `thm:r7`, “Redundancy-seven classification”)
- **Job:** State the complete split-free classification for redundancy seven, list all small-field exceptional orbit profiles, identify the range where split-free directions are exactly deep holes, resolve (q=8) separately, and record the persistent-family orbit law.
- **First-pass accessibility:** No; the main result is present, but several distinct classifications and computational-status qualifications are compressed into one theorem.
- **Friction:** Sentence/concept overload plus undefined conventions. The notation (168^{45}) is not explained as an orbit-size multiplicity; “Certificate R7,” “frozen representatives,” and “not promoted” are verification jargon; the switch from split-free syndromes to distance-six/seven rows requires the reader to reconstruct the covering-radius logic; and the orbit law (T/T^6) does not define (T), inversion, Frobenius, or what “tangent splitting” does to the orbit list.
- **Smallest high-value repair:** Split the display into (i) split-free classification, with a sentence defining the profile notation, and (ii) a deep-hole consequence by covering radius; then add a short explicit (q=8) paragraph and define the set/action in the orbit law rather than naming only the quotient.
- **Finding:** MAJOR.

### packet-21 / paragraph-0247.tex (proof of `thm:r7`)
- **Job:** Count the persistent locus, invoke the two-marker induction for (q\ge37), use the contained-component classification, and bridge every remaining field by two computational enumerations before applying the covering-radius theorem.
- **First-pass accessibility:** The symbolic count and large-field argument are followable; the finite-field completion is not accessible to a reader outside the certificate implementation.
- **Friction:** Formal/computational-interface jump. Terms such as “exact primary quotient enumeration,” “replay,” “public record,” “R7 generator,” “quotient partition,” “literal four-secant complement,” and “transient marked orbit” arrive without specifying the enumerated objects, the completeness invariant, or what the independent replay shares with the first computation. Package phrases such as “complete second one-step package” and “depth-two data” further obscure the mathematical dependency chain.
- **Smallest high-value repair:** Insert a plain-language certificate lemma or audit paragraph stating the finite search space, canonical quotient/orbit reduction, completeness check, independently recomputed data, and exact output compared; then cite that lemma here and present the induction dependencies as a short ordered list.
- **Finding:** MAJOR.

### packet-21 / paragraph-0248.tex
- **Job:** Explain what data the finite-field certificate records, decode the theorem's compressed orbit-size profiles, point to the exhaustive human- and machine-readable lists, and provide sample syndrome representatives for every size block.
- **First-pass accessibility:** Yes. It explicitly distinguishes an orbit-size summary from the canonical per-orbit records and identifies the coordinate encoding for extension fields.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-21 / paragraph-0249.tex
- **Job:** Give a concrete (q=19) example showing why the lower system must be classified together with its marked point: a system bad for one marker can be usable for another, and the apparently bad pointed orbit does not lift coherently.
- **First-pass accessibility:** Yes. The explicit list of split members makes the distinction between an intrinsic obstruction and a marker-dependent obstruction tangible.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-21 / paragraph-0250.tex (Table `tab:field-ranges`, “Field-range closure ledger”)
- **Job:** Summarize, for redundancies five through seven, exactly which prime-power ranges are covered by direct computation, finite bridge certificates, characteristic-specific arguments, or uniform geometry.
- **First-pass accessibility:** Yes. The table makes the otherwise scattered small-field/large-field handoff easy to audit, and its caption defines the strength of “Certificate.”
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-21 / paragraph-0251.tex
- **Job:** Prevent two likely overreadings of the ledger: R7 computational rows concern split-free syndromes rather than automatically deep holes, and an orbit-size profile is not a unique orbit identifier.
- **First-pass accessibility:** Yes; this is a useful scope warning placed directly after the summary table.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-21 / paragraph-0252.tex
- **Job:** Verify explicitly that the finite certificate ranges and the uniform geometric ranges in the ledger cover every prime power, despite apparent numerical gaps.
- **First-pass accessibility:** Yes; it closes a natural bookkeeping question in one sentence.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### Packet 21 note
- **Current mental model:** Redundancy seven is now classified completely at the level of split-free syndrome directions. The large-field proof uses two marked contractions, a degree-bounded bad-marker set, and the genus-one terminal cover; contained polar lines contribute only the persistent tangent/conjugate-secant families and, in characteristic two with odd extension degree, the unique central point (e_3). Finite certificates fill all smaller prime-power gaps. The split-free list becomes a deep-hole classification when an independent covering-radius theorem is available, with (q=8) handled separately.
- **Questions carried forward:** Will the manuscript now synthesize the R5--R7 results into a reader-facing main theorem? Will it define the persistent orbit quotient (T/T^6) and explain the characteristic-two/three tangent splitting? Will the computational certificate interface be summarized mathematically enough that a reader can understand completeness without consulting implementation records?
- **Top accessibility issue so far:** The headline R7 theorem and its proof mix geometric classification, covering-radius promotion, orbit bookkeeping, and computational verification in one dense block. The later example and field-range ledger are excellent aids, but the finite-certificate proof still needs a plain-language specification of what is enumerated and why the enumeration is exhaustive.

### packet-22 / paragraph-0253.tex
- **Job:** Open a section that separates the mathematical argument from its computational and formal-verification evidence.
- **First-pass accessibility:** Yes.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-22 / paragraph-0254.tex
- **Job:** State exactly what Lean does and does not verify, preventing the formal annotations from being mistaken for a formalization of the geometric classification itself.
- **First-pass accessibility:** Yes; the boundary between checked identities/implications and assumed mathematical inputs is unusually explicit.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-22 / paragraph-0255.tex
- **Job:** Explain how claims that depend on computation are linked to reproducible public artifacts and direct the reader to the evidence table and mathematical results map.
- **First-pass accessibility:** Yes; it gives both the artifact chain and the place to find the mathematical interpretation.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-22 / paragraph-0256.tex (Table `tab:evidence`, “Public verification map”)
- **Job:** Inventory each computational certificate, the fields or identities it verifies, the available replay, and—crucially—which code or mathematical inputs are shared rather than independently reimplemented.
- **First-pass accessibility:** Mostly. The independence qualifications are admirably candid, but some audit vocabulary remains implementation-specific.
- **Friction:** Formal/computational-language jump: “primary quotient enumeration,” “direct-locus engine,” “field layer,” and “kernel checked” are not glossed, and the public label “SC” is not expanded in the table. A non-specialist can rank the evidence only approximately.
- **Smallest high-value repair:** Add a two-sentence legend expanding SC and defining “replay,” “second implementation,” and “kernel checked,” with a pointer to the supplement for the algorithms.
- **Finding:** MINOR.

### packet-22 / paragraph-0257.tex
- **Job:** Establish provenance for the printed R6 exceptional table and state that it is regenerated and compared exactly against the checked-in source.
- **First-pass accessibility:** Yes; “byte-for-byte equality” makes the reproducibility claim concrete.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-22 / paragraph-0258.tex
- **Job:** Give the concrete entry points for understanding the certificate schema and reproducing integrity checks or the paper-local computations.
- **First-pass accessibility:** Yes; filenames and the `--replay` distinction make the workflow actionable without overloading the prose.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-22 / paragraph-0259.tex
- **Job:** Point to the exact Lean audit, enumerate the interfaces checked versus assumed, and delimit the significance of the formally checked (q=8) record for the quantum-code application.
- **First-pass accessibility:** Yes. The checked/input boundary is repeated at a useful level of specificity, and the absence of a quantum consequence is tied to a cited mathematical obstruction.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-22 / paragraph-0260.tex
- **Job:** Mark the transition from verification scope to artifact provenance and disclosure.
- **First-pass accessibility:** Yes.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-22 / paragraph-0261.tex
- **Job:** Inventory the supplement, state its role in assigning trust routes, and distinguish the submission artifact from the eventual archived release with persistent identifiers.
- **First-pass accessibility:** Yes; the current and future provenance states are clearly separated.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### packet-22 / paragraph-0262.tex
- **Job:** Describe the executable toolkit command by command, including outputs, witnesses, search budgets, theorem-registry scope, fail-closed statuses, and the exact trust required for positive classification and minimality claims.
- **First-pass accessibility:** Mostly. The individual guarantees are careful, but five interfaces and several distinct trust boundaries are packed into one long paragraph.
- **Friction:** Sentence overload: `canonicalize`, `distance`, `decode`, `simultaneous-locator`, `classify`, and `verify` each have different domains, outputs, and evidentiary force, so the crucial distinction between reconstructed witnesses, trusted search minimality, and cited covering radius is hard to retain linearly.
- **Smallest high-value repair:** Replace the command catalogue with a compact command / output / guarantee / remaining trust table, followed by the two sentences delimiting R5--R7 from companion R8--R10 claims.
- **Finding:** MINOR.

### packet-22 / paragraph-0263.tex
- **Job:** Prevent the toolkit's extra capabilities from being mistaken for stronger paper theorems, explain what the search budget controls, and delimit the sole certified higher-redundancy family from a complete higher-redundancy classification.
- **First-pass accessibility:** Yes; the distinction between software reach, a certified family, and an exhaustive theorem is explicit.
- **Friction / repair:** CLEAR.
- **Finding:** CLEAR.

### Packet 22 note
- **Current mental model:** The final section makes the paper's layered evidence architecture explicit. The geometric classifications are conventional mathematical arguments; deterministic certificates close finite fields and record representatives/orbits; Lean checks coordinate and conditional-synthesis interfaces while taking the geometry, point-existence inputs, group actions, and certificate semantics as hypotheses; and the executable toolkit exposes replayable witnesses without silently extending the theorem registry. The supplement and manifests provide the provenance chain.
- **Questions carried forward:** None about the claimed formal boundary: this packet answers that unusually well. The remaining reader questions are mathematical/expository—chiefly the exact meaning of the persistent orbit quotients and a compact global dictionary for the carrier/marker strata—not questions about which parts Lean or the certificates prove.
- **Top accessibility issue so far:** The verification section itself is strong. Its only notable burden is interface density: the evidence table and especially the toolkit paragraph would be faster to absorb with short legends or command/guarantee/trust tables.

## Whole-paper first-pass synthesis

### Mental model at the end
The paper turns high-weight-coset questions for projective/generalized Reed--Solomon codes into a finite-geometric problem about binary forms. A projective syndrome (f\in\PP(\Gamma^{r-1}E)) determines a Hankel/catalecticant kernel (W_f\subset\Sym^{r-2}E^\vee). A split squarefree member of (W_f) is a short locator/error representation; consequently a split-free syndrome has distance at least the target value, and becomes a deep-hole direction only after a separate covering-radius theorem supplies the matching upper bound.

The uniform classification is recursive. Choosing a rational marker (r) contracts (f) to (b(r)), and a split member of the lower system lifts provided it avoids the marker. Most markers work. The proof bounds the exceptional marker scheme using catalecticant/secant intersections, fixed-factor conditions, collision divisors, and characteristic-dependent cyclic or wild loci. If a whole first-polar line is trapped in an exceptional locus, a separate contained-component classification shows that only persistent rank-two families (tangent and conjugate-secant types, after shallow rational secants are removed) and a small binary nucleus phenomenon survive. At the bottom, cubic pencils are handled either by elementary graph counts or by a geometrically integral genus-one off-diagonal cover with an explicit deletion budget and Hasse--Weil estimate.

For redundancies five, six, and seven, the geometric bounds cover all sufficiently large fields and deterministic finite certificates bridge the remaining prime powers. The persistent locus has a uniform count and orbit description; small fields contribute explicitly enumerated exceptional orbits. Finally, covering-radius results determine when the split-free lists are deep-hole classifications (with (q=8) requiring its own distance split). The formal/computational layer is evidence infrastructure, not a replacement for the geometry: Lean checks coordinate identities and conditional interfaces, certificates exhaust finite search spaces, replays check recorded representatives and orbits, and the supplement states shared code and trusted inputs.

### Where the model first became stable
The model first became stable in the middle structural development, roughly packets 6--8, once three facts had appeared together: the explicit syndrome-to-kernel construction (f\mapsto W_f), the equivalence between split squarefree kernel forms and short coset representatives, and the marker contraction/lifting identity. Before that point, the paper's secant geometry, catalecticants, and coding claims felt like parallel languages. After that bridge, the later persistent loci, carrier exclusions, terminal covers, and finite certificates could all be placed in one proof architecture, even when their local notation remained difficult.

### Five highest-value accessibility repairs (ranked by reader benefit per added word)
1. **Add a compact global dictionary immediately after the syndrome/kernel bridge.** In about 120--180 words, define “split-free,” “shallow,” “persistent,” “marker,” “first-polar line,” “carrier,” and “collision,” and state the single chain: split form (\leftrightarrow) short representation; split-free (+) radius equality (\Rightarrow) deep hole. This would eliminate the most repeated backtracking in the paper.
2. **Put a one-line status legend before every headline R5--R7 theorem.** Separate (a) geometric split-free classification, (b) finite-certificate completion, and (c) covering-radius promotion to deep holes. Define profile notation such as (168^{45}) and any quotient such as (T/T^k) at first use, including the acting inversion/Frobenius operations and tangent splitting. A few lines would prevent major overreadings of the main results.
3. **Reuse one “bad-marker ledger” in the recursive proofs.** Give columns for concrete failure, geometric locus, degree bound, and cited result. The R6/R7 prose repeatedly stacks secant, cyclic/wild, collision, fixed-factor, and nucleus exclusions in long sentences; one small table would make both the total degree and the induction logic auditable.
4. **State the finite-certificate contract in plain mathematical language before the first certificate-dependent theorem.** Name the enumerated universe, the canonical quotient/orbit reduction, the exhaustion invariant, what a replay recomputes, what code is shared, and how extension-field coordinates are encoded. The excellent final verification section arrives too late to support a cold reading of the earlier exceptional tables and proofs.
5. **Add two-sentence transition roadmaps at the main disciplinary interfaces.** Before the invariant-theoretic/cyclic-(S_3) analysis, the contained-component classifications, and the formal/computational records, say what new object is being introduced, which obstruction it detects, and exactly what output the main induction will consume. These tiny bridges would do more than expanding technical proofs.

### Recurring friction patterns
- Terms were often mathematically meaningful but locally untyped: a reader met “first-polar line,” “second catalecticant,” (g^d_n), (\mathrm{CC}(6,1)), nucleus strata, and quotients (T/T^k) without a quick reminder of the ambient space or role.
- The manuscript frequently named a locus before saying which concrete failure it encoded. The missing sentence was often simply “these are precisely the unusable markers because …”.
- Internal workflow nouns—“package,” “gate,” “carrier,” “bridge,” “replay,” “frozen representative,” and “promotion”—compressed real logical distinctions but made the prose sound like implementation documentation.
- Headline theorems sometimes combined classification, counts, orbit laws, exceptional fields, covering-radius consequences, and verification status in one block. Each ingredient was recoverable, but their logical scopes were not immediately separable.
- Proofs sometimes imported earlier proof-level bookkeeping (“eight deletions,” “two graph points,” a tuple ((g,\delta,\kappa))) rather than briefly restating the mathematical meaning of the numbers.
- Cross-characteristic replacements (cyclic versus wild, characteristic-two nucleus, characteristic-three tangent behavior) were precise once developed, but transitions rarely reminded the reader whether the change affected geometry, orbit splitting, point counts, or only notation.
- Computational tables needed explicit normalization: what is an orbit, what exponent means multiplicity, which semilinear group acts, how extension-field elements are encoded, and whether a row is split-free or already promoted to a deep hole.

### Material already exemplary and worth protecting
- The explicit contraction identities and lift conditions are excellent: formulas such as ((t-r)g\in W_f\iff g\in W_{b(r)}), followed immediately by the nonvanishing condition for squarefreeness, make the recursion concrete.
- The direct counting arguments are particularly readable when they expose their parameter space and bad divisors. The exact-gcd-one bidegree count and the genus-one calculation (q+1-2\sqrt q>\delta) show the reader exactly where thresholds come from.
- Concrete diagnostic examples should be preserved, especially the (q=19) marked lower net: it explains in a few lines why pointed rather than unpointed classification is logically necessary.
- The field-range closure ledger is an outstanding synthesis device. It shows that finite and geometric ranges meet and, with the subsequent no-prime-power observation, closes a bookkeeping gap that readers would otherwise have to check themselves.
- The central binary lift proof is a model short exceptional-characteristic argument: coefficient elimination, contraction for odd extension degree, and an explicit polynomial for even degree.
- The final “Verification and formal boundary” section is exemplary in candor. It clearly denies formalization claims not earned, identifies hypotheses retained as inputs, distinguishes replay from independent implementation, exposes fail-closed behavior, and keeps broader software capabilities from enlarging the theorem.

### Overall verdict
For a mathematically mature coding-theory reader who is not simultaneously fluent in finite geometry, algebraic geometry, invariant theory, and computational/formal verification, the paper is **followable in its broad strategy and convincing in its evidence architecture, but not yet reliably readable straight through at the level of theorem dependencies on a first pass**. The core bridge from syndromes to split forms is powerful, the recursive idea is coherent, and many local calculations are admirably explicit. The main obstacle is not inherent technical depth; it is the cumulative cost of locally unexplained stratum names, compressed scope changes, and proof/verification jargon.

The reader can finish with a sound mental model, but only after substantial backtracking, and the model stabilizes later than it should. The five repairs above are small relative to the manuscript and would materially change that experience: they would let a coding theorist treat the adjacent fields as well-specified interfaces rather than reconstructing those interfaces from scattered propositions. The strongest parts—the explicit identities, threshold counts, concrete examples, range ledger, and verification boundary—already demonstrate the right expository standard and should be used as the template for revision.
