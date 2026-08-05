# Proposal: a safe mathematical connection between Paper IV and the Clebsch series

**Date:** 2026-08-04
**Task:** C682
**Lane:** `clebsch`
**Status:** Draft — advisory; no manuscript, Lean, or release file changed by this document

## Problem

The series is currently titled *The Clebsch cubic*, numbered I--IV with a fifth
paper planned. Paper IV, the q = 13 passant-code reconstruction, does not
contain the Clebsch cubic. The program unity review of 2026-08-03 records this
as an open obligation rather than a proved arrow: no current theorem carries
Paper IV's reconstructed `PG(2,13)` to the oriented cubic torsor, so the series
map draws that edge dashed and the numbered papers' captions are instructed to
point at identifications rather than at the unproved Rosetta theorem.

Two consequences follow. First, the series title asserts a membership for
Paper IV that the mathematics does not currently support, which constrains the
title revisit under this task: an object-anchored name inherits the gap, and a
genre-anchored name works around it without closing it. Second, and more
important, Paper IV itself reports a structural fact it does not explain. Its
main theorem states that the four minimum-word orbits are one octahedral
homogeneous space and three chord-indexed punctured conics. Why the exceptional
non-dihedral marking is octahedral is left as a census observation.

Those two problems have one answer.

## Context

### What Paper IV actually proves

From `papers/q13-passant-code/passant_code_q13.tex`, Theorem `thm:main` at
lines 102--108:

> The code `K` has parameters `[78,36,12]_2` and exactly `364` minimum words.
> Under `PGL(2,13)`, those words form four orbits of size `91`. One is an
> octahedral homogeneous space with stabilizer `S_4`; the other three are
> chord-indexed punctured conics with stabilizer `D_24`. Every orbit spans `K`.

The construction of the octahedral family is at lines 436--448: take the
octahedral subgroup `O` isomorphic to `S_4` whose conic-point orbits have sizes
six and eight, select the internal-point suborbit of size twelve cut out by the
stated matching profile, and observe `Stab_G(X_O) = O`. The counting remark that
closes that subsection is exact: all four stabilizers have order twenty-four, so
each family has `2184/24 = 91 = binom(14,2)` supports.

The manuscript never uses the words *icosahedral*, *golden*, or `sqrt 5`. Its
only mentions of *Clebsch* are the series banner, a back-reference to Paper I,
and the closing positioning paragraph. So the connection proposed below is new
content for that paper, not a restatement.

### The arithmetic that governs which markings exist

The stabilizer of a nonsingular conic in `PG(2,q)` is `PGL(2,q)` acting on the
conic as the projective line, so the distinguished markings of a conic are
orbits of the finite subgroups of `PGL(2,q)`: cyclic, dihedral, tetrahedral,
octahedral, icosahedral. Availability is a congruence condition on q.

- `S_4` embeds in `PGL(2,q)` for every odd q. The octahedral marking is always
  present.
- `A_5` embeds in `PSL(2,q)` exactly when 5 is a square in `F_q`, equivalently
  `q ≡ ±1 (mod 5)`. The icosahedral marking exists only on the golden branch.

At eleven, `11 ≡ 1 (mod 5)`, the icosahedral marking exists and `sqrt 5` is
rational. That is the Clebsch hexagon, the golden orientation torsor, and the
operator with `B^2 = 5I` of Papers I and III. At seven the octahedral subgroup
already lies inside `PSL(2,7)`, and Paper II's classification returns exactly
the octahedral `B_3/F_7` and icosahedral `H_3/F_11` orbits as the only carriers
of the two-valued strength-two trade.

At thirteen the squares are `{1,3,4,9,10,12}`. Five is not among them, so `phi`
lives in `F_169` and not in `F_13`, `13 ≡ 3 (mod 5)`, and `PGL(2,13)` contains
no icosahedral subgroup at all. `|PGL(2,13)| = 2184 = 2^3 · 3 · 7 · 13` is not
divisible by 60, which settles it by order alone without invoking the
congruence classification.

So at thirteen the only Platonic marking above the dihedral and tetrahedral
floor is the octahedral one. Paper IV's exceptional family could not have been
anything else.

### Prior proposals

The 2026-08-03 unity review, the C862 ceiling-upgrade research note, and the
C862 independent review all treat Paper IV's series membership as a framing
question and none of them proposes a mathematical bridge. This is not a
duplicate.

