# 2026-08-20 — C816 work item 1: priority audit of the triangle–Pfaffian recognition theorem

**Task:** C816 (lane `clebsch`), work item 1 of
`notes/clebsch-tasks/c816-paper-iii-four-shadow-integration.md`.
**Governing conventions:** `notes/literature-audit-conventions.md`, binding in full.
**Subject:** `thm:triangle-pfaffian-recognition`,
`papers/clebsch-passages/sections/05-golden-operator.tex:311`.
**Status:** complete for the five bodies named in the work item, with the access gaps below carried
forward. Reading and searching only; the manuscript was not edited by this pass. The ledger row it
licenses is `OPER-5` in `papers/clebsch-passages/literature-boundaries.md`.

---

## Opening summary

**No source in this report was read at full text.** Six were read at `partial`: Tanturri's Pfaffian
representations of cubic surfaces, Beauville's determinantal hypersurfaces, Huang and Oeding's
symmetrization of principal minors and cycle-sums, Boussaïri and Chergui on skew-symmetric matrices
and their principal minors, Boege's almost-principal minors note, and Brouwer and Van Maldeghem's
*Strongly Regular Graphs*. Al Ahmadieh and Vinzant is at `abstract/metadata only` plus a term search;
the Ishikawa–Wakayama minor-summation line, Holtz and Sturmfels, Oeding, and Buckley and Košir are at
`abstract/metadata only` here, with Holtz and Sturmfels inherited at `full text` from the C880 audit.
Three citing sets were screened at title level. The per-source records below are authoritative.

**Nothing pre-empts the recognition theorem, and no adjacent-crown extraction is triggered.** The
converse direction — nonzero proportionality of the commutator Pfaffian to the triangle cubic forces
order six and forces \(A^2=\lambda I\) — was not located in any of the five bodies. The strongest
statement the search supports is a "we have not located" negative, not a claim of priority.

Three things the audit does change.

**First, the theorem's two ingredients each have a classical owner that the manuscript does not yet
name.** The existence side is Beauville's: which homogeneous forms are Pfaffians of skew matrices of
linear forms is settled in general there, and for cubic surfaces the explicit constructive theory is
Tanturri's, so a \(6\times6\) linear Pfaffian representation of a cubic surface is a known object and
must not be presented as one. The triangle cubic's coefficients are the order-three cycle products
whose sum is Huang and Oeding's order-three cycle-sum, and for a hollow symmetric matrix each equals
half the corresponding principal \(3\times3\) minor; the cycle-sum change of coordinates on principal
minors is theirs. What is paper-owned is the *comparison* of the two, in the specific commutator form
\(\Phi_A=\operatorname{Pf}[D_x,A]\), and the recognition direction.

**Second, the conclusion \(A^2=\lambda I\) has a standard name the manuscript is not using.** For real
symmetric hollow \(A\), the condition \(A^2=\lambda I\) says exactly that \(A/\sqrt\lambda=2P-I\) for
an orthogonal projection \(P\) of rank \(n/2\) with every diagonal entry \(1/2\) — equivalently, that
the rows of any factorization of \(P\) form an equal-norm tight frame of \(n\) vectors in
\(\mathbf R^{n/2}\). In the equal-modulus case this is the classical correspondence between
equiangular tight frames, regular two-graphs, and conference matrices that the series already cites
elsewhere. Naming it costs one sentence and connects the theorem's conclusion to the frame literature
the referee will have in mind.

**Third, the boundary sentence understates what is known and should be sharpened.** The manuscript
now closes with "the remaining weighted solutions of \(A^2=\lambda I\) are not classified," which
reads as an admission that the ambient set is mysterious. It is not: by the description above, the
solutions of \(A^2=\lambda I\) at order six form a set of dimension at least four — the Grassmannian
\(\mathrm{Gr}(3,6)\) has dimension nine and the constant-diagonal condition imposes at most five
independent equations, the trace being automatic — and it is nonempty at the conference point, where
all entries are nonzero, an open condition. What is genuinely unclassified is the smaller object: the
solutions of the *proportionality* among weighted matrices. Theorem D already says that locus is
rigid at either oriented golden representative with only the scaling direction, so the two sets have
different dimensions and the distinction is not cosmetic. The sentence should say which set it means.

