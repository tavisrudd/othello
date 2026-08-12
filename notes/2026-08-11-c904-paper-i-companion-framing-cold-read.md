# C904 Paper I + computational companion framing cold read

**Date:** 2026-08-11
**Verdict:** **MINOR**
**Artifacts read:** `papers/clebsch-rigidity/clebsch_rigidity.pdf` (29 PDF pages) and `papers/clebsch-rigidity/clebsch_rigidity_computational_companion.pdf` (13 PDF pages)

## Protocol

I read both rendered PDFs completely before consulting manuscript source. I did not read prior reports, notes, handoffs, Git history, or manuscript source during the PDF-first pass. Afterward I inspected only the two TeX sources to locate exact repair sites. No manuscript was edited.

## Paired-release assessment

The pair is mathematically coherent and releaseable after minor repair. Paper I gives a genuine structural inverse theorem; the companion sharpens it by finite classification and closes the bounded cases left by the structural window. The papers do not compete for the same crown, and the companion consistently describes enumeration as a strengthening or terminal closure rather than as the proof of Paper I's rigidity theorem.

I found no theorem/framing contradiction and no headline that materially exceeds the theorem statements. The main reasons for **MINOR**, rather than **PASS**, are a demonstrably stale phrase in the rendered companion, an unnecessary unsupported research-note assertion, an underdescribed trusted-execution exhaustion step for the exact q=13 minimum-word count, and release/locator prose that is not yet fully standalone.

## What each paper says

### Paper I

- **Main inverse problem.** From the projective maximum-distance syndrome locus (equivalently, the uncovered locus of a six-arc), reconstruct the parity-check geometry and then its intrinsic orientation data.
- **Principal structural headline.** PDF p. 3, Theorem 1.1: for a six-arc in `PG(2,11)`, conic containment of `U(A)`, equality with a nonsingular conic, and projective equivalence to the Clebsch hexagon are equivalent.
- **Quantified consequences.** The fixed-conic orbit statement (p. 10), 12 projective deep-hole directions / 120 deep-hole cosets / 159720 received-word deep holes (p. 13), the field window `2k-3 <= q <= (k(k-1)+3)/3` (pp. 10--11), and the golden identities `B^2=5I` and `c_ijk=B_ij B_jk B_ki` (pp. 19--20).
- **Scope.** The rigidity theorem is order eleven and six points; the chord-defect identity and field window are uniform. The golden-orientation reconstruction is for the reconstructed Clebsch object.
- **Novelty/attribution boundary.** Strong. PDF pp. 3--6 explicitly separate the classical Clebsch hexagon, Dye uniqueness/polarity/stabilizer, known cubic, and known conference-matrix context from the new arbitrary-quadratic-containment criterion, decoder reconstruction, support bipartition, field window, concurrence spectrum, and intrinsic recovery of the cubic/operator from syndrome and support data.
- **Trust boundary.** Strong. The rigidity and decoder spine are human proofs using pinpointed classical inputs; the displayed finite orbit and Groebner data are human-auditable certificates; Lean and replay are explicitly redundant cross-checks (pp. 25--27). The companion searches are expressly outside Paper I's formal gate.
- **Standalone intelligibility.** Yes. A reader can identify the datum, conclusion, mechanism, imported theorems, and machine boundary without another paper. The series map and later-paper catalogue are distractions, not dependencies.

### Computational companion

