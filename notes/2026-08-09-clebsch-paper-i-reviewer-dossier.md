# C898 — Paper I reviewer and critic dossier

**Date:** 2026-08-09  
**Lane:** `clebsch`  
**Use:** review-sub-agent context only  
**Manuscript:** *Reconstructing the Clebsch code and its golden orientation
from its deep-hole syndrome locus*

> **Isolation boundary.** This file is a sealed input for Paper I review
> sub-agents. Do not route it into ordinary Paper I work, the general Clebsch
> handoff, manuscript-writing context, or formal-proof tasks. A later
> conventions-only extraction may be made from findings that survive the cold
> reads, but that extraction is not part of this dossier.

The people named below are forecasts and critic personas assembled from public
editorial, publication, and institutional information. They are not reports of
private editorial knowledge, and nobody has been contacted.

C898 remains the owning id for multiple rounds of cold review, synthesis, and
remediation. This dossier stays sealed between rounds. Remediation receives only
the frozen reports and the coordinator's adopted-finding ledger; a new round
then reviews one newly frozen manuscript commit and PDF hash.

## 1. Frozen review surface

Review the authoritative monorepo manuscript, not the older standalone mirror.

- manuscript commit: `6e011ff585f46658a2650803d8672f07a48e786a`;
- PDF: `papers/clebsch-rigidity/clebsch_rigidity.pdf`;
- PDF SHA-256:
  `95ccf1ff32180fd806608002d69a912c5a1aae26a8fb5778d553a88b62803d83`;
- optional public supplement, after the first human-proof pass:
  `papers/clebsch-rigidity/verification/` and the exact checkers cited by the
  manuscript;
- explicitly excluded on the first pass: task cards, internal handoffs,
  theorem-completeness audits, prior reviews, this repository's issue history,
  and other reviewers' reports.

The standalone mirror was at commit
`87915b54dced89f64cf0b34d860eeaf22e13161f` with PDF SHA-256
`46b012419591ee57d5cff6758d74042a1c1dad8e07d66b8c1b4700b9c1ff5f6c` when
this dossier was prepared. It is not the review surface because it is behind
the authoritative manuscript. If Paper I advances before the batch starts,
freeze one new commit and one new PDF hash for every reviewer; never mix
versions within a batch.

## 2. Review surface in one page

The manuscript starts with a six-arc in `PG(2,11)` and studies the uncovered
projective points, equivalently the projective syndrome locus of cosets at
covering radius three. Its central inverse theorem says that this locus is a
conic exactly for the Clebsch hexagon. The proof combines a universal chord
defect, a new claimed concurrence spectrum, a lower bound for covers of the
complement of a conic, and Dye's equality classification. It then reconstructs
the non-GRS code, a polarity, and an `A_5` action.

The second half reconstructs more structure from the support: a bipartition,
the Petersen/synthematic dictionary, an orientation torsor, a signed symmetric
matrix `B` with `B^2=5I`, triangle holonomy, a cubic threefold with six nodes,
a determinantal pencil, and the integral order `Z[B]` identified with the
golden quadratic order. A final family theorem records the finite-field window
in which conic filling can occur.

The reviews requested here are not audits of Lean code or release machinery.
They ask whether a mathematician can follow and trust the human arguments,
whether cited inputs are used with the right hypotheses, whether conventions
are stable across finite geometry and coding theory, and whether the exposition
makes the result and its novelty legible at the target venue.

## 3. Bottom line: likely route and ranked slate

### Editorial route

The preferred venue in the project strategy is the *Journal of Combinatorial
Theory, Series A*. Its public scope includes finite geometry, codes, and
algebraic geometry over finite fields. The public board currently lists Michel
Lavrauw as Editor-in-Chief and, among relevant editors, Simeon Ball, Ilaria
Cardinali, and Ferdinand Ihringer:

- journal and scope:
  <https://www.sciencedirect.com/journal/journal-of-combinatorial-theory-series-a>;
- public editorial board:
  <https://www.sciencedirect.com/journal/journal-of-combinatorial-theory-series-a/about/editorial-board>.

The most natural forecast is Lavrauw to Ball because the headline theorem
joins arcs and codes. Cardinali is a credible alternate for the
finite-projective/code interface; Ihringer is a credible alternate if the
spectral and graph-theoretic half is emphasized. An editor who handles the
submission would ordinarily not also serve as an anonymous referee, so Ball is
used below as an editorial/adversarial persona rather than predicted
simultaneously as editor and referee.

### Ranked full-paper candidates

1. **Leo Storme — strongest anonymous-referee forecast; high confidence.**
   His work with Van Maldeghem gives the closest published finite-geometric
   neighbour: the projectively unique `A_5`-orbits of sizes six and ten in
   `PG(2,q)`, their Clebsch/Brianchon interpretation, and completeness and
   transitivity questions for arcs. His public research page still centres
   finite geometry and coding theory, and his current publication record shows
   continuing activity. He is positioned to test whether the paper's
   symmetry-free reconstruction is genuinely stronger than the classical
   `A_5`-equivariant classification, whether Dye is represented precisely, and
   whether every small-arc step is humanly complete.

