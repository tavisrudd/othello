# Cross-paper novelty ceilings and one-level-up research moves

**Date:** 2026-08-02

**Scope:** `papers/ame_lu`, `papers/beyond4_prs`, and Clebsch Papers I--IV

**Status:** bounded read-only scout complete; no manuscript, queue, handoff, or
task-card edit was made by the scout

## Executive verdict

The scout tested the principal claims of six papers against their closest
known literature and then asked, for each collision or close ceiling, whether
the right response was a theorem one conceptual level higher: reconstruction
rather than construction, classification rather than examples, or a faithful
observable rather than an invariant.

One fresh material collision was found.  In Clebsch Paper II, the general
self-associated/Schur-square/arithmetically-Gorenstein mechanism has a near-
exact 2025 predecessor.  It must be presented as imported structure rather
than as a paper-owned general mechanism.  Paper II's exact (B_3/H_3) orbit
classification, unique two-valued quadratic trade, and identification of the
sheet-sign third moment with the Macaulay cubic survive.

The strongest level-up is C794: the aligned four-set shadow appears to recover
an arbitrary two-graph on at least seven vertices up to complement.  The
seven-vertex base is already proved by exact exhaustion and the unrestricted
extension follows by a short local-to-global argument.  The remaining work is
to replace the finite base by a human proof, audit precedence, and derive the
first cut moment not forced by the classical (3)-design parameters.

### Read-depth summary

The scout directly read **seven individually named sources at full-text
depth**, eleven at partial depth, and one at abstract/metadata depth.  It also
relied on Clebsch Paper III's existing sixteen-source audit, which records
three full-text sources.  MathSciNet and automated Google Scholar were not
covered; every negative verdict remains qualified.  Cache hashes below record
fetched bytes, while the stated depth records what was actually read.

## Claim matrix

| Our paper and theorem surface | Closest literature | Verdict | Surviving boundary |
|---|---|---|---|
| AME--LU, Theorem `lu-lc-rigidity`: LU equivalence of additive stabilizer AME\((2m,q)\) states is factorwise Clifford | Rains's qubit Pauli-axis recovery; Van den Nest--Dehaene--De Moor's qubit minimal-support LU-to-LC criterion | **CLOSE CEILING**; the qubit instance is covered | uniform prime-power scope, arbitrary additive stabilizers, and the explicit intrinsic frame-recovery proof |
| AME--LU, Theorem `atlas-classification`: the minimum-support atlas classifies LU equivalence and gives the exact symmetry-group extension | finite binary LC invariants; Wirthmüller's local symmetry work; Tan's low-party AME symmetry analysis | **CLOSE CEILING** | the all-prime-power operator-pushing atlas, exact extension, and prime-field holonomy centralizer |
| AME--LU, Theorem `two-uniform-stability` and Fisher-isotropy remark | standard pure-state Fisher metric and two-uniform covariance cancellation | **CLOSE CEILING / CLASSICAL COROLLARY** | the paper's explicit uniform constants and their use as a quantitative rigidity bound, not Fisher isotropy itself |
| PRS, Theorems `r5` and `spine`: complete redundancy-five and six classifications, plus the radius-delimited redundancy-seven split-free result | Zhang--Wan--Kaipa stop at redundancy four; Wang supplies general splitting semantics | **NO COLLISION LOCATED** | the complete (r=5,6) classifications, coherent polar contraction, and delimited (r=7) theorem |
| PRS, higher-Lucas endpoint criterion around the Lucas-carrier analysis | Wang--Wu--Hu, Proposition 11 | **VERIFIED COLLISION** | the paper must import the endpoint criterion; its coherent-Hankel identification and full (e_7)-orbit shallowness remain configuration-specific |
| PRS, Theorem `e7`: the entire degree-nine (e_7) orbit is shallow, with exact witness count | no exact predecessor located in the bounded pass | **NO COLLISION LOCATED** | the exact orbit theorem; the other intrinsic strata of the six-dimensional carrier remain the natural classification frontier |
| Clebsch I, inverse (q=11) theorem: the complete projective deep-hole syndrome locus reconstructs the non-GRS Clebsch code | Dye's classical hexagon uniqueness/stabilizer; Wu--Ding--Chen's deep-hole/MDS-extension equivalence; Li--Lu--Ling--Lam's forward construction framework | **CLOSE CEILING**, not a collision | inverse recovery of the code from the entire maximum-distance syndrome locus |
| Clebsch I, decoder-derived marked golden orientation | classical Seidel/two-graph and conference machinery | **CLOSE CEILING** | recovery of the marked support two-graph and orientation from decoder ambiguity, not the existence of the classical operator |
| Clebsch I, uniform conic-filling window | no predecessor located in this bounded pass | **NO COLLISION LOCATED**, nonexhaustive | retain qualified wording pending a dedicated audit |
| Clebsch II, Theorem `factorization-recovery` parts (v): self-associated configurations, Gorenstein coordinate rings, and Schur-square mechanism | Rodríguez-Pajares--Ruano--Salizzoni 2025, Theorem 3.11 and Corollary 3.13, importing Eisenbud--Popescu Theorem 7.3 | **VERIFIED COLLISION / NEAR-EXACT PREDECESSOR** | treat the general AG mechanism as imported; retain the exact (B_3/H_3) specialization and sheet-sign cubic identification |
| Clebsch II, Theorem `factorization-recovery` parts (ii)--(iv): exact (B_3/H_3) trade classification, sheet recovery, and first nonzero signed cubic | classical subgroup classifications of PGL\(_2(q)\) and Dickson-module structure | **NO COLLISION LOCATED** | exact matching-orbit classification and configuration-specific cubic orientation |
| Clebsch III, rational twist (5J_0), marked sign transport, spinor specialization, and labelled Petersen harmonic coefficient | existing sixteen-source audit | **NO COLLISION LOCATED** within that audit | the exact marked synthesis; all absence claims retain the audit's coverage qualifications |
| Clebsch III, Joubert--Segre--Igusa/operator ingredients | classical Joubert, Segre, Igusa, conference, and invariant-theory literature | **CLOSE CEILING / CLASSICAL INGREDIENTS** | the exact common-operator propagation and marking-compatible synthesis |
| Clebsch IV, exact ([78,36,12]_2) code, (364) minimum words in four orbits, and minimum-layer reconstruction | Droms--Mellinger--Meyer have the same code and bounds; Madison--Wu the dimension; Hollmann--Xiang the elliptic scheme; Ma--Liu--Tian the bound (8\le d\le12) | **CLOSE CEILING**, but no collision with the exact closure | exact distance (12), full minimum-word/orbit structure, reconstruction, and symmetry |

