# C775 — Literature audit: approximate rigidity of 2-uniform states

**Lane**: `ame-lu`.
**Audited material**: `2026-08-01-external-session-notes/approximate_rigidity_of_2uniform_states.md`
(Theorem A — discreteness from 2-uniformity; Theorem B — stability with a party-count-independent
constant; Proposition C — quantum Fisher isotropy; Corollary D — local gauge groups of 2-unitary
gates), read with the corrections in that directory's `README.md`.
**Target manuscript**: `papers/ame_lu` (*Local-Unitary Rigidity of Stabilizer AME States and
Transversal Clifford Groups of MDS--CSS Codes*), whose `sections/01-introduction.tex` already
concedes Rains, Van den Nest--Dehaene--De Moor, Tan, and Wirthmüller.

## Summary

Verdicts, one per claim:

| Claim | Verdict |
|---|---|
| 1. Discreteness from 2-uniformity alone | **PARTIAL** |
| 2. Stability with a party-count-independent constant | **CLEAR** |
| 3. Quantum Fisher isotropy | **PARTIAL** |
| 4. Local gauge groups of 2-unitary gates | **CLEAR** (downstream of claim 1) |

No full precedent was located for any of the four claims. The narrowing on claim 1 comes from two
sources the manuscript already cites: Wirthmüller (2011) settles the discreteness question
completely for **binary stabilizer** codes/states, and Tan (2026) computes the finite local symmetry
group of the **four-qutrit** AME state. Neither covers arbitrary local dimension or non-stabilizer
states, and Tan explicitly carries finiteness of the local symmetry group of an r-uniform state as a
*hypothesis* rather than a theorem — which is the strongest single piece of evidence that the
general statement was not available to an expert working on exactly this object in 2026. The
narrowing on claim 3 is that the quantum Fisher information (QFI) identity
`F_Q = 4 Var(M)` and the variance-plus-covariance decomposition over parties are standard
metrology results (Braunstein--Caves; Hyllus et al.; Tóth), so Proposition C is a specialization
of known machinery and must be written as a remark with citations, not as an independent theorem.

**Read depth**: 22 sources are named below, plus a screened set of 2 covered by a set record.
Five were read at **partial** depth (Wirthmüller, Ramadas--Lakshminarayan, Rather et al., and the
Rajchel-Mieldzioć et al. survey from cached full text; Tan from arXiv HTML full text via a
question-answering fetch). Fifteen were read at **abstract/metadata only** and two at
**secondary only** (Tóth 2012; the Bertini--Kos--Prosen dual-unitary parametrization).
**No source in this report was read cover-to-cover at full text.** Every
verdict below is therefore a *search* negative — "no predecessor was located under the stated
domain and stop condition" — not a reading of every candidate paper end to end.

## Coverage statement

**Searched and found nothing** (licenses the negatives below):

- arXiv API abstract search (`export.arxiv.org/api/query`), queries recorded verbatim per claim.
- OpenAlex works API (`api.openalex.org/works`), title-search and `cites:` filters.
- Crossref works API (`api.crossref.org/works/<doi>`).
- The shared literature cache at `/tmp/persistent/tavis/lit-search/` (`litcache.py list`, then
  `get` on the AME/entanglement-relevant keys), checked before any fetch.
- General web search (Anthropic WebSearch, US index) with the phrasings recorded per claim.

**Not covered — carry forward as open gaps:**

- **MathSciNet**: NOT COVERED (institutional authentication unreachable from this session). Every
  claim below keeps "to our knowledge".
- **zbMATH Open**: NOT COVERED in this pass. It is freely reachable and was simply not queried;
  this is a real gap for the mathematics-side literature (invariant theory / GIT statements about
  stabilizers of tensors), which is exactly where a claim-1 precedent would hide.
- **Google Scholar**: NOT COVERED (blocks automated access).
- **Semantic Scholar**: **PARTIALLY COVERED**. The `graph/v1/paper/search` endpoint returned
  HTTP 429 (rate limit) on both attempted keyword queries, and those were not retried. The
  `graph/v1/paper/arXiv:1102.5715/citations` endpoint *did* return successfully with an empty
  `data` array — that is an empty result, distinguished from an error by the presence of a
  well-formed JSON body with `"offset": 0, "data": []` rather than an HTTP error status. So
  Semantic Scholar covered the one forward-citation enumeration but not the keyword searches.
- **Full texts**: no PDF was fetched and newly cached during this audit; all cached bytes relied on
  were fetched in earlier sessions (dates and SHA-256 recorded below).