2. **Krishna Kaipa — strongest coding-side referee forecast; high confidence.**
   Kaipa's work directly connects deep holes, MDS extensions, projective
   Reed--Solomon codes, and equivalence of received words. He is positioned to
   catch a change of quotient, a hidden covering-radius hypothesis, confusion
   between projective syndrome points and cosets, or an overstatement of what
   has been reconstructed from the locus. His institutional page records an
   active coding/algebraic-combinatorics research programme.

3. **Fernanda Pambianco — plausible coding/arc referee; medium-to-high
   confidence.** Her work with Davydov and Marcugini is the exact source for
   converting secant multiplicities into MDS-coset weight distributions, and
   her public profile records continuing work in finite geometry and coding.
   She is the closest alternate to Kaipa when an editor wants the arc/coset
   dictionary audited more than the projective Reed--Solomon deep-hole
   quotient. Her expected pressure is on covering radius, scalar syndrome
   counts, leader multiplicity, and historical arc data.

4. **Tamás Szőnyi — plausible finite-geometry referee; medium confidence.**
   The Blokhuis--Brouwer--Szőnyi partial-cover result supplies the numerical
   obstruction used in the inverse theorem, including a computer-supported
   uniqueness statement at `q=11`. Szőnyi is positioned to demand an exact
   comparison between that known uniqueness and the manuscript's new inverse
   classification, and to inspect the equality hypotheses and dual language.
   His 2024 JCTA work remains directly in finite-field arc completeness, and
   he co-organized a 2025 finite-geometry workshop. Aart Blokhuis would be a
   similarly exact senior substitute.

### Focused critics, less certain as full-paper referees

5. **Willem Haemers — conference-matrix/two-graph critic; high relevance,
   medium selection confidence.** The matrix `B` is a symmetric conference
   matrix of order six. Haemers and Parsaei Majd state that every conference
   matrix of order six is Paley and use the standard Seidel switching
   equivalence. A Haemers persona should ask which labelled reconstruction is
   new, which switching-class facts are classical, and whether the manuscript
   consistently separates switching, permutation, and global negation.

6. **Zhijia Zhang or Brendan Hassett — cubic-geometry critic; high relevance,
   lower full-paper selection confidence.** Cheltsov--Tschinkel--Zhang classify
   automorphism groups after assuming a cubic threefold already has six nodes
   in general position. Hassett--Tschinkel explain determinantal cubic
   hypersurfaces and the six-node construction under transversality. Neither
   source supplies the manuscript's claimed direct singular-locus
   calculation. This persona should therefore review the gradient computation,
   completeness of the six nodes, ordinary-double-point check, and transition
   from equations to intrinsic reconstruction.

7. **Neil Gillespie — two-graph/outer-`S_6` conventions critic; high topical
   relevance, lower selection confidence.** Gillespie's papers make the
   switching invariants and Sylvester synthematic-total conventions explicit.
   This persona is useful for the Petersen, matching, normalizer, and
   orientation sections even if less likely to be asked for a full finite-
   geometry report.

### Editorial persona

8. **Simeon Ball — likely handling/editorial read; high route confidence.**
   Ball and Lavrauw's survey fixes the standard arc/MDS-code dictionary and
   emphasizes exactly stated size hypotheses in large-arc completion results.
   The persona should ask whether a specialized `q=11` inverse theorem plus a
   substantial orientation/cubic sequel clears JCTA's significance and length
   bar, and whether the introduction distinguishes the exceptional small-arc
   problem from the better-known large-arc theory.

No ranking here is an availability claim. Conflicts, recent collaborations,
editorial workload, and the submitted author list are not known to this
dossier and could change the actual choice.

## 4. The criticals most likely to control a report

These are review prompts, not pre-judged defects. A cold reader must locate the
earliest exact implication and decide whether it is proved, cited, merely
checkable, or missing.

### Critical A — the inverse theorem's novelty boundary

The manuscript must distinguish three nearby statements without blurring them:

- Dye classifies Clebsch hexagons and their polarity/stabilizer once the
  Clebsch condition is in place;
- Storme--Van Maldeghem classify the relevant six- and ten-point `A_5` orbits
  under an `A_5` symmetry hypothesis;
- Blokhuis--Brouwer--Szőnyi give a lower bound for covers of a conic complement
  and report uniqueness of the extremal `q=11` cover up to isomorphism.

Paper I claims something different: the uncovered/conic locus alone forces the
six-arc, before `A_5` is assumed. The referee should demand a short, exact
comparison with the known `q=11` uniqueness statement: does that statement
classify only a line cover, and what extra work recovers six vertices and the
complete-graph incidence? The paper should neither surrender its new theorem
nor imply that no nearby uniqueness theorem existed.

### Critical B — the human proof of the concurrence spectrum

