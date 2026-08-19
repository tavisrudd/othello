# C919 governing specification — author implementation packet

**Lane:** `clebsch` · **Received:** 2026-08-18 · Verbatim copy of
`/tmp/persistent/tavis/clebsch_rebranding_opus_instructions.md`, preserved here
because the original lives outside the repository. Source SHA-256
`bac7791a03189ac5e275b8045c8e4851f98cfd321de70cac5a2f65edf0732eb8`. Do not edit; corrections come
from the author as a new packet.

---

# Implementation packet: de-brand the paper fronts, move the Clebsch programme to a post-conclusion coda

You have already inspected these five papers and previously analyzed the page-2 **“Reconstruction perspective”** interludes. Continue from that work rather than treating this as a fresh rewrite.

The series/programme is:

> **Clebsch: Rigidity from Sparse Shadows**

The five papers are **logically independent but thematically connected**. The current presentation overstates the series structure on the first pages and in the introductions. The goal is to let each paper present itself first as an independent research article, then place the series/programme connective tissue in a visually distinctive coda after the paper’s mathematical conclusion.

Do **not** change mathematical claims, theorem statements, proofs, notation, bibliography content, or substantive technical exposition except where material is explicitly being moved or a redundant sentence is explicitly being cut.

---

## 1. First-page debranding

Apply to Papers I–V.

### Remove from page 1

- Remove the banner of the form:
  - `CLEBSCH: RIGIDITY FROM SPARSE SHADOWS — I`
  - etc.
- Remove the Roman-series number from the title-page identity.
- Remove the current series epigraph from page 1.
- Do not replace these with a smaller series banner, subtitle, running-head series label, or equivalent front-page branding.

### Keep

- The standalone paper title.
- Author.
- Date/version information.
- Abstract.
- Normal article metadata already present.

The first page should read as the first page of an independent paper.

If the series name is currently baked into PDF metadata or `\title{...}`, remove it there as well unless doing so would accidentally alter repository-level metadata outside these five papers.

---

## 2. Move the series connective tissue into a post-conclusion coda

Each paper should acquire an unnumbered post-conclusion programme section.

Preferred heading:

```latex
\section*{Clebsch: Rigidity from Sparse Shadows}
```

Use the existing typography conventions of the papers if an equivalent unnumbered-heading mechanism is already defined.

This coda should appear **after the paper’s actual mathematical conclusion** and before the bibliography. If a paper has technical appendices whose placement makes that awkward, preserve the mathematical reading order and place the coda at the end of the substantive article body, before references. Do not put programme material back into the introduction merely to simplify layout.

The coda should contain, in this order:

1. the five-line programme poem;
2. the programme map;
3. concise explanatory prose placing the current paper in the programme and stating the logical-independence point;
4. any other series-level material moved out of the old “Reconstruction perspective” interlude.

The poem and map should appear adjacent, with no long prose block between them. The intended visual experience is:

**poetic five-line map → geometric programme map → explanatory prose**

---

## 3. Final programme poem

Use this wording exactly unless a purely typographic change is required:

> From deep holes, a form arises;  
> beneath it, paired chords find their bearing;  
> through changing guises, the golden source persists;  
> from bare words, a plane rises;  
> beneath one form, two shadows, a hidden twist between.

Do not restore the older wording (“a cubic takes shape,” “its companion,” “the carrier stands fixed,” “the scattered shadows gather home,” etc.).

The last line is deliberately written to encode the Paper-V situation without suggesting that the two shadows literally merge: one underlying form/carrier, two distinct shadows, residual twofold ambiguity.

---

## 4. Make the poem ↔ paper correspondence visually explicit

The five lines correspond to Papers I–V in order.

Present the poem as **five actual lines**, not a wrapped paragraph.

Add small/light Roman numerals in the left margin or as a restrained leading column:

```text
I    From deep holes, a form arises;
II   beneath it, paired chords find their bearing;
III  through changing guises, the golden source persists;
IV   from bare words, a plane rises;
V    beneath one form, two shadows, a hidden twist between.
```

The numerals should be subordinate to the poem: smaller and/or lighter than the main text, not large section labels.

### Per-paper emphasis

In each paper:

- emphasize the **entire line corresponding to that paper**;
- emphasize the **corresponding box in the programme map**.

For example:

- Paper I: line I + box I.
- Paper II: line II + box II.
- ...
- Paper V: line V + box V.

Prefer one restrained emphasis mechanism consistently across all five papers. Existing map-box shading is a good model. For the poem, bold/semibold or equivalent is acceptable if it does not look heavy. Do **not** go back to bolding isolated phrases inside every line; the full-line/paper correspondence is now the visual device.

The poem should still read naturally as a poem when the emphasis is ignored.

---

## 5. Programme map: preserve the architecture, make these tweaks

Use the existing map as the basis. Do not redesign it into a new infographic.

### A. Rename it

Change caption language from **“Series map”** to **“Programme map.”**

