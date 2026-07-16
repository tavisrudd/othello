# Clebsch Hexagon Code: Cold Prose Read

Date: 2026-07-15

## 1. Overall cold-read verdict

The manuscript has a strong, intelligible mathematical spine: arc–coset dictionary → Clebsch example → rigidity → decoding/chirality → uniqueness of \(q=11\). The central claims are memorable, the main proof is surprisingly short once reached, and the numerical statements are unusually concrete.

As exposition, however, the draft is carrying three papers at once:

1. a finite-geometry/coding-theory narrative;
2. a priority and literature-positioning memorandum;
3. a verification dossier.

Those layers repeatedly interrupt one another. The largest problem is not sentence-level opacity but hierarchy: important ideas, provenance defenses, implementation notes, ancillary classifications, and exact histograms are often given the same rhetorical weight. A cold reader consequently spends too long deciding what must be retained.

My verdict is “strong paper, substantial editorial revision needed.” The mathematical story is publishably compelling, but the current version feels denser and more defensive than it needs to be. A focused reorganization could materially improve it without sacrificing results.

## 2. Strongest exposition features

- **The abstract is admirably concrete.** It states the classification, distinguishes the non-GRS code, gives all main counts, previews chirality and \(q=11\), and closes with a clean novelty statement. The progression from theorem to code data to broader boundary is effective. Section/anchor: abstract, PDF p. 1, TeX lines 39–61.

- **The initial syndrome setup is economical and reader-oriented.** The definitions of \(w(s)\), deep holes, syndrome cosets, and the projectivized locus arrive in the right order, with the scaling consequence immediately explained. Section 1, PDF p. 1, lines 74–90.

- **The plane arc–coset dictionary is the manuscript’s best conceptual bridge.** “Weights one, two, or three according as…” gives the coding reader a geometric picture and the geometry reader a coding interpretation. Section 1, pp. 1–2, lines 92–112.

- **The paper’s object and main theorem are described lucidly once they appear.** “A single, small, and highly symmetric exception” is an effective entry point, followed by a compact statement of what the theorem reconstructs and which ingredients are conceptual versus enumerative. Section 1, p. 2, lines 128–152.

- **Remark 4.1 prevents the manuscript’s most likely misunderstanding.** The contrast between “\(U(A)\) lies on a conic” and “\(A\) lies on a conic” is exactly the clarification a cold reader needs. Section 4, p. 8, lines 558–568.

- **The six-arc line-bound proof is well staged.** It separates chord, one-vertex, and disjoint-line cases, then turns the equality case into a concrete normalized contradiction. Section 4, pp. 8–9, lines 604–633.

- **The core rigidity proof is exceptionally efficient.** The upper bound from conic containment, lower bound from chord defect and Brianchon concurrence, and equality classification form a clean conceptual chain. The proof also states plainly where the census enters. Section 4, pp. 9–10, lines 661–697.

- **The complete syndrome oracle is an excellent payoff.** The four-case formula is immediately usable, and the proof explains the ambiguity counts rather than merely reporting them. Section 3, p. 7, lines 468–505.

- **Figure 1 and the decoder corollary make an abstract dictionary visible.** The figure is not ornamental: it supports the transition among self-polar triangles, matchings, Brianchon points, and support pairs. Section 5, pp. 13–14, lines 929–1039.

- **Section 6 opens with a strong roadmap.** “A universal chord-multiplicity identity makes this a four-field question” tells the reader both the scale reduction and the nature of the remaining obstruction. Section 6, p. 15, lines 1104–1111.

- **The chord-defect identity is presented at the right level.** The two moments and their elimination are short, transparent, and later reused effectively. Section 6, pp. 15–16, lines 1151–1178.

- **The small-\(k\) theorem has a genuine unifying mechanism.** The universal moments make the \(k=4,5,6,7\) discussion feel like one argument rather than four disconnected classifications. Section 6.1, pp. 18–19, lines 1347–1402.

## 3. Paragraph-level issues in reading order

