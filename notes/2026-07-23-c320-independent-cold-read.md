# C320 independent cold read of Clebsch Paper I

**Date:** 2026-07-23  
**Reviewer posture:** user-launched independent referee; manuscript and public artifacts read before
the C320 ledger or Lean prose audit  
**Verdict:** **NO-GO**

## Scope and method

I first read `papers/style-guide.md`, then read
`papers/clebsch-hexagon-code/clebsch_hexagon_code.tex` linearly from the title through the
bibliography. I recorded the reactions below in reading order before consulting internal planning
or history. I then inspected the rendered 32-page PDF, the public README, statement extraction,
trust manifest, aggregate Lean gate, and selected load-bearing Lean theorem types and definitions.
Finally I audited the tracked public tree for workflow leakage and compared this independent
judgment only with `notes/2026-07-20-c320-clebsch-trust-ledger.md` and
`notes/2026-07-23-clebsch-paper-1-lean-prose-audit.md`.

This review did not modify the manuscript, formalization, manifest, evidence, or release scripts.
The paper tree was changing concurrently during review; the exact release-state finding below is
therefore intentionally phrased as a gate that must be rerun on the eventual frozen candidate.

## Prioritized findings

| Priority | Finding | Disposition |
|---|---|---|
| P0 | The headline geometric-parent recovery claim outruns its cited Lean terminal. The paper says a singleton decoration “recovers a Clebsch parent” (`clebsch_hexagon_code.tex:302-303,1550-1555`), and the manifest routes that clause as mixed with “six-profile compression and recovery” kernel checked (`verification/trust_manifest.json:1778`). But `ClebschGatewayQ11Matching.lean:10-13` explicitly says `Parent` is only a table-row index and that geometric identification is a separate obligation; the terminal `chosenPositiveSingleton_recovers_decoratedParent` merely applies injectivity of a frozen mate table (`ClebschDoubleCosetDepth.lean:221-227`). The manifest row supplies generic Dye/Edge/Jurrius--Pellikaan citations, not the missing row-to-geometric-parent bridge. | **Blocking.** Downgrade the claim to recovery of the displayed matching row, or add and route an explicit geometric reconstruction theorem/certificate with an audited correspondence. |
| P0 | The factorization-memory half does not reveal enough of its mechanism to support its headline scale. Central assertions are introduced as outputs of “finite decoders,” “exact matrices,” and “recovery maps” without defining the finite configurations or displaying the maps: especially (10.1), balanced uniqueness, the six profiles, and parent recovery (`clebsch_hexagon_code.tex:1488-1500,1536-1555,1589-1616`). A reader cannot reconstruct why the quotient points encode Coxeter matchings or how a singleton becomes a parent. This conflicts with the paper’s own claim that certificates merely support structures that explain the theorem (`:332-340`). | **Blocking manuscript issue.** Give one explicit B3 or H3 worked configuration, define the profile coordinates and parent map, and separate the conceptual implication from the exact finite hypotheses. |
| P0 | The Torsor Rosetta theorem asserts twelve semantic identifications, but neither its statement nor its proof defines most carriers or gives their comparison maps. Its proof reduces every row to “the finite calculation verifies” the same two-point action (`clebsch_hexagon_code.tex:1908-1965`). The generic torsor lemma is correct, but it proves only that *after* each semantic carrier is shown to bear the sign action, a marked equivariant bijection is forced (`:1877-1905`). That antecedent is the substantive content and remains opaque in the manuscript. | **Blocking.** Either move the twelve-row dictionary to a separately defined/certified theorem with a human-readable table of carriers, actions, and bridge evidence, or sharply narrow Theorem E to the transport lemma plus named, individually established applications. |
| P0 | The current public candidate was not a frozen releasable state during review. `verify_release.py` failed closed because the paper tree was dirty and the new `four_sheet_holonomy` bundle was untracked. After the TeX closing lines were restored concurrently, the source SHA-256 was still different from both `statement_adequacy.json:4` and `trust_manifest.json:6539`. | **Blocking release gate.** Freeze and commit the whole public bundle, regenerate statement/manifest hashes, rebuild the PDF, and obtain a clean full release replay. The independent post-fix review must use exactly that commit. |
| P1 | The four-sheet holonomy theorem enters abruptly from an undefined “admitted non-GRS pencil,” undefined coordinate covectors, and unexplained relation to the Clebsch reconstruction (`clebsch_hexagon_code.tex:1761-1805`). Its detailed proof is internally more informative than several headline proofs, but it has no setup, motivation, or consequence in the conclusion. | **Blocking for present paper shape.** Supply the pencil and bridge before the theorem and explain its role, or remove it from Paper I. |
| P1 | Headline Theorem A combines four results at different conceptual levels (`clebsch_hexagon_code.tex:251-270`). The manuscript gives a strong proof of A1, but no comparably locatable body proof of the full A2--A4 rank-three code law; the discussion visibly develops A3 and H3 while B3 and the split-torus/Legendre assertions are mostly trust-surface claims (`:1259-1355`). | **Blocking exposition/adequacy.** Add a theorem-proof section that states the reflection complements uniformly, includes B3, and derives length, distance, conic phase, and torus orbits with exact hypotheses. |
| P1 | “Statement adequacy” is currently statement extraction, not adequacy analysis. The JSON preserves TeX and hashes (`verification/statement_adequacy.json:1-13`), which is useful identity evidence, but it cannot detect the geometric-parent mismatch above or conditional theorems whose hypotheses encode the desired bridge. The appendix’s title and wording risk implying more (`clebsch_hexagon_code.tex:2212-2221`). | **Blocking trust-language issue.** Rename it “statement extraction/identity” or add a genuinely semantic adequacy layer that cites load-bearing definitions and bridge obligations. |
| P2 | The public README is stale and incomplete: it says the replays are cited in “Section 7” although verification is Section 13 (`README.md:3-5`), and it promises that an eventual immutable release will add success sentinels, runtimes, licenses, release identifiers, and an archive manifest (`:49-50`). No license file is tracked in this paper subtree. | Nonblocking for mathematics, blocking for archival release packaging. |
| P2 | The verification tables are legible but cramped in the PDF. Page 27 breaks long paths aggressively and page 28 is visually dominated by filenames. They function as an audit appendix, but a stable URL plus shorter semantic identifiers would read better. | Nonblocking layout repair. |
| P2 | The Hofstadter record-player paragraph (`clebsch_hexagon_code.tex:342-349`) is memorable but does not clarify the mathematical obstruction beyond the immediately preceding torsor language. It also changes register sharply. | Nonblocking; cut or compress to one sentence. |