## The fresh Paper-II collision

### Our claim

Clebsch Paper II studies the balanced (B_3/\mathbf F_7) and
(H_3/\mathbf F_{11}) matching quotients.  Theorem
`factorization-recovery` proves that their homogenized point configurations
are self-associated with Gorenstein coordinate rings and that the signed
cubic is the Macaulay inverse system of an Artinian reduction.

### Predecessor

Rodríguez-Pajares--Ruano--Salizzoni, arXiv `2512.16766`, Theorem 3.11 proves


\[
 \dim C^{(2)}=2k-nb(C),
\]

in their self-dual-code framework, and Corollary 3.13 states that the
self-associated column points are arithmetically Gorenstein exactly when the
self-dual code is indecomposable.  Their account explicitly imports
Eisenbud--Popescu, Theorem 7.3, for the geometric bridge.

This reaches the general self-associated/Schur-square/AG mechanism used in
Paper II.  Paper II should cite it and cease presenting that mechanism as a
general novelty.  The source does **not** provide:

- the classification of full PGL\(_2(q)\)-matching orbits with a
  one-dimensional two-valued quadratic trade;
- the conclusion that only (B_3/\mathbf F_7) and
  (H_3/\mathbf F_{11}) survive;
- recovery of the unordered factorization sheets from quadratic moments; or
- identification of the sheet-sign third moment with the specific Macaulay
  inverse-system cubic.

Accordingly the collision changes attribution and hierarchy, not the main
classification theorem.

### Bounded adjacent-crown extraction

The stronger surviving target is the trade-only classification in Level-up 5
below: remove the residual one-factorization/matching hypothesis and ask
whether the existence of a one-dimensional two-valued quadratic trade itself
forces the hidden sheet structure and hence the (B_3/H_3) list.  This turns
factorization from an input into a reconstructed consequence.

## Ranked level-ups

The effort estimates below are deliberately at AI-research speed.  They assume
parallel exact experimentation, symbolic algebra, and literature triage; they
are not human-calendar estimates.

