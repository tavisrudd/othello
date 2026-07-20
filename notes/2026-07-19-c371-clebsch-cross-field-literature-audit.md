# C371 — bounded Clebsch cross-field literature audit

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `NARROW SURVIVAL; RANK-EIGHT SCHEME STRONGEST; QUANTUM EQUIVALENCE OPEN`

## Read-depth statement

This audit read **zero external papers in full**.  It read six external papers **partially**, one
external paper at **abstract/metadata only**, and two external sources **secondarily only** through a
named primary or local report.  It also read three local theorem/audit reports **partially**.  The
question-to-source ledger below gives the exact version, access path, cache key and hash, sections or
passages read, and the conclusion for which each read was used.

Search-result screening is recorded separately and is not counted as reading a source.  No forward-
citation closure was attempted.  Consequently every negative below means only **no direct predecessor
located in the bounded screened set**, never a universal priority claim.

## Headline results, graded and sorted by publication value

| rank | candidate connection | grade | bounded literature verdict |
|---:|:---|:---:|:---|
| 1 | The q=11 Clebsch code as an `A5`-symmetric `AME(6,11)` perfect tensor whose eight syndrome orbits form a rank-eight translation association scheme | **A- / conditional** | Generic MDS-to-AME and stabilizer constructions are prior art.  No screened source combined this non-GRS Clebsch tensor, the conic of projectivized maximum-weight `X`-error syndromes, and the exact 512-number Bose--Mesner algebra.  Quantum local-Clifford/local-unitary equivalence to a Reed--Solomon AME remains untested. |
| 2 | The exact rank-eight scheme on `F_11^3` as a standalone algebraic-combinatorics object | **A- / conditional** | Strongest pure-math candidate.  The only directly surfaced `A5` association-scheme paper concerns the group association scheme on `A5`, not this affine translation scheme.  Catalogue isomorphism, algebraic isomorphism, and separability have not been closed. |
| 3 | Characteristic five as the modular phase where the Clebsch six-orbit becomes a conic/GRS code, explained by `A5 = PSL_2(5)` on `P^1(F_5)` and `Sym^2`/Veronese | **B** | The conic collapse and six-point action are classical.  The `Sym^2` explanation was not found verbatim, but is best presented as a short conceptual derivation, not a novelty claim. |
| 4 | The two ten-element support classes as icosahedral chirality / outer-`S6` / matroid-decorated basis data | **B- as application; D as discovery** | The 20 triples, `10+10` coloring, opposite icosahedra, and outer automorphism of `S6` are explicit prior art.  What can survive is only an intrinsic decoder/code-theoretic recovery of that classical torsor.  The underlying matroid is merely `U_{3,6}`. |
| 5 | An `H3`/icosahedral holographic tensor-network cell at local dimension 11 | **C / speculative** | Perfect tensors in `H3` holographic codes and six-party tensor decompositions are prior art, but the existing dodecahedral construction uses a 13-leg `AME(13,13)` tensor.  The six-leg Clebsch tensor is not a drop-in dodecahedral cell.  No claim survives without a compatible tessellation/network theorem. |

The broadest defensible headline is therefore:

> The q=11 Clebsch code yields an icosahedrally symmetric six-party perfect tensor whose
> projectivized hardest Pauli-`X` syndrome sectors form a conic, while all syndrome transitions
> close in an exact eight-dimensional Bose--Mesner algebra.

Here “hardest” means minimum coset-leader weight three for the classical parity-check syndrome;
it does not mean a physical noise-rate or threshold theorem.  The headline must remain conditional
until quantum local-equivalence is checked.

## Questions actually audited

`Q1 — quantum tensor.` Does the Clebsch `[6,3,4]_11` MDS code give more than the standard
MDS-to-`AME(6,11)` construction—specifically `A5` symmetry, a conic of deepest Pauli-`X` syndrome
directions, or a new perfect-tensor equivalence class?

`Q2 — modular/representation-theoretic phase.` Is C341's characteristic-five GRS collapse already
explained by the exceptional isomorphism `A5 = PSL_2(5)`, its six-point action on `P^1(F_5)`, and
the quadratic Veronese/`Sym^2` representation?

`Q3 — association scheme.` Is C341's symmetric rank-eight translation scheme on `F_11^3`, with
orbit valencies `1,60,100,120,150,300,300,300`, already catalogued or an immediate instance of an
existing `A5` scheme?

