# C956 editorial spine and framing

**Owner:** C956 (`cubic-threefolds`)

This is the authoritative editorial plan for the replacement manuscript in
this directory.  C925 remains the research record; a fresh manuscript session
starts from the C956 task card and this document, not from C925's history.

This document controls the paper's argument and emphasis. The detailed result
ranking is in `results-inventory.md`.

## One-sentence result

There are explicit smooth cubic threefolds `X/Q` for which `X × P¹` is
irrational but `X × P²` is rational; hence the least stabilizing dimension is
exactly two over both `Q` and `C`.

## Mathematical framing

The paper begins from a rationality question, not from a technical
improvement to another paper.

- The one-stabilization theorem says that `X_C × P¹` is irrational for every
  smooth complex cubic threefold.
- Special smooth cubic threefolds are now known to be stably rational.
- The present theorem locates the transition for two explicit examples:

  `X_C × P¹` is irrational, but `X × P²` is rational over `Q`.

Thus the first possible rational stabilization actually occurs. The answer is
neither stable irrationality nor an unspecified eventual rationality result;
it is the exact value two.

Three complementary facts make this more than an isolated computation.

1. The same proof works for every member of both Tschinkel–Zhang cubic
   families, in every dimension in which they are defined.
2. The underlying surface theorem gives rationality after adjoining two
   variables under a standard Picard-lattice hypothesis.
3. Passing from `X` to `Y=X × P¹` produces a smooth projective nonrational
   fourfold for which `Y × A¹` is rational, answering the explicit
   construction problem recorded in their paper.

The memorable formula is

```text
X × P¹  irrational     |     X × P²  rational.
```

The conceptual explanation is a rational quotient of the projective Cox
model by a saturated rank-three torus.

## Intended mathematical legacy

The paper should support the following three descriptions without
qualification being supplied only in fine print.

1. **It determines the first rational stabilization of explicit stably
   rational smooth cubic threefolds.** For the two displayed threefolds, one
   projective variable does not suffice and two do. This is not a
   classification of stable rationality for every smooth cubic threefold:
   very general cubics are not stably rational.
2. **It recovers and sharpens the Tschinkel–Zhang stable-rationality
   conclusions.** The surface theorem implies their Corollary 4.3 under the
   same hypotheses, and the family theorem implies their Theorem 1.3 with
   the quantitative bound `P²`.
3. **Its mechanism is more general than the application.** The
   unimodular-window quotient criterion concerns projective torus actions on
   varieties with birational generic tangent projection. It is not specific
   to quartic del Pezzo surfaces or cubic hypersurfaces.

This is not presented as an extension of Tschinkel–Zhang. The organizing
results are the standalone quotient criterion, surface theorem, and exact
cubic threshold. Their universal-torsor rationality theorem, Cox/OADP
construction, Galois classification, and explicit fibrations are cited as
independent geometric inputs at the points where they are used.

## Alternate framing options

### Option A — exact cubic threshold (recommended)

**Preferred title:** *Explicit Cubic Threefolds Rational after Two
Stabilizations*

**Shorter alternative:** *Cubic Threefolds Rational after Two
Stabilizations*. The adjective “explicit” is preferable because the theorem
does not concern every smooth cubic threefold.

**Opening claim:** explicit smooth cubic threefolds have least stabilizing
dimension two.

**Advantages**

- Directly answers the motivating cubic-threefold question.
- Makes the `m=1` and Tschinkel–Zhang results collide in one sharp theorem.
- The statement is understood before any Cox-ring or torus terminology.
- It naturally accommodates the fourfold consequence and the moduli contrast.

**Risk**

- The strongest general theorem is not in the title. Counter this by stating
  it as Theorem B on page 2 and by saying in the abstract that it recovers the
  Tschinkel–Zhang stable-rationality conclusions quantitatively.

**Verdict:** best balance of memorability, mathematical importance, and the
user's intended focus.

### Option B — affine-line stabilization of a nonrational fourfold

**Possible title:** *A Nonrational Projective Fourfold Rational after
Affine-Line Stabilization*

**Opening claim:** an explicit `Y/Q` is nonrational but `Y × A¹` is rational.

**Advantages**

- Strongest standalone surprise.
- Directly answers the construction problem stated by Tschinkel–Zhang.
- Broadest audience outside cubic-threefold specialists.

**Risks**

- Hides that `Y` is simply the boundary immediately before a cubic
  threefold's first rational stabilization.
- Makes the paper sound primarily about cancellation and invites confusion
  with Zariski cancellation.
- Demotes the new rationality theorem to a mechanism for a corollary.

**Verdict:** use as the second theorem and as abstract/introductory leverage,
not as the title.

