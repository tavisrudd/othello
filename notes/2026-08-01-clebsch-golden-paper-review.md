# Clebsch + Golden manuscript group: editorial and mathematical review

**Date:** 2026-08-01
**Scope:** `papers/clebsch-hexagon-code/clebsch_hexagon_code.tex` (frozen fallback),
`papers/clebsch-rigidity/clebsch_rigidity.tex` + `clebsch_rigidity_computational_companion.tex`
(Paper I), `papers/clebsch-factorization/clebsch_factorization.tex` (Paper II),
`papers/clebsch-passages/` (Paper III), `papers/golden-operator/golden_operator.tex`.
All six .tex sources were read in full, in the order established by `papers/papers-index.md`
and the per-paper READMEs (mega-paper → I → II → III → golden). `papers/style-guide.md` read
before prose comments. Read-only review; no manuscript was edited. Line numbers refer to the
working tree as of this date (factorization and golden-operator have uncommitted modifications;
see the release note under each).

Verification claims (Lean gates, replay bundles, checksum manifests) were reviewed as *claims
architecture* — I checked internal consistency of what is asserted where, not by executing the
replays.

---

## 1. Paper I — `clebsch-rigidity/clebsch_rigidity.tex`

*Reconstructing the Clebsch code and its golden orientation from its deep-hole syndrome locus.*

### 1.1 Issues

Load-bearing items first.

1. **BBS partial-cover citation is the one unverified-by-me hinge of the headline window.**
   The upper bound `q ≤ (k(k-1)+3)/3` (abstract, and Theorem 4.3 = `cor:conic-filling-window`)
   rests entirely on "Proposition 1.5 of Blokhuis, Brouwer, Szőnyi" applied as
   `m ≥ 2q−1−(q+1)/2` for a partial line cover whose q+1 holes are the (noncollinear) conic
   points (clebsch_rigidity.tex:456–464). Every other step of the window I could verify by
   hand (passant count → q ≥ 2k−3; nucleus argument for even q; chord-defect algebra all
   check). This single citation carries the headline inequality: the exact statement and
   hypotheses of BBS Prop. 1.5 (what "holes" means there, whether the bound is
   ≥ 2q−1−h for h holes, and whether noncollinearity is the right side condition) must be
   verified against the source before submission, per the repo's own literature conventions.
   If it has been verified, the manuscript gives no sign of it; a one-clause restatement of
   the proposition in the proof would both fix that and help the referee.

2. **Hassett–Tschinkel Proposition 10 is used as an "exact converse."**
   Singular-locus completeness of the support cubic is transferred through "a
   trace-orthogonal determinantal cubic threefold has six ordinary nodes precisely when its
   dual cubic surface is smooth" (clebsch_rigidity.tex:1310–1315, 1407–1411). The proof
   deliberately routes around the CTZ coordinate match (good), so this citation is now the
   sole external input for node completeness. Same request as above: quote the proposition's
   hypotheses (which matrix spaces, which pairing, genericity assumptions) in the text. The
   replay independently checks the gradient-ideal exhaustion (clebsch_rigidity.tex:1420–1425),
   which mitigates but does not remove the citation risk.

3. **Notation collision: `A` is the arc and also an orbital adjacency matrix.**
   The arc is `A` from line 228 onward; Section 8 then sets "let `A` and `A'` be the
   adjacency matrices of the two five-valent orbitals" (clebsch_rigidity.tex:1045–1046) and
   uses `A(ω)`, `A−A'` (1128–1184) while the arc `A` is still live in the same paper. A
   reader landing in Section 8 will misparse `A'=AR`. Rename the orbitals (e.g. `N`, `N'`).

4. **Internal label/type mismatches invite citation errors — and have already caused one.**
   `\label{lem:chord-defect}` sits on a Theorem (line 272), `\label{cor:conic-filling-window}`
   on a Theorem (line 417). Harmless internally, but the companion cites the window as
   "[Theorem 3.2]" (clebsch_rigidity_computational_companion.tex:95) when it is actually
   **Theorem 4.3** of Paper I (Section 4 order: Lemma 4.1 line bound, Remark 4.2, Theorem 4.3
   window). The companion's "[Theorem 3.1]" for chord defect is correct. Fix the companion's
   cross-reference and consider renaming the labels.

5. **Minor proof-reading points, all checked and sound but worth a second look:**
   the `MAut(C) ≅ C10 × A5` splitting argument (708–722) is correct but compressed — the
   claim that determinant-one representatives' monomial lifts form a complement deserves one
   more sentence on why the lift map is a homomorphism; the `B² = 5I` pentagon verification
   (1170–1176), the determinant pencil `e6 − e4 + 5e2 − 125 − 2C` (1077–1079; I verified all
   principal-minor sizes via Jacobi), and the Hessian rank computation at the nodes
   (1322–1344) all check out.

### 1.2 Suggestions

- Promote the orientation two-graph theorem harder in the abstract's second paragraph: the
  identity `c_ijk = B_ij B_jk B_ki` plus the determinant-pencil identity is the most
  memorable single formula in the whole program and reads well boxed (1072, 1077). It is
  currently slightly buried under coding vocabulary.
- The paper is the natural citation target for the golden-operator paper's
  `support split ⇒ conference two-graph` step; make sure the statement of
  Theorem 8.2 (`thm:orientation-two-graph`) is phrased so the golden paper can cite it
  cleanly rather than reproving it (see §6.1 item 4 below).
- Conclusion (1472–1499) is good and ends mathematically, per the style guide. The two open
  problems are concrete. No change needed.

### 1.3 Exposition

Best-written manuscript in the group. The default opening sequence from the style guide is
followed almost exactly: object and inverse question in paragraph 1, dictionary set up with
minimal notation, main theorem by page 2, "What is new and what is not" paragraph
(197–213) that does the novelty accounting once and neutrally. The mixed audience
(finite geometry + coding) is handled with correct one-clause glosses. Two style-guide
frictions:

- The italic series epigraph "From deep holes, the cubic takes shape…" (48–52, repeated with
  different bolding in II and III) is charming but is exactly the kind of ornament the
  style guide's calm-tone rule warns about, and some journals will strike it. Keep it only
  if the target venue tolerates it; it should not survive into an IEEE-adjacent submission.
- The abstract's middle block (operator `B`, `B²=5I`, "shadow" language at 66–78) uses
  series vocabulary ("stands fixed while its shadows move") that a cold reader has no
  anchor for; "two presentations of the same intrinsic signed two-graph" is the load-bearing
  clause and could open that block.

### 1.4 Grade

- (a) Mathematical content: **A−.** A genuinely clean inverse theorem with a fully
  conceptual proof (census demoted to the companion — a major improvement over the
  mega-paper), a universal identity, a sharp two-sided window, and a surprising bridge to
  the six-nodal cubic threefold and Z[√5]. Held below A only by the two load-bearing
  external citations (items 1–2) not yet visibly verified in-text.
- (b) Writing/exposition: **A−.** See above; near style-guide-exemplary.
- (c) Readiness to submit as-is: **B+.** Mathematically submit-ready after items 1–4;
  the remaining blockers are the repo's own release gates (archive locator, provenance
  policy) rather than content.

### 1.5 Venues

- **Fit:** Designs, Codes and Cryptography; Finite Fields and Their Applications. (Matches
  the planning doc's own ruling; the coding/geometry mix is exactly DCC's remit.)
- **Reach:** JCTA (the rigidity theorem and two-graph section are attractive enough; length
  is fine); Combinatorica is a stretch given the single-field focus.
- **Safe:** Journal of Geometry; Innovations in Incidence Geometry.
- arXiv: math.CO primary, cross-list cs.IT and math.AG (for the cubic threefold section).

---

## 2. Companion — `clebsch_rigidity_computational_companion.tex`

### 2.1 Issues

1. **Wrong cross-reference into Paper I** (Theorem 3.2 → should be 4.3), companion line 95;
   see §1.1 item 4.
2. **The q=13 weight-eight exclusion is labeled a "human structural proof" but is really a
   hand-executable computation.** The order-14 orbit adjacency table (443–453) and the
   five-row four-clique closure (456–464) are "direct substitution" results; a referee will
   want either the substitutions displayed for one row or an explicit pointer that these two
   tables are certificate-checked (the trust table row at 766–767 says "human structural
   proof — Segre reduction and the five-row unique closure", which slightly overstates the
   human share). Recommend re-labeling that row "human reduction + finite table" or moving
   the tables' verification pointer inline.
3. **The weight-ten exclusion is a pure disjointness certificate** over ~1.7×10⁸ supports
   (469–497) with an independent DP replay — correctly labeled. Fine, but the prose
   "compact syndrome certificates" undersells the trust structure: say in one sentence that
   this is the only distance claim resting wholly on certificate mode.
4. The q13 minimum-word section is the strongest new mathematics here and the
   mod-two association-algebra span proof (525–567) is elegant and correct
   (I verified the `A0² = I + A9 + A10 + A12` ⇒ injectivity of `B=A9` on `ker A0` step).
   The four-anchor rigidity argument (569–597) is sound. No issues beyond density.

### 2.2 Suggestions

- The passant-code theorem (`[78,36,12]₂`, 364 minimum words, reconstruction with full
  PGL(2,13) symmetry) is strong enough that burying it in a "companion" wastes it. Two
  options: (i) extract Section 4 as a short standalone paper for DCC/FFA (it cites Madison–Wu
  and Hollmann–Xiang and would be read by that community); (ii) if the companion stays a
  companion, advertise this theorem in Paper I's introduction with one sentence, which
  currently mentions only "an exact q=13 binary incidence-code theorem" (Paper I 211–213).
  I recommend (i) — it is the only result in the whole group with a self-contained classical
  coding statement and no Clebsch dependency.
- The companion's framing ("restated to make every dependency explicit", 79–81) is good
  practice and should be kept.

### 2.3 Exposition

Well organized; the five-mode trust taxonomy (728–742) is the clearest verification prose
in the group and could be the template for the other papers. Table 1 duplicated from the
mega-paper is fine here. Minor: the census table's C14 pair "23/(9,10)" breaks the
`xy/uv` two-digit convention (companion 185; same in mega-paper 871) — say "digits ≥ 10
parenthesized" in the caption.

### 2.4 Grade

- (a) Mathematical content: **B+** (the q13 code theorem alone would be B+/A−; the rest is
  competent finite classification).
- (b) Writing/exposition: **B+.**
- (c) Readiness: **B+** — fix the cross-reference; otherwise ready as a companion.

### 2.5 Venues

As a companion: arXiv ancillary to Paper I (math.CO). If Section 4 is extracted: DCC or
FFA (fit), Advances in Mathematics of Communications (safe), JCTA (reach).

---

## 3. Paper II — `clebsch-factorization/clebsch_factorization.tex`

*Quadratic trade rigidity and cubic orientation in conic matching quotients.*

### 3.1 Issues