## The statement being audited

Let \(A=(a_{ij})\) be real symmetric of even order \(n\geq4\) with zero diagonal and every
off-diagonal entry nonzero. Write
\[
 \mathcal T_A(x)=\sum_{|S|=3}\Big(\prod_{\{i,j\}\subset S}a_{ij}\Big)x_S,
 \qquad
 \Phi_A(x)=\operatorname{Pf}[D_x,A],
 \qquad x_S=\prod_{i\in S}x_i .
\]
The theorem asserts that \(\Phi_A=\mu\mathcal T_A\) with \(\mu\ne0\) forces \(n=6\) and
\(A^2=\lambda I\) with \(\lambda>0\); and that under the additional hypothesis of a common absolute
value for the off-diagonal entries, \(A\) is the pentagon conference matrix up to scale, switching,
and relabelling, with \(\Phi_A=\pm4\mathcal T_A\) and the sign the orientation character.

Two structural facts fix where in the literature a predecessor would sit. The commutator has entries
\([D_x,A]_{ij}=a_{ij}(x_i-x_j)\), so \(\Phi_A\) is the Pfaffian of a skew matrix of linear forms —
a linear Pfaffian representation. And for a hollow symmetric \(3\times3\) block,
\(\det A[S,S]=2a_{ij}a_{jk}a_{ki}\), so the coefficients of \(\mathcal T_A\) are half the principal
\(3\times3\) minors. The theorem therefore compares a Pfaffian representation against the principal
third-order minors, which places it between the determinantal-representation literature and the
principal-minor-assignment literature, with the conference-matrix and tight-frame literature holding
the conclusion.

## Verdict

| Question | Verdict | Rests on |
|---|---|---|
| Does any source characterize the order-six conference class by proportionality of a commutator Pfaffian (or complementary third-compound cubic) to the triangle cubic? | Not located | zbMATH keyword screens; three citing-set screens; term searches of six cached full texts |
| Is the existence of a \(6\times6\) linear Pfaffian representation of a cubic surface classical? | Yes — Beauville, and constructively Tanturri | Beauville abstract and introduction; Tanturri abstract and introduction |
| Are the triangle cubic's coefficients a known coordinate on principal minors? | Yes — order-three cycle products, cycle-sum coordinates of Huang and Oeding | Huang–Oeding abstract and Theorem 1.1 |
| Is the conclusion \(A^2=\lambda I\) a named object? | Yes — hollow symmetric involution, equivalently a constant-diagonal rank-\(n/2\) projection, equivalently an equal-norm tight frame; equal-modulus case is the classical conference/two-graph/equiangular-tight-frame correspondence | Auditor's derivation from \(P=(A/\sqrt\lambda+I)/2\); correspondence inherited from `OPER-1`, `OPER-3`, and the C876 audit |
| Does prior work pre-empt the theorem, triggering adjacent-crown extraction? | No | The above |

## Search record

Every query below is verbatim. zbMATH Open is the keyword instrument; its API returns HTTP 404 with
`"No results found"` for an empty result and a non-404 status for an error, so an empty result is
distinguishable from a failure. OpenAlex, Crossref, and Semantic Scholar were used for citing sets,
where an error is an HTTP status and an empty result is a zero-length `results`/`data`/`items` array.
Crossref's bibliographic keyword search returns million-item bag-of-words totals and was not used as
a negative instrument; its ranked head was read only to surface candidate titles, which is how
Tanturri entered the audit.

### zbMATH Open — keyword screens

Result counts are zbMATH's own totals; the hits listed are those whose titles were read.

