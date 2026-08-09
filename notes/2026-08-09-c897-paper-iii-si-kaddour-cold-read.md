# C897 Paper III cold read — Hamza Si Kaddour persona

Date: 2026-08-09
Review mode: sealed reconstruction-referee read
Frozen manuscript: `clebsch-passages` commit `7208275e6b5f979fea487d2130943bbd979aed37`
Frozen PDF SHA-256: `6794202d653d6908b495120c47848162a15d357c1438611e9e42f10384472622`
Dossier SHA-256: `12fd05f3ace288282075432a303214ea37d606b658e9967540e4b316efe7f8f8`

## Frozen PDF-only proof assessment

This section was written before any permitted supplement file was opened. The proof premises here are the PDF and Packet R's four cited reconstruction sources only.

### The reconstruction theorem in the packet's vocabulary

On a fixed labelled vertex set (V), the input is that two two-graphs \(\tau,\tau'\) are **4-hypomorphic up to complementation**: for every labelled four-set (K\), the restrictions \(\tau|_K\) and \(\tau'|_K\) are isomorphic up to complement. Within the two-graph parity class this is equivalent to equality of the aligned-family indicator, because a four-point two-graph has zero, two, or four triples, and all two-triple restrictions are mutually isomorphic. The output is the stronger labelled conclusion **equality up to complementation**, \(\tau'=\tau\) or \(\tau'=1+\tau\). In matrix language, the determinant-\((-3)\) four-set bit determines a Seidel/conference signing up to diagonal sign similarity (switching) and global negation.

This differs from Pouzet--Si Kaddour's arbitrary 3-uniform-hypergraph theorem both in domain and observable: their eventual least local size is \(s(3)=5\), with ambient threshold at most eight, whereas Paper III restricts to the two-graph parity class and reads only whether a four-set is aligned. It is genuinely analogous to, but is not implied by, Dammak--Lopez--Pouzet--Si Kaddour's ordinary-graph four-local theorem at order seven.

### Causal proof reconstructed from the article

1. Root a two-graph at (r\). Its values \(\tau(rij)\) are the edges of a graph (G_r\), and the two-graph equation gives \(\tau(ijk)=\tau(rij)+\tau(rik)+\tau(rjk)\). Thus a rooted four-set is aligned exactly when its other three vertices form a clique or independent triple. Ramsey's (R(3,3)=6\) supplies an aligned anchor in every seven-set.
2. On seven vertices, normalize the two candidates on an aligned four-set (Q\), then switch each outside point so its fourth coordinate is zero. The four tests through three points of (Q\) recover each normalized cut except for three balanced cuts.
3. The six tests through two points of (Q\) and two outside points recover the outside edge and resolve every balanced-cut ambiguity except the order of two distinct balanced cuts. With exactly three outside points, any attempted change forces two incompatible swaps, so no cut changes. Formula (5.2) then recovers every outside edge.
4. For larger (V\), apply the seven-point result on every seven-set. Adjacent seven-sets overlap in six vertices; their local complement bits must agree because the overlap contains a triple, on which equality and complement cannot both hold. Connectedness of the Johnson graph propagates one convention globally.
5. The displayed six-point rooted graphs have the same aligned family but are neither equal nor complementary, proving sharpness. Direct enumeration of rooted graph representatives confirms that on seven vertices all (2^{15}\) representatives fall into (2^{14}\) aligned-family fibres, each exactly one complementary pair; on six vertices there are non-complementary collisions (maximum fibre size twelve). This check supports the prose but is not used as a proof premise.

### Earliest unsupported implication and complement-convention audit

I find **no unproved propagation of the complement convention in the headline proof**. The earliest possible concern is the passage from seven points to larger (V\), but the article supplies the needed argument: assign a local bit \(\epsilon_X\) to each seven-set (X\); for adjacent (X,Y\), any triple in (X\cap Y\) forces \(\epsilon_X=\epsilon_Y\); connectedness of (J(|V|,7)\) makes the bit global. The decoder later uses the same fact when a new seven-set shares the fixed six-set (Q\cup\{x,y\}\); this is terse, not a gap.

The earliest implication not justified by the assigned source as cited occurs later in Remark 5.4: Holtz--Sturmfels Theorem 6 is invoked for the unconditional identifiability class of a Seidel matrix, but that theorem assumes the strict inequalities (12). The PDF neither verifies those inequalities for every Seidel matrix nor limits the sentence to the nondegenerate case. The identifiability claim is nevertheless true here by the paper's own elementary order-three-minor observation, so this is citation overreach, not a defect in Theorem 5.2.