1. **The Lucas-socle lemma (Lemma 3.3, clebsch_factorization.tex:448–796) is still the
   referee bottleneck of the series, but its proof is now well structured.** Outer-parity
   vanishing goes through a torus-weight decomposition φ = φ₊+φ₋ at weights ±(q−1)
   ((3.2c₄), :615), a root-defect factorization D(t) = (t^q−t)B(t) with B(t) = β₊u_S(t)
   ((3.2c₅)–(3.2c₆), :625–636), and an explicit 𝐆-map Θ on S⊗L(1)⊗L(1)^{(e)}
   ((3.2c₈)–(3.2c₁₀), :654–705) that reduces the finite-group parity question to
   algebraic-group Homs; detecting modules are then excluded by tilting and highest-weight
   arguments, with the branch S = L(q−7) handling the transitive-dihedral (full nonsplit
   normalizer) stabilizers at q ≡ 3 (mod 4), e > 1 (:889–910). A proof-roadmap paragraph
   (:508–516) and a case-tree table (:1024–1044) orient the reader. My spot-checks pass:
   the weight bound 3q−7 < 3(q−1) forcing j ∈ {±1} for odd parity; the cocycle identity
   for D(t) and the two-step degree argument giving B(t+a) = B(t)u_S(a); the Y₁ weights
   (q+1, q−1, 1−q, −q−1) with Θ(C−B) = φ; and the tilting exclusion of the two-digit
   candidates for the prime-field detectors. Residual asks: the L(q−7) exclusions
   (:720–755, especially the p = 3 tilting-T(3) branch) are the hardest new paragraphs and
   each deserves one displayed intermediate step; and the lemma at ~350 lines merits its
   own subsection and a worked small-q example.

2. **Typo in a displayed equation:** `\quad` missing its backslash, twice, inside
   (3.2c₇) (clebsch_factorization.tex:650) — will typeset "quad" in math italic
   mid-display. Whatever template produces these displays has generated this error class
   before; grep for `,q?quad` at the build gate.

3. **Notation collision:** `L` is the affine evaluation space (:806 and throughout §4)
   while `L(c₀,…)` denotes the restricted simple modules throughout the Lucas lemma
   (:448–796). In a lemma whose content is Hom(L(…), Sym²F) versus trades on L, this is
   unkind. Rename the evaluation space (e.g. `𝔏` or `E_Ω`).

4. **Uncommitted working-tree state.** The manuscript and its verification JSONs are
   modified but uncommitted, while the paper prints a pinned evidence fingerprint. The
   statement identity and fingerprint must be regenerated, and the PDF rebuilt, before any
   release claim is made for the current wording.

### 3.2 Suggestions

- The **balanced-orbit completeness theorem (Theorem 3.5)** is the paper's real headline —
  an all-q classification, not a two-example study — and the abstract leads with it
  correctly. But the introduction's mechanism paragraph (§1) still narrates the paper as
  "quotient → sheets → cubic", relegating completeness to its three-row table. Restructure the intro
  around: (1) completeness classification, (2) recovery/orientation for the two survivors,
  (3) Gorenstein duality. That is also the order of decreasing novelty.
- The Gorenstein/self-association section (§4 end) is a self-contained gem: the
  maximal-isotropy proof of the perfect pairing is short and slick, and the
  connection to the self-dual-code criterion of Rodríguez-Pajares et al. is
  well placed. Consider promoting Corollary 4.6 (`self-associated arithmetically
  Gorenstein, inverse system = cubic line`) to a named theorem; commutative algebraists are
  a real secondary audience and will search on those keywords.
- Appendices A–E are honest about being decoration-relative (the appendix preamble states the
  boundary well). Appendix E (Tate plane, [2,9,1] vs [2,8,1] non-gluing) is the most likely cut if a
  journal asks for length: it defends a boundary rather than proving a headline.

### 3.3 Exposition

The abstract violates the style guide's layering rule: "one-dimensional strength-two trade
space with two-valued generator", "Frobenius-digit criterion", "the only missing Fischer
layer is `Q𝓗₂`" (:48–66) are all first uses with no gloss; a DCC/JCTA reader gets no
foothold until §2. Each needs a one-clause operational gloss or deletion from the abstract
("a five-dimensional radial layer" instead of "Fischer layer Q𝓗₂"). The body is better:
the three-layer roadmap in §1 is good, and proof-mode paragraphs before each theorem
are a genuinely good pattern other computer-assisted papers should copy. The middle of the
paper remains its densest stretch; see item 1.

### 3.4 Grade

- (a) Mathematical content: **A−.** The completeness theorem is the strongest single
  theorem in the group after Paper I's rigidity theorem, and the machinery (defining-
  characteristic permutation modules replacing search) is the right proof. The Gorenstein
  chapter is a bonus with independent appeal.
- (b) Writing/exposition: **B+.** The proof restructure, roadmap paragraph, and case-tree
  table have removed the worst of the density; the abstract jargon and one typo class
  remain.
- (c) Readiness: **B.** Close: remaining blockers are the notation rename, the `\quad`
  typo, the evidence re-freeze/commit, and the intro reordering of §3.2.

### 3.5 Venues

- **Fit:** Journal of Algebra (modular rep theory + invariant theory mix); Algebraic
  Combinatorics.
- **Reach:** JCTA; Transactions AMS is unrealistic for the scope.
- **Safe:** Communications in Algebra; Journal of Pure and Applied Algebra (the Gorenstein
  material helps here).
- arXiv: math.RT primary, cross math.CO, math.AC.

---

## 4. Paper III — `clebsch-passages/` (driver + sections/)

*Arithmetic and harmonic realizations of the Clebsch cubic.*

### 4.1 Issues

1. **The paper's own ledger says NO-GO; the prose reads as finished.** The queue/index
   record (papers-index.md:88–95) lists the Clebsch inclusion and the local fibre
   comparison as *open proof gaps* and the release bundle as not self-contained, verdict
   "NO-GO for submission". The manuscript text, however, states the corresponding steps as
   proved-by-citation: `V_t = U_t^⊥` with "The polarization identity and Hitchin's
   description give" (sections/02-orientation-cover.tex:149–153), and "the local comparison
   proves that this morphism carries ν⁻¹([xyz]) isomorphically onto the golden incidence
   fibre" (02:160–162). The verification section does disclose that "the global incidence
   and Stein identifications, scheme-theoretic chart correspondence, geometric golden-fibre
   identification … remain human inputs" (08-verification.tex:38–41), but a reader of the
   main text cannot tell which of those human inputs are *verified citations* and which are
   *unclosed gaps*. Until C680 closes them, the body must mark them (e.g. "we use Hitchin's
   statements X and Y, whose hypotheses we have verified against [HitchinIcosahedron §§…]" —
   or an explicit standing-assumption box). This is the single blocking issue for the paper.

2. **Heavy, load-bearing reliance on precise readings of Hitchin.** The square-class
   theorem needs, from the sources: the degree-2 generic cover (Chern number 2), branch
   divisor = {J₀=0} irreducible, the chart restriction ι*J₀ = 16σ₃² in the pinned
   normalization of J₀, and the two-configuration classification over [xyz]
   (02:169–231). The normalization dependence is acute — the constant `c=5` is exactly a
   square-class statement, so any factor-of-square slip in the J₀ scale would be
   invisible; the paper handles this correctly by evaluating at the etale point
   (02:222–231), and the normalization citation is pinned to the exact displayed formulas
   in Hitchin. What remains is verifying those pinned readings against the source, which
   is the C680 closure.

3. **The relative orientation theorem is hedged into near-unfalsifiability.** Theorem 1.2
   (`thm:orientation-source`) compares two orientation torsors "relative to" a marked
   bridge datum 𝔪 comprising: axis order, five plane-triple labels, a normalized lift,
   Petersen labels (01:70–99). The ambiguity ledger (03:134–172) is admirably complete, but
   the residue of actual content — after everything that is "not asserted" (sheet does not
   determine 𝔪; no polynomial identification; no descent claim for the inputs) — is thin:
   essentially "with all labels fixed, deck exchange flips all three signs coherently."
   That is worth recording, but it is a proposition-level fact dressed as one of three main
   theorems. Recommend demoting it to a proposition and re-centering the paper on Theorems
   1.1 and 1.3 (which is what the abstract's own README summary already does).

4. **Mathematical checks that pass:** the quadratic pinching lemma (02:74–97) is correct
   and nicely self-contained; the spinor computation θ(R)=2 via two reflections
   (04:102–123) is right (R = s_{e₂}s_{e₂−e₃} on the yz-plane, Q(e₂)Q(e₂−e₃)=1·2); the
   Gram-determinant six-arc proof (04:32–51) checks; the Petersen kernel matrix
   `K = (196I + 47J − 112A)/243` and the eigenvalue bookkeeping in degree six
   (05:57–97) check against P₆(1)=1, P₆(1/3)=47/243, P₆(√5/3)=−65/243; the
   `Hom_{SO₃}(H,𝓗₆)=0` no-covariant argument (05:119–129) is correct and a good
   scope-boundary. The Gaunt factorization 784000/1247103 = (400/46189)(1960/27) is
   arithmetically consistent (46189 = 11·13·17·19).

### 4.2 Suggestions

- Re-scope as a **two-result note**: (A) the rational square class 5J₀ with the golden
  fibre and spinor specialization; (B) the degree-six Petersen/Gaunt restriction. Both are
  clean, citable, and provable to current standards once item 1's citations are pinned.
  Move the marked-bridge comparison into a remark/proposition with its ambiguity ledger in
  an appendix. This matches the "cut to a seven-page two-theorem note" decision already
  recorded in the index; the current text still carries more relative-orientation apparatus
  than that decision implies.
- The bond-order/Steinhardt connection (01:190–207, 05:180–207) is the note's best hook for
  a broader readership (the q₆/W₆ invariant is genuinely famous in soft-matter physics);
  one more sentence saying *what the reader can now do* with the exact restriction (e.g.
  exact icosahedral W₆ values with provenance) would earn its place.

### 4.3 Exposition

The prose is the most defensive in the group — a large fraction of sentences state what is
*not* claimed (abstract 60–64; 01:133–139; 03:169–172; 04:56–59, 144–148; 09:25–32).
Each individual disclaimer is justified; collectively they invert the style guide's
hierarchy rule: boundaries get more rhetorical weight than results. Consolidate the
non-claims into one scope paragraph in the introduction and one ambiguity appendix, then
let the theorems speak. The abstract also displays a raw integral with an ungainly
constant as its centerpiece — good for precision, but lead with what it *means* (the
classical degree-six bond-order observable restricts to the Clebsch invariant exactly).

### 4.4 Grade

- (a) Mathematical content: **B−.** Two genuine but modest results plus one heavily
  relativized comparison; the central arithmetic input is imported from Hitchin, with the
  paper contributing the square-class bookkeeping, the pinching/descent explanation, the
  spinor class, and the exact harmonic constant.
- (b) Writing/exposition: **B.** Locally careful, globally over-hedged.
- (c) Readiness: **C.** The project's own verdict (NO-GO) is correct: citation gaps
  (item 1) and a non-self-contained release bundle block submission.

### 4.5 Venues (post-closure)

- **Fit:** Archiv der Mathematik or Comptes Rendus Mathématique (short-note formats that
  accept a two-theorem arithmetic/geometry note); Journal of Algebra (short section).
- **Reach:** Michigan Mathematical Journal; Épijournal GA is a stretch.
- **Safe:** JP Journal-tier venues are beneath it; Rocky Mountain JM or Involve-adjacent
  would be safe but under-place result (A).
- arXiv: math.AG primary, cross math.NT (square class), math-ph (harmonic part).

---

## 5. Golden paper — `golden-operator/golden_operator.tex`

*The golden conference operator and its shadow sisters.*

### 5.1 Issues

1. **The new six-node cubic-wall corollary (uncommitted) restates Paper I's node theorem
   without citing it.** The uncommitted `cor:golden-cubic-wall-nodes` proves, for each
   sister, that Sing{Z_T = 0} is exactly the six ordinary double points [𝟏−6e_i], with an
   exact-saturation/Hessian proof and a Milnor-total-saturation remark via Dolgachev.
   That is the same six-node statement as Paper I's Corollary 8.3
   (clebsch_rigidity.tex:1093–1112), reached by a third route. Cite the relation, as the
   paper already does for the two-graph import (golden_operator.tex:748); the redundancy
   is then a feature — three independent proofs of node completeness across the program,
   further insulating the Hassett–Tschinkel exposure flagged in §1.1. The new Dolgachev
   bibliography entry is also arXiv-number-only while the rest of the bibliography
   carries journal data.

2. **Verification-surface sync.** The manuscript's description of the Lean gate's
   coverage predates the completed Golden proof spine (the sharded
   `GoldenMatchingJacobian*` files), so it now understates the formal surface; and the
   verification supplement must be re-frozen for the uncommitted corollary before any
   release claim.

3. **Verified spot-checks that pass:** Z_T = ±10√5 det B_T from 16Z² = (2√5)⁶ det B²
   (proof of Theorem 2.3(iii)); the frustration equivalences and the Gram identity
   RRᵀ = 12(I − J/6) (Theorem 3.2); S₁₀² = 9I from G² = 12G (Corollary 3.3); the
   e₅(Z) = 32·Vandermonde scalar and the product identity ∏(Z_T+Z_U) = −e₅(Z)³
   (anomaly-inverse proof); the Hom-dimension characters in `thm:unmarked-boundary`; and
   the primitive-kernel cofactor lemma. The collision-filtration appendix's chart
   identities were not re-expanded but have plausible unit-prefactor structure and are
   declared certificate-checked.

4. **Scope discipline is good.** The README's forbidden-claims list (no gauge theory /
   topological qubit / positive dimer function) is respected in the text, physics
   material is framed as "instruments" and "transport", and the classical prior art
   (Costa–Dobrescu–Fox, Gripaios–Nguyen) is cited as owning the anomaly parametrization.
   The claimed contribution boundary — marking compatibility, exact Slater cost, Pfaffian
   normalization — is stated correctly.