The claimed universal spectrum `{0,1,2,3,4,6,10}` for ten diagonal-line
concurrences is a major new combinatorial input. Check the equivalence-relation
or graph reduction independently. In particular:

- is every geometric coincidence translated to the stated relation and back;
- are forbidden class sizes or graph types excluded by a written argument;
- is each listed value realized over the stated fields and with six distinct
  arc points;
- do relabelling and projective normalization preserve exactly the quantity
  being counted; and
- is the absence of `5,7,8,9` proved without relying on an unstated finite
  enumeration?

Also challenge the priority wording. The dossier did not establish the absence
of earlier work on all ten concurrence counts; a reviewer should ask for a
bounded novelty statement tied to the literature actually searched.

### Critical C — certificate language inside a human proof

Several orbit and symmetry arguments refer to a two-generator certificate,
particular rows of an action table, or normalizers supplied by a displayed
table. The reader should verify that the table or equivalent data is actually
visible at the point of use and that the written stabilizer/orbit argument can
be reconstructed without opening generated files. A finite check can be a
legitimate proof mode, but the manuscript must identify its domain, invariant,
coverage, and replay surface rather than allude to absent rows.

Apply this especially to the `A_5` point-orbit decomposition, the six cubic
lines and their normalizer, and any claim that a short list exhausts all
possibilities.

### Critical D — coding objects and equivalence relations

Track these layers separately throughout:

- a nonzero syndrome vector;
- its projective point;
- a coset of the fixed code;
- a received word modulo addition of a codeword;
- a deep-hole class with an additional nonzero scalar quotient;
- monomially or semilinearly equivalent codes; and
- projectively equivalent column arcs.

For a point lying on `i` bisecants, the DMP formula counts `q-1` syndrome
cosets over that projective point and `i` weight-two leaders per coset. Check
that orbit counts and decoder statements never silently switch to projective
points or received-word classes. Check separately that the non-GRS conclusion
and every reconstruction statement use the intended equivalence relation.

### Critical E — what is new about the golden matrix

Standard two-graph and conference-matrix language already knows:

- switching by simultaneous sign changes of matching rows and columns;
- relabelling by permutation;
- triple products as switching invariants;
- the Paley switching class in order six; and
- spectral consequences of `B^2=5I`.

Paper I may still make a substantial new claim: that the syndrome/support
geometry canonically recovers a labelled orientation torsor, its conference
matrix, the cubic geometry, and the integral golden order. The reader should
force the paper to say which output is canonical, which is canonical only up
to switching or global negation, and which classification fact is imported.
Do not accept a classical conference-matrix fact presented as if it followed
for the first time from the Clebsch construction.

### Critical F — the six-node cubic proof

The singular-locus argument reportedly reduces the gradient equations to five
quadrics and says they vanish exactly at six axis vectors. A human reader
should perform or demand the missing elimination: why are there no other
projective solutions over the stated field or its algebraic closure? Then
check the Hessian/local quadratic term at every point to establish ordinary
double points, not merely singularity. Finally distinguish:

- six nodes;
- six nodes in general position;
- the six-nodal cubic classification used in the literature;
- the automorphism group of the cubic; and
- the group preserving the labelled support/orientation data.

The cited cubic papers begin after some of these hypotheses; they cannot be
used backward to prove them.

### Critical G — cohesion and JCTA significance

The first half is an inverse theorem in finite geometry/coding; the second is
a long orientation, representation, and cubic sequel. Ask whether the latter
is logically needed for the title and central claim, whether it should be a
separate paper, and whether the introduction supplies one causal story rather
than a catalogue of remarkable structures. Verification apparatus should not
crowd out the human idea. At JCTA length, each extended calculation must repay
its space with a theorem that a combinatorics reader can state and use.

### Critical H — fields, characteristics, and descent

Audit every transition among `F_11`, a general odd field, a field containing
`sqrt(5)`, and an algebraic closure. Dye's exceptional characteristics and
stabilizer changes matter. Audit the existence window, the use of projective
duality, division by `2` or `5`, the splitting of the `A_5` representation,
and the passage from a rational commutant to the integral order. Computation
over `F_11` cannot by itself prove a field-uniform statement.

## 5. Source-grounded convention extracts

The extracts below are paraphrases made for review preparation. They are not
quotations and should not be cited as a substitute for the sources.

### 5.1 Dye: what the classical Clebsch theorems actually give

Source: R. H. Dye, “Hexagons, conics, `A_5` and `PSL_2(K)`,” *Journal of the
London Mathematical Society* (2) 44 (1991), 270–286,
<https://doi.org/10.1112/jlms/s2-44.2.270>.

The authoritative page images in the local `dye-1991` scan set establish:

- Theorem 1: Clebsch hexagons exist exactly when the characteristic is not two
  and five is a square, with projective transitivity on them;
- Theorem 2: each edge has two Brianchon points, the ten points form five
  triangles, and there is a unique orthogonal polarity;
- Theorem 3: the stabilizer is `A_5`, except for the characteristic-five
  enlargement to `S_5`, with the associated transitivity corollary; and