| Query | Total | Outcome |
|---|---|---|
| `Pfaffian conference matrix` | 18 | No hit combines the two; heads are Pfaffian ideals and Pfaff systems |
| `two-graph cubic form` | 1 | Brouwer–Van Maldeghem only |
| `Seidel matrix cubic surface` | 2 | Conference proceedings, unrelated |
| `ab:Pfaffian & ab:commutator` | 3 | Quantitative K-theory, Clifford algebra, Riemann–Hilbert; none relevant |
| `ab:conference matrix & ab:cubic form` | 9 | No hit relates the two |
| `ab:two-graph & ab:cubic` | 5 | "Cubic" is complexity-theoretic in every hit |
| `ti:Pfaffian & ti:matching polynomial` | empty (404) | — |
| `ab:third compound & ab:symmetric matrix` | 1 | Proceedings volume |
| `ab:complementary minors & ab:principal minors & ab:proportional` | empty (404) | — |
| `ab:principal minors & ab:symmetric matrix & ab:hollow` | empty (404) | — |
| `ti:principal minor assignment problem` | 4 | Griffin–Tsatsomeros; Rising–Kulesza–Taskar; Brunel; Aravind et al. — all covered by C880 |
| `ab:compound matrix & ab:Hodge star` | 2 | Numerical exterior algebra; spectral functions |
| `ab:involutory & ab:zero diagonal & ab:sign matrix` | empty (404) | — |
| `ab:zero diagonal & ab:two distinct eigenvalues & ab:symmetric matrix` | 7 | Hollow nonnegative matrices, arrowhead deflation, distance spectra; none relevant |
| `ti:weighted graphs with two distinct eigenvalues` | empty (404) | — |
| `ab:generalized conference matrix & ab:real symmetric` | 23 | Et-Taoui's complex conference note is the only on-topic hit; no cubic form |
| `ab:equiangular lines & ab:cubic form` | 1 | History-of-geometry textbook |
| `ab:Calogero & ab:Pfaffian` | 3 | None relevant |
| `ti:minor summation formula & ab:Pfaffian` | 4 | Ishikawa–Okada–Wakayama; Ishikawa–Wakayama; Ishikawa; Hashimoto |
| `ab:Pfaffian & ab:diagonal matrix & ab:commutator & ab:cubic` | empty (404) | — |
| `ab:Schur Pfaffian` | 77 | Symmetric-function literature; no conference or two-graph contact |
| `ab:conference matrix & ab:Clebsch` | 3 | Brouwer–Van Maldeghem; two proceedings |
| `ab:cubic surface & ab:two-graph` | empty (404) | — |
| `ab:characterization & ab:conference matrix & ab:polynomial identity` | 2 | Complexity-theory hits |
| `ab:Clebsch cubic & ab:icosahedron` | 2 | Hitchin's spherical harmonics; a bifurcation paper |
| `ab:six points & ab:cubic surface & ab:Segre & ab:invariant` | 4 | Historical and moduli papers; no matrix recognition |
| `ab:Pfaffian representation & ab:Clebsch` | 2 | Physics texts |
| `ab:linear Pfaffian representation & ab:cubic surface` | 3 | Tanturri; Iliev–Manivel; a Pfaffian-number paper |
| `ab:Pfaffian & ab:equiangular` | empty (404) | — |
| `ab:skew-symmetric & ab:conference matrix & ab:characterization` | empty (404) | — |
| `ab:Pfaffian & ab:translation invariant & ab:cubic` | empty (404) | — |
| `ab:matching polynomial & ab:conference matrix` | 49 | Assignment/algorithms proceedings; no hit relates the two |
| `ab:tight frame & ab:zero diagonal & ab:involution` | empty (404) | — |
| `ab:Naimark complement & ab:two-graph` | empty (404) | — |

### arXiv API — targeted title and phrase queries

`all:"cycle-sums" AND all:"principal minors"` returned arXiv:1510.02515.
`ti:"principal minors of symmetric matrices"` returned arXiv:2105.13444, arXiv:2103.02589, and
arXiv:0809.4236 (Oeding). `au:Boussairi AND all:"principal minors"` returned arXiv:2105.02715,
arXiv:1606.09081, and arXiv:1403.0095. `ti:"Pfaffian representations of cubic surfaces"` returned
arXiv:1203.0999; `ti:"Determinantal hypersurfaces" AND au:Beauville` returned arXiv:math/9910030.

