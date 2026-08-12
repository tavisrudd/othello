# C909 — priority audit for the proposed epilogue cycle package

Date: 2026-08-12
Status: bounded, convention-compliant positioning audit; no manuscript,
blueprint, PDF, mirror, Lean, or bibliography edit

## Opening audit statement

**Full-text count: 2.**  The two full sources are De Concini--Eisenbud--
Procesi and Yu, identified below.  Six further sources were read at the
recorded partial depth.  This audit also reuses the full De
Concini--Eisenbud--Procesi reading recorded in
[`2026-08-11-c909-four-slot-pluecker-literature-audit.md`](2026-08-11-c909-four-slot-pluecker-literature-audit.md)
and the partial-source records in
[`2026-08-11-c909-etale-saturation-priority-audit.md`](2026-08-11-c909-etale-saturation-priority-audit.md);
the reuse is explicit rather than inferred from cache presence.

The planned statements divide into three claims.

* **(A) Marked finite-etale PD saturation.**  A *marked* polarized
  elliptic-power graph presentation, with its elliptic ruling, self-dual
  graph kernel, orthogonal depth decomposition, block-respecting
  (B)-self-adjoint finite-etale slope algebras, has its prescribed graph
  Néron--Severi lattice generated after finite unramified splitting by
  genuine rank-one square-zero divisor forms.  Hence every divided power of
  every divisor in that lattice is an ordinary integral divisor product.
* **(B) The actual rank-five six-axis packet.**  At a non-CM fibre of the
  six-axis construction, the preceding graph lattice is the full
  Néron--Severi lattice and
  (operatorname{Hdg}^{2k}=P^k) in all degrees.  This is an *ambient Hodge*
  conclusion, stronger than (A), and rests on the printed two- and
  three-primary four-slot calculation.
* **(C) The comparison tower.**  For the one-depth rank-five packet with
  five pairwise distinct slope roots modulo (p),
  [
    operatorname{Hdg}^{4}/P^2\simeq
    operatorname{Hdg}^{6}/P^3\simeq(\mathbf Z/p^a)^5,
  ]
  other quotient degrees vanish, and multiplication by the polarization
  gives the stated theta-complement isomorphism.  This is a sharpness
  calculation for a different packet, not a claim about the cubic packet.

Within the recorded search and source boundary, no source was found stating
any of these exact integral claims.  The defensible posture is **a bounded
negative and a new synthesis/theorem package**, never ``first'' or an
unqualified ``to our knowledge.''  The old inputs are more specific: tropical
midpoint inequalities, unweighted integral Plücker straightening, rational
divisor generation, and integral Fourier/divided-power technology.  None of
those inputs supplies the signed DVR lifting, exact graph coefficient lattice,
or the rank-five Smith quotient.

## Exact search protocol and coverage

The search was deliberately claim-shaped, not a broad census.

| Batch | Verbatim queries | Screened set and method | Outcome |
|---|---|---|---|
| Graph/isogeny and integral Hodge | `"finite etale" graph isogeny "divisor" "elliptic curves"`; `"integral Hodge" "divisor products" "elliptic curve" isogeny`; `"Plucker" "Smith" "abelian variety" integral Hodge`; `"self-adjoint" graph "principal polarization" elliptic power` | 16 rendered general-web result snippets, screened by title, URL, and search snippet; no abstract or full text was imputed to unpromoted entries | No exact graph-lattice or all-degree PD theorem located. |
| Tropical midpoint skeleton | `"Yu tropical positive semidefinite cone symmetric matrices valuations rank one generators"`; `"tropical PSD" "Yu" symmetric matrix`; `"tropical positive semidefinite" "rank one" symmetric matrices` | 3 rendered result snippets, screened by title/URL/snippet; Yu promoted and read in full | Located the tropical inequality/cone source, not an integral lift. |
| DVR rank-one and product lattice | `"symmetric matrix of ideals" "rank-one" DVR`; `"lattice" "symmetric matrices" "rank one" DVR valuation`; `"tropical PSD" integer lattice rank one symmetric forms`; `"ordinary products of divisor classes" "integral" abelian variety` | 15 rendered general-web result snippets, screened by title, URL, and snippet | No exact symmetric-ideal-lattice, graph-isogeny, or ordinary-product predecessor located. |
| Targeted local corpus | The two C909 audits linked above, searched at their listed theorem loci and source registers | Eight promoted source records; two full and six partial readings listed below | Separates the closest standard ingredients from (A)--(C). |