**Citation-graph triple check.** One verdict rests on enumerating a citing set — whether anyone
extended Wirthmüller's finiteness result beyond binary stabilizer codes. Seed resolved by pinned
identifier, not title search at query time: arXiv:1102.5715, OpenAlex `W4297688411`.

| Service | Query | Citing count | Notes |
|---|---|---|---|
| OpenAlex | `https://api.openalex.org/works?filter=cites:W4297688411` | 2 | Both screened, see claim 1 |
| Semantic Scholar | `https://api.semanticscholar.org/graph/v1/paper/arXiv:1102.5715/citations?fields=title,year,externalIds&limit=50` | 0 | Well-formed empty result, not an error |
| Crossref | `https://api.crossref.org/works/10.48550/arXiv.1102.5715` | n/a | HTTP 404 NOT FOUND — the record is not in Crossref |

The three services disagree, and the disagreement is itself the finding: the paper appears never to
have been journal-published, so Crossref has no record at all and Semantic Scholar has not linked
its citations. OpenAlex additionally carries a *duplicate* record for the same paper
(`W1610470066`, DOI `10.48550/arxiv.1102.5715`, 0 citations) alongside the primary
`W4297688411`. Any forward-citation reasoning about this seed based on one graph alone would have
been wrong. The union of citing works is the two OpenAlex ones.

**Screened set — citing works of Wirthmüller.** Size 2, provenance OpenAlex `cites:W4297688411`,
screened over title and year only (no abstract retrieved). Discriminator applied: *does the title
indicate a result about the identity component, dimension, or finiteness of a local-unitary
symmetry/automorphism group for states outside the binary stabilizer class?*
- "A Family of Quantum Codes with Exotic Transversal Gates" (2023, arXiv:2305.07023) — no.
- "On Groups in the Qubit Clifford Hierarchy" (2022, arXiv:2212.05398) — no.
Neither was promoted for individual reading; both are covered by this set record.

---

## Claim 1 — Discreteness from 2-uniformity alone

**The claim.** Every 2-uniform pure state of n qudits of local dimension q has
`G(ψ)/U(1)` finite: the Lie algebra of its product-unitary symmetry group is exactly the global
phases. No stabilizer hypothesis; covers non-stabilizer AME states and all prime and non-prime q.

**Verdict: PARTIAL.**

### What must be cited, and how the claim narrows

**Wirthmüller (2011), "Automorphisms of Stabilizer Codes", arXiv:1102.5715.**
*Read depth: partial* — cached full text read at the introduction (lines ~30--70 of the extraction),
the statement of Theorem 7 and its proof preamble, and Corollary 11. Cache key `arXiv:1102.5715`,
SHA-256 `5cfd43e7f314056c7c7f61e6da6599a56252a759c11552a7b2c4d50d736d8164`, fetched 2026-07-25 from
`https://arxiv.org/pdf/1102.5715`. Version read: the arXiv preprint; no journal version was located
(Crossref 404, see above), so no version comparison is possible.

Theorem 7 determines, for an isotropic subspace `L ⊂ V^P` free of zero, trivial and Bell factors,
the connected component of the local-unitary automorphism group explicitly as a torus:

> "Then after a suitable local symplectic transformation and for a suitable choice of the section
> σ: L → L̃ the connected automorphism group becomes
> `A_c(L,σ) = {(g_p)_{p∈P} ∈ (C_z)^P | Π_{s∈S} g_s = 1 for every protected class S ∈ S}`.
> Thus the dimension of this torus is |P| minus the number of protected contiguity classes."

and Corollary 11:

> "Let L ⊂ V^P be an isotropic subspace without zero factors. If every nontrivial qubit of P is
> protected then the group A(L) = A(L)/Z(L) is finite."