- **Main finite problem.** Determine the sharp finite boundary around Paper I's reconstruction theorem: strengthen the q=11 recognition criterion, exclude the remaining field orders for six-arcs, and classify conic-filling arcs for `4 <= k <= 8`.
- **Principal quantified headlines.** Fifteen projective six-arc classes over `F_11`; degree at most three and `|U(A)| <= 15` each characterize the Clebsch class (pp. 2--4); q=11 is the unique order for a conic-filling six-arc (pp. 4--5); only `(k,q)=(4,5),(6,11)` occur through eight points (pp. 9--10). The q=13 historical branch asserts a binary `[78,36,12]_2` code with 364 minimum words in four size-91 orbits and reconstructs the six-class elliptic scheme (pp. 6--8).
- **Scope.** Exact finite computation, plus the structural q=9 Sylvester reduction and the historical q=13 incidence-code branch. The q=13 material is partially reused in the k=8 exclusion but its full minimum-layer theorem is broader than the Clebsch companion's central task.
- **Novelty/attribution boundary.** Clear for the structural inputs and q=13 published inputs, but the novelty status of the fifteen-class q=11 census itself should be said explicitly; see concern 6.
- **Trust boundary.** Exceptionally clear at the category level: human proof, published theorem, Lean theorem, finite certificate, and trusted execution are distinguished claim by claim (pp. 11--12). The remaining weakness is not category confusion but insufficient standalone detail for one trusted exhaustion and no stable finite-bundle locator in the PDF; see concerns 3--4.
- **Standalone intelligibility.** Substantively yes as a companion: Paper I's three inputs are restated on pp. 1--2, and every finite theorem says what it closes. Audit-level standalone reproducibility is not yet complete because the paths are relative to an unnamed release directory.

## Headline-to-theorem support audit

### Paper I: PASS

1. **Conic containment recognizes Clebsch.** Abstract p. 1 is exactly Theorem 1.1 on p. 3, proved on pp. 9--10.
2. **Code reconstruction up to monomial equivalence.** The fixed-conic orbit is Corollary 4.2, and the projective/monomial passage is explicit on p. 10.
3. **Decoder multiplicities and exact counts.** Proposition 6.5 and its incidence proof on pp. 15--16 support the ambiguity claims; Corollary 6.2 supports the 12/120/2400/159720 figures.
4. **Support bipartition and golden orientation.** Propositions 7.1--7.3 reconstruct the relevant support datum; Theorem 8.1 and Corollary 8.2 support the conference operator, cubic, node frame, `S_5/A_5`, and integral-commutant claims.
5. **Uniform field window.** Theorem 4.4 states and proves the abstract's bound.

### Computational companion: PASS, with one trust-documentation qualification

1. **Fifteen q=11 classes, cubic recognition, and four-point gap.** Table 1, Proposition 2.1, and Theorem 2.4 support the abstract exactly.
2. **Unique six-arc field order.** Theorem 3.2 proves q=11 using the structural window, concurrence spectrum, and q=9 Sylvester clique obstruction.
3. **Classification through eight points.** Theorem 5.1 has the advertised `4 <= k <= 8` quantifier and supplies structural reductions plus finite terminal certificates.
4. **q=13 code theorem.** The parameters, orbit count, and reconstruction are stated in Theorem 4.2. The trust table correctly marks the minimum-word classification/reconstruction as a trusted execution rather than a certificate, but the prose does not describe the exhaustion sufficiently for an audit reader; concern 3 is documentation, not a theorem/framing contradiction.

## Concerns and exact repair sites

### 1. MINOR — rendered companion contains a stale forward reference

**PDF location:** computational companion p. 5.
**Quoted phrase:** “belongs to forthcoming Paper IV”.

This is demonstrably stale relative to the present TeX, which now says simply “belongs to Paper IV.” The current source repair is already present at `clebsch_rigidity_computational_companion.tex:436--438`; the PDF needs to be rebuilt from that source and checked against it. This is the clearest paired-release blocker, but it is mechanically minor.

### 2. MINOR — unsupported private-note result is stated despite being outside the claim surface

**PDF location:** computational companion p. 5.
**Quoted phrases:** “A descent refinement of that decomposition is recorded in the project's research notes” and “Its proof is not reproduced here and its formalization is pending”.

The paragraph nevertheless states the sharp assertions that `K` is irreducible over `F_2`, has endomorphism field `F_8`, and has a canonical twelve-dimensional `F_8` structure. Declaring the assertions outside the claim surface does not turn them into citable mathematics, and nothing later uses them. Delete this aside or replace it with a proved/cited statement. Source: `clebsch_rigidity_computational_companion.tex:419--428`.

### 3. MINOR — exact q=13 minimum-word count lacks a reader-visible exhaustion account

**PDF locations:** computational companion pp. 7 and 11.
**Quoted phrases:** “generates four projective orbits from explicit representatives and verifies all 364 supports against M” and “A trusted execution reconstructs and exhausts its stated domain”.