These are rendered-result counts, not claims of search-engine exhaustiveness.
No forward-citation enumeration was used: **OpenAlex, Crossref, and Semantic
Scholar were not queried**, so no citation count or forward-tree negative is
asserted.  **MathSciNet: NOT COVERED** (authentication unavailable).
**Google Scholar: NOT COVERED** (automated access blocked).  **zbMATH Open:
metadata discovery only, not a systematic screen.**  Thus a future manuscript
``to our knowledge'' sentence would still need a wider, pinned-ID search.

## Closest sources and the exact priority boundary

Every named source in this report carries its reading record.  “Partial”
means only the listed portions bear the characterization.

1. **C. De Concini, D. Eisenbud, and C. Procesi, _Hodge algebras_,
   Astérisque 91 (1982).**  **Read depth: full text.**  Accessed from the
   cached Numdam scan, cache key `AST_1982__91__1_0`, SHA-256
   `fa857ea1c610f15d008f49e2b99966454ba4892b0a4d9bf34903e27731b8425f`;
   all 88 pages, including the standard-monomial/Plücker material used in the
   four-slot audit, were read.  It supplies integral unweighted Plücker
   straightening with unit coefficients.  It does not state a rescaled graph
   lattice, a (p^a)-Smith calculation, a finite-etale graph quotient, or
   ordinary divisor-product saturation.

2. **J. Yu, _The tropical positive semidefinite cone_,
   arXiv:1309.6011v1.**  **Read depth: full text.**  Accessed from cache key
   `arXiv:1309.6011`, SHA-256
   `ed4e28307e5ac1815d3f391118a7a37548a4a8df070cd2aefec0bef49b6faea6`;
   all 5 pages were read.  Theorem 1 gives the tropical condition
   (x_{ii}+x_{jj}\leq2x_{ij}), and Theorem 4 identifies the tropical PSD
   cone with the tropical convex hull of rank-one symmetric matrices.  This
   is the correct predecessor for the *valuation skeleton*
   (2e_{ij}\geq a_i+a_j).  It neither proves the integral signed
   three-rank-one lift (especially at (2)) nor any assertion about abelian
   varieties or divided powers.

3. **J. S. Milne, _Lefschetz classes on abelian varieties_, Duke
   Mathematical Journal 96 (1999), DOI `10.1215/S0012-7094-99-09620-5`.**
   **Read depth: partial.**  Accessed as the cached author PDF, cache key
   `10.1215/S0012-7094-99-09620-5`, SHA-256
   `28ae245e58748438b7070680cac83f8b2f695c43f1643b59cde21eb94077fe53`;
   Introduction and the passage containing Theorem 3.2 were read.  The cited
   conclusion is rational/Weil-cohomological divisor generation.  It cannot
   determine an integral product index and so is not a predecessor for
   (A)--(C).

4. **B. Moonen and A. Polishchuk, _Algebraic cycles on abelian varieties
   and the Fourier transform_, arXiv:0904.3995v1.**  **Read depth:
   partial.**  Accessed from cache key `arXiv:0904.3995`, SHA-256
   `ecb7b3882c96609b1c66f8012fd1adc9dd61a82c936c7fbecd17f097192007c4`;
   Introduction and Section 3 were read.  It provides divided-power/Fourier
   context in Chow theory, not the ordinary cohomological product lattice of
   a marked graph quotient.