This is important: the map records relations among independent papers, not a proof-dependency chain.

### B. Preserve the current-paper highlighting

Use the current paper’s box as the shaded/emphasized box in each PDF, as already happens in at least the current Paper-I and Paper-V versions.

Keep the highlighting style consistent across all five papers.

### C. Make the I–III cluster and IV branch read structurally

Increase the vertical whitespace between Paper III and Paper IV enough that:

- I–III read as the upper cluster feeding the Paper-V correspondence;
- IV reads as the independent lower branch.

Do this with whitespace/layout, not with extra enclosing boxes or decorative cluster labels unless absolutely necessary.

### D. V is the hinge

The topology should make Paper V read as the hinge/correspondence node.

Its box can retain a slightly stronger border than ordinary unhighlighted boxes if the current TikZ/diagram code makes this easy and visually clean. Do not over-style it.

### E. Distinguish the duplicate I / III box labels

The current map uses **“conference companion”** for both I and III. That makes them look duplicated.

Inspect the actual Paper-I and Paper-III terminology and replace these with short, established paper-specific labels that distinguish their roles **without inventing new mathematical terminology**.

Good fallback candidates, if they are faithful to wording already used in the papers, are along the lines of:

- I: `deep-hole conference companion`
- III: `golden conference companion`

But prefer terminology already present in the abstracts/intros over these suggestions.

Keep labels short enough that the map remains sparse.

### F. Captions

The caption should explain arrow semantics, not narrate paper order.

A standardized form close to the existing caption is fine, e.g. conceptually:

> **Programme map.** Upper double arrows record the marked transports and returns proved in Paper V; the right arrow is its common-carrier theorem. The lower solid arrow is Paper IV’s independent reconstruction.

Adapt the last target phrase to the actual target shown in that paper’s current diagram (`marked conic plane and polarity`, `... and an F_8-orbit`, etc.) only if the diagrams legitimately differ. Do not silently homogenize distinct mathematical targets.

Add one concise sentence in the nearby prose, not necessarily the caption:

> The five papers are logically independent; the map records reconstruction correspondences and thematic relations, not proof dependencies.

Use equivalent house style if this sentence already exists in stronger form elsewhere.

---

## 6. Handle the old “Reconstruction perspective” interludes sentence by sentence

Do **not** simply delete the interludes wholesale.

Use the test from our previous pass:

> **Does the sentence describe this paper’s mathematics, or where this paper sits?**

Then:

- **local mathematics / local motivation / local roadmap** → merge into the ordinary introduction;
- **series placement / cross-paper comparison / programme map explanation** → move to the post-conclusion coda;
- **duplicate of immediately preceding introduction prose** → cut;
- strip the label **“Reconstruction perspective.”** once its contents have been redistributed.

Preserve the strongest local prose. The point is to remove the interlude as a *series-placement device*, not to throw away useful exposition.

### Specific decisions already identified in the previous analysis

Treat these as requirements unless current source has materially changed:

#### Paper IV

The exact-arity sentence is one of the strongest lines in the opening and is currently stranded in the interlude:

> “unary data are constant while weighted pair data recover the marked conic plane and polarity, so the exact arity is two”

Move this into the ordinary introduction in the most natural local position. Do not relegate it to the programme coda.

#### Paper III

The existing **three-question roadmap** is genuinely local to Paper III.

Keep it in the introduction, but remove the “Reconstruction perspective” wrapper/label and integrate it into the ordinary introductory flow.

#### Papers I and II

Each currently has one sentence in the interlude that merely restates the paragraph immediately above it.

Cut those redundant sentences rather than moving them.

Do not preserve duplication merely because the old interlude is being relocated.

#### Paper V

Most of its current “Reconstruction perspective” material is series placement / cross-paper synthesis.

Move that material to the coda, after Paper V has first concluded its own theorem as a standalone result.

Paper V’s ordinary conclusion should first summarize **Paper V itself**. The cross-paper “scattered shadows” / information-loss synthesis then belongs in the new programme coda.

---

## 7. Paper V: separate standalone conclusion from programme wrap

Paper V is special because it is the natural series wrap, but it must still read as an independent paper.

Its structure should become:

1. **Conclusion** — conclude Paper V’s own results:
   - marked correspondence;
   - exact information loss;
   - nonidentification of the two invariant cubic lines;
   - residual ambiguity / sharpness;
   - any genuinely Paper-V-local consequences.

2. **Clebsch: Rigidity from Sparse Shadows** — the programme coda:
   - five-line poem with line V emphasized;
   - programme map with box V emphasized;
   - cross-paper synthesis involving I–IV;
   - broader “information-loss principle” discussion;
   - explanation of how distinct shadows can encode equivalent source data without becoming isomorphic/identical.

The existing opening sentence:

> “The scattered shadows gather on one carrier, but not by becoming equal.”