### 5.2 Suggestions

- The paper needs an **audience decision** more than any other edit. As written it walks
  through invariant theory (HMSV/Joubert), commutative algebra (MCM modules), GIT (Luna
  slices), design theory (ETF), and physics-adjacent instruments. Two viable shapes:
  (i) a mathematics paper for SIGMA/J. Algebra centered on Theorems 2.3 + 2.4 + 3.2
  (propagation, quotient geometry, frustration/Naimark) with the anomaly section compressed
  to one application subsection; (ii) two papers, splitting the anomaly/Slater material
  into a short math-phys note. I recommend (i): the anomaly section's genuinely new content
  (marking compatibility + exact cost + Fano realization) fits in 4 pages.
- Consider titling down. "…and its shadow sisters" is memorable but signals whimsy;
  combined with the abstract's density it reads as inside-baseball. A subtitle naming the
  actual objects ("the order-six conference matrix, the Segre cubic, and marked matching
  quotients") would help editors triage it.

### 5.3 Exposition

The abstract now names the object plainly, sequences the results, and points to the
provenance papers; remaining gloss debt is modest ("coherent outer S₆-marking" and
"Naimark–Gram construction" could each take a one-clause gloss). The introduction's
"separates propagation from provenance" organization is good, and the marking-necessity
paragraph now sits up front where it belongs. The middle sections still assume the
six-point yoga (duads/synthemes, outer S₆) without a single figure; one diagram of the
X ↔ 𝒯 outer duality with the six sisters would pay for itself. The Verification and
scope section is well done.

### 5.4 Grade

- (a) Mathematical content: **B+.** The unifying propagation theorem, the marked-lift
  uniqueness, the frustration/Naimark chain, and the reconstruction boundary are a real
  contribution; but a substantial fraction of the paper is expert reassembly of classical
  material (Joubert coordinates, Segre–Igusa duality, Fano components, Cayley two-graph
  facts) with the novelty living in the *coherence* of the assembly.
- (b) Writing/exposition: **B.** Remaining debts are the missing figure, modest abstract
  glosses, and the whimsical title.
- (c) Readiness: **B−.** Remaining: the audience/venue decision, the Paper I citation on
  the new node corollary, and the verification re-freeze for the uncommitted text.

### 5.5 Venues

- **Fit:** SIGMA (eclectic symmetry papers are its remit; length fine); Journal of Algebra
  (if refocused on §§2–3).
- **Reach:** IMRN / Algebra & Number Theory — unrealistic in current shape; JCTA possible
  if the design/ETF thread is promoted.
- **Safe:** Linear Algebra and its Applications (conference-matrix/ETF framing); Journal of
  Algebraic Combinatorics.
- arXiv: math.CO or math.RT primary, cross math.AG, hep-th only if the anomaly section
  survives (I'd advise against the cross-list; it invites the wrong referees).

---

## 6. Mega-paper — `clebsch-hexagon-code/clebsch_hexagon_code.tex` (preserved fallback)

Read in full as the group's ancestor. Its rigidity/decoding first half is the source of
Paper I nearly verbatim; its factorization/torsor second half was correctly judged
overloaded (the survival table at 2044–2067 and the torsor Rosetta theorem at 2295–2384
are ledger-prose, not paper-prose, and the four-sheet holonomy theorem (2143–2262) sits in
no community). The split into I/II/III + golden is the right decision and has demonstrably
improved every inherited section (compare the census-dependent rigidity proof here
(771–821) with Paper I's fully conceptual one). Two administrative notes:

1. If any split paper publishes, the mega-paper must never be posted publicly in parallel —
   large verbatim overlaps (e.g. the A₅-orbit proof, 444–512 here vs Paper I 635–700)
   would constitute duplicate publication. Its README should state "superseded for
   publication purposes; retained as internal evidence surface only" (the papers-index
   already says this; the paper's own directory README does not).
2. No further editorial effort should go into it. Grade for the record: content B+
   (aggregate), writing B− (overload), readiness N/A (fallback, frozen at 5a82e80d).

---

## 7. Cross-group findings

### 7.1 Issues spanning papers

1. **Cross-reference drift between the papers.** Companion → Paper I theorem
   number wrong (§2.1.1). With the series
   marketed as I/II/III, referees will read them together; a pre-submission pass that
   greps every `\cite{Rudd…}` against the current titles/numbering is cheap and necessary.
2. **Shared-notation table absent.** Across the group: `C` = code (I) vs conference matrix
   (golden); `B` = signed operator (I) vs sign matrix (golden) vs second-moment form (II,
   line 1431); `Ω` = conic points (I §8) vs matching orbit (II); `A` overloaded within
   Paper I itself. Since the papers cross-cite, a half-page notation concordance in each
   introduction (or at least consistent renaming of the §8/golden operators) would prevent
   real confusion. Priority: fix the within-paper collisions (I: `A`; II: `L`).
3. **Series independence claims are accurate but under-explained.** Each README says "the
   shared progression is expository; this manuscript is logically independent." True on
   inspection (II uses only I's *problem*, not its theorems; III uses neither; golden takes
   provenance only). One sentence *in each paper's introduction* saying exactly this would
   preempt the referee question "do I need to read the other two?"
4. **The same two-line epigraph appears in I, II, III** with rotating boldface. As a series
   device it is cute; as a submission artifact it will read oddly when the papers land at
   different journals at different times. Decide once whether it survives.
5. **The verification-prose gradient is inconsistent.** Companion has the best model (five
   named proof modes, atomic-claim table). Paper II's is good; Paper III's is candid but
   forces the reader to diff prose against the verification section to find the true trust
   state (§4.1.1); golden's is adequate. Recommend porting the companion's five-mode
   taxonomy verbatim to III and golden.
6. **Freshness of frozen evidence.** Two of the five active manuscripts are modified in the
   working tree while embedding pinned digests of their own normalized sources
   (factorization 2792–2816; golden per its verification/ directory). This is expected
   mid-task, but the review flags it because both papers *print* their fingerprints in the
   PDF: any submitted PDF must be rebuilt after a re-freeze, or the printed digest will be
   provably wrong.

### 7.2 What should move between papers

- Companion §4 (q=13 passant code) → standalone short paper (§2.2). Highest-value move
  available in the group.
- Paper II Appendix E (Tate plane) → cut or compress to a remark if length pressure arises;
  its content (a boundary non-identification) is also stated in prose at the end of
  Appendix C.
- Paper III's marked-bridge Theorem 1.2 → demote to proposition + appendix ledger (§4.1.3).

### 7.3 Ranking

**By mathematical strength:**
1. **Paper I** (rigidity + window + golden operator bridge — one clean inverse theorem with
   a memorable identity chain),
2. **Paper II** (the all-q completeness classification is the hardest theorem in the group;
   held back only by exposition risk),
3. **Golden** (a real unification theorem over largely classical substrate),
4. **Companion** (solid finite classification + one genuinely good coding theorem),
5. **Mega-paper** (aggregate content high but superseded),
6. **Paper III** (two modest results, key inputs imported).

**By publication-readiness:**
1. **Paper I** — submit after §1.1 items 1–4 and the repo's archive gates.
2. **Companion** — one cross-reference fix; ships with Paper I.
3. **Paper II** — the Lucas-lemma restructure has landed; remaining work is the commit
   and evidence re-freeze plus notation/gloss passes. Days, not weeks, from submit-ready.
4. **Golden** — the mandatory text repairs have landed; the audience/venue decision and
   supplement re-freeze remain, and it still ships best after Papers I–III are citable.
5. **Paper III** — blocked (NO-GO) on citation-closure of the Hitchin inputs and a
   self-contained bundle; correct to hold.
6. **Mega-paper** — not a candidate; keep frozen.

### 7.4 Nits (short list, no discussion)

- clebsch_factorization.tex:650 — `,quad` (missing backslash), twice in one display.
- clebsch_rigidity_computational_companion.tex:95 — "[Theorem 3.2]" → Theorem 4.3.
- clebsch_rigidity.tex:1045–1046 — orbital matrices named `A`,`A'` while `A` is the arc.
- Companion/mega census tables — C14 pair "23/(9,10)" breaks the two-digit `xy/uv`
  caption convention; document the parenthesization.
- clebsch_hexagon_code.tex:673 vs clebsch_rigidity.tex:594 — "each support(s) one
  weight-three leader" subject-agreement drift between the two copies; harmonize
  whichever survives.
- golden_operator.tex — the new Dolgachev bibliography entry is arXiv-number-only.
- Epigraph (I:48–52, II, III driver) — venue-dependent; decide once.

### 7.5 Summary verdict

The split of the mega-paper was the right call and has already produced one near-submission
paper (I) and one strong-but-underdressed paper (II). The group's characteristic risk is
not correctness — the trust architecture is unusually disciplined and every spot-checkable
identity I tested passed — but *load-bearing external citations asserted without visible
verification* (BBS and Hassett–Tschinkel in I; Hitchin's normalizations and classification
in III) and *exposition debt where the mathematics is hardest* (Paper II's Lucas lemma,
golden's abstract). Those are exactly the places a referee will push, and all are fixable
without new mathematics except Paper III's citation closure, which is already correctly
gated as C680.

---

# Follow-up (same date): headlines, titles, and optimal connection

## 8. Real headlines

For each paper: the sentence a well-informed non-specialist referee would actually repeat,
versus what the paper currently advertises.

### 8.1 Paper I (rigidity)

- **Presented headline:** the rigidity equivalence — abstract opens with it
  (clebsch_rigidity.tex:55–63) — followed by the operator material and then the window,
  which the introduction calls "the main general theorem" (174–176).
- **Actual headline (agree):** *"The deep-hole locus of a six-column MDS code over F11 lies
  on a conic if and only if the code is the Clebsch hexagon code — so nearest-codeword data
  alone reconstruct a classical configuration, its polarity, and its A5 symmetry, none of
  which were built in."* That is the right lede and it is led with.
- **Where the advertised order is wrong:** the *second* billing goes to the conic-filling
  window, but the window is the weakest of the paper's three pillars (a counting inequality
  hanging on one cited proposition). The strongest secondary result is the orientation
  two-graph theorem — decoder ambiguity recovers a signed operator with B²=5I whose
  triangle products are exactly the Clebsch diagonal cubic's coefficients and whose integral
  commutant is Z[√5] (1049–1112). A referee will remember "the decoder remembers the
  icosahedron's golden ring" far longer than a q-window. Swap the emphasis: rigidity first,
  golden operator second, window third-as-tool. The introduction paragraph at 163–171
  already has the right order internally; the abstract block at 65–78 and the "main general
  theorem" sentence at 174 do not.

### 8.2 Companion

- **Presented headline:** none — "Computational strengthenings" is a manifest, not a claim,
  and the abstract (companion:33–54) is a list of five results with equal weight.
- **Actual headline:** *"Through length eight there are exactly two projective MDS codes
  whose deep-hole locus is a full conic — the F5 frame code and the Clebsch code."* That is
  a complete classification statement and should open the abstract.
- **Buried lede, badly:** the q=13 passant-code theorem ([78,36,12]₂, exactly 364 minimum
  words, minimum layer reconstructs the incidence matrix and full PGL(2,13)) is the only
  result in the whole group with a self-contained classical statement a coding theorist can
  repeat with zero Clebsch context — and it sits as Section 4 of a companion whose title
  says "computational." This is the strongest argument for the extraction recommended in
  §2.2/§7.2.

### 8.3 Paper II (factorization)

- **Presented headline:** the abstract leads correctly with the completeness classification
  (clebsch_factorization.tex:48–52). Good.
- **Actual headline (agree):** *"Over every odd prime power, exactly two full projective
  matching orbits — B3/F7 and H3/F11 — have a one-dimensional two-valued quadratic trade;
  for those two, quadratic data recover the pairing sheets and the first surviving signed
  moment is a cubic that orients them."*
- **Where the machinery outruns the advertisement:** the intro's mechanism narrative
  (82–120) still tells the *old* two-example story (quotient → sheets → cubic) and
  relegates completeness to a three-row table (90–101); and the Gorenstein/inverse-system
  theorem — "the 14- and 22-point configurations are self-associated arithmetically
  Gorenstein with Macaulay inverse system the orientation cubic" (1807–1838) — is a
  headline-grade sentence for a commutative-algebra audience that appears only as
  Corollary 4.6. Both deserve promotion; the classification-first restructure in §3.2
  fixes the first, naming Corollary 4.6 a theorem fixes the second.

### 8.4 Paper III (passages)

- **Presented headline:** the square class — abstract sentence 1–2
  (clebsch_passages.tex:41–44). Correct choice.
- **Actual headline (agree, with a merge):** *"Hitchin's two-icosahedra incidence cover of
  harmonic cubics is the quadratic extension by √(5·J0) — the golden descent made exact —
  and the same Clebsch invariant σ3 reappears verbatim as the classical degree-six
  bond-order cubic on the icosahedral face axes."* The two theorems are stronger as one
  sentence than as two; the abstract currently separates them with the heavily hedged
  bridge theorem in between (48–55), which dilutes both.
- **Weaker than advertised:** the "relative marked orientation bridge" is billed as one of
  three main theorems (Theorem 1.2, 01-introduction.tex:101–135) but, net of its ledger of
  non-claims, its content is proposition-grade (§4.1.3). Demoting it *strengthens* the
  paper's perceived headline by removing the hedge cloud around the two clean results.

### 8.5 Golden paper

- **Presented headline:** the propagation theorem, correctly first in the abstract
  (golden_operator.tex:33–40) but phrased in vocabulary nobody outside the project holds.
- **Actual headline:** *"Every natural operation on the order-six conference matrix —
  middle exterior power, diagonal commutator, golden eigenspace splitting, adjugation,
  centered squaring — is a shadow of one universal matching quotient, and the unique extra
  bit needed to orient any signed shadow is a choice of support half."* That is
  Theorem 2.3 + Theorem 3.2(c–d) fused, and it is repeatable.
- **The best cocktail-party fact is hidden mid-paper:** Theorem `thm:frustration` — *C² = 5I is equivalent to every balanced 3+3 cut having maximum-determinant
  frustration, and the ten cut-signs then force the order-ten conference matrix and the
  real ETF(5,10) with no classification input* — is the single most quotable equivalence in
  the group for a general combinatorial audience, and the abstract gives it one clause
  (45–48). Give it a full sentence and a mention in the intro's first paragraph.

### 8.6 The group as one program

**Single best headline:** *"One small code remembers the icosahedron: the nearest-codeword
geometry of the [6,3,4]₁₁ Clebsch code reconstructs, layer by layer, the Clebsch hexagon
and its A5 symmetry, the golden conference operator with B²=5I, the Clebsch diagonal cubic
and the order Z[√5], the two-sheet matching factorization over F7 and F11 (provably the
only such fields), and — in characteristic zero — the √5 descent class of Hitchin's
icosahedral incidence cover and the exact degree-six bond-order invariant; and the papers
determine precisely which forgetting step erases which datum."*

The program's identity is **forgetting and memory across quotients** — which is literally
the title of the mega-paper's §2 ("A guided tour of forgetting and memory",
clebsch_hexagon_code.tex:210–250). That framing is currently stranded in the frozen
fallback. It should be resurrected as the connective paragraph in each split paper's intro
(see §10.2).

## 9. Titles

Format: current → **recommended** → alternative (different emphasis), with one-line
justification against §8's headline and the venue's conventions.

### 9.1 Paper I

- Current: *Reconstructing the Clebsch code and its golden orientation from its deep-hole
  syndrome locus.*
- **Recommended: keep it, minus one word: "Reconstructing the Clebsch code and its golden
  orientation from deep holes."** "Syndrome locus" is redundant with "deep-hole" for the
  DCC/FFA audience and the shorter form is stronger. The title already carries both
  headline pillars (reconstruction + golden orientation) — it is the best-calibrated title
  in the group.
- Alternative (phenomenon-forward): *"Deep-hole rigidity of a non-GRS MDS code: the
  Clebsch hexagon, its conic, and its golden two-graph."* Use if the venue prefers
  descriptive-list titles (J. Geometry style).
- No misrepresentation flag.

### 9.2 Companion (as companion)

- Current: *Computational strengthenings of Clebsch syndrome rigidity.*
- **Recommended: "Conic-filling arcs through eight points: exhaustive classification and
  numerical gaps."** Theorem-forward, names the actual classification headline (§8.2); the
  word "computational" in a title reads as an apology and buries the fact that the
  classification is *complete*.
- Alternative (if q=13 section is extracted, which I recommend): companion becomes
  *"Census strengthenings of Clebsch deep-hole rigidity"*, and the extraction gets its own
  title: **"A [78,36,12] binary code from the passant lines of a conic in PG(2,13)"** —
  parameter-forward, exactly DCC/FFA naming convention, instantly indexable.
- Flag: the current title actively undersells — "strengthenings" hides two complete
  classifications and a new code.

### 9.3 Paper II

- Current: *Quadratic trade rigidity and cubic orientation in conic matching quotients.*
- **Recommended: "Quadratic recovery and cubic orientation in conic matching quotients: the
  two balanced orbits."** Restores the earlier, clearer "recovery" (the registry still uses
  it, papers-index.md:79–80; "trade rigidity" is design-theory insider vocabulary that even
  JCTA readers will parse slowly), and the subtitle announces the completeness theorem —
  the paper's actual headline — which the current title omits entirely.
- Alternative (theorem-forward, aggressive): *"Balanced conic matching orbits exist only
  over F7 and F11."* Maximal memorability; use for a JCTA submission where a sharp
  classification title fits the house style.
- Flag: current title undersells — it describes the two-example phenomenon and is silent
  about the all-q classification that is the paper's hardest theorem.

### 9.4 Paper III

- Current: *Arithmetic and harmonic realizations of the Clebsch cubic.*
- **Recommended: "The golden square class of Hitchin's icosahedral incidence cover."**
  Theorem-forward, names the headline object and the answer (√5); short-note venues
  (Archiv, CRAS) favor exactly this shape. The harmonic theorem rides along fine — a note's
  title need not enumerate both results.
- Alternative (two-result, object-forward): *"Hitchin's incidence cover and the degree-six
  Clebsch invariant: √5 and the bond-order cubic."*
- Flag: "realizations" is vague to the point of unsearchability — nobody queries it, and it
  gives no hint that the paper computes a specific arithmetic invariant of a known cover.

### 9.5 Golden paper

- Current: *The golden conference operator and its shadow sisters.*
- **Recommended: "Shadows of the order-six conference matrix: the universal matching
  quotient and its marked lifts."** Keeps the paper's own good "shadow" metaphor but
  anchors it to a named object and the actual theorem (§8.5); SIGMA tolerates — even likes —
  a metaphor when the colon clause is concrete.
- Alternative (theorem-forward): *"One matching quotient: propagation and recovery for the
  golden conference operator C² = 5I."*
- Flag: "shadow sisters" without an anchor actively misleads — an editor cannot tell the
  field from the title alone, and even with the now-plainer abstract it invites
  desk-reject triage error. Of the five titles this is the one that most needs changing.

## 10. Optimal connection

### 10.1 (a) Mathematics: the correct dependency graph

**Recommended canonical graph** (A → B means B cites A for a stated theorem; dashed =
provenance only):

```
Paper I (rigidity, window, golden two-graph)
  ├──> Companion        (imports Thm 3.1, Thm 4.3, Thm 1.1; already explicit, companion:79–116)
  ├──> q13 paper        (extracted from companion §4; cites companion for the k=8 context)
  ├╌╌> Paper II         (provenance: the marked conic and its forgetting question; no theorem import)
  ├──> Golden           (imports Thm 8.2: support split ⇒ conference two-graph)
  └╌╌> Paper III        (provenance: the finite T11 torsor its √5 class explains)
Paper II ╌╌> Golden     (provenance: sheets/cubic as the finite shadow of the marked cubic line)
Paper III ──> Golden    (imports the golden fibre + exchanger as the characteristic-zero parent)
```

**Complete duplication inventory**, with the canonical home for each:

1. *Support split ⇒ C with C²=5I (two-graph construction).* Paper I Thm 8.2
   (clebsch_rigidity.tex:1049–1091) and golden Prop `support-two-graph`. **Canonical
   home: Paper I**; golden retains an independent orbit-parity proof and cites the
   intrinsic construction at golden_operator.tex:748 — the right settlement. The same
   pattern should be applied to the new node corollary (§5.1 item 1).
2. *C²=5I from the tight-frame/Gram mechanism.* Paper III re-derives it a third way
   (G=(t+2)I+tC, frame operator scalar ⇒ C²=5I, plus translation-invariance of Z_C;
   sections/03-orientation-source.tex:43–72). **Keep the Gram derivation in III** — it is
   genuinely the natural proof in that context and is three lines — but add "recovering the
   conference identity of [Paper I, Thm 8.2] from the frame geometry."
3. *Triangle-cubic Z and its translation invariance.* Defined independently in I
   (1055–1079), III (01-introduction.tex:82–99), and golden (140–142). **Canonical
   definition: golden** is the natural home of the abstract marked object (Def 2.1,
   golden_operator.tex:106–115), but golden ships last (§10.2), so: I keeps its concrete
   definition, III and golden cite I for the object and keep only their new structure
   (III: the marked source class; golden: the coherent outer family).
4. *The two-element sign torsor T11 = PGL2(11)/PSL2(11).* Appears as the sheet character
   (Paper II §4, det character at 1189, 2513–2517), the spinor class target (Paper III
   04-arithmetic-specialization.tex:87–123), and the support-half bit (golden
   Thm `recovery-propagation`(c), 705–733). No theorem is duplicated, but each paper
   re-introduces the object from scratch. **Golden should own the one-paragraph dictionary**
   (it is the program-closer; the mega-paper's Theorem `torsor-rosetta-close` at
   clebsch_hexagon_code.tex:2295–2384 is the raw material — compress it to a cited table,
   not a theorem).
5. *Matching-secant quotient proposition and split–inert lemma.* Mega §8/(D-section) vs
   Paper II Prop 2.1 and Lemma C.2 — no action; mega is frozen and unpublished.
6. *Chord-defect and window restatements in the companion* (companion:83–108) — correct as
   explicit restated imports; keep.
7. *Petersen/KG(5,2) dictionary.* Paper I Fig. 1 (839–898), Paper III's face-axis two-subset
   labels (05-harmonic-realization.tex:11–39), golden's duad–syntheme usage. Conceptual
   recurrence, not duplication; a shared sentence "we index by two-subsets of the five
   labels, as in [Paper I, Fig. 1]" in III and golden is enough.

**Self-citation state:** golden's bibliography carries Papers I–III as "preprint, 2026"
entries with the two-graph import cited inline; these become arXiv IDs at posting time
(§10.2). Paper III cites Dye but not Paper I even where it names "Dye's finite theorem
gives the complementary square-5 criterion" (01-introduction.tex:183–184) — acceptable:
III can stand on Dye alone.

**Is the split right?** Yes, with two amendments already argued: extract the q=13 code
paper (fifth unit), and keep III as a two-theorem note rather than merging it into golden.
Do **not** merge I+companion into one paper: the census/certificate mass would re-create
the mega-paper's overload, and the current human-proof/finite-proof separation is the
group's best structural feature. Do **not** split golden further: its anomaly section
compresses to an application subsection (§5.2); a standalone physics note would face
referees the disclaimers are designed to avoid.

**Foundational material to factor rather than restate:** nothing new needs writing. Paper I
is already the de facto foundations paper — the marked conic, the support bipartition, and
the golden two-graph all live there. The action items are pure citation hygiene: golden
cites I (item 1, missing-bib fix), III cites I in the frame remark (item 2), and the T11
dictionary lands once in golden (item 4).

### 10.2 (b) Story arc, order, and arXiv sequencing

**The through-line** — say it in every intro in one paragraph: *the program studies what
successive natural forgettings of one exceptional object retain.* The code forgets the
hexagon; Paper I proves the deep holes remember it, down to the golden operator. The conic
forgets the pairing; Paper II proves the quotient remembers the sheets and a cubic
remembers their orientation — and that F7, F11 are the only fields where this happens. The
finite picture forgets its characteristic-zero source; Paper III proves the orientation bit
upstairs is exactly √5 (and reappears in the classical bond-order invariant). Golden closes
the loop: all of these signs are shadows of one marked operator, and the *minimal* datum
that must be remembered is the unordered support two-graph. This is precisely the
mega-paper's stranded "forgetting and memory" frame (clebsch_hexagon_code.tex:210–250);
recycle its first two paragraphs (not its figure) into golden's introduction and one-line
variants into I–III.

**Submission/arXiv order (recommended, concrete):**

1. **Paper I + companion, same day** (they cite each other; both bibs already do:
   clebsch_rigidity.tex:1635–1638, companion:932–936 — replace "companion manuscript /
   working paper" with the real arXiv IDs at posting).
2. **q13 extraction**, one to two weeks later, citing both by arXiv ID. It is the group's
   ambassador to the pure coding-theory audience and benefits from landing while Paper I is
   fresh on listings.
3. **Paper II**, after its revision cycle (§3.4), citing I's arXiv ID (fixing the stale
   title at clebsch_factorization.tex:2929–2932 in the same pass).
4. **Paper III**, strictly after C680 closes the Hitchin citation gaps — posting it earlier
   with known-open verification rows would be the one move that could damage the group's
   credibility.
5. **Golden last.** It is the synthesis paper: it needs I (two-graph import), II (sheet
   provenance), and III (characteristic-zero parent) to exist as citable objects so that
   its provenance citations point at arXiv IDs. Posting golden last also lets its
   introduction legitimately tell the whole program story — which is where the group
   headline of §8.6 should appear in print.

**What each abstract/intro should say about the others** (one sentence each, at
submission time):

- *Paper I:* keep self-contained; add one forward sentence at the end of the intro's
  novelty paragraph (after clebsch_rigidity.tex:213): "The factorization retained by the
  conic quotient, and the characteristic-zero source of the orientation torsor, are
  treated in companion papers." No abstract change.
- *Companion / q13 paper:* already correctly positioned as dependents; abstracts unchanged.
- *Paper II:* one sentence in the intro (near clebsch_factorization.tex:80) placing the
  forgetting question as the sequel to Paper I's reconstruction ("the deep-hole conic of
  [I] forgets its parent; we ask what its ideal remembers"), which simultaneously repairs
  the series-independence opacity flagged in §7.1.3.
- *Paper III:* one sentence stating its role as the characteristic-zero source of the
  finite sign torsor of Papers I–II (this replaces the current unexplained appearance of
  T11 at 04-arithmetic-specialization.tex:96–99).
- *Golden:* its "propagation versus provenance" paragraph is already the right shape and
  the three provenance citations are in place; at posting time the "preprint, 2026"
  entries become the real arXiv IDs.

**Why this order maximizes force:** I lands as a clean single-theorem paper with no
dangling references; the companion and q13 papers convert its listing momentum into the
coding audience; II arrives as "the classification behind the phenomenon you just saw";
III arrives de-risked; and golden — the only paper whose value is *coherence* — is the one
paper that genuinely reads better when everything it unifies is already public. Every
citation then points backward, and no paper ever cites a "working paper."

---

# Follow-up 2 (same date): packaging the headline results

## 11. Packaging: surprise, beauty, de-risking — and the reconciled plan

### 11.1 Surprise / memorability

**The sharpest hook is not the program line — it is a formula.** "One small code remembers
the icosahedron" is the best *program* hook (it needs the whole arc to land). But the group
is sitting on a sharper single-artifact hook that needs no program and no coding theory:

> Let B be the (unique up to switching) 6×6 symmetric sign matrix with zero diagonal and
> B² = 5I. Then
> det(B + diag(x)) = e₆(x) − e₄(x) + 5e₂(x) − 125 − 2C(x),
> where C is the Clebsch diagonal cubic — and Pf[diag(x), B_T] = 4Z_T(x), where the six
> Z_T are the Joubert coordinates cutting out the Segre cubic.

One 6×6 sign matrix generates both famous cubics of classical projective geometry, one via
the odd part of a determinant pencil, one via commutator Pfaffians. Any reader can verify
it in a minute of computer algebra; it is memorable at the blackboard; and it is currently
*hidden* — the first identity sits mid-theorem in Paper I (clebsch_rigidity.tex:1077–1079,
boxed but inside a two-part Theorem 8.2 whose statement runs 40+ lines), and the second is
clause (ii) of a multi-clause theorem in golden. Paper I's abstract describes the
operator in words; golden's abstract names the three equivalent cubic forms — but
neither abstract displays the identity.

Other surprises currently buried in routine machinery:

- **The frustration equivalence** (C²=5I ⟺ every balanced 3+3 cut is maximum-determinant
  frustrated ⟺ pentagon of negative edges), golden Theorem 3.2 — the most repeatable
  fact for a pure combinatorialist, given one sentence in the abstract.
- **The Sylvester-graph kill of q=9** (a six-clique would be needed in the distance-two
  graph of the Sylvester graph, whose clique number is 5), companion:341–366 — the
  cutest step in the whole "why 11" story, invisible from any abstract.
- **The Paley remark** (cross-sheet incidence = complement of the Paley difference set;
  bordering gives the Paley Hadamard matrix), clebsch_factorization.tex:1069–1077 — a
  genuine "oh!" for design theorists, correctly a remark but deserving a sentence in
  Paper II's introduction.
- **The conductor-two degeneration** Z[√5]⊗F₂ ≅ F₂[u]/(u−1)² as "orientation collapse
  mod 2" (clebsch_rigidity.tex:1379–1389) — right-sized as a remark; no change.

**Verdict on the hook question:** keep "one small code remembers the icosahedron" as the
program narrative (golden's intro, talks, any survey), but make the conference-matrix →
two-cubics formula the *poster*: it hits first, travels alone, and drags the reader into
the program behind it.

### 11.2 Elegance and mathematical beauty

**Ugly-general in the headline slot, clean special case available:**

- Paper I's abstract *displays* the general window `2k−3 ≤ q ≤ (k(k−1)+3)/3`
  (clebsch_rigidity.tex:78–81). As a display, it is the least beautiful object in the
  abstract, and it is also the least safe (§11.3). The clean statement at k=6 —
  "|𝒰(A)| = 22 − #Brianchon points, so Dye's bound c ≤ 10 forces |𝒰| ≥ 12 = one conic" —
  is where the actual charm lives. Recommendation: abstract states the window in words
  ("a two-sided field window, quadratically widening in k"), displays nothing; the k=6
  chord-defect count can carry the abstract's arithmetic if a display is wanted.
- Paper II's classification hypothesis "one-dimensional strength-two trade space with
  two-valued generator" (clebsch_factorization.tex:48–52, 912–913) is the ugly-general
  phrasing of a clean fact: *the only full matching orbits that split into two equal
  sheets invisible to all quadratic statistics are B₃/F₇ and H₃/F₁₁.* Lead with the clean
  sentence; keep the trade-space formulation as the formal theorem.

**Coincidences stated as coincidences that are one structural fact:**

- **The sign torsor.** The sheet-exchange character of Paper II (det character,
  Paper II Theorem C.3), the spinor class [2] of Paper III's exchanger
  (04-arithmetic-specialization.tex:87–123), and golden's support-half bit
  (golden_operator.tex:705–733) are three appearances of the single torsor
  T₁₁ = PGL₂(11)/PSL₂(11). The unifying statement was *written and then cut*: it is the
  mega-paper's Theorem `torsor-rosetta-close` (clebsch_hexagon_code.tex:2295–2384). In
  its mega form it was ledger-prose; compressed to a half-page proposition-with-table in
  golden ("the following two-valued data are canonically isomorphic T₁₁-torsors: …"), it
  becomes the program's unification statement. This is the one currently-unwritten theorem
  the group most needs.
- **B²=5I four ways.** Pentagon holonomy (Paper I, clebsch_rigidity.tex:1158–1176), tight
  frame (Paper III, 03-orientation-source.tex:59–66), balanced frustration (golden,
  549–595), Paley circulant (Paper II remark). The structural fact is: *there is exactly
  one regular two-graph on six points, and every construction in the program factors
  through its switching class.* One sentence saying this, in golden's introduction with
  the four citations, converts four apparent coincidences into one theorem with four
  proofs — strictly more beautiful and costs three lines.

**The most beautiful single theorem extractable (not currently stated anywhere):** the
fused "golden rosetta" —

> *For the unique six-point regular two-graph, with any conference representative B:
> (i) the odd part of det(B + diag x) is −2 × the Clebsch diagonal cubic, whose six nodes
> recover the axes; (ii) the six commutator Pfaffians Pf[diag x, B_T] are the Joubert
> coordinates of the Segre cubic; (iii) the switching class of B is reconstructed by the
> decoder ambiguity of the [6,3,4]₁₁ Clebsch code; (iv) the two golden eigenspaces of B
> reduce mod 11 to the two matching sheets of the conic quotient, and their
> characteristic-zero choice is the square class √5 of Hitchin's incidence cover.*

Clauses live in Papers I, golden, I, and II+III respectively. Do **not** state it as a new
monolithic theorem (it would inherit the union of all trust exposures — see 11.3); state
it as golden's opening "Theorem A (program summary)", each clause tagged with its proof
location. That gets the beauty on the page without creating a new refereeing surface.

### 11.3 Referee and publication de-risking

Ordering results by trust exposure:

- **Zero-exposure (lead with these):** everything finite and replay-backed — the fifteen-
  class census, the k≤8 classification, the q13 code theorem (its only citations,
  Madison–Wu and Hollmann–Xiang, supply known facts the paper re-verifies by elimination,
  companion:405–411), the pencil/Pfaffian identities (kernel-checkable), the frustration/
  Naimark chain. The q13 extraction is the purest "cannot be argued with" paper available
  — it wins on all three axes simultaneously.
- **Low exposure:** Paper I's rigidity theorem — its one external input (Dye's Theorem 1)
  is classical, pinpoint-cited, and explicitly axiomatized in the Lean gate
  (clebsch_rigidity.tex:1466–1470). Safe in the headline slot.
- **Medium exposure:** the window (BBS Prop. 1.5, §1.1 item 1) and singular-locus
  completeness (Hassett–Tschinkel Prop. 10, §1.1 item 2). Neither should sit in a
  headline slot until verified. Two cheap structural mitigations: (a) stop calling the
  window "the main general theorem" (clebsch_rigidity.tex:174–176) — call it "a uniform
  field window"; if BBS ever fails to say what is used, only a secondary result needs a
  new proof and the paper survives. (b) For node completeness, the paper *already owns* an
  independent finite route (the gradient-ideal exhaustion) but demotes it to "an
  independent exact check rather than the proof of completeness"
  (clebsch_rigidity.tex:1424–1425). Flip that sentence: state completeness with *two
  independent proofs* (citation route and exhaustion route), so an objection to the HT
  reading cannot sink the theorem. This costs one sentence and removes the paper's second-
  largest single point of failure.
- **High exposure:** Paper III wholesale (Hitchin normalizations + C680 gaps) and, in a
  different way, golden's breadth (desk-reject risk from audience mismatch, not
  correctness). Handled by sequencing (III gated, golden last) and by keeping golden's abstract
  plain (§5.3).