5. **O. Beckmann and J. de Gaay Fortman, _Integral Hodge conjecture for
   one-cycles on abelian varieties_, arXiv:2202.05230v2.**  **Read depth:
   partial.**  Accessed from cache key `arXiv:2202.05230`, SHA-256
   `ab63a64cc5be9444c4eb36609f4831e662e0f95b19e9be07d5ddb5d7d82f9fbc`;
   abstract, introduction, Theorem 1.1, Theorem 3.8, and Corollary 4.1 were
   read.  It is a genuine integral-Fourier/minimal-class antecedent, but does
   not calculate (P^k\subseteq\operatorname{Hdg}^{2k}) for the weighted
   finite-etale graph lattices here.

6. **X. Roulleau, _The Fano surface of the Klein cubic threefold_,
   arXiv:1002.4467v1.**  **Read depth: partial.**  Accessed from cache key
   `arXiv:1002.4467`, SHA-256
   `c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd`;
   Introduction and Section 3.2/Theorem 11 were read.  It supplies the
   special Fano-surface configuration used to construct the six axes, not the
   graph kernel calculation or full integral Hodge/product equality in (B).

7. **M. Hartlieb, _Special subvarieties in the locus of intermediate
   Jacobians of cubic threefolds_, arXiv:2304.03214v2.**  **Read depth:
   partial.**  Accessed from cache key `arXiv:2304.03214`, SHA-256
   `3e6e55c0277b44fadbcbea8cd9f1d4501d307caaab6d6fd5314af36c0b49ab01`;
   Section 5.3, Lemma 5.5, Proposition 5.7, and Remark 5.8 were read.  The
   paper identifies the one-dimensional special (A_5) period component and
   an isogeny-to-(E^5) feature; it does not prove (B).

8. **I. Dolgachev and D. Lehavi, _On isogenous principally polarized
   abelian surfaces_, arXiv:0710.1298v3.**  **Read depth: partial.**
   Accessed from cache key `arXiv:0710.1298`, SHA-256
   `0dcfa76fdac989d5ede8025a7251ebf96a77a3d4c02b20b932dc6b51f716fd1e`;
   Introduction and Section 2.1, including Proposition 2.1 and Corollary
   2.2, were read.  It is cited only for standard maximal-isotropic principal
   quotient descent, not for the new integral lattice assertion.

### Claim-by-claim conclusion

| Planned claim | What is genuinely covered by predecessors | What remains unlocated in this bounded audit | Required wording |
|---|---|---|---|
| (A) all-degree marked finite-etale PD saturation | Yu: tropical midpoint cone; De Concini--Eisenbud--Procesi: unweighted integral Plücker straightening; Dolgachev--Lehavi: principal quotient descent; Milne: rational divisor generation; Moonen--Polishchuk and Beckmann--de Gaay Fortman: divided-power/integral-cycle setting | The exact graph coefficient ideals, signed DVR rank-one lift without trace denominators, finite-unramified faithful-flat descent, and the all-degree ordinary-product conclusion | Call it a theorem proved here; make no priority superlative.  Credit the four inputs at their actual ranges. |
| (B) six-axis (g=5) full (operatorname{Hdg}=P) | Roulleau and Hartlieb: geometry/period locus; (A)'s algebraic mechanism; De Concini--Eisenbud--Procesi: unweighted four-slot relation | The repeated-root (2+2) and scalar-primary weighted four-slot calculation, and its conversion to all degrees in dimension five | State as the outcome of the printed local calculation for non-CM six-axis fibres.  Do not call it a generic finite-etale consequence. |
| (C) distinct roots give two copies of ((\mathbf Z/p^a)^5) | Yu and De Concini--Eisenbud--Procesi explain the midpoint and Plücker shapes | The exact four-slot Smith factor, its five-support sum, zero in other degrees, and the theta-complement identification | Present as a comparison/sharpness example, explicitly separate from the cubic packet. |

The audit therefore supports **proof compression, not attribution
compression**: replace the existing adjugate ladder only after the manuscript
prints the marked hypotheses, exact cross-ideal formula, rank-one identity,
square-zero realization, and descent.  The ordinary-product statement must
never be silently upgraded to a statement about all Hodge classes; that extra
step is special to the actual non-CM six-axis calculation.

## Owning ledger row and all surfaces that must be synchronized