contains the right corrective idea but belongs to the programme-level synthesis rather than being allowed to blur the standalone conclusion/programme-wrap boundary. Preserve/rework it only where it naturally fits after the theorem-local conclusion.

Do not reintroduce “gather home” language into the poem; the finalized fifth line is designed specifically to avoid implying literal coalescence.

---

## 8. Introductory prose after the move

After removing the series interludes, each introduction should still answer the normal standalone-paper questions:

- What object/problem is studied here?
- What is reconstructed/classified/proved?
- What is genuinely field-uniform versus exceptional?
- What are the main theorem(s)?
- What is the local roadmap, if needed?

It should **not** need to explain Papers II–V in order for Paper I to be intelligible, etc.

A very brief companion-work citation in an introduction is acceptable only where mathematically useful, but do not recreate a mini-series map in prose.

---

## 9. Repository/programme identity

The series/programme identity should remain strong at the repository/README level.

Inside each PDF, it should now function as **post hoc connective tissue**, not as the primary first-page identity.

Do not rename the programme. The correct name is:

> **Clebsch: Rigidity from Sparse Shadows**

Do not use “Clebsch Reconstruction Series” or similar invented names.

---

## 10. Visual restraint

The desired effect is editorial, mathematical, and slightly literary—not decorative.

Please avoid:

- ornamental borders around the coda;
- oversized Roman numerals;
- colored boxes unless the papers already use color consistently;
- icons;
- arrows linking poem lines directly to boxes;
- a second explanatory legend if the caption suffices;
- excessive bolding;
- turning the coda into a title page or poster.

The linkage should come from **repetition of I–V, matching emphasis, adjacency, and layout**.

---

## 11. Consistency across all five papers

Implement the coda using a shared macro/environment if the TeX structure makes that sensible, but do not force abstraction if the papers genuinely need small differences.

At minimum, keep these identical across I–V:

- coda heading;
- poem wording;
- Roman-numeral presentation;
- emphasis convention;
- map typography/layout;
- “Programme map” terminology;
- general spacing;
- logical-independence message.

Only the current-paper line/box emphasis and legitimately paper-specific explanatory prose should vary.

If the map itself is currently copied five times, consider centralizing the TikZ source with parameters for current-paper highlighting, provided this does not destabilize builds.

---

## 12. Acceptance checklist

Before considering the change complete, verify all five PDFs.

### Front matter

- [ ] No series banner on page 1.
- [ ] No `— I`, `— II`, etc. as part of the first-page series identity.
- [ ] No programme poem on page 1.
- [ ] Standalone title/author/date/abstract still typeset cleanly.
- [ ] Removing the banner did not leave awkward vertical whitespace.

### Introductions

- [ ] No section/paragraph label “Reconstruction perspective.”
- [ ] Local mathematical content from those interludes has been preserved where useful.
- [ ] Paper IV exact-arity sentence is in the introduction.
- [ ] Paper III three-question roadmap remains in the introduction without the old wrapper.
- [ ] Known redundant sentences in I and II are cut.
- [ ] Cross-paper placement prose has not leaked back into the opening unnecessarily.

### Codas

- [ ] Each paper has the unnumbered `Clebsch: Rigidity from Sparse Shadows` coda after its mathematical conclusion.
- [ ] The five-line poem is identical in all five.
- [ ] The corresponding line is emphasized in each paper.
- [ ] The programme map follows directly after the poem.
- [ ] The corresponding map box is emphasized.
- [ ] Map caption says “Programme map,” not “Series map.”
- [ ] I and III map labels are distinguishable and mathematically faithful.
- [ ] I–III / IV branch separation is visually clear.
- [ ] Nearby prose explicitly prevents a dependency-chain reading.
- [ ] Paper V cleanly separates its own conclusion from the programme wrap.

### Build / references

- [ ] All five papers compile without warnings newly introduced by this refactor.
- [ ] Figure numbering/cross-references still resolve.
- [ ] Moving the map does not leave stale “Figure 1” references in introductions.
- [ ] Any references such as “Figure 1 records the programme…” are updated to the map’s new location/number.
- [ ] Page breaks around Conclusion → coda → references are intentional.
- [ ] PDF bookmarks/TOC do not misleadingly number the unnumbered coda.
- [ ] No series-title remnants remain in headers/metadata unless intentionally retained outside the paper title.

---

## 13. Implementation discipline

Please make this as a **presentation/structure refactor**, not a prose rewrite of the mathematics.

When moving prose:

- preserve exact mathematical meaning;
- prefer moving existing good sentences over paraphrasing them;
- cut only genuine redundancy;
- do not “improve” theorem claims or terminology opportunistically;
- flag any sentence whose correct destination is ambiguous instead of silently rewriting it.

After implementation, provide:

1. a concise per-paper summary of what moved / was cut;
2. any wording decisions made for the distinct I/III map labels;
3. any places where the source structure prevented the exact requested layout;
4. a list of the five rebuilt PDFs for review.