This is a complete answer to the discreteness question **for qubit stabilizer states and codes**,
including the exclusion of Bell factors that Theorem A's Remark 2 rediscovers as the m = 1 boundary.
It is already cited in `sections/01-introduction.tex` ("Wirthmüller determines the identity
component of the local-unitary automorphism group and gives a protected-qubit criterion for
finiteness"). Theorem A must therefore not be presented as first-ever discreteness. The residual
scope is: **arbitrary local dimension q, arbitrary (non-stabilizer) states, hypothesis =
2-uniformity rather than a code-theoretic protection criterion.** That residual scope is real and
was not located in any source.

**Tan (2026), "Transversal gates of the ((3,3,2)) qutrit code and local symmetries of the
absolutely maximally entangled state of four qutrits", arXiv:2601.19677, DOI
10.1007/s44464-026-00021-z.** *Read depth: partial* — arXiv HTML full text (`arxiv.org/html/2601.19677`,
v1 Jan 27 2026 / v2 May 6 2026) interrogated by targeted question-answering fetch for finiteness
statements, the Section 3.3 passage, and the bibliography; the surrounding proofs were not read.
Already cited in the manuscript.

Two findings, both load-bearing:

1. Tan's Theorem 5.3 computes the local symmetry group of the four-qutrit AME state explicitly:
   order 5832, five displayed generators. So the q = 3, n = 4 case is a *computed* instance of
   finiteness, and Theorem A must concede it.
2. In Section 3.3 Tan writes, verbatim: *"In general, for any r-uniform state |φ⟩, S(|φ⟩) ≤ U_D^⊗n
   whenever S(|φ⟩) is finite [7, Proposition 6]."* The reference [7] is Gour and Wallach,
   "Necessary and sufficient conditions for local manipulation of multipartite pure quantum states",
   New Journal of Physics 13, 073013 (2011), arXiv:1103.5096 (*read depth: abstract/metadata only*,
   arXiv abstract page; the abstract is about multipartite Nielsen majorization and SLOCC
   stabilizers, and contains no discreteness statement). The conditional phrasing "whenever S(|φ⟩)
   is finite" is the key evidence: an author writing in 2026 specifically about local symmetries of
   AME states treats finiteness for r-uniform states as an unresolved side condition, not as a
   citable theorem. This is my inference from Tan's phrasing, not something Tan asserts.

### Distinctions that must be maintained

Three different objects are routinely conflated in this literature, and the value of Theorem A
depends entirely on keeping them apart:

- **Equivalence of two states** (is ψ LU-equivalent to φ?) — this is what almost all of the AME
  literature does, and it is *not* the same question.
- **Symmetry group of one state** (what fixes ψ?) — Theorem A's question.
- **Stabilizer-state results** — a structural hypothesis Theorem A drops.

Papers checked and confirmed to be about *equivalence*, not about the symmetry group of a single
state:
- Ramadas and Lakshminarayan, "Local unitary equivalence of absolutely maximally entangled states
  constructed from orthogonal arrays", J. Phys. A 58, 125301 (2025), arXiv:2411.04096.
  *Read depth: partial* — cached full text mechanically searched for `symmetr`, `gauge`,
  `isotropy`, `finite group`, `local symmetr`, `stabilizer group`: **zero matches**. Cache key
  `arXiv:2411.04096`, SHA-256 `a73e8c2c48c2d55f07b1e34bc75ba0d18c7115ec4e65d412605f52bf7430c647`,
  fetched 2026-07-19. Already cited in the manuscript.
- Rather, Ramadas, Kodiyalam and Lakshminarayan, "Absolutely maximally entangled state equivalence
  and the construction of infinite quantum solutions to the problem of 36 officers of Euler",
  arXiv:2212.06737. *Read depth: partial* — cached full text mechanically searched for the same
  terms; the single `symmetr` match is "the symmetric group" in an unrelated context. Cache key
  `arXiv:2212.06737`, SHA-256
  `740ee6e03fcd77f320ff03233f6b9ab0a7fba32781aa0cac40b5e88ed0465655`, fetched 2026-07-19.

### The Rather--Burchardt--Życzkowski line specifically

The source note flags this line as the likeliest place for a precedent. The best available stop
condition is the group's own current survey:

**Rajchel-Mieldzioć, Bistroń, Rico, Lakshminarayan and Życzkowski, "Absolutely maximally entangled
pure states of multipartite quantum systems", arXiv:2508.04777v3, dated 25 June 2026.**
*Read depth: partial* — cached full text; title block and abstract read directly, then the whole
extraction (≈158 kB) mechanically searched for `local symmetr`, `symmetry group`, `Fisher`,
`gauge`, `isotropy`, `metrolog`. **One match total**, and it is the English verb "gauge the quality
of emerging quantum processors". Cache key `arXiv:2508.04777`, SHA-256
`bc8ee8fc5648b574dc8e994eb7d27b7ef213e1873a2204e4060cc3613e15760b`, fetched 2026-07-19; note the
cached bytes are v3 as confirmed by the internal date line. The survey does cover "an updated
summary of the number of local unitary equivalence classes" — again, equivalence, not symmetry
groups.

Reading (my inference, not the survey's claim): a June 2026 survey of AME states by the named group
that never mentions symmetry groups, Fisher information, or metrology is strong evidence that
neither Theorem A nor Proposition C exists inside that line.

### Adjacent invariant-theory framing — must be cited, and it sharpens the claim

Theorem A is, in geometric-invariant-theory language, the statement that every 2-uniform state is a
**stable** point for the action of `SL(q,C)^n` (finite stabilizer), not merely a polystable/critical
one. That translation is my own inference; none of the sources below states it. The relevant works:

- Bryan, Reichstein and Van Raamsdonk, "Existence of Locally Maximally Entangled Quantum States via
  Geometric Invariant Theory", Annales Henri Poincaré 19 (2018) 2491--2511, DOI
  10.1007/s00023-018-0682-6. *Read depth: abstract/metadata only* (OpenAlex record `W2744074143`).
- Bryan, Leutheusser, Reichstein and Van Raamsdonk, "Locally Maximally Entangled States of Multipart
  Quantum Systems", Quantum 3, 115 (2019), DOI 10.22331/q-2019-01-06-115. *Read depth:
  abstract/metadata only* — the journal landing page, abstract quoted verbatim by fetch. The
  abstract ends: "Finally, we give the dimension of the stabilizer subgroup S ⊂ SL(d_1,C) × ⋯ ×
  SL(d_n,C) for a generic state in an arbitrary multipart system and identify all cases where this
  stabilizer is trivial." This is a **generic-state** result: it says nothing about a *particular*
  2-uniform state, and so does not pre-empt Theorem A. It must nonetheless be cited, because it is
  the closest statement of the same shape and a referee will ask.
- Słowik, Sawicki and Maciążek, "Designing locally maximally entangled quantum states with arbitrary
  local symmetries", Quantum 5, 450 (2021), arXiv:2011.04078, DOI 10.22331/q-2021-05-01-450.
  *Read depth: abstract/metadata only* — journal landing page, abstract quoted verbatim by fetch:
  "We show how to design critical states with arbitrarily large local unitary symmetry." This is the
  **sharpest contrast citation available** and should go into the paper next to Theorem A: it
  demonstrates that 1-uniformity (criticality / locally maximally entangled) is nowhere near enough
  to force discreteness, since critical states with arbitrarily large *continuous* local symmetry
  can be built to order. It makes the jump from k = 1 to k = 2 the actual content of Theorem A
  rather than a technical convenience. I did not verify from the full text that their symmetry
  groups are positive-dimensional; the phrase "arbitrarily large local unitary symmetry" and "the
  unitary group of local mode operations" in the abstract indicate continuous groups, but this
  should be confirmed against the paper before the sentence is written into the manuscript.

Qubit-side adjacent work, located but not pre-empting (all *read depth: abstract/metadata only*,
arXiv abstract pages and web-search-surfaced abstracts):
- Walck and Lyons, "Maximum stabilizer dimension for nonproduct states", arXiv:0706.1785 (2007).
- Lyons and Walck, "Classification of nonproduct states with maximum stabilizer dimension",
  Phys. Rev. A 77, 022309 (2008), arXiv:0709.1105. These bound and classify the *maximum* stabilizer
  dimension for n-qubit nonproduct states (n − 1, attained by generalized GHZ, with an extra
  n = 4 class); they give no criterion forcing the dimension to zero, so they do not pre-empt.
- Gour, Kraus and Wallach, "Almost all multipartite qubit quantum states have trivial stabilizer",
  J. Math. Phys. 58, 092204 (2017), arXiv:1609.01327. Genericity, not a 2-uniformity criterion.

### Searched domain and stop condition

- arXiv abstract search `abs:"k-uniform states"`, 60 results requested, sorted by submission date
  descending: 26 entries returned, spanning 2014-07 to 2026-06. Screened over title and first author
  only; discriminator: *does the title indicate a result about symmetry groups, local unitary
  stabilizers, or rigidity of a single state?* Zero promotions — every entry is about construction,
  existence bounds, orthogonal arrays, masking, or linear-programming bounds.
- arXiv abstract search `abs:"k-uniform" AND abs:"local unitary"`: **0 results**
  (`<opensearch:totalResults>0</opensearch:totalResults>`).
- arXiv abstract search `abs:"stabilizer" AND abs:"local unitary" AND abs:"Lie algebra"`: 3 results,
  all Lyons/Walck, listed above.
- arXiv search `abs:"critical states" AND abs:"local symmetries"` and
  `all:"local symmetries" AND all:"entanglement" AND all:"critical state"`: 1 result each, both the
  Słowik--Sawicki--Maciążek paper.
- OpenAlex title search `absolutely maximally entangled local unitary symmetry group` and
  `title.search:"locally maximally entangled"`, plus the `cites:` enumeration recorded above.
- Web search phrasings: `k-uniform state local unitary symmetry group finite discrete no continuous
  local symmetries`; `"local symmetry group" pure state finite "maximally mixed" marginals
  "one-parameter" continuous local unitary stabilizer`; `"absolutely maximally entangled" state
  "local symmetry group" finite "no continuous" symmetries`; `multipartite pure state continuous
  local unitary symmetry exists if and only if correlation matrix singular`.
- **Stop condition**: stopped after the June 2026 AME survey, the two AME-equivalence papers, and
  the Tan paper all came back negative on symmetry-group finiteness, and after the qubit-side
  stabilizer-dimension line (Lyons--Walck, Wirthmüller, Gour--Kraus--Wallach) was exhausted without
  a q-general or non-stabilizer statement. **This is a finite search. It does not license "no such
  result exists"** — in particular the invariant-theory literature on stable points of
  `SL(d_1)×⋯×SL(d_n)` acting on tensors was not searched systematically, and zbMATH was not queried.
  Keep "to our knowledge" on every firstness sentence.

---

## Claim 2 — Stability with a party-count-independent constant

**The claim.** For 2-uniform ψ and `U = ⊗_j e^{i h_j}` with `Σ_j ||h_j||_op ≤ 1/2`, the defect
bounds the generator size: `D ≤ sqrt(6q/5) · eps(U)`, with the constant depending only on the local
dimension q and **not** on the number of parties n; plus Corollary B′ placing every sufficiently
small approximate product symmetry within `~1.1 sqrt(q) · eps` of an exact one.

**Verdict: CLEAR** — no predecessor located, subject to the attribution requirements below.

### What must be cited at point of use even though nothing is pre-empted

Theorem B is a second-order Taylor expansion of `|⟨e^{iM}⟩|` with a cubic integral remainder,
combined with the second-moment identity (★). Both halves have standard antecedents and the paper
should say so rather than let a referee find it:

- The identification of `eps²` with the Fubini--Study/Bures geometry, and of the quadratic form
  governing it with the quantum Fisher information, is Braunstein and Caves, "Statistical distance
  and the geometry of quantum states", Phys. Rev. Lett. 72, 3439 (1994). *Read depth:
  abstract/metadata only* — this is background attribution, not a precedent claim; the specific
  bibliographic detail here (volume/page/year) is from background familiarity and **must be
  re-verified from a consulted source before it enters the manuscript**, per the attribution rule.
  I flag it rather than assert it.
- Corollary B′'s argument shape — nondegenerate Hessian at each zero, compactness off the union of
  balls — is the standard Łojasiewicz/quadratic-growth argument and needs no citation, but the
  non-explicitness of ε₀ must be stated in the manuscript exactly as the source note already states
  it.

### The n-independence question specifically

Nothing was located that gives an n-independent robustness constant for the local symmetry group of
a k-uniform, AME, or perfect-tensor resource state. Two clarifications that matter for how the claim
is written:

1. **This is not self-testing.** Theorem B is a *local* stability estimate for the symmetry group of
   a known state under a norm bound on the generators. Device-independent self-testing bounds an
   unknown strategy's distance to an ideal state from observed correlations. Comparing the two
   constants directly, as the source note's "selling point" paragraph does, invites a referee
   objection. The manuscript should either restrict the comparison to "certification with trusted
   local measurements" or drop the self-testing framing.
2. The self-testing literature that *was* surveyed does show the size-dependence the source note
   asserts is typical, but I did not verify any specific bound's n-scaling from a full text. Sources
   located, all *read depth: abstract/metadata only* (search-result abstracts and arXiv abstract
   pages):
   - "Scalable self-testing of generic multipartite quantum states", arXiv:2605.15106 — abstract
     states prior protocols demand sample complexity exponential in the number of parties, and it
     achieves polynomial.
   - "Robustly self-testing all maximally entangled states in every finite dimension",
     arXiv:2508.01071 — δ = O(√ε) trace-distance robustness for *bipartite* maximally entangled
     states.
   - "Robust self-test of the maximally entangled state of two-qubits without assuming unitary
     observables", arXiv:2607.04035 — analytic O(√ε) robustness, two qubits.
   None of these is about AME/k-uniform resource states or about symmetry-group stability, so none
   pre-empts. Equally, none of them establishes the "typically degrade with system size" claim in
   the exact form the source note asserts; that sentence should be softened or supported by a
   specific cited bound.

### Searched domain and stop condition

- Web search: `self-testing robustness bound independent of number of parties graph states AME
  robust certification "does not degrade with" system size local unitary distance to exact
  symmetry`; `self-testing absolutely maximally entangled state certification robustness bound
  perfect tensor 2-unitary gate device independent`; `"approximate symmetry" quantum state "close to
  an exact" local unitary symmetry quantitative stability explicit constant perturbation of symmetry
  group multipartite`.
- Screened by title over the returned result sets (7--9 links per query); discriminator: *does the
  title indicate a robustness or stability constant for the symmetry group of a k-uniform, AME, or
  perfect-tensor state?* Zero promotions beyond the three listed above, which were promoted only to
  characterise the self-testing baseline.
- **Stop condition**: stopped after three independent phrasings returned only bipartite
  maximally-entangled-state self-testing and generic multipartite sample-complexity results, with no
  hit on symmetry-group stability for highly entangled resource states. Finite search; not a
  nonexistence claim. The approximate-representation / Ulam-stability literature (Gowers--Hatami and
  successors), which is the mathematically closest body of "approximate symmetry implies near exact
  symmetry" results, was **not** searched and is an open gap.

---

## Claim 3 — Quantum Fisher isotropy

**The claim.** For 2-uniform ψ and the local-generator family `U(s) = ⊗_j e^{i s h_j}`,
`F_Q = 4 Var_ψ(M) = (4/q) Σ_j ||h_j||_F²`, so the QFI form on traceless local generators is an
exactly isotropic multiple of the Euclidean form.

**Verdict: PARTIAL.** No paper stating this for k-uniform or AME states was located, but every
ingredient is standard metrology, and the claim must be narrowed accordingly.

### How the claim narrows

The content decomposes as: (i) `F_Q = 4 Var(M)` for a pure state under unitary encoding — Braunstein
and Caves (1994), textbook; (ii) `Var(Σ_j h_j) = Σ_j Var(h_j) + Σ_{j≠k} Cov(h_j, h_k)` — arithmetic;
(iii) 2-uniformity kills every covariance and pins every `Var(h_j)` to `tr(h_j²)/q`. Step (iii) is a
one-line marginal computation. The variance-plus-covariance decomposition over parties, and the
observation that it is precisely the cross-party covariances that carry any advantage over the
shot-noise limit, is the standing framework of the metrological-entanglement literature:

- Hyllus, Laskowski, Krischek, Schwemmer, Wieczorek, Weinfurter, Pezzé and Smerzi, "Fisher
  information and multiparticle entanglement", Phys. Rev. A 85, 022321 (2012), arXiv:1006.4366.
  *Read depth: abstract/metadata only* — arXiv abstract page; authors, journal, volume, article
  number and year taken from that page.
- Tóth, "Multipartite entanglement and high-precision metrology", Phys. Rev. A 85, 022322 (2012).
  *Read depth: secondary only* — named in the Hyllus et al. arXiv abstract page as the concurrent
  companion paper; that page is the only source consulted for it, and its own read depth is
  abstract/metadata only. The bibliographic detail is as recorded there.

Consequently Proposition C should enter the manuscript as an **explanatory remark with citations**,
phrased as "specializing the standard variance decomposition to 2-uniform states gives exactly …",
and it should not carry a firstness claim. The genuinely paper-owned part is the *interpretation* —
that the inverse stability constant of Theorem B is the flat Fisher metric of the local-unitary
orbit, with Bell and GHZ as the two complementary degeneracies. That framing was not located
anywhere and is the part worth keeping.

### Searched domain and stop condition

- arXiv abstract search `abs:"absolutely maximally entangled" AND abs:"Fisher"`: **0 results**.
- arXiv abstract search `abs:"quantum Fisher information" AND abs:"maximally mixed" AND
  abs:"marginals"`: **0 results**.
- The June 2026 AME survey arXiv:2508.04777v3 contains no occurrence of `Fisher` or `metrolog` (see
  claim 1 for the exact search and cache hashes).
- Web search: `quantum Fisher information "absolutely maximally entangled" states metrology standard
  quantum limit no advantage local generators variance`; `"metrologically useful" entanglement
  requires two-body correlations quantum Fisher information equals shot noise when two-body
  marginals maximally mixed k-uniform states useless metrology`; `"quantum Fisher information"
  decomposition "sum of variances" plus covariances local operators multipartite state vanishing
  two-body correlations shot noise exactly N Toth Hyllus`.
- One further item surfaced and worth recording as adjacent: "Universal Shot-Noise Limit for Quantum
  Metrology with Local Hamiltonians", arXiv:2308.03696. *Read depth: abstract/metadata only*
  (search-result listing; the abstract page itself was not opened). It is about shot-noise limits
  from local Hamiltonians and may or may not contain the k-uniform specialization — **this is an
  unclosed lead, not a cleared one**, and it should be opened before the manuscript sentence is
  finalized.
- **Stop condition**: stopped after two independent arXiv abstract queries returned literally zero,
  the AME survey returned zero, and three web phrasings returned only the generic
  QFI-and-entanglement literature. Finite search; the metrology corpus is large and was searched by
  abstract keyword only, so a buried statement in a review's worked-examples section would not have
  been found. Keep "to our knowledge".

---

## Claim 4 — Local gauge groups of 2-unitary gates

**The claim.** The local gauge group `{(u_1⊗u_2, v_1⊗v_2) : (u_1⊗u_2) W (v_1⊗v_2) = e^{iφ} W}` of any
2-unitary gate W is finite modulo global phase, and Theorem B transports verbatim to gates.

**Verdict: CLEAR** — no predecessor located. But note the verdict is *downstream of claim 1*:
Corollary D is the state--gate transport of Theorems A and B through the AME(4,q) ↔ 2-unitary
vectorization, so if claim 1 is later found pre-empted, claim 4 falls with it.

### Adjacent work that must be cited at point of use

- Rather, Aravinda and Lakshminarayan, "Construction and local equivalence of dual-unitary
  operators: from dynamical maps to quantum combinatorial designs", arXiv:2205.08842 (submitted
  2022-05-18, revised 2022-11-21). *Read depth: abstract/metadata only* — arXiv abstract page read
  by question-answering fetch, which reported no discussion of the stabilizer group of a gate under
  local unitaries. The paper *does* give "a necessary criterion for their local unitary equivalence
  to distinguish classes", i.e. the equivalence question, not the symmetry question — the same
  distinction as in claim 1. This is the natural citation for the statement that local gauge freedom
  is the standing nuisance parameter in the dual-unitary classification programme.
- Bertini, Kos and Prosen's complete parametrization of two-*qubit* dual-unitary gates, in which the
  local unitaries are an explicit gauge redundancy and the interaction parameter is the only
  invariant. *Read depth: secondary only* — characterised from a web-search synthesis of secondary
  pages (an IOPscience biunitary-model article page and the arXiv listing for arXiv:2210.13307),
  none of which was itself read beyond its abstract. **No Bertini--Kos--Prosen paper was opened in
  this audit and no bibliographic detail for it is asserted here**; it must be resolved from a
  consulted source before citation. Two qubits admit no 2-unitary gate, so this is context, not a
  precedent.
- The same secondary synthesis reports that for local dimension greater than 2, complete
  parametrizations of general biunitary connections remain absent. Attributed to the reviewer/search
  synthesis and **unverified against any paper**; treat as a lead, not a fact.
- Pahari, "Classification and Exact Local Masking in Finite-Field Clifford Dual-Unitary Circuits",
  arXiv:2607.00210 (submitted 30 June 2026). *Read depth: abstract/metadata only* — arXiv abstract
  page, abstract first sentence quoted verbatim by fetch: "We classify two-qudit Clifford
  dual-unitary gates over the finite field F_q, where the local dimension q is a prime power, and
  apply the classification to exact local masking and operator transport in homogeneous brickwork
  circuits", with q−2 perfect-tensor cores, one rank-one core and one SWAP core under ordered
  one-qudit Clifford equivalence. This is close to the lane's own territory and is a required
  citation for Corollary D, but it classifies *Clifford* gates up to Clifford equivalence and proves
  nothing about finiteness of the local gauge group of an arbitrary 2-unitary gate.

### Searched domain and stop condition

- arXiv abstract search `abs:"dual unitary" AND abs:"local unitary"`, 40 requested, sorted by
  submission date descending: 9 entries, 2019-12 to 2026-05. Screened over title and first author;
  discriminator: *does the title indicate a result about the group of local unitaries fixing a given
  gate?* Zero promotions; Rather et al. arXiv:2205.08842 was promoted on the strength of its
  equivalence-classification content, not a symmetry-group title.
- arXiv abstract search `abs:"perfect tensor" AND abs:"symmetr"`: 1 result, "Holographic Tensor
  Networks as Tessellations of Geometry" (arXiv:2512.19452), irrelevant on title screen.
- Web search: `"dual unitary" OR "2-unitary" gate "local gauge" group finite equivalence classes "up
  to local unitaries" classification nuisance`; `dual-unitary gate parametrization "local unitary"
  gauge redundancy residual discrete stabilizer counting parameters Bertini Kos Prosen classification
  two-qudit`.
- **Stop condition**: stopped after the dual-unitary abstract sweep and two web phrasings produced
  only equivalence-classification and parametrization work, with the gauge group appearing
  everywhere as a quotient to be divided out and nowhere as an object whose finiteness is proved.
  Finite search; the dual-unitary circuit literature is large and fast-moving, and only abstracts
  were screened. Keep "to our knowledge".

---

## Attribution / cite at point of use

Independently of any absence claim, the following should be cited where the corresponding statement
is used. Read depths are as recorded above.

| Source | Cite at | Why |
|---|---|---|
| Wirthmüller, arXiv:1102.5715, Thm 7 + Cor 11 | Theorem A | Settles discreteness for binary stabilizer codes, Bell factors excluded |
| Tan, arXiv:2601.19677, Thm 5.3 | Theorem A | Computed finite local symmetry group of AME(4,3), order 5832 |
| Słowik--Sawicki--Maciążek, Quantum 5, 450 (2021) | Theorem A | Critical (1-uniform) states with arbitrarily large local symmetry — shows k = 2 is doing the work |
| Bryan--Leutheusser--Reichstein--Van Raamsdonk, Quantum 3, 115 (2019) | Theorem A | Generic-state stabilizer dimension in `SL(d_1)×⋯×SL(d_n)`; the GIT-stability framing |
| Bryan--Reichstein--Van Raamsdonk, Ann. Henri Poincaré 19 (2018) | Theorem A | Existence of locally maximally entangled states via GIT |
| Lyons--Walck, Phys. Rev. A 77, 022309 (2008); Walck--Lyons, arXiv:0706.1785 | Theorem A | Maximum qubit stabilizer dimension; GHZ as the extremal case |
| Gour--Kraus--Wallach, J. Math. Phys. 58, 092204 (2017) | Theorem A | Genericity of trivial stabilizer |
| Braunstein--Caves (1994) — bibliographic detail to be verified | Theorem B, Prop. C | `F_Q = 4 Var`; Bures/Fubini--Study geometry of the defect |
| Hyllus et al., Phys. Rev. A 85, 022321 (2012); Tóth, Phys. Rev. A 85, 022322 (2012) | Prop. C | Variance-plus-covariance framework; covariances carry the metrological advantage |
| Rather--Aravinda--Lakshminarayan, arXiv:2205.08842 | Cor. D | Local equivalence classification of dual-unitary/2-unitary operators |
| Pahari, arXiv:2607.00210 | Cor. D | Finite-field Clifford dual-unitary classification, perfect-tensor cores |
| Ramadas--Lakshminarayan, arXiv:2411.04096; Rather et al., arXiv:2212.06737; Rajchel-Mieldzioć et al., arXiv:2508.04777 | Positioning | The AME literature's question is *equivalence of two states*, not the symmetry group of one |

Two attribution corrections to the source note itself, for whoever writes C776:

1. The note's sentence "Self-testing-type stability bounds typically degrade with system size" is
   asserted without a citation and was not confirmed by this audit for any bound comparable to
   Theorem B. Either support it with a specific cited bound or drop it.
2. The note's framing of Theorem B as directly enabling self-testing conflates a trusted-device
   local stability estimate with device-independent certification. See claim 2.

## C776 branch trigger

**Branch: discreteness survives as the headline, with a conceded-prior-art paragraph.**

Concretely, against C776's pre-registered branches:

- **Discreteness (Theorem A) is not pre-empted**, so it does *not* drop to a cited remark and
  stability does *not* have to become the headline. It must, however, be written with an explicit
  concession paragraph naming Wirthmüller for the binary stabilizer case and Tan for the four-qutrit
  case, and with Słowik--Sawicki--Maciążek as the contrast that makes 2-uniformity (rather than
  1-uniformity) the load-bearing hypothesis. The firstness sentence must be scoped to arbitrary
  local dimension and non-stabilizer states, and must retain "to our knowledge" because MathSciNet
  and zbMATH were not covered.
- **The Fisher item (Proposition C) survives as an explanatory remark with a citation**, exactly as
  pre-registered. It should not be a numbered theorem with a firstness claim; the cited framework is
  Braunstein--Caves plus Hyllus et al./Tóth, and the paper-owned content is the
  rigidity--metrology complementarity interpretation.
- **The gauge corollary (Corollary D) is retained as a corollary with citations**, not reduced to a
  citation and not dropped — no predecessor was located. Its citations are Rather--Aravinda--
  Lakshminarayan and Pahari.
- **Stability (Theorem B) is clear** and can carry the "explicit, party-count-independent constant"
  claim, provided the self-testing framing is corrected per claim 2.

**Gates that remain open before any firstness sentence ships**: zbMATH Open query; MathSciNet
(unreachable — permanent "to our knowledge"); the Ulam/Gowers--Hatami approximate-representation
stability literature for claim 2; arXiv:2308.03696 for claim 3; and confirmation from the
Słowik--Sawicki--Maciążek full text that their designed local symmetry groups are indeed
positive-dimensional.