`Q4 — holography.` Does the `H3`/`A5` symmetry at q=11 produce a known or nearly free holographic
quantum-code construction?

`Q5 — chirality/matroids/outer S6.` Are the two ten-element `A5` orbits on three-subsets a missed
matroid or icosahedral-chirality discovery, or classical outer-`S6` combinatorics?

## Claim-by-claim findings

### Q1 — AME/perfect tensor: generic bridge preempted, exact Clebsch package survives narrowly

The generic implication is immediate and already published: a linear `[6,3,4]_11` MDS code gives a
minimal-support `AME(6,11)` state/perfect tensor, and its generator and parity-check rows give Pauli
stabilizers.  This is not a Clebsch novelty.

The local q=11 theorem adds genuinely more structured data.  The scalar-closed `A5` action has eight
affine syndrome orbits; the 120-vector orbit projectivizes to twelve maximum-weight syndrome
directions.  C211's separate finite geometry identifies the 12-point complement of the fifteen
secants as a conic.  Thus Pauli-`X` errors inherit a conic of projectivized syndrome sectors only after
combining the standard stabilizer dictionary with the exact Clebsch geometry.  The resulting
statement is a synthesis/inference of this audit, not a statement found in an external source.

The important unresolved gate is equivalence.  Non-GRS monomial inequivalence of the classical code
does **not** by itself prove that the associated AME state is inequivalent under local Clifford or
local unitary transformations to a Reed--Solomon-derived AME.  The bounded search found no direct
classification for `AME(6,11)`, but it did not solve the equivalence problem.  Until that calculation
is done, claim a distinguished symmetric presentation and syndrome algebra, not a new AME
entanglement class.

### Q2 — characteristic five: excellent explanation, weak novelty

The finite-geometric core is explicit prior art: in odd characteristic five the Clebsch hexagon is a
conic in a `PG(2,5)` subplane, whereas in the `q congruent to +/-1 mod 10` case it is not contained in
a conic.  The six axes as the natural six-point action of `PSL_2(5) = A5` are also classical.

The clean explanation of C341 is then standard representation theory.  The six projective-line
points embed by the quadratic Veronese map

```text
[s:t] -> [s^2:st:t^2],
```

which is the projectivization of `Sym^2(F_5^2)` and lands on a nonsingular conic in `P^2`.  C341's
determinant `16(3*tau-4)` vanishes exactly at the prime above five, so its integral `H3` orbit becomes
that conic/GRS realization at precisely the modular place where the icosahedral group is
`PSL_2(5)`.  No screened source stated this exact determinant-to-`Sym^2` sentence, but every ingredient
is classical; use it as explanatory glue, not as an independent theorem claim.

### Q3 — rank-eight translation scheme: strongest surviving object

C341 constructs the orbitals of

```text
F_11^3 semidirect (F_11^* x A5)
```

and checks all 512 intersection numbers, symmetry, valency identities, and associativity.  This is
more than the earlier arrangement multiplicity or coset-leader enumerator: the three 300-vector
relations split a single classical nearest-leader stratum, and class-invariant convolution occurs in
an eight-dimensional Bose--Mesner algebra.

The exact-query search found no direct `F_11^3`/`A5` translation-scheme hit.  Tomiyama's title-matched
paper is about the group association scheme of `A5` itself and is not an identification of C341's
affine scheme.  Generic automorphism-orbit decoding and generic association-scheme language are
prior art; the candidate contribution is this exact orbit partition and intersection tensor.

This remains a candidate, not a priority-closed theorem.  Required next checks are:

1. compute the first and second eigenmatrices, Krein parameters, imprimitivity, and fusions;
2. compare those invariants against association-scheme catalogues and affine/Schurian families;
3. decide algebraic isomorphism and, if possible, separability; and
4. only then advertise the scheme as new rather than “the exact Clebsch syndrome scheme.”

### Q4 — holography: real resonance, wrong arity

The literature already uses finite-field Reed--Solomon AME stabilizer states as perfect tensors in
hyperbolic/HQECC constructions.  One explicit `H3` dodecahedral construction requires a 13-leg
`AME(13,13)` pseudo-perfect tensor, and its appendix identifies the dodecahedron's rotation subgroup
as `A5`.  A separate construction in the same paper uses an eight-leg `AME(8,11)` Reed--Solomon
tensor.  Six-party AME states also have known small tensor-network decompositions for local
dimension at least five.