1. **“This arc–coset dictionary, in various forms…”**  
   Section 1, pp. 1–2, lines 92–126.

   This paragraph begins with the indispensable dictionary, then accumulates provenance, covering-radius caveats, NP-hardness history, two Reed–Solomon literatures, and the GRS contrast. By its end, the reader has lost the newly defined \(U(A)\).

   Revision direction: end the first paragraph at line 112. Put the Reed–Solomon comparison in a separate, shorter paragraph after the paper’s object has been introduced.

2. **“The object of this paper…” arrives too late.**  
   Section 1, p. 2, lines 128–141.

   This is the first paragraph that tells a cold reader what concrete object is being studied. It should appear before the long Reed–Solomon literature paragraph.

   Revision direction: move lines 128–133 immediately after the arc–coset dictionary, then give only the literature needed to locate the exception.

3. **“What is new and what is not.”**  
   Section 1, p. 2, lines 154–168.

   This is useful once, but essentially the same novelty boundary is restated in the census framing, Remark 4.8, and Remark 4.12. Repetition makes the paper sound anxious and slows the mathematical arrival.

   Revision direction: retain one authoritative novelty paragraph here; later sections should refer back to it only when a genuinely local distinction is required.

4. **“The Clebsch hexagon is the six-point orbit of poles…”**  
   Section 2, p. 3, lines 181–187.

   The first definition uses “poles,” “5-fold-axis chords,” “antipodal pair,” and “Sylow 5-subgroup” before offering the reader a picture or usable coordinates. It is accurate but not a good first mental model.

   Revision direction: precede it with one plain-language sentence explaining that six special external points are selected from the icosahedral action, or move the explicit coordinate representative much earlier and present this as the invariant construction.

5. **“For a nonsingular conic over an odd field…”**  
   Section 2, p. 3, lines 190–203.

   The first half explains exteriority well. The last sentence pivots to LDPC stopping sets before the present MDS code has even been defined.

   Revision direction: end after the stronger covering statement at lines 197–200. Move the distinct LDPC connection to a compact literature remark after the code is introduced.

6. **“There is also a more direct fixed-conic binary-code lineage.”**  
   Section 2, p. 3, lines 215–230.

   This full paragraph is a substantial detour through four binary-code constructions and two parameter sets. The conclusion is merely that they are different objects. A cold reader has to learn a second coding context to be told to discard it.

   Revision direction: compress to two sentences or a footnote: such incidence codes exist, but their coordinates and alphabet differ from the present six-coordinate \(\mathbb F_{11}\)-linear code.

7. **“This is projectively the arc \(K_2\)…”**  
   Section 2, pp. 3–4, lines 232–259.

   Too many jobs are assigned to one paragraph: catalogue identification, existence condition, uniqueness, stabilizer, associated conic, nonconic property, a long footnote, primitive-group context, incompleteness, and covering radius.

   Revision direction: split into “classical identification and properties” and “covering radius.” Move the catalogue-for-completeness material to a note. Bring the explicit representative at lines 261–267 closer to the definition.

8. **“By the arc–coset dictionary…”**  
   Section 3, p. 4, lines 285–302.

   The essential first six lines repeat a useful bridge. The remainder over-defends the applicability and numbering of one source, including a parenthetical catalogue of unused theorems.

   Revision direction: keep the applicability sentence, but move the unused-theorem discussion to a footnote or remove it. The reader needs the formula, not the history of nearby theorem numbers.