### Benchmark and query audit

- Dammak--Lopez--Pouzet--Si Kaddour already put ordinary graphs at local size four and ambient order seven in the immediate neighborhood. The manuscript now says “analogous” and explicitly distinguishes its sharpness statement; it does not claim that the arbitrary-hypergraph threshold is the only benchmark.
- Pouzet--Si Kaddour give (s(3)=5\) for arbitrary 3-hypergraphs and eventual ambient threshold at most eight. Saying that the two-graph parity axiom lowers the general threshold to four is accurate once read as a restricted-class comparison, which the surrounding sentences make explicit.
- Holtz--Sturmfels use a full compatible principal-minor vector under strict nondegeneracy. Brunel--Urschel query numerical principal-minor values and obtain polynomial-time recovery with (O(n^2)\) queries. Paper III queries only the bit “is this fourth-order minor \(-3\)?” and explicitly denies a speedup or runtime claim.
- The fixed-family count is exact after an aligned anchor is known: (1+4(n-4)+6\binom{n-4}{2}=3n^2-23n+45\). The entropy lower bound using (H(1/4)\) is expressly restricted to fixed, nonadaptive test families. The binary decision-tree bound applies adaptively, and the later (\binom n2+O(n)\) construction is explicitly adaptive. These claims are not conflated.

### PDF-only provisional findings

1. **Citation overreach:** Remark 5.4 cites Holtz--Sturmfels Theorem 6 as though it unconditionally supplied Seidel identifiability up to diagonal sign similarity; the theorem quoted in Packet R has a strict nondegeneracy hypothesis not checked here. The surrounding elementary order-three argument repairs the mathematical claim.
2. **Exposition friction:** the adaptive (\binom n2+O(n)\) paragraph compresses the one-test extension dichotomy enough that a reader must verify the two cases algebraically. It is correct, but a displayed one-line rooted-test identity would make the fixed/adaptive distinction easier to audit.

Provisional PDF-only verdict: **MINOR**.

## Supplement audit

The permitted supplement was inspected only after the PDF-only section above was frozen. At commit `7208275e6b5f979fea487d2130943bbd979aed37`, `git status --short` over `README.md`, `ARTIFACT.md`, `literature-boundaries.md`, `clebsch_passages.tex`, `sections/`, and `verification/` was empty. Thus the permitted supplement was clean.

Exactly these files affected or confirmed findings:

- `README.md` confirmed the public headline—seven-point sharp reconstruction from fourth-order Seidel data—and the logical independence of this result from the golden setting. It changed no finding.
- `ARTIFACT.md` confirmed that supplement/formal coverage is partial evidence with explicit human boundaries and is not a manuscript proof premise. It increased confidence in the audit trail but changed no proof conclusion.
- `literature-boundaries.md` row `OPER-4` confirmed the distinctions among the ordinary-graph four-local theorem, the arbitrary-hypergraph size-five threshold, full-value principal-minor algorithms, and Paper III's one-bit fourth-order oracle. It confirmed the benchmark assessment. Its unqualified sentence assigning the identifiability class to Holtz--Sturmfels does not supply the strict-hypothesis check missing at the citation.
- `clebsch_passages.tex` confirmed that the PDF abstract and source statement coincide. It changed no finding.
- `sections/05-golden-operator.tex` confirmed the exact theorem, tables, complement-bit overlap sentence, fixed-family count, adaptive paragraph, and surrounding benchmark wording seen in the PDF. It changed no finding.
- `sections/10-references.tex` confirmed the cited versions of Dammak--Lopez--Pouzet--Si Kaddour, Pouzet--Si Kaddour, Holtz--Sturmfels, and Brunel--Urschel. It confirmed rather than repaired the citation-hypothesis issue.
- `verification/README.md` confirmed that the normalized classifier, third-point disambiguation, overlap consistency, switching transport, determinant identity, and query polynomial have a public formal audit, while stating that no manuscript theorem takes that audit as a proof dependency. It increased confidence but changed no human-proof finding.
- `verification/trust_manifest.json` (`OPER-4`) and `verification/statement_identity.json` (`thm:aligned-faithfulness`) confirmed the frozen theorem and trust surface. They changed no finding.
- `verification/passages_formal.json` (`OPER-4`) confirmed declarations for seven-point agreement, global complement-bit agreement, selected-query sufficiency, Seidel transport, and determinant fibres. `verification/golden_return_formal.json` (`OPER-4`) confirmed the supplemental switching/triangle mechanisms. Neither was used to fill a prose proof step, and neither changed a finding.