Therefore “Clebsch connects to holography” is true but not novel.  More importantly, C341's six-leg
tensor does not match the dodecahedral cell's 12 faces plus one bulk leg.  A publishable connection
would need a tiling or network whose leg incidence matches six, an `A5`-equivariant orientation
theorem, and an operational code consequence.  None was found or proved here.

### Q5 — outer S6 and matroids: the surprise is classical

The exact `10+10` split is explicit in the outer-automorphism literature: the twenty triangles on six
labels admit six two-colorings into ten and ten, and labeled icosahedra realize each ten-set as their
face triples; opposite icosahedra exchange the two sets.  This directly preempts any claim that the
two `A5` orbits on three-subsets are newly discovered “support chirality.”

Because every three Clebsch columns are independent, the underlying abstract rank-three matroid is
the uniform matroid `U_{3,6}`.  It cannot remember either ten-set.  The split is extra structure from
the marked `A5` action—analogous in flavor to a chirotope, but not an oriented matroid over the
unordered finite field.  A surviving code-theoretic theorem would have to reconstruct this classical
outer-`S6` torsor intrinsically from an unmarked code, decoder, or syndrome scheme.  C341 explicitly
does not yet prove that stronger claim.

## Comparison with the arc and Clebsch papers

| layer | already owned by arc/coding literature | already owned by Clebsch/icosahedral literature | narrow residue from the crowns work |
|:---|:---|:---|:---|
| six columns | arc/MDS dictionary; conic iff GRS in dimension three | six axes, `A5/D5` action, Clebsch hexagon | integral all-odd MDS proof and exact characteristic-five determinant boundary |
| deep holes | syndrome weight as minimum column-span size; secant arrangements and coset leaders | q=11 six axes, fifteen joins, ten Brianchon points, conic complement | exact `A5/C5` deep-hole orbit and its placement inside the eight-class affine scheme |
| quantum | MDS-to-minimal-support AME/perfect tensor; stabilizer construction | no Clebsch-specific quantum theorem located | `A5`-symmetric presentation plus conic deepest-`X` sectors and Bose--Mesner noise compression, conditional on quantum equivalence audit |
| `10+10` triples | uniform matroid has all twenty bases | labeled icosahedra, opposite ten-sets, outer automorphism of `S6` | possible intrinsic code/decoder recovery only; combinatorial dictionary itself is preempted |
| association algebra | generic Schurian/translation schemes and automorphism-orbit decoding | group action supplies the orbit labels | exact eight relations and 512 transition numbers; catalogue/separability open |

## Exact source and read-depth ledger

All quoted line ranges below refer to `pdftotext` output in the verified literature cache.  Line
ranges document the material actually inspected; they do not imply that intervening or remaining
pages were read.