### Option C — quantitative quartic-del-Pezzo theorem

**Possible title:** *Two-Variable Rationality of Quartic del Pezzo Surfaces*

**Opening claim:** the rational-point and stably-permutation hypotheses imply
`S × A²` rational.

**Advantages**

- Formally the strongest and most general theorem.
- Makes the relation to Tschinkel–Zhang Corollary 4.3 exceptionally clean.
- Natural for arithmetic-geometry readers.

**Risks**

- Conceals the exact cubic threshold, which is the result readers will quote.
- Sounds like a quantitative refinement of a surface theorem rather than a
  resolution of the first rational stabilization of new cubic threefolds.

**Verdict:** make it Theorem B and the engine of the paper.

### Option D — the quotient mechanism

**Possible title:** *Rational Torus Quotients from Tangent Projection*

**Opening claim:** a unimodular weight window gives a rational Rosenlicht
quotient of an OADP variety.

**Advantages**

- Most reusable theorem and cleanest conceptual method.
- Could attract readers working on Cox rings, torsors, and torus actions.

**Risks**

- The general statement has only one developed application in the paper.
- It suppresses both the cubic threshold and the contemporary
  Tschinkel–Zhang consequence.

**Verdict:** feature as the principal technical theorem, not the title.

### Option E — source-centered framing

**Possible title:** *The Rationality Level of the Tschinkel–Zhang Cubic
Threefolds*

**Opening claim:** their newly stably rational cubics have exact level two.

**Advantages**

- Maximizes immediacy and makes the relation to their paper unmistakable.
- Signals the strongest priority-judo point honestly.

**Risks**

- Makes the work appear derivative even though the surface and quotient
  theorems are general.
- A person's name in the title dates the result and narrows the perceived
  scope.

**Verdict:** reject. Use their names in citations and in a short comparison
paragraph, not in the title, principal theorem captions, or section
architecture.

## Recommended hybrid

Use Option A as the title and narrative, Option C as Theorem B, Option D as
the proof mechanism, and Option B as the first corollary. This produces a
simple hierarchy:

```text
Theorem A: exact cubic threshold 2
    |
    +-- Corollary: nonrational fourfold rational after A¹
    +-- Corollary: value 2 at explicit moduli points, infinity very generally

Theorem B: quartic del Pezzo × A² is rational
    |
    +-- recovers TZ Corollary 4.3 quantitatively
    +-- gives both TZ cubic families × P² rational
    +-- recovers TZ's cubic stable-rationality existence theorem

Technical theorem: unimodular-window torus quotient is rational
    |
    +-- proves Theorem B from the TZ Cox/OADP inputs
```

The abstract should devote roughly equal space to the exact cubic threshold
and the general surface theorem. The fourfold is one final sentence. The
technical certificate gets no coefficients in the abstract.

The title must not suggest a universal theorem for smooth cubic threefolds.
The preferred title therefore includes “Explicit”; the first sentence of the
abstract names the two examples and the first theorem displays their
equations.

## Introduction pitch in five paragraphs

1. Ask for the least `m` for a stably rational but nonrational smooth cubic
   threefold. Recall the universal `m=1` irrationality theorem and the recent
   existence of such cubic threefolds only as the context making the question
   concrete.
2. Display the two cubic equations and state the exact answer `m=2`.
3. State the affine-line fourfold consequence and distinguish it from
   isomorphism cancellation.
4. State the general quartic-del-Pezzo theorem. In a separate relation-to-the-
   literature paragraph, explain precisely which recent conclusions it
   recovers and which geometric results it uses.
5. Give the proof idea: saturated rank-three torus, Galois-stable four-block
   window, one-point tangent slice, rational quotient, residual rank-two
   torus. End with the section roadmap.

This ordering establishes the main result and its logical context before
asking the reader to learn the mechanism.

## Claim hierarchy

1. **Theorem A — cubic threefolds.** For the two displayed cubic threefolds,
   `ell_Q(X) = ell_C(X_C) = 2`.
2. **Theorem B — reusable surface theorem.** If `S/k` is a smooth quartic
   del Pezzo surface, `char(k)=0`, `S(k)` is nonempty, and `Pic(S_bar)` is a
   stably permutation Galois module, then `S × A²` is `k`-rational.
3. **Family consequence.** Every member of both displayed cubic families
   becomes rational after multiplication by `P²`.
4. **Fourfold consequence.** For `Y=X × P¹`, the smooth projective fourfold
   `Y` remains nonrational over `C`, while `Y × A¹` is rational over `Q`.
5. **Moduli contrast.** The value is two at the explicit cubic points and
   infinite at a very general complex cubic threefold.