**Split vs concentrate:** the existing split is already the de-risked configuration; every
further concentration move (merging I+companion, folding III into golden, one program
mega-paper) re-creates wholesale-rejection risk for no gain. The one remaining split that
pays is the q13 extraction. Do *not* move Paper I's §8 (two-graph/cubic) into golden to
resolve the duplication — Paper I needs its second pillar, and §8's exposure is contained
by mitigation (b) above; resolve the duplication by citation direction only (§10.1).

### 11.4 Reconciliation: the recommended packaging plan

The tension, stated plainly: the most memorable object (the two-cubics formula and the
fused rosetta) lives furthest from the safest papers; the safest results (finite censuses)
are the least memorable; the most beautiful statement (the rosetta) would, as a single
theorem, concentrate every trust exposure in one place. The plan below spends a little
memorability in Papers I–III to keep them maximally safe, and concentrates all program-
level flash in golden — the paper whose value *is* synthesis and which ships last, when
every input is public and citable.

Paper-by-paper headline slots:

1. **Paper I.** Headline: the rigidity theorem (safe, already first). Beauty injection at
   zero risk: display the two identities `c_ijk = B_ij B_jk B_ki` and the determinant
   pencil in the abstract (replacing the wordy operator block at
   clebsch_rigidity.tex:66–78) — both are kernel-checkable, so this adds memorability with
   no exposure. De-risk edits: window display out of the abstract (78–81 → prose), "main
   general theorem" phrase retired (174), HT completeness restated with dual proof routes
   (1424–1425). *Give up:* the abstract no longer displays the general window — the
   general-k reader finds it in Section 4.