- Theorem 6 supplies the orbit conditions used later in the paper, alongside
  characteristic-three and characteristic-five exceptions.

Reviewer convention: name precisely which Dye theorem supplies existence,
transitivity, polarity, or stabilizer. “By Dye” is not a substitute for the
hypothesis that the six points already form the relevant Clebsch hexagon.

### 5.2 Storme--Van Maldeghem: symmetry assumed versus symmetry recovered

Source: Leo Storme and Hendrik Van Maldeghem, “Primitive arcs in `PG(2,q)`,"
*Journal of Combinatorial Theory, Series A* 69 (1995), 200–216,
<https://doi.org/10.1016/0097-3165(95)90051-9>.

Relevant propositions construct explicit `A_5`-invariant orbits `K_1` and
`K_2` of sizes ten and six when the field congruences permit them. The ten
points lie on three-bisecant structures of the six-point orbit. Both orbits are
projectively unique among the relevant `A_5` orbits; the paper identifies the
Clebsch hexagon, ten Brianchon points, and five self-polar triangles, and then
studies completeness and transitivity.

Reviewer convention: this is an equivariant classification. Paper I's claimed
advance is that no group is assumed and `A_5` is reconstructed. Every novelty
comparison should keep that quantifier difference visible.

### 5.3 Blokhuis--Seress--Wilbrink: the older order-eleven configuration

Source: A. Blokhuis, Á. Seress, and H. A. Wilbrink, “Characterization of
complete exterior sets of conics,” *Combinatorica* 12 (1992), 143–147,
authoritative local `bsw-1992` scan set,
<https://doi.org/10.1007/BF01204717>.

The paper defines a complete exterior set as `(q+1)/2` exterior points whose
pairwise joining lines are passants. At `q=11` it records two configurations,
the six-arc and the Pasch configuration, using computer classification, and
attributes the small examples to Korchmáros.

Reviewer convention: historical priority around the order-eleven six-set is
older than modern code language. A novelty claim should concern the inverse
syndrome-locus theorem or recovered structure, not the mere existence of the
configuration.

### 5.4 Blokhuis--Brouwer--Szőnyi: the exact partial-cover input

Source: A. Blokhuis, A. E. Brouwer, and T. Szőnyi, “Covering all points except
one,” *Journal of Algebraic Combinatorics* 32 (2010), 59–66,
<https://doi.org/10.1007/s10801-009-0204-1>.

Proposition 1.5 gives the general lower bound for a partial cover with a hole.
Proposition 1.6 specializes to lines covering the complement of a conic and
gives the bound `3(q-1)/2`. The paper says the bound is attained for
`q=3,5,7,11` and that the cover is unique up to isomorphism in each of those
orders, based on computer search.

Reviewer convention: cite both the numerical bound and the status of the
small-order equality statement. Then explain whether its object is only an
unlabelled line cover and why Paper I still has to recover the six vertices,
their pair incidences, and the Clebsch condition.

### 5.5 Ball--Lavrauw: arcs and linear MDS codes

Source: Simeon Ball and Michel Lavrauw, “Arcs in finite projective spaces,”
arXiv:1908.10772, <https://arxiv.org/abs/1908.10772>.

Their Theorem 17 is the standard column dictionary between projective arcs and
linear MDS codes, with projective/monomial equivalence kept explicit. Later
large-arc tangent-polynomial and unique-completion results carry size
hypotheses far from a six-arc in `PG(2,11)`.

Reviewer convention: state the matrix orientation and equivalence relation
when passing from columns to a code. Do not let a large-arc conic theorem
silently explain the small exceptional inverse theorem; this manuscript lives
outside those hypotheses and should say so plainly.

### 5.6 Davydov--Marcugini--Pambianco: coset weight from secants

Source: Alexander A. Davydov, Stefano Marcugini, and Fernanda Pambianco, “On
the weight distribution of the cosets of MDS codes,” arXiv:2101.12722,
<https://arxiv.org/abs/2101.12722>.

Definition 6.1 uses the columns of a parity-check matrix as an arc. For an
incomplete arc with covering radius three, Theorem 6.3 converts the number of
bisecants through an off-arc projective point into the number of cosets and
leaders: each point contributes `q-1` scalar syndrome cosets; a point on `i`
bisecants yields that many weight-two cosets, each with `i` weight-two leaders;
an uncovered point yields weight-three cosets with the stated triple count.

Reviewer convention: the geometry controls a projective syndrome point first.
Restore the `q-1` scalar representatives before counting actual cosets, and
keep leader multiplicity separate from coset multiplicity.

### 5.7 Kaipa and Zhang--Wan--Kaipa: deep-hole classes

Sources:

- Krishna Kaipa, “Deep holes and MDS extensions of Reed--Solomon codes,”
  arXiv:1612.05447, <https://arxiv.org/abs/1612.05447>;
- Jun Zhang, Daqing Wan, and Krishna Kaipa, “Deep Holes of Projective
  Reed--Solomon Codes,” arXiv:1901.05445,
  <https://arxiv.org/abs/1901.05445>.

