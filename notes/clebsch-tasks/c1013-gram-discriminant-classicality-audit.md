# C1013 — Classicality audit for the Gram–discriminant hierarchy

**Date:** 2026-08-30
**Question:** Is the factorization
\(G_{d,r}=\Delta\Phi_{d,r}\), obtained by taking the norm of the
Vandermonde-divided exterior Veronese covariant, classical?
**Manuscript status:** no manuscript source was edited.
**Read-depth summary:** one source was read at **full text**, two at
**partial** depth, and one forward-citation set of 12 OpenAlex records was
screened over title, abstract, and full identifier metadata.

## Verdict

### 1. The mechanism is classical

The map underlying

\[
 \Psi_{d,r}=
 \frac{\ell_1^d\wedge\cdots\wedge\ell_r^d}
      {\prod_{i<j}[\ell_i,\ell_j]}
\]

is the classical Wronskian isomorphism/Hermite-reciprocity construction.
Abdesselam--Chipalkatti explicitly identify

\[
 \bigwedge^r S_d\simeq \operatorname{Sym}^r(S_{d-r+1})
\]

and obtain the Wronskian of pure powers by calculating the Vandermonde
determinant. McDowell--Wildon give an explicit modular Wronskian isomorphism
over an arbitrary field. Dividing an alternant by its Vandermonde is also the
standard Schur-polynomial mechanism.

Therefore the exterior covariant, its degree, its equivariance, and its
arbitrary-field representation-theoretic home are not new.

### 2. The normed factorization is classical-derived

None of the inspected theorem-level sources states

\[
 \det(B_d(\ell_i^d,\ell_j^d))
 =\Delta(F)\,
 B_d^{\wedge r}(\Psi_{d,r}(F),\Psi_{d,r}(F))
\]

or studies this norm as an invariant of the root form. But once the classical
Wronskian isomorphism and the invariant bilinear form are placed together, the
identity follows immediately by taking the induced norm of

\[
 \ell_1^d\wedge\cdots\wedge\ell_r^d
 =\left(\prod_{i<j}[\ell_i,\ell_j]\right)\Psi_{d,r}.
\]

The safe publication classification is therefore **classical-derived
corollary**, not a standalone novelty theorem. An exact historical occurrence
may still exist in symbolic or compound-matrix language.

### 3. The quartic square-class case is substantially pre-existing

Kaipa--Patanker--Pradhan identify the invariant quadratic form on binary
quartics, derive

\[
 36I(f)=\beta^2(\lambda^2-\lambda+1),
\]

and count the finite-field square cases in their line-orbit problem. Thus the
quartic residual factor and its all-\(q\) character count cannot be claimed as
new.

### 4. The plausible new payload begins after the factorization

The inspected sources do not formulate:

- the Gram determinant as the norm of the Wronskian covariant;
- the odd-degree alternating/Pfaffian square-class ceiling;
- the family of finite-field double covers
  \(y^2=\Phi_{2m,4}(\lambda)\) and their Frobenius biases;
- the split of the Gram-degeneracy divisor into collision boundary
  \(\Delta=0\) and interior divisor \(\Phi=0\) on configuration moduli;
- the exceptional \(q=11,13\) collapse to the harmonic design;
- the excess-automorphism and marking-reconstruction consequences.

These are **no-predecessor-located**, not certified absence claims. Any
paper-facing novelty sentence must remain “to our knowledge” and live first in
the owning paper's claim--proof--novelty ledger.

## Sources and read depth

### Abdesselam--Chipalkatti

- **Source:** A. Abdesselam and J. Chipalkatti, *On the Wronskian combinants
  of binary forms*, arXiv:math/0507488v1 (2005 preprint); the published
  version was not separately checked.
- **Read depth:** `full text`; all sections of the 16-page preprint were read
  from the cached text extraction. Load-bearing passages are §§1.3--1.6 and
  §2, especially the decomposition
  \(\bigwedge^rS_d\simeq S_r(S_{d-r+1})\), the symbolic Wronskian formula,
  and the Vandermonde calculation.
- **Cache:** `arXiv:math/0507488`, SHA-256
  `80a03f71ff56d212d1a84afd490434e8bb282cafa7a067b0a59f900b2a4b5a1d`.
- **Attribution boundary:** the source studies Wronskian combinants and the
  Grassmannian embedding. It does not mention Gram matrices, bilinear norms,
  discriminant factorization, or finite-field square classes. The statement
  that our norm identity is an immediate consequence is this audit's
  inference, not the authors' framing.

### McDowell--Wildon

- **Source:** E. McDowell and M. Wildon, *Modular plethystic isomorphisms for
  two-dimensional linear groups*, arXiv:2105.00538v3 (2022 preprint).