2. **Companion.** Headline: the completed k≤8 classification, first sentence of the
   abstract (companion:33–54 currently reaches it in sentence five). Pure safety; nothing
   given up.
3. **q13 extraction.** Package immediately; it is the group's no-tradeoff asset: safe
   (finite + replay), memorable (parameters in the title), and clean. Lead its abstract
   with the reconstruction clause ("the 364 minimum words reconstruct the passant geometry
   and its full PGL(2,13) symmetry"), which is the surprising half.
4. **Paper II.** Headline: the classification in clean language ("the only orbits whose
   two equal sheets are invisible to quadratic statistics are B₃/F₇ and H₃/F₁₁"),
   technical trade-space phrasing demoted to the formal statement
   (clebsch_factorization.tex:48–52, 912–913). Add the Paley sentence to the intro. Risk
   here is not packaging but the Lucas-lemma exposition (§3.1.2) — no packaging fix exists;
   it needs the rewrite. *Give up:* nothing; this is a strict improvement.
5. **Paper III.** Headline when it ships: the √5 square class alone, with the harmonic
   theorem fused into the same abstract sentence (§8.4) and the bridge demoted. *Give up:*
   memorability of the physics hook is deliberately muted (one sentence on bond-order,
   not a frame) because this is the highest-exposure paper and should claim exactly what
   its citations support.
6. **Golden.** This is where all three axes are spent together. Open the paper with
   "Theorem A (program summary)" — the four-clause rosetta of §11.2, clause-cited to
   Papers I/II/III and to its own body, replacing nothing but sitting before the current
   Definition 2.1. Sharpen the abstract further to lead with the two-cubics formula as
   the hook (§11.1), then the propagation theorem, then the frustration/ETF sentence.
   Write the
   compressed T₁₁-torsor proposition from the mega-paper's raw material
   (clebsch_hexagon_code.tex:2295–2384 → half a page). *Give up:* golden's referee surface
   widens slightly (Theorem A references three other papers), accepted because by the
   sequencing plan (§10.2) all three are already on arXiv, and clause-wise citation means
   a referee can reject golden's synthesis framing without any clause being wrong.

**What the plan trades away, explicitly:** on memorability — the flashiest cross-field
claims (bond-order physics, anomaly instruments) never occupy any headline slot; the
program accepts being remembered by mathematicians first. On beauty — the rosetta is a
summary theorem with distributed proofs, not a monolith; aesthetes may call that
bookkeeping. On de-risking — Paper I's abstract keeps the (HT-dependent) cubic-recovery
material because it is the memorability payload; the dual-route mitigation is the price
paid to keep it there. Every other exposure is pushed off the headline surfaces entirely.

---

# Follow-up 3 (same date): pushback responses, consolidation, and the A+ question

## 12.1 Pushback (a): verify the citations instead of architecting around them

Mostly conceded — with one fact I can add and one piece of the recommendation I keep.

**Conceded:** verification-first is right. All three exposures are bounded literature
tasks (BBS is one proposition in one paper; HT is one proposition; the Hitchin items are
already scoped by C680), the lit cache exists, and a downgraded framing is indeed sticky.
The §11.3 demotions were priced as ship-before-verifying hedges; if the checks run first,
most of the hedging is unnecessary.

**The fact:** the manuscripts contain an internal consistency check on the BBS usage that
I should have stated: the Clebsch configuration itself attains the cited bound *with
equality*. At k=6, q=11 the fifteen chords are a 15-line partial cover missing exactly the
twelve conic points, and the bound as used reads m ≥ (3q−3)/2 = 15 (clebsch_rigidity.tex:
456–464), with the sharpness remark (473–480) confirming the upper end of the window is
attained. A misquoted-stronger bound would be *contradicted by the paper's own example*,
and a misquoted-weaker bound would fail to give the window at all. So the plausible
failure modes are narrow: a side hypothesis on the hole set (collinearity condition,
size restriction) that the conic case might not satisfy. My prior that the citation
verifies clean is high (~85–90%).

**What each verification must find for the demotion to stand (i.e., what would keep it):**
- *BBS:* verification fails to locate a statement yielding "cover missing exactly the
  q+1 points of a conic ⇒ ≥ 2q−1−(q+1)/2 lines" — either the proposition's hole set must
  be a single point / different shape, or the bound has an extra term. Then the window's
  upper bound needs a new proof and demotion becomes suspension.
- *HT Prop 10:* verification finds it is one-directional (determinantal ⇒ six nodes) with
  no smooth-dual converse, or its hypotheses (trace-orthogonality of the two matrix
  spaces, genericity) don't match Paper I's setup at clebsch_rigidity.tex:1310–1315. Then
  the node-completeness proof must run through the replay route alone.
- *Hitchin:* C680's check finds the normalization of J₀ in the cited invariant
  calculation differs by a non-square factor from what 02-orientation-cover.tex:39–46
  assumes, or that the two-configuration fibre classification is stated only over ℂ with
  no argument descending it. Either keeps Paper III gated.

**What I keep regardless of verification outcomes:**
1. The HT dual-route flip (clebsch_rigidity.tex:1424–1425): stating node completeness
   with two independent proofs is strictly better than one even if HT verifies — it costs
   one sentence and the second proof already exists and is replayed. That was never a
   demotion.
2. Removing the *displayed* general window from the abstract (78–81): that is an elegance
   call (§11.2), not a trust call — the display is the abstract's least attractive object
   whether or not BBS checks out.
3. On "main general theorem" (174): here I partially reverse myself. The phrase is
   literally accurate — the window *is* the paper's only theorem uniform in (k,q); the
   rigidity theorem is q=11-specific. If BBS verifies, keep the phrase. My §8.1 point
   survives in weaker form: the window is the paper's most *general* theorem but not its
   most *interesting* one, and the abstract's ordering should reflect interest
   (rigidity, operator, window), which it already nearly does.

## 12.2 Pushback (b): the hook arrives late in the shakiest vessel

**You are right, and the fix is concrete: most of the hook is movable to Paper I, and I
should have said so.** The dual-cubic identity decomposes:

- The determinant-pencil half (odd part of det(B + diag x) = −2·Clebsch cubic) is
  *already proved in Paper I* (clebsch_rigidity.tex:1077–1086).
- The commutator-Pfaffian half needs no outer family for a *single* matrix: Paper I's own
  homogeneous odd-part identity F_B(x,z) − F_B(x,−z) = −4z³C(x) (1082–1086) is
  equivalent, for one B, to Pf[D_x, B] = 4·(triangle cubic) — the derivation is the
  matching expansion at golden_operator.tex:231–242, which uses nothing marked. Adding
  this one-line restatement to Paper I §8, and the display `Pf[diag(x), B] = 4C(x)` to
  its abstract, puts the full one-matrix version of the hook in the first paper to ship.
- What genuinely cannot move forward: the *six-fold synchronization* — that the six
  sisters' Pfaffians are simultaneously the Joubert coordinates cutting the Segre cubic,
  with the marked-lift uniqueness (golden thm 2.3(i)–(ii)). That is honestly golden-paper
  content (it needs the coherent outer family and the S⁽³'³⁾ multiplicity-one input).

So the choice you posed resolves as: **move the hook forward.** Paper I then carries the
rigidity theorem *and* the complete one-matrix dual-cubic formula; golden's Theorem A
becomes the six-fold/Segre upgrade plus the torsor unification rather than the program's
first memorable moment. Residual priced cost: the Segre/Joubert synchronization and the
program rosetta still arrive last, in the weakest-written paper — that cost stands, but
it is now the cost of delaying the *encore*, not the hook. (This also softens the §10.1
duplication ruling: with the Pfaffian identity in Paper I, golden's citation into Paper I
covers both the two-graph and the one-matrix identity; golden proves only the marked
six-fold statement.)

## 12.3 Pushback (c): is the q13 extraction actually free?

Not free — under-priced in §11. Honest accounting:

- **Real costs:** one more referee lottery and submission overhead; ~2 pages of duplicated
  setup (conic, passant/internal dictionary); a mild salami-slicing appearance risk
  *if* the companion is also journal-submitted, since both would carry q=13 material.
- **Mitigations that hold up on inspection:** (1) The companion's k=8 proof does *not*
  depend on the extracted theorem: the weight-eight/code route is explicitly the
  "conceptual exclusion" while the terminal orbit-DAG certificate independently covers
  q=13 (companion:672–713, with the q=13 row in the DAG table at 686–693). Extraction
  breaks no proof; the companion keeps a one-sentence pointer. (2) The audiences are
  genuinely disjoint — the q13 paper sits in the Madison–Wu / Hollmann–Xiang lineage
  (binary codes from conics), the companion in arc classification; a referee seeing both
  will not read them as one result sliced.
- **The hidden assumption I should have stated:** my recommendation implicitly treats the
  companion as an **arXiv ancillary to Paper I, never separately journal-submitted**
  (journals rarely take companions, and its function is evidence, not narrative). Under
  that assumption, extraction converts the group's single best self-contained theorem
  from journal-invisible (buried in an unsubmitted companion) to journal-visible, at the
  price of exactly one added referee cycle. That trade I take. If instead the companion
  was intended for journal submission, extraction guts its best section and the
  calculus changes — but I would still extract, because "Computational strengthenings"
  was always going to be a hard journal sell and the q13 paper is an easy one.

Verdict: cost is real, small, and worth it; now priced.

## 12.4 Pushback (d): status of the two §11 proposals

- **T₁₁-torsor proposition: not actually a from-scratch proposal.** It is a *cut theorem*:
  the mega-paper states and proves it as Theorem `torsor-rosetta-close` with Lean-checked
  equal-kernel implications and replayed carriers (clebsch_hexagon_code.tex:2295–2384,
  incl. the carrier/evidence table at 2329–2367). The golden version must merely
  *restrict* the carrier list to what the split papers actually construct: the sheet
  character (II, Theorem C.3), the spinor class (III,
  04-arithmetic-specialization.tex:87–123), the support-half bit (I §8 / golden §3), and
  the marker roots {4,8} (II Appendix C). The core argument — homomorphisms onto the
  symmetric group of a two-point set with the same index-two kernel coincide — is
  trivial and already kernel-checked in the mega surface. **Confidence it survives as a
  half-page proposition: ~90%.** To bank: one pass confirming each retained carrier's
  action is defined in the split papers (not only in mega) and factors through
  PGL₂(11) with kernel exactly PSL₂(11); roughly a day against the mega replay.
- **Four-clause rosetta: three clauses bankable, one is genuinely unverified.** Clauses
  (i)–(iii) are proved theorems (Paper I §8; golden thm 2.3(ii); Paper I thm 8.2).
  Clause (iv) — "the golden eigenspaces of B reduce mod 11 to the two matching sheets,
  and the characteristic-zero choice is the √5 class of Hitchin's cover" — is, as I
  phrased it, a *heuristic composite*, and I flag two specific gaps: (1) no split paper
  states an equivariant identification between Paper I's eigenspace pair
  (L⁻⊗Q(√5) = V₃⊕V₃′, clebsch_rigidity.tex:1360–1376) and Paper II's sheet pair; the
  nearest existing statement is mega clause (E5) (clebsch_hexagon_code.tex:2317–2322)
  with its replayed reduction map to the roots {4,8}. (2) The phrase conflates two
  distinct classes: III's deck/discriminant torsor has class [5], its exchanger has
  spinor class [2] (04:129–135 states them as two independent characters). The clean
  clause (iv) is therefore "the marker-algebra torsor (class [5]) restricts to the sheet
  pair mod 11, equivariantly for conjugation and the sheet swap" — mega (E5) shape —
  with the [2] spinor statement kept separate. **Confidence the exact §11 phrasing
  survives: ~40%; confidence a clean corrected clause survives: ~75%.** To bank: verify
  the eigenspace↔sheet identification against mega's (E5) certificate and decide whether
  golden restates it with proof or imports it; half a day to a day. Theorem A should be
  drafted with clause (iv) last and in the corrected form, and not announced anywhere
  until that check passes.

## 12.5 Question 1: the fewer-but-stronger alternative

**Concrete consolidated partition (the strongest version I can design):**

- **Paper α — "The Clebsch code, its deep holes, and the golden operator."** Paper I +
  the one-matrix Pfaffian identity (§12.2) + the companion demoted to arXiv-ancillary
  appendix + the *statement* (not proof) of the k≤8 classification. ~26–30 pp.
- **Paper β — Paper II unchanged.** It is already the irreducible hard-machinery unit;
  nothing consolidates into it without dilution, and nothing extracts without
  destroying the classification.
- **Paper γ — golden + Paper III merged:** the marked operator paper with the
  characteristic-zero source (√5 cover, spinor class, bond-order cubic) as a section,
  plus the torsor proposition and Theorem A. ~35 pp.
- q13 paper as in §12.3 (extraction is orthogonal to consolidation).

**Head-to-head against my recommended split:**

- *Memorability:* α beats split-Paper-I — one paper containing "deep holes reconstruct
  the code" + the dual-cubic formula + "only two conic-filling codes ever (≤8)" is a
  genuinely striking read, and consolidation is the only way to get all three under one
  title. γ gains coherence (the √5 source sits beside the operator it orients). Clear
  win for consolidation on this axis.
- *Beauty:* mild win for consolidation (α's arc is beautiful; γ's rosetta sits beside
  its own clause (iv) proof rather than citing forward).
- *De-risking:* consolidation loses, and not mildly. α couples the safe rigidity core to
  the BBS and HT exposures *and* to a length that pushes it out of DCC/FFA's comfortable
  band; a referee objection to any pillar stalls all of them. γ is actively bad: it
  chains golden (ready modulo cleanups) behind C680's Hitchin closure — the group's
  slowest gate — and hands one referee both the breadth objection and the citation
  objection. And the group has already run this experiment: the 37-page mega-paper *was*
  the consolidated form, and the project's own review history judged it overloaded and
  split it (papers-index.md:10–16). That is evidence, not taste.

**Does consolidation raise the ceiling or concentrate risk?** Both, asymmetrically: it
raises α's ceiling roughly half a grade (a strong-DCC paper becomes a plausible JCTA
paper) while multiplying its stall probability, and it lowers γ's expected outcome
outright. **Recommendation: take the cheap half of the consolidation and refuse the
expensive half.** Concretely: (1) companion becomes arXiv-ancillary to Paper I and stops
being counted as a separate publication — that *is* a consolidation; (2) the hook moves
into Paper I per §12.2 — that captures most of α's memorability gain with none of its
coupling; (3) III and golden stay separate, with golden importing III's results by
citation. Net: four journal submissions (I, q13, II, golden) + one gated short note (III)
+ one ancillary — versus the consolidated three. The extra submission relative to
full consolidation buys decoupling from C680, and that is the best trade on the board.

## 12.6 Question 2: is there an A+ paper in here?

**Plain answer: not by repackaging. There is one identified theorem that would create
one, and it is not yet proved.**

What repackaging can reach: Paper I, with the §12.2 hook moved in and citations
verified, tops out around **A−/A** — a paper specialists genuinely admire and cite, at a
fit venue. It does not reach A+ because the binding constraint is neither writing nor
citation exposure but **mathematical scope**: every headline is about one exceptional
object over one or two small fields. There is no infinite family, no asymptotic
statement, and — with the partial exception of Paper II's defining-characteristic method
for killing search — no transferable technique. Exceptional-object papers reach A+ only
when the exceptional object closes a general question, and right now the general
question is left open at k=9.

**The one A+ candidate:** the *complete* conic-filling classification —

> For every k and every prime power q, the only k-arcs in PG(2,q) whose uncovered locus
> is the full point set of a nonsingular conic are the projective four-frame over F₅ and
> the Clebsch hexagon over F₁₁.

i.e., remove the k≤8 boundary (currently the open problem stated at
clebsch_rigidity.tex:1485–1489 and the k≥8/k≥9 boundary flagged at
clebsch_hexagon_code.tex:1646–1647). "Deep-hole loci are conics exactly twice, ever" is a
clean, final, quotable classification — combined with the golden-operator material it
would make a single paper with a real claim on a top-tier combinatorics venue
(Combinatorica/JCTA-lead-article class). What would have to be proved: a uniform
obstruction for k ≥ 9 across the window's ~k²/3-sized q-range — the chord-moment system
leaves free concurrence parameters for r ≥ 4 (the mega-paper says exactly this,
clebsch_hexagon_code.tex:1646–1647), so a new idea is needed, not more search; the k=7
case already required brute force, which does not scale. **Realistic probability with
current tools: ~30%**, driven by whether some second-order counting (secant-pencil
saturation à la the q=13 weight-eight argument, or an association-scheme/clique bound
generalizing the Sylvester trick) can be made uniform in k. If that theorem lands, the
right packaging is a *new* headline paper (rigidity + all-k classification + operator),
not an upgrade of Paper I after the fact.

Runner-up (further away): an all-good-reduction version of Paper II's classification —
the paper itself names the missing ingredients (integral models, degeneration
analysis; the all-good-reductions paragraph after the rank theorem). That is a bigger project than a bounded push.

If neither is pursued, say plainly: the program's realistic ceiling is a set of A−
papers that are collectively memorable — which the §12.2/§12.5 amendments are designed
to maximize — and no packaging decision changes that.

---

# Provenance and review state

This review reflects the repository at commit `9f5e6f50` ("Close local Paper III review
defects") plus the uncommitted working tree of 2026-08-01: clebsch_factorization.tex
(+399/−232 vs HEAD, including its verification JSONs — the restructured Lucas-socle
lemma and case-tree table reviewed in §3 are this in-flight text) and
golden_operator.tex (+41 vs HEAD — the C757 six-node cubic-wall corollary reviewed in
§5.1). Paper I, its companion, and the mega-paper are unchanged at this state; Paper III
includes the repair commits `e5f14aa2` and `9f5e6f50`. C756 (all-k conic-filling, per
§12.6) and C757 (Golden cubic wall census) are allocated and active.

**Archive note.** Earlier committed revisions of this report (`b3068748`, `b866cb8f`)
recorded defects that have since been fixed and are therefore no longer listed above: in
golden, internal task-ID leakage (C715/C707), a `\qquad` typo, missing self-citations to
Papers I–III, an undressed bibliography, and a jargon-dense abstract (all repaired in
`f555998f`, which also promoted the unmarked-boundary result into the introduction); in
Paper II, five `\qquad` typos, a duplicate/skipping equation-tag scheme, a comma splice
in the main theorem statement, a stale Paper I title in the bibliography, and the missing
case-tree summary (all repaired in the in-flight rework, which also replaced the former
borrow-chain elimination that earlier revisions flagged as the primary referee risk); in
Paper III, an unpinned J₀-normalization citation and a missing mod-11 scope note in the
abstract (repaired in `9f5e6f50`). Grades were updated accordingly: Paper II writing
B→B+ and readiness B−→B; golden writing B−→B and readiness C+→B−. Sections 8–12 are a
Q&A record and retain their dialogue structure, including the §12.1 partial reversal of
the earlier window-demotion recommendation; only their factual state references were
updated. Superseded reasoning lives in this file's git history, not in the text above.

---

# Follow-up 5 (same date): re-argument under strength-over-schedule

## 14. Recommendations re-derived when delay, referee convenience, and our own effort cost ~nothing

**C680's category, first, since it gates everything downstream:** C680 is *internal*. Its
content is (a) verifying our pinned readings of Hitchin against sources that exist and are
fetchable into the lit cache — the degree-2 cover, the branch sextic, the chart
restriction ι*J₀ = 16σ₃², the two-configuration fibre, V_t = U_t^⊥ — and (b) making the
release bundle self-contained. No third party, no unproven external input, no waiting on
anyone. The same holds for the BBS and Hassett–Tschinkel checks in Paper I. **None of the
three citation exposures is a scheduling argument under the new objective; they are
mandatory correctness gates that we close ourselves, in days.** The only residual risk they
carry is mathematical (a verification could *fail*), and that risk exists under any
packaging.

### 14.1 Consolidation (§12.5 re-argued): I reverse on γ and take α in full

My §12.5 refusal decomposed into three reasons: referee wholesale-rejection risk, venue
length bands, and γ chained behind C680. The first two are referee-process costs — gone
under preprint primacy. The third is now an internal gate — gone as a scheduling argument.
What survives of my refusal is only the mega-paper precedent, and re-examined, that
precedent is about **strength, not schedule — but it constrains writing, not partition.**
The 37-page paper failed because it merged *heterogeneous* threads (rigidity +
factorization + passages + survival ledgers) and let ledger-prose compete with its
headline; that is a hierarchy failure the style guide diagnoses, and it would sink a
consolidated paper under any objective. It does not argue against merging *homogeneous*
threads around one narrative.

**Revised partition (recommended):**

- **α — the headline paper:** Paper I + the one-matrix dual-cubic identity (§12.2) + the
  census/companion material as an appendix or ancillary + the k≤8 classification stated
  in the body. One object, one narrative ("deep holes reconstruct the code, its golden
  operator, and — through length eight — nothing else ever does this"). This is the full
  consolidation of the α I designed and previously took only half of.
- **β — Paper II**, unchanged as a unit (irreducible), now with the all-good-reduction
  extension queued as its strength upgrade (§14.2).
- **γ — golden + Paper III merged, after C680 closes.** I reverse my earlier refusal.
  Under strength-primacy the decisive fact is that III standalone is the group's weakest
  preprint (B− content, seven hedged pages) — exactly the kind of thin note that gets
  pre-empted or ignored — while its two results are *strong* as the source clauses of the
  synthesis: the √5 square class becomes clause (iv) of Theorem A sitting beside its
  proof, and the bond-order restriction becomes the program's cross-field exit. Golden
  and III are homogeneous (both are about the orientation torsor and its
  characteristic-zero source), so the mega precedent's surviving lesson (no ledger-prose,
  one headline) is satisfiable. Condition: clause (iv) must pass the §12.4 check and C680
  must verify — both internal.
- **q13 extraction: unchanged, and strengthened.** It was never schedule-motivated
  (audience fit + visibility), and under §14.2 it acquires a new role: the passant-code
  argument is the *method pilot* for C756. A standalone methods-bearing paper is stronger
  than a buried companion section under any objective.

Net: four preprints (α, β, γ, q13), each individually strong, no B− paper in the set.

### 14.2 Strongest reachable paper (§12.6 re-argued): C756 becomes the spine, not a side bet

Under the old objective C756 was a 30% side bet because months of work with a 70% failure
mode was expensive. Under the new objective the expected value flips: 30–40% × (an A+
classification paper) with the failure branch still yielding partial results (extended
k-ranges, new uniform lemmas, a conceptual k=7 proof) dominates every packaging move on
the table. **Build around it.** Concretely, the attack has more structure than my §12.6
suggested, using tools already in the repo:

- *Lower window edge (q near 2k−3):* there the passant pencils saturate — at q = 2k−3
  every vertex's k−1 chords exhaust its (q+1)/2 passants — so a conic-filling arc's
  vertices give low-weight words of the binary passant/internal incidence code, whose
  dimension is known for **all** odd q (Madison–Wu). The q=13 weight-eight exclusion is
  precisely this argument at one field; generalizing its Segre-lemma/clique step to a
  uniform minimum-distance or clique bound is the natural first campaign. This is why the
  q13 paper should ship as the pilot.
- *Upper window edge (q near k²/3):* the chord-moment system plus n_i ≥ 0 feasibility,
  which already kills k=5 outright and pinned the k=7 spectra; push for an infeasibility
  band uniform in k.
- *Middle range:* Hollmann–Xiang's association scheme exists for all q; the Sylvester
  trick at q=9 is its smallest instance. Clique/eigenvalue bounds in that scheme are the
  third lever.

If C756 lands, the A+ paper is **α⁺ = α + the all-k classification** ("deep-hole loci are
conics exactly twice, ever"), and it should be assembled as one paper. Decision rule for
the tension between shipping α and waiting: do not hold α hostage — post α when its own
internal gates (BBS/HT verification, hook merge) close; if C756 resolves within that
assembly window, merge before first posting; otherwise the classification lands as α's
v2 or a sequel. arXiv versioning makes this costless, and posting α early *protects*
priority on rigidity while C756 runs.

**The runner-up is back on the table:** the all-good-reduction upgrade of Paper II
(integral models + degeneration analysis of the harmonic decomposition, orbit structure,
and marker algebra — the ingredients the paper itself names). It attacks my stated
binding constraint on II's ceiling (no transferable technique / no uniformity) directly.
Queue it as a C-task; it is the second-highest-EV mathematics after C756.

**Other strength moves I filtered out earlier for effort, now recommended:**
1. Formalize Dye's Theorem 1 (the Brianchon bound and equality classification) in Lean,
   eliminating the last two axioms from Paper I's formal surface — a genuine
   trust-strength upgrade, bounded synthetic-geometry work.
2. Replace the brute-force k=7 exclusion with a conceptual proof (a C756 stepping stone;
   the companion's note that spectral/LP attempts failed marks where the difficulty is).
3. Bank the §12.4 items now (eigenspace↔sheet lemma against mega (E5); compressed
   T₁₁-torsor proposition) — they were always cheap; under the new objective there is no
   reason they are still unwritten.
4. Solve Paper III's integral-boundary problem (identify the exact prime set N via an
   integral Mukai–Umemura model, flatness, Stein base change) — makes γ's arithmetic
   clause characteristic-complete; larger, queue behind C756 and the good-reduction task.

### 14.3 Sequencing (§10.2 re-argued): waves, not a chain

The old order optimized backward-pointing citations and listing momentum — partly
schedule-flavored reasoning. Under strength-primacy the answer is **two simultaneous
waves**: wave 1 = α and the q13 paper together (the q13 paper is α's method pilot; each
cites the other's fresh arXiv ID); wave 2 = β and γ together once their internal gates
close (β: commit/re-freeze + gloss passes; γ: C680 + clause-(iv) banking + merge). A
simultaneous program launch lands with more force than a drip: each abstract carries one
program sentence and the γ introduction tells the whole story with four live citations.
III never ships as a thin standalone; golden-last survives only in the weak form
"γ is in wave 2." If C756 lands early, wave 1 becomes α⁺ + q13 and is the strongest
single arXiv day this program can produce.

### 14.4 Audit of §§8–12 for schedule/effort/referee-risk load-bearing

- **Collapses:** most of §11.3's positioning logic ("bill the window as secondary so an
  objection can't sink the paper", "keep HT-dependent material off headline surfaces") —
  replaced by *verify, then bill on merit*; §11.4's "spend memorability sparingly in
  I–III to keep them safe" — put the flash where it is strongest, including unmuting the
  bond-order hook in γ once C680 verifies; §12.3's extraction pricing (the referee-lottery
  cost is no longer a cost).
- **Survives unchanged (never schedule-based):** §8 headlines; §9 titles for β and q13
  (α and γ need new titles — proposal for α: *"Deep holes remember the icosahedron:
  reconstruction, rigidity, and the golden operator of the Clebsch code"*; γ keeps a
  sharpened golden title with the program-summary Theorem A); §12.2 hook-forward (pure
  memorability logic — now lands in α); the HT dual-route flip (strength: two proofs
  beat one); §12.1's verify-first (now mandatory under both objectives); the q13
  extraction; the Paper II Lucas-lemma readability work — reader comprehension is not
  referee appeasement, an unreadable proof is a weaker preprint, so this survives as a
  strength requirement.
- **Reversed by the new objective:** §12.5's refusal of γ (now: merge III into golden
  after C680); §12.5's hedge of keeping companion material half-out of α (now: full α);
  §12.6's treatment of C756 as optional upside (now: the spine) and of the
  all-good-reduction extension as out of scope (now: queued second).

**What we give up, stated plainly:** wave 2 may trail wave 1 by however long C680 plus the
clause-(iv) banking take — acceptable, since both are our own work; α carries the BBS/HT
verification obligation *before* posting rather than around it — also our own work; and if
C756 fails outright, α still ships as the §12.5-era strong paper, so the downside of
building around the spine is only the time spent, which this objective prices at zero.
