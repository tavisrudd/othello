# C902 Paper III cheap-upgrade literature audit

Date: 2026-08-09

Scope: advisory audit only.  This report does not authorize manuscript, mirror,
portfolio, or public-summary edits.  The eight candidates are those fixed in
the C902 task card.

## Executive verdicts

| Candidate | Verdict | Reason |
|---|---|---|
| 1. Conductor-led abstract | **ACCEPTED, ALREADY LANDED; NO NEW WORDING** | The abstract and cover section already lead with the exact double cover and identify its pinching/conductor/discriminant class.  The square-class lemma is correctly presented as standard. |
| 2. Triangle--Pfaffian recognition | **ACCEPT, NARROWED** | The C809 argument gives a short exact converse in the all-nonzero, nonzero-proportionality locus, and its sign specialization gives the all-even-degree boundary.  Recommend a theorem after the existing four-shadow theorem, with no novelty or priority adjective. |
| 3. Determinant-line norm | **ACCEPT, NARROWED** | The C862 proof packet supplies a basis-free determinant-line interpretation and the exact identity `det[D_x,C]=8000 N(det B_x)`.  Recommend an unnumbered explanatory paragraph, not a new headline theorem. |
| 4. Marked spectral compatibility | **ACCEPT, NARROWED** | The manuscript already proves that deck exchange sends `C` to `-C`.  One sentence may observe that the generated *unmarked* algebra is unchanged, `Q[C]=Q[-C]`, while the relative marked generator changes sign.  Do not state a new theorem `E \cong Q[C]`. |
| 5. Principal-minor discoverability | **ACCEPTED, ALREADY LANDED; NO NEW WORDING** | The introduction already names principal-minor reconstruction, the graph benchmark, two-graphs, Seidel matrices, keywords, and MSC 05B20/05C22. |
| 6. C894 rooted exact sequence | **DEFER** | The internal proof packet is sound, but the task's institutional-search and external-specialist safeguards remain open.  It must not enter Paper III through this cheap-upgrade lane. |
| 7. Gaunt factorization proposition | **REJECT PROMOTION** | The existing named paragraph states the exact factorization and explains the multiplicity-one mechanism.  Numbering it would add visual and rhetorical weight without adding content. |
| 8. Portfolio generality fixes | **ACCEPTED, ALREADY LANDED; NO NEW WORDING** | The public portfolio already uses reconstruction/rigidity-first headlines, attributes the `q=11` forcing result to the computational companion, cross-links the all-plane and chord-defect results, and includes the infinite-family table. |

## Search and source-depth record

The audit used the repository literature cache and ledgers first, then bounded
exact web searches for the proposed converse-recognition formulation and the
standard background needed to classify its claims.  **Seven literature items
were available at full-text depth** (counting the two Hitchin papers
separately).  All other literature reads are explicitly partial or secondary.

### Full-text reads or inherited full-text reads

- Goethals--Seidel, *Orthogonal matrices with zero diagonal* (1967): `full
  text`; published version; shared-cache DOI key `10.4153/CJM-1967-091-8`, PDF
  and text extraction, SHA-256
  `68c0ef0b8fda6d44325382a047a873d2075ed2ad3cf9d0e6ec27ba7ace60b734`;
  inherited C755 forward-citation screening.
- Delsarte--Goethals--Seidel, *Orthogonal matrices with zero diagonal II*
  (1971): `full text`; published version; shared-cache DOI key
  `10.4153/CJM-1971-091-x`, PDF and text extraction, SHA-256
  `ff5a4a7c1deba6937a653829cb0699abfb44638eece05e021e3f131770a69a18`.
- Et-Taoui, *Complex conference matrices, complex Hadamard matrices and
  equiangular tight frames* (2014): `full text`; arXiv v1; shared-cache key
  `arXiv:1409.5720`, PDF and text extraction, SHA-256
  `eb45c19abf8fb8ea10c4263c9659e1af9b80050899c38085cf8ed846e582ca66`.
- Hitchin, *Spherical harmonics and the icosahedron* (2007): `full text`; arXiv
  v1; shared-cache key `arXiv:0706.0088`, PDF and text extraction, SHA-256
  `33cb8b2e5b7102c0adaeb1c00af1e8d1702f5fd086fa1abfddb739c149d05eeb`.
- Hitchin, *Vector bundles and the icosahedron* (2009): `full text`; arXiv v1;
  shared-cache key `arXiv:0906.4208`, PDF and text extraction, SHA-256
  `7da4fb227846551a788821d2a6f8082aa4e75088d34633934ba34c4e7f59b722`.