---

## Approach A: state the arithmetic branch, in Paper IV and in the series framing

### Architecture

Add one short remark to Paper IV, after the octahedral family's construction or
in the closing positioning subsection, of roughly this shape.

> **Remark (why the exceptional family is octahedral).** The conic stabilizer
> is `PGL(2,13)`, acting on the conic as `PG(1,13)`, so every marking of the
> conic by a Platonic configuration is an orbit of a finite subgroup of that
> group. The octahedral subgroup `S_4` embeds in `PGL(2,q)` for every odd q,
> whereas the icosahedral subgroup `A_5` embeds only when 5 is a square in
> `F_q`. Since `5` is a nonresidue mod 13 — equivalently `60` does not divide
> `|PGL(2,13)| = 2184` — no icosahedral marking exists at thirteen. The
> octahedral family of Theorem `thm:main` is therefore the only exceptional
> non-dihedral marking the field admits, and its icosahedral counterpart,
> which is the carrier of the golden structure at `q = 11` in Papers I--III of
> this series, is arithmetically absent here.

The series framing then gains a clause it can prove: Papers I, II, and III live
on the branch where 5 is a square and the golden marking exists; Paper IV is
the reconstruction theorem on the complementary branch, where that gate is shut
and the octahedral marking is what remains in the minimum-weight layer.

### Trade-offs

**Strengths:**

- It converts a reported census fact into a forced structural one. The reader
  currently has no reason why one family is octahedral; afterwards it is the
  only possibility.
- The mathematics is classical, citable, and checkable in a line. Dickson's
  classification of the subgroups of `PSL(2,q)` is the standard reference; the
  order argument `60 ∤ 2184` needs no reference at all.
- It asserts nothing about the oriented cubic torsor, so it does not touch the
  dashed edge or pre-empt the Rosetta theorem. Nothing here becomes a debt for
  Paper V.
- It connects Paper IV to the exact arithmetic seam — the square class `[5]` —
  that Paper III spends its arithmetic section descending, and to Paper II's
  octahedral/icosahedral dichotomy, rather than to the cubic.
- It costs one remark and no new theorem, so it fits inside a prose-only edit
  batch of the kind C862 already authorized.

**Weaknesses:**

- It is an explanation of an absence. A referee could call it a soft
  observation rather than a result. The defence is that it is the same absence
  the rest of the series is organized around, and that it explains a feature of
  the paper's own main theorem.
- It slightly enlarges Paper IV's citation surface, since the subgroup
  classification is new to that manuscript.
- Whether the remark belongs in the introduction, next to the construction, or
  in the closing positioning subsection is a placement judgement that interacts
  with C761 packaging.

---

## Approach B: the weight-spectrum duality, as framing only

### Architecture

State, in the series front matter and the portfolio README rather than inside
Paper IV's mathematics, the exact opposition between Papers I and IV.

Paper I reconstructs a marked conic plane from the deep holes — the words
farthest from every codeword, the top of the metric. Paper IV reconstructs a
marked conic plane from the minimum-weight words — the lightest nonzero words,
the bottom of the metric. Same class of conclusion, opposite ends of the weight
spectrum, different fields, no shared mechanism required.

### Trade-offs

**Strengths:**

- Free. No new mathematics, no new citations, no manuscript theorem touched.
- Sharper than the existing "fourth instance of the recognition genre"
  language, because it names the specific opposition instead of a shared genre.
- Immune to the Paper V architecture question. Nothing about it depends on
  which of the four single-punch options lands.

**Weaknesses:**

- It strengthens the packaging, not the paper. A reader of Paper IV alone gains
  nothing.
- Taken alone it leaves the octahedral fact unexplained, which is the more
  valuable of the two gaps.

---

## Approach C: leave Paper IV outside and retitle around it

### Architecture

Change nothing mathematically. Adopt a genre-anchored series name so that the
title stops asserting cubic membership for Paper IV, and rely on the series map
captions, which already assert only proved or citable arrows, to carry the
boundary.

### Trade-offs

**Strengths:**

- Zero risk and zero work beyond the retitle that C682 is already considering.
- Correctly refuses to manufacture a connection.

**Weaknesses:**