## Reading-order notes

### Abstract and introduction (`clebsch_hexagon_code.tex:40-207`)

- The opening coding/arc dictionary is excellent. Lines 80--118 introduce syndrome weight,
  projectivization, arcs, secants, and uncovered points economically, and lines 120--128 give a
  genuinely useful three-row translation table.
- The abstract is too compressed to orient a reader outside the project. “Quotient
  configurations,” “factorization sheets,” “depth profiles,” “golden reduction,” theta signatures,
  and quantum equivalence arrive before the central construction is pictured (`:49-66`). The
  first paragraph is much stronger than the latter two.
- The novelty paragraph is scrupulous and unusually specific (`:177-206`). It is also long enough
  to interrupt the mathematical launch. Some classical-boundary detail belongs in related work or
  verification.
- The sentence distinguishing orientation torsor from support bipartition and unrelated meanings
  (`:146-156`) is an important scope control.

### Guided tour and headline blocks (`:208-350`)

- Figure 1 is the right organizing device. Its explicit warning that the arrows are not all linear
  quotients prevents a natural misreading (`:218-243`).
- Four large headline theorems in succession (`:251-324`) overload the reader before the objects
  are defined. Theorems B--D in particular use “Coxeter factorization sheets,” “depth plane,”
  “golden matching,” and “rational hinge” as if already established.
- The proof-division paragraph (`:332-340`) promises causal mechanisms. This became my standard for
  the rest of the paper; the rigidity half meets it, while the later finite-model half often does
  not.
- The Hofstadter paragraph is rhetorically conspicuous and mathematically dispensable.

### Clebsch code, decoding, and rigidity (`:351-943`)

- The displayed arc and invariant definition are well chosen (`:354-375`).
- Proposition 4.1’s orbit proof is dense but testable. The fixed-point ledger, stabilizer
  subtraction, and exhaustion of 133 projective points make the argument auditable
  (`:436-492`).
- The double count proving the uncovered locus has size 12 is one of the paper’s best proofs
  (`:502-527`). It cleanly separates incidence counting from the A5-orbit identification.
- The code consequences and complete syndrome oracle are concrete, useful, and properly derived
  (`:529-655`).
- The automorphism splitting argument at `:549-564` is concise; it would benefit from one phrase
  explaining why the unique determinant-one representatives multiply, but I found no mathematical
  error.
- The six-arc line bound (`:701-734`) is a particularly good mechanism proof: edge coloring gives
  the lower bound, and the impossible affine parallelogram case handles equality.
- The rigidity theorem’s conceptual implication is strong and clear (`:750-771`). The census is
  honestly isolated to the numerical gap (`:773-798`).
- The low-degree and perturbation results are correctly labeled computer-assisted and state their
  finite domains and acceptance criteria (`:817-827,922-934`).

### Support bipartition and the field boundary (`:945-1416`)

- Figure 2 and Proposition 6.1 make the synthematic/Petersen/Brianchon dictionary visible
  (`:955-1064`). This is another exemplary section.