- Howard--Millson--Snowden--Vakil, *A description of the outer automorphism of
  S6, and the invariants of six points in projective space* (2008): `full text`;
  author-hosted published-version PDF; shared-cache key
  `10.1016/j.jcta.2008.01.004`, SHA-256
  `a875f0bccccc42db97703e9cadf52648a3f4e41b429abd0b05ef84bf6725043c`;
  inherited C755 citation audit.
- Pouzet--Si Kaddour--Trotignon, *Claw-freeness, 3-homogeneous subsets of a
  graph and a reconstruction problem* (2011/2013): `full text`; arXiv preprint
  v2 rather than the published version; shared-cache key `arXiv:1309.1835`, PDF
  and text extraction, SHA-256
  `a0d71732a15b440d4658dd08eddce29cc544ccde32a5b753911ef9635cf8a39b`.

C809 and C862 were also read in full as internal proof authority; they are not
counted as literature or used as precedence evidence.

### Partial reads

- Haemers--Parsaei Majd, *Spectral symmetry in conference matrices* (published
  2022): `partial`; relevant conference-bordering and order-six passages;
  shared-cache DOI key `10.1007/s10623-021-00858-8`, PDF and text extraction,
  SHA-256
  `86a4d6e41f62ef224f5a410653120794bf756ad9a9e2dc2aaa4bdc2f4f4c799e`.
- Brouwer--Van Maldeghem, *Strongly Regular Graphs*: `partial`; author-hosted
  preprint, §§1.1.12, 8.2, 8.10, and the relevant Clebsch/switching passages;
  shared-cache record inherited from C876, SHA-256
  `fa73d72e86bbd8dc3fbfcbca45679cb8f2671d777e91c009eeff0a563fd9289d`.
- NIST DLMF §34.3.22: `partial`; current official HTML formula page, accessed
  2026-08-09, no shared-cache artifact; read the Gaunt-integral formula and its
  `3j`-symbol normalization note.
- Javanpeykar--Loughran--Mathur, *Good reduction and cyclic covers* (published
  JIMJ 2024): `partial`; current official Cambridge HTML, accessed 2026-08-09,
  no shared-cache artifact; read Remark 3.11 on a root line bundle plus branch
  section.
- Steinhardt--Nelson--Ronchetti, *Bond-Orientational Order in Liquids and
  Glasses* (1983): `partial`; publisher full-text endpoint yielded only a
  partial cached extraction; shared-cache DOI key `10.1103/PhysRevB.28.784`,
  SHA-256
  `0efaad674f48c98b716e6732c63e2b04b0d5339c0844c733e72d09d58d041fc5`.
- Cohan, *The spherical harmonics with the symmetry of the icosahedral group*
  (1958): `publisher extract only`; shared-cache DOI key
  `10.1017/S0305004100033156`; the cached response is rejected HTML, not full
  text, SHA-256
  `0accf9c537d0f86cc5b4b7dcb8abab8dfebadda89b6d9737c042bc7459f860ab`.

### Forward-citation and exact-query coverage

- Inherited C755 three-service screening for Howard--Millson--Snowden--Vakil:
  OpenAlex/Crossref/Semantic Scholar counts `28/9/40`; the largest service set
  was screened.
- Inherited C755 screening for Goethals--Seidel: counts `213/117/146`; 200 of
  213 OpenAlex records were retrieved, so that branch is explicitly incomplete.
- Exact searches included combinations of “triangle”, “Pfaffian”, “conference
  matrix”, “commutator diagonal”, “principal minors”, and “orthogonal matrices
  with zero diagonal”.  They recovered neighboring conference-matrix,
  two-graph, OMZD, and principal-minor literature, but no exact statement of the
  proposed triangle--Pfaffian converse.

### Coverage limits and claim policy

MathSciNet review text, Scopus, and Google Scholar were not covered.  The
Goethals--Seidel OpenAlex retrieval was incomplete, and inaccessible Seidel
survey material was not reconstructed from snippets.  Consequently the
recognition wording may say only “we prove”; it may not say “new”, “first”,
“apparently unknown”, “not previously observed”, or any equivalent absence or
priority claim.  The determinant-line norm is presented as an interpretation
of the paper's formula, not as a literature novelty.

Candidate 6 has a stronger local gate: C894's institutional database query and
external finite-geometry/character-sum specialist check remain unsatisfied.
Nothing in this bounded audit closes those human gates.

## Ownership implications

The three surviving recommendations belong to the later integration owner,
after the Paper III formal-closure and API-reconciliation lanes.  C902 itself
changes no manuscript.  Candidate 2 should receive a new claim-ledger row;
candidates 3 and 4 amend the existing determinant and orientation rows.