6. **Quantitative recovery of the source results.** The surface theorem
   implies the stable-rationality conclusion of Tschinkel–Zhang Corollary 4.3,
   and the all-dimensional family theorem implies their headline existence
   theorem for stably rational smooth cubic hypersurfaces.

The cubic theorem is the headline. The surface theorem is the mechanism. The
fourfold statement is a memorable reformulation, not the organizing subject.

## Proof spine

```text
Tschinkel–Zhang quartic-del-Pezzo Cox model
        |
        v
saturated rank-3 projective subtorus T3
  + Galois-stable set of four weight blocks
  + unimodular weight differences
        |
        v
codimension-3 tangent section meets a general T3-orbit once
        |
        v
Z/T3 is rational by generic tangent projection
        |
        v
Z/T3 ~ S × (T0/T3), with T0/T3 a rational rank-2 torus
        |
        v
S × A² is rational
        |
        v
generic-fibre function-field argument for the two cubic families
        |
        v
X × P² is rational
        |
        +-- prior m=1 theorem: X_C × P¹ is irrational
        |
        v
ell_Q(X)=ell_C(X_C)=2
```

## Dependency audit

| Statement | Internal inputs | External inputs | Must not be used |
|---|---|---|---|
| rational torus quotient criterion | signed maximal minors, uniqueness of the orbit intersection, inverse tangent projection | none beyond standard Rosenlicht quotient language | any Tschinkel–Zhang rationality conclusion |
| descended tangent section for the four types | quotient criterion, saturated rank-three lattice, four-witness exact cover, incidence descent | Tschinkel–Zhang Cox equations, OADP property, density lemma, and four-type subgroup description | descent of an individual split-coordinate witness |
| `S × A²` rational | rational quotient, equivariant generic trivialization, nonminimal contraction | Tschinkel–Zhang generic splitting and type classification; Voskresenskii on rank-two tori; high-degree del Pezzo rationality | Tschinkel–Zhang Corollary 4.3 as a stable-rationality input |
| both cubic families × `P²` rational | surface theorem, function-field bookkeeping | Tschinkel–Zhang Propositions 5.1–5.2 for the fibrations, smoothness, and Galois types | specialization from the generic fibre |
| exact cubic level two | family theorem at `r=0` | independent one-stabilization irrationality theorem | any all-cubic `m=2` statement |
| fourfold × `A¹` rational | exact cubic theorem and equality of two-variable function fields | none | Zariski cancellation terminology |
| moduli contrast | exact cubic theorem | Engel–de Gaay Fortman–Schreieder on very general cubic threefolds | deformation invariance of stable rationality |

### Non-circular recovery of the Tschinkel–Zhang conclusions

The surface proof uses their geometric and group-theoretic ingredients but
does not invoke their Corollary 4.3. Therefore the stronger conclusion
`S × A²` rational legitimately implies the stable-rationality conclusion of
that corollary. Likewise, the cubic-family proof takes their explicit smooth
fibrations and generic-fibre descriptions as input, but does not invoke their
final stable-rationality theorem. Rationality after `P²` therefore recovers
that theorem's existence conclusion.

This distinction must be stated wherever the paper says that a
Tschinkel–Zhang result follows as a corollary.

The exact source chain is:

- Tschinkel–Zhang Proposition 4.1 classifies the minimal quartic del Pezzo
  surfaces satisfying condition `(H1)` into four Galois types;
- their Lemma 4.2 proves that `(H1)` is equivalent to the geometric Picard
  lattice being stably permutation;
- their Corollary 4.3 concludes stable rationality under the rational-point
  hypothesis;
- the present surface theorem assumes the same rational-point and
  stably-permutation conditions and concludes the stronger rationality of
  `S × A²`.

For the cubic application, Tschinkel–Zhang Propositions 5.1 and 5.2 supply
the smooth equations, fibrations, and type computations. The present
function-field argument replaces their final use of Corollary 4.3 by the
two-variable surface theorem.

### Equation transcription gate

The second Tschinkel–Zhang family must be copied exactly from Proposition
5.2. Its cubic tail is

`x_3^3 - x_3 x_4^2 + x_4^3`,

not `x_3^3 - x_3^2 x_4 + x_4^3`. The current draft contains the latter
incorrect transcription and must be repaired before the next build. The
first family agrees with Proposition 5.1.

## Layered exposition

- **Page 1:** state the explicit cubic equations, Theorem A, and the
  affine-line fourfold corollary. State Theorem B immediately afterward as
  the engine.
- **Conceptual layer:** begin each major proof with a short roadmap. Keep the
  quotient construction, descent, torsor splitting, residual-torus argument,
  and function-field passage in the main text.