Kaipa relates a received word for a fixed Reed--Solomon code to an extra column
of a parity-check matrix and, under the stated range and covering-radius
hypotheses, to an MDS extension. The projective Reed--Solomon paper takes a
deep-hole class modulo `v=a u+c`, with `a` nonzero and `c` a codeword. It
classifies within a fixed projective RS setting and does not assert that every
non-GRS code is recoverable from its deep-hole locus.

Reviewer convention: every “class,” “same hole,” and “recovered code” statement
must name its quotient. Pay special attention at length `q+1`, where the
covering radius and MDS-extension equivalence require their own justification.

### 5.8 Gillespie and Seidel conventions: signs are representatives

Source: David M. Duncan, Thomas R. Hoffman, and James P. Solazzo, “Numerical
Measures for Two-Graphs,” arXiv:0810.3189,
<https://arxiv.org/abs/0810.3189>.

The paper reviews a two-graph as a triple system satisfying even parity on
each four-set, its representation by a graph switching class, and the
coherent/incoherent terminology. Changing unit-vector signs changes the graph
representative by switching while leaving triple products and the two-graph
invariant.

Reviewer convention: distinguish the labelled sign matrix, its switching
class, the two-graph, and an orientation torsor. A proof that triple products
are intrinsic does not make individual edge signs intrinsic.

### 5.9 Haemers--Parsaei Majd: conference-matrix equivalence

Source: Willem H. Haemers and Leila Parsaei Majd, “Spectral symmetry in
conference matrices,” *Designs, Codes and Cryptography* 90 (2022), 1677–1684,
<https://doi.org/10.1007/s10623-021-00858-8>.

Their convention uses a Seidel matrix with `-1` at adjacent pairs. Switching
multiplies a matching set of rows and columns by `-1`; equivalence also permits
reordering. They note that every conference matrix of order six is Paley.

Reviewer convention: `B^2=5I` places Paper I's `B` in a classical order-six
conference class. The publishable content must therefore lie in its intrinsic
recovery, labelling, compatibility with the support/cubic structures, or
integral consequences—not in the bare switching classification.

### 5.10 Sylvester totals and the outer automorphism

Source: Neil Gillespie, Padraig Ó Catháin, and Cheryl Praeger, “Construction of
the outer automorphism of `S_6` via a complex Hadamard matrix,” arXiv:1805.01273,
<https://arxiv.org/abs/1805.01273>.

The paper gives an explicit Sylvester synthematic-total construction and is
careful about action side and the two non-equivalent six-point actions of
`S_6` connected by the outer automorphism.

Reviewer convention: a matching, syntheme, synthematic total, outer action,
and Petersen model are related but not interchangeable labels. State which
six-element set each permutation acts on and display enough of the map to fix
the convention.

### 5.11 Cheltsov--Tschinkel--Zhang: classification begins after the nodes

Source: Ivan Cheltsov, Yuri Tschinkel, and Zhijia Zhang, “Equivariant geometry
of singular cubic threefolds,” arXiv:2401.10974,
<https://arxiv.org/abs/2401.10974>.

Section 7 and Proposition 7.3 classify automorphism possibilities under the
assumption that the cubic threefold already has six nodes in general position;
one case has the expected `S_5` symmetry. This is contextual classification,
not a proof that a newly written cubic has exactly six ordinary nodes.

Reviewer convention: prove the singular scheme and general-position
hypotheses before invoking the classification. Do not infer the hypotheses
from the desired automorphism group.

### 5.12 Hassett--Tschinkel: determinantal cubics and transversality

Source: Brendan Hassett and Yuri Tschinkel, “Flops on holomorphic symplectic
fourfolds and determinantal cubic hypersurfaces,” arXiv:0805.4162,
<https://arxiv.org/abs/0805.4162>.

Their determinantal construction relates trace-orthogonal matrix spaces and
cubic hypersurfaces. Under transversality/general-position hypotheses, the
associated cubic threefold has six ordinary nodes; the argument makes clear
that a determinant formula alone does not certify the singularity type.

Reviewer convention: identify which transversality statement Paper I proves
in its special pencil, or give the direct gradient and local-quadratic proof.

## 6. Persona packets

Each packet is deliberately bounded. A reviewer reads the frozen PDF first,
then only the listed sources. Do not add internal task context. When a packet
names a source section, reading more of that paper is allowed; adding a new
literature narrative is not.

### Packet E — Ball editorial/significance read

**Persona:** a JCTA finite-geometry and coding editor deciding whether to send
the paper out and what expertise is required.

**Read:**

1. frozen Paper I PDF, in order;
2. Ball--Lavrauw, Theorem 17 and the large-arc completion sections;
3. Dye, theorem statements on pp. 275–281;
4. Storme--Van Maldeghem, Propositions 11–13;
5. JCTA public scope.

**Ask:**

- Can the main new theorem be stated in two sentences without the verification
  apparatus?
