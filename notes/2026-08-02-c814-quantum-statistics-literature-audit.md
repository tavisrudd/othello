# C814 — continuous-control and complex-conference literature boundary

**Date:** 2026-08-02

**Lane:** `golden`

**Scope:** the C814 exchange-sector Pareto theorem and the order-six complex
Hermitian conference holonomy/rigidity theorem

## Verdict

Two sources were consulted directly, one at **full-text** depth and one at
**partial** depth.  A third full-text source record is inherited from C788's
audited reading.  This is a bounded precedence check for results to be reviewed
later; it does not license a paper novelty claim.

- Et-Taoui already constructs the one-parameter Hermitian conference family
  of order six used by C814.  The family itself, and inequivalence of its
  parameters, are prior work.
- Uniform subframe bounds and spectral monomorphy are the two closest named
  frameworks.  They ask respectively for cut-independent extremal frame
  bounds and equality of characteristic polynomials of principal Hermitian
  blocks.  C814 instead computes squared cross-block spectra and all degree-three
  Schur sectors.
- Bargmann/triple products are established switching invariants in frame and
  quantum-state geometry.  C814 makes no novelty claim for the invariant or
  terminology.
- No consulted source states the exact formulas
  \(e_3=4(5-r_T^2)/125\), \(h_3=(317-4r_T^2)/125\), and
  \(s_{(2,1)}=(196+4r_T^2)/125\), or classifies order-six Hermitian conference
  matrices having cut-independent *squared* balanced spectra.  That is only a
  qualified candidate result because the search gaps below remain open.
- The continuous-control theorem synthesizes earlier Golden results with a new
  convexity reduction and spectral lemma.  Its precise joint-Pareto statement
  was not found in the bounded search, but no priority conclusion is drawn.

Recommended promotion language is: “For the Golden order-six representative
we prove ...” and “Within the order-six Hermitian conference class we prove
...”.  Do not use “first”, “new”, or an unqualified “to our knowledge” until a
publication-stage audit closes the stated gaps.

## Source records

### B. Et-Taoui, *Complex conference matrices, complex Hadamard matrices and
complex equiangular tight frames*

- Identifier: arXiv `1409.5720`, v1.
- **Read depth: full text.**  Read all sections of arXiv v1.
- Access: shared cache key `arXiv:1409.5720`; SHA-256
  `eb45c19abf8fb8ea10c4263c9659e1af9b80050899c38085cf8ed846e582ca66`.
- Load-bearing content: the paper exhibits a one-parameter complex Hermitian
  conference family \(C_6(b)\) and records inequivalence of parameters.  C814
  uses \(C_6(i)\) as an exact counterexample to real balanced-cut rigidity.
  The paper does not discuss balanced cross-block squared spectra or their
  Schur-sector exchange statistics.

### Cheng--Lv--Sun, *Frames of uniform subframe bounds with applications to
erasures*

- Identifier: DOI `10.1016/j.laa.2018.05.025`.
- **Read depth: partial.**  Read the publisher HTML abstract, introduction,
  Definition 1.1, roadmap, and visible references.  Full text was not reached.
- Access: ScienceDirect publisher HTML; the DOI was not present in the shared
  full-text cache.
- Load-bearing content: the visible sections define frames for which all
  subframes of a fixed cardinality have common optimal upper and lower frame
  bounds.  This is the closest frame-theoretic umbrella found.  The partial
  read does not support a negative about the paper's later classification
  results, so full-text comparison remains an explicit promotion gap.

### Attas--Boussaïri--Souktani, *Characterization of \(k\)-spectrally
monomorphic Hermitian matrices*

- Identifier: arXiv `1907.05817`; published DOI
  `10.1142/S1793830925500399`.
- **Read depth: full text, inherited from the C788 audit.**  C788 read arXiv
  v2, 27 July 2021, all sections; cache key `arXiv:1907.05817`, SHA-256
  `a51abeb59f39129514f87c4f28ace738c256679bc866ad3aeb7335662993afe0`.
- Load-bearing content: the paper classifies Hermitian matrices whose fixed-size
  principal blocks have equal characteristic polynomials.  C814's condition
  forgets eigenvalue signs by passing to squared/singular spectra, so it is not
  the same property.  See the full source record in
  `notes/2026-08-02-c788-balanced-cut-spectrum-literature-audit.md`.

## Search and screening record

Discovery queries run on 2026-08-02 included:

```text
complex Hermitian conference matrix order 6
"C_6(b)" conference matrix principal submatrix spectrum
"Hermitian conference" "uniform subframe"
"complex conference matrix" "principal submatrix" singular values
"Bargmann invariant" equiangular tight frame triples
"3-uniform frames"
"uniform subframe bounds"
```

The searches also surfaced work on robust Hadamard matrices and general
Bargmann invariants.  Those were screened from titles/abstract snippets and
were not used for a source characterization or negative verdict.  Exact-phrase
searches did not locate the C814 formulas or squared-spectrum classification;
this is a bounded search observation, not proof of absence.

## Coverage gaps

- The full Cheng--Lv--Sun paper was **NOT REACHED**.
- MathSciNet was **NOT COVERED** because institutional access is unavailable.
- Google Scholar was **NOT COVERED** because automated access is unavailable.
- zbMATH Open and citation graphs were not exhaustively screened.
- No subject expert was consulted.

Consequently both C814 theorem packages remain **research candidates for later
paper-inclusion review**, not publication-cleared novelty claims.

## Post-closeout scope note

The later `tt`+`ej`/`aa` pass in the main C814 report derives a general
three-subset holonomy formula and the exact order-six Hermitian-conference/
real-control Pareto edge.  No additional source search was performed for those
strengthenings.  They inherit every coverage gap above and must be treated as a
third research candidate requiring its own claim-level promotion audit, not as
an extension of this audit's bounded negative.