The first sentence verifies the 364 generated supports but does not tell the reader how the execution proves that no other weight-twelve supports exist: the searched domain, traversal/symmetry reduction, deduplication rule, stopping condition, and expected terminal count are not stated. The later definition of “trusted execution” asserts exhaustion at the category level but does not supply those missing particulars. Add a compact algorithm/domain paragraph beside the classification claim, or weaken “exactly 364” to a result explicitly conditional on the named execution. Source: `clebsch_rigidity_computational_companion.tex:578--584` and `:844--851`.

### 4. MINOR — replay paths are not tied to a stable finite-artifact release

**PDF location:** computational companion p. 12.
**Quoted phrases:** “Its paths are relative to the present directory” and “The clean companion entry point is verification/verify_computational_companion.py.”

This is usable only if the reader already has the right directory. The PDF does not give a DOI/repository locator and exact release revision for the finite companion bundle, nor a toolchain/resource envelope or expected top-level result. Paper I pins its formal manifests and gives a concept DOI, but that does not visibly pin these finite certificates and replays. Add the stable archive/revision and a one-command replay contract. Source: `clebsch_rigidity_computational_companion.tex:913--929`.

### 5. MINOR — Paper I contains series-planning language that precedes or distracts from the standalone story

**PDF locations:** Paper I pp. 2 and 4.
**Quoted phrases:** “The later papers study other shadows of related sources”, Figure 1's “conference companion”, and “the unnumbered Golden quantum-statistics companion”.

“Conference companion” is not operationally glossed before the figure, and “unnumbered” is internal series metadata rather than mathematics. The later-paper catalogue on p. 4 substantially repeats the p. 2 programme map. Retain one short dependency-neutral series sentence or move the full map to end matter; delete “unnumbered.” Source: `clebsch_rigidity.tex:110--137` and `:281--287`.

### 6. MINOR — the companion does not state the novelty status of the fifteen-class census

**PDF locations:** computational companion pp. 1 and 3.
**Quoted phrases:** “There are fifteen projective classes of six-arcs over F11” and “the fifteen rows and every uncovered-set size follow from the orbit ledger”.

The result is a headline, but the paper does not say whether the fifteen-class projective census is new, a new independently certified enumeration of a known classification, or merely a release-specific ledger. Paper I is exemplary about this kind of boundary; the companion should add one neutral sentence with the closest prior classification or an appropriately bounded absence statement. The relevant opening is `clebsch_rigidity_computational_companion.tex:37--54`.

### 7. MINOR — one pronoun can be read as accusing the cited classification of incompleteness

**PDF location:** Paper I p. 7.
**Quoted phrase:** “their Proposition 13 classifies the complete two-transitive arcs and omits this order-eleven six-arc. It is therefore incomplete”.

The intended antecedent is the six-arc, but the nearest grammatical antecedent is Proposition 13. Replace with “The order-eleven six-arc is therefore incomplete.” Source: `clebsch_rigidity.tex:487--492`.

### 8. MINOR — paired-release bibliography metadata are asymmetric

**PDF locations:** Paper I p. 29 and computational companion p. 13.
**Quoted phrases:** Paper I “[21] ... companion manuscript, 2026”; companion “[9] ... Paper I, released manuscript, version 2, 2026.”

For a paired release, each paper should identify the other at the same release status and preferably with stable version/DOI metadata. Update the Paper I entry at `clebsch_rigidity.tex:2191--2194` and the companion entry at `clebsch_rigidity_computational_companion.tex:1059--1068` together.

## Copy-edit / repetition / overclaim tally

- **Copy-edit detritus:** concerns 1, 5, and 7.
- **Repetition:** the Paper I series map plus the p. 4 later-paper catalogue (concern 5). I found no harmful repetition of the principal theorem or trust disclaimer.
- **Stale forward references:** concern 1 is definite; concern 8 is release-metadata staleness/asymmetry.
- **Overclaim:** no load-bearing theorem overclaim. Concern 2 is an unnecessary unproved assertion explicitly disclaimed from the claim surface; concern 3 needs a fuller statement of what the trusted execution exhausts.
- **Theorem/framing mismatch:** none.