- Is the symmetry-free inverse direction visibly absent from the cited
  classical results?
- Does the small exceptional problem matter beyond `q=11`?
- Is the orientation/cubic half one coherent consequence or a second paper?
- Are the human proofs readable enough to justify external review?

**Expected pressure:** novelty positioning, length, causal exposition, theorem
hierarchy, and the boundary between an exact finite result and a reusable
method.

### Packet S — Storme/Szőnyi finite-geometry read

**Persona:** an expert in arcs, projective group orbits, complete exterior
sets, and partial covers.

**Read:**

1. frozen Paper I PDF, with emphasis on the inverse theorem and field family;
2. Dye, Theorems 1–3 and 6 from authoritative scans;
3. Storme--Van Maldeghem, Propositions 11–13 and surrounding definitions;
4. Blokhuis--Seress--Wilbrink, `q=11` classification pages;
5. Blokhuis--Brouwer--Szőnyi, Propositions 1.5 and 1.6.

**Ask:**

- Does the chord-defect identity count the correct dual object with the right
  multiplicities?
- Is the concurrence spectrum fully proved and field-valid?
- Does equality in the cover bound force exactly what the paper says?
- What does the known `q=11` uniqueness already classify?
- Is the application of Dye circular at any point?
- Are every exceptional characteristic and square-class hypothesis visible?

**Expected pressure:** the earliest unsupported incidence implication,
classification status, historical attribution, and symmetry assumed versus
symmetry recovered.

### Packet K — Kaipa coding read

**Persona:** an expert in Reed--Solomon deep holes, MDS extensions, and
projective code equivalence.

**Read:**

1. frozen Paper I PDF, especially introduction and code/deep-hole sections;
2. Kaipa, arXiv:1612.05447, main equivalence theorem and hypotheses;
3. Zhang--Wan--Kaipa, definitions of projective RS deep-hole classes;
4. Davydov--Marcugini--Pambianco, Definition 6.1 and Theorem 6.3;
5. Ball--Lavrauw, Theorem 17.

**Ask:**

- Is the code fixed at each quotient or equivalence step?
- Does the covering radius equal three for the reason stated?
- Are projective syndrome points converted to actual cosets by the correct
  scalar factor?
- Are leaders, holes, received words, and hole classes counted separately?
- Does “reconstructs the code” mean a labelled parity-check matrix, a
  projective arc, or a monomial-equivalence class?
- Is “non-GRS” proved for the relevant equivalence notion?

**Expected pressure:** normalization, quotient conventions, hypotheses at
length `q+1`, and whether the code-language theorem really follows from the
geometric theorem.

### Packet H — Haemers/Gillespie orientation read

**Persona:** an expert in Seidel matrices, regular two-graphs, conference
matrices, switching, and the outer automorphism of `S_6`.

**Read:**

1. frozen Paper I PDF from the support bipartition through the commutant;
2. Duncan--Hoffman--Solazzo, definitions and switching construction;
3. Haemers--Parsaei Majd, conference equivalence and small orders;
4. Gillespie--Ó Catháin--Praeger, the synthematic-total construction;
5. only after the first report, the exact Paper I checkers that instantiate
   `B`, triangle products, and group actions.

**Ask:**

- Which data determine `B`, and only up to which operations?
- Is global negation part of the same equivalence or the second orientation?
- Are triple products, the support cubic, and the two-graph synchronized under
  the manuscript's sign convention?
- Is the order-six Paley/conference classification properly acknowledged?
- Are the two six-point actions and all normalizers fixed by displayed data?
- Which part of `Z[B]` is intrinsic rather than basis-dependent?

**Expected pressure:** classical-versus-new boundary, sign discipline,
labelled versus switching-class recovery, and absent action tables.

### Packet C — Zhang/Hassett cubic read

**Persona:** an algebraic geometer familiar with singular and determinantal
cubic threefolds.

**Read:**

1. frozen Paper I PDF from triangle holonomy through the cubic and determinant
   pencil;
2. Cheltsov--Tschinkel--Zhang, Section 7, especially Proposition 7.3;
3. Hassett--Tschinkel, determinantal cubic construction and the propositions
   governing six nodes;
4. only after the first report, the manuscript's exact singular-locus checker.

**Ask:**

- Solve the five displayed quadrics: why are the six asserted points the full
  projective singular locus?
- Is the statement geometric over an algebraic closure or only rational over
  the base field?
- Is every singularity an ordinary double point, with a humanly visible local
  calculation?
- Are the nodes in the general position required by the cited classification?
- Does the determinant identity explain the cubic or merely repackage a
  checked polynomial identity?
- Does the claimed automorphism group preserve the cubic, the node labelling,
  or the full oriented support?

**Expected pressure:** completeness of elimination, transversality, field of
definition, and improper backward use of classification results.

## 7. Cold-read protocol

Run at least four independent reports: Packet S, Packet K, Packet H, and
Packet C. Packet E is a separate editorial read and should be included before
submission triage. The packets must not see one another's output.