### Citing-set screens

Every seed was resolved by DOI through OpenAlex and the resolved title checked against the intended
work before use. One seed was mis-resolved at first pass and is recorded here because the convention
requires it: `10.1016/j.jalgebra.2007.01.045`, taken from recall, resolves to Landsberg and Weyman's
secant-variety paper, not to Holtz and Sturmfels; the correct DOI, read off the OpenAlex record, is
`10.1016/j.jalgebra.2007.01.039`. No verdict rests on the mis-resolved pass.

Counts were taken from OpenAlex, Crossref, and Semantic Scholar independently and are recorded
separately rather than aggregated. The screen ran over **titles only**, over the union of the
OpenAlex and Semantic Scholar citing lists. The discriminator applied to the union was the verbatim
case-insensitive regular expression

```
conference|seidel|two-?graph|equiangular|pfaff|compound|cubic|minor|switch|clebsch|frame|hollow|involut|commutator|graph|design|line
```

with every matching title read individually and the non-matching remainder covered by this set
record.

| Seed | OpenAlex `cited_by_count` | Crossref `is-referenced-by-count` | Semantic Scholar citations fetched | Union titles | Titles passing the discriminator |
|---|---|---|---|---|---|
| Holtz–Sturmfels, `10.1016/j.jalgebra.2007.01.039` | 69 | 51 | 84 | 87 | 26 |
| Oeding, `10.2140/ant.2011.5.75` | 39 | 31 | 44 | 46 | 22 |
| Buckley–Košir, `10.1007/s10711-007-9144-x` | 30 | 18 | 35 | 43 | 14 |

The three services disagree, which is itself reportable: Crossref is consistently the smallest and
Semantic Scholar the largest for all three seeds, so a negative resting on Crossref alone would have
screened roughly two-thirds of the available set. The union was screened in each case.

Nothing in the three screened sets characterizes conference matrices, two-graphs, or Seidel matrices
by a cubic-form identity. The four nearest titles were promoted out of the sets and read
individually: Huang and Oeding's cycle-sums paper, Boussaïri and Chergui on skew-symmetric principal
minors, Al Ahmadieh and Vinzant on determinantal multiaffine polynomials, and Boege's
almost-principal-minor note. None mentions conference matrices, Seidel matrices, two-graphs, or
equiangular lines anywhere in its text.

### Term searches of cached full texts

Run over the `pdftotext` extractions in the shared literature cache, case-insensitively. A zero is a
genuine absence from the extraction, not a failed access.

| Text | `Pfaffian` | `compound matrix` | `cubic form` | `conference` | `Seidel` | `two-graph` | `equiangular` | `Clebsch` |
|---|---|---|---|---|---|---|---|---|
| Brouwer–Van Maldeghem, *Strongly Regular Graphs* | 0 | 0 | 1 (bibliography: Manin, *Cubic Forms*) | — | — | — | — | 36 (Clebsch graph) |
| Tanturri, arXiv:1203.0999 | passim | — | — | 0 | 0 | 0 | 0 | 0 |
| Beauville, arXiv:math/9910030 | passim | — | — | 0 | 0 | 0 | 0 | 0 |
| Huang–Oeding, arXiv:1510.02515 | 1 (skew principal-Pfaffian remark) | — | — | 0 | 0 | 0 | 0 | 0 |
| Boussaïri–Chergui, arXiv:1403.0095 | 1 (minors are squares of Pfaffians) | — | — | 0 | 0 | 0 | 0 | 0 |
| Al Ahmadieh–Vinzant, arXiv:2105.13444 | 0 | — | — | 0 | 0 | 0 | 0 | 0 |
| Boege, arXiv:2103.02589 | 0 | — | — | 0 | 0 | 0 | 0 | 0 |

The Brouwer–Van Maldeghem result is the load-bearing one. It is the standard reference for this
territory, and it contains no Pfaffian, no compound matrix, and no cubic-form material; its only
cubic-surface passage is the classical twenty-seven lines and the Schläfli graph. The nine cached
equiangular-tight-frame, biangular-frame, and conference-matrix texts listed in the coverage
statement were screened by the same three-term filter and returned one hit, a bibliography entry for
Manin's *Cubic Forms*.

