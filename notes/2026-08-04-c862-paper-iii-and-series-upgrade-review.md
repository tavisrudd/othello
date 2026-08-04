# C862 — review of the Paper III upgrade proposals and the series exceptionality problem

**Date:** 2026-08-04
**Lane:** `clebsch` (Paper III stream)
**Task:** C862 (active; research report only; no manuscript, Lean, or release edit)
**Inputs read in full:** the Paper III manuscript (all sections and the front
matter), `2026-08-03-c862-paper-iii-ceiling-upgrade-research.md`,
`2026-08-03-c862-paper-iii-spectral-descent-recognition-theorem-packet.md`,
`2026-08-03-paper-iii-framing-and-ceiling-review.md`,
`2026-08-03-clebsch-program-unity-review.md`,
`2026-08-02-c815-four-shadow-lean-formalization.md`,
`2026-08-03-c815-paper-iii-formalization-gap-inventory.md`,
`2026-08-04-c815-paper-iii-gate-hardening-report.md`, plus a cold external
portfolio review of Paper III supplied by the user.

## Verdict

The C862 proposals are sound where they are cautious and mis-framed at exactly
one point: Theorem I of the spectral packet is stated as the existence of an
isomorphism `E ≅ Q[C]`, which is automatic — `Q(√5)` is the unique quadratic
field of discriminant five, so no content can live in the existence claim. The
content is the *compatibility* the packet then proves: the incidence deck
involution corresponds to `C ↦ −C`, and the six-axis carrier is a rank-three
module over the resulting algebra. Promoted in its current wording, a referee
dismisses it in one line. Promoted as a compatibility statement it is a real
unity gain.

The framing review's `L1` (marking invariance) is correctly rejected, `J1`
(complete obstruction data) is correctly rejected, and the recognition
re-centring is correctly accepted. The one substantive under-ranking is `PJ3`,
the general one-fibre square-class lemma: it is the cheapest generality upgrade
in the entire memo, it is already proved verbatim inside the manuscript, and it
appears in no tier.

Separately: the external cold review's central mathematical objection — that
several of the identifications may be forced by working in one small
`A₅`-representation rather than by a theorem — is not answered anywhere in the
C862 material, and the manuscript already contains the correct answer in its
harmonic section. Applying that device uniformly is a cheap, high-value upgrade.

The exceptionality perception is a packaging problem more than a content
problem. The corpus contains at least five theorems that quantify over all
orders, all fields, or all two-graphs; every one of them is currently packaged
as a lemma in service of one distinguished configuration.

## State verified in the manuscript and the formal surface

Checked directly rather than inherited from the notes:

- The three C815 manuscript corrections in
  `papers/clebsch-passages/sections/08-verification.tex` **are already applied**.
  The Ramsey sentence now credits the kernel-checked bounds and carries the
  distinctness obligation (lines 46–51), the gate count is plural (line 59), and
  the compiled-evaluation paragraph asserts the stronger checked property
  (lines 65–69).
- That last point matters: item 2 of "Work for the manuscript owner" in
  `2026-08-04-c815-paper-iii-gate-hardening-report.md` — add a
  compiled-evaluation disclosure for seventeen terminals — **is stale**, as are
  lines 126–128 of the same report, which say the passages and golden-return
  closures legitimately contain `native_decide`. None of the three axiom reports
  contains a `native` entry, and all three verifiers refuse it. Anyone working
  that checklist verbatim would re-introduce a disclosure of a boundary that no
  longer exists.
- Two manuscript ambiguities from the assertion inventory remain live and need
  an author decision, since Lean cannot state either until they are settled:
  the abstract's "four equivalent descriptions"
  (`clebsch_passages.tex:53`) against the introduction's attribution of the four
  to the six outer translates; and the selected-query claim, stated as
  sufficiency at `05-golden-operator.tex:235` and as an exact count at
  `05-golden-operator.tex:337` and `09-conclusion.tex:32`.
- Gap classes B and C of the inventory are untouched. Class C item 6 (the
  rank-14 weighted Jacobian, an external rational certificate) is the one that
  touches C862's Tier 1: it does **not** gate promotion of the sign-locus
  recognition theorem, which is fully symbolic and kernel-checked, but it does
  gate any manuscript sentence asserting local weighted rigidity or isolation.
  Promote the recognition theorem; keep the weighted-rigidity sentence behind
  the certificate until a structural rank argument or a compressed Lean rank
  computation exists.