- **Read depth:** `partial`; abstract, §1, and §4 were read. These sections
  state and prove the explicit arbitrary-field modular Wronskian isomorphism.
- **Cache:** `arXiv:2105.00538`, SHA-256
  `8e9012cea77b2eca5aecf03238fd0565155a6941c89c98c422533d94aa94a890`.
- **Attribution boundary:** this source closes the broad claim that the
  Wronskian isomorphism itself needs a large-characteristic hypothesis. It
  does not, in the inspected sections, transport or evaluate an invariant
  bilinear norm.

### Kaipa--Patanker--Pradhan

- **Source:** K. Kaipa, N. Patanker, and P. Pradhan, *On the
  \(PGL_2(q)\)-orbits of lines of \(PG(3,q)\) and binary quartic forms*,
  arXiv:2312.07118v3 (9 August 2025).
- **Read depth:** `partial`; §§3--4 around equations (15)--(24), and
  Proposition 6.2 and its proof were read. These passages define the apolar
  invariant, relate it to the invariant bilinear form, derive the cross-ratio
  factor, and count its square classes.
- **Cache:** `arXiv:2312.07118`, SHA-256
  `2ea8efc04bbf42be0919288e5e3777a4010ae30940bf8fec3a5c32feef789752`.
- **Attribution boundary:** their result is a binary-quartic/line-orbit
  theorem. Connecting it to a four-point Gram shadow and reconstruction loss
  is this audit's inference.

## Forward-citation audit

### Pinned seed

- DOI: `10.1016/j.jpaa.2006.08.006`
- OpenAlex: `W1996830797`
- Semantic Scholar paper ID:
  `c1e44ced8a6372a1d886ba641bad4d0dac8ad33a`

### Independent counts

Retrieved 2026-08-30:

| Graph | Count | Empty/error distinction |
|---|---:|---|
| OpenAlex | 12 | HTTP-valid JSON seed and citing-work response; `meta.count=12`, 12 records returned |
| Semantic Scholar | 10 | HTTP-valid JSON; 10 records returned and `next` absent |
| Crossref | 7 | seed metadata field `is-referenced-by-count=7` |

Crossref's `/works` route rejected the attempted `reference:` filter with an
explicit `filter-not-available` validation error. Therefore Crossref supplied
an independent count but no enumerable citing set; this was not treated as an
empty result.

### Largest-set screen

The largest set was OpenAlex's 12 records. The screen covered `title`,
`abstract_inverted_index`, publication year, DOI, OpenAlex ID, and work type.
It contained two preprint/published duplicate pairs. The mechanical
discriminator was applied case-insensitively to title plus reconstructed
abstract:

```text
gram|discrimin|bilinear|quadratic|norm|veronese|finite field|wronsk|vandermonde|exterior|pleth
```

The only work promoted to theorem-level inspection was the modular
plethystic-isomorphism paper above. The other hits concerned plethysm,
Wronski-map degrees, polynomial-subspace equivalence, or linear combinants;
none advertised Gram norms or the residual invariant in its title or indexed
abstract. This is an abstract/metadata screen, not a full-text negative for
those works.

### Exact graph queries

```text
GET https://api.openalex.org/works/https://doi.org/10.1016/j.jpaa.2006.08.006
GET https://api.openalex.org/works?filter=cites:W1996830797&per-page=200&select=id,doi,title,publication_year,type,abstract_inverted_index,ids
GET https://api.semanticscholar.org/graph/v1/paper/DOI:10.1016/j.jpaa.2006.08.006?fields=paperId,title,citationCount,externalIds
GET https://api.semanticscholar.org/graph/v1/paper/c1e44ced8a6372a1d886ba641bad4d0dac8ad33a/citations?limit=100&fields=paperId,title,year,externalIds,abstract,url
GET https://api.crossref.org/works/10.1016/j.jpaa.2006.08.006
GET https://api.crossref.org/works?filter=reference:10.1016%2Fj.jpaa.2006.08.006&rows=1000&select=DOI,title,author,published,type
```

Raw responses are retained under
`/tmp/persistent/tavis/lit-search/audits/c1013/`. The load-bearing hashes are:

```text
openalex-seed.json                 801a0675f7d87254818e9a5b9222ea09890687c0d9789e3b431a224cde870db1
openalex-citations-abstracts.json 5581fa8d69cb972160285b05d96725a0dfe8af85a873c4d1214998ff221e1f5e
s2-seed.json                       37e19a9d1f4facc6f75403877de33148044ad8f4333d544dc34b073da25550dd
s2-citations.json                  61811fe06665d9a30d265a1c22fa6101b51432c0d9789e3b431a224cde870db1
crossref-seed.json                 30759cf15f0f3c7ee37ffb1f6e1893b658ee3981faaf19bfed17b3099e678ca3
crossref-citations.json            74305ff2c349a6c5eb9f7e94c502be164d0b78d9e2ff065042273a0636be542b
```