## Sources

Cache keys are in the shared literature cache described in `CLAUDE.md` § "Literature cache".

| Source | Version read | Read depth | Access |
|---|---|---|---|
| F. Tanturri, *Pfaffian representations of cubic surfaces*, Geom. Dedicata, DOI `10.1007/s10711-012-9818-x` | arXiv:1203.0999v3 preprint, not the published version | `partial` — abstract and Section 1 including Definition 1.0.1; whole text term-searched | Cache key `arXiv:1203.0999`, sha256 `dd0a0c076047f79dc133b06a7a37d762763231ac81f1a7ace18a359592047b41`, 17 pages |
| A. Beauville, *Determinantal hypersurfaces*, Michigan Math. J. 48 (2000) | arXiv:math/9910030v2 preprint, not the published version | `partial` — introduction (0.1); whole text term-searched | Cache key `arXiv:math/9910030`, sha256 `1ba560a5634f2ae15b94c6c2b3979308debaf2f96941edea7a0fd5adc98eb586`, 29 pages |
| H. Huang and L. Oeding, *Symmetrization of principal minors and cycle-sums*, Linear Multilinear Algebra, DOI `10.1080/03081087.2016.1233932` | arXiv:1510.02515v2 preprint, not the published version | `partial` — abstract, Section 1 summary and Theorem 1.1; whole text term-searched | Cache key `arXiv:1510.02515`, sha256 `5c8a3d277efea0a0b6d56b13c86f88a4e8e388903e02b968f45a5a40dc6e9a57`, 23 pages |
| A. Boussaïri and B. Chergui, *Skew-symmetric matrices and their principal minors*, Linear Algebra Appl., DOI `10.1016/j.laa.2015.07.024` | arXiv:1403.0095v2 preprint, not the published version | `partial` — abstract and problem statement; whole text term-searched | Cache key `arXiv:1403.0095`, sha256 `20758a14a7a72197cedb6deab87b543488c75d6452fe90eda37c96b28c31c2c3`, 14 pages |
| T. Boege, *Incidence geometry in the projective plane via almost-principal minors of symmetric matrices* | arXiv:2103.02589v1 preprint | `partial` — abstract; whole text term-searched | Cache key `arXiv:2103.02589`, sha256 `e4258db8656f55961c865498c1f5c146ed786327fd4f06c81c4f422ac7fd8977`, 14 pages |
| A. Al Ahmadieh and C. Vinzant, *Characterizing principal minors of symmetric matrices via determinantal multiaffine polynomials*, J. Algebra, DOI `10.1016/j.jalgebra.2023.09.030` | arXiv:2105.13444v1 preprint, not the published version | `abstract/metadata only`, plus a term search of the whole text | Cache key `arXiv:2105.13444`, sha256 `d11cc02d0d43a4d91b51d568bbdd284390e1a4ca319d2764f18788946018c761`, 19 pages |
| A. E. Brouwer and H. Van Maldeghem, *Strongly Regular Graphs* (2022), DOI `10.1017/9781009057226` | Published book | `partial` — term-searched the whole extraction; the twenty-seven-lines passage read | Cache key `10.1017/9781009057226`, sha256 `fa73d72e86bbd8dc3fbfcbca45679cb8f2671d777e91c009eeff0a563fd9289d`, 452 pages |
| O. Holtz and B. Sturmfels, *Hyperdeterminantal relations among symmetric principal minors*, J. Algebra, DOI `10.1016/j.jalgebra.2007.01.039` | Not read this round | `abstract/metadata only` here; **inherited** at `full text` from `notes/2026-08-07-c880-literature-audit.md`, which read the preprint | OpenAlex record `W2043984109`; used as a citing-set seed |
| L. Oeding, *Set-theoretic defining equations of the variety of principal minors of symmetric matrices*, Algebra Number Theory, DOI `10.2140/ant.2011.5.75` | Not read | `abstract/metadata only` | OpenAlex record `W2003688125`; used as a citing-set seed |
| A. Buckley and T. Košir, *Determinantal representations of smooth cubic surfaces*, Geom. Dedicata, DOI `10.1007/s10711-007-9144-x` | Not read | `abstract/metadata only` | OpenAlex record `W2058299352`; used as a citing-set seed |
| M. Ishikawa, S. Okada and M. Wakayama, *Applications of minor-summation formula I* (1996), and M. Ishikawa and M. Wakayama, *Applications of minor summation formula III* (2006) | Not read | `abstract/metadata only` | zbMATH records reached by `ti:minor summation formula & ab:Pfaffian` |
| J. J. Seidel, *A survey of two-graphs*, and J. J. Seidel and D. E. Taylor, *Two-graphs, a second survey*, in the 1991 *Geometry and Combinatorics* reprint | Not accessed this round | **Inherited** from the `OPER-4` row's search record, which states both were searched and neither states a reconstruction of a two-graph from local data | Not present in the shared cache under any Seidel-named path as of this audit |