9. **“The ordinary three-dimensional icosahedral character…”**  
   Proposition 3.1 proof, p. 5, lines 326–363.

   The proof abruptly assumes comfort with modular reduction of characters, subgroup normalizers, and exact stabilizer subtraction. The ledger is compact but its row “\(\#H\)” is not explained clearly enough, and the paragraph never reminds the reader why this full orbit census is needed.

   Revision direction: add a one-sentence roadmap before the ledger and explicitly define every row. Consider moving the full exact-stabilizer bookkeeping to an appendix while retaining the unique 12-orbit conclusion in the main text.

10. **“The kernel certificate verifies…”**  
    After Proposition 3.1, p. 5, lines 366–367.

    This one-sentence paragraph is an orphan between the orbit proof and the proposition that uses it. It breaks momentum without advancing the mathematical narrative.

    Revision direction: consolidate such verification notes in Section 7 or attach them uniformly as end-of-proof notes.

11. **“The companion arcs paper records this identification…”**  
    Section 3, p. 6, lines 402–405.

    This is another novelty/provenance interruption immediately after a satisfying proof and before its numerical corollary.

    Revision direction: cut from this location and incorporate the point into the single novelty discussion in the introduction.

12. **“Certified structural facts.”**  
    Section 3.1, pp. 7–8, lines 512–545.

    The hierarchy is uneven: a substantial automorphism-group derivation, a one-line orthogonal-array observation, and the crucial self-polar triangles are peers in one bullet list. The design bullet feels incidental; the triangle bullet is needed for Section 5.

    Revision direction: give automorphisms and triangles their own short subsections or propositions. Move the orthogonal-array fact to a remark.

13. **“Census framing.”**  
    Section 4, p. 8, lines 571–589.

    Before the main theorem, the reader receives another extended priority disclaimer that repeats the introduction and anticipates later novelty remarks.

    Revision direction: replace this paragraph with three sentences: what is enumerated, what invariant is extracted, and which theorem clause uses it.

14. **“For an external line, the secant intersections form the focus set…”**  
    Section 4, p. 8, lines 594–602.

    This literature preamble is longer than the conceptual role it plays. It introduces “focus set,” “hyperfocused,” “internal-nucleus theorem,” and “hyperovals in five-nets,” none of which is used in the direct proof.

    Revision direction: reduce to a final note after the lemma: related stronger results exist, but the direct six-point proof is included for exact applicability.

15. **“Frame-normalized census.” before the theorem.**  
    Section 4, p. 9, lines 635–645.

    The main theorem has already been announced, but the reader must pause for normalization mechanics before seeing its statement.

    Revision direction: state Theorem 4.4 immediately after the line bound. Move this remark to the numerical clause of the proof or the verification section.

16. **“The standalone artifact…” / “The formal development exposes…”**  
    Section 4, p. 10, lines 700–715.

    These two paragraphs interrupt the transition from the rigidity theorem to its low-degree strengthening. They also repeat which parts are conceptual and enumerative, already stated in the proof.

    Revision direction: consolidate in the verification map. In the body, one sentence such as “Clause (iii) is established by the census described in Section 7” is enough.

17. **“Degree three is best possible.”**  
    Remark 4.7, p. 11, lines 764–775.

    The phrase is initially counterintuitive because the following examples occur in degrees four, five, and six. The reader must infer that “best possible” means the rigidity statement fails as soon as degree four is allowed. The sextic-kernel detail then opens a new classification thread.

    Revision direction: say explicitly, “The cutoff cannot be raised from three to four.” Keep the quartic counterexample; relegate the quintic/sextic catalogue to a later computational-results remark.

18. **“Which implications are new.”**  
    Remark 4.8, p. 11, lines 778–793.

    This is the third substantial novelty explanation. Its last three lines express the bridge beautifully, but the rest repeats prior attribution.

    Revision direction: preserve the final conceptual sentence, but merge the attribution into the introduction’s novelty paragraph.

19. **“The rigidity theorem has three quantitative refinements…”**  
    Section 4, p. 11, lines 796–824.

    Three different notions are introduced in succession: count gap, classwise nearest-conic discrepancy, and fixed-embedding local discrepancy. The distinction is real but cognitively expensive, and the following theorem reports several histograms at once.

    Revision direction: insert a small comparison table or split the gap theorem into three results, each immediately following its definition. Put the global-versus-fixed warning before the local result.

20. **“The Clebsch configuration is rigid rather than merely stable.”**  
    Theorem 4.9, pp. 11–12, lines 826–860.

    “Rigid” and “stable” are not defined in the sense suggested by this sentence. The theorem then combines a forbidden interval, an exact class histogram, two local histograms, and an eight-orbit decomposition. The headline insight is buried in data.

    Revision direction: lead with the three qualitative bounds \(16\), \(12\), and \(18\), then put exact histograms in a corollary or table.

21. **“Two spectra, one word apart.”**  
    Remark 4.11, p. 12, lines 875–887.

    Like Remark 4.1, it guards against a terminology confusion, but here the defensive digression comes after an already overloaded theorem.

    Revision direction: compress to one sentence or a footnote attached to “census gap.”

22. **Section 5 begins “The 20 three-supports form two…”**  
    Section 5, p. 13, lines 921–927.

    The section title promises “chirality,” but the opening declares the orbit split without explaining why it merits that name or what reader-facing phenomenon it captures.

    Revision direction: add two sentences: complementary supports are paired, automorphisms preserve the two classes, but no class has a preferred sign; this is the sense of chirality used here.

23. **“Let \(M(T,T')\)… let \(\beta(T,T')\)…”**  
    Proposition 5.1, p. 13, lines 983–1008.

    The reader must simultaneously hold triangles-as-matchings, their alternating cycle, an opposite matching, a bipartition, a concurrence point, two bijections, and Petersen adjacency.

    Revision direction: work one explicit example from the displayed \(T_i\) before giving the general maps. The figure then becomes a decoding aid rather than a legend the reader must reverse-engineer.

24. **“All concurrences… follow from these two equivariant bijections.”**  
    Proposition 5.1 proof, pp. 13–14, lines 1011–1022.

    The final sentence compresses several nontrivial conclusions into “follow,” including multiplicity counts and compatibility.

    Revision direction: separate the proof into bijectivity, concurrence, and equivariance paragraphs; state which conclusion follows from which construction.

25. **“Two classical constructions are adjacent but different.”**  
    Section 5, p. 14, lines 1041–1045.

    This provenance distinction interrupts the direct progression from decoder reconstruction to chirality.

    Revision direction: move to a footnote or the introduction’s related-work discussion.

26. **“An unbased \(\mathbb Z/2\)-torsor…”**  
    Proposition 5.3, p. 14, lines 1047–1064.

    This is precise but introduces sophisticated abstraction after “unordered bipartition” has already said most of what is needed. The terminology risks making a simple invariant feel more forbidding.

    Revision direction: keep “unordered two-class decomposition” in the theorem; reserve the torsor formulation for a following remark.

27. **“There is a finer equivariance distinction.”**  
    Section 5, pp. 14–15, lines 1092–1102.

    The size-five equivariant decoder is interesting but arrives as an unannounced secondary result after the section’s natural conclusion at lines 1089–1090.

    Revision direction: promote it to a proposition with motivation, or omit it from the main narrative and place it with ancillary decoding results.

28. **“No accounting for overlap…”**  
    Lemma 6.1 proof, p. 15, lines 1140–1148.

    The parenthetical is longer than the counting argument it defends. It reads as a response to a prior objection rather than part of a polished proof.

    Revision direction: replace with “Overlaps can only reduce the union, so summing the fifteen capacities gives the required upper bound.”

29. **“It remains to exclude \(q=9\).”**  
    Theorem 6.3 proof, p. 16, lines 1201–1218.

    The passage from passant chords to the Sylvester graph is elegant but fast. “Standard conic counts,” the polarity graph, the intersection array, exact-distance-two graph, and \(\operatorname{eq}_2\) appear in one paragraph.

    Revision direction: give a three-step roadmap: vertices are internal; passant joins become distance two; the exact-distance graph has clique number five. Define \(\operatorname{eq}_2(H)\) in words.

30. **“The from-scratch certificate…” followed by the census.**  
    Section 6, pp. 16–17, lines 1225–1260.

    The conceptual proof has just finished, but the narrative pauses for a second verification path and a dense table before moving to the Clebsch-family formula.

    Revision direction: move the full census to Section 7 or an appendix; in Section 6 retain only the rows or observation directly illuminating \(q=11\).

31. **“The failure of the same symmetric recipe at the next admissible prime…”**  
    Section 6, pp. 17–18, lines 1301–1340.

    The \(q=19\) example is illuminating, but two long paragraphs introduce split versus nonsplit tori, \(\mathbb F_{361}\), Galois-stable chords, capacity excess, and rank calculations. It delays the advertised small-arc boundary.

    Revision direction: make this a labeled example or subsection. Preserve the contrast \(140=20+120\) and the exact excess; compress the group-rationality discussion unless it is needed later.

32. **“Proof with exhaustive finite verification.”**  
    Theorem 6.5, pp. 18–19, lines 1359–1402.

    The \(k=4,5,6\) progression is clean; the \(k=7\) paragraph suddenly shifts from moment bounds to enumeration mechanics. The proof’s conceptual and finite parts would be easier to appraise if visibly separated.

    Revision direction: end the theoretical reduction after the two surviving fields, then add a distinct “finite exclusion” paragraph or lemma.

33. **“The \(q=5\) four-frame equality is elementary…”**  
    Section 6.1, p. 19, lines 1405–1412.

    This paragraph again mixes priority disclaimer, distinction from Dye, novelty, and outlook.

    Revision direction: retain only the actual boundary statement for \(k\ge8\); consolidate priority material earlier.

34. **“Verification architecture and outlook.”**  
    Section 7, p. 19, lines 1414–1473.

    The title promises two coequal functions, but almost the entire section is a verification table; the outlook is one short paragraph. The paper therefore ends administratively rather than conceptually.

    Revision direction: rename the section “Verification architecture,” then add a genuine concluding section that restates the conceptual bridge, explains what \(q=11\) teaches, and develops the open directions by mathematical theme.

## 4. Top five edits ranked by impact

1. **Rebuild the first four pages around the object rather than the literature.**  
   Introduce the \([6,3,4]_{11}\) code and its conic syndrome locus immediately after the arc–coset dictionary. Compress or relocate the Reed–Solomon, LDPC, exterior-set, and catalogue discussions.

2. **Consolidate all novelty, provenance, and verification commentary.**  
   Keep one strong novelty statement in the introduction and one verification architecture section. Remove the recurring mid-proof and post-proof reminders. This alone would make the central argument feel much shorter.

3. **Split the gap material into conceptually separate results.**  
   Treat the count gap, classwise nearest-conic gap, and one-point perturbation gap independently. State qualitative bounds first; move exact histograms and orbit rows to tables or corollaries.

4. **Add conceptual on-ramps to Sections 2 and 5.**  
   Give a plain-language model or explicit example before the invariant Clebsch definition, and explain “chirality” before deploying synthematic totals, alternating cycles, and torsors.

5. **Give Section 6 a cleaner terminal arc.**  
   Preserve the conceptual \(q=11\) proof, but relocate the full census and shorten or label the \(q=19\) excursion. End with a genuine conclusion/outlook rather than the verification table.

## 5. Passages that should not be cut

- The abstract’s concrete theorem-and-count summary, lines 39–61.
- The syndrome and projective-direction setup, lines 74–90.
- The core plane arc–coset dictionary, lines 92–112.
- The concise description of the exceptional code and main theorem, lines 128–152.
- The distinction between the arc lying on a conic and its uncovered locus lying on one, Remark 4.1, lines 558–568.
- The direct proof of the six-arc line bound, lines 610–633.
- The conceptual part of the rigidity proof, lines 661–682.
- The complete syndrome oracle and its ambiguity interpretation, lines 468–505.
- Figure 1, the Brianchon–support dictionary, and especially the decoder reconstruction corollary, lines 929–1039.
- The sentence explaining that the chirality split has no preferred signs, lines 1089–1090.
- The opening roadmap of “Why \(q=11\),” lines 1107–1111.
- The chord-defect identity and proof, lines 1151–1178.
- The \(q=9\) Sylvester-graph obstruction, lines 1201–1218, though it needs a slower exposition.
- The exact \(q=19\) contrast \(140=20+120\) and the explanation that the conic remains inside but no longer exhausts \(U(A)\), lines 1312–1317 and 1327–1340; shorten, but do not delete.
- The universal moment framework for \(4\le k\le7\), lines 1359–1394.
- The closing observation that additional concurrency parameters appear for \(k\ge8\), lines 1410–1412; it is the natural mathematical handoff to future work.