## Keyword searches

The following load-bearing web queries were run verbatim:

```text
Gram determinant Veronese curve discriminant binary form invariant apolar
"Gram determinant" "binary quartic" apolar invariant
exterior power rational normal curve Vandermonde discriminant invariant binary forms
determinant ([xi xj]^d) discriminant binary form
determinant pairwise brackets powers discriminant invariant theory
"Vandermonde-divided" exterior power Veronese covariant
wedge Veronese vectors divided by Vandermonde binary forms invariant
exterior power symmetric power SL2 Wronski map Vandermonde pure powers
Wronski map wedge powers binary forms rational normal curve
Hermite reciprocity wedge Sym^d binary forms Vandermonde
compound Veronese matrix Vandermonde quotient Schur polynomial binary forms
"Wronskian combinants of binary forms"
```

These located the exact Wronskian-isomorphism predecessor and the nearby
quartic finite-field result, but no source whose searchable presentation
combined the Wronskian map with its invariant Gram norm.

## Coverage gaps

- **MathSciNet:** NOT COVERED; institutional authentication unavailable.
- **Google Scholar:** NOT COVERED; automated access unavailable.
- **zbMATH Open:** exact-title and discriminator web searches were run, but
  no stable exhaustive result set was obtained; this licenses no negative.
- **Classical monographs and 19th-century sources:** the Wronskian paper's
  references establish that the combinant machinery is classical, but those
  originals were not inspected for the precise norm identity.
- **Published Wronskian article:** NOT SEPARATELY READ; the full-text reading
  was of arXiv:math/0507488v1.

These gaps require “to our knowledge” on any surviving novelty formulation.

## Surface-update checklist

This audit changes the earlier provisional classification from “possible
upward-judo theorem” to “classical mechanism plus potentially new downstream
interpretations.”

| Surface | Status |
|---|---|
| Manuscript | no novelty sentence present; not edited |
| Owning claim--proof--novelty ledger | no row yet; must be created before manuscript use |
| Results snapshot | no C1013 claim present; not edited |
| Public paper summary | no C1013 claim present; not edited |
| C1013 hierarchy note | updated to point to this audit and downgrade the factorization |
| C1012 sparse-shadow note | updated to keep priority on the reconstruction consequence, not the Wronskian mechanism |

## Publication advice

Do not headline “we prove a Gram--discriminant factorization” as though the
mechanism were new. Use the classical Wronskian isomorphism explicitly and
state the norm identity as the organizing lemma. Novelty, if the deeper audit
continues to survive, should be attached to a theorem such as:

1. an all-degree classification of the square-class shadow and its
   automorphism group;
2. the parity/no-go theorem plus arithmetic double-cover family;
3. a moduli theorem identifying and analyzing the interior degeneracy divisor;
4. a reconstruction theorem deriving exact marking fibres from these
   invariant colorings.

That is still a useful judo position: a classical map answers questions its
own literature did not ask. It is latent-consequence judo, not a newly
invented representation-theoretic engine.

## Mystery ledger — `ej` + `tt` closeout

| Feature | Status after closeout | Evidence gap or successor gate |
|---|---|---|
| Why the Vandermonde-divided wedge exists | **settled** | classical Wronskian isomorphism; full-text Abdesselam--Chipalkatti and partial McDowell--Wildon |
| Whether the quartic factor must be \(I\) | **settled** in nonmodular characteristic | degree-one Wronskian map plus self-duality/Schur uniqueness; small-characteristic semisimplicity must be stated separately |
| Whether the exact norm equation was printed classically | **open** | classical monographs, compound-matrix literature, MathSciNet, and original sources were not fully covered |
| Whether the norm gives a useful arbitrary-characteristic Gram shadow | **open** | the modular Wronskian map exists over every field, but the chosen invariant bilinear form may degenerate; compute the radical and divided-power normalization prime by prime |
| Whether higher \(\Phi_{2m,4}\) double covers or moduli divisors are prior | **open** | requires a separate theorem-level arithmetic/moduli audit, not merely the Wronskian citation graph |
| Whether the Paper V reconstruction consequence is pre-empted | **not located; still qualified** | audit harmonic-design and finite-geometry literature specifically for the \(A_5\subset PGL_2(11)\) marking fibre |

The cheap upgrade exposed by the closeout is the modular distinction:
**Wronskian covariance is all-field, while a nondegenerate Gram interpretation
is characteristic-sensitive.** No additional genuine mystery is manufactured
beyond the explicit gates above.