## Coverage statement

**Searched and found nothing** — licenses the negative:

- zbMATH Open, the queries above, over the Pfaffian-commutator, compound-minor,
  determinantal-representation, conference-matrix, and tight-frame vocabularies.
- The union citing sets of Holtz–Sturmfels, Oeding, and Buckley–Košir, screened at title level.
- Term searches of the seven cached texts in the table above, plus the nine cached
  equiangular-tight-frame, biangular-frame, and conference-matrix texts: `arXiv:1107.2267`,
  `arXiv:1402.3521`, `arXiv:1409.5720`, `arXiv:1504.00253`, `arXiv:1703.01786`, `arXiv:1809.05739`,
  `arXiv:1903.06721`, `arXiv:2110.15842`, `arXiv:2505.00160`, together with
  `10.1007/s10623-021-00858-8`, `arXiv:2004.05829`, `10.1006/eujc.2001.0539`, and `arXiv:0810.3189`.

**Could not access** — licenses nothing and is carried forward as an open gap:

- **MathSciNet: NOT COVERED.** It requires institutional authentication and is unreachable from this
  session. Every claim it would have gated keeps "to our knowledge."
- **Google Scholar: NOT COVERED.** It blocks automated access, so no full-text web index was
  searched. This is the audit's sharpest limitation: zbMATH, OpenAlex, Crossref, and Semantic Scholar
  all index titles, abstracts, and metadata, not article bodies, and a recognition theorem of this
  shape could sit inside a paper whose title and abstract are about something else. The negative is
  bounded accordingly.
- **The two Seidel two-graph surveys were not re-accessed this round.** The `OPER-4` row records that
  both were searched in the 1991 *Geometry and Combinatorics* reprint; that record is inherited here
  rather than re-earned, and no copy is present in the shared cache.
- Published versions of the six preprints above were not obtained; every characterization of them is
  a characterization of the preprint and is marked as such in the source table.

## Auditor's inferences, kept distinct from the sources

Three statements in this report are mine, not any source's framing.

1. That the coefficients of \(\mathcal T_A\) are half the principal \(3\times3\) minors of a hollow
   symmetric \(A\), and hence are the order-three cycle products underlying Huang and Oeding's
   cycle-sum coordinates. Elementary; Huang and Oeding do not mention hollow matrices.
2. That \(A^2=\lambda I\) for real symmetric hollow \(A\) is equivalent to \(A/\sqrt\lambda=2P-I\)
   with \(P\) an orthogonal projection of rank \(n/2\) and constant diagonal \(1/2\), and hence to an
   equal-norm tight frame of \(n\) vectors in \(\mathbf R^{n/2}\). Two lines from
   \(P=(A/\sqrt\lambda+I)/2\); the frame reading is standard, but no consulted source states it for
   this equation.
3. That the order-six solution set of \(A^2=\lambda I\) has dimension at least four, from
   \(\dim\mathrm{Gr}(3,6)=9\) minus the at most five independent constant-diagonal equations, and is
   therefore far larger than the proportionality locus, which Theorem D pins to the scaling line at
   either golden representative. This is what makes the manuscript's current boundary sentence
   ambiguous rather than wrong.