No other supplement file affected a finding.

## Neutral protocol answers

1. **Strongest theorem/package believed proved.** In the assigned reconstruction scope, Theorem 5.2 is a coherent sharp package: for every labelled two-graph on at least seven vertices, its aligned four-sets determine it up to global complement; six vertices do not suffice. Consequently the determinant-\((-3)\) four-subsets of a symmetric conference/Seidel signing determine the signing up to diagonal switching and global negation, with an explicit fixed quadratic query family after an anchor and a separate orientation calibration.

2. **Causal proof without supplement.** Rooting converts the two-graph equation into graph-edge xor; Ramsey supplies an aligned anchor; four one-point signatures recover all but three balanced cuts; the pair criterion (5.2) and its two tables recover outside edges and leave only an ordered balanced-cut ambiguity; the third outside point rules that ambiguity out; overlap of adjacent seven-sets propagates one complement bit; the displayed six-point collision proves sharpness; and the determinant identity transports the result to signings.

3. **Earliest unjustified implication.** No unjustified implication occurs in the headline reconstruction proof. The first source-dependent overstatement is in Remark 5.4, where Holtz--Sturmfels Theorem 6 is cited without its strict nondegeneracy hypothesis. For Seidel matrices that hypothesis can be discharged—the relevant almost-principal minors are odd modulo two—so this needs a sentence, not a new idea. The later adaptive one-test extension is correct but compressed.

4. **Fields, base change, normality, labels, signs, equivalences, exceptional orders.** The reconstruction proof is over \(\mathbf F_2\) and uses a fixed labelled set; no base change or normality enters this logically independent theorem. Its output is labelled equality up to complement, not merely isomorphism. Root switching is change of graph representative, global complement negates all triangle values, diagonal sign similarity is matrix switching, and global matrix negation is the residual orientation ambiguity. Faithfulness starts at seven and fails at six. The conference corollary is stated from order ten, the first relevant conference-design range beyond the six-point obstruction. Holtz--Sturmfels work over real symmetric matrices and require strict inequalities; Brunel--Urschel return matrix recovery from numerical minor values in their magnitude-symmetric class.

5. **Category separation.** There is no false statement and no headline proof gap. There is one citation-overreach/hypothesis-visibility issue, one mild convention/translation ambiguity, and one exposition friction in the adaptive query sketch; these are listed below without converting them into proof defects.

6. **Verdict and ranked effect.** **MINOR**. The sharp theorem, fixed decoder, and convention propagation are sound. The changes requested below affect benchmark attribution and auditability, not the headline conclusion.

7. **Contribution relative to Packet R.** The two-graph parity equation turns the aligned-four-set bit into a sharp labelled reconstruction observable at local size four and ambient order seven, strictly weaker per query than full principal-minor values and narrower in domain than arbitrary 3-hypergraph reconstruction.

8. **Advances in Mathematics bar, assuming repairs.** The reconstruction result itself meets a specialist significance bar and is unusually explicit. The article's cross-field readability is not yet fully at that level: the abstract joins several arithmetic, operator, reconstruction, and harmonic outputs before exposing their common marked-sign mechanism, while the reconstruction section's own causal line is readable. Assuming the other theorem packages are equally sound, a modest abstract/roadmap revision would make the common mechanism and the independent status of Theorem 5.2 easier to retain.

## Ranked findings and verdict

1. **Citation overreach (minor, benchmark-facing).** Remark 5.4 attributes unconditional Seidel identifiability up to diagonal sign similarity to Holtz--Sturmfels Theorem 6 without stating its strict nondegeneracy assumption. The target matrices satisfy the needed strictness by a short parity argument for the relevant almost-principal minors, and order-three minors independently prove the same identifiability statement. Add either argument or narrow the citation sentence.
2. **Exposition friction (minor).** The adaptive \(\binom n2+O(n)\) claim correctly distinguishes decision-tree queries from a fixed family, but “either way the test reads as one bit” hides the rooted xor calculation that makes the single-test extension work. Add the two-case identity; this would make the leading-constant comparison independently checkable on first reading.
3. **Normalization ambiguity (minor).** At first use, say explicitly that “aligned” is the union of the coherent and incoherent four-set types in standard two-graph terminology. The mathematical definition is exact, but this one-clause translation would prevent readers from confusing complement, switching, and coherent-set conventions.

No false statement was found. No proof gap was found in Theorem 5.2 or its fixed-family decoder.

**Verdict: MINOR.**