### 1. Aligned-design faithfulness and conference tomography

**Our papers affected:** primarily Clebsch Paper III and the Golden quantum-
statistics companion; Clebsch Paper I supplies a sharp small-order boundary.

**The theorem to seek.**  Let (\Delta) be a two-graph on a vertex set (V),
and let (\mathcal A(\Delta)) be the four-subsets containing either zero or
four coherent triples.  Prove that for \(|V|\ge7\),

\[
 \mathcal A(\Delta)=\mathcal A(\Delta')
 \quad\Longrightarrow\quad
 \Delta'=\Delta\ \text{or}\ \overline\Delta.
\]

For a symmetric conference two-graph, Greaves--Suda's determinant-((-3))
design is exactly (\mathcal A(\Delta)).  The theorem would therefore say
that this determinant design reconstructs the conference two-graph up to
complement.  Composed with C788's injective four-to-balanced inclusion map,
it would further imply that the **labelled balanced-cut purity function** of
every conference matrix of order at least ten reconstructs its two-graph up
to complement.

**Why this is one level higher.**  Greaves--Suda construct a (3)-design from
a conference matrix.  C794 reverses the arrow: the design, or equivalently the
full labelled exchange-purity landscape, recovers the source.

**Current evidence.**  Exact normalized enumeration proves the base statement
for all (32{,}768) labelled two-graphs on seven vertices: every aligned-
family fibre is exactly one complementary pair.  Larger fibres occur for four,
five, and six vertices, so seven is sharp.  Restriction to seven-subsets and
connectedness of the Johnson graph globalize the base to every larger vertex
set.  At order ten, the naive overlap graph degenerates into thirty isolated
Steiner blocks, but the full binary parity system has rank (28), nullity
two, and exactly the complementary pair of solutions.

**Likely proof route.**  Replace the seven-vertex exhaustion by a cochain or
parity proof on triples and four-sets.  Show that equality of aligned status
forces the difference of two triple indicators to be constant; analyze the
small fibres as the exact failure of that implication.  The existing
seven-subset overlap lemma then gives the unrestricted result immediately.

**Literature ceiling.**  Greaves--Suda own only the forward determinant-design
construction.  Classical two-graph reconstruction results must still be
checked for the reverse functor.  No novelty verdict is licensed until C794's
bounded audit closes.

**Cheapest falsifier:** already passed exhaustively at the sharp base
(v=7).  The remaining falsifier is literature, not computation.

**AI-speed effort:** roughly 4--12 focused hours for several human-proof
attacks and the bounded audit; one to two days if the seven-vertex argument
requires a representation-theoretic classification rather than elementary
parity.

**Paper lift:** high.  Paper III gains a genuine shadow-to-source theorem;
the Golden paper gains an operational tomography statement.  Paper I lies at
the exceptional six-vertex endpoint and must not import the (v\ge7) theorem.

### 2. Classification of all higher Lucas carriers in PRS

**Our paper affected:** `papers/beyond4_prs`, especially Section 9 and Theorem
`e7`.

**Collision forcing the pivot.**  Wang--Wu--Hu, arXiv `2604.21183v4`,
Proposition 11 gives the higher-Lucas endpoint criterion.  That criterion must
be imported rather than claimed as the PRS paper's general endpoint theorem.
What remains paper-owned is the identification of the relevant coherent
Hankel carrier and the proof that the complete degree-nine (e_7) orbit is
shallow.

**The theorem to seek.**  Classify the intrinsic strata of every higher Lucas
carrier under PGL\(_2\) and coefficient Frobenius, and decide for each
stratum whether its kernel contains a squarefree fully split polynomial.  A
successful theorem would upgrade the single (e_7)-orbit result to a
carrier-wide shallowness/deepness classification, preferably expressed by
subspace-polynomial geometry and coherent polar flags.

Concretely, the present paper says that the other intrinsic strata of the
six-dimensional degree-nine carrier are unclassified.  The first deliverable
should close that exact finite-dimensional carrier before claiming an all-
Lucas theorem.  The higher theorem would then describe how the answer changes
with the base-(p) digit pattern controlling the Lucas kernel.

**Why this is one level higher.**  The collided result detects the endpoint;
the proposed theorem classifies the geometry and orbit structure of every
carrier at and beyond that endpoint.

**Likely proof route.**  Use linearized/subspace polynomials to parameterize
split witnesses, express their coefficient images in the Lucas carrier, and
compare those images with the coherent Hankel/polar stratification.  Quotient
by PGL\(_2\), Frobenius, and affine translation only after the incidence
map is explicit.  The existing (e_7) proof supplies the model calculation:
three-dimensional \(\mathbf F_2\)-subspaces give all additive-affine
witnesses and exact counting.

**Literature ceiling.**  Zhang--Wan--Kaipa reach projective Reed--Solomon deep
holes through redundancy four.  Wang supplies general splitting semantics.
Wang--Wu--Hu own the endpoint criterion, but the scout did not locate a full
carrier-orbit classification.

**Cheapest falsifier:** enumerate the first unclosed carrier strata and their
split-squarefree incidence for the smallest admissible fields.  A single
carrier orbit whose behavior is not controlled by subspace-polynomial type
kills the naive uniform formulation while leaving a stratified theorem open.

**AI-speed effort:** 6--18 hours for the exact first-carrier census and orbit
recognition; one to three days for a uniform proof if the coefficient image is
representation-theoretically clean.  The existing C620 frontier is the natural
owner.

**Paper lift:** high.  It would turn the paper's endpoint and one-orbit result
into a reusable all-carrier classification mechanism and materially strengthen
the claim to go beyond redundancy four.

### 3. Uniform minimum-layer faithfulness for passant codes

**Our paper affected:** Clebsch Paper IV,
`papers/q13-passant-code`.

**Current theorem.**  At (q=13), the passant-line construction gives an
exact binary ([78,36,12]) code with (364) minimum words in four orbits; its
minimum layer reconstructs the relevant incidence and exact symmetry.

**Literature ceiling.**  Droms--Mellinger--Meyer already describe the same code
and bounds at abstract/metadata depth.  Madison--Wu own the dimension,
Hollmann--Xiang the elliptic association-scheme background, and Ma--Liu--Tian
record (8\le d\le12).  The exact distance, complete minimum-word structure,
and reconstruction survive.

**The theorem to seek.**  Determine the exact odd (q), or exact congruence
and size range, for which the minimum-support hypergraph of the binary passant-
line code reconstructs the elliptic association scheme, the conic, and the
passant incidence up to projective equivalence.  The theorem should state both
the faithful range and the first failure modes; a naive all-(q) claim is not
yet justified.

**Why this is one level higher.**  Paper IV reconstructs one exceptional
(q=13) object.  The proposed theorem classifies when the minimum layer is a
faithful functor across the entire family.

**Likely proof route.**  Express minimum supports as distinguished cliques or
relation classes in the elliptic association scheme; recover primitive
idempotents or intersection numbers from the support hypergraph; then recover
the conic and projective group from the reconstructed scheme.  Separate the
uniform scheme argument from the field-specific minimum-distance theorem.

**Cheapest falsifier:** exact tests at (q=9,11,17) of distance, minimum-
support hypergraph, automorphism group, and incidence reconstruction.  Any two
nonisomorphic incidence structures with the same minimum hypergraph, or any
field where the minimum layer changes type, kills the naive uniform statement
and identifies the correct range.

**AI-speed effort:** 6--18 hours for the three-field falsifier and scheme
recognition; one to three days for a positive uniform theorem if the minimum
supports occupy a single scheme-theoretic class.

**Paper lift:** very high if positive.  It changes Paper IV from an exact
exceptional-code paper into the first member of a classified reconstruction
family.  A negative still improves the paper by proving why (q=13) is
exceptional.

### 4. AME local-symmetry tomography from low-order correlations

**Our paper affected:** `papers/ame_lu`, chiefly Theorems
`lu-lc-rigidity`, `atlas-classification`, and `two-uniform-stability`.

**Current ceiling.**  Rains and Van den Nest--Dehaene--De Moor already recover
qubit Pauli axes from minimal-support correlation data and obtain a qubit
LU-to-LC criterion.  Wirthmüller and Tan provide close finite-symmetry context.
The AME--LU paper survives through its all-prime-power arbitrary-additive scope
and its exact minimum-support atlas.

**The theorem to seek.**  For the low-order stabilizer AME families, prove
that a bounded collection of connected correlation tensors reconstructs the
minimum-support atlas and hence the complete fixed-party projective product-
unitary symmetry extension

\[
 1\longrightarrow L_\psi\longrightarrow\Gamma_\psi
 \longrightarrow\mathcal G_\psi\longrightarrow1.
\]

The strongest useful form would give a uniform tensor order independent of
the number of parties.  A safer first target is the canonical four-qutrit and
other smallest nonbinary AMEs, using three-body connected correlations where
they contain the full Weyl-frame data.

**Why this is one level higher.**  The present theorem says any exact local
unitary equivalence must be Clifford and describes the atlas once minimum-
support operators are known.  Tomography asks whether experimentally or
invariantly accessible low-order tensors recover the entire finite symmetry
group, not merely constrain its elements.

**Likely proof route.**  Compute the stabilizer of the connected-correlation
tensor under the product orthogonal action on local traceless operators.
Rank-one contractions should recover the local Weyl axes; overlaps should
recover the transport maps (M_A(i,j)); loop products then recover atlas
holonomy and its centralizer.  Compare the resulting tensor stabilizer with
the exact LU group from the atlas theorem.

**Cheapest falsifier:** the canonical four-qutrit AME and a small stabilizer
AME with a known exact LU group.  If the low-order tensor stabilizer strictly
contains the atlas symmetry group, fixed-order tomography fails in that form.
The adjacent fallback is quantitative rather than exact: test whether the
global frame-recovery map has a uniform singular-value lower bound, extending
Theorem `two-uniform-stability` from state overlap to reconstructed frames.

**AI-speed effort:** 4--12 hours for exact tensor-stabilizer computations on
the two smallest examples; one to two days for a general proof if contractions
recover the atlas without exceptional degeneracy.

**Paper lift:** high.  It would turn a rigidity theorem into a faithful,
observable reconstruction theorem and clarify why the atlas is the natural
finite invariant rather than only a proof device.

### 5. Trade-only classification in Clebsch Paper II

**Our paper affected:** Clebsch Paper II,
`papers/clebsch-factorization`.

**The theorem to seek.**  Remove the residual matching/one-factorization
clause from the current classification.  Classify full projective
PGL\(_2(q)\)-orbits whose strength-two trade space is one-dimensional
with a two-valued generator, and prove that the trade alone reconstructs the
two complementary sheets and forces the (B_3/\mathbf F_7) or
(H_3/\mathbf F_{11}) configurations.  In this formulation the hidden
factorization is a conclusion rather than part of the carrier.

**Why this is one level higher.**  The general AG consequence collided with
the literature.  The exact trade is the genuinely paper-specific mechanism.
Making it sufficient for the entire configuration concentrates the theorem on
what the literature does not supply.

**Likely proof route.**  Begin with the two values and their multiplicities,
derive the permutation-module quotient forced by the quadratic annihilator,
and use defining-characteristic PGL\(_2\)-module structure to recover the
sheet system.  The current four-endpoint switch and outer-parity arguments
should then identify the only possible matching realization.  The hard branch
is the nonretracting higher-digit module.

**Literature ceiling.**  Rodríguez-Pajares--Ruano--Salizzoni and
Eisenbud--Popescu own the general self-associated/AG bridge.  Giudici,
Dickson, and Guralnick--Zieve bound the possible projective subgroup actions.
The scout located no source deriving the (B_3/H_3) matching geometry from
the trade alone.

**Cheapest falsifier:** the (q=121) ordinary-contraction/Borel calculation.
The existing C665 analysis isolates the nonretracting (L(6)) obstruction.
An extra orbit satisfying the trade but lacking the required sheets kills the
two-case theorem; a clean obstruction there is strong evidence for the
classification.

**AI-speed effort:** 8--24 hours for the (q=121) gate and small-field orbit
audit; one to three days for the modular proof if the Borel invariants close.

**Paper lift:** high.  It replaces a collided general consequence by a sharper
classification at the paper's true mechanism and could make the cubic
orientation theorem feel forced rather than appended.

## Other paper-specific opportunities

### Clebsch Paper I

The inverse deep-hole theorem survived.  A plausible higher theorem is to
classify when the map from an arc to its complete deep-hole ambiguity
structure is faithful, and when it is quantitatively stable under deletion or
corruption of syndrome directions.  The cheapest gate is a small-(q) exact
collision census.  This is conceptually attractive, but the existing C756
all-(k) conic-filling theorem is more concrete and currently has a clearer
proof route.

### Clebsch Paper III

The existing marked arithmetic/operator/harmonic synthesis survived its prior
audit.  C794 is the natural higher move because it reverses one of Paper III's
shadow constructions.  No additional broad extension should be opened until
C794's seven-vertex human proof and novelty audit decide whether that reverse
theorem is real.

## Source records

### AME--LU ceiling sources

- **Rains**, arXiv `quant-ph/9704043v1`.  **Read depth: partial**; the scout
  used the qubit Pauli-axis/correlation-tensor material relevant to the
  manuscript's cited Theorem 13.  Cache SHA-256
  `ad906a12c2a5ac65e6efa575d72b94b7dd65bcb7d435145284ea8eb26dad3a4c`.
- **Van den Nest--Dehaene--De Moor**, arXiv `quant-ph/0411115v2`.
  **Read depth: full text.**  Used for the binary minimal-support LU-to-LC
  criterion and its corollary.  Cache SHA-256
  `c0f8e192552369d5af9304ebf08995f59b6917e243a570f37ff1b29f3b4cb735`.
- **Wirthmüller**, arXiv `1102.5715`.  **Read depth: partial**; used only for
  neighboring finite local-symmetry context.  Cache SHA-256
  `5cfd43e7f314056c7c7f61e6da6599a56252a759c11552a7b2c4d50d736d8164`.
- **Tan**, arXiv `2601.19677`.  **Read depth: partial**; used for the reported
  four-qutrit/low-party AME symmetry comparison.  Cache SHA-256
  `460f398f1fe63aa347f2457e44c0fe12d1164bdc33a25ee3f44ce3805d4f48e6`.

### PRS ceiling sources

- **Zhang--Wan--Kaipa**, arXiv `1901.05445`.
  **Read depth: full text.**  Used for the projective Reed--Solomon deep-hole
  classification through redundancy four and its stated next boundary.
  Cache SHA-256
  `5c2b9e2508c7200428c441b7a41da1596b1c9b0851f5632e2297cdbed41caf24`.
- **Wang**, arXiv `2606.12810`.  **Read depth: full text.**  Used only for
  general splitting semantics; it does not contain the PRS paper's coherent
  polar contraction.  Cache SHA-256
  `5dd4e19544335ebc2c75a184074e94adb91b78331930b5e8a643ae606021a107`.
- **Wang--Wu--Hu**, arXiv `2604.21183v4`.
  **Read depth: full text.**  Proposition 11 is the load-bearing collision for
  the higher-Lucas endpoint criterion.  Cache SHA-256
  `ad1e19b1a1bf7b1bbc016cc4617a59a718cf1a3f9396f6386f4b1b151149a811`.

### Clebsch-I sources

- **Dye (1991)**.  **Read depth: full text via the repository's OCR
  reconstruction; every load-bearing uniqueness/stabilizer passage was
  verified against the adjacent authoritative page image.**  The directory's
  README-promised `SHA256SUMS` was not present during report finalization, so
  the reconstruction hash below was recomputed directly and that manifest gap
  remains open.
  Reconstruction SHA-256
  `6d48847949e2b37c3a87557df9fa4147c9b1305d8469c7c06965c62b99fcbf92`.
- **Wu--Ding--Chen**, arXiv `2312.05534`.
  **Read depth: partial**; read the material around Lemma 5 and Theorem 6 on
  deep holes and MDS extensions.  Cache SHA-256
  `9fe6878668bafce0ba1eb759f9fee16ab10f77b5520b47eb1c4626aec5f76000`.
- **Li--Lu--Ling--Lam**, arXiv `2605.12133`.
  **Read depth: partial**; abstract, introduction, and Theorem 1.  Used for the
  forward-construction ceiling, not an inverse theorem.  Cache SHA-256
  `8f854dcb3ad549b8bfdcaac6f585edc9d9516c7ea9674e970f54020657c0fa7d`.

### Clebsch-II sources

- **Rodríguez-Pajares--Ruano--Salizzoni**, arXiv `2512.16766`.
  **Read depth: full text.**  Theorem 3.11 and Corollary 3.13 are the
  load-bearing collision; the paper explicitly imports Eisenbud--Popescu
  Theorem 7.3.  Cache SHA-256
  `9dc89d58c45537bdd3d7844903da5de7d4d55aef9550dd6ddba36064c03882ca`.
- **Giudici**, arXiv `math/0703685`.
  **Read depth: full text.**  Used for the projective subgroup-classification
  ceiling.  Cache SHA-256
  `2c829b573dadf9ee2c71a9f85f92e1fb2d7443f64242dbe4a829c6246d9ae8e9`.
- **Dickson**, sections 260--262 of the consulted edition.
  **Read depth: partial.**  Used for the classical subgroup/module boundary.
  Cache key `IA:lineargroupswith00dickrich`; SHA-256
  `c03060b341dcf69ba0376f6fe4d23010460185892f806a28f4178444fd6ee00a`.
- **Guralnick--Zieve**, DOI `10.4007/annals.2010.172.1315`.
  **Read depth: partial**, Appendix A.  Used for the projective subgroup
  boundary.  Cache SHA-256
  `470b15d0a217c7acdd1378f1066f7249ba7272057c9c4a60bec60942bbdc3d35`.

### Clebsch-III coverage

The scout relied on the paper's existing sixteen-source audit rather than
repeating it.  That audit records **three full-text sources** and its own
partial/metadata sources, queries, and uncovered databases.  This report
inherits its qualified negative verdict but does not silently upgrade any read
depth.

### Clebsch-IV ceiling sources

- **Droms--Mellinger--Meyer**, *LDPC codes generated by conics in the
  classical projective plane*, DOI `10.1007/s10623-006-0022-6`.
  **Read depth: abstract/metadata only.**  Used for the claim that the same
  (q=13) code and bounds appear in prior work; no stronger theorem is
  attributed at this depth and no cached full text was available to the scout.
- **Madison--Wu**, arXiv `1104.0324`.
  **Read depth: partial.**  Used for the dimension result.  Cache SHA-256
  `f3edf20a2b63286164b3aced06a04a9039d7bbba2eb955a6461b7f7e793f6343`.
- **Hollmann--Xiang**, arXiv `math/0503573`.
  **Read depth: partial.**  Used for the elliptic association-scheme
  background.  Cache SHA-256
  `c7da1c736b1d229228f74cbcc22a77dd848a512e206c1cb88462fc3fd513ab4b`.
- **Ma--Liu--Tian**, DOI `10.3934/math.20241421`.
  **Read depth: partial.**  Used for the recorded distance bound
  (8\le d\le12).  Cache SHA-256
  `47c0a52292517a1773a676e2422e7b5a4a7b4bae502b70c1015f8fe87c61c984`.

## Coverage and wording boundary

This was a bounded scout, not six independent submission-grade audits.  It
used existing manuscript audits where available and promoted only sources that
met the claim-level discriminator.  MathSciNet was not accessible, automated
Google Scholar was not used, and several published versions or complete cache
hashes remain to be recovered before manuscript citation.  Therefore:

- **VERIFIED COLLISION** licenses attribution repair and demotion of the
  collided claim, not a statement that the rest of the literature is empty;
- **CLOSE CEILING** means that a neighboring mechanism or special case is
  known and the manuscript must distinguish its scope precisely;
- **NO COLLISION LOCATED** means only that this bounded pass and any inherited
  audit found none; manuscript wording remains “we have not located” or “to
  our knowledge,” never “first.”

## Mystery ledger

- **Settled:** Paper II's general self-associated/Schur-square/AG mechanism is
  prior structure; the exact trade classification and signed cubic survive.
- **Settled:** the qubit part of AME LU-to-LC rigidity has a classical
  minimal-support route; the paper's all-prime-power additive scope and atlas
  remain the proper claim.
- **Settled:** the PRS higher-Lucas endpoint criterion has a direct
  predecessor; the (e_7) orbit and coherent-Hankel realization remain the
  paper-owned frontier.
- **Open, C794:** replace the exact seven-vertex base by a human proof and close
  the reverse two-graph literature audit.
- **Open, PRS:** determine whether all higher Lucas carriers admit a uniform
  subspace-polynomial classification or require several digit-pattern
  families.
- **Open, Paper IV:** determine the exact field range in which minimum supports
  reconstruct the elliptic/passant incidence.
- **Open, AME--LU:** decide whether low-order connected correlations recover
  the exact atlas symmetry group or only a larger tensor stabilizer.
- **Open, Paper II:** resolve the (q=121) nonretracting module gate for the
  trade-only classification.

No other genuine mystery was isolated by the bounded scout.  The negative
verdicts remain limited by the stated database and read-depth gaps.