## What the ledger row licenses

The `OPER-5` row added to `papers/clebsch-passages/literature-boundaries.md` records the boundary. In
manuscript prose the audit licenses "we prove" and "we have not located"; it does not license
"first", "new", or any unqualified priority claim, and every negative sentence keeps "to our
knowledge". A sentence claiming novelty for a linear Pfaffian representation of a cubic surface, or
for the cycle-sum coordinates, would be wrong on this evidence.

## Recommended manuscript changes, for the C816 owner to take or decline

None is applied by this pass.

1. Add a bounded positioning sentence near
   `thm:triangle-pfaffian-recognition` quoting the `OPER-5` row: the ingredients are classical
   separately, the recognition direction was not located, "to our knowledge".
2. Cite Beauville for the general Pfaffian-representation question and Tanturri for the constructive
   cubic-surface case, at the point where \(\Phi_A\) is introduced as a Pfaffian of linear forms.
3. Cite Huang and Oeding for cycle-sum coordinates where \(\mathcal T_A\) is introduced, and state
   the elementary identity \(\det A[S,S]=2a_{ij}a_{jk}a_{ki}\) that makes its coefficients principal
   minors. This is the sentence that tells a referee the two cubics are minors of the same matrix.
4. Name the conclusion: \(A^2=\lambda I\) says \(A\) is a scaled hollow symmetric involution,
   equivalently a constant-diagonal rank-three projection, equivalently an equal-norm tight frame of
   six vectors in \(\mathbf R^3\); the equal-modulus case is the classical conference-matrix,
   regular-two-graph, equiangular-tight-frame correspondence.
5. Replace the boundary sentence so it names the right set: the weighted solutions of the
   *proportionality*, not of \(A^2=\lambda I\), are what remain unclassified.

## Surfaces repeating this verdict

No verdict was changed by this audit, so nothing needed correcting downstream. The surfaces that
would carry a novelty sentence about the recognition theorem, checked rather than recalled:

| Surface | State after this audit |
|---|---|
| `papers/clebsch-passages/literature-boundaries.md` | Row `OPER-5` added; this is the one home of the claim |
| `papers/clebsch-passages/sections/05-golden-operator.tex` | Carries no novelty sentence near the theorem; recommendation 1 above would add one quoting the row |
| `notes/clebsch-tasks/c816-paper-iii-four-shadow-integration.md` | Work item 1 discharged; work item 4's abstract decision is now ungated |
| `notes/handoffs/2026-07-13-clebsch-lane.md` | Routing only; carries no novelty sentence and needs none |
| Public released versions 1 and 2 of Paper III | Carry no novelty sentence about the recognition theorem, which is not in them; nothing stale |

## Closeout pass: a sixth domain, and what forced it

The `ej` closeout on this work item produced a reformulation of the theorem's equal-modulus half that
the five named domains do not reach, and the domain it points at — maximal determinants of sign
matrices and D-optimal designs — was therefore searched as well, with the queries and the same
bounded negative recorded in `notes/2026-08-20-c816-extremal-minor-census.md`. Nothing was located
there either, and row `OPER-5` covers both.

The reformulation itself: over all 32768 hollow symmetric sign matrices of order six, being a
conference matrix, having every complementary \(3\times3\) minor nonzero, and satisfying the cubic
proportionality hold on exactly the same 384 matrices. The constant \(4\) is forced rather than
computed, because a \(3\times3\) sign matrix has absolute determinant \(0\) or \(4\) and nothing else.
That is census evidence at order six, not a proof; the bundle report states the limit explicitly and
recommends against promoting the nondegeneracy form into the manuscript without one.

## Discovery-track candidates

Logged separately in `notes/2026-07-14-clebsch-discovery-track.md`: the equal-norm-tight-frame reading
of \(A^2=\lambda I\) and the dimension-four ambient count, which were not what this audit was looking
for and are not owed to any task.