## Acceptance recommendation

Rebuild and re-read the companion after concern 1, remove the research-note aside, add a compact q=13 exhaustion description and stable artifact locator, and normalize cross-references. The remaining prose fixes are small. No restructuring of either theorem spine is needed.

**Vibe check:** mathematically strong and unusually honest about trust; the release needs a short hygiene pass, not a conceptual rewrite.

## Semi-blind A/B follow-up

**Version A:** the PDFs reviewed above.
**Version B:** rebuilt PDFs dated 2026-08-11 16:47 local time, inspected together with only the scoped Git diff for the two TeX manuscripts.
**B verdict:** **MINOR**.

The mathematical result remains soundly framed, and most A concerns were repaired accurately. B is not yet a clean PASS because two trust/result-indexing defects remain, the finite artifact and paired bibliography are still not stably identified, and one small typography regression was introduced.

### A-concern repair ledger

1. **A1 stale “forthcoming Paper IV”: PASS.** B companion p. 5 now says “Their current paper-level development belongs to Paper IV [10]”; the same stale adjective is gone from the abstract on B p. 1. The rebuilt PDF and changed TeX agree.
2. **A2 private-note `F_8` assertion: PASS.** The entire assertion and “formalization is pending” disclaimer are gone. B companion p. 5 now moves directly from Madison--Wu's published decomposition to Hollmann--Xiang's association scheme. No later argument in B names irreducibility, `F_8`, the private notes, or that pending formalization, so deletion leaves no dangling dependence.
3. **A3 q=13 trusted-execution exhaustion: PARTIAL / MINOR.** The central distinction is now accurate and explicit on B companion p. 7: “The exhaustive minimum-layer classification is proved structurally in Paper IV [10]” and the local replay “starts from its four explicit representatives ...; it does not replace the exhaustiveness proof.” That repairs the previous suggestion that the local replay itself exhausted all minimum words. A proof-mode inconsistency remains; see B concern 1 below.
4. **A4 stable finite-artifact locator: UNREPAIRED / MINOR.** B companion p. 12 still says “Its paths are relative to the present directory” and gives only `verification/verify_computational_companion.py`. No stable finite-bundle revision/DOI, toolchain/resource envelope, or expected top-level result was added.
5. **A5 series-planning language: PARTIAL PASS.** The repeated Paper II/III/IV/Golden catalogue and “unnumbered Golden quantum-statistics companion” are gone from B Paper I p. 4. B p. 2 still uses the unexplained Figure 1 label “conference companion,” but the figure is now the single architecture map and the prose states that no later construction is used. This is residual orientation cost, not a release blocker.
6. **A6 census novelty boundary: PASS with a copy regression.** B companion p. 1 now says “this companion does not claim priority for the bare number of projective classes.” That avoids claiming novelty for the fifteen-class count while identifying the certified census as the contribution. The new sentence contains the typography regression “at (q=11)”; see B concern 3.
7. **A7 ambiguous incompleteness pronoun: PASS.** B Paper I p. 7 now reads “The order-eleven six-arc is therefore incomplete,” which has the intended antecedent.
8. **A8 paired bibliography metadata: UNREPAIRED / MINOR.** B Paper I p. 29 still lists the computational paper as “companion manuscript, 2026,” while B companion p. 13 calls Paper I a “released manuscript, version 2, 2026.” Paper IV is likewise only “companion manuscript, 2026,” despite becoming the load-bearing source for q=13 exhaustiveness.

### Hostile-referee B audit

#### B concern 1 — MINOR: q=13 is correctly separated from the local replay, but assigned a proof mode that its own definition excludes

**B PDF locations:** computational companion pp. 7, 11, and 13.
**Quoted phrases:**

- p. 7: “The exhaustive minimum-layer classification is proved structurally in Paper IV [10].”
- p. 11: “A human structural proof is a complete argument in this paper or the geometric paper.”
- p. 11 table: “q = 13 minimum-word classification and reconstruction — human structural proof — Paper IV's complete proof”.
- p. 13 bibliography: “Paper IV, companion manuscript, 2026.”