Each reviewer should:

1. record the PDF hash and packet used;
2. read the PDF before opening the supplement or internal checkers;
3. state the strongest theorem they believe the paper proves;
4. reconstruct its causal proof chain in their own words;
5. identify the earliest implication they cannot justify from the PDF;
6. test every relevant field, quotient, switching, action-side, and
   singularity hypothesis;
7. classify each finding as proof, citation, normalization, computation,
   exposition, or novelty/significance;
8. distinguish a false statement, a proof gap, a missing finite certificate, a
   missing citation, and an explanation that is merely too compressed;
9. give a categorical verdict: `GO`, `MINOR`, or `MAJOR`;
10. list no more than five controlling findings, in priority order;
11. write one sentence saying what is new relative to their packet; and
12. only then inspect the allowed supplement and say which concerns it resolves
    and which remain defects of the human exposition.

The coordinator freezes all reports before synthesis. The synthesis should
separate overlaps from persona-specific preferences, locate each overlap at
the earliest TeX statement, and avoid majority voting. A finding is adopted
because its mathematical premise is verified, not because several simulated
reviewers repeat it.

## 8. Availability, conflict, and persona cautions

- Public research activity establishes topical plausibility, not willingness
  or availability.
- Do not imitate prose, temperament, nationality, or personal style. A persona
  consists only of source-grounded mathematical conventions and proof
  expectations.
- Do not claim that a named scholar would reach a particular verdict.
- The handling editor and anonymous referee roles are alternatives when they
  concern the same person.
- Before any real submission recommendation, check the actual author list for
  recent coauthorship, same-institution conflicts, advisor relationships, and
  other journal-defined exclusions. This dossier intentionally does not infer
  those from partial public data.
- Cubic and conference-matrix critics are selected to stress specialized
  sections; their inclusion does not predict that JCTA would seek that exact
  specialty.
- Internal reviews and theorem-completeness work are withheld because they
  would contaminate a cold read. Their existence must not be hinted to a
  persona as a list of expected defects.

## 9. Source ledger

### Manuscript and project surfaces read

- complete `papers/clebsch-rigidity/clebsch_rigidity.tex` at the frozen commit;
- `papers/clebsch-rigidity/README.md`;
- `papers/clebsch-rigidity/verification/README.md`;
- Paper II and Paper III reviewer dossiers as process precedents;
- public Clebsch venue strategy for the intended submission route.

### Authoritative scans inspected

- Dye 1991: page images corresponding to journal pp. 275, 277, 278, and 281;
  OCR was used only to locate statements. The local scan set, verified by the
  literature-cache root `SHA256SUMS`, is the authority.
- Blokhuis--Seress--Wilbrink 1992: page images corresponding to journal
  pp. 143 and 146; OCR was used only for navigation. The local scan set,
  verified by the literature-cache root `SHA256SUMS`, is the authority.

### Cached papers and relevant sections read

The cache keys and PDF SHA-256 hashes make the packet reproducible:

- `arXiv:1908.10772`, Ball--Lavrauw,
  `00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4`;
- `10.1016/0097-3165(95)90051-9`, Storme--Van Maldeghem,
  `770f27f1e22b29e077ee17c9747c7f529f27ed4b26e5408f2a1dae5c56363d3b`;
- `10.1007/s10801-009-0204-1`, Blokhuis--Brouwer--Szőnyi,
  `c645a01905340e8100a5b9d46d806331bb0c21339e4c655aa6747d7e82c25fbe`;
- `arXiv:2101.12722`, Davydov--Marcugini--Pambianco,
  `7d025799078793d01db22f845dec8c46e851f63e6f0c9343462545b7d46944e9`;
- `arXiv:1612.05447`, Kaipa,
  `1fe8de83c0b8cd3938e1a450fd49f376de795d7a317f099a730c63ab968178a4`;
- `arXiv:1901.05445`, Zhang--Wan--Kaipa,
  `5c2b9e2508c7200428c441b7a41da1596b1c9b0851f5632e2297cdbed41caf24`;
- `arXiv:0810.3189`, Duncan--Hoffman--Solazzo,
  `47b184d9e56da34cb24b7289b5a4ad54b4f922164e8831a367e1f79354f5f01e`;
- `10.1007/s10623-021-00858-8`, Haemers--Parsaei Majd,
  `86a4d6e41f62ef224f5a410653120794bf756ad9a9e2dc2aaa4bdc2f4f4c799e`;
- `arXiv:1805.01273`, Gillespie--Ó Catháin--Praeger,
  `f5e7ecefeb2f3528b0099644d60486314c4b045e7d2e79657f4ccd7c73ad86d0`;
- `arXiv:2401.10974`, Cheltsov--Tschinkel--Zhang,
  `5fb44374d4a2c1790c6246a522e12df32afc7c9a81c9ca8bcd1ade62215df089`;
- `arXiv:0805.4162`, Hassett--Tschinkel,
  `89ca37f2a5908c3355fda20bda6e8e469d22ffcc5f93232de88a60a7f700f885`.