- The support bipartition carefully distinguishes an intrinsic unordered split from an orientation
  (`:1082-1118`).
- The chord-defect identity (`:1131-1159`) efficiently explains why conic filling reduces to a few
  fields.
- The q=9 exclusion gives an honest three-step roadmap and clearly marks the cited Sylvester clique
  number (`:1181-1205`).
- The H3 coordinate bridge is explicit enough to audit (`:1266-1307`). In contrast, the ensuing
  “complete rank-three family” discussion does not develop B3 at the same level.
- The small-k theorem states exactly where exhaustive verification enters (`:1357-1413`) and leaves
  the k≥8 problem open without speculation (`:1415-1416`).

### Factorization, balance, and depth (`:1418-1616`)

- The canonical bracket scaling and Plücker identity are the core conceptual insight
  (`:1421-1446`). This is simple, memorable, and plausibly important.
- The paper correctly warns that the four-endpoint base does not imply unrestricted matching-graph
  connectivity (`:1435-1441`), and separates symbolic harmonic dimensions from finite image ranks
  (`:1457-1461`).
- Equation (10.1) is load-bearing but unexplained: “finite decoders on each sheet prove” an entire
  Hadamard-square hyperplane identity (`:1488-1499`). A reader needs at least the evaluation-space
  dimensions, the decoder statement, and why both inclusions hold.
- “The tensor moment is zero exactly when every multilinear shadow is zero” (`:1484`) needs a
  characteristic/degree qualification if intended beyond the degrees used here; polarization is
  harmless for degrees at most three in characteristics 7 and 11, but the sentence is written for
  arbitrary `j`.
- The six-profile section (`:1536-1555`) reports orbit sizes, profiles, ranks, and reconstruction
  but never displays the profile vectors or reconstruction map. This is where understanding should
  be expanded.
- The modular representation explanation at `:1557-1564` is promising. The proposition then
  introduces `R`, `M_G`, `π`, `N`, semi-invariant contraction, two relations, and divided transfer
  too abruptly (`:1566-1586`); the later appendix repeats rather than fully motivates it.

### Gluing, survival, holonomy, and Rosetta (`:1618-1966`)

- The split/inert lemma and mod-40 proposition are appropriately promoted from computations to
  short conceptual proofs (`:1621-1644,1727-1751`).
- The arithmetic-gluing “proof” (`:1672-1679`) is a certificate ledger, not an explanatory proof.
  It does not show how the literal groups or determinant comparison are constructed.
- The survival table is valuable because it puts retained, erased, and conditional passages in one
  place (`:1684-1709`). Several rows, however, introduce substantial mathematics absent from the
  body before the table.
- The four-sheet theorem and its calculation (`:1761-1875`) are self-contained only after assuming
  an undefined pencil. Its appearance is structurally surprising.
- The no-section lemma is correct and is the genuine Rosetta mechanism (`:1877-1905`).
- The twelve-row theorem then hides twelve bridge problems behind one generic lemma
  (`:1908-1965`). The number of rows is itself confusing: the colon-separated list mixes
  two-point carriers, an acting hinge, and a characteristic-zero specialization.

### Verification, appendices, conclusion (`:1968-2459`)

- The opening of verification architecture states the categories and repository split clearly
  (`:1971-1989`).
- The provenance/assistance disclosure is factual and appropriately places responsibility on the
  author (`:2029-2038`).
- The trust tables are honest about cited semantic boundaries, but “same paper trust gate” is not
  enough for a human reader to see which terminal proves which implication; the manifest is needed.
- The small-field census is compact and well captioned (`:2142-2170`).
- The Tate-plane appendix states the positive and negative results cleanly, but it presupposes a
  “frozen relative basis” and canonical maps not constructed in prose (`:2172-2210`).
- The adequacy appendix is useful as a route summary, but its machine artifact establishes textual
  identity rather than semantic adequacy.
- The conclusion accurately restates the intended conceptual chain (`:2257-2298`). Its confidence
  about decorated-parent recovery and all Rosetta carriers is precisely why the missing semantic
  bridges are blocking.

## Public-artifact and trust-boundary audit

### What works

- The manifest is clause-granular rather than theorem-granular. It records terminal names, axiom
  lists, artifact hashes, replay coverage, and residual trust.
- The aggregate Lean gate is explicit about what its literal finite checks do **not** identify
  (`lean/RelativeConicArcs/Gates/ClebschPaperTrust.lean:20-31`).
- Balanced-half uniqueness itself is adequately stated: the B3 theorem assumes annihilation and
  pointwise ±1 values and concludes the sheet sign up to negation
  (`ClebschBalancedSheetsB3.lean:333-342`).
- The public-tree scan found no `C320`, dated private-plan, handoff, `/home/...`, `/tmp/...`,
  Claude, or Codex reference and no suspicious notes/plan/handoff filenames. This agrees with the
  internal ledger’s leakage claim.