- The dashed edge stays dashed and the octahedral fact stays unexplained, when
  both are cheap to improve.
- It treats a mathematical gap as a naming problem, which the unity review's
  own diagnosis argues against.

---

## Approach comparison

| Criterion                        | A: arithmetic branch                     | B: weight-spectrum duality        | C: retitle only                  |
|----------------------------------|------------------------------------------|-----------------------------------|----------------------------------|
| New mathematics required         | none; classical subgroup facts           | none                              | none                             |
| Strengthens Paper IV itself      | yes — explains its own main theorem      | no                                | no                               |
| Strengthens series coherence     | yes, on the arithmetic seam              | yes, on the recognition genre     | no                               |
| Touches the dashed cubic edge    | no                                       | no                                | no                               |
| Creates a debt for Paper V       | no                                       | no                                | no                               |
| Manuscript disruption            | one remark plus one citation             | front matter and README only      | banner only                      |
| Referee risk                     | low; could be called soft                | none                              | none                             |

---

## Open questions

1. **Placement in Paper IV.** Construction site, introduction, or the closing
   positioning subsection. The construction site is where the reader first
   meets the octahedral subgroup and is the recommended default.
2. **Ownership.** The remark is Paper IV content, so it sits with C761
   packaging rather than with C816, which owns Paper III promotion. C682 owns
   the title decision only. Whether this needs its own C-ID or rides an
   existing Paper IV pass is a routing call for the user.
3. **Citation choice.** Dickson's subgroup classification is the standard
   reference, but the order argument alone suffices and may be preferable
   precisely because it needs no citation.
4. **Whether the three `D_24` families admit a parallel statement.** All four
   minimum-word stabilizers have order twenty-four, one octahedral and three
   dihedral. Whether that coincidence of orders has a reason, or is specific to
   thirteen, is not settled here and is not needed for the proposal.
5. **Title interaction.** If the arithmetic-branch remark lands, an
   object-anchored series title is less wrong than it is today, but still
   asserts more than Paper IV proves. The genre-anchored options remain
   preferable on their own merits.

## Recommendation

**Approach A, with Approach B applied alongside it.** They are complementary
rather than competing: A repairs the paper, B repairs the packaging, and
together they cost one remark and a few sentences of front matter.

Justification:

1. Approach A explains a feature of Paper IV's own main theorem. Of everything
   available, that is the only item that makes the paper mathematically better
   rather than better positioned.
2. It joins Paper IV to the series through the square class `[5]` — the seam
   Paper III descends and the dichotomy Paper II classifies — instead of
   through the oriented cubic, so it stays entirely clear of the obligation the
   unity review deliberately left open.
3. The supporting facts are verified. Paper IV's own theorem gives the four
   orbits of size ninety-one with stabilizers `S_4` and `D_24`; five is a
   nonresidue mod thirteen; and sixty does not divide `2184`. Nothing here rests
   on an unchecked claim.
4. Approach C is not wrong, only insufficient. Adopting A and B does not
   foreclose the genre-anchored retitle, which this document still recommends
   on independent grounds.

Explicitly excluded: the six-class elliptic association scheme must not be
linked to the program's six axes. Those six classes come from the orbit
structure of `PGL(2,13)` on pairs of internal points and the six axes come from
the icosahedral frame; the numerical echo has no content. The `F_8` operator
field is a more interesting lead, since seven divides `2184`, but no route from
it to the golden structure is visible and it should stay an internal note.

### Implementation phases

1. **Phase 1 — the remark.** Draft the octahedral-branch remark against the
   construction subsection of `passant_code_q13.tex`, decide the citation
   question, and confirm with the lane that Paper IV edits are in scope for
   whichever task carries them. This is the minimum that validates the
   proposal: if the remark does not read as a genuine explanation in place, the
   rest is unaffected.
2. **Phase 2 — the framing.** Add the deep-hole versus minimum-word opposition
   to the series front matter and to the portfolio README's Paper IV entry,
   which the C862 batch is already regenerating.
3. **Phase 3 — the series map.** Relabel Paper IV's node caption to name the
   arithmetic branch. The edge stays dashed; only the caption gains content.
4. **Phase 4 — the title.** Settle C682 on a genre-anchored name, now with the
   Paper IV membership resting on a stated arithmetic relationship rather than
   on genre resemblance alone.