The sole home for a priority sentence is
[`papers/cubic-stabilization-epilogue/claim-proof-novelty-ledger.md`](../papers/cubic-stabilization-epilogue/claim-proof-novelty-ledger.md).
Its current row **“Semisimple graph-slope primitivity”** is too narrow for the
planned package.  Before public manuscript text is changed, replace that row
with three rows, one for each of (A), (B), and (C), or explicitly make the
current row the parent and add (B)--(C) children.  Each should say only
“no exact predecessor located in the bounded audit recorded in this note” and
should name the above standard inputs.  It must not make an independent broad
novelty claim.

The following surfaces contain, repeat, or plan the affected result.  **None
was updated in this audit.**

| Surface | Required action before integration |
|---|---|
| `papers/cubic-stabilization-epilogue/claim-proof-novelty-ledger.md` | **Owner:** add/replace the three controlled rows and point to this audit; this is the only priority home. |
| `papers/cubic-stabilization-epilogue/sections/03-minimal-class.tex` | Replace the old “semisimple graph slopes” ladder only with the fully scoped (A) proof, then print the separate (B) and (C) local statements. |
| `papers/cubic-stabilization-epilogue/sections/01-introduction.tex` | Describe results, not novelty; distinguish marked graph saturation, six-axis ambient equality, and comparison defect. |
| `papers/cubic-stabilization-epilogue/sections/02-envelope.tex` | Cross-reference the actual six-axis packet only after the geometric realization and non-CM boundary are stated. |
| `papers/cubic-stabilization-epilogue/sections/05-synthesis.tex` | Keep the cycle conclusion fibrewise and nonrelative; do not turn (A) into a bare-ppav theorem. |
| `papers/cubic-stabilization-epilogue/cubic_stabilization_epilogue.tex` and its bibliography | Add only sources actually cited in prose (at minimum the classical input citations used in the new section); do not use the bibliography as a priority claim. |
| `papers/cubic-stabilization-epilogue/README.md` | Paraphrase the ledger row, rather than carrying an independent novelty claim. |
| `papers/cubic-stabilization-epilogue/verification/README.md` | Add the exact local table and theorem-scope checks if they become verification obligations; point priority wording back to the ledger. |
| `notes/2026-08-12-c909-epilogue-integration-blueprint.md` | Revise its “claim-ledger additions” and any unqualified “new” language to point to the ledger/audit once implementation begins. |
| `notes/2026-08-12-c909-epilogue-integration-cycle-audit.md` | Keep as the proof-scope audit; add only a pointer to this priority audit if the two reports are cross-linked. |
| `notes/2026-08-11-c909-etale-saturation-priority-audit.md` and `notes/2026-08-11-c909-four-slot-pluecker-literature-audit.md` | Preserve as underlying source evidence; no retroactive prose change is needed. |

## Mystery ledger / gates before a stronger public posture

1. MathSciNet has not been searched, and Scholar is inaccessible.  This
   blocks any global priority claim about integral divisor products on
   elliptic powers.
2. No triple-service forward-citation screen has been performed for the
   closest modern seeds (Milne is older but still has no such screen; Yu,
   Moonen--Polishchuk, and Beckmann--de Gaay Fortman are the most relevant
   searchable seeds).  The present negative does not cover their citing work.
3. A bibliography-level audit of all literature on integral Lefschetz/Hodge
   lattices on powers of elliptic curves remains open.  The current searches
   were exact-claim searches, not a classification of that field.
4. The proof obligations are mathematical rather than bibliographic: the
   integration must print the marked-presentation hypotheses and the exact
   two-/three-primary tables.  Without them, the priority boundary cannot be
   evaluated by a reader.

## One-line handoff

Safe positioning: **classical tropical and standard-monomial inputs explain
the shape, while the marked finite-etale integral graph lift and the two
rank-five Smith computations are unlocated in the bounded audit; keep all
novelty language ledger-bound and qualified.**

`go C909 clebsch literature-priority audit complete; use this report as the
sole cycle-side bounded-negative source.`