The cache text was used to navigate and compare relevant definitions,
theorems, and surrounding proofs. No claim of exhaustive reading is made for
the 30- to 67-page survey and cubic papers.

### Metadata/current-activity evidence only

- Simeon Ball: <https://web.mat.upc.edu/simeon.michael.ball/>;
- Leo Storme: <https://cage.ugent.be/~ls/research_leo.html> and
  <https://research.ugent.be/web/person/leo-storme-0/publications/en>;
- Krishna Kaipa:
  <https://www.iiserpune.ac.in/research/department/mathematics/people/faculty/regular-faculty/krishna-kaipa/282>;
- Fernanda Pambianco:
  <https://www.unipg.it/personale/fernanda.pambianco>;
- Tamás Szőnyi: <https://szonyitamas.web.elte.hu/> and the 2024 JCTA article
  record <https://publicatio.bibl.u-szeged.hu/29111>;
- Willem Haemers:
  <https://www.tilburguniversity.edu/nl/medewerkers/haemers>;
- Brendan Hassett: <https://www.math.brown.edu/bhassett/>;
- Zhijia Zhang: <https://zhijiazhangz.github.io/>.

These pages support affiliation, research area, and recent activity only. They
do not support the mathematical convention extracts, which come from the
papers above.

### Not established

- the actual handling editor or referee list;
- any named person's availability, conflicts, or likely verdict;
- an exhaustive priority search for the concurrence spectrum;
- whether the Blokhuis--Brouwer--Szőnyi `q=11` uniqueness can be converted
  directly into the manuscript's vertex reconstruction without extra work;
- whether a journal would prefer the orientation/cubic half as a separate
  submission.

## 10. Recommended batch and synthesis order

Launch the reports in this order only for administration; they remain
independent:

1. Packet S, full inverse-theorem read;
2. Packet K, full coding-language read;
3. Packet H, support/orientation read;
4. Packet C, cubic singularity read;
5. Packet E, full editorial/significance read.

Do not use the exact public scholar's name as a claim of impersonation in the
report title. Use labels such as `finite-geometry persona (Storme packet)` and
state that the packet is constructed from published conventions. Freeze each
report before launching synthesis. Only the final synthesis may compare their
categorical verdicts.

## 11. EJ + TT closeout

**Extra juice.** The coding side should not be collapsed into one generic
persona. Kaipa supplies the received-word/MDS-extension quotient discipline,
while Pambianco's exact source supplies the secant-to-coset enumeration. The
cheap upgrade taken here was to rank Pambianco explicitly and make Packet K
test both layers. This also gives an editor a credible coding alternate without
changing the finite-geometry packet.

**TT stress question.** The closest pair of order-eleven predecessors may be
more tightly related than the manuscript's citation flow makes visible:
Blokhuis--Seress--Wilbrink classify complete exterior six-sets, while
Blokhuis--Brouwer--Szőnyi report a unique extremal fifteen-line cover of a conic
complement. Conic polarity and the fifteen pair-lines suggest a bridge, but the
read sources do not state the exact reconstruction map. Packet S must decide
whether these are two descriptions of the same classified object, whether the
line cover determines its six concurrency vertices, and precisely what remains
for Paper I's symmetry-free inverse theorem. This is a high-value review
question, not an established objection.

The closeout also confirmed that the order-six conference classification is a
classical input that deserves its own critic packet rather than a generic
finite-geometry aside. No new C-item is warranted: both questions are direct
acceptance gates for the pending C898 cold reads.

## 12. Mystery ledger

### Settled for dossier purposes

- Paper I is the intended review target; this is separate from the existing
  Paper III dossier.
- JCTA supplies the venue model, with a finite-geometry/coding editorial route.
- Storme and Kaipa give the most plausible complementary anonymous-referee
  profiles; Haemers/Gillespie and Zhang/Hassett supply necessary specialized
  stress tests.
- The authoritative monorepo PDF, not the stale standalone mirror, is the
  frozen review artifact.
- Five bounded packets cover the human-proof and exposition interfaces without
  importing normal Paper I lane context.

### Open and owned by C898

- Does the `q=11` partial-cover uniqueness materially shorten or alter the
  claimed inverse proof?
- Are the Blokhuis--Seress--Wilbrink six-set and the
  Blokhuis--Brouwer--Szőnyi fifteen-line cover explicitly dual descriptions of
  the same isomorphism class, and does either source recover the six vertices?
- Can a cold finite geometer reproduce the concurrence spectrum from the prose
  alone?
- Are the orbit/action certificates actually exposed sufficiently for a human
  proof?
- Does the code section keep every projective and scalar quotient exact?
- Does the orientation section distinguish intrinsic recovery from classical
  order-six conference classification?
- Is the six-node cubic proof complete without a checker?
- Does the orientation/cubic sequel strengthen the paper's JCTA case or dilute
  it?

Those questions are deliberately unresolved here. The independent reports,
not the dossier author, own their adjudication.