The new p. 7 prose does exactly what it should: Paper IV owns exhaustive classification, while the local replay begins with Paper IV's four representatives and only regenerates/checks their orbits and profiles. The table, however, calls the imported Paper IV proof a “human structural proof” after defining that mode as an argument in this companion or Paper I (“the geometric paper”). Either extend the definition to named external companion proofs, or give Paper IV a distinct imported-proof mode. Because Paper IV is now load-bearing, its bibliography entry also needs a stable released locator/version; otherwise a reader of this pair cannot inspect the proof that replaces local exhaustion.

The reconstruction language is defensible only because B p. 5 says Paper IV supplies the standalone proof of the exact minimum distance and intrinsic reconstruction. The local sentence on p. 7, “It then forms all pair and triple concurrence profiles,” must continue to be described as replay/corroboration, not silently promoted to structural proof.

#### B concern 2 — MINOR: one abstract/introduction headline still lacks a numbered result

**B PDF location:** computational companion p. 1.
**Quoted phrase:** “There are fifteen projective classes of six-arcs over F11.”

The degree-three recognition headline maps to Proposition 2.1, the four-point gap to Theorem 2.4, unique q=11 to Theorem 3.2, the through-eight classification to Theorem 5.1, and the q=13 branch to Theorem 4.2. The bare fifteen-class census appears in Table 1 and its surrounding certificate proof, but no numbered proposition/theorem states it. Under the requested headline discipline, fold “exactly fifteen projective classes” into a numbered census/gap statement or remove it as a standalone abstract headline.

Paper I passes this check: its conic recognition, decoder reconstruction, orientation identities, integral order, and uniform field window all map to Theorem 1.1/Corollary 4.2, Propositions 6.1--7.3, Theorem 8.1/Corollary 8.2, and Theorem 4.4 respectively.

#### B concern 3 — MINOR regression: malformed math typography in new novelty sentence

**B PDF location:** computational companion p. 1.
**Quoted phrase:** “The certified fifteen-class census at (q=11)”.

This new phrase renders `q=11` as ordinary text inside literal parentheses. Use “at `q = 11`” with math typesetting; the parentheses add nothing.

#### B concern 4 — MINOR persistent release residue: artifact and paired-paper references remain unstable

**B PDF locations:** Paper I p. 29; computational companion pp. 12--13.
**Quoted phrases:** “companion manuscript, 2026,” “Its paths are relative to the present directory,” and “Paper IV, companion manuscript, 2026.”

There is no stale “forthcoming” wording left, and the deleted cross-paper bibliography entries no longer leave visible citation gaps. But the paired papers still describe one another asymmetrically, and the newly load-bearing Paper IV proof and finite replay directory have no stable locator. Normalize release status and add stable version identifiers before calling the pair archival.

### B headline and regression verdict

- **Abstract/introduction mathematical overclaim:** none. Every substantive headline except the bare fifteen-class count is backed by a numbered result with the same quantifiers.
- **q=13 structural/computational boundary:** conceptually repaired; one proof-mode-definition inconsistency remains.
- **Deleted `F_8` assertion:** clean removal, no dangling use.
- **Novelty/attribution:** no overclaim in B. The new non-priority sentence is appropriately bounded.
- **Stale forward references:** “forthcoming” and “unnumbered” residue removed. Unstable manuscript/release metadata remain.
- **New regression:** only the p. 1 “at (q=11)” typography and the proof-mode-definition mismatch exposed by the q=13 repair.

**B acceptance recommendation:** fix the two sentences on proof-mode scope and q=11 typography, put the fifteen-class count in a numbered result, and pin/normalize Paper I, the computational bundle, and Paper IV in the bibliographies. No mathematical rewrite or new computation is needed.

**B vibe check:** the substantive repair is good; the remaining defects are precise release-contract issues, not theorem failures.

**Targeted closure:** **MINOR residual** — latest companion p. 13 still says “Those retain the finite modes stated in Table 2,” although Table 2 now assigns Paper IV's q=13 minimum-word classification a human structural proof; otherwise Proposition 2.1 supports the fifteen-class headline, `q = 11` renders correctly, the local replay stays corroborative, and the 14-page flow is clean.