- The 32-page PDF has a professional, consistent layout; both diagrams are useful and readable.
  I saw no clipped text or broken float. The verification tables are the only notably cramped
  pages.

### Trust mismatch in detail

The formal source itself is admirably explicit:

> `Parent` below means a row index ... its decorated-recovery theorem recovers a table row, not a
> geometric parent.

That is `lean/RelativeConicArcs/ClebschGatewayQ11Matching.lean:10-13`. The downstream theorem says
only that if a row has the same `matchingMate` as row 0, injectivity makes it row 0
(`ClebschDoubleCosetDepth.lean:223-227`). The paper’s “Clebsch parent” is a geometric six-arc/projective
object, not a `Fin 22` row. Therefore kernel checking this terminal cannot establish the paper
statement until an explicit row-to-geometry equivalence is supplied. The public manifest’s cited
inputs for this clause do not name that equivalence.

The fixed-child theorem has the same conditional pattern. `FixedChildCertificate` includes an
equivalence from an arbitrary parent type to the 22-row index and compatibility of the outer action
(`ClebschTorsorRosetta.lean:97-107`); `fixedChildQuotient_is_t11` derives the 22=11+11 conclusion
from that certificate (`:126-141`). This is a valid theorem about a supplied certificate, but it
does not construct or validate the certificate for geometric Clebsch parents. The manifest does
attach a replay to the gluing clause, so this route may be repairable; the paper and manifest must
name the exact bridge rather than call the conditional consequence alone “full-trust Lean.”

## Comparison with the internal C320 records

The cold read agrees with the Lean prose audit’s praise for candid formal boundaries and its
criticism of layering. It independently reached the same concern at larger scale: the manuscript
often uses the formal audit vocabulary as a substitute for exposition.

The cold read disagrees materially with the C320 ledger’s final claim that no correctness mystery
remains. The ledger’s first-pass map correctly said singleton recovery must “separate unordered-pair
recovery from the additional decoration hypothesis,” but its final reconciliation treats
decorated-parent recovery as adequate. The inspected source proves only table-row recovery and
explicitly says the geometric bridge is external. This review therefore does not accept the
ledger’s completed checkbox for adequacy against load-bearing definitions.

The review also encountered a new four-sheet theorem/evidence bundle not reflected in the ledger’s
reported 27-statement/57-claim final state. The current extraction reported 28 statements and the
manifest 61 claims. That is not inherently wrong, but it means the prior clean-run and final-state
claims cannot certify the new candidate; a fresh frozen release and review are mandatory.

## Strengths

1. The rigidity theorem has a real conceptual proof, not just a census.
2. The projective-code dictionary and decoder consequences are exceptionally concrete.
3. The chord-defect identity and field-isolation argument expose why q=11 appears.
4. The Plücker/conic-ideal identity is a compelling central mechanism.
5. The paper is unusually honest about classical inputs, finite checks, and limits of claimed
   interpretations.
6. The public verification architecture is ambitious, clause-granular, and fail-closed.
7. The figures materially improve comprehension and the PDF is visually sound.

## Questions and openings

- What is the explicit functor or map from one of the 22 matching rows to a geometric Clebsch
  six-arc, and what proves its injectivity/surjectivity up to the claimed decoration?
- Can (10.1) be proved conceptually from an evaluation-code duality rather than only by frozen
  decoders?
- Is there a uniform definition of the A3/B3/H3 quotient configuration from which ranks 3,6,10
  and the conic phase follow, or are these three coordinated finite examples?
- Which exact twelve Rosetta carriers are genuine two-point `G`-sets, which are actions or
  specializations, and where is each sign-action bridge proved?
- Does the four-sheet holonomy theorem advance the factorization-memory reconstruction, or is it a
  companion-paper result?
- The paper’s final open question asks for an arithmetic/metaplectic origin of the gluing
  (`clebsch_hexagon_code.tex:2296-2298`). Before that, the more immediate paper-level opening is to
  construct the geometric parent bridge already claimed in Theorems C and D.

## Final decision

**NO-GO.**

The blocking findings are the missing geometric-parent adequacy bridge, insufficient manuscript
exposition for the balanced/depth reconstruction and twelve-row Rosetta claims, the unintegrated
four-sheet theorem, the underproved uniform rank-three headline, and the absence of a frozen clean
release state for the newly expanded candidate. I found no definite error in the rigidity/code
half, and I found substantial mathematical value throughout. The verdict is about the present
paper’s claim-to-proof correspondence and ability to transfer its mechanisms, not a judgment that
the finite calculations are false.

A post-fix review should begin from one committed paper-export hash, rerun the clean release gate,
and resample the exact parent-recovery and Rosetta bridge definitions before judging prose polish.