- **Computational layer:** state exactly what the four witnesses certify and
  why four witnesses cover the smooth moduli chart. Put the large determinant
  polynomials, Gröbner branches, and Bézout identity in a certificate appendix.
- **Reproducibility layer:** retain the machine-readable exact certificate and
  replay checker. State plainly which arguments are not checked by code and
  that the new theorem has no Lean formalization.

## Relation to Tschinkel–Zhang

The paper is not organized as an extension of Tschinkel–Zhang. Its general
quotient criterion is stated and proved independently, its surface theorem is
the main geometric application, and the exact cubic threshold is the
headline. The relation to their work is an input/consequence comparison:

- the paper's surface theorem has the same rational-point and
  stably-permutation hypotheses as their Corollary 4.3 and has the stronger
  conclusion `S × A²` rational; their stable-rationality conclusion is
  therefore a corollary;
- their general quartic-del-Pezzo bound drops from eleven variables to two;
- their cubic families become rational after two stabilizations, so their
  headline existence theorem for stably rational smooth cubic hypersurfaces
  follows from the stronger family statement;
- for the cubic threefold members, the independent one-stabilization
  irrationality theorem makes the level exactly two.

The proof imports their OADP Cox geometry, tangent-projection theorem,
Galois-type classification, and explicit generic-fibre construction. It does
not import their stable-rationality conclusions when deriving the two stronger
statements above. Present these as cited geometric inputs, not as the paper's
organizing framework. Do not make a global firstness claim. State the
input-versus-consequence boundary with pinpoint citations.

### Attribution standard

- Never write that the Tschinkel–Zhang paper is subsumed.
- Write that the **conclusion of Corollary 4.3** follows from their Lemma 4.2,
  Manin's necessary condition, and the stronger surface theorem here.
- Write that the **stable-rationality conclusions of Propositions 5.1–5.2
  and Theorem 1.3** follow with a two-variable bound once their explicit
  fibrations and Galois-type computations are taken as input.
- State that their Theorem 1.1/3.4 on rational universal torsors is not
  recovered and has separate arithmetic scope.
- Attribute their Cox equations, OADP lemma, tangent-projection theorem,
  density lemma, four-type classification, and generic-fibre constructions
  at the first point each is used.
- Describe eleven and two as outputs of different constructions. Do not
  characterize their eleven-variable resolution as an error or deficiency.

## Terminology and notation

- Use **least stabilizing dimension** in prose and `ell_k(X)` in formulas.
- Attribute **levels of stable rationality** to Tschinkel–Zhang when used.
- Use **projectively linear torus action**, **Rosenlicht quotient**,
  **universal torsor**, **Néron–Severi torus**, and **stably permutation
  Galois module** in their standard senses.
- The four selected Cox weight blocks form a **Galois-stable set**; they are
  permuted and are not individually Galois stable.
- Projective weights are defined up to common translation. Only weight
  differences enter the quotient construction.
- Say **rational after affine-line stabilization**. Do not call the fourfold
  consequence a counterexample to Zariski cancellation.

## Proof-review requirements

- State the domain of every rational map and the open conditions used.
- For the quotient criterion, show existence and uniqueness of the orbit
  correction and write both composites of the birational parametrization.
- Explain Galois descent through uniqueness, not through a chosen split
  coordinate witness.
- Separate the affine universal torsor, its projectivization, and the scalar
  quotient explicitly.
- In the generic-fibre argument, write the function fields and count all
  transcendence variables.
- Explain why rationality over `Q` survives base change and why irrationality
  over `C` implies irrationality over `Q`.
- Distinguish imported geometric theorems from exact calculations and from
  prose-only deductions.

## Statements to avoid

- No claim about every smooth cubic threefold becoming rational after two
  stabilizations.
- No claim about arbitrary stabilization or stable irrationality.
- No survival or transport claim from the abandoned quantum argument.
- No claim that the four weight blocks are individually Galois stable.
- No claim that the exact coefficients alone prove Galois descent.
- No claim that the affine-line fourfold is an isomorphism-cancellation
  counterexample.
- No invented DOI, publication date, version, peer-review status, or priority
  assertion.

## Final impression

The reader should leave with the sharp threshold

`X × P¹ irrational; X × P² rational`,

and with a reusable geometric reason: a saturated rank-three torus quotient
of the projective Cox model reduces stable rationality of the quartic del
Pezzo fibre to a rational two-dimensional torus.

The reader should also understand the exact division of credit: the paper
uses Tschinkel–Zhang's geometric construction to prove stronger quantitative
conclusions from it; it neither reproves nor supersedes their universal-torsor
geometry.