## Assessment of the C862 spectral-descent packet

### What holds

The algebra checks out. With `θ = (I+C)/2` and `C² = 5I`,
`θ² = (I + 2C + 5I)/4 = (3I + C)/2 = θ + I`, so `t ↦ θ` is the golden
specialization; `C = 2θ − I` gives surjectivity. The block determinant is right:
for two three-dimensional summands,
`det [[0, −aBᵀ],[aB, 0]] = (−1)⁹ (−a³ det B)(a³ det B) = a⁶ (det B)²`, and
`a = 2√5` gives `8000`. Against the manuscript's existing `16 Z_T²` this yields
`Z_T² = 500 (det B_T)²`, which is exactly the identity already displayed at
`05-golden-operator.tex:538–540`. So Proposition II is not new arithmetic; it is
a new *reading* of an identity the paper already proves.

That reading is worth having. It upgrades C764's answer to "why the determinant
and not the permanent" from a basis-freeness argument to an arithmetic one: the
commutator determinant is the norm of a determinant-line-valued object measuring
the failure of the diagonal algebra to preserve the rank-three module. The
determinant-line formulation also removes an invisible choice of eigenbases from
the central claim. Both are cheap and both improve the paper.

### What must be restated before promotion

1. **Theorem I is currently a tautology in its headline clause.** Restate so the
   claim is the correspondence of involutions and the module structure, not the
   existence of an isomorphism. The paper already proves the involution half at
   `03-orientation-source.tex:90–92` ("conjugation transported by `R` changes `C`
   to `−C` and `Z_C` to `−Z_C`"). The genuinely new clause is rank three over
   `Q[C]`.

2. **The mechanism claim outruns what is proved.** "The incidence residue
   algebra is the operator's coefficient algebra" reads as a construction: the
   fibre algebra acting on a carrier built from incidence data. What is proved is
   transport of a marked bridge — the packet says so in its conventions section
   ("Nothing below removes the need for that bridge") and then lists globalizing
   the action as open and "not needed here". It *is* needed for the strong
   sentence. Two honest options, and the choice is an author decision:
   - safe now: state the compatibility, not the identification — the deck
     involution is the operator sign involution and the carrier is rank three
     over the fibre algebra, relative to the marked bridge;
   - ambitious: construct a relative rank-three module over an open of `P(H)`
     whose fibre at `[xyz]` is the golden one. That would make the spectral
     statement global rather than pointwise, and it is the natural home for the
     integral comparison as well. See the ambitious plan below.

3. **The significance language drops the relativity.** The abstract sentences
   proposed at the end of the C862 report state the spectral realization without
   the marked-bridge qualifier, while the packet's own "claims deliberately not
   made" section keeps it. Paper III's largest completed correctness repair
   (C733) was precisely making that relativity explicit; the abstract must not
   silently regress it.

### The missing proposition: answer the coincidence objection with the paper's own device

The cold external review's sharpest point is that in a low-dimensional
irreducible representation many equivariant tensors are unique up to scalar, so
a network of "equivalent realizations" may be inevitable rather than
theorem-worthy. Neither C862 document addresses this, and it is the objection
most likely to be raised by an invariant theorist.

The manuscript already answers it — in the harmonic section, and nowhere else.
At `05-harmonic-realization.tex:119–137` the two-transitivity of `A₅` on five
letters forces every equivariant comparison to be a scalar multiple of the
pair-sum map, and requiring `σ₃` to be preserved forces the scalar; at line 191,
"Multiplicity one is what reduces the whole cubic calculation to this marked
fixed line; `1960/27` is therefore a normalization scalar, not an experimental
coincidence." That is exactly the right move, stated exactly once.

**Recommendation: apply it uniformly to the four cubic shadows.** Add a short
proposition or remark before Theorem `thm:operator-shadows` saying which of the
identifications are forced by equivariance and multiplicity one, and what
residual content each carries after that is granted. The residue is not empty
and is worth naming: the exact scalars (`4` for the Pfaffian, `±10√5` for the
cross-golden determinant, the factor `8000` if Proposition II lands), the Hodge
orientation transport — which the paper already flags as not freely
interchangeable with switching at `05-golden-operator.tex:402–406` — the
integral structure, and above all the *reverse* direction, C809's recognition
theorem, which is not a coincidence statement at all.

This converts the strongest available referee objection into a proposition, at
the cost of one paragraph and a dimension count, using a method the paper has
already validated in another section. It belongs in Tier 1.

### PJ3 is under-ranked

The general one-fibre reconstruction lemma appears in the C862 report's prose
and in no tier. It is the cheapest generality upgrade available, and the proof is
already written: the argument at `02-orientation-cover.tex:174–200` uses only
characteristic zero, `Pic(P(H)) = Z`, and irreducibility of the branch divisor.
Lifting that paragraph into a displayed lemma — *for a normal base whose Picard
group has no two-torsion and a quadratic cover with irreducible branch divisor
cut by a section `J`, the generic field is `K(√(cJ))` for a constant square
class `c`, and one unramified rational point with quadratic residue field
determines `c`* — costs nothing and changes the register of the whole arithmetic
section from "we computed a constant" to "one arithmetic fibre reconstructs
every rational quadratic twist with this branch divisor".

Priority caution: this is close to standard descent for quadratic covers. C811
is already queued to delimit Kummer precedence, and the lemma should be stated
with an attribution-neutral framing regardless of the outcome. A standard lemma,
stated in general form and then applied, still raises the paper's generality; it
just cannot carry a novelty claim.

### On the integral seam

The re-ranking of the integral comparison depends entirely on arXiv `2601.10106`
being what the report says it is; the read depth is recorded as partial and the
identification of Paper III's three-skew-form Grassmannian model with the split
`V₂₂`-scheme is not yet checked against the construction, only against the
abstract and the numbered statements. Before allocating the comparison task,
one in-house step is cheaper than anything external: C708 records that prime
three is the scalar-six/compound boundary and C711 locates it in the icosahedral
integral splitting rather than the quaternion layer. That existing localization
may answer the characteristic-three gate outright, and it predicts the likely
outcome — the comparison holds after inverting three as well, i.e. over
`Z[1/30]`, matching C682's recorded minimal base. Run that read before spending
on new geometry. The prediction is falsifiable, which is the point.

## Cheap upgrades to Paper III, ranked

All are prose or statement-level. None requires new mathematics, and each names
its anchor in the current source.

1. **Lead the abstract with the conductor, not the constant.** The paper proves
   at `02-orientation-cover.tex:99–106` that five is the discriminant square
   class of the two branches, forced by residue-field pinching — "not merely a
   value recovered from the sextic". The abstract still opens "We determine the
   rational twist". One sentence, and the advertised content finally matches the
   proved content.

2. **Add the multiplicity-one proposition** described above, and state the
   residual content of the four shadow identifications.

3. **Promote the general square-class lemma (PJ3)** out of the proof of
   Theorem `thm:arithmetic-main` and state it before its Hitchin application.

4. **Insert the spectral compatibility statement and the determinant-line
   norm** (C862 Theorem I restated as compatibility, plus Proposition II),
   keeping the marked-bridge qualifier in every promoted sentence.

5. **Re-bill the two general theorems as general.** Concretely:
   - retitle `\subsection{Why order six is exceptional}`
     (`05-golden-operator.tex:78`). The theorem under it is a general spectral
     formula for every symmetric conference matrix of order `2d`, with order six
     as its *answer*. The current title advertises the exceptionality the series
     is trying to shed.
   - restate the balanced-exchange abstract sentence so the general formula
     leads and order six follows as the conclusion.
   - state aligned faithfulness in **principal-minor language**: the family of
     4×4 principal minors of a Seidel matrix determines it up to switching and
     negation for `n ≥ 7`, with seven sharp and an `O(n²)` decoder. The identity
     `det C[Q] = 3 − 2w(Q)` is already in the paper at
     `05-golden-operator.tex:190–191`; the reframing is free. This matters more
     than it looks: "aligned four-sets" is a private term that no one will
     search for, while the principal-minor assignment problem is an existing
     literature with an audience. See the caution in the ambitious plan.

6. **Settle the two live ambiguities** (the abstract's "four equivalent
   descriptions" and the query-count sufficiency-versus-exact-count split).
   These block the corresponding Lean statements, so settling them is on the
   critical path for gap class C, not only for prose.

7. **Disambiguate the two elevens.** The paper carefully says that the prime
   eleven in the harmonic denominator is the universal Wigner normalization and
   is unrelated to the incidence square class
   (`05-harmonic-realization.tex:186–195`). It does not say it is unrelated to
   Paper I's field `q = 11`. In a series already perceived as "the `q = 11`
   thing", a reader will conflate them. One clause fixes it.

8. **Name the Gaunt factorization** as a proposition (framing review upgrade 4).
   Already proved; currently living inside prose.

## Cheap upgrades to the series

1. **A standing "what is general here" paragraph** in each paper's introduction,
   naming the results that quantify over all orders, fields, or two-graphs, and
   the results that concern the distinguished configuration. Same structure in
   all four papers. This is the single highest-leverage anti-exceptionality move
   available and it costs a paragraph per paper.

2. **The series map figure** and the cross-paper recognition blurb already
   drafted in `2026-08-03-clebsch-program-unity-review.md`, landing only through
   the passes already scheduled.

3. **Cross-anchor Paper I and Paper III at the conductor-two order.** The exact
   statement is `Z[C] ≅ Z[√5] ⊊ Z[(1+√5)/2]`, index two, with `(I+C)/2`
   non-integral on the raw coordinate lattice. Paper I's fibre-odd integral
   commutant is recorded as the same conductor-two order in the handoff. State
   the rational fact as a remark; a full lattice identification needs an explicit
   map and should not be claimed.

## The exceptionality problem

### Diagnosis

The perception is that the series is a rich chapter in the theory of one
exceptional object. The diagnosis is packaging: the corpus already contains
general theorems, all of them currently subordinate to the distinguished
configuration.

| result | actual quantifier range | current packaging |
|---|---|---|
| aligned-design faithfulness | every two-graph, every `n ≥ 7`, sharp; `O(n²)` decoder | private terminology, fourth item in a golden-vocabulary abstract |
| balanced exchange spectrum | every symmetric conference matrix of order `2d`; general trace formulas | section titled "Why order six is exceptional" |
| triangle/Pfaffian recognition (C809) | every symmetric zero-diagonal matrix with nonzero entries, any characteristic ≠ 2 | not in the manuscript at all yet |
| quadratic pinching | every separable quadratic extension, every `n ≥ 1` | unnumbered display inside a subsection |
| square class from one fibre | every normal base with 2-torsion-free Picard group | inside a proof |
| conic filling (C756) | all odd prime powers, both residue classes | active research crown, unpublished |

Three of the six are literally general lemmas presented as machinery. Two of the
remaining three have "order six" or "`q = 11`" in the headline where it belongs
in the conclusion.

There is also a real second `11`: Paper I's field and the harmonic Wigner
denominator `46189 = 11·13·17·19` are unrelated, and the series does not say so.

### Ambitious plan: three arms, each removing one flavour of exceptionality

**Arm 1 — general order: a determinantal recognition programme for signed
graphs.** The series already owns two data points on one question: *how much
small determinantal data recognizes a signed graph?*
- 4×4 principal minors of a Seidel matrix determine it up to switching, `n ≥ 7`
  sharp, with a quadratic decoder (aligned faithfulness).
- The complementary `(n/2)`-minors are the coefficients of the commutator
  Pfaffian `Pf[D_x, A]`; at `n = 6` the triangle coefficients recover the
  switching class, and nonzero coincidence with the triangle cubic forces
  `A² = λI` (C809).
The natural general question is whether `Pf[D_x, A]` — a degree-`n/2` form
whose `x_S` coefficient is `± det A[S^c, S]` — determines `A` up to switching and
sign for general even `n`. C862's degree observation (`n/2 = 3` forces `n = 6`)
explains only why *that particular pair* of shadows can coincide in order six;
it says nothing about what the Pfaffian shadow alone knows at higher order.
Add the order-26 moment separation (C812/C822) and the story becomes: at each
conference order, which determinantal data separate the classes, with order six
as the rigid endpoint where everything collapses to one class. That is a
programme, not a configuration.
*Caution before this is used for positioning:* the principal-minor assignment
problem is an existing literature, and only one query in the C862 search record
touches it. Run the bounded audit in that language before any novelty claim. The
reframing is worth doing even if it costs a novelty claim, because it converts
a private term into a searchable one — and the sharp `n = 7` bound and the
`O(n²)` decoder are likely to survive an attribution hit.

**Arm 2 — general field: land C756.** The all-`k` conic-filling classification
replaces "we did `q = 11, 13, 17, 19`" with an all-`q` theorem. Its current
state is strong: the branch is unconditionally empty for every odd prime power
`q ≤ 151`, Baer-subline containment is closed outright for every odd prime
power, and the invariant clique bound empties `q ≡ 1 (mod 4)` using neither
condition (A) nor any conjecture. This is the single strongest available answer
to the "exceptional `q = 11`" reading, because it is the only one that makes the
finite-field work a corollary rather than the content.

**Arm 3 — general base: the relative spectral module and the integral
comparison.** Two coupled targets. Construct a relative rank-three module over
an open of `P(H)` whose fibre at `[xyz]` carries the golden algebra action —
this turns C862's pointwise spectral statement into a global theorem and removes
the "transport through a marked bridge" weakness. Then run the integral
comparison against the split Mukai–Umemura model over `Z[1/10]`, with
characteristic three as the cheap first gate, informed by the C708/C711
localization. Success replaces "an unspecified cofinite set of primes" — the one
seam a referee can poke, disclosed four times in the current manuscript — with a
theorem over an explicit base.

Each arm independently answers a different form of the objection: general order,
general field, general base. Arm 1 is the most exportable and the cheapest to
start; Arm 2 has the highest single-theorem value; Arm 3 closes the paper's own
declared open seam.

### The portfolio is where the perception is manufactured

Reading `~/src/math-papers/math-papers-summary/README.md` changes the
diagnosis. The exceptionality reading is not something a reader imposes on the
work; the public entry point actively advertises it, while the underlying
theorems point the other way.

**The portfolio title is the problem.** *Mathematical Reconstruction, Rigidity,
and Exceptional Finite Geometry.* The word `Exceptional` is in the brand. A
reader who forms the "rich chapter on one exceptional object" impression is
reading the title correctly.

**The actual quantifier ranges of the released non-Clebsch papers:**

| paper | range |
|---|---|
| stabilizer AME rigidity | every prime power `q`, every `m ≥ 2` |
| projective Reed–Solomon deep holes | every `q ≥ 7` at redundancies five to seven, explicit ranges through ten |
| arcs complete outside a conic | **every finite projective plane and every prescribed hole set** |
| MDS–CSS transversal groups | all lengths; "the all-length multiplier and group theorems are conceptual" |
| golden interferometer | all symmetric conference matrices for the exchange spectrum |

This is a portfolio of all-`q`, all-`m`, all-plane classification theorems whose
*answers* are sometimes exceptional. That is a completely different thing from a
collection of papers about exceptional objects, and it is the distinction the
packaging currently destroys.

**The lead paragraph reinforces it.** The three "concrete results" open with "a
reconstruction of the exceptional Clebsch code", then give two general ones.
Reordering so the all-`q` and all-`m` results lead, with the Clebsch
reconstruction as the worked exceptional case, costs nothing and changes the
read of the whole page.

**Two nails already exist in the corpus and are mis-shelved:**

1. *Paper I's mechanism already has a published all-planes generalization, and
   nothing says so.* Paper I proves its rigidity "using a universal chord-defect
   identity and a partial-cover bound"; *Arcs Complete Outside a Conic* proves
   "a theorem for every finite projective plane and every prescribed hole set
   `H`: the first two secant moments combine into an exact identity with a
   pointwise nonnegative remainder." That is the general parent of Paper I's
   mechanism. The README files them in different groups — "Clebsch Series"
   versus "Other papers" — so a reader never learns the connection. Cross-linking
   them is free and directly refutes the curiosity reading.

2. *`q = 11` is forced, and the theorem saying so is in a companion.* The
   computational companion's abstract states that "a Sylvester-graph obstruction
   shows that `q = 11` is the only field order admitting a conic-filling
   six-arc." That converts `q = 11` from the field the author happened to study
   into the unique field where the phenomenon can exist — by theorem. It is
   currently shelved under "exact finite computations". If the obstruction is
   structural, it belongs in Paper I's abstract; even if it stays in the
   companion, Paper I's abstract should state it. This is the single strongest
   available answer to "exceptional `q = 11` object", and it is already proved.

Paper I also already contains an all-fields statement — the window
`2k − 3 ≤ q ≤ (k(k−1)+3)/3` for any `k`-arc whose uncovered locus is a
nonsingular conic — billed as "a secondary uniform consequence". It is the kind
of result that should lead a generality-facing abstract, not trail one.

**One hygiene item.** "Order six is the unique nontrivial symmetric conference
order with cut-independent balanced exchange spectrum" is the headline of the
golden interferometer paper in the README's top-eleven list and is also
Theorem `thm:balanced-exchange-rigidity` in Paper III. Paper III has the earlier
DOI. Worth checking that the interferometer manuscript cites Paper III for it
rather than restating it as its own; a referee who notices the same theorem
headlining two papers will ask.

### How the front matter actually lands

Rendered first pages of all four released Clebsch PDFs, read visually.

**The epigraph device works exactly once.** On Paper I it sets on a single line,
italic, with the bold clause *takes shape* falling mid-line: restrained and
effective. On Paper II it wraps with an orphaned "move." alone on the second
line. On Paper III it wraps *and* the bold clause *stands fixed while its
shadows move* straddles the break, so the emphasis is split across two lines
with a one-word second line. On Paper IV it is absent entirely. A device that
degrades from elegant to broken to missing across four papers reads as
inconsistency, not as a series signature. Either fix the line breaks — the
clause is long enough that Papers II and III need a manual break or a narrower
measure — or shorten the epigraph so every paper's bold clause fits one line.

**The series header is also inconsistent.** Papers I–III carry two small-caps
lines, *The Clebsch cubic* over *Recovering, orienting, and realizing — N*.
Paper IV carries one line, *The Clebsch cubic program — IV*, and no epigraph,
and it is the only one of the four with no Mathematics Subject Classification.

**The one-object impression is created lexically, on page one, before any
mathematics.** Counting occurrences of "Clebsch" above the introduction: Paper
III has six — series header, title, and then the Clebsch chart, the diagonal
Clebsch cubic, the Clebsch four-space, and "Clebsch configuration" as the first
keyword. Paper I has five. A referee forms the impression from the first page,
and on the first page there is nothing but one classical object's name repeated.

**Paper II is the counterexample that proves the point, and it is inside the
series already.** Its title contains no "Clebsch"; its abstract is about full
`PGL₂(q)`-orbits uniformly over all odd finite fields; its keywords are entirely
general — conic ideal, secant matching, Coxeter configuration, self-associated
points, arithmetically Gorenstein, cubic inverse system, modular representation.
Only the series header carries the object's name, and the page reads as a
general classification paper whose answer happens to be two exceptional
geometries. That is the target register for the whole series, and no new
mathematics was needed to reach it.

**Keywords and MSC are free generality advertising that Paper III declines.**
Its keywords are `Clebsch configuration; Hitchin cover; icosahedral invariant;
arithmetic double cover; spherical harmonics; Gaunt invariant; symmetric
conference matrix`. Absent: two-graph, switching class, reconstruction, Seidel
matrix, principal minor. Its most exportable theorem is therefore invisible to
search. Its MSC codes are `14G25, 14J30, 20C20, 51E20` — arithmetic geometry,
algebraic geometry, group representations, finite geometry — with nothing from
`05B` (designs), `05C` (graph theory), or `05E` (algebraic combinatorics), which
is where the four-local reconstruction theorem lives and where its audience is.
Both are one-line fixes with real discoverability value.

**The epigraph itself is object-biography.** *From deep holes, the cubic takes
shape, finds its bearings, and stands fixed while its shadows move.* Every
clause is about the cubic, and it opens on Paper I's specific data. Rendered in
italic at the top of every paper, it is the "rich chapter in the theory of one
exceptional object" reading, stated as the series' own poetry. If the series is
to read as a programme about recovering structure from coarse data, the epigraph
is the one line that most directly contradicts it — and also the cheapest thing
to change, since it is unreleased text in forward versions only.

**Drift found in passing.** Paper I's released PDF abstract is ahead of the
version shown in the portfolio README: the PDF adds that the deep-hole locus is
"a recognition invariant whose metric boundary data recover the parity-check
geometry", that coset-leader ambiguity recovers "the integral quadratic order
`Z[B] ≃ Z[√5]`", and the closing sentence "Thus for each fixed `k`, the
all-field existence problem reduces to finitely many field orders." That last
sentence is the generality statement the series needs, it is already in the
released paper, and the public entry point does not show it. Regenerate the
README abstracts from the manuscript sources.

### Renaming

Released titles for Papers I–III are immutable, so a rename can only touch
forward versions, the series line, the portfolio README, and Paper V. In order
of value:

1. **Retitle the portfolio, not the series.** Drop `Exceptional` from
   *Mathematical Reconstruction, Rigidity, and Exceptional Finite Geometry*.
   This is a one-line change to a README and it is very likely the highest-value
   edit identified in this review. Inside a portfolio branded for reconstruction
   and rigidity, a series named after one object reads as a case study, which is
   both accurate and attractive; inside a portfolio branded as exceptional
   geometry, everything reads as a curiosity cabinet.

2. **Reorder and rebalance the README's lead results and standout list** so the
   all-`q`, all-`m`, all-plane theorems lead and the exceptional answers appear
   as answers to general classification questions. Several headlines already
   have the right shape — "a quadratic trade recognizes exactly two exceptional
   geometries" is a classification with an exceptional answer, which is exactly
   the framing to generalize.

3. **State the principle inside the papers.** The README already states it well
   at the portfolio level: "how much of a mathematical object can be recovered
   after most of the original information has been discarded... find an
   invariant that survives the loss of information, then prove that few
   possibilities remain." None of the manuscripts says this. Putting one
   paragraph of it in each introduction, with that paper's general results
   named, is the per-paper version of the fix.

4. **Let Paper V carry a general title.** It is unreleased, it is the paper that
   states the unifying theorem, and titling it for the phenomenon rather than
   the object retro-names the series at zero cost. Its current README
   description — "intended to bring the preceding results into a more unified
   picture" — should be replaced by the concrete statement once the architecture
   is chosen.

5. **Change the series subtitle** — *Recovering, orienting, and realizing* is
   three verbs applied to one object. This is the one item I would treat as
   optional; it is a judgment call about the value of the `Clebsch` brand, and
   dropping `Clebsch` from the series name is the move I would *not* make. The
   object is genuine, the classical name is an asset, and the perception problem
   is that the general theorems are invisible, not that the object is named.

## Open questions for the author

1. Does the Tier 1 wording upgrade have to wait for C800's manifest
   reconciliation? It touches only TeX in sections 1, 2, 4 and 5 and no formal
   surface, and the C815 corrections to section 8 already landed under the same
   conditions. If the serialization can be relaxed for prose-only changes, the
   cheap list can land now instead of behind two Lean tasks.
2. Extraction of aligned faithfulness: C862 rejects it, the cold external review
   ranks it as the most independently reusable result in the paper. Both are
   satisfiable — keep it in Paper III as the third movement, but bill it in
   principal-minor language as a standalone general theorem with its own abstract
   sentence. Extraction stays available later; a released paper can be cited by a
   follow-up note.
3. Which of the three exceptionality arms gets allocated first, and does Arm 3's
   relative-module target belong to `clebsch` or to `golden`?

## Mystery ledger

| feature | status after this pass | remaining gate or owner |
|---|---|---|
| Whether the network of shadow identifications is forced by multiplicity one | **settled as a method, not yet as a statement** | write the dimension count and name the residual content; the harmonic section already does this correctly for its own scalar |
| Whether `E ≅ Q[C]` carries content | **settled negatively for the isomorphism, positively for the compatibility** | restate Theorem I around the involution correspondence and the rank-three module |
| Whether the fibre algebra genuinely acts on the carrier | **open; currently transport through a marked bridge** | construct a relative rank-three module over an open of `P(H)`, or keep the compatibility wording |
| What the Pfaffian shadow knows at general even order | **open, and not previously asked** | Arm 1; the `n/2 = 3` observation answers a different question |
| Whether principal-minor reconstruction of Seidel matrices is known | **open audit gap** | bounded literature check in the principal-minor assignment literature before any novelty language |
| Whether characteristic three is a genuine bad prime for the paper's model | **narrowed, not settled** | read C708/C711's existing localization first; predicted outcome is that the comparison needs `Z[1/30]`, matching C682's minimal base |
| Whether the two elevens are ever conflated by readers | **untested, but cheap to prevent** | one clause in the harmonic section |

## Disposition

C862 remains open. No manuscript, Lean, release, or public-package file was
changed by this pass. The C815 manuscript corrections are confirmed applied and
its compiled-evaluation checklist item is confirmed stale. Nothing here
authorizes manuscript promotion; the cheap list is input to C816 and C824 and
the ambitious arms need separate allocation.

Vibe check: better than expected. The paper is already doing the right thing in
one section and not the others, which is the cheapest possible defect to fix,
and the generality the series is accused of lacking is mostly present and
mispackaged rather than absent.