| source | depth | exact access/version and cache | exact material read | questions and use |
|:---|:---|:---|:---|:---|
| Raissi, Gogolin, Riera, and Acin, [*Constructing optimal quantum error correcting codes from absolute maximally entangled states*](https://arxiv.org/abs/1701.03359) | **partial** | arXiv `1701.03359v2`, 2017-04-28; PDF fetched 2026-07-19; cache key `arXiv:1701.03359`; SHA-256 `768f70614685a881ba7902428164fe9e2cf0e78be123cd344c6e838ac072e673` | abstract/introduction; Section III at extracted lines 100–180, especially 118–163; Section VI at lines 500–569, especially equations (27)–(29) | Q1: establishes generic minimal-support AME/perfect-tensor to MDS correspondence and Pauli stabilizers; preempts the generic quantum bridge |
| Kohler and Cubitt, [*Toy Models of Holographic Duality between local Hamiltonians*](https://arxiv.org/abs/1810.08992) | **partial** | arXiv `1810.08992v3`, 2019-07-30; PDF fetched 2026-07-19; cache key `arXiv:1810.08992`; SHA-256 `8addb693e35cfa062b5ebd8d5075fb534ca3051bd0b7112edb1ac2bf24ab87d4` | Section 6.2.1, extracted lines 2638–2670; Sections 6.3–6.3.1, lines 2735–2759; Appendix G passage, lines 3982–4005 | Q4: verifies the explicit `AME(8,11)` Reed--Solomon tensor, 13-leg dodecahedral `AME(13,13)` construction, and `H3` rotation subgroup `A5`; establishes the arity mismatch |
| Pozsgay and Wanless, [*Tensor network decompositions for absolutely maximally entangled states*](https://arxiv.org/abs/2308.07042) | **partial** | arXiv `2308.07042v3`, 2024-04-30; PDF fetched 2026-07-19; cache key `arXiv:2308.07042`; SHA-256 `75ce8acc1988534ceb941d134bbc0e3b7ec75f01b05fcd200c0facdba6611038` | abstract/introduction, lines 1–55; Section 4 opening, lines 610–665; Section 4.1 superregular/MDS passage, lines 790–845; Section 6 example passage, lines 1140–1190 | Q1/Q4: supplies generic six-party AME tensor-network/decomposition context; no Clebsch or `A5` specialization located in the read passages |
| Howard, Millson, Snowden, and Vakil, [*A description of the outer automorphism of S6, and the invariants of six points in projective space*](https://arxiv.org/abs/0710.5916) | **partial** | arXiv `0710.5916v1`, 2007-10-31; PDF fetched 2026-07-19; cache key `arXiv:0710.5916`; SHA-256 `d2da258cd8513a9b782a8270baa82acc51bc8d552e18db104967c2a08bffebfc` | abstract and Sections 1.1–1.4, extracted lines 1–159; load-bearing passages are Section 1.2, lines 113–127, and Section 1.3, lines 128–143 | Q5: exact preemption of 20 triples split `10+10`, labeled/opposite icosahedra, and outer `S6` |
| Storme and Van Maldeghem, [*Primitive arcs in PG(2,q)*](https://doi.org/10.1016/0097-3165(95)90051-9) | **partial** | author-hosted 14-page PDF dated 2010-12-14 for the 1995 article; equivalence to the version of record was not checked; fetched 2026-07-19 from `https://cage.ugent.be/~hvm/artikels/41.pdf`; cache key `10.1016/0097-3165(95)90051-9`; SHA-256 `770f27f1e22b29e077ee17c9747c7f529f27ed4b26e5408f2a1dae5c56363d3b` | introduction opening; Remark 2 and surrounding classification at extracted lines 490–548, especially 516–533 | Q2/Q5: explicit characteristic-five Clebsch conic, non-conic comparison, ten Brianchon points, and five triangles; credits Dye for the detailed hexagon study |
| Kostant, [*The Graph of the Truncated Icosahedron and the Last Letter of Galois*](https://www.ams.org/notices/199509/kostant.pdf) | **partial** | exact read copy: *Notices of the AMS*, September 1995, pp. 959–968, fetched 2026-07-19.  Cache key `10.1515/dmvm-1995-0405` is the DOI of a same-title 1995 *Mitteilungen der DMV* publication, while cached bytes are the AMS edition; no conclusion relies on edition identity.  SHA-256 `983dbc4d0b7d645bb194ef210fd6ea1e09fb5f9d073b295b737fe7f578c4fdde` | AMS p. 961, extracted lines 200–289, especially 219–260 | Q2: verifies the natural `PSL_2(5)` action on six points of `P^1(F_5)` and its geometric realization as six antipodal icosahedron vertex pairs |
| Tomiyama, [*Characterization of the group association scheme of A5 by its intersection numbers*](https://doi.org/10.2969/jmsj/05010043) | **abstract/metadata only** | Crossref metadata plus NDL/J-STAGE title/abstract snippets accessed 2026-07-19; no PDF cached and no body text read | title, bibliographic metadata, and abstract/snippet only | Q3: discriminator is “group association scheme of `A5`”; used only to reject identity with C341's affine translation scheme, not to claim non-overlap with uninspected body results |
| Dye, *Hexagons, Conics, `A5` and `PSL_2(K)`* | **secondary only** | not directly accessed in C371; exact secondary chain is Storme--Van Maldeghem Remark 2, extracted lines 516–533, and its reference [5] | no Dye text read | Q2/Q5: attribution only—that detailed Clebsch hexagons were already studied; no finer claim is drawn from Dye here |
| Jurrius and Pellikaan, [*The coset leader and list weight enumerator*](https://doi.org/10.1090/conm/632/12631) | **secondary only** | not reread in C371; local C211 reports a prior full-text read of cached DOI `10.1090/conm/632/12631`, SHA-256 `99a2c5d1625af85d4c5560276b45728acaba347dd13f88d789d49b792f714b95` | C371 read C211 lines 118–127, which identifies Proposition 3.11, Theorems 5.3 and 5.7, and Example 5.10; those primary passages were not reopened | Q1/Q3 comparison only: general arrangement-to-coset-leader mechanism is treated as preempted; exact rank-eight refinement remains the candidate |
| local C341, `notes/2026-07-18-c341-a5-subgroup-decoder.md` | **partial** | committed repository report at the 2026-07-19 working revision | theorem and determinant, lines 9–53; subgroup dictionary, 55–76; q=11 scheme and boundary, 78–157; reproduction/source matrix, 159–208 | Q1–Q3/Q5: exact local claims being audited |
| local C211, `notes/2026-07-16-c211-clebsch-reflection-arrangements.md` | **partial** | committed repository report at the 2026-07-19 working revision | exact q=11 identification and complement, lines 1–100; priority boundary, lines 102–127; manuscript correction, lines 139–166 | Q1/Q2: conic complement and classical-boundary chain |
| local C339, `notes/2026-07-18-c339-clebsch-deep-hole-transform.md` | **partial** | committed repository report at the 2026-07-19 working revision | theorem, spectrum, and deep-hole origin through the “Deep-hole origin and inverse theorem” section, lines 1–100 | Q1/Q3: exact meaning of projective deep-hole syndrome direction; not used for its `q>14` inverse theorem at q=11 |

## Screened-set ledger

The discriminator for all database/card sets was title plus abstract when supplied; where noted,
only title/snippet was available.  A card or metadata record is not a paper read.

### Web search cards

| question | verbatim queries | returned cards screened | discriminator |
|:---|:---|---:|:---|
| Q1 | `"Clebsch hexagon" "perfect tensor" quantum AME`; `"Clebsch code" "perfect tensor" quantum entangled`; `"A5" "AME(6,11)"`; `"H3" "perfect tensor" 11 icosahedral` | 15 | title/snippet for a direct Clebsch + AME/perfect-tensor combination |
| Q2 | `"A5" "characteristic 5" "symmetric square" representation`; `"PSL(2,5)" Veronese conic six points`; `"Clebsch" "Reed-Solomon" "characteristic five"`; `"3 tau - 4" A5 conic` | 19 | title/snippet for the exact modular explanation |
| Q3 | `"F_11^3" "A5" "association scheme"`; `"rank-eight" translation association scheme A5`; `"1, 60, 100, 120, 150, 300, 300" association scheme`; `icosahedral syndrome association scheme coding` | 22 | title/snippet for the exact affine group, rank, or valency fingerprint |
| Q4 | `"Clebsch hexagon" holographic code perfect tensor`; `"AME(6,11)" holographic tensor network`; `"H3" dodecahedral "perfect tensor" A5`; `icosahedral A5 symmetric perfect tensor six qudits 11` | 31 | title/snippet for a six-leg q=11 Clebsch cell or exact `H3` construction |
| Q5 | `"Clebsch hexagon" matroid code`; `"support chirality" coding theory`; `A5 six point action two orbits ten triples outer automorphism S6`; `icosahedral "U(3,6)" matroid` | 28 | title/snippet for the exact two ten-set or matroid connection |
| Q1 equivalence supplement | `site:arxiv.org AME stabilizer states local Clifford equivalence MDS codes`; `site:arxiv.org "AME(6" "local Clifford" qudit`; `site:arxiv.org perfect tensor local unitary equivalence Reed Solomon MDS`; `site:arxiv.org non-GRS MDS AME state local Clifford` | 9 | title/abstract snippet for a directly applicable local-equivalence classification; none was located |

### Bibliographic/search databases

For the API databases, the five common query strings were:

```text
Q1 Clebsch hexagon quantum perfect tensor AME
Q2 Clebsch hexagon characteristic 5 symmetric square Veronese Reed Solomon
Q3 F_11^3 A5 association scheme syndrome
Q4 H3 icosahedral q=11 perfect tensor holographic code
Q5 A5 six axes ten triples support chirality outer automorphism S6 code
```

| provider | exact screened set | outcome and limitation |
|:---|:---|:---|
| OpenAlex API | Q1 `7/7`; Q2 `0/0`; Q3 `0/0`; Q4 `3/3`; Q5 `0/0`; **10 records total**, titles and available abstracts screened | Q4 surfaced the relevant holographic paper; no direct exact-object collision in the returned sets |
| Semantic Scholar API | Q1 `8/8`; Q3 top `20/249`; **28 records total**, titles and available abstracts screened | Q3's remainder was not screened because the results were already dominated by medical `A5` token collisions; Q2, Q4, and Q5 returned HTTP 429 after retries and are **NOT COVERED**, not empty |
| Crossref API | 25 records fetched per query; only top 5 titles per query screened, **25 titles total** | total-result counts were Q1 `863751`, Q2 `427671`, Q3 `8665568`, Q4 `6204593`, Q5 `3945`; the enormous noisy totals make this weak absence evidence. Q3 surfaced Tomiyama |
| zbMATH Open via web index | four exact `site:zbmath.org` queries—`"Clebsch hexagon" AME perfect tensor`; `"Clebsch hexagon" characteristic 5 Veronese`; `A5 translation association scheme F11 syndrome`; `six points icosahedron outer automorphism S6 triples`—returned **13 cards**, title/snippet screened | web-index coverage only, not an API or complete zbMATH result set; it surfaced the Howard--Millson--Snowden--Vakil record but no direct scheme/quantum hit |
| MathSciNet | **NOT COVERED** | institutional authentication unavailable; no query executed |
| Google Scholar | **NOT COVERED** | no reliable automation/query set obtained |

Additional ad hoc exact web queries were run during discovery, but their returned-set sizes were not
preserved; by the audit convention they are not used as evidence for a negative conclusion.

## What the audit does and does not establish

It does establish a conservative claim boundary:

- do not claim MDS-to-AME, perfect-tensor stabilizers, Clebsch conic collapse, six icosahedral axes,
  the `10+10` triple split, outer `S6`, or generic orbit decoding as new;
- the q=11 exact translation scheme is the strongest surviving pure-math candidate;
- the most accessible cross-field story is the combination of `A5`-symmetric AME, conic deepest
  Pauli-`X` syndrome directions, and eight-class convolution;
- the characteristic-five `Sym^2` story is a nearly free explanatory upgrade; and
- the holographic connection is currently analogy/context, not a theorem.

It does **not** establish:

- a new local-unitary or local-Clifford class of `AME(6,11)`;
- novelty or separability of the rank-eight association scheme;
- a holographic tensor network using the Clebsch tensor;
- an oriented-matroid/chirotope theorem;
- forward-citation or subscription-database priority closure; or
- exhaustive coverage of quantum-information, association-scheme, modular-representation, or
  matroid literature.

## Cheapest responsible upgrades

1. **Quantum equivalence gate:** compute a canonical stabilizer/graph-state form and test local
   Clifford equivalence against q=11 Reed--Solomon `AME(6,11)` presentations.  This decides whether
   “new symmetric AME presentation” can strengthen to “new LC class.”
2. **Scheme identity gate:** compute eigenmatrices/Krein data/fusions and run catalogue plus algebraic-
   isomorphism checks.  This is the highest expected-value next research step.
3. **Free exposition:** add the `PSL_2(5) -> Sym^2 ->` Veronese conic explanation to the
   characteristic-five phase theorem, with the classical sources credited.
4. **Chirality boundary:** state the `10+10` split as the classical outer-`S6` icosahedral model; only
   pursue it further if an unmarked code or decoder intrinsically recovers the torsor.
5. **Holography stop:** do no network computation until a concrete six-leg-compatible tiling or
   tensor-incidence architecture is specified.

## Publication wording released by this audit

Safe now:

> Applying the standard MDS-to-AME construction to the q=11 Clebsch orbit gives an
> `A5`-symmetric `AME(6,11)` stabilizer state.  Its projectivized weight-three `X`-syndrome
> directions form the Clebsch complement conic, and its scalar-closed syndrome orbits carry the
> exact rank-eight translation association scheme computed here.

Not safe yet:

> This is a new AME state, a new association scheme, or an icosahedral holographic code.

The latter sentence requires, respectively, local-equivalence classification, scheme
catalogue/separability closure, or an actual compatible tensor-network theorem.
